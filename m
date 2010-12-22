Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab0LVBEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 20:04:40 -0500
Received: from smtpout06.highway.telekom.at ([195.3.96.89]:30594 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751475Ab0LVBEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 20:04:38 -0500
To: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] USB: add support for Dream Cheeky DL100B Webmail Notifier (1d34:0004)
From: Melchior FRANZ <melchior.franz@gmail.com>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
Date: Wed, 22 Dec 2010 02:04:33 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012220204.33642@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Melchior FRANZ <mfranz@aon.at>

So far the USBLED driver only supports Delcom's "USB Visual Signal
Indicator" (http://www.delcomproducts.com/products_USBLMP.asp). The
driver generates virtual files "red", "green", and "blue" under the
device's /sys/ directory, where color values can be read from and
written to.

This patch adds support for Dream Cheeky's "DL100B Webmail Notifier"
(http://www.dreamcheeky.com/webmail-notifier -- available from several
shops, such as http://www.conrad.at/ce/de/product/777048/USB-WEBMAIL).
This device isn't as pretty as Delcom's, but it's *far* cheaper, and
its 3 LEDs can be set in 32 brightness steps each. The grey envelope
contour can easily be removed, leaving a rather neutral white box (with
a few small holes), which is useful for generic signalling purposes.
Of course, the small circuit board can easily be put into a prettier
case.

The DL100B device pretends to be a HID, but the HID descriptor shows
that it's not overly useful as such (see below). The patch therefore
removes the "HID-ness" (hid-core.c, hid-ids.h), and adds the necessary
commands to usbled.c. The protocol info comes from the developer's
manual that Dream Cheeky kindly provided (815DeveloperManual.pdf).


HID descriptor:

  0: 05 01   Usage Page 'Generic Desktop Controls'
  2: 09 10   Usage 'Reserved'
  4: a1 01   Collection 'Application (mouse, keyboard)'
  6: 05 00           Usage Page 'Undefined'
  8: 19 10           Usage Minimum = 16
 10: 29 11           Usage Maximum = 17
 12: 15 00           Logical Minimum = 0
 14: 25 0f           Logical Maximum = 15
 16: 75 08           Report Size = 8
 18: 95 08           Report Count = 8
 20: 91 02           Output data *var abs lin pref-state null-pos non-vol bit-field
 22: 19 10           Usage Minimum = 16
 24: 29 11           Usage Maximum = 17
 26: 15 00           Logical Minimum = 0
 28: 25 0f           Logical Maximum = 15
 30: 75 08           Report Size = 8
 32: 95 08           Report Count = 8
 34: 81 00           Input data array abs lin pref-state null-pos non-vol bit-field
 36: c0      End Collection

Signed-off-by: Melchior FRANZ <mfranz@aon.at>
---


Same as v2, except:
- version number removed from usbled.c file header
- garbage removed from corrupted diff (sorry about that)


Please review yet again and consider for inclusion. (The patch is diffed
against 2.6.36.2.)

m.  :-)



 drivers/hid/hid-core.c    |    1 +
 drivers/hid/hid-ids.h     |    2 +
 drivers/usb/misc/usbled.c |  118 ++++++++++++++++++++++++++++++++++-----------
 3 files changed, 93 insertions(+), 28 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a0dea3d..cb904d2 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1594,6 +1594,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DEALEXTREAME, USB_DEVICE_ID_DEALEXTREAME_RADIO_SI4701) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EARTHMATE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EM_LT20) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DREAM_CHEEKY, 0x0004) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ESSENTIAL_REALITY, USB_DEVICE_ID_ESSENTIAL_REALITY_P5) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ETT, USB_DEVICE_ID_TC5UH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ETT, USB_DEVICE_ID_TC4UM) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index c5ae5f1..650c7b2 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -197,6 +197,8 @@
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
 
+#define USB_VENDOR_ID_DREAM_CHEEKY	0x1d34
+
 #define USB_VENDOR_ID_ELO		0x04E7
 #define USB_DEVICE_ID_ELO_TS2700	0x0020
 
diff --git a/drivers/usb/misc/usbled.c b/drivers/usb/misc/usbled.c
index c96f51d..1732d9b 100644
--- a/drivers/usb/misc/usbled.c
+++ b/drivers/usb/misc/usbled.c
@@ -1,5 +1,5 @@
 /*
- * USB LED driver - 1.1
+ * USB LED driver
  *
  * Copyright (C) 2004 Greg Kroah-Hartman (greg@kroah.com)
  *
@@ -20,12 +20,17 @@
 #define DRIVER_AUTHOR "Greg Kroah-Hartman, greg@kroah.com"
 #define DRIVER_DESC "USB LED Driver"
 
-#define VENDOR_ID	0x0fc5
-#define PRODUCT_ID	0x1223
+enum led_type {
+	DELCOM_VISUAL_SIGNAL_INDICATOR,
+	DREAM_CHEEKY_WEBMAIL_NOTIFIER,
+};
 
 /* table of devices that work with this driver */
 static const struct usb_device_id id_table[] = {
-	{ USB_DEVICE(VENDOR_ID, PRODUCT_ID) },
+	{ USB_DEVICE(0x0fc5, 0x1223),
+			.driver_info = DELCOM_VISUAL_SIGNAL_INDICATOR },
+	{ USB_DEVICE(0x1d34, 0x0004),
+			.driver_info = DREAM_CHEEKY_WEBMAIL_NOTIFIER },
 	{ },
 };
 MODULE_DEVICE_TABLE (usb, id_table);
