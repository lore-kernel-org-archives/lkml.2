Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2KWPbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:31:55 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35522 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab2KWPbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:31:51 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] HID: hid-multitouch: manually send sync event for pen input report
Date: Fri, 23 Nov 2012 16:31:28 +0100
Message-Id: <1353684694-5723-6-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since hid-multitouch sets the quirk HID_QUIRK_NO_INPUT_SYNC, we need
to manually send the events and then make the SYN_EV.

This patch needs to export hidinput_hid_event

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-input.c      |  1 +
 drivers/hid/hid-multitouch.c | 17 ++++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index b0572d0..66ddbb6 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1057,6 +1057,7 @@ void hidinput_hid_event(struct hid_device *hid, struct hid_field *field, struct
 	if ((field->flags & HID_MAIN_ITEM_RELATIVE) && (usage->type == EV_KEY))
 		input_event(input, usage->type, usage->code, 0);
 }
+EXPORT_SYMBOL_GPL(hidinput_hid_event);
 
 void hidinput_report_event(struct hid_device *hid, struct hid_report *report)
 {
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index c894306..0a4c062 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -84,6 +84,7 @@ struct mt_device {
 	struct mt_fields *fields;	/* temporary placeholder for storing the
 					   multitouch fields */
 	unsigned last_field_index;	/* last field index of the report */
+	unsigned last_pen_field_index;	/* last field index of the pen report */
 	unsigned last_slot_field;	/* the last field of a slot */
 	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
 	__s8 inputmode_index;	/* InputMode HID feature index in the report */
@@ -371,8 +372,10 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		td->physical = field->physical;
 	}
 
-	if (field->physical == HID_DG_STYLUS)
+	if (field->physical == HID_DG_STYLUS) {
+		td->last_pen_field_index = field->index;
 		return 0;
+	}
 
 	if (usage->usage_index)
 		prev_usage = &field->usage[usage->usage_index - 1];
@@ -598,8 +601,16 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 	struct mt_device *td = hid_get_drvdata(hid);
 	__s32 quirks = td->mtclass.quirks;
 
-	if (field->physical == HID_DG_STYLUS)
-		return 0;
+	if (field->physical == HID_DG_STYLUS) {
+		if (hid->claimed & HID_CLAIMED_INPUT)
+			hidinput_hid_event(hid, field, usage, value);
+		if (hid->claimed & HID_CLAIMED_HIDDEV && hid->hiddev_hid_event)
+			hid->hiddev_hid_event(hid, field, usage, value);
+		if (usage->usage_index + 1 == field->report_count &&
+		    field->index == td->last_pen_field_index)
+			input_sync(field->hidinput->input);
+		return 1;
+	}
 
 	if (hid->claimed & HID_CLAIMED_INPUT) {
 		switch (usage->hid) {
-- 
1.8.0

