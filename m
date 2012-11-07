Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab2KGQi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 11:38:58 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33927 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab2KGQiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 11:38:10 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 11/13] HID: hid-multitouch: support for hovering devices
Date: Wed,  7 Nov 2012 17:37:34 +0100
Message-Id: <1352306256-12180-12-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Win8 devices supporting hovering must provides InRange HID field.
The information that the finger is here but is not touching the surface
is sent to the user space through ABS_MT_DISTANCE as required by the
multitouch protocol.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index b393c6c..1f3d1e0 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -59,6 +59,7 @@ struct mt_slot {
 	__s32 x, y, cx, cy, p, w, h;
 	__s32 contactid;	/* the device ContactID assigned to this slot */
 	bool touch_state;	/* is the touch valid? */
+	bool inrange_state;	/* is the finger in proximity of the sensor? */
 };
 
 struct mt_class {
@@ -397,6 +398,12 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	case HID_UP_DIGITIZER:
 		switch (usage->hid) {
 		case HID_DG_INRANGE:
+			if (cls->quirks & MT_QUIRK_WIN_8_CERTIFIED) {
+				hid_map_usage(hi, usage, bit, max,
+					EV_ABS, ABS_MT_DISTANCE);
+				input_set_abs_params(hi->input,
+					ABS_MT_DISTANCE, -1, 1, 0, 0);
+			}
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
@@ -516,6 +523,10 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
 		if (slotnum < 0 || slotnum >= td->maxcontacts)
 			return;
 
+		if (!test_bit(ABS_MT_DISTANCE, input->absbit))
+			/* If InRange is not present, rely on TipSwitch */
+			s->inrange_state = s->touch_state;
+
 		if (td->mtclass.quirks & MT_QUIRK_IGNORE_DUPLICATES &&
 		    input_mt_is_active(&input->mt->slots[slotnum]) &&
 		    input_mt_is_used(input->mt, &input->mt->slots[slotnum]))
@@ -523,9 +534,9 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
 
 		input_mt_slot(input, slotnum);
 		input_mt_report_slot_state(input, MT_TOOL_FINGER,
-			s->touch_state);
-		if (s->touch_state) {
-			/* this finger is on the screen */
+			s->inrange_state);
+		if (s->inrange_state) {
+			/* this finger is in proximity of the sensor */
 			int wide = (s->w > s->h);
 			/* divided by two to match visual scale of touch */
 			int major = max(s->w, s->h) >> 1;
@@ -535,11 +546,14 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
 			input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
 			input_event(input, EV_ABS, ABS_MT_TOOL_X, s->cx);
 			input_event(input, EV_ABS, ABS_MT_TOOL_Y, s->cy);
+			input_event(input, EV_ABS, ABS_MT_DISTANCE,
+				!s->touch_state);
 			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
 			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
 			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
 			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
-		}
+		} else
+			input_event(input, EV_ABS, ABS_MT_DISTANCE, -1);
 	}
 
 	td->num_received++;
@@ -567,6 +581,8 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 		case HID_DG_INRANGE:
 			if (quirks & MT_QUIRK_VALID_IS_INRANGE)
 				td->curvalid = value;
+			if (quirks & MT_QUIRK_WIN_8_CERTIFIED)
+				td->curdata.inrange_state = value;
 			break;
 		case HID_DG_TIPSWITCH:
 			if (quirks & MT_QUIRK_NOT_SEEN_MEANS_UP)
-- 
1.7.11.7

