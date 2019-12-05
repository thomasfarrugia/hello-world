#####################################################
#####################################################
###                                               ###
###  Auto-Generate Basic Plots from MiniPAT Data  ###
###                                               ###
#####################################################
#####################################################
# Get MiniPAT data files from Argos website
# Produce base plots and export in standard format

library (ggplot2)

#####################################################
###           Bring CSV data files in R          ####
#####################################################

setwd("Z:/Research Projects/Sat tag data/Tags") #This is the directory with all the folders of each tag

Tags <- list.files() #List all the tag numbers in the directory
dfs<-NULL #Establish an empty list that will include the names of each data frame

for (i in Tags){  #For each tag
  setwd(paste0(getwd(),"/",i)) #Find the tag's folder
  nam <- paste0("ts", i) #Make a new name for the data frame
  assign(nam, read.csv(paste0(i,"-Series.csv"), header=T)) #Import the CSV file of the time series data
  setwd("Z:/Research Projects/Sat tag data/Tags") #Return to root directory
  dfs <- append(dfs, nam) #Add the name of the data frame to the empty list
  }

#####################################################
###               Reformat data                  ####
#####################################################

for (j in dfs){ #For each imported data frame
  tmp <- get(j) #Temporary data frame
  tmp$Day <- as.Date(tmp$Day, format="%d-%h-%Y") #Change the format of the date column
  tmp$DateTime <- as.POSIXct(paste(tmp$Day, tmp$Time), format="%Y-%m-%d %H:%M") #Make a new DateTime column
  assign(j, tmp) #Update the original data frame
}


#####################################################
###                Produce plots                 ####
#####################################################

# Depth and temperature time series for the whole time series
for (k in dfs){ #For each data frame
  tmp <- get(k) #Make temp data frame
  par(mar=c(5,4,4,5)) #Set margins of plot
  plot(tmp$DateTime, tmp$Depth,ylim=c(max(tmp$Depth, na.rm=T),0), axes=F, xlab="", ylab="",type="l",col="blue", 
       main=paste(k)) #Plot depth with inversed y axis
  axis(2, ylim=c(max(tmp$Depth, na.rm=T),0),col="black") #Show y axis
  mtext(2,text="Depth (m)",line=2, col="blue") #Y axis label
  par(new=T) #New plot overlayed
  plot(tmp$DateTime, tmp$Temperature, axes=F, ylim=c(5,max(tmp$Temperature, na.rm=T)+20), xlab="", ylab="", #Plot the temperature data
     type="l", main="",col="red")
  axis(4, ylim=c(5,max(tmp$Temperature, na.rm=T)), col="black") #Show secondary y axis
  mtext(4,text="Temperature (C)", line=2, col="red") #Secondary y axis label
  axis.POSIXct(1, tmp$DateTime, format="%m/%d/%y") #Show x axis with appropriate format
  mtext("Date",side=1,col="black",line=2) #Label x axis
  box()
}

# Depth and temperature on two different plots one above the other
for (k in dfs){ #For each data frame
  tmp <- get(k) #Make temp data frame
  par(mfrow=c(2,1)) #Make 2 plots one above the other
  par(mar=c(0,4,2,2)) #Set margins of plot
  plot(tmp$DateTime, tmp$Depth,ylim=c(max(tmp$Depth, na.rm=T),0), axes=F, xlab="", ylab="",type="l",col="blue", 
       main=paste(k)) #Plot depth with inversed y axis
  axis(2, ylim=c(max(tmp$Depth, na.rm=T),0),col="black") #Show y axis
  mtext(2,text="Depth (m)",line=2, col="blue") #Y axis label
  box()
  par(mar=c(2,4,0,2)) #Set margins of plot
  plot(tmp$DateTime, tmp$Temperature, axes=F, ylim=c(5,max(tmp$Temperature, na.rm=T)), xlab="", ylab="", #Plot the temperature data
     type="l", main="",col="red")
  axis(2, ylim=c(5,max(tmp$Temperature, na.rm=T)), col="black") #Show secondary y axis
  mtext(2,text="Temperature (C)", line=2, col="red") #Secondary y axis label
  axis.POSIXct(1, tmp$DateTime, format="%m/%d/%y") #Show x axis with appropriate format
  mtext("Date",side=1,col="black",line=2) #Label x axis
  box()
}

# Depth line colored with a temperature gradient

# Same depth/temperature graphs for the first day (to see short-term survival)

# Same depth/temperature graphs for the last 5 days (to see if there was a reason for premature release)

# Same depth/temperature for each day (if less than X days, otherwise subsample)

# Map of first pop-up location (with light geolocation when available)

#


