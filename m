Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab2KVUOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:14:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54328 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab2KVTuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:50:06 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 13/46] staging: line6: drop retrieve_effects_setup sysfs attr
Date: Thu, 22 Nov 2012 20:48:52 +0100
Message-Id: <1353613765-18690-14-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 48 ---------------------------------------------
 1 file changed, 48 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index bc65fc7..95769c5 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -381,39 +381,6 @@ static int pod_resolve(const char *buf, short block0, short block1,
 }
 
 /*
-	Send command to store channel/effects setup/amp setup to PODxt Pro.
-*/
-static ssize_t pod_send_store_command(struct device *dev, const char *buf,
-				      size_t count, short block0, short block1)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	int ret;
-	int size = 3 + sizeof(pod->prog_data_buf);
-	char *sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_STORE, size);
-
-	if (!sysex)
-		return 0;
-
-	/* Don't know what this is good for, but PODxt Pro transmits it, so we
-	 * also do... */
-	sysex[SYSEX_DATA_OFS] = 5;
-	ret = pod_resolve(buf, block0, block1, sysex + SYSEX_DATA_OFS + 1);
-	if (ret) {
-		kfree(sysex);
-		return ret;
-	}
-
-	memcpy(sysex + SYSEX_DATA_OFS + 3, &pod->prog_data_buf,
-	       sizeof(pod->prog_data_buf));
-
-	line6_send_sysex_message(&pod->line6, sysex, size);
-	kfree(sysex);
-	/* needs some delay here on AMD64 platform */
-	return count;
-}
-
-/*
 	Send command to retrieve channel/effects setup/amp setup to PODxt Pro.
 */
 static ssize_t pod_send_retrieve_command(struct device *dev, const char *buf,
@@ -608,16 +575,6 @@ static ssize_t pod_set_store_amp_setup(struct device *dev,
 }
 
 /*
-	"write" request on "retrieve_effects_setup" special file.
-*/
-static ssize_t pod_set_retrieve_effects_setup(struct device *dev,
-					      struct device_attribute *attr,
-					      const char *buf, size_t count)
-{
-	return pod_send_retrieve_command(dev, buf, count, 0x0080, 0x0080);
-}
-
-/*
 	"read" request on "midi_postprocess" special file.
 */
 static ssize_t pod_get_midi_postprocess(struct device *dev,
@@ -790,8 +747,6 @@ static DEVICE_ATTR(firmware_version, S_IRUGO, pod_get_firmware_version,
 		   line6_nop_write);
 static DEVICE_ATTR(midi_postprocess, S_IWUSR | S_IRUGO,
 		   pod_get_midi_postprocess, pod_set_midi_postprocess);
-static DEVICE_ATTR(retrieve_effects_setup, S_IWUSR, line6_nop_read,
-		   pod_set_retrieve_effects_setup);
 static DEVICE_ATTR(routing, S_IWUSR | S_IRUGO, pod_get_routing,
 		   pod_set_routing);
 static DEVICE_ATTR(serial_number, S_IRUGO, pod_get_serial_number,
@@ -890,7 +845,6 @@ static int pod_create_files2(struct device *dev)
 	CHECK_RETURN(device_create_file(dev, &dev_attr_finish));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_firmware_version));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_midi_postprocess));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_retrieve_effects_setup));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_routing));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_serial_number));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_store_amp_setup));
@@ -1021,8 +975,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 			device_remove_file(dev, &dev_attr_finish);
 			device_remove_file(dev, &dev_attr_firmware_version);
 			device_remove_file(dev, &dev_attr_midi_postprocess);
-			device_remove_file(dev,
-					   &dev_attr_retrieve_effects_setup);
 			device_remove_file(dev, &dev_attr_routing);
 			device_remove_file(dev, &dev_attr_serial_number);
 			device_remove_file(dev, &dev_attr_store_amp_setup);
-- 
1.8.0

