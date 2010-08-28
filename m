Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0H1O3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 10:29:44 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:56395 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753536Ab0H1O3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 10:29:42 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 2/3] hid: 3m: Convert to MT slots
Date: Sat, 28 Aug 2010 16:29:07 +0200
Message-Id: <1283005748-3293-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283005748-3293-1-git-send-email-rydberg@euromail.se>
References: <1283005748-3293-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OpMPX-0000kn-9F.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OpMPX-0000kn-9F f9b574a4851b561eec3a95a5613e8b0f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Microtouch controller is capable of doing finger tracking on
up to 60 fingers. To reduce bandwidth and cpu usage, convert the
driver to use the MT slots protocol.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-3m-pct.c |   50 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/hid-3m-pct.c b/drivers/hid/hid-3m-pct.c
index 1057430..9a3b047 100644
--- a/drivers/hid/hid-3m-pct.c
+++ b/drivers/hid/hid-3m-pct.c
@@ -25,16 +25,22 @@ MODULE_LICENSE("GPL");
 #include "hid-ids.h"
 
 #define MAX_SLOTS		60
-#define MAX_TRKID		59
+#define MAX_TRKID		USHRT_MAX
+#define MAX_EVENTS		360
+#define SN_MOVE			2048
+#define SN_WIDTH		128
 
 struct mmm_finger {
 	__s32 x, y, w, h;
+	__u16 id;
 	__u8 rank;
+	bool prev_touch;
 	bool touch, valid;
 };
 
 struct mmm_data {
 	struct mmm_finger f[MAX_SLOTS];
+	__u16 id;
 	__u8 curid, num;
 	__u8 nexp, nreal;
 	bool touch, valid;
@@ -44,6 +50,10 @@ static int mmm_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
+	int f1 = field->logical_minimum;
+	int f2 = field->logical_maximum;
+	int df = f2 - f1;
+
 	switch (usage->hid & HID_USAGE_PAGE) {
 
 	case HID_UP_BUTTON:
@@ -54,18 +64,20 @@ static int mmm_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_GD_X:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_POSITION_X);
+			input_set_abs_params(hi->input, ABS_MT_POSITION_X,
+					     f1, f2, df / SN_MOVE, 0);
 			/* touchscreen emulation */
 			input_set_abs_params(hi->input, ABS_X,
-						field->logical_minimum,
-						field->logical_maximum, 0, 0);
+					     f1, f2, df / SN_MOVE, 0);
 			return 1;
 		case HID_GD_Y:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_POSITION_Y);
+			input_set_abs_params(hi->input, ABS_MT_POSITION_Y,
+					     f1, f2, df / SN_MOVE, 0);
 			/* touchscreen emulation */
 			input_set_abs_params(hi->input, ABS_Y,
-						field->logical_minimum,
-						field->logical_maximum, 0, 0);
+					     f1, f2, df / SN_MOVE, 0);
 			return 1;
 		}
 		return 0;
@@ -85,14 +97,19 @@ static int mmm_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_TIPSWITCH:
 			/* touchscreen emulation */
 			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
+			input_set_capability(hi->input, EV_KEY, BTN_TOUCH);
 			return 1;
 		case HID_DG_WIDTH:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TOUCH_MAJOR);
+			input_set_abs_params(hi->input, ABS_MT_TOUCH_MAJOR,
+					     f1, f2, df / SN_WIDTH, 0);
 			return 1;
 		case HID_DG_HEIGHT:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TOUCH_MINOR);
+			input_set_abs_params(hi->input, ABS_MT_TOUCH_MINOR,
+					     f1, f2, df / SN_WIDTH, 0);
 			input_set_abs_params(hi->input, ABS_MT_ORIENTATION,
 					1, 1, 0, 0);
 			return 1;
@@ -100,6 +117,11 @@ static int mmm_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			field->logical_maximum = MAX_TRKID;
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TRACKING_ID);
+			input_set_abs_params(hi->input, ABS_MT_TRACKING_ID,
+					     0, MAX_TRKID, 0, 0);
+			if (!hi->input->mt)
+				input_mt_create_slots(hi->input, MAX_SLOTS);
+			input_set_events_per_packet(hi->input, MAX_EVENTS);
 			return 1;
 		}
 		/* let hid-input decide for the others */
@@ -117,10 +139,10 @@ static int mmm_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
+	/* tell hid-input to skip setup of these event types */
 	if (usage->type == EV_KEY || usage->type == EV_ABS)
-		clear_bit(usage->code, *bit);
-
-	return 0;
+		set_bit(usage->type, hi->input->evbit);
+	return -1;
 }
 
 /*
@@ -141,10 +163,15 @@ static void mmm_filter_event(struct mmm_data *md, struct input_dev *input)
 		struct mmm_finger *f = &md->f[i];
 		if (!f->valid) {
 			/* this finger is just placeholder data, ignore */
-		} else if (f->touch) {
+			continue;
+		}
+		input_mt_slot(input, i);
+		if (f->touch) {
 			/* this finger is on the screen */
 			int wide = (f->w > f->h);
-			input_event(input, EV_ABS, ABS_MT_TRACKING_ID, i);
+			if (!f->prev_touch)
+				f->id = md->id++;
+			input_event(input, EV_ABS, ABS_MT_TRACKING_ID, f->id);
 			input_event(input, EV_ABS, ABS_MT_POSITION_X, f->x);
 			input_event(input, EV_ABS, ABS_MT_POSITION_Y, f->y);
 			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
@@ -152,7 +179,6 @@ static void mmm_filter_event(struct mmm_data *md, struct input_dev *input)
 						wide ? f->w : f->h);
 			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR,
 						wide ? f->h : f->w);
-			input_mt_sync(input);
 			/*
 			 * touchscreen emulation: maintain the age rank
 			 * of this finger, decide if we have a press
@@ -181,7 +207,9 @@ static void mmm_filter_event(struct mmm_data *md, struct input_dev *input)
 			--(md->num);
 			if (md->num == 0)
 				released = true;
+			input_event(input, EV_ABS, ABS_MT_TRACKING_ID, -1);
 		}
+		f->prev_touch = f->touch;
 		f->valid = 0;
 	}
 
-- 
1.7.1

