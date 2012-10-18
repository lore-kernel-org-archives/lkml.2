Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798Ab2JRXln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:41:43 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56212 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2JRXlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:41:37 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: lars@metafoo.de, cbou@mail.ru, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 2/4] Use devm_* for request_mem_region and ioremap
Date: Thu, 18 Oct 2012 20:41:02 -0300
Message-Id: <1350603664-18148-3-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350603664-18148-1-git-send-email-marcos.souza.org@gmail.com>
References: <1350603664-18148-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This don't change the rationale, just a cleanup.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/power/jz4740-battery.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index 72f6335..9d9b2a8 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -274,7 +274,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	jz_battery->mem = request_mem_region(jz_battery->mem->start,
+	jz_battery->mem = devm_request_mem_region(&pdev->dev, jz_battery->mem->start,
 				resource_size(jz_battery->mem),	pdev->name);
 	if (!jz_battery->mem) {
 		ret = -EBUSY;
@@ -282,12 +282,12 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	jz_battery->base = ioremap_nocache(jz_battery->mem->start,
+	jz_battery->base = devm_ioremap_nocache(&pdev->dev, jz_battery->mem->start,
 				resource_size(jz_battery->mem));
 	if (!jz_battery->base) {
 		ret = -EBUSY;
 		dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
-		goto err_release_mem_region;
+		goto err;
 	}
 
 	battery = &jz_battery->battery;
@@ -311,7 +311,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 			jz_battery);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq %d\n", ret);
-		goto err_iounmap;
+		goto err;
 	}
 	disable_irq(jz_battery->irq);
 
@@ -368,11 +368,7 @@ err_free_gpio:
 		gpio_free(jz_battery->pdata->gpio_charge);
 err_free_irq:
 	free_irq(jz_battery->irq, jz_battery);
-err_iounmap:
 	platform_set_drvdata(pdev, NULL);
-	iounmap(jz_battery->base);
-err_release_mem_region:
-	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
 err:
 	return ret;
 }
@@ -393,9 +389,6 @@ static int __devexit jz_battery_remove(struct platform_device *pdev)
 
 	free_irq(jz_battery->irq, jz_battery);
 
-	iounmap(jz_battery->base);
-	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
-
 	return 0;
 }
 
-- 
1.7.9.5

