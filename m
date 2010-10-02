Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0JBKWa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 06:22:30 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:43994 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab0JBKW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 06:22:28 -0400
Message-ID: <4CA707E1.8050504@web.de>
Date: Sat, 02 Oct 2010 12:22:25 +0200
From: Hendrik Iben <Hendrik_Iben@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100502 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hid input - force feedback support for (old) Logitech RumblePad
 gamepad
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/AT9FvDOnNIG6AptLywvKnB+5MXyo3jfFiHWFE
	CQzqoqirMpIZ8Kvfxsbjp6XRIbqq+Hvjy+nMhfwMTvvx2MILmY
	1cJmSuFRu+/D1AH8ROkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

I implemented a force feedback driver for an old (~year 2000, corded) Logitech RumblePad by sniffing on USB traffic.
In the end I realized that it uses the same protocol that is used for the Rumblepad 2 device. So adding support was 
as easy as adding the new device id to the existing hid parts.
This patch was made against kernel 2.6.35 and tested on 2.6.32 and 2.6.33.
Please note that the old device is really spelled RumblePad while the new devices are called Rumblepad...
I don't know anybody else with this pad to test this but as there were no code changes necessary I believe this
patch should be easy to integrate.

Best regards,
Hendrik

p.s.
I hope I stick to the submitting guidelines with this...

From: Hendrik Iben <Hendrik_Iben@web.de>

This patch adds force feedback support for Logitech WingMan RumblePad
gamepads by extending the Logitech Rumblepad 2 force feedback code.

Signed-off-by: Hendrik Iben <Hendrik_Iben@web.de>

---

diff -uprN -X linux-2.6.35-vanilla/Documentation/dontdiff linux-2.6.35-vanilla/drivers/hid/hid-core.c linux-2.6.35/drivers/hid/hid-core.c
--- linux-2.6.35-vanilla/drivers/hid/hid-core.c	2010-09-29 14:12:13.000000000 +0200
+++ linux-2.6.35/drivers/hid/hid-core.c	2010-09-29 14:15:25.000000000 +0200
@@ -1316,6 +1316,7 @@ static const struct hid_device_id hid_bl
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_CORDLESS_DESKTOP_LX500) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_EXTREME_3D) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_WHEEL) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_RUMBLEPAD_CORD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_RUMBLEPAD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_RUMBLEPAD2_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_WINGMAN_F3D) },
diff -uprN -X linux-2.6.35-vanilla/Documentation/dontdiff linux-2.6.35-vanilla/drivers/hid/hid-ids.h linux-2.6.35/drivers/hid/hid-ids.h
--- linux-2.6.35-vanilla/drivers/hid/hid-ids.h	2010-09-29 14:12:12.000000000 +0200
+++ linux-2.6.35/drivers/hid/hid-ids.h	2010-09-29 14:13:17.000000000 +0200
@@ -325,6 +325,7 @@
 #define USB_DEVICE_ID_LOGITECH_RECEIVER	0xc101
 #define USB_DEVICE_ID_LOGITECH_HARMONY_FIRST  0xc110
 #define USB_DEVICE_ID_LOGITECH_HARMONY_LAST 0xc14f
+#define USB_DEVICE_ID_LOGITECH_RUMBLEPAD_CORD	0xc20a
 #define USB_DEVICE_ID_LOGITECH_RUMBLEPAD	0xc211
 #define USB_DEVICE_ID_LOGITECH_EXTREME_3D	0xc215
 #define USB_DEVICE_ID_LOGITECH_RUMBLEPAD2	0xc218
diff -uprN -X linux-2.6.35-vanilla/Documentation/dontdiff linux-2.6.35-vanilla/drivers/hid/hid-lg2ff.c linux-2.6.35/drivers/hid/hid-lg2ff.c
--- linux-2.6.35-vanilla/drivers/hid/hid-lg2ff.c	2010-09-29 14:12:13.000000000 +0200
+++ linux-2.6.35/drivers/hid/hid-lg2ff.c	2010-09-29 14:40:09.000000000 +0200
@@ -1,5 +1,5 @@
 /*
- *  Force feedback support for Logitech Rumblepad 2
+ *  Force feedback support for Logitech RumblePad and Rumblepad 2
  *
  *  Copyright (c) 2008 Anssi Hannula <anssi.hannula@gmail.com>
  */
@@ -110,7 +110,7 @@ int lg2ff_init(struct hid_device *hid)
 
 	usbhid_submit_report(hid, report, USB_DIR_OUT);
 
-	dev_info(&hid->dev, "Force feedback for Logitech Rumblepad 2 by "
+	dev_info(&hid->dev, "Force feedback for Logitech RumblePad/Rumblepad 2 by "
 	       "Anssi Hannula <anssi.hannula@gmail.com>\n");
 
 	return 0;
diff -uprN -X linux-2.6.35-vanilla/Documentation/dontdiff linux-2.6.35-vanilla/drivers/hid/hid-lg.c linux-2.6.35/drivers/hid/hid-lg.c
--- linux-2.6.35-vanilla/drivers/hid/hid-lg.c	2010-09-29 14:12:12.000000000 +0200
+++ linux-2.6.35/drivers/hid/hid-lg.c	2010-09-29 14:39:15.000000000 +0200
@@ -7,6 +7,7 @@
  *  Copyright (c) 2006-2007 Jiri Kosina
  *  Copyright (c) 2007 Paul Walmsley
  *  Copyright (c) 2008 Jiri Slaby
+ *  Copyright (c) 2010 Hendrik Iben
  */
 
 /*
@@ -325,6 +326,8 @@ static const struct hid_device_id lg_dev
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_WHEEL),
 		.driver_data = LG_NOGET | LG_FF },
 
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_RUMBLEPAD_CORD),
+		.driver_data = LG_FF2 },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_RUMBLEPAD),
 		.driver_data = LG_FF },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_RUMBLEPAD2_2),
diff -uprN -X linux-2.6.35-vanilla/Documentation/dontdiff linux-2.6.35-vanilla/drivers/hid/Kconfig linux-2.6.35/drivers/hid/Kconfig
--- linux-2.6.35-vanilla/drivers/hid/Kconfig	2010-09-29 14:12:12.000000000 +0200
+++ linux-2.6.35/drivers/hid/Kconfig	2010-09-29 14:38:26.000000000 +0200
@@ -206,12 +206,12 @@ config LOGITECH_FF
 	  force feedback.
 
 config LOGIRUMBLEPAD2_FF
-	bool "Logitech Rumblepad 2 force feedback support"
+	bool "Logitech RumblePad/Rumblepad 2 force feedback support"
 	depends on HID_LOGITECH
 	select INPUT_FF_MEMLESS
 	help
 	  Say Y here if you want to enable force feedback support for Logitech
-	  Rumblepad 2 devices.
+	  RumblePad and Rumblepad 2 devices.
 
 config LOGIG940_FF
 	bool "Logitech Flight System G940 force feedback support"
