Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab1ANG5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 01:57:01 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:21108 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab1ANG4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 01:56:36 -0500
Date: Fri, 14 Jan 2011 15:53:38 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 2/2] MAX8997/8966 PMIC Regulator Driver Initial Release
In-reply-to: <1294988018-25100-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Message-id: <1294988018-25100-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
References: <1294988018-25100-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 14 Jan 2011 06:53:39.0170 (UTC)
 FILETIME=[C5F44C20:01CBB3B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports PMIC/Regulator part of MAX8997/MAX8966 MFD.
In this initial release, selecting voltages or current-limit
and switching on/off the regulators are supported.

Controlling voltages for DVS with GPIOs is not implemented fully
and requires more considerations: it controls multiple bucks (selection
of 1, 2, and 5) at the same time with SET1~3 gpios. Thus, when DVS-GPIO
is activated, we lose the ability to control the voltage of a single
buck regulator independently; i.e., contolling a buck affects other two
bucks. Therefore, using the conventional regulator framework directly
might be problematic.

On the other hand, controlling all the three bucks simultenously based
on the voltage set table may help build cpufreq and similar system
more robust; i.e., all the three voltages are consistent every time without
glitches during transition.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/Kconfig   |    9 +
 drivers/regulator/Makefile  |    1 +
 drivers/regulator/max8997.c |  867 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8997.h |   20 +-
 4 files changed, 896 insertions(+), 1 deletions(-)
 create mode 100644 drivers/regulator/max8997.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index dd30e88..2c96bcd 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -108,6 +108,15 @@ config REGULATOR_MAX8952
 	  via I2C bus. Maxim 8952 has one voltage output and supports 4 DVS
 	  modes ranging from 0.77V to 1.40V by 0.01V steps.
 
+config REGULATOR_MAX8997
+	tristate "Maxim 8997/8966 regulator"
+	depends on MFD_MAX8997
+	help
+	  This driver controls a Maxim 8997/8966 regulator
+	  via I2C bus. The provided regulator is suitable for S5PC110,
+	  S5PV210, S5PC210,and S5PV310 chips to control VCC_CORE and
+	  VCC_USIM voltages.
+
 config REGULATOR_MAX8998
 	tristate "Maxim 8998 voltage regulator"
 	depends on MFD_MAX8998
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index bff8157..0610693 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_REGULATOR_MAX8649)	+= max8649.o
 obj-$(CONFIG_REGULATOR_MAX8660) += max8660.o
 obj-$(CONFIG_REGULATOR_MAX8925) += max8925-regulator.o
 obj-$(CONFIG_REGULATOR_MAX8952) += max8952.o
+obj-$(CONFIG_REGULATOR_MAX8997) += max8997.o
 obj-$(CONFIG_REGULATOR_MAX8998) += max8998.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-dcdc.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-isink.o
diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
new file mode 100644
index 0000000..449432b
--- /dev/null
+++ b/drivers/regulator/max8997.c
@@ -0,0 +1,867 @@
+/*
+ * max8997.c - Regulator driver for the Maxim 8997/8966
+ *
+ * Copyright (C) 2011 Samsung Electronics
+ * MyungJoo Ham <myungjoo.ham@smasung.com>
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
+ * This driver is based on max8998.c
+ */
+
+
+#include <linux/bug.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/mfd/max8997.h>
+#include <linux/mfd/max8997-private.h>
+
+struct max8997_data {
+	struct device *dev;
+	struct max8997_dev *iodev;
+	int num_regulators;
+	struct regulator_dev **rdev;
+
+	u8 buck1_vol[8];
+	u8 buck2_vol[8];
+	u8 buck5_vol[8];
+	int buck125_gpioindex;
+};
+
+struct voltage_map_desc {
+	int min;
+	int max;
+	int step;
+	unsigned int n_bits;
+};
+
+/* Voltage maps in mV */
+static const struct voltage_map_desc ldo_voltage_map_desc = {
+	.min = 800,	.max = 3950,	.step = 50,	.n_bits = 6,
+}; /* LDO1 ~ 18, 21 all */
+
+static const struct voltage_map_desc buck1245_voltage_map_desc = {
+	.min = 650,	.max = 2225,	.step = 25,	.n_bits = 6,
+}; /* Buck1, 2, 4, 5 */
+
+static const struct voltage_map_desc buck37_voltage_map_desc = {
+	.min = 750,	.max = 3900,	.step = 50,	.n_bits = 6,
+}; /* Buck3, 7 */
+
+/* current map in mA */
+static const struct voltage_map_desc charger_current_map_desc = {
+	.min = 200,	.max = 950,	.step = 50,	.n_bits = 4,
+};
+
+static const struct voltage_map_desc topoff_current_map_desc = {
+	.min = 50,	.max = 200,	.step = 10,	.n_bits = 4,
+};
+
+static const struct voltage_map_desc *reg_voltage_map[] = {
+	[MAX8997_LDO1] = &ldo_voltage_map_desc,
+	[MAX8997_LDO2] = &ldo_voltage_map_desc,
+	[MAX8997_LDO3] = &ldo_voltage_map_desc,
+	[MAX8997_LDO4] = &ldo_voltage_map_desc,
+	[MAX8997_LDO5] = &ldo_voltage_map_desc,
+	[MAX8997_LDO6] = &ldo_voltage_map_desc,
+	[MAX8997_LDO7] = &ldo_voltage_map_desc,
+	[MAX8997_LDO8] = &ldo_voltage_map_desc,
+	[MAX8997_LDO9] = &ldo_voltage_map_desc,
+	[MAX8997_LDO10] = &ldo_voltage_map_desc,
+	[MAX8997_LDO11] = &ldo_voltage_map_desc,
+	[MAX8997_LDO12] = &ldo_voltage_map_desc,
+	[MAX8997_LDO13] = &ldo_voltage_map_desc,
+	[MAX8997_LDO14] = &ldo_voltage_map_desc,
+	[MAX8997_LDO15] = &ldo_voltage_map_desc,
+	[MAX8997_LDO16] = &ldo_voltage_map_desc,
+	[MAX8997_LDO17] = &ldo_voltage_map_desc,
+	[MAX8997_LDO18] = &ldo_voltage_map_desc,
+	[MAX8997_LDO21] = &ldo_voltage_map_desc,
+	[MAX8997_BUCK1] = &buck1245_voltage_map_desc,
+	[MAX8997_BUCK2] = &buck1245_voltage_map_desc,
+	[MAX8997_BUCK3] = &buck37_voltage_map_desc,
+	[MAX8997_BUCK4] = &buck1245_voltage_map_desc,
+	[MAX8997_BUCK5] = &buck1245_voltage_map_desc,
+	[MAX8997_BUCK6] = NULL,
+	[MAX8997_BUCK7] = &buck37_voltage_map_desc,
+	[MAX8997_EN32KHZ_AP] = NULL,
+	[MAX8997_EN32KHZ_CP] = NULL,
+	[MAX8997_ENVICHG] = NULL,
+	[MAX8997_ESAFEOUT1] = NULL,
+	[MAX8997_ESAFEOUT2] = NULL,
+	[MAX8997_CHARGER_CV] = NULL,
+	[MAX8997_CHARGER] = &charger_current_map_desc,
+	[MAX8997_CHARGER_TOPOFF] = &topoff_current_map_desc,
+};
+
+static inline int max8997_get_ldo(struct regulator_dev *rdev)
+{
+	return rdev_get_id(rdev);
+}
+
+static int max8997_list_voltage(struct regulator_dev *rdev,
+		unsigned int selector)
+{
+	const struct voltage_map_desc *desc;
+	int ldo = max8997_get_ldo(rdev);
+	int val;
+
+	if (ldo >= ARRAY_SIZE(reg_voltage_map) ||
+			ldo < 0)
+		return -EINVAL;
+
+	desc = reg_voltage_map[ldo];
+	if (desc == NULL)
+		return -EINVAL;
+
+	val = desc->min + desc->step * selector;
+	if (val > desc->max)
+		return -EINVAL;
+
+	return val * 1000;
+}
+
+static int max8997_get_enable_register(struct regulator_dev *rdev,
+		int *reg, int *mask, int *pattern)
+{
+	int ldo = max8997_get_ldo(rdev);
+
+	switch (ldo) {
+	case MAX8997_LDO1 ... MAX8997_LDO21:
+		*reg = MAX8997_REG_LDO1CTRL + (ldo - MAX8997_LDO1);
+		*mask = 0xC0;
+		*pattern = 0xC0;
+		break;
+	case MAX8997_BUCK1:
+		*reg = MAX8997_REG_BUCK1CTRL;
+		*mask = 0x01;
+		*pattern = 0x01;
+		break;
+	case MAX8997_BUCK2:
+		*reg = MAX8997_REG_BUCK2CTRL;
+		*mask = 0x01;
+		*pattern = 0x01;
+		break;
+	case MAX8997_BUCK3:
+		*reg = MAX8997_REG_BUCK3CTRL;
+		*mask = 0x01;
+		*pattern = 0x01;
+		break;
+	case MAX8997_BUCK4:
+		*reg = MAX8997_REG_BUCK4CTRL;
+		*mask = 0x01;
+		*pattern = 0x01;
+		break;
+	case MAX8997_BUCK5:
+		*reg = MAX8997_REG_BUCK5CTRL;
+		*mask = 0x01;
+		*pattern = 0x01;
+		break;
+	case MAX8997_BUCK6:
+		*reg = MAX8997_REG_BUCK6CTRL;
+		*mask = 0x01;
+		*pattern = 0x01;
+		break;
+	case MAX8997_BUCK7:
+		*reg = MAX8997_REG_BUCK7CTRL;
+		*mask = 0x01;
+		*pattern = 0x01;
+		break;
+	case MAX8997_EN32KHZ_AP ... MAX8997_EN32KHZ_CP:
+		*reg = MAX8997_REG_MAINCON1;
+		*mask = 0x01 << (ldo - MAX8997_EN32KHZ_AP);
+		*pattern = 0x01 << (ldo - MAX8997_EN32KHZ_AP);
+		break;
+	case MAX8997_ENVICHG:
+		*reg = MAX8997_REG_MBCCTRL1;
+		*mask = 0x80;
+		*pattern = 0x80;
+		break;
+	case MAX8997_ESAFEOUT1 ... MAX8997_ESAFEOUT2:
+		*reg = MAX8997_REG_SAFEOUTCTRL;
+		*mask = 0x40 << (ldo - MAX8997_ESAFEOUT1);
+		*pattern = 0x40 << (ldo - MAX8997_ESAFEOUT1);
+		break;
+	case MAX8997_CHARGER:
+		*reg = MAX8997_REG_MBCCTRL2;
+		*mask = 0x40;
+		*pattern = 0x40;
+		break;
+	default:
+		/* Not controllable or not exists */
+		return -EINVAL;
+		break;
+	}
+
+	return 0;
+}
+
+static int max8997_reg_is_enabled(struct regulator_dev *rdev)
+{
+	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8997->iodev->i2c;
+	int ret, reg, mask, pattern;
+	u8 val;
+
+	ret = max8997_get_enable_register(rdev, &reg, &mask, &pattern);
+	if (ret == -EINVAL)
+		return 1; /* "not controllable" */
+	else if (ret)
+		return ret;
+
+	ret = max8997_read_reg(i2c, reg, &val);
+	if (ret)
+		return ret;
+
+	return (val & mask) == pattern;
+}
+
+static int max8997_reg_enable(struct regulator_dev *rdev)
+{
+	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8997->iodev->i2c;
+	int ret, reg, mask, pattern;
+
+	ret = max8997_get_enable_register(rdev, &reg, &mask, &pattern);
+	if (ret)
+		return ret;
+
+	return max8997_update_reg(i2c, reg, pattern, mask);
+}
+
+static int max8997_reg_disable(struct regulator_dev *rdev)
+{
+	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8997->iodev->i2c;
+	int ret, reg, mask, pattern;
+
+	ret = max8997_get_enable_register(rdev, &reg, &mask, &pattern);
+	if (ret)
+		return ret;
+
+	return max8997_update_reg(i2c, reg, ~pattern, mask);
+}
+
+static int max8997_get_voltage_register(struct regulator_dev *rdev,
+		int *_reg, int *_shift, int *_mask)
+{
+	int ldo = max8997_get_ldo(rdev);
+	int reg, shift = 0, mask = 0x3f;
+
+	switch (ldo) {
+	case MAX8997_LDO1 ... MAX8997_LDO21:
+		reg = MAX8997_REG_LDO10CTRL + (ldo - MAX8997_LDO1);
+		break;
+	case MAX8997_BUCK1:
+		reg = MAX8997_REG_BUCK1DVS1;
+		break;
+	case MAX8997_BUCK2:
+		reg = MAX8997_REG_BUCK2DVS1;
+		break;
+	case MAX8997_BUCK3:
+		reg = MAX8997_REG_BUCK3DVS;
+		break;
+	case MAX8997_BUCK4:
+		reg = MAX8997_REG_BUCK4DVS;
+		break;
+	case MAX8997_BUCK5:
+		reg = MAX8997_REG_BUCK5DVS1;
+		break;
+	case MAX8997_BUCK7:
+		reg = MAX8997_REG_BUCK7DVS;
+		break;
+	case MAX8997_ESAFEOUT1 ...  MAX8997_ESAFEOUT2:
+		reg = MAX8997_REG_SAFEOUTCTRL;
+		shift = (ldo == MAX8997_ESAFEOUT2) ? 2 : 0;
+		mask = 0x3;
+		break;
+	case MAX8997_CHARGER_CV:
+		reg = MAX8997_REG_MBCCTRL3;
+		shift = 0;
+		mask = 0xf;
+		break;
+	case MAX8997_CHARGER:
+		reg = MAX8997_REG_MBCCTRL4;
+		shift = 0;
+		mask = 0xf;
+		break;
+	case MAX8997_CHARGER_TOPOFF:
+		reg = MAX8997_REG_MBCCTRL5;
+		shift = 0;
+		mask = 0xf;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*_reg = reg;
+	*_shift = shift;
+	*_mask = mask;
+
+	return 0;
+}
+
+static int max8997_get_voltage(struct regulator_dev *rdev)
+{
+	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8997->iodev->i2c;
+	int reg, shift, mask, ret;
+	u8 val;
+
+	ret = max8997_get_voltage_register(rdev, &reg, &shift, &mask);
+	if (ret)
+		return ret;
+
+	ret = max8997_read_reg(i2c, reg, &val);
+	if (ret)
+		return ret;
+
+	val >>= shift;
+	val &= mask;
+
+	ret = max8997_list_voltage(rdev, val);
+	if (ret == -EINVAL) {
+		int ldo = max8997_get_ldo(rdev);
+		switch (ldo) {
+		case MAX8997_ESAFEOUT1 ... MAX8997_ESAFEOUT2:
+			switch (val) {
+			case 0x00:
+				return 4850000;
+			case 0x01:
+				return 4900000;
+			case 0x02:
+				return 4950000;
+			case 0x03:
+				return 3300000;
+			default:
+				return -EINVAL;
+			}
+			break;
+		case MAX8997_CHARGER_CV:
+			switch (val) {
+			case 0x00:
+				return 4200000;
+			case 0x01 ... 0x0E:
+				return 4000000 + 20000 * (val - 0x01);
+			case 0x0F:
+				return 4350000;
+			default:
+				return -EINVAL;
+			}
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * For LDO1 ~ LDO21, BUCK1~5, BUCK7, CHARGER, CHARGER_TOPOFF
+ * BUCK1, 2, and 5 are available if they are not controlled by gpio
+ */
+static int max8997_set_voltage_ldo(struct regulator_dev *rdev,
+		int min_uV, int max_uV)
+{
+	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8997->iodev->i2c;
+	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
+	const struct voltage_map_desc *desc;
+	int ldo = max8997_get_ldo(rdev);
+	int reg, shift = 0, mask, ret;
+	int i = 0;
+
+	if ((ldo > MAX8997_BUCK7 || ldo < MAX8997_LDO1) &&
+			ldo != MAX8997_CHARGER_CV &&
+			ldo != MAX8997_CHARGER &&
+			ldo != MAX8997_CHARGER_TOPOFF)
+		return -EINVAL;
+	if (ldo == MAX8997_BUCK6)
+		return -EINVAL;
+
+	desc = reg_voltage_map[ldo];
+	if (desc == NULL)
+		return -EINVAL;
+
+	if (max_vol < desc->min || min_vol > desc->max)
+		return -EINVAL;
+
+	while (desc->min + desc->step * i < min_vol &&
+			desc->min + desc->step * i < desc->max)
+		i++;
+
+	if (desc->min + desc->step * i > max_vol)
+		return -EINVAL;
+
+	if (i >= (1 << desc->n_bits))
+		return -EINVAL;
+
+	ret = max8997_get_voltage_register(rdev, &reg, &shift, &mask);
+	if (ret)
+		return ret;
+
+	ret = max8997_update_reg(i2c, reg, i << shift, mask << shift);
+
+	return ret;
+}
+
+static int max8997_set_voltage_buck(struct regulator_dev *rdev,
+		int min_uV, int max_uV)
+{
+	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
+	struct max8997_platform_data *pdata =
+		dev_get_platdata(max8997->iodev->dev);
+	int ldo = max8997_get_ldo(rdev);
+
+	switch (ldo) {
+	case MAX8997_BUCK1:
+		if (pdata->buck1_gpiodvs) {
+			WARN(true, "gpio dvs feature not implemented, %s\n",
+				__func__);
+			return -EINVAL;
+		}
+		break;
+	case MAX8997_BUCK2:
+		if (pdata->buck2_gpiodvs) {
+			WARN(true, "gpio dvs feature not implemented, %s\n",
+				__func__);
+			return -EINVAL;
+		}
+		break;
+	case MAX8997_BUCK5:
+		if (pdata->buck5_gpiodvs) {
+			WARN(true, "gpio dvs feature not implemented, %s\n",
+				__func__);
+			return -EINVAL;
+		}
+		break;
+	}
+
+	if (ldo < MAX8997_BUCK1 || ldo > MAX8997_BUCK7)
+		return -EINVAL;
+
+	return max8997_set_voltage_ldo(rdev, min_uV, max_uV);
+}
+
+static const int safeoutvolt[] = {
+	3300000,
+	4850000,
+	4900000,
+	4950000,
+};
+
+static int max8997_set_voltage_safeout(struct regulator_dev *rdev,
+		int min_uV, int max_uV)
+{
+	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8997->iodev->i2c;
+	int ldo = max8997_get_ldo(rdev);
+	int reg, shift = 0, mask, ret;
+	int i = 0;
+	u8 val;
+
+	if (ldo != MAX8997_ESAFEOUT1 && ldo != MAX8997_ESAFEOUT2)
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(safeoutvolt); i++) {
+		if (min_uV <= safeoutvolt[i] &&
+				max_uV >= safeoutvolt[i])
+			break;
+	}
+
+	if (i >= ARRAY_SIZE(safeoutvolt))
+		return -EINVAL;
+
+	if (i == 0)
+		val = 0x3;
+	else
+		val = i - 1;
+
+	ret = max8997_get_voltage_register(rdev, &reg, &shift, &mask);
+	if (ret)
+		return ret;
+
+	ret = max8997_update_reg(i2c, reg, val << shift, mask << shift);
+
+	return ret;
+}
+
+static struct regulator_ops max8997_ldo_ops = {
+	.list_voltage		= max8997_list_voltage,
+	.is_enabled		= max8997_reg_is_enabled,
+	.enable			= max8997_reg_enable,
+	.disable		= max8997_reg_disable,
+	.get_voltage		= max8997_get_voltage,
+	.set_voltage		= max8997_set_voltage_ldo,
+};
+
+static struct regulator_ops max8997_buck_ops = {
+	.list_voltage		= max8997_list_voltage,
+	.is_enabled		= max8997_reg_is_enabled,
+	.enable			= max8997_reg_enable,
+	.disable		= max8997_reg_disable,
+	.get_voltage		= max8997_get_voltage,
+	.set_voltage		= max8997_set_voltage_buck,
+};
+
+static struct regulator_ops max8997_fixedvolt_ops = {
+	.list_voltage		= max8997_list_voltage,
+	.is_enabled		= max8997_reg_is_enabled,
+	.enable			= max8997_reg_enable,
+	.disable		= max8997_reg_disable,
+};
+
+static struct regulator_ops max8997_safeout_ops = {
+	.list_voltage		= max8997_list_voltage,
+	.is_enabled		= max8997_reg_is_enabled,
+	.enable			= max8997_reg_enable,
+	.disable		= max8997_reg_disable,
+	.get_voltage		= max8997_get_voltage,
+	.set_voltage		= max8997_set_voltage_safeout,
+};
+
+static struct regulator_ops max8997_fixedstate_ops = {
+	.list_voltage		= max8997_list_voltage,
+	.is_enabled		= max8997_reg_is_enabled,
+	.get_voltage		= max8997_get_voltage,
+	.set_voltage		= max8997_set_voltage_ldo,
+};
+
+static struct regulator_ops max8997_charger_ops = {
+	.is_enabled		= max8997_reg_is_enabled,
+	.enable			= max8997_reg_enable,
+	.disable		= max8997_reg_disable,
+	.get_current_limit	= max8997_get_voltage,
+	.set_current_limit	= max8997_set_voltage_ldo,
+};
+
+static struct regulator_ops max8997_charger_fixedstate_ops = {
+	.is_enabled		= max8997_reg_is_enabled,
+	.get_current_limit	= max8997_get_voltage,
+	.set_current_limit	= max8997_set_voltage_ldo,
+};
+
+#define regulator_desc_ldo(num)		{	\
+	.name		= "LDO"#num,		\
+	.id		= MAX8997_LDO##num,	\
+	.ops		= &max8997_ldo_ops,	\
+	.type		= REGULATOR_VOLTAGE,	\
+	.owner		= THIS_MODULE,		\
+}
+#define regulator_desc_buck(num)		{	\
+	.name		= "BUCK"#num,		\
+	.id		= MAX8997_BUCK##num,	\
+	.ops		= &max8997_buck_ops,	\
+	.type		= REGULATOR_VOLTAGE,	\
+	.owner		= THIS_MODULE,		\
+}
+
+static struct regulator_desc regulators[] = {
+	regulator_desc_ldo(1),
+	regulator_desc_ldo(2),
+	regulator_desc_ldo(3),
+	regulator_desc_ldo(4),
+	regulator_desc_ldo(5),
+	regulator_desc_ldo(6),
+	regulator_desc_ldo(7),
+	regulator_desc_ldo(8),
+	regulator_desc_ldo(9),
+	regulator_desc_ldo(10),
+	regulator_desc_ldo(11),
+	regulator_desc_ldo(12),
+	regulator_desc_ldo(13),
+	regulator_desc_ldo(14),
+	regulator_desc_ldo(15),
+	regulator_desc_ldo(16),
+	regulator_desc_ldo(17),
+	regulator_desc_ldo(18),
+	regulator_desc_ldo(18),
+	regulator_desc_buck(1),
+	regulator_desc_buck(2),
+	regulator_desc_buck(3),
+	regulator_desc_buck(4),
+	regulator_desc_buck(5),
+	{
+		.name	= "BUCK6",
+		.id	= MAX8997_BUCK6,
+		.ops	= &max8997_fixedvolt_ops,
+		.type	= REGULATOR_VOLTAGE,
+		.owner	= THIS_MODULE,
+	},
+	regulator_desc_buck(7),
+	{
+		.name	= "EN32KHz AP",
+		.id	= MAX8997_EN32KHZ_AP,
+		.ops	= &max8997_fixedvolt_ops,
+		.type	= REGULATOR_VOLTAGE,
+		.owner	= THIS_MODULE,
+	}, {
+		.name	= "EN32KHz CP",
+		.id	= MAX8997_EN32KHZ_CP,
+		.ops	= &max8997_fixedvolt_ops,
+		.type	= REGULATOR_VOLTAGE,
+		.owner	= THIS_MODULE,
+	}, {
+		.name	= "ENVICHG",
+		.id	= MAX8997_EN32KHZ_AP,
+		.ops	= &max8997_fixedvolt_ops,
+		.type	= REGULATOR_VOLTAGE,
+		.owner	= THIS_MODULE,
+	}, {
+		.name	= "ESAFEOUT1",
+		.id	= MAX8997_ESAFEOUT1,
+		.ops	= &max8997_safeout_ops,
+		.type	= REGULATOR_VOLTAGE,
+		.owner	 = THIS_MODULE,
+	}, {
+		.name	= "ESAFEOUT2",
+		.id	= MAX8997_ESAFEOUT2,
+		.ops	= &max8997_safeout_ops,
+		.type	= REGULATOR_VOLTAGE,
+		.owner	 = THIS_MODULE,
+	}, {
+		.name	= "CHARGER CV",
+		.id	= MAX8997_CHARGER_CV,
+		.ops	= &max8997_fixedstate_ops,
+		.type	= REGULATOR_VOLTAGE,
+		.owner	 = THIS_MODULE,
+	}, {
+		.name	= "CHARGER",
+		.id	= MAX8997_CHARGER,
+		.ops	= &max8997_charger_ops,
+		.type	= REGULATOR_CURRENT,
+		.owner	 = THIS_MODULE,
+	}, {
+		.name	= "CHARGER TOPOFF",
+		.id	= MAX8997_CHARGER_TOPOFF,
+		.ops	= &max8997_charger_fixedstate_ops,
+		.type	= REGULATOR_CURRENT,
+		.owner	 = THIS_MODULE,
+	},
+};
+
+static inline unsigned int max8997_buck_voltage(int uV)
+{
+	int step;
+
+	if (uV <= 650000)
+		return 0x0;
+	if (uV >= 2225000)
+		return 0x3f;
+
+	step = uV - 650000;
+	step /= 25000;
+
+	return step + 1;
+}
+
+static __devinit int max8997_pmic_probe(struct platform_device *pdev)
+{
+	struct max8997_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct max8997_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct regulator_dev **rdev;
+	struct max8997_data *max8997;
+	struct i2c_client *i2c;
+	int i, ret, size;
+
+	if (!pdata) {
+		dev_err(pdev->dev.parent, "No platform init data supplied.\n");
+		return -ENODEV;
+	}
+
+	max8997 = kzalloc(sizeof(struct max8997_data), GFP_KERNEL);
+	if (!max8997)
+		return -ENOMEM;
+
+	size = pdata->num_regulators * sizeof(struct regulator_dev *);
+
+	max8997->rdev = kzalloc(size, GFP_KERNEL);
+	if (!max8997->rdev) {
+		kfree(max8997);
+		return -ENOMEM;
+	}
+
+	rdev = max8997->rdev;
+	max8997->dev = &pdev->dev;
+	max8997->iodev = iodev;
+	max8997->num_regulators = pdata->num_regulators;
+	platform_set_drvdata(pdev, max8997);
+	i2c = max8997->iodev->i2c;
+
+	max8997->buck125_gpioindex = pdata->buck125_default_idx;
+
+	for (i = 0; i < 8; i++) {
+		max8997_update_reg(i2c, MAX8997_REG_BUCK1DVS(i),
+				max8997_buck_voltage(pdata->buck1_voltage[i]),
+				0x3f);
+		max8997_update_reg(i2c, MAX8997_REG_BUCK2DVS(i),
+				max8997_buck_voltage(pdata->buck2_voltage[i]),
+				0x3f);
+		max8997_update_reg(i2c, MAX8997_REG_BUCK5DVS(i),
+				max8997_buck_voltage(pdata->buck5_voltage[i]),
+				0x3f);
+	}
+
+	/*
+	 * If buck 1, 2, and 5 do not care DVS GPIO settings, ignore them.
+	 * If at least one of them cares, set gpios.
+	 */
+	if (pdata->buck1_gpiodvs || pdata->buck2_gpiodvs ||
+			pdata->buck5_gpiodvs) {
+		if (gpio_is_valid(pdata->buck125_gpios[0]) &&
+				gpio_is_valid(pdata->buck125_gpios[1]) &&
+				gpio_is_valid(pdata->buck125_gpios[2])) {
+			bool gpio1set = false, gpio2set = false;
+
+			ret = gpio_request(pdata->buck125_gpios[0],
+					"MAX8997 SET1");
+			if (ret == -EBUSY)
+				dev_warn(&pdev->dev,
+						"ignored gpio request SET1\n");
+			else if (ret)
+				goto err_alloc;
+			else
+				gpio1set = true;
+
+			ret = gpio_request(pdata->buck125_gpios[1],
+					"MAX8997 SET2");
+			if (ret == -EBUSY)
+				dev_warn(&pdev->dev,
+						"ignored gpio request SET2\n");
+			else if (ret) {
+				if (gpio1set)
+					gpio_free(pdata->buck125_gpios[0]);
+				goto err_alloc;
+			} else
+				gpio2set = true;
+
+			ret = gpio_request(pdata->buck125_gpios[2],
+					"MAX8997 SET3");
+			if (ret == -EBUSY)
+				dev_warn(&pdev->dev,
+						"ignored gpio request SET3\n");
+			else if (ret) {
+				if (gpio1set)
+					gpio_free(pdata->buck125_gpios[0]);
+				if (gpio2set)
+					gpio_free(pdata->buck125_gpios[1]);
+				goto err_alloc;
+			}
+
+			ret = 0;
+		} else {
+			dev_err(&pdev->dev, "GPIO NOT VALID\n");
+			ret = -EINVAL;
+			goto err_alloc;
+		}
+	}
+
+	/* DVS-GPIO disabled */
+	max8997_update_reg(i2c, MAX8997_REG_BUCK1CTRL, (pdata->buck1_gpiodvs) ?
+			(1 << 1) : (0 << 1), 1 << 1);
+	max8997_update_reg(i2c, MAX8997_REG_BUCK2CTRL, (pdata->buck2_gpiodvs) ?
+			(1 << 1) : (0 << 1), 1 << 1);
+	max8997_update_reg(i2c, MAX8997_REG_BUCK5CTRL, (pdata->buck5_gpiodvs) ?
+			(1 << 1) : (0 << 1), 1 << 1);
+
+	for (i = 0; i < pdata->num_regulators; i++) {
+		const struct voltage_map_desc *desc;
+		int id = pdata->regulators[i].id;
+
+		desc = reg_voltage_map[id];
+		if (desc)
+			regulators[id].n_voltages =
+				(desc->max - desc->min) / desc->step + 1;
+		else if (id == MAX8997_ESAFEOUT1 || id == MAX8997_ESAFEOUT2)
+			regulators[id].n_voltages = 4;
+		else if (id == MAX8997_CHARGER_CV)
+			regulators[id].n_voltages = 16;
+
+		rdev[i] = regulator_register(&regulators[id], max8997->dev,
+				pdata->regulators[i].initdata, max8997);
+		if (IS_ERR(rdev[i])) {
+			ret = PTR_ERR(rdev[i]);
+			dev_err(max8997->dev, "regulator init failed for %d\n",
+					id);
+			rdev[i] = NULL;
+			goto err;
+		}
+	}
+
+	/* Misc Settings */
+	/* TODO: Read BUCK RAMP and apply delays for it */
+
+	return 0;
+err:
+	for (i = 0; i < max8997->num_regulators; i++)
+		if (rdev[i])
+			regulator_unregister(rdev[i]);
+err_alloc:
+	kfree(max8997->rdev);
+	kfree(max8997);
+
+	return ret;
+}
+
+static int __devexit max8997_pmic_remove(struct platform_device *pdev)
+{
+	struct max8997_data *max8997 = platform_get_drvdata(pdev);
+	struct regulator_dev **rdev = max8997->rdev;
+	int i;
+
+	for (i = 0; i < max8997->num_regulators; i++)
+		if (rdev[i])
+			regulator_unregister(rdev[i]);
+
+	kfree(max8997->rdev);
+	kfree(max8997);
+
+	return 0;
+}
+
+static const struct platform_device_id max8997_pmic_id[] = {
+	{ "max8997-pmic", 0},
+	{ },
+};
+
+static struct platform_driver max8997_pmic_driver = {
+	.driver = {
+		.name = "max8997-pmic",
+		.owner = THIS_MODULE,
+	},
+	.probe = max8997_pmic_probe,
+	.remove = __devexit_p(max8997_pmic_remove),
+	.id_table = max8997_pmic_id,
+};
+
+static int __init max8997_pmic_init(void)
+{
+	return platform_driver_register(&max8997_pmic_driver);
+}
+subsys_initcall(max8997_pmic_init);
+
+static void __exit max8997_pmic_cleanup(void)
+{
+	platform_driver_unregister(&max8997_pmic_driver);
+}
+module_exit(max8997_pmic_cleanup);
+
+MODULE_DESCRIPTION("MAXIM 8997/8966 Regulator Driver");
+MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
index ef3feb9..4077b24 100644
--- a/include/linux/mfd/max8997.h
+++ b/include/linux/mfd/max8997.h
@@ -77,7 +77,25 @@ struct max8997_regulator_data {
 };
 
 struct max8997_platform_data {
-	/* PMIC: Not implemented */
+	/* PMIC */
+	struct max8997_regulator_data *regulators;
+	int num_regulators;
+
+	/*
+	 * SET1~3 DVS GPIOs control Buck1, 2, and 5 simultaneously. Therefore,
+	 * With buckx_gpiodvs enabled, the buckx cannot be controlled
+	 * independently. To control buckx (of 1, 2, and 5) independently,
+	 * disable buckx_gpiodvs and control with BUCKxDVS1 register.
+	 */
+	int buck125_gpios[3]; /* GPIO of SET1, 2, 3 */
+	int buck125_default_idx; /* Default value of SET1, 2, 3 */
+	unsigned int buck1_voltage[8]; /* buckx_voltage in uV */
+	bool buck1_gpiodvs;
+	unsigned int buck2_voltage[8];
+	bool buck2_gpiodvs;
+	unsigned int buck5_voltage[8];
+	bool buck5_gpiodvs;
+
 	/* MUIC: Not implemented */
 	/* HAPTIC: Not implemented */
 	/* RTC: Not implemented */
-- 
1.7.1

