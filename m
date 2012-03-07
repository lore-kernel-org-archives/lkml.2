Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab2CGNYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:24:43 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32773 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758461Ab2CGNYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:24:41 -0500
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Nancy Chen <Nancy.Chen@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v9] Regulator: Add Anatop regulator driver
Date: Wed,  7 Mar 2012 21:24:18 +0800
Message-Id: <1331126658-26926-1-git-send-email-paul.liu@linaro.org>
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
---
 .../bindings/regulator/anatop-regulator.txt        |   28 +++
 drivers/regulator/Kconfig                          |    8 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/anatop-regulator.c               |  231 ++++++++++++++++++++
 4 files changed, 268 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/anatop-regulator.txt
 create mode 100644 drivers/regulator/anatop-regulator.c

diff --git a/Documentation/devicetree/bindings/regulator/anatop-regulator.txt b/Documentation/devicetree/bindings/regulator/anatop-regulator.txt
new file mode 100644
index 0000000..500463e
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/anatop-regulator.txt
@@ -0,0 +1,28 @@
+Anatop Voltage regulators
+
+Required properties:
+- compatible: Must be "fsl,anatop-regulator"
+- vol-bit-shift: Bit shift for the register
+- vol-bit-width: Number of bits used in the register
+- min-bit-val: Minimum value of this register
+- min-voltage: Minimum voltage of this regulator
+- max-voltage: Maximum voltage of this regulator
+
+Any property defined as part of the core regulator
+binding, defined in regulator.txt, can also be used.
+
+Example:
+
+	reg_vddpu: regulator-vddpu@140 {
+		compatible = "fsl,anatop-regulator";
+		regulator-name = "vddpu";
+		regulator-min-microvolt = <725000>;
+		regulator-max-microvolt = <1300000>;
+		regulator-always-on;
+		reg = <0x140>;
+		vol-bit-shift = <9>;
+		vol-bit-width = <5>;
+		min-bit-val = <1>;
+		min-voltage = <725000>;
+		max-voltage = <1300000>;
+	};
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 7a61b17..5366991 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -335,5 +335,13 @@ config REGULATOR_AAT2870
 	  If you have a AnalogicTech AAT2870 say Y to enable the
 	  regulator driver.
 
+config REGULATOR_ANATOP
+	tristate "Freescale i.MX on-chip ANATOP LDO regulators"
+	depends on MFD_ANATOP
+	help
+	  Say y here to support Freescale i.MX on-chip ANATOP LDOs
+	  regulators. It is recommended that this option be
+	  enabled on i.MX6 platform.
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
index 0000000..1e20690
--- /dev/null
+++ b/drivers/regulator/anatop-regulator.c
@@ -0,0 +1,231 @@
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
+	if (anatop_reg->control_reg) {
+		sel = (uv - anatop_reg->min_voltage) / 25000;
+		if (sel * 25000 + anatop_reg->min_voltage
+		    > anatop_reg->max_voltage)
+			return -EINVAL;
+		val = anatop_reg->min_bit_val + sel;
+		*selector = sel;
+		dev_dbg(&reg->dev, "%s: calculated val %d\n", __func__, val);
+		anatop_set_bits(anatop_reg->mfd,
+				anatop_reg->control_reg,
+				anatop_reg->vol_bit_shift,
+				anatop_reg->vol_bit_width,
+				val);
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
+
+	if (anatop_reg->control_reg) {
+		u32 val = anatop_get_bits(anatop_reg->mfd,
+					  anatop_reg->control_reg,
+					  anatop_reg->vol_bit_shift,
+					  anatop_reg->vol_bit_width);
+		selector = val - anatop_reg->min_bit_val;
+		return selector;
+	} else {
+		return -ENOTSUPP;
+	}
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
+	if (of_property_read_u32(np, "reg", &sreg->control_reg)) {
+		dev_err(&pdev->dev, "no reg property set\n");
+		ret = -ENODEV;
+		goto anatop_probe_end;
+	}
+	if (of_property_read_u32(np, "vol-bit-width", &sreg->vol_bit_width)) {
+		dev_err(&pdev->dev, "no vol-bit-width property set\n");
+		ret = -ENODEV;
+		goto anatop_probe_end;
+	}
+	if (of_property_read_u32(np, "vol-bit-shift", &sreg->vol_bit_shift)) {
+		dev_err(&pdev->dev, "no vol-bit-shift property set\n");
+		ret = -ENODEV;
+		goto anatop_probe_end;
+	}
+	if (of_property_read_u32(np, "min-bit-val", &sreg->min_bit_val)) {
+		dev_err(&pdev->dev, "no min-bit-val property set\n");
+		ret = -ENODEV;
+		goto anatop_probe_end;
+	}
+	if (of_property_read_u32(np, "min-voltage", &sreg->min_voltage)) {
+		dev_err(&pdev->dev, "no min-voltage property set\n");
+		ret = -ENODEV;
+		goto anatop_probe_end;
+	}
+	if (of_property_read_u32(np, "max-voltage", &sreg->max_voltage)) {
+		dev_err(&pdev->dev, "no max-voltage property set\n");
+		ret = -ENODEV;
+		goto anatop_probe_end;
+	}
+
+	/* register regulator */
+	rdev = regulator_register(rdesc, &pdev->dev,
+				  initdata, sreg, pdev->dev.of_node);
+	if (IS_ERR(rdev)) {
+		dev_err(&pdev->dev, "failed to register %s\n",
+			rdesc->name);
+		ret = PTR_ERR(rdev);
+		goto anatop_probe_end;
+	}
+
+	platform_set_drvdata(pdev, rdev);
+
+anatop_probe_end:
+	if (ret != 0 && sreg->name)
+		kfree(sreg->name);
+	return ret;
+}
+
+static int __devexit anatop_regulator_remove(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+	struct anatop_regulator *sreg = rdev_get_drvdata(rdev);
+	kfree(sreg->name);
+	regulator_unregister(rdev);
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

