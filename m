Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab2END1c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 23:27:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37148 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab2END1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 23:27:31 -0400
Message-ID: <1336966045.24732.16.camel@phoenix>
Subject: [PATCH RFT 2/2] regulator: tps62360: Convert to set_voltage_sel and
 regulator_map_voltage_linear
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 14 May 2012 11:27:25 +0800
In-Reply-To: <1336965942.24732.14.camel@phoenix>
References: <1336965942.24732.14.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps62360-regulator.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index dae08a8..926c0e8 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -137,35 +137,24 @@ static int tps62360_dcdc_get_voltage_sel(struct regulator_dev *dev)
 	return vsel;
 }
 
-static int tps62360_dcdc_set_voltage(struct regulator_dev *dev,
-	     int min_uV, int max_uV, unsigned *selector)
+static int tps62360_dcdc_set_voltage_sel(struct regulator_dev *dev,
+					 unsigned selector)
 {
 	struct tps62360_chip *tps = rdev_get_drvdata(dev);
-	int vsel;
 	int ret;
 	bool found = false;
 	int new_vset_id = tps->curr_vset_id;
 
-	if ((max_uV < min_uV) || (max_uV < tps->voltage_base))
-		return -EINVAL;
-
-	if (min_uV > (tps->voltage_base + (tps->desc.n_voltages - 1) * 10000))
-		return -EINVAL;
-
-	vsel = DIV_ROUND_UP(min_uV - tps->voltage_base, 10000);
-	if (selector)
-		*selector = (vsel & tps->voltage_reg_mask);
-
 	/*
 	 * If gpios are available to select the VSET register then least
 	 * recently used register for new configuration.
 	 */
 	if (tps->valid_gpios)
-		found = find_voltage_set_register(tps, vsel, &new_vset_id);
+		found = find_voltage_set_register(tps, selector, &new_vset_id);
 
 	if (!found) {
 		ret = regmap_update_bits(tps->regmap, REG_VSET0 + new_vset_id,
-				tps->voltage_reg_mask, vsel);
+				tps->voltage_reg_mask, selector);
 		if (ret < 0) {
 			dev_err(tps->dev,
 				"%s(): register %d update failed with err %d\n",
@@ -173,7 +162,7 @@ static int tps62360_dcdc_set_voltage(struct regulator_dev *dev,
 			return ret;
 		}
 		tps->curr_vset_id = new_vset_id;
-		tps->curr_vset_vsel[new_vset_id] = vsel;
+		tps->curr_vset_vsel[new_vset_id] = selector;
 	}
 
 	/* Select proper VSET register vio gpios */
@@ -204,8 +193,9 @@ static int tps62360_set_voltage_time_sel(struct regulator_dev *rdev,
 
 static struct regulator_ops tps62360_dcdc_ops = {
 	.get_voltage_sel	= tps62360_dcdc_get_voltage_sel,
-	.set_voltage		= tps62360_dcdc_set_voltage,
+	.set_voltage_sel	= tps62360_dcdc_set_voltage_sel,
 	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
 	.set_voltage_time_sel	= tps62360_set_voltage_time_sel,
 };
 
-- 
1.7.5.4



