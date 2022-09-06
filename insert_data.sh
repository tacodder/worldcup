#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "Truncate table games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_G OPPONENT_G
do
  TEAMS=$($PSQL "Select name from teams where name='$WINNER'")
  if [[ $WINNER != "winner" ]]
  then
    if [[ -z $TEAMS ]]
    then
     INSERT_TEAM=$($PSQL "INSERT INTO teams(name) values('$WINNER')")
     if [[ INSERT_TEAM == "INSERT 0 1" ]]
     then
      echo Inserted0 into teams, $WINNER
     fi
    fi
  fi

  TEAMS2=$($PSQL "Select name from teams where name='$OPPONENT'")
  if [[ $OPPONENT != "opponent" ]]
  then
    if [[ -z $TEAMS2 ]]
    then
     INSERT_TEAM2=$($PSQL "INSERT INTO teams(name) values('$OPPONENT')")
     if [[ $INSERT_TEAM2 == "INSERT 0 1" ]]
     then
      echo Inserted1 into teams, $OPPONENT
     fi
    fi
  fi

 TEAM_ID_W=$($PSQL "Select team_id from teams where name='$WINNER'")
 TEAM_ID_O=$($PSQL "Select team_id from teams where name='$OPPONENT'")

  if [[ -n TEAM_ID_W || -n TEAM_ID_O ]]
  then
    if [[ $YEAR != "year" ]]
    then
      INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID_W, $TEAM_ID_O, $WINNER_G, $OPPONENT_G)")
      if [[ $INSERT_GAMES == "INSERT 0 1" ]]  
      then
        echo Inserted2 into games, $YEAR
      fi
    fi
  fi

done
