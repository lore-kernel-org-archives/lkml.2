Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab2KVULf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:11:35 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53550 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054Ab2KVTvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:20 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 20/46] staging: line6: drop tuner_mute sysfs attr
Date: Thu, 22 Nov 2012 20:48:59 +0100
Message-Id: <1353613765-18690-21-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 34 ----------------------------------
 drivers/staging/line6/pod.h |  5 -----
 2 files changed, 39 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 57fbe27..df2f37a 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -248,8 +248,6 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 						break;
 
 						PROCESS_SYSTEM_PARAM
-						    (tuner_mute);
-						PROCESS_SYSTEM_PARAM
 						    (tuner_pitch);
 
 #undef PROCESS_SYSTEM_PARAM
@@ -453,20 +451,6 @@ static int pod_set_system_param_int(struct usb_line6_pod *pod, int value,
 }
 
 /*
-	Send system parameter (from string).
-	@param tuner non-zero, if code refers to a tuner parameter
-*/
-static ssize_t pod_set_system_param_string(struct usb_line6_pod *pod,
-					   const char *buf, int count, int code,
-					   unsigned short mask)
-{
-	int retval;
-	unsigned short value = simple_strtoul(buf, NULL, 10) & mask;
-	retval = pod_set_system_param_int(pod, value, code);
-	return (retval < 0) ? retval : count;
-}
-
-/*
 	"write" request on "finish" special file.
 */
 static ssize_t pod_set_finish(struct device *dev,
@@ -630,21 +614,8 @@ static ssize_t pod_get_ ## code(struct device *dev, \
 					   &pod->code, sign);		\
 }
 
-#define POD_GET_SET_SYSTEM_PARAM(code, mask, sign) \
-POD_GET_SYSTEM_PARAM(code, sign) \
-static ssize_t pod_set_ ## code(struct device *dev, \
-				struct device_attribute *attr, \
-				const char *buf, size_t count) \
-{ \
-	struct usb_interface *interface = to_usb_interface(dev); \
-	struct usb_line6_pod *pod = usb_get_intfdata(interface); \
-	return pod_set_system_param_string(pod, buf, count, POD_ ## code, mask); \
-}
-
-POD_GET_SET_SYSTEM_PARAM(tuner_mute, 0x0001, 0);
 POD_GET_SYSTEM_PARAM(tuner_pitch, 1);
 
-#undef GET_SET_SYSTEM_PARAM
 #undef GET_SYSTEM_PARAM
 
 /* POD special files: */
@@ -656,8 +627,6 @@ static DEVICE_ATTR(midi_postprocess, S_IWUSR | S_IRUGO,
 		   pod_get_midi_postprocess, pod_set_midi_postprocess);
 static DEVICE_ATTR(serial_number, S_IRUGO, pod_get_serial_number,
 		   line6_nop_write);
-static DEVICE_ATTR(tuner_mute, S_IWUSR | S_IRUGO, pod_get_tuner_mute,
-		   pod_set_tuner_mute);
 static DEVICE_ATTR(tuner_pitch, S_IRUGO, pod_get_tuner_pitch, line6_nop_write);
 
 #ifdef CONFIG_LINE6_USB_RAW
@@ -742,7 +711,6 @@ static int pod_create_files2(struct device *dev)
 	CHECK_RETURN(device_create_file(dev, &dev_attr_firmware_version));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_midi_postprocess));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_serial_number));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_mute));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_pitch));
 
 #ifdef CONFIG_LINE6_USB_RAW
@@ -768,7 +736,6 @@ static int pod_try_init(struct usb_interface *interface,
 		return -ENODEV;
 
 	/* initialize wait queues: */
-	init_waitqueue_head(&pod->tuner_mute.wait);
 	init_waitqueue_head(&pod->tuner_pitch.wait);
 
 	/* initialize USB buffers: */
@@ -863,7 +830,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 			device_remove_file(dev, &dev_attr_firmware_version);
 			device_remove_file(dev, &dev_attr_midi_postprocess);
 			device_remove_file(dev, &dev_attr_serial_number);
-			device_remove_file(dev, &dev_attr_tuner_mute);
 			device_remove_file(dev, &dev_attr_tuner_pitch);
 
 #ifdef CONFIG_LINE6_USB_RAW
diff --git a/drivers/staging/line6/pod.h b/drivers/staging/line6/pod.h
index 1659120..4930742 100644
--- a/drivers/staging/line6/pod.h
+++ b/drivers/staging/line6/pod.h
@@ -99,11 +99,6 @@ struct usb_line6_pod {
 	struct pod_program prog_data_buf;
 
 	/**
-		Tuner mute mode.
-	*/
-	struct ValueWait tuner_mute;
-
-	/**
 		Pitch value received from tuner.
 	*/
 	struct ValueWait tuner_pitch;
-- 
1.8.0

