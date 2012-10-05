Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2JEIXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:23:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58211 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab2JEIXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:23:09 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 21/28] leds-lp5521/5523: use lp55xx data structure on
 selftest
Thread-Topic: [PATCH 21/28] leds-lp5521/5523: use lp55xx data structure on
 selftest
Thread-Index: Ac2i0qAbzXntZC4wQKWM9/lG5n0hGQ==
Date: Fri, 5 Oct 2012 08:22:58 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6417681D@DQHE02.ent.ti.com>
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

 The lp5521_chip and lp5523_chip are not used any more.
 The R/W functions are replaced with lp55xx common functions.

 LP5521 : Changes on checking the external clock
 The selftest device attribute is created only when the platform data exists.
 So no need to check whether the pdata is NULL or not.
 And just skip read status value in case of external clock mode.

 LP5523 : Like LP5521, pdata NULL checking is unnecessary.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   18 +++++++++++-------
 drivers/leds/leds-lp5523.c |   43 ++++++++++++++++++++-----------------------
 2 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 84023e2..71e8d31 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -398,19 +398,23 @@ static int lp5521_post_init_device(struct lp55xx_chip *chip)
 	return 0;
 }
 
-static int lp5521_run_selftest(struct lp5521_chip *chip, char *buf)
+static int lp5521_run_selftest(struct lp55xx_chip *chip, char *buf)
 {
+	struct lp55xx_platform_data *pdata = chip->pdata;
 	int ret;
 	u8 status;
 
-	ret = lp5521_read(chip->client, LP5521_REG_STATUS, &status);
+	ret = lp55xx_read(chip, LP5521_REG_STATUS, &status);
 	if (ret < 0)
 		return ret;
 
+	if (pdata->clock_mode != LP55XX_CLOCK_EXT)
+		return 0;
+
 	/* Check that ext clock is really in use if requested */
-	if (chip->pdata && chip->pdata->clock_mode == LP5521_CLOCK_EXT)
-		if  ((status & LP5521_EXT_CLK_USED) == 0)
-			return -EIO;
+	if  ((status & LP5521_EXT_CLK_USED) == 0)
+		return -EIO;
+
 	return 0;
 }
 
@@ -430,8 +434,8 @@ static ssize_t lp5521_selftest(struct device *dev,
 			       struct device_attribute *attr,
 			       char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lp5521_chip *chip = i2c_get_clientdata(client);
+	struct lp55xx_led *led = i2c_get_clientdata(to_i2c_client(dev));
+	struct lp55xx_chip *chip = led->chip;
 	int ret;
 
 	mutex_lock(&chip->lock);
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index cf629fb..9518be4 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -241,66 +241,63 @@ static ssize_t lp5523_selftest(struct device *dev,
 			       struct device_attribute *attr,
 			       char *buf)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lp5523_chip *chip = i2c_get_clientdata(client);
+	struct lp55xx_led *led = i2c_get_clientdata(to_i2c_client(dev));
+	struct lp55xx_chip *chip = led->chip;
+	struct lp55xx_platform_data *pdata = chip->pdata;
 	int i, ret, pos = 0;
-	int led = 0;
 	u8 status, adc, vdd;
 
 	mutex_lock(&chip->lock);
 
-	ret = lp5523_read(chip->client, LP5523_REG_STATUS, &status);
+	ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
 	if (ret < 0)
 		goto fail;
 
 	/* Check that ext clock is really in use if requested */
-	if ((chip->pdata) && (chip->pdata->clock_mode == LP5523_CLOCK_EXT))
+	if (pdata->clock_mode == LP55XX_CLOCK_EXT) {
 		if  ((status & LP5523_EXT_CLK_USED) == 0)
 			goto fail;
+	}
 
 	/* Measure VDD (i.e. VBAT) first (channel 16 corresponds to VDD) */
-	lp5523_write(chip->client, LP5523_REG_LED_TEST_CTRL,
-				    LP5523_EN_LEDTEST | 16);
+	lp55xx_write(chip, LP5523_REG_LED_TEST_CTRL, LP5523_EN_LEDTEST | 16);
 	usleep_range(3000, 6000); /* ADC conversion time is typically 2.7 ms */
-	ret = lp5523_read(chip->client, LP5523_REG_STATUS, &status);
+	ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
 	if (!(status & LP5523_LEDTEST_DONE))
 		usleep_range(3000, 6000); /* Was not ready. Wait little bit */
 
-	ret |= lp5523_read(chip->client, LP5523_REG_LED_TEST_ADC, &vdd);
+	ret |= lp55xx_read(chip, LP5523_REG_LED_TEST_ADC, &vdd);
 	vdd--;	/* There may be some fluctuation in measurement */
 
-	for (i = 0; i < LP5523_LEDS; i++) {
+	for (i = 0; i < LP5523_MAX_LEDS; i++) {
 		/* Skip non-existing channels */
-		if (chip->pdata->led_config[i].led_current == 0)
+		if (pdata->led_config[i].led_current == 0)
 			continue;
 
 		/* Set default current */
-		lp5523_write(chip->client,
-			LP5523_REG_LED_CURRENT_BASE + i,
-			chip->pdata->led_config[i].led_current);
+		lp55xx_write(chip, LP5523_REG_LED_CURRENT_BASE + i,
+			pdata->led_config[i].led_current);
 
-		lp5523_write(chip->client, LP5523_REG_LED_PWM_BASE + i, 0xff);
+		lp55xx_write(chip, LP5523_REG_LED_PWM_BASE + i, 0xff);
 		/* let current stabilize 2 - 4ms before measurements start */
 		usleep_range(2000, 4000);
-		lp5523_write(chip->client,
-			     LP5523_REG_LED_TEST_CTRL,
+		lp55xx_write(chip, LP5523_REG_LED_TEST_CTRL,
 			     LP5523_EN_LEDTEST | i);
 		/* ADC conversion time is 2.7 ms typically */
 		usleep_range(3000, 6000);
-		ret = lp5523_read(chip->client, LP5523_REG_STATUS, &status);
+		ret = lp55xx_read(chip, LP5523_REG_STATUS, &status);
 		if (!(status & LP5523_LEDTEST_DONE))
 			usleep_range(3000, 6000);/* Was not ready. Wait. */
-		ret |= lp5523_read(chip->client, LP5523_REG_LED_TEST_ADC, &adc);
+		ret |= lp55xx_read(chip, LP5523_REG_LED_TEST_ADC, &adc);
 
 		if (adc >= vdd || adc < LP5523_ADC_SHORTCIRC_LIM)
 			pos += sprintf(buf + pos, "LED %d FAIL\n", i);
 
-		lp5523_write(chip->client, LP5523_REG_LED_PWM_BASE + i, 0x00);
+		lp55xx_write(chip, LP5523_REG_LED_PWM_BASE + i, 0x00);
 
 		/* Restore current */
-		lp5523_write(chip->client,
-			LP5523_REG_LED_CURRENT_BASE + i,
-			chip->leds[led].led_current);
+		lp55xx_write(chip, LP5523_REG_LED_CURRENT_BASE + i,
+			led->led_current);
 		led++;
 	}
 	if (pos == 0)
-- 
1.7.9.5


Best Regards,
Milo


