Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab1K1WpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:45:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60971 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754949Ab1K1WpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:45:02 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/8] mfd: Convert wm8994 to devm_kzalloc()
Date: Mon, 28 Nov 2011 22:44:29 +0000
Message-Id: <1322520274-13789-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1322520274-13789-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20111128224017.GA13163@opensource.wolfsonmicro.com>
 <1322520274-13789-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 74d4746..a6846b0 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -401,9 +401,9 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		goto err_regmap;
 	}
 
-	wm8994->supplies = kzalloc(sizeof(struct regulator_bulk_data) *
-				   wm8994->num_supplies,
-				   GFP_KERNEL);
+	wm8994->supplies = devm_kzalloc(wm8994->dev,
+					sizeof(struct regulator_bulk_data) *
+					wm8994->num_supplies, GFP_KERNEL);
 	if (!wm8994->supplies) {
 		ret = -ENOMEM;
 		goto err_regmap;
@@ -431,7 +431,7 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 				 wm8994->supplies);
 	if (ret != 0) {
 		dev_err(wm8994->dev, "Failed to get supplies: %d\n", ret);
-		goto err_supplies;
+		goto err_regmap;
 	}
 
 	ret = regulator_bulk_enable(wm8994->num_supplies,
@@ -559,12 +559,9 @@ err_enable:
 			       wm8994->supplies);
 err_get:
 	regulator_bulk_free(wm8994->num_supplies, wm8994->supplies);
-err_supplies:
-	kfree(wm8994->supplies);
 err_regmap:
 	regmap_exit(wm8994->regmap);
 	mfd_remove_devices(wm8994->dev);
-	kfree(wm8994);
 	return ret;
 }
 
@@ -576,9 +573,7 @@ static void wm8994_device_exit(struct wm8994 *wm8994)
 	regulator_bulk_disable(wm8994->num_supplies,
 			       wm8994->supplies);
 	regulator_bulk_free(wm8994->num_supplies, wm8994->supplies);
-	kfree(wm8994->supplies);
 	regmap_exit(wm8994->regmap);
-	kfree(wm8994);
 }
 
 static const struct of_device_id wm8994_of_match[] = {
@@ -595,7 +590,7 @@ static int wm8994_i2c_probe(struct i2c_client *i2c,
 	struct wm8994 *wm8994;
 	int ret;
 
-	wm8994 = kzalloc(sizeof(struct wm8994), GFP_KERNEL);
+	wm8994 = devm_kzalloc(&i2c->dev, sizeof(struct wm8994), GFP_KERNEL);
 	if (wm8994 == NULL)
 		return -ENOMEM;
 
@@ -609,7 +604,6 @@ static int wm8994_i2c_probe(struct i2c_client *i2c,
 		ret = PTR_ERR(wm8994->regmap);
 		dev_err(wm8994->dev, "Failed to allocate register map: %d\n",
 			ret);
-		kfree(wm8994);
 		return ret;
 	}
 
-- 
1.7.7.3

