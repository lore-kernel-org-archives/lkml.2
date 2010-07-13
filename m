Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab0GMGub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 02:50:31 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:60152 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751003Ab0GMGua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 02:50:30 -0400
From: Sundar Iyer <sundar.iyer@stericsson.com>
To: <lrg@slimlogic.co.uk>, <broonie@opensource.wolfsonmicro.com>,
        <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <STEricsson_nomadik_linux@list.st.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "Acked-By: Bengt JONSSON" <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 2/3] regulator: add support for regulators on the ab8500 MFD
Date: Tue, 13 Jul 2010 11:51:29 +0530
Message-ID: <1279002090-11234-3-git-send-email-sundar.iyer@stericsson.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1279002090-11234-1-git-send-email-sundar.iyer@stericsson.com>
References: <1279002090-11234-1-git-send-email-sundar.iyer@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sundar R Iyer <sundar.iyer@stericsson.com>

Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-By: Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Signed-off-by: Sundar R Iyer <sundar.iyer@stericsson.com>
---
 drivers/regulator/Kconfig  |    8 +
 drivers/regulator/Makefile |    1 +
 drivers/regulator/ab8500.c |  414 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 423 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/ab8500.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 7cd8a29..6c14afd 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -221,5 +221,13 @@ config REGULATOR_AD5398
 	help
 	  This driver supports AD5398 and AD5821 current regulator chips.
 	  If building into module, its name is ad5398.ko.
+
+config REGULATOR_AB8500
+	bool "ST-Ericsson AB8500 Power Regulators"
+	depends on AB8500_CORE
+	help
+	  This driver supports the regulators found on the ST-Ericsson mixed
+	  signal AB8500 PMIC
+
 endif
 
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 74a4638..fc696c5 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -34,5 +34,6 @@ obj-$(CONFIG_REGULATOR_TPS65023) += tps65023-regulator.o
 obj-$(CONFIG_REGULATOR_TPS6507X) += tps6507x-regulator.o
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
 obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
+obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
new file mode 100644
index 0000000..e33d279
--- /dev/null
+++ b/drivers/regulator/ab8500.c
@@ -0,0 +1,414 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Author: Sundar Iyer <sundar.iyer@stericsson.com>
+ *
+ * AB8500 peripheral regulators
+ *
+ * AB8500 supports the following regulators,
+ * LDOs - VAUDIO, VANAMIC2/2, VDIGMIC, VINTCORE12, VTVOUT,
+ *        VAUX1/2/3, VANA
+ *
+ * for DB8500 cut 1.0 and previous versions of the silicon, all accesses
+ * to registers are through the DB8500 SPI. In cut 1.1 onwards, these
+ * accesses are through the DB8500 APE_I2C
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/ab8500.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/ab8500.h>
+
+/**
+ * struct ab8500_regulator_info - ab8500 regulator information
+ * @desc: regulator description
+ * @ab8500: ab8500 parent
+ * @regulator_dev: regulator device
+ * @max_uV: maximum voltage (for variable voltage supplies)
+ * @min_uV: minimum voltage (for variable voltage supplies)
+ * @fixed_uV: typical voltage (for fixed voltage supplies)
+ * @update_reg: register to control on/off
+ * @mask: mask to enable/disable regulator
+ * @enable: enable bits to enable the regulator
+ * @voltage_reg: register to control regulator voltage
+ * @voltage_mask: mask to control regulator voltage
+ * @typical_voltages: typical supported voltage table
+ * @voltages_len: number of supported voltages for the regulator
+ */
+struct ab8500_regulator_info {
+	struct regulator_desc	desc;
+	struct ab8500		*ab8500;
+	struct regulator_dev	*regulator;
+	int max_uV;
+	int min_uV;
+	int fixed_uV;
+	int update_reg;
+	int mask;
+	int enable;
+	int voltage_reg;
+	int voltage_mask;
+	int const *typical_voltages;
+	int voltages_len;
+};
+
+/* voltage tables for the vauxn/vintcore supplies */
+static const int ldo_vauxn_voltages[] = {
+	1100000,
+	1200000,
+	1300000,
+	1400000,
+	1500000,
+	1800000,
+	1850000,
+	1900000,
+	2500000,
+	2650000,
+	2700000,
+	2750000,
+	2800000,
+	2900000,
+	3000000,
+	3300000,
+};
+
+static const int ldo_vintcore_voltages[] = {
+	1200000,
+	1225000,
+	1250000,
+	1275000,
+	1300000,
+	1325000,
+	1350000,
+};
+
+static int ab8500_regulator_enable(struct regulator_dev *rdev)
+{
+	int regulator_id, ret;
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= AB8500_NUM_REGULATORS)
+		return -EINVAL;
+
+	ret = ab8500_set_bits(info->ab8500, info->update_reg,
+			info->mask, info->enable);
+	if (ret < 0)
+		dev_dbg(rdev_get_dev(rdev),
+			"couldnt set enable bits for regulator\n");
+	return ret;
+}
+
+static int ab8500_regulator_disable(struct regulator_dev *rdev)
+{
+	int regulator_id, ret;
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= AB8500_NUM_REGULATORS)
+		return -EINVAL;
+
+	ret = ab8500_set_bits(info->ab8500, info->update_reg,
+			info->mask, 0x0);
+	if (ret < 0)
+		dev_dbg(rdev_get_dev(rdev),
+			"couldnt set disable bits for regulator\n");
+	return ret;
+}
+
+static int ab8500_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	int regulator_id, ret;
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= AB8500_NUM_REGULATORS)
+		return -EINVAL;
+
+	ret = ab8500_read(info->ab8500, info->update_reg);
+	if (ret < 0)
+		dev_dbg(rdev_get_dev(rdev),
+			"couldnt read 0x%x register\n", info->update_reg);
+
+	if (ret & info->mask)
+		return true;
+	else
+		return false;
+}
+
+static int ab8500_list_voltage(struct regulator_dev *rdev, unsigned selector)
+{
+	int regulator_id;
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= AB8500_NUM_REGULATORS)
+		return -EINVAL;
+
+	if (selector > info->voltages_len)
+		return -EINVAL;
+
+	return info->typical_voltages[selector];
+}
+
+static int ab8500_regulator_get_voltage(struct regulator_dev *rdev)
+{
+	int regulator_id, ret;
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= AB8500_NUM_REGULATORS)
+		return -EINVAL;
+
+	ret = ab8500_read(info->ab8500, info->voltage_reg);
+	if (ret < 0)
+		dev_dbg(rdev_get_dev(rdev),
+			"couldnt read voltage reg for regulator\n");
+
+	/* vintcore has a different layout */
+	if (regulator_id == AB8500_LDO_INTCORE)
+		ret = info->typical_voltages[(ret & info->voltage_mask) >> 0x3];
+	else
+		ret = info->typical_voltages[(ret & info->voltage_mask)];
+
+	return ret;
+}
+
+static int ab8500_get_best_voltage_index(struct regulator_dev *rdev,
+		int min_uV, int max_uV)
+{
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+	int i;
+
+	/* check the supported voltage */
+	for (i = 0; i < info->voltages_len; i++) {
+		if ((info->typical_voltages[i] >= min_uV) &&
+			(info->typical_voltages[i] <= max_uV))
+			return i;
+	}
+
+	return -EINVAL;
+}
+
+static int ab8500_regulator_set_voltage(struct regulator_dev *rdev,
+		int min_uV, int max_uV)
+{
+	int regulator_id, ret;
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= AB8500_NUM_REGULATORS)
+		return -EINVAL;
+
+	/* get the appropriate voltages within the range */
+	ret = ab8500_get_best_voltage_index(rdev, min_uV, max_uV);
+	if (ret < 0) {
+		dev_dbg(rdev_get_dev(rdev),
+				"coudlnt get best voltage for regulator\n");
+	}
+
+	/* set the registers for the request */
+	ret = ab8500_set_bits(info->ab8500, info->voltage_reg,
+				info->voltage_mask, ret);
+	if (ret < 0) {
+		dev_dbg(rdev_get_dev(rdev),
+		"couldnt set voltage reg for regulator\n");
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
+static struct regulator_ops ab8500_regulator_ops = {
+	.enable		= ab8500_regulator_enable,
+	.disable	= ab8500_regulator_disable,
+	.is_enabled	= ab8500_regulator_is_enabled,
+	.get_voltage	= ab8500_regulator_get_voltage,
+	.set_voltage	= ab8500_regulator_set_voltage,
+	.list_voltage	= ab8500_list_voltage,
+};
+
+static int ab8500_fixed_get_voltage(struct regulator_dev *rdev)
+{
+	int regulator_id;
+	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	regulator_id = rdev_get_id(rdev);
+	if (regulator_id >= AB8500_NUM_REGULATORS)
+		return -EINVAL;
+
+	return info->fixed_uV;
+}
+
+static struct regulator_ops ab8500_ldo_fixed_ops = {
+	.enable		= ab8500_regulator_enable,
+	.disable	= ab8500_regulator_disable,
+	.is_enabled	= ab8500_regulator_is_enabled,
+	.get_voltage	= ab8500_fixed_get_voltage,
+};
+
+#define AB8500_LDO(_id, min, max, reg, reg_mask, reg_enable,	\
+		volt_reg, volt_mask, voltages,			\
+			len_volts)				\
+{								\
+	.desc	= {						\
+		.name	= "LDO-" #_id,				\
+		.ops	= &ab8500_regulator_ops,		\
+		.type	= REGULATOR_VOLTAGE,			\
+		.id	= AB8500_LDO_##_id,			\
+		.owner	= THIS_MODULE,				\
+	},							\
+	.min_uV		= (min) * 1000,				\
+	.max_uV		= (max) * 1000,				\
+	.update_reg	= reg,					\
+	.mask		= reg_mask,				\
+	.enable		= reg_enable,				\
+	.voltage_reg	= volt_reg,				\
+	.voltage_mask	= volt_mask,				\
+	.typical_voltages = voltages,				\
+	.voltages_len	= len_volts,				\
+}
+
+#define AB8500_FIXED_LDO(_id, fixed, reg, reg_mask,	\
+				reg_enable)		\
+{							\
+	.desc	= {					\
+		.name	= "LDO-" #_id,			\
+		.ops	= &ab8500_ldo_fixed_ops,	\
+		.type	= REGULATOR_VOLTAGE,		\
+		.id	= AB8500_LDO_##_id,		\
+		.owner	= THIS_MODULE,			\
+	},						\
+	.fixed_uV	= fixed * 1000,			\
+	.update_reg	= reg,				\
+	.mask		= reg_mask,			\
+	.enable		= reg_enable,			\
+}
+
+static struct ab8500_regulator_info ab8500_regulator_info[] = {
+	/*
+	 * Variable Voltage LDOs
+	 * name, min uV, max uV, ctrl reg, reg mask, enable mask,
+	 *	volt ctrl reg, volt ctrl mask, volt table, num supported volts
+	 */
+	AB8500_LDO(AUX1, 1100, 3300, 0x0409, 0x3, 0x1, 0x041f, 0xf,
+			ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
+	AB8500_LDO(AUX2, 1100, 3300, 0x0409, 0xc, 0x4, 0x0420, 0xf,
+			ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
+	AB8500_LDO(AUX3, 1100, 3300, 0x040a, 0x3, 0x1, 0x0421, 0xf,
+			ldo_vauxn_voltages, ARRAY_SIZE(ldo_vauxn_voltages)),
+	AB8500_LDO(INTCORE, 1100, 3300, 0x0380, 0x4, 0x4, 0x0380, 0x38,
+		ldo_vintcore_voltages, ARRAY_SIZE(ldo_vintcore_voltages)),
+
+	/*
+	 * Fixed Voltage LDOs
+	 *		 name,	o/p uV, ctrl reg, enable, disable
+	 */
+	AB8500_FIXED_LDO(TVOUT,	  2000,   0x0380,   0x2,    0x2),
+	AB8500_FIXED_LDO(AUDIO,   2000,   0x0383,   0x2,    0x2),
+	AB8500_FIXED_LDO(ANAMIC1, 2050,   0x0383,   0x4,    0x4),
+	AB8500_FIXED_LDO(ANAMIC2, 2050,   0x0383,   0x8,    0x8),
+	AB8500_FIXED_LDO(DMIC,    1800,   0x0383,   0x10,   0x10),
+	AB8500_FIXED_LDO(ANA,     1200,   0x0383,   0xc,    0x4),
+};
+
+static inline struct ab8500_regulator_info *find_regulator_info(int id)
+{
+	struct ab8500_regulator_info *info;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ab8500_regulator_info); i++) {
+		info = &ab8500_regulator_info[i];
+		if (info->desc.id == id)
+			return info;
+	}
+	return NULL;
+}
+
+static __devinit int ab8500_regulator_probe(struct platform_device *pdev)
+{
+	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
+	struct ab8500_platform_data *pdata = dev_get_platdata(ab8500->dev);
+	int i, err;
+
+	if (!ab8500) {
+		dev_err(&pdev->dev, "null mfd parent\n");
+		return -EINVAL;
+	}
+
+	/* register all regulators */
+	for (i = 0; i < ARRAY_SIZE(ab8500_regulator_info); i++) {
+		struct ab8500_regulator_info *info = NULL;
+
+		/* assign per-regulator data */
+		info = &ab8500_regulator_info[i];
+		info->ab8500 = ab8500;
+
+		info->regulator = regulator_register(&info->desc, &pdev->dev,
+				pdata->regulator[i], info);
+		if (IS_ERR(info->regulator)) {
+			err = PTR_ERR(info->regulator);
+			dev_err(&pdev->dev, "failed to register regulator %s\n",
+					info->desc.name);
+			/* when we fail, un-register all earlier regulators */
+			i--;
+			while (i > 0) {
+				info = &ab8500_regulator_info[i];
+				regulator_unregister(info->regulator);
+				i--;
+			}
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static __devexit int ab8500_regulator_remove(struct platform_device *pdev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ab8500_regulator_info); i++) {
+		struct ab8500_regulator_info *info = NULL;
+		info = &ab8500_regulator_info[i];
+		regulator_unregister(info->regulator);
+	}
+
+	return 0;
+}
+
+static struct platform_driver ab8500_regulator_driver = {
+	.probe = ab8500_regulator_probe,
+	.remove = __devexit_p(ab8500_regulator_remove),
+	.driver         = {
+		.name   = "ab8500-regulator",
+		.owner  = THIS_MODULE,
+	},
+};
+
+static int __init ab8500_regulator_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&ab8500_regulator_driver);
+	if (ret != 0)
+		pr_err("Failed to register ab8500 regulator: %d\n", ret);
+
+	return ret;
+}
+subsys_initcall(ab8500_regulator_init);
+
+static void __exit ab8500_regulator_exit(void)
+{
+	platform_driver_unregister(&ab8500_regulator_driver);
+}
+module_exit(ab8500_regulator_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Sundar Iyer <sundar.iyer@stericsson.com>");
+MODULE_DESCRIPTION("Regulator Driver for ST-Ericsson AB8500 Mixed-Sig PMIC");
+MODULE_ALIAS("platform:ab8500-regulator");
-- 
1.7.0

