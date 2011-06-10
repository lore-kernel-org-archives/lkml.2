Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1FJIAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:00:51 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:59561 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752685Ab1FJIAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:00:49 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Richard Purdie <rpurdie@rpsys.net>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/2] leds/lm3530: calibrate ALS input voltage
Date: Fri, 10 Jun 2011 10:00:17 +0200
Message-ID: <1307692817-15602-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>

This patch provides the support for auto calibration of ALS Zone
boundaries based on min/max ALS input voltage.

Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/leds/leds-lm3530.c |   67 ++++++++++++++++++++++++++++++++++---------
 include/linux/led-lm3530.h |    5 +++
 2 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 4d7ce76..3dd7090 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -68,17 +68,16 @@
 #define LM3530_ALS2_IMP_SHIFT		(4)
 
 /* Zone Boundary Register defaults */
-#define LM3530_DEF_ZB_0			(0x33)
-#define LM3530_DEF_ZB_1			(0x66)
-#define LM3530_DEF_ZB_2			(0x99)
-#define LM3530_DEF_ZB_3			(0xCC)
+#define LM3530_ALS_ZB_MAX		(4)
+#define LM3530_ALS_WINDOW_mV		(1000)
+#define LM3530_ALS_OFFSET_mV		(4)
 
 /* Zone Target Register defaults */
-#define LM3530_DEF_ZT_0			(0x19)
-#define LM3530_DEF_ZT_1			(0x33)
+#define LM3530_DEF_ZT_0			(0x7F)
+#define LM3530_DEF_ZT_1			(0x66)
 #define LM3530_DEF_ZT_2			(0x4C)
-#define LM3530_DEF_ZT_3			(0x66)
-#define LM3530_DEF_ZT_4			(0x7F)
+#define LM3530_DEF_ZT_3			(0x33)
+#define LM3530_DEF_ZT_4			(0x19)
 
 struct lm3530_mode_map {
 	const char *mode;
@@ -150,6 +149,8 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 	u8 als_imp_sel = 0;
 	u8 brightness;
 	u8 reg_val[LM3530_REG_MAX];
+	u8 zones[LM3530_ALS_ZB_MAX];
+	u32 als_vmin, als_vmax, als_vstep;
 	struct lm3530_platform_data *pltfm = drvdata->pdata;
 	struct i2c_client *client = drvdata->client;
 
@@ -161,6 +162,26 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 		gen_config |= (LM3530_ENABLE_I2C);
 
 	if (drvdata->mode == LM3530_BL_MODE_ALS) {
+		if (pltfm->als_vmax == 0) {
+			pltfm->als_vmin = als_vmin = 0;
+			pltfm->als_vmin = als_vmax = LM3530_ALS_WINDOW_mV;
+		}
+
+		als_vmin = pltfm->als_vmin;
+		als_vmax = pltfm->als_vmax;
+
+		if ((als_vmax - als_vmin) > LM3530_ALS_WINDOW_mV)
+			pltfm->als_vmax = als_vmax =
+				als_vmin + LM3530_ALS_WINDOW_mV;
+
+		/* n zone boundary makes n+1 zones */
+		als_vstep = (als_vmax - als_vmin) / (LM3530_ALS_ZB_MAX + 1);
+
+		for (i = 0; i < LM3530_ALS_ZB_MAX; i++)
+			zones[i] = (((als_vmin + LM3530_ALS_OFFSET_mV) +
+					als_vstep + (i * als_vstep)) * LED_FULL)
+					/ 1000;
+
 		als_config =
 			(pltfm->als_avrg_time << LM3530_ALS_AVG_TIME_SHIFT) |
 			(LM3530_ENABLE_ALS) |
@@ -169,6 +190,7 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 		als_imp_sel =
 			(pltfm->als1_resistor_sel << LM3530_ALS1_IMP_SHIFT) |
 			(pltfm->als2_resistor_sel << LM3530_ALS2_IMP_SHIFT);
+
 	}
 
 	if (drvdata->mode == LM3530_BL_MODE_PWM)
@@ -190,10 +212,10 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 	reg_val[3] = 0x00;		/* LM3530_ALS_ZONE_REG */
 	reg_val[4] = als_imp_sel;	/* LM3530_ALS_IMP_SELECT */
 	reg_val[5] = brightness;	/* LM3530_BRT_CTRL_REG */
-	reg_val[6] = LM3530_DEF_ZB_0;	/* LM3530_ALS_ZB0_REG */
-	reg_val[7] = LM3530_DEF_ZB_1;	/* LM3530_ALS_ZB1_REG */
-	reg_val[8] = LM3530_DEF_ZB_2;	/* LM3530_ALS_ZB2_REG */
-	reg_val[9] = LM3530_DEF_ZB_3;	/* LM3530_ALS_ZB3_REG */
+	reg_val[6] = zones[0];		/* LM3530_ALS_ZB0_REG */
+	reg_val[7] = zones[1];		/* LM3530_ALS_ZB1_REG */
+	reg_val[8] = zones[2];		/* LM3530_ALS_ZB2_REG */
+	reg_val[9] = zones[3];		/* LM3530_ALS_ZB3_REG */
 	reg_val[10] = LM3530_DEF_ZT_0;	/* LM3530_ALS_Z0T_REG */
 	reg_val[11] = LM3530_DEF_ZT_1;	/* LM3530_ALS_Z1T_REG */
 	reg_val[12] = LM3530_DEF_ZT_2;	/* LM3530_ALS_Z2T_REG */
@@ -265,6 +287,24 @@ static void lm3530_brightness_set(struct led_classdev *led_cdev,
 	}
 }
 
