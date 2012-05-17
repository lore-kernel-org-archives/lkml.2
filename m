Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966473Ab2EQNkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 09:40:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47236 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760752Ab2EQNkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 09:40:04 -0400
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH v2 2/2] regulator: Add support for MAX77686.
Date: Thu, 17 May 2012 19:09:27 +0530
Message-Id: <1337261967-26004-3-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337261967-26004-1-git-send-email-yadi.brar@samsung.com>
References: <1337261967-26004-1-git-send-email-yadi.brar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for PMIC/regulator portion of MAX77686 multifunction device.
MAX77686 provides LDOs[1-26] and BUCKs[1-9]. This is initial release of driver
which supports setting and getting the voltage of a regulator with I2C
interface.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/Kconfig    |    9 +
 drivers/regulator/Makefile   |    1 +
 drivers/regulator/max77686.c |  512 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 522 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/max77686.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 4ad4e8d..a41d2cf 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -195,6 +195,15 @@ config REGULATOR_MAX8998
 	  via I2C bus. The provided regulator is suitable for S3C6410
 	  and S5PC1XX chips to control VCC_CORE and VCC_USIM voltages.
 
+config REGULATOR_MAX77686
+	tristate "Maxim 77686 regulator"
+	depends on MFD_MAX77686
+	help
+	  This driver controls a Maxim 77686 voltage regulator via I2C
+	  bus. The provided regulator is suitable for Exynos5 chips to
+	  control VDD_ARM and VDD_INT voltages.It supports LDOs[1-26]
+	  and BUCKs[1-9].
+
 config REGULATOR_PCAP
 	tristate "Motorola PCAP2 regulator driver"
 	depends on EZX_PCAP
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index dcc56dc..949b1f2 100644
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
index 0000000..7379c29
--- /dev/null
+++ b/drivers/regulator/max77686.c
@@ -0,0 +1,512 @@
+/*
+ * max77686.c - Regulator driver for the Maxim 77686
+ *
+ * Copyright (C) 2012 Samsung Electronics Co. Ltd.
+ * Chiwoong Byun <woong.byun@samsung.com>
+ * Yadwinder Singh Brar <yadi.brar@samsung.com>
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
+#include <linux/bug.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/mfd/max77686.h>
+#include <linux/mfd/max77686-private.h>
+
+#define RAMP_VALUE (max77686->ramp_delay << 6)
+
+struct max77686_data {
+	struct device *dev;
+	struct max77686_dev *iodev;
+	int num_regulators;
+	struct regulator_dev **rdev;
+	int ramp_delay;		/* index of ramp_delay */
+
+	/*GPIO-DVS feature is not enabled with the
+	 *current version of MAX77686 driver.*/
+};
+
+static int max77686_get_enable_register(struct regulator_dev *rdev,
+					int *reg, int *mask, int *pattern)
+{
+	int rid = rdev_get_id(rdev);
+
+	switch (rid) {
+	case MAX77686_LDO1...MAX77686_LDO26:
+		*reg = MAX77686_REG_LDO1CTRL1 + (rid - MAX77686_LDO1);
+		*mask = 0xc0;
+		*pattern = 0xc0;
+		break;
+	case MAX77686_BUCK1:
+		*reg = MAX77686_REG_BUCK1CTRL;
+		*mask = 0x03;
+		*pattern = 0x03;
+		break;
+	case MAX77686_BUCK2:
+		*reg = MAX77686_REG_BUCK2CTRL1;
+		*mask = 0x30;
+		*pattern = 0x10;
+		break;
+	case MAX77686_BUCK3:
+		*reg = MAX77686_REG_BUCK3CTRL1;
+		*mask = 0x30;
+		*pattern = 0x10;
+		break;
+	case MAX77686_BUCK4:
+		*reg = MAX77686_REG_BUCK4CTRL1;
+		*mask = 0x30;
+		*pattern = 0x10;
+		break;
+	case MAX77686_BUCK5...MAX77686_BUCK9:
+		*reg = MAX77686_REG_BUCK5CTRL + (rid - MAX77686_BUCK5) * 2;
+		*mask = 0x03;
+		*pattern = 0x03;
+		break;
+	default:
+		/* Not controllable or not exists */
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int max77686_reg_is_enabled(struct regulator_dev *rdev)
+{
+	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max77686->iodev->i2c;
+	int ret, reg, mask, pattern;
+	int val;
+
+	ret = max77686_get_enable_register(rdev, &reg, &mask, &pattern);
+	if (ret)
+		return ret;
+
+	ret = max77686_read_reg(i2c, reg, &val);
+	if (ret)
+		return ret;
+
+	return (val & mask) == pattern;
+}
+
+static int max77686_reg_enable(struct regulator_dev *rdev)
+{
+	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max77686->iodev->i2c;
+	int ret, reg, mask, pattern;
+
+	ret = max77686_get_enable_register(rdev, &reg, &mask, &pattern);
+	if (ret)
+		return ret;
+
+	return max77686_update_reg(i2c, reg, pattern, mask);
+}
+
+static int max77686_reg_disable(struct regulator_dev *rdev)
+{
+	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max77686->iodev->i2c;
+	int ret, reg, mask, pattern;
+
+	ret = max77686_get_enable_register(rdev, &reg, &mask, &pattern);
+	if (ret)
+		return ret;
+
+	return max77686_update_reg(i2c, reg, ~mask, mask);
+}
+
+static int max77686_get_voltage_register(struct regulator_dev *rdev,
+					 int *_reg, int *_shift, int *_mask)
+{
+	int rid = rdev_get_id(rdev);
+	int reg, shift = 0, mask = 0x3f;
+
+	switch (rid) {
+	case MAX77686_LDO1...MAX77686_LDO26:
+		reg = MAX77686_REG_LDO1CTRL1 + (rid - MAX77686_LDO1);
+		break;
+	case MAX77686_BUCK1:
+		reg = MAX77686_REG_BUCK1OUT;
+		break;
+	case MAX77686_BUCK2:
+		reg = MAX77686_REG_BUCK2DVS1;
+		mask = 0xff;
+		break;
+	case MAX77686_BUCK3:
+		reg = MAX77686_REG_BUCK3DVS1;
+		mask = 0xff;
+		break;
+	case MAX77686_BUCK4:
+		reg = MAX77686_REG_BUCK4DVS1;
+		mask = 0xff;
+		break;
+	case MAX77686_BUCK5...MAX77686_BUCK9:
+		reg = MAX77686_REG_BUCK5OUT + (rid - MAX77686_BUCK5) * 2;
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
+static int max77686_get_voltage_sel(struct regulator_dev *rdev)
+{
+	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max77686->iodev->i2c;
+	int reg, shift, mask, ret;
+	int val;
+
+	ret = max77686_get_voltage_register(rdev, &reg, &shift, &mask);
+	if (ret)
+		return ret;
+
+	ret = max77686_read_reg(i2c, reg, &val);
+	if (ret)
+		return ret;
+
+	val >>= shift;
+	val &= mask;
+
+	return val;
+}
+
+static int max77686_set_voltage_sel(struct regulator_dev *rdev,
+					unsigned sel)
+{
+	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max77686->iodev->i2c;
+	int reg, shift = 0, mask, ret;
+
+	ret = max77686_get_voltage_register(rdev, &reg, &shift, &mask);
+	if (ret)
+		return ret;
+
+	ret = max77686_update_reg(i2c, reg, sel << shift, mask << shift);
+
+	return ret;
+}
+
+static int max77686_voltage_buck_time_sel(struct regulator_dev *rdev,
+					unsigned int old_sel,
+					unsigned int new_sel)
+{
+	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
+	int ramp[] = {13, 27, 55, 100};	/* ramp_rate in mV/uS */
+
+	return DIV_ROUND_UP(rdev->desc->uV_step *
+			    abs(new_sel - old_sel),
+			    ramp[max77686->ramp_delay]);
+}
+
+static struct regulator_ops max77686_ops = {
+	.map_voltage		= regulator_map_voltage_linear,
+	.list_voltage		= regulator_list_voltage_linear,
+	.is_enabled		= max77686_reg_is_enabled,
+	.enable			= max77686_reg_enable,
+	.disable		= max77686_reg_disable,
+	.get_voltage_sel	= max77686_get_voltage_sel,
+	.set_voltage_sel	= max77686_set_voltage_sel,
+};
+
+static struct regulator_ops max77686_buck_ops = {
+	.map_voltage		= regulator_map_voltage_linear,
+	.list_voltage		= regulator_list_voltage_linear,
+	.is_enabled		= max77686_reg_is_enabled,
+	.enable			= max77686_reg_enable,
+	.disable		= max77686_reg_disable,
+	.get_voltage_sel	= max77686_get_voltage_sel,
+	.set_voltage_sel	= max77686_set_voltage_sel,
+	.set_voltage_time_sel	= max77686_voltage_buck_time_sel,
+};
+
+#define regulator_desc_ldo(num)		{	\
+	.name		= "LDO"#num,		\
+	.id		= MAX77686_LDO##num,	\
+	.n_voltages	= 64,			\
+	.ops		= &max77686_ops,	\
+	.type		= REGULATOR_VOLTAGE,	\
+	.owner		= THIS_MODULE,		\
+	.min_uV		= 800000,		\
+	.uV_step	= 50000			\
+}
+#define regulator_desc_ldo_low_vol(num)	{	\
+	.name		= "LDO"#num,		\
+	.id		= MAX77686_LDO##num,	\
+	.ops		= &max77686_ops,	\
+	.type		= REGULATOR_VOLTAGE,	\
+	.owner		= THIS_MODULE,		\
+	.min_uV		= 800000,		\
+	.uV_step	= 25000,		\
+	.n_voltages	= 64		\
+}
+#define regulator_desc_buck(num)	{	\
+	.name		= "BUCK"#num,		\
+	.id		= MAX77686_BUCK##num,	\
+	.ops		= &max77686_ops,	\
+	.type		= REGULATOR_VOLTAGE,	\
+	.owner		= THIS_MODULE,		\
+	.min_uV		= 750000,		\
+	.uV_step	= 50000,		\
+	.n_voltages	= 64			\
+}
+#define regulator_desc_buck_dvs(num)	{	\
+	.name		= "BUCK"#num,		\
+	.id		= MAX77686_BUCK##num,	\
+	.ops		= &max77686_buck_ops,	\
+	.type		= REGULATOR_VOLTAGE,	\
+	.owner		= THIS_MODULE,		\
+	.min_uV		= 600000,		\
+	.uV_step	= 12500,			\
+	.n_voltages	= 256			\
+}
+
+static struct regulator_desc regulators[] = {
+	regulator_desc_ldo_low_vol(1),
+	regulator_desc_ldo_low_vol(2),
+	regulator_desc_ldo(3),
+	regulator_desc_ldo(4),
+	regulator_desc_ldo(5),
+	regulator_desc_ldo_low_vol(6),
+	regulator_desc_ldo_low_vol(7),
+	regulator_desc_ldo_low_vol(8),
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
+	regulator_desc_ldo(19),
+	regulator_desc_ldo(20),
+	regulator_desc_ldo(21),
+	regulator_desc_ldo(22),
+	regulator_desc_ldo(23),
+	regulator_desc_ldo(24),
+	regulator_desc_ldo(25),
+	regulator_desc_ldo(26),
+	regulator_desc_buck(1),
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
+#ifdef CONFIG_OF
+static int max77686_pmic_dt_parse_pdata(struct max77686_dev *iodev,
+					struct max77686_platform_data *pdata)
+{
+	struct device_node *pmic_np, *regulators_np;
+	struct of_regulator_match *rdata;
+	unsigned int i, ret;
+
+	pmic_np = iodev->dev->of_node;
+	if (!pmic_np) {
+		dev_err(iodev->dev, "could not find pmic sub-node\n");
+		return -ENODEV;
+	}
+
+	regulators_np = of_find_node_by_name(pmic_np, "voltage-regulators");
+	if (!regulators_np) {
+		dev_err(iodev->dev, "could not find regulators sub-node\n");
+		return -EINVAL;
+	}
+
+	/* count the number of regulators to be supported in pmic */
+	pdata->num_regulators = ARRAY_SIZE(regulators);
+
+	rdata = devm_kzalloc(iodev->dev, sizeof(*rdata) *
+				(pdata->num_regulators), GFP_KERNEL);
+	if (!rdata) {
+		dev_err(iodev->dev,
+			"could not allocate memory for regulator data\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < pdata->num_regulators; i++)
+		rdata[i].name = regulators[i].name;
+
+	ret = of_regulator_match(iodev->dev, regulators_np, rdata,
+				pdata->num_regulators);
+
+	if (ret < 0)
+		dev_err(iodev->dev, "Parsing DT for regulators failed\n");
+	else
+		dev_info(iodev->dev, "regulators found in device tree : %d\n"
+			, ret);
+
+	pdata->regulators = rdata;
+
+	if (of_property_read_u32(pmic_np, "max77686,buck_ramp_delay", &i))
+		pdata->ramp_delay = i & 0xff;
+
+	return 0;
+}
+#else
+static int max77686_pmic_dt_parse_pdata(struct max77686_dev *iodev,
+					struct max77686_platform_data *pdata)
+{
+	return 0;
+}
+#endif	/* CONFIG_OF */
+
+static __devinit int max77686_pmic_probe(struct platform_device *pdev)
+{
+	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
+	struct max77686_platform_data *pdata = iodev->pdata;
+	struct regulator_dev **rdev;
+	struct max77686_data *max77686;
+	struct i2c_client *i2c = iodev->i2c;
+	struct regulator_config config = { };
+	int i, ret, size;
+
+	if (iodev->dev->of_node) {
+		ret = max77686_pmic_dt_parse_pdata(iodev, pdata);
+		if (ret)
+			return ret;
+	} else {			/* pdata from machine-setup file */
+		if (!pdata) {
+			dev_err(&pdev->dev, "platform data not found\n");
+			return -ENODEV;
+		} else {
+			if (pdata->num_regulators != ARRAY_SIZE(regulators)) {
+				dev_err(&pdev->dev,
+					"incomplete regulator list\n");
+				return -ENODEV;
+			}
+		}
+	}
+
+	max77686 = devm_kzalloc(&pdev->dev, sizeof(struct max77686_data),
+				GFP_KERNEL);
+	if (!max77686)
+		return -ENOMEM;
+
+	size = sizeof(struct regulator_dev *) * pdata->num_regulators;
+	max77686->rdev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	if (!max77686->rdev) {
+		kfree(max77686);
+		return -ENOMEM;
+	}
+
+	rdev = max77686->rdev;
+
+	max77686->dev = &pdev->dev;
+	max77686->iodev = iodev;
+	max77686->num_regulators = pdata->num_regulators;
+
+	if (pdata->ramp_delay < MAX77686_RAMP_RATE_13MV ||
+		pdata->ramp_delay > MAX77686_RAMP_RATE_100MV)
+		pdata->ramp_delay = MAX77686_RAMP_RATE_27MV;	/* default */
+
+	max77686->ramp_delay = pdata->ramp_delay - 1;
+	max77686_update_reg(i2c, MAX77686_REG_BUCK2CTRL1,
+		RAMP_VALUE, RAMP_MASK);
+	max77686_update_reg(i2c, MAX77686_REG_BUCK3CTRL1,
+		RAMP_VALUE, RAMP_MASK);
+	max77686_update_reg(i2c, MAX77686_REG_BUCK4CTRL1,
+		RAMP_VALUE, RAMP_MASK);
+
+	platform_set_drvdata(pdev, max77686);
+
+	for (i = 0; i < pdata->num_regulators; i++) {
+		config.dev = max77686->dev;
+		config.init_data = pdata->regulators[i].init_data;
+		config.driver_data = max77686;
+
+		rdev[i] = regulator_register(&regulators[i], &config);
+		if (IS_ERR(rdev[i])) {
+			ret = PTR_ERR(rdev[i]);
+			dev_err(max77686->dev,
+				"regulator init failed for id : %d\n", i);
+			rdev[i] = NULL;
+			goto err;
+		}
+	}
+
+	return 0;
+ err:
+	for (i = 0; i < max77686->num_regulators; i++)
+		if (rdev[i])
+			regulator_unregister(rdev[i]);
+
+	return ret;
+}
+
+static int __devexit max77686_pmic_remove(struct platform_device *pdev)
+{
+	struct max77686_data *max77686 = platform_get_drvdata(pdev);
+	struct regulator_dev **rdev = max77686->rdev;
+	int i;
+
+	for (i = 0; i < max77686->num_regulators; i++)
+		if (rdev[i])
+			regulator_unregister(rdev[i]);
+
+	return 0;
+}
+
+static const struct platform_device_id max77686_pmic_id[] = {
+	{"max77686-pmic", 0},
+	{},
+};
+MODULE_DEVICE_TABLE(platform, max77686_pmic_id);
+
+static struct platform_driver max77686_pmic_driver = {
+	.driver = {
+		   .name = "max77686-pmic",
+		   .owner = THIS_MODULE,
+		   },
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
+MODULE_AUTHOR("Yadwinder Singh Brar <yadi.brar@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.0.4

