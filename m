Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab2JVBQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 21:16:25 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:46967 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab2JVBQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 21:16:22 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: lars@metafoo.de, cbou@mail.ru, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 1/2 v2] drivers: power: jz4740-battery: Use devm_kzalloc instead of kzalloc/kfree
Date: Sun, 21 Oct 2012 23:13:44 -0200
Message-Id: <1350868425-26852-2-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350868425-26852-1-git-send-email-marcos.souza.org@gmail.com>
References: <1350868425-26852-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
---

No changes from v1.

 drivers/power/jz4740-battery.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index 8dbc7bf..59900c6 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -252,7 +252,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	jz_battery = kzalloc(sizeof(*jz_battery), GFP_KERNEL);
+	jz_battery = devm_kzalloc(&pdev->dev, sizeof(*jz_battery), GFP_KERNEL);
 	if (!jz_battery) {
 		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
 		return -ENOMEM;
@@ -262,24 +262,21 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 
 	jz_battery->irq = platform_get_irq(pdev, 0);
 	if (jz_battery->irq < 0) {
-		ret = jz_battery->irq;
 		dev_err(&pdev->dev, "Failed to get platform irq: %d\n", ret);
-		goto err_free;
+		return jz_battery->irq;
 	}
 
 	jz_battery->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!jz_battery->mem) {
-		ret = -ENOENT;
 		dev_err(&pdev->dev, "Failed to get platform mmio resource\n");
-		goto err_free;
+		return -ENOENT;
 	}
 
 	jz_battery->mem = request_mem_region(jz_battery->mem->start,
 				resource_size(jz_battery->mem),	pdev->name);
 	if (!jz_battery->mem) {
-		ret = -EBUSY;
 		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
-		goto err_free;
+		return -EBUSY;
 	}
 
 	jz_battery->base = ioremap_nocache(jz_battery->mem->start,
@@ -373,8 +370,6 @@ err_iounmap:
 	iounmap(jz_battery->base);
 err_release_mem_region:
 	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
-err_free:
-	kfree(jz_battery);
 	return ret;
 }
 
@@ -396,7 +391,6 @@ static int __devexit jz_battery_remove(struct platform_device *pdev)
 
 	iounmap(jz_battery->base);
 	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
-	kfree(jz_battery);
 
 	return 0;
 }
-- 
1.7.9.5

