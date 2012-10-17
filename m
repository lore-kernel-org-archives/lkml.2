Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab2JQMhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 08:37:47 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:58276 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755587Ab2JQMhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:37:42 -0400
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RFC 03/15 v5] gpiolib: Fix default attributes for class
Date: Wed, 17 Oct 2012 14:31:35 +0200
Message-Id: <1350477107-26512-4-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350477107-26512-1-git-send-email-stigge@antcom.de>
References: <1350477107-26512-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race condition between creating a gpio or gpiochip device and adding
default attribues. This patch fixes this by defining the default attributes as
dev_attrs of the class. For this, it was necessary to create a separate
gpiochip_class besides gpio_class.

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 drivers/gpio/gpiolib.c |   79 +++++++++++++++++++++----------------------------
 1 file changed, 34 insertions(+), 45 deletions(-)

--- linux-2.6.orig/drivers/gpio/gpiolib.c
+++ linux-2.6/drivers/gpio/gpiolib.c
@@ -321,9 +321,6 @@ static ssize_t gpio_value_store(struct d
 	return status;
 }
 
-static const DEVICE_ATTR(value, 0644,
-		gpio_value_show, gpio_value_store);
-
 static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
 {
 	struct sysfs_dirent	*value_sd = priv;
@@ -544,19 +541,6 @@ static ssize_t gpio_active_low_store(str
 	return status ? : size;
 }
 
-static const DEVICE_ATTR(active_low, 0644,
-		gpio_active_low_show, gpio_active_low_store);
-
-static const struct attribute *gpio_attrs[] = {
-	&dev_attr_value.attr,
-	&dev_attr_active_low.attr,
-	NULL,
-};
-
-static const struct attribute_group gpio_attr_group = {
-	.attrs = (struct attribute **) gpio_attrs,
-};
-
 /*
  * /sys/class/gpio/gpiochipN/
  *   /base ... matching gpio_chip.base (N)
@@ -571,7 +555,6 @@ static ssize_t chip_base_show(struct dev
 
 	return sprintf(buf, "%d\n", chip->base);
 }
-static DEVICE_ATTR(base, 0444, chip_base_show, NULL);
 
 static ssize_t chip_label_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
@@ -580,7 +563,6 @@ static ssize_t chip_label_show(struct de
 
 	return sprintf(buf, "%s\n", chip->label ? : "");
 }
-static DEVICE_ATTR(label, 0444, chip_label_show, NULL);
 
 static ssize_t chip_ngpio_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
@@ -589,18 +571,6 @@ static ssize_t chip_ngpio_show(struct de
 
 	return sprintf(buf, "%u\n", chip->ngpio);
 }
-static DEVICE_ATTR(ngpio, 0444, chip_ngpio_show, NULL);
-
-static const struct attribute *gpiochip_attrs[] = {
-	&dev_attr_base.attr,
-	&dev_attr_label.attr,
-	&dev_attr_ngpio.attr,
-	NULL,
-};
-
-static const struct attribute_group gpiochip_attr_group = {
-	.attrs = (struct attribute **) gpiochip_attrs,
-};
 
 /*
  * /sys/class/gpio/export ... write-only
@@ -677,11 +647,32 @@ static struct class_attribute gpio_class
 	__ATTR_NULL,
 };
 
+static struct device_attribute gpio_attrs[] = {
+	__ATTR(active_low, 0644, gpio_active_low_show, gpio_active_low_store),
+	__ATTR(value, 0644, gpio_value_show, gpio_value_store),
+	__ATTR_NULL,
+};
+
 static struct class gpio_class = {
 	.name =		"gpio",
 	.owner =	THIS_MODULE,
 
-	.class_attrs =	gpio_class_attrs,
+	.class_attrs = gpio_class_attrs,
+	.dev_attrs = gpio_attrs,
+};
+
+static struct device_attribute gpiochip_attrs[] = {
+	__ATTR(label, 0444, chip_label_show, NULL),
+	__ATTR(base, 0444, chip_base_show, NULL),
+	__ATTR(ngpio, 0444, chip_ngpio_show, NULL),
+	__ATTR_NULL,
+};
+
+static struct class gpiochip_class = {
+	.name =		"gpiochip",
+	.owner =	THIS_MODULE,
+
+	.dev_attrs =	gpiochip_attrs,
 };
 
 
@@ -738,10 +729,7 @@ int gpio_export(unsigned gpio, bool dire
 		dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
 				desc, ioname ? ioname : "gpio%u", gpio);
 		if (!IS_ERR(dev)) {
-			status = sysfs_create_group(&dev->kobj,
-						&gpio_attr_group);
-
-			if (!status && direction_may_change)
+			if (direction_may_change)
 				status = device_create_file(dev,
 						&dev_attr_direction);
 
@@ -911,25 +899,22 @@ EXPORT_SYMBOL_GPL(gpio_unexport);
 
 static int gpiochip_export(struct gpio_chip *chip)
 {
-	int		status;
+	int		status = 0;
 	struct device	*dev;
 
 	/* Many systems register gpio chips for SOC support very early,
 	 * before driver model support is available.  In those cases we
 	 * export this later, in gpiolib_sysfs_init() ... here we just
-	 * verify that _some_ field of gpio_class got initialized.
+	 * verify that _some_ field of gpiochip_class got initialized.
 	 */
-	if (!gpio_class.p)
+	if (!gpiochip_class.p)
 		return 0;
 
 	/* use chip->base for the ID; it's already known to be unique */
 	mutex_lock(&sysfs_lock);
-	dev = device_create(&gpio_class, chip->dev, MKDEV(0, 0), chip,
-				"gpiochip%d", chip->base);
-	if (!IS_ERR(dev)) {
-		status = sysfs_create_group(&dev->kobj,
-				&gpiochip_attr_group);
-	} else
+	dev = device_create(&gpiochip_class, chip->dev, MKDEV(0, 0), chip,
+			    "gpiochip%d", chip->base);
+	if (IS_ERR(dev))
 		status = PTR_ERR(dev);
 	chip->exported = (status == 0);
 	mutex_unlock(&sysfs_lock);
@@ -957,7 +942,7 @@ static void gpiochip_unexport(struct gpi
 	struct device		*dev;
 
 	mutex_lock(&sysfs_lock);
-	dev = class_find_device(&gpio_class, NULL, chip, match_export);
+	dev = class_find_device(&gpiochip_class, NULL, chip, match_export);
 	if (dev) {
 		put_device(dev);
 		device_unregister(dev);
@@ -1190,6 +1175,10 @@ static int __init gpiolib_sysfs_init(voi
 	if (status < 0)
 		return status;
 
+	status = class_register(&gpiochip_class);
+	if (status < 0)
+		return status;
+
 	status = class_register(&gpio_block_class);
 	if (status < 0)
 		return status;
