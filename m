Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3AHHUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 02:20:07 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11575 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3AHHT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 02:19:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 07 Jan 2013 23:19:16 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 1/4] gpiolib: introduce descriptor-based GPIO interface
Date: Tue, 8 Jan 2013 16:18:52 +0900
Message-ID: <1357629535-26033-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357629535-26033-1-git-send-email-acourbot@nvidia.com>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current API, GPIOs are represented by a unique integer. This
causes problems in terms of security (GPIO numbers can be arbitrarily
forged and used without proper allocation) and flexibility (the maximum
number of GPIOs that the system can handle is fixed at compilation time
and a static array of that size is allocated to store the GPIO
descriptors).

This patch introduces an alternative GPIO API that uses opaque handlers
and refactors GPIOlib's internals to work with these handlers instead of
GPIO numbers. The former integer-based API is still available as a light
wrapper around this new API.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/devres.c         |  59 +++--
 drivers/gpio/gpiolib.c        | 486 +++++++++++++++++++++++-------------------
 include/asm-generic/gpio.h    | 176 ++++++---------
 include/linux/gpio/consumer.h |  64 ++++++
 include/linux/gpio/driver.h   | 112 ++++++++++
 5 files changed, 552 insertions(+), 345 deletions(-)
 create mode 100644 include/linux/gpio/consumer.h
 create mode 100644 include/linux/gpio/driver.h

diff --git a/drivers/gpio/devres.c b/drivers/gpio/devres.c
index 1077754..b7a9ad6 100644
--- a/drivers/gpio/devres.c
+++ b/drivers/gpio/devres.c
@@ -15,22 +15,24 @@
  */
 
 #include <linux/module.h>
+#include <linux/err.h>
 #include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/device.h>
 #include <linux/gfp.h>
 
 static void devm_gpio_release(struct device *dev, void *res)
 {
-	unsigned *gpio = res;
+	struct gpio_desc **desc = res;
 
-	gpio_free(*gpio);
+	gpiod_put(*desc);
 }
 
 static int devm_gpio_match(struct device *dev, void *res, void *data)
 {
-	unsigned *this = res, *gpio = data;
+	struct gpio_desc **this = res, **desc = data;
 
-	return *this == *gpio;
+	return *this == *desc;
 }
 
 /**
@@ -50,10 +52,11 @@ static int devm_gpio_match(struct device *dev, void *res, void *data)
 
 int devm_gpio_request(struct device *dev, unsigned gpio, const char *label)
 {
-	unsigned *dr;
+	struct gpio_desc **dr;
 	int rc;
 
-	dr = devres_alloc(devm_gpio_release, sizeof(unsigned), GFP_KERNEL);
+	dr = devres_alloc(devm_gpio_release, sizeof(struct gpio_desc *),
+			  GFP_KERNEL);
 	if (!dr)
 		return -ENOMEM;
 
@@ -63,7 +66,7 @@ int devm_gpio_request(struct device *dev, unsigned gpio, const char *label)
 		return rc;
 	}
 
-	*dr = gpio;
+	*dr = gpio_to_desc(gpio);
 	devres_add(dev, dr);
 
 	return 0;
@@ -80,10 +83,11 @@ EXPORT_SYMBOL(devm_gpio_request);
 int devm_gpio_request_one(struct device *dev, unsigned gpio,
 			  unsigned long flags, const char *label)
 {
-	unsigned *dr;
+	struct gpio_desc **dr;
 	int rc;
 
-	dr = devres_alloc(devm_gpio_release, sizeof(unsigned), GFP_KERNEL);
+	dr = devres_alloc(devm_gpio_release, sizeof(struct gpio_desc *),
+			  GFP_KERNEL);
 	if (!dr)
 		return -ENOMEM;
 
@@ -93,7 +97,7 @@ int devm_gpio_request_one(struct device *dev, unsigned gpio,
 		return rc;
 	}
 
-	*dr = gpio;
+	*dr = gpio_to_desc(gpio);
 	devres_add(dev, dr);
 
 	return 0;
@@ -112,8 +116,39 @@ EXPORT_SYMBOL(devm_gpio_request_one);
  */
 void devm_gpio_free(struct device *dev, unsigned int gpio)
 {
+	struct gpio_desc *desc = gpio_to_desc(gpio);
 
-	WARN_ON(devres_release(dev, devm_gpio_release, devm_gpio_match,
-		&gpio));
+	devm_gpiod_put(dev, desc);
 }
 EXPORT_SYMBOL(devm_gpio_free);
+
+struct gpio_desc *__must_check devm_gpiod_get(struct device *dev,
+						     const char *con_id)
+{
+	struct gpio_desc **dr;
+	struct gpio_desc *desc;
+
+	dr = devres_alloc(devm_gpio_release, sizeof(struct gpio_desc *),
+			  GFP_KERNEL);
+	if (!dr)
+		return ERR_PTR(-ENOMEM);
+
+	desc = gpiod_get(dev, con_id);
+	if (IS_ERR_OR_NULL(desc)) {
+		devres_free(dr);
+		return desc;
+	}
+
+	*dr = desc;
+	devres_add(dev, dr);
+
+	return 0;
+}
+EXPORT_SYMBOL(devm_gpiod_get);
+
+void devm_gpiod_put(struct device *dev, struct gpio_desc *desc)
+{
+	WARN_ON(devres_release(dev, devm_gpio_release, devm_gpio_match,
+		&desc));
+}
+EXPORT_SYMBOL(devm_gpiod_put);
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 199fca1..d04b90b 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -11,6 +11,8 @@
 #include <linux/of_gpio.h>
 #include <linux/idr.h>
 #include <linux/slab.h>
+#include <linux/gpio/consumer.h>
+#include <linux/gpio/driver.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/gpio.h>
@@ -76,6 +78,9 @@ static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 static DEFINE_IDR(dirent_idr);
 #endif
 
+static int gpiod_request(struct gpio_desc *desc, const char *label);
+static void gpiod_free(struct gpio_desc *desc);
+
 static inline void desc_set_label(struct gpio_desc *d, const char *label)
 {
 #ifdef CONFIG_DEBUG_FS
@@ -83,6 +88,38 @@ static inline void desc_set_label(struct gpio_desc *d, const char *label)
 #endif
 }
 
+/*
+ * Return the GPIO number of the passed descriptor relative to its chip
+ */
+static int gpio_chip_hwgpio(struct gpio_desc *desc)
+{
+	return (desc - &gpio_desc[0]) - desc->chip->base;
+}
+
+/**
+ * Convert a GPIO number to its descriptor
+ */
+struct gpio_desc *gpio_to_desc(unsigned gpio)
+{
+	if (WARN(!gpio_is_valid(gpio), "invalid GPIO %d\n", gpio))
+		return NULL;
+	else
+		return &gpio_desc[gpio];
+}
+EXPORT_SYMBOL_GPL(gpio_to_desc);
+
+/**
+ * Convert a GPIO descriptor to the integer namespace.
+ * This should disappear in the future but is needed since we still
+ * use GPIO numbers for error messages and sysfs nodes
+ */
+int desc_to_gpio(const struct gpio_desc *desc)
+{
+	return desc - &gpio_desc[0];
+}
+EXPORT_SYMBOL_GPL(desc_to_gpio);
+
+
 /* Warn when drivers omit gpio_request() calls -- legal but ill-advised
  * when setting direction, and otherwise illegal.  Until board setup code
  * and drivers use explicit requests everywhere (which won't happen when
@@ -94,10 +131,10 @@ static inline void desc_set_label(struct gpio_desc *d, const char *label)
  * only "legal" in the sense that (old) code using it won't break yet,
  * but instead only triggers a WARN() stack dump.
  */
