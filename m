Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab2LFGca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 01:32:30 -0500
Received: from mail.active-venture.com ([67.228.131.205]:58239 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab2LFGc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 01:32:29 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Thu, 06 Dec 2012 00:32:29 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] gpio: export 'debounce' attribute if supported by the gpio chip
Date: Wed,  5 Dec 2012 22:32:47 -0800
Message-Id: <1354775567-17408-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a 'debounce' attribute if debounce is supported by the gpio
chip and a gpio pin is exported.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/gpio/gpiolib.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a971e3d..13ee9a7 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -67,6 +67,7 @@ struct gpio_desc {
 #ifdef CONFIG_DEBUG_FS
 	const char		*label;
 #endif
+	unsigned		debounce;
 };
 static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 
@@ -215,6 +216,10 @@ static DEFINE_MUTEX(sysfs_lock);
  *      * is read/write as zero/nonzero
  *      * also affects existing and subsequent "falling" and "rising"
  *        /edge configuration
+ *   /debounce
+ *      * configures debounce time in uS
+ *      * available only if debounce is supported by the chip
+ *      * is read/write; 0 to disable or debounce time
  */
 
 static ssize_t gpio_direction_show(struct device *dev,
@@ -320,6 +325,55 @@ static ssize_t gpio_value_store(struct device *dev,
 static const DEVICE_ATTR(value, 0644,
 		gpio_value_show, gpio_value_store);
 
+static ssize_t gpio_debounce_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+	ssize_t status;
+
+	mutex_lock(&sysfs_lock);
+
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		status = -EIO;
+	else
+		status = sprintf(buf, "%u\n", desc->debounce);
+
+	mutex_unlock(&sysfs_lock);
+	return status;
+}
+
+static ssize_t gpio_debounce_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t size)
+{
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+	unsigned		gpio = desc - gpio_desc;
+	ssize_t			status;
+
+	mutex_lock(&sysfs_lock);
+
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		status = -EIO;
+	else if (test_bit(FLAG_IS_OUT, &desc->flags))
+		status = -EPERM;
+	else {
+		long		value;
+
+		status = kstrtoul(buf, 0, &value);
+		if (status == 0) {
+			status = gpio_set_debounce(gpio, value);
+			if (status == 0)
+				status = size;
+		}
+	}
+
+	mutex_unlock(&sysfs_lock);
+	return status;
+}
+
+static const DEVICE_ATTR(debounce, 0644,
+			 gpio_debounce_show, gpio_debounce_store);
+
 static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
 {
 	struct sysfs_dirent	*value_sd = priv;
@@ -741,6 +795,10 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 				status = device_create_file(dev,
 						&dev_attr_direction);
 
+			if (!status && desc->chip->set_debounce)
+				status = device_create_file(dev,
+						&dev_attr_debounce);
+
 			if (!status && gpio_to_irq(gpio) >= 0
 					&& (direction_may_change
 						|| !test_bit(FLAG_IS_OUT,
@@ -1507,6 +1565,7 @@ int gpio_set_debounce(unsigned gpio, unsigned debounce)
 
 	might_sleep_if(chip->can_sleep);
 
+	desc->debounce = debounce;
 	return chip->set_debounce(chip, gpio, debounce);
 
 fail:
-- 
1.7.5.4

