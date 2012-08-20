Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab2HTECV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:02:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37310 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914Ab2HTECR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:02:17 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] leds-lm3530: replace pwm platform functions with generic
 pwm functions
Thread-Topic: [PATCH] leds-lm3530: replace pwm platform functions with
 generic pwm functions
Thread-Index: Ac1+iI3X+iN5rabESjyXTrhr06HT3A==
Date: Mon, 20 Aug 2012 04:02:05 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF0095@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use generic pwm functions for changing the duty rather than the platform data

(a) add lm3530_pwm_xxx functions for supporting pwm control mode
(b) add pwm id and period in the platform data
(c) gather pwm platform data into one place

This device should be built even if the pwm mode is unused.
That's why CONFIG_PWM is defined in the source rather than in Kconfig file.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lm3530.c |   95 ++++++++++++++++++++++++++++++++++++++------
 include/linux/led-lm3530.h |   17 +++-----
 2 files changed, 89 insertions(+), 23 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 23637bd..0d9efc5 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -19,6 +19,7 @@
 #include <linux/types.h>
 #include <linux/regulator/consumer.h>
 #include <linux/module.h>
+#include <linux/pwm.h>
 
 #define LM3530_LED_DEV "lcd-backlight"
 #define LM3530_NAME "lm3530-led"