@@ -35,15 +40,12 @@ struct usb_led {
 	unsigned char		blue;
 	unsigned char		red;
 	unsigned char		green;
+	enum led_type		type;
 };
 
-#define BLUE	0x04
-#define RED	0x02
-#define GREEN	0x01
 static void change_color(struct usb_led *led)
 {
 	int retval;
-	unsigned char color = 0x07;
 	unsigned char *buffer;
 
 	buffer = kmalloc(8, GFP_KERNEL);
@@ -52,25 +54,59 @@ static void change_color(struct usb_led *led)
 		return;
 	}
 
-	if (led->blue)
-		color &= ~(BLUE);
-	if (led->red)
-		color &= ~(RED);
-	if (led->green)
-		color &= ~(GREEN);
-	dev_dbg(&led->udev->dev,
-		"blue = %d, red = %d, green = %d, color = %.2x\n",
-		led->blue, led->red, led->green, color);
-
-	retval = usb_control_msg(led->udev,
-				usb_sndctrlpipe(led->udev, 0),
-				0x12,
-				0xc8,
-				(0x02 * 0x100) + 0x0a,
-				(0x00 * 0x100) + color,
-				buffer,	
-				8,
-				2000);
+	switch (led->type) {
+	case DELCOM_VISUAL_SIGNAL_INDICATOR: {
+		unsigned char color = 0x07;
+
+		if (led->blue)
+			color &= ~0x04;
+		if (led->red)
+			color &= ~0x02;
+		if (led->green)
+			color &= ~0x01;
+		dev_dbg(&led->udev->dev,
+			"blue = %d, red = %d, green = %d, color = %.2x\n",
+			led->blue, led->red, led->green, color);
+
+		retval = usb_control_msg(led->udev,
+					usb_sndctrlpipe(led->udev, 0),
+					0x12,
+					0xc8,
+					(0x02 * 0x100) + 0x0a,
+					(0x00 * 0x100) + color,
+					buffer,
+					8,
+					2000);
+		break;
+	}
+
+	case DREAM_CHEEKY_WEBMAIL_NOTIFIER:
+		dev_dbg(&led->udev->dev,
+			"red = %d, green = %d, blue = %d\n",
+			led->red, led->green, led->blue);
+
+		buffer[0] = led->red;
+		buffer[1] = led->green;
+		buffer[2] = led->blue;
+		buffer[3] = buffer[4] = buffer[5] = 0;
+		buffer[6] = 0x1a;
+		buffer[7] = 0x05;
+
+		retval = usb_control_msg(led->udev,
+					usb_sndctrlpipe(led->udev, 0),
+					0x09,
+					0x21,
+					0x200,
+					0,
+					buffer,
+					8,
+					2000);
+		break;
+
+	default:
+		dev_err(&led->udev->dev, "unknown device type %d\n", led->type);
+	}
+
 	if (retval)
 		dev_dbg(&led->udev->dev, "retval = %d\n", retval);
 	kfree(buffer);
@@ -107,11 +143,12 @@ static int led_probe(struct usb_interface *interface, const struct usb_device_id
 
 	dev = kzalloc(sizeof(struct usb_led), GFP_KERNEL);
 	if (dev == NULL) {
-		dev_err(&interface->dev, "Out of memory\n");
+		dev_err(&interface->dev, "out of memory\n");
 		goto error_mem;
 	}
 
 	dev->udev = usb_get_dev(udev);
+	dev->type = id->driver_info;
 
 	usb_set_intfdata (interface, dev);
 
@@ -125,6 +162,31 @@ static int led_probe(struct usb_interface *interface, const struct usb_device_id
 	if (retval)
 		goto error;
 
+	if (dev->type == DREAM_CHEEKY_WEBMAIL_NOTIFIER) {
+		unsigned char *enable;
+
+		enable = kmemdup("\x1f\x02\0\x5f\0\0\x1a\x03", 8, GFP_KERNEL);
+		if (!enable) {
+			dev_err(&interface->dev, "out of memory\n");
+			retval = -ENOMEM;
+			goto error;
+		}
+
+		retval = usb_control_msg(udev,
+					usb_sndctrlpipe(udev, 0),
+					0x09,
+					0x21,
+					0x200,
+					0,
+					enable,
+					8,
+					2000);
+
+		kfree(enable);
+		if (retval != 8)
+			goto error;
+	}
+
 	dev_info(&interface->dev, "USB LED device now attached\n");
 	return 0;
 
