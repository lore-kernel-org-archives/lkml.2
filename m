Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2JEINU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:13:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55715 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab2JEINM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:13:12 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/28] leds-lp5521/5523: cleanup initializing LEDs
Thread-Topic: [PATCH 06/28] leds-lp5521/5523: cleanup initializing LEDs
Thread-Index: Ac2i0Tqp+tN1p6ZbRFiDTbjBUlEJww==
Date: Fri, 5 Oct 2012 08:12:58 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6417673E@DQHE02.ent.ti.com>
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

 Initializing LEDs of LP55xx family devices is as follows.

 (1) Register LED class device.
 (2) Create the LED attributes (R/W LED current and get max current).
 (3) Initialize a workqueue for the brightness control.
 (4) Repeat (1) to (3) a number of channels.

 Many lines of code are moved to the lp55xx common driver.
 (lp55xx_register_leds() and lp55xx_init_led())

 The error occurs while registering LEDs, registered LEDs should be unregistered.
 This work is handled by the lp55xx_unregister_leds().
 For the future use, this function is exported.
 In the LP5521 and LP5523/55231 driver, additional error handling is required.
 The device should be de-initialized as well as unregistering LEDs.
 Therefore, err_register_leds condition is added in _probe().

 However, this patch is not sufficient because there are different information
 between LP5521 and LP5523/55231.
   o LED brightness register address
   o LED current register address
   o A number of channels (LP5521: max 3, LP5523/55231: max 9 channels)
 For resolving this limitation, the next three patches are required.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c        |  156 ++------------------------------
 drivers/leds/leds-lp5523.c        |  159 ++------------------------------
 drivers/leds/leds-lp55xx-common.c |  181 +++++++++++++++++++++++++++++++++++++
 drivers/leds/leds-lp55xx-common.h |    6 ++
 4 files changed, 199 insertions(+), 303 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 0f2bbd5..18c194c 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -469,54 +469,6 @@ store_mode(1)
 store_mode(2)
 store_mode(3)
 
-static ssize_t show_max_current(struct device *dev,
-			    struct device_attribute *attr,
-			    char *buf)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct lp5521_led *led = cdev_to_led(led_cdev);
-
-	return sprintf(buf, "%d\n", led->max_current);
-}
-
-static ssize_t show_current(struct device *dev,
-			    struct device_attribute *attr,
-			    char *buf)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct lp5521_led *led = cdev_to_led(led_cdev);
-
-	return sprintf(buf, "%d\n", led->led_current);
-}
-
-static ssize_t store_current(struct device *dev,
-			     struct device_attribute *attr,
-			     const char *buf, size_t len)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct lp5521_led *led = cdev_to_led(led_cdev);
-	struct lp5521_chip *chip = led_to_lp5521(led);
-	ssize_t ret;
-	unsigned long curr;
-
-	if (kstrtoul(buf, 0, &curr))
-		return -EINVAL;
-
-	if (curr > led->max_current)
-		return -EINVAL;
-
-	mutex_lock(&chip->lock);
-	ret = lp5521_set_led_current(chip, led->id, curr);
-	mutex_unlock(&chip->lock);
-
-	if (ret < 0)
-		return ret;
-
-	led->led_current = (u8)curr;
-
-	return len;
-}
-
 static ssize_t lp5521_selftest(struct device *dev,
 			       struct device_attribute *attr,
 			       char *buf)
@@ -622,20 +574,6 @@ static ssize_t store_led_pattern(struct device *dev,
 	return len;
 }
 
-/* led class device attributes */
-static DEVICE_ATTR(led_current, S_IRUGO | S_IWUSR, show_current, store_current);
-static DEVICE_ATTR(max_current, S_IRUGO , show_max_current, NULL);
-
-static struct attribute *lp5521_led_attributes[] = {
-	&dev_attr_led_current.attr,
-	&dev_attr_max_current.attr,
-	NULL,
-};
-
-static struct attribute_group lp5521_led_attribute_group = {
-	.attrs = lp5521_led_attributes
-};
-
 /* device attributes */
 static DEVICE_ATTR(engine1_mode, S_IRUGO | S_IWUSR,
 		   show_engine1_mode, store_engine1_mode);
