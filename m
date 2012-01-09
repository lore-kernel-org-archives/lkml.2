Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab2AIPAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:00:49 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9825 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab2AIPAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:00:47 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Jan 2012 07:00:46 -0800
From: Laxman Dewangan <ldewangan.com@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V4] regulator: TPS62360: Add tps62360 regulator driver
Date: Mon,  9 Jan 2012 20:27:41 +0530
Message-Id: <1326121061-23647-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laxman Dewangan <ldewangan@nvidia.com>

The regulator module consists of 1 DCDC. The output voltage
is configurable and is meant for supply power to the core
voltage of Soc.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Main changes from patch V1:
 1. Used the euation for voltage selection in place of lookup table.
 2. Used regmap inplace of direct i2c api for register access.
 3. Removed unimplmented function.
 4. Used devm_kzalloc()
 
Change from patch V2:
 Added regmap_exit in failing path.

Change from V3:
 1. Gpios for VSEL0 and VSEL1 is provided through platform data.
 2. The VSET register selection is done throgh the LRU mechanism
    for configuring the voltage register.
 3. Gpio apis will be used to select proper voltage register to
    output voltage.


 drivers/regulator/Kconfig              |   10 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/tps62360-regulator.c |  472 ++++++++++++++++++++++++++++++++
 include/linux/regulator/tps62360.h     |   57 ++++
 4 files changed, 540 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/tps62360-regulator.c
 create mode 100644 include/linux/regulator/tps62360.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 7a61b17..b9ad3d8 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -328,6 +328,16 @@ config REGULATOR_TPS65910
 	help
 	  This driver supports TPS65910 voltage regulator chips.
 
