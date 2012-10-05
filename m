Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab2JEJzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:55:24 -0400
Received: from mx1.zhaw.ch ([160.85.104.50]:65205 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217Ab2JEJzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:55:23 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Oct 2012 05:55:22 EDT
From: Tobias Klauser <tklauser@distanz.ch>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] gpio/gpio-pl061: Covert to use devm_* functions
Date: Fri,  5 Oct 2012 11:45:28 +0200
Message-Id: <1349430328-18459-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.5.4
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.10.5.93616
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 HTML_00_01 0.05, HTML_00_10 0.05, BODY_SIZE_3000_3999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, RDNS_NXDOMAIN 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, __ANY_URI 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __SUBJ_ALPHA_END 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the devm_* family of functions during probe to reduce the error
handling code footprint.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/gpio/gpio-pl061.c |   59 ++++++++++++++++----------------------------
 1 files changed, 22 insertions(+), 37 deletions(-)

diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
index b4b5da4..31d9c9e 100644
--- a/drivers/gpio/gpio-pl061.c
+++ b/drivers/gpio/gpio-pl061.c
@@ -216,39 +216,34 @@ static void __init pl061_init_gc(struct pl061_gpio *chip, int irq_base)
 			       IRQ_GC_INIT_NESTED_LOCK, IRQ_NOREQUEST, 0);
 }
 
-static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
+static int pl061_probe(struct amba_device *adev, const struct amba_id *id)
 {
-	struct pl061_platform_data *pdata;
+	struct device *dev = &adev->dev;
+	struct pl061_platform_data *pdata = dev->platform_data;
 	struct pl061_gpio *chip;
 	int ret, irq, i;
 
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	chip = devm_kzalloc(dev, sizeof(*chip), GFP_KERNEL);
 	if (chip == NULL)
 		return -ENOMEM;
 
-	pdata = dev->dev.platform_data;
 	if (pdata) {
 		chip->gc.base = pdata->gpio_base;
 		chip->irq_base = pdata->irq_base;
-	} else if (dev->dev.of_node) {
+	} else if (adev->dev.of_node) {
 		chip->gc.base = -1;
 		chip->irq_base = 0;
-	} else {
-		ret = -ENODEV;
-		goto free_mem;
-	}
+	} else
+		return -ENODEV;
 
-	if (!request_mem_region(dev->res.start,
-				resource_size(&dev->res), "pl061")) {
-		ret = -EBUSY;
-		goto free_mem;
-	}
+	if (!devm_request_mem_region(dev, adev->res.start,
+				resource_size(&adev->res), "pl061"))
+		return -EBUSY;
 
-	chip->base = ioremap(dev->res.start, resource_size(&dev->res));
-	if (chip->base == NULL) {
-		ret = -ENOMEM;
-		goto release_region;
-	}
+	chip->base = devm_ioremap(dev, adev->res.start,
+				resource_size(&adev->res));
+	if (chip->base == NULL)
+		return -ENOMEM;
 
 	spin_lock_init(&chip->lock);
 
@@ -258,13 +253,13 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
 	chip->gc.set = pl061_set_value;
 	chip->gc.to_irq = pl061_to_irq;
 	chip->gc.ngpio = PL061_GPIO_NR;
-	chip->gc.label = dev_name(&dev->dev);
-	chip->gc.dev = &dev->dev;
+	chip->gc.label = dev_name(dev);
+	chip->gc.dev = dev;
 	chip->gc.owner = THIS_MODULE;
 
 	ret = gpiochip_add(&chip->gc);
 	if (ret)
-		goto iounmap;
+		return ret;
 
 	/*
 	 * irq_chip support
@@ -276,11 +271,10 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
 	pl061_init_gc(chip, chip->irq_base);
 
 	writeb(0, chip->base + GPIOIE); /* disable irqs */
-	irq = dev->irq[0];
-	if (irq < 0) {
-		ret = -ENODEV;
-		goto iounmap;
-	}
+	irq = adev->irq[0];
+	if (irq < 0)
+		return -ENODEV;
+
 	irq_set_chained_handler(irq, pl061_irq_handler);
 	irq_set_handler_data(irq, chip);
 
@@ -294,18 +288,9 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
 		}
 	}
 
-	amba_set_drvdata(dev, chip);
+	amba_set_drvdata(adev, chip);
 
 	return 0;
-
-iounmap:
-	iounmap(chip->base);
-release_region:
-	release_mem_region(dev->res.start, resource_size(&dev->res));
-free_mem:
-	kfree(chip);
-
-	return ret;
 }
 
 #ifdef CONFIG_PM
-- 
1.7.5.4

