Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab2KTF3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:29:19 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65000 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2KTF3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:29:16 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 7/7] extcon: max77693: Use devm_kzalloc
Date: Tue, 20 Nov 2012 10:52:43 +0530
Message-Id: <1353388963-23761-8-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353388963-23761-1-git-send-email-sachin.kamat@linaro.org>
References: <1353388963-23761-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_kzalloc() is a device managed function. It makes error handling
and cleanup code a bit simpler.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/extcon/extcon-max77693.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 2a0f397..3c29bb7 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -657,11 +657,11 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
 	int ret, i;
 	u8 id;
 
-	info = kzalloc(sizeof(struct max77693_muic_info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(struct max77693_muic_info),
+				   GFP_KERNEL);
 	if (!info) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
-		ret = -ENOMEM;
-		goto err_kfree;
+		return -ENOMEM;
 	}
 	info->dev = &pdev->dev;
 	info->max77693 = max77693;
@@ -672,10 +672,9 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
 						info->max77693->muic,
 						&max77693_muic_regmap_config);
 		if (IS_ERR(info->max77693->regmap_muic)) {
-			ret = PTR_ERR(info->max77693->regmap_muic);
 			dev_err(max77693->dev,
 				"failed to allocate register map: %d\n", ret);
-			goto err_regmap;
+			return PTR_ERR(info->max77693->regmap_muic);
 		}
 	}
 	platform_set_drvdata(pdev, info);
@@ -709,7 +708,8 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize extcon device */
-	info->edev = kzalloc(sizeof(struct extcon_dev), GFP_KERNEL);
+	info->edev = devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
+				  GFP_KERNEL);
 	if (!info->edev) {
 		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		ret = -ENOMEM;
@@ -720,7 +720,7 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
 	ret = extcon_dev_register(info->edev, NULL);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
-		goto err_extcon;
+		goto err_irq;
 	}
 
 	/* Initialize MUIC register by using platform data */
@@ -753,7 +753,7 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
 			MAX77693_MUIC_REG_ID, &id);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to read revision number\n");
-		goto err_extcon;
+		goto err_irq;
 	}
 	dev_info(info->dev, "device ID : 0x%x\n", id);
 
@@ -765,14 +765,9 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
 
 	return ret;
 
-err_extcon:
-	kfree(info->edev);
 err_irq:
 	while (--i >= 0)
 		free_irq(muic_irqs[i].virq, info);
-err_regmap:
-	kfree(info);
-err_kfree:
 	return ret;
 }
 
@@ -785,8 +780,6 @@ static int __devexit max77693_muic_remove(struct platform_device *pdev)
 		free_irq(muic_irqs[i].virq, info);
 	cancel_work_sync(&info->irq_work);
 	extcon_dev_unregister(info->edev);
-	kfree(info->edev);
-	kfree(info);
 
 	return 0;
 }
-- 
1.7.4.1

