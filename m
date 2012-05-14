Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab2ENMVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 08:21:24 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15349 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab2ENMVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 08:21:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 14 May 2012 05:21:17 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        <grant.likely@secretlab.ca>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: tps62360: support force PWM mode via regulator mode
Date: Mon, 14 May 2012 17:46:51 +0530
Message-ID: <1336997811-32207-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the mechanism of enabling the force PWM mode through
regulator set mode. This can be dynamically configured now.
In the REGULATOR_MODE_FAST the force PWM is enabled and in
REGULATOR_MODE_NORMAL the force PWM is disabled.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
There was discussion on the dt support patch that force
pwm should be mapped to regulator mode. Although modern
regulator does not need this to be enable but still saw
some latest regulator having this configuration and
it is better to have this support in driver and hence
sending the patch.

 .../bindings/regulator/tps62360-regulator.txt      |    1 -
 drivers/regulator/tps62360-regulator.c             |  102 +++++++++++++-------
 include/linux/regulator/tps62360.h                 |    2 -
 3 files changed, 65 insertions(+), 40 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt b/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt
index f411b57..c8ca6b8 100644
--- a/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt
@@ -9,7 +9,6 @@ Required properties:
 - reg: I2C slave address
 
 Optional properties:
-- ti,enable-force-pwm: Enable force PWM mode. This is boolean value.
 - ti,enable-vout-discharge: Enable output discharge. This is boolean value.
 - ti,enable-pull-down: Enable pull down. This is boolean value.
 - ti,vsel0-gpio: GPIO for controlling VSEL0 line.
diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index 926c0e8..3331df3 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -49,6 +49,8 @@
 #define REG_RAMPCTRL		6
 #define REG_CHIPID		8
 
+#define FORCE_PWM_ENABLE	BIT(7)
+
 enum chips {TPS62360, TPS62361, TPS62362, TPS62363};
 
 #define TPS62360_BASE_VOLTAGE	770000
