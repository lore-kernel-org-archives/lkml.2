Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab0DXOS5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 10:18:57 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38647 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab0DXOSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 10:18:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=s6lrRVGh/wU5oNs1ZuF1Jhv4fILcOSPLSPsPdT9lO8Br9x9g8rUWfOttqhqjSf0D/s
         RvM0lXSl1GRvBCf1enrvNGgbUaRAyyEFQznM+17wzxFSCPJenkTEn7/WlC3Iqtcm/Rms
         1EGOmYsEFD3+QkzRG5ov1yiQpTY7TrwfbT+lY=
MIME-Version: 1.0
Date: Sat, 24 Apr 2010 16:18:51 +0200
Message-ID: <t2g3711715e1004240718m8aacffc5o68fc9ccd1e66f212@mail.gmail.com>
Subject: HID: expand hid-topseed driver to support BTC "Emprex 3009URF III 
	Vista MCE Remote"
From: Wayne Thomas <waynethomas69@gmail.com>
To: jkosina@suse.cz, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HID: expand hid-topseed driver to support BTC "Emprex 3009URF III
Vista MCE Remote"

The Behavior Tech. Computer Corp. (BTC) remote branded as "Emprex 3009URF III
Vista Remote Controller" uses non-standard mappings for all of its 'special
purpose' keys (0xffbc usage page).  This patch modifies the existing hid-topseed
quirky driver to support both remotes in order to prevent proliferation of
in-kernel quirky drivers until such a time that udev remapping works
with these devices.
Tested successfully with both the "Emprex" remote and the "CyberLink" remote
originally supported by the hid-topseed driver.

Signed-off-by: Wayne Thomas <waynethomas69@gmail.com>


diff -uprN linux-2.6.33-clean/drivers/hid/hid-core.c
linux/drivers/hid/hid-core.c
--- linux-2.6.33-clean/drivers/hid/hid-core.c	2010-04-22
21:04:17.000000000 +0200
+++ linux/drivers/hid/hid-core.c	2010-04-23 19:55:17.000000000 +0200
@@ -1291,6 +1291,7 @@ static const struct hid_device_id hid_bl
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_CYMOTION) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_TACTICAL_PAD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_1) },
diff -uprN linux-2.6.33-clean/drivers/hid/hid-ids.h linux/drivers/hid/hid-ids.h
--- linux-2.6.33-clean/drivers/hid/hid-ids.h	2010-04-22 21:04:17.000000000 +0200
+++ linux/drivers/hid/hid-ids.h	2010-04-23 07:09:59.000000000 +0200
@@ -116,6 +116,9 @@
 #define USB_VENDOR_ID_BERKSHIRE		0x0c98
 #define USB_DEVICE_ID_BERKSHIRE_PCWD	0x1140

+#define USB_VENDOR_ID_BTC		0x046e
+#define USB_DEVICE_ID_BTC_EMPREX_REMOTE	0x5578
+
 #define USB_VENDOR_ID_CH		0x068e
 #define USB_DEVICE_ID_CH_PRO_PEDALS	0x00f2
 #define USB_DEVICE_ID_CH_COMBATSTICK	0x00f4
diff -uprN linux-2.6.33-clean/drivers/hid/hid-topseed.c
linux/drivers/hid/hid-topseed.c
--- linux-2.6.33-clean/drivers/hid/hid-topseed.c	2010-04-22
20:48:43.000000000 +0200
+++ linux/drivers/hid/hid-topseed.c	2010-04-22 21:29:20.000000000 +0200
@@ -3,6 +3,9 @@
  *
  *  Copyright (c) 2008 Lev Babiev
  *  based on hid-cherry driver
