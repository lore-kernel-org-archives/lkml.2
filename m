Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab2BHUv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 15:51:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36868 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab2BHUvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 15:51:54 -0500
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org
Cc: patches@linaro.org, eric.miao@linaro.org, shawn.guo@linaro.org,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Nancy Chen <Nancy.Chen@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH v4 2/2] Regulator: Add Anatop regulator driver
Date: Thu,  9 Feb 2012 04:51:26 +0800
Message-Id: <1328734286-30091-2-git-send-email-paul.liu@linaro.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328734286-30091-1-git-send-email-paul.liu@linaro.org>
References: <1324980994-18462-1-git-send-email-paul.liu@linaro.org>
 <1328734286-30091-1-git-send-email-paul.liu@linaro.org>
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
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>
---
 drivers/regulator/Kconfig                  |    6 +
 drivers/regulator/Makefile                 |    1 +
 drivers/regulator/anatop-regulator.c       |  204 ++++++++++++++++++++++++++++
 include/linux/regulator/anatop-regulator.h |   49 +++++++
 4 files changed, 260 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/anatop-regulator.c
 create mode 100644 include/linux/regulator/anatop-regulator.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 7a61b17..5fbcda2 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -335,5 +335,11 @@ config REGULATOR_AAT2870
 	  If you have a AnalogicTech AAT2870 say Y to enable the
 	  regulator driver.
 
+config REGULATOR_ANATOP
+	tristate "ANATOP LDO regulators"
+	depends on MFD_ANATOP
+	help
+	  Say y here to support ANATOP LDOs regulators.
+
 endif
 
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 503bac8..8440871 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -48,5 +48,6 @@ obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
 obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
 obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
 obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
