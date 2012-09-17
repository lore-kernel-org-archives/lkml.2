Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab2IQAwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:52:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34022 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754735Ab2IQAvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:44 -0400
Message-Id: <20120917003629.133399725@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Aaron Tian <aaron_tian@pixart.com.tw>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 021/135] HID: multitouch: support PixArt optical touch screen
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Tian <aaron_tian@pixart.com.tw>

commit b7ea95ff9baab144dacdc30d752307938c5ab6bf upstream.

This patch modifies hid-multitouch driver for supporting PixArt optical touch
screen.  Because of the device does not have to set initial report, we apply
"HID_QUIRK_NO_INIT_REPORTS" quirk and add the device into hid_blacklist[]

Signed-off-by: Aaron Tian <aaron_tian@pixart.com.tw>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/Kconfig             |    1 +
 drivers/hid/hid-core.c          |    3 +++
 drivers/hid/hid-ids.h           |    5 +++++
 drivers/hid/hid-multitouch.c    |   15 +++++++++++++++
 drivers/hid/usbhid/hid-quirks.c |    3 +++
 5 files changed, 27 insertions(+)

--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -350,6 +350,7 @@ config HID_MULTITOUCH
 	  - Lumio CrystalTouch panels
 	  - MosArt dual-touch panels
 	  - PenMount dual touch panels
+	  - PixArt optical touch screen
 	  - Pixcir dual touch panels
 	  - eGalax dual-touch panels, including the Joojoo and Wetab tablets
 	  - Stantum multitouch panels
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1507,6 +1507,9 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT, USB_DEVICE_ID_PENMOUNT_PCI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_KEYBOARD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -593,6 +593,11 @@
 #define USB_VENDOR_ID_PI_ENGINEERING	0x05f3
 #define USB_DEVICE_ID_PI_ENGINEERING_VEC_USB_FOOTPEDAL	0xff
 
+#define USB_VENDOR_ID_PIXART				0x093a
+#define USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN	0x8001
+#define USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1	0x8002
+#define USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2	0x8003
+
 #define USB_VENDOR_ID_PLAYDOTCOM	0x0b43
 #define USB_DEVICE_ID_PLAYDOTCOM_EMS_USBII	0x0003
 
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -93,6 +93,7 @@ struct mt_class {
 #define MT_CLS_DUAL_INRANGE_CONTACTID		0x0005
 #define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	0x0006
 #define MT_CLS_DUAL_NSMU_CONTACTID		0x0007
+#define MT_CLS_INRANGE_CONTACTNUMBER		0x0009
 
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
@@ -155,6 +156,9 @@ struct mt_class mt_classes[] = {
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
 			MT_QUIRK_SLOT_IS_CONTACTID,
 		.maxcontacts = 2 },
+	{ .name = MT_CLS_INRANGE_CONTACTNUMBER,
+		.quirks = MT_QUIRK_VALID_IS_INRANGE |
+			MT_QUIRK_SLOT_IS_CONTACTNUMBER },
 
 	/*
 	 * vendor specific classes
@@ -744,6 +748,17 @@ static const struct hid_device_id mt_dev
 		HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT,
 			USB_DEVICE_ID_PENMOUNT_PCI) },
 
+	/* PixArt optical touch screen */
+	{ .driver_data = MT_CLS_INRANGE_CONTACTNUMBER,
+		HID_USB_DEVICE(USB_VENDOR_ID_PIXART,
+			USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN) },
+	{ .driver_data = MT_CLS_INRANGE_CONTACTNUMBER,
+		HID_USB_DEVICE(USB_VENDOR_ID_PIXART,
+			USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1) },
+	{ .driver_data = MT_CLS_INRANGE_CONTACTNUMBER,
+		HID_USB_DEVICE(USB_VENDOR_ID_PIXART,
+			USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2) },
+
 	/* PixCir-based panels */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
 		HID_USB_DEVICE(USB_VENDOR_ID_HANVON,
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -68,6 +68,9 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_AXIS_295, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_DMI, USB_DEVICE_ID_DMI_ENC, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1, HID_QUIRK_NO_INIT_REPORTS },
+	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN2, HID_QUIRK_NO_INIT_REPORTS },
 	{ USB_VENDOR_ID_PRODIGE, USB_DEVICE_ID_PRODIGE_CORDLESS, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_SUN, USB_DEVICE_ID_RARITAN_KVM_DONGLE, HID_QUIRK_NOGET },


