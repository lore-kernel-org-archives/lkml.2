Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab2LLOBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:01:55 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50812 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab2LLOBx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:01:53 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/33] leds-lp55xx: use lp55xx_set_brightness() for
 brightness control
Thread-Topic: [PATCH 14/33] leds-lp55xx: use lp55xx_set_brightness() for
 brightness control
Thread-Index: Ac3YcTm7Tx2to1foQMu9VLoVrCw1dA==
Date: Wed, 12 Dec 2012 14:01:48 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AB4D@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
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

 lp5521_set_brightness() and lp5523_set_brightness() are replaced with
 common lp55xx_set_brightness().
 This common function is invoked when the brightness of each LED channel
 is updated.
 LP5521 and LP5523 have different register address for the brightness control,
 so this work is done by chip specific brightness_work_fn().

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c        |   19 ++++---------------
 drivers/leds/leds-lp5523.c        |   23 ++++-------------------
 drivers/leds/leds-lp55xx-common.c |    9 +++++++++
 drivers/leds/leds-lp55xx-common.h |    4 ++++
 4 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 19b314c..fbe7129 100644
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
@@ -706,6 +694,7 @@ static struct lp55xx_device_config lp5521_cfg = {
 	},
 	.max_channel  = LP5521_MAX_LEDS,
 	.post_init_device   = lp5521_post_init_device,
+	.brightness_work_fn = lp5521_led_brightness_work,
 };
 
 static int __devinit lp5521_probe(struct i2c_client *client,
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index e534ec4..c2927d8 100644
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
@@ -468,29 +466,15 @@ release_lock:
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
 
@@ -807,6 +791,7 @@ static struct lp55xx_device_config lp5523_cfg = {
 	},
 	.max_channel  = LP5523_MAX_LEDS,
 	.post_init_device   = lp5523_post_init_device,
+	.brightness_work_fn = lp5523_led_brightness_work,
 };
 
 static int __devinit lp5523_probe(struct i2c_client *client,
diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index e85e8dc..59f0975 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -63,6 +63,15 @@ static int lp55xx_post_init_device(struct lp55xx_chip *chip)
 	return cfg->post_init_device(chip);
 }
 
+static void lp55xx_set_brightness(struct led_classdev *cdev,
+			     enum led_brightness brightness)
+{
+	struct lp55xx_led *led = cdev_to_lp55xx_led(cdev);
+
+	led->brightness = (u8)brightness;
+	schedule_work(&led->brightness_work);
+}
+
 static int lp55xx_init_led(struct lp55xx_led *led,
 			struct lp55xx_chip *chip, int chan)
 {
diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
index 1bacc41..194ac2a 100644
--- a/drivers/leds/leds-lp55xx-common.h
+++ b/drivers/leds/leds-lp55xx-common.h
@@ -34,6 +34,7 @@ struct lp55xx_reg {
  * @enable             : Chip specific enable command
  * @max_channel        : Maximum number of channels
  * @post_init_device   : Chip specific initialization code
+ * @brightness_work_fn : Brightness work function
  */
 struct lp55xx_device_config {
 	const struct lp55xx_reg reset;
@@ -42,6 +43,9 @@ struct lp55xx_device_config {
 
 	/* define if the device has specific initialization process */
 	int (*post_init_device) (struct lp55xx_chip *chip);
+
+	/* access brightness register */
+	void (*brightness_work_fn)(struct work_struct *work);
 };
 
 /*
-- 
1.7.9.5


Best Regards,
Milo


