Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab2JTKXJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 06:23:09 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:59944 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754155Ab2JTKWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 06:22:22 -0400
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 2/5 v6] gpio: Add sysfs support to block GPIO API
Date: Sat, 20 Oct 2012 12:21:45 +0200
Message-Id: <1350728508-22508-3-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350728508-22508-1-git-send-email-stigge@antcom.de>
References: <1350728508-22508-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds sysfs support to the block GPIO API.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 Documentation/ABI/testing/sysfs-gpio |   18 ++
 drivers/gpio/gpiolib.c               |  214 +++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h           |   11 +
 include/linux/gpio.h                 |   13 ++
 4 files changed, 256 insertions(+)

--- linux-2.6.orig/Documentation/ABI/testing/sysfs-gpio
+++ linux-2.6/Documentation/ABI/testing/sysfs-gpio
@@ -25,3 +25,21 @@ Description:
 	    /label ... (r/o) descriptive, not necessarily unique
 	    /ngpio ... (r/o) number of GPIOs; numbered N to N + (ngpio - 1)
 
+What:		/sys/class/gpioblock/
+Date:		October 2012
+KernelVersion:	3.7
+Contact:	Roland Stigge <stigge@antcom.de>
+Description:
+
+  Block GPIO devices are visible in sysfs as soon as they are registered
+  (e.g. via devicetree definition). For actual I/O use, their "exported"
+  boolean attribute must be set to "1". Then, the attribute "values" is
+  created and at the same time, the GPIOs in the block are requested for
+  exclusive use by sysfs.
+
+    /sys/class/gpioblock
+	/BLOCKNAME ... for each GPIO block name
+	    /ngpio ... (r/o) number of GPIOs in this group
+	    /exported ... sysfs export state of this group (0, 1)
+	    /value ... current value as 32 or 64 bit integer in hex
+                       (only available if /exported is 1)
--- linux-2.6.orig/drivers/gpio/gpiolib.c
+++ linux-2.6/drivers/gpio/gpiolib.c
@@ -972,6 +972,214 @@ static void gpiochip_unexport(struct gpi
 				chip->label, status);
 }
 
