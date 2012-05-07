Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab2EGMpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 08:45:54 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1907 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab2EGMpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 08:45:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 07 May 2012 05:45:37 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, lrg@ti.com
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH v2 2/2] regulator: tps62360: Provide settling time for voltage change
Date: Mon,  7 May 2012 18:08:26 +0530
Message-Id: <1336394306-2211-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1336394306-2211-1-git-send-email-ldewangan@nvidia.com>
References: <1336394306-2211-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Settling time is require when there is voltage output change.
Implement set_voltage_time_sel() callback which returns delay time
for voltage change to settle down to new value.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Removing stylistic fix as it is under discussion and
creating new patch series.

 drivers/regulator/tps62360-regulator.c |   46 +++++++++++++++++++++++++++----
 1 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index e893080..d2f657e 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -71,6 +71,7 @@ struct tps62360_chip {
 	int lru_index[4];
 	int curr_vset_vsel[4];
 	int curr_vset_id;
+	int change_uv_per_us;
 };
 
 /*
@@ -114,7 +115,7 @@ update_lru_index:
 	return found;
 }
 
-static int tps62360_dcdc_get_voltage(struct regulator_dev *dev)
+static int tps62360_dcdc_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct tps62360_chip *tps = rdev_get_drvdata(dev);
 	int vsel;
@@ -128,7 +129,7 @@ static int tps62360_dcdc_get_voltage(struct regulator_dev *dev)
 		return ret;
 	}
 	vsel = (int)data & tps->voltage_reg_mask;
-	return (tps->voltage_base + vsel * 10) * 1000;
+	return vsel;
 }
 
 static int tps62360_dcdc_set_voltage(struct regulator_dev *dev,
@@ -193,10 +194,28 @@ static int tps62360_dcdc_list_voltage(struct regulator_dev *dev,
 	return (tps->voltage_base + selector * 10) * 1000;
 }
 
+static int tps62360_set_voltage_time_sel(struct regulator_dev *rdev,
+		unsigned int old_selector, unsigned int new_selector)
+{
+	struct tps62360_chip *tps = rdev_get_drvdata(rdev);
+	int old_uV, new_uV;
+
+	old_uV = tps62360_dcdc_list_voltage(rdev, old_selector);
+	if (old_uV < 0)
+		return old_uV;
+
+	new_uV = tps62360_dcdc_list_voltage(rdev, new_selector);
+	if (new_uV < 0)
+		return new_uV;
+
+	return DIV_ROUND_UP(abs(old_uV - new_uV), tps->change_uv_per_us);
+}
+
 static struct regulator_ops tps62360_dcdc_ops = {
-	.get_voltage = tps62360_dcdc_get_voltage,
-	.set_voltage = tps62360_dcdc_set_voltage,
-	.list_voltage = tps62360_dcdc_list_voltage,
+	.get_voltage_sel	= tps62360_dcdc_get_voltage_sel,
+	.set_voltage		= tps62360_dcdc_set_voltage,
+	.list_voltage		= tps62360_dcdc_list_voltage,
+	.set_voltage_time_sel	= tps62360_set_voltage_time_sel,
 };
 
 static int tps62360_init_force_pwm(struct tps62360_chip *tps,
@@ -228,6 +247,7 @@ static int tps62360_init_dcdc(struct tps62360_chip *tps,
 {
 	int ret;
 	int i;
+	unsigned int ramp_ctrl;
 
 	/* Initailize internal pull up/down control */
 	if (tps->en_internal_pulldn)
@@ -255,9 +275,23 @@ static int tps62360_init_dcdc(struct tps62360_chip *tps,
 
 	/* Reset output discharge path to reduce power consumption */
 	ret = regmap_update_bits(tps->regmap, REG_RAMPCTRL, BIT(2), 0);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(tps->dev, "%s() fails in updating reg %d\n",
 			__func__, REG_RAMPCTRL);
+		return ret;
+	}
+
+	/* Get ramp value from ramp control register */
+	ret = regmap_read(tps->regmap, REG_RAMPCTRL, &ramp_ctrl);
+	if (ret < 0) {
+		dev_err(tps->dev, "%s() fails in reading reg %d\n",
+			__func__, REG_RAMPCTRL);
+		return ret;
+	}
+	ramp_ctrl = (ramp_ctrl >> 4) & 0x7;
+
+	/* ramp mV/us = 32/(2^ramp_ctrl) */
+	tps->change_uv_per_us = DIV_ROUND_UP(32000, BIT(ramp_ctrl));
 	return ret;
 }
 
-- 
1.7.1.1

