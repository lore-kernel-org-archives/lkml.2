Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab2EVKGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:06:03 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55197 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2EVKF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:05:59 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rob Landley <rob@landley.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 1/2] leds: lm3533: replace als attribute with als_channel and als_en
Date: Tue, 22 May 2012 12:05:07 +0200
Message-Id: <1337681108-13838-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the als attribute with two separate attributes for selecting ALS
channel and enabling ALS-current-control mode.

This change is needed to reflect changes made to the ALS sub-driver
which now uses 0-indexed current output channels (rather than 1-indexed
ALS-mapper target sets).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 .../ABI/testing/sysfs-class-led-driver-lm3533      |   19 +++-
 drivers/leds/leds-lm3533.c                         |   98 +++++++++++++++-----
 2 files changed, 87 insertions(+), 30 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-led-driver-lm3533 b/Documentation/ABI/testing/sysfs-class-led-driver-lm3533
index a9633fd..620ebb3 100644
--- a/Documentation/ABI/testing/sysfs-class-led-driver-lm3533
+++ b/Documentation/ABI/testing/sysfs-class-led-driver-lm3533
@@ -1,13 +1,20 @@
-What:		/sys/class/leds/<led>/als
-Date:		April 2012
+What:		/sys/class/leds/<led>/als_channel
+Date:		May 2012
 KernelVersion:	3.5
 Contact:	Johan Hovold <jhovold@gmail.com>
 Description:
-		Set the ALS-control mode (0, 2, 3), where
+		Set the ALS output channel to use as input in
+		ALS-current-control mode (1, 2), where
+
+		1 - out_current1
+		2 - out_current2
 
-		0 - disabled
-		2 - ALS-mapper 2
-		3 - ALS-mapper 3
+What:		/sys/class/leds/<led>/als_en
+Date:		May 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Enable ALS-current-control mode (0, 1).
 
 What:		/sys/class/leds/<led>/falltime
 What:		/sys/class/leds/<led>/risetime
diff --git a/drivers/leds/leds-lm3533.c b/drivers/leds/leds-lm3533.c
index e968470..f56b6e7 100644
--- a/drivers/leds/leds-lm3533.c
+++ b/drivers/leds/leds-lm3533.c
@@ -27,8 +27,8 @@
 #define LM3533_LVCTRLBANK_MAX		5
 #define LM3533_LVCTRLBANK_COUNT		4
 #define LM3533_RISEFALLTIME_MAX		7
-#define LM3533_ALS_LV_MIN		2
-#define LM3533_ALS_LV_MAX		3
+#define LM3533_ALS_CHANNEL_LV_MIN	1
+#define LM3533_ALS_CHANNEL_LV_MAX	2
 
 #define LM3533_REG_CTRLBANK_BCONF_BASE		0x1b
 #define LM3533_REG_PATTERN_ENABLE		0x28
@@ -39,8 +39,9 @@
 
 #define LM3533_REG_PATTERN_STEP			0x10
 
-#define LM3533_REG_CTRLBANK_BCONF_MAPPING_MASK	0x04
-#define LM3533_REG_CTRLBANK_BCONF_ALS_MASK	0x03
+#define LM3533_REG_CTRLBANK_BCONF_MAPPING_MASK		0x04
+#define LM3533_REG_CTRLBANK_BCONF_ALS_EN_MASK		0x02
+#define LM3533_REG_CTRLBANK_BCONF_ALS_CHANNEL_MASK	0x01
 
 #define LM3533_LED_FLAG_PATTERN_ENABLE		1
 
@@ -416,21 +417,14 @@ static ssize_t store_falltime(struct device *dev,
 					LM3533_REG_PATTERN_FALLTIME_BASE);
 }
 
-/*
- * ALS-control setting:
- *
- *   0 - ALS disabled
- *   2 - ALS-mapper 2
- *   3 - ALS-mapper 3
- */
-static ssize_t show_als(struct device *dev,
+static ssize_t show_als_channel(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct lm3533_led *led = to_lm3533_led(led_cdev);
+	unsigned channel;
 	u8 reg;
 	u8 val;
-	int als;
 	int ret;
 
 	reg = lm3533_led_get_lv_reg(led, LM3533_REG_CTRLBANK_BCONF_BASE);
@@ -438,32 +432,85 @@ static ssize_t show_als(struct device *dev,
 	if (ret)
 		return ret;
 
-	als = val & LM3533_REG_CTRLBANK_BCONF_ALS_MASK;
+	channel = (val & LM3533_REG_CTRLBANK_BCONF_ALS_CHANNEL_MASK) + 1;
 
-	return scnprintf(buf, PAGE_SIZE, "%d\n", als);
+	return scnprintf(buf, PAGE_SIZE, "%u\n", channel);
 }
 
-static ssize_t store_als(struct device *dev,
+static ssize_t store_als_channel(struct device *dev,
 					struct device_attribute *attr,
 					const char *buf, size_t len)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct lm3533_led *led = to_lm3533_led(led_cdev);
-	u8 als;
+	unsigned channel;
 	u8 reg;
+	u8 val;
 	u8 mask;
 	int ret;
 
-	if (kstrtou8(buf, 0, &als))
+	if (kstrtouint(buf, 0, &channel))
 		return -EINVAL;
 
-	if (als != 0 && (als < LM3533_ALS_LV_MIN || als > LM3533_ALS_LV_MAX))
+	if (channel < LM3533_ALS_CHANNEL_LV_MIN ||
+					channel > LM3533_ALS_CHANNEL_LV_MAX)
 		return -EINVAL;
 
 	reg = lm3533_led_get_lv_reg(led, LM3533_REG_CTRLBANK_BCONF_BASE);
-	mask = LM3533_REG_CTRLBANK_BCONF_ALS_MASK;
+	mask = LM3533_REG_CTRLBANK_BCONF_ALS_CHANNEL_MASK;
+	val = channel - 1;
+
+	ret = lm3533_update(led->lm3533, reg, val, mask);
+	if (ret)
+		return ret;
+
+	return len;
+}
+
+static ssize_t show_als_en(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3533_led *led = to_lm3533_led(led_cdev);
+	bool enable;
+	u8 reg;
+	u8 val;
+	int ret;
+
+	reg = lm3533_led_get_lv_reg(led, LM3533_REG_CTRLBANK_BCONF_BASE);
+	ret = lm3533_read(led->lm3533, reg, &val);
+	if (ret)
+		return ret;
 
-	ret = lm3533_update(led->lm3533, reg, als, mask);
+	enable = val & LM3533_REG_CTRLBANK_BCONF_ALS_EN_MASK;
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", enable);
+}
+
+static ssize_t store_als_en(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3533_led *led = to_lm3533_led(led_cdev);
+	unsigned enable;
+	u8 reg;
+	u8 mask;
+	u8 val;
+	int ret;
+
+	if (kstrtouint(buf, 0, &enable))
+		return -EINVAL;
+
+	reg = lm3533_led_get_lv_reg(led, LM3533_REG_CTRLBANK_BCONF_BASE);
+	mask = LM3533_REG_CTRLBANK_BCONF_ALS_EN_MASK;
+
+	if (enable)
+		val = mask;
+	else
+		val = 0;
+
+	ret = lm3533_update(led->lm3533, reg, val, mask);
 	if (ret)
 		return ret;
 
@@ -558,7 +605,8 @@ static ssize_t store_pwm(struct device *dev,
 	return len;
 }
 
-static LM3533_ATTR_RW(als);
+static LM3533_ATTR_RW(als_channel);
+static LM3533_ATTR_RW(als_en);
 static LM3533_ATTR_RW(falltime);
 static LM3533_ATTR_RO(id);
 static LM3533_ATTR_RW(linear);
@@ -566,7 +614,8 @@ static LM3533_ATTR_RW(pwm);
 static LM3533_ATTR_RW(risetime);
 
 static struct attribute *lm3533_led_attributes[] = {
-	&dev_attr_als.attr,
+	&dev_attr_als_channel.attr,
+	&dev_attr_als_en.attr,
 	&dev_attr_falltime.attr,
 	&dev_attr_id.attr,
 	&dev_attr_linear.attr,
@@ -583,7 +632,8 @@ static umode_t lm3533_led_attr_is_visible(struct kobject *kobj,
 	struct lm3533_led *led = to_lm3533_led(led_cdev);
 	umode_t mode = attr->mode;
 
-	if (attr == &dev_attr_als.attr) {
+	if (attr == &dev_attr_als_channel.attr ||
+					attr == &dev_attr_als_en.attr) {
 		if (!led->lm3533->have_als)
 			mode = 0;
 	}
-- 
1.7.8.5

