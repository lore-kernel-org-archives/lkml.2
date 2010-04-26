Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0DZT2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:28:45 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:51652 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab0DZT2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:28:34 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: iio-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 19/19] staging:iio:Documentation: Rewrite example for new abi.
Date: Mon, 26 Apr 2010 20:31:21 +0100
Message-Id: <1272310281-7418-20-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1272310281-7418-19-git-send-email-jic23@cam.ac.uk>
References: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-2-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-3-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-4-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-5-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-6-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-7-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-8-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-9-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-10-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-11-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-12-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-13-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-14-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-15-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-16-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-17-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-18-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-19-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/Documentation/iio_utils.h      |  277 ++++++++++++--------
 .../iio/Documentation/lis3l02dqbuffersimple.c      |  237 +++++++++++------
 2 files changed, 314 insertions(+), 200 deletions(-)

diff --git a/drivers/staging/iio/Documentation/iio_utils.h b/drivers/staging/iio/Documentation/iio_utils.h
index d24006a..a4555e6 100644
--- a/drivers/staging/iio/Documentation/iio_utils.h
+++ b/drivers/staging/iio/Documentation/iio_utils.h
@@ -7,140 +7,173 @@
  * the Free Software Foundation.
  */
 
+/* Made up value to limit allocation sizes */
+#include <string.h>
+#include <stdlib.h>
+
+#define IIO_MAX_NAME_LENGTH 30
+
 #define IIO_EVENT_CODE_RING_50_FULL 200
 #define IIO_EVENT_CODE_RING_75_FULL 201
 #define IIO_EVENT_CODE_RING_100_FULL 202
 
+const char *iio_dir = "/sys/bus/iio/devices/";
+
 struct iio_event_data {
 	int id;
 	__s64 timestamp;
 };
 
