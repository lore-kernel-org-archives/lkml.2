Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965209Ab2CAJQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:16:52 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49863 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab2CAJQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:16:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of paul.liu@linaro.org designates 10.68.218.228 as permitted sender) smtp.mail=paul.liu@linaro.org
MIME-Version: 1.0
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Nancy Chen <Nancy.Chen@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v5 2/2] Regulator: Add Anatop regulator driver
Date: Thu,  1 Mar 2012 17:10:52 +0800
Message-Id: <1330593052-15184-2-git-send-email-paul.liu@linaro.org>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330593052-15184-1-git-send-email-paul.liu@linaro.org>
References: <1328734286-30091-1-git-send-email-paul.liu@linaro.org>
 <1330593052-15184-1-git-send-email-paul.liu@linaro.org>
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
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
---
 .../bindings/regulator/anatop-regulator.txt        |   28 +++
 drivers/regulator/Kconfig                          |    6 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/anatop-regulator.c               |  203 ++++++++++++++++++++
 include/linux/regulator/anatop-regulator.h         |   40 ++++
 5 files changed, 278 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regulator/anatop-regulator.txt
 create mode 100644 drivers/regulator/anatop-regulator.c
 create mode 100644 include/linux/regulator/anatop-regulator.h

diff --git a/Documentation/devicetree/bindings/regulator/anatop-regulator.txt b/Documentation/devicetree/bindings/regulator/anatop-regulator.txt
new file mode 100644
index 0000000..9ed7326
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/anatop-regulator.txt
@@ -0,0 +1,28 @@
+Anatop Voltage regulators
+
+Required properties:
+- compatible: Must be "fsl,anatop-regulator"
+- vol-bit-shift: Bit shift for the register
+- vol-bit-size: Number of bits used in the register
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
+		vol-bit-size = <5>;
+		min-bit-val = <1>;
+		min-voltage = <725000>;
+		max-voltage = <1300000>;
+	};
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
index 0000000..1f3a878
--- /dev/null
+++ b/drivers/regulator/anatop-regulator.c
@@ -0,0 +1,203 @@
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
+				anatop_reg->vol_bit_size,
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
+					  anatop_reg->vol_bit_size);
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
+	sreg->name = rdesc->name;
+	sreg->mfd = anatopmfd;
+	rval = of_get_address(np, 0, &ofsize, NULL);
+	if (rval)
+		sreg->control_reg = be32_to_cpu(*rval);
+	rval = of_get_property(np, "vol-bit-size", NULL);
+	if (rval)
+		sreg->vol_bit_size = be32_to_cpu(*rval);
+	rval = of_get_property(np, "vol-bit-shift", NULL);
+	if (rval)
+		sreg->vol_bit_shift = be32_to_cpu(*rval);
+	rval = of_get_property(np, "min-bit-val", NULL);
+	if (rval)
+		sreg->min_bit_val = be32_to_cpu(*rval);
+	rval = of_get_property(np, "min-voltage", NULL);
+	if (rval)
+		sreg->min_voltage = be32_to_cpu(*rval);
+	rval = of_get_property(np, "max-voltage", NULL);
+	if (rval)
+		sreg->max_voltage = be32_to_cpu(*rval);
+
+	/* register regulator */
+	rdev = regulator_register(rdesc, &pdev->dev,
+				  initdata, sreg, pdev->dev.of_node);
+	platform_set_drvdata(pdev, rdev);
+
+	if (IS_ERR(rdev)) {
+		dev_err(&pdev->dev, "failed to register %s\n",
+			rdesc->name);
+		kfree(rdesc->name);
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
+postcore_initcall(anatop_regulator_init);
+
+void anatop_regulator_exit(void)
+{
+	platform_driver_unregister(&anatop_regulator);
+}
+module_exit(anatop_regulator_exit);
+
+MODULE_DESCRIPTION("ANATOP Regulator driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/regulator/anatop-regulator.h b/include/linux/regulator/anatop-regulator.h
new file mode 100644
index 0000000..7a9a05b
--- /dev/null
+++ b/include/linux/regulator/anatop-regulator.h
@@ -0,0 +1,40 @@
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
+
+#include <linux/regulator/driver.h>
+#include <linux/mfd/anatop.h>
+
+struct anatop_regulator {
+	struct regulator_desc *regulator;
+	struct regulator_init_data *initdata;
+	const char *name;
+	u32 control_reg;
+	struct anatop *mfd;
+	int vol_bit_shift;
+	int vol_bit_size;
+	int min_bit_val;
+	int min_voltage;
+	int max_voltage;
+};
+
+#endif /* __ANATOP_REGULATOR_H */
-- 
1.7.9