@@ -69,7 +71,6 @@ struct tps62360_chip {
 	int voltage_base;
 	u8 voltage_reg_mask;
 	bool en_internal_pulldn;
-	bool en_force_pwm;
 	bool en_discharge;
 	bool valid_gpios;
 	int lru_index[4];
@@ -191,37 +192,81 @@ static int tps62360_set_voltage_time_sel(struct regulator_dev *rdev,
 	return DIV_ROUND_UP(abs(old_uV - new_uV), tps->change_uv_per_us);
 }
 
+static int tps62360_set_mode(struct regulator_dev *rdev, unsigned int mode)
+{
+	struct tps62360_chip *tps = rdev_get_drvdata(rdev);
+	int i;
+	int val;
+	int ret;
+
+	/* Enable force PWM mode in FAST mode only. */
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+		val = FORCE_PWM_ENABLE;
+		break;
+
+	case REGULATOR_MODE_NORMAL:
+		val = 0;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (!tps->valid_gpios) {
+		ret = regmap_update_bits(tps->regmap,
+			REG_VSET0 + tps->curr_vset_id, FORCE_PWM_ENABLE, val);
+		if (ret < 0)
+			dev_err(tps->dev,
+				"%s(): register %d update failed with err %d\n",
+				__func__, REG_VSET0 + tps->curr_vset_id, ret);
+		return ret;
+	}
+
+	/* If gpios are valid then all register set need to be control */
+	for (i = 0; i < 4; ++i) {
+		ret = regmap_update_bits(tps->regmap,
+					REG_VSET0 + i, FORCE_PWM_ENABLE, val);
+		if (ret < 0) {
+			dev_err(tps->dev,
+				"%s(): register %d update failed with err %d\n",
+				__func__, REG_VSET0 + i, ret);
+			return ret;
+		}
+	}
+	return ret;
+}
+
+static unsigned int tps62360_get_mode(struct regulator_dev *rdev)
+{
+	struct tps62360_chip *tps = rdev_get_drvdata(rdev);
+	unsigned int data;
+	int ret;
+
+	ret = regmap_read(tps->regmap, REG_VSET0 + tps->curr_vset_id, &data);
+	if (ret < 0) {
+		dev_err(tps->dev, "%s(): register %d read failed with err %d\n",
+			__func__, REG_VSET0 + tps->curr_vset_id, ret);
+		return ret;
+	}
+	return (data & FORCE_PWM_ENABLE) ?
+				REGULATOR_MODE_FAST : REGULATOR_MODE_NORMAL;
+}
+
 static struct regulator_ops tps62360_dcdc_ops = {
 	.get_voltage_sel	= tps62360_dcdc_get_voltage_sel,
 	.set_voltage_sel	= tps62360_dcdc_set_voltage_sel,
 	.list_voltage		= regulator_list_voltage_linear,
 	.map_voltage		= regulator_map_voltage_linear,
 	.set_voltage_time_sel	= tps62360_set_voltage_time_sel,
+	.set_mode		= tps62360_set_mode,
+	.get_mode		= tps62360_get_mode,
 };
 
-static int __devinit tps62360_init_force_pwm(struct tps62360_chip *tps,
-	struct tps62360_regulator_platform_data *pdata,
-	int vset_id)
-{
-	int ret;
-	int bit = 0;
-
-	if (pdata->en_force_pwm)
-		bit = BIT(7);
-
-	ret = regmap_update_bits(tps->regmap, REG_VSET0 + vset_id, BIT(7), bit);
-	if (ret < 0)
-		dev_err(tps->dev,
-			"%s(): register %d update failed with err %d\n",
-			__func__, REG_VSET0 + vset_id, ret);
-	return ret;
-}
-
 static int __devinit tps62360_init_dcdc(struct tps62360_chip *tps,
 		struct tps62360_regulator_platform_data *pdata)
 {
 	int ret;
-	int i;
 	unsigned int ramp_ctrl;
 
 	/* Initialize internal pull up/down control */
@@ -236,19 +281,6 @@ static int __devinit tps62360_init_dcdc(struct tps62360_chip *tps,
 		return ret;
 	}
 
-	/* Initialize force PWM mode */
-	if (tps->valid_gpios) {
-		for (i = 0; i < 4; ++i) {
-			ret = tps62360_init_force_pwm(tps, pdata, i);
-			if (ret < 0)
-				return ret;
-		}
-	} else {
-		ret = tps62360_init_force_pwm(tps, pdata, tps->curr_vset_id);
-		if (ret < 0)
-			return ret;
-	}
-
 	/* Reset output discharge path to reduce power consumption */
 	ret = regmap_update_bits(tps->regmap, REG_RAMPCTRL, BIT(2), 0);
 	if (ret < 0) {
@@ -310,9 +342,6 @@ static struct tps62360_regulator_platform_data *
 	if (of_find_property(np, "ti,enable-pull-down", NULL))
 		pdata->en_internal_pulldn = true;
 
-	if (of_find_property(np, "ti,enable-force-pwm", NULL))
-		pdata->en_force_pwm = true;
-
 	if (of_find_property(np, "ti,enable-vout-discharge", NULL))
 		pdata->en_discharge = true;
 
@@ -370,7 +399,6 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 		return -ENOMEM;
 	}
 
-	tps->en_force_pwm = pdata->en_force_pwm;
 	tps->en_discharge = pdata->en_discharge;
 	tps->en_internal_pulldn = pdata->en_internal_pulldn;
 	tps->vsel0_gpio = pdata->vsel0_gpio;
diff --git a/include/linux/regulator/tps62360.h b/include/linux/regulator/tps62360.h
index 5e11d50..a4c4939 100644
--- a/include/linux/regulator/tps62360.h
+++ b/include/linux/regulator/tps62360.h
@@ -30,7 +30,6 @@
  * struct tps62360_regulator_platform_data - tps62360 regulator platform data.
  *
  * @reg_init_data: The regulator init data.
- * @en_force_pwm: Enable force pwm or not.
  * @en_discharge: Enable discharge the output capacitor via internal
  *                register.
  * @en_internal_pulldn: internal pull down enable or not.
@@ -43,7 +42,6 @@
  */
 struct tps62360_regulator_platform_data {
 	struct regulator_init_data *reg_init_data;
-	bool en_force_pwm;
 	bool en_discharge;
 	bool en_internal_pulldn;
 	int vsel0_gpio;
-- 
1.7.1.1