@@ -673,64 +611,9 @@ static int lp5521_register_sysfs(struct i2c_client *client)
 
 static void lp5521_unregister_sysfs(struct i2c_client *client)
 {
-	struct lp5521_chip *chip = i2c_get_clientdata(client);
 	struct device *dev = &client->dev;
-	int i;
 
 	sysfs_remove_group(&dev->kobj, &lp5521_group);
-
-	for (i = 0; i < chip->num_leds; i++)
-		sysfs_remove_group(&chip->leds[i].cdev.dev->kobj,
-				&lp5521_led_attribute_group);
-}
-
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
 }
 
 /* Chip specific configurations */
@@ -750,8 +633,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct lp5521_chip		*old_chip;
-	struct lp5521_platform_data	*old_pdata;
-	int ret, i, old_led;
+	int ret, i;
 	struct lp55xx_chip *chip;
 	struct lp55xx_led *led;
 	struct lp55xx_platform_data *pdata = client->dev.platform_data;
@@ -784,32 +666,9 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 
 	dev_info(&client->dev, "%s programmable led chip found\n", id->name);
 
-	/* Initialize leds */
-	old_chip->num_channels = old_pdata->num_channels;
-	old_chip->num_leds = 0;
-	old_led = 0;
-	for (i = 0; i < old_pdata->num_channels; i++) {
-		/* Do not initialize channels that are not connected */
-		if (old_pdata->led_config[i].led_current == 0)
-			continue;
-
-		ret = lp5521_init_led(&old_chip->leds[old_led], client, i, old_pdata);
-		if (ret) {
-			dev_err(&client->dev, "error initializing leds\n");
-			goto fail2;
-		}
-		old_chip->num_leds++;
-
-		old_chip->leds[old_led].id = old_led;
-		/* Set initial LED current */
-		lp5521_set_led_current(old_chip, old_led,
-				old_chip->leds[old_led].led_current);
-
-		INIT_WORK(&(old_chip->leds[old_led].brightness_work),
-			lp5521_led_brightness_work);
-
-		old_led++;
-	}
+	ret = lp55xx_register_leds(led, chip);
+	if (ret)
+		goto err_register_leds;
 
 	ret = lp5521_register_sysfs(client);
 	if (ret) {
@@ -822,11 +681,8 @@ fail2:
 		led_classdev_unregister(&old_chip->leds[i].cdev);
 		cancel_work_sync(&old_chip->leds[i].brightness_work);
 	}
-fail1:
-	if (old_pdata->enable)
-		old_pdata->enable(0);
-	if (old_pdata->release_resources)
-		old_pdata->release_resources();
+err_register_leds:
+	lp55xx_deinit_device(chip);
 err_init:
 	return ret;
 }
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index c487a91..58c252e 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -607,70 +607,6 @@ store_mode(1)
 store_mode(2)
 store_mode(3)
 
-static ssize_t show_max_current(struct device *dev,
-			    struct device_attribute *attr,
-			    char *buf)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct lp5523_led *led = cdev_to_led(led_cdev);
-
-	return sprintf(buf, "%d\n", led->max_current);
-}
-
-static ssize_t show_current(struct device *dev,
-			    struct device_attribute *attr,
-			    char *buf)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct lp5523_led *led = cdev_to_led(led_cdev);
-
-	return sprintf(buf, "%d\n", led->led_current);
-}
-
-static ssize_t store_current(struct device *dev,
-			     struct device_attribute *attr,
-			     const char *buf, size_t len)
-{
-	struct led_classdev *led_cdev = dev_get_drvdata(dev);
-	struct lp5523_led *led = cdev_to_led(led_cdev);
-	struct lp5523_chip *chip = led_to_lp5523(led);
-	ssize_t ret;
-	unsigned long curr;
-
-	if (strict_strtoul(buf, 0, &curr))
-		return -EINVAL;
-
-	if (curr > led->max_current)
-		return -EINVAL;
-
-	mutex_lock(&chip->lock);
-	ret = lp5523_write(chip->client,
-			LP5523_REG_LED_CURRENT_BASE + led->chan_nr,
-			(u8)curr);
-	mutex_unlock(&chip->lock);
-
-	if (ret < 0)
-		return ret;
-
-	led->led_current = (u8)curr;
-
-	return len;
-}
-
-/* led class device attributes */
-static DEVICE_ATTR(led_current, S_IRUGO | S_IWUSR, show_current, store_current);
-static DEVICE_ATTR(max_current, S_IRUGO , show_max_current, NULL);
-
-static struct attribute *lp5523_led_attributes[] = {
-	&dev_attr_led_current.attr,
-	&dev_attr_max_current.attr,
-	NULL,
-};
-
-static struct attribute_group lp5523_led_attribute_group = {
-	.attrs = lp5523_led_attributes
-};
-
 /* device attributes */
 static DEVICE_ATTR(engine1_mode, S_IRUGO | S_IWUSR,
 		   show_engine1_mode, store_engine1_mode);
