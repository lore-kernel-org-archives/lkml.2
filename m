Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab1C3NgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:36:17 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46958 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1C3NgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:36:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=J7eSnk9kfpSi1EJMYRwHTWlhCEe2+DJENRQZHsVV2Hh6pNyRNeW0up/ER7fdrks2vl
         cwlTRZnPDvGTHbH0aEtaIYBpvp62Jh9cMqPRwGeUrO7n1mwkLXgFKtPLuPhMFf+5wwKi
         4KAUjpJbrks/Ac2uODNdQLr4NtCJbproW6qWQ=
From: wanlong.gao@gmail.com
To: dmitry.torokhov@gmail.com, w.sang@pengutronix.de, rpurdie@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, khali@linux-fr.org
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiaweiwei.xiyou@gmail.com, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] Add the support of the touchscreen keypad of tsc2007 .
Date: Sun, 27 Mar 2011 17:29:22 +0800
Message-Id: <1301218162-5210-1-git-send-email-wanlong.gao@gmail.com>
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
 drivers/input/touchscreen/tsc2007.c |   47 +++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
index 80467f2..496369f 100644
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
-- 
1.7.3

