Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab2BMGcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 01:32:08 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15038 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab2BMGb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 01:31:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 12 Feb 2012 22:31:52 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        dunlap@xenotime.net, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1 1/3] gpio: gpiolib: Support for open drain gpios
Date: Mon, 13 Feb 2012 11:59:46 +0530
Message-Id: <1329114588-15430-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1329114588-15430-1-git-send-email-ldewangan@nvidia.com>
References: <1329114588-15430-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for the open drain gpio on which client
can specify the open drain property through GPIO flag
at the time of gpio request.
The open drain pins cannot be driven to output with
value of 1 and so when client request for setting the
pin to HIGH, the gpio will be set to input direction
and hence PULL-UP on pins will make the state to HIGH.
The open drain pin can be driven to 0 by setting output
with value of 0.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/gpio/gpiolib.c |  144 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/gpio.h   |    3 +
 2 files changed, 145 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 17fdf4b..2347324 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -58,6 +58,7 @@ struct gpio_desc {
 #define FLAG_TRIG_FALL	5	/* trigger on falling edge */
 #define FLAG_TRIG_RISE	6	/* trigger on rising edge */
 #define FLAG_ACTIVE_LOW	7	/* sysfs value has active low */
+#define FLAG_OPEN_DRAIN 8	/* Gpio is open drain type */
 
 #define ID_SHIFT	16	/* add new flags before this one */
 
@@ -543,9 +544,68 @@ static ssize_t gpio_active_low_store(struct device *dev,
 static const DEVICE_ATTR(active_low, 0644,
 		gpio_active_low_show, gpio_active_low_store);
 
+static int sysfs_set_open_drain(struct gpio_desc *desc, struct device *dev,
+				int value)
+{
+	if (!!test_bit(FLAG_OPEN_DRAIN, &desc->flags) == !!value)
+		return 0;
+
+	if (value)
+		set_bit(FLAG_OPEN_DRAIN, &desc->flags);
+	else
+		clear_bit(FLAG_OPEN_DRAIN, &desc->flags);
+	return 0;
+}
+
+static ssize_t gpio_open_drain_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+	ssize_t			status;
+
+	mutex_lock(&sysfs_lock);
+
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		status = -EIO;
+	else
+		status = sprintf(buf, "%d\n",
+				!!test_bit(FLAG_OPEN_DRAIN, &desc->flags));
+
+	mutex_unlock(&sysfs_lock);
+
+	return status;
+}
+
+static ssize_t gpio_open_drain_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
+	ssize_t			status;
+
+	mutex_lock(&sysfs_lock);
+
+	if (!test_bit(FLAG_EXPORT, &desc->flags)) {
+		status = -EIO;
+	} else {
+		long		value;
+
+		status = strict_strtol(buf, 0, &value);
+		if (status == 0)
+			status = sysfs_set_open_drain(desc, dev, value != 0);
+	}
+
+	mutex_unlock(&sysfs_lock);
+
+	return status ? : size;
+}
+
+static const DEVICE_ATTR(open_drain, 0644,
+		gpio_open_drain_show, gpio_open_drain_store);
+
 static const struct attribute *gpio_attrs[] = {
 	&dev_attr_value.attr,
 	&dev_attr_active_low.attr,
+	&dev_attr_open_drain.attr,
 	NULL,
 };
 
