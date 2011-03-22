Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab1CVPPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:15:03 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:57477 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753239Ab1CVPO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:14:59 -0400
X-Greylist: delayed 2634 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Mar 2011 11:14:59 EDT
Date: Tue, 22 Mar 2011 14:31:04 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.38] Mode button quirk for Saitek Cyborg R.A.T. 7
Message-ID: <mpro.ligqzs1xd6elc0462.linux@youmustbejoking.demon.co.uk>
Mail-Followup-To: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com, 
 linux-kernel@vger.kernel.org, Darren Salt <linux@youmustbejoking.demon.co.uk>
User-Agent: Messenger-Pro/2.66.6.3353 (Qt/4.6.3) (Linux-x86_64)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a quirk for the Saitek Cyborg R.A.T. 7 mouse. It has a
"mode" button, to the left of button 1, which behaves strangely: it cycles
through three logical button numbers (8, 9 and 10 as seen by the kernel and
13, 14 and 15, as seen by X), and defers sending the release event until the
next time this button is pressed. This, I've noticed, confuses X into
thinking that a drag operation is in progress when this button is clicked.

The only sensible workaround is, I think, to have these logical buttons
treated as instant-release.

(Other R.A.T. mice are almost certainly affected.)

Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>

diff -ur linux-2.6.38.orig/drivers/hid/hid-ids.h
linux-2.6.38/drivers/hid/hid-ids.h
--- linux-2.6.38.orig/drivers/hid/hid-ids.h	2011-03-15 01:20:32.000000000
+0000
+++ linux-2.6.38/drivers/hid/hid-ids.h	2011-03-22 12:55:13.413659466 +0000
@@ -502,6 +502,7 @@
 #define USB_DEVICE_ID_ROCCAT_PYRA_WIRELESS	0x2cf6
 
 #define USB_VENDOR_ID_SAITEK		0x06a3
+#define USB_DEVICE_ID_SAITEK_RAT7	0x0ccb
 #define USB_DEVICE_ID_SAITEK_RUMBLEPAD	0xff17
 
 #define USB_VENDOR_ID_SAMSUNG		0x0419
diff -ur linux-2.6.38.orig/drivers/hid/hid-input.c
linux-2.6.38/drivers/hid/hid-input.c
--- linux-2.6.38.orig/drivers/hid/hid-input.c	2011-03-15 01:20:32.000000000
+0000
+++ linux-2.6.38/drivers/hid/hid-input.c	2011-03-22 13:45:47.507874406 +0000
@@ -790,6 +790,13 @@
 
 	if ((field->flags & HID_MAIN_ITEM_RELATIVE) && (usage->type == EV_KEY))
 		input_event(input, usage->type, usage->code, 0);
+
+        /* hack for Saitek RAT mice which report release events for their
+         * mode button on the NEXT press event
+         */
+	if ((*quirks & HID_QUIRK_RAT_BROKEN_BUTTON_RELEASE) &&
+            (usage->code >= BTN_MOUSE + 8) && (usage->code <= BTN_MOUSE +
10))
+		input_event(input, usage->type, usage->code, 0);
 }
 
 void hidinput_report_event(struct hid_device *hid, struct hid_report
*report)
diff -ur linux-2.6.38.orig/drivers/hid/usbhid/hid-quirks.c
linux-2.6.38/drivers/hid/usbhid/hid-quirks.c
--- linux-2.6.38.orig/drivers/hid/usbhid/hid-quirks.c	2011-03-15
01:20:32.000000000 +0000
+++ linux-2.6.38/drivers/hid/usbhid/hid-quirks.c	2011-03-22
12:58:23.016556607 +0000
@@ -85,6 +85,8 @@
 
 	{ USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_MULTI_TOUCH,
HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS,
HID_QUIRK_MULTI_INPUT },
+
+	{ USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_RAT7,
HID_QUIRK_RAT_BROKEN_BUTTON_RELEASE },
 	{ 0, 0 }
 };
 
diff -ur linux-2.6.38.orig/include/linux/hid.h
linux-2.6.38/include/linux/hid.h
--- linux-2.6.38.orig/include/linux/hid.h	2011-03-15 01:20:32.000000000 +0000
+++ linux-2.6.38/include/linux/hid.h	2011-03-22 12:58:12.688834637 +0000
@@ -312,6 +312,7 @@
 #define HID_QUIRK_BADPAD			0x00000020
 #define HID_QUIRK_MULTI_INPUT			0x00000040
 #define HID_QUIRK_HIDINPUT_FORCE		0x00000080
+#define HID_QUIRK_RAT_BROKEN_BUTTON_RELEASE	0x00000100
 #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00010000
 #define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
 #define HID_QUIRK_NO_INIT_REPORTS		0x20000000

-- 
| Darren Salt            | linux at youmustbejoking | nr. Ashington, | Toon
| using Debian GNU/Linux | or ds    ,demon,co,uk    | Northumberland | back!
| + Buy less and make it last longer.         INDUSTRY CAUSES GLOBAL WARMING.

A clean desk is a sign of a sick mind.
