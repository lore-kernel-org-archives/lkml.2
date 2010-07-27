Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab0G0LC0 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 27 Jul 2010 07:02:26 -0400
Received: from compulab.co.il ([67.18.134.219]:55548 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab0G0LCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 07:02:25 -0400
From: y@droid.compulab.local
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH] mfd: add TPS6586x driver
Date: Tue, 27 Jul 2010 14:01:40 +0300
Message-Id: <1280228500-2173-1-git-send-email-y>
X-Mailer: git-send-email 1.6.6.2
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Rapoport <mike@compulab.co.il>

Add mfd core driver for TPS6586x PMICs family.
The driver provides I/O access for the sub-device drivers and performs
regstration of the sub-devices based on the platform requirements.
In addition it implements GPIOlib interface for the chip GPIOs.

TODO:
	- add interrupt support
	- add platform data for PWM, backlight leds and charger

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/mfd/Kconfig          |   14 ++
 drivers/mfd/Makefile         |    1 +
 drivers/mfd/tps6586x.c       |  375 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/tps6586x.h |   47 ++++++
 4 files changed, 437 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/tps6586x.c
 create mode 100644 include/linux/mfd/tps6586x.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9da0e50..b6ee6cf 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -482,6 +482,20 @@ config MFD_JANZ_CMODIO
 	  host many different types of MODULbus daughterboards, including
 	  CAN and GPIO controllers.
 
+config MFD_TPS6586X
+	tristate "TPS6586x Power Management chips"
+	depends on I2C
+	select MFD_CORE
+	help
+	  If you say yes here you get support for the TPS6586X series of
+	  Power Management chips.
+  	  This driver provides common support for accessing the device,
+	  additional drivers must be enabled in order to use the
+	  functionality of the device.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called tps6586x.
+
 endif # MFD_SUPPORT
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index fb503e7..fefc1d3 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -71,3 +71,4 @@ obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
 obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
 obj-$(CONFIG_MFD_RDC321X)	+= rdc321x-southbridge.o
 obj-$(CONFIG_MFD_JANZ_CMODIO)	+= janz-cmodio.o
