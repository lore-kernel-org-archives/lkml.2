Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab2FSJOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 05:14:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54069 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab2FSJOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 05:14:38 -0400
Message-ID: <1340097271.28289.4.camel@phoenix>
Subject: [PATCH RFT 3/3] regulator: tps65023: Convert tps65023_ldo_ops to
 regulator_[get|set]_voltage_sel_regmap
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Tue, 19 Jun 2012 17:14:31 +0800
In-Reply-To: <1340097138.28289.1.camel@phoenix>
References: <1340097138.28289.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps65023-regulator.c |   51 ++++++++------------------------
 1 file changed, 13 insertions(+), 38 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index eacff95..5f3f60a 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -69,10 +69,6 @@
 #define TPS65023_REG_CTRL2_DCDC1	BIT(1)
 #define TPS65023_REG_CTRL2_DCDC3	BIT(0)
 
-/* LDO_CTRL bitfields */
-#define TPS65023_LDO_CTRL_LDOx_SHIFT(ldo_id)	((ldo_id)*4)
-#define TPS65023_LDO_CTRL_LDOx_MASK(ldo_id)	(0x07 << ((ldo_id)*4))
-
 /* Number of step-down converters available */
 #define TPS65023_NUM_DCDC		3
 /* Number of LDO voltage regulators  available */
@@ -198,35 +194,6 @@ out:
 	return ret;
 }
 
-static int tps65023_ldo_get_voltage_sel(struct regulator_dev *dev)
-{
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
-	int data, ldo = rdev_get_id(dev);
-	int ret;
-
-	if (ldo < TPS65023_LDO_1 || ldo > TPS65023_LDO_2)
-		return -EINVAL;
-
-	ret = regmap_read(tps->regmap, TPS65023_REG_LDO_CTRL, &data);
-	if (ret != 0)
-		return ret;
-
-	data >>= (TPS65023_LDO_CTRL_LDOx_SHIFT(ldo - TPS65023_LDO_1));
-	data &= (tps->info[ldo]->table_len - 1);
-	return data;
-}
-
-static int tps65023_ldo_set_voltage_sel(struct regulator_dev *dev,
-					unsigned selector)
-{
-	struct tps_pmic *tps = rdev_get_drvdata(dev);
-	int ldo_index = rdev_get_id(dev) - TPS65023_LDO_1;
-
-	return regmap_update_bits(tps->regmap, TPS65023_REG_LDO_CTRL,
-			TPS65023_LDO_CTRL_LDOx_MASK(ldo_index),
-			selector << TPS65023_LDO_CTRL_LDOx_SHIFT(ldo_index));
-}
-
 /* Operations permitted on VDCDCx */
 static struct regulator_ops tps65023_dcdc_ops = {
 	.is_enabled = regulator_is_enabled_regmap,
@@ -242,8 +209,8 @@ static struct regulator_ops tps65023_ldo_ops = {
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
-	.get_voltage_sel = tps65023_ldo_get_voltage_sel,
-	.set_voltage_sel = tps65023_ldo_set_voltage_sel,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.list_voltage = regulator_list_voltage_table,
 };
 
@@ -304,13 +271,21 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 		tps->desc[i].owner = THIS_MODULE;
 
 		tps->desc[i].enable_reg = TPS65023_REG_REG_CTRL;
-		if (i == TPS65023_LDO_1)
+		switch (i) {
+		case TPS65023_LDO_1:
+			tps->desc[i].vsel_reg = TPS65023_REG_LDO_CTRL;
+			tps->desc[i].vsel_mask = 0x07;
 			tps->desc[i].enable_mask = 1 << 1;
-		else if (i == TPS65023_LDO_2)
+			break;
+		case TPS65023_LDO_2:
+			tps->desc[i].vsel_reg = TPS65023_REG_LDO_CTRL;
+			tps->desc[i].vsel_mask = 0x70;
 			tps->desc[i].enable_mask = 1 << 2;
-		else /* DCDCx */
+			break;
+		default: /* DCDCx */
 			tps->desc[i].enable_mask =
 					1 << (TPS65023_NUM_REGULATOR - i);
+		}
 
 		config.dev = &client->dev;
 		config.init_data = init_data;
-- 
1.7.9.5