+config REGULATOR_TPS62360
+	tristate "TI TPS62360 Power Regulator"
+	depends on I2C
+	select REGMAP_I2C
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
index 0000000..f778ef0
--- /dev/null
+++ b/drivers/regulator/tps62360-regulator.c
@@ -0,0 +1,472 @@
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
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/regmap.h>
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
+#define TPS62360_BASE_VOLTAGE	770
+#define TPS62360_N_VOLTAGES	64
+
+#define TPS62361_BASE_VOLTAGE	500
+#define TPS62361_N_VOLTAGES	128
+
+/* tps 62360 chip information */
+struct tps62360_chip {
+	const char *name;
+	struct device *dev;
+	struct regulator_desc desc;
+	struct i2c_client *client;
+	struct regulator_dev *rdev;
+	struct regmap *regmap;
+	int chip_id;
+	int vsel0_gpio;
+	int vsel1_gpio;
+	int voltage_base;
+	u8 voltage_reg_mask;
+	bool en_internal_pulldn;
+	bool en_force_pwm;
+	bool en_discharge;
+	bool valid_gpios;
+	int lru_index[4];
+	int curr_vset_vsel[4];
+	int curr_vset_id;
+};
+
+/*
+ * find_voltage_set_register: Find new voltage configuration register
+ * (VSET) id.
+ * The finding of the new VSET register will be based on the LRU mechanism.
+ * Each VSET register will have different voltage configured . This
+ * Function will look if any of the VSET register have requested voltage set
+ * or not.
+ *     - If it is already there then it will make that register as most
+ *       recently used and return as found so that caller need not to set
+ *       the VSET register but need to set the proper gpios to select this
+ *       VSET register.
+ *     - If requested voltage is not found then it will use the least
+ *       recently mechanism to get new VSET register for new configuration
+ *       and will return not_found so that caller need to set new VSET
+ *       register and then gpios (both).
+ */
+static bool find_voltage_set_register(struct tps62360_chip *tps,
+		int req_vsel, int *vset_reg_id)
+{
+	int i;
+	bool found = false;
+	int new_vset_reg = tps->lru_index[3];
+	int found_index = 3;
+	for (i = 0; i < 4; ++i) {
+		if (tps->curr_vset_vsel[tps->lru_index[i]] == req_vsel) {
+			new_vset_reg = tps->lru_index[i];
+			found_index = i;
+			found = true;
+			goto update_lru_index;
+		}
+	}
+
+update_lru_index:
+	for (i = found_index; i > 0; i--)
+		tps->lru_index[i] = tps->lru_index[i - 1];
+
+	tps->lru_index[0] = new_vset_reg;
+	*vset_reg_id = new_vset_reg;
+	return found;
+}
+
+static int tps62360_dcdc_get_voltage(struct regulator_dev *dev)
+{
+	struct tps62360_chip *tps = rdev_get_drvdata(dev);
+	int vsel;
+	unsigned int data;
+	int ret;
+
+	ret = regmap_read(tps->regmap, REG_VSET0 + tps->curr_vset_id, &data);
+	if (ret < 0) {
+		dev_err(tps->dev, "%s: Error in reading register %d\n",
+			__func__, REG_VSET0 + tps->curr_vset_id);
+		return ret;
+	}
+	vsel = (int)data & tps->voltage_reg_mask;
+	return (tps->voltage_base + vsel * 10) * 1000;
+}
+
+static int tps62360_dcdc_set_voltage(struct regulator_dev *dev,
+	     int min_uV, int max_uV, unsigned *selector)
+{
+	struct tps62360_chip *tps = rdev_get_drvdata(dev);
+	int vsel;
+	int ret;
+	bool found = false;
+	int new_vset_id = tps->curr_vset_id;
+
+	if (max_uV < min_uV)
+		return -EINVAL;
+
+	if (min_uV >
+		((tps->voltage_base + (tps->desc.n_voltages - 1) * 10) * 1000))
+		return -EINVAL;
+
+	if (max_uV < tps->voltage_base * 1000)
+		return -EINVAL;
+
+	vsel = DIV_ROUND_UP(min_uV - (tps->voltage_base * 1000), 10000);
+	if (selector)
+		*selector = (vsel & tps->voltage_reg_mask);
+
+	/*
+	 * If gpios are available to select the VSET register then least
+	 * recently used register for new configuration.
+	 */
+	if (tps->valid_gpios)
+		found = find_voltage_set_register(tps, vsel, &new_vset_id);
+
+	if (!found) {
+		ret = regmap_update_bits(tps->regmap, REG_VSET0 + new_vset_id,
+				tps->voltage_reg_mask, vsel);
+		if (ret < 0) {
+			dev_err(tps->dev, "%s: Error in updating register %d\n",
+				 __func__, REG_VSET0 + new_vset_id);
+			return ret;
+		}
+		tps->curr_vset_id = new_vset_id;
+		tps->curr_vset_vsel[new_vset_id] = vsel;
+	}
+
+	/* Select proper VSET register vio gpios */
+	if (tps->valid_gpios) {
+		gpio_set_value_cansleep(tps->vsel0_gpio,
+					new_vset_id & 0x1);
+		gpio_set_value_cansleep(tps->vsel1_gpio,
+					(new_vset_id >> 1) & 0x1);
+	}
+	return 0;
+}
+
+static int tps62360_dcdc_list_voltage(struct regulator_dev *dev,
+					unsigned selector)
+{
+	struct tps62360_chip *tps = rdev_get_drvdata(dev);
+
+	if ((selector < 0) || (selector >= tps->desc.n_voltages))
+		return -EINVAL;
+	return (tps->voltage_base + selector * 10) * 1000;
+}
+
+static struct regulator_ops tps62360_dcdc_ops = {
+	.get_voltage = tps62360_dcdc_get_voltage,
+	.set_voltage = tps62360_dcdc_set_voltage,
+	.list_voltage = tps62360_dcdc_list_voltage,
+};
+
+static int tps62360_init_force_pwm(struct tps62360_chip *tps,
+	struct tps62360_regulator_platform_data *pdata,
+	int vset_id)
+{
+	unsigned int data;
+	int ret;
+	ret = regmap_read(tps->regmap, REG_VSET0 + vset_id, &data);
+	if (ret < 0) {
+		dev_err(tps->dev, "%s() fails in writing reg %d\n",
+			__func__, REG_VSET0 + vset_id);
+		return ret;
+	}
+	tps->curr_vset_vsel[vset_id] = data & tps->voltage_reg_mask;
+	if (pdata->en_force_pwm)
+		data |= BIT(7);
+	else
+		data &= ~BIT(7);
+	ret = regmap_write(tps->regmap, REG_VSET0 + vset_id, data);
+	if (ret < 0)
+		dev_err(tps->dev, "%s() fails in writing reg %d\n",
+				__func__, REG_VSET0 + vset_id);
+	return ret;
+}
+
+static int tps62360_init_dcdc(struct tps62360_chip *tps,
+		struct tps62360_regulator_platform_data *pdata)
+{
+	int ret;
+	int i;
+
+	/* Initailize internal pull up/down control */
+	if (tps->en_internal_pulldn)
+		ret = regmap_write(tps->regmap, REG_CONTROL, 0xE0);
+	else
+		ret = regmap_write(tps->regmap, REG_CONTROL, 0x0);
+	if (ret < 0) {
+		dev_err(tps->dev, "%s() fails in writing reg %d\n",
+			__func__, REG_CONTROL);
+		return ret;
+	}
+
+	/* Initailize force PWM mode */
+	if (tps->valid_gpios) {
+		for (i = 0; i < 4; ++i) {
+			ret = tps62360_init_force_pwm(tps, pdata, i);
+			if (ret < 0)
+				return ret;
+		}
+	} else {
+		ret = tps62360_init_force_pwm(tps, pdata, tps->curr_vset_id);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* Reset output discharge path to reduce power consumption */
+	ret = regmap_update_bits(tps->regmap, REG_RAMPCTRL, BIT(2), 0);
+	if (ret < 0)
+		dev_err(tps->dev, "%s() fails in updating reg %d\n",
+			__func__, REG_RAMPCTRL);
+	return ret;
+}
+
+static const struct regmap_config tps62360_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int __devinit tps62360_probe(struct i2c_client *client,
+				     const struct i2c_device_id *id)
+{
+	struct tps62360_regulator_platform_data *pdata;
+	struct regulator_dev *rdev;
+	struct tps62360_chip *tps;
+	int ret;
+	int i;
+
+	pdata = client->dev.platform_data;
+	if (!pdata) {
+		dev_err(&client->dev, "%s() Err: Platform data not found\n",
+						__func__);
+		return -EIO;
+	}
+
+	tps = devm_kzalloc(&client->dev, sizeof(*tps), GFP_KERNEL);
+	if (!tps) {
+		dev_err(&client->dev, "%s() Err: Memory allocation fails\n",
+						__func__);
+		return -ENOMEM;
+	}
+
+	tps->en_force_pwm = pdata->en_force_pwm;
+	tps->en_discharge = pdata->en_discharge;
+	tps->en_internal_pulldn = pdata->en_internal_pulldn;
+	tps->vsel0_gpio = pdata->vsel0_gpio;
+	tps->vsel1_gpio = pdata->vsel1_gpio;
+	tps->client = client;
+	tps->dev = &client->dev;
+	tps->name = id->name;
+	tps->voltage_base = (id->driver_data == TPS62360) ?
+				TPS62360_BASE_VOLTAGE : TPS62361_BASE_VOLTAGE;
+	tps->voltage_reg_mask = (id->driver_data == TPS62360) ? 0x3F : 0x7F;
+
+	tps->desc.name = id->name;
+	tps->desc.id = 0;
+	tps->desc.n_voltages = (id->driver_data == TPS62360) ?
+				TPS62360_N_VOLTAGES : TPS62361_N_VOLTAGES;
+	tps->desc.ops = &tps62360_dcdc_ops;
+	tps->desc.type = REGULATOR_VOLTAGE;
+	tps->desc.owner = THIS_MODULE;
+	tps->regmap = regmap_init_i2c(client, &tps62360_regmap_config);
+	if (IS_ERR(tps->regmap)) {
+		ret = PTR_ERR(tps->regmap);
+		dev_err(&client->dev, "%s() Err: Failed to allocate register"
+			"map: %d\n", __func__, ret);
+		return ret;
+	}
+	i2c_set_clientdata(client, tps);
+
+	tps->curr_vset_id = (pdata->vsel1_def_state & 1) * 2 +
+				(pdata->vsel0_def_state & 1);
+	tps->lru_index[0] = tps->curr_vset_id;
+	tps->valid_gpios = false;
+
+	if (gpio_is_valid(tps->vsel0_gpio) && gpio_is_valid(tps->vsel1_gpio)) {
+		ret = gpio_request(tps->vsel0_gpio, "tps62360-vsel0");
+		if (ret) {
+			dev_err(&client->dev,
+				"Err: Could not obtain vsel0 GPIO %d: %d\n",
+						tps->vsel0_gpio, ret);
+			goto err_gpio0;
+		}
+		ret = gpio_direction_output(tps->vsel0_gpio,
+					pdata->vsel0_def_state);
+		if (ret) {
+			dev_err(&client->dev, "Err: Could not set direction of"
+				"vsel0 GPIO %d: %d\n", tps->vsel0_gpio, ret);
+			gpio_free(tps->vsel0_gpio);
+			goto err_gpio0;
+		}
+
+		ret = gpio_request(tps->vsel1_gpio, "tps62360-vsel1");
+		if (ret) {
+			dev_err(&client->dev,
+				"Err: Could not obtain vsel1 GPIO %d: %d\n",
+						tps->vsel1_gpio, ret);
+			goto err_gpio1;
+		}
+		ret = gpio_direction_output(tps->vsel1_gpio,
+					pdata->vsel1_def_state);
+		if (ret) {
+			dev_err(&client->dev, "Err: Could not set direction of"
+				"vsel1 GPIO %d: %d\n", tps->vsel1_gpio, ret);
+			gpio_free(tps->vsel1_gpio);
+			goto err_gpio1;
+		}
+		tps->valid_gpios = true;
+
+		/*
+		 * Initialize the lru index with vset_reg id
+		 * The index 0 will be most recently used and
+		 * set with the tps->curr_vset_id */
+		for (i = 0; i < 4; ++i)
+			tps->lru_index[i] = i;
+		tps->lru_index[0] = tps->curr_vset_id;
+		tps->lru_index[tps->curr_vset_id] = 0;
+	}
+
+	ret = tps62360_init_dcdc(tps, pdata);
+	if (ret < 0) {
+		dev_err(tps->dev, "%s() Err: Init fails with = %d\n",
+				__func__, ret);
+		goto err_init;
+	}
+
+	/* Register the regulators */
+	rdev = regulator_register(&tps->desc, &client->dev,
+				&pdata->reg_init_data, tps, NULL);
+	if (IS_ERR(rdev)) {
+		dev_err(tps->dev, "%s() Err: Failed to register %s\n",
+				__func__, id->name);
+		ret = PTR_ERR(rdev);
+		goto err_init;
+	}
+
+	tps->rdev = rdev;
+	return 0;
+
+err_init:
+	if (gpio_is_valid(tps->vsel1_gpio))
+		gpio_free(tps->vsel1_gpio);
+err_gpio1:
+	if (gpio_is_valid(tps->vsel0_gpio))
+		gpio_free(tps->vsel0_gpio);
+err_gpio0:
+	regmap_exit(tps->regmap);
+	return ret;
+}
+
+/**
+ * tps62360_remove - tps62360 driver i2c remove handler
+ * @client: i2c driver client device structure
+ *
+ * Unregister TPS driver as an i2c client device driver
+ */
+static int __devexit tps62360_remove(struct i2c_client *client)
+{
+	struct tps62360_chip *tps = i2c_get_clientdata(client);
+
+	if (gpio_is_valid(tps->vsel1_gpio))
+		gpio_free(tps->vsel1_gpio);
+
+	if (gpio_is_valid(tps->vsel0_gpio))
+		gpio_free(tps->vsel0_gpio);
+
+	regulator_unregister(tps->rdev);
+	regmap_exit(tps->regmap);
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
+	st = regmap_update_bits(tps->regmap, REG_RAMPCTRL, BIT(2), BIT(2));
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
diff --git a/include/linux/regulator/tps62360.h b/include/linux/regulator/tps62360.h
new file mode 100644
index 0000000..6a5c1b2
--- /dev/null
+++ b/include/linux/regulator/tps62360.h
@@ -0,0 +1,57 @@
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
+ * @en_discharge: Enable discharge the output capacitor via internal
+ *                register.
+ * @en_internal_pulldn: internal pull down enable or not.
+ * @vsel0_gpio: Gpio number for vsel0. It should be -1 if this is tied with
+ *              fixed logic.
+ * @vsel1_gpio: Gpio number for vsel1. It should be -1 if this is tied with
+ *              fixed logic.
+ * @vsel0_def_state: Default state of vsel0. 1 if it is high else 0.
+ * @vsel1_def_state: Default state of vsel1. 1 if it is high else 0.
+ */
+struct tps62360_regulator_platform_data {
+	struct regulator_init_data reg_init_data;
+	bool en_force_pwm;
+	bool en_discharge;
+	bool en_internal_pulldn;
+	int vsel0_gpio;
+	int vsel1_gpio;
+	int vsel0_def_state;
+	int vsel1_def_state;
+};
+
+#endif /* __LINUX_REGULATOR_TPS62360_H */
-- 
1.7.1.1

