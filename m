Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759882Ab1KWKCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:02:19 -0500
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:41683 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758761Ab1KWKB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:01:29 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] hid-multitouch: cleanup eGalax quirks
Date: Wed, 23 Nov 2011 10:54:29 +0100
Message-Id: <1322042074-3759-4-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1322042074-3759-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous implementation of eGalax protocol was not satisfying as
we had to manually set x/y ranges as they were corrupted after reading
the report descriptor.
Indeed, the report descriptor provided a stylus input interface which
override the correct values.

This patch omits this input, thus leaving the correct value untouched,
and the MT_QUIRK_EGALAX_XYZ_FIXUP not required anymore.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index f41bcea..8250f3c 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -50,7 +50,6 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_ALWAYS_VALID		(1 << 4)
 #define MT_QUIRK_VALID_IS_INRANGE	(1 << 5)
 #define MT_QUIRK_VALID_IS_CONFIDENCE	(1 << 6)
-#define MT_QUIRK_EGALAX_XYZ_FIXUP	(1 << 7)
 #define MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE	(1 << 8)
 
 struct mt_slot {
@@ -171,8 +170,7 @@ static struct mt_class mt_classes[] = {
 		.maxcontacts = 10 },
 	{ .name = MT_CLS_EGALAX,
 		.quirks =  MT_QUIRK_SLOT_IS_CONTACTID |
-			MT_QUIRK_VALID_IS_INRANGE |
-			MT_QUIRK_EGALAX_XYZ_FIXUP,
+			MT_QUIRK_VALID_IS_INRANGE,
 		.maxcontacts = 2,
 		.sn_move = 4096,
 		.sn_pressure = 32,
@@ -253,7 +251,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
 	struct mt_class *cls = &td->mtclass;
-	__s32 quirks = cls->quirks;
 
 	/* Only map fields from TouchScreen or TouchPad collections.
          * We need to ignore fields that belong to other collections
@@ -265,13 +262,17 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	else
 		return 0;
 
+	/* eGalax devices provide a Digitizer.Stylus input which overrides
+	 * the correct Digitizers.Finger X/Y ranges.
+	 * Let's just ignore this input. */
+	if (field->physical == HID_DG_STYLUS)
+		return -1;
+
 	switch (usage->hid & HID_USAGE_PAGE) {
 
 	case HID_UP_GENDESK:
 		switch (usage->hid) {
 		case HID_GD_X:
-			if (quirks & MT_QUIRK_EGALAX_XYZ_FIXUP)
-				field->logical_maximum = 32760;
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_POSITION_X);
 			set_abs(hi->input, ABS_MT_POSITION_X, field,
@@ -284,8 +285,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			}
 			return 1;
 		case HID_GD_Y:
-			if (quirks & MT_QUIRK_EGALAX_XYZ_FIXUP)
-				field->logical_maximum = 32760;
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_POSITION_Y);
 			set_abs(hi->input, ABS_MT_POSITION_Y, field,
@@ -353,8 +352,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			}
 			return 1;
 		case HID_DG_TIPPRESSURE:
-			if (quirks & MT_QUIRK_EGALAX_XYZ_FIXUP)
-				field->logical_minimum = 0;
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_PRESSURE);
 			set_abs(hi->input, ABS_MT_PRESSURE, field,
-- 
1.7.4.4