-
-inline char *find_ring_subelement(const char *directory, const char *subelement)
-{
-	DIR *dp;
-	const struct dirent *ent;
-	int pos;
-	char temp[100];
-	char *returnstring;
-	dp = opendir(directory);
-	if (dp == NULL) {
-		printf("could not directory: %s\n", directory);
-		return NULL;
-	}
-	while (ent = readdir(dp), ent != NULL) {
-		if (strcmp(ent->d_name, ".") != 0 &&
-		    strcmp(ent->d_name, "..") != 0)  {
-			if (strncmp(ent->d_name, subelement, strlen(subelement)) == 0) {
-				int length = sprintf(temp, "%s%s%s", directory, ent->d_name, "/");
-				returnstring = malloc(length+1);
-				strncpy(returnstring, temp, length+1);
-				return returnstring;
-
-			}
-		}
-	}
-	return 0;
-}
-
-
-char *find_type_by_name(const char *name, const char *type)
+/**
+ * find_type_by_name() - function to match top level types by name
+ * @name: top level type instance name
+ * @type: the type of top level instance being sort
+ *
+ * Typical types this is used for are device and trigger.
+ **/
+inline int find_type_by_name(const char *name, const char *type)
 {
-	const char *iio_dir = "/sys/bus/iio/devices/";
 	const struct dirent *ent;
-	int cnt, pos, pos2;
+	int number, numstrlen;
 
 	FILE *nameFile;
 	DIR *dp;
-	char thisname[100];
-	char temp[100];
-
-	char *returnstring = NULL;
+	char thisname[IIO_MAX_NAME_LENGTH];
+	char *filename;
 	struct stat Stat;
-	pos = sprintf(temp, "%s", iio_dir);
+
 	dp = opendir(iio_dir);
 	if (dp == NULL) {
 		printf("No industrialio devices available");
-		return NULL;
+		return -ENODEV;
 	}
+
 	while (ent = readdir(dp), ent != NULL) {
-		cnt++;
-		/*reject . and .. */
 		if (strcmp(ent->d_name, ".") != 0 &&
-		    strcmp(ent->d_name, "..") != 0)  {
-			/*make sure it isn't a trigger!*/
-			if (strncmp(ent->d_name, type, strlen(type)) == 0) {
-				/* build full path to new file */
-				pos2 = pos + sprintf(temp + pos, "%s/", ent->d_name);
-				sprintf(temp + pos2, "name");
-				printf("search location %s\n", temp);
-				nameFile = fopen(temp, "r");
-				if (!nameFile) {
-					sprintf(temp + pos2, "modalias", ent->d_name);
-					nameFile = fopen(temp, "r");
-					if (!nameFile) {
-						printf("Failed to find a name for device\n");
-						return NULL;
-					}
-				}
+			strcmp(ent->d_name, "..") != 0 &&
+			strlen(ent->d_name) > strlen(type) &&
+			strncmp(ent->d_name, type, strlen(type)) == 0) {
+			numstrlen = sscanf(ent->d_name + strlen(type),
+					   "%d",
+					   &number);
+			/* verify the next character is not a colon */
+			if (strncmp(ent->d_name + strlen(type) + numstrlen,
+					":",
+					1) != 0) {
+				filename = malloc(strlen(iio_dir)
+						+ strlen(type)
+						+ 1
+						+ numstrlen
+						+ 1);
+				if (filename == NULL)
+					return -ENOMEM;
+				sprintf(filename, "%s%s%d/name",
+					iio_dir,
+					type,
+					number);
+				nameFile = fopen(filename, "r");
+				if (!nameFile)
+					continue;
+				free(filename);
 				fscanf(nameFile, "%s", thisname);
-				if (strcmp(name, thisname) == 0) {
-					returnstring = malloc(strlen(temp) + 1);
-					sprintf(temp + pos2, "");
-					strcpy(returnstring, temp);
-					return returnstring;
-				}
+				if (strcmp(name, thisname) == 0)
+					return number;
 				fclose(nameFile);
-
 			}
 		}
 	}
+	return -ENODEV;
 }
 
-int write_sysfs_int(char *filename, char *basedir, int val)
+inline int _write_sysfs_int(char *filename, char *basedir, int val, int verify)
 {
 	int ret;
-	FILE  *sysfsfp;
-	char temp[100];
-	sprintf(temp, "%s%s", basedir, filename);
+	FILE *sysfsfp;
+	int test;
+	char *temp = malloc(strlen(basedir) + strlen(filename) + 2);
+	if (temp == NULL)
+		return -ENOMEM;
+	sprintf(temp, "%s/%s", basedir, filename);
 	sysfsfp = fopen(temp, "w");
-	if (sysfsfp == NULL)
-		return -1;
+	if (sysfsfp == NULL) {
+		printf("failed to open %s\n", temp);
+		ret = -errno;
+		goto error_free;
+	}
 	fprintf(sysfsfp, "%d", val);
 	fclose(sysfsfp);
-	return 0;
+	if (verify) {
+		sysfsfp = fopen(temp, "r");
+		if (sysfsfp == NULL) {
+			printf("failed to open %s\n", temp);
+			ret = -errno;
+			goto error_free;
+		}
+		fscanf(sysfsfp, "%d", &test);
+		if (test != val) {
+			printf("Possible failure in int write %d to %s%s\n",
+				val,
+				basedir,
+				filename);
+			ret = -1;
+		}
+	}
+error_free:
+	free(temp);
+	return ret;
+}
+
+int write_sysfs_int(char *filename, char *basedir, int val)
+{
+	return _write_sysfs_int(filename, basedir, val, 0);
 }
 
 int write_sysfs_int_and_verify(char *filename, char *basedir, int val)
 {
+	return _write_sysfs_int(filename, basedir, val, 1);
+}
+
+int _write_sysfs_string(char *filename, char *basedir, char *val, int verify)
+{
 	int ret;
 	FILE  *sysfsfp;
-	char temp[100];
-	int test;
-
-	sprintf(temp, "%s%s", basedir, filename);
+	char *temp = malloc(strlen(basedir) + strlen(filename) + 2);
+	if (temp == NULL) {
+		printf("Memory allocation failed\n");
+		return -ENOMEM;
+	}
+	sprintf(temp, "%s/%s", basedir, filename);
 	sysfsfp = fopen(temp, "w");
-	if (sysfsfp == NULL)
-		return -1;
-	fprintf(sysfsfp, "%d", val);
+	if (sysfsfp == NULL) {
+		printf("Could not open %s\n", temp);
+		ret = -errno;
+		goto error_free;
+	}
+	fprintf(sysfsfp, "%s", val);
 	fclose(sysfsfp);
-
-	sysfsfp = fopen(temp, "r");
-	if (sysfsfp == NULL)
-		return -1;
-	fscanf(sysfsfp, "%d", &test);
-	if (test != val) {
-		printf("Possible failure in int write %d to %s%s\n",
-		       val,
-		       basedir,
-		       filename);
-		return -1;
+	if (verify) {
+		sysfsfp = fopen(temp, "r");
+		if (sysfsfp == NULL) {
+			ret = -errno;
+			goto error_free;
+		}
+		fscanf(sysfsfp, "%s", temp);
+		if (strcmp(temp, val) != 0) {
+			printf("Possible failure in string write of %s "
+				"Should be %s "
+				"writen to %s\%s\n",
+				temp,
+				val,
+				basedir,
+				filename);
+			ret = -1;
+		}
 	}
+error_free:
+	free(temp);
 
-	return 0;
+	return ret;
 }
-
 /**
  * write_sysfs_string_and_verify() - string write, readback and verify
  * @filename: name of file to write to
@@ -149,40 +182,54 @@ int write_sysfs_int_and_verify(char *filename, char *basedir, int val)
  **/
 int write_sysfs_string_and_verify(char *filename, char *basedir, char *val)
 {
-	int ret;
-	FILE  *sysfsfp;
-	char temp[100];
-	sprintf(temp, "%s%s", basedir, filename);
-	sysfsfp = fopen(temp, "w");
-	if (sysfsfp == NULL)
-		return -1;
-	fprintf(sysfsfp, "%s", val);
-	fclose(sysfsfp);
+	return _write_sysfs_string(filename, basedir, val, 1);
+}
 
-	sysfsfp = fopen(temp, "r");
-	if (sysfsfp == NULL)
-		return -1;
-	fscanf(sysfsfp, "%s", temp);
-	if (strcmp(temp, val) != 0) {
-		printf("Possible failure in string write %s to %s%s \n",
-		       val,
-		       basedir,
-		       filename);
-		return -1;
-	}
-	return 0;
+int write_sysfs_string(char *filename, char *basedir, char *val)
+{
+	return _write_sysfs_string(filename, basedir, val, 0);
 }
 
 int read_sysfs_posint(char *filename, char *basedir)
 {
 	int ret;
 	FILE  *sysfsfp;
-	char temp[100];
-	sprintf(temp, "%s%s", basedir, filename);
+	char *temp = malloc(strlen(basedir) + strlen(filename) + 2);
+	if (temp == NULL) {
+		printf("Memory allocation failed");
+		return -ENOMEM;
+	}
+	sprintf(temp, "%s/%s", basedir, filename);
 	sysfsfp = fopen(temp, "r");
-	if (sysfsfp == NULL)
-		return -1;
+	if (sysfsfp == NULL) {
+		ret = -errno;
+		goto error_free;
+	}
 	fscanf(sysfsfp, "%d\n", &ret);
 	fclose(sysfsfp);
+error_free:
+	free(temp);
+	return ret;
+}
+
+int read_sysfs_float(char *filename, char *basedir, float *val)
+{
+	float ret = 0;
+	FILE  *sysfsfp;
+	char *temp = malloc(strlen(basedir) + strlen(filename) + 2);
+	if (temp == NULL) {
+		printf("Memory allocation failed");
+		return -ENOMEM;
+	}
+	sprintf(temp, "%s/%s", basedir, filename);
+	sysfsfp = fopen(temp, "r");
+	if (sysfsfp == NULL) {
+		ret = -errno;
+		goto error_free;
+	}
+	fscanf(sysfsfp, "%f\n", val);
+	fclose(sysfsfp);
+error_free:
+	free(temp);
 	return ret;
 }
diff --git a/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c b/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
index 2b5cfc5..3a58028 100644
--- a/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
+++ b/drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c
@@ -1,4 +1,4 @@
-/* Industrialio test ring buffer with a lis3l02dq acceleromter
+/* Industrialio ring buffer with a lis3l02dq accelerometer
  *
  * Copyright (c) 2008 Jonathan Cameron
  *
@@ -6,126 +6,181 @@
  * under the terms of the GNU General Public License version 2 as published by
  * the Free Software Foundation.
  *
- * Assumes suitable udev rules are used to create the dev nodes as named here.
+ * This program is primarily intended as an example application.
  */
 
 #include <dirent.h>
 #include <fcntl.h>
 #include <stdio.h>
 #include <errno.h>
-#include <stdint.h>
-#include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/dir.h>
-
 #include <linux/types.h>
-#include <dirent.h>
-#include "iio_util.h"
+#include "iio_utils.h"
 
-static const char *ring_access = "/dev/iio/lis3l02dq_ring_access";
-static const char *ring_event = "/dev/iio/lis3l02dq_ring_event";
-static const char *device_name = "lis3l02dq";
-static const char *trigger_name = "lis3l02dq-dev0";
-static int NumVals = 3;
-static int scan_ts = 1;
-static int RingLength = 128;
+const char *device_name = "lis3l02dq";
+const char *trigger_name_base = "lis3l02dq-dev";
+const int num_vals = 3;
+const int scan_ts = 1;
+const int buf_len = 128;
+const int num_loops = 10;
 
 /*
  * Could get this from ring bps, but only after starting the ring
- * which is a bit late for it to be useful
+ * which is a bit late for it to be useful.
+ *
+ * Todo: replace with much more generic version based on scan_elements
+ * directory.
  */
-int size_from_scanmode(int numVals, int timestamp)
+int size_from_scanmode(int num_vals, int timestamp)
 {
-	if (numVals && timestamp)
+	if (num_vals && timestamp)
 		return 16;
 	else if (timestamp)
 		return 8;
 	else
-		return numVals*2;
+		return num_vals*2;
 }
 
 int main(int argc, char **argv)
 {
+	int ret;
 	int i, j, k, toread;
 	FILE *fp_ev;
 	int fp;
+
+	char *trigger_name, *dev_dir_name, *buf_dir_name;
 	char *data;
 	size_t read_size;
 	struct iio_event_data dat;
+	int dev_num, trig_num;
 
-	char	*BaseDirectoryName,
-		*TriggerDirectoryName,
-		*RingBufferDirectoryName;
+	char *buffer_access, *buffer_event;
+	const char *iio_dir = "/sys/bus/iio/devices/";
+	int scan_size;
+	float gain = 1;
 
-	BaseDirectoryName = find_type_by_name(device_name, "device");
-	if (BaseDirectoryName == NULL) {
-		printf("Failed to find the %s \n", device_name);
-		return -1;
+
+	/* Find out which iio device is the accelerometer. */
+	dev_num = find_type_by_name(device_name, "device");
+	if (dev_num < 0) {
+		printf("Failed to find the %s\n", device_name);
+		ret = -ENODEV;
+		goto error_ret;
+	}
+	printf("iio device number being used is %d\n", dev_num);
+	asprintf(&dev_dir_name, "%sdevice%d", iio_dir, dev_num);
+
+	/*
+	 * Build the trigger name.
+	 * In this case we want the lis3l02dq's data ready trigger
+	 * for this lis3l02dq. The naming is lis3l02dq_dev[n], where
+	 * n matches the device number found above.
+	 */
+	ret = asprintf(&trigger_name, "%s%d", trigger_name_base, dev_num);
+	if (ret < 0) {
+		ret = -ENOMEM;
+		goto error_free_dev_dir_name;
 	}
-	TriggerDirectoryName = find_type_by_name(trigger_name, "trigger");
-	if (TriggerDirectoryName == NULL) {
+
+	/*
+	 * Find the trigger by name.
+	 * This is techically unecessary here as we only need to
+	 * refer to the trigger by name and that name is already
+	 * known.
+	 */
+	trig_num = find_type_by_name(trigger_name, "trigger");
+	if (trig_num < 0) {
 		printf("Failed to find the %s\n", trigger_name);
-		return -1;
+		ret = -ENODEV;
+		goto error_free_triggername;
 	}
-	RingBufferDirectoryName = find_ring_subelement(BaseDirectoryName,
-						       "ring_buffer");
-	if (RingBufferDirectoryName == NULL) {
-		printf("Failed to find ring buffer\n");
-		return -1;
+	printf("iio trigger number being used is %d\n", trig_num);
+
+	/*
+	 * Read in the scale value - in a more generic case, first
+	 * check for accel_scale, then the indivual channel scales
+	 */
+	ret = read_sysfs_float("accel_scale", dev_dir_name, &gain);
+	if (ret)
+		goto error_free_triggername;;
+
+	/*
+	 * Construct the directory name for the associated buffer.
+	 * As we know that the lis3l02dq has only one buffer this may
+	 * be built rather than found.
+	 */
+	ret = asprintf(&buf_dir_name, "%sdevice%d:buffer0", iio_dir, dev_num);
+	if (ret < 0) {
+		ret = -ENOMEM;
+		goto error_free_triggername;
 	}
-
-	if (write_sysfs_string_and_verify("trigger/current_trigger",
-					  BaseDirectoryName,
-					  (char *)trigger_name) < 0) {
-		printf("Failed to write current_trigger file \n");
-		return -1;
+	/* Set the device trigger to be the data rdy trigger found above */
+	ret = write_sysfs_string_and_verify("trigger/current_trigger",
+					dev_dir_name,
+					trigger_name);
+	if (ret < 0) {
+		printf("Failed to write current_trigger file\n");
+		goto error_free_buf_dir_name;
 	}
 
 	/* Setup ring buffer parameters */
-	if (write_sysfs_int("length", RingBufferDirectoryName,
-			    RingLength) < 0) {
-		printf("Failed to open the ring buffer length file \n");
-		return -1;
-	}
+	ret = write_sysfs_int("length", buf_dir_name, buf_len);
+	if (ret < 0)
+		goto error_free_buf_dir_name;
 
-	/* Enable the ring buffer */
-	if (write_sysfs_int("ring_enable", RingBufferDirectoryName, 1) < 0) {
-		printf("Failed to open the ring buffer control file \n");
-		return -1;
-	};
+	/* Enable the buffer */
+	ret = write_sysfs_int("ring_enable", buf_dir_name, 1);
+	if (ret < 0)
+		goto error_free_buf_dir_name;
 
-	data = malloc(size_from_scanmode(NumVals, scan_ts)*RingLength);
+	data = malloc(size_from_scanmode(num_vals, scan_ts)*buf_len);
 	if (!data) {
-		printf("Could not allocate space for usespace data store\n");
-		return -1;
+		ret = -ENOMEM;
+		goto error_free_buf_dir_name;
+	}
+
+	ret = asprintf(&buffer_access,
+		       "/dev/device%d:buffer0:access0",
+		       dev_num);
+	if (ret < 0) {
+		ret = -ENOMEM;
+		goto error_free_data;
 	}
 
+	ret = asprintf(&buffer_event, "/dev/device%d:buffer0:event0", dev_num);
+	if (ret < 0) {
+		ret = -ENOMEM;
+		goto error_free_data;
+	}
 	/* Attempt to open non blocking the access dev */
-	fp = open(ring_access, O_RDONLY | O_NONBLOCK);
+	fp = open(buffer_access, O_RDONLY | O_NONBLOCK);
 	if (fp == -1) { /*If it isn't there make the node */
-		printf("Failed to open %s\n", ring_access);
-		return -1;
+		printf("Failed to open %s\n", buffer_access);
+		ret = -errno;
+		goto error_free_buffer_event;
 	}
 	/* Attempt to open the event access dev (blocking this time) */
-	fp_ev = fopen(ring_event, "rb");
+	fp_ev = fopen(buffer_event, "rb");
 	if (fp_ev == NULL) {
-		printf("Failed to open %s\n", ring_event);
-		return -1;
+		printf("Failed to open %s\n", buffer_event);
+		ret = -errno;
+		goto error_close_buffer_access;
 	}
 
 	/* Wait for events 10 times */
-	for (j = 0; j < 10; j++) {
+	for (j = 0; j < num_loops; j++) {
 		read_size = fread(&dat, 1, sizeof(struct iio_event_data),
 				  fp_ev);
 		switch (dat.id) {
 		case IIO_EVENT_CODE_RING_100_FULL:
-			toread = RingLength;
+			toread = buf_len;
 			break;
 		case IIO_EVENT_CODE_RING_75_FULL:
-			toread = RingLength*3/4;
+			toread = buf_len*3/4;
 			break;
 		case IIO_EVENT_CODE_RING_50_FULL:
-			toread = RingLength/2;
+			toread = buf_len/2;
 			break;
 		default:
 			printf("Unexpecteded event code\n");
@@ -133,39 +188,51 @@ int main(int argc, char **argv)
 		}
 		read_size = read(fp,
 				 data,
-				 toread*size_from_scanmode(NumVals, scan_ts));
+				 toread*size_from_scanmode(num_vals, scan_ts));
 		if (read_size == -EAGAIN) {
-			printf("nothing available \n");
+			printf("nothing available\n");
 			continue;
 		}
-
-		for (i = 0;
-		     i < read_size/size_from_scanmode(NumVals, scan_ts);
-		     i++) {
-			for (k = 0; k < NumVals; k++) {
-				__s16 val = *(__s16 *)(&data[i*size_from_scanmode(NumVals, scan_ts)
+		scan_size = size_from_scanmode(num_vals, scan_ts);
+		for (i = 0; i < read_size/scan_size; i++) {
+			for (k = 0; k < num_vals; k++) {
+				__s16 val = *(__s16 *)(&data[i*scan_size
 							     + (k)*2]);
-				printf("%05d ", val);
+				printf("%05f ", (float)val*gain);
 			}
 			printf(" %lld\n",
-			       *(__s64 *)(&data[(i+1)*size_from_scanmode(NumVals, scan_ts)
+			       *(__s64 *)(&data[(i + 1)
+						*size_from_scanmode(num_vals,
+								    scan_ts)
 						- sizeof(__s64)]));
 		}
 	}
 
 	/* Stop the ring buffer */
-	if (write_sysfs_int("ring_enable", RingBufferDirectoryName, 0) < 0) {
-		printf("Failed to open the ring buffer control file \n");
-		return -1;
-	};
-
-	/* Disconnect from the trigger - writing something that doesn't exist.*/
-	write_sysfs_string_and_verify("trigger/current_trigger",
-				      BaseDirectoryName, "NULL");
-	free(BaseDirectoryName);
-	free(TriggerDirectoryName);
-	free(RingBufferDirectoryName);
+	ret = write_sysfs_int("ring_enable", buf_dir_name, 0);
+	if (ret < 0)
+		goto error_close_buffer_event;
+
+	/* Disconnect from the trigger - just write a dummy name.*/
+	write_sysfs_string("trigger/current_trigger",
+			dev_dir_name, "NULL");
+
+error_close_buffer_event:
+	fclose(fp_ev);
+error_close_buffer_access:
+	close(fp);
+error_free_data:
 	free(data);
-
-	return 0;
+error_free_buffer_access:
+	free(buffer_access);
+error_free_buffer_event:
+	free(buffer_event);
+error_free_buf_dir_name:
+	free(buf_dir_name);
+error_free_triggername:
+	free(trigger_name);
+error_free_dev_dir_name:
+	free(dev_dir_name);
+error_ret:
+	return ret;
 }
-- 
1.6.4.4

