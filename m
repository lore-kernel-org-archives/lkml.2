Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab2LLOCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:02:07 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42276 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab2LLOCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:02:03 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 15/33] leds-lp55xx: provide common LED current setting
Thread-Topic: [PATCH 15/33] leds-lp55xx: provide common LED current setting
Thread-Index: Ac3YcTyXVZopKC1kQwaX52s1yCklng==
Date: Wed, 12 Dec 2012 14:01:53 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AB55@DQHE02.ent.ti.com>
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

 LED current is configurable via the sysfs.
 Max current is a read-only attribute.
 These attributes code can be shared in lp55xx common driver.

 show_max_current()  => lp55xx_show_max_current()
 show_current()      => lp55xx_show_current()
 store_current()     => lp55xx_store_current()

 Current registers are device specific, so configurable function is added
 in each driver.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c        |   77 ++++---------------------------------
 drivers/leds/leds-lp5523.c        |   72 ++++------------------------------
 drivers/leds/leds-lp55xx-common.c |   66 +++++++++++++++++++++++++++++++
 drivers/leds/leds-lp55xx-common.h |    3 ++
 4 files changed, 85 insertions(+), 133 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index fbe7129..acf2495 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -134,6 +134,13 @@ static inline void lp5521_wait_enable_done(void)
 	usleep_range(500, 600);
 }
 
+static void lp5521_set_led_current(struct lp55xx_led *led, u8 led_current)
+{
+	led->led_current = led_current;
+	lp55xx_write(led->chip, LP5521_REG_LED_CURRENT_BASE + led->chan_nr,
+		led_current);
+}
+
 static inline struct lp5521_led *cdev_to_led(struct led_classdev *cdev)
 {
 	return container_of(cdev, struct lp5521_led, cdev);
@@ -229,13 +236,6 @@ static int lp5521_load_program(struct lp5521_engine *eng, const u8 *pattern)
 	return lp5521_write(client, LP5521_REG_OP_MODE, mode);
 }
 
-static int lp5521_set_led_current(struct lp5521_chip *chip, int led, u8 curr)
-{
-	return lp5521_write(chip->client,
-		    LP5521_REG_LED_CURRENT_BASE + chip->leds[led].chan_nr,
-		    curr);
-}
-
 static int lp5521_post_init_device(struct lp55xx_chip *chip)
 {
 	int ret;
@@ -457,54 +457,6 @@ store_mode(1)
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
@@ -610,20 +562,6 @@ static ssize_t store_led_pattern(struct device *dev,
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
@@ -695,6 +633,7 @@ static struct lp55xx_device_config lp5521_cfg = {
 	.max_channel  = LP5521_MAX_LEDS,
 	.post_init_device   = lp5521_post_init_device,
 	.brightness_work_fn = lp5521_led_brightness_work,
+	.set_led_current    = lp5521_set_led_current,
 };
 
 static int __devinit lp5521_probe(struct i2c_client *client,
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index c2927d8..4ae43ac 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -142,6 +142,13 @@ struct lp5523_chip {
 	u8			num_leds;
 };
 
+static void lp5523_set_led_current(struct lp55xx_led *led, u8 led_current)
+{
+	led->led_current = led_current;
+	lp55xx_write(led->chip, LP5523_REG_LED_CURRENT_BASE + led->chan_nr,
+		led_current);
+}
+
 static inline struct lp5523_led *cdev_to_led(struct led_classdev *cdev)
 {
 	return container_of(cdev, struct lp5523_led, cdev);
@@ -602,70 +609,6 @@ store_mode(1)
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
-	if (kstrtoul(buf, 0, &curr))
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
@@ -792,6 +735,7 @@ static struct lp55xx_device_config lp5523_cfg = {
 	.max_channel  = LP5523_MAX_LEDS,
 	.post_init_device   = lp5523_post_init_device,
 	.brightness_work_fn = lp5523_led_brightness_work,
+	.set_led_current    = lp5523_set_led_current,
 };
 
 static int __devinit lp5523_probe(struct i2c_client *client,
diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index 59f0975..81ed90d 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -20,6 +20,16 @@
 
 #include "leds-lp55xx-common.h"
 
+static struct lp55xx_led *cdev_to_lp55xx_led(struct led_classdev *cdev)
+{
+	return container_of(cdev, struct lp55xx_led, cdev);
+}
+
+static struct lp55xx_led *dev_to_lp55xx_led(struct device *dev)
+{
+	return cdev_to_lp55xx_led(dev_get_drvdata(dev));
+}
+
 static void lp55xx_reset_device(struct lp55xx_chip *chip)
 {
 	struct lp55xx_device_config *cfg = chip->cfg;
@@ -63,6 +73,62 @@ static int lp55xx_post_init_device(struct lp55xx_chip *chip)
 	return cfg->post_init_device(chip);
 }
 
+static ssize_t lp55xx_show_current(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct lp55xx_led *led = dev_to_lp55xx_led(dev);
+
+	return sprintf(buf, "%d\n", led->led_current);
+}
+
+static ssize_t lp55xx_store_current(struct device *dev,
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
+static ssize_t lp55xx_show_max_current(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct lp55xx_led *led = dev_to_lp55xx_led(dev);
+
+	return sprintf(buf, "%d\n", led->max_current);
+}
+
+static DEVICE_ATTR(led_current, S_IRUGO | S_IWUSR, lp55xx_show_current,
+		lp55xx_store_current);
+static DEVICE_ATTR(max_current, S_IRUGO , lp55xx_show_max_current, NULL);
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
 static void lp55xx_set_brightness(struct led_classdev *cdev,
 			     enum led_brightness brightness)
 {
diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
index 194ac2a..595bbf3 100644
--- a/drivers/leds/leds-lp55xx-common.h
+++ b/drivers/leds/leds-lp55xx-common.h
@@ -46,6 +46,9 @@ struct lp55xx_device_config {
 
 	/* access brightness register */
 	void (*brightness_work_fn)(struct work_struct *work);
+
+	/* current setting function */
+	void (*set_led_current) (struct lp55xx_led *led, u8 led_current);
 };
 
 /*
-- 
1.7.9.5


Best Regards,
Milo


