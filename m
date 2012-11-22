Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab2KVTt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:49:56 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54328 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab2KVTtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:49:51 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 04/46] staging: line6: drop dirty sysfs attr
Date: Thu, 22 Nov 2012 20:48:43 +0100
Message-Id: <1353613765-18690-5-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 21 +--------------------
 drivers/staging/line6/pod.h |  5 -----
 2 files changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 8fdbe9f..7c76b65 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -156,12 +156,11 @@ static void pod_dump(struct usb_line6_pod *pod, const unsigned char *data)
 }
 
 /*
-	Store parameter value in driver memory and mark it as dirty.
+	Store parameter value in driver memory.
 */
 static void pod_store_parameter(struct usb_line6_pod *pod, int param, int value)
 {
 	pod->prog_data.control[param] = value;
-	pod->dirty = 1;
 }
 
 /*
@@ -170,7 +169,6 @@ static void pod_store_parameter(struct usb_line6_pod *pod, int param, int value)
 static void pod_save_button_pressed(struct usb_line6_pod *pod, int type,
 				    int index)
 {
-	pod->dirty = 0;
 	set_bit(POD_SAVE_PRESSED, &pod->atomic_flags);
 }
 
@@ -209,7 +207,6 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 
 	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_DEVICE:
 	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_HOST:
-		pod->dirty = 0;
 		set_bit(POD_CHANNEL_DIRTY, &pod->atomic_flags);
 		line6_dump_request_async(&pod->dumpreq, &pod->line6, 0,
 					 LINE6_DUMP_CURRENT);
@@ -778,19 +775,6 @@ static ssize_t pod_set_retrieve_amp_setup(struct device *dev,
 }
 
 /*
-	"read" request on "dirty" special file.
-*/
-static ssize_t pod_get_dirty(struct device *dev, struct device_attribute *attr,
-			     char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	buf[0] = pod->dirty ? '1' : '0';
-	buf[1] = '\n';
-	return 2;
-}
-
-/*
 	"read" request on "midi_postprocess" special file.
 */
 static ssize_t pod_get_midi_postprocess(struct device *dev,
@@ -959,7 +943,6 @@ POD_GET_SYSTEM_PARAM(tuner_pitch, 1);
 
 /* POD special files: */
 static DEVICE_ATTR(device_id, S_IRUGO, pod_get_device_id, line6_nop_write);
-static DEVICE_ATTR(dirty, S_IRUGO, pod_get_dirty, line6_nop_write);
 static DEVICE_ATTR(dump, S_IWUSR | S_IRUGO, pod_get_dump, pod_set_dump);
 static DEVICE_ATTR(dump_buf, S_IWUSR | S_IRUGO, pod_get_dump_buf,
 		   pod_set_dump_buf);
@@ -1073,7 +1056,6 @@ static int pod_create_files2(struct device *dev)
 	int err;
 
 	CHECK_RETURN(device_create_file(dev, &dev_attr_device_id));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_dirty));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_dump));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_dump_buf));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_finish));
@@ -1213,7 +1195,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 					       properties->device_bit, dev);
 
 			device_remove_file(dev, &dev_attr_device_id);
-			device_remove_file(dev, &dev_attr_dirty);
 			device_remove_file(dev, &dev_attr_dump);
 			device_remove_file(dev, &dev_attr_dump_buf);
 			device_remove_file(dev, &dev_attr_finish);
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index dd6c318..b3bf243 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -168,11 +168,6 @@ struct usb_line6_pod {
 	int device_id;
 
 	/**
-		Flag to indicate modification of current program settings.
-	*/
-	char dirty;
-
-	/**
 		Flag to enable MIDI postprocessing.
 	*/
 	char midi_postprocess;
-- 
1.8.0

