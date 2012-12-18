Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab2LRBG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:06:27 -0500
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:54247 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752416Ab2LRBG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:06:26 -0500
X-Greylist: delayed 1150 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2012 20:06:25 EST
Message-ID: <1355791689.12070.4.camel@localhost>
Subject: Rumble support for Jess/Saitek "color rumble pad"
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Pantelis Koukousoulas <pktoss@gmail.com>,
        Anssi Hannula <anssi.hannula@gmail.com>
Date: Tue, 18 Dec 2012 01:48:09 +0100
Content-Type: multipart/mixed; boundary="=-0h+7Z48n/MYpCs6jhzm9"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
X-Originating-IP: 92.204.22.77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0h+7Z48n/MYpCs6jhzm9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hello developers (and testers)

The attached pad adds supports for another gamepad to the hid-pl driver.
The "color rumble pad P580" marketed using the "Saitek" brand in
Germany, and using a USB Vendor ID attributed to "Jess" seems to be
electronically identical to the 4-field variant of the "Green Asia"
gamepad.

The pad has been tested to support rumble strengths up to 255, not just
127. Currently the patch discriminates the pads by an if on the vendor
ID, a bit in the driver_data field with definitely do better, but I
recommend the owners of the 4-field green asia pad to verify whether the
maximum rumble strength is indeed only 127, otherwise the condition
should be removed entirely and 255 used in all cases.

Regards,
  Michael Karcher

--=-0h+7Z48n/MYpCs6jhzm9
Content-Disposition: attachment; filename="0001-Support-Jess-Saitek-Color-Rumble-Pad.patch"
Content-Type: text/x-patch; name="0001-Support-Jess-Saitek-Color-Rumble-Pad.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 8bit

>From 935b0e9f08bf7b4d271eab3356eacc1b7c47eb73 Mon Sep 17 00:00:00 2001
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Date: Mon, 17 Dec 2012 08:41:37 +0100
Subject: [PATCH] Support Jess/Saitek Color Rumble Pad

---
 drivers/hid/hid-ids.h |    3 +++
 drivers/hid/hid-pl.c  |   13 +++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 3203923..9267188 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -419,6 +419,9 @@
 #define USB_VENDOR_ID_JESS		0x0c45
 #define USB_DEVICE_ID_JESS_YUREX	0x1010
 
+#define USB_VENDOR_ID_JESS2		0x0f30
+#define USB_DEVICE_ID_JESS_COLOR_RUMBLE_PAD 0x0111
+
 #define USB_VENDOR_ID_KBGEAR		0x084e
 #define USB_DEVICE_ID_KBGEAR_JAMSTUDIO	0x1001
 
diff --git a/drivers/hid/hid-pl.c b/drivers/hid/hid-pl.c
index 47ed74c..825d102 100644
--- a/drivers/hid/hid-pl.c
+++ b/drivers/hid/hid-pl.c
@@ -14,6 +14,8 @@
  *  0e8f:0003 "GASIA USB Gamepad"
  *   - another version of the König gamepad
  *
+ *  0f30:0111 "Saitek Color Rumble Pad"
+ *
  *  Copyright (c) 2007, 2009 Anssi Hannula <anssi.hannula@gmail.com>
  */
 
@@ -51,6 +53,7 @@
 
 struct plff_device {
 	struct hid_report *report;
+	s32 maxval;
 	s32 *strong;
 	s32 *weak;
 };
@@ -66,8 +69,8 @@ static int hid_plff_play(struct input_dev *dev, void *data,
 	right = effect->u.rumble.weak_magnitude;
 	debug("called with 0x%04x 0x%04x", left, right);
 
-	left = left * 0x7f / 0xffff;
-	right = right * 0x7f / 0xffff;
+	left = left * plff->maxval / 0xffff;
+	right = right * plff->maxval / 0xffff;
 
 	*plff->strong = left;
 	*plff->weak = right;
@@ -87,6 +90,7 @@ static int plff_init(struct hid_device *hid)
 	struct list_head *report_ptr = report_list;
 	struct input_dev *dev;
 	int error;
+	s32 maxval;
 	s32 *strong;
 	s32 *weak;
 
@@ -123,6 +127,7 @@ static int plff_init(struct hid_device *hid)
 			return -ENODEV;
 		}
 
+		maxval = 0x7f;
 		if (report->field[0]->report_count >= 4) {
 			report->field[0]->value[0] = 0x00;
 			report->field[0]->value[1] = 0x00;
@@ -135,6 +140,8 @@ static int plff_init(struct hid_device *hid)
 			report->field[1]->value[0] = 0x00;
 			strong = &report->field[2]->value[0];
 			weak = &report->field[3]->value[0];
+			if (hid->vendor == USB_VENDOR_ID_JESS2)
+				maxval = 0xff;
 			debug("detected 4-field device");
 		} else {
 			hid_err(hid, "not enough fields or values\n");
@@ -158,6 +165,7 @@ static int plff_init(struct hid_device *hid)
 		plff->report = report;
 		plff->strong = strong;
 		plff->weak = weak;
+		plff->maxval = maxval;
 
 		*strong = 0x00;
 		*weak = 0x00;
@@ -207,6 +215,7 @@ static const struct hid_device_id pl_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GAMERON, USB_DEVICE_ID_GAMERON_DUAL_PCS_ADAPTOR),
 		.driver_data = 1 }, /* Twin USB Joystick */
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, 0x0003), },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS2, USB_DEVICE_ID_JESS_COLOR_RUMBLE_PAD), },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, pl_devices);
-- 
1.7.10.4


--=-0h+7Z48n/MYpCs6jhzm9--

