Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab2AKKlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 05:41:53 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48198 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab2AKKlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 05:41:49 -0500
From: AnilKumar Ch <anilkumar@ti.com>
To: <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <nsekhar@ti.com>,
        AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH V4 1/2] MFD: TPS65217: Add new mfd device for TPS65217
Date: Wed, 11 Jan 2012 16:11:41 +0530
Message-ID: <1326278501-29798-1-git-send-email-anilkumar@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPS65217 chip is a power management IC for Portable Navigation Systems
and Tablet Computing devices. It contains the following components:

- Regulators
- White LED
- USB battery charger

This patch adds support for tps65217 mfd device. At this time only
the regulator functionality is made available.

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
---
 drivers/mfd/Kconfig          |   15 +++
 drivers/mfd/Makefile         |    1 +
 drivers/mfd/tps65217.c       |  242 ++++++++++++++++++++++++++++++++++++
 include/linux/mfd/tps65217.h |  283 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 541 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/tps65217.c
 create mode 100644 include/linux/mfd/tps65217.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index f1391c2..d2c55e8 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -142,6 +142,21 @@ config TPS6507X
 	  This driver can also be built as a module.  If so, the module
 	  will be called tps6507x.
 
+config MFD_TPS65217
+	tristate "TPS65217 Power Management / White LED chips"
+	depends on I2C
+	select MFD_CORE
+	select REGMAP_I2C
+	help
+	  If you say yes here you get support for the TPS65217 series of
+	  Power Management / White LED chips.
+	  These include voltage regulators, lithium ion/polymer battery
+	  charger, wled and other features that are often used in portable
+	  devices.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called tps65217.
+
 config MFD_TPS6586X
 	bool "TPS6586x Power Management chips"
 	depends on I2C=y && GPIOLIB && GENERIC_HARDIRQS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index b2292eb..7a6d111 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_MFD_WM8994)	+= wm8994-core.o wm8994-irq.o
 obj-$(CONFIG_TPS6105X)		+= tps6105x.o
 obj-$(CONFIG_TPS65010)		+= tps65010.o
 obj-$(CONFIG_TPS6507X)		+= tps6507x.o
+obj-$(CONFIG_MFD_TPS65217)	+= tps65217.o
 obj-$(CONFIG_MFD_TPS65910)	+= tps65910.o tps65910-irq.o
 tps65912-objs                   := tps65912-core.o tps65912-irq.o
 obj-$(CONFIG_MFD_TPS65912)	+= tps65912.o
diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
new file mode 100644
index 0000000..f7d854e
--- /dev/null
+++ b/drivers/mfd/tps65217.c
@@ -0,0 +1,242 @@
+/*
+ * tps65217.c
+ *
+ * TPS65217 chip family multi-function driver
+ *
+ * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/regmap.h>
+#include <linux/err.h>
+
+#include <linux/mfd/core.h>
+#include <linux/mfd/tps65217.h>
+
+/**
+ * tps65217_reg_read: Read a single tps65217 register.
+ *
+ * @tps: Device to read from.
+ * @reg: Register to read.
+ * @val: Contians the value
+ */
+int tps65217_reg_read(struct tps65217 *tps, unsigned int reg,
+			unsigned int *val)
+{
+	return regmap_read(tps->regmap, reg, val);
+}
+EXPORT_SYMBOL_GPL(tps65217_reg_read);
+
+/**
+ * tps65217_reg_write: Write a single tps65217 register.
+ *
+ * @tps65217: Device to write to.
+ * @reg: Register to write to.
+ * @val: Value to write.
+ * @level: Password protected level
+ */
+int tps65217_reg_write(struct tps65217 *tps, unsigned int reg,
+			unsigned int val, unsigned int level)
+{
+	int ret;
+	unsigned int xor_reg_val;
+
+	switch (level) {
+	case TPS65217_PROTECT_NONE:
+		return regmap_write(tps->regmap, reg, val);
+	case TPS65217_PROTECT_L1:
+		xor_reg_val = reg ^ TPS65217_PASSWORD_REGS_UNLOCK;
+		ret = regmap_write(tps->regmap, TPS65217_REG_PASSWORD,
+							xor_reg_val);
+		if (ret < 0)
+			return ret;
+
+		return regmap_write(tps->regmap, reg, val);
+	case TPS65217_PROTECT_L2:
+		xor_reg_val = reg ^ TPS65217_PASSWORD_REGS_UNLOCK;
+		ret = regmap_write(tps->regmap, TPS65217_REG_PASSWORD,
+							xor_reg_val);
+		if (ret < 0)
+			return ret;
+		ret = regmap_write(tps->regmap, reg, val);
+		if (ret < 0)
+			return ret;
+		ret = regmap_write(tps->regmap, TPS65217_REG_PASSWORD,
+							xor_reg_val);
+		if (ret < 0)
+			return ret;
+		return regmap_write(tps->regmap, reg, val);
+	default:
+		return -EINVAL;
+	}
+}
+EXPORT_SYMBOL_GPL(tps65217_reg_write);
+
+/**
+ * tps65217_update_bits: Modify bits w.r.t mask, val and level.
+ *
+ * @tps65217: Device to write to.
+ * @reg: Register to read-write to.
+ * @mask: Mask.
+ * @val: Value to write.
+ * @level: Password protected level
+ */
+int tps65217_update_bits(struct tps65217 *tps, unsigned int reg,
+		unsigned int mask, unsigned int val, unsigned int level)
+{
+	int ret;
+	unsigned int data;
+
+	ret = tps65217_reg_read(tps, reg, &data);
+	if (ret) {
+		dev_err(tps->dev, "Read from reg 0x%x failed\n", reg);
+		return ret;
+	}
+
+	data &= ~mask;
+	data |= val & mask;
+
+	ret = tps65217_reg_write(tps, reg, data, level);
+	if (ret)
+		dev_err(tps->dev, "Write for reg 0x%x failed\n", reg);
+
+	return ret;
+}
+
+int tps65217_set_bits(struct tps65217 *tps, unsigned int reg,
+		unsigned int mask, unsigned int val, unsigned int level)
+{
+	return tps65217_update_bits(tps, reg, mask, val, level);
+}
+EXPORT_SYMBOL_GPL(tps65217_set_bits);
+
+int tps65217_clear_bits(struct tps65217 *tps, unsigned int reg,
+		unsigned int mask, unsigned int level)
+{
+	return tps65217_update_bits(tps, reg, mask, 0, level);
+}
+EXPORT_SYMBOL_GPL(tps65217_clear_bits);
+
+static struct regmap_config tps65217_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int __devinit tps65217_probe(struct i2c_client *client,
+				const struct i2c_device_id *ids)
+{
+	struct tps65217 *tps;
+	struct tps65217_board *pdata = client->dev.platform_data;
+	int i, ret;
+	unsigned int version;
+
+	tps = devm_kzalloc(&client->dev, sizeof(*tps), GFP_KERNEL);
+	if (!tps)
+		return -ENOMEM;
+
+	tps->pdata = pdata;
+	tps->regmap = regmap_init_i2c(client, &tps65217_regmap_config);
+	if (IS_ERR(tps->regmap)) {
+		ret = PTR_ERR(tps->regmap);
+		dev_err(tps->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
+	i2c_set_clientdata(client, tps);
+	tps->dev = &client->dev;
+
+	ret = tps65217_reg_read(tps, TPS65217_REG_CHIPID, &version);
+	if (ret < 0) {
+		dev_err(tps->dev, "Failed to read revision"
+					" register: %d\n", ret);
+		goto err_regmap;
+	}
+
+	dev_info(tps->dev, "TPS65217 ID %#x version 1.%d\n",
+			(version & TPS65217_CHIPID_CHIP_MASK) >> 4,
+			version & TPS65217_CHIPID_REV_MASK);
+
+	for (i = 0; i < TPS65217_NUM_REGULATOR; i++) {
+		struct platform_device *pdev;
+
+		pdev = platform_device_alloc("tps65217-pmic", i);
+		if (!pdev) {
+			dev_err(tps->dev, "Cannot create regulator %d\n", i);
+			continue;
+		}
+
+		pdev->dev.parent = tps->dev;
+		platform_device_add_data(pdev, &pdata->tps65217_init_data[i],
+					sizeof(pdata->tps65217_init_data[i]));
+		tps->regulator_pdev[i] = pdev;
+
+		platform_device_add(pdev);
+	}
+
+	return 0;
+
+err_regmap:
+	regmap_exit(tps->regmap);
+
+	return ret;
+}
+
+static int __devexit tps65217_remove(struct i2c_client *client)
+{
+	struct tps65217 *tps = i2c_get_clientdata(client);
+	int i;
+
+	for (i = 0; i < TPS65217_NUM_REGULATOR; i++)
+		platform_device_unregister(tps->regulator_pdev[i]);
+
+	regmap_exit(tps->regmap);
+
+	return 0;
+}
+
+static const struct i2c_device_id tps65217_id_table[] = {
+	{"tps65217", 0xF0},
+	{/* end of list */}
+};
+MODULE_DEVICE_TABLE(i2c, tps65217_id_table);
+
+static struct i2c_driver tps65217_driver = {
+	.driver		= {
+		.name	= "tps65217",
+	},
+	.id_table	= tps65217_id_table,
+	.probe		= tps65217_probe,
+	.remove		= __devexit_p(tps65217_remove),
+};
+
+static int __init tps65217_init(void)
+{
+	return i2c_add_driver(&tps65217_driver);
+}
+subsys_initcall(tps65217_init);
+
+static void __exit tps65217_exit(void)
+{
+	i2c_del_driver(&tps65217_driver);
+}
+module_exit(tps65217_exit);
+
+MODULE_AUTHOR("AnilKumar Ch <anilkumar@ti.com>");
+MODULE_DESCRIPTION("TPS65217 chip family multi-function driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/tps65217.h b/include/linux/mfd/tps65217.h
new file mode 100644
index 0000000..e030ef9
--- /dev/null
+++ b/include/linux/mfd/tps65217.h
@@ -0,0 +1,283 @@
+/*
+ * linux/mfd/tps65217.h
+ *
+ * Functions to access TPS65217 power management chip.
+ *
+ * Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __LINUX_MFD_TPS65217_H
+#define __LINUX_MFD_TPS65217_H
+
+#include <linux/i2c.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+
+/* I2C ID for TPS65217 part */
+#define TPS65217_I2C_ID			0x24
+
+/* All register addresses */
+#define TPS65217_REG_CHIPID		0X00
+#define TPS65217_REG_PPATH		0X01
+#define TPS65217_REG_INT		0X02
+#define TPS65217_REG_CHGCONFIG0		0X03
+#define TPS65217_REG_CHGCONFIG1		0X04
+#define TPS65217_REG_CHGCONFIG2		0X05
+#define TPS65217_REG_CHGCONFIG3		0X06
+#define TPS65217_REG_WLEDCTRL1		0X07
+#define TPS65217_REG_WLEDCTRL2		0X08
+#define TPS65217_REG_MUXCTRL		0X09
+#define TPS65217_REG_STATUS		0X0A
+#define TPS65217_REG_PASSWORD		0X0B
+#define TPS65217_REG_PGOOD		0X0C
+#define TPS65217_REG_DEFPG		0X0D
+#define TPS65217_REG_DEFDCDC1		0X0E
+#define TPS65217_REG_DEFDCDC2		0X0F
+#define TPS65217_REG_DEFDCDC3		0X10
+#define TPS65217_REG_DEFSLEW		0X11
+#define TPS65217_REG_DEFLDO1		0X12
+#define TPS65217_REG_DEFLDO2		0X13
+#define TPS65217_REG_DEFLS1		0X14
+#define TPS65217_REG_DEFLS2		0X15
+#define TPS65217_REG_ENABLE		0X16
+#define TPS65217_REG_DEFUVLO		0X18
+#define TPS65217_REG_SEQ1		0X19
+#define TPS65217_REG_SEQ2		0X1A
+#define TPS65217_REG_SEQ3		0X1B
+#define TPS65217_REG_SEQ4		0X1C
+#define TPS65217_REG_SEQ5		0X1D
+#define TPS65217_REG_SEQ6		0X1E
+
+/* Register field definitions */
+#define TPS65217_CHIPID_CHIP_MASK	0xF0
+#define TPS65217_CHIPID_REV_MASK	0x0F
+
+#define TPS65217_PPATH_ACSINK_ENABLE	BIT(7)
+#define TPS65217_PPATH_USBSINK_ENABLE	BIT(6)
+#define TPS65217_PPATH_AC_PW_ENABLE	BIT(5)
+#define TPS65217_PPATH_USB_PW_ENABLE	BIT(4)
+#define TPS65217_PPATH_AC_CURRENT_MASK	0x0C
+#define TPS65217_PPATH_USB_CURRENT_MASK	0x03
+
+#define TPS65217_INT_PBM		BIT(6)
+#define TPS65217_INT_ACM		BIT(5)
+#define TPS65217_INT_USBM		BIT(4)
+#define TPS65217_INT_PBI		BIT(2)
+#define TPS65217_INT_ACI		BIT(1)
+#define TPS65217_INT_USBI		BIT(0)
+
+#define TPS65217_CHGCONFIG0_TREG	BIT(7)
+#define TPS65217_CHGCONFIG0_DPPM	BIT(6)
+#define TPS65217_CHGCONFIG0_TSUSP	BIT(5)
+#define TPS65217_CHGCONFIG0_TERMI	BIT(4)
+#define TPS65217_CHGCONFIG0_ACTIVE	BIT(3)
+#define TPS65217_CHGCONFIG0_CHGTOUT	BIT(2)
+#define TPS65217_CHGCONFIG0_PCHGTOUT	BIT(1)
+#define TPS65217_CHGCONFIG0_BATTEMP	BIT(0)
+
+#define TPS65217_CHGCONFIG1_TMR_MASK	0xC0
+#define TPS65217_CHGCONFIG1_TMR_ENABLE	BIT(5)
+#define TPS65217_CHGCONFIG1_NTC_TYPE	BIT(4)
+#define TPS65217_CHGCONFIG1_RESET	BIT(3)
+#define TPS65217_CHGCONFIG1_TERM	BIT(2)
+#define TPS65217_CHGCONFIG1_SUSP	BIT(1)
+#define TPS65217_CHGCONFIG1_CHG_EN	BIT(0)
+
+#define TPS65217_CHGCONFIG2_DYNTMR	BIT(7)
+#define TPS65217_CHGCONFIG2_VPREGHG	BIT(6)
+#define TPS65217_CHGCONFIG2_VOREG_MASK	0x30
+
+#define TPS65217_CHGCONFIG3_ICHRG_MASK	0xC0
+#define TPS65217_CHGCONFIG3_DPPMTH_MASK	0x30
+#define TPS65217_CHGCONFIG2_PCHRGT	BIT(3)
+#define TPS65217_CHGCONFIG2_TERMIF	0x06
+#define TPS65217_CHGCONFIG2_TRANGE	BIT(0)
+
+#define TPS65217_WLEDCTRL1_ISINK_ENABLE	BIT(3)
+#define TPS65217_WLEDCTRL1_ISEL		BIT(2)
+#define TPS65217_WLEDCTRL1_FDIM_MASK	0x03
+
+#define TPS65217_WLEDCTRL2_DUTY_MASK	0x7F
+
+#define TPS65217_MUXCTRL_MUX_MASK	0x07
+
+#define TPS65217_STATUS_OFF		BIT(7)
+#define TPS65217_STATUS_ACPWR		BIT(3)
+#define TPS65217_STATUS_USBPWR		BIT(2)
+#define TPS65217_STATUS_PB		BIT(0)
+
+#define TPS65217_PASSWORD_REGS_UNLOCK	0x7D
+
+#define TPS65217_PGOOD_LDO3_PG		BIT(6)
+#define TPS65217_PGOOD_LDO4_PG		BIT(5)
+#define TPS65217_PGOOD_DC1_PG		BIT(4)
+#define TPS65217_PGOOD_DC2_PG		BIT(3)
+#define TPS65217_PGOOD_DC3_PG		BIT(2)
+#define TPS65217_PGOOD_LDO1_PG		BIT(1)
+#define TPS65217_PGOOD_LDO2_PG		BIT(0)
+
+#define TPS65217_DEFPG_LDO1PGM		BIT(3)
+#define TPS65217_DEFPG_LDO2PGM		BIT(2)
+#define TPS65217_DEFPG_PGDLY_MASK	0x03
+
+#define TPS65217_DEFDCDCX_XADJX		BIT(7)
+#define TPS65217_DEFDCDCX_DCDC_MASK	0x3F
+
+#define TPS65217_DEFSLEW_GO		BIT(7)
+#define TPS65217_DEFSLEW_GODSBL		BIT(6)
+#define TPS65217_DEFSLEW_PFM_EN1	BIT(5)
+#define TPS65217_DEFSLEW_PFM_EN2	BIT(4)
+#define TPS65217_DEFSLEW_PFM_EN3	BIT(3)
+#define TPS65217_DEFSLEW_SLEW_MASK	0x07
+
+#define TPS65217_DEFLDO1_LDO1_MASK	0x0F
+
+#define TPS65217_DEFLDO2_TRACK		BIT(6)
+#define TPS65217_DEFLDO2_LDO2_MASK	0x3F
+
+#define TPS65217_DEFLDO3_LDO3_EN	BIT(5)
+#define TPS65217_DEFLDO3_LDO3_MASK	0x1F
+
+#define TPS65217_DEFLDO4_LDO4_EN	BIT(5)
+#define TPS65217_DEFLDO4_LDO4_MASK	0x1F
+
+#define TPS65217_ENABLE_LS1_EN		BIT(6)
+#define TPS65217_ENABLE_LS2_EN		BIT(5)
+#define TPS65217_ENABLE_DC1_EN		BIT(4)
+#define TPS65217_ENABLE_DC2_EN		BIT(3)
+#define TPS65217_ENABLE_DC3_EN		BIT(2)
+#define TPS65217_ENABLE_LDO1_EN		BIT(1)
+#define TPS65217_ENABLE_LDO2_EN		BIT(0)
+
+#define TPS65217_DEFUVLO_UVLOHYS	BIT(2)
+#define TPS65217_DEFUVLO_UVLO_MASK	0x03
+
+#define TPS65217_SEQ1_DC1_SEQ_MASK	0xF0
+#define TPS65217_SEQ1_DC2_SEQ_MASK	0x0F
+
+#define TPS65217_SEQ2_DC3_SEQ_MASK	0xF0
+#define TPS65217_SEQ2_LDO1_SEQ_MASK	0x0F
+
+#define TPS65217_SEQ3_LDO2_SEQ_MASK	0xF0
+#define TPS65217_SEQ3_LDO3_SEQ_MASK	0x0F
+
+#define TPS65217_SEQ4_LDO4_SEQ_MASK	0xF0
+
+#define TPS65217_SEQ5_DLY1_MASK		0xC0
+#define TPS65217_SEQ5_DLY2_MASK		0x30
+#define TPS65217_SEQ5_DLY3_MASK		0x0C
+#define TPS65217_SEQ5_DLY4_MASK		0x03
+
+#define TPS65217_SEQ6_DLY5_MASK		0xC0
+#define TPS65217_SEQ6_DLY6_MASK		0x30
+#define TPS65217_SEQ6_SEQUP		BIT(2)
+#define TPS65217_SEQ6_SEQDWN		BIT(1)
+#define TPS65217_SEQ6_INSTDWN		BIT(0)
+
+#define TPS65217_MAX_REGISTER		0x1E
+#define TPS65217_PROTECT_NONE		0
+#define TPS65217_PROTECT_L1		1
+#define TPS65217_PROTECT_L2		2
+
+
+enum tps65217_regulator_id {
+	/* DCDC's */
+	TPS65217_DCDC_1,
+	TPS65217_DCDC_2,
+	TPS65217_DCDC_3,
+	/* LDOs */
+	TPS65217_LDO_1,
+	TPS65217_LDO_2,
+	TPS65217_LDO_3,
+	TPS65217_LDO_4,
+};
+
+#define TPS65217_MAX_REG_ID		TPS65217_LDO_4
+
+/* Number of step-down converters available */
+#define TPS65217_NUM_DCDC		3
+/* Number of LDO voltage regulators available */
+#define TPS65217_NUM_LDO		4
+/* Number of total regulators available */
+#define TPS65217_NUM_REGULATOR		(TPS65217_NUM_DCDC + TPS65217_NUM_LDO)
+
+/**
+ * struct tps65217_board - packages regulator init data
+ * @tps65217_regulator_data: regulator initialization values
+ *
+ * Board data may be used to initialize regulator.
+ */
+struct tps65217_board {
+	struct regulator_init_data *tps65217_init_data;
+};
+
+/**
+ * struct tps_info - packages regulator constraints
+ * @name:		Voltage regulator name
+ * @min_uV:		minimum micro volts
+ * @max_uV:		minimum micro volts
+ * @vsel_to_uv:		Function pointer to get voltage from selector
+ * @uv_to_vsel:		Function pointer to get selector from voltage
+ * @table:		Table for non-uniform voltage step-size
+ * @table_len:		Length of the voltage table
+ * @enable_mask:	Regulator enable mask bits
+ * @set_vout_reg:	Regulator output voltage set register
+ * @set_vout_mask:	Regulator output voltage set mask
+ *
+ * This data is used to check the regualtor voltage limits while setting.
+ */
+struct tps_info {
+	const char *name;
+	int min_uV;
+	int max_uV;
+	int (*vsel_to_uv)(unsigned int vsel);
+	int (*uv_to_vsel)(int uV, unsigned int *vsel);
+	const int *table;
+	unsigned int table_len;
+	unsigned int enable_mask;
+	unsigned int set_vout_reg;
+	unsigned int set_vout_mask;
+};
+
+/**
+ * struct tps65217 - tps65217 sub-driver chip access routines
+ *
+ * Device data may be used to access the TPS65217 chip
+ */
+
+struct tps65217 {
+	struct device *dev;
+	struct tps65217_board *pdata;
+	struct regulator_desc desc[TPS65217_NUM_REGULATOR];
+	struct regulator_dev *rdev[TPS65217_NUM_REGULATOR];
+	struct tps_info *info[TPS65217_NUM_REGULATOR];
+	struct regmap *regmap;
+
+	/* Client devices */
+	struct platform_device *regulator_pdev[TPS65217_NUM_REGULATOR];
+};
+
+static inline struct tps65217 *dev_to_tps65217(struct device *dev)
+{
+	return dev_get_drvdata(dev);
+}
+
+int tps65217_reg_read(struct tps65217 *tps, unsigned int reg,
+					unsigned int *val);
+int tps65217_reg_write(struct tps65217 *tps, unsigned int reg,
+			unsigned int val, unsigned int level);
+int tps65217_set_bits(struct tps65217 *tps, unsigned int reg,
+		unsigned int mask, unsigned int val, unsigned int level);
+int tps65217_clear_bits(struct tps65217 *tps, unsigned int reg,
+		unsigned int mask, unsigned int level);
+
+#endif /*  __LINUX_MFD_TPS65217_H */
-- 
1.7.0.4

