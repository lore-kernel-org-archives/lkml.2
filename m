Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab2GGA2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 20:28:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60075 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab2GGA2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 20:28:44 -0400
Message-ID: <1341620913.3153.1.camel@phoenix>
Subject: [PATCH] regulator: tps62360: Convert to devm_gpio_request_one
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 07 Jul 2012 08:28:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_gpio_request_one to save a few error handling code.
Also remove trivial comment for tps62360_remove.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps62360-regulator.c |   38 +++++++-------------------------
 1 file changed, 8 insertions(+), 30 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index 103bb62..062a9cf 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -428,24 +428,24 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 		int gpio_flags;
 		gpio_flags = (pdata->vsel0_def_state) ?
 				GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
-		ret = gpio_request_one(tps->vsel0_gpio,
-				gpio_flags, "tps62360-vsel0");
+		ret = devm_gpio_request_one(&client->dev, tps->vsel0_gpio,
+					    gpio_flags, "tps62360-vsel0");
 		if (ret) {
 			dev_err(&client->dev,
 				"%s(): Could not obtain vsel0 GPIO %d: %d\n",
 				__func__, tps->vsel0_gpio, ret);
-			goto err_gpio0;
+			return ret;
 		}
 
 		gpio_flags = (pdata->vsel1_def_state) ?
 				GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
-		ret = gpio_request_one(tps->vsel1_gpio,
-				gpio_flags, "tps62360-vsel1");
+		ret = devm_gpio_request_one(&client->dev, tps->vsel1_gpio,
+					    gpio_flags, "tps62360-vsel1");
 		if (ret) {
 			dev_err(&client->dev,
 				"%s(): Could not obtain vsel1 GPIO %d: %d\n",
 				__func__, tps->vsel1_gpio, ret);
-			goto err_gpio1;
+			return ret;
 		}
 		tps->valid_gpios = true;
 
@@ -463,7 +463,7 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 	if (ret < 0) {
 		dev_err(tps->dev, "%s(): Init failed with err = %d\n",
 				__func__, ret);
-		goto err_init;
+		return ret;
 	}
 
 	config.dev = &client->dev;
@@ -477,39 +477,17 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 		dev_err(tps->dev,
 			"%s(): regulator register failed with err %s\n",
 			__func__, id->name);
-		ret = PTR_ERR(rdev);
-		goto err_init;
+		return PTR_ERR(rdev);
 	}
 
 	tps->rdev = rdev;
 	return 0;
-
-err_init:
-	if (gpio_is_valid(tps->vsel1_gpio))
-		gpio_free(tps->vsel1_gpio);
-err_gpio1:
-	if (gpio_is_valid(tps->vsel0_gpio))
-		gpio_free(tps->vsel0_gpio);
-err_gpio0:
-	return ret;
 }
 
-/**
- * tps62360_remove - tps62360 driver i2c remove handler
- * @client: i2c driver client device structure
- *
- * Unregister TPS driver as an i2c client device driver
- */
 static int __devexit tps62360_remove(struct i2c_client *client)
 {
 	struct tps62360_chip *tps = i2c_get_clientdata(client);
 
-	if (gpio_is_valid(tps->vsel1_gpio))
-		gpio_free(tps->vsel1_gpio);
-
-	if (gpio_is_valid(tps->vsel0_gpio))
-		gpio_free(tps->vsel0_gpio);
-
 	regulator_unregister(tps->rdev);
 	return 0;
 }
-- 
1.7.9.5



