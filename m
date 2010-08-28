Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0H1OaI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 10:30:08 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:38226 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754042Ab0H1OaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 10:30:02 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/3] hid: 3m: Adjust to sequential MT HID protocol
Date: Sat, 28 Aug 2010 16:29:06 +0200
Message-Id: <1283005748-3293-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OpMPL-0004sj-CV.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OpMPL-0004sj-CV 61cb2362eaaf565db8aba357850652b1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The multitouch extensions to the HID protocol allows for contact
data to be sent over several reports, which is also the case for
the 3M M2256PW touchscreen. This patch modifies the logic to only
synchronize the input layer when all contacts have been received.
Consequentially, the full 60-finger capacity of the device is enabled.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-3m-pct.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-3m-pct.c b/drivers/hid/hid-3m-pct.c
index 2a0d56b..1057430 100644
--- a/drivers/hid/hid-3m-pct.c
+++ b/drivers/hid/hid-3m-pct.c
@@ -24,6 +24,9 @@ MODULE_LICENSE("GPL");
 
 #include "hid-ids.h"
 
+#define MAX_SLOTS		60
+#define MAX_TRKID		59
+
 struct mmm_finger {
 	__s32 x, y, w, h;
 	__u8 rank;
@@ -31,8 +34,9 @@ struct mmm_finger {
 };
 
 struct mmm_data {
-	struct mmm_finger f[10];
+	struct mmm_finger f[MAX_SLOTS];
 	__u8 curid, num;
+	__u8 nexp, nreal;
 	bool touch, valid;
 };
 
@@ -93,7 +97,7 @@ static int mmm_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 					1, 1, 0, 0);
 			return 1;
 		case HID_DG_CONTACTID:
-			field->logical_maximum = 59;
+			field->logical_maximum = MAX_TRKID;
 			hid_map_usage(hi, usage, bit, max,
 					EV_ABS, ABS_MT_TRACKING_ID);
 			return 1;
@@ -133,7 +137,7 @@ static void mmm_filter_event(struct mmm_data *md, struct input_dev *input)
 	 * we need to iterate on all fingers to decide if we have a press
 	 * or a release event in our touchscreen emulation.
 	 */
-	for (i = 0; i < 10; ++i) {
+	for (i = 0; i < MAX_SLOTS; ++i) {
 		struct mmm_finger *f = &md->f[i];
 		if (!f->valid) {
 			/* this finger is just placeholder data, ignore */
@@ -190,6 +194,7 @@ static void mmm_filter_event(struct mmm_data *md, struct input_dev *input)
 	} else if (released) {
 		input_event(input, EV_KEY, BTN_TOUCH, 0);
 	}
+	input_sync(input);
 }
 
 /*
@@ -223,10 +228,12 @@ static int mmm_event(struct hid_device *hid, struct hid_field *field,
 				md->f[md->curid].h = value;
 			break;
 		case HID_DG_CONTACTID:
+			value = clamp_val(value, 0, MAX_SLOTS - 1);
 			if (md->valid) {
 				md->curid = value;
 				md->f[value].touch = md->touch;
 				md->f[value].valid = 1;
+				md->nreal++;
 			}
 			break;
 		case HID_GD_X:
@@ -238,7 +245,12 @@ static int mmm_event(struct hid_device *hid, struct hid_field *field,
 				md->f[md->curid].y = value;
 			break;
 		case HID_DG_CONTACTCOUNT:
-			mmm_filter_event(md, input);
+			if (value)
+				md->nexp = value;
+			if (md->nreal >= md->nexp) {
+				mmm_filter_event(md, input);
+				md->nreal = 0;
+			}
 			break;
 		}
 	}
@@ -255,6 +267,8 @@ static int mmm_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	int ret;
 	struct mmm_data *md;
 
+	hdev->quirks |= HID_QUIRK_NO_INPUT_SYNC;
+
 	md = kzalloc(sizeof(struct mmm_data), GFP_KERNEL);
 	if (!md) {
 		dev_err(&hdev->dev, "cannot allocate 3M data\n");
-- 
1.7.1

