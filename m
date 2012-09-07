Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab2IGSDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:03:00 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:58577 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2IGSC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:02:57 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqiHAJs1SlBV5qoUPGdsb2JhbABFikGvdAGBBxkBAQEBHhkNJ4IhAQUnExwTAQ8QCBE4FCUKGhOIFLtXFI4Egk5gA5VchW+NFA
X-IronPort-AV: E=Sophos;i="4.80,388,1344204000"; 
   d="scan'208";a="184727812"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 7 Sep 2012 20:09:33 +0200
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: [PATCH v2] HID: hid-multitouch: Add Flatfrog support
Message-ID: <20120907180933.GA469@polaris.bitmath.org>
References: <1346858857-281-1-git-send-email-rydberg@euromail.se>
 <1346858857-281-2-git-send-email-rydberg@euromail.se>
 <20120905161218.GA270@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905161218.GA270@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Flatfrog Multitouch 3200 panel. This panel
advertises some fields that it does not use, hence the new quirk.

Cc: Pablo Cases <pablo.cases@flatfrog.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
The Flatfrog team pointed out that the pressure information, which is
currently present but set to a fixed value, is a scheduled firmware
update. Therefore, ignoring the pressure information seems
unnecessary, and I agree. This version is without the pressure quirk,
and will be pushed to the maybe branch in a couple of days.

Thanks,
Henrik

 drivers/hid/hid-ids.h        |  3 +++
 drivers/hid/hid-multitouch.c | 26 +++++++++++++++++++++-----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 1dcb76f..c843db9 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -283,6 +283,9 @@
 #define USB_VENDOR_ID_EMS		0x2006
 #define USB_DEVICE_ID_EMS_TRIO_LINKER_PLUS_II 0x0118
 
+#define USB_VENDOR_ID_FLATFROG		0x25b5
+#define USB_DEVICE_ID_MULTITOUCH_3200	0x0002
+
 #define USB_VENDOR_ID_ESSENTIAL_REALITY	0x0d7f
 #define USB_DEVICE_ID_ESSENTIAL_REALITY_P5 0x0100
 
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 63f120b..ee0b76b 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -51,6 +51,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_VALID_IS_INRANGE	(1 << 5)
 #define MT_QUIRK_VALID_IS_CONFIDENCE	(1 << 6)
 #define MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE	(1 << 8)
+#define MT_QUIRK_NO_AREA		(1 << 9)
 
 struct mt_slot {
 	__s32 x, y, p, w, h;
@@ -115,6 +116,7 @@ struct mt_device {
 #define MT_CLS_EGALAX_SERIAL			0x0104
 #define MT_CLS_TOPSEED				0x0105
 #define MT_CLS_PANASONIC			0x0106
+#define MT_CLS_FLATFROG				0x0107
 
 #define MT_DEFAULT_MAXCONTACT	10
 
@@ -199,6 +201,12 @@ static struct mt_class mt_classes[] = {
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP,
 		.maxcontacts = 4 },
 
+	{ .name = MT_CLS_FLATFROG,
+		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
+			MT_QUIRK_NO_AREA,
+		.sn_move = 2048,
+		.maxcontacts = 40,
+	},
 	{ }
 };
 
@@ -366,18 +374,21 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_WIDTH:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TOUCH_MAJOR);
-			set_abs(hi->input, ABS_MT_TOUCH_MAJOR, field,
-				cls->sn_width);
+			if (!(cls->quirks & MT_QUIRK_NO_AREA))
+				set_abs(hi->input, ABS_MT_TOUCH_MAJOR, field,
+					cls->sn_width);
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_HEIGHT:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TOUCH_MINOR);
-			set_abs(hi->input, ABS_MT_TOUCH_MINOR, field,
-				cls->sn_height);
-			input_set_abs_params(hi->input,
+			if (!(cls->quirks & MT_QUIRK_NO_AREA)) {
+				set_abs(hi->input, ABS_MT_TOUCH_MINOR, field,
+					cls->sn_height);
+				input_set_abs_params(hi->input,
 					ABS_MT_ORIENTATION, 0, 1, 0, 0);
+			}
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
@@ -860,6 +871,11 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_ELO,
 			USB_DEVICE_ID_ELO_TS2515) },
 
+	/* Flatfrog Panels */
+	{ .driver_data = MT_CLS_FLATFROG,
+		MT_USB_DEVICE(USB_VENDOR_ID_FLATFROG,
+			USB_DEVICE_ID_MULTITOUCH_3200) },
+
 	/* GeneralTouch panel */
 	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
 		MT_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
-- 
1.7.12

