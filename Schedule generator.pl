%schedule([events(Week,Day,Slot,Event,Course,Group)]).

%schedule([events(1,tuesday,1,quiz1,csen403,group4MET),events(2,thursday,1,quiz1,csen401,group4MET),events(3,saturday,1,quiz1,csen601,group6MET)]).% The model of the schedule is a list of events that contains a weeknumber,a day,slot,the event that take place in this timing,the course code, the groupname.


event_in_course(csen403, labquiz1, assignment).
event_in_course(csen403, labquiz2, assignment).
event_in_course(csen403, project1, evaluation).
event_in_course(csen403, project2, evaluation).
event_in_course(csen403, quiz1, quiz).
event_in_course(csen403, quiz2, quiz).
event_in_course(csen403, quiz3, quiz).

event_in_course(csen401, quiz1, quiz).
event_in_course(csen401, quiz2, quiz).
event_in_course(csen401, quiz3, quiz).
event_in_course(csen401, milestone1, evaluation).
event_in_course(csen401, milestone2, evaluation).
event_in_course(csen401, milestone3, evaluation).

event_in_course(csen402, quiz1, quiz).
event_in_course(csen402, quiz2, quiz).
event_in_course(csen402, quiz3, quiz).

event_in_course(math401, quiz1, quiz).
event_in_course(math401, quiz2, quiz).
event_in_course(math401, quiz3, quiz).

event_in_course(elct401, quiz1, quiz).
event_in_course(elct401, quiz2, quiz).
event_in_course(elct401, quiz3, quiz).
event_in_course(elct401, assignment1, assignment).
event_in_course(elct401, assignment2, assignment).

event_in_course(csen601, quiz1, quiz).
event_in_course(csen601, quiz2, quiz).
event_in_course(csen601, quiz3, quiz).
event_in_course(csen601, project, evaluation).
event_in_course(csen603, quiz1, quiz).
event_in_course(csen603, quiz2, quiz).
event_in_course(csen603, quiz3, quiz).

event_in_course(csen602, quiz1, quiz).
event_in_course(csen602, quiz2, quiz).
event_in_course(csen602, quiz3, quiz).

event_in_course(csen604, quiz1, quiz).
event_in_course(csen604, quiz2, quiz).
event_in_course(csen604, quiz3, quiz).
event_in_course(csen604, project1, evaluation).
event_in_course(csen604, project2, evaluation).


holiday(3,monday).
holiday(5,tuesday).
holiday(10,sunday).


studying(csen403, group4MET).
studying(csen401, group4MET).
studying(csen402, group4MET).
studying(csen402, group4MET).

studying(csen601, group6MET).
studying(csen602, group6MET).
studying(csen603, group6MET).
studying(csen604, group6MET).

should_precede(csen403,project1,project2).
should_precede(csen403,quiz1,quiz2).
should_precede(csen403,quiz2,quiz3).

quizslot(group4MET, tuesday, 1).
quizslot(group4MET, thursday, 1).
quizslot(group6MET, saturday, 5).

%precede:Precede method that checks whether this event of this particular group has something precedes it or not, if this event hasn't any event preceding it, it simply add it to the accumulator, if it has it checks wether the preceding event is a member of the accumulator if so then the preceding event is in the schedule if the preceding event is not in the schedule it fails.

	
precede(G,Schedule):-
	precede(G,Schedule,[]).
precede(G,[events(_,_,_,E,C,G)|T],A):-
	\+ should_precede(C,X,E),
	append(A,[E],A1),
	precede(G,T,A1).
precede(G,[events(_,_,_,E,C,G)|T],A):-
	should_precede(C,X,E),
	member(X,A),
	append(A,[E],A1),
	precede(G,T,A1).
precede(G,[events(_,_,_,E,C,F)|T],A):-
	G\=F,
	precede(G,T,A).
precede(_,[],_).
	
	

	