+static ssize_t lm3530_mode_get(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client = container_of(
+					dev->parent, struct i2c_client, dev);
+	struct lm3530_data *drvdata = i2c_get_clientdata(client);
+	int i, len = 0;
+
+	for (i = 0; i < ARRAY_SIZE(mode_map); i++)
+		if (drvdata->mode == mode_map[i].mode_val)
+			len += sprintf(buf + len, "[%s] ", mode_map[i].mode);
+		else
+			len += sprintf(buf + len, "%s ", mode_map[i].mode);
+
+	len += sprintf(buf + len, "\n");
+
+	return len;
+}
 
 static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
 				   *attr, const char *buf, size_t size)
@@ -298,8 +338,7 @@ static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
 
 	return sizeof(drvdata->mode);
 }
-
-static DEVICE_ATTR(mode, 0644, NULL, lm3530_mode_set);
+static DEVICE_ATTR(mode, 0644, lm3530_mode_get, lm3530_mode_set);
 
 static int __devinit lm3530_probe(struct i2c_client *client,
 			   const struct i2c_device_id *id)
diff --git a/include/linux/led-lm3530.h b/include/linux/led-lm3530.h
index 58592fa..8eb1235 100644
--- a/include/linux/led-lm3530.h
+++ b/include/linux/led-lm3530.h
@@ -84,6 +84,8 @@ enum lm3530_als_mode {
  * @brt_ramp_rise: rate of rise of led current
  * @als1_resistor_sel: internal resistance from ALS1 input to ground
  * @als2_resistor_sel: internal resistance from ALS2 input to ground
+ * @als_vmin: als input voltage calibrated for max brightness in mV
+ * @als_vmax: als input voltage calibrated for min brightness in mV
  * @brt_val: brightness value (0-255)
  */
 struct lm3530_platform_data {
@@ -101,6 +103,9 @@ struct lm3530_platform_data {
 	u8 als1_resistor_sel;
 	u8 als2_resistor_sel;
 
+	u32 als_vmin;
+	u32 als_vmax;
+
 	u8 brt_val;
 };
 
-- 
1.7.3.2

