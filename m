Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab2KWPjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 10:39:22 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:43649 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab2KWPjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 10:39:20 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] HID: hid-multitouch: creates and handle stylus report with dual-sensors
Date: Fri, 23 Nov 2012 16:31:27 +0100
Message-Id: <1353684694-5723-5-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that drivers can create new inputs, let's use this to split
the reports coming from the pen and from the touch.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/hid-multitouch.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 61543c0..c894306 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -98,6 +98,8 @@ struct mt_device {
 	bool serial_maybe;	/* need to check for serial protocol */
 	bool curvalid;		/* is the current contact valid? */
 	unsigned mt_flags;	/* flags to pass to input-mt */
+	unsigned application;	/* the current HID application (pen or touch) */
+	unsigned physical;	/* the current HID physical (pen or touch) */
 };
 
 /* classes of device behavior */
@@ -342,7 +344,8 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	/* Only map fields from TouchScreen or TouchPad collections.
 	* We need to ignore fields that belong to other collections
 	* such as Mouse that might have the same GenericDesktop usages. */
-	if (field->application == HID_DG_TOUCHSCREEN)
+	if (field->application == HID_DG_TOUCHSCREEN ||
+	    field->application == HID_DG_PEN)
 		td->mt_flags |= INPUT_MT_DIRECT;
 	else if (field->application != HID_DG_TOUCHPAD)
 		return 0;
@@ -354,11 +357,22 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	    (usage->hid & HID_USAGE_PAGE) == HID_UP_BUTTON)
 		td->mt_flags |= INPUT_MT_POINTER;
 
-	/* eGalax devices provide a Digitizer.Stylus input which overrides
-	 * the correct Digitizers.Finger X/Y ranges.
-	 * Let's just ignore this input. */
+	/*
+	 * eGalax and newer N-Trig devices provide a Digitizer.Stylus input.
+	 * Create a new input device for this collection and let hid-input
+	 * handling it.
+	 */
+	if (td->application != field->application ||
+	    td->physical != field->physical) {
+		if (td->application)
+			/* a hidinput is already here, allocate a new one */
+			hi = hidinput_allocate(hdev);
+		td->application = field->application;
+		td->physical = field->physical;
+	}
+
 	if (field->physical == HID_DG_STYLUS)
-		return -1;
+		return 0;
 
 	if (usage->usage_index)
 		prev_usage = &field->usage[usage->usage_index - 1];
@@ -492,6 +506,9 @@ static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
+	if (field->physical == HID_DG_STYLUS)
+		return 0;
+
 	if (usage->type == EV_KEY || usage->type == EV_ABS)
 		set_bit(usage->type, hi->input->evbit);
 
@@ -581,6 +598,9 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 	struct mt_device *td = hid_get_drvdata(hid);
 	__s32 quirks = td->mtclass.quirks;
 
+	if (field->physical == HID_DG_STYLUS)
+		return 0;
+
 	if (hid->claimed & HID_CLAIMED_INPUT) {
 		switch (usage->hid) {
 		case HID_DG_INRANGE:
-- 
1.8.0