+static ssize_t gpio_block_ngpio_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	const struct gpio_block	*block = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u\n", block->ngpio);
+}
+
+static ssize_t gpio_block_value_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	const struct gpio_block *block = dev_get_drvdata(dev);
+
+	return sprintf(buf, sizeof(unsigned long) == 4 ? "0x%08lx\n" :
+		       "0x%016lx\n", gpio_block_get(block));
+}
+
+static bool gpio_block_is_output(struct gpio_block *block)
+{
+	int i;
+
+	for (i = 0; i < block->ngpio; i++)
+		if (!test_bit(FLAG_IS_OUT, &gpio_desc[block->gpio[i]].flags))
+			return false;
+	return true;
+}
+
+static ssize_t gpio_block_value_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t size)
+{
+	ssize_t			status;
+	struct gpio_block	*block = dev_get_drvdata(dev);
+	unsigned long		value;
+
+	status = kstrtoul(buf, 0, &value);
+	if (status == 0) {
+		mutex_lock(&sysfs_lock);
+		if (gpio_block_is_output(block)) {
+			gpio_block_set(block, value);
+			status = size;
+		} else {
+			status = -EPERM;
+		}
+		mutex_unlock(&sysfs_lock);
+	}
+	return status;
+}
+
+static struct device_attribute
+dev_attr_block_value = __ATTR(value, S_IWUSR | S_IRUGO, gpio_block_value_show,
+			      gpio_block_value_store);
+
+static struct class gpio_block_class;
+
+static int gpio_block_value_is_exported(struct gpio_block *block)
+{
+	struct device		*dev;
+	struct sysfs_dirent	*sd = NULL;
+
+	mutex_lock(&sysfs_lock);
+	dev = class_find_device(&gpio_block_class, NULL, block, match_export);
+	if (!dev)
+		goto out;
+
+	sd = sysfs_get_dirent(dev->kobj.sd, NULL, "value");
+
+out:
+	mutex_unlock(&sysfs_lock);
+	return !!sd;
+}
+
+static ssize_t gpio_block_exported_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct gpio_block	*block = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u\n", gpio_block_value_is_exported(block));
+}
+
+static int gpio_block_value_export(struct gpio_block *block)
+{
+	struct device	*dev;
+	int		status;
+	int		i;
+
+	mutex_lock(&sysfs_lock);
+
+	for (i = 0; i < block->ngpio; i++) {
+		status = gpio_request(block->gpio[i], "sysfs");
+		if (status)
+			goto out;
+	}
+
+	dev = class_find_device(&gpio_block_class, NULL, block, match_export);
+	if (!dev) {
+		status = -ENODEV;
+		goto out;
+	}
+
+	status = device_create_file(dev, &dev_attr_block_value);
+	if (status)
+		goto out;
+
+	mutex_unlock(&sysfs_lock);
+	return 0;
+
+out:
+	while (--i >= 0)
+		gpio_free(block->gpio[i]);
+
+	mutex_unlock(&sysfs_lock);
+	return status;
+}
+
+static int gpio_block_value_unexport(struct gpio_block *block)
+{
+	struct device	*dev;
+	int		i;
+
+	dev = class_find_device(&gpio_block_class, NULL, block, match_export);
+	if (!dev)
+		return -ENODEV;
+
+	for (i = 0; i < block->ngpio; i++)
+		gpio_free(block->gpio[i]);
+
+	device_remove_file(dev, &dev_attr_block_value);
+
+	return 0;
+}
+
+static ssize_t gpio_block_exported_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t size)
+{
+	long	value;
+	int	status;
+	struct	gpio_block *block = dev_get_drvdata(dev);
+	int	exported = gpio_block_value_is_exported(block);
+
+	status = kstrtoul(buf, 0, &value);
+	if (status < 0)
+		goto err;
+
+	if (value != exported) {
+		if (value)
+			status = gpio_block_value_export(block);
+		else
+			status = gpio_block_value_unexport(block);
+		if (!status)
+			status = size;
+	} else {
+		status = size;
+	}
+err:
+	return status;
+}
+
+static struct device_attribute gpio_block_attrs[] = {
+	__ATTR(exported, S_IWUSR | S_IRUGO, gpio_block_exported_show,
+	       gpio_block_exported_store),
+	__ATTR(ngpio, S_IRUGO, gpio_block_ngpio_show, NULL),
+	__ATTR_NULL,
+};
+
+static struct class gpio_block_class = {
+	.name =         "gpioblock",
+	.owner =        THIS_MODULE,
+
+	.dev_attrs =  gpio_block_attrs,
+};
+
+int gpio_block_export(struct gpio_block *block)
+{
+	int		status = 0;
+	struct device	*dev;
+
+	/* can't export until sysfs is available ... */
+	if (!gpio_block_class.p) {
+		pr_debug("%s: called too early!\n", __func__);
+		return -ENOENT;
+	}
+
+	mutex_lock(&sysfs_lock);
+	dev = device_create(&gpio_block_class, NULL, MKDEV(0, 0), block,
+			    block->name);
+	if (IS_ERR(dev))
+		status = PTR_ERR(dev);
+	mutex_unlock(&sysfs_lock);
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_block_export);
+
+void gpio_block_unexport(struct gpio_block *block)
+{
+	struct device *dev;
+
+	mutex_lock(&sysfs_lock);
+	dev = class_find_device(&gpio_block_class, NULL, block, match_export);
+	if (dev)
+		device_unregister(dev);
+	mutex_unlock(&sysfs_lock);
+}
+EXPORT_SYMBOL_GPL(gpio_block_unexport);
+
 static int __init gpiolib_sysfs_init(void)
 {
 	int		status;
@@ -982,6 +1190,10 @@ static int __init gpiolib_sysfs_init(voi
 	if (status < 0)
 		return status;
 
+	status = class_register(&gpio_block_class);
+	if (status < 0)
+		return status;
+
 	/* Scan and register the gpio_chips which registered very
 	 * early (e.g. before the class_register above was called).
 	 *
@@ -1876,6 +2088,7 @@ int gpio_block_register(struct gpio_bloc
 		return -EBUSY;
 
 	list_add(&block->list, &gpio_block_list);
+	gpio_block_export(block);
 
 	return 0;
 }
@@ -1888,6 +2101,7 @@ void gpio_block_unregister(struct gpio_b
 	list_for_each_entry(i, &gpio_block_list, list)
 		if (i == block) {
 			list_del(&i->list);
+			gpio_block_unexport(block);
 			break;
 		}
 }
--- linux-2.6.orig/include/asm-generic/gpio.h
+++ linux-2.6/include/asm-generic/gpio.h
@@ -211,6 +211,8 @@ extern int gpio_export_link(struct devic
 			unsigned gpio);
 extern int gpio_sysfs_set_active_low(unsigned gpio, int value);
 extern void gpio_unexport(unsigned gpio);
+extern int gpio_block_export(struct gpio_block *block);
+extern void gpio_block_unexport(struct gpio_block *block);
 
 #endif	/* CONFIG_GPIO_SYSFS */
 
@@ -270,6 +272,15 @@ static inline int gpio_sysfs_set_active_
 static inline void gpio_unexport(unsigned gpio)
 {
 }
+
+static inline int gpio_block_export(struct gpio_block *block)
+{
+	return -ENOSYS;
+}
+
+static inline void gpio_block_unexport(struct gpio_block *block)
+{
+}
 #endif	/* CONFIG_GPIO_SYSFS */
 
 #endif /* _ASM_GENERIC_GPIO_H */
--- linux-2.6.orig/include/linux/gpio.h
+++ linux-2.6/include/linux/gpio.h
@@ -291,6 +291,19 @@ static inline void gpio_unexport(unsigne
 	WARN_ON(1);
 }
 
+static inline int gpio_block_export(struct gpio_block *block)
+{
+	/* GPIO block can never have been requested or set as {in,out}put */
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+static inline void gpio_block_unexport(struct gpio_block *block)
+{
+	/* GPIO block can never have been exported */
+	WARN_ON(1);
+}
+
 static inline int gpio_to_irq(unsigned gpio)
 {
 	/* GPIO can never have been requested or set as input */
