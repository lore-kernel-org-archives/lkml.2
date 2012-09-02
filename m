Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab2IBJ3D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 05:29:03 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:35609 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab2IBJ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 05:29:00 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AldMAIcmQ1BV5qoUPGdsb2JhbABFij+wYRkBAQEBHhkNJ4JOLxMBDxiBAgoaARKIEbpbFJIcA5tHjRE
X-IronPort-AV: E=Sophos;i="4.80,355,1344204000"; 
   d="scan'208";a="404248748"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>
Subject: [PATCH v3 18/20] HID: hid-multitouch: Simplify setup and frame synchronization
Date: Sun,  2 Sep 2012 11:34:28 +0200
Message-Id: <1346578468-16916-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the input_configured() callback in place, the setup and frame
synchronization can be simplified. The input device initialization is
moved to mt_input_configured(), to make sure the full HID report has been
seen.

Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-multitouch.c | 67 +++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 29 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index c400d90..1df86a7 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -92,8 +92,10 @@ struct mt_device {
 	__u8 touches_by_report;	/* how many touches are present in one report:
 				* 1 means we should use a serial protocol
 				* > 1 means hybrid (multitouch) protocol */
+	bool serial_maybe;	/* need to check for serial protocol */
 	bool curvalid;		/* is the current contact valid? */
 	struct mt_slot *slots;
+	unsigned mt_flags;	/* flags to pass to input-mt */
 };
 
 /* classes of device behavior */
@@ -319,24 +321,16 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	* We need to ignore fields that belong to other collections
 	* such as Mouse that might have the same GenericDesktop usages. */
 	if (field->application == HID_DG_TOUCHSCREEN)
-		set_bit(INPUT_PROP_DIRECT, hi->input->propbit);
+		td->mt_flags |= INPUT_MT_DIRECT;
 	else if (field->application != HID_DG_TOUCHPAD)
 		return 0;
 
-	/* In case of an indirect device (touchpad), we need to add
-	 * specific BTN_TOOL_* to be handled by the synaptics xorg
-	 * driver.
-	 * We also consider that touchscreens providing buttons are touchpads.
+	/*
+	 * Model touchscreens providing buttons as touchpads.
 	 */
 	if (field->application == HID_DG_TOUCHPAD ||
-	    (usage->hid & HID_USAGE_PAGE) == HID_UP_BUTTON ||
-	    cls->is_indirect) {
-		set_bit(INPUT_PROP_POINTER, hi->input->propbit);
-		set_bit(BTN_TOOL_FINGER, hi->input->keybit);
-		set_bit(BTN_TOOL_DOUBLETAP, hi->input->keybit);
-		set_bit(BTN_TOOL_TRIPLETAP, hi->input->keybit);
-		set_bit(BTN_TOOL_QUADTAP, hi->input->keybit);
-	}
+	    (usage->hid & HID_USAGE_PAGE) == HID_UP_BUTTON)
+		td->mt_flags |= INPUT_MT_POINTER;
 
 	/* eGalax devices provide a Digitizer.Stylus input which overrides
 	 * the correct Digitizers.Finger X/Y ranges.
@@ -353,8 +347,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 					EV_ABS, ABS_MT_POSITION_X);
 			set_abs(hi->input, ABS_MT_POSITION_X, field,
 				cls->sn_move);
-			/* touchscreen emulation */
-			set_abs(hi->input, ABS_X, field, cls->sn_move);
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
@@ -363,8 +355,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 					EV_ABS, ABS_MT_POSITION_Y);
 			set_abs(hi->input, ABS_MT_POSITION_Y, field,
 				cls->sn_move);
-			/* touchscreen emulation */
-			set_abs(hi->input, ABS_Y, field, cls->sn_move);
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
@@ -388,9 +378,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTID:
-			if (!td->maxcontacts)
-				td->maxcontacts = MT_DEFAULT_MAXCONTACT;
-			input_mt_init_slots(hi->input, td->maxcontacts, 0);
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			td->touches_by_report++;
@@ -418,9 +405,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 					EV_ABS, ABS_MT_PRESSURE);
 			set_abs(hi->input, ABS_MT_PRESSURE, field,
 				cls->sn_pressure);
-			/* touchscreen emulation */
-			set_abs(hi->input, ABS_PRESSURE, field,
-				cls->sn_pressure);
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
@@ -536,7 +520,7 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
 
 	}
 
-	input_mt_report_pointer_emulation(input, true);
+	input_mt_sync_frame(input);
 	input_sync(input);
 	td->num_received = 0;
 }
@@ -685,6 +669,32 @@ static void mt_post_parse(struct mt_device *td)
 	}
 }
 
+static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
+
+{
+	struct mt_device *td = hid_get_drvdata(hdev);
+	struct mt_class *cls = &td->mtclass;
+	struct input_dev *input = hi->input;
+
+	/* Only initialize slots for MT input devices */
+	if (!test_bit(ABS_MT_POSITION_X, input->absbit))
+		return;
+
+	if (!td->maxcontacts)
+		td->maxcontacts = MT_DEFAULT_MAXCONTACT;
+
+	mt_post_parse(td);
+	if (td->serial_maybe)
+		mt_post_parse_default_settings(td);
+
+	if (cls->is_indirect)
+		td->mt_flags |= INPUT_MT_POINTER;
+
+	input_mt_init_slots(input, td->maxcontacts, td->mt_flags);
+
+	td->mt_flags = 0;
+}
+
 static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	int ret, i;
@@ -722,6 +732,9 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		goto fail;
 	}
 
+	if (id->vendor == HID_ANY_ID && id->product == HID_ANY_ID)
+		td->serial_maybe = true;
+
 	ret = hid_parse(hdev);
 	if (ret != 0)
 		goto fail;
@@ -730,11 +743,6 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (ret)
 		goto fail;
 
-	mt_post_parse(td);
-
-	if (id->vendor == HID_ANY_ID && id->product == HID_ANY_ID)
-		mt_post_parse_default_settings(td);
-
 	td->slots = kzalloc(td->maxcontacts * sizeof(struct mt_slot),
 				GFP_KERNEL);
 	if (!td->slots) {
@@ -1087,6 +1095,7 @@ static struct hid_driver mt_driver = {
 	.remove = mt_remove,
 	.input_mapping = mt_input_mapping,
 	.input_mapped = mt_input_mapped,
+	.input_configured = mt_input_configured,
 	.feature_mapping = mt_feature_mapping,
 	.usage_table = mt_grabbed_usages,
 	.event = mt_event,
-- 
1.7.12

