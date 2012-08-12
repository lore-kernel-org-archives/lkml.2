Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab2HLVk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 17:40:57 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:52517 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab2HLVj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 17:39:58 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap5OAA8iKFBV5qoUPGdsb2JhbABEhRiFI68/GQEBAQE3NIIhAQUnLxMBDxAISTkKFAYBCQmIEbY6FJEvA5s2jQY
X-IronPort-AV: E=Sophos;i="4.77,756,1336341600"; 
   d="scan'208";a="173154372"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 15/19] Input: bcm5974 - Convert to MT-B
Date: Sun, 12 Aug 2012 23:42:33 +0200
Message-Id: <1344807757-2217-16-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of the in-kernel tracking code to convert the driver to MT-B.

With ten fingers on the pad, the in-kernel tracking adds approximately
25 us to the maximum irqsoff latency. Under normal workloads, however,
the tracking has no measurable effect.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/bcm5974.c | 80 +++++++++++++++----------------------------
 1 file changed, 27 insertions(+), 53 deletions(-)

diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index fb8ec52..6fddee6 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -40,6 +40,7 @@
 #include <linux/usb/input.h>
 #include <linux/hid.h>
 #include <linux/mutex.h>
+#include <linux/input/mt.h>
 
 #define USB_VENDOR_ID_APPLE		0x05ac
 
@@ -234,6 +235,9 @@ struct bcm5974 {
 	struct bt_data *bt_data;	/* button transferred data */
 	struct urb *tp_urb;		/* trackpad usb request block */
 	u8 *tp_data;			/* trackpad transferred data */
+	const struct tp_finger *index[MAX_FINGERS];	/* finger index data */
+	struct input_mt_pos pos[MAX_FINGERS];		/* position array */
+	int slots[MAX_FINGERS];				/* slot assignments */
 };
 
 /* logical signal quality */
