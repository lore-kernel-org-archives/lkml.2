Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab2FRELG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 00:11:06 -0400
Received: from mail-bk0-f74.google.com ([209.85.214.74]:45518 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2FREIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 00:08:51 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 17/22 v4] Input: atmel_mxt_ts - simplify event reporting
Date: Mon, 18 Jun 2012 12:08:37 +0800
Message-Id: <1339992522-22073-18-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
References: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of carrying around per-finger state in the driver instance, just
report each finger as it arrives to the input layer, and let the input
layer (evdev) hold the event state (which it does anyway).

Note: this driver does not really do MT-B properly. Each input report
(a group of input events followed by a SYN_REPORT) only contains data for
a single contact.  When multiple fingers are present on a device, each is
properly reported in its own MT_SLOT.  However, there is only ever one
MT_SLOT per SYN_REPORT.  This is fixed in a subsequent patch.

This patch was tested with an mXT224E.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   89 ++++-------------------------
 1 files changed, 13 insertions(+), 76 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 0d769de..02ff914 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -239,14 +239,6 @@ struct mxt_message {
 	u8 message[7];
 };
 
-struct mxt_finger {
-	int status;
-	int x;
-	int y;
-	int area;
-	int pressure;
-};
-
 /* Each client has this additional data */
 struct mxt_data {
 	struct i2c_client *client;
@@ -254,7 +246,6 @@ struct mxt_data {
 	const struct mxt_platform_data *pdata;
 	struct mxt_object *object_table;
 	struct mxt_info info;
-	struct mxt_finger finger[MXT_MAX_FINGER];
 	unsigned int irq;
 	unsigned int max_x;
 	unsigned int max_y;
@@ -512,75 +503,17 @@ static int mxt_write_object(struct mxt_data *data,
 	return mxt_write_reg(data->client, reg + offset, val);
 }
 
-static void mxt_input_report(struct mxt_data *data, int single_id)
-{
-	struct mxt_finger *finger = data->finger;
-	struct input_dev *input_dev = data->input_dev;
-	int status = finger[single_id].status;
-	int finger_num = 0;
-	int id;
-
-	for (id = 0; id < MXT_MAX_FINGER; id++) {
-		if (!finger[id].status)
-			continue;
-
-		input_mt_slot(input_dev, id);
-		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER,
-				finger[id].status != MXT_RELEASE);
-
-		if (finger[id].status != MXT_RELEASE) {
-			finger_num++;
-			input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR,
-					finger[id].area);
-			input_report_abs(input_dev, ABS_MT_POSITION_X,
-					finger[id].x);
-			input_report_abs(input_dev, ABS_MT_POSITION_Y,
-					finger[id].y);
-			input_report_abs(input_dev, ABS_MT_PRESSURE,
-					finger[id].pressure);
-		} else {
-			finger[id].status = 0;
-		}
-	}
-
-	input_report_key(input_dev, BTN_TOUCH, finger_num > 0);
-
-	if (status != MXT_RELEASE) {
-		input_report_abs(input_dev, ABS_X, finger[single_id].x);
-		input_report_abs(input_dev, ABS_Y, finger[single_id].y);
-		input_report_abs(input_dev,
-				 ABS_PRESSURE, finger[single_id].pressure);
-	}
-
-	input_sync(input_dev);
-}
-
 static void mxt_input_touchevent(struct mxt_data *data,
 				      struct mxt_message *message, int id)
 {
-	struct mxt_finger *finger = data->finger;
 	struct device *dev = &data->client->dev;
 	u8 status = message->message[0];
+	struct input_dev *input_dev = data->input_dev;
 	int x;
 	int y;
 	int area;
 	int pressure;
 
-	/* Check the touch is present on the screen */
-	if (!(status & MXT_DETECT)) {
-		if (status & MXT_RELEASE) {
-			dev_dbg(dev, "[%d] released\n", id);
-
-			finger[id].status = MXT_RELEASE;
-			mxt_input_report(data, id);
-		}
-		return;
-	}
-
-	/* Check only AMP detection */
-	if (!(status & (MXT_PRESS | MXT_MOVE)))
-		return;
-
 	x = (message->message[1] << 4) | ((message->message[3] >> 4) & 0xf);
 	y = (message->message[2] << 4) | ((message->message[3] & 0xf));
 	if (data->max_x < 1024)
@@ -594,15 +527,19 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	dev_dbg(dev, "[%d] %s x: %d, y: %d, area: %d\n", id,
 		status & MXT_MOVE ? "moved" : "pressed",
 		x, y, area);
+	input_mt_slot(input_dev, id);
+	input_mt_report_slot_state(input_dev, MT_TOOL_FINGER,
+				   status & MXT_DETECT);
+
+	if (status & MXT_DETECT) {
+		input_report_abs(input_dev, ABS_MT_POSITION_X, x);
+		input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
+		input_report_abs(input_dev, ABS_MT_PRESSURE, pressure);
+		input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR, area);
+	}
 
-	finger[id].status = status & MXT_MOVE ?
-				MXT_MOVE : MXT_PRESS;
-	finger[id].x = x;
-	finger[id].y = y;
-	finger[id].area = area;
-	finger[id].pressure = pressure;
-
-	mxt_input_report(data, id);
+	input_mt_report_pointer_emulation(input_dev, false);
+	input_sync(input_dev);
 }
 
 static irqreturn_t mxt_interrupt(int irq, void *dev_id)
-- 
1.7.7.3

