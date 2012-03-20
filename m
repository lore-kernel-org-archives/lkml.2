Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab2CTCqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 22:46:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37664 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab2CTCqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 22:46:42 -0400
Message-ID: <1332211595.10843.5.camel@phoenix>
Subject: [PATCH RFT] regulator: Convert mc13xxx regulator drivers to
 set_voltage_sel
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yong Shen <yong.shen@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 20 Mar 2012 10:46:35 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert mc13892_sw_regulator_ops and mc13xxx_regulator_ops to set_voltage_sel.
mc13xxx_get_best_voltage_index function is not used now, remove it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/mc13892-regulator.c      |   17 ++-------
 drivers/regulator/mc13xxx-regulator-core.c |   54 +++-------------------------
 drivers/regulator/mc13xxx.h                |    2 -
 3 files changed, 9 insertions(+), 64 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index e8cfc99..ba58681 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -428,24 +428,15 @@ static int mc13892_sw_regulator_get_voltage(struct regulator_dev *rdev)
 	return val;
 }
 
-static int mc13892_sw_regulator_set_voltage(struct regulator_dev *rdev,
-		int min_uV, int max_uV, unsigned *selector)
+static int mc13892_sw_regulator_set_voltage_sel(struct regulator_dev *rdev,
+						unsigned selector)
 {
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
 	int hi, value, mask, id = rdev_get_id(rdev);
 	u32 valread;
 	int ret;
 
-	dev_dbg(rdev_get_dev(rdev), "%s id: %d min_uV: %d max_uV: %d\n",
-		__func__, id, min_uV, max_uV);
-
-	/* Find the best index */
-	value = mc13xxx_get_best_voltage_index(rdev, min_uV, max_uV);
-	dev_dbg(rdev_get_dev(rdev), "%s best value: %d\n", __func__, value);
-	if (value < 0)
-		return value;
-
-	value = mc13892_regulators[id].voltages[value];
+	value = mc13892_regulators[id].voltages[selector];
 
 	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_read(priv->mc13xxx,
@@ -480,7 +471,7 @@ err:
 static struct regulator_ops mc13892_sw_regulator_ops = {
 	.is_enabled = mc13xxx_sw_regulator_is_enabled,
 	.list_voltage = mc13xxx_regulator_list_voltage,
-	.set_voltage = mc13892_sw_regulator_set_voltage,
+	.set_voltage_sel = mc13892_sw_regulator_set_voltage_sel,
 	.get_voltage = mc13892_sw_regulator_get_voltage,
 };
 
diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 62dcd0a..4fa9704 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -94,62 +94,18 @@ int mc13xxx_regulator_list_voltage(struct regulator_dev *rdev,
 }
 EXPORT_SYMBOL_GPL(mc13xxx_regulator_list_voltage);
 
-int mc13xxx_get_best_voltage_index(struct regulator_dev *rdev,
-						int min_uV, int max_uV)
+static int mc13xxx_regulator_set_voltage_sel(struct regulator_dev *rdev,
+					     unsigned selector)
 {
 	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
 	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
-	int reg_id = rdev_get_id(rdev);
-	int i;
-	int bestmatch;
-	int bestindex;
-
-	/*
-	 * Locate the minimum voltage fitting the criteria on
-	 * this regulator. The switchable voltages are not
-	 * in strict falling order so we need to check them
-	 * all for the best match.
-	 */
-	bestmatch = INT_MAX;
-	bestindex = -1;
-	for (i = 0; i < mc13xxx_regulators[reg_id].desc.n_voltages; i++) {
-		if (mc13xxx_regulators[reg_id].voltages[i] >= min_uV &&
-		    mc13xxx_regulators[reg_id].voltages[i] < bestmatch) {
-			bestmatch = mc13xxx_regulators[reg_id].voltages[i];
-			bestindex = i;
-		}
-	}
-
-	if (bestindex < 0 || bestmatch > max_uV) {
-		dev_warn(&rdev->dev, "no possible value for %d<=x<=%d uV\n",
-				min_uV, max_uV);
-		return -EINVAL;
-	}
-	return bestindex;
-}
-EXPORT_SYMBOL_GPL(mc13xxx_get_best_voltage_index);
-
-static int mc13xxx_regulator_set_voltage(struct regulator_dev *rdev, int min_uV,
-		int max_uV, unsigned *selector)
-{
-	struct mc13xxx_regulator_priv *priv = rdev_get_drvdata(rdev);
-	struct mc13xxx_regulator *mc13xxx_regulators = priv->mc13xxx_regulators;
-	int value, id = rdev_get_id(rdev);
+	int id = rdev_get_id(rdev);
 	int ret;
 
-	dev_dbg(rdev_get_dev(rdev), "%s id: %d min_uV: %d max_uV: %d\n",
-		__func__, id, min_uV, max_uV);
-
-	/* Find the best index */
-	value = mc13xxx_get_best_voltage_index(rdev, min_uV, max_uV);
-	dev_dbg(rdev_get_dev(rdev), "%s best value: %d\n", __func__, value);
-	if (value < 0)
-		return value;
-
 	mc13xxx_lock(priv->mc13xxx);
 	ret = mc13xxx_reg_rmw(priv->mc13xxx, mc13xxx_regulators[id].vsel_reg,
 			mc13xxx_regulators[id].vsel_mask,
-			value << mc13xxx_regulators[id].vsel_shift);
+			selector << mc13xxx_regulators[id].vsel_shift);
 	mc13xxx_unlock(priv->mc13xxx);
 
 	return ret;
@@ -187,7 +143,7 @@ struct regulator_ops mc13xxx_regulator_ops = {
 	.disable = mc13xxx_regulator_disable,
 	.is_enabled = mc13xxx_regulator_is_enabled,
 	.list_voltage = mc13xxx_regulator_list_voltage,
-	.set_voltage = mc13xxx_regulator_set_voltage,
+	.set_voltage_sel = mc13xxx_regulator_set_voltage_sel,
 	.get_voltage = mc13xxx_regulator_get_voltage,
 };
 EXPORT_SYMBOL_GPL(mc13xxx_regulator_ops);
diff --git a/drivers/regulator/mc13xxx.h b/drivers/regulator/mc13xxx.h
index b3961c6..044aba4 100644
--- a/drivers/regulator/mc13xxx.h
+++ b/drivers/regulator/mc13xxx.h
@@ -35,8 +35,6 @@ struct mc13xxx_regulator_priv {
 
 extern int mc13xxx_sw_regulator(struct regulator_dev *rdev);
 extern int mc13xxx_sw_regulator_is_enabled(struct regulator_dev *rdev);
-extern int mc13xxx_get_best_voltage_index(struct regulator_dev *rdev,
-						int min_uV, int max_uV);
 extern int mc13xxx_regulator_list_voltage(struct regulator_dev *rdev,
 						unsigned selector);
 extern int mc13xxx_fixed_regulator_set_voltage(struct regulator_dev *rdev,
-- 
1.7.5.4



