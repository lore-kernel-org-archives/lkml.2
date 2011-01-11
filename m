Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab1AKKwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:52:39 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:51801 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab1AKKwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:52:34 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Stephane Chatty <chatty@enac.fr>, Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: [PATCH] hid-multitouch: changes from the review process
Date: Tue, 11 Jan 2011 11:53:14 +0100
Message-Id: <1294743194-2310-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* amended Kconfig
* insert field name in mt_class and retrieving it in mt_probe
* cosmetics changes (tabs and comments)
* disable MT_QUIRK_NOT_SEEN_MEANS_UP: needs further tests for curvalid field
* do not send unnecessary properties once the touch is up

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---

Hi Jiri,

here are the updates of your branch multitouch.
My tester still didn't contact me but I know the driver works for 
PixCir and Cypress.

Cheers,
Benjamin

 drivers/hid/Kconfig          |    5 ++
 drivers/hid/hid-multitouch.c |   88 ++++++++++++++++++++++++++----------------
 2 files changed, 60 insertions(+), 33 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 9bd2148..ecb2b2f 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -296,6 +296,11 @@ config HID_MULTITOUCH
 	  - Cypress TrueTouch
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
index 3442ed5..88596fa 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -32,7 +32,7 @@ MODULE_LICENSE("GPL");
 /* quirks to control the device */
 #define MT_QUIRK_NOT_SEEN_MEANS_UP	(1 << 0)
 #define MT_QUIRK_SLOT_IS_CONTACTID	(1 << 1)
-#define MT_QUIRK_CYPRESS	(1 << 2)
+#define MT_QUIRK_CYPRESS		(1 << 2)
 #define MT_QUIRK_SLOT_IS_CONTACTNUMBER	(1 << 3)
 
 struct mt_slot {
@@ -55,6 +55,7 @@ struct mt_device {
 };
 
 struct mt_class {
+	__s32 name;	/* MT_CLS */
 	__s32 quirks;
 	__s32 sn_move;	/* Signal/noise ratio for move events */
 	__s32 sn_pressure;	/* Signal/noise ratio for pressure events */
@@ -62,10 +63,10 @@ struct mt_class {
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
@@ -103,17 +104,35 @@ static int find_slot_from_contactid(struct mt_device *td)
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
+		.quirks = 0,
+		.sn_move = 0,
+		.sn_pressure = 0,
+		.maxcontacts = 10 },
+	{ .name = MT_CLS_DUAL1,
+		.quirks = MT_QUIRK_SLOT_IS_CONTACTID,
+		.sn_move = 0,
+		.sn_pressure = 0,
+		.maxcontacts = 2 },
+	{ .name = MT_CLS_DUAL2,
+		.quirks = MT_QUIRK_SLOT_IS_CONTACTNUMBER,
+		.sn_move = 0,
+		.sn_pressure = 0,
+		.maxcontacts = 2 },
+	{ .name = MT_CLS_CYPRESS,
+		.quirks = MT_QUIRK_CYPRESS,
+		.sn_move = 0,
+		.sn_pressure = 0,
+		.maxcontacts = 10 },
+
+	{ }
 };
 
 static void mt_feature_mapping(struct hid_device *hdev, struct hid_input *hi,
@@ -192,7 +211,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TOUCH_MINOR);
 			field->logical_maximum = 1;
-			field->logical_minimum = 1;
+			field->logical_minimum = 0;
 			set_abs(hi->input, ABS_MT_ORIENTATION, field, 0);
 			td->last_slot_field = usage->hid;
 			return 1;
@@ -257,16 +276,12 @@ static int mt_compute_slot(struct mt_device *td)
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
@@ -282,11 +297,10 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
 
 	for (i = 0; i < td->mtclass->maxcontacts; ++i) {
 		struct mt_slot *s = &(td->slots[i]);
-		if ((td->mtclass->quirks & MT_QUIRK_NOT_SEEN_MEANS_UP) &&
-			!s->seen_in_this_frame) {
+		if (!s->seen_in_this_frame) {
 			/*
-			 * this slot does not contain useful data,
-			 * notify its closure
+			 * FixMe: use MT_QUIRK_NOT_SEEN_MEANS_UP here.
+			 * This requires to change the curvalid logic.
 			 */
 			s->touch_state = false;
 		}
@@ -294,11 +308,13 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
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
@@ -345,9 +361,8 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
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
 				td->num_expected = value - 1;
@@ -392,9 +407,16 @@ static void mt_set_input_mode(struct hid_device *hdev)
 
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
@@ -417,7 +439,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		goto fail;
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
-	if (ret != 0)
+	if (ret)
 		goto fail;
 
 	mt_set_input_mode(hdev);
-- 
1.7.3.4

