Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2GIWKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:10:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49545 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2GIWKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:10:21 -0400
Message-ID: <1341871812.4847.2.camel@phoenix>
Subject: [PATCH RFT] regulator: max8952: Use core GPIO enable support
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 10 Jul 2012 06:10:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8952.c |   59 +++----------------------------------------
 1 file changed, 4 insertions(+), 55 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index ea58a44..355ca7b 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -51,7 +51,6 @@ struct max8952_data {
 
 	bool vid0;
 	bool vid1;
-	bool en;
 };
 
 static int max8952_read_reg(struct max8952_data *max8952, u8 reg)
@@ -80,38 +79,6 @@ static int max8952_list_voltage(struct regulator_dev *rdev,
 	return (max8952->pdata->dvs_mode[selector] * 10 + 770) * 1000;
 }
 
-static int max8952_is_enabled(struct regulator_dev *rdev)
-{
-	struct max8952_data *max8952 = rdev_get_drvdata(rdev);
-	return max8952->en;
-}
-
-static int max8952_enable(struct regulator_dev *rdev)
-{
-	struct max8952_data *max8952 = rdev_get_drvdata(rdev);
-
-	/* If not valid, assume "ALWAYS_HIGH" */
-	if (gpio_is_valid(max8952->pdata->gpio_en))
-		gpio_set_value(max8952->pdata->gpio_en, 1);
-
-	max8952->en = true;
-	return 0;
-}
-
-static int max8952_disable(struct regulator_dev *rdev)
-{
-	struct max8952_data *max8952 = rdev_get_drvdata(rdev);
-
-	/* If not valid, assume "ALWAYS_HIGH" -> not permitted */
-	if (gpio_is_valid(max8952->pdata->gpio_en))
-		gpio_set_value(max8952->pdata->gpio_en, 0);
-	else
-		return -EPERM;
-
-	max8952->en = false;
-	return 0;
-}
-
 static int max8952_get_voltage_sel(struct regulator_dev *rdev)
 {
 	struct max8952_data *max8952 = rdev_get_drvdata(rdev);
@@ -146,9 +113,6 @@ static int max8952_set_voltage_sel(struct regulator_dev *rdev,
 
 static struct regulator_ops max8952_ops = {
 	.list_voltage		= max8952_list_voltage,
-	.is_enabled		= max8952_is_enabled,
-	.enable			= max8952_enable,
-	.disable		= max8952_disable,
 	.get_voltage_sel	= max8952_get_voltage_sel,
 	.set_voltage_sel	= max8952_set_voltage_sel,
 };
@@ -193,6 +157,10 @@ static int __devinit max8952_pmic_probe(struct i2c_client *client,
 	config.init_data = &pdata->reg_data;
 	config.driver_data = max8952;
 
+	config.ena_gpio = pdata->gpio_en;
+	if (pdata->reg_data.constraints.boot_on)
+		config.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
+
 	max8952->rdev = regulator_register(&regulator, &config);
 
 	if (IS_ERR(max8952->rdev)) {
@@ -201,27 +169,9 @@ static int __devinit max8952_pmic_probe(struct i2c_client *client,
 		return ret;
 	}
 
-	max8952->en = !!(pdata->reg_data.constraints.boot_on);
 	max8952->vid0 = pdata->default_mode & 0x1;
 	max8952->vid1 = (pdata->default_mode >> 1) & 0x1;
 
-	if (gpio_is_valid(pdata->gpio_en)) {
-		if (!gpio_request(pdata->gpio_en, "MAX8952 EN"))
-			gpio_direction_output(pdata->gpio_en, max8952->en);
-		else
-			err = 1;
-	} else
-		err = 2;
-
-	if (err) {
-		dev_info(max8952->dev, "EN gpio invalid: assume that EN"
-				"is always High\n");
-		max8952->en = 1;
-		pdata->gpio_en = -1; /* Mark invalid */
-	}
-
-	err = 0;
-
 	if (gpio_is_valid(pdata->gpio_vid0) &&
 			gpio_is_valid(pdata->gpio_vid1)) {
 		if (!gpio_request(pdata->gpio_vid0, "MAX8952 VID0"))
@@ -307,7 +257,6 @@ static int __devexit max8952_pmic_remove(struct i2c_client *client)
 
 	gpio_free(pdata->gpio_vid0);
 	gpio_free(pdata->gpio_vid1);
-	gpio_free(pdata->gpio_en);
 	return 0;
 }
 
-- 
1.7.9.5



