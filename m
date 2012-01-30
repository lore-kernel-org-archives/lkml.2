Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2A3V3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:29:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35522 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753257Ab2A3V3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:29:48 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] mfd: wm8994: Convert to devm_regmap_init()
Date: Mon, 30 Jan 2012 21:29:44 +0000
Message-Id: <1327958986-16115-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

OK to take this via regmap, it's another new feature?

 drivers/mfd/wm8994-core.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index f275427..e294717 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -401,7 +401,7 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 			      NULL, 0);
 	if (ret != 0) {
 		dev_err(wm8994->dev, "Failed to add children: %d\n", ret);
-		goto err_regmap;
+		goto err;
 	}
 
 	switch (wm8994->type) {
@@ -416,7 +416,7 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		break;
 	default:
 		BUG();
-		goto err_regmap;
+		goto err;
 	}
 
 	wm8994->supplies = devm_kzalloc(wm8994->dev,
@@ -424,7 +424,7 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 					wm8994->num_supplies, GFP_KERNEL);
 	if (!wm8994->supplies) {
 		ret = -ENOMEM;
-		goto err_regmap;
+		goto err;
 	}
 
 	switch (wm8994->type) {
@@ -442,14 +442,14 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		break;
 	default:
 		BUG();
-		goto err_regmap;
+		goto err;
 	}
 		
 	ret = regulator_bulk_get(wm8994->dev, wm8994->num_supplies,
 				 wm8994->supplies);
 	if (ret != 0) {
 		dev_err(wm8994->dev, "Failed to get supplies: %d\n", ret);
-		goto err_regmap;
+		goto err;
 	}
 
 	ret = regulator_bulk_enable(wm8994->num_supplies,
@@ -581,7 +581,7 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		if (ret != 0) {
 			dev_err(wm8994->dev, "Failed to register patch: %d\n",
 				ret);
-			goto err_regmap;
+			goto err;
 		}
 	}
 
@@ -647,8 +647,7 @@ err_enable:
 			       wm8994->supplies);
 err_get:
 	regulator_bulk_free(wm8994->num_supplies, wm8994->supplies);
-err_regmap:
-	regmap_exit(wm8994->regmap);
+err:
 	mfd_remove_devices(wm8994->dev);
 	return ret;
 }
@@ -661,7 +660,6 @@ static __devexit void wm8994_device_exit(struct wm8994 *wm8994)
 	regulator_bulk_disable(wm8994->num_supplies,
 			       wm8994->supplies);
 	regulator_bulk_free(wm8994->num_supplies, wm8994->supplies);
-	regmap_exit(wm8994->regmap);
 }
 
 static const struct of_device_id wm8994_of_match[] = {
@@ -687,7 +685,7 @@ static int wm8994_i2c_probe(struct i2c_client *i2c,
 	wm8994->irq = i2c->irq;
 	wm8994->type = id->driver_data;
 
-	wm8994->regmap = regmap_init_i2c(i2c, &wm8994_base_regmap_config);
+	wm8994->regmap = devm_regmap_init_i2c(i2c, &wm8994_base_regmap_config);
 	if (IS_ERR(wm8994->regmap)) {
 		ret = PTR_ERR(wm8994->regmap);
 		dev_err(wm8994->dev, "Failed to allocate register map: %d\n",
-- 
1.7.9.rc1

