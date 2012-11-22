Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab2KVTtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:49:51 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45940 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333Ab2KVTtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:49:49 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 03/46] staging: line6: drop unused param_dirty bitmap
Date: Thu, 22 Nov 2012 20:48:42 +0100
Message-Id: <1353613765-18690-4-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The param_dirty bitmap tracks which parameters have been modified since
saving a preset.  The bitmap is never used though so we can drop this
deadcode.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 16 ----------------
 drivers/staging/line6/pod.h |  5 -----
 2 files changed, 21 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 4abe2de..8fdbe9f 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -130,17 +130,6 @@ static void pod_startup2(unsigned long data);
 static void pod_startup3(struct usb_line6_pod *pod);
 static void pod_startup4(struct usb_line6_pod *pod);
 
-/*
-	Mark all parameters as dirty and notify waiting processes.
-*/
-static void pod_mark_batch_all_dirty(struct usb_line6_pod *pod)
-{
-	int i;
-
-	for (i = 0; i < POD_CONTROL_SIZE; i++)
-		set_bit(i, pod->param_dirty);
-}
-
 static char *pod_alloc_sysex_buffer(struct usb_line6_pod *pod, int code,
 				    int size)
 {
@@ -163,7 +152,6 @@ static void pod_dump(struct usb_line6_pod *pod, const unsigned char *data)
 	memcpy(sysex + SYSEX_DATA_OFS + 1, data, sizeof(pod->prog_data));
 	line6_send_sysex_message(&pod->line6, sysex, size);
 	memcpy(&pod->prog_data, data, sizeof(pod->prog_data));
-	pod_mark_batch_all_dirty(pod);
 	kfree(sysex);
 }
 
@@ -173,7 +161,6 @@ static void pod_dump(struct usb_line6_pod *pod, const unsigned char *data)
 static void pod_store_parameter(struct usb_line6_pod *pod, int param, int value)
 {
 	pod->prog_data.control[param] = value;
-	set_bit(param, pod->param_dirty);
 	pod->dirty = 1;
 }
 
@@ -239,7 +226,6 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 					case LINE6_DUMP_CURRENT:
 						memcpy(&pod->prog_data, buf + 7,
 						       sizeof(pod->prog_data));
-						pod_mark_batch_all_dirty(pod);
 						break;
 
 					case POD_DUMP_MEMORY:
@@ -1139,8 +1125,6 @@ static int pod_try_init(struct usb_interface *interface,
 	init_waitqueue_head(&pod->tuner_note.wait);
 	init_waitqueue_head(&pod->tuner_pitch.wait);
 
-	memset(pod->param_dirty, 0xff, sizeof(pod->param_dirty));
-
 	/* initialize USB buffers: */
 	err = line6_dumpreq_init(&pod->dumpreq, pod_request_channel,
 				 sizeof(pod_request_channel));
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index fa247b8..dd6c318 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -148,11 +148,6 @@ struct usb_line6_pod {
 	int startup_progress;
 
 	/**
-		Dirty flags for access to parameter data.
-	*/
-	unsigned long param_dirty[POD_CONTROL_SIZE / sizeof(unsigned long)];
-
-	/**
 		Some atomic flags.
 	*/
 	unsigned long atomic_flags;
-- 
1.8.0

