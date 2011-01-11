Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab1AKPpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:45:13 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:46349 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab1AKPpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:45:10 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Stephane Chatty <chatty@enac.fr>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: [PATCH v2] hid-multitouch: changes from the review process
Date: Tue, 11 Jan 2011 16:45:54 +0100
Message-Id: <1294760754-7885-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* amended Kconfig (PixCir and Hanvon are the same panel but with
  different name)
* insert field name in mt_class and retrieving it in mt_probe
* add 2 quirks: MT_QUIRK_VALID_IS_INRANGE, MT_QUIRK_VALID_IS_CONFIDENCE,
  in order to find the field "valid"
* inlined slot_is_contactid and slot_is_contact_number
* cosmetics changes (tabs and comments)
* do not send unnecessary properties once the touch is up

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/Kconfig          |   10 +++-
 drivers/hid/hid-multitouch.c |  127 +++++++++++++++++++++++-------------------
 2 files changed, 78 insertions(+), 59 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 9bd2148..97c200b 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -292,10 +292,16 @@ config HID_MULTITOUCH
 	  Generic support for HID multitouch panels.
 
 	  Say Y here if you have one of the following devices:
-	  - PixCir touchscreen
-	  - Cypress TrueTouch
+	  - Cypress TrueTouch panels
+	  - Hanvon dual touch panels
+	  - Pixcir dual touch panels
 	  - 'Sensing Win7-TwoFinger' panel by GeneralTouch
 
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called hid-multitouch.
+
 config HID_NTRIG
 	tristate "N-Trig touch screen"
 	depends on USB_HID
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 3442ed5..07d3183 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -32,8 +32,10 @@ MODULE_LICENSE("GPL");
 /* quirks to control the device */
 #define MT_QUIRK_NOT_SEEN_MEANS_UP	(1 << 0)
 #define MT_QUIRK_SLOT_IS_CONTACTID	(1 << 1)
-#define MT_QUIRK_CYPRESS	(1 << 2)
+#define MT_QUIRK_CYPRESS		(1 << 2)
 #define MT_QUIRK_SLOT_IS_CONTACTNUMBER	(1 << 3)
+#define MT_QUIRK_VALID_IS_INRANGE	(1 << 4)
+#define MT_QUIRK_VALID_IS_CONFIDENCE	(1 << 5)
 
 struct mt_slot {
 	__s32 x, y, p, w, h;
@@ -55,6 +57,7 @@ struct mt_device {
 };
 
 struct mt_class {
+	__s32 name;	/* MT_CLS */
 	__s32 quirks;
 	__s32 sn_move;	/* Signal/noise ratio for move events */
 	__s32 sn_pressure;	/* Signal/noise ratio for pressure events */
@@ -62,26 +65,16 @@ struct mt_class {
 };
 
 /* classes of device behavior */
-#define MT_CLS_DEFAULT 0
-#define MT_CLS_DUAL1 1
-#define MT_CLS_DUAL2 2
-#define MT_CLS_CYPRESS 3
+#define MT_CLS_DEFAULT	1
+#define MT_CLS_DUAL1	2
+#define MT_CLS_DUAL2	3
+#define MT_CLS_CYPRESS	4
 
 /*
  * these device-dependent functions determine what slot corresponds
  * to a valid contact that was just read.
  */
 
-static int slot_is_contactid(struct mt_device *td)
-{
-	return td->curdata.contactid;
-}
-
-static int slot_is_contactnumber(struct mt_device *td)
-{
-	return td->num_received;
-}
-
 static int cypress_compute_slot(struct mt_device *td)
 {
 	if (td->curdata.contactid != 0 || td->num_received == 0)
@@ -103,17 +96,30 @@ static int find_slot_from_contactid(struct mt_device *td)
 			!td->slots[i].touch_state)
 			return i;
 	}
-	return -1;
 	/* should not occurs. If this happens that means
 	 * that the device sent more touches that it says
 	 * in the report descriptor. It is ignored then. */
+	return -1;
 }
 
 struct mt_class mt_classes[] = {
-	{ 0, 0, 0, 10 },                             /* MT_CLS_DEFAULT */
-	{ MT_QUIRK_SLOT_IS_CONTACTID, 0, 0, 2 },     /* MT_CLS_DUAL1 */
-	{ MT_QUIRK_SLOT_IS_CONTACTNUMBER, 0, 0, 10 },    /* MT_CLS_DUAL2 */
-	{ MT_QUIRK_CYPRESS | MT_QUIRK_NOT_SEEN_MEANS_UP, 0, 0, 10 }, /* MT_CLS_CYPRESS */
+	{ .name = MT_CLS_DEFAULT,
+		.quirks = MT_QUIRK_VALID_IS_INRANGE,
+		.maxcontacts = 10 },
+	{ .name = MT_CLS_DUAL1,
+		.quirks = MT_QUIRK_VALID_IS_INRANGE |
+			MT_QUIRK_SLOT_IS_CONTACTID,
+		.maxcontacts = 2 },
+	{ .name = MT_CLS_DUAL2,
+		.quirks = MT_QUIRK_VALID_IS_INRANGE |
+			MT_QUIRK_SLOT_IS_CONTACTNUMBER,
+		.maxcontacts = 2 },
+	{ .name = MT_CLS_CYPRESS,
+		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
+			MT_QUIRK_CYPRESS,
+		.maxcontacts = 10 },
+
+	{ }
 };
 
 static void mt_feature_mapping(struct hid_device *hdev, struct hid_input *hi,
@@ -192,7 +198,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TOUCH_MINOR);
 			field->logical_maximum = 1;
