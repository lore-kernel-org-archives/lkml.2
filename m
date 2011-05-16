Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab1EPMsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:48:20 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:52702 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755116Ab1EPMsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:48:19 -0400
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linus.walleij@stericsson.com>
Cc: <richard.purdie@linuxfoundation.org>, <rpurdie@rpsys.net>,
        <lee.jones@linaro.org>, <akpm@linux-foundation.org>,
        <shreshthakumar.sahu@stericsson.com>
Subject: [PATCH] leds: add regulator to lm3530 driver
Date: Mon, 16 May 2011 18:17:58 +0530
Message-ID: <1305550078-28389-1-git-send-email-shreshthakumar.sahu@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>

Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
---
 drivers/leds/leds-lm3530.c |   73 +++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 65 insertions(+), 8 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index e7089a1..6cf9925 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -17,6 +17,7 @@
 #include <linux/input.h>
 #include <linux/led-lm3530.h>
 #include <linux/types.h>
+#include <linux/regulator/consumer.h>
 
 #define LM3530_LED_DEV "lcd-backlight"
 #define LM3530_NAME "lm3530-led"
@@ -96,12 +97,18 @@ static struct lm3530_mode_map mode_map[] = {
  * @client: i2c client
  * @pdata: LM3530 platform data
  * @mode: mode of operation - manual, ALS, PWM
+ * @regulator: regulator
+ * @brighness: previous brightness value
+ * @enable: regulator is enabled
  */
 struct lm3530_data {
 	struct led_classdev led_dev;
 	struct i2c_client *client;
 	struct lm3530_platform_data *pdata;
 	enum lm3530_mode mode;
+	struct regulator *regulator;
+	enum led_brightness brightness;
+	bool enable;
 };
 
 static const u8 lm3530_reg[LM3530_REG_MAX] = {
@@ -172,7 +179,10 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 	brt_ramp = (pltfm->brt_ramp_fall << LM3530_BRT_RAMP_FALL_SHIFT) |
 			(pltfm->brt_ramp_rise << LM3530_BRT_RAMP_RISE_SHIFT);
 
-	brightness = pltfm->brt_val;
+	if (drvdata->brightness)
+		brightness = drvdata->brightness;
+	else
+		brightness = drvdata->brightness = pltfm->brt_val;
 
 	reg_val[0] = gen_config;	/* LM3530_GEN_CONFIG */
 	reg_val[1] = als_config;	/* LM3530_ALS_CONFIG */
@@ -190,6 +200,16 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 	reg_val[13] = LM3530_DEF_ZT_3;	/* LM3530_ALS_Z3T_REG */
 	reg_val[14] = LM3530_DEF_ZT_4;	/* LM3530_ALS_Z4T_REG */
 
+	if (!drvdata->enable) {
+		ret = regulator_enable(drvdata->regulator);
+		if (ret) {
+			dev_err(&drvdata->client->dev,
+					"Enable regulator failed\n");
+			return ret;
+		}
+		drvdata->enable = true;
+	}
+	
 	for (i = 0; i < LM3530_REG_MAX; i++) {
 		ret = i2c_smbus_write_byte_data(client,
 				lm3530_reg[i], reg_val[i]);
@@ -210,12 +230,31 @@ static void lm3530_brightness_set(struct led_classdev *led_cdev,
 	switch (drvdata->mode) {
 	case LM3530_BL_MODE_MANUAL:
 
+		if (!drvdata->enable) {
+			err = lm3530_init_registers(drvdata);
+			if (err) {
+				dev_err(&drvdata->client->dev,
+					"Register Init failed: %d\n", err);
+				break;
+			}
+		}
+
 		/* set the brightness in brightness control register*/
 		err = i2c_smbus_write_byte_data(drvdata->client,
 				LM3530_BRT_CTRL_REG, brt_val / 2);
 		if (err)
 			dev_err(&drvdata->client->dev,
 				"Unable to set brightness: %d\n", err);
+		else
+			drvdata->brightness = brt_val / 2;
+
+		if (brt_val == 0) {
+			err = regulator_disable(drvdata->regulator);
+			if (err)
+				dev_err(&drvdata->client->dev,
+					"Disable regulator failed\n");
+			drvdata->enable = false;
+		}
 		break;
 	case LM3530_BL_MODE_ALS:
 		break;
@@ -297,20 +336,31 @@ static int __devinit lm3530_probe(struct i2c_client *client,
 	drvdata->mode = pdata->mode;
 	drvdata->client = client;
 	drvdata->pdata = pdata;
+	drvdata->brightness = LED_OFF;
+	drvdata->enable = false;
 	drvdata->led_dev.name = LM3530_LED_DEV;
 	drvdata->led_dev.brightness_set = lm3530_brightness_set;
 
 	i2c_set_clientdata(client, drvdata);
 
-	err = lm3530_init_registers(drvdata);
-	if (err < 0) {
-		dev_err(&client->dev, "Register Init failed: %d\n", err);
-		err = -ENODEV;
-		goto err_reg_init;
+	drvdata->regulator = regulator_get(&client->dev, "vin");
+	if (IS_ERR(drvdata->regulator)) {
+		dev_err(&client->dev, "regulator get failed\n");
+		err = PTR_ERR(drvdata->regulator);
+		drvdata->regulator = NULL;
+		goto err_regulator_get;
 	}
 
-	err = led_classdev_register((struct device *)
-				      &client->dev, &drvdata->led_dev);
+	if (drvdata->pdata->brt_val) {
+		err = lm3530_init_registers(drvdata);
+		if (err < 0) {
+			dev_err(&client->dev,
+				"Register Init failed: %d\n", err);
+			err = -ENODEV;
+			goto err_reg_init;
+		}
+	}
+	err = led_classdev_register(&client->dev, &drvdata->led_dev);
 	if (err < 0) {
 		dev_err(&client->dev, "Register led class failed: %d\n", err);
 		err = -ENODEV;
@@ -330,6 +380,9 @@ err_create_file:
 	led_classdev_unregister(&drvdata->led_dev);
 err_class_register:
 err_reg_init:
+	regulator_put(drvdata->regulator);
+err_regulator_get:
+	i2c_set_clientdata(client, NULL);
 	kfree(drvdata);
 err_out:
 	return err;
@@ -340,6 +393,10 @@ static int __devexit lm3530_remove(struct i2c_client *client)
 	struct lm3530_data *drvdata = i2c_get_clientdata(client);
 
 	device_remove_file(drvdata->led_dev.dev, &dev_attr_mode);
+
+	if (drvdata->enable)
+		regulator_disable(drvdata->regulator);
+	regulator_put(drvdata->regulator);
 	led_classdev_unregister(&drvdata->led_dev);
 	kfree(drvdata);
 	return 0;
-- 
1.7.2.dirty