@@ -398,10 +402,6 @@ static void setup_events_to_report(struct input_dev *input_dev,
 {
 	__set_bit(EV_ABS, input_dev->evbit);
 
-	/* pointer emulation */
-	set_abs(input_dev, ABS_X, &cfg->w);
-	set_abs(input_dev, ABS_Y, &cfg->w);
-
 	/* finger touch area */
 	set_abs(input_dev, ABS_MT_TOUCH_MAJOR, &cfg->w);
 	set_abs(input_dev, ABS_MT_TOUCH_MINOR, &cfg->w);
@@ -415,16 +415,13 @@ static void setup_events_to_report(struct input_dev *input_dev,
 	set_abs(input_dev, ABS_MT_POSITION_Y, &cfg->y);
 
 	__set_bit(EV_KEY, input_dev->evbit);
-	__set_bit(BTN_TOUCH, input_dev->keybit);
-	__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
-	__set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
-	__set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
-	__set_bit(BTN_TOOL_QUADTAP, input_dev->keybit);
 	__set_bit(BTN_LEFT, input_dev->keybit);
 
-	__set_bit(INPUT_PROP_POINTER, input_dev->propbit);
 	if (cfg->caps & HAS_INTEGRATED_BUTTON)
 		__set_bit(INPUT_PROP_BUTTONPAD, input_dev->propbit);
+
+	input_mt_init_slots(input_dev, MAX_FINGERS,
+		INPUT_MT_POINTER | INPUT_MT_DROP_UNUSED | INPUT_MT_TRACK);
 }
 
 /* report button data as logical button state */
@@ -444,10 +441,13 @@ static int report_bt_state(struct bcm5974 *dev, int size)
 	return 0;
 }
 
-static void report_finger_data(struct input_dev *input,
-			       const struct bcm5974_config *cfg,
+static void report_finger_data(struct input_dev *input, int slot,
+			       const struct input_mt_pos *pos,
 			       const struct tp_finger *f)
 {
+	input_mt_slot(input, slot);
+	input_mt_report_slot_state(input, MT_TOOL_FINGER, true);
+
 	input_report_abs(input, ABS_MT_TOUCH_MAJOR,
 			 raw2int(f->touch_major) << 1);
 	input_report_abs(input, ABS_MT_TOUCH_MINOR,
@@ -458,10 +458,8 @@ static void report_finger_data(struct input_dev *input,
 			 raw2int(f->tool_minor) << 1);
 	input_report_abs(input, ABS_MT_ORIENTATION,
 			 MAX_FINGER_ORIENTATION - raw2int(f->orientation));
-	input_report_abs(input, ABS_MT_POSITION_X, raw2int(f->abs_x));
-	input_report_abs(input, ABS_MT_POSITION_Y,
-			 cfg->y.min + cfg->y.max - raw2int(f->abs_y));
-	input_mt_sync(input);
+	input_report_abs(input, ABS_MT_POSITION_X, pos->x);
+	input_report_abs(input, ABS_MT_POSITION_Y, pos->y);
 }
 
 /* report trackpad data as logical trackpad state */
@@ -470,8 +468,7 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 	const struct bcm5974_config *c = &dev->cfg;
 	const struct tp_finger *f;
 	struct input_dev *input = dev->input;
-	int raw_p, raw_x, raw_y, raw_n, i;
-	int abs_x = 0, abs_y = 0, n = 0;
+	int raw_n, i, n = 0;
 
 	if (size < c->tp_offset || (size - c->tp_offset) % SIZEOF_FINGER != 0)
 		return -EIO;
@@ -480,44 +477,21 @@ static int report_tp_state(struct bcm5974 *dev, int size)
 	f = (const struct tp_finger *)(dev->tp_data + c->tp_offset);
 	raw_n = (size - c->tp_offset) / SIZEOF_FINGER;
 
-	/* always track the first finger; when detached, start over */
-	if (raw_n) {
-
-		/* report raw trackpad data */
-		for (i = 0; i < raw_n; i++)
-			report_finger_data(input, c, &f[i]);
-
-		raw_p = raw2int(f->touch_major);
-		raw_x = raw2int(f->abs_x);
-		raw_y = raw2int(f->abs_y);
-
-		dprintk(9,
-			"bcm5974: "
-			"raw: p: %+05d x: %+05d y: %+05d n: %d\n",
-			raw_p, raw_x, raw_y, raw_n);
-
-		/* while tracking finger still valid, count all fingers */
-		if (raw_p > 0 && raw2int(f->origin)) {
-			abs_x = raw_x;
-			abs_y = c->y.min + c->y.max - raw_y;
-			while (raw_n--) {
-				if (raw2int(f->touch_major) > 0)
-					n++;
-				f++;
-			}
-		}
+	for (i = 0; i < raw_n; i++) {
+		if (raw2int(f[i].touch_major) == 0)
+			continue;
+		dev->pos[n].x = raw2int(f[i].abs_x);
+		dev->pos[n].y = c->y.min + c->y.max - raw2int(f[i].abs_y);
+		dev->index[n++] = &f[i];
 	}
 
-	input_report_key(input, BTN_TOUCH, n > 0);
-	input_report_key(input, BTN_TOOL_FINGER, n == 1);
-	input_report_key(input, BTN_TOOL_DOUBLETAP, n == 2);
-	input_report_key(input, BTN_TOOL_TRIPLETAP, n == 3);
-	input_report_key(input, BTN_TOOL_QUADTAP, n > 3);
+	input_mt_assign_slots(input, dev->slots, dev->pos, n);
 
-	if (n > 0) {
-		input_report_abs(input, ABS_X, abs_x);
-		input_report_abs(input, ABS_Y, abs_y);
-	}
+	for (i = 0; i < n; i++)
+		report_finger_data(input, dev->slots[i],
+				   &dev->pos[i], dev->index[i]);
+
+	input_mt_sync_frame(input);
 
 	/* type 2 reports button events via ibt only */
 	if (c->tp_type == TYPE2) {
-- 
1.7.11.4

