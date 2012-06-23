Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab2FWMSm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 08:18:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53302 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808Ab2FWMSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 08:18:41 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Add driver for Arizona LDO1
Date: Sat, 23 Jun 2012 13:18:35 +0100
Message-Id: <1340453915-6417-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arizona class devices feature an integrated LDO which is intended to
supply the digital core for the device. Provide a driver offering
minimal control of this regulator.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/Makefile       |    2 +-
 drivers/regulator/arizona-ldo1.c |  134 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 135 insertions(+), 1 deletion(-)
 create mode 100644 drivers/regulator/arizona-ldo1.c

diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index ec4a0cf..c746088 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -15,7 +15,7 @@ obj-$(CONFIG_REGULATOR_AB3100) += ab3100.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
 obj-$(CONFIG_REGULATOR_AD5398) += ad5398.o
 obj-$(CONFIG_REGULATOR_ANATOP) += anatop-regulator.o
-obj-$(CONFIG_REGULATOR_ARIZONA) += arizona-micsupp.o
+obj-$(CONFIG_REGULATOR_ARIZONA) += arizona-micsupp.o arizona-ldo1.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_DA9052)	+= da9052-regulator.o
 obj-$(CONFIG_REGULATOR_DBX500_PRCMU) += dbx500-prcmu.o
diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
new file mode 100644
index 0000000..51f02ca
--- /dev/null
+++ b/drivers/regulator/arizona-ldo1.c
@@ -0,0 +1,134 @@
+/*
+ * arizona-ldo1.c  --  LDO1 supply for Arizona devices
+ *
+ * Copyright 2012 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/arizona/core.h>
+#include <linux/mfd/arizona/pdata.h>
+#include <linux/mfd/arizona/registers.h>
+
+struct arizona_ldo1 {
+	struct regulator_dev *regulator;
+	struct arizona *arizona;
+
+	struct regulator_consumer_supply supply;
+	struct regulator_init_data init_data;
+};
+
+static struct regulator_ops arizona_ldo1_ops = {
+	.list_voltage = regulator_list_voltage_linear,
+	.map_voltage = regulator_map_voltage_linear,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+};
+
+static const struct regulator_desc arizona_ldo1 = {
+	.name = "LDO1",
+	.supply_name = "LDOVDD",
+	.type = REGULATOR_VOLTAGE,
+	.ops = &arizona_ldo1_ops,
+
+	.vsel_reg = ARIZONA_LDO1_CONTROL_1,
+	.vsel_mask = ARIZONA_LDO1_VSEL_MASK,
+	.min_uV = 900000,
+	.uV_step = 50000,
+	.n_voltages = 7,
+
+	.owner = THIS_MODULE,
+};
+
+static const struct regulator_init_data arizona_ldo1_default = {
+	.num_consumer_supplies = 1,
+};
+
+static __devinit int arizona_ldo1_probe(struct platform_device *pdev)
+{
+	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
+	struct regulator_config config = { };
+	struct arizona_ldo1 *ldo1;
+	int ret;
+
+	ldo1 = devm_kzalloc(&pdev->dev, sizeof(*ldo1), GFP_KERNEL);
+	if (ldo1 == NULL) {
+		dev_err(&pdev->dev, "Unable to allocate private data\n");
+		return -ENOMEM;
+	}
+
+	ldo1->arizona = arizona;
+
+	/*
+	 * Since the chip usually supplies itself we provide some
+	 * default init_data for it.  This will be overridden with
+	 * platform data if provided.
+	 */
+	ldo1->init_data = arizona_ldo1_default;
+	ldo1->init_data.consumer_supplies = &ldo1->supply;
+	ldo1->supply.supply = "DCVDD";
+	ldo1->supply.dev_name = dev_name(arizona->dev);
+
+	config.dev = arizona->dev;
+	config.driver_data = ldo1;
+	config.regmap = arizona->regmap;
+
+	if (arizona->pdata.ldo1)
+		config.init_data = arizona->pdata.ldo1;
+	else
+		config.init_data = &ldo1->init_data;
+
+	ldo1->regulator = regulator_register(&arizona_ldo1, &config);
+	if (IS_ERR(ldo1->regulator)) {
+		ret = PTR_ERR(ldo1->regulator);
+		dev_err(arizona->dev, "Failed to register LDO1 supply: %d\n",
+			ret);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, ldo1);
+
+	return 0;
+}
+
+static __devexit int arizona_ldo1_remove(struct platform_device *pdev)
+{
+	struct arizona_ldo1 *ldo1 = platform_get_drvdata(pdev);
+
+	regulator_unregister(ldo1->regulator);
+
+	return 0;
+}
+
+static struct platform_driver arizona_ldo1_driver = {
+	.probe = arizona_ldo1_probe,
+	.remove = __devexit_p(arizona_ldo1_remove),
+	.driver		= {
+		.name	= "arizona-ldo1",
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(arizona_ldo1_driver);
+
+/* Module information */
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_DESCRIPTION("Arizona LDO1 driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:arizona-ldo1");
-- 
1.7.10

