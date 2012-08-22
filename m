Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab2HVUxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 16:53:47 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:56824 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933298Ab2HVUxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 16:53:44 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhlSAGxGNVBV5qoUPGdsb2JhbABFhRiFI7ASGQEBAQEeGQ0ngiEBBScTHBMBDxAISRQlChoTiBG5LRSLCIYoYAOVUYVsjQ2BVg
X-IronPort-AV: E=Sophos;i="4.77,811,1336341600"; 
   d="scan'208";a="398216034"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 22 Aug 2012 22:58:32 +0200
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] HID: multitouch: Remove the redundant touch state
Message-ID: <20120822205832.GA18102@polaris.bitmath.org>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
 <1344807757-2217-20-git-send-email-rydberg@euromail.se>
 <CAN+gG=F6hhOxU--mF2v3sCTzFLHqd6vK5JqcvvDXigss7EkPHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=F6hhOxU--mF2v3sCTzFLHqd6vK5JqcvvDXigss7EkPHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the input_mt_sync_frame() function in place, there is no longer
any need to keep the full touch state in the driver. This patch
removes the slot state and replaces the lookup code with the input-mt
equivalent. The initialization code is moved to mt_input_configured(),
to make sure the full HID report has been seen.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
Hi Benjamin,

Maybe this patch works better? It has received limited testing so far.

Henrik

 drivers/hid/hid-multitouch.c | 133 +++++++++++++++----------------------------
 1 file changed, 46 insertions(+), 87 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index c400d90..dc08a4e 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -56,7 +56,6 @@ struct mt_slot {
 	__s32 x, y, p, w, h;
 	__s32 contactid;	/* the device ContactID assigned to this slot */
 	bool touch_state;	/* is the touch valid? */
-	bool seen_in_this_frame;/* has this slot been updated */
 };
 
 struct mt_class {
@@ -93,7 +92,7 @@ struct mt_device {
 				* 1 means we should use a serial protocol
 				* > 1 means hybrid (multitouch) protocol */
 	bool curvalid;		/* is the current contact valid? */
-	struct mt_slot *slots;
+	unsigned mt_flags;	/* flags to pass to input-mt */
 };
 
 /* classes of device behavior */
@@ -134,25 +133,6 @@ static int cypress_compute_slot(struct mt_device *td)
 		return -1;
 }
 
-static int find_slot_from_contactid(struct mt_device *td)
-{
-	int i;
-	for (i = 0; i < td->maxcontacts; ++i) {
-		if (td->slots[i].contactid == td->curdata.contactid &&
-			td->slots[i].touch_state)
-			return i;
-	}
-	for (i = 0; i < td->maxcontacts; ++i) {
-		if (!td->slots[i].seen_in_this_frame &&
-			!td->slots[i].touch_state)
-			return i;
-	}
-	/* should not occurs. If this happens that means
-	 * that the device sent more touches that it says
-	 * in the report descriptor. It is ignored then. */
-	return -1;
-}
-
 static struct mt_class mt_classes[] = {
 	{ .name = MT_CLS_DEFAULT,
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP },
@@ -319,24 +299,16 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
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
@@ -353,8 +325,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 					EV_ABS, ABS_MT_POSITION_X);
 			set_abs(hi->input, ABS_MT_POSITION_X, field,
 				cls->sn_move);
-			/* touchscreen emulation */
-			set_abs(hi->input, ABS_X, field, cls->sn_move);
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
@@ -363,8 +333,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 					EV_ABS, ABS_MT_POSITION_Y);
 			set_abs(hi->input, ABS_MT_POSITION_Y, field,
 				cls->sn_move);
-			/* touchscreen emulation */
-			set_abs(hi->input, ABS_Y, field, cls->sn_move);
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
@@ -390,7 +358,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_CONTACTID:
 			if (!td->maxcontacts)
 				td->maxcontacts = MT_DEFAULT_MAXCONTACT;
-			input_mt_init_slots(hi->input, td->maxcontacts, 0);
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			td->touches_by_report++;
@@ -418,9 +385,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 					EV_ABS, ABS_MT_PRESSURE);
 			set_abs(hi->input, ABS_MT_PRESSURE, field,
 				cls->sn_pressure);
-			/* touchscreen emulation */
-			set_abs(hi->input, ABS_PRESSURE, field,
-				cls->sn_pressure);
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
@@ -464,7 +428,24 @@ static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 	return -1;
 }
 
