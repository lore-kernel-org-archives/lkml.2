Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab2BGFOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 00:14:35 -0500
Received: from mail2.nsc.com ([12.238.8.132]:39173 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751302Ab2BGFOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 00:14:34 -0500
X-WSS-ID: 0LZ0BW5-0A-1JT-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 6 Feb 2012 21:14:21 -0800
Subject: [PATCH v4 3/5] leds-lm3530: support pwm input mode
Thread-Topic: [PATCH v4 3/5] leds-lm3530: support pwm input mode
Thread-Index: AczlV1m1O67xyhsXQZmVvWiO9iWkAg==
Message-ID: <B567DBAB974C0544994013492B949F8E3812ED44A8@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 632E6CBA1LS10196157-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* add 'struct lm3530_pwm_data' in the platform data
  The pwm data is the platform specific functions which generate the pwm.
  The pwm data is only valid when brightness is pwm input mode.
  Functions should be implemented by the pwm driver.
  pwm_set_intensity() : set duty of pwm.
  pwm_get_intensity() : get current the brightness.

* brightness control by pwm
  If the control mode is pwm, then brightness is changed by the duty of pwm.
  So pwm platform function should be called in lm3530_brightness_set().

* do not update brightness register when pwm input mode
  In pwm input mode, brightness register is not used.
  If any value is updated in this register, then the led will be off.

* when input mode is changed, set duty of pwm to 0 if unnecessary.

* patch base version : kernel 3.2.4

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lm3530.c |   30 ++++++++++++++++++++++--------
 include/linux/led-lm3530.h |    9 +++++++++
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 8886959..8ec7b2b 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -157,6 +157,7 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 	u32 als_vmin, als_vmax, als_vstep;
 	struct lm3530_platform_data *pltfm = drvdata->pdata;
 	struct i2c_client *client = drvdata->client;
+	struct lm3530_pwm_data *pwm = &pltfm->pwm_data;
 
 	gen_config = (pltfm->brt_ramp_law << LM3530_RAMP_LAW_SHIFT) |
 			((pltfm->max_current & 7) << LM3530_MAX_CURR_SHIFT);
@@ -240,6 +241,15 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 	}
 
 	for (i = 0; i < LM3530_REG_MAX; i++) {
+		/* do not update brightness register when pwm mode */
+		if (lm3530_reg[i] == LM3530_BRT_CTRL_REG &&
+		    drvdata->mode == LM3530_BL_MODE_PWM) {
+			if (pwm->pwm_set_intensity)
+				pwm->pwm_set_intensity(reg_val[i],
+					drvdata->led_dev.max_brightness);
+			continue;
+		}
+
 		ret = i2c_smbus_write_byte_data(client,
 				lm3530_reg[i], reg_val[i]);
 		if (ret)
@@ -255,6 +265,9 @@ static void lm3530_brightness_set(struct led_classdev *led_cdev,
 	int err;
 	struct lm3530_data *drvdata =
 	    container_of(led_cdev, struct lm3530_data, led_dev);
+	struct lm3530_platform_data *pdata = drvdata->pdata;
+	struct lm3530_pwm_data *pwm = &pdata->pwm_data;
+	u8 max_brightness = led_cdev->max_brightness;
 
 	switch (drvdata->mode) {
 	case LM3530_BL_MODE_MANUAL:
@@ -288,6 +301,8 @@ static void lm3530_brightness_set(struct led_classdev *led_cdev,
 	case LM3530_BL_MODE_ALS:
 		break;
 	case LM3530_BL_MODE_PWM:
+		if (pwm->pwm_set_intensity)
+			pwm->pwm_set_intensity(brt_val, max_brightness);
 		break;
 	default:
 		break;
@@ -319,6 +334,8 @@ static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct lm3530_data *drvdata =
 	    container_of(led_cdev, struct lm3530_data, led_dev);
+	struct lm3530_pwm_data *pwm = &drvdata->pdata->pwm_data;
+	u8 max_brightness = led_cdev->max_brightness;
 	int mode, err;
 
 	mode = lm3530_get_mode_from_str(buf);
@@ -327,14 +344,11 @@ static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
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
+
+	/* set pwm to low if unnecessary */
+	if (mode != LM3530_BL_MODE_PWM && pwm->pwm_set_intensity)
+		pwm->pwm_set_intensity(0, max_brightness);
 
 	err = lm3530_init_registers(drvdata);
 	if (err) {
diff --git a/include/linux/led-lm3530.h b/include/linux/led-lm3530.h
index 8eb1235..eeae6e7 100644
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
@@ -87,6 +93,7 @@ enum lm3530_als_mode {
  * @als_vmin: als input voltage calibrated for max brightness in mV
  * @als_vmax: als input voltage calibrated for min brightness in mV
  * @brt_val: brightness value (0-255)
+ * @pwm_data: PWM control functions (only valid when the mode is PWM)
  */
 struct lm3530_platform_data {
 	enum lm3530_mode mode;
@@ -107,6 +114,8 @@ struct lm3530_platform_data {
 	u32 als_vmax;
 
 	u8 brt_val;
+
+	struct lm3530_pwm_data pwm_data;
 };
 
 #endif	/* _LINUX_LED_LM3530_H__ */
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated




