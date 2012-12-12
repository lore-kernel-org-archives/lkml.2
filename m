Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab2LLOBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:01:48 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44404 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab2LLOBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:01:45 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/33] leds-lp55xx: use lp55xx_init_led() common function
Thread-Topic: [PATCH 13/33] leds-lp55xx: use lp55xx_init_led() common
 function
Thread-Index: Ac3YcTVjzmyHhbnJQ8ih7n41CpHZXw==
Date: Wed, 12 Dec 2012 14:01:41 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AB45@DQHE02.ent.ti.com>
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

 lp5521_init_led() and lp5523_init_led() are replaced with one common function,
 lp55xx_init_led().
 Max channels is configurable, so it's used in lp55xx_init_led().

 'LP5523_LEDS' are changed to 'LP5523_MAX_LEDS'.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c        |   50 +-----------------------------
 drivers/leds/leds-lp5523.c        |   62 +++++--------------------------------
 drivers/leds/leds-lp55xx-common.c |   59 +++++++++++++++++++++++++++++++++++
 drivers/leds/leds-lp55xx-common.h |    2 ++
 4 files changed, 69 insertions(+), 104 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 33c3110..19b314c 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -684,55 +684,6 @@ static void lp5521_unregister_sysfs(struct i2c_client *client)
 				&lp5521_led_attribute_group);
 }
 
-static int __devinit lp5521_init_led(struct lp5521_led *led,
-				struct i2c_client *client,
-				int chan, struct lp5521_platform_data *pdata)
-{
-	struct device *dev = &client->dev;
-	char name[32];
-	int res;
-
-	if (chan >= LP5521_MAX_LEDS)
-		return -EINVAL;
-
-	if (pdata->led_config[chan].led_current == 0)
-		return 0;
-
-	led->led_current = pdata->led_config[chan].led_current;
-	led->max_current = pdata->led_config[chan].max_current;
-	led->chan_nr = pdata->led_config[chan].chan_nr;
-
-	if (led->chan_nr >= LP5521_MAX_LEDS) {
-		dev_err(dev, "Use channel numbers between 0 and %d\n",
-			LP5521_MAX_LEDS - 1);
-		return -EINVAL;
-	}
-
-	led->cdev.brightness_set = lp5521_set_brightness;
-	if (pdata->led_config[chan].name) {
-		led->cdev.name = pdata->led_config[chan].name;
-	} else {
-		snprintf(name, sizeof(name), "%s:channel%d",
-			pdata->label ?: client->name, chan);
-		led->cdev.name = name;
-	}
-
-	res = led_classdev_register(dev, &led->cdev);
-	if (res < 0) {
-		dev_err(dev, "couldn't register led on channel %d\n", chan);
-		return res;
-	}
-
-	res = sysfs_create_group(&led->cdev.dev->kobj,
-			&lp5521_led_attribute_group);
-	if (res < 0) {
-		dev_err(dev, "couldn't register current attribute\n");
-		led_classdev_unregister(&led->cdev);
-		return res;
-	}
-	return 0;
-}
-
 static void lp5521_unregister_leds(struct lp5521_chip *chip)
 {
 	int i;
@@ -753,6 +704,7 @@ static struct lp55xx_device_config lp5521_cfg = {
 		.addr = LP5521_REG_ENABLE,
 		.val  = LP5521_ENABLE_DEFAULT,
 	},
+	.max_channel  = LP5521_MAX_LEDS,
 	.post_init_device   = lp5521_post_init_device,
 };
 
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index aa77f40..e534ec4 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -94,7 +94,7 @@
 #define LP5523_PROGRAM_PAGES		6
 #define LP5523_ADC_SHORTCIRC_LIM	80
 
-#define LP5523_LEDS			9
+#define LP5523_MAX_LEDS			9
 #define LP5523_ENGINES			3
 
 #define LP5523_ENG_MASK_BASE		0x30 /* 00110000 */
