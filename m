Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2CUHfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 03:35:32 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17068 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab2CUHfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 03:35:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 21 Mar 2012 00:35:30 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] regulator: Add TPS65090 regulator driver
Date: Wed, 21 Mar 2012 13:05:26 +0530
Message-Id: <1332315326-11354-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venu Byravarasu <vbyravarasu@nvidia.com>

Add TPS65090 regulator driver

TPS65090 PMIC from TI consists of 3 step down converters,
2 always on LDOs and 7 current limited load switches. The
output voltages are ON/OFF controllable and are meant to
supply power to the components on target board.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/regulator/Kconfig                    |    8 +
 drivers/regulator/Makefile                   |    1 +
 drivers/regulator/tps65090-regulator.c       |  197 ++++++++++++++++++++++++++
 include/linux/regulator/tps65090-regulator.h |   50 +++++++
 4 files changed, 256 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/tps65090-regulator.c
 create mode 100644 include/linux/regulator/tps65090-regulator.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 36db5a4..6907144 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -366,5 +366,13 @@ config REGULATOR_WM8994
 	  This driver provides support for the voltage regulators on the
 	  WM8994 CODEC.
 
+config REGULATOR_TPS65090
+	tristate "TI TPS65090 Power regulator"
+	depends on MFD_TPS65090
+	help
+	  This driver provides support for the voltage regulators on the
+	  TI TPS65090 PMIC.
+
+
 endif
 
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 94b5274..425d1be 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_REGULATOR_MAX8925) += max8925-regulator.o
 obj-$(CONFIG_REGULATOR_MAX8952) += max8952.o
 obj-$(CONFIG_REGULATOR_MAX8997) += max8997.o
 obj-$(CONFIG_REGULATOR_MAX8998) += max8998.o
+obj-$(CONFIG_REGULATOR_TPS65090) += tps65090-regulator.o
 obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
 obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o
 obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
