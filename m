Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab1A1QE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 11:04:56 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:42942 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1A1QEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 11:04:55 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] hid-multitouch: work on default classes and renaming of classes
Date: Fri, 28 Jan 2011 17:04:39 +0100
Message-Id: <1296230680-2871-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The safest quirk for a device (the one that works out of the box for
most of them) is the MT_QUIRK_NOT_SEEN_MEANS_UP. Indeed, it does not
make any assumption on the device. When adding a new device, we can
easily test it against MT_CLS_DEFAULT, and then optimize it with other
quirks: that's why no device use MT_CLS_DEFAULT right now.

This patch introduce also MT_CLS_DUAL_DEFAULT which has the same purpose
than MT_CLS_DEFAULT, but for dual touch panels.

Finally, the patch renames MT_CLS_DUAL1 to MT_CLS_DUAL_INRANGE_CONTACTID
and MT_CLS_DUAL2 to MT_CLS_DUAL_INRANGE_CONTACTNUMBER for better
readability.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 07d3183..ffe2a76 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -24,6 +24,7 @@
 
 
 MODULE_AUTHOR("Stephane Chatty <chatty@enac.fr>");
+MODULE_AUTHOR("Benjamin Tissoires <benjamin.tissoires@gmail.com>");
 MODULE_DESCRIPTION("HID multitouch panels");
 MODULE_LICENSE("GPL");
 
@@ -65,10 +66,11 @@ struct mt_class {
 };
 
 /* classes of device behavior */
-#define MT_CLS_DEFAULT	1
-#define MT_CLS_DUAL1	2
-#define MT_CLS_DUAL2	3
-#define MT_CLS_CYPRESS	4
+#define MT_CLS_DEFAULT				1
+#define MT_CLS_DUAL_DEFAULT			2
+#define MT_CLS_DUAL_INRANGE_CONTACTID		3
+#define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	4
+#define MT_CLS_CYPRESS				10
 
 /*
  * these device-dependent functions determine what slot corresponds
@@ -104,13 +106,16 @@ static int find_slot_from_contactid(struct mt_device *td)
 
 struct mt_class mt_classes[] = {
 	{ .name = MT_CLS_DEFAULT,
-		.quirks = MT_QUIRK_VALID_IS_INRANGE,
+		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP,
 		.maxcontacts = 10 },
-	{ .name = MT_CLS_DUAL1,
+	{ .name = MT_CLS_DUAL_DEFAULT,
+		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP,
+		.maxcontacts = 2 },
+	{ .name = MT_CLS_DUAL_INRANGE_CONTACTID,
 		.quirks = MT_QUIRK_VALID_IS_INRANGE |
 			MT_QUIRK_SLOT_IS_CONTACTID,
 		.maxcontacts = 2 },
-	{ .name = MT_CLS_DUAL2,
+	{ .name = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
 		.quirks = MT_QUIRK_VALID_IS_INRANGE |
 			MT_QUIRK_SLOT_IS_CONTACTNUMBER,
 		.maxcontacts = 2 },
@@ -466,15 +471,15 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_CYPRESS_TRUETOUCH) },
 
 	/* GeneralTouch panel */
-	{ .driver_data = MT_CLS_DUAL2,
+	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
 		HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
 			USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS) },
 
 	/* PixCir-based panels */
-	{ .driver_data = MT_CLS_DUAL1,
+	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
 		HID_USB_DEVICE(USB_VENDOR_ID_HANVON,
 			USB_DEVICE_ID_HANVON_MULTITOUCH) },
-	{ .driver_data = MT_CLS_DUAL1,
+	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
 		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_PIXCIR_MULTI_TOUCH) },
 
-- 
1.7.3.4