-static int mt_compute_slot(struct mt_device *td)
+static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
+
+{
+	struct mt_device *td = hid_get_drvdata(hdev);
+	struct mt_class *cls = &td->mtclass;
+
+	if (cls->is_indirect)
+		td->mt_flags |= INPUT_MT_POINTER;
+
+	if (cls->quirks & MT_QUIRK_NOT_SEEN_MEANS_UP)
+		td->mt_flags |= INPUT_MT_DROP_UNUSED;
+
+	input_mt_init_slots(hi->input, td->maxcontacts, td->mt_flags);
+
+	td->mt_flags = 0;
+}
+
+static int mt_compute_slot(struct mt_device *td, struct input_dev *input)
 {
 	__s32 quirks = td->mtclass.quirks;
 
@@ -480,42 +461,23 @@ static int mt_compute_slot(struct mt_device *td)
 	if (quirks & MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE)
 		return td->curdata.contactid - 1;
 
-	return find_slot_from_contactid(td);
+	return input_mt_assign_slot_by_id(input, td->curdata.contactid);
 }
 
 /*
  * this function is called when a whole contact has been processed,
  * so that it can assign it to a slot and store the data there
  */
-static void mt_complete_slot(struct mt_device *td)
+static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
 {
-	td->curdata.seen_in_this_frame = true;
 	if (td->curvalid) {
-		int slotnum = mt_compute_slot(td);
-
-		if (slotnum >= 0 && slotnum < td->maxcontacts)
-			td->slots[slotnum] = td->curdata;
-	}
-	td->num_received++;
-}
+		int slotnum = mt_compute_slot(td, input);
+		struct mt_slot *s = &td->curdata;
 
+		if (slotnum < 0 || slotnum >= td->maxcontacts)
+			return;
 
-/*
- * this function is called when a whole packet has been received and processed,
- * so that it can decide what to send to the input layer.
- */
-static void mt_emit_event(struct mt_device *td, struct input_dev *input)
-{
-	int i;
-
-	for (i = 0; i < td->maxcontacts; ++i) {
-		struct mt_slot *s = &(td->slots[i]);
-		if ((td->mtclass.quirks & MT_QUIRK_NOT_SEEN_MEANS_UP) &&
-			!s->seen_in_this_frame) {
-			s->touch_state = false;
-		}
-
-		input_mt_slot(input, i);
+		input_mt_slot(input, slotnum);
 		input_mt_report_slot_state(input, MT_TOOL_FINGER,
 			s->touch_state);
 		if (s->touch_state) {
@@ -532,16 +494,22 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
 			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
 			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
 		}
-		s->seen_in_this_frame = false;
-
 	}
 
-	input_mt_report_pointer_emulation(input, true);
-	input_sync(input);
-	td->num_received = 0;
+	td->num_received++;
 }
 
 
+/*
+ * this function is called when a whole packet has been received and processed,
+ * so that it can decide what to send to the input layer.
+ */
+static void mt_sync_frame(struct mt_device *td, struct input_dev *input)
+{
+	input_mt_sync_frame(input);
+	input_sync(input);
+	td->num_received = 0;
+}
 
 static int mt_event(struct hid_device *hid, struct hid_field *field,
 				struct hid_usage *usage, __s32 value)
@@ -549,7 +517,7 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 	struct mt_device *td = hid_get_drvdata(hid);
 	__s32 quirks = td->mtclass.quirks;
 
-	if (hid->claimed & HID_CLAIMED_INPUT && td->slots) {
+	if (hid->claimed & HID_CLAIMED_INPUT) {
 		switch (usage->hid) {
 		case HID_DG_INRANGE:
 			if (quirks & MT_QUIRK_ALWAYS_VALID)
@@ -602,11 +570,11 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 		}
 
 		if (usage->hid == td->last_slot_field)
-			mt_complete_slot(td);
+			mt_complete_slot(td, field->hidinput->input);
 
 		if (field->index == td->last_field_index
 			&& td->num_received >= td->num_expected)
-			mt_emit_event(td, field->hidinput->input);
+			mt_sync_frame(td, field->hidinput->input);
 
 	}
 
@@ -735,15 +703,6 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (id->vendor == HID_ANY_ID && id->product == HID_ANY_ID)
 		mt_post_parse_default_settings(td);
 
-	td->slots = kzalloc(td->maxcontacts * sizeof(struct mt_slot),
-				GFP_KERNEL);
-	if (!td->slots) {
-		dev_err(&hdev->dev, "cannot allocate multitouch slots\n");
-		hid_hw_stop(hdev);
-		ret = -ENOMEM;
-		goto fail;
-	}
-
 	ret = sysfs_create_group(&hdev->dev.kobj, &mt_attribute_group);
 
 	mt_set_maxcontacts(hdev);
@@ -774,7 +733,6 @@ static void mt_remove(struct hid_device *hdev)
 	struct mt_device *td = hid_get_drvdata(hdev);
 	sysfs_remove_group(&hdev->dev.kobj, &mt_attribute_group);
 	hid_hw_stop(hdev);
-	kfree(td->slots);
 	kfree(td);
 	hid_set_drvdata(hdev, NULL);
 }
@@ -1087,6 +1045,7 @@ static struct hid_driver mt_driver = {
 	.remove = mt_remove,
 	.input_mapping = mt_input_mapping,
 	.input_mapped = mt_input_mapped,
+	.input_configured = mt_input_configured,
 	.feature_mapping = mt_feature_mapping,
 	.usage_table = mt_grabbed_usages,
 	.event = mt_event,
-- 
1.7.11.5