new file mode 100644
index 0000000..0dee06d
--- /dev/null
+++ b/drivers/regulator/tps65090-regulator.c
@@ -0,0 +1,197 @@
+/*
+ * Regulator driver for tps65090 power management chip.
+ *
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/mfd/tps65090.h>
+#include <linux/regulator/tps65090-regulator.h>
+
+struct tps65090_regulator {
+	int		id;
+	/* Regulator register address.*/
+	u8		reg_en_reg;
+	u8		en_bit;
+
+	/* used by regulator core */
+	struct regulator_desc	desc;
+
+	/* Device */
+	struct device		*dev;
+};
+
+static inline struct device *to_tps65090_dev(struct regulator_dev *rdev)
+{
+	return rdev_get_dev(rdev)->parent->parent;
+}
+
+static int tps65090_reg_is_enabled(struct regulator_dev *rdev)
+{
+	struct tps65090_regulator *ri = rdev_get_drvdata(rdev);
+	struct device *parent = to_tps65090_dev(rdev);
+	uint8_t control;
+	int ret;
+
+	ret = tps65090_read(parent, ri->reg_en_reg, &control);
+	if (ret < 0) {
+		dev_err(&rdev->dev, "Error in reading reg 0x%x\n",
+			ri->reg_en_reg);
+		return ret;
+	}
+	return (((control >> ri->en_bit) & 1) == 1);
+}
+
+static int tps65090_reg_enable(struct regulator_dev *rdev)
+{
+	struct tps65090_regulator *ri = rdev_get_drvdata(rdev);
+	struct device *parent = to_tps65090_dev(rdev);
+	int ret;
+
+	ret = tps65090_set_bits(parent, ri->reg_en_reg, ri->en_bit);
+	if (ret < 0)
+		dev_err(&rdev->dev, "Error in updating reg 0x%x\n",
+			ri->reg_en_reg);
+	return ret;
+}
+
+static int tps65090_reg_disable(struct regulator_dev *rdev)
+{
+	struct tps65090_regulator *ri = rdev_get_drvdata(rdev);
+	struct device *parent = to_tps65090_dev(rdev);
+	int ret;
+
+	ret = tps65090_clr_bits(parent, ri->reg_en_reg, ri->en_bit);
+	if (ret < 0)
+		dev_err(&rdev->dev, "Error in updating reg 0x%x\n",
+			ri->reg_en_reg);
+
+	return ret;
+}
+
+static struct regulator_ops tps65090_ops = {
+	.enable		= tps65090_reg_enable,
+	.disable	= tps65090_reg_disable,
+	.is_enabled	= tps65090_reg_is_enabled,
+};
+
+#define tps65090_REG(_id, _en_reg, _en_bit, _ops)	\
+{							\
+	.reg_en_reg	= _en_reg,			\
+	.en_bit		= _en_bit,			\
+	.id		= TPS65090_ID_##_id,		\
+	.desc = {					\
+		.name = tps65090_rails(_id),		\
+		.id = TPS65090_ID_##_id,		\
+		.ops = &_ops,				\
+		.type = REGULATOR_VOLTAGE,		\
+		.owner = THIS_MODULE,			\
+	},						\
+}
+
+static struct tps65090_regulator TPS65090_regulator[] = {
+	tps65090_REG(DCDC1, 12, 0, tps65090_ops),
+	tps65090_REG(DCDC2, 13, 0, tps65090_ops),
+	tps65090_REG(DCDC3, 14, 0, tps65090_ops),
+	tps65090_REG(FET1,  15, 0, tps65090_ops),
+	tps65090_REG(FET2,  16, 0, tps65090_ops),
+	tps65090_REG(FET3,  17, 0, tps65090_ops),
+	tps65090_REG(FET4,  18, 0, tps65090_ops),
+	tps65090_REG(FET5,  19, 0, tps65090_ops),
+	tps65090_REG(FET6,  20, 0, tps65090_ops),
+	tps65090_REG(FET7,  21, 0, tps65090_ops),
+};
+
+static inline struct tps65090_regulator *find_regulator_info(int id)
+{
+	struct tps65090_regulator *ri;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(TPS65090_regulator); i++) {
+		ri = &TPS65090_regulator[i];
+		if (ri->desc.id == id)
+			return ri;
+	}
+	return NULL;
+}
+
+static int __devinit tps65090_regulator_probe(struct platform_device *pdev)
+{
+	struct tps65090_regulator *ri = NULL;
+	struct regulator_dev *rdev;
+	struct tps65090_regulator_platform_data *tps_pdata;
+	int id = pdev->id;
+
+	dev_dbg(&pdev->dev, "Probing regulator %d\n", id);
+
+	ri = find_regulator_info(id);
+	if (ri == NULL) {
+		dev_err(&pdev->dev, "invalid regulator ID specified\n");
+		return -EINVAL;
+	}
+	tps_pdata = pdev->dev.platform_data;
+	ri->dev = &pdev->dev;
+
+	rdev = regulator_register(&ri->desc, &pdev->dev,
+				&tps_pdata->regulator, ri);
+	if (IS_ERR_OR_NULL(rdev)) {
+		dev_err(&pdev->dev, "failed to register regulator %s\n",
+				ri->desc.name);
+		return PTR_ERR(rdev);
+	}
+
+	platform_set_drvdata(pdev, rdev);
+	return 0;
+}
+
+static int __devexit tps65090_regulator_remove(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+
+	regulator_unregister(rdev);
+	return 0;
+}
+
+static struct platform_driver tps65090_regulator_driver = {
+	.driver	= {
+		.name	= "tps65090-regulator",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= tps65090_regulator_probe,
+	.remove		= __devexit_p(tps65090_regulator_remove),
+};
+
+static int __init tps65090_regulator_init(void)
+{
+	return platform_driver_register(&tps65090_regulator_driver);
+}
+subsys_initcall(tps65090_regulator_init);
+
+static void __exit tps65090_regulator_exit(void)
+{
+	platform_driver_unregister(&tps65090_regulator_driver);
+}
+module_exit(tps65090_regulator_exit);
+
+MODULE_DESCRIPTION("tps65090 regulator driver");
+MODULE_AUTHOR("Venu Byravarasu <vbyravarasu@nvidia.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/regulator/tps65090-regulator.h b/include/linux/regulator/tps65090-regulator.h
new file mode 100644
index 0000000..0fa04b6
--- /dev/null
+++ b/include/linux/regulator/tps65090-regulator.h
@@ -0,0 +1,50 @@
+/*
+ * Regulator driver interface for TI TPS65090 PMIC family
+ *
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __REGULATOR_TPS65090_H
+#define __REGULATOR_TPS65090_H
+
+#include <linux/regulator/machine.h>
+
+#define tps65090_rails(_name) "tps65090_"#_name
+
+enum {
+	TPS65090_ID_DCDC1,
+	TPS65090_ID_DCDC2,
+	TPS65090_ID_DCDC3,
+	TPS65090_ID_FET1,
+	TPS65090_ID_FET2,
+	TPS65090_ID_FET3,
+	TPS65090_ID_FET4,
+	TPS65090_ID_FET5,
+	TPS65090_ID_FET6,
+	TPS65090_ID_FET7,
+};
+
+/*
+ * struct tps65090_regulator_platform_data
+ *
+ * @regulator: The regulator init data.
+ * @slew_rate_uV_per_us: Slew rate microvolt per microsec.
+ */
+
+struct tps65090_regulator_platform_data {
+	struct regulator_init_data regulator;
+};
+
+#endif	/* __REGULATOR_TPS65090_H */
-- 
1.7.1.1

