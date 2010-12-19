Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab0LSWRD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 17:17:03 -0500
Received: from nat-warsl417-02.aon.at ([195.3.96.120]:38718 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757238Ab0LSWRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 17:17:00 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Dec 2010 17:16:59 EST
From: Melchior FRANZ <melchior.franz@gmail.com>
To: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] USB: add support for Dream Cheeky DL100B Webmail Notifier (1d34:0004)
Date: Sun, 19 Dec 2010 23:10:12 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.2+; KDE/4.4.4; x86_64; ; )
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012192310.13431@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Melchior FRANZ <mfranz@aon.at>

Add support for Dream Cheeky DL100B Webmail Notifier (1d34:0004) as
usbled device. Lets hid-core ignore the device's HID-ness.

Signed-off-by: Melchior FRANZ <mfranz@aon.at>
---

So far the USBLED driver only supports Delcom's "USB Visual Signal
Indicator" (http://www.delcomproducts.com/products_USBLMP.asp). The
driver generates virtual files "red", "blue", and "green" under the
device's /sys/ directory, where color values can be read and written to.

This patch adds support for Dream Cheeky's "DL100B Webmail Notifier"
(http://www.dreamcheeky.com/webmail-notifier -- available from several
shops, such as http://www.conrad.at/ce/de/product/777048/USB-WEBMAIL).
This device isn't as pretty as Delcom's, but it's *far* cheaper, and
its 3 LEDs can be set in 32 brightness steps each. The grey envelope
contour can easily be removed, leaving a rather neutral white box (with
a few small holes), which is useful for generic signalling purposes.
Of course, the small circuit board can easily be put into a prettier
case. The price difference to Delcom's thingy lets you a lot of room. :-)

The DL100B device pretends to be a HID, but the HID descriptor shows
that it's not overly useful as such (see below). The patch therefore
removes the "HID-ness" (hid-core.c, hid-ids.h), and adds the necessary
commands to usbled.c. The protocol comes from the developer's manual
that Dream Cheeky kindly provided (815DeveloperManual.pdf).

Please review and consider for inclusion. (The patch is diffed against
2.6.36.2.)

m.


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



 drivers/hid/hid-core.c    |    1 +
 drivers/hid/hid-ids.h     |    2 +
 drivers/usb/misc/usbled.c |  101 ++++++++++++++++++++++++++++++++++-----------
 3 files changed, 80 insertions(+), 24 deletions(-)

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
index c96f51d..156f236 100644
--- a/drivers/usb/misc/usbled.c
+++ b/drivers/usb/misc/usbled.c
@@ -20,12 +20,13 @@
 #define DRIVER_AUTHOR "Greg Kroah-Hartman, greg@kroah.com"
 #define DRIVER_DESC "USB LED Driver"
 
-#define VENDOR_ID	0x0fc5
-#define PRODUCT_ID	0x1223
+#define VENDOR_ID_DELCOM       0x0fc5
+#define VENDOR_ID_DREAM_CHEEKY 0x1d34
 
 /* table of devices that work with this driver */
 static const struct usb_device_id id_table[] = {
-	{ USB_DEVICE(VENDOR_ID, PRODUCT_ID) },
+	{ USB_DEVICE(VENDOR_ID_DELCOM, 0x1223) },
+	{ USB_DEVICE(VENDOR_ID_DREAM_CHEEKY, 0x0004) }, /* DL100B */
 	{ },
 };
 MODULE_DEVICE_TABLE (usb, id_table);
@@ -35,6 +36,7 @@ struct usb_led {
 	unsigned char		blue;
 	unsigned char		red;
 	unsigned char		green;
+	unsigned char		dream_cheeky:1;
 };
 
 #define BLUE	0x04
@@ -43,7 +45,6 @@ struct usb_led {
 static void change_color(struct usb_led *led)
 {
 	int retval;
-	unsigned char color = 0x07;
 	unsigned char *buffer;
 
 	buffer = kmalloc(8, GFP_KERNEL);
@@ -52,25 +53,51 @@ static void change_color(struct usb_led *led)
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
+	if (led->dream_cheeky) {
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
+
+	} else { /* Delcom */
+		unsigned char color = 0x07;
+
+		if (led->blue)
+			color &= ~(BLUE);
+		if (led->red)
+			color &= ~(RED);
+		if (led->green)
+			color &= ~(GREEN);
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
+	}
 	if (retval)
 		dev_dbg(&led->udev->dev, "retval = %d\n", retval);
 	kfree(buffer);
@@ -107,7 +134,7 @@ static int led_probe(struct usb_interface *interface, const struct usb_device_id
 
 	dev = kzalloc(sizeof(struct usb_led), GFP_KERNEL);
 	if (dev == NULL) {
-		dev_err(&interface->dev, "Out of memory\n");
+		dev_err(&interface->dev, "out of memory\n");
 		goto error_mem;
 	}
 
@@ -125,6 +152,32 @@ static int led_probe(struct usb_interface *interface, const struct usb_device_id
 	if (retval)
 		goto error;
 
+	if (id->idVendor == VENDOR_ID_DREAM_CHEEKY && id->idProduct == 0x0004) {
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
+		dev->dream_cheeky = 1;
+	}
+
 	dev_info(&interface->dev, "USB LED device now attached\n");
 	return 0;
 
