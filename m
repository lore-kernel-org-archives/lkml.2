Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab2K2CBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 21:01:51 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35877 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2K2CBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 21:01:50 -0500
Message-ID: <1354154504.10511.4.camel@phoenix>
Subject: [RFT][PATCH 2/2] regulator: palmas: Convert palmas_ops_smps to
 regulator_[get|set]_voltage_sel_regmap
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2012 10:01:44 +0800
In-Reply-To: <1354154356.10511.2.camel@phoenix>
References: <1354154356.10511.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/palmas-regulator.c |   87 ++++++++++------------------------
 1 file changed, 26 insertions(+), 61 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 76eaafb..932cc05 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -327,42 +327,6 @@ static int palmas_list_voltage_smps(struct regulator_dev *dev,
 		return (490000 + ((selector - 5) * 10000)) * mult;
 }
 
-static int palmas_get_voltage_smps_sel(struct regulator_dev *dev)
-{
-	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
-	int id = rdev_get_id(dev);
-	int selector;
-	unsigned int reg;
-	unsigned int addr;
-
-	addr = palmas_regs_info[id].vsel_addr;
-
-	palmas_smps_read(pmic->palmas, addr, &reg);
-
-	selector = reg & PALMAS_SMPS12_VOLTAGE_VSEL_MASK;
-
-	return selector;
-}
-
-static int palmas_set_voltage_smps_sel(struct regulator_dev *dev,
-		unsigned selector)
-{
-	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
-	int id = rdev_get_id(dev);
-	unsigned int reg, addr;
-
-	addr = palmas_regs_info[id].vsel_addr;
-	reg = selector;
-
-	/* Make sure we don't change the value of RANGE */
-	if (pmic->range[id])
-		reg |= PALMAS_SMPS12_VOLTAGE_RANGE;
-
-	palmas_smps_write(pmic->palmas, addr, reg);
-
-	return 0;
-}
-
 static int palmas_map_voltage_smps(struct regulator_dev *rdev,
 		int min_uV, int max_uV)
 {
@@ -397,8 +361,8 @@ static struct regulator_ops palmas_ops_smps = {
 	.disable		= palmas_disable_smps,
 	.set_mode		= palmas_set_mode_smps,
 	.get_mode		= palmas_get_mode_smps,
-	.get_voltage_sel	= palmas_get_voltage_smps_sel,
-	.set_voltage_sel	= palmas_set_voltage_smps_sel,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.list_voltage		= palmas_list_voltage_smps,
 	.map_voltage		= palmas_map_voltage_smps,
 };
@@ -693,6 +657,14 @@ static int palmas_probe(struct platform_device *pdev)
 				continue;
 		}
 
+		/* Initialise sleep/init values from platform data */
+		if (pdata && pdata->reg_init[id]) {
+			reg_init = pdata->reg_init[id];
+			ret = palmas_smps_init(palmas, id, reg_init);
+			if (ret)
+				goto err_unregister_regulator;
+		}
+
 		/* Register the regulators */
 		pmic->desc[id].name = palmas_regs_info[id].name;
 		pmic->desc[id].id = id;
@@ -713,29 +685,11 @@ static int palmas_probe(struct platform_device *pdev)
 			pmic->desc[id].uV_step = 1250000;
 			break;
 		default:
-			pmic->desc[id].ops = &palmas_ops_smps;
-			pmic->desc[id].n_voltages = PALMAS_SMPS_NUM_VOLTAGES;
-		}
-
-		pmic->desc[id].type = REGULATOR_VOLTAGE;
-		pmic->desc[id].owner = THIS_MODULE;
-
-		/* Initialise sleep/init values from platform data */
-		if (pdata) {
-			reg_init = pdata->reg_init[id];
-			if (reg_init) {
-				ret = palmas_smps_init(palmas, id, reg_init);
-				if (ret)
-					goto err_unregister_regulator;
-			}
-		}
-
-		/*
-		 * read and store the RANGE bit for later use
-		 * This must be done before regulator is probed otherwise
-		 * we error in probe with unsuportable ranges.
-		 */
-		if (id != PALMAS_REG_SMPS10) {
+			/*
+			 * Read and store the RANGE bit for later use
+			 * This must be done before regulator is probed,
+			 * otherwise we error in probe with unsupportable ranges.
+			 */
 			addr = palmas_regs_info[id].vsel_addr;
 
 			ret = palmas_smps_read(pmic->palmas, addr, &reg);
@@ -743,8 +697,19 @@ static int palmas_probe(struct platform_device *pdev)
 				goto err_unregister_regulator;
 			if (reg & PALMAS_SMPS12_VOLTAGE_RANGE)
 				pmic->range[id] = 1;
+
+			pmic->desc[id].ops = &palmas_ops_smps;
+			pmic->desc[id].n_voltages = PALMAS_SMPS_NUM_VOLTAGES;
+			pmic->desc[id].vsel_reg =
+					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
+						palmas_regs_info[id].vsel_addr);
+			pmic->desc[id].vsel_mask =
+					PALMAS_SMPS12_VOLTAGE_VSEL_MASK;
 		}
 
+		pmic->desc[id].type = REGULATOR_VOLTAGE;
+		pmic->desc[id].owner = THIS_MODULE;
+
 		if (pdata)
 			config.init_data = pdata->reg_data[id];
 		else
-- 
1.7.9.5



