Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab2JEIN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:13:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57766 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab2JEINv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:13:51 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/28] leds-lp5521/5523: cleanup brightness work function
Thread-Topic: [PATCH 07/28] leds-lp5521/5523: cleanup brightness work
 function
Thread-Index: Ac2i0VUEWRCgZZz0SGiiitC5nrCczQ==
Date: Fri, 5 Oct 2012 08:13:42 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6417674D@DQHE02.ent.ti.com>
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

 The brightness function of LED classdev was moved to the lp55xx common driver
 in previous patch.
 To change the LED brightness, specific register should be updated.
 This brightness register is the chip specific.
 Therefore, actual operation should be handled in each driver.

 This work function is registered on initializing LEDs and
 it is called when the brightness is changed by the user-space.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   19 ++++---------------
 drivers/leds/leds-lp5523.c |   23 ++++-------------------
 2 files changed, 8 insertions(+), 34 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 18c194c..e029598 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -151,8 +151,6 @@ static inline struct lp5521_chip *led_to_lp5521(struct lp5521_led *led)
 			    leds[led->id]);
 }
 
-static void lp5521_led_brightness_work(struct work_struct *work);
-
 static inline int lp5521_write(struct i2c_client *client, u8 reg, u8 value)
 {
 	return i2c_smbus_write_byte_data(client, reg, value);
@@ -298,24 +296,14 @@ static int lp5521_run_selftest(struct lp5521_chip *chip, char *buf)
 	return 0;
 }
 
-static void lp5521_set_brightness(struct led_classdev *cdev,
-			     enum led_brightness brightness)
-{
-	struct lp5521_led *led = cdev_to_led(cdev);
-	led->brightness = (u8)brightness;
-	schedule_work(&led->brightness_work);
-}
-
 static void lp5521_led_brightness_work(struct work_struct *work)
 {
-	struct lp5521_led *led = container_of(work,
-					      struct lp5521_led,
+	struct lp55xx_led *led = container_of(work, struct lp55xx_led,
 					      brightness_work);
-	struct lp5521_chip *chip = led_to_lp5521(led);
-	struct i2c_client *client = chip->client;
+	struct lp55xx_chip *chip = led->chip;
 
 	mutex_lock(&chip->lock);
-	lp5521_write(client, LP5521_REG_LED_PWM_BASE + led->chan_nr,
+	lp55xx_write(chip, LP5521_REG_LED_PWM_BASE + led->chan_nr,
 		led->brightness);
 	mutex_unlock(&chip->lock);
 }
@@ -627,6 +615,7 @@ static struct lp55xx_device_config lp5521_cfg = {
 		.val  = LP5521_ENABLE_DEFAULT,
 	},
 	.post_init_device   = lp5521_post_init_device,
+	.brightness_work_fn = lp5521_led_brightness_work,
 };
 
 static int __devinit lp5521_probe(struct i2c_client *client,
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 58c252e..fbde823 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -163,8 +163,6 @@ static void lp5523_set_mode(struct lp5523_engine *engine, u8 mode);
 static int lp5523_set_engine_mode(struct lp5523_engine *engine, u8 mode);
 static int lp5523_load_program(struct lp5523_engine *engine, const u8 *pattern);
 
-static void lp5523_led_brightness_work(struct work_struct *work);
-
 static int lp5523_write(struct i2c_client *client, u8 reg, u8 value)
 {
 	return i2c_smbus_write_byte_data(client, reg, value);
@@ -457,29 +455,15 @@ release_lock:
 	return pos;
 }
 
-static void lp5523_set_brightness(struct led_classdev *cdev,
-			     enum led_brightness brightness)
-{
-	struct lp5523_led *led = cdev_to_led(cdev);
-
-	led->brightness = (u8)brightness;
-
-	schedule_work(&led->brightness_work);
-}
-
 static void lp5523_led_brightness_work(struct work_struct *work)
 {
-	struct lp5523_led *led = container_of(work,
-					      struct lp5523_led,
+	struct lp55xx_led *led = container_of(work, struct lp55xx_led,
 					      brightness_work);
-	struct lp5523_chip *chip = led_to_lp5523(led);
-	struct i2c_client *client = chip->client;
+	struct lp55xx_chip *chip = led->chip;
 
 	mutex_lock(&chip->lock);
-
-	lp5523_write(client, LP5523_REG_LED_PWM_BASE + led->chan_nr,
+	lp55xx_write(chip, LP5523_REG_LED_PWM_BASE + led->chan_nr,
 		     led->brightness);
-
 	mutex_unlock(&chip->lock);
 }
 
@@ -704,6 +688,7 @@ static struct lp55xx_device_config lp5523_cfg = {
 		.val  = LP5523_ENABLE,
 	},
 	.post_init_device   = lp5523_post_init_device,
+	.brightness_work_fn = lp5523_led_brightness_work,
 };
 
 static int __devinit lp5523_probe(struct i2c_client *client,
-- 
1.7.9.5


Best Regards,
Milo