-			field->logical_minimum = 1;
+			field->logical_minimum = 0;
 			set_abs(hi->input, ABS_MT_ORIENTATION, field, 0);
 			td->last_slot_field = usage->hid;
 			return 1;
@@ -237,16 +243,16 @@ static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 
 static int mt_compute_slot(struct mt_device *td)
 {
-	struct mt_class *cls = td->mtclass;
+	__s32 quirks = td->mtclass->quirks;
 
-	if (cls->quirks & MT_QUIRK_SLOT_IS_CONTACTID)
-		return slot_is_contactid(td);
+	if (quirks & MT_QUIRK_SLOT_IS_CONTACTID)
+		return td->curdata.contactid;
 
-	if (cls->quirks & MT_QUIRK_CYPRESS)
+	if (quirks & MT_QUIRK_CYPRESS)
 		return cypress_compute_slot(td);
 
-	if (cls->quirks & MT_QUIRK_SLOT_IS_CONTACTNUMBER)
-		return slot_is_contactnumber(td);
+	if (quirks & MT_QUIRK_SLOT_IS_CONTACTNUMBER)
+		return td->num_received;
 
 	return find_slot_from_contactid(td);
 }
@@ -257,16 +263,12 @@ static int mt_compute_slot(struct mt_device *td)
  */
 static void mt_complete_slot(struct mt_device *td)
 {
+	td->curdata.seen_in_this_frame = true;
 	if (td->curvalid) {
-		struct mt_slot *slot;
 		int slotnum = mt_compute_slot(td);
 
-		if (slotnum >= 0 && slotnum < td->mtclass->maxcontacts) {
-			slot = td->slots + slotnum;
-
-			memcpy(slot, &(td->curdata), sizeof(struct mt_slot));
-			slot->seen_in_this_frame = true;
-		}
+		if (slotnum >= 0 && slotnum < td->mtclass->maxcontacts)
+			td->slots[slotnum] = td->curdata;
 	}
 	td->num_received++;
 }
@@ -284,21 +286,19 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
 		struct mt_slot *s = &(td->slots[i]);
 		if ((td->mtclass->quirks & MT_QUIRK_NOT_SEEN_MEANS_UP) &&
 			!s->seen_in_this_frame) {
-			/*
-			 * this slot does not contain useful data,
-			 * notify its closure
-			 */
 			s->touch_state = false;
 		}
 
 		input_mt_slot(input, i);
 		input_mt_report_slot_state(input, MT_TOOL_FINGER,
 			s->touch_state);
-		input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
-		input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
-		input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
-		input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, s->w);
-		input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, s->h);
+		if (s->touch_state) {
+			input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
+			input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
+			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
+			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, s->w);
+			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, s->h);
+		}
 		s->seen_in_this_frame = false;
 
 	}
@@ -314,16 +314,22 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 				struct hid_usage *usage, __s32 value)
 {
 	struct mt_device *td = hid_get_drvdata(hid);
+	__s32 quirks = td->mtclass->quirks;
 
 	if (hid->claimed & HID_CLAIMED_INPUT) {
 		switch (usage->hid) {
 		case HID_DG_INRANGE:
+			if (quirks & MT_QUIRK_VALID_IS_INRANGE)
+				td->curvalid = value;
 			break;
 		case HID_DG_TIPSWITCH:
-			td->curvalid = value;
+			if (quirks & MT_QUIRK_NOT_SEEN_MEANS_UP)
+				td->curvalid = value;
 			td->curdata.touch_state = value;
 			break;
 		case HID_DG_CONFIDENCE:
+			if (quirks & MT_QUIRK_VALID_IS_CONFIDENCE)
+				td->curvalid = value;
 			break;
 		case HID_DG_CONTACTID:
 			td->curdata.contactid = value;
@@ -345,26 +351,26 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 			break;
 		case HID_DG_CONTACTCOUNT:
 			/*
-			 * We must not overwrite the previous value (some
-			 * devices send one sequence splitted over several
-			 * messages)
+			 * Includes multi-packet support where subsequent
+			 * packets are sent with zero contactcount.
 			 */
 			if (value)
-				td->num_expected = value - 1;
+				td->num_expected = value;
 			break;
 
 		default:
 			/* fallback to the generic hidinput handling */
 			return 0;
 		}
-	}
 
-	if (usage->hid == td->last_slot_field)
-		mt_complete_slot(td);
+		if (usage->hid == td->last_slot_field)
+			mt_complete_slot(td);
+
+		if (field->index == td->last_field_index
+			&& td->num_received >= td->num_expected)
+			mt_emit_event(td, field->hidinput->input);
 
-	if (field->index == td->last_field_index
-		&& td->num_received > td->num_expected)
-		mt_emit_event(td, field->hidinput->input);
+	}
 
 	/* we have handled the hidinput part, now remains hiddev */
 	if (hid->claimed & HID_CLAIMED_HIDDEV && hid->hiddev_hid_event)
@@ -392,9 +398,16 @@ static void mt_set_input_mode(struct hid_device *hdev)
 
 static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
-	int ret;
+	int ret, i;
 	struct mt_device *td;
-	struct mt_class *mtclass = mt_classes + id->driver_data;
+	struct mt_class *mtclass = mt_classes; /* MT_CLS_DEFAULT */
+
+	for (i = 0; mt_classes[i].name ; i++) {
+		if (id->driver_data == mt_classes[i].name) {
+			mtclass = &(mt_classes[i]);
+			break;
+		}
+	}
 
 	/* This allows the driver to correctly support devices
 	 * that emit events over several HID messages.
@@ -417,7 +430,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		goto fail;
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
-	if (ret != 0)
+	if (ret)
 		goto fail;
 
 	mt_set_input_mode(hdev);
-- 
1.7.3.4

