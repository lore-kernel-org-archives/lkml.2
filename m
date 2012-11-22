Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab2KVTyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:54:22 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61568 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965239Ab2KVTv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:58 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 43/46] staging: line6: drop variax model_data field
Date: Thu, 22 Nov 2012 20:49:22 +0100
Message-Id: <1353613765-18690-44-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sysfs attrs to access the model dump have been removed so it's safe
to drop the model_data field.  The next step will be to simplify the
startup process since we no longer need to fetch this data via dump
requests, but that will be done in a later patch.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/variax.c | 27 ---------------------------
 drivers/staging/line6/variax.h | 20 --------------------
 2 files changed, 47 deletions(-)

diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index 0adba32..0262d7d 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -70,21 +70,6 @@ static void variax_startup2(unsigned long data);
 static void variax_startup4(unsigned long data);
 static void variax_startup5(unsigned long data);
 
-/*
-	Decode data transmitted by workbench.
-*/
-static void variax_decode(const unsigned char *raw_data, unsigned char *data,
-			  int raw_size)
-{
-	for (; raw_size > 0; raw_size -= 6) {
-		data[2] = raw_data[0] | (raw_data[1] << 4);
-		data[1] = raw_data[2] | (raw_data[3] << 4);
-		data[0] = raw_data[4] | (raw_data[5] << 4);
-		raw_data += 6;
-		data += 3;
-	}
-}
-
 static void variax_activate_async(struct usb_line6_variax *variax, int a)
 {
 	variax->buffer_activate[VARIAX_OFFSET_ACTIVATE] = a;
@@ -214,18 +199,6 @@ void line6_variax_process_message(struct usb_line6_variax *variax)
 					break;
 
 				case VARIAX_DUMP_PASS2:
-					/* model name is transmitted twice, so skip it here: */
-					variax_decode(buf +
-						      VARIAX_MODEL_HEADER_LENGTH,
-						      (unsigned char *)
-						      &variax->
-						      model_data.control +
-						      sizeof(variax->model_data.
-							     control)
-						      / 2,
-						      sizeof(variax->model_data.
-							     control)
-						      / 2 * 2);
 					line6_dump_request_async
 					    (&variax->dumpreq, &variax->line6,
 					     2, VARIAX_DUMP_PASS3);
diff --git a/drivers/staging/line6/variax.h b/drivers/staging/line6/variax.h
index f3d95fa..13d5680 100644
--- a/drivers/staging/line6/variax.h
+++ b/drivers/staging/line6/variax.h
@@ -44,21 +44,6 @@ enum {
 	VARIAX_DUMP_PASS3
 };
 
-/**
-	Binary Variax model dump
-*/
-struct variax_model {
-	/**
-		Header information (including program name).
-	*/
-	unsigned char name[18];
-
-	/**
-		Model parameters.
-	*/
-	unsigned char control[78 * 2];
-};
-
 struct usb_line6_variax {
 	/**
 		Generic Line6 USB data.
@@ -78,11 +63,6 @@ struct usb_line6_variax {
 	unsigned char *buffer_activate;
 
 	/**
-		Current model settings.
-	*/
-	struct variax_model model_data;
-
-	/**
 		Handler for device initializaton.
 	*/
 	struct work_struct startup_work;
-- 
1.8.0