-static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
+static int gpio_ensure_requested(struct gpio_desc *desc)
 {
 	const struct gpio_chip *chip = desc->chip;
-	const int gpio = chip->base + offset;
+	const int gpio = desc_to_gpio(desc);
 
 	if (WARN(test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0,
 			"autorequest GPIO-%d\n", gpio)) {
@@ -116,9 +153,9 @@ static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
 }
 
 /* caller holds gpio_lock *OR* gpio is marked as requested */
-struct gpio_chip *gpio_to_chip(unsigned gpio)
+struct gpio_chip *gpiod_to_chip(struct gpio_desc *desc)
 {
-	return gpio_desc[gpio].chip;
+	return desc->chip;
 }
 
 /* dynamic allocation of GPIOs, e.g. on a hotplugged device */
@@ -192,19 +229,19 @@ err:
 }
 
 /* caller ensures gpio is valid and requested, chip->get_direction may sleep  */
-static int gpio_get_direction(unsigned gpio)
+static int gpiod_get_direction(struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
-	struct gpio_desc	*desc = &gpio_desc[gpio];
+	unsigned		offset;
 	int			status = -EINVAL;
 
-	chip = gpio_to_chip(gpio);
-	gpio -= chip->base;
+	chip = gpiod_to_chip(desc);
+	offset = gpio_chip_hwgpio(desc);
 
 	if (!chip->get_direction)
 		return status;
 
-	status = chip->get_direction(chip, gpio);
+	status = chip->get_direction(chip, offset);
 	if (status > 0) {
 		/* GPIOF_DIR_IN, or other positive */
 		status = 1;
@@ -248,8 +285,7 @@ static DEFINE_MUTEX(sysfs_lock);
 static ssize_t gpio_direction_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	const struct gpio_desc	*desc = dev_get_drvdata(dev);
-	unsigned		gpio = desc - gpio_desc;
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
 	ssize_t			status;
 
 	mutex_lock(&sysfs_lock);
@@ -257,7 +293,7 @@ static ssize_t gpio_direction_show(struct device *dev,
 	if (!test_bit(FLAG_EXPORT, &desc->flags))
 		status = -EIO;
 	else
-		gpio_get_direction(gpio);
+		gpiod_get_direction(desc);
 		status = sprintf(buf, "%s\n",
 			test_bit(FLAG_IS_OUT, &desc->flags)
 				? "out" : "in");
@@ -269,8 +305,7 @@ static ssize_t gpio_direction_show(struct device *dev,
 static ssize_t gpio_direction_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
-	const struct gpio_desc	*desc = dev_get_drvdata(dev);
-	unsigned		gpio = desc - gpio_desc;
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
 	ssize_t			status;
 
 	mutex_lock(&sysfs_lock);
@@ -278,11 +313,11 @@ static ssize_t gpio_direction_store(struct device *dev,
 	if (!test_bit(FLAG_EXPORT, &desc->flags))
 		status = -EIO;
 	else if (sysfs_streq(buf, "high"))
-		status = gpio_direction_output(gpio, 1);
+		status = gpiod_direction_output(desc, 1);
 	else if (sysfs_streq(buf, "out") || sysfs_streq(buf, "low"))
-		status = gpio_direction_output(gpio, 0);
+		status = gpiod_direction_output(desc, 0);
 	else if (sysfs_streq(buf, "in"))
-		status = gpio_direction_input(gpio);
+		status = gpiod_direction_input(desc);
 	else
 		status = -EINVAL;
 
@@ -296,8 +331,7 @@ static /* const */ DEVICE_ATTR(direction, 0644,
 static ssize_t gpio_value_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	const struct gpio_desc	*desc = dev_get_drvdata(dev);
-	unsigned		gpio = desc - gpio_desc;
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
 	ssize_t			status;
 
 	mutex_lock(&sysfs_lock);
@@ -307,7 +341,7 @@ static ssize_t gpio_value_show(struct device *dev,
 	} else {
 		int value;
 
-		value = !!gpio_get_value_cansleep(gpio);
+		value = !!gpiod_get_value_cansleep(desc);
 		if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
 			value = !value;
 
@@ -321,8 +355,7 @@ static ssize_t gpio_value_show(struct device *dev,
 static ssize_t gpio_value_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
-	const struct gpio_desc	*desc = dev_get_drvdata(dev);
-	unsigned		gpio = desc - gpio_desc;
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
 	ssize_t			status;
 
 	mutex_lock(&sysfs_lock);
@@ -338,7 +371,7 @@ static ssize_t gpio_value_store(struct device *dev,
 		if (status == 0) {
 			if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
 				value = !value;
-			gpio_set_value_cansleep(gpio, value != 0);
+			gpiod_set_value_cansleep(desc, value != 0);
 			status = size;
 		}
 	}
@@ -368,7 +401,7 @@ static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 	if ((desc->flags & GPIO_TRIGGER_MASK) == gpio_flags)
 		return 0;
 
-	irq = gpio_to_irq(desc - gpio_desc);
+	irq = gpiod_to_irq(desc);
 	if (irq < 0)
 		return -EIO;
 
@@ -638,29 +671,32 @@ static ssize_t export_store(struct class *class,
 				struct class_attribute *attr,
 				const char *buf, size_t len)
 {
-	long	gpio;
-	int	status;
+	long			gpio;
+	struct gpio_desc	*desc;
+	int			status;
 
 	status = strict_strtol(buf, 0, &gpio);
 	if (status < 0)
 		goto done;
 
+	desc = gpio_to_desc(gpio);
+
 	/* No extra locking here; FLAG_SYSFS just signifies that the
 	 * request and export were done by on behalf of userspace, so
 	 * they may be undone on its behalf too.
 	 */
 
-	status = gpio_request(gpio, "sysfs");
+	status = gpiod_request(desc, "sysfs");
 	if (status < 0) {
 		if (status == -EPROBE_DEFER)
 			status = -ENODEV;
 		goto done;
 	}
-	status = gpio_export(gpio, true);
+	status = gpiod_export(desc, true);
 	if (status < 0)
-		gpio_free(gpio);
+		gpiod_free(desc);
 	else
-		set_bit(FLAG_SYSFS, &gpio_desc[gpio].flags);
+		set_bit(FLAG_SYSFS, &desc->flags);
 
 done:
 	if (status)
@@ -672,8 +708,9 @@ static ssize_t unexport_store(struct class *class,
 				struct class_attribute *attr,
 				const char *buf, size_t len)
 {
-	long	gpio;
-	int	status;
+	long			gpio;
+	struct gpio_desc	*desc;
+	int			status;
 
 	status = strict_strtol(buf, 0, &gpio);
 	if (status < 0)
@@ -681,17 +718,18 @@ static ssize_t unexport_store(struct class *class,
 
 	status = -EINVAL;
 
+	desc = gpio_to_desc(gpio);
 	/* reject bogus commands (gpio_unexport ignores them) */
-	if (!gpio_is_valid(gpio))
+	if (!desc)
 		goto done;
 
 	/* No extra locking here; FLAG_SYSFS just signifies that the
 	 * request and export were done by on behalf of userspace, so
 	 * they may be undone on its behalf too.
 	 */
-	if (test_and_clear_bit(FLAG_SYSFS, &gpio_desc[gpio].flags)) {
+	if (test_and_clear_bit(FLAG_SYSFS, &desc->flags)) {
 		status = 0;
-		gpio_free(gpio);
+		gpiod_free(desc);
 	}
 done:
 	if (status)
@@ -714,8 +752,8 @@ static struct class gpio_class = {
 
 
 /**
- * gpio_export - export a GPIO through sysfs
- * @gpio: gpio to make available, already requested
+ * gpiod_export - export a GPIO through sysfs
+ * @desc: descriptor of the gpio to make available
  * @direction_may_change: true if userspace may change gpio direction
  * Context: arch_initcall or later
  *
@@ -728,13 +766,13 @@ static struct class gpio_class = {
  *
  * Returns zero on success, else an error.
  */
-int gpio_export(unsigned gpio, bool direction_may_change)
+int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
 {
 	unsigned long		flags;
-	struct gpio_desc	*desc;
 	int			status;
 	const char		*ioname = NULL;
 	struct device		*dev;
+	int			offset;
 
 	/* can't export until sysfs is available ... */
 	if (!gpio_class.p) {
@@ -742,20 +780,19 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 		return -ENOENT;
 	}
 
-	if (!gpio_is_valid(gpio)) {
-		pr_debug("%s: gpio %d is not valid\n", __func__, gpio);
+	if (!desc) {
+		pr_debug("%s: invalid gpio descriptor\n", __func__);
 		return -EINVAL;
 	}
 
 	mutex_lock(&sysfs_lock);
 
 	spin_lock_irqsave(&gpio_lock, flags);
-	desc = &gpio_desc[gpio];
 	if (!test_bit(FLAG_REQUESTED, &desc->flags) ||
 	     test_bit(FLAG_EXPORT, &desc->flags)) {
 		spin_unlock_irqrestore(&gpio_lock, flags);
 		pr_debug("%s: gpio %d unavailable (requested=%d, exported=%d)\n",
-				__func__, gpio,
+				__func__, desc_to_gpio(desc),
 				test_bit(FLAG_REQUESTED, &desc->flags),
 				test_bit(FLAG_EXPORT, &desc->flags));
 		status = -EPERM;
@@ -766,11 +803,13 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 		direction_may_change = false;
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
-	if (desc->chip->names && desc->chip->names[gpio - desc->chip->base])
-		ioname = desc->chip->names[gpio - desc->chip->base];
+	offset = gpio_chip_hwgpio(desc);
+	if (desc->chip->names && desc->chip->names[offset])
+		ioname = desc->chip->names[offset];
 
 	dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
-			    desc, ioname ? ioname : "gpio%u", gpio);
+			    desc, ioname ? ioname : "gpio%u",
+			    desc_to_gpio(desc));
 	if (IS_ERR(dev)) {
 		status = PTR_ERR(dev);
 		goto fail_unlock;
@@ -786,7 +825,7 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 			goto fail_unregister_device;
 	}
 
-	if (gpio_to_irq(gpio) >= 0 && (direction_may_change ||
+	if (gpiod_to_irq(desc) >= 0 && (direction_may_change ||
 				       !test_bit(FLAG_IS_OUT, &desc->flags))) {
 		status = device_create_file(dev, &dev_attr_edge);
 		if (status)
@@ -801,10 +840,11 @@ fail_unregister_device:
 	device_unregister(dev);
 fail_unlock:
 	mutex_unlock(&sysfs_lock);
-	pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+	pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
+		 status);
 	return status;
 }
-EXPORT_SYMBOL_GPL(gpio_export);
+EXPORT_SYMBOL_GPL(gpiod_export);
 
 static int match_export(struct device *dev, void *data)
 {
@@ -812,28 +852,26 @@ static int match_export(struct device *dev, void *data)
 }
 
 /**
- * gpio_export_link - create a sysfs link to an exported GPIO node
+ * gpiod_export_link - create a sysfs link to an exported GPIO node
  * @dev: device under which to create symlink
  * @name: name of the symlink
- * @gpio: gpio to create symlink to, already exported
+ * @desc: descriptor of gpio to create symlink to, already exported
  *
  * Set up a symlink from /sys/.../dev/name to /sys/class/gpio/gpioN
  * node. Caller is responsible for unlinking.
  *
  * Returns zero on success, else an error.
  */
-int gpio_export_link(struct device *dev, const char *name, unsigned gpio)
+int gpiod_export_link(struct device *dev, const char *name,
+		      struct gpio_desc *desc)
 {
-	struct gpio_desc	*desc;
 	int			status = -EINVAL;
 
-	if (!gpio_is_valid(gpio))
+	if (!desc)
 		goto done;
 
 	mutex_lock(&sysfs_lock);
 
-	desc = &gpio_desc[gpio];
-
 	if (test_bit(FLAG_EXPORT, &desc->flags)) {
 		struct device *tdev;
 
@@ -850,16 +888,17 @@ int gpio_export_link(struct device *dev, const char *name, unsigned gpio)
 
 done:
 	if (status)
-		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+		pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
+			 status);
 
 	return status;
 }
-EXPORT_SYMBOL_GPL(gpio_export_link);
+EXPORT_SYMBOL_GPL(gpiod_export_link);
 
 
 /**
- * gpio_sysfs_set_active_low - set the polarity of gpio sysfs value
- * @gpio: gpio to change
+ * gpiod_sysfs_set_active_low - set the polarity of gpio sysfs value
+ * @desc: descriptor of gpio to change
  * @value: non-zero to use active low, i.e. inverted values
  *
  * Set the polarity of /sys/class/gpio/gpioN/value sysfs attribute.
@@ -869,19 +908,16 @@ EXPORT_SYMBOL_GPL(gpio_export_link);
  *
  * Returns zero on success, else an error.
  */
-int gpio_sysfs_set_active_low(unsigned gpio, int value)
+int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value)
 {
-	struct gpio_desc	*desc;
 	struct device		*dev = NULL;
 	int			status = -EINVAL;
 
-	if (!gpio_is_valid(gpio))
+	if (!desc)
 		goto done;
 
 	mutex_lock(&sysfs_lock);
 
-	desc = &gpio_desc[gpio];
-
 	if (test_bit(FLAG_EXPORT, &desc->flags)) {
 		dev = class_find_device(&gpio_class, NULL, desc, match_export);
 		if (dev == NULL) {
@@ -897,33 +933,31 @@ unlock:
 
 done:
 	if (status)
-		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+		pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
+			 status);
 
 	return status;
 }
-EXPORT_SYMBOL_GPL(gpio_sysfs_set_active_low);
+EXPORT_SYMBOL_GPL(gpiod_sysfs_set_active_low);
 
 /**
- * gpio_unexport - reverse effect of gpio_export()
- * @gpio: gpio to make unavailable
+ * gpiod_unexport - reverse effect of gpio_export()
+ * @desc: descriptor of gpio to make unavailable
  *
  * This is implicit on gpio_free().
  */
-void gpio_unexport(unsigned gpio)
+void gpiod_unexport(struct gpio_desc *desc)
 {
-	struct gpio_desc	*desc;
 	int			status = 0;
 	struct device		*dev = NULL;
 
-	if (!gpio_is_valid(gpio)) {
+	if (!desc) {
 		status = -EINVAL;
 		goto done;
 	}
 
 	mutex_lock(&sysfs_lock);
 
-	desc = &gpio_desc[gpio];
-
 	if (test_bit(FLAG_EXPORT, &desc->flags)) {
 
 		dev = class_find_device(&gpio_class, NULL, desc, match_export);
@@ -935,15 +969,17 @@ void gpio_unexport(unsigned gpio)
 	}
 
 	mutex_unlock(&sysfs_lock);
+
 	if (dev) {
 		device_unregister(dev);
 		put_device(dev);
 	}
 done:
 	if (status)
-		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+		pr_debug("%s: gpio%d status %d\n", __func__, desc_to_gpio(desc),
+			 status);
 }
-EXPORT_SYMBOL_GPL(gpio_unexport);
+EXPORT_SYMBOL_GPL(gpiod_unexport);
 
 static int gpiochip_export(struct gpio_chip *chip)
 {
@@ -1297,20 +1333,18 @@ EXPORT_SYMBOL_GPL(gpiochip_remove_pin_ranges);
  * on each other, and help provide better diagnostics in debugfs.
  * They're called even less than the "set direction" calls.
  */
-int gpio_request(unsigned gpio, const char *label)
+static int gpiod_request(struct gpio_desc *desc, const char *label)
 {
-	struct gpio_desc	*desc;
 	struct gpio_chip	*chip;
 	int			status = -EPROBE_DEFER;
 	unsigned long		flags;
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (!gpio_is_valid(gpio)) {
+	if (!desc) {
 		status = -EINVAL;
 		goto done;
 	}
-	desc = &gpio_desc[gpio];
 	chip = desc->chip;
 	if (chip == NULL)
 		goto done;
@@ -1334,7 +1368,7 @@ int gpio_request(unsigned gpio, const char *label)
 	if (chip->request) {
 		/* chip->request may sleep */
 		spin_unlock_irqrestore(&gpio_lock, flags);
-		status = chip->request(chip, gpio - chip->base);
+		status = chip->request(chip, gpio_chip_hwgpio(desc));
 		spin_lock_irqsave(&gpio_lock, flags);
 
 		if (status < 0) {
@@ -1347,42 +1381,45 @@ int gpio_request(unsigned gpio, const char *label)
 	if (chip->get_direction) {
 		/* chip->get_direction may sleep */
 		spin_unlock_irqrestore(&gpio_lock, flags);
-		gpio_get_direction(gpio);
+		gpiod_get_direction(desc);
 		spin_lock_irqsave(&gpio_lock, flags);
 	}
 done:
 	if (status)
-		pr_debug("gpio_request: gpio-%d (%s) status %d\n",
-			gpio, label ? : "?", status);
+		pr_debug("_gpio_request: gpio-%d (%s) status %d\n",
+			desc_to_gpio(desc), label ? : "?", status);
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	return status;
 }
+
+int gpio_request(unsigned gpio, const char *label)
+{
+	return gpiod_request(gpio_to_desc(gpio), label);
+}
 EXPORT_SYMBOL_GPL(gpio_request);
 
-void gpio_free(unsigned gpio)
+static void gpiod_free(struct gpio_desc *desc)
 {
 	unsigned long		flags;
-	struct gpio_desc	*desc;
 	struct gpio_chip	*chip;
 
 	might_sleep();
 
-	if (!gpio_is_valid(gpio)) {
+	if (!desc) {
 		WARN_ON(extra_checks);
 		return;
 	}
 
-	gpio_unexport(gpio);
+	gpiod_unexport(desc);
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	desc = &gpio_desc[gpio];
 	chip = desc->chip;
 	if (chip && test_bit(FLAG_REQUESTED, &desc->flags)) {
 		if (chip->free) {
 			spin_unlock_irqrestore(&gpio_lock, flags);
 			might_sleep_if(chip->can_sleep);
-			chip->free(chip, gpio - chip->base);
+			chip->free(chip, gpio_chip_hwgpio(desc));
 			spin_lock_irqsave(&gpio_lock, flags);
 		}
 		desc_set_label(desc, NULL);
@@ -1396,6 +1433,11 @@ void gpio_free(unsigned gpio)
 
 	spin_unlock_irqrestore(&gpio_lock, flags);
 }
+
+void gpio_free(unsigned gpio)
+{
+	gpiod_free(gpio_to_desc(gpio));
+}
 EXPORT_SYMBOL_GPL(gpio_free);
 
 /**
@@ -1406,29 +1448,32 @@ EXPORT_SYMBOL_GPL(gpio_free);
  */
 int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
 {
+	struct gpio_desc *desc;
 	int err;
 
-	err = gpio_request(gpio, label);
+	desc = gpio_to_desc(gpio);
+
+	err = gpiod_request(desc, label);
 	if (err)
 		return err;
 
 	if (flags & GPIOF_OPEN_DRAIN)
-		set_bit(FLAG_OPEN_DRAIN, &gpio_desc[gpio].flags);
+		set_bit(FLAG_OPEN_DRAIN, &desc->flags);
 
 	if (flags & GPIOF_OPEN_SOURCE)
-		set_bit(FLAG_OPEN_SOURCE, &gpio_desc[gpio].flags);
+		set_bit(FLAG_OPEN_SOURCE, &desc->flags);
 
 	if (flags & GPIOF_DIR_IN)
-		err = gpio_direction_input(gpio);
+		err = gpiod_direction_input(desc);
 	else
-		err = gpio_direction_output(gpio,
+		err = gpiod_direction_output(desc,
 				(flags & GPIOF_INIT_HIGH) ? 1 : 0);
 
 	if (err)
 		goto free_gpio;
 
 	if (flags & GPIOF_EXPORT) {
-		err = gpio_export(gpio, flags & GPIOF_EXPORT_CHANGEABLE);
+		err = gpiod_export(desc, flags & GPIOF_EXPORT_CHANGEABLE);
 		if (err)
 			goto free_gpio;
 	}
@@ -1436,7 +1481,7 @@ int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
 	return 0;
 
  free_gpio:
-	gpio_free(gpio);
+	gpiod_free(desc);
 	return err;
 }
 EXPORT_SYMBOL_GPL(gpio_request_one);
@@ -1492,13 +1537,14 @@ EXPORT_SYMBOL_GPL(gpio_free_array);
 const char *gpiochip_is_requested(struct gpio_chip *chip, unsigned offset)
 {
 	unsigned gpio = chip->base + offset;
+	struct gpio_desc *desc = &gpio_desc[gpio];
 
-	if (!gpio_is_valid(gpio) || gpio_desc[gpio].chip != chip)
+	if (!gpio_is_valid(gpio) || desc->chip != chip)
 		return NULL;
-	if (test_bit(FLAG_REQUESTED, &gpio_desc[gpio].flags) == 0)
+	if (test_bit(FLAG_REQUESTED, &desc->flags) == 0)
 		return NULL;
 #ifdef CONFIG_DEBUG_FS
-	return gpio_desc[gpio].label;
+	return desc->label;
 #else
 	return "?";
 #endif
@@ -1515,24 +1561,21 @@ EXPORT_SYMBOL_GPL(gpiochip_is_requested);
  * rely on gpio_request() having been called beforehand.
  */
 
-int gpio_direction_input(unsigned gpio)
+int gpiod_direction_input(struct gpio_desc *desc)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
-	struct gpio_desc	*desc = &gpio_desc[gpio];
 	int			status = -EINVAL;
+	int			offset;
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (!gpio_is_valid(gpio))
+	if (!desc)
 		goto fail;
 	chip = desc->chip;
 	if (!chip || !chip->get || !chip->direction_input)
 		goto fail;
-	gpio -= chip->base;
-	if (gpio >= chip->ngpio)
-		goto fail;
-	status = gpio_ensure_requested(desc, gpio);
+	status = gpio_ensure_requested(desc);
 	if (status < 0)
 		goto fail;
 
@@ -1542,11 +1585,12 @@ int gpio_direction_input(unsigned gpio)
 
 	might_sleep_if(chip->can_sleep);
 
+	offset = gpio_chip_hwgpio(desc);
 	if (status) {
-		status = chip->request(chip, gpio);
+		status = chip->request(chip, offset);
 		if (status < 0) {
 			pr_debug("GPIO-%d: chip request fail, %d\n",
-				chip->base + gpio, status);
+				desc_to_gpio(desc), status);
 			/* and it's not available to anyone else ...
 			 * gpio_request() is the fully clean solution.
 			 */
@@ -1554,48 +1598,49 @@ int gpio_direction_input(unsigned gpio)
 		}
 	}
 
-	status = chip->direction_input(chip, gpio);
+	status = chip->direction_input(chip, offset);
 	if (status == 0)
 		clear_bit(FLAG_IS_OUT, &desc->flags);
 
-	trace_gpio_direction(chip->base + gpio, 1, status);
+	trace_gpio_direction(desc_to_gpio(desc), 1, status);
 lose:
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status)
+	if (status) {
+		int gpio = -1;
+		if (desc)
+			gpio = desc_to_gpio(desc);
 		pr_debug("%s: gpio-%d status %d\n",
 			__func__, gpio, status);
+	}
 	return status;
 }
-EXPORT_SYMBOL_GPL(gpio_direction_input);
+EXPORT_SYMBOL_GPL(gpiod_direction_input);
 
-int gpio_direction_output(unsigned gpio, int value)
+int gpiod_direction_output(struct gpio_desc *desc, int value)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
-	struct gpio_desc	*desc = &gpio_desc[gpio];
 	int			status = -EINVAL;
+	int offset;
 
 	/* Open drain pin should not be driven to 1 */
 	if (value && test_bit(FLAG_OPEN_DRAIN,  &desc->flags))
-		return gpio_direction_input(gpio);
+		return gpiod_direction_input(desc);
 
 	/* Open source pin should not be driven to 0 */
 	if (!value && test_bit(FLAG_OPEN_SOURCE,  &desc->flags))
-		return gpio_direction_input(gpio);
+		return gpiod_direction_input(desc);
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (!gpio_is_valid(gpio))
+	if (!desc)
 		goto fail;
 	chip = desc->chip;
 	if (!chip || !chip->set || !chip->direction_output)
 		goto fail;
-	gpio -= chip->base;
-	if (gpio >= chip->ngpio)
-		goto fail;
-	status = gpio_ensure_requested(desc, gpio);
+	status = gpio_ensure_requested(desc);
 	if (status < 0)
 		goto fail;
 
@@ -1605,11 +1650,12 @@ int gpio_direction_output(unsigned gpio, int value)
 
 	might_sleep_if(chip->can_sleep);
 
+	offset = gpio_chip_hwgpio(desc);
 	if (status) {
-		status = chip->request(chip, gpio);
+		status = chip->request(chip, offset);
 		if (status < 0) {
 			pr_debug("GPIO-%d: chip request fail, %d\n",
-				chip->base + gpio, status);
+				desc_to_gpio(desc), status);
 			/* and it's not available to anyone else ...
 			 * gpio_request() is the fully clean solution.
 			 */
@@ -1617,45 +1663,47 @@ int gpio_direction_output(unsigned gpio, int value)
 		}
 	}
 
-	status = chip->direction_output(chip, gpio, value);
+	status = chip->direction_output(chip, offset, value);
 	if (status == 0)
 		set_bit(FLAG_IS_OUT, &desc->flags);
-	trace_gpio_value(chip->base + gpio, 0, value);
-	trace_gpio_direction(chip->base + gpio, 0, status);
+	trace_gpio_value(desc_to_gpio(desc), 0, value);
+	trace_gpio_direction(desc_to_gpio(desc), 0, status);
 lose:
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status)
+	if (status) {
+		int gpio = -1;
+		if (desc)
+			gpio = desc_to_gpio(desc);
 		pr_debug("%s: gpio-%d status %d\n",
 			__func__, gpio, status);
+	}
 	return status;
 }
-EXPORT_SYMBOL_GPL(gpio_direction_output);
+EXPORT_SYMBOL_GPL(gpiod_direction_output);
 
 /**
- * gpio_set_debounce - sets @debounce time for a @gpio
- * @gpio: the gpio to set debounce time
+ * gpiod_set_debounce - sets @debounce time for a gpio
+ * @desc: descriptor to the gpio to set debounce time
  * @debounce: debounce time is microseconds
  */
-int gpio_set_debounce(unsigned gpio, unsigned debounce)
+int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
-	struct gpio_desc	*desc = &gpio_desc[gpio];
 	int			status = -EINVAL;
+	int			offset;
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (!gpio_is_valid(gpio))
+	if (!desc)
 		goto fail;
 	chip = desc->chip;
 	if (!chip || !chip->set || !chip->set_debounce)
 		goto fail;
-	gpio -= chip->base;
-	if (gpio >= chip->ngpio)
-		goto fail;
-	status = gpio_ensure_requested(desc, gpio);
+
+	status = gpio_ensure_requested(desc);
 	if (status < 0)
 		goto fail;
 
@@ -1665,17 +1713,22 @@ int gpio_set_debounce(unsigned gpio, unsigned debounce)
 
 	might_sleep_if(chip->can_sleep);
 
-	return chip->set_debounce(chip, gpio, debounce);
+	offset = gpio_chip_hwgpio(desc);
+	return chip->set_debounce(chip, offset, debounce);
 
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status)
+	if (status) {
+		int gpio = -1;
+		if (desc)
+			gpio = desc_to_gpio(desc);
 		pr_debug("%s: gpio-%d status %d\n",
 			__func__, gpio, status);
+	}
 
 	return status;
 }
-EXPORT_SYMBOL_GPL(gpio_set_debounce);
+EXPORT_SYMBOL_GPL(gpiod_set_debounce);
 
 /* I/O calls are only valid after configuration completed; the relevant
  * "is this a valid GPIO" error checks should already have been done.
@@ -1700,27 +1753,28 @@ EXPORT_SYMBOL_GPL(gpio_set_debounce);
  */
 
 /**
- * __gpio_get_value() - return a gpio's value
- * @gpio: gpio whose value will be returned
+ * gpiod_get_value() - return a gpio's value
+ * @desc: descriptor of gpio whose value will be returned
  * Context: any
  *
- * This is used directly or indirectly to implement gpio_get_value().
- * It returns the zero or nonzero value provided by the associated
+ * Returns the zero or nonzero value provided by the associated
  * gpio_chip.get() method; or zero if no such method is provided.
  */
-int __gpio_get_value(unsigned gpio)
+int gpiod_get_value(struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
 	int value;
+	int offset;
 
-	chip = gpio_to_chip(gpio);
+	chip = desc->chip;
+	offset = gpio_chip_hwgpio(desc);
 	/* Should be using gpio_get_value_cansleep() */
 	WARN_ON(chip->can_sleep);
-	value = chip->get ? chip->get(chip, gpio - chip->base) : 0;
-	trace_gpio_value(gpio, 1, value);
+	value = chip->get ? chip->get(chip, offset) : 0;
+	trace_gpio_value(desc_to_gpio(desc), 1, value);
 	return value;
 }
-EXPORT_SYMBOL_GPL(__gpio_get_value);
+EXPORT_SYMBOL_GPL(gpiod_get_value);
 
 /*
  *  _gpio_set_open_drain_value() - Set the open drain gpio's value.
@@ -1728,23 +1782,25 @@ EXPORT_SYMBOL_GPL(__gpio_get_value);
  * @chip: Gpio chip.
  * @value: Non-zero for setting it HIGH otherise it will set to LOW.
  */
-static void _gpio_set_open_drain_value(unsigned gpio,
-			struct gpio_chip *chip, int value)
+static void _gpio_set_open_drain_value(struct gpio_desc *desc, int value)
 {
 	int err = 0;
+	struct gpio_chip *chip = desc->chip;
+	int offset = gpio_chip_hwgpio(desc);
+
 	if (value) {
-		err = chip->direction_input(chip, gpio - chip->base);
+		err = chip->direction_input(chip, offset);
 		if (!err)
-			clear_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
+			clear_bit(FLAG_IS_OUT, &desc->flags);
 	} else {
-		err = chip->direction_output(chip, gpio - chip->base, 0);
+		err = chip->direction_output(chip, offset, 0);
 		if (!err)
-			set_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
+			set_bit(FLAG_IS_OUT, &desc->flags);
 	}
-	trace_gpio_direction(gpio, value, err);
+	trace_gpio_direction(desc_to_gpio(desc), value, err);
 	if (err < 0)
 		pr_err("%s: Error in set_value for open drain gpio%d err %d\n",
-					__func__, gpio, err);
+					__func__, desc_to_gpio(desc), err);
 }
 
 /*
@@ -1753,124 +1809,120 @@ static void _gpio_set_open_drain_value(unsigned gpio,
  * @chip: Gpio chip.
  * @value: Non-zero for setting it HIGH otherise it will set to LOW.
  */
-static void _gpio_set_open_source_value(unsigned gpio,
-			struct gpio_chip *chip, int value)
+static void _gpio_set_open_source_value(struct gpio_desc *desc, int value)
 {
 	int err = 0;
+	struct gpio_chip *chip = desc->chip;
+	int offset = gpio_chip_hwgpio(desc);
+
 	if (value) {
-		err = chip->direction_output(chip, gpio - chip->base, 1);
+		err = chip->direction_output(chip, offset, 1);
 		if (!err)
-			set_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
+			set_bit(FLAG_IS_OUT, &desc->flags);
 	} else {
-		err = chip->direction_input(chip, gpio - chip->base);
+		err = chip->direction_input(chip, offset);
 		if (!err)
-			clear_bit(FLAG_IS_OUT, &gpio_desc[gpio].flags);
+			clear_bit(FLAG_IS_OUT, &desc->flags);
 	}
-	trace_gpio_direction(gpio, !value, err);
+	trace_gpio_direction(desc_to_gpio(desc), !value, err);
 	if (err < 0)
 		pr_err("%s: Error in set_value for open source gpio%d err %d\n",
-					__func__, gpio, err);
+					__func__, desc_to_gpio(desc), err);
 }
 
-
 /**
- * __gpio_set_value() - assign a gpio's value
- * @gpio: gpio whose value will be assigned
+ * gpiod_set_value() - assign a gpio's value
+ * @desc: descriptor of gpio whose value will be assigned
  * @value: value to assign
  * Context: any
  *
- * This is used directly or indirectly to implement gpio_set_value().
- * It invokes the associated gpio_chip.set() method.
+ * Invokes the associated gpio_chip.set() method.
  */
-void __gpio_set_value(unsigned gpio, int value)
+void gpiod_set_value(struct gpio_desc *desc, int value)
 {
 	struct gpio_chip	*chip;
 
-	chip = gpio_to_chip(gpio);
+	chip = desc->chip;
 	/* Should be using gpio_set_value_cansleep() */
 	WARN_ON(chip->can_sleep);
-	trace_gpio_value(gpio, 0, value);
-	if (test_bit(FLAG_OPEN_DRAIN,  &gpio_desc[gpio].flags))
-		_gpio_set_open_drain_value(gpio, chip, value);
-	else if (test_bit(FLAG_OPEN_SOURCE,  &gpio_desc[gpio].flags))
-		_gpio_set_open_source_value(gpio, chip, value);
+	trace_gpio_value(desc_to_gpio(desc), 0, value);
+	if (test_bit(FLAG_OPEN_DRAIN, &desc->flags))
+		_gpio_set_open_drain_value(desc, value);
+	else if (test_bit(FLAG_OPEN_SOURCE, &desc->flags))
+		_gpio_set_open_source_value(desc, value);
 	else
-		chip->set(chip, gpio - chip->base, value);
+		chip->set(chip, gpio_chip_hwgpio(desc), value);
 }
-EXPORT_SYMBOL_GPL(__gpio_set_value);
+EXPORT_SYMBOL_GPL(gpiod_set_value);
 
 /**
- * __gpio_cansleep() - report whether gpio value access will sleep
- * @gpio: gpio in question
+ * gpiod_cansleep() - report whether gpio value access will sleep
+ * @desc: descriptor of gpio in question
  * Context: any
  *
- * This is used directly or indirectly to implement gpio_cansleep().  It
- * returns nonzero if access reading or writing the GPIO value can sleep.
+ * Returns nonzero if access reading or writing the GPIO value can sleep.
  */
-int __gpio_cansleep(unsigned gpio)
+int gpiod_cansleep(struct gpio_desc *desc)
 {
-	struct gpio_chip	*chip;
-
 	/* only call this on GPIOs that are valid! */
-	chip = gpio_to_chip(gpio);
-
-	return chip->can_sleep;
+	return desc->chip->can_sleep;
 }
-EXPORT_SYMBOL_GPL(__gpio_cansleep);
+EXPORT_SYMBOL_GPL(gpiod_cansleep);
 
 /**
- * __gpio_to_irq() - return the IRQ corresponding to a GPIO
- * @gpio: gpio whose IRQ will be returned (already requested)
+ * gpiod_to_irq() - return the IRQ corresponding to a GPIO
+ * @desc: descriptor of gpio whose IRQ will be returned (already requested)
  * Context: any
  *
- * This is used directly or indirectly to implement gpio_to_irq().
- * It returns the number of the IRQ signaled by this (input) GPIO,
+ * Returns the number of the IRQ signaled by this (input) GPIO,
  * or a negative errno.
  */
-int __gpio_to_irq(unsigned gpio)
+int gpiod_to_irq(struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
 
-	chip = gpio_to_chip(gpio);
-	return chip->to_irq ? chip->to_irq(chip, gpio - chip->base) : -ENXIO;
+	chip = desc->chip;
+	if (chip->to_irq)
+		return chip->to_irq(chip, gpio_chip_hwgpio(desc));
+	else
+		return -ENXIO;
 }
-EXPORT_SYMBOL_GPL(__gpio_to_irq);
-
-
+EXPORT_SYMBOL_GPL(gpiod_to_irq);
 
 /* There's no value in making it easy to inline GPIO calls that may sleep.
  * Common examples include ones connected to I2C or SPI chips.
  */
 
-int gpio_get_value_cansleep(unsigned gpio)
+int gpiod_get_value_cansleep(struct gpio_desc *desc)
 {
 	struct gpio_chip	*chip;
 	int value;
+	int offset;
 
 	might_sleep_if(extra_checks);
-	chip = gpio_to_chip(gpio);
-	value = chip->get ? chip->get(chip, gpio - chip->base) : 0;
-	trace_gpio_value(gpio, 1, value);
+	chip = desc->chip;
+	offset = gpio_chip_hwgpio(desc);
+	value = chip->get ? chip->get(chip, offset) : 0;
+	trace_gpio_value(desc_to_gpio(desc), 1, value);
 	return value;
 }
-EXPORT_SYMBOL_GPL(gpio_get_value_cansleep);
+EXPORT_SYMBOL_GPL(gpiod_get_value_cansleep);
 
-void gpio_set_value_cansleep(unsigned gpio, int value)
+void gpiod_set_value_cansleep(struct gpio_desc *desc, int value)
 {
 	struct gpio_chip	*chip;
 
 	might_sleep_if(extra_checks);
-	chip = gpio_to_chip(gpio);
-	trace_gpio_value(gpio, 0, value);
-	if (test_bit(FLAG_OPEN_DRAIN,  &gpio_desc[gpio].flags))
-		_gpio_set_open_drain_value(gpio, chip, value);
-	else if (test_bit(FLAG_OPEN_SOURCE,  &gpio_desc[gpio].flags))
-		_gpio_set_open_source_value(gpio, chip, value);
+	chip = desc->chip;
+	trace_gpio_value(desc_to_gpio(desc), 0, value);
+	if (test_bit(FLAG_OPEN_DRAIN,  &desc->flags))
+		_gpio_set_open_drain_value(desc, value);
+	else if (test_bit(FLAG_OPEN_SOURCE,  &desc->flags))
+		_gpio_set_open_source_value(desc, value);
 	else
-		chip->set(chip, gpio - chip->base, value);
+		chip->set(chip, gpio_chip_hwgpio(desc), value);
 }
-EXPORT_SYMBOL_GPL(gpio_set_value_cansleep);
-
+EXPORT_SYMBOL_GPL(gpiod_set_value_cansleep);
 
 #ifdef CONFIG_DEBUG_FS
 
@@ -1885,7 +1937,7 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 		if (!test_bit(FLAG_REQUESTED, &gdesc->flags))
 			continue;
 
-		gpio_get_direction(gpio);
+		gpiod_get_direction(gdesc);
 		is_out = test_bit(FLAG_IS_OUT, &gdesc->flags);
 		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s",
 			gpio, gdesc->label,
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 20ca766..6fe2a03 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -10,6 +10,8 @@
 #ifdef CONFIG_GPIOLIB
 
 #include <linux/compiler.h>
+#include <linux/gpio/consumer.h>
+#include <linux/gpio/driver.h>
 
 /* Platforms may implement their GPIO interface with library code,
  * at a small performance cost for non-inlined operations and some
@@ -48,110 +50,12 @@ struct seq_file;
 struct module;
 struct device_node;
 
-/**
- * struct gpio_chip - abstract a GPIO controller
- * @label: for diagnostics
- * @dev: optional device providing the GPIOs
- * @owner: helps prevent removal of modules exporting active GPIOs
- * @request: optional hook for chip-specific activation, such as
- *	enabling module power and clock; may sleep
- * @free: optional hook for chip-specific deactivation, such as
- *	disabling module power and clock; may sleep
- * @get_direction: returns direction for signal "offset", 0=out, 1=in,
- *	(same as GPIOF_DIR_XXX), or negative error
- * @direction_input: configures signal "offset" as input, or returns error
- * @get: returns value for signal "offset"; for output signals this
- *	returns either the value actually sensed, or zero
- * @direction_output: configures signal "offset" as output, or returns error
- * @set_debounce: optional hook for setting debounce time for specified gpio in
- *      interrupt triggered gpio chips
- * @set: assigns output value for signal "offset"
- * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
- *	implementation may not sleep
- * @dbg_show: optional routine to show contents in debugfs; default code
- *	will be used when this is omitted, but custom code can show extra
- *	state (such as pullup/pulldown configuration).
- * @base: identifies the first GPIO number handled by this chip; or, if
- *	negative during registration, requests dynamic ID allocation.
- * @ngpio: the number of GPIOs handled by this controller; the last GPIO
- *	handled is (base + ngpio - 1).
- * @can_sleep: flag must be set iff get()/set() methods sleep, as they
- *	must while accessing GPIO expander chips over I2C or SPI
- * @names: if set, must be an array of strings to use as alternative
- *      names for the GPIOs in this chip. Any entry in the array
- *      may be NULL if there is no alias for the GPIO, however the
- *      array must be @ngpio entries long.  A name can include a single printk
- *      format specifier for an unsigned int.  It is substituted by the actual
- *      number of the gpio.
- *
- * A gpio_chip can help platforms abstract various sources of GPIOs so
- * they can all be accessed through a common programing interface.
- * Example sources would be SOC controllers, FPGAs, multifunction
- * chips, dedicated GPIO expanders, and so on.
- *
- * Each chip controls a number of signals, identified in method calls
- * by "offset" values in the range 0..(@ngpio - 1).  When those signals
- * are referenced through calls like gpio_get_value(gpio), the offset
- * is calculated by subtracting @base from the gpio number.
- */
-struct gpio_chip {
-	const char		*label;
-	struct device		*dev;
-	struct module		*owner;
-
-	int			(*request)(struct gpio_chip *chip,
-						unsigned offset);
-	void			(*free)(struct gpio_chip *chip,
-						unsigned offset);
-	int			(*get_direction)(struct gpio_chip *chip,
-						unsigned offset);
-	int			(*direction_input)(struct gpio_chip *chip,
-						unsigned offset);
-	int			(*get)(struct gpio_chip *chip,
-						unsigned offset);
-	int			(*direction_output)(struct gpio_chip *chip,
-						unsigned offset, int value);
-	int			(*set_debounce)(struct gpio_chip *chip,
-						unsigned offset, unsigned debounce);
-
-	void			(*set)(struct gpio_chip *chip,
-						unsigned offset, int value);
-
-	int			(*to_irq)(struct gpio_chip *chip,
-						unsigned offset);
-
-	void			(*dbg_show)(struct seq_file *s,
-						struct gpio_chip *chip);
-	int			base;
-	u16			ngpio;
-	const char		*const *names;
-	unsigned		can_sleep:1;
-	unsigned		exported:1;
-
-#if defined(CONFIG_OF_GPIO)
-	/*
-	 * If CONFIG_OF is enabled, then all GPIO controllers described in the
-	 * device tree automatically may have an OF translation
-	 */
-	struct device_node *of_node;
-	int of_gpio_n_cells;
-	int (*of_xlate)(struct gpio_chip *gc,
-		        const struct of_phandle_args *gpiospec, u32 *flags);
-#endif
-#ifdef CONFIG_PINCTRL
-	/*
-	 * If CONFIG_PINCTRL is enabled, then gpio controllers can optionally
-	 * describe the actual pin range which they serve in an SoC. This
-	 * information would be used by pinctrl subsystem to configure
-	 * corresponding pins for gpio usage.
-	 */
-	struct list_head pin_ranges;
-#endif
-};
-
 extern const char *gpiochip_is_requested(struct gpio_chip *chip,
 			unsigned offset);
-extern struct gpio_chip *gpio_to_chip(unsigned gpio);
+static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
+{
+	return gpiod_to_chip(gpio_to_desc(gpio));
+}
 extern int __must_check gpiochip_reserve(int start, int ngpio);
 
 /* add/remove chips */
@@ -168,25 +72,52 @@ extern struct gpio_chip *gpiochip_find(void *data,
 extern int gpio_request(unsigned gpio, const char *label);
 extern void gpio_free(unsigned gpio);
 
-extern int gpio_direction_input(unsigned gpio);
-extern int gpio_direction_output(unsigned gpio, int value);
+static inline int gpio_direction_input(unsigned gpio)
+{
+	return gpiod_direction_input(gpio_to_desc(gpio));
+}
+static inline int gpio_direction_output(unsigned gpio, int value)
+{
+	return gpiod_direction_output(gpio_to_desc(gpio), value);
+}
 
-extern int gpio_set_debounce(unsigned gpio, unsigned debounce);
+static inline int gpio_set_debounce(unsigned gpio, unsigned debounce)
+{
+	return gpiod_set_debounce(gpio_to_desc(gpio), debounce);
+}
 
-extern int gpio_get_value_cansleep(unsigned gpio);
-extern void gpio_set_value_cansleep(unsigned gpio, int value);
+static inline int gpio_get_value_cansleep(unsigned gpio)
+{
+	return gpiod_get_value_cansleep(gpio_to_desc(gpio));
+}
+static inline void gpio_set_value_cansleep(unsigned gpio, int value)
+{
+	return gpiod_set_value_cansleep(gpio_to_desc(gpio), value);
+}
 
 
 /* A platform's <asm/gpio.h> code may want to inline the I/O calls when
  * the GPIO is constant and refers to some always-present controller,
  * giving direct access to chip registers and tight bitbanging loops.
  */
-extern int __gpio_get_value(unsigned gpio);
-extern void __gpio_set_value(unsigned gpio, int value);
+static inline int __gpio_get_value(unsigned gpio)
+{
+	return gpiod_get_value(gpio_to_desc(gpio));
+}
+static inline void __gpio_set_value(unsigned gpio, int value)
+{
+	gpiod_set_value(gpio_to_desc(gpio), value);
+}
 
-extern int __gpio_cansleep(unsigned gpio);
+static inline int __gpio_cansleep(unsigned gpio)
+{
+	return gpiod_cansleep(gpio_to_desc(gpio));
+}
 
-extern int __gpio_to_irq(unsigned gpio);
+static inline int __gpio_to_irq(unsigned gpio)
+{
+	return gpiod_to_irq(gpio_to_desc(gpio));
+}
 
 extern int gpio_request_one(unsigned gpio, unsigned long flags, const char *label);
 extern int gpio_request_array(const struct gpio *array, size_t num);
@@ -204,11 +135,24 @@ void devm_gpio_free(struct device *dev, unsigned int gpio);
  * A sysfs interface can be exported by individual drivers if they want,
  * but more typically is configured entirely from userspace.
  */
-extern int gpio_export(unsigned gpio, bool direction_may_change);
-extern int gpio_export_link(struct device *dev, const char *name,
-			unsigned gpio);
-extern int gpio_sysfs_set_active_low(unsigned gpio, int value);
-extern void gpio_unexport(unsigned gpio);
+
+static inline int gpio_export(unsigned gpio, bool direction_may_change)
+{
+	return gpiod_export(gpio_to_desc(gpio), direction_may_change);
+}
+static inline int gpio_export_link(struct device *dev, const char *name,
+			unsigned gpio)
+{
+	return gpiod_export_link(dev, name, gpio_to_desc(gpio));
+}
+static inline int gpio_sysfs_set_active_low(unsigned gpio, int value)
+{
+	return gpiod_sysfs_set_active_low(gpio_to_desc(gpio), value);
+}
+static inline void gpio_unexport(unsigned gpio)
+{
+	gpiod_unexport(gpio_to_desc(gpio));
+}
 
 #endif	/* CONFIG_GPIO_SYSFS */
 
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
new file mode 100644
index 0000000..0ce96cf
--- /dev/null
+++ b/include/linux/gpio/consumer.h
@@ -0,0 +1,64 @@
+#ifndef __LINUX_GPIO_CONSUMER_H
+#define __LINUX_GPIO_CONSUMER_H
+
+#ifdef CONFIG_GPIOLIB
+
+struct device;
+struct gpio_chip;
+
+/**
+ * Opaque descriptor for a GPIO. These are obtained and manipulated through
+ * the gpiod_* API and are preferable to the old integer-based handles.
+ *
+ * Contrary to integers, a pointer to a gpio_desc is guaranteed to be valid
+ * until the GPIO is released.
+ */
+struct gpio_desc;
+
+struct gpio_desc *gpio_to_desc(unsigned gpio);
+int desc_to_gpio(const struct gpio_desc *desc);
+struct gpio_chip *gpiod_to_chip(struct gpio_desc *desc);
+
+int gpiod_direction_input(struct gpio_desc *desc);
+int gpiod_direction_output(struct gpio_desc *desc, int value);
+int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce);
+int gpiod_get_value_cansleep(struct gpio_desc *desc);
+void gpiod_set_value_cansleep(struct gpio_desc *desc, int value);
+
+int gpiod_get_value(struct gpio_desc *desc);
+void gpiod_set_value(struct gpio_desc *desc, int value);
+int gpiod_cansleep(struct gpio_desc *desc);
+int gpiod_to_irq(struct gpio_desc *desc);
+
+#ifdef CONFIG_GPIO_SYSFS
+
+int gpiod_export(struct gpio_desc *desc, bool direction_may_change);
+int gpiod_export_link(struct device *dev, const char *name,
+			struct gpio_desc *desc);
+int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value);
+void gpiod_unexport(struct gpio_desc *desc);
+
+#else  /* CONFIG_GPIO_SYSFS */
+
+static inline int gpiod_export(struct gpio_desc *desc, bool dir_may_change)
+{
+	return -ENOSYS;
+}
+static inline int gpiod_export_link(struct device *dev, const char *name,
+				struct gpio_desc *desc)
+{
+	return -ENOSYS;
+}
+static inline int gpiod_sysfs_set_active_low(struct gpio_desc *desc, int value)
+{
+	return -ENOSYS;
+}
+static inline void gpiod_unexport(struct gpio_desc *desc)
+{
+}
+
+#endif	/* CONFIG_GPIO_SYSFS */
+
+#endif /* CONFIG_GPIOLIB */
+
+#endif
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
new file mode 100644
index 0000000..d42f941
--- /dev/null
+++ b/include/linux/gpio/driver.h
@@ -0,0 +1,112 @@
+#ifndef __LINUX_GPIO_DRIVER_H_
+#define __LINUX_GPIO_DRIVER_H_
+
+#ifdef CONFIG_GPIOLIB
+
+#include <linux/types.h>
+
+/**
+ * struct gpio_chip - abstract a GPIO controller
+ * @label: for diagnostics
+ * @dev: optional device providing the GPIOs
+ * @owner: helps prevent removal of modules exporting active GPIOs
+ * @request: optional hook for chip-specific activation, such as
+ *	enabling module power and clock; may sleep
+ * @free: optional hook for chip-specific deactivation, such as
+ *	disabling module power and clock; may sleep
+ * @get_direction: returns direction for signal "offset", 0=out, 1=in,
+ *	(same as GPIOF_DIR_XXX), or negative error
+ * @direction_input: configures signal "offset" as input, or returns error
+ * @get: returns value for signal "offset"; for output signals this
+ *	returns either the value actually sensed, or zero
+ * @direction_output: configures signal "offset" as output, or returns error
+ * @set_debounce: optional hook for setting debounce time for specified gpio in
+ *      interrupt triggered gpio chips
+ * @set: assigns output value for signal "offset"
+ * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
+ *	implementation may not sleep
+ * @dbg_show: optional routine to show contents in debugfs; default code
+ *	will be used when this is omitted, but custom code can show extra
+ *	state (such as pullup/pulldown configuration).
+ * @base: identifies the first GPIO number handled by this chip; or, if
+ *	negative during registration, requests dynamic ID allocation.
+ * @ngpio: the number of GPIOs handled by this controller; the last GPIO
+ *	handled is (base + ngpio - 1).
+ * @can_sleep: flag must be set iff get()/set() methods sleep, as they
+ *	must while accessing GPIO expander chips over I2C or SPI
+ * @names: if set, must be an array of strings to use as alternative
+ *      names for the GPIOs in this chip. Any entry in the array
+ *      may be NULL if there is no alias for the GPIO, however the
+ *      array must be @ngpio entries long.  A name can include a single printk
+ *      format specifier for an unsigned int.  It is substituted by the actual
+ *      number of the gpio.
+ *
+ * A gpio_chip can help platforms abstract various sources of GPIOs so
+ * they can all be accessed through a common programing interface.
+ * Example sources would be SOC controllers, FPGAs, multifunction
+ * chips, dedicated GPIO expanders, and so on.
+ *
+ * Each chip controls a number of signals, identified in method calls
+ * by "offset" values in the range 0..(@ngpio - 1).  When those signals
+ * are referenced through calls like gpio_get_value(gpio), the offset
+ * is calculated by subtracting @base from the gpio number.
+ */
+struct gpio_chip {
+	const char		*label;
+	struct device		*dev;
+	struct module		*owner;
+
+	int			(*request)(struct gpio_chip *chip,
+						unsigned offset);
+	void			(*free)(struct gpio_chip *chip,
+						unsigned offset);
+	int			(*get_direction)(struct gpio_chip *chip,
+						unsigned offset);
+	int			(*direction_input)(struct gpio_chip *chip,
+						unsigned offset);
+	int			(*get)(struct gpio_chip *chip,
+						unsigned offset);
+	int			(*direction_output)(struct gpio_chip *chip,
+						unsigned offset, int value);
+	int			(*set_debounce)(struct gpio_chip *chip,
+						unsigned offset,
+						unsigned debounce);
+
+	void			(*set)(struct gpio_chip *chip,
+						unsigned offset, int value);
+
+	int			(*to_irq)(struct gpio_chip *chip,
+						unsigned offset);
+
+	void			(*dbg_show)(struct seq_file *s,
+						struct gpio_chip *chip);
+	int			base;
+	u16			ngpio;
+	const char		*const *names;
+	unsigned		can_sleep:1;
+	unsigned		exported:1;
+
+#if defined(CONFIG_OF_GPIO)
+	/*
+	 * If CONFIG_OF is enabled, then all GPIO controllers described in the
+	 * device tree automatically may have an OF translation
+	 */
+	struct device_node *of_node;
+	int of_gpio_n_cells;
+	int (*of_xlate)(struct gpio_chip *gc,
+			const struct of_phandle_args *gpiospec, u32 *flags);
+#endif
+#ifdef CONFIG_PINCTRL
+	/*
+	 * If CONFIG_PINCTRL is enabled, then gpio controllers can optionally
+	 * describe the actual pin range which they serve in an SoC. This
+	 * information would be used by pinctrl subsystem to configure
+	 * corresponding pins for gpio usage.
+	 */
+	struct list_head pin_ranges;
+#endif
+};
+
+#endif /* CONFIG_GPIOLIB */
+
+#endif
-- 
1.8.1

