Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2ENFUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 01:20:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49042 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2ENFUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 01:20:36 -0400
X-AuditID: cbfee61a-b7bbeae000003a71-8b-4fb09623e104
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sameo@linux.intel.com
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v3 1/2] MFD: MAX77693: add MAX77693 MFD driver
Date: Mon, 14 May 2012 14:20:30 +0900
Message-id: <1336972830-15169-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds MFD driver for MAX77693 to enable its sub devices.

The MAX77693 is a multi-function devices. It includes PMIC,
MUIC(Micro USB Interface Controller), flash LED control and
haptic motor control.

Signef-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off0by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/Kconfig                  |   12 ++
 drivers/mfd/Makefile                 |    1 +
 drivers/mfd/max77693.c               |  221 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/max77693-private.h |  217 +++++++++++++++++++++++++++++++++
 include/linux/mfd/max77693.h         |   37 ++++++
 5 files changed, 488 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/max77693.c
 create mode 100644 include/linux/mfd/max77693-private.h
 create mode 100644 include/linux/mfd/max77693.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 11e4438..a8619eb 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -452,6 +452,18 @@ config MFD_S5M_CORE
 	 additional drivers must be enabled in order to use the functionality
 	 of the device
 
+config MFD_MAX77693
+	bool "Maxim Semiconductor MAX77693 PMIC Support"
+	depends on I2C=y && GENERIC_HARDIRQS
+	select MFD_CORE
+	help
+	  Say yes here to support for Maxim Semiconductor MAX77693.
+	  This is a companion Power Management IC with Flash, Haptic, Charger,
+	  and MUIC(Micro USB Interface Controller) controls on chip.
+	  This driver provides common support for accessing the device;
+	  additional drivers must be enabled in order to use the functionality
+	  of the device.
+
 config MFD_WM8400
 	tristate "Support Wolfson Microelectronics WM8400"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 05fa538..ae18cf1 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -79,6 +79,7 @@ max8925-objs			:= max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
 obj-$(CONFIG_MFD_MAX8997)	+= max8997.o max8997-irq.o
 obj-$(CONFIG_MFD_MAX8998)	+= max8998.o max8998-irq.o
+obj-$(CONFIG_MFD_MAX77693)	+= max77693.o
 
 pcf50633-objs			:= pcf50633-core.o pcf50633-irq.o
 obj-$(CONFIG_MFD_PCF50633)	+= pcf50633.o
diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
new file mode 100644
index 0000000..bf28e12
--- /dev/null
+++ b/drivers/mfd/max77693.c
@@ -0,0 +1,221 @@
+/*
+ * max77693.c - mfd core driver for the MAX 77693
+ *
+ * Copyright (C) 2012 Samsung Electronics
+ * SangYoung Son <hello.son@smasung.com>
+ *
+ * This program is not provided / owned by Maxim Integrated Products.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * This driver is based on max8997.c
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
+#include <linux/mutex.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/max77693.h>
+#include <linux/mfd/max77693-private.h>
+#include <linux/regulator/machine.h>
+#include <linux/regmap.h>
+
+#define I2C_ADDR_PMIC	(0xCC >> 1)	/* Charger, Flash LED */
+#define I2C_ADDR_MUIC	(0x4A >> 1)
+#define I2C_ADDR_HAPTIC	(0x90 >> 1)
+
+static struct mfd_cell max77693_devs[] = {
+	{ .name = "max77693-pmic", },
+	{ .name = "max77693-charger", },
+	{ .name = "max77693-flash", },
+	{ .name = "max77693-muic", },
+	{ .name = "max77693-haptic", },
+};
+
+int max77693_read_reg(struct regmap *map, u8 reg, u8 *dest)
+{
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(map, reg, &val);
+	val &= 0xff;
+	*dest = val;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(max77693_read_reg);
+
+int max77693_bulk_read(struct regmap *map, u8 reg, int count, u8 *buf)
+{
+	int ret;
+
+	ret = regmap_bulk_read(map, reg, buf, count);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(max77693_bulk_read);
+
+int max77693_write_reg(struct regmap *map, u8 reg, u8 value)
+{
+	int ret;
+
+	ret = regmap_write(map, reg, value);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(max77693_write_reg);
+
+int max77693_bulk_write(struct regmap *map, u8 reg, int count, u8 *buf)
+{
+	int ret;
+
+	ret = regmap_bulk_write(map, reg, buf, count);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(max77693_bulk_write);
+
+int max77693_update_reg(struct regmap *map, u8 reg, u8 val, u8 mask)
+{
+	unsigned int old_val, new_val;
+	int ret;
+
+	ret = regmap_read(map, reg, &old_val);
+	old_val &= 0xff;
+	new_val = (val & mask) | (old_val & (~mask));
+	ret = regmap_write(map, reg, new_val);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(max77693_update_reg);
+
+static struct regmap_config max77693_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int max77693_i2c_probe(struct i2c_client *i2c,
+			      const struct i2c_device_id *id)
+{
+	struct max77693_dev *max77693;
+	struct max77693_platform_data *pdata = i2c->dev.platform_data;
+	u8 reg_data;
+	int ret = 0;
+
+	max77693 = devm_kzalloc(&i2c->dev,
+			sizeof(struct max77693_dev), GFP_KERNEL);
+	if (max77693 == NULL)
+		return -ENOMEM;
+
+	max77693->regmap = regmap_init_i2c(i2c, &max77693_regmap_config);
+	if (IS_ERR(max77693->regmap)) {
+		ret = PTR_ERR(max77693->regmap);
+		dev_err(max77693->dev,"failed to allocate register map: %d\n",
+				ret);
+		goto err_regmap;
+	}
+
+	i2c_set_clientdata(i2c, max77693);
+	max77693->dev = &i2c->dev;
+	max77693->i2c = i2c;
+	max77693->irq = i2c->irq;
+	max77693->type = id->driver_data;
+
+	if (!pdata)
+		goto err_regmap;
+
+	max77693->wakeup = pdata->wakeup;
+
+	mutex_init(&max77693->iolock);
+
+	if (max77693_read_reg(max77693->regmap,
+				MAX77693_PMIC_REG_PMIC_ID2, &reg_data) < 0) {
+		dev_err(max77693->dev, "device not found on this channel\n");
+		ret = -ENODEV;
+		goto err_regmap;
+	} else
+		dev_info(max77693->dev, "device ID: 0x%x\n", reg_data);
+
+	max77693->muic = i2c_new_dummy(i2c->adapter, I2C_ADDR_MUIC);
+	i2c_set_clientdata(max77693->muic, max77693);
+
+	max77693->haptic = i2c_new_dummy(i2c->adapter, I2C_ADDR_HAPTIC);
+	i2c_set_clientdata(max77693->haptic, max77693);
+
+	pm_runtime_set_active(max77693->dev);
+
+	ret = mfd_add_devices(max77693->dev, -1, max77693_devs,
+			ARRAY_SIZE(max77693_devs), NULL, 0);
+	if (ret < 0)
+		goto err_mfd;
+
+	return ret;
+
+err_mfd:
+	i2c_unregister_device(max77693->muic);
+	i2c_unregister_device(max77693->haptic);
+err_regmap:
+	kfree(max77693);
+
+	return ret;
+}
+
+static int max77693_i2c_remove(struct i2c_client *i2c)
+{
+	struct max77693_dev *max77693 = i2c_get_clientdata(i2c);
+
+	mfd_remove_devices(max77693->dev);
+	i2c_unregister_device(max77693->muic);
+	i2c_unregister_device(max77693->haptic);
+
+	return 0;
+}
+
+static const struct i2c_device_id max77693_i2c_id[] = {
+	{ "max77693", TYPE_MAX77693 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, max77693_i2c_id);
+
+static struct i2c_driver max77693_i2c_driver = {
+	.driver = {
+		   .name = "max77693",
+		   .owner = THIS_MODULE,
+	},
+	.probe = max77693_i2c_probe,
+	.remove = max77693_i2c_remove,
+	.id_table = max77693_i2c_id,
+};
+
+static int __init max77693_i2c_init(void)
+{
+	return i2c_add_driver(&max77693_i2c_driver);
+}
+/* init early so consumer devices can complete system boot */
+subsys_initcall(max77693_i2c_init);
+
+static void __exit max77693_i2c_exit(void)
+{
+	i2c_del_driver(&max77693_i2c_driver);
+}
+module_exit(max77693_i2c_exit);
+
+MODULE_DESCRIPTION("MAXIM 77693 multi-function core driver");
+MODULE_AUTHOR("SangYoung, Son <hello.son@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
new file mode 100644
index 0000000..bf6077d
--- /dev/null
+++ b/include/linux/mfd/max77693-private.h
@@ -0,0 +1,217 @@
+/*
+ * max77693-private.h - Voltage regulator driver for the Maxim 77693
+ *
+ *  Copyright (C) 2012 Samsung Electrnoics
+ *  SangYoung Son <hello.son@samsung.com>
+ *
+ * This program is not provided / owned by Maxim Integrated Products.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef __LINUX_MFD_MAX77693_PRIV_H
+#define __LINUX_MFD_MAX77693_PRIV_H
+
+#include <linux/i2c.h>
+
+#define MAX77693_NUM_IRQ_MUIC_REGS	3
+#define MAX77693_REG_INVALID		(0xff)
+
+/* Slave addr = 0xCC: PMIC, Charger, Flash LED */
+enum max77693_pmic_reg {
+	MAX77693_LED_REG_IFLASH1			= 0x00,
+	MAX77693_LED_REG_IFLASH2			= 0x01,
+	MAX77693_LED_REG_ITORCH				= 0x02,
+	MAX77693_LED_REG_ITORCHTIMER			= 0x03,
+	MAX77693_LED_REG_FLASH_TIMER			= 0x04,
+	MAX77693_LED_REG_FLASH_EN			= 0x05,
+	MAX77693_LED_REG_MAX_FLASH1			= 0x06,
+	MAX77693_LED_REG_MAX_FLASH2			= 0x07,
+	MAX77693_LED_REG_MAX_FLASH3			= 0x08,
+	MAX77693_LED_REG_MAX_FLASH4			= 0x09,
+	MAX77693_LED_REG_VOUT_CNTL			= 0x0A,
+	MAX77693_LED_REG_VOUT_FLASH1			= 0x0B,
+	MAX77693_LED_REG_VOUT_FLASH2			= 0x0C,
+	MAX77693_LED_REG_FLASH_INT			= 0x0E,
+	MAX77693_LED_REG_FLASH_INT_MASK			= 0x0F,
+	MAX77693_LED_REG_FLASH_INT_STATUS		= 0x10,
+
+	MAX77693_PMIC_REG_PMIC_ID1			= 0x20,
+	MAX77693_PMIC_REG_PMIC_ID2			= 0x21,
+	MAX77693_PMIC_REG_INTSRC			= 0x22,
+	MAX77693_PMIC_REG_INTSRC_MASK			= 0x23,
+	MAX77693_PMIC_REG_TOPSYS_INT			= 0x24,
+	MAX77693_PMIC_REG_TOPSYS_INT_MASK		= 0x26,
+	MAX77693_PMIC_REG_TOPSYS_STAT			= 0x28,
+	MAX77693_PMIC_REG_MAINCTRL1			= 0x2A,
+	MAX77693_PMIC_REG_LSCNFG			= 0x2B,
+
+	MAX77693_CHG_REG_CHG_INT			= 0xB0,
+	MAX77693_CHG_REG_CHG_INT_MASK			= 0xB1,
+	MAX77693_CHG_REG_CHG_INT_OK			= 0xB2,
+	MAX77693_CHG_REG_CHG_DETAILS_00			= 0xB3,
+	MAX77693_CHG_REG_CHG_DETAILS_01			= 0xB4,
+	MAX77693_CHG_REG_CHG_DETAILS_02			= 0xB5,
+	MAX77693_CHG_REG_CHG_DETAILS_03			= 0xB6,
+	MAX77693_CHG_REG_CHG_CNFG_00			= 0xB7,
+	MAX77693_CHG_REG_CHG_CNFG_01			= 0xB8,
+	MAX77693_CHG_REG_CHG_CNFG_02			= 0xB9,
+	MAX77693_CHG_REG_CHG_CNFG_03			= 0xBA,
+	MAX77693_CHG_REG_CHG_CNFG_04			= 0xBB,
+	MAX77693_CHG_REG_CHG_CNFG_05			= 0xBC,
+	MAX77693_CHG_REG_CHG_CNFG_06			= 0xBD,
+	MAX77693_CHG_REG_CHG_CNFG_07			= 0xBE,
+	MAX77693_CHG_REG_CHG_CNFG_08			= 0xBF,
+	MAX77693_CHG_REG_CHG_CNFG_09			= 0xC0,
+	MAX77693_CHG_REG_CHG_CNFG_10			= 0xC1,
+	MAX77693_CHG_REG_CHG_CNFG_11			= 0xC2,
+	MAX77693_CHG_REG_CHG_CNFG_12			= 0xC3,
+	MAX77693_CHG_REG_CHG_CNFG_13			= 0xC4,
+	MAX77693_CHG_REG_CHG_CNFG_14			= 0xC5,
+	MAX77693_CHG_REG_SAFEOUT_CTRL			= 0xC6,
+
+	MAX77693_PMIC_REG_END,
+};
+
+/* Slave addr = 0x4A: MUIC */
+enum max77693_muic_reg {
+	MAX77693_MUIC_REG_ID		= 0x00,
+	MAX77693_MUIC_REG_INT1		= 0x01,
+	MAX77693_MUIC_REG_INT2		= 0x02,
+	MAX77693_MUIC_REG_INT3		= 0x03,
+	MAX77693_MUIC_REG_STATUS1	= 0x04,
+	MAX77693_MUIC_REG_STATUS2	= 0x05,
+	MAX77693_MUIC_REG_STATUS3	= 0x06,
+	MAX77693_MUIC_REG_INTMASK1	= 0x07,
+	MAX77693_MUIC_REG_INTMASK2	= 0x08,
+	MAX77693_MUIC_REG_INTMASK3	= 0x09,
+	MAX77693_MUIC_REG_CDETCTRL1	= 0x0A,
+	MAX77693_MUIC_REG_CDETCTRL2	= 0x0B,
+	MAX77693_MUIC_REG_CTRL1		= 0x0C,
+	MAX77693_MUIC_REG_CTRL2		= 0x0D,
+	MAX77693_MUIC_REG_CTRL3		= 0x0E,
+
+	MAX77693_MUIC_REG_END,
+};
+
+/* Slave addr = 0x90: Haptic */
+enum max77693_haptic_reg {
+	MAX77693_HAPTIC_REG_STATUS		= 0x00,
+	MAX77693_HAPTIC_REG_CONFIG1		= 0x01,
+	MAX77693_HAPTIC_REG_CONFIG2		= 0x02,
+	MAX77693_HAPTIC_REG_CONFIG_CHNL		= 0x03,
+	MAX77693_HAPTIC_REG_CONFG_CYC1		= 0x04,
+	MAX77693_HAPTIC_REG_CONFG_CYC2		= 0x05,
+	MAX77693_HAPTIC_REG_CONFIG_PER1		= 0x06,
+	MAX77693_HAPTIC_REG_CONFIG_PER2		= 0x07,
+	MAX77693_HAPTIC_REG_CONFIG_PER3		= 0x08,
+	MAX77693_HAPTIC_REG_CONFIG_PER4		= 0x09,
+	MAX77693_HAPTIC_REG_CONFIG_DUTY1	= 0x0A,
+	MAX77693_HAPTIC_REG_CONFIG_DUTY2	= 0x0B,
+	MAX77693_HAPTIC_REG_CONFIG_PWM1		= 0x0C,
+	MAX77693_HAPTIC_REG_CONFIG_PWM2		= 0x0D,
+	MAX77693_HAPTIC_REG_CONFIG_PWM3		= 0x0E,
+	MAX77693_HAPTIC_REG_CONFIG_PWM4		= 0x0F,
+	MAX77693_HAPTIC_REG_REV			= 0x10,
+
+	MAX77693_HAPTIC_REG_END,
+};
+
+enum max77693_irq_source {
+	LED_INT = 0,
+	TOPSYS_INT,
+	CHG_INT,
+	MUIC_INT1,
+	MUIC_INT2,
+	MUIC_INT3,
+
+	MAX77693_IRQ_GROUP_NR,
+};
+
+enum max77693_irq {
+	/* PMIC - FLASH */
+	MAX77693_LED_IRQ_FLED2_OPEN,
+	MAX77693_LED_IRQ_FLED2_SHORT,
+	MAX77693_LED_IRQ_FLED1_OPEN,
+	MAX77693_LED_IRQ_FLED1_SHORT,
+	MAX77693_LED_IRQ_MAX_FLASH,
+
+	/* PMIC - TOPSYS */
+	MAX77693_TOPSYS_IRQ_T120C_INT,
+	MAX77693_TOPSYS_IRQ_T140C_INT,
+	MAX77693_TOPSYS_IRQ_LOWSYS_INT,
+
+	/* PMIC - Charger */
+	MAX77693_CHG_IRQ_BYP_I,
+	MAX77693_CHG_IRQ_THM_I,
+	MAX77693_CHG_IRQ_BAT_I,
+	MAX77693_CHG_IRQ_CHG_I,
+	MAX77693_CHG_IRQ_CHGIN_I,
+
+	/* MUIC INT1 */
+	MAX77693_MUIC_IRQ_INT1_ADC,
+	MAX77693_MUIC_IRQ_INT1_ADC_LOW,
+	MAX77693_MUIC_IRQ_INT1_ADC_ERR,
+	MAX77693_MUIC_IRQ_INT1_ADC1K,
+
+	/* MUIC INT2 */
+	MAX77693_MUIC_IRQ_INT2_CHGTYP,
+	MAX77693_MUIC_IRQ_INT2_CHGDETREUN,
+	MAX77693_MUIC_IRQ_INT2_DCDTMR,
+	MAX77693_MUIC_IRQ_INT2_DXOVP,
+	MAX77693_MUIC_IRQ_INT2_VBVOLT,
+	MAX77693_MUIC_IRQ_INT2_VIDRM,
+
+	/* MUIC INT3 */
+	MAX77693_MUIC_IRQ_INT3_EOC,
+	MAX77693_MUIC_IRQ_INT3_CGMBC,
+	MAX77693_MUIC_IRQ_INT3_OVP,
+	MAX77693_MUIC_IRQ_INT3_MBCCHG_ERR,
+	MAX77693_MUIC_IRQ_INT3_CHG_ENABLED,
+	MAX77693_MUIC_IRQ_INT3_BAT_DET,
+
+	MAX77693_IRQ_NR,
+};
+
+struct max77693_dev {
+	struct device *dev;
+	struct i2c_client *i2c;		/* 0xCC , PMIC, Charger, Flash LED */
+	struct i2c_client *muic;	/* 0x4A , MUIC */
+	struct i2c_client *haptic;	/* 0x90 , Haptic */
+	struct mutex iolock;
+
+	int type;
+
+	struct regmap *regmap;
+	struct regmap *regmap_muic;
+	struct regmap *regmap_haptic;
+
+	int irq;
+	bool wakeup;
+};
+
+enum max77693_types {
+	TYPE_MAX77693,
+};
+
+extern int max77693_read_reg(struct regmap *map, u8 reg, u8 *dest);
+extern int max77693_bulk_read(struct regmap *map, u8 reg, int count,
+				u8 *buf);
+extern int max77693_write_reg(struct regmap *map, u8 reg, u8 value);
+extern int max77693_bulk_write(struct regmap *map, u8 reg, int count,
+				u8 *buf);
+extern int max77693_update_reg(struct regmap *map, u8 reg, u8 val, u8 mask);
+
+#endif /*  __LINUX_MFD_MAX77693_PRIV_H */
diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
new file mode 100644
index 0000000..5020b86
--- /dev/null
+++ b/include/linux/mfd/max77693.h
@@ -0,0 +1,37 @@
+/*
+ * max77693.h - Driver for the Maxim 77693
+ *
+ *  Copyright (C) 2012 Samsung Electrnoics
+ *  SangYoung Son <hello.son@samsung.com>
+ *
+ * This program is not provided / owned by Maxim Integrated Products.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * This driver is based on max8997.h
+ *
+ * MAX77693 has PMIC, Charger, Flash LED, Haptic, MUIC devices.
+ * The devices share the same I2C bus and included in
+ * this mfd driver.
+ */
+
+#ifndef __LINUX_MFD_MAX77693_H
+#define __LINUX_MFD_MAX77693_H
+
+struct max77693_platform_data {
+	/* IRQ */
+	int wakeup;
+};
+#endif	/* __LINUX_MFD_MAX77693_H */
-- 
1.7.0.4

