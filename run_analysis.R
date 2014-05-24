## The data can be downloaded using the following link
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# Load the train and test data into data frames
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Merge appropriate rows for x, y and subject
allX <- rbind(xtrain, xtest)
allY <- rbind(ytrain, ytest)
subject <- rbind(subject_train, subject_test)

#Make a data frame with features
allfeatures <- read.table("UCI HAR Dataset/features.txt")
mean_std<- grep("mean\\(\\)|std\\(\\)", allfeatures[, 2])

# Get the columns from the allX dataframe that contain mean or standard deviation data 
# and clean up the column names
allX <- allX[, mean_std]
names(allX) <- allfeatures[mean_std, 2]
names(allX) <- gsub("\\(|\\)", "", names(allX))
names(allX) <- gsub("-","",names(allX))
names(allX) <- tolower(names(allX))

#load in the data that contains the activity id's and activity labels
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

# Replace the activity id's in the Y data set with the names of the activities
allY[,1] = activities[allY[,1], 2]

#Set the name of the Y data frame to Activity and the name of the Subject data frame to subject
names(allY)<- "Activity"
names(subject) <- "subject"

#Create the tidy data set by combining the columns from the Subject, allY and allX
# data frames into one data frame and write out the tidy data set
data <- cbind(subject, allY, allX)
write.table(data, "data.txt")

# Using the package reshape2 reshape the data. Using the reshaped data 
# creates a second, independent tidy data set with the average of each variable for each activity 
#and each subject. Write the 
library(reshape2)
id_vars = c("subject", "Activity")
melt <- melt(tidy,id_vars)
tidy_data <- dcast(melt, subject + Activity ~ variable, mean)
write.table(tidy_data,"tidy_data.txt")