%group_events:The first thing the group_events predicate does is that it gets all the courses of this particular group and put them in a list then it removes the duplicate to give a resulting list with no duplicate courses and then it gets the events of the courses one by one recursively using the accumulator untill the courses list is empty.

group_events(G,Events):- 
	findall(X,studying(X,G),C),
	removeDup(C,C1),
	group_events(G,Events,C1,[]).
group_events(G,Events,[H|T],A):-
	findall([H,E],event_in_course(H,E,_),L),
	append(A,L,A1),
	group_events(G,Events,T,A1).
group_events(_,A,[],A).




%valid_slots_schedule:The first thing this predicate does is that it takes a copy of the schedule and pass it to the overwritten predicate as Clone then it takes the first event of this particular group and traverses the whole list comparing the timings if it finds any other event with the same timing it simply fails, else it continue to do this recursively untill the schedule is empty and then it takes another event as now the clone will become the schedule.


valid_slots_schedule(G,Schedule):-
	valid_slots_schedule(G,Schedule,Schedule).

valid_slots_schedule(G,[events(W,D,S,_,_,F)|T],Clone):-
	G\=F,
	valid_slots_schedule(G,T,T).

valid_slots_schedule(_,_,[]).

valid_slots_schedule(G,[events(W,D,S,_,_,G)|T],Clone):-
	valid_slots_schedule(G,T,T,events(W,D,S,_,_,G)).
valid_slots_schedule(_,[],[],_).

valid_slots_schedule(G,[events(W,D,Z,_,_,G)|T],Clone,events(W,D,S,_,_,G)):-
	Z\=S,
	valid_slots_schedule(G,T,Clone,events(W,D,S,_,_,G)).
	
valid_slots_schedule(G,[events(X,_,_,_,_,G)|T],Clone,events(W,D,S,_,_,G)):-
	X\=W,
	valid_slots_schedule(G,T,Clone,events(W,D,S,_,_,G)).

valid_slots_schedule(G,[events(_,Y,_,_,_,G)|T],Clone,events(W,D,S,_,_,G)):-
	Y\=D,
	valid_slots_schedule(G,T,Clone,events(W,D,S,_,_,G)).

valid_slots_schedule(G,[events(_,_,_,_,_,F)|T],Clone,events(W,D,S,_,_G)):-
	F\=G,
	valid_slots_schedule(G,T,Clone,events(W,D,S,_,_,G)).


valid_slots_schedule(G,[],[_|T],_):-
	valid_slots_schedule(G,T,T).


%available_timings:it gathers all the possible quizslots for this group in a list of list of timings of week and day.

available_timings(G,L):-
	findall([W,D],quizslot(G,W,D),L).

%no_consec_quizzes:it pass the schedule as a clone to the overwritten predicate and then traverses the schedule to find the first quiz of a particular course of this particular group and then it passes this event as a parameter to the overwritten predicate and traverses the whole schedule comparing with the timings of the next quiz of this particular course if the next quiz if theres atleast 1 week before the two events it succeds and return to the clone to get a new event to compare it with the whole schedule, and it keeps on doing this recursively untill the clone is empty.

no_consec_quizzes(G,Schedule):-
	no_consec_quizzes(G,Schedule,Schedule).

no_consec_quizzes(G,[events(W,_,_,E,C,G)|T],Clone):-
	event_in_course(C,E,quiz),
	no_consec_quizzes(G,T,T,events(W,_,_,E,C,G)).

no_consec_quizzes(G,[events(_,_,_,_,_,F)|T],Clone):-
	F\=G,
	no_consec_quizzes(G,T,T).
	
no_consec_quizzes(G,[events(_,_,_,E,C,G)|T],Clone):-
	\+event_in_course(C,E,quiz),
	no_consec_quizzes(G,T,T).

no_consec_quizzes(_,_,[]).

no_consec_quizzes(G,[events(A,_,_,E,C,G)|T],Clone,events(W,_,_,E1,C,G)):-
	event_in_course(C,E,quiz),
	W1 is W+1,
	A > W1,
	no_consec_quizzes(G,T,Clone,events(A,_,_,E,C,G)).

