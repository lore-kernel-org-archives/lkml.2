Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2CIH50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 02:57:26 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51134 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825Ab2CIH5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 02:57:24 -0500
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Nancy Chen <Nancy.Chen@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Axel Lin <axel.lin@gmail.com>
Subject: [PATCH v11] Regulator: Add Anatop regulator driver
Date: Fri,  9 Mar 2012 15:57:09 +0800
Message-Id: <1331279829-4584-1-git-send-email-paul.liu@linaro.org>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>

Anatop is an integrated regulator inside i.MX6 SoC.
There are 3 digital regulators which controls PU, CORE (ARM), and SOC.
And 3 analog regulators which controls 1P1, 2P5, 3P0 (USB).
This patch adds the Anatop regulator driver.

Signed-off-by: Nancy Chen <Nancy.Chen@freescale.com>
Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/Kconfig            |    8 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/anatop-regulator.c |  238 ++++++++++++++++++++++++++++++++++
 3 files changed, 247 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/anatop-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index c733df5..a229de9 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -102,6 +102,14 @@ config REGULATOR_DA9052
 	  This driver supports the voltage regulators of DA9052-BC and
 	  DA9053-AA/Bx PMIC.
 
+config REGULATOR_ANATOP
+	tristate "Freescale i.MX on-chip ANATOP LDO regulators"
+	depends on MFD_ANATOP
+	help
+	  Say y here to support Freescale i.MX on-chip ANATOP LDOs
+	  regulators. It is recommended that this option be
+	  enabled on i.MX6 platform.
+
 config REGULATOR_MC13XXX_CORE
 	tristate
 
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 2b09c81..b5042c8 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
 obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
 obj-$(CONFIG_REGULATOR_AD5398) += ad5398.o
+obj-$(CONFIG_REGULATOR_ANATOP) += anatop-regulator.o
 obj-$(CONFIG_REGULATOR_BQ24022) += bq24022.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_DA9052)	+= da9052-regulator.o
diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
new file mode 100644
index 0000000..53a2d87
--- /dev/null
+++ b/drivers/regulator/anatop-regulator.c
@@ -0,0 +1,238 @@
+/*
+ * Copyright (C) 2011 Freescale Semiconductor, Inc. All Rights Reserved.
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/mfd/anatop.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/of_regulator.h>
+
+struct anatop_regulator {
+	const char *name;
+	u32 control_reg;
+	struct anatop *mfd;
+	int vol_bit_shift;
+	int vol_bit_width;
+	int min_bit_val;
+	int min_voltage;
+	int max_voltage;
+	struct regulator_desc rdesc;
+	struct regulator_init_data *initdata;
+};
+
+static int anatop_set_voltage(struct regulator_dev *reg, int min_uV,
+				  int max_uV, unsigned *selector)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+	u32 val, sel;
+	int uv;
+
+	uv = min_uV;
+	dev_dbg(&reg->dev, "%s: uv %d, min %d, max %d\n", __func__,
+		uv, anatop_reg->min_voltage,
+		anatop_reg->max_voltage);
+
+	if (uv < anatop_reg->min_voltage) {
+		if (max_uV > anatop_reg->min_voltage)
+			uv = anatop_reg->min_voltage;
+		else
+			return -EINVAL;
+	}
+
+	if (!anatop_reg->control_reg)
+		return -ENOTSUPP;
+
+	sel = DIV_ROUND_UP(uv - anatop_reg->min_voltage, 25000);
+	if (sel * 25000 + anatop_reg->min_voltage > anatop_reg->max_voltage)
+		return -EINVAL;
+	val = anatop_reg->min_bit_val + sel;
+	*selector = sel;
+	dev_dbg(&reg->dev, "%s: calculated val %d\n", __func__, val);
+	anatop_set_bits(anatop_reg->mfd,
+			anatop_reg->control_reg,
+			anatop_reg->vol_bit_shift,
+			anatop_reg->vol_bit_width,
+			val);
+
+	return 0;
+}
+
+static int anatop_get_voltage_sel(struct regulator_dev *reg)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+	u32 val;
+
+	if (!anatop_reg->control_reg)
+		return -ENOTSUPP;
+
+	val = anatop_get_bits(anatop_reg->mfd,
+			      anatop_reg->control_reg,
+			      anatop_reg->vol_bit_shift,
+			      anatop_reg->vol_bit_width);
+
+	return val - anatop_reg->min_bit_val;
+}
+
+static int anatop_list_voltage(struct regulator_dev *reg, unsigned selector)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+	int uv;
+
+	uv = anatop_reg->min_voltage + selector * 25000;
+	dev_dbg(&reg->dev, "vddio = %d, selector = %u\n", uv, selector);
+
+	return uv;
+}
+
+static struct regulator_ops anatop_rops = {
+	.set_voltage     = anatop_set_voltage,
+	.get_voltage_sel = anatop_get_voltage_sel,
+	.list_voltage    = anatop_list_voltage,
+};
+
+static int __devinit anatop_regulator_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct regulator_desc *rdesc;
+	struct regulator_dev *rdev;
+	struct anatop_regulator *sreg;
+	struct regulator_init_data *initdata;
+	struct anatop *anatopmfd = dev_get_drvdata(pdev->dev.parent);
+	int ret = 0;
+
+	initdata = of_get_regulator_init_data(dev, np);
+	sreg = devm_kzalloc(dev, sizeof(*sreg), GFP_KERNEL);
+	if (!sreg)
+		return -ENOMEM;
+	sreg->initdata = initdata;
+	sreg->name = kstrdup(of_get_property(np, "regulator-name", NULL),
+			     GFP_KERNEL);
+	rdesc = &sreg->rdesc;
+	memset(rdesc, 0, sizeof(*rdesc));
+	rdesc->name = sreg->name;
+	rdesc->ops = &anatop_rops;
+	rdesc->type = REGULATOR_VOLTAGE;
+	rdesc->owner = THIS_MODULE;
+	sreg->mfd = anatopmfd;
+	ret = of_property_read_u32(np, "reg", &sreg->control_reg);
+	if (ret) {
+		dev_err(dev, "no reg property set\n");
+		goto anatop_probe_end;
+	}
+	ret = of_property_read_u32(np, "anatop-vol-bit-width",
+				   &sreg->vol_bit_width);
+	if (ret) {
+		dev_err(dev, "no anatop-vol-bit-width property set\n");
+		goto anatop_probe_end;
+	}
+	ret = of_property_read_u32(np, "anatop-vol-bit-shift",
+				   &sreg->vol_bit_shift);
+	if (ret) {
+		dev_err(dev, "no anatop-vol-bit-shift property set\n");
+		goto anatop_probe_end;
+	}
+	ret = of_property_read_u32(np, "anatop-min-bit-val",
+				   &sreg->min_bit_val);
+	if (ret) {
+		dev_err(dev, "no anatop-min-bit-val property set\n");
+		goto anatop_probe_end;
+	}
+	ret = of_property_read_u32(np, "anatop-min-voltage",
+				   &sreg->min_voltage);
+	if (ret) {
+		dev_err(dev, "no anatop-min-voltage property set\n");
+		goto anatop_probe_end;
+	}
+	ret = of_property_read_u32(np, "anatop-max-voltage",
+				   &sreg->max_voltage);
+	if (ret) {
+		dev_err(dev, "no anatop-max-voltage property set\n");
+		goto anatop_probe_end;
+	}
+
+	/* register regulator */
+	rdev = regulator_register(rdesc, dev,
+				  initdata, sreg, pdev->dev.of_node);
+	if (IS_ERR(rdev)) {
+		dev_err(dev, "failed to register %s\n",
+			rdesc->name);
+		ret = PTR_ERR(rdev);
+		goto anatop_probe_end;
+	}
+
+	platform_set_drvdata(pdev, rdev);
+
+anatop_probe_end:
+	if (ret)
+		kfree(sreg->name);
+
+	return ret;
+}
+
+static int __devexit anatop_regulator_remove(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+	struct anatop_regulator *sreg = rdev_get_drvdata(rdev);
+	const char *name = sreg->name;
+
+	regulator_unregister(rdev);
+	kfree(name);
+
+	return 0;
+}
+
+static struct of_device_id __devinitdata of_anatop_regulator_match_tbl[] = {
+	{ .compatible = "fsl,anatop-regulator", },
+	{ /* end */ }
+};
+
+static struct platform_driver anatop_regulator = {
+	.driver = {
+		.name	= "anatop_regulator",
+		.owner  = THIS_MODULE,
+		.of_match_table = of_anatop_regulator_match_tbl,
+	},
+	.probe	= anatop_regulator_probe,
+	.remove	= anatop_regulator_remove,
+};
+
+static int __init anatop_regulator_init(void)
+{
+	return platform_driver_register(&anatop_regulator);
+}
+postcore_initcall(anatop_regulator_init);
+
+static void __exit anatop_regulator_exit(void)
+{
+	platform_driver_unregister(&anatop_regulator);
+}
+module_exit(anatop_regulator_exit);
+
+MODULE_AUTHOR("Nancy Chen <Nancy.Chen@freescale.com>, "
+	      "Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>");
+MODULE_DESCRIPTION("ANATOP Regulator driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.1