@@ -102,6 +103,8 @@ static struct lm3530_mode_map mode_map[] = {
  * @regulator: regulator
  * @brighness: previous brightness value
  * @enable: regulator is enabled
+ * @pwm: pwm device for setting duty
+ * @period: pwm period length from the platform data
  */
 struct lm3530_data {
 	struct led_classdev led_dev;
@@ -111,6 +114,8 @@ struct lm3530_data {
 	struct regulator *regulator;
 	enum led_brightness brightness;
 	bool enable;
+	struct pwm_device *pwm;
+	int period_ns;
 };
 
 /*
@@ -153,6 +158,64 @@ static int lm3530_get_mode_from_str(const char *str)
 	return -1;
 }
 
+#ifdef CONFIG_PWM
+static int lm3530_pwm_request(struct lm3530_data *drvdata)
+{
+	int pwm_id;
+
+	/* if the pwm device exists, skip requesting the device */
+	if (drvdata->pwm)
+		return 0;
+
+	pwm_id = drvdata->pdata ? drvdata->pdata->pwm_id : 0;
+
+	drvdata->pwm = pwm_request(pwm_id, "lm3530-pwm");
+	drvdata->period_ns = drvdata->pdata ? drvdata->pdata->period_ns : 0;
+
+	return IS_ERR(drvdata->pwm) ? PTR_ERR(drvdata->pwm) : 0;
+}
+
+static void lm3530_pwm_set(struct lm3530_data *drvdata,
+			int brightness, int max_brightness)
+{
+	struct pwm_device *pwm = drvdata->pwm;
+
+	if (pwm) {
+		int period = drvdata->period_ns;
+		int duty = brightness * period / max_brightness;
+
+		pwm_config(pwm, duty, period);
+
+		if (duty > 0)
+			pwm_enable(pwm);
+		else
+			pwm_disable(pwm);
+	}
+}
+
+static void lm3530_pwm_free(struct lm3530_data *drvdata)
+{
+	if (drvdata->pwm)
+		pwm_free(drvdata->pwm);
+}
+#else
+static inline int lm3530_pwm_request(struct lm3530_data *drvdata)
+{
+	return 0;
+}
+
+static inline void lm3530_pwm_set(struct lm3530_data *drvdata,
+			int brightness, int max_brightness)
+{
+	return;
+}
+
+static inline void lm3530_pwm_free(struct lm3530_data *drvdata)
+{
+	return;
+}
+#endif
+
 static void lm3530_als_configure(struct lm3530_platform_data *pdata,
 				struct lm3530_als_data *als)
 {
@@ -197,7 +260,6 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 	u8 reg_val[LM3530_REG_MAX];
 	struct lm3530_platform_data *pdata = drvdata->pdata;
 	struct i2c_client *client = drvdata->client;
-	struct lm3530_pwm_data *pwm = &pdata->pwm_data;
 	struct lm3530_als_data als;
 
 	memset(&als, 0, sizeof(struct lm3530_als_data));
@@ -259,8 +321,7 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 		/* do not update brightness register when pwm mode */
 		if (lm3530_reg[i] == LM3530_BRT_CTRL_REG &&
 		    drvdata->mode == LM3530_BL_MODE_PWM) {
-			if (pwm->pwm_set_intensity)
-				pwm->pwm_set_intensity(reg_val[i],
+			lm3530_pwm_set(drvdata, reg_val[i],
 					drvdata->led_dev.max_brightness);
 			continue;
 		}
@@ -280,9 +341,6 @@ static void lm3530_brightness_set(struct led_classdev *led_cdev,
 	int err;
 	struct lm3530_data *drvdata =
 	    container_of(led_cdev, struct lm3530_data, led_dev);
-	struct lm3530_platform_data *pdata = drvdata->pdata;
-	struct lm3530_pwm_data *pwm = &pdata->pwm_data;
-	u8 max_brightness = led_cdev->max_brightness;
 
 	switch (drvdata->mode) {
 	case LM3530_BL_MODE_MANUAL:
@@ -316,8 +374,7 @@ static void lm3530_brightness_set(struct led_classdev *led_cdev,
 	case LM3530_BL_MODE_ALS:
 		break;
 	case LM3530_BL_MODE_PWM:
-		if (pwm->pwm_set_intensity)
-			pwm->pwm_set_intensity(brt_val, max_brightness);
+		lm3530_pwm_set(drvdata, brt_val, led_cdev->max_brightness);
 		break;
 	default:
 		break;
@@ -348,12 +405,10 @@ static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct lm3530_data *drvdata;
-	struct lm3530_pwm_data *pwm;
 	u8 max_brightness;
 	int mode, err;
 
 	drvdata = container_of(led_cdev, struct lm3530_data, led_dev);
-	pwm = &drvdata->pdata->pwm_data;
 	max_brightness = led_cdev->max_brightness;
 	mode = lm3530_get_mode_from_str(buf);
 	if (mode < 0) {
@@ -363,9 +418,15 @@ static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
 
 	drvdata->mode = mode;
 
-	/* set pwm to low if unnecessary */
-	if (mode != LM3530_BL_MODE_PWM && pwm->pwm_set_intensity)
-		pwm->pwm_set_intensity(0, max_brightness);
+	/* if new mode is pwm, then request a pwm device.
+	   otherwise, set pwm to low */
+	if (mode == LM3530_BL_MODE_PWM) {
+		err = lm3530_pwm_request(drvdata);
+		if (err)
+			return err;
+	} else {
+		lm3530_pwm_set(drvdata, 0, max_brightness);
+	}
 
 	err = lm3530_init_registers(drvdata);
 	if (err) {
@@ -424,6 +485,12 @@ static int __devinit lm3530_probe(struct i2c_client *client,
 		return err;
 	}
 
+	if (drvdata->mode == LM3530_BL_MODE_PWM) {
+		err = lm3530_pwm_request(drvdata);
+		if (err)
+			goto err_reg_init;
+	}
+
 	if (drvdata->pdata->brt_val) {
 		err = lm3530_init_registers(drvdata);
 		if (err < 0) {
@@ -467,6 +534,8 @@ static int __devexit lm3530_remove(struct i2c_client *client)
 		regulator_disable(drvdata->regulator);
 	regulator_put(drvdata->regulator);
 	led_classdev_unregister(&drvdata->led_dev);
+	lm3530_pwm_free(drvdata);
+
 	return 0;
 }
 
diff --git a/include/linux/led-lm3530.h b/include/linux/led-lm3530.h
index 4b13347..7ba6096 100644
--- a/include/linux/led-lm3530.h
+++ b/include/linux/led-lm3530.h
@@ -72,18 +72,11 @@ enum lm3530_als_mode {
 	LM3530_INPUT_CEIL,	/* Max of ALS1 and ALS2 */
 };
 
-/* PWM Platform Specific Data */
-struct lm3530_pwm_data {
-	void (*pwm_set_intensity) (int brightness, int max_brightness);
-	int (*pwm_get_intensity) (int max_brightness);
-};
-
 /**
  * struct lm3530_platform_data
  * @mode: mode of operation i.e. Manual, ALS or PWM
  * @als_input_mode: select source of ALS input - ALS1/2 or average
  * @max_current: full scale LED current
- * @pwm_pol_hi: PWM input polarity - active high/active low
  * @als_avrg_time: ALS input averaging time
  * @brt_ramp_law: brightness mapping mode - exponential/linear
  * @brt_ramp_fall: rate of fall of led current
@@ -93,14 +86,15 @@ struct lm3530_pwm_data {
  * @als_vmin: als input voltage calibrated for max brightness in mV
  * @als_vmax: als input voltage calibrated for min brightness in mV
  * @brt_val: brightness value (0-127)
- * @pwm_data: PWM control functions (only valid when the mode is PWM)
+ * @pwm_pol_hi: PWM input polarity - active high/active low
+ * @pwm_id: pwm channel id
+ * @period_ns: pwm period length - nanoseconds
  */
 struct lm3530_platform_data {
 	enum lm3530_mode mode;
 	enum lm3530_als_mode als_input_mode;
 
 	u8 max_current;
-	bool pwm_pol_hi;
 	u8 als_avrg_time;
 
 	bool brt_ramp_law;
@@ -115,7 +109,10 @@ struct lm3530_platform_data {
 
 	u8 brt_val;
 
-	struct lm3530_pwm_data pwm_data;
+	/* pwm specific data */
+	bool pwm_pol_hi;
+	int pwm_id;
+	int period_ns;
 };
 
 #endif	/* _LINUX_LED_LM3530_H__ */
-- 
1.7.2.5


Best Regards,
Milo



