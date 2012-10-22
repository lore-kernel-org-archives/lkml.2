Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783Ab2JVBQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 21:16:29 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64447 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab2JVBQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 21:16:27 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: lars@metafoo.de, cbou@mail.ru, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 2/2 v2] drivers: power: jz4740_battery: Use devm_request_and_ioremap
Date: Sun, 21 Oct 2012 23:13:45 -0200
Message-Id: <1350868425-26852-3-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350868425-26852-1-git-send-email-marcos.souza.org@gmail.com>
References: <1350868425-26852-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And remove all checks abvout request_mem_region and ioremap.
This is just a cleanup. Not functional changes here.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/power/jz4740-battery.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index 59900c6..1df7be8 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -272,19 +272,12 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	jz_battery->mem = request_mem_region(jz_battery->mem->start,
-				resource_size(jz_battery->mem),	pdev->name);
-	if (!jz_battery->mem) {
-		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
-		return -EBUSY;
-	}
+	jz_battery->base = devm_request_and_ioremap(&pdev->dev
+							, jz_battery->mem);
 
-	jz_battery->base = ioremap_nocache(jz_battery->mem->start,
-				resource_size(jz_battery->mem));
 	if (!jz_battery->base) {
-		ret = -EBUSY;
 		dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
-		goto err_release_mem_region;
+		return -EBUSY;
 	}
 
 	battery = &jz_battery->battery;
@@ -308,7 +301,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 			jz_battery);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq %d\n", ret);
-		goto err_iounmap;
+		goto err_irq;
 	}
 	disable_irq(jz_battery->irq);
 
@@ -365,11 +358,8 @@ err_free_gpio:
 		gpio_free(jz_battery->pdata->gpio_charge);
 err_free_irq:
 	free_irq(jz_battery->irq, jz_battery);
-err_iounmap:
+err_irq:
 	platform_set_drvdata(pdev, NULL);
-	iounmap(jz_battery->base);
-err_release_mem_region:
-	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
 	return ret;
 }
 
@@ -389,9 +379,6 @@ static int __devexit jz_battery_remove(struct platform_device *pdev)
 
 	free_irq(jz_battery->irq, jz_battery);
 
-	iounmap(jz_battery->base);
-	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
-
 	return 0;
 }
 
-- 
1.7.9.5

