Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352Ab2JYOLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:11:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:32841 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935732Ab2JYOLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:11:13 -0400
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] HID: hid-multitouch: support for hovering devices
Date: Thu, 25 Oct 2012 16:09:47 +0200
Message-Id: <1351174189-24719-9-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351174189-24719-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1351174189-24719-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Win8 devices supporting hovering must provides InRange HID field.
The information that the finger is here but is not touching the surface
is sent to the user space through ABS_MT_DISTANCE as required by the
multitouch protocol.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 6d4ad30..5aebbff 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -55,7 +55,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_WIN_8_CERTIFIED	(1 << 10)
 
 struct mt_slot {
-	__s32 x, y, cx, cy, p, w, h;
+	__s32 x, y, cx, cy, z, p, w, h;
 	__s32 contactid;	/* the device ContactID assigned to this slot */
 	bool touch_state;	/* is the touch valid? */
 };
@@ -394,6 +394,12 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	case HID_UP_DIGITIZER:
 		switch (usage->hid) {
 		case HID_DG_INRANGE:
+			if (cls->quirks & MT_QUIRK_WIN_8_CERTIFIED) {
+				hid_map_usage(hi, usage, bit, max,
+					EV_ABS, ABS_MT_DISTANCE);
+				input_set_abs_params(hi->input,
+					ABS_MT_DISTANCE, 0, 1, 0, 0);
+			}
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
@@ -511,6 +517,11 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
 		struct mt_slot *s = &td->curdata;
 
 		if (td->mtclass.quirks & MT_QUIRK_WIN_8_CERTIFIED &&
+		    !test_bit(ABS_MT_DISTANCE, input->absbit))
+			/* If InRange is not present, rely on TipSwitch */
+			s->touch_state = !s->z;
+
+		if (td->mtclass.quirks & MT_QUIRK_WIN_8_CERTIFIED &&
 		    !s->touch_state) {
 			struct input_mt_slot *slot = &input->mt->slots[slotnum];
 			int prv_x = input_mt_get_value(slot, ABS_MT_POSITION_X);
@@ -543,6 +554,7 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
 				input_event(input, EV_ABS, ABS_MT_TOOL_Y,
 					s->cy);
 			}
+			input_event(input, EV_ABS, ABS_MT_DISTANCE, s->z);
 			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
 			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
 			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
@@ -575,11 +587,16 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 		case HID_DG_INRANGE:
 			if (quirks & MT_QUIRK_VALID_IS_INRANGE)
 				td->curvalid = value;
+			if (quirks & MT_QUIRK_WIN_8_CERTIFIED)
+				td->curdata.touch_state = value;
 			break;
 		case HID_DG_TIPSWITCH:
 			if (quirks & MT_QUIRK_NOT_SEEN_MEANS_UP)
 				td->curvalid = value;
-			td->curdata.touch_state = value;
+			if (quirks & MT_QUIRK_WIN_8_CERTIFIED)
+				td->curdata.z = !value;
+			else
+				td->curdata.touch_state = value;
 			break;
 		case HID_DG_CONFIDENCE:
 			if (quirks & MT_QUIRK_VALID_IS_CONFIDENCE)
-- 
1.7.11.7

