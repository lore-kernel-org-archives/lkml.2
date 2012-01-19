Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab2ASEgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 23:36:45 -0500
Received: from mail2.nsc.com ([12.238.8.132]:34042 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752752Ab2ASEgn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 23:36:43 -0500
X-WSS-ID: 0LY13H4-0A-1CM-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "D.Murphy@motorola.com" <D.Murphy@motorola.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Date: Wed, 18 Jan 2012 20:36:33 -0800
Subject: [PATCH] leds-lm3530: support pwm input mode and add platform
 data
Thread-Topic: [PATCH] leds-lm3530: support pwm input mode and add
 platform data
Thread-Index: AczWY1QKSavtV3udQ1efAf7wr0xvgQAABeiw
Message-ID: <B567DBAB974C0544994013492B949F8E3812C6CB35@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6309425E1LS9784552-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(a) support pwm control mode
  (1) add 'struct lm3530_pwm_data' in the platform data
  The pwm data is the platform specific functions which generate the pwm.
  The pwm data is only valid when brightness is pwm input mode.
  Functions should be implemented by the pwm driver.
  pwm_set_intensity() : set duty of pwm.
  pwm_get_intensity() : get current duty of pwm.

  (2) brightness control by pwm
  If the control mode is pwm, then brightness is changed by the duty of pwm.
  So pwm platform function should be called in lm3530_brightness_set().

  (3) do not update brightness register when pwm input mode
  In pwm input mode, brightness register is not used.
  If any value is updated in this register, then the led will be off.

(b) add 'name' in the lm3530_platform_data
  : The led device name can be configurable.
  For the compatibility, the name is set to default value(LM3530_LED_DEV)
  when 'name' is not defined.

(c) add 'is_vin_always_on' in the lm3530_platform_data
  : The 'IN' pin(Input voltage connection) can be always turned on
  in case it is connected with VBATT.
  To support this case, 'is_vin_always_on' is added.
  If VIN is always on, then we don't need to control the regulator for IN pin.

(d) add 'lm3530_mode_get()' in the lm3530 device attribute
  : To get information about brightness control mode.

(e) use 'struct led_classdev' rather than 'struct i2c_client'
  to get members of lm3530_data
  : in lm3530_mode_set()

(f) use 'pdata' rather than 'pltfm' in lm3530_init_registers()

(g) for less arithmetic operation, replace 'divide-by-2' with
  'shift-right-by 1 bit'
  : in lm3530_brightness_set()

* patched based on kernel 3.0.1

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lm3530.c |   93 ++++++++++++++++++++++++++------------------
 include/linux/led-lm3530.h |   14 +++++++
 2 files changed, 69 insertions(+), 38 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 4d7ce76..6df636f 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -150,11 +150,11 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 	u8 als_imp_sel = 0;
 	u8 brightness;
 	u8 reg_val[LM3530_REG_MAX];
-	struct lm3530_platform_data *pltfm = drvdata->pdata;
+	struct lm3530_platform_data *pdata = drvdata->pdata;
 	struct i2c_client *client = drvdata->client;
 
-	gen_config = (pltfm->brt_ramp_law << LM3530_RAMP_LAW_SHIFT) |
-			((pltfm->max_current & 7) << LM3530_MAX_CURR_SHIFT);
+	gen_config = (pdata->brt_ramp_law << LM3530_RAMP_LAW_SHIFT) |
+			((pdata->max_current & 7) << LM3530_MAX_CURR_SHIFT);
 
 	if (drvdata->mode == LM3530_BL_MODE_MANUAL ||
 	    drvdata->mode == LM3530_BL_MODE_ALS)
@@ -162,27 +162,27 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 
 	if (drvdata->mode == LM3530_BL_MODE_ALS) {
 		als_config =
-			(pltfm->als_avrg_time << LM3530_ALS_AVG_TIME_SHIFT) |
+			(pdata->als_avrg_time << LM3530_ALS_AVG_TIME_SHIFT) |
 			(LM3530_ENABLE_ALS) |
-			(pltfm->als_input_mode << LM3530_ALS_SEL_SHIFT);
+			(pdata->als_input_mode << LM3530_ALS_SEL_SHIFT);
 
 		als_imp_sel =
-			(pltfm->als1_resistor_sel << LM3530_ALS1_IMP_SHIFT) |
-			(pltfm->als2_resistor_sel << LM3530_ALS2_IMP_SHIFT);
+			(pdata->als1_resistor_sel << LM3530_ALS1_IMP_SHIFT) |
+			(pdata->als2_resistor_sel << LM3530_ALS2_IMP_SHIFT);
 	}
 
 	if (drvdata->mode == LM3530_BL_MODE_PWM)
 		gen_config |= (LM3530_ENABLE_PWM) |
-				(pltfm->pwm_pol_hi << LM3530_PWM_POL_SHIFT) |
+				(pdata->pwm_pol_hi << LM3530_PWM_POL_SHIFT) |
 				(LM3530_ENABLE_PWM_SIMPLE);
 
-	brt_ramp = (pltfm->brt_ramp_fall << LM3530_BRT_RAMP_FALL_SHIFT) |
-			(pltfm->brt_ramp_rise << LM3530_BRT_RAMP_RISE_SHIFT);
+	brt_ramp = (pdata->brt_ramp_fall << LM3530_BRT_RAMP_FALL_SHIFT) |
+			(pdata->brt_ramp_rise << LM3530_BRT_RAMP_RISE_SHIFT);
 
 	if (drvdata->brightness)
 		brightness = drvdata->brightness;
 	else
-		brightness = drvdata->brightness = pltfm->brt_val;
+		brightness = drvdata->brightness = pdata->brt_val;
 
 	reg_val[0] = gen_config;	/* LM3530_GEN_CONFIG */
 	reg_val[1] = als_config;	/* LM3530_ALS_CONFIG */
@@ -200,7 +200,7 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 	reg_val[13] = LM3530_DEF_ZT_3;	/* LM3530_ALS_Z3T_REG */
 	reg_val[14] = LM3530_DEF_ZT_4;	/* LM3530_ALS_Z4T_REG */
 
-	if (!drvdata->enable) {
+	if (!drvdata->enable && !pdata->is_vin_always_on) {
 		ret = regulator_enable(drvdata->regulator);
 		if (ret) {
 			dev_err(&drvdata->client->dev,
@@ -211,6 +211,12 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 	}
 
 	for (i = 0; i < LM3530_REG_MAX; i++) {
+
+		/* do not update brightness register when pwm mode */
+		if (lm3530_reg[i] == LM3530_BRT_CTRL_REG &&
+		    drvdata->mode == LM3530_BL_MODE_PWM)
+			continue;
+
 		ret = i2c_smbus_write_byte_data(client,
 				lm3530_reg[i], reg_val[i]);
 		if (ret)
@@ -226,6 +232,9 @@ static void lm3530_brightness_set(struct led_classdev *led_cdev,
 	int err;
 	struct lm3530_data *drvdata =
 	    container_of(led_cdev, struct lm3530_data, led_dev);
+	struct lm3530_platform_data *pdata = drvdata->pdata;
+	struct lm3530_pwm_data *pwm = &pdata->pwm_data;
+	u8 max_brightness = led_cdev->max_brightness;
 
 	switch (drvdata->mode) {
 	case LM3530_BL_MODE_MANUAL:
@@ -241,14 +250,14 @@ static void lm3530_brightness_set(struct led_classdev *led_cdev,
 
 		/* set the brightness in brightness control register*/
 		err = i2c_smbus_write_byte_data(drvdata->client,
-				LM3530_BRT_CTRL_REG, brt_val / 2);
+				LM3530_BRT_CTRL_REG, brt_val >> 1);
 		if (err)
 			dev_err(&drvdata->client->dev,
 				"Unable to set brightness: %d\n", err);
 		else
-			drvdata->brightness = brt_val / 2;
+			drvdata->brightness = brt_val >> 1;
 
-		if (brt_val == 0) {
+		if (brt_val == 0 && !pdata->is_vin_always_on) {
 			err = regulator_disable(drvdata->regulator);
 			if (err)
 				dev_err(&drvdata->client->dev,
@@ -259,21 +268,33 @@ static void lm3530_brightness_set(struct led_classdev *led_cdev,
 	case LM3530_BL_MODE_ALS:
 		break;
 	case LM3530_BL_MODE_PWM:
+		if (pwm->pwm_set_intensity)
+			pwm->pwm_set_intensity(brt_val, max_brightness);
 		break;
 	default:
 		break;
 	}
 }
 
+static ssize_t lm3530_mode_get(struct device *dev,
+			struct device_attribute *attr,
+			char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3530_data *drvdata =
+	    container_of(led_cdev, struct lm3530_data, led_dev);
+	enum lm3530_mode m = drvdata->mode;
+
+	return sprintf(buf, "%s\n", mode_map[m].mode);
+}
 
 static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
 				   *attr, const char *buf, size_t size)
 {
-	int err;
-	struct i2c_client *client = container_of(
-					dev->parent, struct i2c_client, dev);
-	struct lm3530_data *drvdata = i2c_get_clientdata(client);
-	int mode;
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3530_data *drvdata =
+	    container_of(led_cdev, struct lm3530_data, led_dev);
+	int mode, err;
 
 	mode = lm3530_get_mode_from_str(buf);
 	if (mode < 0) {
@@ -281,14 +302,7 @@ static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
 		return -EINVAL;
 	}
 
-	if (mode == LM3530_BL_MODE_MANUAL)
-		drvdata->mode = LM3530_BL_MODE_MANUAL;
-	else if (mode == LM3530_BL_MODE_ALS)
-		drvdata->mode = LM3530_BL_MODE_ALS;
-	else if (mode == LM3530_BL_MODE_PWM) {
-		dev_err(dev, "PWM mode not supported\n");
-		return -EINVAL;
-	}
+	drvdata->mode = mode;
 
 	err = lm3530_init_registers(drvdata);
 	if (err) {
@@ -299,7 +313,7 @@ static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
 	return sizeof(drvdata->mode);
 }
 
-static DEVICE_ATTR(mode, 0644, NULL, lm3530_mode_set);
+static DEVICE_ATTR(mode, 0644, lm3530_mode_get, lm3530_mode_set);
 
 static int __devinit lm3530_probe(struct i2c_client *client,
 			   const struct i2c_device_id *id)
@@ -337,18 +351,20 @@ static int __devinit lm3530_probe(struct i2c_client *client,
 	drvdata->client = client;
 	drvdata->pdata = pdata;
 	drvdata->brightness = LED_OFF;
-	drvdata->enable = false;
-	drvdata->led_dev.name = LM3530_LED_DEV;
+	drvdata->enable = pdata->is_vin_always_on;
+	drvdata->led_dev.name = pdata->name ? pdata->name : LM3530_LED_DEV;
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
@@ -391,10 +407,11 @@ err_out:
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
index 58592fa..0240204 100644
--- a/include/linux/led-lm3530.h
+++ b/include/linux/led-lm3530.h
@@ -72,6 +72,12 @@ enum lm3530_als_mode {
 	LM3530_INPUT_CEIL,	/* Max of ALS1 and ALS2 */
 };
 
+/* PWM Platform Specific Data */
+struct lm3530_pwm_data {
+	void (*pwm_set_intensity) (int brightness, int max_brightness);
+	int (*pwm_get_intensity) (int max_brightness);
+};
+
 /**
  * struct lm3530_platform_data
  * @mode: mode of operation i.e. Manual, ALS or PWM
@@ -85,6 +91,10 @@ enum lm3530_als_mode {
  * @als1_resistor_sel: internal resistance from ALS1 input to ground
  * @als2_resistor_sel: internal resistance from ALS2 input to ground
  * @brt_val: brightness value (0-255)
+ * @name: led device name
+ * @is_vin_always_on: set to true if VIN is always on.
+ *		      ex) VIN is connected with VBATT
+ * @pwm_data: PWM control functions. only valid when the mode is PWM.
  */
 struct lm3530_platform_data {
 	enum lm3530_mode mode;
@@ -102,6 +112,10 @@ struct lm3530_platform_data {
 	u8 als2_resistor_sel;
 
 	u8 brt_val;
+
+	const char *name;
+	bool is_vin_always_on;
+	struct lm3530_pwm_data pwm_data;
 };
 
 #endif	/* _LINUX_LED_LM3530_H__ */
-- 
1.7.4.1


Thanks & BR
Milo (Woogyom) Kim
Texas Instruments Incorporated



