Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab2KVTt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:49:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45940 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393Ab2KVTtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:49:53 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 05/46] staging: line6: drop dump sysfs attr
Date: Thu, 22 Nov 2012 20:48:44 +0100
Message-Id: <1353613765-18690-6-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once further sysfs attrs have been removed it will also be possible to
drop prog_data and other pieces which we keep for now.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/pod.c | 60 +++------------------------------------------
 1 file changed, 3 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/line6/pod.c b/drivers/staging/line6/pod.c
index 7c76b65..56eab0a 100644
--- a/drivers/staging/line6/pod.c
+++ b/drivers/staging/line6/pod.c
@@ -138,24 +138,6 @@ static char *pod_alloc_sysex_buffer(struct usb_line6_pod *pod, int code,
 }
 
 /*
-	Send channel dump data to the PODxt Pro.
-*/
-static void pod_dump(struct usb_line6_pod *pod, const unsigned char *data)
-{
-	int size = 1 + sizeof(pod->prog_data);
-	char *sysex = pod_alloc_sysex_buffer(pod, POD_SYSEX_DUMP, size);
-	if (!sysex)
-		return;
-	/* Don't know what this is good for, but PODxt Pro transmits it, so we
-	 * also do... */
-	sysex[SYSEX_DATA_OFS] = 5;
-	memcpy(sysex + SYSEX_DATA_OFS + 1, data, sizeof(pod->prog_data));
-	line6_send_sysex_message(&pod->line6, sysex, size);
-	memcpy(&pod->prog_data, data, sizeof(pod->prog_data));
-	kfree(sysex);
-}
-
-/*
 	Store parameter value in driver memory.
 */
 static void pod_store_parameter(struct usb_line6_pod *pod, int param, int value)
@@ -411,7 +393,9 @@ static ssize_t pod_send_store_command(struct device *dev, const char *buf,
 	if (!sysex)
 		return 0;
 
-	sysex[SYSEX_DATA_OFS] = 5;	/* see pod_dump() */
+	/* Don't know what this is good for, but PODxt Pro transmits it, so we
+	 * also do... */
+	sysex[SYSEX_DATA_OFS] = 5;
 	ret = pod_resolve(buf, block0, block1, sysex + SYSEX_DATA_OFS + 1);
 	if (ret) {
 		kfree(sysex);
@@ -513,41 +497,6 @@ static ssize_t pod_get_name_buf(struct device *dev,
 }
 
 /*
-	"read" request on "dump" special file.
-*/
-static ssize_t pod_get_dump(struct device *dev, struct device_attribute *attr,
-			    char *buf)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-	int retval = line6_dump_wait_interruptible(&pod->dumpreq);
-	if (retval < 0)
-		return retval;
-	memcpy(buf, &pod->prog_data, sizeof(pod->prog_data));
-	return sizeof(pod->prog_data);
-}
-
-/*
-	"write" request on "dump" special file.
-*/
-static ssize_t pod_set_dump(struct device *dev, struct device_attribute *attr,
-			    const char *buf, size_t count)
-{
-	struct usb_interface *interface = to_usb_interface(dev);
-	struct usb_line6_pod *pod = usb_get_intfdata(interface);
-
-	if (count != sizeof(pod->prog_data)) {
-		dev_err(pod->line6.ifcdev,
-			"data block must be exactly %d bytes\n",
-			(int)sizeof(pod->prog_data));
-		return -EINVAL;
-	}
-
-	pod_dump(pod, buf);
-	return sizeof(pod->prog_data);
-}
-
-/*
 	Identify system parameters related to the tuner.
 */
 static bool pod_is_tuner(int code)
@@ -943,7 +892,6 @@ POD_GET_SYSTEM_PARAM(tuner_pitch, 1);
 
 /* POD special files: */
 static DEVICE_ATTR(device_id, S_IRUGO, pod_get_device_id, line6_nop_write);
-static DEVICE_ATTR(dump, S_IWUSR | S_IRUGO, pod_get_dump, pod_set_dump);
 static DEVICE_ATTR(dump_buf, S_IWUSR | S_IRUGO, pod_get_dump_buf,
 		   pod_set_dump_buf);
 static DEVICE_ATTR(finish, S_IWUSR, line6_nop_read, pod_set_finish);
@@ -1056,7 +1004,6 @@ static int pod_create_files2(struct device *dev)
 	int err;
 
 	CHECK_RETURN(device_create_file(dev, &dev_attr_device_id));
-	CHECK_RETURN(device_create_file(dev, &dev_attr_dump));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_dump_buf));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_finish));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_firmware_version));
@@ -1195,7 +1142,6 @@ void line6_pod_disconnect(struct usb_interface *interface)
 					       properties->device_bit, dev);
 
 			device_remove_file(dev, &dev_attr_device_id);
-			device_remove_file(dev, &dev_attr_dump);
 			device_remove_file(dev, &dev_attr_dump_buf);
 			device_remove_file(dev, &dev_attr_finish);
 			device_remove_file(dev, &dev_attr_firmware_version);
-- 
1.8.0

