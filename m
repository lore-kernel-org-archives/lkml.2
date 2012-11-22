Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab2KVUR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:17:28 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54328 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab2KVTtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:49:47 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 02/46] staging: line6: drop clip sysfs attr
Date: Thu, 22 Nov 2012 20:48:41 +0100
Message-Id: <1353613765-18690-3-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 23 -----------------------
 drivers/staging/line6/pod.h |  5 -----
 2 files changed, 28 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index e3e2247..4abe2de 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -26,7 +26,6 @@
 /* *INDENT-OFF* */
 
 enum {
-	POD_SYSEX_CLIP      = 0x0f,
 	POD_SYSEX_SAVE      = 0x24,
 	POD_SYSEX_SYSTEM    = 0x56,
 	POD_SYSEX_SYSTEMREQ = 0x57,
@@ -311,12 +310,6 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 				pod_save_button_pressed(pod, buf[6], buf[7]);
 				break;
 
-			case POD_SYSEX_CLIP:
-				dev_dbg(pod->line6.ifcdev, "audio clipped\n");
-				pod->clipping.value = 1;
-				wake_up(&pod->clipping.wait);
-				break;
-
 			case POD_SYSEX_STORE:
 				dev_dbg(pod->line6.ifcdev,
 					"message %02X not yet implemented\n",
@@ -879,18 +872,6 @@ static ssize_t pod_get_device_id(struct device *dev,
 }
 
 /*
-	"read" request on "clip" special file.
-*/
-static ssize_t pod_wait_for_clip(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	return wait_event_interruptible(pod->clipping.wait,
-					pod->clipping.value != 0);
-}
-
-/*
 	POD startup procedure.
 	This is a sequence of functions with special requirements (e.g., must
 	not run immediately after initialization, must not run in interrupt
@@ -991,7 +972,6 @@ POD_GET_SYSTEM_PARAM(tuner_pitch, 1);
 #undef GET_SYSTEM_PARAM
 
 /* POD special files: */
-static DEVICE_ATTR(clip, S_IRUGO, pod_wait_for_clip, line6_nop_write);
 static DEVICE_ATTR(device_id, S_IRUGO, pod_get_device_id, line6_nop_write);
 static DEVICE_ATTR(dirty, S_IRUGO, pod_get_dirty, line6_nop_write);
 static DEVICE_ATTR(dump, S_IWUSR | S_IRUGO, pod_get_dump, pod_set_dump);
@@ -1106,7 +1086,6 @@ static int pod_create_files2(struct device *dev)
 {
 	int err;
 
-	CHECK_RETURN(device_create_file(dev, &dev_attr_clip));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_device_id));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_dirty));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_dump));
@@ -1159,7 +1138,6 @@ static int pod_try_init(struct usb_interface *interface,
 	init_waitqueue_head(&pod->tuner_freq.wait);
 	init_waitqueue_head(&pod->tuner_note.wait);
 	init_waitqueue_head(&pod->tuner_pitch.wait);
-	init_waitqueue_head(&pod->clipping.wait);
 
 	memset(pod->param_dirty, 0xff, sizeof(pod->param_dirty));
 
@@ -1250,7 +1228,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 					       pod->line6.
 					       properties->device_bit, dev);
 
-			device_remove_file(dev, &dev_attr_clip);
 			device_remove_file(dev, &dev_attr_device_id);
 			device_remove_file(dev, &dev_attr_dirty);
 			device_remove_file(dev, &dev_attr_dump);
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index 0f9e83d..fa247b8 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -133,11 +133,6 @@ struct usb_line6_pod {
 	struct ValueWait routing;
 
 	/**
-		Wait for audio clipping event.
-	*/
-	struct ValueWait clipping;
-
-	/**
 		Timer for device initializaton.
 	*/
 	struct timer_list startup_timer;
-- 
1.8.0

