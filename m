Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab2LJLrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:47:04 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:46067 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2LJLrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:47:01 -0500
Message-ID: <1355140012.6601.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: lp3971: Convert to get_voltage_sel
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Dec 2012 19:46:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_list_voltage_table() returns -EINVAL if selector >= n_voltages.
Thus we don't need to check if reg is greater than BUCK_TARGET_VOL_MAX_IDX in
lp3971_dcdc_get_voltage_sel.

BUCK_TARGET_VOL_MIN_IDX and BUCK_TARGET_VOL_MAX_IDX are not used, remove them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp3971.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 5f68ff1..9cb2c0f 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -73,8 +73,6 @@ static const unsigned int buck_voltage_map[] = {
 };
 
 #define BUCK_TARGET_VOL_MASK 0x3f
-#define BUCK_TARGET_VOL_MIN_IDX 0x01
-#define BUCK_TARGET_VOL_MAX_IDX 0x19
 
 #define LP3971_BUCK_RAMP_REG(x)	(buck_base_addr[x]+2)
 
@@ -140,7 +138,7 @@ static int lp3971_ldo_disable(struct regulator_dev *dev)
 	return lp3971_set_bits(lp3971, LP3971_LDO_ENABLE_REG, mask, 0);
 }
 
-static int lp3971_ldo_get_voltage(struct regulator_dev *dev)
+static int lp3971_ldo_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct lp3971 *lp3971 = rdev_get_drvdata(dev);
 	int ldo = rdev_get_id(dev) - LP3971_LDO1;
@@ -149,7 +147,7 @@ static int lp3971_ldo_get_voltage(struct regulator_dev *dev)
 	reg = lp3971_reg_read(lp3971, LP3971_LDO_VOL_CONTR_REG(ldo));
 	val = (reg >> LDO_VOL_CONTR_SHIFT(ldo)) & LDO_VOL_CONTR_MASK;
 
-	return dev->desc->volt_table[val];
+	return val;
 }
 
 static int lp3971_ldo_set_voltage_sel(struct regulator_dev *dev,
@@ -168,7 +166,7 @@ static struct regulator_ops lp3971_ldo_ops = {
 	.is_enabled = lp3971_ldo_is_enabled,
 	.enable = lp3971_ldo_enable,
 	.disable = lp3971_ldo_disable,
-	.get_voltage = lp3971_ldo_get_voltage,
+	.get_voltage_sel = lp3971_ldo_get_voltage_sel,
 	.set_voltage_sel = lp3971_ldo_set_voltage_sel,
 };
 
@@ -201,24 +199,16 @@ static int lp3971_dcdc_disable(struct regulator_dev *dev)
 	return lp3971_set_bits(lp3971, LP3971_BUCK_VOL_ENABLE_REG, mask, 0);
 }
 
-static int lp3971_dcdc_get_voltage(struct regulator_dev *dev)
+static int lp3971_dcdc_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct lp3971 *lp3971 = rdev_get_drvdata(dev);
 	int buck = rdev_get_id(dev) - LP3971_DCDC1;
 	u16 reg;
-	int val;
 
 	reg = lp3971_reg_read(lp3971, LP3971_BUCK_TARGET_VOL1_REG(buck));
 	reg &= BUCK_TARGET_VOL_MASK;
 
-	if (reg <= BUCK_TARGET_VOL_MAX_IDX)
-		val = buck_voltage_map[reg];
-	else {
-		val = 0;
-		dev_warn(&dev->dev, "chip reported incorrect voltage value.\n");
-	}
-
-	return val;
+	return reg;
 }
 
 static int lp3971_dcdc_set_voltage_sel(struct regulator_dev *dev,
@@ -249,7 +239,7 @@ static struct regulator_ops lp3971_dcdc_ops = {
 	.is_enabled = lp3971_dcdc_is_enabled,
 	.enable = lp3971_dcdc_enable,
 	.disable = lp3971_dcdc_disable,
-	.get_voltage = lp3971_dcdc_get_voltage,
+	.get_voltage_sel = lp3971_dcdc_get_voltage_sel,
 	.set_voltage_sel = lp3971_dcdc_set_voltage_sel,
 };
 
-- 
1.7.9.5



