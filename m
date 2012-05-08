Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2EHLjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 07:39:36 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4442 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2EHLjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 07:39:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 08 May 2012 04:39:34 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: tps62360: fix stylistic issue and optimize code
Date: Tue,  8 May 2012 17:05:58 +0530
Message-Id: <1336476958-18620-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix multiple stylistic issue like:
- The print message should be not break into multiple line.
- line gap after variable declaration and statement.
- checkpatch error.
- some typo.

Some enhancement on error message printing to print error value
also along with proper text.

Avoid voltage_base conversion to microvolts every time.
Put init functions in init section.
Using efficient function inplace of calling multiple function
to reduce the code size.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
When working again on this regulator to support some more similar
device and add device-tree support, realize that there is lots of
opportunity to enhance this code.
With this patch I tried to fix some of coding style issue as well
try to reduce code size by using better apis.

I am not sure that this is ok to have all the change in single
patch or in multiple patch.

I had sent similar older patch for using better api with addition of
clear/set bits functionality in regmap but based on review discussion
dropping these new api and only using update_bits.

 drivers/regulator/tps62360-regulator.c |  131 +++++++++++++++-----------------
 1 files changed, 60 insertions(+), 71 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index d2f657e..97fd98b 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -47,10 +47,10 @@
 
 enum chips {TPS62360, TPS62361, TPS62362, TPS62363};
 
-#define TPS62360_BASE_VOLTAGE	770
+#define TPS62360_BASE_VOLTAGE	770000
 #define TPS62360_N_VOLTAGES	64
 
-#define TPS62361_BASE_VOLTAGE	500
+#define TPS62361_BASE_VOLTAGE	500000
 #define TPS62361_N_VOLTAGES	128
 
 /* tps 62360 chip information */
