Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab2FSMkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 08:40:12 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62455 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab2FSMkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 08:40:09 -0400
From: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] HID: hid-multitouch: fix input mode feature command
Date: Tue, 19 Jun 2012 14:39:52 +0200
Message-Id: <1340109594-10732-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

Zytronic panels shows a new way of setting the Input Mode feature.
This feature is put in the second usage in the HID feature, instead
of the first, as the majority of the multitouch devices.

This patch adds a detection step when the feature is presented to know
where the feature is located in the report. We can then trigger the right
command to the device. This removes the magic number "0" in the function
mt_set_input_mode.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
 drivers/hid/hid-multitouch.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 61cc4cb..9a3891e 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -83,6 +83,7 @@ struct mt_device {
 	unsigned last_field_index;	/* last field index of the report */
 	unsigned last_slot_field;	/* the last field of a slot */
 	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
+	__s8 inputmode_index;	/* InputMode HID feature index in the report */
 	__s8 maxcontact_report_id;	/* Maximum Contact Number HID feature,
 				   -1 if non-existent */
 	__u8 num_received;	/* how many contacts we received */
@@ -260,10 +261,20 @@ static void mt_feature_mapping(struct hid_device *hdev,
 		struct hid_field *field, struct hid_usage *usage)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
+	int i;
 
 	switch (usage->hid) {
 	case HID_DG_INPUTMODE:
 		td->inputmode = field->report->id;
+		td->inputmode_index = 0; /* has to be updated below */
+
+		for (i=0; i < field->maxusage; i++) {
+			if (field->usage[i].hid == usage->hid) {
+				td->inputmode_index = i;
+				break;
+			}
+		}
+
 		break;
 	case HID_DG_CONTACTMAX:
 		td->maxcontact_report_id = field->report->id;
@@ -618,7 +629,7 @@ static void mt_set_input_mode(struct hid_device *hdev)
 	re = &(hdev->report_enum[HID_FEATURE_REPORT]);
 	r = re->report_id_hash[td->inputmode];
 	if (r) {
-		r->field[0]->value[0] = 0x02;
+		r->field[0]->value[td->inputmode_index] = 0x02;
 		usbhid_submit_report(hdev, r, USB_DIR_OUT);
 	}
 }
-- 
1.7.10.2

