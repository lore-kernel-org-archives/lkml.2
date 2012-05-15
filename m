Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966071Ab2EORZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:25:13 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42819 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965223Ab2EORZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:25:09 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] mfd: lm3533: convert to use devres
Date: Tue, 15 May 2012 19:24:53 +0200
Message-Id: <1337102693-30911-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devres to manage core driver data and regmap.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/mfd/lm3533-core.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/mfd/lm3533-core.c b/drivers/mfd/lm3533-core.c
index 5770bea..104faba 100644
--- a/drivers/mfd/lm3533-core.c
+++ b/drivers/mfd/lm3533-core.c
@@ -603,33 +603,24 @@ static int __devinit lm3533_i2c_probe(struct i2c_client *i2c,
 
 	dev_dbg(&i2c->dev, "%s\n", __func__);
 
-	lm3533 = kzalloc(sizeof(*lm3533), GFP_KERNEL);
+	lm3533 = devm_kzalloc(&i2c->dev, sizeof(*lm3533), GFP_KERNEL);
 	if (!lm3533)
 		return -ENOMEM;
 
 	i2c_set_clientdata(i2c, lm3533);
 
-	lm3533->regmap = regmap_init_i2c(i2c, &regmap_config);
-	if (IS_ERR(lm3533->regmap)) {
-		ret = PTR_ERR(lm3533->regmap);
-		goto err_regmap;
-	}
+	lm3533->regmap = devm_regmap_init_i2c(i2c, &regmap_config);
+	if (IS_ERR(lm3533->regmap))
+		return PTR_ERR(lm3533->regmap);
 
 	lm3533->dev = &i2c->dev;
 	lm3533->irq = i2c->irq;
 
 	ret = lm3533_device_init(lm3533);
 	if (ret)
-		goto err_dev;
+		return ret;
 
 	return 0;
-
-err_dev:
-	regmap_exit(lm3533->regmap);
-err_regmap:
-	kfree(lm3533);
-
-	return ret;
 }
 
 static int __devexit lm3533_i2c_remove(struct i2c_client *i2c)
@@ -639,9 +630,6 @@ static int __devexit lm3533_i2c_remove(struct i2c_client *i2c)
 	dev_dbg(&i2c->dev, "%s\n", __func__);
 
 	lm3533_device_exit(lm3533);
-	regmap_exit(lm3533->regmap);
-
-	kfree(lm3533);
 
 	return 0;
 }
-- 
1.7.8.5

