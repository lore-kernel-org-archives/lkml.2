Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965276Ab2KVUBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:01:21 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61568 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965187Ab2KVTvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:51:38 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        laurent_navet@yahoo.com, Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 31/46] staging: line6: drop variax tone sysfs attr
Date: Thu, 22 Nov 2012 20:49:10 +0100
Message-Id: <1353613765-18690-32-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/variax.c | 42 ------------------------------------------
 drivers/staging/line6/variax.h |  5 -----
 2 files changed, 47 deletions(-)

diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index ef78f5a..31ece34 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -199,11 +199,6 @@ void line6_variax_process_message(struct usb_line6_variax *variax)
 
 	switch (buf[0]) {
 	case LINE6_PARAM_CHANGE | LINE6_CHANNEL_HOST:
-		switch (buf[1]) {
-		case VARIAXMIDI_tone:
-			variax->tone = buf[2];
-		}
-
 		break;
 
 	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_DEVICE:
@@ -326,40 +321,6 @@ static ssize_t variax_set_active(struct device *dev,
 	return count;
 }
 
-/*
-	"read" request on "tone" special file.
-*/
-static ssize_t variax_get_tone(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	return sprintf(buf, "%d\n", variax->tone);
-}
-
-/*
-	"write" request on "tone" special file.
-*/
-static ssize_t variax_set_tone(struct device *dev,
-			       struct device_attribute *attr,
-			       const char *buf, size_t count)
-{
-	struct usb_line6_variax *variax =
-	    usb_get_intfdata(to_usb_interface(dev));
-	u8 value;
-	int ret;
-
-	ret = kstrtou8(buf, 10, &value);
-	if (ret)
-		return ret;
-
-	if (line6_transmit_parameter(&variax->line6, VARIAXMIDI_tone,
-				     value) == 0)
-		variax->tone = value;
-
-	return count;
-}
-
 static ssize_t get_string(char *buf, const char *data, int length)
 {
 	int i;
@@ -477,7 +438,6 @@ static ssize_t variax_set_raw2(struct device *dev,
 #endif
 
 /* Variax workbench special files: */
-static DEVICE_ATTR(tone, S_IWUSR | S_IRUGO, variax_get_tone, variax_set_tone);
 static DEVICE_ATTR(name, S_IRUGO, variax_get_name, line6_nop_write);
 static DEVICE_ATTR(bank, S_IRUGO, variax_get_bank, line6_nop_write);
 static DEVICE_ATTR(dump, S_IRUGO, variax_get_dump, line6_nop_write);
@@ -519,7 +479,6 @@ static void variax_destruct(struct usb_interface *interface)
 static int variax_create_files2(struct device *dev)
 {
 	int err;
-	CHECK_RETURN(device_create_file(dev, &dev_attr_tone));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_name));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_bank));
 	CHECK_RETURN(device_create_file(dev, &dev_attr_dump));
@@ -623,7 +582,6 @@ void line6_variax_disconnect(struct usb_interface *interface)
 	if (dev != NULL) {
 		/* remove sysfs entries: */
 		line6_variax_remove_files(0, 0, dev);
-		device_remove_file(dev, &dev_attr_tone);
 		device_remove_file(dev, &dev_attr_name);
 		device_remove_file(dev, &dev_attr_bank);
 		device_remove_file(dev, &dev_attr_dump);
diff --git a/drivers/staging/line6/variax.h b/drivers/staging/line6/variax.h
index 426c90c..745b5a1 100644
--- a/drivers/staging/line6/variax.h
+++ b/drivers/staging/line6/variax.h
@@ -93,11 +93,6 @@ struct usb_line6_variax {
 	unsigned char bank[18];
 
 	/**
-		Position of tone control dial.
-	*/
-	int tone;
-
-	/**
 		Handler for device initializaton.
 	*/
 	struct work_struct startup_work;
-- 
1.8.0

