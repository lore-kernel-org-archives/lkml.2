Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab2KVTwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:52:36 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53557 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965250Ab2KVTwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:52:04 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 46/46] staging: line6: drop unused dumprequest code
Date: Thu, 22 Nov 2012 20:49:25 +0100
Message-Id: <1353613765-18690-47-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The line6 drive no longer requests MIDI dumps from the device so
dumprequest.c is not needed.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/Makefile      |   1 -
 drivers/staging/line6/dumprequest.c | 135 ------------------------------------
 drivers/staging/line6/dumprequest.h |  76 --------------------
 3 files changed, 212 deletions(-)
 delete mode 100644 drivers/staging/line6/dumprequest.c
 delete mode 100644 drivers/staging/line6/dumprequest.h

diff --git a/drivers/staging/line6/Makefile b/drivers/staging/line6/Makefile
index 44ee5ae..ae5c374 100644
--- a/drivers/staging/line6/Makefile
+++ b/drivers/staging/line6/Makefile
@@ -4,7 +4,6 @@ line6usb-y := 		\
 		audio.o		\
 		capture.o	\
 		driver.o	\
-		dumprequest.o	\
 		midi.o		\
 		midibuf.o	\
 		pcm.o		\
diff --git a/drivers/staging/line6/dumprequest.c b/drivers/staging/line6/dumprequest.c
deleted file mode 100644
index 60c7bae..0000000
--- a/drivers/staging/line6/dumprequest.c
+++ /dev/null
@@ -1,135 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#include <linux/slab.h>
-
-#include "driver.h"
-#include "dumprequest.h"
-
-/*
-	Set "dump in progress" flag.
-*/
-void line6_dump_started(struct line6_dump_request *l6dr, int dest)
-{
-	l6dr->in_progress = dest;
-}
-
-/*
-	Invalidate current channel, i.e., set "dump in progress" flag.
-	Reading from the "dump" special file blocks until dump is completed.
-*/
-void line6_invalidate_current(struct line6_dump_request *l6dr)
-{
-	line6_dump_started(l6dr, LINE6_DUMP_CURRENT);
-}
-
-/*
-	Clear "dump in progress" flag and notify waiting processes.
-*/
-void line6_dump_finished(struct line6_dump_request *l6dr)
-{
-	l6dr->in_progress = LINE6_DUMP_NONE;
-	wake_up(&l6dr->wait);
-}
-
-/*
-	Send an asynchronous channel dump request.
-*/
-int line6_dump_request_async(struct line6_dump_request *l6dr,
-			     struct usb_line6 *line6, int num, int dest)
-{
-	int ret;
-	line6_dump_started(l6dr, dest);
-	ret = line6_send_raw_message_async(line6, l6dr->reqbufs[num].buffer,
-					   l6dr->reqbufs[num].length);
-
-	if (ret < 0)
-		line6_dump_finished(l6dr);
-
-	return ret;
-}
-
-/*
-	Wait for completion (interruptible).
-*/
-int line6_dump_wait_interruptible(struct line6_dump_request *l6dr)
-{
-	return wait_event_interruptible(l6dr->wait,
-					l6dr->in_progress == LINE6_DUMP_NONE);
-}
-
-/*
-	Wait for completion.
-*/
-void line6_dump_wait(struct line6_dump_request *l6dr)
-{
-	wait_event(l6dr->wait, l6dr->in_progress == LINE6_DUMP_NONE);
-}
-
-/*
-	Wait for completion (with timeout).
-*/
-int line6_dump_wait_timeout(struct line6_dump_request *l6dr, long timeout)
-{
-	return wait_event_timeout(l6dr->wait,
-				  l6dr->in_progress == LINE6_DUMP_NONE,
-				  timeout);
-}
-
-/*
-	Initialize dump request buffer.
-*/
-int line6_dumpreq_initbuf(struct line6_dump_request *l6dr, const void *buf,
-			  size_t len, int num)
-{
-	l6dr->reqbufs[num].buffer = kmemdup(buf, len, GFP_KERNEL);
-	if (l6dr->reqbufs[num].buffer == NULL)
-		return -ENOMEM;
-	l6dr->reqbufs[num].length = len;
-	return 0;
-}
-
-/*
-	Initialize dump request data structure (including one buffer).
-*/
-int line6_dumpreq_init(struct line6_dump_request *l6dr, const void *buf,
-		       size_t len)
-{
-	int ret;
-	ret = line6_dumpreq_initbuf(l6dr, buf, len, 0);
-	if (ret < 0)
-		return ret;
-	init_waitqueue_head(&l6dr->wait);
-	return 0;
-}
-
-/*
-	Destruct dump request data structure.
-*/
-void line6_dumpreq_destructbuf(struct line6_dump_request *l6dr, int num)
-{
-	if (l6dr == NULL)
-		return;
-	if (l6dr->reqbufs[num].buffer == NULL)
-		return;
-	kfree(l6dr->reqbufs[num].buffer);
-	l6dr->reqbufs[num].buffer = NULL;
-}
-
-/*
-	Destruct dump request data structure.
-*/
-void line6_dumpreq_destruct(struct line6_dump_request *l6dr)
-{
-	if (l6dr->reqbufs[0].buffer == NULL)
-		return;
-	line6_dumpreq_destructbuf(l6dr, 0);
-}
diff --git a/drivers/staging/line6/dumprequest.h b/drivers/staging/line6/dumprequest.h
deleted file mode 100644
index c17a262..0000000
--- a/drivers/staging/line6/dumprequest.h
+++ /dev/null
@@ -1,76 +0,0 @@
-/*
- * Line6 Linux USB driver - 0.9.1beta
- *
- * Copyright (C) 2004-2010 Markus Grabner (grabner@icg.tugraz.at)
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License as
- *	published by the Free Software Foundation, version 2.
- *
- */
-
-#ifndef DUMPREQUEST_H
-#define DUMPREQUEST_H
-
-#include <linux/usb.h>
-#include <linux/wait.h>
-#include <sound/core.h>
-
-enum {
-	LINE6_DUMP_NONE,
-	LINE6_DUMP_CURRENT
-};
-
-struct line6_dump_reqbuf {
-	/**
-		 Buffer for dump requests.
-	*/
-	unsigned char *buffer;
-
-	/**
-		 Size of dump request.
-	*/
-	size_t length;
-};
-
-/**
-	 Provides the functionality to request channel/model/... dump data from a
-	 Line6 device.
-*/
-struct line6_dump_request {
-	/**
-		 Wait queue for access to program dump data.
-	*/
-	wait_queue_head_t wait;
-
-	/**
-		 Indicates an unfinished program dump request.
-		 0: no dump
-		 1: dump current settings
-		 Other device-specific values are also allowed.
-	*/
-	int in_progress;
-
-	/**
-		 Dump request buffers
-	*/
-	struct line6_dump_reqbuf reqbufs[1];
-};
-
-extern void line6_dump_finished(struct line6_dump_request *l6dr);
-extern int line6_dump_request_async(struct line6_dump_request *l6dr,
-				    struct usb_line6 *line6, int num, int dest);
-extern void line6_dump_started(struct line6_dump_request *l6dr, int dest);
-extern void line6_dumpreq_destruct(struct line6_dump_request *l6dr);
-extern void line6_dumpreq_destructbuf(struct line6_dump_request *l6dr, int num);
-extern int line6_dumpreq_init(struct line6_dump_request *l6dr, const void *buf,
-			      size_t len);
-extern int line6_dumpreq_initbuf(struct line6_dump_request *l6dr,
-				 const void *buf, size_t len, int num);
-extern void line6_invalidate_current(struct line6_dump_request *l6dr);
-extern void line6_dump_wait(struct line6_dump_request *l6dr);
-extern int line6_dump_wait_interruptible(struct line6_dump_request *l6dr);
-extern int line6_dump_wait_timeout(struct line6_dump_request *l6dr,
-				   long timeout);
-
-#endif
-- 
1.8.0

