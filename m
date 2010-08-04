Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab0HDN7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 09:59:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62082 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab0HDN7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 09:59:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=hmzJLM4cNMg3Kg81VRyH58I1bUug4cyyWy/8GCAOLhexTAoMBbo9z/XXYZWQpAfIPN
         aWRRW+BdM8g/FWcZad7nrCC3ZmDRH0j4BVTztkU+DPFN4b1RZE+Hh6wf2hN+Z/WjyIDO
         cNafJg6MG8bCzmRsSJzfwdkI9EoWRCLBoTFWk=
MIME-Version: 1.0
Date: Wed, 4 Aug 2010 16:59:31 +0300
Message-ID: <AANLkTinmm17rYJX-A7mvutMGzdDYZgYe1_TjEsFRbwg1@mail.gmail.com>
Subject: [PATCH v2] mfd: add TPS6586x driver
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mike Rapoport <mike@compulab.co.il>, Jean Delvare <khali@linux-fr.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00163646ba66c380fd048cffd75f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00163646ba66c380fd048cffd75f
Content-Type: text/plain; charset=ISO-8859-1

Hi Samuel.
Here's the updated version of the TPS6586x driver.
I've left the GPIO code in the driver because of
* David prefers to keep GPIO part of MFD devices in the drivers/mfd ( [1] )
* Implementation of dedicated input functionality rather belongs to the MFD core

[1] http://lkml.org/lkml/2010/6/30/307


v2 changes: changed tps6586x_{probe,remove} to  tps6586x_i2c_{probe,remove}
-- 

>From 323eadedcec6af1b6579b05c9858fd8421b77b95 Mon Sep 17 00:00:00 2001
From: Mike Rapoport <mike@compulab.co.il>
Date: Tue, 27 Jul 2010 13:45:41 +0300
Subject: [PATCH] mfd: add TPS6586x driver

Add mfd core driver for TPS6586x PMICs family.
The driver provides I/O access for the sub-device drivers and performs
regstration of the sub-devices based on the platform requirements.
In addition it implements GPIOlib interface for the chip GPIOs.

TODO:
	- add interrupt support
	- add platform data for PWM, backlight leds and charger

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
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
index 0000000..4cde31e
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
+static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
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
+static int __devexit tps6586x_i2c_remove(struct i2c_client *client)
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
+	.probe		= tps6586x_i2c_probe,
+	.remove		= __devexit_p(tps6586x_i2c_remove),
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
1.6.3.3

--00163646ba66c380fd048cffd75f
Content-Type: application/octet-stream; 
	name="0001-mfd-add-TPS6586x-driver.patch"
Content-Disposition: attachment; 
	filename="0001-mfd-add-TPS6586x-driver.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gcg8tz0h0