no_consec_quizzes(G,[events(A,_,_,E,C,G)|T],Clone,events(W,_,_,E1,C,G)):-
	\+event_in_course(C,E,quiz),
	no_consec_quizzes(G,T,Clone,events(W,_,_,E1,C,G)).

no_consec_quizzes(G,[events(_,_,_,_,C1,_)|T],Clone,events(W,_,_,E,C,G)):-
	C1\=C,
	no_consec_quizzes(G,T,Clone,events(W,_,_,E,C,G)).

no_consec_quizzes(G,[],Clone,_):-
	no_consec_quizzes(G,Clone,Clone).


%no_same_day_quiz: it passes the schedule as a clone to the overwritten predicate and traverses the list searching for the first quiz of this particular group and then passes this event as a parameter to the next overwritten predicate to compare the dates with the rest of the schedule and the dates can't be on the same day and it keeps doing this recursively untill the clone is empty, as it keeps taking a new event(quiz)to compare with the rest of the schedule.

no_same_day_quiz(G,Schedule):-
	no_same_day_quiz(G,Schedule,Schedule).

no_same_day_quiz(G,[events(W,D,_,E,C,G)|T],Clone):-
	event_in_course(C,E,quiz),
	no_same_day_quiz(G,T,T,events(W,D,_,_,_,G)).

no_same_day_quiz(G,[events(W,D,_,E,C,G)|T],Clone):-
	\+event_in_course(C,E,quiz),
	no_same_day_quiz(G,T,T).

no_same_day_quiz(G,[events(_,_,_,_,_,F)|T],Clone):-
	F\=G,
	no_same_day_quiz(G,T,T).

no_same_day_quiz(_,_,[]).

no_same_day_quiz(G,[events(X,_,_,_,_,G)|T],Clone,events(W,D,_,_,_,G)):-
	X\=W,
	no_same_day_quiz(G,T,Clone,events(W,D,_,_,_,G)).

no_same_day_quiz(G,[events(W,Y,_,_,_,G)|T],Clone,events(W,D,_,_,_,G)):-
	Y\=D,
	no_same_day_quiz(G,T,Clone,events(W,D,_,_,_,G)).

no_same_day_quiz(G,[events(_,_,_,_,_,F)|T],Clone,events(W,D,_,_,_,G)):-
	F\=G,
	no_same_day_quiz(G,T,Clone,events(W,D,_,_,_,G)).

no_same_day_quiz(G,[events(W,D,_,E,C,G)|T],Clone,events(W,D,_,_,_,G)):-
	\+event_in_course(C,E,quiz),
	no_same_day_quiz(G,T,Clone,events(W,D,_,_,_,G)).

no_same_day_quiz(G,[],Clone,_):-
	no_same_day_quiz(G,Clone,Clone).
	

%no_same_day_assignment:It passes the schedule as a paramter to the overwritten predicate and then it traverses the schedule to search for the first event of type assignment of this particular group and then it passes this event as a parameter to the next overwritten predicate to compare the timings of this assignment with the rest of the events of type(assignment) in the schedule and the dates can't be on the same day and it keeps doing this recursively untill the clone is empty as it keeps getting a new event of type(assignment) to compare it with the rest of the schedule.


no_same_day_assignment(G,Schedule):-	
	no_same_day_assignment(G,Schedule,Schedule).

no_same_day_assignment(G,[events(W,D,_,E,C,G)|T],Clone):-
	event_in_course(C,E,assignment),
	no_same_day_assignment(G,T,T,events(W,D,_,_,_,G)).

no_same_day_assignment(G,[events(W,D,_,E,C,G)|T],Clone):-
	\+event_in_course(C,E,assignment),
	no_same_day_assignment(G,T,T).

no_same_day_assignment(G,[events(_,_,_,_,_,F)|T],Clone):-
	F\=G,
	no_same_day_assignment(G,T,T).

no_same_day_assignment(_,_,[]).

