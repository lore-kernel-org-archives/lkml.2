Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab2DGP2k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 11:28:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62639 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2DGP2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 11:28:39 -0400
Message-ID: <1333812508.6390.1.camel@phoenix>
Subject: [PATCH 1/3] regulator: max8649: Use devm_* APIs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jonghwan Choi <jhbird.choi@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Sat, 07 Apr 2012 23:28:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8649.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 2e9ffbe..f22e893 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -229,17 +229,18 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 	unsigned char data;
 	int ret;
 
-	info = kzalloc(sizeof(struct max8649_regulator_info), GFP_KERNEL);
+	info = devm_kzalloc(&client->dev, sizeof(struct max8649_regulator_info),
+			    GFP_KERNEL);
 	if (!info) {
 		dev_err(&client->dev, "No enough memory\n");
 		return -ENOMEM;
 	}
 
-	info->regmap = regmap_init_i2c(client, &max8649_regmap_config);
+	info->regmap = devm_regmap_init_i2c(client, &max8649_regmap_config);
 	if (IS_ERR(info->regmap)) {
 		ret = PTR_ERR(info->regmap);
 		dev_err(&client->dev, "Failed to allocate register map: %d\n", ret);
-		goto fail;
+		return ret;
 	}
 
 	info->dev = &client->dev;
@@ -267,7 +268,7 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 	if (ret != 0) {
 		dev_err(info->dev, "Failed to detect ID of MAX8649:%d\n",
 			ret);
-		goto out;
+		return ret;
 	}
 	dev_info(info->dev, "Detected MAX8649 (ID:%x)\n", val);
 
@@ -302,16 +303,10 @@ static int __devinit max8649_regulator_probe(struct i2c_client *client,
 	if (IS_ERR(info->regulator)) {
 		dev_err(info->dev, "failed to register regulator %s\n",
 			dcdc_desc.name);
-		ret = PTR_ERR(info->regulator);
-		goto out;
+		return PTR_ERR(info->regulator);
 	}
 
 	return 0;
-out:
-	regmap_exit(info->regmap);
-fail:
-	kfree(info);
-	return ret;
 }
 
 static int __devexit max8649_regulator_remove(struct i2c_client *client)
@@ -321,8 +316,6 @@ static int __devexit max8649_regulator_remove(struct i2c_client *client)
 	if (info) {
 		if (info->regulator)
 			regulator_unregister(info->regulator);
-		regmap_exit(info->regmap);
-		kfree(info);
 	}
 
 	return 0;
-- 
1.7.5.4



