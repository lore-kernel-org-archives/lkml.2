Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab1DTJTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:19:52 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:36537 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab1DTJTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EidGWykyzyyEqK1caF/9eHz4/WwD4UWnK0LxQJj4Iv/78VdRW6h8w69dNqwkTYVgSW
         JrjKsQFyZhwOXRcXJE8JhkCJBy0VI2i0L+HPHDVaBdjYBmEyjlGO0NjTjTjpbjQYfq/b
         PjJ9ecZupODrN9iBLjayhEU9/VHbcTmJc/ZAw=
From: PenMount <penmount.touch@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: penmount.touch@gmail.com, PenMount <salt@salt.com.tw>
Subject: [PATCH] HID: add support for PenMount dual-touch panel
Date: Wed, 20 Apr 2011 17:19:15 +0800
Message-Id: <1303291155-3148-1-git-send-email-salt@salt.com.tw>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds PenMount support to hid-multitouch.
A new class MT_CLS_CONFIDENCE_SERIAL_MODE is defined for PenMount,
since it uses HID_DG_CONFIDENCE as the valid flag.
A new quirk MT_QUIRK_SERIAL_REPORT_MODE is defined,
since PenMount uses serial reporting mode and there is no
HID_DG_CONTACTCOUNT usage in it's report descriptor.

Signed-off-by: PenMount <salt@salt.com.tw>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/Kconfig          |    1 +
 drivers/hid/hid-core.c       |    1 +
 drivers/hid/hid-ids.h        |    3 +++
 drivers/hid/hid-multitouch.c |   14 ++++++++++++++
 4 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 996ae3a..8058cf1 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -313,6 +313,7 @@ config HID_MULTITOUCH
 	  - Cypress TrueTouch panels
 	  - Hanvon dual touch panels
 	  - IrTouch Infrared USB panels
+	  - PenMount dual touch panels
 	  - Pixcir dual touch panels
 	  - 'Sensing Win7-TwoFinger' panel by GeneralTouch
           - eGalax dual-touch panels, including the
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index c3d6626..6e31b9f 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1438,6 +1438,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_PKB1700) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT, USB_DEVICE_ID_PENMOUNT_PCI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_QUANTA, USB_DEVICE_ID_PIXART_IMAGING_INC_OPTICAL_TOUCH_SCREEN) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index d485894..a4d0505 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -487,6 +487,9 @@
 #define USB_VENDOR_ID_PETALYNX		0x18b1
 #define USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE	0x0037
 
+#define USB_VENDOR_ID_PENMOUNT		0x14e1
+#define USB_DEVICE_ID_PENMOUNT_PCI	0x3500
+
 #define USB_VENDOR_ID_PHILIPS		0x0471
 #define USB_DEVICE_ID_PHILIPS_IEEE802154_DONGLE 0x0617
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 0175f85..c88d96d 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -50,6 +50,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_VALID_IS_INRANGE	(1 << 4)
 #define MT_QUIRK_VALID_IS_CONFIDENCE	(1 << 5)
 #define MT_QUIRK_EGALAX_XYZ_FIXUP	(1 << 6)
+#define MT_QUIRK_SERIAL_REPORT_MODE	(1 << 7)
 
 struct mt_slot {
 	__s32 x, y, p, w, h;
@@ -89,6 +90,7 @@ struct mt_class {
 #define MT_CLS_EGALAX				5
 #define MT_CLS_STANTUM				6
 #define MT_CLS_3M				7
+#define MT_CLS_CONFIDENCE_SERIAL_MODE		8
 
 #define MT_DEFAULT_MAXCONTACT	10
 
@@ -156,6 +158,9 @@ struct mt_class mt_classes[] = {
 		.sn_move = 2048,
 		.sn_width = 128,
 		.sn_height = 128 },
+	{ .name = MT_CLS_CONFIDENCE_SERIAL_MODE,
+		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE |
+			MT_QUIRK_SERIAL_REPORT_MODE },
 
 	{ }
 };
@@ -196,6 +201,10 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	struct mt_class *cls = td->mtclass;
 	__s32 quirks = cls->quirks;
 
+	if ((quirks & MT_QUIRK_SERIAL_REPORT_MODE) &&
+		(!td->last_field_index))
+		td->last_field_index = field->report->maxfield - 1;
+
 	switch (usage->hid & HID_USAGE_PAGE) {
 
 	case HID_UP_GENDESK:
@@ -585,6 +594,11 @@ static const struct hid_device_id mt_devices[] = {
 		HID_USB_DEVICE(USB_VENDOR_ID_IRTOUCHSYSTEMS,
 			USB_DEVICE_ID_IRTOUCH_INFRARED_USB) },
 
+	/* PenMount panels */
+	{  .driver_data = MT_CLS_CONFIDENCE_SERIAL_MODE,
+		HID_USB_DEVICE(USB_VENDOR_ID_PENMOUNT,
+			USB_DEVICE_ID_PENMOUNT_PCI) },
+
 	/* PixCir-based panels */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
 		HID_USB_DEVICE(USB_VENDOR_ID_HANVON,
-- 
1.7.4.1