no_same_day_assignment(G,[events(X,_,_,_,_,G)|T],Clone,events(W,D,_,_,_,G)):-
	X\=W,
	no_same_day_assignment(G,T,Clone,events(W,D,_,_,_,G)).

no_same_day_assignment(G,[events(W,Y,_,_,_,G)|T],Clone,events(W,D,_,_,_,G)):-
	Y\=D,
	no_same_day_assignment(G,T,Clone,events(W,D,_,_,_,G)).

no_same_day_assignment(G,[events(_,_,_,_,_,F)|T],Clone,events(W,D,_,_,_,G)):-
	F\=G,
	no_same_day_assignment(G,T,Clone,events(W,D,_,_,_,G)).

no_same_day_assignment(G,[events(W,D,_,E,C,G)|T],Clone,events(W,D,_,_,_,G)):-
	\+event_in_course(C,E,assignment),
	no_same_day_assignment(G,T,Clone,events(W,D,_,_,_,G)).

no_same_day_assignment(G,[],Clone,_):-
	no_same_day_assignment(G,Clone,Clone).
	
%no_holidays:It traverses the schedule comparing the dates of the events of this group with the holiday predicate if it unifies with the holiday predicate then this timing is a holiday and it has event scheduled to it so it fails else it keeps traversing the whole schedule untill it's empty.

no_holidays(G,[events(W,D,_,_,_,G)|T]):-
	\+holiday(W,D),
	no_holidays(G,T).

no_holidays(G,[events(_,_,_,_,_,F)|T]):-
	F\=G,
	no_holidays(G,T).

no_holidays(_,[]).
%removeDup: this predicate remove any duplicate in a given list to give a list R with no duplicates.
removeDup(L,R):-
	removeDup(L,R,[]).

removeDup([H|T],R,A):-

	length(A,0),
	append(A,[H],A1),
	removeDup(T,R,A1).

removeDup([H|T],R,A):-
	\+length(A,0),	
	\+member(H,A),
	append(A,[H],A1),
	removeDup(T,R,A1).

removeDup([H|T],R,A):-
	\+length(A,0),
	member(H,A),
	removeDup(T,R,A).

removeDup([],A,A).
%schedule: the main predicate responsible for scheduling given a week number, it will give a schedule for all groups from week 1 to the given week number.
schedule(Week,Schedule):-
	findall(X,studying(_,X),G),
	removeDup(G,G1),
	schedule(Week,Schedule,G1,[],1).

schedule(Week,Schedule,[G1|T],A,W):-
	group_events(G1,L),
	available_timings(G1,L1),
	schedule(Week,Schedule,[G1|T],A,W,L,L1).

schedule(_,A,[],A,_).

schedule(Week,Schedule,[G|T],A,W,Events,[[D,S|_]|T1]):-
	W=<Week,
	random_select([C,E|_],Events,R),
	append(A,[events(W,D,S,E,C,G)],A1),
	((precede(G,A1),
	valid_slots_schedule(G,A1),
	no_consec_quizzes(G,A1),
	no_same_day_quiz(G,A1),
	no_same_day_assignment(G,A1),
	no_holidays(G,A1))
	->schedule(Week,Schedule,[G|T],A1,W,R,T1)
	;last(A1,events(Wz,Dz,Sz,Event,Course,Group)),delete(A1,events(Wz,Dz,Sz,Event,Course,Group),A2),schedule(Week,Schedule,[G|T],A,W,Events,T1)).
	


schedule(Week,Schedule,[G|T],A,W,[E1|_],[[D,S|_]|T1]):-
	W>Week,
	schedule(Week,Schedule,[G|T],A,1,[E1|_],[[D,S|_]|T1]).

schedule(Week,Schedule,[G|T],A,W,[],_):-
	schedule(Week,Schedule,T,A,1).

schedule(Week,Schedule,[G|T],A,W,Events,[]):-
	available_timings(G,L),
	W1 is W+1,
	schedule(Week,Schedule,[G|T],A,W1,Events,L).
		

	
	


