Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2ADJWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 04:22:25 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3202 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab2ADJWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 04:22:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 04 Jan 2012 01:22:20 -0800
From: Laxman Dewangan <ldewangan.com@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1] TPS62360: Add tps62360 regulator driver
Date: Wed,  4 Jan 2012 14:50:18 +0530
Message-Id: <1325668818-1096-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laxman Dewangan <ldewangan@nvidia.com>

The regulator module consists of 1 DCDC. The output voltage
is configurable and is meant for supply power to the core
voltage of Soc.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Change-Id: I93739aad865401047738f899b2248f2714d824ea
---
 drivers/regulator/Kconfig              |    9 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/tps62360-regulator.c |  440 ++++++++++++++++++++++++++++++++
 include/linux/regulator/tps62360.h     |   50 ++++
 4 files changed, 500 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/tps62360-regulator.c
 create mode 100644 include/linux/regulator/tps62360.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 7a61b17..b865674 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -328,6 +328,15 @@ config REGULATOR_TPS65910
 	help
 	  This driver supports TPS65910 voltage regulator chips.
 
+config REGULATOR_TPS62360
+	tristate "TI TPS62360 Power Regulator"
+	depends on I2C
+	help
+	  This driver supports TPS62360 voltage regulator chip. This
+	  regulator is meant for processor core supply. This chip is
+	  high-frequency synchronous step down dc-dc converter optimized
+	  for battery-powered portable applications.
+
 config REGULATOR_AAT2870
 	tristate "AnalogicTech AAT2870 Regulators"
 	depends on MFD_AAT2870_CORE
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 503bac8..1668b2e 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
 obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
 obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
+obj-$(CONFIG_REGULATOR_TPS62360) += tps62360-regulator.o
 obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
