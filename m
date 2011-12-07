Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1LGNxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 08:53:46 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44147 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab1LGNxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 08:53:44 -0500
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: patches@linaro.org, eric.miao@linaro.org,
        broonie@opensource.wolfsonmicro.com,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Nancy Chen <Nancy.Chen@freescale.com>, Liam Girdwood <lrg@ti.com>
Subject: [PATCH] Regulator: Add Anatop regulator driver
Date: Wed,  7 Dec 2011 21:53:18 +0800
Message-Id: <1323265998-29088-2-git-send-email-paul.liu@linaro.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323265998-29088-1-git-send-email-paul.liu@linaro.org>
References: <1323265998-29088-1-git-send-email-paul.liu@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>

Anatop regulator driver is used by i.MX6 SoC. This patch adds the
Anatop regulator driver.

Signed-off-by: Nancy Chen <Nancy.Chen@freescale.com>
Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>
---
 drivers/regulator/Kconfig                  |    7 +
 drivers/regulator/Makefile                 |    1 +
 drivers/regulator/anatop-regulator.c       |  236 ++++++++++++++++++++++++++++
 include/linux/regulator/anatop-regulator.h |   82 ++++++++++
 4 files changed, 326 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/anatop-regulator.c
 create mode 100644 include/linux/regulator/anatop-regulator.h

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 9713b1b..790eca5 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -327,5 +327,12 @@ config REGULATOR_AAT2870
 	  If you have a AnalogicTech AAT2870 say Y to enable the
 	  regulator driver.
 
+config REGULATOR_ANATOP
+	tristate "ANATOP LDO regulators"
+	depends on ARCH_MX6
+	default y if ARCH_MX6
+	help
+	  Say y here to support ANATOP LDOs regulators.
+
 endif
 
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 93a6318..990c332 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -46,5 +46,6 @@ obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
 obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
 obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
 obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
