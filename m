Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2ENDZt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 23:25:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54861 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab2ENDZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 23:25:48 -0400
Message-ID: <1336965942.24732.14.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: tps62360: Convert to
 regulator_list_voltage_linear()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 14 May 2012 11:25:42 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps62360-regulator.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index 60765cc..dae08a8 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -185,28 +185,17 @@ static int tps62360_dcdc_set_voltage(struct regulator_dev *dev,
 	return 0;
 }
 
-static int tps62360_dcdc_list_voltage(struct regulator_dev *dev,
-					unsigned selector)
-{
-	struct tps62360_chip *tps = rdev_get_drvdata(dev);
-
-	if (selector >= tps->desc.n_voltages)
-		return -EINVAL;
-
-	return tps->voltage_base + selector * 10000;
-}
-
 static int tps62360_set_voltage_time_sel(struct regulator_dev *rdev,
 		unsigned int old_selector, unsigned int new_selector)
 {
 	struct tps62360_chip *tps = rdev_get_drvdata(rdev);
 	int old_uV, new_uV;
 
-	old_uV = tps62360_dcdc_list_voltage(rdev, old_selector);
+	old_uV = regulator_list_voltage_linear(rdev, old_selector);
 	if (old_uV < 0)
 		return old_uV;
 
-	new_uV = tps62360_dcdc_list_voltage(rdev, new_selector);
+	new_uV = regulator_list_voltage_linear(rdev, new_selector);
 	if (new_uV < 0)
 		return new_uV;
 
@@ -216,7 +205,7 @@ static int tps62360_set_voltage_time_sel(struct regulator_dev *rdev,
 static struct regulator_ops tps62360_dcdc_ops = {
 	.get_voltage_sel	= tps62360_dcdc_get_voltage_sel,
 	.set_voltage		= tps62360_dcdc_set_voltage,
-	.list_voltage		= tps62360_dcdc_list_voltage,
+	.list_voltage		= regulator_list_voltage_linear,
 	.set_voltage_time_sel	= tps62360_set_voltage_time_sel,
 };
 
@@ -420,6 +409,9 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 	tps->desc.ops = &tps62360_dcdc_ops;
 	tps->desc.type = REGULATOR_VOLTAGE;
 	tps->desc.owner = THIS_MODULE;
+	tps->desc.min_uV = tps->voltage_base;
+	tps->desc.uV_step = 10000;
+
 	tps->regmap = devm_regmap_init_i2c(client, &tps62360_regmap_config);
 	if (IS_ERR(tps->regmap)) {
 		ret = PTR_ERR(tps->regmap);
-- 
1.7.5.4



