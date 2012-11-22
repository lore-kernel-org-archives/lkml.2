Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965258Ab2KVTwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:52:53 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40852 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965247Ab2KVTwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:52:02 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 45/46] staging: line6: drop dump requests from pod startup
Date: Thu, 22 Nov 2012 20:49:24 +0100
Message-Id: <1353613765-18690-46-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pod startup procedure dumps model data.  This is no longer useful
since the sysfs attrs which expose this information to userspace have
been removed.  The dump request wasn't been processed anymore.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 44 ++++----------------------------------------
 drivers/staging/line6/pod.h |  7 -------
 2 files changed, 4 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index f8257be..e542540 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -111,10 +111,6 @@ static struct line6_pcm_properties pod_pcm_properties = {
 	.bytes_per_frame = POD_BYTES_PER_FRAME
 };
 
-static const char pod_request_channel[] = {
-	0xf0, 0x00, 0x01, 0x0c, 0x03, 0x75, 0xf7
-};
-
 static const char pod_version_header[] = {
 	0xf2, 0x7e, 0x7f, 0x06, 0x02
 };
@@ -122,7 +118,6 @@ static const char pod_version_header[] = {
 /* forward declarations: */
 static void pod_startup2(unsigned long data);
 static void pod_startup3(struct usb_line6_pod *pod);
-static void pod_startup4(struct usb_line6_pod *pod);
 
 static char *pod_alloc_sysex_buffer(struct usb_line6_pod *pod, int code,
 				    int size)
@@ -157,8 +152,6 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 
 	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_DEVICE:
 	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_HOST:
-		line6_dump_request_async(&pod->dumpreq, &pod->line6, 0,
-					 LINE6_DUMP_CURRENT);
 		break;
 
 	case LINE6_SYSEX_BEGIN | LINE6_CHANNEL_DEVICE:
@@ -166,8 +159,6 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 		if (memcmp(buf + 1, line6_midi_id, sizeof(line6_midi_id)) == 0) {
 			switch (buf[5]) {
 			case POD_SYSEX_DUMP:
-				line6_dump_finished(&pod->dumpreq);
-				pod_startup3(pod);
 				break;
 
 			case POD_SYSEX_SYSTEM:{
@@ -208,7 +199,7 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 			pod->device_id =
 			    ((int)buf[8] << 16) | ((int)buf[9] << 8) | (int)
 			    buf[10];
-			pod_startup4(pod);
+			pod_startup3(pod);
 		} else
 			dev_dbg(pod->line6.ifcdev, "unknown sysex header\n");
 
@@ -308,22 +299,6 @@ static void pod_startup1(struct usb_line6_pod *pod)
 static void pod_startup2(unsigned long data)
 {
 	struct usb_line6_pod *pod = (struct usb_line6_pod *)data;
-
-	/* schedule another startup procedure until startup is complete: */
-	if (pod->startup_progress >= POD_STARTUP_LAST)
-		return;
-
-	pod->startup_progress = POD_STARTUP_DUMPREQ;
-	line6_start_timer(&pod->startup_timer, POD_STARTUP_DELAY, pod_startup2,
-			  (unsigned long)pod);
-
-	/* current channel dump: */
-	line6_dump_request_async(&pod->dumpreq, &pod->line6, 0,
-				 LINE6_DUMP_CURRENT);
-}
-
-static void pod_startup3(struct usb_line6_pod *pod)
-{
 	struct usb_line6 *line6 = &pod->line6;
 	CHECK_STARTUP_PROGRESS(pod->startup_progress, POD_STARTUP_VERSIONREQ);
 
@@ -331,7 +306,7 @@ static void pod_startup3(struct usb_line6_pod *pod)
 	line6_version_request_async(line6);
 }
 
-static void pod_startup4(struct usb_line6_pod *pod)
+static void pod_startup3(struct usb_line6_pod *pod)
 {
 	CHECK_STARTUP_PROGRESS(pod->startup_progress, POD_STARTUP_WORKQUEUE);
 
@@ -339,7 +314,7 @@ static void pod_startup4(struct usb_line6_pod *pod)
 	schedule_work(&pod->startup_work);
 }
 
-static void pod_startup5(struct work_struct *work)
+static void pod_startup4(struct work_struct *work)
 {
 	struct usb_line6_pod *pod =
 	    container_of(work, struct usb_line6_pod, startup_work);
@@ -422,9 +397,6 @@ static void pod_destruct(struct usb_interface *interface)
 
 	del_timer(&pod->startup_timer);
 	cancel_work_sync(&pod->startup_work);
-
-	/* free dump request data: */
-	line6_dumpreq_destruct(&pod->dumpreq);
 }
 
 /*
@@ -450,19 +422,11 @@ static int pod_try_init(struct usb_interface *interface,
 	struct usb_line6 *line6 = &pod->line6;
 
 	init_timer(&pod->startup_timer);
-	INIT_WORK(&pod->startup_work, pod_startup5);
+	INIT_WORK(&pod->startup_work, pod_startup4);
 
 	if ((interface == NULL) || (pod == NULL))
 		return -ENODEV;
 
-	/* initialize USB buffers: */
-	err = line6_dumpreq_init(&pod->dumpreq, pod_request_channel,
-				 sizeof(pod_request_channel));
-	if (err < 0) {
-		dev_err(&interface->dev, "Out of memory\n");
-		return -ENOMEM;
-	}
-
 	/* create sysfs entries: */
 	err = pod_create_files2(&interface->dev);
 	if (err < 0)
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index 843eb4e..3e3f167 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -19,7 +19,6 @@
 #include <sound/core.h>
 
 #include "driver.h"
-#include "dumprequest.h"
 
 /*
 	PODxt Live interfaces
@@ -45,7 +44,6 @@
 */
 enum {
 	POD_STARTUP_INIT = 1,
-	POD_STARTUP_DUMPREQ,
 	POD_STARTUP_VERSIONREQ,
 	POD_STARTUP_WORKQUEUE,
 	POD_STARTUP_SETUP,
@@ -59,11 +57,6 @@ struct usb_line6_pod {
 	struct usb_line6 line6;
 
 	/**
-		Dump request structure.
-	*/
-	struct line6_dump_request dumpreq;
-
-	/**
 		Instrument monitor level.
 	*/
 	int monitor_level;
-- 
1.8.0