@@ -136,7 +136,7 @@ struct lp5523_chip {
 	struct mutex		lock; /* Serialize control */
 	struct i2c_client	*client;
 	struct lp5523_engine	engines[LP5523_ENGINES];
-	struct lp5523_led	leds[LP5523_LEDS];
+	struct lp5523_led	leds[LP5523_MAX_LEDS];
 	struct lp5523_platform_data *pdata;
 	u8			num_channels;
 	u8			num_leds;
@@ -285,7 +285,7 @@ static int lp5523_mux_parse(const char *buf, u16 *mux, size_t len)
 	int i;
 	u16 tmp_mux = 0;
 
-	len = min_t(int, len, LP5523_LEDS);
+	len = min_t(int, len, LP5523_MAX_LEDS);
 	for (i = 0; i < len; i++) {
 		switch (buf[i]) {
 		case '1':
@@ -308,7 +308,7 @@ static int lp5523_mux_parse(const char *buf, u16 *mux, size_t len)
 static void lp5523_mux_to_array(u16 led_mux, char *array)
 {
 	int i, pos = 0;
-	for (i = 0; i < LP5523_LEDS; i++)
+	for (i = 0; i < LP5523_MAX_LEDS; i++)
 		pos += sprintf(array + pos, "%x", LED_ACTIVE(led_mux, i));
 
 	array[pos] = '\0';
@@ -324,7 +324,7 @@ static ssize_t show_engine_leds(struct device *dev,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct lp5523_chip *chip = i2c_get_clientdata(client);
-	char mux[LP5523_LEDS + 1];
+	char mux[LP5523_MAX_LEDS + 1];
 
 	lp5523_mux_to_array(chip->engines[nr - 1].led_mux, mux);
 
@@ -417,7 +417,7 @@ static ssize_t lp5523_selftest(struct device *dev,
 
 	vdd--;	/* There may be some fluctuation in measurement */
 
-	for (i = 0; i < LP5523_LEDS; i++) {
+	for (i = 0; i < LP5523_MAX_LEDS; i++) {
 		/* Skip non-existing channels */
 		if (chip->pdata->led_config[i].led_current == 0)
 			continue;
@@ -785,55 +785,6 @@ static int __init lp5523_init_engine(struct lp5523_engine *engine, int id)
 	return 0;
 }
 
-static int __devinit lp5523_init_led(struct lp5523_led *led, struct device *dev,
-			   int chan, struct lp5523_platform_data *pdata,
-			   const char *chip_name)
-{
-	char name[32];
-	int res;
-
-	if (chan >= LP5523_LEDS)
-		return -EINVAL;
-
-	if (pdata->led_config[chan].led_current) {
-		led->led_current = pdata->led_config[chan].led_current;
-		led->max_current = pdata->led_config[chan].max_current;
-		led->chan_nr = pdata->led_config[chan].chan_nr;
-
-		if (led->chan_nr >= LP5523_LEDS) {
-			dev_err(dev, "Use channel numbers between 0 and %d\n",
-				LP5523_LEDS - 1);
-			return -EINVAL;
-		}
-
-		if (pdata->led_config[chan].name) {
-			led->cdev.name = pdata->led_config[chan].name;
-		} else {
-			snprintf(name, sizeof(name), "%s:channel%d",
-				pdata->label ? : chip_name, chan);
-			led->cdev.name = name;
-		}
-
-		led->cdev.brightness_set = lp5523_set_brightness;
-		res = led_classdev_register(dev, &led->cdev);
-		if (res < 0) {
-			dev_err(dev, "couldn't register led on channel %d\n",
-				chan);
-			return res;
-		}
-		res = sysfs_create_group(&led->cdev.dev->kobj,
-				&lp5523_led_attribute_group);
-		if (res < 0) {
-			dev_err(dev, "couldn't register current attribute\n");
-			led_classdev_unregister(&led->cdev);
-			return res;
-		}
-	} else {
-		led->led_current = 0;
-	}
-	return 0;
-}
-
 static void lp5523_unregister_leds(struct lp5523_chip *chip)
 {
 	int i;
@@ -854,6 +805,7 @@ static struct lp55xx_device_config lp5523_cfg = {
 		.addr = LP5523_REG_ENABLE,
 		.val  = LP5523_ENABLE,
 	},
+	.max_channel  = LP5523_MAX_LEDS,
 	.post_init_device   = lp5523_post_init_device,
 };
 
diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index 55ac340..e85e8dc 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -63,6 +63,65 @@ static int lp55xx_post_init_device(struct lp55xx_chip *chip)
 	return cfg->post_init_device(chip);
 }
 
+static int lp55xx_init_led(struct lp55xx_led *led,
+			struct lp55xx_chip *chip, int chan)
+{
+	struct lp55xx_platform_data *pdata = chip->pdata;
+	struct lp55xx_device_config *cfg = chip->cfg;
+	struct device *dev = &chip->cl->dev;
+	char name[32];
+	int ret;
+	int max_channel = cfg->max_channel;
+
+	if (chan >= max_channel) {
+		dev_err(dev, "invalid channel: %d / %d\n", chan, max_channel);
+		return -EINVAL;
+	}
+
+	if (pdata->led_config[chan].led_current == 0)
+		return 0;
+
+	led->led_current = pdata->led_config[chan].led_current;
+	led->max_current = pdata->led_config[chan].max_current;
+	led->chan_nr = pdata->led_config[chan].chan_nr;
+
+	if (led->chan_nr >= max_channel) {
+		dev_err(dev, "Use channel numbers between 0 and %d\n",
+			max_channel - 1);
+		return -EINVAL;
+	}
+
+	led->cdev.brightness_set = lp55xx_set_brightness;
+
+	if (pdata->led_config[chan].name) {
+		led->cdev.name = pdata->led_config[chan].name;
+	} else {
+		snprintf(name, sizeof(name), "%s:channel%d",
+			pdata->label ? : chip->cl->name, chan);
+		led->cdev.name = name;
+	}
+
+	/*
+	 * register led class device for each channel and
+	 * add device attributes
+	 */
+
+	ret = led_classdev_register(dev, &led->cdev);
+	if (ret) {
+		dev_err(dev, "led register err: %d\n", ret);
+		return ret;
+	}
+
+	ret = sysfs_create_group(&led->cdev.dev->kobj, &lp55xx_led_attr_group);
+	if (ret) {
+		dev_err(dev, "led sysfs err: %d\n", ret);
+		led_classdev_unregister(&led->cdev);
+		return ret;
+	}
+
+	return 0;
+}
+
 int lp55xx_write(struct lp55xx_chip *chip, u8 reg, u8 val)
 {
 	return i2c_smbus_write_byte_data(chip->cl, reg, val);
diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
index 8283906..1bacc41 100644
--- a/drivers/leds/leds-lp55xx-common.h
+++ b/drivers/leds/leds-lp55xx-common.h
@@ -32,11 +32,13 @@ struct lp55xx_reg {
  * struct lp55xx_device_config
  * @reset              : Chip specific reset command
  * @enable             : Chip specific enable command
+ * @max_channel        : Maximum number of channels
  * @post_init_device   : Chip specific initialization code
  */
 struct lp55xx_device_config {
 	const struct lp55xx_reg reset;
 	const struct lp55xx_reg enable;
+	const int max_channel;
 
 	/* define if the device has specific initialization process */
 	int (*post_init_device) (struct lp55xx_chip *chip);
-- 
1.7.9.5


Best Regards,
Milo


