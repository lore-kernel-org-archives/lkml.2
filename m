Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab2K0C1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 21:27:41 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:46938 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809Ab2K0C1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 21:27:40 -0500
Message-ID: <1353983254.5422.6.camel@phoenix>
Subject: [RFC/RFT][PATCH 3/4] regulator: palmas: Use linear_min_sel and
 regulator_[map|list]_voltage_linear
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 27 Nov 2012 10:27:34 +0800
In-Reply-To: <1353983073.5422.2.camel@phoenix>
References: <1353983073.5422.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/palmas-regulator.c |   37 +++++-----------------------------
 1 file changed, 5 insertions(+), 32 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 3d44592..d5b0408 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -436,44 +436,14 @@ static int palmas_is_enabled_ldo(struct regulator_dev *dev)
 	return !!(reg);
 }
 
-static int palmas_list_voltage_ldo(struct regulator_dev *dev,
-					unsigned selector)
-{
-	if (!selector)
-		return 0;
-
-	/* voltage is 0.85V + (selector * 0.05v) */
-	return  850000 + (selector * 50000);
-}
-
-static int palmas_map_voltage_ldo(struct regulator_dev *rdev,
-		int min_uV, int max_uV)
-{
-	int ret, voltage;
-
-	if (min_uV == 0)
-		return 0;
-
-	if (min_uV < 900000)
-		min_uV = 900000;
-	ret = DIV_ROUND_UP(min_uV - 900000, 50000) + 1;
-
-	/* Map back into a voltage to verify we're still in bounds */
-	voltage = palmas_list_voltage_ldo(rdev, ret);
-	if (voltage < min_uV || voltage > max_uV)
-		return -EINVAL;
-
-	return ret;
-}
-
 static struct regulator_ops palmas_ops_ldo = {
 	.is_enabled		= palmas_is_enabled_ldo,
 	.enable			= regulator_enable_regmap,
 	.disable		= regulator_disable_regmap,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
-	.list_voltage		= palmas_list_voltage_ldo,
-	.map_voltage		= palmas_map_voltage_ldo,
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
 };
 
 /*
@@ -821,6 +791,9 @@ static int palmas_probe(struct platform_device *pdev)
 
 		pmic->desc[id].type = REGULATOR_VOLTAGE;
 		pmic->desc[id].owner = THIS_MODULE;
+		pmic->desc[id].min_uV = 900000;
+		pmic->desc[id].uV_step = 50000;
+		pmic->desc[id].linear_min_sel = 1;
 		pmic->desc[id].vsel_reg = PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
 						palmas_regs_info[id].vsel_addr);
 		pmic->desc[id].vsel_mask = PALMAS_LDO1_VOLTAGE_VSEL_MASK;
-- 
1.7.9.5