@@ -97,6 +97,7 @@ static bool find_voltage_set_register(struct tps62360_chip *tps,
 	bool found = false;
 	int new_vset_reg = tps->lru_index[3];
 	int found_index = 3;
+
 	for (i = 0; i < 4; ++i) {
 		if (tps->curr_vset_vsel[tps->lru_index[i]] == req_vsel) {
 			new_vset_reg = tps->lru_index[i];
@@ -124,8 +125,8 @@ static int tps62360_dcdc_get_voltage_sel(struct regulator_dev *dev)
 
 	ret = regmap_read(tps->regmap, REG_VSET0 + tps->curr_vset_id, &data);
 	if (ret < 0) {
-		dev_err(tps->dev, "%s: Error in reading register %d\n",
-			__func__, REG_VSET0 + tps->curr_vset_id);
+		dev_err(tps->dev, "%s(): register %d read failed with err %d\n",
+			__func__, REG_VSET0 + tps->curr_vset_id, ret);
 		return ret;
 	}
 	vsel = (int)data & tps->voltage_reg_mask;
@@ -141,17 +142,13 @@ static int tps62360_dcdc_set_voltage(struct regulator_dev *dev,
 	bool found = false;
 	int new_vset_id = tps->curr_vset_id;
 
-	if (max_uV < min_uV)
-		return -EINVAL;
-
-	if (min_uV >
-		((tps->voltage_base + (tps->desc.n_voltages - 1) * 10) * 1000))
+	if ((max_uV < min_uV) || (max_uV < tps->voltage_base))
 		return -EINVAL;
 
-	if (max_uV < tps->voltage_base * 1000)
+	if (min_uV > (tps->voltage_base + (tps->desc.n_voltages - 1) * 10000))
 		return -EINVAL;
 
-	vsel = DIV_ROUND_UP(min_uV - (tps->voltage_base * 1000), 10000);
+	vsel = DIV_ROUND_UP(min_uV - tps->voltage_base, 10000);
 	if (selector)
 		*selector = (vsel & tps->voltage_reg_mask);
 
@@ -166,8 +163,9 @@ static int tps62360_dcdc_set_voltage(struct regulator_dev *dev,
 		ret = regmap_update_bits(tps->regmap, REG_VSET0 + new_vset_id,
 				tps->voltage_reg_mask, vsel);
 		if (ret < 0) {
-			dev_err(tps->dev, "%s: Error in updating register %d\n",
-				 __func__, REG_VSET0 + new_vset_id);
+			dev_err(tps->dev,
+				"%s(): register %d update failed with err %d\n",
+				 __func__, REG_VSET0 + new_vset_id, ret);
 			return ret;
 		}
 		tps->curr_vset_id = new_vset_id;
@@ -176,8 +174,7 @@ static int tps62360_dcdc_set_voltage(struct regulator_dev *dev,
 
 	/* Select proper VSET register vio gpios */
 	if (tps->valid_gpios) {
-		gpio_set_value_cansleep(tps->vsel0_gpio,
-					new_vset_id & 0x1);
+		gpio_set_value_cansleep(tps->vsel0_gpio, new_vset_id & 0x1);
 		gpio_set_value_cansleep(tps->vsel1_gpio,
 					(new_vset_id >> 1) & 0x1);
 	}
@@ -191,7 +188,8 @@ static int tps62360_dcdc_list_voltage(struct regulator_dev *dev,
 
 	if (selector >= tps->desc.n_voltages)
 		return -EINVAL;
-	return (tps->voltage_base + selector * 10) * 1000;
+
+	return tps->voltage_base + selector * 10000;
 }
 
 static int tps62360_set_voltage_time_sel(struct regulator_dev *rdev,
@@ -218,49 +216,44 @@ static struct regulator_ops tps62360_dcdc_ops = {
 	.set_voltage_time_sel	= tps62360_set_voltage_time_sel,
 };
 
-static int tps62360_init_force_pwm(struct tps62360_chip *tps,
+static int __devinit tps62360_init_force_pwm(struct tps62360_chip *tps,
 	struct tps62360_regulator_platform_data *pdata,
 	int vset_id)
 {
-	unsigned int data;
 	int ret;
-	ret = regmap_read(tps->regmap, REG_VSET0 + vset_id, &data);
-	if (ret < 0) {
-		dev_err(tps->dev, "%s() fails in writing reg %d\n",
-			__func__, REG_VSET0 + vset_id);
-		return ret;
-	}
-	tps->curr_vset_vsel[vset_id] = data & tps->voltage_reg_mask;
+	int bit = 0;
+
 	if (pdata->en_force_pwm)
-		data |= BIT(7);
-	else
-		data &= ~BIT(7);
-	ret = regmap_write(tps->regmap, REG_VSET0 + vset_id, data);
+		bit = BIT(7);
+
+	ret = regmap_update_bits(tps->regmap, REG_VSET0 + vset_id, BIT(7), bit);
 	if (ret < 0)
-		dev_err(tps->dev, "%s() fails in writing reg %d\n",
-				__func__, REG_VSET0 + vset_id);
+		dev_err(tps->dev,
+			"%s(): register %d update failed with err %d\n",
+			__func__, REG_VSET0 + vset_id, ret);
 	return ret;
 }
 
-static int tps62360_init_dcdc(struct tps62360_chip *tps,
+static int __devinit tps62360_init_dcdc(struct tps62360_chip *tps,
 		struct tps62360_regulator_platform_data *pdata)
 {
 	int ret;
 	int i;
 	unsigned int ramp_ctrl;
 
-	/* Initailize internal pull up/down control */
+	/* Initialize internal pull up/down control */
 	if (tps->en_internal_pulldn)
 		ret = regmap_write(tps->regmap, REG_CONTROL, 0xE0);
 	else
 		ret = regmap_write(tps->regmap, REG_CONTROL, 0x0);
 	if (ret < 0) {
-		dev_err(tps->dev, "%s() fails in writing reg %d\n",
-			__func__, REG_CONTROL);
+		dev_err(tps->dev,
+			"%s(): register %d write failed with err %d\n",
+			__func__, REG_CONTROL, ret);
 		return ret;
 	}
 
-	/* Initailize force PWM mode */
+	/* Initialize force PWM mode */
 	if (tps->valid_gpios) {
 		for (i = 0; i < 4; ++i) {
 			ret = tps62360_init_force_pwm(tps, pdata, i);
@@ -276,16 +269,18 @@ static int tps62360_init_dcdc(struct tps62360_chip *tps,
 	/* Reset output discharge path to reduce power consumption */
 	ret = regmap_update_bits(tps->regmap, REG_RAMPCTRL, BIT(2), 0);
 	if (ret < 0) {
-		dev_err(tps->dev, "%s() fails in updating reg %d\n",
-			__func__, REG_RAMPCTRL);
+		dev_err(tps->dev,
+			"%s(): register %d update failed with err %d\n",
+			__func__, REG_RAMPCTRL, ret);
 		return ret;
 	}
 
 	/* Get ramp value from ramp control register */
 	ret = regmap_read(tps->regmap, REG_RAMPCTRL, &ramp_ctrl);
 	if (ret < 0) {
-		dev_err(tps->dev, "%s() fails in reading reg %d\n",
-			__func__, REG_RAMPCTRL);
+		dev_err(tps->dev,
+			"%s(): register %d read failed with err %d\n",
+			__func__, REG_RAMPCTRL, ret);
 		return ret;
 	}
 	ramp_ctrl = (ramp_ctrl >> 4) & 0x7;
@@ -314,14 +309,14 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 
 	pdata = client->dev.platform_data;
 	if (!pdata) {
-		dev_err(&client->dev, "%s() Err: Platform data not found\n",
+		dev_err(&client->dev, "%s(): Platform data not found\n",
 						__func__);
 		return -EIO;
 	}
 
 	tps = devm_kzalloc(&client->dev, sizeof(*tps), GFP_KERNEL);
 	if (!tps) {
-		dev_err(&client->dev, "%s() Err: Memory allocation fails\n",
+		dev_err(&client->dev, "%s(): Memory allocation failed\n",
 						__func__);
 		return -ENOMEM;
 	}
@@ -358,8 +353,9 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 	tps->regmap = devm_regmap_init_i2c(client, &tps62360_regmap_config);
 	if (IS_ERR(tps->regmap)) {
 		ret = PTR_ERR(tps->regmap);
-		dev_err(&client->dev, "%s() Err: Failed to allocate register"
-			"map: %d\n", __func__, ret);
+		dev_err(&client->dev,
+			"%s(): regmap allocation failed with err %d\n",
+			__func__, ret);
 		return ret;
 	}
 	i2c_set_clientdata(client, tps);
@@ -370,35 +366,26 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 	tps->valid_gpios = false;
 
 	if (gpio_is_valid(tps->vsel0_gpio) && gpio_is_valid(tps->vsel1_gpio)) {
-		ret = gpio_request(tps->vsel0_gpio, "tps62360-vsel0");
+		int gpio_flags;
+		gpio_flags = (pdata->vsel0_def_state) ?
+				GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
+		ret = gpio_request_one(tps->vsel0_gpio,
+				gpio_flags, "tps62360-vsel0");
 		if (ret) {
 			dev_err(&client->dev,
-				"Err: Could not obtain vsel0 GPIO %d: %d\n",
-						tps->vsel0_gpio, ret);
-			goto err_gpio0;
-		}
-		ret = gpio_direction_output(tps->vsel0_gpio,
-					pdata->vsel0_def_state);
-		if (ret) {
-			dev_err(&client->dev, "Err: Could not set direction of"
-				"vsel0 GPIO %d: %d\n", tps->vsel0_gpio, ret);
-			gpio_free(tps->vsel0_gpio);
+				"%s(): Could not obtain vsel0 GPIO %d: %d\n",
+				__func__, tps->vsel0_gpio, ret);
 			goto err_gpio0;
 		}
 
-		ret = gpio_request(tps->vsel1_gpio, "tps62360-vsel1");
+		gpio_flags = (pdata->vsel1_def_state) ?
+				GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
+		ret = gpio_request_one(tps->vsel1_gpio,
+				gpio_flags, "tps62360-vsel1");
 		if (ret) {
 			dev_err(&client->dev,
-				"Err: Could not obtain vsel1 GPIO %d: %d\n",
-						tps->vsel1_gpio, ret);
-			goto err_gpio1;
-		}
-		ret = gpio_direction_output(tps->vsel1_gpio,
-					pdata->vsel1_def_state);
-		if (ret) {
-			dev_err(&client->dev, "Err: Could not set direction of"
-				"vsel1 GPIO %d: %d\n", tps->vsel1_gpio, ret);
-			gpio_free(tps->vsel1_gpio);
+				"%s(): Could not obtain vsel1 GPIO %d: %d\n",
+				__func__, tps->vsel1_gpio, ret);
 			goto err_gpio1;
 		}
 		tps->valid_gpios = true;
@@ -415,7 +402,7 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 
 	ret = tps62360_init_dcdc(tps, pdata);
 	if (ret < 0) {
-		dev_err(tps->dev, "%s() Err: Init fails with = %d\n",
+		dev_err(tps->dev, "%s(): Init failed with err = %d\n",
 				__func__, ret);
 		goto err_init;
 	}
@@ -427,8 +414,9 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 	/* Register the regulators */
 	rdev = regulator_register(&tps->desc, &config);
 	if (IS_ERR(rdev)) {
-		dev_err(tps->dev, "%s() Err: Failed to register %s\n",
-				__func__, id->name);
+		dev_err(tps->dev,
+			"%s(): regulator register failed with err %s\n",
+			__func__, id->name);
 		ret = PTR_ERR(rdev);
 		goto err_init;
 	}
@@ -477,8 +465,9 @@ static void tps62360_shutdown(struct i2c_client *client)
 	/* Configure the output discharge path */
 	st = regmap_update_bits(tps->regmap, REG_RAMPCTRL, BIT(2), BIT(2));
 	if (st < 0)
-		dev_err(tps->dev, "%s() fails in updating reg %d\n",
-			__func__, REG_RAMPCTRL);
+		dev_err(tps->dev,
+			"%s(): register %d update failed with err %d\n",
+			__func__, REG_RAMPCTRL, st);
 }
 
 static const struct i2c_device_id tps62360_id[] = {
-- 
1.7.1.1

