Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab2KFXMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 18:12:06 -0500
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37122 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab2KFXMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 18:12:00 -0500
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: cbou@mail.ru, dwmw2@infradead.org, lars@metafoo.de,
        linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 2/2] drivres/power/jz4740-battery.c: Use devm_request_and_ioremap
Date: Tue,  6 Nov 2012 21:11:12 -0200
Message-Id: <1352243472-14951-3-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352243472-14951-1-git-send-email-marcos.souza.org@gmail.com>
References: <1352243472-14951-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes. Just a cleanup.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/power/jz4740-battery.c |   33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index 59900c6..e4ec7eb 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -33,7 +33,6 @@ struct jz_battery {
 	struct jz_battery_platform_data *pdata;
 	struct platform_device *pdev;
 
-	struct resource *mem;
 	void __iomem *base;
 
 	int irq;
@@ -246,6 +245,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 	struct jz_battery_platform_data *pdata = pdev->dev.parent->platform_data;
 	struct jz_battery *jz_battery;
 	struct power_supply *battery;
+	struct resource *mem;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No platform_data supplied\n");
@@ -266,25 +266,12 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 		return jz_battery->irq;
 	}
 
-	jz_battery->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!jz_battery->mem) {
-		dev_err(&pdev->dev, "Failed to get platform mmio resource\n");
-		return -ENOENT;
-	}
-
-	jz_battery->mem = request_mem_region(jz_battery->mem->start,
-				resource_size(jz_battery->mem),	pdev->name);
-	if (!jz_battery->mem) {
-		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
-		return -EBUSY;
-	}
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	jz_battery->base = ioremap_nocache(jz_battery->mem->start,
-				resource_size(jz_battery->mem));
+	jz_battery->base = devm_request_and_ioremap(&pdev->dev, mem);
 	if (!jz_battery->base) {
-		ret = -EBUSY;
-		dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
-		goto err_release_mem_region;
+		dev_err(&pdev->dev, "Failed to request/ioremap mmio memory\n");
+		return -EBUSY;
 	}
 
 	battery = &jz_battery->battery;
@@ -308,7 +295,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 			jz_battery);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq %d\n", ret);
-		goto err_iounmap;
+		goto err;
 	}
 	disable_irq(jz_battery->irq);
 
@@ -365,11 +352,8 @@ err_free_gpio:
 		gpio_free(jz_battery->pdata->gpio_charge);
 err_free_irq:
 	free_irq(jz_battery->irq, jz_battery);
-err_iounmap:
+err:
 	platform_set_drvdata(pdev, NULL);
-	iounmap(jz_battery->base);
-err_release_mem_region:
-	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
 	return ret;
 }
 
@@ -389,9 +373,6 @@ static int __devexit jz_battery_remove(struct platform_device *pdev)
 
 	free_irq(jz_battery->irq, jz_battery);
 
-	iounmap(jz_battery->base);
-	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
-
 	return 0;
 }
 
-- 
1.7.9.5