@@ -864,6 +924,48 @@ done:
 EXPORT_SYMBOL_GPL(gpio_sysfs_set_active_low);
 
 /**
+ * gpio_sysfs_set_open_drain - set the open drain status of gpio sysfs value
+ * @gpio: gpio to change
+ * @value: non-zero to use open drain enable else open drain disable.
+ *
+ * Returns zero on success, else an error.
+ */
+int gpio_sysfs_set_open_drain(unsigned gpio, int value)
+{
+	struct gpio_desc	*desc;
+	struct device		*dev = NULL;
+	int			status = -EINVAL;
+
+	if (!gpio_is_valid(gpio))
+		goto done;
+
+	mutex_lock(&sysfs_lock);
+
+	desc = &gpio_desc[gpio];
+
+	if (test_bit(FLAG_EXPORT, &desc->flags)) {
+		dev = class_find_device(&gpio_class, NULL, desc, match_export);
+		if (dev == NULL) {
+			status = -ENODEV;
+			goto unlock;
+		}
+
+	}
+
+	status = sysfs_set_open_drain(desc, dev, value);
+
+unlock:
+	mutex_unlock(&sysfs_lock);
+
+done:
+	if (status)
+		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_sysfs_set_open_drain);
+
+/**
  * gpio_unexport - reverse effect of gpio_export()
  * @gpio: gpio to make unavailable
  *
@@ -1261,6 +1363,7 @@ void gpio_free(unsigned gpio)
 		module_put(desc->chip->owner);
 		clear_bit(FLAG_ACTIVE_LOW, &desc->flags);
 		clear_bit(FLAG_REQUESTED, &desc->flags);
+		clear_bit(FLAG_OPEN_DRAIN, &desc->flags);
 	} else
 		WARN_ON(extra_checks);
 
@@ -1282,6 +1385,9 @@ int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
 	if (err)
 		return err;
 
+	if (flags & GPIOF_OD)
+		set_bit(FLAG_OPEN_DRAIN, &gpio_desc[gpio].flags);
+
 	if (flags & GPIOF_DIR_IN)
 		err = gpio_direction_input(gpio);
 	else
@@ -1431,6 +1537,9 @@ int gpio_direction_output(unsigned gpio, int value)
 	struct gpio_desc	*desc = &gpio_desc[gpio];
 	int			status = -EINVAL;
 
+	if (value && test_bit(FLAG_OPEN_DRAIN,  &desc->flags))
+		return gpio_direction_input(gpio);
+
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	if (!gpio_is_valid(gpio))
@@ -1567,6 +1676,31 @@ int __gpio_get_value(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(__gpio_get_value);
 
+/*
+ *  _gpio_set_open_drain_value() - Set the open drain gpio's value.
+ * @gpio: Gpio whose state need to be set.
+ * @chip: Gpio chip.
+ * @value: Non-zero for setting it HIGH otherise it will set to LOW.
+ */
+static void _gpio_set_open_drain_value(unsigned gpio,
+			struct gpio_chip *chip, int value)
+{
+	int err = 0;
+	if (value) {
+		err = chip->direction_input(chip, gpio - chip->base);
+		if (!err)
+			clear_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
+	} else {
+		err = chip->direction_output(chip, gpio - chip->base, 0);
+		if (!err)
+			set_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
+	}
+	trace_gpio_direction(gpio, value, err);
+	if (err < 0)
+		pr_err("%s: Error in set_value for open drain gpio%d err %d\n",
+					__func__, gpio, err);
+}
+
 /**
  * __gpio_set_value() - assign a gpio's value
  * @gpio: gpio whose value will be assigned
@@ -1583,7 +1717,10 @@ void __gpio_set_value(unsigned gpio, int value)
 	chip = gpio_to_chip(gpio);
 	WARN_ON(chip->can_sleep);
 	trace_gpio_value(gpio, 0, value);
-	chip->set(chip, gpio - chip->base, value);
+	if (test_bit(FLAG_OPEN_DRAIN,  &gpio_desc[gpio].flags))
+		_gpio_set_open_drain_value(gpio, chip, value);
+	else
+		chip->set(chip, gpio - chip->base, value);
 }
 EXPORT_SYMBOL_GPL(__gpio_set_value);
 
@@ -1650,7 +1787,10 @@ void gpio_set_value_cansleep(unsigned gpio, int value)
 	might_sleep_if(extra_checks);
 	chip = gpio_to_chip(gpio);
 	trace_gpio_value(gpio, 0, value);
-	chip->set(chip, gpio - chip->base, value);
+	if (test_bit(FLAG_OPEN_DRAIN,  &gpio_desc[gpio].flags))
+		_gpio_set_open_drain_value(gpio, chip, value);
+	else
+		chip->set(chip, gpio - chip->base, value);
 }
 EXPORT_SYMBOL_GPL(gpio_set_value_cansleep);
 
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 38ac48b..13b32dd 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -14,6 +14,9 @@
 #define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
 #define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
 
+/* Gpio pin is open drain */
+#define GPIOF_OD	(1 << 2)
+
 /**
  * struct gpio - a structure describing a GPIO with configuration
  * @gpio:	the GPIO number
-- 
1.7.1.1

