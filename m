Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab2FQBdV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 21:33:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33060 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab2FQBdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 21:33:20 -0400
Message-ID: <1339896787.12833.1.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: max8998: Convert to
 regulator_list_voltage_linear()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sun, 17 Jun 2012 09:33:07 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8998.c |   32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 18bb58b..105dafc 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -111,27 +111,6 @@ static const struct voltage_map_desc *ldo_voltage_map[] = {
 	&buck4_voltage_map_desc,	/* BUCK4 */
 };
 
-static int max8998_list_voltage(struct regulator_dev *rdev,
-				unsigned int selector)
-{
-	const struct voltage_map_desc *desc;
-	int ldo = rdev_get_id(rdev);
-	int val;
-
-	if (ldo >= ARRAY_SIZE(ldo_voltage_map))
-		return -EINVAL;
-
-	desc = ldo_voltage_map[ldo];
-	if (desc == NULL)
-		return -EINVAL;
-
-	val = desc->min + desc->step * selector;
-	if (val > desc->max)
-		return -EINVAL;
-
-	return val * 1000;
-}
-
 static int max8998_get_enable_register(struct regulator_dev *rdev,
 					int *reg, int *shift)
 {
@@ -392,8 +371,8 @@ static int max8998_set_voltage_buck(struct regulator_dev *rdev,
 	/* if previous_voltage equal new voltage, return */
 	if (previous_sel == i) {
 		dev_dbg(max8998->dev, "No voltage change, old:%d, new:%d\n",
-			max8998_list_voltage(rdev, previous_sel),
-			max8998_list_voltage(rdev, i));
+			regulator_list_voltage_linear(rdev, previous_sel),
+			regulator_list_voltage_linear(rdev, i));
 		return ret;
 	}
 
@@ -519,7 +498,7 @@ static int max8998_set_voltage_buck_time_sel(struct regulator_dev *rdev,
 }
 
 static struct regulator_ops max8998_ldo_ops = {
-	.list_voltage		= max8998_list_voltage,
+	.list_voltage		= regulator_list_voltage_linear,
 	.is_enabled		= max8998_ldo_is_enabled,
 	.enable			= max8998_ldo_enable,
 	.disable		= max8998_ldo_disable,
@@ -530,7 +509,7 @@ static struct regulator_ops max8998_ldo_ops = {
 };
 
 static struct regulator_ops max8998_buck_ops = {
-	.list_voltage		= max8998_list_voltage,
+	.list_voltage		= regulator_list_voltage_linear,
 	.is_enabled		= max8998_ldo_is_enabled,
 	.enable			= max8998_ldo_enable,
 	.disable		= max8998_ldo_disable,
@@ -860,7 +839,10 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		desc = ldo_voltage_map[id];
 		if (desc && regulators[index].ops != &max8998_others_ops) {
 			int count = (desc->max - desc->min) / desc->step + 1;
+
 			regulators[index].n_voltages = count;
+			regulators[index].min_uV = desc->min * 1000;
+			regulators[index].uV_step = desc->step * 1000;
 		}
 
 		config.dev = max8998->dev;
-- 
1.7.9.5



