Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2LJLuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:50:21 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:48791 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab2LJLuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:50:17 -0500
Message-ID: <1355140212.6601.4.camel@phoenix>
Subject: [PATCH 2/2] regulator: lp3972: Convert to get_voltage_sel
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Mon, 10 Dec 2012 19:50:12 +0800
In-Reply-To: <1355140012.6601.1.camel@phoenix>
References: <1355140012.6601.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_list_voltage_table() returns -EINVAL if selector >= n_voltages.
Thus we don't need to check if reg is greater than LP3972_BUCK_VOL_MAX_IDX in
lp3972_dcdc_get_voltage_sel.

LP3972_BUCK_VOL_MIN_IDX and LP3972_BUCK_VOL_MAX_IDX are not used, remove them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp3972.c |   22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/regulator/lp3972.c b/drivers/regulator/lp3972.c
index 69c42c3..0baabcf 100644
--- a/drivers/regulator/lp3972.c
+++ b/drivers/regulator/lp3972.c
@@ -165,8 +165,6 @@ static const int buck_base_addr[] = {
 #define LP3972_BUCK_VOL_ENABLE_REG(x) (buck_vol_enable_addr[x])
 #define LP3972_BUCK_VOL1_REG(x) (buck_base_addr[x])
 #define LP3972_BUCK_VOL_MASK 0x1f
-#define LP3972_BUCK_VOL_MIN_IDX(x) ((x) ? 0x01 : 0x00)
-#define LP3972_BUCK_VOL_MAX_IDX(x) ((x) ? 0x19 : 0x1f)
 
 static int lp3972_i2c_read(struct i2c_client *i2c, char reg, int count,
 	u16 *dest)
@@ -257,7 +255,7 @@ static int lp3972_ldo_disable(struct regulator_dev *dev)
 				mask, 0);
 }
 
-static int lp3972_ldo_get_voltage(struct regulator_dev *dev)
+static int lp3972_ldo_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct lp3972 *lp3972 = rdev_get_drvdata(dev);
 	int ldo = rdev_get_id(dev) - LP3972_LDO1;
@@ -267,7 +265,7 @@ static int lp3972_ldo_get_voltage(struct regulator_dev *dev)
 	reg = lp3972_reg_read(lp3972, LP3972_LDO_VOL_CONTR_REG(ldo));
 	val = (reg >> LP3972_LDO_VOL_CONTR_SHIFT(ldo)) & mask;
 
-	return dev->desc->volt_table[val];
+	return val;
 }
 
 static int lp3972_ldo_set_voltage_sel(struct regulator_dev *dev,
@@ -314,7 +312,7 @@ static struct regulator_ops lp3972_ldo_ops = {
 	.is_enabled = lp3972_ldo_is_enabled,
 	.enable = lp3972_ldo_enable,
 	.disable = lp3972_ldo_disable,
-	.get_voltage = lp3972_ldo_get_voltage,
+	.get_voltage_sel = lp3972_ldo_get_voltage_sel,
 	.set_voltage_sel = lp3972_ldo_set_voltage_sel,
 };
 
@@ -353,24 +351,16 @@ static int lp3972_dcdc_disable(struct regulator_dev *dev)
 	return val;
 }
 
-static int lp3972_dcdc_get_voltage(struct regulator_dev *dev)
+static int lp3972_dcdc_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct lp3972 *lp3972 = rdev_get_drvdata(dev);
 	int buck = rdev_get_id(dev) - LP3972_DCDC1;
 	u16 reg;
-	int val;
 
 	reg = lp3972_reg_read(lp3972, LP3972_BUCK_VOL1_REG(buck));
 	reg &= LP3972_BUCK_VOL_MASK;
-	if (reg <= LP3972_BUCK_VOL_MAX_IDX(buck))
-		val = dev->desc->volt_table[reg];
-	else {
-		val = 0;
-		dev_warn(&dev->dev, "chip reported incorrect voltage value."
-				    " reg = %d\n", reg);
-	}
 
-	return val;
+	return reg;
 }
 
 static int lp3972_dcdc_set_voltage_sel(struct regulator_dev *dev,
@@ -402,7 +392,7 @@ static struct regulator_ops lp3972_dcdc_ops = {
 	.is_enabled = lp3972_dcdc_is_enabled,
 	.enable = lp3972_dcdc_enable,
 	.disable = lp3972_dcdc_disable,
-	.get_voltage = lp3972_dcdc_get_voltage,
+	.get_voltage_sel = lp3972_dcdc_get_voltage_sel,
 	.set_voltage_sel = lp3972_dcdc_set_voltage_sel,
 };
 
-- 
1.7.9.5



