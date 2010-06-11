Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab0FKHDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 03:03:10 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23963 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab0FKHDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 03:03:08 -0400
Date: Fri, 11 Jun 2010 09:02:45 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] drivers: regulator: add Maxim 8998 driver
To: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com
Message-id: <1276239765-26234-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

This patch adds voltage regulator driver for Maxim 8998 chip. This chip
is used on Samsung Aquila and GONI boards.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/regulator/Kconfig         |    8 +
 drivers/regulator/Makefile        |    1 +
 drivers/regulator/max8998.c       |  842 +++++++++++++++++++++++++++++++++++++
 include/linux/regulator/max8998.h |   77 ++++
 4 files changed, 928 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/max8998.c
 create mode 100644 include/linux/regulator/max8998.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 679ea37..e041dce 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -100,6 +100,14 @@ config REGULATOR_MAX8925
 	help
 	  Say y here to support the voltage regulaltor of Maxim MAX8925 PMIC.
 
+config REGULATOR_MAX8998
+	tristate "Maxim 8998 voltage regulator"
+	depends on I2C
+	help
+	  This driver controls a Maxim 8998 voltage output regulator
+	  via I2C bus. The provided regulator is suitable for S3C6410
+	  and S5PC1XX chips to control VCC_CORE and VCC_USIM voltages.
+
 config REGULATOR_TWL4030
 	bool "TI TWL4030/TWL5030/TWL6030/TPS695x0 PMIC"
 	depends on TWL4030_CORE
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index c256668..eafaa68 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_REGULATOR_TWL4030) += twl-regulator.o
 obj-$(CONFIG_REGULATOR_MAX8649)	+= max8649.o
 obj-$(CONFIG_REGULATOR_MAX8660) += max8660.o
 obj-$(CONFIG_REGULATOR_MAX8925) += max8925-regulator.o
+obj-$(CONFIG_REGULATOR_MAX8998) += max8998.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-dcdc.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-isink.o
 obj-$(CONFIG_REGULATOR_WM831X) += wm831x-ldo.o
diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
new file mode 100644
index 0000000..ae7c970
--- /dev/null
+++ b/drivers/regulator/max8998.c
@@ -0,0 +1,842 @@
+/*
+ * max8698.c - Voltage regulator driver for the Maxim 8998
+ *
+ * Copyright (C) 2009-2010 Samsung Electronics
+ * Kyungmin Park <kyungmin.park@samsung.com>
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
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/max8998.h>
+#include <linux/mutex.h>
+
+/* Registers */
+enum {
+	MAX8998_REG_IRQ1,
+	MAX8998_REG_IRQ2,
+	MAX8998_REG_IRQ3,
+	MAX8998_REG_IRQ4,
+	MAX8998_REG_IRQM1,
+	MAX8998_REG_IRQM2,
+	MAX8998_REG_IRQM3,
+	MAX8998_REG_IRQM4,
+	MAX8998_REG_STATUS1,
+	MAX8998_REG_STATUS2,
+	MAX8998_REG_STATUSM1,
+	MAX8998_REG_STATUSM2,
+	MAX8998_REG_CHGR1,
+	MAX8998_REG_CHGR2,
+	MAX8998_REG_LDO_ACTIVE_DISCHARGE1,
+	MAX8998_REG_LDO_ACTIVE_DISCHARGE2,
+	MAX8998_REG_BUCK_ACTIVE_DISCHARGE3,
+	MAX8998_REG_ONOFF1,
+	MAX8998_REG_ONOFF2,
+	MAX8998_REG_ONOFF3,
+	MAX8998_REG_ONOFF4,
+	MAX8998_REG_BUCK1_DVSARM1,
+	MAX8998_REG_BUCK1_DVSARM2,
+	MAX8998_REG_BUCK1_DVSARM3,
+	MAX8998_REG_BUCK1_DVSARM4,
+	MAX8998_REG_BUCK2_DVSINT1,
+	MAX8998_REG_BUCK2_DVSINT2,
+	MAX8998_REG_BUCK3,
+	MAX8998_REG_BUCK4,
+	MAX8998_REG_LDO2_LDO3,
+	MAX8998_REG_LDO4,
+	MAX8998_REG_LDO5,
+	MAX8998_REG_LDO6,
+	MAX8998_REG_LDO7,
+	MAX8998_REG_LDO8_LDO9,
+	MAX8998_REG_LDO10_LDO11,
+	MAX8998_REG_LDO12,
+	MAX8998_REG_LDO13,
+	MAX8998_REG_LDO14,
+	MAX8998_REG_LDO15,
+	MAX8998_REG_LDO16,
+	MAX8998_REG_LDO17,
+	MAX8998_REG_BKCHR,
+	MAX8998_REG_LBCNFG1,
+	MAX8998_REG_LBCNFG2,
+};
+
+struct max8998_data {
+	struct i2c_client	*client;
+	struct device		*dev;
+
+	struct mutex		mutex;
+
+	int			ono_pin;
+	int			ono_irq;
+
+	int			num_regulators;
+	struct regulator_dev	**rdev;
+};
+
+static unsigned int cache_regs_initialized;
+
+static u8 max8998_cache_regs[64] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	  -1,   -1, 0xff, 0xff, 0x0a, 0x80, 0xff, 0xff,
+	0xff, 0xed, 0xb8, 0x00, 0xe9, 0x12, 0x12, 0x12,
+	0x12, 0x12, 0x12, 0x02, 0x04, 0x88, 0x02, 0x0c,
+	0x0a, 0x0e, 0x30, 0xac, 0x0a, 0x14, 0x06, 0x10,
+	0x11, 0x01, 0x17, 0x14,   -1,   -1,   -1,   -1,
+};
+
+static int max8998_i2c_cache_read(struct i2c_client *client, u8 reg, u8 *dest)
+{
+	*dest = max8998_cache_regs[reg];
+	return 0;
+}
+
+static int max8998_cache_read_allow(u8 reg)
+{
+	switch (reg) {
+	case MAX8998_REG_CHGR2:
+		return 0;
+	default:
+		break;
+	}
+
+	return 1;
+}
+
+static int max8998_i2c_read(struct i2c_client *client, u8 reg, u8 *dest)
+{
+	int ret;
+
+	if (max8998_cache_read_allow(reg) && cache_regs_initialized)
+		return max8998_i2c_cache_read(client, reg, dest);
+
+	ret = i2c_smbus_read_byte_data(client, reg);
+	if (ret < 0)
+		return -EIO;
+
+	ret &= 0xff;
+	max8998_cache_regs[reg] = ret;
+	*dest = ret;
+	return 0;
+}
+
+static int max8998_i2c_write(struct i2c_client *client, u8 reg, u8 value)
+{
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(client, reg, value);
+	if (!ret)
+		max8998_cache_regs[reg] = value;
+	return ret;
+}
+
+static void max8998_cache_register_init(struct i2c_client *client)
+{
+	u8 value;
+	int ret;
+
+	ret = max8998_i2c_read(client, MAX8998_REG_STATUS1, &value);
+	if (ret)
+		return;
+	ret = max8998_i2c_read(client, MAX8998_REG_STATUS2, &value);
+	if (ret)
+		return;
+
+	cache_regs_initialized = 1;
+}
+
+static int max8998_read_reg(struct max8998_data *max8998, u8 reg)
+{
+	u8 value = 0;
+	int ret;
+
+	mutex_lock(&max8998->mutex);
+	ret = max8998_i2c_read(max8998->client, reg, &value);
+	mutex_unlock(&max8998->mutex);
+	if (!ret)
+		ret = value & 0xff;
+
+	return ret;
+}
+
+static int max8998_write_reg(struct max8998_data *max8998, u8 reg, u8 value)
+{
+	int ret;
+
+	mutex_lock(&max8998->mutex);
+	ret = max8998_i2c_write(max8998->client, reg, value);
+	mutex_unlock(&max8998->mutex);
+
+	return ret;
+}
+
+/* Voltage */
+static const int ldo23_voltage_map[] = {
+	 800,  850,  900,  950, 1000,
+	1050, 1100, 1150, 1200, 1250,
+	1300,
+};
+
+static const int ldo456711_voltage_map[] = {
+	1600, 1700, 1800, 1900, 2000,
+	2100, 2200, 2300, 2400, 2500,
+	2600, 2700, 2800, 2900, 3000,
+	3100, 3200, 3300, 3400, 3500,
+	3600,
+};
+
+static const int ldo8_voltage_map[] = {
+	3000, 3100, 3200, 3300, 3400,
+	3500, 3600,
+};
+
+static const int ldo9_voltage_map[] = {
+	2800, 2900, 3000, 3100,
+};
+
+static const int ldo10_voltage_map[] = {
+	 950, 1000, 1050, 1100, 1150,
+	1200, 1250, 1300,
+};
+
+static const int ldo1213_voltage_map[] = {
+	 800,  900, 1000, 1100, 1200,
+	1300, 1400, 1500, 1600, 1700,
+	1800, 1900, 2000, 2100, 2200,
+	2300, 2400, 2500, 2600, 2700,
+	2800, 2900, 3000, 3100, 3200,
+	3300,
+};
+
+static const int ldo1415_voltage_map[] = {
+	1200, 1300, 1400, 1500, 1600,
+	1700, 1800, 1900, 2000, 2100,
+	2200, 2300, 2400, 2500, 2600,
+	2700, 2800, 2900, 3000, 3100,
+	3200, 3300,
+};
+
+static const int ldo1617_voltage_map[] = {
+	1600, 1700, 1800, 1900, 2000,
+	2100, 2200, 2300, 2400, 2500,
+	2600, 2700, 2800, 2900, 3000,
+	3100, 3200, 3300, 3400, 3500,
+	3600,
+};
+
+static const int buck12_voltage_map[] = {
+	 750,  775,  800,  825,  850,
+	 875,  900,  925,  950,  975,
+	1000, 1025, 1050, 1075, 1100,
+	1125, 1150, 1175, 1200, 1225,
+	1250, 1275, 1300, 1325, 1350,
+	1375, 1400, 1425, 1450, 1475,
+	1500, 1525,
+};
+
+static const int buck3_voltage_map[] = {
+	1600, 1700, 1800, 1900, 2000,
+	2100, 2200, 2300, 2400, 2500,
+	2600, 2700, 2800, 2900, 3000,
+	3100, 3200, 3300, 3400, 3500,
+	3600,
+};
+
+static const int buck4_voltage_map[] = {
+	 800,  900, 1000, 1100, 1200,
+	1300, 1400, 1500, 1600, 1700,
+	1800, 1900, 2000, 2100, 2200,
+	2300,
+};
+
+static const int *ldo_voltage_map[] = {
+	NULL,
+	NULL,
+	ldo23_voltage_map,	/* LDO2 */
+	ldo23_voltage_map,	/* LDO3 */
+	ldo456711_voltage_map,	/* LDO4 */
+	ldo456711_voltage_map,	/* LDO5 */
+	ldo456711_voltage_map,	/* LDO6 */
+	ldo456711_voltage_map,	/* LDO7 */
+	ldo8_voltage_map,	/* LDO8 */
+	ldo9_voltage_map,	/* LDO9 */
+	ldo10_voltage_map,	/* LDO10 */
+	ldo456711_voltage_map,	/* LDO11 */
+	ldo1213_voltage_map,	/* LDO12 */
+	ldo1213_voltage_map,	/* LDO13 */
+	ldo1415_voltage_map,	/* LDO14 */
+	ldo1415_voltage_map,	/* LDO15 */
+	ldo1617_voltage_map,	/* LDO16 */
+	ldo1617_voltage_map,	/* LDO17 */
+	buck12_voltage_map,	/* BUCK1 */
+	buck12_voltage_map,	/* BUCK2 */
+	buck3_voltage_map,	/* BUCK3 */
+	buck4_voltage_map,	/* BUCK4 */
+};
+
+static int max8998_get_ldo(struct regulator_dev *rdev)
+{
+	return rdev_get_id(rdev);
+}
+
+static int max8998_list_voltage(struct regulator_dev *rdev,
+				unsigned int selector)
+{
+	int ldo = max8998_get_ldo(rdev);
+
+	if (ldo > ARRAY_SIZE(ldo_voltage_map))
+		return -EINVAL;
+
+	return ldo_voltage_map[ldo][selector] * 1000;
+}
+
+static int max8998_get_enable_register(struct regulator_dev *rdev,
+					int *reg, int *shift)
+{
+	int ldo = max8998_get_ldo(rdev);
+
+	switch (ldo) {
+	case MAX8998_LDO2 ... MAX8998_LDO5:
+		*reg = MAX8998_REG_ONOFF1;
+		*shift = 3 - (ldo - MAX8998_LDO2);
+		break;
+	case MAX8998_LDO6 ... MAX8998_LDO13:
+		*reg = MAX8998_REG_ONOFF2;
+		*shift = 7 - (ldo - MAX8998_LDO6);
+		break;
+	case MAX8998_LDO14 ... MAX8998_LDO17:
+		*reg = MAX8998_REG_ONOFF3;
+		*shift = 7 - (ldo - MAX8998_LDO14);
+		break;
+	case MAX8998_BUCK1 ... MAX8998_BUCK4:
+		*reg = MAX8998_REG_ONOFF1;
+		*shift = 7 - (ldo - MAX8998_BUCK1);
+		break;
+	case MAX8998_EN32KHZ_AP ... MAX8998_ENVICHG:
+		*reg = MAX8998_REG_ONOFF4;
+		*shift = 7 - (ldo - MAX8998_EN32KHZ_AP);
+		break;
+	case MAX8998_ESAFEOUT1 ... MAX8998_ESAFEOUT2:
+		*reg = MAX8998_REG_CHGR2;
+		*shift = 7 - (ldo - MAX8998_ESAFEOUT1);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int max8998_ldo_is_enabled(struct regulator_dev *rdev)
+{
+	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	int reg, shift = 8, value;
+
+	value = max8998_get_enable_register(rdev, &reg, &shift);
+	if (value)
+		return value;
+
+	value = max8998_read_reg(max8998, reg);
+
+	return value & (1 << shift);
+}
+
+static int max8998_ldo_enable(struct regulator_dev *rdev)
+{
+	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	int reg, shift = 8, value, ret;
+
+	ret = max8998_get_enable_register(rdev, &reg, &shift);
+	if (ret)
+		return ret;
+
+	value = max8998_read_reg(max8998, reg);
+	value |= (1 << shift);
+	ret = max8998_write_reg(max8998, reg, value);
+
+	return ret;
+}
+
+static int max8998_ldo_disable(struct regulator_dev *rdev)
+{
+	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	int reg, shift = 8, value, ret;
+
+	ret = max8998_get_enable_register(rdev, &reg, &shift);
+	if (ret)
+		return ret;
+
+	value = max8998_read_reg(max8998, reg);
+	value &= ~(1 << shift);
+	ret = max8998_write_reg(max8998, reg, value);
+
+	return ret;
+}
+
+static int max8998_get_voltage_register(struct regulator_dev *rdev,
+				int *_reg, int *_shift, int *_mask)
+{
+	int ldo = max8998_get_ldo(rdev);
+	int reg, shift = -1, mask = 0xff;
+
+	switch (ldo) {
+	case MAX8998_LDO2 ... MAX8998_LDO3:
+		reg = MAX8998_REG_LDO2_LDO3;
+		mask = 0xf;
+		if (ldo == MAX8998_LDO2)
+			shift = 4;
+		else
+			shift = 0;
+		break;
+	case MAX8998_LDO4 ... MAX8998_LDO7:
+		reg = MAX8998_REG_LDO4 + (ldo - MAX8998_LDO4);
+		break;
+	case MAX8998_LDO8 ... MAX8998_LDO9:
+		reg = MAX8998_REG_LDO8_LDO9;
+		mask = 0xf;
+		if (ldo == MAX8998_LDO8)
+			shift = 4;
+		else
+			shift = 0;
+		break;
+	case MAX8998_LDO10 ... MAX8998_LDO11:
+		reg = MAX8998_REG_LDO10_LDO11;
+		if (ldo == MAX8998_LDO10) {
+			shift = 5;
+			mask = 0x7;
+		} else {
+			shift = 0;
+			mask = 0x1f;
+		}
+		break;
+	case MAX8998_LDO12 ... MAX8998_LDO17:
+		reg = MAX8998_REG_LDO12 + (ldo - MAX8998_LDO12);
+		break;
+	case MAX8998_BUCK1:
+		reg = MAX8998_REG_BUCK1_DVSARM1;
+		break;
+	case MAX8998_BUCK2:
+		reg = MAX8998_REG_BUCK2_DVSINT1;
+		break;
+	case MAX8998_BUCK3:
+		reg = MAX8998_REG_BUCK3;
+		break;
+	case MAX8998_BUCK4:
+		reg = MAX8998_REG_BUCK4;
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
+static int max8998_get_voltage(struct regulator_dev *rdev)
+{
+	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	int ldo = max8998_get_ldo(rdev);
+	int reg, shift = -1, mask, value, ret;
+
+	ret = max8998_get_voltage_register(rdev, &reg, &shift, &mask);
+	if (ret)
+		return ret;
+
+	value = max8998_read_reg(max8998, reg);
+	if (shift >= 0) {
+		value >>= shift;
+		value &= mask;
+	}
+	if (ldo > ARRAY_SIZE(ldo_voltage_map))
+		return -EINVAL;
+
+	return ldo_voltage_map[ldo][value] * 1000;
+}
+
+static int max8998_set_voltage(struct regulator_dev *rdev,
+				int min_uV, int max_uV)
+{
+	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
+	int ldo = max8998_get_ldo(rdev);
+	const int *vol_map = ldo_voltage_map[ldo];
+	int reg, shift = -1, mask, value, ret;
+	int i;
+
+	for (i = 0; i < vol_map[i]; i++) {
+		if (vol_map[i] >= min_vol)
+			break;
+	}
+
+	if (!vol_map[i] || vol_map[i] > max_vol)
+		return -EINVAL;
+
+	ret = max8998_get_voltage_register(rdev, &reg, &shift, &mask);
+	if (ret)
+		return ret;
+
+	value = max8998_read_reg(max8998, reg);
+	if (shift >= 0) {
+		value &= ~(mask << shift);
+		value |= i << shift;
+	} else
+		value = i;
+	ret = max8998_write_reg(max8998, reg, value);
+
+	return ret;
+}
+
+static struct regulator_ops max8998_ldo_ops = {
+	.list_voltage		= max8998_list_voltage,
+	.is_enabled		= max8998_ldo_is_enabled,
+	.enable			= max8998_ldo_enable,
+	.disable		= max8998_ldo_disable,
+	.get_voltage		= max8998_get_voltage,
+	.set_voltage		= max8998_set_voltage,
+	.set_suspend_enable	= max8998_ldo_enable,
+	.set_suspend_disable	= max8998_ldo_disable,
+};
+
+static struct regulator_ops max8998_buck_ops = {
+	.list_voltage		= max8998_list_voltage,
+	.is_enabled		= max8998_ldo_is_enabled,
+	.enable			= max8998_ldo_enable,
+	.disable		= max8998_ldo_disable,
+	.get_voltage		= max8998_get_voltage,
+	.set_voltage		= max8998_set_voltage,
+	.set_suspend_enable	= max8998_ldo_enable,
+	.set_suspend_disable	= max8998_ldo_disable,
+};
+
+static struct regulator_ops max8998_others_ops = {
+	.is_enabled		= max8998_ldo_is_enabled,
+	.enable			= max8998_ldo_enable,
+	.disable		= max8998_ldo_disable,
+	.set_suspend_enable	= max8998_ldo_enable,
+	.set_suspend_disable	= max8998_ldo_disable,
+};
+
+static struct regulator_desc regulators[] = {
+	{
+		.name		= "LDO2",
+		.id		= MAX8998_LDO2,
+		.n_voltages	= ARRAY_SIZE(ldo23_voltage_map),
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO3",
+		.id		= MAX8998_LDO3,
+		.n_voltages	= ARRAY_SIZE(ldo23_voltage_map),
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO4",
+		.id		= MAX8998_LDO4,
+		.n_voltages	= ARRAY_SIZE(ldo456711_voltage_map),
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO5",
+		.id		= MAX8998_LDO5,
+		.n_voltages	= ARRAY_SIZE(ldo456711_voltage_map),
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO6",
+		.id		= MAX8998_LDO6,
+		.n_voltages	= ARRAY_SIZE(ldo456711_voltage_map),
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO7",
+		.id		= MAX8998_LDO7,
+		.n_voltages	= ARRAY_SIZE(ldo456711_voltage_map),
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO8",
+		.id		= MAX8998_LDO8,
+		.n_voltages	= ARRAY_SIZE(ldo8_voltage_map),
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO9",
+		.id		= MAX8998_LDO9,
+		.n_voltages	= ARRAY_SIZE(ldo9_voltage_map),
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO10",
+		.id		= MAX8998_LDO10,
+		.n_voltages	= ARRAY_SIZE(ldo10_voltage_map),
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO11",
+		.id		= MAX8998_LDO11,
+		.n_voltages	= ARRAY_SIZE(ldo456711_voltage_map),
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO12",
+		.id		= MAX8998_LDO12,
+		.n_voltages	= ARRAY_SIZE(ldo1213_voltage_map),
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO13",
+		.id		= MAX8998_LDO13,
+		.n_voltages	= ARRAY_SIZE(ldo1213_voltage_map),
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO14",
+		.id		= MAX8998_LDO14,
+		.n_voltages	= ARRAY_SIZE(ldo1415_voltage_map),
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO15",
+		.id		= MAX8998_LDO15,
+		.n_voltages	= ARRAY_SIZE(ldo1415_voltage_map),
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO16",
+		.id		= MAX8998_LDO16,
+		.n_voltages	= ARRAY_SIZE(ldo1617_voltage_map),
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "LDO17",
+		.id		= MAX8998_LDO17,
+		.n_voltages	= ARRAY_SIZE(ldo1617_voltage_map),
+		.ops		= &max8998_ldo_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "BUCK1",
+		.id		= MAX8998_BUCK1,
+		.ops		= &max8998_buck_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "BUCK2",
+		.id		= MAX8998_BUCK2,
+		.ops		= &max8998_buck_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "BUCK3",
+		.id		= MAX8998_BUCK3,
+		.ops		= &max8998_buck_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "BUCK4",
+		.id		= MAX8998_BUCK4,
+		.ops		= &max8998_buck_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "EN32KHz AP",
+		.id		= MAX8998_EN32KHZ_AP,
+		.ops		= &max8998_others_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "EN32KHz CP",
+		.id		= MAX8998_EN32KHZ_CP,
+		.ops		= &max8998_others_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "ENVICHG",
+		.id		= MAX8998_ENVICHG,
+		.ops		= &max8998_others_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "ESAFEOUT1",
+		.id		= MAX8998_ESAFEOUT1,
+		.ops		= &max8998_others_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}, {
+		.name		= "ESAFEOUT2",
+		.id		= MAX8998_ESAFEOUT2,
+		.ops		= &max8998_others_ops,
+		.type		= REGULATOR_VOLTAGE,
+		.owner		= THIS_MODULE,
+	}
+};
+
+static irqreturn_t max8998_ono_irq(int irq, void *data)
+{
+	return IRQ_HANDLED;
+}
+
+static int __devinit max8998_pmic_probe(struct i2c_client *client,
+				const struct i2c_device_id *i2c_id)
+{
+	struct max8998_platform_data *pdata = client->dev.platform_data;
+	struct regulator_dev **rdev;
+	struct max8998_data *max8998;
+	int i, id, ret, size;
+	int irq;
+
+	if (!pdata) {
+		dev_err(&client->dev, "No platform init data supplied\n");
+		return -ENODEV;
+	}
+
+	max8998 = kzalloc(sizeof(struct max8998_data), GFP_KERNEL);
+	if (!max8998)
+		return -ENOMEM;
+
+	size = sizeof(struct regulator_dev *) * (pdata->num_regulators + 1);
+	max8998->rdev = kzalloc(size, GFP_KERNEL);
+	if (!max8998->rdev) {
+		kfree(max8998);
+		return -ENOMEM;
+	}
+	rdev = max8998->rdev;
+
+	max8998->client = client;
+	max8998->dev = &client->dev;
+	max8998->ono_pin = pdata->ono_pin;
+	mutex_init(&max8998->mutex);
+
+	for (i = 0; i < pdata->num_regulators; i++) {
+		id = pdata->regulators[i].id - MAX8998_LDO2,
+		rdev[i] = regulator_register(&regulators[id], max8998->dev,
+				pdata->regulators[i].initdata, max8998);
+		if (IS_ERR(rdev[i])) {
+			err = PTR_ERR(rdev[i]));
+			dev_err(max8998->dev, "regulator init failed\n");
+			rdev[i] = NULL;
+		}
+	}
+
+	if (gpio_is_valid(max8998->ono_pin)) {
+		ret = gpio_request(max8998->ono_pin, "MAX8998 nONO");
+		if (ret)
+			goto out_ono;
+		irq = gpio_to_irq(max8998->ono_pin);
+		ret = request_irq(irq, max8998_ono_irq,
+				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
+				"max8998 nPower", max8998);
+		if (ret) {
+			dev_err(&client->dev, "Can't get interrupt pin\n");
+			goto out_ono_irq;
+		}
+
+		/* enable wakeup source for power button */
+		set_irq_wake(irq, 1);
+		max8998->ono_irq = irq;
+	}
+
+	i2c_set_clientdata(client, max8998);
+
+	max8998_cache_register_init(client);
+
+	return 0;
+out_ono_irq:
+	for (i = 0; i <= max8998->num_regulators; i++)
+		if (rdev[i])
+			regulator_unregister(rdev[i]);
+
+	gpio_free(max8998->ono_pin);
+out_ono:
+	return ret;
+}
+
+static int __devexit max8998_pmic_remove(struct i2c_client *client)
+{
+	struct max8998_data *max8998 = i2c_get_clientdata(client);
+	struct regulator_dev **rdev = max8998->rdev;
+	int i;
+
+	if (max8998->ono_irq)
+		free_irq(max8998->ono_irq, max8998);
+
+	if (gpio_is_valid(max8998->ono_pin))
+		gpio_free(max8998->ono_pin);
+
+	for (i = 0; i <= max8998->num_regulators; i++)
+		if (rdev[i])
+			regulator_unregister(rdev[i]);
+
+	kfree(max8998->rdev);
+	kfree(max8998);
+
+	return 0;
+}
+
+static const struct i2c_device_id max8998_ids[] = {
+	{ "max8998", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, max8998_ids);
+
+static struct i2c_driver max8998_pmic_driver = {
+	.probe		= max8998_pmic_probe,
+	.remove		= __devexit_p(max8998_pmic_remove),
+	.driver		= {
+		.name	= "max8998",
+	},
+	.id_table	= max8998_ids,
+};
+
+static int __init max8998_pmic_init(void)
+{
+	return i2c_add_driver(&max8998_pmic_driver);
+}
+subsys_initcall(max8998_pmic_init);
+
+static void __exit max8998_pmic_exit(void)
+{
+	i2c_del_driver(&max8998_pmic_driver);
+}
+module_exit(max8998_pmic_exit);
+
+MODULE_DESCRIPTION("MAXIM 8998 voltage regulator driver");
+MODULE_AUTHOR("Kyungmin Park <kyungmin.park@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/regulator/max8998.h b/include/linux/regulator/max8998.h
new file mode 100644
index 0000000..9fc2685
--- /dev/null
+++ b/include/linux/regulator/max8998.h
@@ -0,0 +1,77 @@
+/*
+ * max8698.h - Voltage regulator driver for the Maxim 8998
+ *
+ *  Copyright (C) 2009-2010 Samsung Electrnoics
+ *  Kyungmin Park <kyungmin.park@samsung.com>
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
+#ifndef __LINUX_REGULATOR_MAX8998
+#define __LINUX_REGULATOR_MAX8998
+
+#include <linux/regulator/machine.h>
+
+enum {
+	MAX8998_LDO2 = 2,
+	MAX8998_LDO3,
+	MAX8998_LDO4,
+	MAX8998_LDO5,
+	MAX8998_LDO6,
+	MAX8998_LDO7,
+	MAX8998_LDO8,
+	MAX8998_LDO9,
+	MAX8998_LDO10,
+	MAX8998_LDO11,
+	MAX8998_LDO12,
+	MAX8998_LDO13,
+	MAX8998_LDO14,
+	MAX8998_LDO15,
+	MAX8998_LDO16,
+	MAX8998_LDO17,
+	MAX8998_BUCK1,
+	MAX8998_BUCK2,
+	MAX8998_BUCK3,
+	MAX8998_BUCK4,
+	MAX8998_EN32KHZ_AP,
+	MAX8998_EN32KHZ_CP,
+	MAX8998_ENVICHG,
+	MAX8998_ESAFEOUT1,
+	MAX8998_ESAFEOUT2,
+};
+
+/**
+ * max8998_subdev_data - regulator data
+ * @id: regulator Id
+ * @initdata: regulator init data (contraints, supplies, ...)
+ */
+struct max8998_subdev_data {
+	int				id;
+	struct regulator_init_data	*initdata;
+};
+
+/**
+ * max8998_platform_data - platform data for max8998
+ * @num_regulators: number of regultors used
+ * @regulators: regulator used
+ * @ono_pin: gpio pin for power button
+ */
+struct max8998_platform_data {
+	int				num_regulators;
+	struct max8998_subdev_data	*regulators;
+	int				ono_pin;
+};
+
+#endif
-- 
1.7.1.240.g225c