@@ -721,15 +657,9 @@ static int lp5523_register_sysfs(struct i2c_client *client)
 
 static void lp5523_unregister_sysfs(struct i2c_client *client)
 {
-	struct lp5523_chip *chip = i2c_get_clientdata(client);
 	struct device *dev = &client->dev;
-	int i;
 
 	sysfs_remove_group(&dev->kobj, &lp5523_group);
-
-	for (i = 0; i < chip->num_leds; i++)
-		sysfs_remove_group(&chip->leds[i].cdev.dev->kobj,
-				&lp5523_led_attribute_group);
 }
 
 /*--------------------------------------------------------------*/
@@ -762,54 +692,6 @@ static void lp5523_set_mode(struct lp5523_engine *engine, u8 mode)
 /*--------------------------------------------------------------*/
 /*			Probe, Attach, Remove			*/
 /*--------------------------------------------------------------*/
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
 
 /* Chip specific configurations */
 static struct lp55xx_device_config lp5523_cfg = {
@@ -828,8 +710,7 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct lp5523_chip		*old_chip;
-	struct lp5523_platform_data	*old_pdata;
-	int ret, i, old_led;
+	int ret, i;
 	struct lp55xx_chip *chip;
 	struct lp55xx_led *led;
 	struct lp55xx_platform_data *pdata = client->dev.platform_data;
@@ -862,34 +743,9 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 
 	dev_info(&client->dev, "%s Programmable led chip found\n", id->name);
 
-	/* Initialize leds */
-	old_chip->num_channels = old_pdata->num_channels;
-	old_chip->num_leds = 0;
-	old_led = 0;
-	for (i = 0; i < old_pdata->num_channels; i++) {
-		/* Do not initialize channels that are not connected */
-		if (old_pdata->led_config[i].led_current == 0)
-			continue;
-
-		INIT_WORK(&old_chip->leds[old_led].brightness_work,
-			lp5523_led_brightness_work);
-
-		ret = lp5523_init_led(&old_chip->leds[old_led], &client->dev, i, old_pdata,
-				id->name);
-		if (ret) {
-			dev_err(&client->dev, "error initializing leds\n");
-			goto fail2;
-		}
-		old_chip->num_leds++;
-
-		old_chip->leds[old_led].id = old_led;
-		/* Set LED current */
-		lp5523_write(client,
-			  LP5523_REG_LED_CURRENT_BASE + old_chip->leds[old_led].chan_nr,
-			  old_chip->leds[old_led].led_current);
-
-		old_led++;
-	}
+	ret = lp55xx_register_leds(led, chip);
+	if (ret)
+		goto err_register_leds;
 
 	ret = lp5523_register_sysfs(client);
 	if (ret) {
@@ -902,11 +758,8 @@ fail2:
 		led_classdev_unregister(&old_chip->leds[i].cdev);
 		flush_work(&old_chip->leds[i].brightness_work);
 	}
-fail1:
-	if (old_pdata->enable)
-		old_pdata->enable(0);
-	if (old_pdata->release_resources)
-		old_pdata->release_resources();
+err_register_leds:
+	lp55xx_deinit_device(chip);
 err_init:
 	return ret;
 }
diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index bab96a4..987c699 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -61,6 +61,129 @@ static int lp55xx_post_init_device(struct lp55xx_chip *chip)
 	return cfg->post_init_device(chip);
 }
 
