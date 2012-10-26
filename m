Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab2JZIpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:45:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64066 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab2JZIop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:44:45 -0400
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/11] HID: hid-multitouch: support T and C for win8 devices
Date: Fri, 26 Oct 2012 10:44:22 +0200
Message-Id: <1351241067-9521-7-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Win8 input specification clarifies the X and Y sent by devices.
It distincts the position where the user wants to Touch (T) from
the center of the ellipsoide (C). This patch enable supports for this
distinction in hid-multitouch.

We recognize Win8 certified devices from their vendor feature 0xff0000c5
where Microsoft put a signed blob in the report to check if the device
passed the certification.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 53 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 41f2981..000c979 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -52,9 +52,10 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_VALID_IS_CONFIDENCE	(1 << 6)
 #define MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE	(1 << 8)
 #define MT_QUIRK_NO_AREA		(1 << 9)
+#define MT_QUIRK_WIN_8_CERTIFIED	(1 << 10)
 
 struct mt_slot {
-	__s32 x, y, p, w, h;
+	__s32 x, y, cx, cy, p, w, h;
 	__s32 contactid;	/* the device ContactID assigned to this slot */
 	bool touch_state;	/* is the touch valid? */
 };
@@ -292,6 +293,10 @@ static void mt_feature_mapping(struct hid_device *hdev,
 			td->maxcontacts = td->mtclass.maxcontacts;
 
 		break;
+	case 0xff0000c5:
+		if (field->report_count == 256 && field->report_size == 8)
+			td->mtclass.quirks |= MT_QUIRK_WIN_8_CERTIFIED;
+		break;
 	}
 }
 
@@ -350,18 +355,36 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	case HID_UP_GENDESK:
 		switch (usage->hid) {
 		case HID_GD_X:
-			hid_map_usage(hi, usage, bit, max,
+			if (cls->quirks & MT_QUIRK_WIN_8_CERTIFIED &&
+				usage_index) {
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
+			if (cls->quirks & MT_QUIRK_WIN_8_CERTIFIED &&
+				usage_index) {
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
@@ -502,6 +525,12 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
 
 			input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
 			input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
+			if (td->mtclass.quirks & MT_QUIRK_WIN_8_CERTIFIED) {
+				input_event(input, EV_ABS, ABS_MT_TOOL_X,
+					s->cx);
+				input_event(input, EV_ABS, ABS_MT_TOOL_Y,
+					s->cy);
+			}
 			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
 			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
 			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
@@ -553,10 +582,16 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 			td->curdata.p = value;
 			break;
 		case HID_GD_X:
-			td->curdata.x = value;
+			if (usage->code == ABS_MT_POSITION_X)
+				td->curdata.x = value;
+			else
+				td->curdata.cx = value;
 			break;
 		case HID_GD_Y:
-			td->curdata.y = value;
+			if (usage->code == ABS_MT_POSITION_Y)
+				td->curdata.y = value;
+			else
+				td->curdata.cy = value;
 			break;
 		case HID_DG_WIDTH:
 			td->curdata.w = value;
-- 
1.7.11.7

