Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab2KXLOr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 06:14:47 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42547 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab2KXLOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 06:14:46 -0500
From: Devendra Naga <devendra.aaru@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] mfd: jz4740-adc: use devm_kzalloc
Date: Sat, 24 Nov 2012 06:14:38 -0500
Message-Id: <1353755678-28275-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use devm_kzalloc and remove the error path free'ing and unload free'ing
as the devm resource functions free them.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/mfd/jz4740-adc.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index c6b6d7d..3efdb65 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -211,7 +211,7 @@ static int __devinit jz4740_adc_probe(struct platform_device *pdev)
 	int ret;
 	int irq_base;
 
-	adc = kmalloc(sizeof(*adc), GFP_KERNEL);
+	adc = devm_kzalloc(&pdev->dev, sizeof(*adc), GFP_KERNEL);
 	if (!adc) {
 		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
 		return -ENOMEM;
@@ -219,32 +219,28 @@ static int __devinit jz4740_adc_probe(struct platform_device *pdev)
 
 	adc->irq = platform_get_irq(pdev, 0);
 	if (adc->irq < 0) {
-		ret = adc->irq;
-		dev_err(&pdev->dev, "Failed to get platform irq: %d\n", ret);
-		goto err_free;
+		dev_err(&pdev->dev, "Failed to get platform irq: %d\n", adc->irq);
+		return adc->irq;
 	}
 
 	irq_base = platform_get_irq(pdev, 1);
 	if (irq_base < 0) {
-		ret = irq_base;
-		dev_err(&pdev->dev, "Failed to get irq base: %d\n", ret);
-		goto err_free;
+		dev_err(&pdev->dev, "Failed to get irq base: %d\n", irq_base);
+		return irq_base;
 	}
 
 	mem_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem_base) {
-		ret = -ENOENT;
 		dev_err(&pdev->dev, "Failed to get platform mmio resource\n");
-		goto err_free;
+		return -ENOENT;
 	}
 
 	/* Only request the shared registers for the MFD driver */
 	adc->mem = request_mem_region(mem_base->start, JZ_REG_ADC_STATUS,
 					pdev->name);
 	if (!adc->mem) {
-		ret = -EBUSY;
 		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
-		goto err_free;
+		return -EBUSY;
 	}
 
 	adc->base = ioremap_nocache(adc->mem->start, resource_size(adc->mem));
@@ -301,9 +297,6 @@ err_iounmap:
 	iounmap(adc->base);
 err_release_mem_region:
 	release_mem_region(adc->mem->start, resource_size(adc->mem));
-err_free:
-	kfree(adc);
-
 	return ret;
 }
 
@@ -325,8 +318,6 @@ static int __devexit jz4740_adc_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 
-	kfree(adc);
-
 	return 0;
 }
 
-- 
1.7.11.7

