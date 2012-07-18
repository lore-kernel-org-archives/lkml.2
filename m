Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab2GREe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 00:34:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54081 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2GREeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 00:34:14 -0400
Message-ID: <1342586048.28942.8.camel@phoenix>
Subject: [RFT][PATCH v2 5/5] regulator: palmas: Convert palmas_ops_ldo to
 [get|set]_voltage_sel_regmap
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Date: Wed, 18 Jul 2012 12:34:08 +0800
In-Reply-To: <1342585811.28942.3.camel@phoenix>
References: <1342585811.28942.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/palmas-regulator.c |   45 ++++------------------------------
 1 file changed, 5 insertions(+), 40 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 46c7e88..2ba7502 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -443,44 +443,6 @@ static int palmas_list_voltage_ldo(struct regulator_dev *dev,
 	return  850000 + (selector * 50000);
 }
 
-static int palmas_get_voltage_ldo_sel(struct regulator_dev *dev)
-{
-	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
-	int id = rdev_get_id(dev);
-	int selector;
-	unsigned int reg;
-	unsigned int addr;
-
-	addr = palmas_regs_info[id].vsel_addr;
-
-	palmas_ldo_read(pmic->palmas, addr, &reg);
-
-	selector = reg & PALMAS_LDO1_VOLTAGE_VSEL_MASK;
-
-	/* Adjust selector to match list_voltage ranges */
-	if (selector > 49)
-		selector = 49;
-
-	return selector;
-}
-
-static int palmas_set_voltage_ldo_sel(struct regulator_dev *dev,
-		unsigned selector)
-{
-	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
-	int id = rdev_get_id(dev);
-	unsigned int reg = 0;
-	unsigned int addr;
-
-	addr = palmas_regs_info[id].vsel_addr;
-
-	reg = selector;
-
-	palmas_ldo_write(pmic->palmas, addr, reg);
-
-	return 0;
-}
-
 static int palmas_map_voltage_ldo(struct regulator_dev *rdev,
 		int min_uV, int max_uV)
 {
@@ -505,8 +467,8 @@ static struct regulator_ops palmas_ops_ldo = {
 	.is_enabled		= palmas_is_enabled_ldo,
 	.enable			= regulator_enable_regmap,
 	.disable		= regulator_disable_regmap,
-	.get_voltage_sel	= palmas_get_voltage_ldo_sel,
-	.set_voltage_sel	= palmas_set_voltage_ldo_sel,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.list_voltage		= palmas_list_voltage_ldo,
 	.map_voltage		= palmas_map_voltage_ldo,
 };
@@ -757,6 +719,9 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 
 		pmic->desc[id].type = REGULATOR_VOLTAGE;
 		pmic->desc[id].owner = THIS_MODULE;
+		pmic->desc[id].vsel_reg = PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
+						palmas_regs_info[id].vsel_addr);
+		pmic->desc[id].vsel_mask = PALMAS_LDO1_VOLTAGE_VSEL_MASK;
 		pmic->desc[id].enable_reg = PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
 						palmas_regs_info[id].ctrl_addr);
 		pmic->desc[id].enable_mask = PALMAS_LDO1_CTRL_MODE_ACTIVE;
-- 
1.7.9.5



