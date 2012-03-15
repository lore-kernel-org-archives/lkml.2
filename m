Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877Ab2COJRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 05:17:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44582 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759218Ab2COJRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 05:17:44 -0400
Message-ID: <1331803056.13750.0.camel@phoenix>
Subject: [PATCH 1/2] regulator: Implement tps65912_list_voltage to be shared
 by both DCDCs and LDOs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 15 Mar 2012 17:17:36 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge tps65912_list_voltage_dcdc and tps65912_list_voltage_ldo to
tps65912_list_voltage.  This change does not add too much complexity in
tps65912_list_voltage function.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65912-regulator.c |   23 +++++++----------------
 1 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index b36799b..46f3c61 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -372,12 +372,14 @@ static unsigned int tps65912_get_mode(struct regulator_dev *dev)
 	return mode;
 }
 
-static int tps65912_list_voltage_dcdc(struct regulator_dev *dev,
-					unsigned selector)
+static int tps65912_list_voltage(struct regulator_dev *dev, unsigned selector)
 {
 	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
 	int range, voltage = 0, id = rdev_get_id(dev);
 
+	if (id >= TPS65912_REG_LDO1 && id <= TPS65912_REG_LDO10)
+		return tps65912_vsel_to_uv_ldo(selector);
+
 	if (id > TPS65912_REG_DCDC4)
 		return -EINVAL;
 
@@ -418,7 +420,7 @@ static int tps65912_get_voltage_dcdc(struct regulator_dev *dev)
 	vsel = tps65912_reg_read(mfd, reg);
 	vsel &= 0x3F;
 
-	return tps65912_list_voltage_dcdc(dev, vsel);
+	return tps65912_list_voltage(dev, vsel);
 }
 
 static int tps65912_set_voltage_sel(struct regulator_dev *dev,
@@ -451,17 +453,6 @@ static int tps65912_get_voltage_ldo(struct regulator_dev *dev)
 	return tps65912_vsel_to_uv_ldo(vsel);
 }
 
-static int tps65912_list_voltage_ldo(struct regulator_dev *dev,
-					unsigned selector)
-{
-	int ldo = rdev_get_id(dev);
-
-	if (ldo < TPS65912_REG_LDO1 || ldo > TPS65912_REG_LDO10)
-		return -EINVAL;
-
-	return tps65912_vsel_to_uv_ldo(selector);
-}
-
 /* Operations permitted on DCDCx */
 static struct regulator_ops tps65912_ops_dcdc = {
 	.is_enabled = tps65912_reg_is_enabled,
@@ -471,7 +462,7 @@ static struct regulator_ops tps65912_ops_dcdc = {
 	.get_mode = tps65912_get_mode,
 	.get_voltage = tps65912_get_voltage_dcdc,
 	.set_voltage_sel = tps65912_set_voltage_sel,
-	.list_voltage = tps65912_list_voltage_dcdc,
+	.list_voltage = tps65912_list_voltage,
 };
 
 /* Operations permitted on LDOx */
@@ -481,7 +472,7 @@ static struct regulator_ops tps65912_ops_ldo = {
 	.disable = tps65912_reg_disable,
 	.get_voltage = tps65912_get_voltage_ldo,
 	.set_voltage_sel = tps65912_set_voltage_sel,
-	.list_voltage = tps65912_list_voltage_ldo,
+	.list_voltage = tps65912_list_voltage,
 };
 
 static __devinit int tps65912_probe(struct platform_device *pdev)
-- 
1.7.5.4