new file mode 100644
index 0000000..41dfc47
--- /dev/null
+++ b/drivers/regulator/tps62360-regulator.c
@@ -0,0 +1,440 @@
+/*
+ * tps62360.c -- TI tps62360
+ *
+ * Driver for processor core supply tps62360 and tps62361B
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
+ *
+ * Author: Laxman Dewangan <ldewangan@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307, USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/tps62360.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+
+/* Register definitions */
+#define REG_VSET0		0
+#define REG_VSET1		1
+#define REG_VSET2		2
+#define REG_VSET3		3
+#define REG_CONTROL		4
+#define REG_TEMP		5
+#define REG_RAMPCTRL		6
+#define REG_CHIPID		8
+
+enum chips {TPS62360, TPS62361};
+
+/* Supported voltage values for regulators */
+static const u16 TPS62360_VOLTAGES[] = {
+	 770,  780,  790,  800,  810,  820,  830,  840,  850,  860,
+	 870,  880,  890,  900,  910,  920,  930,  940,  950,  960,
+	 970,  980,  990, 1000, 1010, 1020, 1030, 1040, 1050, 1060,
+	1070, 1080, 1090, 1110, 1110, 1120, 1130, 1140, 1150, 1160,
+	1170, 1180, 1190, 1200, 1210, 1220, 1230, 1240, 1250, 1260,
+	1270, 1280, 1290, 1300, 1310, 1320, 1330, 1340, 1350, 1360,
+	1370, 1380, 1390, 1400,
+};
+
+static const u16 TPS62361_VOLTAGES[] = {
+	 500,  510,  520,  530,  540,  550,  560,  570,  580,  590,
+	 600,  610,  620,  630,  640,  650,  660,  670,  680,  690,
+	 700,  710,  720,  730,  740,  750,  760,  770,  780,  790,
+	 800,  810,  820,  830,  840,  850,  860,  870,  880,  890,
+	 900,  910,  920,  930,  940,  950,  960,  970,  980,  990,
+	1000, 1010, 1020, 1030, 1040, 1050, 1060, 1070, 1080, 1090,
+	1110, 1110, 1120, 1130, 1140, 1150, 1160, 1170, 1180, 1190,
+	1200, 1210, 1220, 1230, 1240, 1250, 1260, 1270, 1280, 1290,
+	1300, 1310, 1320, 1330, 1340, 1350, 1360, 1370, 1380, 1390,
+	1400, 1410, 1420, 1430, 1440, 1450, 1460, 1470, 1480, 1490,
+	1500, 1510, 1520, 1530, 1540, 1550, 1560, 1570, 1580, 1590,
+	1600, 1610, 1620, 1630, 1640, 1650, 1660, 1670, 1680, 1690,
+	1700, 1710, 1720, 1730, 1740, 1750, 1760, 1770,
+};
+
+/* tps 62360 chip information */
+struct tps62360_chip {
+	const char *name;
+	struct device *dev;
+	struct regulator_desc desc;
+	struct i2c_client *client;
+	struct regulator_dev *rdev;
+	struct mutex io_lock;
+	unsigned int curr_uV;
+	int chip_id;
+	int vsel_id;
+	const u16 *voltages;
+	u8 voltage_reg_mask;
+	int cache_vset;
+	bool en_internal_pulldn;
+	bool en_force_pwm;
+	bool en_discharge;
+};
+static inline int tps62360_read(struct tps62360_chip *tps, u8 reg)
+{
+	return i2c_smbus_read_byte_data(tps->client, reg);
+}
+
+static inline int tps62360_write(struct tps62360_chip *tps, u8 reg, u8 val)
+{
+	return i2c_smbus_write_byte_data(tps->client, reg, val);
+}
+
+static int tps62360_reg_read(struct tps62360_chip *tps, u8 reg)
+{
+	int data;
+
+	mutex_lock(&tps->io_lock);
+
+	data = tps62360_read(tps, reg);
+	if (data < 0)
+		dev_err(tps->dev, "Read from reg 0x%x failed\n", reg);
+
+	mutex_unlock(&tps->io_lock);
+
+	return data;
+}
+
+static int tps62360_reg_write(struct tps62360_chip *tps, u8 reg, u8 val)
+{
+	int err;
+
+	mutex_lock(&tps->io_lock);
+
+	err = tps62360_write(tps, reg, val);
+	if (err < 0)
+		dev_err(tps->dev, "Write for reg 0x%x failed\n", reg);
+
+	mutex_unlock(&tps->io_lock);
+
+	return err;
+}
+
+static int tps62360_reg_modify_bits(struct tps62360_chip *tps, u8 reg,
+		u8 set_mask, u8 clear_mask)
+{
+	int err;
+	int data;
+
+	mutex_lock(&tps->io_lock);
+	data = tps62360_read(tps, reg);
+	if (data < 0) {
+		dev_err(tps->dev, "Read from reg 0x%x failed\n", reg);
+		err = data;
+		goto out;
+	}
+	data &= ~clear_mask;
+	data |= set_mask;
+
+	err = tps62360_write(tps, reg, data);
+	if (err < 0)
+		dev_err(tps->dev, "Write for reg 0x%x failed\n", reg);
+
+out:
+	mutex_unlock(&tps->io_lock);
+	return err;
+}
+
+static int tps62360_dcdc_is_enabled(struct regulator_dev *dev)
+{
+	/**
+	 * Always return 1 as the EN is not controlled by register
+	 * programming */
+	return 1;
+}
+
+static int tps62360_dcdc_enable(struct regulator_dev *dev)
+{
+	/* No way to enable dc-dc converter through register programming */
+	return 0;
+}
+
+static int tps62360_dcdc_disable(struct regulator_dev *dev)
+{
+	/* No way to disable dc-dc converter through register programming */
+	return 0;
+}
+
+static int tps62360_dcdc_get_voltage(struct regulator_dev *dev)
+{
+	struct tps62360_chip *tps = rdev_get_drvdata(dev);
+	int data;
+
+	data = tps->cache_vset;
+	data &= tps->voltage_reg_mask;
+	return tps->voltages[data] * 1000;
+}
+
+static int tps62360_dcdc_set_voltage(struct regulator_dev *dev,
+	     int min_uV, int max_uV, unsigned *selector)
+{
+	struct tps62360_chip *tps = rdev_get_drvdata(dev);
+	int vsel;
+	int data;
+	int ret;
+
+	if (max_uV < min_uV)
+		return -EINVAL;
+
+	if (min_uV > tps->voltages[tps->desc.n_voltages - 1] * 1000)
+		return -EINVAL;
+
+	if (max_uV < tps->voltages[0] * 1000)
+		return -EINVAL;
+
+	for (vsel = 0; vsel < tps->desc.n_voltages; ++vsel) {
+		int uV = tps->voltages[vsel] * 1000;
+		if (min_uV <= uV && uV <= max_uV) {
+			if (selector)
+				*selector = vsel;
+			data = (tps->cache_vset & ~tps->voltage_reg_mask) |
+						vsel;
+			ret = tps62360_reg_write(tps, REG_VSET0 + tps->vsel_id,
+					data);
+			if (ret < 0)
+				dev_err(tps->dev, "%s: Error in updating "
+					"register\n", __func__);
+			else
+				tps->cache_vset = data;
+			return ret;
+		}
+	}
+	return -EINVAL;
+}
+
+static int tps62360_dcdc_list_voltage(struct regulator_dev *dev,
+					unsigned selector)
+{
+	struct tps62360_chip *tps = rdev_get_drvdata(dev);
+
+	if ((selector < 0) || (selector >= tps->desc.n_voltages))
+		return -EINVAL;
+
+	return tps->voltages[selector] * 1000;
+}
+
+/* Operations permitted on VDCDCx */
+static struct regulator_ops tps62360_dcdc_ops = {
+	.is_enabled = tps62360_dcdc_is_enabled,
+	.enable = tps62360_dcdc_enable,
+	.disable = tps62360_dcdc_disable,
+	.get_voltage = tps62360_dcdc_get_voltage,
+	.set_voltage = tps62360_dcdc_set_voltage,
+	.list_voltage = tps62360_dcdc_list_voltage,
+};
+
+static int tps62360_init_dcdc(struct i2c_client *client,
+		struct tps62360_regulator_platform_data *pdata,
+		struct tps62360_chip *tps)
+{
+	int st;
+	int data;
+
+	/* Initailize internal pull up/down control */
+	if (tps->en_internal_pulldn)
+		st = tps62360_write(tps, REG_CONTROL, 0xE0);
+	else
+		st = tps62360_write(tps, REG_CONTROL, 0x0);
+	if (st < 0) {
+		dev_err(tps->dev, "%s() fails in writing reg %d\n",
+			__func__, REG_CONTROL);
+		return st;
+	}
+
+	/* Initialise force PWM mode */
+	data = tps62360_reg_read(tps, REG_VSET0 + tps->vsel_id);
+	if (data < 0) {
+		dev_err(tps->dev, "%s() fails in reading reg %d\n",
+			__func__, REG_VSET0 + tps->vsel_id);
+		return data;
+	}
+	if (pdata->en_force_pwm)
+		data |= BIT(7);
+	else
+		data &= ~BIT(7);
+	st = tps62360_reg_write(tps, REG_VSET0 + tps->vsel_id, data);
+	if (st < 0) {
+		dev_err(tps->dev, "%s() fails in writing reg %d\n",
+			__func__, REG_VSET0 + tps->vsel_id);
+		return st;
+	}
+	tps->cache_vset = data;
+
+	/* Reset output discharge path to reduce power consumption */
+	st = tps62360_reg_modify_bits(tps, REG_RAMPCTRL, 0, BIT(2));
+	if (st < 0)
+		dev_err(tps->dev, "%s() fails in updating reg %d\n",
+			__func__, REG_RAMPCTRL);
+	return st;
+}
+
+static int __devinit tps62360_probe(struct i2c_client *client,
+				     const struct i2c_device_id *id)
+{
+	struct tps62360_regulator_platform_data *pdata;
+	struct regulator_init_data *init_data;
+	struct regulator_dev *rdev;
+	struct tps62360_chip *tps;
+	int err;
+
+	if (!i2c_check_functionality(client->adapter,
+				I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_err(&client->dev, "%s() Err: The I2c functionality is"
+					" not supported\n", __func__);
+		return -EIO;
+	}
+
+	/**
+	 * init_data points to array of regulator_init structures
+	 * coming from the board-evm file.
+	 */
+	pdata = client->dev.platform_data;
+	if (!pdata) {
+		dev_err(&client->dev, "%s() Err: Platform data not found\n",
+						__func__);
+		return -EIO;
+	}
+
+	init_data = &pdata->reg_init_data;
+	tps = kzalloc(sizeof(*tps), GFP_KERNEL);
+	if (!tps) {
+		dev_err(&client->dev, "%s() Err: Memory allocation fails\n",
+						__func__);
+		return -ENOMEM;
+	}
+
+	mutex_init(&tps->io_lock);
+
+	tps->en_force_pwm = pdata->en_force_pwm;
+	tps->en_discharge = pdata->en_discharge;
+	tps->en_internal_pulldn = pdata->en_internal_pulldn;
+	tps->chip_id = id->driver_data;
+	tps->client = client;
+	tps->dev = &client->dev;
+	tps->vsel_id = pdata->vsel;
+	tps->name = id->name;
+	tps->voltages = (tps->chip_id == TPS62360) ?
+				TPS62360_VOLTAGES : TPS62361_VOLTAGES;
+	tps->voltage_reg_mask = (tps->chip_id == TPS62360) ? 0x3F : 0x7F;
+
+	tps->desc.name = id->name;
+	tps->desc.id = 0;
+	tps->desc.n_voltages = (tps->chip_id == TPS62360) ?
+				ARRAY_SIZE(TPS62360_VOLTAGES) :
+				ARRAY_SIZE(TPS62361_VOLTAGES);
+	tps->desc.ops = &tps62360_dcdc_ops;
+	tps->desc.type = REGULATOR_VOLTAGE;
+	tps->desc.owner = THIS_MODULE;
+
+	i2c_set_clientdata(client, tps);
+
+	err = tps62360_init_dcdc(client, pdata, tps);
+	if (err < 0) {
+		dev_err(tps->dev, "%s() TPS6236X init fails with = %d\n",
+				__func__, err);
+		goto fail;
+	}
+
+	/* Register the regulators */
+	rdev = regulator_register(&tps->desc, &client->dev,
+			init_data, tps, NULL);
+	if (IS_ERR(rdev)) {
+		dev_err(tps->dev, "%s() Failed to register %s\n",
+				__func__, id->name);
+		err = PTR_ERR(rdev);
+		goto fail;
+	}
+
+	tps->rdev = rdev;
+	return 0;
+fail:
+	kfree(tps);
+	return err;
+}
+
+/**
+ * tps62360_remove - tps6236x driver i2c remove handler
+ * @client: i2c driver client device structure
+ *
+ * Unregister TPS driver as an i2c client device driver
+ */
+static int __devexit tps62360_remove(struct i2c_client *client)
+{
+	struct tps62360_chip *tps = i2c_get_clientdata(client);
+
+	regulator_unregister(tps->rdev);
+	kfree(tps);
+	return 0;
+}
+
+static void tps62360_shutdown(struct i2c_client *client)
+{
+	struct tps62360_chip *tps = i2c_get_clientdata(client);
+	int st;
+
+	if (!tps->en_discharge)
+		return;
+
+	/* Configure the output discharge path */
+	st = tps62360_reg_modify_bits(tps, REG_RAMPCTRL, BIT(2), BIT(2));
+	if (st < 0)
+		dev_err(tps->dev, "%s() fails in updating reg %d\n",
+			__func__, REG_RAMPCTRL);
+}
+
+static const struct i2c_device_id tps62360_id[] = {
+	{.name = "tps62360", .driver_data = TPS62360},
+	{.name = "tps62361", .driver_data = TPS62361},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, tps62360_id);
+
+static struct i2c_driver tps62360_i2c_driver = {
+	.driver = {
+		.name = "tps62360",
+		.owner = THIS_MODULE,
+	},
+	.probe = tps62360_probe,
+	.remove = __devexit_p(tps62360_remove),
+	.shutdown = tps62360_shutdown,
+	.id_table = tps62360_id,
+};
+
+static int __init tps62360_init(void)
+{
+	return i2c_add_driver(&tps62360_i2c_driver);
+}
+subsys_initcall(tps62360_init);
+
+static void __exit tps62360_cleanup(void)
+{
+	i2c_del_driver(&tps62360_i2c_driver);
+}
+module_exit(tps62360_cleanup);
+
+MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
+MODULE_DESCRIPTION("TPS62360 voltage regulator driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:tps62360");
diff --git a/include/linux/regulator/tps62360.h b/include/linux/regulator/tps62360.h
new file mode 100644
index 0000000..bc397c0
--- /dev/null
+++ b/include/linux/regulator/tps62360.h
@@ -0,0 +1,50 @@
+/*
+ * tps62360.h -- TI tps62360
+ *
+ * Interface for regulator driver for TI TPS62360 Processor core supply
+ *
+ * Copyright (C) 2012 NVIDIA Corporation
+
+ * Author: Laxman Dewangan <ldewangan@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA	02110-1301, USA.
+ *
+ */
+
+#ifndef __LINUX_REGULATOR_TPS62360_H
+#define __LINUX_REGULATOR_TPS62360_H
+
+#include <linux/regulator/machine.h>
+
+/*
+ * struct tps62360_regulator_platform_data - tps62360 regulator platform data.
+ *
+ * @reg_init_data: The regulator init data.
+ * @en_force_pwm: Enable force pwm or not.
+ * @en_discharge: Enable discharge the output capacitor via a typ. 300Ohm path
+ * @en_internal_pulldn: internal pull down enable or not.
+ * @vsel: Select the voltage id register.
+ * @init_uV: initial micro volts which need to be set.
+ */
+
+struct tps62360_regulator_platform_data {
+	struct regulator_init_data reg_init_data;
+	bool en_force_pwm;
+	bool en_discharge;
+	bool en_internal_pulldn;
+	int vsel;
+};
+
+#endif /* __LINUX_REGULATOR_TPS62360_H */
-- 
1.7.1.1

