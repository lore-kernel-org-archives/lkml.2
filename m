Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2E2CVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 22:21:03 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52194 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2E2CVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 22:21:01 -0400
X-AuditID: cbfee61b-b7faf6d000001f49-f9-4fc4328ae2d5
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v5] regulator: MAX77686: Add Maxim 77686 regulator driver
Date: Tue, 29 May 2012 11:20:51 +0900
Message-id: <1338258051-3155-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDJMWRmVeSWpSXmKPExsVy+t9jQd0uoyP+BhN7LSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGzalnGAv2dTBWXDi/mq2BcVFBFyMnh4SAicTHxSuZIWwxiQv3
	1rN1MXJxCAlMZ5Ro+zadGcJZySSxqvcjE0gVm4COxP99N9lBbBEBBYnNvc9YQYqYBdYxSWzc
	0coKkhAW8JS4t3gtG4jNIqAq8eL0JUYQm1fAXWJfZwsTxDoFiQX33rJNYORewMiwilE0tSC5
	oDgpPddIrzgxt7g0L10vOT93EyPYj8+kdzCuarA4xCjAwajEw/tD/4i/EGtiWXFl7iFGCQ5m
	JRHe9/2H/YV4UxIrq1KL8uOLSnNSiw8xSnOwKInzPlmyw19IID2xJDU7NbUgtQgmy8TBKdXA
	uHlr+oKrGox/f9+e+z9MSE72SUy15wqZT5krVeR2FKvpdk69P+Ve3Trz4PDsV14XdnF1vtvo
	cOF+U7Pm5uv65v2L2503czPX3eS1ZXxdx/KI8VI186YXbsEFbxKYu3KXOrmba2yYmKYm3/rs
	1av/DnKv+rctOtHj8Kd68YG3Ui+Ptq+42XNriRJLcUaioRZzUXEiAGI1CrXfAQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add driver for support max77686 regulator.
MAX77686 provides LDOs[1~26] and BUCKs[1~9]. It support to set or get the
volatege of regulator on max77686 chip with using regmap.

v5
- Remove unnecessary initializing and variable.

v4
- Register Crystal oscillator's clocks with generic clock API.

v3
- Remove voltage_map_desc structure and replace minimum voltage and voltage
  step into regulator_desc.
- Use only regulator common APIs for regulator_ops.
  (No more use driver's own funcions)

This patch is based on broonie/regulator/for-next branch.

v2
- Convert get_voltage to get_voltage_sel
- Convert set_voltage to set_voltage_sel
- Implement set_voltage_time_sel
- Register regulators unconditionally
- kzalloc -> devm_kzalloc
- Remove unneccessary printk
- Keep probing whether pdata exists or not
- Use regmap API to access PMIC register.

Signed-off-by: Chiwoong Byun <woong.byun@samsung.com>
Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/Kconfig    |    8 +
 drivers/regulator/Makefile   |    1 +
 drivers/regulator/max77686.c |  491 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 500 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/max77686.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 36db5a4..8e2ebad 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -195,6 +195,14 @@ config REGULATOR_MAX8998
 	  via I2C bus. The provided regulator is suitable for S3C6410
 	  and S5PC1XX chips to control VCC_CORE and VCC_USIM voltages.
 
+config REGULATOR_MAX77686
+	tristate "Maxim 77686 regulator"
+	depends on MFD_MAX77686
+	help
+	  This driver controls a Maxim 77686 regulator
+	  via I2C bus. The provided regulator is suitable for
+	  Exynos-4 chips to control VARM and VINT voltages.
+
 config REGULATOR_PCAP
 	tristate "Motorola PCAP2 regulator driver"
 	depends on EZX_PCAP
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 94b5274..008931b 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_REGULATOR_MAX8925) += max8925-regulator.o
 obj-$(CONFIG_REGULATOR_MAX8952) += max8952.o
 obj-$(CONFIG_REGULATOR_MAX8997) += max8997.o
 obj-$(CONFIG_REGULATOR_MAX8998) += max8998.o
+obj-$(CONFIG_REGULATOR_MAX77686) += max77686.o
 obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
 obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o
 obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
