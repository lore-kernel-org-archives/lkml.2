Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372Ab2EINO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:14:58 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8112 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352Ab2EINO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:14:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 09 May 2012 06:14:43 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        jedu@slimlogic.co.uk, lrg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/4] mfd: tps65910: convert all allocation to devm_*
Date: Wed,  9 May 2012 18:40:55 +0530
Message-Id: <1336569057-3890-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1336569057-3890-1-git-send-email-ldewangan@nvidia.com>
References: <1336569057-3890-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert memory allocation and regmap initialization to
use devm_* functions.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/tps65910.c |   28 +++++++++-------------------
 1 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 0f95ddf..d0d8ae9 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -161,15 +161,13 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
 	if (!pmic_plat_data)
 		return -EINVAL;
 
-	init_data = kzalloc(sizeof(struct tps65910_platform_data), GFP_KERNEL);
+	init_data = devm_kzalloc(&i2c->dev, sizeof(*init_data), GFP_KERNEL);
 	if (init_data == NULL)
 		return -ENOMEM;
 
-	tps65910 = kzalloc(sizeof(struct tps65910), GFP_KERNEL);
-	if (tps65910 == NULL) {
-		kfree(init_data);
+	tps65910 = devm_kzalloc(&i2c->dev, sizeof(*tps65910), GFP_KERNEL);
+	if (tps65910 == NULL)
 		return -ENOMEM;
-	}
 
 	i2c_set_clientdata(i2c, tps65910);
 	tps65910->dev = &i2c->dev;
@@ -179,18 +177,20 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
 	tps65910->write = tps65910_i2c_write;
 	mutex_init(&tps65910->io_mutex);
 
-	tps65910->regmap = regmap_init_i2c(i2c, &tps65910_regmap_config);
+	tps65910->regmap = devm_regmap_init_i2c(i2c, &tps65910_regmap_config);
 	if (IS_ERR(tps65910->regmap)) {
 		ret = PTR_ERR(tps65910->regmap);
 		dev_err(&i2c->dev, "regmap initialization failed: %d\n", ret);
-		goto regmap_err;
+		return ret;
 	}
 
 	ret = mfd_add_devices(tps65910->dev, -1,
 			      tps65910s, ARRAY_SIZE(tps65910s),
 			      NULL, 0);
-	if (ret < 0)
-		goto err;
+	if (ret < 0) {
+		dev_err(&i2c->dev, "mfd_add_devices failed: %d\n", ret);
+		return ret;
+	}
 
 	init_data->irq = pmic_plat_data->irq;
 	init_data->irq_base = pmic_plat_data->irq_base;
@@ -201,14 +201,6 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
 
 	tps65910_sleepinit(tps65910, pmic_plat_data);
 
-	kfree(init_data);
-	return ret;
-
-err:
-	regmap_exit(tps65910->regmap);
-regmap_err:
-	kfree(tps65910);
-	kfree(init_data);
 	return ret;
 }
 
@@ -218,8 +210,6 @@ static __devexit int tps65910_i2c_remove(struct i2c_client *i2c)
 
 	tps65910_irq_exit(tps65910);
 	mfd_remove_devices(tps65910->dev);
-	regmap_exit(tps65910->regmap);
-	kfree(tps65910);
 
 	return 0;
 }
-- 
1.7.1.1

