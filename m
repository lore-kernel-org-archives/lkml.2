Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab2KVUPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:15:51 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54328 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab2KVTtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:49:55 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 07/46] staging: line6: drop monitor_level sysfs attr
Date: Thu, 22 Nov 2012 20:48:46 +0100
Message-Id: <1353613765-18690-8-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The monitor level can be adjusted using an ALSA volume control.
Therefore the sysfs attribute is unnecessary.  Note that we leave the
monitor_level driver variable so that the ALSA volume control still
works.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index c1eb145..5a941fa 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -244,8 +244,10 @@ void line6_pod_process_message(struct usb_line6_pod *pod)
 						break;
 
 					switch (buf[6]) {
-						PROCESS_SYSTEM_PARAM
-						    (monitor_level);
+					case POD_monitor_level:
+						pod->monitor_level.value = value;
+						break;
+
 						PROCESS_SYSTEM_PARAM(routing);
 						PROCESS_SYSTEM_PARAM
 						    (tuner_mute);
@@ -844,7 +846,6 @@ static ssize_t pod_set_ ## code(struct device *dev, \
 	return pod_set_system_param_string(pod, buf, count, POD_ ## code, mask); \
 }
 
-POD_GET_SET_SYSTEM_PARAM(monitor_level, 0xffff, 0);
 POD_GET_SET_SYSTEM_PARAM(routing, 0x0003, 0);
 POD_GET_SET_SYSTEM_PARAM(tuner_mute, 0x0001, 0);
 POD_GET_SET_SYSTEM_PARAM(tuner_freq, 0xffff, 0);
@@ -861,8 +862,6 @@ static DEVICE_ATTR(firmware_version, S_IRUGO, pod_get_firmware_version,
 		   line6_nop_write);
 static DEVICE_ATTR(midi_postprocess, S_IWUSR | S_IRUGO,
 		   pod_get_midi_postprocess, pod_set_midi_postprocess);
-static DEVICE_ATTR(monitor_level, S_IWUSR | S_IRUGO, pod_get_monitor_level,
-		   pod_set_monitor_level);
 static DEVICE_ATTR(name, S_IRUGO, pod_get_name, line6_nop_write);
 static DEVICE_ATTR(name_buf, S_IRUGO, pod_get_name_buf, line6_nop_write);
 static DEVICE_ATTR(retrieve_amp_setup, S_IWUSR, line6_nop_read,
@@ -969,7 +968,6 @@ static int pod_create_files2(struct device *dev)
 	CHECK_RETURN(device_create_file(dev, &dev_attr_finish));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_firmware_version));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_midi_postprocess));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_monitor_level));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_name));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_name_buf));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_retrieve_amp_setup));
@@ -1008,7 +1006,6 @@ static int pod_try_init(struct usb_interface *interface,
 		return -ENODEV;
 
 	/* initialize wait queues: */
-	init_waitqueue_head(&pod->monitor_level.wait);
 	init_waitqueue_head(&pod->routing.wait);
 	init_waitqueue_head(&pod->tuner_mute.wait);
 	init_waitqueue_head(&pod->tuner_freq.wait);
@@ -1106,7 +1103,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 			device_remove_file(dev, &dev_attr_finish);
 			device_remove_file(dev, &dev_attr_firmware_version);
 			device_remove_file(dev, &dev_attr_midi_postprocess);
-			device_remove_file(dev, &dev_attr_monitor_level);
 			device_remove_file(dev, &dev_attr_name);
 			device_remove_file(dev, &dev_attr_name_buf);
 			device_remove_file(dev, &dev_attr_retrieve_amp_setup);
-- 
1.8.0

