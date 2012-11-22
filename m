Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab2KVUN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:13:26 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54328 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373Ab2KVTuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:50:11 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 16/46] staging: line6: drop store_effects_setup sysfs attr
Date: Thu, 22 Nov 2012 20:48:55 +0100
Message-Id: <1353613765-18690-17-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 68 ---------------------------------------------
 1 file changed, 68 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index abf7ebe..949b8f7 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -360,60 +360,6 @@ void line6_pod_transmit_parameter(struct usb_line6_pod *pod, int param,
 }
 
 /*
-	Resolve value to memory location.
-*/
-static int pod_resolve(const char *buf, short block0, short block1,
-		       unsigned char *location)
-{
-	u8 value;
-	short block;
-	int ret;
-
-	ret = kstrtou8(buf, 10, &value);
-	if (ret)
-		return ret;
-
-	block = (value < 0x40) ? block0 : block1;
-	value &= 0x3f;
-	location[0] = block >> 7;
-	location[1] = value | (block & 0x7f);
-	return 0;
-}
-
-/*
-	Send command to retrieve channel/effects setup/amp setup to PODxt Pro.
-*/
-static ssize_t pod_send_retrieve_command(struct device *dev, const char *buf,
-					 size_t count, short block0,
-					 short block1)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	int ret;
-	int size = 4;
-	char *sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_DUMPMEM, size);
-
-	if (!sysex)
-		return 0;
-
-	ret = pod_resolve(buf, block0, block1, sysex + SYSEX_DATA_OFS);
-	if (ret) {
-		kfree(sysex);
-		return ret;
-	}
-	sysex[SYSEX_DATA_OFS + 2] = 0;
-	sysex[SYSEX_DATA_OFS + 3] = 0;
-	line6_dump_started(&pod->dumpreq, POD_DUMP_MEMORY);
-
-	if (line6_send_sysex_message(&pod->line6, sysex, size) < size)
-		line6_dump_finished(&pod->dumpreq);
-
-	kfree(sysex);
-	/* needs some delay here on AMD64 platform */
-	return count;
-}
-
-/*
 	Identify system parameters related to the tuner.
 */
 static bool pod_is_tuner(int code)
@@ -545,16 +491,6 @@ static ssize_t pod_set_finish(struct device *dev,
 }
 
 /*
-	"write" request on "store_effects_setup" special file.
-*/
-static ssize_t pod_set_store_effects_setup(struct device *dev,
-					   struct device_attribute *attr,
-					   const char *buf, size_t count)
-{
-	return pod_send_store_command(dev, buf, count, 0x0080, 0x0080);
-}
-
-/*
 	"read" request on "midi_postprocess" special file.
 */
 static ssize_t pod_get_midi_postprocess(struct device *dev,
@@ -731,8 +667,6 @@ static DEVICE_ATTR(routing, S_IWUSR | S_IRUGO, pod_get_routing,
 		   pod_set_routing);
 static DEVICE_ATTR(serial_number, S_IRUGO, pod_get_serial_number,
 		   line6_nop_write);
-static DEVICE_ATTR(store_effects_setup, S_IWUSR, line6_nop_read,
-		   pod_set_store_effects_setup);
 static DEVICE_ATTR(tuner_freq, S_IWUSR | S_IRUGO, pod_get_tuner_freq,
 		   pod_set_tuner_freq);
 static DEVICE_ATTR(tuner_mute, S_IWUSR | S_IRUGO, pod_get_tuner_mute,
@@ -823,7 +757,6 @@ static int pod_create_files2(struct device *dev)
 	CHECK_RETURN(device_create_file(dev, &dev_attr_midi_postprocess));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_routing));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_serial_number));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_store_effects_setup));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_freq));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_mute));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_tuner_note));
@@ -951,7 +884,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 			device_remove_file(dev, &dev_attr_midi_postprocess);
 			device_remove_file(dev, &dev_attr_routing);
 			device_remove_file(dev, &dev_attr_serial_number);
-			device_remove_file(dev, &dev_attr_store_effects_setup);
 			device_remove_file(dev, &dev_attr_tuner_freq);
 			device_remove_file(dev, &dev_attr_tuner_mute);
 			device_remove_file(dev, &dev_attr_tuner_note);
-- 
1.8.0