new file mode 100644
index 0000000..2d23f68
--- /dev/null
+++ b/drivers/regulator/max77686.c
@@ -0,0 +1,491 @@
+/*
+ * max77686.c - Regulator driver for the Maxim 77686
+ *
+ * Copyright (C) 2012 Samsung Electronics
+ * Chiwoong Byun <woong.byun@smasung.com>
+ * Jonghwa Lee <jonghwa3.lee@samsung.com>
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
+#include <linux/kernel.h>
+#include <linux/bug.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/mfd/max77686.h>
+#include <linux/mfd/max77686-private.h>
+
+#ifdef CONFIG_COMMON_CLK
+#include <linux/clk-private.h>
+#endif
+
+#define MAX77686_LDO_MINUV	800000
+#define MAX77686_LDO_UVSTEP	50000
+#define MAX77686_LDO_LOW_MINUV	800000
+#define MAX77686_LDO_LOW_UVSTEP	25000
+#define MAX77686_BUCK_MINUV	750000
+#define MAX77686_BUCK_UVSTEP	50000
+#define MAX77686_DVS_MINUV	600000
+#define MAX77686_DVS_UVSTEP	12500
+
+#define MAX77686_OPMODE_SHIFT	6
+#define MAX77686_OPMODE_BUCK234_SHIFT	4
+#define MAX77686_OPMODE_MASK	0x3
+
+#define MAX77686_VSEL_MASK	0x3f
+#define MAX77686_DVS_VSEL_MASK	0xff
+
+#define MAX77686_RAMP_RATE	100
+
+#define MAX77686_REGULATORS	MAX77686_REG_MAX
+#define MAX77686_LDOS		26
+
+struct max77686_data {
+	struct device *dev;
+	struct max77686_dev *iodev;
+	int num_regulators;
+	struct regulator_dev **rdev;
+	int ramp_delay; /* in mV/us */
+
+#ifdef CONFIG_COMMON_CLK
+	struct clk clk32khz_ap;
+	struct clk clk32khz_cp;
+	struct clk clk32khz_pmic;
+#endif
+	u8 buck2_vol[8];
+	u8 buck3_vol[8];
+	u8 buck4_vol[8];
+};
+
+#ifdef CONFIG_COMMON_CLK
+
+#define to_max77686_data(__name)	container_of(hw->clk,		\
+					struct max77686_data, __name)
+
+static struct clk_gate clk32khz_ap_hw = {
+		.ret = MAX77686_REG_32KH,
+		.bit_idx = 0,
+		.flags = 0,
+		.lock = clk_lock,
+};
+
+static struct clk_gate clk32khz_cp_hw = {
+		.ret = MAX77686_REG_32KH,
+		.bit_idx = 1,
+		.flags = 0,
+		.lock = clk_lock,
+};
+
+static struct clk_gate clk32khz_pmic_hw = {
+		.ret = MAX77686_REG_32KH,
+		.bit_idx = 2,
+		.flags = 0,
+		.lock = clk_lock,
+};
+
+static int *clk_enable(struct clk_hw *hw);
+static void *clk_disable(struct clk_hw *hw);
+static int *clk_is_enable(struct clk_hw *hw);
+
+static struct clk_ops clk32khz_ops {
+	.enable		= clk_enable,
+	.disable	= clk_disable,
+	.is_enable	= cli_is_enable,
+};
+#endif
+
+static int max77686_set_voltage_time_sel(struct regulator_dev *rdev,
+			unsigned int old_selector, unsigned int new_selector)
+{
+	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
+	int rid = rdev_get_id(rdev);
+
+	switch (rid) {
+	case MAX77686_BUCK2 ... MAX77686_BUCK4:
+		return (DIV_ROUND_UP(rdev->desc->uV_step
+			* abs(new_selector - old_selector),
+			max77686->ramp_delay * 1000));
+	}
+	/* Unconditionally 100 mV/us */
+	return (DIV_ROUND_UP(rdev->desc->uV_step
+		 * abs(new_selector - old_selector), 100000));
+}
+
+static struct regulator_ops max77686_ldo_ops = {
+	.list_voltage		= regulator_list_voltage_linear,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_voltage_time_sel	= max77686_set_voltage_time_sel,
+};
+
+static struct regulator_ops max77686_buck_ops = {
+	.list_voltage		= regulator_list_voltage_linear,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_voltage_time_sel	= max77686_set_voltage_time_sel,
+};
+
+#define regulator_desc_ldo(num)		{				\
+	.name		= "LDO"#num,					\
+	.id		= MAX77686_LDO##num,				\
+	.ops		= &max77686_ldo_ops,				\
+	.type		= REGULATOR_VOLTAGE,				\
+	.owner		= THIS_MODULE,					\
+	.min_uV		= MAX77686_LDO_MINUV,				\
+	.uV_step	= MAX77686_LDO_UVSTEP,				\
+	.n_voltages	= MAX77686_VSEL_MASK + 1,			\
+	.vsel_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
+	.vsel_mask	= MAX77686_VSEL_MASK,				\
+	.enable_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
+	.enable_mask	= MAX77686_OPMODE_MASK				\
+			<< MAX77686_OPMODE_SHIFT,			\
+}
+#define regulator_desc_ldo_low(num)		{			\
+	.name		= "LDO"#num,					\
+	.id		= MAX77686_LDO##num,				\
+	.ops		= &max77686_ldo_ops,				\
+	.type		= REGULATOR_VOLTAGE,				\
+	.owner		= THIS_MODULE,					\
+	.min_uV		= MAX77686_LDO_LOW_MINUV,			\
+	.uV_step	= MAX77686_LDO_LOW_UVSTEP,			\
+	.n_voltages	= MAX77686_VSEL_MASK + 1,			\
+	.vsel_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
+	.vsel_mask	= MAX77686_VSEL_MASK,				\
+	.enable_reg	= MAX77686_REG_LDO1CTRL1 + num - 1,		\
+	.enable_mask	= MAX77686_OPMODE_MASK				\
+			<< MAX77686_OPMODE_SHIFT,			\
+}
+#define regulator_desc_buck(num)		{			\
+	.name		= "BUCK"#num,					\
+	.id		= MAX77686_BUCK##num,				\
+	.ops		= &max77686_buck_ops,				\
+	.type		= REGULATOR_VOLTAGE,				\
+	.owner		= THIS_MODULE,					\
+	.min_uV		= MAX77686_BUCK_MINUV,				\
+	.uV_step	= MAX77686_BUCK_UVSTEP,				\
+	.n_voltages	= MAX77686_VSEL_MASK + 1,			\
+	.vsel_reg	= MAX77686_REG_BUCK5OUT + (num - 5) * 2,	\
+	.vsel_mask	= MAX77686_VSEL_MASK,				\
+	.enable_reg	= MAX77686_REG_BUCK5CTRL + (num - 5) * 2,	\
+	.enable_mask	= MAX77686_OPMODE_MASK,				\
+}
+#define regulator_desc_buck1(num)		{			\
+	.name		= "BUCK"#num,					\
+	.id		= MAX77686_BUCK##num,				\
+	.ops		= &max77686_buck_ops,				\
+	.type		= REGULATOR_VOLTAGE,				\
+	.owner		= THIS_MODULE,					\
+	.min_uV		= MAX77686_BUCK_MINUV,				\
+	.uV_step	= MAX77686_BUCK_UVSTEP,				\
+	.n_voltages	= MAX77686_VSEL_MASK + 1,			\
+	.vsel_reg	= MAX77686_REG_BUCK1OUT,			\
+	.vsel_mask	= MAX77686_VSEL_MASK,				\
+	.enable_reg	= MAX77686_REG_BUCK1CTRL,			\
+	.enable_mask	= MAX77686_OPMODE_MASK,				\
+}
+#define regulator_desc_buck_dvs(num)		{			\
+	.name		= "BUCK"#num,					\
+	.id		= MAX77686_BUCK##num,				\
+	.ops		= &max77686_buck_ops,				\
+	.type		= REGULATOR_VOLTAGE,				\
+	.owner		= THIS_MODULE,					\
+	.min_uV		= MAX77686_DVS_MINUV,				\
+	.uV_step	= MAX77686_DVS_UVSTEP,				\
+	.n_voltages	= MAX77686_DVS_VSEL_MASK + 1,			\
+	.vsel_reg	= MAX77686_REG_BUCK2DVS1 + (num - 2) * 10,	\
+	.vsel_mask	= MAX77686_DVS_VSEL_MASK,			\
+	.enable_reg	= MAX77686_REG_BUCK2CTRL1 + (num - 2) * 10,	\
+	.enable_mask	= MAX77686_OPMODE_MASK				\
+			<< MAX77686_OPMODE_BUCK234_SHIFT,		\
+}
+
+static struct regulator_desc regulators[] = {
+	regulator_desc_ldo_low(1),
+	regulator_desc_ldo_low(2),
+	regulator_desc_ldo(3),
+	regulator_desc_ldo(4),
+	regulator_desc_ldo(5),
+	regulator_desc_ldo_low(6),
+	regulator_desc_ldo_low(7),
+	regulator_desc_ldo_low(8),
+	regulator_desc_ldo(9),
+	regulator_desc_ldo(10),
+	regulator_desc_ldo(11),
+	regulator_desc_ldo(12),
+	regulator_desc_ldo(13),
+	regulator_desc_ldo(14),
+	regulator_desc_ldo_low(15),
+	regulator_desc_ldo(16),
+	regulator_desc_ldo(17),
+	regulator_desc_ldo(18),
+	regulator_desc_ldo(19),
+	regulator_desc_ldo(20),
+	regulator_desc_ldo(21),
+	regulator_desc_ldo(22),
+	regulator_desc_ldo(23),
+	regulator_desc_ldo(24),
+	regulator_desc_ldo(25),
+	regulator_desc_ldo(26),
+	regulator_desc_buck1(1),
+	regulator_desc_buck_dvs(2),
+	regulator_desc_buck_dvs(3),
+	regulator_desc_buck_dvs(4),
+	regulator_desc_buck(5),
+	regulator_desc_buck(6),
+	regulator_desc_buck(7),
+	regulator_desc_buck(8),
+	regulator_desc_buck(9),
+};
+
+#ifdef CONFIG_COMMON_CLK
+static int *clk_enable(struct clk_hw *hw)
+{
+	struct max77686_data *max77686 = NULL;
+	struct regmap *regmap;
+	int mask;
+
+	if (hw == &clk32khz_ap_hw) {
+		max77686 = to_max77686_dev(clk32khz_ap);
+		mask = (1 << MAX77686_32KH_AP);
+	} else if (hw == &clk32khz_cp_hw) {
+		max77686 = to_max77686_dev(clk32khz_cp);
+		mask = (1 << MAX77686_32KH_CP);
+	} else if (hw == &clk32khz_pmic_hw) {
+		max77686 = to_max77686_dev(clk32khz_pmic);
+		maske = (1 << MAX77686_P32KH);
+	}
+
+	if (!max77686)
+		return -ENOMEM;
+
+	return regmap_update_bits(regmap, MAX77686_REG_32KHZ, mask, 1);
+}
+
+static void *clk_disable(struct clk_hw *hw)
+{
+	struct max77686_data *max77686 = NULL;
+	struct regmap *regmap;
+	int mask;
+
+	if (hw == &clk32khz_ap_hw) {
+		max77686 = to_max77686_dev(clk32khz_ap);
+		mask = (1 << MAX77686_32KH_AP);
+	} else if (hw == &clk32khz_cp_hw) {
+		max77686 = to_max77686_dev(clk32khz_cp);
+		mask = (1 << MAX77686_32KH_CP);
+	} else if (hw == &clk32khz_pmic_hw) {
+		max77686 = to_max77686_dev(clk32khz_pmic);
+		maske = (1 << MAX77686_P32KH);
+	}
+
+	if (!max77686)
+		return -ENOMEM;
+
+	return regmap_update_bits(regmap, MAX77686_REG_32KHZ, mask, 0);
+}
+
+static int *clk_is_enable(struct clk_hw *hw)
+{
+	struct max77686_data *max77686 = NULL;
+	struct regmap *regmap;
+	int mask, ret;
+	u8 val;
+
+	if (hw == &clk32khz_ap_hw) {
+		max77686 = to_max77686_dev(clk32khz_ap);
+		mask = (1 << MAX77686_32KH_AP);
+	} else if (hw == &clk32khz_cp_hw) {
+		max77686 = to_max77686_dev(clk32khz_cp);
+		mask = (1 << MAX77686_32KH_CP);
+	} else if (hw == &clk32khz_pmic_hw) {
+		max77686 = to_max77686_dev(clk32khz_pmic);
+		maske = (1 << MAX77686_P32KH);
+	}
+
+	if (!max77686)
+		return -ENOMEM;
+
+	ret = regmap_read(regamp, MAX77686_REG_32KHZ, &val);
+	if (ret < 0)
+		return -EINVAL;
+
+	return val & mask;
+}
+
+static int set_max77686_clk_init(int cid, struct clk *clk)
+{
+	switch (cid) {
+	case MAX77686_32KH_AP:
+		clk->name	= "32khap";
+		clk->hw		= &clk32khz_ap_hw;
+		break;
+	case MAX77686_32KH_CP:
+		clk->name	= "32khcp";
+		clk->hw		= &clk32khz_cp_hw;
+		break;
+	case MAX77686_P32KH:
+		clk->name	= "p32kh";
+		clk->hw		= &clk32khz_pmic_hw;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	clk->ops	= &clk_ops;
+	clk->flags	= CLK_IS_ROOT;
+	clk->hw->clk	= clk;
+	return 0;
+}
+#endif /* CONFIG_COMMON_CLK */
+
+static __devinit int max77686_pmic_probe(struct platform_device *pdev)
+{
+	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct max77686_platform_data *pdata = dev_get_platdata(iodev->dev);
+	struct regulator_dev **rdev;
+	struct max77686_data *max77686;
+	struct regulator_init_data **init_data;
+	int i, size;
+	int ret = 0;
+	struct regulator_config config;
+
+	dev_dbg(&pdev->dev, "%s\n", __func__);
+
+	max77686 = devm_kzalloc(&pdev->dev, sizeof(struct max77686_data),
+				GFP_KERNEL);
+	if (!max77686)
+		return -ENOMEM;
+
+	size = sizeof(struct regulator_dev *) * MAX77686_REGULATORS;
+	max77686->rdev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	if (!max77686->rdev)
+		return -ENOMEM;
+
+	rdev = max77686->rdev;
+	max77686->dev = &pdev->dev;
+	max77686->iodev = iodev;
+	if (pdata)
+		max77686->num_regulators = pdata->num_regulators;
+	platform_set_drvdata(pdev, max77686);
+	init_data = devm_kzalloc(&pdev->dev,
+				sizeof(struct regulator_init_data *)
+					 * MAX77686_REGULATORS, GFP_KERNEL);
+	if (!init_data)
+		return -ENOMEM;
+
+	config.dev = max77686->dev;
+	config.regmap = iodev->regmap;
+	config.driver_data = max77686;
+
+	max77686->ramp_delay = MAX77686_RAMP_RATE; /* Set 0x3 for RAMP */
+	regmap_update_bits(max77686->iodev->regmap,
+					 MAX77686_REG_BUCK2CTRL1, 0xC0, 0xC0);
+	regmap_update_bits(max77686->iodev->regmap,
+					 MAX77686_REG_BUCK3CTRL1, 0xC0, 0xC0);
+	regmap_update_bits(max77686->iodev->regmap,
+					 MAX77686_REG_BUCK4CTRL1, 0xC0, 0xC0);
+
+	for (i = 0; i < MAX77686_REGULATORS; i++) {
+		if (pdata)
+			init_data[pdata->regulators[i].id] =
+						 pdata->regulators[i].initdata;
+
+		config.init_data = init_data[i];
+		rdev[i] = regulator_register(&regulators[i], &config);
+
+		if (IS_ERR(rdev[i])) {
+			ret = PTR_ERR(rdev[i]);
+			dev_err(max77686->dev,
+				"regulator init failed for %d\n", i);
+			rdev[i] = NULL;
+			goto err;
+		}
+	}
+
+#ifdef CONFIG_COMMON_CLK
+	set_max77686_clk_init(MAX77686_32KH_AP, &max77686->clk32khz_ap);
+	set_max77686_clk_init(MAX77686_32KH_CP, &max77686->clk32khz_cp);
+	set_max77686_clk_init(MAX77686_P32KH, &max77686->clk32khz_pmic);
+	__clk_init(&pdev->dev, &max77686->clk32khz_ap);
+	__clk_init(&pdev->dev, &max77686->clk32khz_cp);
+	__clk_init(&pdev->dev, &max77686->clk32khz_pmic);
+#endif
+
+	return 0;
+err:
+	for (i = 0; i < MAX77686_REGULATORS; i++) {
+		if (rdev[i])
+			regulator_unregister(rdev[i]);
+	}
+	return ret;
+}
+
+static int __devexit max77686_pmic_remove(struct platform_device *pdev)
+{
+	struct max77686_data *max77686 = platform_get_drvdata(pdev);
+	struct regulator_dev **rdev = max77686->rdev;
+	int i;
+
+	for (i = 0; i < MAX77686_REGULATORS; i++)
+		if (rdev[i])
+			regulator_unregister(rdev[i]);
+
+	return 0;
+}
+
+static const struct platform_device_id max77686_pmic_id[] = {
+	{ "max77686-pmic", 0},
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, max77686_pmic_id);
+
+static struct platform_driver max77686_pmic_driver = {
+	.driver = {
+		.name = "max77686-pmic",
+		.owner = THIS_MODULE,
+	},
+	.probe = max77686_pmic_probe,
+	.remove = __devexit_p(max77686_pmic_remove),
+	.id_table = max77686_pmic_id,
+};
+
+static int __init max77686_pmic_init(void)
+{
+	return platform_driver_register(&max77686_pmic_driver);
+}
+subsys_initcall(max77686_pmic_init);
+
+static void __exit max77686_pmic_cleanup(void)
+{
+	platform_driver_unregister(&max77686_pmic_driver);
+}
+module_exit(max77686_pmic_cleanup);
+
+MODULE_DESCRIPTION("MAXIM 77686 Regulator Driver");
+MODULE_AUTHOR("Chiwoong Byun <woong.byun@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.4.1

