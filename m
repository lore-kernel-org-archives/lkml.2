Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab2JEIZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:25:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47876 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab2JEIZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:25:46 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 27/28] leds-lp5521/5523: relocate functions and remove
 comments
Thread-Topic: [PATCH 27/28] leds-lp5521/5523: relocate functions and remove
 comments
Thread-Index: Ac2i0v8khx+TRdquSNW0Rt0cEAWIxg==
Date: Fri, 5 Oct 2012 08:25:38 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6417687C@DQHE02.ent.ti.com>
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

 Relocate device attribute function nearby the declaration of the attribute.
 This is really minor, but it may improve the legibility.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   24 +++----
 drivers/leds/leds-lp5523.c |  154 +++++++++++++++++++++-----------------------
 2 files changed, 87 insertions(+), 91 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 181d73f..59b4589 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -312,6 +312,18 @@ static int lp5521_post_init_device(struct lp55xx_chip *chip)
 	return 0;
 }
 
+static void lp5521_led_brightness_work(struct work_struct *work)
+{
+	struct lp55xx_led *led = container_of(work, struct lp55xx_led,
+					      brightness_work);
+	struct lp55xx_chip *chip = led->chip;
+
+	mutex_lock(&chip->lock);
+	lp55xx_write(chip, LP5521_REG_LED_PWM_BASE + led->chan_nr,
+		led->brightness);
+	mutex_unlock(&chip->lock);
+}
+
 static int lp5521_run_selftest(struct lp55xx_chip *chip, char *buf)
 {
 	struct lp55xx_platform_data *pdata = chip->pdata;
@@ -332,18 +344,6 @@ static int lp5521_run_selftest(struct lp55xx_chip *chip, char *buf)
 	return 0;
 }
 
-static void lp5521_led_brightness_work(struct work_struct *work)
-{
-	struct lp55xx_led *led = container_of(work, struct lp55xx_led,
-					      brightness_work);
-	struct lp55xx_chip *chip = led->chip;
-
-	mutex_lock(&chip->lock);
-	lp55xx_write(chip, LP5521_REG_LED_PWM_BASE + led->chan_nr,
-		led->brightness);
-	mutex_unlock(&chip->lock);
-}
-
 static ssize_t lp5521_selftest(struct device *dev,
 			       struct device_attribute *attr,
 			       char *buf)
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 66d57a5..7405564 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -130,81 +130,6 @@ static int lp5523_post_init_device(struct lp55xx_chip *chip)
 	return lp55xx_write(chip, LP5523_REG_ENABLE_LEDS_LSB, 0xff);
 }
 
