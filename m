Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1EPXDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:03:12 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:35000 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672Ab1EPXDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:03:09 -0400
MIME-Version: 1.0
Date: Mon, 16 May 2011 18:03:07 -0500
Message-ID: <BANLkTi=_sFAghAUzitov3-X4Oob6iWmnMA@mail.gmail.com>
Subject: [PATCHv4 1/4] mfd: tps65912: Add new mfd device
From: Margarita Olaya <magi@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tps65912 chip is a power management IC. It contains the following
components:

- Regulators
- GPIO controller

The tps65912 core driver is registered as a platform driver, it provides
communication through I2C and SPI interfaces.

Signed-off-by: Margarita Olaya Cabrera <magi@slimlogic.co.uk>
---
 drivers/mfd/Kconfig          |   22 +++
 drivers/mfd/Makefile         |    4 +
 drivers/mfd/tps65912-core.c  |  164 +++++++++++++++++++++
 drivers/mfd/tps65912-i2c.c   |  139 ++++++++++++++++++
 drivers/mfd/tps65912-spi.c   |  142 +++++++++++++++++++
 include/linux/mfd/tps65912.h |  321 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 792 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/tps65912-core.c
 create mode 100644 drivers/mfd/tps65912-i2c.c
 create mode 100644 drivers/mfd/tps65912-spi.c
 create mode 100644 include/linux/mfd/tps65912.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3ed3ff0..55e55ff 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -157,6 +157,28 @@ config TPS6507X
 	  This driver can also be built as a module.  If so, the module
 	  will be called tps6507x.

+config MFD_TPS65912
+	bool "TPS65912 PMIC"
+	depends on GPIOLIB
+
+config MFD_TPS65912_I2C
+	bool "TPS95612 Power Management chip with I2C"
+	select MFD_CORE
+	select MFD_TPS65912
+	depends on I2C=y && GPIOLIB
+	help
+	  If you say yes here you get support for the TPS65912 series of
+	  PM chips with I2C interface.
+
+config MFD_TPS65912_SPI
+	bool "TPS65912 Power Management chip with SPI"
+	select MFD_CORE
+	select MFD_TPS65912
+	depends on SPI_MASTER && GPIOLIB
+	help
+	  If you say yes here you get support for the TPS65912 series of
+	  PM chips with SPI interface.
+
 config MENELAUS
 	bool "Texas Instruments TWL92330/Menelaus PM chip"
 	depends on I2C=y && ARCH_OMAP2
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 419caa9..5714b7b 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -35,6 +35,10 @@ obj-$(CONFIG_MFD_WM8994)	+= wm8994-core.o wm8994-irq.o
 obj-$(CONFIG_TPS6105X)		+= tps6105x.o
 obj-$(CONFIG_TPS65010)		+= tps65010.o
 obj-$(CONFIG_TPS6507X)		+= tps6507x.o
+tps65912-objs                   := tps65912-core.o
+obj-$(CONFIG_MFD_TPS65912)	+= tps65912.o
+obj-$(CONFIG_MFD_TPS65912_I2C)	+= tps65912-i2c.o
+obj-$(CONFIG_MFD_TPS65912_SPI)  += tps65912-spi.o
 obj-$(CONFIG_MENELAUS)		+= menelaus.o

 obj-$(CONFIG_TWL4030_CORE)	+= twl-core.o twl4030-irq.o twl6030-irq.o