+obj-$(CONFIG_REGULATOR_ANATOP) += anatop-regulator.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
new file mode 100644
index 0000000..d800c88
--- /dev/null
+++ b/drivers/regulator/anatop-regulator.c
@@ -0,0 +1,204 @@
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
+#include <linux/regulator/driver.h>
+#include <linux/regulator/anatop-regulator.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/regulator/of_regulator.h>
+
+static int anatop_set_voltage(struct regulator_dev *reg, int min_uV,
+				  int max_uV, unsigned *selector)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+	u32 val, sel;
+	int uv;
+
+	uv = min_uV;
+	pr_debug("%s: uv %d, min %d, max %d\n", __func__,
+		 uv, anatop_reg->rdata->min_voltage,
+		 anatop_reg->rdata->max_voltage);
+
+	if (uv < anatop_reg->rdata->min_voltage
+	    || uv > anatop_reg->rdata->max_voltage) {
+		if (max_uV > anatop_reg->rdata->min_voltage)
+			uv = anatop_reg->rdata->min_voltage;
+		else
+			return -EINVAL;
+	}
+
+	if (anatop_reg->rdata->control_reg) {
+		sel = (uv - anatop_reg->rdata->min_voltage) / 25000;
+		val = anatop_reg->rdata->min_bit_val + sel;
+		*selector = sel;
+		pr_debug("%s: calculated val %d\n", __func__, val);
+		anatop_reg->rdata->mfd->write(anatop_reg->rdata->mfd,
+					      anatop_reg->rdata->control_reg,
+					      anatop_reg->rdata->vol_bit_shift,
+					      anatop_reg->rdata->vol_bit_size,
+					      val);
+		return 0;
+	} else {
+		return -ENOTSUPP;
+	}
+}
+
+static int anatop_get_voltage_sel(struct regulator_dev *reg)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+	int selector;
+	struct anatop_regulator_data *rdata = anatop_reg->rdata;
+
+	if (rdata->control_reg) {
+		u32 val = rdata->mfd->read(rdata->mfd,
+				     rdata->control_reg,
+				     rdata->vol_bit_shift,
+				     rdata->vol_bit_size);
+		selector = val - rdata->min_bit_val;
+		return selector;
+	} else {
+		return -ENOTSUPP;
+	}
+}
+
+static int anatop_list_voltage(struct regulator_dev *dev, unsigned selector)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(dev);
+	int uv;
+	struct anatop_regulator_data *rdata = anatop_reg->rdata;
+
+	uv = rdata->min_voltage + selector * 25000;
+	pr_debug("vddio = %d, selector = %u\n", uv, selector);
+	return uv;
+}
+
+static struct regulator_ops anatop_rops = {
+	.set_voltage     = anatop_set_voltage,
+	.get_voltage_sel = anatop_get_voltage_sel,
+	.list_voltage    = anatop_list_voltage,
+};
+
+int anatop_regulator_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct regulator_desc *rdesc;
+	struct regulator_dev *rdev;
+	struct anatop_regulator *sreg;
+	struct regulator_init_data *initdata;
+	struct anatop *anatopmfd = dev_get_drvdata(pdev->dev.parent);
+	const __be32 *rval;
+	u64 ofsize;
+
+	initdata = of_get_regulator_init_data(dev, dev->of_node);
+	sreg = devm_kzalloc(dev, sizeof(struct anatop_regulator), GFP_KERNEL);
+	if (!sreg)
+		return -EINVAL;
+	rdesc = devm_kzalloc(dev, sizeof(struct regulator_desc), GFP_KERNEL);
+	if (!rdesc)
+		return -EINVAL;
+	sreg->initdata = initdata;
+	sreg->regulator = rdesc;
+	memset(rdesc, 0, sizeof(struct regulator_desc));
+	rdesc->name = kstrdup(of_get_property(np, "regulator-name", NULL),
+			      GFP_KERNEL);
+	rdesc->ops = &anatop_rops;
+	rdesc->type = REGULATOR_VOLTAGE;
+	rdesc->owner = THIS_MODULE;
+	sreg->rdata = devm_kzalloc(dev,
+				   sizeof(struct anatop_regulator_data),
+				   GFP_KERNEL);
+	sreg->rdata->name = kstrdup(rdesc->name, GFP_KERNEL);
+	rval = of_get_address(np, 0, &ofsize, NULL);
+	if (rval) {
+		sreg->rdata->control_reg = be32_to_cpu(rval[0]);
+		sreg->rdata->vol_bit_shift = be32_to_cpu(rval[1]);
+	}
+	sreg->rdata->mfd = anatopmfd;
+	sreg->rdata->vol_bit_size = (int)ofsize;
+	rval = of_get_property(np, "min-bit-val", NULL);
+	if (rval)
+		sreg->rdata->min_bit_val = be32_to_cpu(*rval);
+	rval = of_get_property(np, "min-voltage", NULL);
+	if (rval)
+		sreg->rdata->min_voltage = be32_to_cpu(*rval);
+	rval = of_get_property(np, "max-voltage", NULL);
+	if (rval)
+		sreg->rdata->max_voltage = be32_to_cpu(*rval);
+
+	/* register regulator */
+	rdev = regulator_register(rdesc, &pdev->dev,
+				  initdata, sreg, pdev->dev.of_node);
+	platform_set_drvdata(pdev, rdev);
+
+	if (IS_ERR(rdev)) {
+		dev_err(&pdev->dev, "failed to register %s\n",
+			rdesc->name);
+		return PTR_ERR(rdev);
+	}
+
+	return 0;
+}
+
+int anatop_regulator_remove(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+	regulator_unregister(rdev);
+	return 0;
+}
+
+struct of_device_id __devinitdata of_anatop_regulator_match_tbl[] = {
+	{ .compatible = "fsl,anatop-regulator", },
+	{ /* end */ }
+};
+
+
+struct platform_driver anatop_regulator = {
+	.driver = {
+		.name	= "anatop_regulator",
+		.owner  = THIS_MODULE,
+		.of_match_table = of_anatop_regulator_match_tbl,
+	},
+	.probe	= anatop_regulator_probe,
+	.remove	= anatop_regulator_remove,
+};
+
+int anatop_regulator_init(void)
+{
+	return platform_driver_register(&anatop_regulator);
+}
+
+void anatop_regulator_exit(void)
+{
+	platform_driver_unregister(&anatop_regulator);
+}
+
+postcore_initcall(anatop_regulator_init);
+module_exit(anatop_regulator_exit);
+
+MODULE_AUTHOR("Freescale Semiconductor, Inc.");
+MODULE_DESCRIPTION("ANATOP Regulator driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/regulator/anatop-regulator.h b/include/linux/regulator/anatop-regulator.h
new file mode 100644
index 0000000..089d519
--- /dev/null
+++ b/include/linux/regulator/anatop-regulator.h
@@ -0,0 +1,49 @@
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
+#ifndef __ANATOP_REGULATOR_H
+#define __ANATOP_REGULATOR_H
+#include <linux/regulator/driver.h>
+#include <linux/mfd/anatop.h>
+
+struct anatop_regulator {
+	struct regulator_desc *regulator;
+	struct regulator_init_data *initdata;
+	struct anatop_regulator_data *rdata;
+};
+
+
+struct anatop_regulator_data {
+	const char *name;
+
+	u32 control_reg;
+	struct anatop *mfd;
+	int vol_bit_shift;
+	int vol_bit_size;
+	int min_bit_val;
+	int min_voltage;
+	int max_voltage;
+};
+
+int anatop_register_regulator(
+		struct anatop_regulator *reg_data, int reg,
+		      struct regulator_init_data *initdata);
+
+#endif /* __ANATOP_REGULATOR_H */
-- 
1.7.8.3

