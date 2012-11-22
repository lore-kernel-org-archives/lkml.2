Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965278Ab2KVTxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:53:55 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53550 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965233Ab2KVTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:52:00 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 44/46] staging: line6: drop dump requests from variax startup
Date: Thu, 22 Nov 2012 20:49:23 +0100
Message-Id: <1353613765-18690-45-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variax startup procedure dumps model data.  This is no longer useful
since the sysfs attrs which expose this information to userspace have
been removed.  The dump request wasn't been processed anymore.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/variax.c | 106 ++---------------------------------------
 drivers/staging/line6/variax.h |  15 ------
 2 files changed, 4 insertions(+), 117 deletions(-)

diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index 0262d7d..4fca58f 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -15,21 +15,10 @@
 #include "driver.h"
 #include "variax.h"
 
-#define VARIAX_MODEL_HEADER_LENGTH 7
-#define VARIAX_MODEL_MESSAGE_LENGTH 199
 #define VARIAX_OFFSET_ACTIVATE 7
 
 /*
 	This message is sent by the device during initialization and identifies
-	the connected guitar model.
-*/
-static const char variax_init_model[] = {
-	0xf0, 0x00, 0x01, 0x0c, 0x07, 0x00, 0x69, 0x02,
-	0x00
-};
-
-/*
-	This message is sent by the device during initialization and identifies
 	the connected guitar version.
 */
 static const char variax_init_version[] = {
@@ -49,22 +38,6 @@ static const char variax_activate[] = {
 	0xf7
 };
 
-static const char variax_request_bank[] = {
-	0xf0, 0x00, 0x01, 0x0c, 0x07, 0x00, 0x6d, 0xf7
-};
-
-static const char variax_request_model1[] = {
-	0xf0, 0x00, 0x01, 0x0c, 0x07, 0x00, 0x3c, 0x00,
-	0x02, 0x00, 0x00, 0x00, 0x00, 0x03, 0x05, 0x03,
-	0x00, 0x00, 0x00, 0xf7
-};
-
-static const char variax_request_model2[] = {
-	0xf0, 0x00, 0x01, 0x0c, 0x07, 0x00, 0x3c, 0x00,
-	0x02, 0x00, 0x00, 0x00, 0x00, 0x03, 0x07, 0x03,
-	0x00, 0x00, 0x00, 0xf7
-};
-
 /* forward declarations: */
 static void variax_startup2(unsigned long data);
 static void variax_startup4(unsigned long data);
@@ -135,26 +108,13 @@ static void variax_startup5(unsigned long data)
 {
 	struct usb_line6_variax *variax = (struct usb_line6_variax *)data;
 	CHECK_STARTUP_PROGRESS(variax->startup_progress,
-			       VARIAX_STARTUP_DUMPREQ);
-
-	/* current model dump: */
-	line6_dump_request_async(&variax->dumpreq, &variax->line6, 0,
-				 VARIAX_DUMP_PASS1);
-	/* passes 2 and 3 are performed implicitly before entering
-	 * variax_startup6.
-	 */
-}
-
-static void variax_startup6(struct usb_line6_variax *variax)
-{
-	CHECK_STARTUP_PROGRESS(variax->startup_progress,
 			       VARIAX_STARTUP_WORKQUEUE);
 
 	/* schedule work for global work queue: */
 	schedule_work(&variax->startup_work);
 }
 
-static void variax_startup7(struct work_struct *work)
+static void variax_startup6(struct work_struct *work)
 {
 	struct usb_line6_variax *variax =
 	    container_of(work, struct usb_line6_variax, startup_work);
@@ -178,8 +138,6 @@ void line6_variax_process_message(struct usb_line6_variax *variax)
 
 	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_DEVICE:
 	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_HOST:
-		line6_dump_request_async(&variax->dumpreq, &variax->line6, 0,
-					 VARIAX_DUMP_PASS1);
 		break;
 
 	case LINE6_RESET:
@@ -187,41 +145,14 @@ void line6_variax_process_message(struct usb_line6_variax *variax)
 		break;
 
 	case LINE6_SYSEX_BEGIN:
-		if (memcmp(buf + 1, variax_request_model1 + 1,
-			   VARIAX_MODEL_HEADER_LENGTH - 1) == 0) {
-			if (variax->line6.message_length ==
-			    VARIAX_MODEL_MESSAGE_LENGTH) {
-				switch (variax->dumpreq.in_progress) {
-				case VARIAX_DUMP_PASS1:
-					line6_dump_request_async
-					    (&variax->dumpreq, &variax->line6,
-					     1, VARIAX_DUMP_PASS2);
-					break;
-
-				case VARIAX_DUMP_PASS2:
-					line6_dump_request_async
-					    (&variax->dumpreq, &variax->line6,
-					     2, VARIAX_DUMP_PASS3);
-				}
-			} else {
-				dev_dbg(variax->line6.ifcdev,
-					"illegal length %d of model data\n",
-					variax->line6.message_length);
-				line6_dump_finished(&variax->dumpreq);
-			}
-		} else if (memcmp(buf + 1, variax_request_bank + 1,
-				  sizeof(variax_request_bank) - 2) == 0) {
-			line6_dump_finished(&variax->dumpreq);
-			variax_startup6(variax);
-		} else if (memcmp(buf + 1, variax_init_version + 1,
-				  sizeof(variax_init_version) - 1) == 0) {
+		if (memcmp(buf + 1, variax_init_version + 1,
+			   sizeof(variax_init_version) - 1) == 0) {
 			variax_startup3(variax);
 		} else if (memcmp(buf + 1, variax_init_done + 1,
 				  sizeof(variax_init_done) - 1) == 0) {
 			/* notify of complete initialization: */
 			variax_startup4((unsigned long)variax);
 		}
-
 		break;
 
 	case LINE6_SYSEX_END:
@@ -248,11 +179,6 @@ static void variax_destruct(struct usb_interface *interface)
 	del_timer(&variax->startup_timer2);
 	cancel_work_sync(&variax->startup_work);
 
-	/* free dump request data: */
-	line6_dumpreq_destructbuf(&variax->dumpreq, 2);
-	line6_dumpreq_destructbuf(&variax->dumpreq, 1);
-	line6_dumpreq_destruct(&variax->dumpreq);
-
 	kfree(variax->buffer_activate);
 }
 
@@ -266,36 +192,12 @@ static int variax_try_init(struct usb_interface *interface,
 
 	init_timer(&variax->startup_timer1);
 	init_timer(&variax->startup_timer2);
-	INIT_WORK(&variax->startup_work, variax_startup7);
+	INIT_WORK(&variax->startup_work, variax_startup6);
 
 	if ((interface == NULL) || (variax == NULL))
 		return -ENODEV;
 
 	/* initialize USB buffers: */
-	err = line6_dumpreq_init(&variax->dumpreq, variax_request_model1,
-				 sizeof(variax_request_model1));
-
-	if (err < 0) {
-		dev_err(&interface->dev, "Out of memory\n");
-		return err;
-	}
-
-	err = line6_dumpreq_initbuf(&variax->dumpreq, variax_request_model2,
-				    sizeof(variax_request_model2), 1);
-
-	if (err < 0) {
-		dev_err(&interface->dev, "Out of memory\n");
-		return err;
-	}
-
-	err = line6_dumpreq_initbuf(&variax->dumpreq, variax_request_bank,
-				    sizeof(variax_request_bank), 2);
-
-	if (err < 0) {
-		dev_err(&interface->dev, "Out of memory\n");
-		return err;
-	}
-
 	variax->buffer_activate = kmemdup(variax_activate,
 					  sizeof(variax_activate), GFP_KERNEL);
 
diff --git a/drivers/staging/line6/variax.h b/drivers/staging/line6/variax.h
index 13d5680..24de796 100644
--- a/drivers/staging/line6/variax.h
+++ b/drivers/staging/line6/variax.h
@@ -18,7 +18,6 @@
 #include <sound/core.h>
 
 #include "driver.h"
-#include "dumprequest.h"
 
 #define VARIAX_STARTUP_DELAY1 1000
 #define VARIAX_STARTUP_DELAY3 100
@@ -32,18 +31,11 @@ enum {
 	VARIAX_STARTUP_VERSIONREQ,
 	VARIAX_STARTUP_WAIT,
 	VARIAX_STARTUP_ACTIVATE,
-	VARIAX_STARTUP_DUMPREQ,
 	VARIAX_STARTUP_WORKQUEUE,
 	VARIAX_STARTUP_SETUP,
 	VARIAX_STARTUP_LAST = VARIAX_STARTUP_SETUP - 1
 };
 
-enum {
-	VARIAX_DUMP_PASS1 = LINE6_DUMP_CURRENT,
-	VARIAX_DUMP_PASS2,
-	VARIAX_DUMP_PASS3
-};
-
 struct usb_line6_variax {
 	/**
 		Generic Line6 USB data.
@@ -51,13 +43,6 @@ struct usb_line6_variax {
 	struct usb_line6 line6;
 
 	/**
-		Dump request structure.
-		Append two extra buffers for 3-pass data query.
-	*/
-	struct line6_dump_request dumpreq;
-	struct line6_dump_reqbuf extrabuf[2];
-
-	/**
 		Buffer for activation code.
 	*/
 	unsigned char *buffer_activate;
-- 
1.8.0