+ *
+ *  Modified to also support BTC "Emprex 3009URF III Vista MCE Remote"
+ *
  */

 /*
@@ -24,23 +27,29 @@ static int ts_input_mapping(struct hid_d
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
-	if ((usage->hid & HID_USAGE_PAGE) != 0x0ffbc0000)
+	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_LOGIVENDOR)
 		return 0;

 	switch (usage->hid & HID_USAGE) {
-        case 0x00d: ts_map_key_clear(KEY_HOME);           break;
-        case 0x024: ts_map_key_clear(KEY_MENU);           break;
-        case 0x025: ts_map_key_clear(KEY_TV);             break;
-        case 0x048: ts_map_key_clear(KEY_RED);            break;
-        case 0x047: ts_map_key_clear(KEY_GREEN);          break;
-        case 0x049: ts_map_key_clear(KEY_YELLOW);         break;
-        case 0x04a: ts_map_key_clear(KEY_BLUE);           break;
-        case 0x04b: ts_map_key_clear(KEY_ANGLE);          break;
-        case 0x04c: ts_map_key_clear(KEY_LANGUAGE);       break;
-        case 0x04d: ts_map_key_clear(KEY_SUBTITLE);       break;
-        case 0x031: ts_map_key_clear(KEY_AUDIO);          break;
-        case 0x032: ts_map_key_clear(KEY_TEXT);           break;
-        case 0x033: ts_map_key_clear(KEY_CHANNEL);        break;
+	case 0x00d: ts_map_key_clear(KEY_HOME);		break;
+	case 0x024: ts_map_key_clear(KEY_MENU);		break;
+	case 0x025: ts_map_key_clear(KEY_TV);		break;
+	case 0x031: ts_map_key_clear(KEY_AUDIO);	break;
+	case 0x032: ts_map_key_clear(KEY_TEXT);		break;
+	case 0x033: ts_map_key_clear(KEY_CHANNEL);	break;
+	case 0x047: ts_map_key_clear(KEY_MP3);		break;
+	case 0x048: ts_map_key_clear(KEY_DVD);		break;
+	case 0x049: ts_map_key_clear(KEY_CAMERA);	break;
+	case 0x04a: ts_map_key_clear(KEY_VIDEO);	break;
+	case 0x04b: ts_map_key_clear(KEY_ANGLE);	break;
+	case 0x04c: ts_map_key_clear(KEY_LANGUAGE);	break;
+	case 0x04d: ts_map_key_clear(KEY_SUBTITLE);	break;
+	case 0x050: ts_map_key_clear(KEY_RADIO);	break;
+	case 0x05b: ts_map_key_clear(KEY_RED);		break;
+	case 0x05c: ts_map_key_clear(KEY_GREEN);	break;
+	case 0x05d: ts_map_key_clear(KEY_YELLOW);	break;
+	case 0x05e: ts_map_key_clear(KEY_BLUE);		break;
+	case 0x05a: ts_map_key_clear(KEY_TEXT);		break;
 	default:
 		return 0;
 	}
@@ -50,6 +59,7 @@ static int ts_input_mapping(struct hid_d

 static const struct hid_device_id ts_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TOPSEED, USB_DEVICE_ID_TOPSEED_CYBERLINK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ts_devices);
diff -uprN linux-2.6.33-clean/drivers/hid/Kconfig linux/drivers/hid/Kconfig
--- linux-2.6.33-clean/drivers/hid/Kconfig	2010-04-22 20:48:43.000000000 +0200
+++ linux/drivers/hid/Kconfig	2010-04-22 21:29:20.000000000 +0200
@@ -80,6 +80,13 @@ config HID_BELKIN
 	---help---
 	Support for Belkin Flip KVM and Wireless keyboard.

+config HID_BTC
+	tristate "BTC Emprex remote control support" if EMBEDDED
+	depends on USB_HID
+	default y
+	---help---
+	Say Y if you have a BTC Emprex remote control.
+
 config HID_CHERRY
 	tristate "Cherry" if EMBEDDED
 	depends on USB_HID
diff -uprN linux-2.6.33-clean/drivers/hid/Makefile linux/drivers/hid/Makefile
--- linux-2.6.33-clean/drivers/hid/Makefile	2010-04-22 20:48:43.000000000 +0200
+++ linux/drivers/hid/Makefile	2010-04-22 21:29:20.000000000 +0200
@@ -22,6 +22,7 @@ endif
 obj-$(CONFIG_HID_A4TECH)	+= hid-a4tech.o
 obj-$(CONFIG_HID_APPLE)		+= hid-apple.o
 obj-$(CONFIG_HID_BELKIN)	+= hid-belkin.o
+obj-$(CONFIG_HID_BTC)		+= hid-topseed.o
 obj-$(CONFIG_HID_CHERRY)	+= hid-cherry.o
 obj-$(CONFIG_HID_CHICONY)	+= hid-chicony.o
 obj-$(CONFIG_HID_CYPRESS)	+= hid-cypress.o