+obj-$(CONFIG_MFD_TPS6586X)	+= tps6586x.o
diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
new file mode 100644
index 0000000..be514e5
--- /dev/null
+++ b/drivers/mfd/tps6586x.c
@@ -0,0 +1,375 @@
+/*
+ * Core driver for TI TPS6586x PMIC family
+ *
+ * Copyright (c) 2010 CompuLab Ltd.
+ * Mike Rapoport <mike@compulab.co.il>
+ *
+ * Based on da903x.c.
+ * Copyright (C) 2008 Compulab, Ltd.
+ * Mike Rapoport <mike@compulab.co.il>
+ * Copyright (C) 2006-2008 Marvell International Ltd.
+ * Eric Miao <eric.miao@marvell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+
+#include <linux/mfd/core.h>
+#include <linux/mfd/tps6586x.h>
+
+/* GPIO control registers */
+#define TPS6586X_GPIOSET1	0x5d
+#define TPS6586X_GPIOSET2	0x5e
+
+/* device id */
+#define TPS6586X_VERSIONCRC	0xcd
+#define TPS658621A_VERSIONCRC	0x15
+
+struct tps6586x {
+	struct mutex		lock;
+	struct device		*dev;
+	struct i2c_client	*client;
+
+	struct gpio_chip	gpio;
+};
+
+static inline int __tps6586x_read(struct i2c_client *client,
+				  int reg, uint8_t *val)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(client, reg);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed reading at 0x%02x\n", reg);
+		return ret;
+	}
+
+	*val = (uint8_t)ret;
+
+	return 0;
+}
+
+static inline int __tps6586x_reads(struct i2c_client *client, int reg,
+				   int len, uint8_t *val)
+{
+	int ret;
+
+	ret = i2c_smbus_read_i2c_block_data(client, reg, len, val);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed reading from 0x%02x\n", reg);
+		return ret;
+	}
+
+	return 0;
+}
+
+static inline int __tps6586x_write(struct i2c_client *client,
+				 int reg, uint8_t val)
+{
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(client, reg, val);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed writing 0x%02x to 0x%02x\n",
+				val, reg);
+		return ret;
+	}
+
+	return 0;
+}
+
+static inline int __tps6586x_writes(struct i2c_client *client, int reg,
+				  int len, uint8_t *val)
+{
+	int ret;
+
+	ret = i2c_smbus_write_i2c_block_data(client, reg, len, val);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed writings to 0x%02x\n", reg);
+		return ret;
+	}
+
+	return 0;
+}
+
+int tps6586x_write(struct device *dev, int reg, uint8_t val)
+{
+	return __tps6586x_write(to_i2c_client(dev), reg, val);
+}
+EXPORT_SYMBOL_GPL(tps6586x_write);
+
+int tps6586x_writes(struct device *dev, int reg, int len, uint8_t *val)
+{
+	return __tps6586x_writes(to_i2c_client(dev), reg, len, val);
+}
+EXPORT_SYMBOL_GPL(tps6586x_writes);
+
+int tps6586x_read(struct device *dev, int reg, uint8_t *val)
+{
+	return __tps6586x_read(to_i2c_client(dev), reg, val);
+}
+EXPORT_SYMBOL_GPL(tps6586x_read);
+
+int tps6586x_reads(struct device *dev, int reg, int len, uint8_t *val)
+{
+	return __tps6586x_reads(to_i2c_client(dev), reg, len, val);
+}
+EXPORT_SYMBOL_GPL(tps6586x_reads);
+
+int tps6586x_set_bits(struct device *dev, int reg, uint8_t bit_mask)
+{
+	struct tps6586x *tps6586x = dev_get_drvdata(dev);
+	uint8_t reg_val;
+	int ret = 0;
+
+	mutex_lock(&tps6586x->lock);
+
+	ret = __tps6586x_read(to_i2c_client(dev), reg, &reg_val);
+	if (ret)
+		goto out;
+
+	if ((reg_val & bit_mask) == 0) {
+		reg_val |= bit_mask;
+		ret = __tps6586x_write(to_i2c_client(dev), reg, reg_val);
+	}
+out:
+	mutex_unlock(&tps6586x->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tps6586x_set_bits);
+
+int tps6586x_clr_bits(struct device *dev, int reg, uint8_t bit_mask)
+{
+	struct tps6586x *tps6586x = dev_get_drvdata(dev);
+	uint8_t reg_val;
+	int ret = 0;
+
+	mutex_lock(&tps6586x->lock);
+
+	ret = __tps6586x_read(to_i2c_client(dev), reg, &reg_val);
+	if (ret)
+		goto out;
+
+	if (reg_val & bit_mask) {
+		reg_val &= ~bit_mask;
+		ret = __tps6586x_write(to_i2c_client(dev), reg, reg_val);
+	}
+out:
+	mutex_unlock(&tps6586x->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tps6586x_clr_bits);
+
+int tps6586x_update(struct device *dev, int reg, uint8_t val, uint8_t mask)
+{
+	struct tps6586x *tps6586x = dev_get_drvdata(dev);
+	uint8_t reg_val;
+	int ret = 0;
+
+	mutex_lock(&tps6586x->lock);
+
+	ret = __tps6586x_read(tps6586x->client, reg, &reg_val);
+	if (ret)
+		goto out;
+
+	if ((reg_val & mask) != val) {
+		reg_val = (reg_val & ~mask) | val;
+		ret = __tps6586x_write(tps6586x->client, reg, reg_val);
+	}
+out:
+	mutex_unlock(&tps6586x->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tps6586x_update);
+
+static int tps6586x_gpio_get(struct gpio_chip *gc, unsigned offset)
+{
+	struct tps6586x *tps6586x = container_of(gc, struct tps6586x, gpio);
+	uint8_t val;
+	int ret;
+
+	ret = __tps6586x_read(tps6586x->client, TPS6586X_GPIOSET2, &val);
+	if (ret)
+		return ret;
+
+	return !!(val & (1 << offset));
+}
+
+
+static void tps6586x_gpio_set(struct gpio_chip *chip, unsigned offset,
+			      int value)
+{
+	struct tps6586x *tps6586x = container_of(chip, struct tps6586x, gpio);
+
+	__tps6586x_write(tps6586x->client, TPS6586X_GPIOSET2,
+			 value << offset);
+}
+
+static int tps6586x_gpio_output(struct gpio_chip *gc, unsigned offset,
+				int value)
+{
+	struct tps6586x *tps6586x = container_of(gc, struct tps6586x, gpio);
+	uint8_t val, mask;
+
+	tps6586x_gpio_set(gc, offset, value);
+
+	val = 0x1 << (offset * 2);
+	mask = 0x3 << (offset * 2);
+
+	return tps6586x_update(tps6586x->dev, TPS6586X_GPIOSET1, val, mask);
+}
+
+static void tps6586x_gpio_init(struct tps6586x *tps6586x, int gpio_base)
+{
+	int ret;
+
+	if (!gpio_base)
+		return;
+
+	tps6586x->gpio.owner		= THIS_MODULE;
+	tps6586x->gpio.label		= tps6586x->client->name;
+	tps6586x->gpio.dev		= tps6586x->dev;
+	tps6586x->gpio.base		= gpio_base;
+	tps6586x->gpio.ngpio		= 4;
+	tps6586x->gpio.can_sleep	= 1;
+
+	/* FIXME: add handling of GPIOs as dedicated inputs */
+	tps6586x->gpio.direction_output	= tps6586x_gpio_output;
+	tps6586x->gpio.set		= tps6586x_gpio_set;
+	tps6586x->gpio.get		= tps6586x_gpio_get;
+
+	ret = gpiochip_add(&tps6586x->gpio);
+	if (ret)
+		dev_warn(tps6586x->dev, "GPIO registration failed: %d\n", ret);
+}
+
+static int __remove_subdev(struct device *dev, void *unused)
+{
+	platform_device_unregister(to_platform_device(dev));
+	return 0;
+}
+
+static int tps6586x_remove_subdevs(struct tps6586x *tps6586x)
+{
+	return device_for_each_child(tps6586x->dev, NULL, __remove_subdev);
+}
+
+static int __devinit tps6586x_add_subdevs(struct tps6586x *tps6586x,
+					  struct tps6586x_platform_data *pdata)
+{
+	struct tps6586x_subdev_info *subdev;
+	struct platform_device *pdev;
+	int i, ret = 0;
+
+	for (i = 0; i < pdata->num_subdevs; i++) {
+		subdev = &pdata->subdevs[i];
+
+		pdev = platform_device_alloc(subdev->name, subdev->id);
+
+		pdev->dev.parent = tps6586x->dev;
+		pdev->dev.platform_data = subdev->platform_data;
+
+		ret = platform_device_add(pdev);
+		if (ret)
+			goto failed;
+	}
+	return 0;
+
+failed:
+	tps6586x_remove_subdevs(tps6586x);
+	return ret;
+}
+
+static int __devinit tps6586x_probe(struct i2c_client *client,
+				    const struct i2c_device_id *id)
+{
+	struct tps6586x_platform_data *pdata = client->dev.platform_data;
+	struct tps6586x *tps6586x;
+	int ret;
+
+	if (!pdata) {
+		dev_err(&client->dev, "tps6586x requires platform data\n");
+		return -ENOTSUPP;
+	}
+
+	ret = i2c_smbus_read_byte_data(client, TPS6586X_VERSIONCRC);
+	if (ret < 0) {
+		dev_err(&client->dev, "Chip ID read failed: %d\n", ret);
+		return -EIO;
+	}
+
+	if (ret != TPS658621A_VERSIONCRC) {
+		dev_err(&client->dev, "Unsupported chip ID: %x\n", ret);
+		return -ENODEV;
+	}
+
+	tps6586x = kzalloc(sizeof(struct tps6586x), GFP_KERNEL);
+	if (tps6586x == NULL)
+		return -ENOMEM;
+
+	tps6586x->client = client;
+	tps6586x->dev = &client->dev;
+	i2c_set_clientdata(client, tps6586x);
+
+	mutex_init(&tps6586x->lock);
+
+	ret = tps6586x_add_subdevs(tps6586x, pdata);
+	if (ret) {
+		dev_err(&client->dev, "add devices failed: %d\n", ret);
+		goto err_add_devs;
+	}
+
+	tps6586x_gpio_init(tps6586x, pdata->gpio_base);
+
+	return 0;
+
+err_add_devs:
+	kfree(tps6586x);
+	return ret;
+}
+
+static int __devexit tps6586x_remove(struct i2c_client *client)
+{
+	return 0;
+}
+
+static const struct i2c_device_id tps6586x_id_table[] = {
+	{ "tps6586x", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, tps6586x_id_table);
+
+static struct i2c_driver tps6586x_driver = {
+	.driver	= {
+		.name	= "tps6586x",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= tps6586x_probe,
+	.remove		= __devexit_p(tps6586x_remove),
+	.id_table	= tps6586x_id_table,
+};
+
+static int __init tps6586x_init(void)
+{
+	return i2c_add_driver(&tps6586x_driver);
+}
+subsys_initcall(tps6586x_init);
+
+static void __exit tps6586x_exit(void)
+{
+	i2c_del_driver(&tps6586x_driver);
+}
+module_exit(tps6586x_exit);
+
+MODULE_DESCRIPTION("TPS6586X core driver");
+MODULE_AUTHOR("Mike Rapoport <mike@compulab.co.il>");
+MODULE_LICENSE("GPL");
+
diff --git a/include/linux/mfd/tps6586x.h b/include/linux/mfd/tps6586x.h
new file mode 100644
index 0000000..772b3ae
--- /dev/null
+++ b/include/linux/mfd/tps6586x.h
@@ -0,0 +1,47 @@
+#ifndef __LINUX_MFD_TPS6586X_H
+#define __LINUX_MFD_TPS6586X_H
+
+enum {
+	TPS6586X_ID_SM_0,
+	TPS6586X_ID_SM_1,
+	TPS6586X_ID_SM_2,
+	TPS6586X_ID_LDO_0,
+	TPS6586X_ID_LDO_1,
+	TPS6586X_ID_LDO_2,
+	TPS6586X_ID_LDO_3,
+	TPS6586X_ID_LDO_4,
+	TPS6586X_ID_LDO_5,
+	TPS6586X_ID_LDO_6,
+	TPS6586X_ID_LDO_7,
+	TPS6586X_ID_LDO_8,
+	TPS6586X_ID_LDO_9,
+	TPS6586X_ID_LDO_RTC,
+};
+
+struct tps6586x_subdev_info {
+	int		id;
+	const char	*name;
+	void		*platform_data;
+};
+
+struct tps6586x_platform_data {
+	int num_subdevs;
+	struct tps6586x_subdev_info *subdevs;
+
+	int gpio_base;
+};
+
+/*
+ * NOTE: the functions below are not intended for use outside
+ * of the TPS6586X sub-device drivers
+ */
+extern int tps6586x_write(struct device *dev, int reg, uint8_t val);
+extern int tps6586x_writes(struct device *dev, int reg, int len, uint8_t *val);
+extern int tps6586x_read(struct device *dev, int reg, uint8_t *val);
+extern int tps6586x_reads(struct device *dev, int reg, int len, uint8_t *val);
+extern int tps6586x_set_bits(struct device *dev, int reg, uint8_t bit_mask);
+extern int tps6586x_clr_bits(struct device *dev, int reg, uint8_t bit_mask);
+extern int tps6586x_update(struct device *dev, int reg, uint8_t val,
+			   uint8_t mask);
+
+#endif /*__LINUX_MFD_TPS6586X_H */
-- 
1.6.6.2