+obj-$(CONFIG_REGULATOR_ANATOP) += anatop-regulator.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
new file mode 100644
index 0000000..61ad1c2
--- /dev/null
+++ b/drivers/regulator/anatop-regulator.c
@@ -0,0 +1,236 @@
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
+#include <linux/platform_device.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/anatop-regulator.h>
+
+static int anatop_set_voltage(struct regulator_dev *reg, int min_uV,
+				  int max_uV, unsigned *selector)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+
+	if (anatop_reg->rdata->set_voltage)
+		return anatop_reg->rdata->set_voltage(anatop_reg, max_uV);
+	else
+		return -ENOTSUPP;
+}
+
+static int anatop_get_voltage(struct regulator_dev *reg)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+
+	if (anatop_reg->rdata->get_voltage)
+		return anatop_reg->rdata->get_voltage(anatop_reg);
+	else
+		return -ENOTSUPP;
+}
+
+static int anatop_enable(struct regulator_dev *reg)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+
+	return anatop_reg->rdata->enable(anatop_reg);
+}
+
+static int anatop_disable(struct regulator_dev *reg)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+
+	return anatop_reg->rdata->disable(anatop_reg);
+}
+
+static int anatop_is_enabled(struct regulator_dev *reg)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+
+	return anatop_reg->rdata->is_enabled(anatop_reg);
+}
+
+static struct regulator_ops anatop_rops = {
+	.set_voltage	= anatop_set_voltage,
+	.get_voltage	= anatop_get_voltage,
+	.enable		= anatop_enable,
+	.disable	= anatop_disable,
+	.is_enabled	= anatop_is_enabled,
+};
+
+static struct regulator_desc anatop_reg_desc[] = {
+	{
+		.name = "vddpu",
+		.id = ANATOP_VDDPU,
+		.ops = &anatop_rops,
+		.irq = 0,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE
+	},
+	{
+		.name = "vddcore",
+		.id = ANATOP_VDDCORE,
+		.ops = &anatop_rops,
+		.irq = 0,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE
+	},
+	{
+		.name = "vddsoc",
+		.id = ANATOP_VDDSOC,
+		.ops = &anatop_rops,
+		.irq = 0,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE
+	},
+	{
+		.name = "vdd2p5",
+		.id = ANATOP_VDD2P5,
+		.ops = &anatop_rops,
+		.irq = 0,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE
+	},
+	{
+		.name = "vdd1p1",
+		.id = ANATOP_VDD1P1,
+		.ops = &anatop_rops,
+		.irq = 0,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE
+	},
+	{
+		.name = "vdd3p0",
+		.id = ANATOP_VDD3P0,
+		.ops = &anatop_rops,
+		.irq = 0,
+		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE
+	},
+};
+
+int anatop_regulator_probe(struct platform_device *pdev)
+{
+	struct regulator_desc *rdesc;
+	struct regulator_dev *rdev;
+	struct anatop_regulator *sreg;
+	struct regulator_init_data *initdata;
+
+	sreg = platform_get_drvdata(pdev);
+	initdata = pdev->dev.platform_data;
+	sreg->cur_current = 0;
+	sreg->next_current = 0;
+	sreg->cur_voltage = 0;
+
+	init_waitqueue_head(&sreg->wait_q);
+	spin_lock_init(&sreg->lock);
+
+	if (pdev->id > ANATOP_SUPPLY_NUM) {
+		rdesc = kzalloc(sizeof(struct regulator_desc), GFP_KERNEL);
+		memcpy(rdesc, &anatop_reg_desc[ANATOP_SUPPLY_NUM],
+			sizeof(struct regulator_desc));
+		rdesc->name = kstrdup(sreg->rdata->name, GFP_KERNEL);
+	} else
+		rdesc = &anatop_reg_desc[pdev->id];
+
+	pr_debug("probing regulator %s %s %d\n",
+			sreg->rdata->name,
+			rdesc->name,
+			pdev->id);
+
+	/* register regulator */
+	rdev = regulator_register(rdesc, &pdev->dev,
+				  initdata, sreg);
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
+
+int anatop_regulator_remove(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+
+	regulator_unregister(rdev);
+
+	return 0;
+
+}
+
+int anatop_register_regulator(
+		struct anatop_regulator *reg_data, int reg,
+			      struct regulator_init_data *initdata)
+{
+	struct platform_device *pdev;
+	int ret;
+
+	pdev = platform_device_alloc("anatop_reg", reg);
+	if (!pdev)
+		return -ENOMEM;
+
+	pdev->dev.platform_data = initdata;
+
+	platform_set_drvdata(pdev, reg_data);
+	ret = platform_device_add(pdev);
+
+	if (ret != 0) {
+		pr_debug("Failed to register regulator %d: %d\n",
+			reg, ret);
+		platform_device_del(pdev);
+	}
+	pr_debug("register regulator %s, %d: %d\n",
+			reg_data->rdata->name, reg, ret);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(anatop_register_regulator);
+
+struct platform_driver anatop_reg = {
+	.driver = {
+		.name	= "anatop_reg",
+	},
+	.probe	= anatop_regulator_probe,
+	.remove	= anatop_regulator_remove,
+};
+
+int anatop_regulator_init(void)
+{
+	return platform_driver_register(&anatop_reg);
+}
+
+void anatop_regulator_exit(void)
+{
+	platform_driver_unregister(&anatop_reg);
+}
+
+postcore_initcall(anatop_regulator_init);
+module_exit(anatop_regulator_exit);
+
+MODULE_AUTHOR("Freescale Semiconductor, Inc.");
+MODULE_DESCRIPTION("ANATOP Regulator driver");
+MODULE_LICENSE("GPL");
+
diff --git a/include/linux/regulator/anatop-regulator.h b/include/linux/regulator/anatop-regulator.h
new file mode 100644
index 0000000..a1d98ed
--- /dev/null
+++ b/include/linux/regulator/anatop-regulator.h
@@ -0,0 +1,82 @@
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
+
+/* regulator supplies for Anatop */
+enum anatop_regulator_supplies {
+	ANATOP_VDDPU,
+	ANATOP_VDDCORE,
+	ANATOP_VDDSOC,
+	ANATOP_VDD2P5,
+	ANATOP_VDD1P1,
+	ANATOP_VDD3P0,
+	ANATOP_SUPPLY_NUM
+};
+
+struct anatop_regulator {
+	struct regulator_desc regulator;
+	struct anatop_regulator *parent;
+	struct anatop_regulator_data *rdata;
+	struct completion done;
+
+	spinlock_t         lock;
+	wait_queue_head_t  wait_q;
+	struct notifier_block nb;
+
+	int mode;
+	int cur_voltage;
+	int cur_current;
+	int next_current;
+};
+
+
+struct anatop_regulator_data {
+	char name[80];
+	char *parent_name;
+	int (*reg_register)(struct anatop_regulator *sreg);
+	int (*set_voltage)(struct anatop_regulator *sreg, int uv);
+	int (*get_voltage)(struct anatop_regulator *sreg);
+	int (*set_current)(struct anatop_regulator *sreg, int uA);
+	int (*get_current)(struct anatop_regulator *sreg);
+	int (*enable)(struct anatop_regulator *sreg);
+	int (*disable)(struct anatop_regulator *sreg);
+	int (*is_enabled)(struct anatop_regulator *sreg);
+	int (*set_mode)(struct anatop_regulator *sreg, int mode);
+	int (*get_mode)(struct anatop_regulator *sreg);
+	int (*get_optimum_mode)(struct anatop_regulator *sreg,
+			int input_uV, int output_uV, int load_uA);
+	u32 control_reg;
+	int vol_bit_shift;
+	int vol_bit_mask;
+	int min_bit_val;
+	int min_voltage;
+	int max_voltage;
+	int max_current;
+	struct regulation_constraints *cnstraints;
+};
+
+int anatop_register_regulator(
+		struct anatop_regulator *reg_data, int reg,
+		      struct regulator_init_data *initdata);
+
+#endif /* __ANATOP_REGULATOR_H */
-- 
1.7.7.3

