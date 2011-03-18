Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab1CRN1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 09:27:49 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:39045 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab1CRN1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 09:27:42 -0400
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/5] hid-multitouch: Auto detection of maxcontacts
Date: Fri, 18 Mar 2011 14:27:52 +0100
Message-Id: <1300454876-5017-2-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1300454876-5017-1-git-send-email-benjamin.tissoires@enac.fr>
References: <1300454876-5017-1-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables support of autodetection of maxcontacts.
When adding support for a new device, one is now able to let
the device tell how many contacts it supports, or to manually
set the value if the device happens to provide wrong information.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Reviewed-by: Stéphane Chatty <chatty@enac.fr>
---

changes since v2:
* reverted "if (td->mtclass->maxcontacts)" test
* reverted MT_DEFAULT_MAXCONTACT
* add a test on td->slots before kzalloc
* remove device in case td->slots was not allocated

 drivers/hid/hid-multitouch.c |   52 +++++++++++++++++++++++++++++------------
 1 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index ee01e65..b9f9eec 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -60,8 +60,9 @@ struct mt_device {
 	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
 	__u8 num_received;	/* how many contacts we received */
 	__u8 num_expected;	/* expected last contact index */
+	__u8 maxcontacts;
 	bool curvalid;		/* is the current contact valid? */
-	struct mt_slot slots[0];	/* first slot */
+	struct mt_slot *slots;
 };
 
 struct mt_class {
@@ -79,6 +80,8 @@ struct mt_class {
 #define MT_CLS_CYPRESS				4
 #define MT_CLS_EGALAX				5
 
+#define MT_DEFAULT_MAXCONTACT	10
+
 /*
  * these device-dependent functions determine what slot corresponds
  * to a valid contact that was just read.
@@ -95,12 +98,12 @@ static int cypress_compute_slot(struct mt_device *td)
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
@@ -113,8 +116,7 @@ static int find_slot_from_contactid(struct mt_device *td)
 
 struct mt_class mt_classes[] = {
 	{ .name = MT_CLS_DEFAULT,
-		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP,
-		.maxcontacts = 10 },
+		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP },
 	{ .name = MT_CLS_DUAL_INRANGE_CONTACTID,
 		.quirks = MT_QUIRK_VALID_IS_INRANGE |
 			MT_QUIRK_SLOT_IS_CONTACTID,
@@ -142,9 +144,19 @@ struct mt_class mt_classes[] = {
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
+		td->maxcontacts = field->value[0];
+		if (td->mtclass->maxcontacts)
+			/* check if the maxcontacts is given by the class */
+			td->maxcontacts = td->mtclass->maxcontacts;
+
+		break;
 	}
 }
 
@@ -208,8 +220,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			td->last_slot_field = usage->hid;
 			return 1;
 		case HID_DG_CONTACTID:
-			input_mt_init_slots(hi->input,
-					td->mtclass->maxcontacts);
+			input_mt_init_slots(hi->input, td->maxcontacts);
 			td->last_slot_field = usage->hid;
 			return 1;
 		case HID_DG_WIDTH:
@@ -292,7 +303,7 @@ static void mt_complete_slot(struct mt_device *td)
 	if (td->curvalid) {
 		int slotnum = mt_compute_slot(td);
 
-		if (slotnum >= 0 && slotnum < td->mtclass->maxcontacts)
+		if (slotnum >= 0 && slotnum < td->maxcontacts)
 			td->slots[slotnum] = td->curdata;
 	}
 	td->num_received++;
@@ -307,7 +318,7 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
 {
 	int i;
 
-	for (i = 0; i < td->mtclass->maxcontacts; ++i) {
+	for (i = 0; i < td->maxcontacts; ++i) {
 		struct mt_slot *s = &(td->slots[i]);
 		if ((td->mtclass->quirks & MT_QUIRK_NOT_SEEN_MEANS_UP) &&
 			!s->seen_in_this_frame) {
@@ -341,7 +352,7 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 	struct mt_device *td = hid_get_drvdata(hid);
 	__s32 quirks = td->mtclass->quirks;
 
-	if (hid->claimed & HID_CLAIMED_INPUT) {
+	if (hid->claimed & HID_CLAIMED_INPUT && td->slots) {
 		switch (usage->hid) {
 		case HID_DG_INRANGE:
 			if (quirks & MT_QUIRK_VALID_IS_INRANGE)
@@ -442,9 +453,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	 */
 	hdev->quirks |= HID_QUIRK_NO_INPUT_SYNC;
 
-	td = kzalloc(sizeof(struct mt_device) +
-				mtclass->maxcontacts * sizeof(struct mt_slot),
-				GFP_KERNEL);
+	td = kzalloc(sizeof(struct mt_device), GFP_KERNEL);
 	if (!td) {
 		dev_err(&hdev->dev, "cannot allocate multitouch data\n");
 		return -ENOMEM;
@@ -461,6 +470,18 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (ret)
 		goto fail;
 
+	if (!td->maxcontacts)
+		td->maxcontacts = MT_DEFAULT_MAXCONTACT;
+
+	td->slots = kzalloc(td->maxcontacts * sizeof(struct mt_slot),
+				GFP_KERNEL);
+	if (!td->slots) {
+		dev_err(&hdev->dev, "cannot allocate multitouch slots\n");
+		hid_hw_stop(hdev);
+		ret = -ENOMEM;
+		goto fail;
+	}
+
 	mt_set_input_mode(hdev);
 
 	return 0;
@@ -482,6 +503,7 @@ static void mt_remove(struct hid_device *hdev)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
 	hid_hw_stop(hdev);
+	kfree(td->slots);
 	kfree(td);
 	hid_set_drvdata(hdev, NULL);
 }
-- 
1.7.4

