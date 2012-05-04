Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab2EDMyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 08:54:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64736 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038Ab2EDMyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 08:54:12 -0400
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] HID: hid-multitouch: support T and C for win8 devices
Date: Fri,  4 May 2012 14:53:50 +0200
Message-Id: <1336136030-18503-6-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

Win8 input specification clarifies the X and Y sent by devices.
It distincts the position where the user wants to Touch (T) from
the center of the ellipsoide (C). This patch enable supports for this
distinction in hid-multitouch.

We recognize Win8 certified devices from their vendor field 0xff0000c5
where Microsoft put a signed blob in the report to check if the device
passed the certification.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |   77 +++++++++++++++++++++++++++++++++++++++---
 1 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 3ee22ec..48c8576 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -51,9 +51,10 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_VALID_IS_INRANGE	(1 << 5)
 #define MT_QUIRK_VALID_IS_CONFIDENCE	(1 << 6)
 #define MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE	(1 << 8)
+#define MT_QUIRK_WIN_8_CERTIFIED	(1 << 9)
 
 struct mt_slot {
-	__s32 x, y, p, w, h;
+	__s32 x, y, cx, cy, p, w, h;
 	__s32 contactid;	/* the device ContactID assigned to this slot */
 	bool touch_state;	/* is the touch valid? */
 	bool seen_in_this_frame;/* has this slot been updated */
@@ -71,7 +72,7 @@ struct mt_class {
 };
 
 struct mt_fields {
-	unsigned usages[HID_MAX_FIELDS];
+	struct hid_usage *usages[HID_MAX_FIELDS];
 	unsigned int length;
 };
 
@@ -272,9 +273,14 @@ static void mt_feature_mapping(struct hid_device *hdev,
 			td->maxcontacts = td->mtclass.maxcontacts;
 
 		break;
+	case 0xff0000c5:
+		if (field->report_count == 256 && field->report_size == 8)
+			td->mtclass.quirks |= MT_QUIRK_WIN_8_CERTIFIED;
+		break;
 	}
 }
 
+
 static void set_abs(struct input_dev *input, unsigned int code,
 		struct hid_field *field, int snratio)
 {
@@ -292,7 +298,7 @@ static void mt_store_field(struct hid_usage *usage, struct mt_device *td,
 	if (f->length >= HID_MAX_FIELDS)
 		return;
 
-	f->usages[f->length++] = usage->hid;
+	f->usages[f->length++] = usage;
 }
 
 static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
@@ -343,6 +349,9 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 				cls->sn_move);
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_X, field, cls->sn_move);
+			if (cls->quirks & MT_QUIRK_WIN_8_CERTIFIED)
+				set_abs(hi->input, ABS_MT_CENTER_X, field,
+					cls->sn_move);
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
@@ -353,6 +362,9 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 				cls->sn_move);
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_Y, field, cls->sn_move);
+			if (cls->quirks & MT_QUIRK_WIN_8_CERTIFIED)
+				set_abs(hi->input, ABS_MT_CENTER_Y, field,
+					cls->sn_move);
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
@@ -515,6 +527,12 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
 
 			input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
 			input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
+			if (td->mtclass.quirks & MT_QUIRK_WIN_8_CERTIFIED) {
+				input_event(input, EV_ABS, ABS_MT_CENTER_X,
+					s->cx);
+				input_event(input, EV_ABS, ABS_MT_CENTER_Y,
+					s->cy);
+			}
 			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
 			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
 			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
@@ -561,10 +579,14 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 			td->curdata.p = value;
 			break;
 		case HID_GD_X:
-			td->curdata.x = value;
+			if (usage->code == ABS_MT_POSITION_X)
+				td->curdata.x = value;
+			td->curdata.cx = value;
 			break;
 		case HID_GD_Y:
-			td->curdata.y = value;
+			if (usage->code == ABS_MT_POSITION_Y)
+				td->curdata.y = value;
+			td->curdata.cy = value;
 			break;
 		case HID_DG_WIDTH:
 			td->curdata.w = value;
@@ -666,6 +688,47 @@ static void mt_post_parse_default_settings(struct mt_device *td)
 	td->mtclass.quirks = quirks;
 }
 
+static void mt_post_parse_win8(struct mt_device *td)
+{
+	struct mt_fields *f = td->fields;
+	int field_count_per_touch = f->length / td->touches_by_report;
+	int i;
+
+	int position_x_index = -1;
+	int position_y_index = -1;
+	int center_x_index = -1;
+	int center_y_index = -1;
+
+	for (i = 0; i < field_count_per_touch; i++) {
+		switch (f->usages[i]->hid) {
+		case HID_GD_X:
+			if (position_x_index < 0)
+				position_x_index = i;
+			else
+				center_x_index = i;
+			break;
+		case HID_GD_Y:
+			if (position_y_index < 0)
+				position_y_index = i;
+			else
+				center_y_index = i;
+			break;
+		}
+	}
+
+	if (center_x_index < 0 || center_y_index < 0)
+		/* center X and center y are not provided */
+		return;
+
+	for (i = 0; i < td->touches_by_report; i++) {
+		int cur_touch_index = i * field_count_per_touch;
+		struct hid_usage **usages = &f->usages[cur_touch_index];
+
+		usages[center_x_index]->code = ABS_MT_CENTER_X;
+		usages[center_y_index]->code = ABS_MT_CENTER_Y;
+	}
+}
+
 static void mt_post_parse(struct mt_device *td)
 {
 	struct mt_fields *f = td->fields;
@@ -673,6 +736,10 @@ static void mt_post_parse(struct mt_device *td)
 	if (td->touches_by_report > 0) {
 		int field_count_per_touch = f->length / td->touches_by_report;
 		td->last_slot_field = f->usages[field_count_per_touch - 1]->hid;
+
+		if (td->mtclass.quirks & MT_QUIRK_WIN_8_CERTIFIED)
+			mt_post_parse_win8(td);
+
 	}
 }
 
-- 
1.7.7.6