RnJvbSAzMjNlYWRlZGNlYzZhZjFiNjU3OWIwNWM5ODU4ZmQ4NDIxYjc3Yjk1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaWtlIFJhcG9wb3J0IDxtaWtlQGNvbXB1bGFiLmNvLmlsPgpE
YXRlOiBUdWUsIDI3IEp1bCAyMDEwIDEzOjQ1OjQxICswMzAwClN1YmplY3Q6IFtQQVRDSF0gbWZk
OiBhZGQgVFBTNjU4NnggZHJpdmVyCgpBZGQgbWZkIGNvcmUgZHJpdmVyIGZvciBUUFM2NTg2eCBQ
TUlDcyBmYW1pbHkuClRoZSBkcml2ZXIgcHJvdmlkZXMgSS9PIGFjY2VzcyBmb3IgdGhlIHN1Yi1k
ZXZpY2UgZHJpdmVycyBhbmQgcGVyZm9ybXMKcmVnc3RyYXRpb24gb2YgdGhlIHN1Yi1kZXZpY2Vz
IGJhc2VkIG9uIHRoZSBwbGF0Zm9ybSByZXF1aXJlbWVudHMuCkluIGFkZGl0aW9uIGl0IGltcGxl
bWVudHMgR1BJT2xpYiBpbnRlcmZhY2UgZm9yIHRoZSBjaGlwIEdQSU9zLgoKVE9ETzoKCS0gYWRk
IGludGVycnVwdCBzdXBwb3J0CgktIGFkZCBwbGF0Zm9ybSBkYXRhIGZvciBQV00sIGJhY2tsaWdo
dCBsZWRzIGFuZCBjaGFyZ2VyCgpTaWduZWQtb2ZmLWJ5OiBNaWtlIFJhcG9wb3J0IDxtaWtlQGNv
bXB1bGFiLmNvLmlsPgpTaWduZWQtb2ZmLWJ5OiBNaWtlIFJhcG9wb3J0IDxtaWtlLnJhcG9wb3J0
QGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL21mZC9LY29uZmlnICAgICAgICAgIHwgICAxNCArKwog
ZHJpdmVycy9tZmQvTWFrZWZpbGUgICAgICAgICB8ICAgIDEgKwogZHJpdmVycy9tZmQvdHBzNjU4
NnguYyAgICAgICB8ICAzNzUgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrCiBpbmNsdWRlL2xpbnV4L21mZC90cHM2NTg2eC5oIHwgICA0NyArKysrKysKIDQgZmlsZXMg
Y2hhbmdlZCwgNDM3IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCiBjcmVhdGUgbW9kZSAx
MDA2NDQgZHJpdmVycy9tZmQvdHBzNjU4NnguYwogY3JlYXRlIG1vZGUgMTAwNjQ0IGluY2x1ZGUv
bGludXgvbWZkL3RwczY1ODZ4LmgKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21mZC9LY29uZmlnIGIv
ZHJpdmVycy9tZmQvS2NvbmZpZwppbmRleCA5ZGEwZTUwLi5iNmVlNmNmIDEwMDY0NAotLS0gYS9k
cml2ZXJzL21mZC9LY29uZmlnCisrKyBiL2RyaXZlcnMvbWZkL0tjb25maWcKQEAgLTQ4Miw2ICs0
ODIsMjAgQEAgY29uZmlnIE1GRF9KQU5aX0NNT0RJTwogCSAgaG9zdCBtYW55IGRpZmZlcmVudCB0
eXBlcyBvZiBNT0RVTGJ1cyBkYXVnaHRlcmJvYXJkcywgaW5jbHVkaW5nCiAJICBDQU4gYW5kIEdQ
SU8gY29udHJvbGxlcnMuCiAKK2NvbmZpZyBNRkRfVFBTNjU4NlgKKwl0cmlzdGF0ZSAiVFBTNjU4
NnggUG93ZXIgTWFuYWdlbWVudCBjaGlwcyIKKwlkZXBlbmRzIG9uIEkyQworCXNlbGVjdCBNRkRf
Q09SRQorCWhlbHAKKwkgIElmIHlvdSBzYXkgeWVzIGhlcmUgeW91IGdldCBzdXBwb3J0IGZvciB0
aGUgVFBTNjU4Nlggc2VyaWVzIG9mCisJICBQb3dlciBNYW5hZ2VtZW50IGNoaXBzLgorICAJICBU
aGlzIGRyaXZlciBwcm92aWRlcyBjb21tb24gc3VwcG9ydCBmb3IgYWNjZXNzaW5nIHRoZSBkZXZp
Y2UsCisJICBhZGRpdGlvbmFsIGRyaXZlcnMgbXVzdCBiZSBlbmFibGVkIGluIG9yZGVyIHRvIHVz
ZSB0aGUKKwkgIGZ1bmN0aW9uYWxpdHkgb2YgdGhlIGRldmljZS4KKworCSAgVGhpcyBkcml2ZXIg
Y2FuIGFsc28gYmUgYnVpbHQgYXMgYSBtb2R1bGUuICBJZiBzbywgdGhlIG1vZHVsZQorCSAgd2ls
bCBiZSBjYWxsZWQgdHBzNjU4NnguCisKIGVuZGlmICMgTUZEX1NVUFBPUlQKIAogbWVudSAiTXVs
dGltZWRpYSBDYXBhYmlsaXRpZXMgUG9ydCBkcml2ZXJzIgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9t
ZmQvTWFrZWZpbGUgYi9kcml2ZXJzL21mZC9NYWtlZmlsZQppbmRleCBmYjUwM2U3Li5mZWZjMWQz
IDEwMDY0NAotLS0gYS9kcml2ZXJzL21mZC9NYWtlZmlsZQorKysgYi9kcml2ZXJzL21mZC9NYWtl
ZmlsZQpAQCAtNzEsMyArNzEsNCBAQCBvYmotJChDT05GSUdfUE1JQ19BRFA1NTIwKQkrPSBhZHA1
NTIwLm8KIG9iai0kKENPTkZJR19MUENfU0NIKQkJKz0gbHBjX3NjaC5vCiBvYmotJChDT05GSUdf
TUZEX1JEQzMyMVgpCSs9IHJkYzMyMXgtc291dGhicmlkZ2Uubwogb2JqLSQoQ09ORklHX01GRF9K
QU5aX0NNT0RJTykJKz0gamFuei1jbW9kaW8ubworb2JqLSQoQ09ORklHX01GRF9UUFM2NTg2WCkJ
Kz0gdHBzNjU4NngubwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZmQvdHBzNjU4NnguYyBiL2RyaXZl
cnMvbWZkL3RwczY1ODZ4LmMKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMC4uNGNk
ZTMxZQotLS0gL2Rldi9udWxsCisrKyBiL2RyaXZlcnMvbWZkL3RwczY1ODZ4LmMKQEAgLTAsMCAr
MSwzNzUgQEAKKy8qCisgKiBDb3JlIGRyaXZlciBmb3IgVEkgVFBTNjU4NnggUE1JQyBmYW1pbHkK
KyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTAgQ29tcHVMYWIgTHRkLgorICogTWlrZSBSYXBvcG9y
dCA8bWlrZUBjb21wdWxhYi5jby5pbD4KKyAqCisgKiBCYXNlZCBvbiBkYTkwM3guYy4KKyAqIENv
cHlyaWdodCAoQykgMjAwOCBDb21wdWxhYiwgTHRkLgorICogTWlrZSBSYXBvcG9ydCA8bWlrZUBj
b21wdWxhYi5jby5pbD4KKyAqIENvcHlyaWdodCAoQykgMjAwNi0yMDA4IE1hcnZlbGwgSW50ZXJu
YXRpb25hbCBMdGQuCisgKiBFcmljIE1pYW8gPGVyaWMubWlhb0BtYXJ2ZWxsLmNvbT4KKyAqCisg
KiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQg
YW5kL29yIG1vZGlmeQorICogaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQ
dWJsaWMgTGljZW5zZSB2ZXJzaW9uIDIgYXMKKyAqIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0
d2FyZSBGb3VuZGF0aW9uLgorICovCisKKyNpbmNsdWRlIDxsaW51eC9rZXJuZWwuaD4KKyNpbmNs
dWRlIDxsaW51eC9tb2R1bGUuaD4KKyNpbmNsdWRlIDxsaW51eC9tdXRleC5oPgorI2luY2x1ZGUg
PGxpbnV4L3NsYWIuaD4KKyNpbmNsdWRlIDxsaW51eC9ncGlvLmg+CisjaW5jbHVkZSA8bGludXgv
aTJjLmg+CisKKyNpbmNsdWRlIDxsaW51eC9tZmQvY29yZS5oPgorI2luY2x1ZGUgPGxpbnV4L21m
ZC90cHM2NTg2eC5oPgorCisvKiBHUElPIGNvbnRyb2wgcmVnaXN0ZXJzICovCisjZGVmaW5lIFRQ
UzY1ODZYX0dQSU9TRVQxCTB4NWQKKyNkZWZpbmUgVFBTNjU4NlhfR1BJT1NFVDIJMHg1ZQorCisv
KiBkZXZpY2UgaWQgKi8KKyNkZWZpbmUgVFBTNjU4NlhfVkVSU0lPTkNSQwkweGNkCisjZGVmaW5l
IFRQUzY1ODYyMUFfVkVSU0lPTkNSQwkweDE1CisKK3N0cnVjdCB0cHM2NTg2eCB7CisJc3RydWN0
IG11dGV4CQlsb2NrOworCXN0cnVjdCBkZXZpY2UJCSpkZXY7CisJc3RydWN0IGkyY19jbGllbnQJ
KmNsaWVudDsKKworCXN0cnVjdCBncGlvX2NoaXAJZ3BpbzsKK307CisKK3N0YXRpYyBpbmxpbmUg
aW50IF9fdHBzNjU4NnhfcmVhZChzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50LAorCQkJCSAgaW50
IHJlZywgdWludDhfdCAqdmFsKQoreworCWludCByZXQ7CisKKwlyZXQgPSBpMmNfc21idXNfcmVh
ZF9ieXRlX2RhdGEoY2xpZW50LCByZWcpOworCWlmIChyZXQgPCAwKSB7CisJCWRldl9lcnIoJmNs
aWVudC0+ZGV2LCAiZmFpbGVkIHJlYWRpbmcgYXQgMHglMDJ4XG4iLCByZWcpOworCQlyZXR1cm4g
cmV0OworCX0KKworCSp2YWwgPSAodWludDhfdClyZXQ7CisKKwlyZXR1cm4gMDsKK30KKworc3Rh
dGljIGlubGluZSBpbnQgX190cHM2NTg2eF9yZWFkcyhzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50
LCBpbnQgcmVnLAorCQkJCSAgIGludCBsZW4sIHVpbnQ4X3QgKnZhbCkKK3sKKwlpbnQgcmV0Owor
CisJcmV0ID0gaTJjX3NtYnVzX3JlYWRfaTJjX2Jsb2NrX2RhdGEoY2xpZW50LCByZWcsIGxlbiwg
dmFsKTsKKwlpZiAocmV0IDwgMCkgeworCQlkZXZfZXJyKCZjbGllbnQtPmRldiwgImZhaWxlZCBy
ZWFkaW5nIGZyb20gMHglMDJ4XG4iLCByZWcpOworCQlyZXR1cm4gcmV0OworCX0KKworCXJldHVy
biAwOworfQorCitzdGF0aWMgaW5saW5lIGludCBfX3RwczY1ODZ4X3dyaXRlKHN0cnVjdCBpMmNf
Y2xpZW50ICpjbGllbnQsCisJCQkJIGludCByZWcsIHVpbnQ4X3QgdmFsKQoreworCWludCByZXQ7
CisKKwlyZXQgPSBpMmNfc21idXNfd3JpdGVfYnl0ZV9kYXRhKGNsaWVudCwgcmVnLCB2YWwpOwor
CWlmIChyZXQgPCAwKSB7CisJCWRldl9lcnIoJmNsaWVudC0+ZGV2LCAiZmFpbGVkIHdyaXRpbmcg
MHglMDJ4IHRvIDB4JTAyeFxuIiwKKwkJCQl2YWwsIHJlZyk7CisJCXJldHVybiByZXQ7CisJfQor
CisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbmxpbmUgaW50IF9fdHBzNjU4Nnhfd3JpdGVzKHN0
cnVjdCBpMmNfY2xpZW50ICpjbGllbnQsIGludCByZWcsCisJCQkJICBpbnQgbGVuLCB1aW50OF90
ICp2YWwpCit7CisJaW50IHJldDsKKworCXJldCA9IGkyY19zbWJ1c193cml0ZV9pMmNfYmxvY2tf
ZGF0YShjbGllbnQsIHJlZywgbGVuLCB2YWwpOworCWlmIChyZXQgPCAwKSB7CisJCWRldl9lcnIo
JmNsaWVudC0+ZGV2LCAiZmFpbGVkIHdyaXRpbmdzIHRvIDB4JTAyeFxuIiwgcmVnKTsKKwkJcmV0
dXJuIHJldDsKKwl9CisKKwlyZXR1cm4gMDsKK30KKworaW50IHRwczY1ODZ4X3dyaXRlKHN0cnVj
dCBkZXZpY2UgKmRldiwgaW50IHJlZywgdWludDhfdCB2YWwpCit7CisJcmV0dXJuIF9fdHBzNjU4
Nnhfd3JpdGUodG9faTJjX2NsaWVudChkZXYpLCByZWcsIHZhbCk7Cit9CitFWFBPUlRfU1lNQk9M
X0dQTCh0cHM2NTg2eF93cml0ZSk7CisKK2ludCB0cHM2NTg2eF93cml0ZXMoc3RydWN0IGRldmlj
ZSAqZGV2LCBpbnQgcmVnLCBpbnQgbGVuLCB1aW50OF90ICp2YWwpCit7CisJcmV0dXJuIF9fdHBz
NjU4Nnhfd3JpdGVzKHRvX2kyY19jbGllbnQoZGV2KSwgcmVnLCBsZW4sIHZhbCk7Cit9CitFWFBP
UlRfU1lNQk9MX0dQTCh0cHM2NTg2eF93cml0ZXMpOworCitpbnQgdHBzNjU4NnhfcmVhZChzdHJ1
Y3QgZGV2aWNlICpkZXYsIGludCByZWcsIHVpbnQ4X3QgKnZhbCkKK3sKKwlyZXR1cm4gX190cHM2
NTg2eF9yZWFkKHRvX2kyY19jbGllbnQoZGV2KSwgcmVnLCB2YWwpOworfQorRVhQT1JUX1NZTUJP
TF9HUEwodHBzNjU4NnhfcmVhZCk7CisKK2ludCB0cHM2NTg2eF9yZWFkcyhzdHJ1Y3QgZGV2aWNl
ICpkZXYsIGludCByZWcsIGludCBsZW4sIHVpbnQ4X3QgKnZhbCkKK3sKKwlyZXR1cm4gX190cHM2
NTg2eF9yZWFkcyh0b19pMmNfY2xpZW50KGRldiksIHJlZywgbGVuLCB2YWwpOworfQorRVhQT1JU
X1NZTUJPTF9HUEwodHBzNjU4NnhfcmVhZHMpOworCitpbnQgdHBzNjU4Nnhfc2V0X2JpdHMoc3Ry
dWN0IGRldmljZSAqZGV2LCBpbnQgcmVnLCB1aW50OF90IGJpdF9tYXNrKQoreworCXN0cnVjdCB0
cHM2NTg2eCAqdHBzNjU4NnggPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsKKwl1aW50OF90IHJlZ192
YWw7CisJaW50IHJldCA9IDA7CisKKwltdXRleF9sb2NrKCZ0cHM2NTg2eC0+bG9jayk7CisKKwly
ZXQgPSBfX3RwczY1ODZ4X3JlYWQodG9faTJjX2NsaWVudChkZXYpLCByZWcsICZyZWdfdmFsKTsK
KwlpZiAocmV0KQorCQlnb3RvIG91dDsKKworCWlmICgocmVnX3ZhbCAmIGJpdF9tYXNrKSA9PSAw
KSB7CisJCXJlZ192YWwgfD0gYml0X21hc2s7CisJCXJldCA9IF9fdHBzNjU4Nnhfd3JpdGUodG9f
aTJjX2NsaWVudChkZXYpLCByZWcsIHJlZ192YWwpOworCX0KK291dDoKKwltdXRleF91bmxvY2so
JnRwczY1ODZ4LT5sb2NrKTsKKwlyZXR1cm4gcmV0OworfQorRVhQT1JUX1NZTUJPTF9HUEwodHBz
NjU4Nnhfc2V0X2JpdHMpOworCitpbnQgdHBzNjU4NnhfY2xyX2JpdHMoc3RydWN0IGRldmljZSAq
ZGV2LCBpbnQgcmVnLCB1aW50OF90IGJpdF9tYXNrKQoreworCXN0cnVjdCB0cHM2NTg2eCAqdHBz
NjU4NnggPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsKKwl1aW50OF90IHJlZ192YWw7CisJaW50IHJl
dCA9IDA7CisKKwltdXRleF9sb2NrKCZ0cHM2NTg2eC0+bG9jayk7CisKKwlyZXQgPSBfX3RwczY1
ODZ4X3JlYWQodG9faTJjX2NsaWVudChkZXYpLCByZWcsICZyZWdfdmFsKTsKKwlpZiAocmV0KQor
CQlnb3RvIG91dDsKKworCWlmIChyZWdfdmFsICYgYml0X21hc2spIHsKKwkJcmVnX3ZhbCAmPSB+
Yml0X21hc2s7CisJCXJldCA9IF9fdHBzNjU4Nnhfd3JpdGUodG9faTJjX2NsaWVudChkZXYpLCBy
ZWcsIHJlZ192YWwpOworCX0KK291dDoKKwltdXRleF91bmxvY2soJnRwczY1ODZ4LT5sb2NrKTsK
KwlyZXR1cm4gcmV0OworfQorRVhQT1JUX1NZTUJPTF9HUEwodHBzNjU4NnhfY2xyX2JpdHMpOwor
CitpbnQgdHBzNjU4NnhfdXBkYXRlKHN0cnVjdCBkZXZpY2UgKmRldiwgaW50IHJlZywgdWludDhf
dCB2YWwsIHVpbnQ4X3QgbWFzaykKK3sKKwlzdHJ1Y3QgdHBzNjU4NnggKnRwczY1ODZ4ID0gZGV2
X2dldF9kcnZkYXRhKGRldik7CisJdWludDhfdCByZWdfdmFsOworCWludCByZXQgPSAwOworCisJ
bXV0ZXhfbG9jaygmdHBzNjU4NngtPmxvY2spOworCisJcmV0ID0gX190cHM2NTg2eF9yZWFkKHRw
czY1ODZ4LT5jbGllbnQsIHJlZywgJnJlZ192YWwpOworCWlmIChyZXQpCisJCWdvdG8gb3V0Owor
CisJaWYgKChyZWdfdmFsICYgbWFzaykgIT0gdmFsKSB7CisJCXJlZ192YWwgPSAocmVnX3ZhbCAm
IH5tYXNrKSB8IHZhbDsKKwkJcmV0ID0gX190cHM2NTg2eF93cml0ZSh0cHM2NTg2eC0+Y2xpZW50
LCByZWcsIHJlZ192YWwpOworCX0KK291dDoKKwltdXRleF91bmxvY2soJnRwczY1ODZ4LT5sb2Nr
KTsKKwlyZXR1cm4gcmV0OworfQorRVhQT1JUX1NZTUJPTF9HUEwodHBzNjU4NnhfdXBkYXRlKTsK
Kworc3RhdGljIGludCB0cHM2NTg2eF9ncGlvX2dldChzdHJ1Y3QgZ3Bpb19jaGlwICpnYywgdW5z
aWduZWQgb2Zmc2V0KQoreworCXN0cnVjdCB0cHM2NTg2eCAqdHBzNjU4NnggPSBjb250YWluZXJf
b2YoZ2MsIHN0cnVjdCB0cHM2NTg2eCwgZ3Bpbyk7CisJdWludDhfdCB2YWw7CisJaW50IHJldDsK
KworCXJldCA9IF9fdHBzNjU4NnhfcmVhZCh0cHM2NTg2eC0+Y2xpZW50LCBUUFM2NTg2WF9HUElP
U0VUMiwgJnZhbCk7CisJaWYgKHJldCkKKwkJcmV0dXJuIHJldDsKKworCXJldHVybiAhISh2YWwg
JiAoMSA8PCBvZmZzZXQpKTsKK30KKworCitzdGF0aWMgdm9pZCB0cHM2NTg2eF9ncGlvX3NldChz
dHJ1Y3QgZ3Bpb19jaGlwICpjaGlwLCB1bnNpZ25lZCBvZmZzZXQsCisJCQkgICAgICBpbnQgdmFs
dWUpCit7CisJc3RydWN0IHRwczY1ODZ4ICp0cHM2NTg2eCA9IGNvbnRhaW5lcl9vZihjaGlwLCBz
dHJ1Y3QgdHBzNjU4NngsIGdwaW8pOworCisJX190cHM2NTg2eF93cml0ZSh0cHM2NTg2eC0+Y2xp
ZW50LCBUUFM2NTg2WF9HUElPU0VUMiwKKwkJCSB2YWx1ZSA8PCBvZmZzZXQpOworfQorCitzdGF0
aWMgaW50IHRwczY1ODZ4X2dwaW9fb3V0cHV0KHN0cnVjdCBncGlvX2NoaXAgKmdjLCB1bnNpZ25l
ZCBvZmZzZXQsCisJCQkJaW50IHZhbHVlKQoreworCXN0cnVjdCB0cHM2NTg2eCAqdHBzNjU4Nngg
PSBjb250YWluZXJfb2YoZ2MsIHN0cnVjdCB0cHM2NTg2eCwgZ3Bpbyk7CisJdWludDhfdCB2YWws
IG1hc2s7CisKKwl0cHM2NTg2eF9ncGlvX3NldChnYywgb2Zmc2V0LCB2YWx1ZSk7CisKKwl2YWwg
PSAweDEgPDwgKG9mZnNldCAqIDIpOworCW1hc2sgPSAweDMgPDwgKG9mZnNldCAqIDIpOworCisJ
cmV0dXJuIHRwczY1ODZ4X3VwZGF0ZSh0cHM2NTg2eC0+ZGV2LCBUUFM2NTg2WF9HUElPU0VUMSwg
dmFsLCBtYXNrKTsKK30KKworc3RhdGljIHZvaWQgdHBzNjU4NnhfZ3Bpb19pbml0KHN0cnVjdCB0
cHM2NTg2eCAqdHBzNjU4NngsIGludCBncGlvX2Jhc2UpCit7CisJaW50IHJldDsKKworCWlmICgh
Z3Bpb19iYXNlKQorCQlyZXR1cm47CisKKwl0cHM2NTg2eC0+Z3Bpby5vd25lcgkJPSBUSElTX01P
RFVMRTsKKwl0cHM2NTg2eC0+Z3Bpby5sYWJlbAkJPSB0cHM2NTg2eC0+Y2xpZW50LT5uYW1lOwor
CXRwczY1ODZ4LT5ncGlvLmRldgkJPSB0cHM2NTg2eC0+ZGV2OworCXRwczY1ODZ4LT5ncGlvLmJh
c2UJCT0gZ3Bpb19iYXNlOworCXRwczY1ODZ4LT5ncGlvLm5ncGlvCQk9IDQ7CisJdHBzNjU4Nngt
PmdwaW8uY2FuX3NsZWVwCT0gMTsKKworCS8qIEZJWE1FOiBhZGQgaGFuZGxpbmcgb2YgR1BJT3Mg
YXMgZGVkaWNhdGVkIGlucHV0cyAqLworCXRwczY1ODZ4LT5ncGlvLmRpcmVjdGlvbl9vdXRwdXQJ
PSB0cHM2NTg2eF9ncGlvX291dHB1dDsKKwl0cHM2NTg2eC0+Z3Bpby5zZXQJCT0gdHBzNjU4Nnhf
Z3Bpb19zZXQ7CisJdHBzNjU4NngtPmdwaW8uZ2V0CQk9IHRwczY1ODZ4X2dwaW9fZ2V0OworCisJ
cmV0ID0gZ3Bpb2NoaXBfYWRkKCZ0cHM2NTg2eC0+Z3Bpbyk7CisJaWYgKHJldCkKKwkJZGV2X3dh
cm4odHBzNjU4NngtPmRldiwgIkdQSU8gcmVnaXN0cmF0aW9uIGZhaWxlZDogJWRcbiIsIHJldCk7
Cit9CisKK3N0YXRpYyBpbnQgX19yZW1vdmVfc3ViZGV2KHN0cnVjdCBkZXZpY2UgKmRldiwgdm9p
ZCAqdW51c2VkKQoreworCXBsYXRmb3JtX2RldmljZV91bnJlZ2lzdGVyKHRvX3BsYXRmb3JtX2Rl
dmljZShkZXYpKTsKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCB0cHM2NTg2eF9yZW1vdmVf
c3ViZGV2cyhzdHJ1Y3QgdHBzNjU4NnggKnRwczY1ODZ4KQoreworCXJldHVybiBkZXZpY2VfZm9y
X2VhY2hfY2hpbGQodHBzNjU4NngtPmRldiwgTlVMTCwgX19yZW1vdmVfc3ViZGV2KTsKK30KKwor
c3RhdGljIGludCBfX2RldmluaXQgdHBzNjU4NnhfYWRkX3N1YmRldnMoc3RydWN0IHRwczY1ODZ4
ICp0cHM2NTg2eCwKKwkJCQkJICBzdHJ1Y3QgdHBzNjU4NnhfcGxhdGZvcm1fZGF0YSAqcGRhdGEp
Cit7CisJc3RydWN0IHRwczY1ODZ4X3N1YmRldl9pbmZvICpzdWJkZXY7CisJc3RydWN0IHBsYXRm
b3JtX2RldmljZSAqcGRldjsKKwlpbnQgaSwgcmV0ID0gMDsKKworCWZvciAoaSA9IDA7IGkgPCBw
ZGF0YS0+bnVtX3N1YmRldnM7IGkrKykgeworCQlzdWJkZXYgPSAmcGRhdGEtPnN1YmRldnNbaV07
CisKKwkJcGRldiA9IHBsYXRmb3JtX2RldmljZV9hbGxvYyhzdWJkZXYtPm5hbWUsIHN1YmRldi0+
aWQpOworCisJCXBkZXYtPmRldi5wYXJlbnQgPSB0cHM2NTg2eC0+ZGV2OworCQlwZGV2LT5kZXYu
cGxhdGZvcm1fZGF0YSA9IHN1YmRldi0+cGxhdGZvcm1fZGF0YTsKKworCQlyZXQgPSBwbGF0Zm9y
bV9kZXZpY2VfYWRkKHBkZXYpOworCQlpZiAocmV0KQorCQkJZ290byBmYWlsZWQ7CisJfQorCXJl
dHVybiAwOworCitmYWlsZWQ6CisJdHBzNjU4NnhfcmVtb3ZlX3N1YmRldnModHBzNjU4NngpOwor
CXJldHVybiByZXQ7Cit9CisKK3N0YXRpYyBpbnQgX19kZXZpbml0IHRwczY1ODZ4X2kyY19wcm9i
ZShzdHJ1Y3QgaTJjX2NsaWVudCAqY2xpZW50LAorCQkJCQljb25zdCBzdHJ1Y3QgaTJjX2Rldmlj
ZV9pZCAqaWQpCit7CisJc3RydWN0IHRwczY1ODZ4X3BsYXRmb3JtX2RhdGEgKnBkYXRhID0gY2xp
ZW50LT5kZXYucGxhdGZvcm1fZGF0YTsKKwlzdHJ1Y3QgdHBzNjU4NnggKnRwczY1ODZ4OworCWlu
dCByZXQ7CisKKwlpZiAoIXBkYXRhKSB7CisJCWRldl9lcnIoJmNsaWVudC0+ZGV2LCAidHBzNjU4
NnggcmVxdWlyZXMgcGxhdGZvcm0gZGF0YVxuIik7CisJCXJldHVybiAtRU5PVFNVUFA7CisJfQor
CisJcmV0ID0gaTJjX3NtYnVzX3JlYWRfYnl0ZV9kYXRhKGNsaWVudCwgVFBTNjU4NlhfVkVSU0lP
TkNSQyk7CisJaWYgKHJldCA8IDApIHsKKwkJZGV2X2VycigmY2xpZW50LT5kZXYsICJDaGlwIElE
IHJlYWQgZmFpbGVkOiAlZFxuIiwgcmV0KTsKKwkJcmV0dXJuIC1FSU87CisJfQorCisJaWYgKHJl
dCAhPSBUUFM2NTg2MjFBX1ZFUlNJT05DUkMpIHsKKwkJZGV2X2VycigmY2xpZW50LT5kZXYsICJV
bnN1cHBvcnRlZCBjaGlwIElEOiAleFxuIiwgcmV0KTsKKwkJcmV0dXJuIC1FTk9ERVY7CisJfQor
CisJdHBzNjU4NnggPSBremFsbG9jKHNpemVvZihzdHJ1Y3QgdHBzNjU4NngpLCBHRlBfS0VSTkVM
KTsKKwlpZiAodHBzNjU4NnggPT0gTlVMTCkKKwkJcmV0dXJuIC1FTk9NRU07CisKKwl0cHM2NTg2
eC0+Y2xpZW50ID0gY2xpZW50OworCXRwczY1ODZ4LT5kZXYgPSAmY2xpZW50LT5kZXY7CisJaTJj
X3NldF9jbGllbnRkYXRhKGNsaWVudCwgdHBzNjU4NngpOworCisJbXV0ZXhfaW5pdCgmdHBzNjU4
NngtPmxvY2spOworCisJcmV0ID0gdHBzNjU4NnhfYWRkX3N1YmRldnModHBzNjU4NngsIHBkYXRh
KTsKKwlpZiAocmV0KSB7CisJCWRldl9lcnIoJmNsaWVudC0+ZGV2LCAiYWRkIGRldmljZXMgZmFp
bGVkOiAlZFxuIiwgcmV0KTsKKwkJZ290byBlcnJfYWRkX2RldnM7CisJfQorCisJdHBzNjU4Nnhf
Z3Bpb19pbml0KHRwczY1ODZ4LCBwZGF0YS0+Z3Bpb19iYXNlKTsKKworCXJldHVybiAwOworCitl
cnJfYWRkX2RldnM6CisJa2ZyZWUodHBzNjU4NngpOworCXJldHVybiByZXQ7Cit9CisKK3N0YXRp
YyBpbnQgX19kZXZleGl0IHRwczY1ODZ4X2kyY19yZW1vdmUoc3RydWN0IGkyY19jbGllbnQgKmNs
aWVudCkKK3sKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGNvbnN0IHN0cnVjdCBpMmNfZGV2aWNl
X2lkIHRwczY1ODZ4X2lkX3RhYmxlW10gPSB7CisJeyAidHBzNjU4NngiLCAwIH0sCisJeyB9LAor
fTsKK01PRFVMRV9ERVZJQ0VfVEFCTEUoaTJjLCB0cHM2NTg2eF9pZF90YWJsZSk7CisKK3N0YXRp
YyBzdHJ1Y3QgaTJjX2RyaXZlciB0cHM2NTg2eF9kcml2ZXIgPSB7CisJLmRyaXZlcgk9IHsKKwkJ
Lm5hbWUJPSAidHBzNjU4NngiLAorCQkub3duZXIJPSBUSElTX01PRFVMRSwKKwl9LAorCS5wcm9i
ZQkJPSB0cHM2NTg2eF9pMmNfcHJvYmUsCisJLnJlbW92ZQkJPSBfX2RldmV4aXRfcCh0cHM2NTg2
eF9pMmNfcmVtb3ZlKSwKKwkuaWRfdGFibGUJPSB0cHM2NTg2eF9pZF90YWJsZSwKK307CisKK3N0
YXRpYyBpbnQgX19pbml0IHRwczY1ODZ4X2luaXQodm9pZCkKK3sKKwlyZXR1cm4gaTJjX2FkZF9k
cml2ZXIoJnRwczY1ODZ4X2RyaXZlcik7Cit9CitzdWJzeXNfaW5pdGNhbGwodHBzNjU4NnhfaW5p
dCk7CisKK3N0YXRpYyB2b2lkIF9fZXhpdCB0cHM2NTg2eF9leGl0KHZvaWQpCit7CisJaTJjX2Rl
bF9kcml2ZXIoJnRwczY1ODZ4X2RyaXZlcik7Cit9Cittb2R1bGVfZXhpdCh0cHM2NTg2eF9leGl0
KTsKKworTU9EVUxFX0RFU0NSSVBUSU9OKCJUUFM2NTg2WCBjb3JlIGRyaXZlciIpOworTU9EVUxF
X0FVVEhPUigiTWlrZSBSYXBvcG9ydCA8bWlrZUBjb21wdWxhYi5jby5pbD4iKTsKK01PRFVMRV9M
SUNFTlNFKCJHUEwiKTsKKwpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tZmQvdHBzNjU4Nngu
aCBiL2luY2x1ZGUvbGludXgvbWZkL3RwczY1ODZ4LmgKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5k
ZXggMDAwMDAwMC4uNzcyYjNhZQotLS0gL2Rldi9udWxsCisrKyBiL2luY2x1ZGUvbGludXgvbWZk
L3RwczY1ODZ4LmgKQEAgLTAsMCArMSw0NyBAQAorI2lmbmRlZiBfX0xJTlVYX01GRF9UUFM2NTg2
WF9ICisjZGVmaW5lIF9fTElOVVhfTUZEX1RQUzY1ODZYX0gKKworZW51bSB7CisJVFBTNjU4Nlhf
SURfU01fMCwKKwlUUFM2NTg2WF9JRF9TTV8xLAorCVRQUzY1ODZYX0lEX1NNXzIsCisJVFBTNjU4
NlhfSURfTERPXzAsCisJVFBTNjU4NlhfSURfTERPXzEsCisJVFBTNjU4NlhfSURfTERPXzIsCisJ
VFBTNjU4NlhfSURfTERPXzMsCisJVFBTNjU4NlhfSURfTERPXzQsCisJVFBTNjU4NlhfSURfTERP
XzUsCisJVFBTNjU4NlhfSURfTERPXzYsCisJVFBTNjU4NlhfSURfTERPXzcsCisJVFBTNjU4Nlhf
SURfTERPXzgsCisJVFBTNjU4NlhfSURfTERPXzksCisJVFBTNjU4NlhfSURfTERPX1JUQywKK307
CisKK3N0cnVjdCB0cHM2NTg2eF9zdWJkZXZfaW5mbyB7CisJaW50CQlpZDsKKwljb25zdCBjaGFy
CSpuYW1lOworCXZvaWQJCSpwbGF0Zm9ybV9kYXRhOworfTsKKworc3RydWN0IHRwczY1ODZ4X3Bs
YXRmb3JtX2RhdGEgeworCWludCBudW1fc3ViZGV2czsKKwlzdHJ1Y3QgdHBzNjU4Nnhfc3ViZGV2
X2luZm8gKnN1YmRldnM7CisKKwlpbnQgZ3Bpb19iYXNlOworfTsKKworLyoKKyAqIE5PVEU6IHRo
ZSBmdW5jdGlvbnMgYmVsb3cgYXJlIG5vdCBpbnRlbmRlZCBmb3IgdXNlIG91dHNpZGUKKyAqIG9m
IHRoZSBUUFM2NTg2WCBzdWItZGV2aWNlIGRyaXZlcnMKKyAqLworZXh0ZXJuIGludCB0cHM2NTg2
eF93cml0ZShzdHJ1Y3QgZGV2aWNlICpkZXYsIGludCByZWcsIHVpbnQ4X3QgdmFsKTsKK2V4dGVy
biBpbnQgdHBzNjU4Nnhfd3JpdGVzKHN0cnVjdCBkZXZpY2UgKmRldiwgaW50IHJlZywgaW50IGxl
biwgdWludDhfdCAqdmFsKTsKK2V4dGVybiBpbnQgdHBzNjU4NnhfcmVhZChzdHJ1Y3QgZGV2aWNl
ICpkZXYsIGludCByZWcsIHVpbnQ4X3QgKnZhbCk7CitleHRlcm4gaW50IHRwczY1ODZ4X3JlYWRz
KHN0cnVjdCBkZXZpY2UgKmRldiwgaW50IHJlZywgaW50IGxlbiwgdWludDhfdCAqdmFsKTsKK2V4
dGVybiBpbnQgdHBzNjU4Nnhfc2V0X2JpdHMoc3RydWN0IGRldmljZSAqZGV2LCBpbnQgcmVnLCB1
aW50OF90IGJpdF9tYXNrKTsKK2V4dGVybiBpbnQgdHBzNjU4NnhfY2xyX2JpdHMoc3RydWN0IGRl
dmljZSAqZGV2LCBpbnQgcmVnLCB1aW50OF90IGJpdF9tYXNrKTsKK2V4dGVybiBpbnQgdHBzNjU4
NnhfdXBkYXRlKHN0cnVjdCBkZXZpY2UgKmRldiwgaW50IHJlZywgdWludDhfdCB2YWwsCisJCQkg
ICB1aW50OF90IG1hc2spOworCisjZW5kaWYgLypfX0xJTlVYX01GRF9UUFM2NTg2WF9IICovCi0t
IAoxLjYuMy4zCgo=
--00163646ba66c380fd048cffd75f--
