Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab2JEIO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:14:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57783 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab2JEIOU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:14:20 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/28] leds-lp5521/5523: cleanup setting LED current
Thread-Topic: [PATCH 08/28] leds-lp5521/5523: cleanup setting LED current
Thread-Index: Ac2i0WT4h5dfNsBFS5uvhttSLKfX+Q==
Date: Fri, 5 Oct 2012 08:14:09 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6417675C@DQHE02.ent.ti.com>
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

 The LP55xx common driver has general LED attributes.
 (led_current and max_current)
 To set this current, specific register should be updated.
 Therefore, actual operation is handled in each driver.

 This call is invoked on initializing LEDs and
 setting current by an user-space.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |    9 +++++----
 drivers/leds/leds-lp5523.c |    8 ++++++++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index e029598..1791655 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -229,11 +229,11 @@ static int lp5521_load_program(struct lp5521_engine *eng, const u8 *pattern)
 	return lp5521_write(client, LP5521_REG_OP_MODE, mode);
 }
 
-static int lp5521_set_led_current(struct lp5521_chip *chip, int led, u8 curr)
+static void lp5521_set_led_current(struct lp55xx_led *led, u8 led_current)
 {
-	return lp5521_write(chip->client,
-		    LP5521_REG_LED_CURRENT_BASE + chip->leds[led].chan_nr,
-		    curr);
+	led->led_current = led_current;
+	lp55xx_write(led->chip, LP5521_REG_LED_CURRENT_BASE + led->chan_nr,
+		led_current);
 }
 
 static int lp5521_post_init_device(struct lp55xx_chip *chip)
@@ -616,6 +616,7 @@ static struct lp55xx_device_config lp5521_cfg = {
 	},
 	.post_init_device   = lp5521_post_init_device,
 	.brightness_work_fn = lp5521_led_brightness_work,
+	.set_led_current    = lp5521_set_led_current,
 };
 
 static int __devinit lp5521_probe(struct i2c_client *client,
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index fbde823..5d383b2 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -467,6 +467,13 @@ static void lp5523_led_brightness_work(struct work_struct *work)
 	mutex_unlock(&chip->lock);
 }
 
+static void lp5523_set_led_current(struct lp55xx_led *led, u8 led_current)
+{
+	led->led_current = led_current;
+	lp55xx_write(led->chip, LP5523_REG_LED_CURRENT_BASE + led->chan_nr,
+		led_current);
+}
+
 static int lp5523_do_store_load(struct lp5523_engine *engine,
 				const char *buf, size_t len)
 {
@@ -689,6 +696,7 @@ static struct lp55xx_device_config lp5523_cfg = {
 	},
 	.post_init_device   = lp5523_post_init_device,
 	.brightness_work_fn = lp5523_led_brightness_work,
+	.set_led_current    = lp5523_set_led_current,
 };
 
 static int __devinit lp5523_probe(struct i2c_client *client,
-- 
1.7.9.5


Best Regards,
Milo


