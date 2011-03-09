Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab1CIQBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:01:07 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:41425 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab1CIQBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:01:04 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] hid-multitouch: Auto detection of maxcontacts
Date: Wed,  9 Mar 2011 17:00:47 +0100
Message-Id: <1299686450-5475-2-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1299686450-5475-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1299686450-5475-1-git-send-email-benjamin.tissoires@enac.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables support of autodetection of maxcontacts.
We can still manually provide maxcontact in case the device
lies on it.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---

Changes since v1:
- removed MT_CONTACTMAX_DEFAULT
- test the return value of kzalloc
- free td->slots when the device is removed
- check for td->slots in mt_event to avoid a race as it is
initialized after the device has been claimed.

 drivers/hid/hid-multitouch.c |   45 ++++++++++++++++++++++++++++-------------
 1 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 65e7f20..8a5fcc0 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -53,8 +53,9 @@ struct mt_device {
 	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
 	__u8 num_received;	/* how many contacts we received */
 	__u8 num_expected;	/* expected last contact index */
+	__u8 maxcontacts;
 	bool curvalid;		/* is the current contact valid? */
-	struct mt_slot slots[0];	/* first slot */
+	struct mt_slot *slots;
 };
 
 struct mt_class {
@@ -87,12 +88,12 @@ static int cypress_compute_slot(struct mt_device *td)
 static int find_slot_from_contactid(struct mt_device *td)
 {
 	int i;
-	for (i = 0; i < td->mtclass->maxcontacts; ++i) {
+	for (i = 0; i < td->maxcontacts; ++i) {
 		if (td->slots[i].contactid == td->curdata.contactid &&
 			td->slots[i].touch_state)
 			return i;
 	}
-	for (i = 0; i < td->mtclass->maxcontacts; ++i) {
+	for (i = 0; i < td->maxcontacts; ++i) {
 		if (!td->slots[i].seen_in_this_frame &&
 			!td->slots[i].touch_state)
 			return i;
@@ -106,7 +107,7 @@ static int find_slot_from_contactid(struct mt_device *td)
 struct mt_class mt_classes[] = {
 	{ .name = MT_CLS_DEFAULT,
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP,
-		.maxcontacts = 10 },
+		.maxcontacts = 2 },
 	{ .name = MT_CLS_DUAL_INRANGE_CONTACTID,
 		.quirks = MT_QUIRK_VALID_IS_INRANGE |
 			MT_QUIRK_SLOT_IS_CONTACTID,
@@ -126,9 +127,19 @@ struct mt_class mt_classes[] = {
 static void mt_feature_mapping(struct hid_device *hdev,
 		struct hid_field *field, struct hid_usage *usage)
 {
-	if (usage->hid == HID_DG_INPUTMODE) {
-		struct mt_device *td = hid_get_drvdata(hdev);
+	struct mt_device *td = hid_get_drvdata(hdev);
+
+	switch (usage->hid) {
+	case HID_DG_INPUTMODE:
 		td->inputmode = field->report->id;
+		break;
+	case HID_DG_CONTACTMAX:
+		td->maxcontacts = *(field->value);
+		if (td->mtclass->maxcontacts > td->maxcontacts)
+			/* check if the maxcontacts is given by the class */
+			td->maxcontacts = td->mtclass->maxcontacts;
+
+		break;
 	}
 }
 
@@ -186,8 +197,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			td->last_slot_field = usage->hid;
 			return 1;
 		case HID_DG_CONTACTID:
-			input_mt_init_slots(hi->input,
-					td->mtclass->maxcontacts);
+			input_mt_init_slots(hi->input, td->maxcontacts);
 			td->last_slot_field = usage->hid;
 			return 1;
 		case HID_DG_WIDTH:
@@ -268,7 +278,7 @@ static void mt_complete_slot(struct mt_device *td)
 	if (td->curvalid) {
 		int slotnum = mt_compute_slot(td);
 
-		if (slotnum >= 0 && slotnum < td->mtclass->maxcontacts)
+		if (slotnum >= 0 && slotnum < td->maxcontacts)
 			td->slots[slotnum] = td->curdata;
 	}
 	td->num_received++;
@@ -283,7 +293,7 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
 {
 	int i;
 
-	for (i = 0; i < td->mtclass->maxcontacts; ++i) {
+	for (i = 0; i < td->maxcontacts; ++i) {
 		struct mt_slot *s = &(td->slots[i]);
 		if ((td->mtclass->quirks & MT_QUIRK_NOT_SEEN_MEANS_UP) &&
 			!s->seen_in_this_frame) {
@@ -317,7 +327,7 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 	struct mt_device *td = hid_get_drvdata(hid);
 	__s32 quirks = td->mtclass->quirks;
 
-	if (hid->claimed & HID_CLAIMED_INPUT) {
+	if (hid->claimed & HID_CLAIMED_INPUT && td->slots) {
 		switch (usage->hid) {
 		case HID_DG_INRANGE:
 			if (quirks & MT_QUIRK_VALID_IS_INRANGE)
@@ -415,9 +425,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	 */
 	hdev->quirks |= HID_QUIRK_NO_INPUT_SYNC;
 
-	td = kzalloc(sizeof(struct mt_device) +
-				mtclass->maxcontacts * sizeof(struct mt_slot),
-				GFP_KERNEL);
+	td = kzalloc(sizeof(struct mt_device), GFP_KERNEL);
 	if (!td) {
 		dev_err(&hdev->dev, "cannot allocate multitouch data\n");
 		return -ENOMEM;
@@ -434,6 +442,14 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (ret)
 		goto fail;
 
+	td->slots = kzalloc(td->maxcontacts * sizeof(struct mt_slot),
+				GFP_KERNEL);
+	if (!td->slots) {
+		dev_err(&hdev->dev, "cannot allocate multitouch slots\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
 	mt_set_input_mode(hdev);
 
 	return 0;
@@ -455,6 +471,7 @@ static void mt_remove(struct hid_device *hdev)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
 	hid_hw_stop(hdev);
+	kfree(td->slots);
 	kfree(td);
 	hid_set_drvdata(hdev, NULL);
 }
-- 
1.7.4

