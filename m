Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab0JMN7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:59:33 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:44359 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648Ab0JMN7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:59:31 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 2/6] hid: egalax: Setup input device manually
Date: Wed, 13 Oct 2010 15:58:18 +0200
Message-Id: <1286978302-30034-3-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286978302-30034-1-git-send-email-rydberg@euromail.se>
References: <1286978302-30034-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1P61r6-00080Y-3w.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1P61r6-00080Y-3w f4bb00c5f9128f68c45c53007ec722dd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hid core does not yet handle input filtering. Take over the setup
of the input device, so that proper signal-to-noise ratios can be
used.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-egalax.c |   37 +++++++++++++++++++++++++------------
 1 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/hid/hid-egalax.c b/drivers/hid/hid-egalax.c
index 5a1b52e..23f832b 100644
--- a/drivers/hid/hid-egalax.c
+++ b/drivers/hid/hid-egalax.c
@@ -25,6 +25,8 @@ MODULE_LICENSE("GPL");
 
 #include "hid-ids.h"
 
+#define MAX_EVENTS		120
+
 struct egalax_data {
 	__u16 x, y, z;
 	__u8 id;
@@ -34,10 +36,21 @@ struct egalax_data {
 	__u16 lastx, lasty, lastz;	/* latest valid (x, y, z) in the frame */
 };
 
+static void set_abs(struct input_dev *input, unsigned int code,
+		    struct hid_field *field, int snratio)
+{
+	int fmin = field->logical_minimum;
+	int fmax = field->logical_maximum;
+	int fuzz = snratio ? (fmax - fmin) / snratio : 0;
+	input_set_abs_params(input, code, fmin, fmax, fuzz, 0);
+}
+
 static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
+	struct input_dev *input = hi->input;
+
 	switch (usage->hid & HID_USAGE_PAGE) {
 
 	case HID_UP_GENDESK:
@@ -45,18 +58,16 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_GD_X:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_POSITION_X);
+			set_abs(input, ABS_MT_POSITION_X, field, 0);
 			/* touchscreen emulation */
-			input_set_abs_params(hi->input, ABS_X,
-						field->logical_minimum,
-						field->logical_maximum, 0, 0);
+			set_abs(input, ABS_X, field, 0);
 			return 1;
 		case HID_GD_Y:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_POSITION_Y);
+			set_abs(input, ABS_MT_POSITION_Y, field, 0);
 			/* touchscreen emulation */
-			input_set_abs_params(hi->input, ABS_Y,
-						field->logical_minimum,
-						field->logical_maximum, 0, 0);
+			set_abs(input, ABS_Y, field, 0);
 			return 1;
 		}
 		return 0;
@@ -66,6 +77,7 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_TIPSWITCH:
 			/* touchscreen emulation */
 			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
+			input_set_capability(input, EV_KEY, BTN_TOUCH);
 			return 1;
 		case HID_DG_INRANGE:
 		case HID_DG_CONFIDENCE:
@@ -75,14 +87,15 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		case HID_DG_CONTACTID:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TRACKING_ID);
+			set_abs(input, ABS_MT_TRACKING_ID, field, 0);
+			input_set_events_per_packet(input, MAX_EVENTS);
 			return 1;
 		case HID_DG_TIPPRESSURE:
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_PRESSURE);
+			set_abs(input, ABS_MT_PRESSURE, field, 0);
 			/* touchscreen emulation */
-			input_set_abs_params(hi->input, ABS_PRESSURE,
-						field->logical_minimum,
-						field->logical_maximum, 0, 0);
+			set_abs(input, ABS_PRESSURE, field, 0);
 			return 1;
 		}
 		return 0;
@@ -96,10 +109,10 @@ static int egalax_input_mapped(struct hid_device *hdev, struct hid_input *hi,
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
-- 
1.7.1

