Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab0EANuT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 09:50:19 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:49833 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672Ab0EANuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 09:50:16 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/3] input: mt: Simplify event bypass logic
Date: Sat,  1 May 2010 15:49:39 +0200
Message-Id: <1272721779-2124-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1O8D4o-00081z-4y.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1O8D4o-00081z-4y dd46768303e124e0235236be5bf2af16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The input bypass mechanism is only used by the MT events. Since all
MT events use bypassing by construction, the current list is a mere
duplication of input.h. This patch replaces the bypass list by a
simple range test.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input.c |   31 +------------------------------
 include/linux/input.h |    3 +++
 2 files changed, 4 insertions(+), 30 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 9c79bd5..187dd8b 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -33,25 +33,6 @@ MODULE_LICENSE("GPL");
 
 #define INPUT_DEVICES	256
 
-/*
- * EV_ABS events which should not be cached are listed here.
- */
-static unsigned int input_abs_bypass_init_data[] __initdata = {
-	ABS_MT_TOUCH_MAJOR,
-	ABS_MT_TOUCH_MINOR,
-	ABS_MT_WIDTH_MAJOR,
-	ABS_MT_WIDTH_MINOR,
-	ABS_MT_ORIENTATION,
-	ABS_MT_POSITION_X,
-	ABS_MT_POSITION_Y,
-	ABS_MT_TOOL_TYPE,
-	ABS_MT_BLOB_ID,
-	ABS_MT_TRACKING_ID,
-	ABS_MT_PRESSURE,
-	0
-};
-static unsigned long input_abs_bypass[BITS_TO_LONGS(ABS_CNT)];
-
 static LIST_HEAD(input_dev_list);
 static LIST_HEAD(input_handler_list);
 
@@ -235,7 +216,7 @@ static void input_handle_event(struct input_dev *dev,
 	case EV_ABS:
 		if (is_event_supported(code, dev->absbit, ABS_MAX)) {
 
-			if (test_bit(code, input_abs_bypass)) {
+			if (code >= ABS_MT_MIN && code <= ABS_MT_MAX) {
 				disposition = INPUT_PASS_TO_HANDLERS;
 				break;
 			}
@@ -1926,20 +1907,10 @@ static const struct file_operations input_fops = {
 	.open = input_open_file,
 };
 
-static void __init input_init_abs_bypass(void)
-{
-	const unsigned int *p;
-
-	for (p = input_abs_bypass_init_data; *p; p++)
-		input_abs_bypass[BIT_WORD(*p)] |= BIT_MASK(*p);
-}
-
 static int __init input_init(void)
 {
 	int err;
 
-	input_init_abs_bypass();
-
 	err = class_register(&input_class);
 	if (err) {
 		printk(KERN_ERR "input: unable to register input_dev class\n");
diff --git a/include/linux/input.h b/include/linux/input.h
index 7ed2251..d4ad53f 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -706,6 +706,9 @@ struct input_absinfo {
 #define ABS_MT_TRACKING_ID	0x39	/* Unique ID of initiated contact */
 #define ABS_MT_PRESSURE		0x3a	/* Pressure on contact area */
 
+#define ABS_MT_MIN		0x30
+#define ABS_MT_MAX		0x3a
+
 #define ABS_MAX			0x3f
 #define ABS_CNT			(ABS_MAX+1)
 
-- 
1.6.3.3