+static ssize_t show_current(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct lp55xx_led *led = dev_to_lp55xx_led(dev);
+
+	return sprintf(buf, "%d\n", led->led_current);
+}
+
+static ssize_t store_current(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t len)
+{
+	struct lp55xx_led *led = dev_to_lp55xx_led(dev);
+	struct lp55xx_chip *chip = led->chip;
+	unsigned long curr;
+
+	if (kstrtoul(buf, 0, &curr))
+		return -EINVAL;
+
+	if (curr > led->max_current)
+		return -EINVAL;
+
+	if (!chip->cfg->set_led_current)
+		return len;
+
+	mutex_lock(&chip->lock);
+	chip->cfg->set_led_current(led, (u8)curr);
+	mutex_unlock(&chip->lock);
+
+	return len;
+}
+
+static ssize_t show_max_current(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct lp55xx_led *led = dev_to_lp55xx_led(dev);
+
+	return sprintf(buf, "%d\n", led->max_current);
+}
+
+static DEVICE_ATTR(led_current, S_IRUGO | S_IWUSR, show_current, store_current);
+static DEVICE_ATTR(max_current, S_IRUGO , show_max_current, NULL);
+
+static struct attribute *lp55xx_led_attributes[] = {
+	&dev_attr_led_current.attr,
+	&dev_attr_max_current.attr,
+	NULL,
+};
+
+static struct attribute_group lp55xx_led_attr_group = {
+	.attrs = lp55xx_led_attributes
+};
+
+static void lp55xx_set_brightness(struct led_classdev *cdev,
+			     enum led_brightness brightness)
+{
+	struct lp55xx_led *led = cdev_to_lp55xx_led(cdev);
+
+	led->brightness = (u8)brightness;
+	schedule_work(&led->brightness_work);
+}
+
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
@@ -179,3 +302,61 @@ void lp55xx_deinit_device(struct lp55xx_chip *chip)
 		pdata->release_resources();
 }
 EXPORT_SYMBOL_GPL(lp55xx_deinit_device);
+
+int lp55xx_register_leds(struct lp55xx_led *led, struct lp55xx_chip *chip)
+{
+	struct lp55xx_platform_data *pdata = chip->pdata;
+	struct lp55xx_device_config *cfg = chip->cfg;
+	int num_channels = pdata->num_channels;
+	struct lp55xx_led *each;
+	u8 led_current;
+	int ret;
+	int i;
+
+	if (!cfg->brightness_work_fn) {
+		dev_err(&chip->cl->dev, "empty brightness configuration\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < num_channels; i++) {
+
+		/* do not initialize channels that are not connected */
+		if (pdata->led_config[i].led_current == 0)
+			continue;
+
+		led_current = pdata->led_config[i].led_current;
+		each = led + i;
+		ret = lp55xx_init_led(each, chip, i);
+		if (ret)
+			goto err_init_led;
+
+		INIT_WORK(&each->brightness_work, cfg->brightness_work_fn);
+
+		chip->num_leds++;
+		each->chip = chip;
+
+		/* setting led current at each channel */
+		if (cfg->set_led_current)
+			cfg->set_led_current(each, led_current);
+	}
+
+	return 0;
+
+err_init_led:
+	lp55xx_unregister_leds(led, chip);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lp55xx_register_leds);
+
+void lp55xx_unregister_leds(struct lp55xx_led *led, struct lp55xx_chip *chip)
+{
+	int i;
+	struct lp55xx_led *each;
+
+	for (i = 0; i < chip->num_leds; i++) {
+		each = led + i;
+		led_classdev_unregister(&each->cdev);
+		flush_work(&each->brightness_work);
+	}
+}
+EXPORT_SYMBOL_GPL(lp55xx_unregister_leds);
diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
index eb5b691..66d7039 100644
--- a/drivers/leds/leds-lp55xx-common.h
+++ b/drivers/leds/leds-lp55xx-common.h
@@ -125,4 +125,10 @@ extern struct lp55xx_led *dev_to_lp55xx_led(struct device *dev);
 extern int lp55xx_init_device(struct lp55xx_chip *chip);
 extern void lp55xx_deinit_device(struct lp55xx_chip *chip);
 
+/* common LED class device functions */
+extern int lp55xx_register_leds(struct lp55xx_led *led,
+				struct lp55xx_chip *chip);
+extern void lp55xx_unregister_leds(struct lp55xx_led *led,
+				struct lp55xx_chip *chip);
+
 #endif /* __LINUX_LP55XX_COMMON_H */
-- 
1.7.9.5


Best Regards,
Milo


