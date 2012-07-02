Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab2GBKJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:09:39 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5623 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab2GBKJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:09:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 02 Jul 2012 03:09:33 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regulator: tps62360: use devm_* for gpio request
Date: Mon, 2 Jul 2012 15:35:48 +0530
Message-ID: <1341223548-7782-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ version of gpio APIs gpio_request_one() for
requesting gpios.
This avoid extra code for freeing gpios.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps62360-regulator.c |   28 ++++++----------------------
 1 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index bcea4e1..7f42ef5 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -439,24 +439,24 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 		int gpio_flags;
 		gpio_flags = (pdata->vsel0_def_state) ?
 				GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
-		ret = gpio_request_one(tps->vsel0_gpio,
+		ret = devm_gpio_request_one(&client->dev, tps->vsel0_gpio,
 				gpio_flags, "tps62360-vsel0");
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
+		ret = devm_gpio_request_one(&client->dev, tps->vsel1_gpio,
 				gpio_flags, "tps62360-vsel1");
 		if (ret) {
 			dev_err(&client->dev,
 				"%s(): Could not obtain vsel1 GPIO %d: %d\n",
 				__func__, tps->vsel1_gpio, ret);
-			goto err_gpio1;
+			return ret;
 		}
 		tps->valid_gpios = true;
 
@@ -474,7 +474,7 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 	if (ret < 0) {
 		dev_err(tps->dev, "%s(): Init failed with err = %d\n",
 				__func__, ret);
-		goto err_init;
+		return ret;
 	}
 
 	config.dev = &client->dev;
@@ -488,21 +488,11 @@ static int __devinit tps62360_probe(struct i2c_client *client,
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
 
 /**
@@ -515,12 +505,6 @@ static int __devexit tps62360_remove(struct i2c_client *client)
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
1.7.1.1

