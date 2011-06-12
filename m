Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab1FLGWW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 02:22:22 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:46559 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab1FLGWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 02:22:20 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hid-multitouch: fix broken eGalax
Date: Sun, 12 Jun 2011 08:22:08 +0200
Message-Id: <1307859728-3446-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the inclusion of eGalax devices in 2.6.39, I've got some
bug reports for 480d and other devices.
The problem lies in the reports descriptors: eGalax supports both
pen and fingers, and so the reports descriptors contained both.
But hid-multitouch relies on them to detect the last item in each
field to send the multitouch events. In 480d, the last item is not
Y as it should but Pressure. That means that the fields are not
aligned and X,Y are at 0,0 (the other touch coordinates of the report).

With this patch, the detection is made only when the field ContactID
has been detected inside the collection.

There is still a problem with the detections of the range as stylus
and fingers may not have the same min/max, but it's a start.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---

Hi guys,

I'd love to see this patch into stable too. The point is that it does
not applies out of the box. Should I send it again to stable@kernel.org
once the reviews has been made?

Cheers,
Benjamin

 drivers/hid/hid-multitouch.c |   57 ++++++++++++++++++++++++++++-------------
 1 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index ecd4d2d..b2767ea 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -64,6 +64,7 @@ struct mt_device {
 	struct mt_class *mtclass;	/* our mt device class */
 	unsigned last_field_index;	/* last field index of the report */
 	unsigned last_slot_field;	/* the last field of a slot */
+	int last_mt_collection;	/* last known mt-related collection */
 	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
 	__u8 num_received;	/* how many contacts we received */
 	__u8 num_expected;	/* expected last contact index */
@@ -225,8 +226,10 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 				cls->sn_move);
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_X, field, cls->sn_move);
-			td->last_slot_field = usage->hid;
-			td->last_field_index = field->index;
+			if (td->last_mt_collection == usage->collection_index) {
+				td->last_slot_field = usage->hid;
+				td->last_field_index = field->index;
+			}
 			return 1;
 		case HID_GD_Y:
 			if (quirks & MT_QUIRK_EGALAX_XYZ_FIXUP)
@@ -237,8 +240,10 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 				cls->sn_move);
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_Y, field, cls->sn_move);
-			td->last_slot_field = usage->hid;
-			td->last_field_index = field->index;
+			if (td->last_mt_collection == usage->collection_index) {
+				td->last_slot_field = usage->hid;
+				td->last_field_index = field->index;
+			}
 			return 1;
 		}
 		return 0;
@@ -246,31 +251,40 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	case HID_UP_DIGITIZER:
 		switch (usage->hid) {
 		case HID_DG_INRANGE:
-			td->last_slot_field = usage->hid;
-			td->last_field_index = field->index;
+			if (td->last_mt_collection == usage->collection_index) {
+				td->last_slot_field = usage->hid;
+				td->last_field_index = field->index;
+			}
 			return 1;
 		case HID_DG_CONFIDENCE:
-			td->last_slot_field = usage->hid;
-			td->last_field_index = field->index;
+			if (td->last_mt_collection == usage->collection_index) {
+				td->last_slot_field = usage->hid;
+				td->last_field_index = field->index;
+			}
 			return 1;
 		case HID_DG_TIPSWITCH:
 			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
 			input_set_capability(hi->input, EV_KEY, BTN_TOUCH);
-			td->last_slot_field = usage->hid;
-			td->last_field_index = field->index;
+			if (td->last_mt_collection == usage->collection_index) {
+				td->last_slot_field = usage->hid;
+				td->last_field_index = field->index;
+			}
 			return 1;
 		case HID_DG_CONTACTID:
 			input_mt_init_slots(hi->input, td->maxcontacts);
 			td->last_slot_field = usage->hid;
 			td->last_field_index = field->index;
+			td->last_mt_collection = usage->collection_index;
 			return 1;
 		case HID_DG_WIDTH:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TOUCH_MAJOR);
 			set_abs(hi->input, ABS_MT_TOUCH_MAJOR, field,
 				cls->sn_width);
-			td->last_slot_field = usage->hid;
-			td->last_field_index = field->index;
+			if (td->last_mt_collection == usage->collection_index) {
+				td->last_slot_field = usage->hid;
+				td->last_field_index = field->index;
+			}
 			return 1;
 		case HID_DG_HEIGHT:
 			hid_map_usage(hi, usage, bit, max,
@@ -279,8 +293,10 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 				cls->sn_height);
 			input_set_abs_params(hi->input,
 					ABS_MT_ORIENTATION, 0, 1, 0, 0);
-			td->last_slot_field = usage->hid;
-			td->last_field_index = field->index;
+			if (td->last_mt_collection == usage->collection_index) {
+				td->last_slot_field = usage->hid;
+				td->last_field_index = field->index;
+			}
 			return 1;
 		case HID_DG_TIPPRESSURE:
 			if (quirks & MT_QUIRK_EGALAX_XYZ_FIXUP)
@@ -292,16 +308,20 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_PRESSURE, field,
 				cls->sn_pressure);
-			td->last_slot_field = usage->hid;
-			td->last_field_index = field->index;
+			if (td->last_mt_collection == usage->collection_index) {
+				td->last_slot_field = usage->hid;
+				td->last_field_index = field->index;
+			}
 			return 1;
 		case HID_DG_CONTACTCOUNT:
-			td->last_field_index = field->index;
+			if (td->last_mt_collection == usage->collection_index)
+				td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTMAX:
 			/* we don't set td->last_slot_field as contactcount and
 			 * contact max are global to the report */
-			td->last_field_index = field->index;
+			if (td->last_mt_collection == usage->collection_index)
+				td->last_field_index = field->index;
 			return -1;
 		}
 		/* let hid-input decide for the others */
@@ -516,6 +536,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 	td->mtclass = mtclass;
 	td->inputmode = -1;
+	td->last_mt_collection = -1;
 	hid_set_drvdata(hdev, td);
 
 	ret = hid_parse(hdev);
-- 
1.7.4.4

