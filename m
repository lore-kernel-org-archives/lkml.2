Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1FBQAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 12:00:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64852 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab1FBQAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 12:00:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Nb9tysMA/5eAjy+By7hSQ/+PDDXtf5v/iBcPH1MDOZFFF3rIpH30j47LzCzlc+FYXZ
         8tk/OYlyr3qowkByWIQgJ45X+T543ZOirgWcAehUiehtWcwT2V7o+UY6F1pX3YPYI9LN
         2Hqofnhx+rqvGhZzvTbNUUPZlOtVHnFVYMJcU=
From: Johannes Obermaier <johannes.obermaier@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Obermaier <johannes.obermaier@gmail.com>
Subject: [PATCH 3/3] V4L/DVB: mt9v011: Fixed gain calculation
Date: Thu,  2 Jun 2011 18:03:41 +0200
Message-Id: <1307030621-30701-1-git-send-email-johannes.obermaier@gmail.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This patch must be used AFTER the patch "V4L/DVB: mt9v011: Added exposure for mt9v011")
The implementation of the gain calculation for this sensor is incorrect. It is only working for the first 127 values.
The reason is, that the gain cannot be set directly by writing a value into the gain registers of the sensor. The gain register work this way (see datasheet page 24): bits 0 to 6 are called "initial gain". These are linear. But bits 7 and 8 ("analog multiplicative factors") and bits 9 and 10 ("digital multiplicative factors") work completely different: Each of these bits increase the gain by the factor 2. So if the bits 7-10 are 0011, 0110, 1100 or 0101 for example, the gain from bits 0-6 is multiplied by 4. The order of the bits 7-10 is not important for the resulting gain. (But there are some recommended values for low noise)
The current driver doesn't do this correctly: If the current gain is 000 0111 1111 (127) and the gain is increased by 1, you would expect the image to become brighter. But the image is completly dark, because the new gain is 000 1000 0000 (128). This means: Initial gain of 0, multiplied by 2. The result is 0.
This patch adds a new function which does the gain calculation and also fixes the same bug for red_balance and blue_balance. Additionally, the driver follows the recommendation from the datasheet, which says, that the gain should always be above 0x0020.

Signed-off-by: Johannes Obermaier <johannes.obermaier@gmail.com>
---
 drivers/media/video/mt9v011.c |   63 +++++++++++++++++++++++++++++++++-------
 1 files changed, 52 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/mt9v011.c b/drivers/media/video/mt9v011.c
index fbbd018..893a8b8 100644
--- a/drivers/media/video/mt9v011.c
+++ b/drivers/media/video/mt9v011.c
@@ -54,7 +54,7 @@ static struct v4l2_queryctrl mt9v011_qctrl[] = {
 		.type = V4L2_CTRL_TYPE_INTEGER,
 		.name = "Gain",
 		.minimum = 0,
-		.maximum = (1 << 10) - 1,
+		.maximum = (1 << 12) - 1 - 0x0020,
 		.step = 1,
 		.default_value = 0x0020,
 		.flags = 0,
@@ -114,7 +114,8 @@ struct mt9v011 {
 	unsigned hflip:1;
 	unsigned vflip:1;
 
-	u16 global_gain, exposure, red_bal, blue_bal;
+	u16 global_gain, exposure;
+	s16 red_bal, blue_bal;
 };
 
 static inline struct mt9v011 *to_mt9v011(struct v4l2_subdev *sd)
@@ -189,25 +190,65 @@ static const struct i2c_reg_value mt9v011_init_default[] = {
 		{ R07_MT9V011_OUT_CTRL, 0x0002 },	/* chip enable */
 };
 
+
+static u16 calc_mt9v011_gain(s16 lineargain)
+{
+
+	u16 digitalgain = 0;
+	u16 analogmult = 0;
+	u16 analoginit = 0;
+
+	if (lineargain < 0)
+		lineargain = 0;
+
+	/* recommended minimum */
+	lineargain += 0x0020;
+
+	if (lineargain > 2047)
+		lineargain = 2047;
+
+	if (lineargain > 1023) {
+		digitalgain = 3;
+		analogmult = 3;
+		analoginit = lineargain / 16;
+	} else if (lineargain > 511) {
+		digitalgain = 1;
+		analogmult = 3;
+		analoginit = lineargain / 8;
+	} else if (lineargain > 255) {
+		analogmult = 3;
+		analoginit = lineargain / 4;
+	} else if (lineargain > 127) {
+		analogmult = 1;
+		analoginit = lineargain / 2;
+	} else
+		analoginit = lineargain;
+
+	return analoginit + (analogmult << 7) + (digitalgain << 9);
+
+}
+
 static void set_balance(struct v4l2_subdev *sd)
 {
 	struct mt9v011 *core = to_mt9v011(sd);
-	u16 green1_gain, green2_gain, blue_gain, red_gain;
+	u16 green_gain, blue_gain, red_gain;
 	u16 exposure;
+	s16 bal;
 
 	exposure = core->exposure;
 
-	green1_gain = core->global_gain;
-	green2_gain = core->global_gain;
+	green_gain = calc_mt9v011_gain(core->global_gain);
 
-	blue_gain = core->global_gain +
-		    core->global_gain * core->blue_bal / (1 << 9);
+	bal = core->global_gain;
+	bal += (core->blue_bal * core->global_gain / (1 << 7));
+	blue_gain = calc_mt9v011_gain(bal);
 
-	red_gain = core->global_gain +
-		   core->global_gain * core->blue_bal / (1 << 9);
+	bal = core->global_gain;
+	bal += (core->red_bal * core->global_gain / (1 << 7));
+	red_gain = calc_mt9v011_gain(bal);
 
-	mt9v011_write(sd, R2B_MT9V011_GREEN_1_GAIN, green1_gain);
-	mt9v011_write(sd, R2E_MT9V011_GREEN_2_GAIN,  green1_gain);
+	mt9v011_write(sd, R2B_MT9V011_GREEN_1_GAIN, green_gain);
+	mt9v011_write(sd, R2E_MT9V011_GREEN_2_GAIN, green_gain);
 	mt9v011_write(sd, R2C_MT9V011_BLUE_GAIN, blue_gain);
 	mt9v011_write(sd, R2D_MT9V011_RED_GAIN, red_gain);
 	mt9v011_write(sd, R09_MT9V011_SHUTTER_WIDTH, exposure);
-- 
1.6.4.2

