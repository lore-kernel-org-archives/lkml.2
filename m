Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab2F2Nih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 09:38:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56962 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab2F2NdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 09:33:10 -0400
Message-ID: <1340976785.4752.3.camel@phoenix>
Subject: [PATCH 4/4] pwm: Convert pwm-vt8500 to use devm_* APIs
From: Axel Lin <axel.lin@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Alexey Charkov <alchark@gmail.com>
Date: Fri, 29 Jun 2012 21:33:05 +0800
In-Reply-To: <1340976628.4752.0.camel@phoenix>
References: <1340976628.4752.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/pwm/pwm-vt8500.c |   45 ++++++++-------------------------------------
 1 file changed, 8 insertions(+), 37 deletions(-)

diff --git a/drivers/pwm/pwm-vt8500.c b/drivers/pwm/pwm-vt8500.c
index 3db0746..92f7475 100644
--- a/drivers/pwm/pwm-vt8500.c
+++ b/drivers/pwm/pwm-vt8500.c
@@ -1,5 +1,5 @@
 /*
- * arch/arm/mach-vt8500/pwm.c
+ * drivers/pwm/pwm-vt8500.c
  *
  *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
  *
@@ -113,7 +113,7 @@ static int __devinit pwm_probe(struct platform_device *pdev)
 	struct resource *r;
 	int ret;
 
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	chip = devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
 	if (chip == NULL) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
 		return -ENOMEM;
@@ -127,44 +127,24 @@ static int __devinit pwm_probe(struct platform_device *pdev)
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (r == NULL) {
 		dev_err(&pdev->dev, "no memory resource defined\n");
-		ret = -ENODEV;
-		goto err_free;
-	}
-
-	r = request_mem_region(r->start, resource_size(r), pdev->name);
-	if (r == NULL) {
-		dev_err(&pdev->dev, "failed to request memory resource\n");
-		ret = -EBUSY;
-		goto err_free;
+		return -ENODEV;
 	}
 
-	chip->base = ioremap(r->start, resource_size(r));
-	if (chip->base == NULL) {
-		dev_err(&pdev->dev, "failed to ioremap() registers\n");
-		ret = -ENODEV;
-		goto err_free_mem;
-	}
+	chip->base = devm_request_and_ioremap(&pdev->dev, r);
+	if (chip->base == NULL)
+		return -ENODEV;
 
 	ret = pwmchip_add(&chip->chip);
 	if (ret < 0)
-		goto err_unmap;
+		return ret;
 
 	platform_set_drvdata(pdev, chip);
 	return ret;
-
-err_unmap:
-	iounmap(chip->base);
-err_free_mem:
-	release_mem_region(r->start, resource_size(r));
-err_free:
-	kfree(chip);
-	return ret;
 }
 
 static int __devexit pwm_remove(struct platform_device *pdev)
 {
 	struct vt8500_chip *chip;
-	struct resource *r;
 	int err;
 
 	chip = platform_get_drvdata(pdev);
@@ -172,16 +152,7 @@ static int __devexit pwm_remove(struct platform_device *pdev)
 		return -ENODEV;
 
 	err = pwmchip_remove(&chip->chip);
-	if (err < 0)
-		return err;
-
-	iounmap(chip->base);
-
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(r->start, resource_size(r));
-
-	kfree(chip);
-	return 0;
+	return err;
 }
 
 static struct platform_driver pwm_driver = {
-- 
1.7.9.5



