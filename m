Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab2JRXmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:42:10 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56212 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab2JRXlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:41:39 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: lars@metafoo.de, cbou@mail.ru, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 4/4] power/jz4740.c: Simplify exit of function
Date: Thu, 18 Oct 2012 20:41:04 -0300
Message-Id: <1350603664-18148-5-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350603664-18148-1-git-send-email-marcos.souza.org@gmail.com>
References: <1350603664-18148-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit simplifies the exit of probe function, by returning
directly when it don't need to release any resources.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/power/jz4740-battery.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index b80f7ed..0d6c9e4 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -262,32 +262,28 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 
 	jz_battery->irq = platform_get_irq(pdev, 0);
 	if (jz_battery->irq < 0) {
-		ret = jz_battery->irq;
 		dev_err(&pdev->dev, "Failed to get platform irq: %d\n", ret);
-		goto err;
+		return jz_battery->irq;
 	}
 
 	jz_battery->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!jz_battery->mem) {
-		ret = -ENOENT;
 		dev_err(&pdev->dev, "Failed to get platform mmio resource\n");
-		goto err;
+		return -ENOENT;
 	}
 
 	jz_battery->mem = devm_request_mem_region(&pdev->dev, jz_battery->mem->start,
 				resource_size(jz_battery->mem),	pdev->name);
 	if (!jz_battery->mem) {
-		ret = -EBUSY;
 		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
-		goto err;
+		return -EBUSY;
 	}
 
 	jz_battery->base = devm_ioremap_nocache(&pdev->dev, jz_battery->mem->start,
 				resource_size(jz_battery->mem));
 	if (!jz_battery->base) {
-		ret = -EBUSY;
 		dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
-		goto err;
+		return -EBUSY;
 	}
 
 	battery = &jz_battery->battery;
@@ -311,7 +307,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 				0, pdev->name, jz_battery);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq %d\n", ret);
-		goto err;
+		return ret;
 	}
 	disable_irq(jz_battery->irq);
 
@@ -319,7 +315,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 		ret = gpio_request(pdata->gpio_charge, dev_name(&pdev->dev));
 		if (ret) {
 			dev_err(&pdev->dev, "charger state gpio request failed.\n");
-			goto err;
+			return ret;
 		}
 		ret = gpio_direction_input(pdata->gpio_charge);
 		if (ret) {
@@ -364,7 +360,6 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 err_free_gpio:
 	if (gpio_is_valid(pdata->gpio_charge))
 		gpio_free(jz_battery->pdata->gpio_charge);
-err:
 	platform_set_drvdata(pdev, NULL);
 	return ret;
 }
-- 
1.7.9.5

