Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab1C3Nxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:53:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49532 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab1C3Nxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:53:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=icRq1dytbCgGYWrO0dD9bQ0awwuzffPU3iajCm8aZ3azCzRuOVs437h4xdktrt6EQU
         CAH3SkSfY266CgBSGJZC4RB3l3dfs0ojc7nPf9+g6E5VS+cUv66qNddiyyMyW/Bd0xX3
         mfIUBjGEaICo3cbXYW5oLbM2fUmHcxC5BMu64=
From: wanlong.gao@gmail.com
To: dmitry.torokhov@gmail.com, w.sang@pengutronix.de, rpurdie@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, khali@linux-fr.org
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiaweiwei.xiyou@gmail.com, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH V2] Add the support of the touchscreen keypad of tsc2007 .
Date: Sun, 27 Mar 2011 17:46:32 +0800
Message-Id: <1301219192-5293-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

Many touchscreens support touch-keypad .
Open the definition of the TOUCHSCREEN_TSC2007_WITH_KEYPAD, you can
open the support of the touchscreen's keypad .
We can add the support of the touchscreen keypad in the driver.
In this patch , add the ts_key_pos array to determine the position
of the key's X. And the ts_key_sensitivity can use to detemine the
key's sensitivity. You can modify the ts_key_pos array for you own
touchscreen keys . And modify the ts_key_sensitivity for you own
key's sensitivity .
If you want to modify the ts_key_map, change the position of the
keys ,too.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/input/touchscreen/tsc2007.c |   48 +++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
index 80467f2..8f70fca 100644
--- a/drivers/input/touchscreen/tsc2007.c
+++ b/drivers/input/touchscreen/tsc2007.c
@@ -83,6 +83,51 @@ struct tsc2007 {
 	void			(*clear_penirq)(void);
 };
 
+/*
+#define	TOUCHSCREEN_TSC2007_WITH_KEYPAD
+*/
+#ifndef	TOUCHSCREEN_TSC2007_WITH_KEYPAD
+static void ts_key_set_capacity(struct input_dev *input) {};
+static void ts_key_up(struct input_dev *input) {};
+static void ts_key_event(struct input_dev *input, u16 x, u16 y) {};
+#else
+static int ts_key_pos[] = {700, 1650, 2550, 3500};
+static int ts_key_map[] = {KEY_MENU, KEY_HOME, KEY_BACK, KEY_SEARCH};
+/* you can modify this value to change the touch_key's sensitivity */
+static int ts_key_sensitivity = 50;
+
+static void ts_key_set_capacity(struct input_dev *input)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(ts_key_map); i++) {
+		input_set_capability(input, EV_KEY, ts_key_map[i]);
+	}
+}
+
+/* you must have an input_sync() followed this func . */
+static void ts_key_up(struct input_dev *input)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(ts_key_map); i++) {
+		input_report_key(input, ts_key_map[i], 0);
+	}
+}
+
+static void ts_key_event(struct input_dev *input, u16 x, u16 y)
+{
+	int i;
+	if (y > MAX_12BIT) {
+		for (i = 0; i < ARRAY_SIZE(ts_key_pos); i++) {
+			if ((x > (ts_key_pos[i] - ts_key_sensitivity)) &&
+				(x < (ts_key_pos[i] + ts_key_sensitivity))) {
+				input_report_key(input, ts_key_map[i], 1);
+				input_sync(input);
+			}
+		}
+	}
+}
+#endif
+
 static inline int tsc2007_xfer(struct tsc2007 *tsc, u8 cmd)
 {
 	s32 data;
@@ -149,6 +194,7 @@ static void tsc2007_send_up_event(struct tsc2007 *tsc)
 
 	input_report_key(input, BTN_TOUCH, 0);
 	input_report_abs(input, ABS_PRESSURE, 0);
+	ts_key_up(input);
 	input_sync(input);
 }
 
@@ -201,6 +247,7 @@ static void tsc2007_work(struct work_struct *work)
 		if (!ts->pendown) {
 			dev_dbg(&ts->client->dev, "DOWN\n");
 
+			ts_key_event(input, tc.x, tc.y);
 			input_report_key(input, BTN_TOUCH, 1);
 			ts->pendown = true;
 		}
@@ -308,6 +355,7 @@ static int __devinit tsc2007_probe(struct i2c_client *client,
 	input_set_abs_params(input_dev, ABS_X, 0, MAX_12BIT, 0, 0);
 	input_set_abs_params(input_dev, ABS_Y, 0, MAX_12BIT, 0, 0);
 	input_set_abs_params(input_dev, ABS_PRESSURE, 0, MAX_12BIT, 0, 0);
+	ts_key_set_capacity(input_dev);
 
 	if (pdata->init_platform_hw)
 		pdata->init_platform_hw();
-- 
1.7.3