-static ssize_t lp5523_selftest(struct device *dev,
-			       struct device_attribute *attr,
-			       char *buf)
-{
-	struct lp55xx_led *led = i2c_get_clientdata(to_i2c_client(dev));
-	struct lp55xx_chip *chip = led->chip;
-	struct lp55xx_platform_data *pdata = chip->pdata;
-	int i, ret, pos = 0;
-	u8 status, adc, vdd;
-
-	mutex_lock(&chip->lock);
-
-	ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
-	if (ret < 0)
-		goto fail;
-
-	/* Check that ext clock is really in use if requested */
-	if (pdata->clock_mode == LP55XX_CLOCK_EXT) {
-		if  ((status & LP5523_EXT_CLK_USED) == 0)
-			goto fail;
-	}
-
-	/* Measure VDD (i.e. VBAT) first (channel 16 corresponds to VDD) */
-	lp55xx_write(chip, LP5523_REG_LED_TEST_CTRL, LP5523_EN_LEDTEST | 16);
-	usleep_range(3000, 6000); /* ADC conversion time is typically 2.7 ms */
-	ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
-	if (!(status & LP5523_LEDTEST_DONE))
-		usleep_range(3000, 6000); /* Was not ready. Wait little bit */
-
-	ret |= lp55xx_read(chip, LP5523_REG_LED_TEST_ADC, &vdd);
-	vdd--;	/* There may be some fluctuation in measurement */
-
-	for (i = 0; i < LP5523_MAX_LEDS; i++) {
-		/* Skip non-existing channels */
-		if (pdata->led_config[i].led_current == 0)
-			continue;
-
-		/* Set default current */
-		lp55xx_write(chip, LP5523_REG_LED_CURRENT_BASE + i,
-			pdata->led_config[i].led_current);
-
-		lp55xx_write(chip, LP5523_REG_LED_PWM_BASE + i, 0xff);
-		/* let current stabilize 2 - 4ms before measurements start */
-		usleep_range(2000, 4000);
-		lp55xx_write(chip, LP5523_REG_LED_TEST_CTRL,
-			     LP5523_EN_LEDTEST | i);
-		/* ADC conversion time is 2.7 ms typically */
-		usleep_range(3000, 6000);
-		ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
-		if (!(status & LP5523_LEDTEST_DONE))
-			usleep_range(3000, 6000);/* Was not ready. Wait. */
-		ret |= lp55xx_read(chip, LP5523_REG_LED_TEST_ADC, &adc);
-
-		if (adc >= vdd || adc < LP5523_ADC_SHORTCIRC_LIM)
-			pos += sprintf(buf + pos, "LED %d FAIL\n", i);
-
-		lp55xx_write(chip, LP5523_REG_LED_PWM_BASE + i, 0x00);
-
-		/* Restore current */
-		lp55xx_write(chip, LP5523_REG_LED_CURRENT_BASE + i,
-			led->led_current);
-		led++;
-	}
-	if (pos == 0)
-		pos = sprintf(buf, "OK\n");
-	goto release_lock;
-fail:
-	pos = sprintf(buf, "FAIL\n");
-
-release_lock:
-	mutex_unlock(&chip->lock);
-
-	return pos;
-}
-
 static void lp5523_led_brightness_work(struct work_struct *work)
 {
 	struct lp55xx_led *led = container_of(work, struct lp55xx_led,
@@ -381,6 +306,81 @@ static void lp5523_firmware_loaded(struct lp55xx_chip *chip)
 	lp5523_update_program_memory(chip, fw->data, fw->size);
 }
 
+static ssize_t lp5523_selftest(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct lp55xx_led *led = i2c_get_clientdata(to_i2c_client(dev));
+	struct lp55xx_chip *chip = led->chip;
+	struct lp55xx_platform_data *pdata = chip->pdata;
+	int i, ret, pos = 0;
+	u8 status, adc, vdd;
+
+	mutex_lock(&chip->lock);
+
+	ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
+	if (ret < 0)
+		goto fail;
+
+	/* Check that ext clock is really in use if requested */
+	if (pdata->clock_mode == LP55XX_CLOCK_EXT) {
+		if  ((status & LP5523_EXT_CLK_USED) == 0)
+			goto fail;
+	}
+
+	/* Measure VDD (i.e. VBAT) first (channel 16 corresponds to VDD) */
+	lp55xx_write(chip, LP5523_REG_LED_TEST_CTRL, LP5523_EN_LEDTEST | 16);
+	usleep_range(3000, 6000); /* ADC conversion time is typically 2.7 ms */
+	ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
+	if (!(status & LP5523_LEDTEST_DONE))
+		usleep_range(3000, 6000); /* Was not ready. Wait little bit */
+
+	ret |= lp55xx_read(chip, LP5523_REG_LED_TEST_ADC, &vdd);
+	vdd--;	/* There may be some fluctuation in measurement */
+
+	for (i = 0; i < LP5523_MAX_LEDS; i++) {
+		/* Skip non-existing channels */
+		if (pdata->led_config[i].led_current == 0)
+			continue;
+
+		/* Set default current */
+		lp55xx_write(chip, LP5523_REG_LED_CURRENT_BASE + i,
+			pdata->led_config[i].led_current);
+
+		lp55xx_write(chip, LP5523_REG_LED_PWM_BASE + i, 0xff);
+		/* let current stabilize 2 - 4ms before measurements start */
+		usleep_range(2000, 4000);
+		lp55xx_write(chip, LP5523_REG_LED_TEST_CTRL,
+			     LP5523_EN_LEDTEST | i);
+		/* ADC conversion time is 2.7 ms typically */
+		usleep_range(3000, 6000);
+		ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
+		if (!(status & LP5523_LEDTEST_DONE))
+			usleep_range(3000, 6000);/* Was not ready. Wait. */
+		ret |= lp55xx_read(chip, LP5523_REG_LED_TEST_ADC, &adc);
+
+		if (adc >= vdd || adc < LP5523_ADC_SHORTCIRC_LIM)
+			pos += sprintf(buf + pos, "LED %d FAIL\n", i);
+
+		lp55xx_write(chip, LP5523_REG_LED_PWM_BASE + i, 0x00);
+
+		/* Restore current */
+		lp55xx_write(chip, LP5523_REG_LED_CURRENT_BASE + i,
+			led->led_current);
+		led++;
+	}
+	if (pos == 0)
+		pos = sprintf(buf, "OK\n");
+	goto release_lock;
+fail:
+	pos = sprintf(buf, "FAIL\n");
+
+release_lock:
+	mutex_unlock(&chip->lock);
+
+	return pos;
+}
+
 static DEVICE_ATTR(selftest, S_IRUGO, lp5523_selftest, NULL);
 
 static struct attribute *lp5523_attributes[] = {
@@ -392,10 +392,6 @@ static const struct attribute_group lp5523_group = {
 	.attrs = lp5523_attributes,
 };
 
-/*--------------------------------------------------------------*/
-/*			Probe, Attach, Remove			*/
-/*--------------------------------------------------------------*/
-
 /* Chip specific configurations */
 static struct lp55xx_device_config lp5523_cfg = {
 	.max_channel  = LP5523_MAX_LEDS,
-- 
1.7.9.5


Best Regards,
Milo


