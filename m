Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059Ab2DRCuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 22:50:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46974 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab2DRCuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 22:50:51 -0400
Message-ID: <1334717437.12560.1.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: pcf50633: Use generic regmap
 enable/disable operations
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 18 Apr 2012 10:50:37 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/pcf50633-regulator.c |  108 +++++++------------------------
 1 files changed, 25 insertions(+), 83 deletions(-)

diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index 7ee70f1..5887505 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -24,14 +24,16 @@
 #include <linux/mfd/pcf50633/core.h>
 #include <linux/mfd/pcf50633/pmic.h>
 
-#define PCF50633_REGULATOR(_name, _id, _n) 		\
-	{					\
-		.name = _name, 			\
-		.id = _id,			\
-		.ops = &pcf50633_regulator_ops,	\
-		.n_voltages = _n, \
-		.type = REGULATOR_VOLTAGE, 	\
-		.owner = THIS_MODULE, 		\
+#define PCF50633_REGULATOR(_name, _id, _n)			\
+	{							\
+		.name = _name,					\
+		.id = PCF50633_REGULATOR_##_id,			\
+		.ops = &pcf50633_regulator_ops,			\
+		.n_voltages = _n,				\
+		.type = REGULATOR_VOLTAGE,			\
+		.owner = THIS_MODULE,				\
+		.enable_reg = PCF50633_REG_##_id##OUT + 1,	\
+		.enable_mask = PCF50633_REGULATOR_ON,		\
 	}
 
 static const u8 pcf50633_regulator_registers[PCF50633_NUM_REGULATORS] = {
@@ -208,88 +210,27 @@ static int pcf50633_regulator_list_voltage(struct regulator_dev *rdev,
 	return millivolts * 1000;
 }
 
-static int pcf50633_regulator_enable(struct regulator_dev *rdev)
-{
-	struct pcf50633 *pcf = rdev_get_drvdata(rdev);
-	int regulator_id;
-	u8 regnr;
-
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= PCF50633_NUM_REGULATORS)
-		return -EINVAL;
-
-	/* The *ENA register is always one after the *OUT register */
-	regnr = pcf50633_regulator_registers[regulator_id] + 1;
-
-	return pcf50633_reg_set_bit_mask(pcf, regnr, PCF50633_REGULATOR_ON,
-						       PCF50633_REGULATOR_ON);
-}
-
-static int pcf50633_regulator_disable(struct regulator_dev *rdev)
-{
-	struct pcf50633 *pcf = rdev_get_drvdata(rdev);
-	int regulator_id;
-	u8 regnr;
-
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= PCF50633_NUM_REGULATORS)
-		return -EINVAL;
-
-	/* the *ENA register is always one after the *OUT register */
-	regnr = pcf50633_regulator_registers[regulator_id] + 1;
-
-	return pcf50633_reg_set_bit_mask(pcf, regnr,
-					PCF50633_REGULATOR_ON, 0);
-}
-
-static int pcf50633_regulator_is_enabled(struct regulator_dev *rdev)
-{
-	struct pcf50633 *pcf = rdev_get_drvdata(rdev);
-	int regulator_id = rdev_get_id(rdev);
-	u8 regnr;
-
-	regulator_id = rdev_get_id(rdev);
-	if (regulator_id >= PCF50633_NUM_REGULATORS)
-		return -EINVAL;
-
-	/* the *ENA register is always one after the *OUT register */
-	regnr = pcf50633_regulator_registers[regulator_id] + 1;
-
-	return pcf50633_reg_read(pcf, regnr) & PCF50633_REGULATOR_ON;
-}
-
 static struct regulator_ops pcf50633_regulator_ops = {
 	.set_voltage = pcf50633_regulator_set_voltage,
 	.get_voltage_sel = pcf50633_regulator_get_voltage_sel,
 	.list_voltage = pcf50633_regulator_list_voltage,
-	.enable = pcf50633_regulator_enable,
-	.disable = pcf50633_regulator_disable,
-	.is_enabled = pcf50633_regulator_is_enabled,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
 };
 
 static const struct regulator_desc regulators[] = {
-	[PCF50633_REGULATOR_AUTO] =
-		PCF50633_REGULATOR("auto", PCF50633_REGULATOR_AUTO, 128),
-	[PCF50633_REGULATOR_DOWN1] =
-		PCF50633_REGULATOR("down1", PCF50633_REGULATOR_DOWN1, 96),
-	[PCF50633_REGULATOR_DOWN2] =
-		PCF50633_REGULATOR("down2", PCF50633_REGULATOR_DOWN2, 96),
-	[PCF50633_REGULATOR_LDO1] =
-		PCF50633_REGULATOR("ldo1", PCF50633_REGULATOR_LDO1, 28),
-	[PCF50633_REGULATOR_LDO2] =
-		PCF50633_REGULATOR("ldo2", PCF50633_REGULATOR_LDO2, 28),
-	[PCF50633_REGULATOR_LDO3] =
-		PCF50633_REGULATOR("ldo3", PCF50633_REGULATOR_LDO3, 28),
-	[PCF50633_REGULATOR_LDO4] =
-		PCF50633_REGULATOR("ldo4", PCF50633_REGULATOR_LDO4, 28),
-	[PCF50633_REGULATOR_LDO5] =
-		PCF50633_REGULATOR("ldo5", PCF50633_REGULATOR_LDO5, 28),
-	[PCF50633_REGULATOR_LDO6] =
-		PCF50633_REGULATOR("ldo6", PCF50633_REGULATOR_LDO6, 28),
-	[PCF50633_REGULATOR_HCLDO] =
-		PCF50633_REGULATOR("hcldo", PCF50633_REGULATOR_HCLDO, 28),
-	[PCF50633_REGULATOR_MEMLDO] =
-		PCF50633_REGULATOR("memldo", PCF50633_REGULATOR_MEMLDO, 28),
+	[PCF50633_REGULATOR_AUTO] = PCF50633_REGULATOR("auto", AUTO, 128),
+	[PCF50633_REGULATOR_DOWN1] = PCF50633_REGULATOR("down1", DOWN1, 96),
+	[PCF50633_REGULATOR_DOWN2] = PCF50633_REGULATOR("down2", DOWN2, 96),
+	[PCF50633_REGULATOR_LDO1] = PCF50633_REGULATOR("ldo1", LDO1, 28),
+	[PCF50633_REGULATOR_LDO2] = PCF50633_REGULATOR("ldo2", LDO2, 28),
+	[PCF50633_REGULATOR_LDO3] = PCF50633_REGULATOR("ldo3", LDO3, 28),
+	[PCF50633_REGULATOR_LDO4] = PCF50633_REGULATOR("ldo4", LDO4, 28),
+	[PCF50633_REGULATOR_LDO5] = PCF50633_REGULATOR("ldo5", LDO5, 28),
+	[PCF50633_REGULATOR_LDO6] = PCF50633_REGULATOR("ldo6", LDO6, 28),
+	[PCF50633_REGULATOR_HCLDO] = PCF50633_REGULATOR("hcldo", HCLDO, 28),
+	[PCF50633_REGULATOR_MEMLDO] = PCF50633_REGULATOR("memldo", MEMLDO, 28),
 };
 
 static int __devinit pcf50633_regulator_probe(struct platform_device *pdev)
@@ -304,6 +245,7 @@ static int __devinit pcf50633_regulator_probe(struct platform_device *pdev)
 	config.dev = &pdev->dev;
 	config.init_data = pdev->dev.platform_data;
 	config.driver_data = pcf;
+	config.regmap = pcf->regmap;
 
 	rdev = regulator_register(&regulators[pdev->id], &config);
 	if (IS_ERR(rdev))
-- 
1.7.5.4