diff --git a/drivers/mfd/tps65912-core.c b/drivers/mfd/tps65912-core.c
new file mode 100644
index 0000000..10baf76
--- /dev/null
+++ b/drivers/mfd/tps65912-core.c
@@ -0,0 +1,164 @@
+/*
+ * tps65912-core.c  --  TI TPS65912x
+ *
+ * Copyright 2011 Texas Instruments Inc.
+ *
+ * Author: Margarita Olaya Cabrera <magi@slimlogic.co.uk>
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under  the terms of the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ *  This driver is based on wm8350 implementation.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/tps65912.h>
+
+static struct mfd_cell tps65912s[] = {
+	{
+		.name = "tps65912-pmic",
+	},
+};
+
+int tps65912_set_bits(struct tps65912 *tps65912, u8 reg, u8 mask)
+{
+	u8 data;
+	int err;
+
+	mutex_lock(&tps65912->io_mutex);
+
+	err = tps65912->read(tps65912, reg, 1, &data);
+	if (err) {
+		dev_err(tps65912->dev, "Read from reg 0x%x failed\n", reg);
+		goto out;
+	}
+
+	data |= mask;
+	err = tps65912->write(tps65912, reg, 1, &data);
+	if (err)
+		dev_err(tps65912->dev, "Write to reg 0x%x failed\n", reg);
+
+out:
+	mutex_unlock(&tps65912->io_mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(tps65912_set_bits);
+
+int tps65912_clear_bits(struct tps65912 *tps65912, u8 reg, u8 mask)
+{
+	u8 data;
+	int err;
+
+	mutex_lock(&tps65912->io_mutex);
+	err = tps65912->read(tps65912, reg, 1, &data);
+	if (err) {
+		dev_err(tps65912->dev, "Read from reg 0x%x failed\n", reg);
+		goto out;
+	}
+
+	data &= ~mask;
+	err = tps65912->write(tps65912, reg, 1, &data);
+	if (err)
+		dev_err(tps65912->dev, "Write to reg 0x%x failed\n", reg);
+
+out:
+	mutex_unlock(&tps65912->io_mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(tps65912_clear_bits);
+
+static inline int tps65912_read(struct tps65912 *tps65912, u8 reg)
+{
+	u8 val;
+	int err;
+
+	err = tps65912->read(tps65912, reg, 1, &val);
+	if (err < 0)
+		return err;
+
+	return val;
+}
+
+static inline int tps65912_write(struct tps65912 *tps65912, u8 reg, u8 val)
+{
+	return tps65912->write(tps65912, reg, 1, &val);
+}
+
+int tps65912_reg_read(struct tps65912 *tps65912, u8 reg)
+{
+	int data;
+
+	mutex_lock(&tps65912->io_mutex);
+
+	data = tps65912_read(tps65912, reg);
+	if (data < 0)
+		dev_err(tps65912->dev, "Read from reg 0x%x failed\n", reg);
+
+	mutex_unlock(&tps65912->io_mutex);
+	return data;
+}
+EXPORT_SYMBOL_GPL(tps65912_reg_read);
+
+int tps65912_reg_write(struct tps65912 *tps65912, u8 reg, u8 val)
+{
+	int err;
+
+	mutex_lock(&tps65912->io_mutex);
+
+	err = tps65912_write(tps65912, reg, val);
+	if (err < 0)
+		dev_err(tps65912->dev, "Write for reg 0x%x failed\n", reg);
+
+	mutex_unlock(&tps65912->io_mutex);
+	return err;
+}
+EXPORT_SYMBOL_GPL(tps65912_reg_write);
+
+int tps65912_device_init(struct tps65912 *tps65912)
+{
+	struct tps65912_board *pmic_plat_data = tps65912->dev->platform_data;
+	int ret, dcdc_avs, value;
+
+	mutex_init(&tps65912->io_mutex);
+	dev_set_drvdata(tps65912->dev, tps65912);
+
+	dcdc_avs = (pmic_plat_data->is_dcdc1_avs << 0 |
+			pmic_plat_data->is_dcdc2_avs  << 1 |
+				pmic_plat_data->is_dcdc3_avs << 2 |
+					pmic_plat_data->is_dcdc4_avs << 3);
+	if (dcdc_avs) {
+		tps65912->read(tps65912, TPS65912_I2C_SPI_CFG, 1, &value);
+		dcdc_avs |= value;
+		tps65912->write(tps65912, TPS65912_I2C_SPI_CFG, 1, &dcdc_avs);
+	}
+
+	ret = mfd_add_devices(tps65912->dev, -1,
+			      tps65912s, ARRAY_SIZE(tps65912s),
+			      NULL, 0);
+	if (ret < 0)
+		goto err;
+
+	return ret;
+
+err:
+	mfd_remove_devices(tps65912->dev);
+	kfree(tps65912);
+	return ret;
+}
+
+void tps65912_device_exit(struct tps65912 *tps65912)
+{
+	mfd_remove_devices(tps65912->dev);
+	kfree(tps65912);
+}
+
+MODULE_AUTHOR("Margarita Olaya	<magi@slimlogic.co.uk>");
+MODULE_DESCRIPTION("TPS65912x chip family multi-function driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/tps65912-i2c.c b/drivers/mfd/tps65912-i2c.c
new file mode 100644
index 0000000..9ed123a
--- /dev/null
+++ b/drivers/mfd/tps65912-i2c.c
@@ -0,0 +1,139 @@
+/*
+ * tps65912-i2c.c  --  I2C access for TI TPS65912x PMIC
+ *
+ * Copyright 2011 Texas Instruments Inc.
+ *
+ * Author: Margarita Olaya Cabrera <magi@slimlogic.co.uk>
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under  the terms of the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ *  This driver is based on wm8350 implementation.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/tps65912.h>
+
+static int tps65912_i2c_read(struct tps65912 *tps65912, u8 reg,
+				  int bytes, void *dest)
+{
+	struct i2c_client *i2c = tps65912->control_data;
+	struct i2c_msg xfer[2];
+	int ret;
+
+	/* Write register */
+	xfer[0].addr = i2c->addr;
+	xfer[0].flags = 0;
+	xfer[0].len = 1;
+	xfer[0].buf = &reg;
+
+	/* Read data */
+	xfer[1].addr = i2c->addr;
+	xfer[1].flags = I2C_M_RD;
+	xfer[1].len = bytes;
+	xfer[1].buf = dest;
+
+	ret = i2c_transfer(i2c->adapter, xfer, 2);
+	if (ret == 2)
+		ret = 0;
+	else if (ret >= 0)
+		ret = -EIO;
+	return ret;
+}
+
+static int tps65912_i2c_write(struct tps65912 *tps65912, u8 reg,
+				   int bytes, void *src)
+{
+	struct i2c_client *i2c = tps65912->control_data;
+	/* we add 1 byte for device register */
+	u8 msg[TPS6591X_MAX_REGISTER + 1];
+	int ret;
+
+	if (bytes > (TPS6591X_MAX_REGISTER + 1))
+		return -EINVAL;
+
+	msg[0] = reg;
+	memcpy(&msg[1], src, bytes);
+
+	ret = i2c_master_send(i2c, msg, bytes + 1);
+	if (ret < 0)
+		return ret;
+	if (ret != bytes + 1)
+		return -EIO;
+
+	return 0;
+}
+
+static int tps65912_i2c_probe(struct i2c_client *i2c,
+			    const struct i2c_device_id *id)
+{
+	struct tps65912 *tps65912;
+
+	tps65912 = kzalloc(sizeof(struct tps65912), GFP_KERNEL);
+	if (tps65912 == NULL)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, tps65912);
+	tps65912->dev = &i2c->dev;
+	tps65912->control_data = i2c;
+	tps65912->read = tps65912_i2c_read;
+	tps65912->write = tps65912_i2c_write;
+
+	return tps65912_device_init(tps65912);
+}
+
+static int tps65912_i2c_remove(struct i2c_client *i2c)
+{
+	struct tps65912 *tps65912 = i2c_get_clientdata(i2c);
+
+	tps65912_device_exit(tps65912);
+
+	return 0;
+}
+
+static const struct i2c_device_id tps65912_i2c_id[] = {
+	{"tps65912", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, tps65912_i2c_id);
+
+static struct i2c_driver tps65912_i2c_driver = {
+	.driver = {
+		   .name = "tps65912",
+		   .owner = THIS_MODULE,
+	},
+	.probe = tps65912_i2c_probe,
+	.remove = tps65912_i2c_remove,
+	.id_table = tps65912_i2c_id,
+};
+
+static int __init tps65912_i2c_init(void)
+{
+	int ret;
+
+	ret = i2c_add_driver(&tps65912_i2c_driver);
+	if (ret != 0)
+		pr_err("Failed to register TPS65912 I2C driver: %d\n", ret);
+
+	return ret;
+}
+/* init early so consumer devices can complete system boot */
+subsys_initcall(tps65912_i2c_init);
+
+static void __exit tps65912_i2c_exit(void)
+{
+	i2c_del_driver(&tps65912_i2c_driver);
+}
+module_exit(tps65912_i2c_exit);
+
+MODULE_AUTHOR("Margarita Olaya	<magi@slimlogic.co.uk>");
+MODULE_DESCRIPTION("TPS6591x chip family multi-function driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/tps65912-spi.c b/drivers/mfd/tps65912-spi.c
new file mode 100644
index 0000000..6d71e0d
--- /dev/null
+++ b/drivers/mfd/tps65912-spi.c
@@ -0,0 +1,142 @@
+/*
+ * tps65912-spi.c  --  SPI access for TI TPS65912x PMIC
+ *
+ * Copyright 2011 Texas Instruments Inc.
+ *
+ * Author: Margarita Olaya Cabrera <magi@slimlogic.co.uk>
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under  the terms of the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ *  This driver is based on wm8350 implementation.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/spi/spi.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/tps65912.h>
+
+static int tps65912_spi_write(struct tps65912 *tps65912, u8 addr,
+							int bytes, void *src)
+{
+	struct spi_device *spi = tps65912->control_data;
+	u8 *data = (u8 *) src;
+	int ret;
+	/* bit 23 is the read/write bit */
+	unsigned long spi_data = 1 << 23 | addr << 15 | *data;
+	struct spi_transfer xfer;
+	struct spi_message msg;
+	u32 tx_buf, rx_buf;
+
+	tx_buf = spi_data;
+	rx_buf = 0;
+
+	xfer.tx_buf	= &tx_buf;
+	xfer.rx_buf	= NULL;
+	xfer.len	= sizeof(unsigned long);
+	xfer.bits_per_word = 24;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+
+	ret = spi_sync(spi, &msg);
+	return ret;
+}
+
+static int tps65912_spi_read(struct tps65912 *tps65912, u8 addr,
+							int bytes, void *dest)
+{
+	struct spi_device *spi = tps65912->control_data;
+	/* bit 23 is the read/write bit */
+	unsigned long spi_data = 0 << 23 | addr << 15;
+	struct spi_transfer xfer;
+	struct spi_message msg;
+	int ret;
+	u8 *data = (u8 *) dest;
+	u32 tx_buf, rx_buf;
+
+	tx_buf = spi_data;
+	rx_buf = 0;
+
+	xfer.tx_buf	= &tx_buf;
+	xfer.rx_buf	= &rx_buf;
+	xfer.len	= sizeof(unsigned long);
+	xfer.bits_per_word = 24;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+
+	if (spi == NULL)
+		return 0;
+
+	ret = spi_sync(spi, &msg);
+	if (ret == 0)
+		*data = (u8) (rx_buf & 0xFF);
+	return ret;
+}
+
+static int __devinit tps65912_spi_probe(struct spi_device *spi)
+{
+	struct tps65912 *tps65912;
+
+	tps65912 = kzalloc(sizeof(struct tps65912), GFP_KERNEL);
+	if (tps65912 == NULL)
+		return -ENOMEM;
+
+	tps65912->dev = &spi->dev;
+	tps65912->control_data = spi;
+	tps65912->read = tps65912_spi_read;
+	tps65912->write = tps65912_spi_write;
+
+	spi_set_drvdata(spi, tps65912);
+
+	return tps65912_device_init(tps65912);
+}
+
+static int __devexit tps65912_spi_remove(struct spi_device *spi)
+{
+	struct tps65912 *tps65912 = spi_get_drvdata(spi);
+
+	tps65912_device_exit(tps65912);
+
+	return 0;
+}
+
+static struct spi_driver tps65912_spi_driver = {
+	.driver = {
+		.name = "tps65912",
+		.bus = &spi_bus_type,
+		.owner = THIS_MODULE,
+	},
+	.probe	= tps65912_spi_probe,
+	.remove = __devexit_p(tps65912_spi_remove),
+};
+
+static int __init tps65912_spi_init(void)
+{
+	int ret;
+
+	ret = spi_register_driver(&tps65912_spi_driver);
+	if (ret != 0)
+		pr_err("Failed to register TPS65912 SPI driver: %d\n", ret);
+
+	return 0;
+}
+/* init early so consumer devices can complete system boot */
+subsys_initcall(tps65912_spi_init);
+
+static void __exit tps65912_spi_exit(void)
+{
+	spi_unregister_driver(&tps65912_spi_driver);
+}
+module_exit(tps65912_spi_exit);
+
+MODULE_AUTHOR("Margarita Olaya	<magi@slimlogic.co.uk>");
+MODULE_DESCRIPTION("SPI support for TPS65912 chip family mfd");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/tps65912.h b/include/linux/mfd/tps65912.h
new file mode 100644
index 0000000..48d3b53
--- /dev/null
+++ b/include/linux/mfd/tps65912.h
@@ -0,0 +1,321 @@
+/*
+ * tps65912.h  --  TI TPS6591x
+ *
+ * Copyright 2011 Texas Instruments Inc.
+ *
+ * Author: Margarita Olaya <magi@slimlogic.co.uk>
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under  the terms of the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __LINUX_MFD_TPS65912_H
+#define __LINUX_MFD_TPS65912_H
+
+/* TPS regulator type list */
+#define REGULATOR_LDO		0
+#define REGULATOR_DCDC		1
+
+/*
+ * List of registers for TPS65912
+ */
+
+#define TPS65912_DCDC1_CTRL		0x00
+#define TPS65912_DCDC2_CTRL		0x01
+#define TPS65912_DCDC3_CTRL		0x02
+#define TPS65912_DCDC4_CTRL		0x03
+#define TPS65912_DCDC1_OP		0x04
+#define TPS65912_DCDC1_AVS		0x05
+#define TPS65912_DCDC1_LIMIT		0x06
+#define TPS65912_DCDC2_OP		0x07
+#define TPS65912_DCDC2_AVS		0x08
+#define TPS65912_DCDC2_LIMIT		0x09
+#define TPS65912_DCDC3_OP		0x0A
+#define TPS65912_DCDC3_AVS		0x0B
+#define TPS65912_DCDC3_LIMIT		0x0C
+#define TPS65912_DCDC4_OP		0x0D
+#define TPS65912_DCDC4_AVS		0x0E
+#define TPS65912_DCDC4_LIMIT		0x0F
+#define TPS65912_LDO1_OP		0x10
+#define TPS65912_LDO1_AVS		0x11
+#define TPS65912_LDO1_LIMIT		0x12
+#define TPS65912_LDO2_OP		0x13
+#define TPS65912_LDO2_AVS		0x14
+#define TPS65912_LDO2_LIMIT		0x15
+#define TPS65912_LDO3_OP		0x16
+#define TPS65912_LDO3_AVS		0x17
+#define TPS65912_LDO3_LIMIT		0x18
+#define TPS65912_LDO4_OP		0x19
+#define TPS65912_LDO4_AVS		0x1A
+#define TPS65912_LDO4_LIMIT		0x1B
+#define TPS65912_LDO5			0x1C
+#define TPS65912_LDO6			0x1D
+#define TPS65912_LDO7			0x1E
+#define TPS65912_LDO8			0x1F
+#define TPS65912_LDO9			0x20
+#define TPS65912_LDO10			0x21
+#define TPS65912_THRM			0x22
+#define TPS65912_CLK32OUT		0x23
+#define TPS65912_DEVCTRL		0x24
+#define TPS65912_DEVCTRL2		0x25
+#define TPS65912_I2C_SPI_CFG		0x26
+#define TPS65912_KEEP_ON		0x27
+#define TPS65912_KEEP_ON2		0x28
+#define TPS65912_SET_OFF1		0x29
+#define TPS65912_SET_OFF2		0x2A
+#define TPS65912_DEF_VOLT		0x2B
+#define TPS65912_DEF_VOLT_MAPPING	0x2C
+#define TPS65912_DISCHARGE		0x2D
+#define TPS65912_DISCHARGE2		0x2E
+#define TPS65912_EN1_SET1		0x2F
+#define TPS65912_EN1_SET2		0x30
+#define TPS65912_EN2_SET1		0x31
+#define TPS65912_EN2_SET2		0x32
+#define TPS65912_EN3_SET1		0x33
+#define TPS65912_EN3_SET2		0x34
+#define TPS65912_EN4_SET1		0x35
+#define TPS65912_EN4_SET2		0x36
+#define TPS65912_PGOOD			0x37
+#define TPS65912_PGOOD2			0x38
+#define TPS65912_INT_STS		0x39
+#define TPS65912_INT_MSK		0x3A
+#define TPS65912_INT_STS2		0x3B
+#define TPS65912_INT_MSK2		0x3C
+#define TPS65912_INT_STS3		0x3D
+#define TPS65912_INT_MSK3		0x3E
+#define TPS65912_INT_STS4		0x3F
+#define TPS65912_INT_MSK4		0x40
+#define TPS65912_GPIO1			0x41
+#define TPS65912_GPIO2			0x42
+#define TPS65912_GPIO3			0x43
+#define TPS65912_GPIO4			0x44
+#define TPS65912_GPIO5			0x45
+#define TPS65912_VMON			0x46
+#define TPS65912_LEDA_CTRL1		0x47
+#define TPS65912_LEDA_CTRL2		0x48
+#define TPS65912_LEDA_CTRL3		0x49
+#define TPS65912_LEDA_CTRL4		0x4A
+#define TPS65912_LEDA_CTRL5		0x4B
+#define TPS65912_LEDA_CTRL6		0x4C
+#define TPS65912_LEDA_CTRL7		0x4D
+#define TPS65912_LEDA_CTRL8		0x4E
+#define TPS65912_LEDB_CTRL1		0x4F
+#define TPS65912_LEDB_CTRL2		0x50
+#define TPS65912_LEDB_CTRL3		0x51
+#define TPS65912_LEDB_CTRL4		0x52
+#define TPS65912_LEDB_CTRL5		0x53
+#define TPS65912_LEDB_CTRL6		0x54
+#define TPS65912_LEDB_CTRL7		0x55
+#define TPS65912_LEDB_CTRL8		0x56
+#define TPS65912_LEDC_CTRL1		0x57
+#define TPS65912_LEDC_CTRL2		0x58
+#define TPS65912_LEDC_CTRL3		0x59
+#define TPS65912_LEDC_CTRL4		0x5A
+#define TPS65912_LEDC_CTRL5		0x5B
+#define TPS65912_LEDC_CTRL6		0x5C
+#define TPS65912_LEDC_CTRL7		0x5D
+#define TPS65912_LEDC_CTRL8		0x5E
+#define TPS65912_LED_RAMP_UP_TIME	0x5F
+#define TPS65912_LED_RAMP_DOWN_TIME	0x60
+#define TPS65912_LED_SEQ_EN		0x61
+#define TPS65912_LOADSWITCH		0x62
+#define TPS65912_SPARE			0x63
+#define TPS65912_VERNUM			0x64
+#define TPS6591X_MAX_REGISTER		0x64
+
+/* IRQ Definitions */
+#define TPS65912_IRQ_PWRHOLD_F		0
+#define TPS65912_IRQ_VMON		1
+#define TPS65912_IRQ_PWRON		2
+#define TPS65912_IRQ_PWRON_LP		3
+#define TPS65912_IRQ_PWRHOLD_R		4
+#define TPS65912_IRQ_HOTDIE		5
+#define TPS65912_IRQ_GPIO1_R		6
+#define TPS65912_IRQ_GPIO1_F		7
+#define TPS65912_IRQ_GPIO2_R		8
+#define TPS65912_IRQ_GPIO2_F		9
+#define TPS65912_IRQ_GPIO3_R		10
+#define TPS65912_IRQ_GPIO3_F		11
+#define TPS65912_IRQ_GPIO4_R		12
+#define TPS65912_IRQ_GPIO4_F		13
+#define TPS65912_IRQ_GPIO5_R		14
+#define TPS65912_IRQ_GPIO5_F		15
+#define TPS65912_IRQ_PGOOD_DCDC1	16
+#define TPS65912_IRQ_PGOOD_DCDC2	17
+#define TPS65912_IRQ_PGOOD_DCDC3	18
+#define TPS65912_IRQ_PGOOD_DCDC4	19
+#define TPS65912_IRQ_PGOOD_LDO1		20
+#define TPS65912_IRQ_PGOOD_LDO2		21
+#define TPS65912_IRQ_PGOOD_LDO3		22
+#define TPS65912_IRQ_PGOOD_LDO4		23
+#define TPS65912_IRQ_PGOOD_LDO5		24
+#define TPS65912_IRQ_PGOOD_LDO6		25
+#define TPS65912_IRQ_PGOOD_LDO7		26
+#define TPS65912_IRQ_PGOOD_LD08		27
+#define TPS65912_IRQ_PGOOD_LDO9		28
+#define TPS65912_IRQ_PGOOD_LDO10	29
+
+#define TPS65912_NUM_IRQ		30
+
+/* GPIO 1 and 2 Register Definitions */
+#define GPIO_SLEEP_MASK			0x80
+#define GPIO_SLEEP_SHIFT		7
+#define GPIO_DEB_MASK			0x10
+#define GPIO_DEB_SHIFT			4
+#define GPIO_CFG_MASK			0x04
+#define GPIO_CFG_SHIFT			2
+#define GPIO_STS_MASK			0x02
+#define GPIO_STS_SHIFT			1
+#define GPIO_SET_MASK			0x01
+#define GPIO_SET_SHIFT			0
+
+/* GPIO 3 Register Definitions */
+#define GPIO3_SLEEP_MASK		0x80
+#define GPIO3_SLEEP_SHIFT		7
+#define GPIO3_SEL_MASK			0x40
+#define GPIO3_SEL_SHIFT			6
+#define GPIO3_ODEN_MASK			0x20
+#define GPIO3_ODEN_SHIFT		5
+#define GPIO3_DEB_MASK			0x10
+#define GPIO3_DEB_SHIFT			4
+#define GPIO3_PDEN_MASK			0x08
+#define GPIO3_PDEN_SHIFT		3
+#define GPIO3_CFG_MASK			0x04
+#define GPIO3_CFG_SHIFT			2
+#define GPIO3_STS_MASK			0x02
+#define GPIO3_STS_SHIFT			1
+#define GPIO3_SET_MASK			0x01
+#define GPIO3_SET_SHIFT			0
+
+/* GPIO 4 Register Definitions */
+#define GPIO4_SLEEP_MASK		0x80
+#define GPIO4_SLEEP_SHIFT		7
+#define GPIO4_SEL_MASK			0x40
+#define GPIO4_SEL_SHIFT			6
+#define GPIO4_ODEN_MASK			0x20
+#define GPIO4_ODEN_SHIFT		5
+#define GPIO4_DEB_MASK			0x10
+#define GPIO4_DEB_SHIFT			4
+#define GPIO4_PDEN_MASK			0x08
+#define GPIO4_PDEN_SHIFT		3
+#define GPIO4_CFG_MASK			0x04
+#define GPIO4_CFG_SHIFT			2
+#define GPIO4_STS_MASK			0x02
+#define GPIO4_STS_SHIFT			1
+#define GPIO4_SET_MASK			0x01
+#define GPIO4_SET_SHIFT			0
+
+/* Register THERM  (0x80) register.RegisterDescription */
+#define THERM_THERM_HD_MASK		0x20
+#define THERM_THERM_HD_SHIFT		5
+#define THERM_THERM_TS_MASK		0x10
+#define THERM_THERM_TS_SHIFT		4
+#define THERM_THERM_HDSEL_MASK		0x0C
+#define THERM_THERM_HDSEL_SHIFT		2
+#define THERM_RSVD1_MASK		0x02
+#define THERM_RSVD1_SHIFT		1
+#define THERM_THERM_STATE_MASK		0x01
+#define THERM_THERM_STATE_SHIFT		0
+
+/* Register DCDCCTRL1 register.RegisterDescription */
+#define DCDCCTRL_VCON_ENABLE_MASK	0x80
+#define DCDCCTRL_VCON_ENABLE_SHIFT	7
+#define DCDCCTRL_VCON_RANGE1_MASK	0x40
+#define DCDCCTRL_VCON_RANGE1_SHIFT	6
+#define DCDCCTRL_VCON_RANGE0_MASK	0x20
+#define DCDCCTRL_VCON_RANGE0_SHIFT	5
+#define DCDCCTRL_TSTEP2_MASK		0x10
+#define DCDCCTRL_TSTEP2_SHIFT		4
+#define DCDCCTRL_TSTEP1_MASK		0x08
+#define DCDCCTRL_TSTEP1_SHIFT		3
+#define DCDCCTRL_TSTEP0_MASK		0x04
+#define DCDCCTRL_TSTEP0_SHIFT		2
+#define DCDCCTRL_DCDC1_MODE_MASK	0x02
+#define DCDCCTRL_DCDC1_MODE_SHIFT	1
+
+/* Register DCDCCTRL2 and DCDCCTRL3 register.RegisterDescription */
+#define DCDCCTRL_TSTEP2_MASK		0x10
+#define DCDCCTRL_TSTEP2_SHIFT		4
+#define DCDCCTRL_TSTEP1_MASK		0x08
+#define DCDCCTRL_TSTEP1_SHIFT		3
+#define DCDCCTRL_TSTEP0_MASK		0x04
+#define DCDCCTRL_TSTEP0_SHIFT		2
+#define DCDCCTRL_DCDC_MODE_MASK		0x02
+#define DCDCCTRL_DCDC_MODE_SHIFT	1
+#define DCDCCTRL_RSVD0_MASK		0x01
+#define DCDCCTRL_RSVD0_SHIFT		0
+
+/* Register DCDCCTRL4 register.RegisterDescription */
+#define DCDCCTRL_RAMP_TIME_MASK		0x01
+#define DCDCCTRL_RAMP_TIME_SHIFT	0
+
+/* Register DCDCx_AVS */
+#define DCDC_AVS_ENABLE_MASK		0x80
+#define DCDC_AVS_ENABLE_SHIFT		7
+#define DCDC_AVS_ECO_MASK		0x40
+#define DCDC_AVS_ECO_SHIFT		6
+
+/* Register DCDCx_LIMIT */
+#define DCDC_LIMIT_RANGE_MASK		0xC0
+#define DCDC_LIMIT_RANGE_SHIFT		6
+#define DCDC_LIMIT_MAX_SEL_MASK		0x3F
+#define DCDC_LIMIT_MAX_SEL_SHIFT	0
+
+/**
+ * struct tps65912_board
+ * Board platform dat may be used to initialize regulators.
+ */
+struct tps65912_board {
+	int is_dcdc1_avs;
+	int is_dcdc2_avs;
+	int is_dcdc3_avs;
+	int is_dcdc4_avs;
+	struct regulator_init_data *tps65912_pmic_init_data;
+};
+
+/**
+ * struct tps65912 - tps65912 sub-driver chip access routines
+ */
+
+struct tps65912 {
+	struct device *dev;
+	/* for read/write acces */
+	struct mutex io_mutex;
+
+	/* For device IO interfaces: I2C or SPI */
+	void *control_data;
+
+	int (*read)(struct tps65912 *tps65912, u8 reg, int size, void *dest);
+	int (*write)(struct tps65912 *tps65912, u8 reg, int size, void *src);
+
+	/* Client devices */
+	struct tps65912_pmic *pmic;
+
+	/* GPIO Handling */
+	struct gpio_chip gpio;
+
+	/* IRQ Handling */
+	struct mutex irq_lock;
+	int chip_irq;
+	int irq_base;
+	int irq_num;
+	u32 irq_mask;
+};
+
+struct tps65912_platform_data {
+	int irq_base;
+};
+
+unsigned int tps_chip(void);
+
+int tps65912_set_bits(struct tps65912 *tps65912, u8 reg, u8 mask);
+int tps65912_clear_bits(struct tps65912 *tps65912, u8 reg, u8 mask);
+int tps65912_reg_read(struct tps65912 *tps65912, u8 reg);
+int tps65912_reg_write(struct tps65912 *tps65912, u8 reg, u8 val);
+int tps65912_device_init(struct tps65912 *tps65912);
+void tps65912_device_exit(struct tps65912 *tps65912);
+
+#endif /*  __LINUX_MFD_TPS65912_H */
-- 
1.7.0.4
