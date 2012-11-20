Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab2KTF3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:29:44 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65000 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2KTF3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:29:13 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 6/7] extcon: max8997: Use devm_kzalloc
Date: Tue, 20 Nov 2012 10:52:42 +0530
Message-Id: <1353388963-23761-7-git-send-email-sachin.kamat@linaro.org>
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
 drivers/extcon/extcon-max8997.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index ffdbe8c..8059325 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -433,11 +433,11 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
 	struct max8997_muic_info *info;
 	int ret, i;
 
-	info = kzalloc(sizeof(struct max8997_muic_info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(struct max8997_muic_info),
+			    GFP_KERNEL);
 	if (!info) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
-		ret = -ENOMEM;
-		goto err_kfree;
+		return -ENOMEM;
 	}
 
 	info->dev = &pdev->dev;
@@ -471,7 +471,8 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
 	}
 
 	/* External connector */
-	info->edev = kzalloc(sizeof(struct extcon_dev), GFP_KERNEL);
+	info->edev = devm_kzalloc(&pdev->dev, sizeof(struct extcon_dev),
+				  GFP_KERNEL);
 	if (!info->edev) {
 		dev_err(&pdev->dev, "failed to allocate memory for extcon\n");
 		ret = -ENOMEM;
@@ -482,7 +483,7 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
 	ret = extcon_dev_register(info->edev, NULL);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
-		goto err_extcon;
+		goto err_irq;
 	}
 
 	/* Initialize registers according to platform data */
@@ -500,13 +501,9 @@ static int __devinit max8997_muic_probe(struct platform_device *pdev)
 
 	return ret;
 
-err_extcon:
-	kfree(info->edev);
 err_irq:
 	while (--i >= 0)
 		free_irq(muic_irqs[i].virq, info);
-	kfree(info);
-err_kfree:
 	return ret;
 }
 
@@ -521,9 +518,6 @@ static int __devexit max8997_muic_remove(struct platform_device *pdev)
 
 	extcon_dev_unregister(info->edev);
 
-	kfree(info->edev);
-	kfree(info);
-
 	return 0;
 }
 
-- 
1.7.4.1

