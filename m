Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab2EGHjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 03:39:07 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16665 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab2EGHjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 03:39:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 07 May 2012 00:39:04 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org,
        lrg@ti.com, linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V1 3/4] regulator: tps62360: use efficient function
Date: Mon,  7 May 2012 13:05:38 +0530
Message-Id: <1336376139-1048-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1336376139-1048-1-git-send-email-ldewangan@nvidia.com>
References: <1336376139-1048-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In place of using the multiple function to achieve desire
functionality, use the function which implement that functionality,
like:
- regmap_update_bits for read-modify-write
- gpio_request_one for gpio_request and intial setting output.

This reduces code size effectively.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps62360-regulator.c |   53 +++++++++++---------------------
 1 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index 375f757..ad7d67a 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -203,23 +203,15 @@ static int tps62360_init_force_pwm(struct tps62360_chip *tps,
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
+	int reg = REG_VSET0 + vset_id;
 	if (pdata->en_force_pwm)
-		data |= BIT(7);
+		ret = regmap_set_bits(tps->regmap, reg, BIT(7));
 	else
-		data &= ~BIT(7);
-	ret = regmap_write(tps->regmap, REG_VSET0 + vset_id, data);
+		ret = regmap_clear_bits(tps->regmap, reg, BIT(7));
 	if (ret < 0)
-		dev_err(tps->dev, "%s() fails in writing reg %d\n",
-				__func__, REG_VSET0 + vset_id);
+		dev_err(tps->dev, "%s() register %d configuration fails\n",
+			__func__, reg);
 	return ret;
 }
 
@@ -254,9 +246,9 @@ static int tps62360_init_dcdc(struct tps62360_chip *tps,
 	}
 
 	/* Reset output discharge path to reduce power consumption */
-	ret = regmap_update_bits(tps->regmap, REG_RAMPCTRL, BIT(2), 0);
+	ret = regmap_clear_bits(tps->regmap, REG_RAMPCTRL, BIT(2));
 	if (ret < 0)
-		dev_err(tps->dev, "%s() fails in updating reg %d\n",
+		dev_err(tps->dev, "%s() fails in clearing bits of reg %d\n",
 			__func__, REG_RAMPCTRL);
 	return ret;
 }
@@ -337,37 +329,28 @@ static int __devinit tps62360_probe(struct i2c_client *client,
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
 				"Err: Could not obtain vsel0 GPIO %d: %d\n",
 						tps->vsel0_gpio, ret);
 			goto err_gpio0;
 		}
-		ret = gpio_direction_output(tps->vsel0_gpio,
-					pdata->vsel0_def_state);
-		if (ret) {
-			dev_err(&client->dev, "Err: Could not set direction of"
-				"vsel0 GPIO %d: %d\n", tps->vsel0_gpio, ret);
-			gpio_free(tps->vsel0_gpio);
-			goto err_gpio0;
-		}
 
-		ret = gpio_request(tps->vsel1_gpio, "tps62360-vsel1");
+		gpio_flags = (pdata->vsel1_def_state) ?
+				GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
+		ret = gpio_request_one(tps->vsel1_gpio,
+				gpio_flags, "tps62360-vsel1");
 		if (ret) {
 			dev_err(&client->dev,
 				"Err: Could not obtain vsel1 GPIO %d: %d\n",
 						tps->vsel1_gpio, ret);
 			goto err_gpio1;
 		}
-		ret = gpio_direction_output(tps->vsel1_gpio,
-					pdata->vsel1_def_state);
-		if (ret) {
-			dev_err(&client->dev, "Err: Could not set direction of"
-				"vsel1 GPIO %d: %d\n", tps->vsel1_gpio, ret);
-			gpio_free(tps->vsel1_gpio);
-			goto err_gpio1;
-		}
 		tps->valid_gpios = true;
 
 		/*
@@ -442,9 +425,9 @@ static void tps62360_shutdown(struct i2c_client *client)
 		return;
 
 	/* Configure the output discharge path */
-	st = regmap_update_bits(tps->regmap, REG_RAMPCTRL, BIT(2), BIT(2));
+	st = regmap_set_bits(tps->regmap, REG_RAMPCTRL, BIT(2));
 	if (st < 0)
-		dev_err(tps->dev, "%s() fails in updating reg %d\n",
+		dev_err(tps->dev, "%s() fails in setting reg %d\n",
 			__func__, REG_RAMPCTRL);
 }
 
-- 
1.7.1.1

