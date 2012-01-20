Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab2ATBso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 20:48:44 -0500
Received: from mail2.nsc.com ([12.238.8.132]:52601 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755325Ab2ATBsn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 20:48:43 -0500
X-WSS-ID: 0LY2QD4-0A-FEC-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Date: Thu, 19 Jan 2012 17:48:24 -0800
Subject: [PATCH 3/7] leds-lm3530: add 'is_vin_always_on' in the
 lm3530_platform_data
Thread-Topic: [PATCH 3/7] leds-lm3530: add 'is_vin_always_on' in the
 lm3530_platform_data
Thread-Index: AczXFZjmtQHOiXDCSJi9Lr1dSJlaCQ==
Message-ID: <B567DBAB974C0544994013492B949F8E3812C6D0CD@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 630618611LS9809963-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'IN' pin(Input voltage connection) can be always turned on
in case it is connected with VBATT.
To support this case, 'is_vin_always_on' is added.
If VIN is always on, then we don't need to control the regulator for IN pin.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 963a1db..ba2bb7e 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -200,7 +200,7 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 	reg_val[13] = LM3530_DEF_ZT_3;	/* LM3530_ALS_Z3T_REG */
 	reg_val[14] = LM3530_DEF_ZT_4;	/* LM3530_ALS_Z4T_REG */
 
-	if (!drvdata->enable) {
+	if (!drvdata->enable && !pltfm->is_vin_always_on) {
 		ret = regulator_enable(drvdata->regulator);
 		if (ret) {
 			dev_err(&drvdata->client->dev,
@@ -256,7 +256,7 @@ static void lm3530_brightness_set(struct led_classdev *led_cdev,
 		else
 			drvdata->brightness = brt_val / 2;
 
-		if (brt_val == 0) {
+		if (brt_val == 0 && !pdata->is_vin_always_on) {
 			err = regulator_disable(drvdata->regulator);
 			if (err)
 				dev_err(&drvdata->client->dev,
@@ -340,18 +340,20 @@ static int __devinit lm3530_probe(struct i2c_client *client,
 	drvdata->client = client;
 	drvdata->pdata = pdata;
 	drvdata->brightness = LED_OFF;
-	drvdata->enable = false;
+	drvdata->enable = pdata->is_vin_always_on;
 	drvdata->led_dev.name = pdata->name ? pdata->name : LM3530_LED_DEV;
 	drvdata->led_dev.brightness_set = lm3530_brightness_set;
 
 	i2c_set_clientdata(client, drvdata);
 
-	drvdata->regulator = regulator_get(&client->dev, "vin");
-	if (IS_ERR(drvdata->regulator)) {
-		dev_err(&client->dev, "regulator get failed\n");
-		err = PTR_ERR(drvdata->regulator);
-		drvdata->regulator = NULL;
-		goto err_regulator_get;
+	if (!drvdata->enable) {
+		drvdata->regulator = regulator_get(&client->dev, "vin");
+		if (IS_ERR(drvdata->regulator)) {
+			dev_err(&client->dev, "regulator get failed\n");
+			err = PTR_ERR(drvdata->regulator);
+			drvdata->regulator = NULL;
+			goto err_regulator_get;
+		}
 	}
 
 	if (drvdata->pdata->brt_val) {
@@ -394,10 +396,11 @@ err_out:
 static int __devexit lm3530_remove(struct i2c_client *client)
 {
 	struct lm3530_data *drvdata = i2c_get_clientdata(client);
+	struct lm3530_platform_data *pdata = drvdata->pdata;
 
 	device_remove_file(drvdata->led_dev.dev, &dev_attr_mode);
 
-	if (drvdata->enable)
+	if (drvdata->enable && !pdata->is_vin_always_on)
 		regulator_disable(drvdata->regulator);
 	regulator_put(drvdata->regulator);
 	led_classdev_unregister(&drvdata->led_dev);
diff --git a/include/linux/led-lm3530.h b/include/linux/led-lm3530.h
index 513e9c3..0240204 100644
--- a/include/linux/led-lm3530.h
+++ b/include/linux/led-lm3530.h
@@ -92,6 +92,8 @@ struct lm3530_pwm_data {
  * @als2_resistor_sel: internal resistance from ALS2 input to ground
  * @brt_val: brightness value (0-255)
  * @name: led device name
+ * @is_vin_always_on: set to true if VIN is always on.
+ *		      ex) VIN is connected with VBATT
  * @pwm_data: PWM control functions. only valid when the mode is PWM.
  */
 struct lm3530_platform_data {
@@ -112,6 +114,7 @@ struct lm3530_platform_data {
 	u8 brt_val;
 
 	const char *name;
+	bool is_vin_always_on;
 	struct lm3530_pwm_data pwm_data;
 };
 
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated

