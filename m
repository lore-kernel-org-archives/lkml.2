Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab1CaOyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:54:19 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:57439 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067Ab1CaOwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:52:54 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 17/21] staging:iio:Documentation generic_buffer.c update to new abi for buffers.
Date: Thu, 31 Mar 2011 15:54:11 +0100
Message-Id: <1301583255-28468-18-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial space before newline fix incorporated.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/Documentation/generic_buffer.c |   53 +++++--------------
 1 files changed, 14 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/iio/Documentation/generic_buffer.c b/drivers/staging/iio/Documentation/generic_buffer.c
index eb72e95..3c41d7d 100644
--- a/drivers/staging/iio/Documentation/generic_buffer.c
+++ b/drivers/staging/iio/Documentation/generic_buffer.c
@@ -27,6 +27,7 @@
 #include <sys/dir.h>
 #include <linux/types.h>
 #include <string.h>
+#include <poll.h>
 #include "iio_utils.h"
 
 /**
@@ -135,7 +136,7 @@ int main(int argc, char **argv)
 	ssize_t read_size;
 	struct iio_event_data dat;
 	int dev_num, trig_num;
-	char *buffer_access, *buffer_event;
+	char *buffer_access;
 	int scan_size;
 	int noevents = 0;
 	char *dummy;
@@ -210,7 +211,7 @@ int main(int argc, char **argv)
 	 */
 	ret = build_channel_array(dev_dir_name, &infoarray, &num_channels);
 	if (ret) {
-		printf("Problem reading scan element information \n");
+		printf("Problem reading scan element information\n");
 		goto error_free_triggername;
 	}
 
@@ -251,54 +252,32 @@ int main(int argc, char **argv)
 	}
 
 	ret = asprintf(&buffer_access,
-		       "/dev/device%d:buffer0:access0",
+		       "/dev/device%d:buffer0",
 		       dev_num);
 	if (ret < 0) {
 		ret = -ENOMEM;
 		goto error_free_data;
 	}
 
-	ret = asprintf(&buffer_event, "/dev/device%d:buffer0:event0", dev_num);
-	if (ret < 0) {
-		ret = -ENOMEM;
-		goto error_free_buffer_access;
-	}
 	/* Attempt to open non blocking the access dev */
 	fp = open(buffer_access, O_RDONLY | O_NONBLOCK);
 	if (fp == -1) { /*If it isn't there make the node */
 		printf("Failed to open %s\n", buffer_access);
 		ret = -errno;
-		goto error_free_buffer_event;
-	}
-	/* Attempt to open the event access dev (blocking this time) */
-	fp_ev = fopen(buffer_event, "rb");
-	if (fp_ev == NULL) {
-		printf("Failed to open %s\n", buffer_event);
-		ret = -errno;
-		goto error_close_buffer_access;
+		goto error_free_buffer_access;
 	}
 
 	/* Wait for events 10 times */
 	for (j = 0; j < num_loops; j++) {
 		if (!noevents) {
-			read_size = fread(&dat,
-					1,
-					sizeof(struct iio_event_data),
-					fp_ev);
-			switch (dat.id) {
-			case IIO_EVENT_CODE_RING_100_FULL:
-				toread = buf_len;
-				break;
-			case IIO_EVENT_CODE_RING_75_FULL:
-				toread = buf_len*3/4;
-				break;
-			case IIO_EVENT_CODE_RING_50_FULL:
-				toread = buf_len/2;
-				break;
-			default:
-				printf("Unexpecteded event code\n");
-				continue;
-			}
+			struct pollfd pfd = {
+				.fd = fp,
+				.events = POLLIN,
+			};
+
+			poll(&pfd, 1, -1);
+			toread = buf_len;
+
 		} else {
 			usleep(timedelay);
 			toread = 64;
@@ -320,22 +299,18 @@ int main(int argc, char **argv)
 	/* Stop the ring buffer */
 	ret = write_sysfs_int("enable", buf_dir_name, 0);
 	if (ret < 0)
-		goto error_close_buffer_event;
+		goto error_close_buffer_access;
 
 	/* Disconnect from the trigger - just write a dummy name.*/
 	write_sysfs_string("trigger/current_trigger",
 			dev_dir_name, "NULL");
 
-error_close_buffer_event:
-	fclose(fp_ev);
 error_close_buffer_access:
 	close(fp);
 error_free_data:
 	free(data);
 error_free_buffer_access:
 	free(buffer_access);
-error_free_buffer_event:
-	free(buffer_event);
 error_free_buf_dir_name:
 	free(buf_dir_name);
 error_free_triggername:
-- 
1.7.3.4

