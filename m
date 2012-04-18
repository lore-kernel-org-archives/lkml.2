Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2DRBfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 21:35:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63570 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2DRBfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 21:35:39 -0400
Message-ID: <1334712935.3020.6.camel@phoenix>
Subject: [PATCH 2/2] regulator: virtual: Convert to use devm_* APIs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 18 Apr 2012 09:35:35 +0800
In-Reply-To: <1334712874.3020.5.camel@phoenix>
References: <1334712874.3020.5.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/virtual.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index ee0b161..f74a68f 100644
--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -291,18 +291,19 @@ static int __devinit regulator_virtual_probe(struct platform_device *pdev)
 	struct virtual_consumer_data *drvdata;
 	int ret;
 
-	drvdata = kzalloc(sizeof(struct virtual_consumer_data), GFP_KERNEL);
+	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct virtual_consumer_data),
+			       GFP_KERNEL);
 	if (drvdata == NULL)
 		return -ENOMEM;
 
 	mutex_init(&drvdata->lock);
 
-	drvdata->regulator = regulator_get(&pdev->dev, reg_id);
+	drvdata->regulator = devm_regulator_get(&pdev->dev, reg_id);
 	if (IS_ERR(drvdata->regulator)) {
 		ret = PTR_ERR(drvdata->regulator);
 		dev_err(&pdev->dev, "Failed to obtain supply '%s': %d\n",
 			reg_id, ret);
-		goto err;
+		return ret;
 	}
 
 	ret = sysfs_create_group(&pdev->dev.kobj,
@@ -310,7 +311,7 @@ static int __devinit regulator_virtual_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		dev_err(&pdev->dev,
 			"Failed to create attribute group: %d\n", ret);
-		goto err_regulator;
+		return ret;
 	}
 
 	drvdata->mode = regulator_get_mode(drvdata->regulator);
@@ -318,12 +319,6 @@ static int __devinit regulator_virtual_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, drvdata);
 
 	return 0;
-
-err_regulator:
-	regulator_put(drvdata->regulator);
-err:
-	kfree(drvdata);
-	return ret;
 }
 
 static int __devexit regulator_virtual_remove(struct platform_device *pdev)
@@ -334,9 +329,6 @@ static int __devexit regulator_virtual_remove(struct platform_device *pdev)
 
 	if (drvdata->enabled)
 		regulator_disable(drvdata->regulator);
-	regulator_put(drvdata->regulator);
-
-	kfree(drvdata);
 
 	platform_set_drvdata(pdev, NULL);
 
-- 
1.7.5.4



