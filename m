Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab2KGQiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:38:08 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:56660 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab2KGQiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:38:04 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 07/13] HID: hid-multitouch: support T and C for win8 devices
Date: Wed,  7 Nov 2012 17:37:30 +0100
Message-Id: <1352306256-12180-8-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Win8 input specification clarifies the X and Y sent by devices.
It distincts the position where the user wants to Touch (T) from
the center of the ellipsoide (C). This patch enable supports for this
distinction in hid-multitouch.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 46 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index ae57b8f..54367f4 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -54,7 +54,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_NO_AREA		(1 << 9)
 
 struct mt_slot {
-	__s32 x, y, p, w, h;
+	__s32 x, y, cx, cy, p, w, h;
 	__s32 contactid;	/* the device ContactID assigned to this slot */
 	bool touch_state;	/* is the touch valid? */
 };
@@ -323,6 +323,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	struct mt_device *td = hid_get_drvdata(hdev);
 	struct mt_class *cls = &td->mtclass;
 	int code;
+	struct hid_usage *prev_usage = NULL;
 
 	/* Only map fields from TouchScreen or TouchPad collections.
 	* We need to ignore fields that belong to other collections
@@ -345,23 +346,42 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	if (field->physical == HID_DG_STYLUS)
 		return -1;
 
+	if (usage->usage_index)
+		prev_usage = &field->usage[usage->usage_index - 1];
+
 	switch (usage->hid & HID_USAGE_PAGE) {
 
 	case HID_UP_GENDESK:
 		switch (usage->hid) {
 		case HID_GD_X:
-			hid_map_usage(hi, usage, bit, max,
+			if (prev_usage && (prev_usage->hid == usage->hid)) {
+				hid_map_usage(hi, usage, bit, max,
+					EV_ABS, ABS_MT_TOOL_X);
+				set_abs(hi->input, ABS_MT_TOOL_X, field,
+					cls->sn_move);
+			} else {
+				hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_POSITION_X);
-			set_abs(hi->input, ABS_MT_POSITION_X, field,
-				cls->sn_move);
+				set_abs(hi->input, ABS_MT_POSITION_X, field,
+					cls->sn_move);
+			}
+
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_GD_Y:
-			hid_map_usage(hi, usage, bit, max,
+			if (prev_usage && (prev_usage->hid == usage->hid)) {
+				hid_map_usage(hi, usage, bit, max,
+					EV_ABS, ABS_MT_TOOL_Y);
+				set_abs(hi->input, ABS_MT_TOOL_Y, field,
+					cls->sn_move);
+			} else {
+				hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_POSITION_Y);
-			set_abs(hi->input, ABS_MT_POSITION_Y, field,
-				cls->sn_move);
+				set_abs(hi->input, ABS_MT_POSITION_Y, field,
+					cls->sn_move);
+			}
+
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
@@ -502,6 +522,8 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
 
 			input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
 			input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
+			input_event(input, EV_ABS, ABS_MT_TOOL_X, s->cx);
+			input_event(input, EV_ABS, ABS_MT_TOOL_Y, s->cy);
 			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
 			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
 			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
@@ -553,10 +575,16 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 			td->curdata.p = value;
 			break;
 		case HID_GD_X:
-			td->curdata.x = value;
+			if (usage->code == ABS_MT_TOOL_X)
+				td->curdata.cx = value;
+			else
+				td->curdata.x = value;
 			break;
 		case HID_GD_Y:
-			td->curdata.y = value;
+			if (usage->code == ABS_MT_TOOL_Y)
+				td->curdata.cy = value;
+			else
+				td->curdata.y = value;
 			break;
 		case HID_DG_WIDTH:
 			td->curdata.w = value;
-- 
1.7.11.7

