Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab2FLSTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:19:42 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:47448 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559Ab2FLSTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:19:41 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] dma: coh901318: use devm allocation
Date: Tue, 12 Jun 2012 20:19:24 +0200
Message-ID: <1339525164-7325-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Allocate memory, region, remap and irq for device state using
devm_* helpers to simplify memory accounting.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/coh901318.c |   72 ++++++++++++++++-------------------------------
 1 file changed, 24 insertions(+), 48 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index e67b4e0..aa384e5 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1438,34 +1438,32 @@ static int __init coh901318_probe(struct platform_device *pdev)
 
 	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!io)
-		goto err_get_resource;
+		return -ENODEV;
 
 	/* Map DMA controller registers to virtual memory */
-	if (request_mem_region(io->start,
-			       resource_size(io),
-			       pdev->dev.driver->name) == NULL) {
-		err = -EBUSY;
-		goto err_request_mem;
-	}
+	if (devm_request_mem_region(&pdev->dev,
+				    io->start,
+				    resource_size(io),
+				    pdev->dev.driver->name) == NULL)
+		return -ENOMEM;
 
 	pdata = pdev->dev.platform_data;
 	if (!pdata)
-		goto err_no_platformdata;
+		return -ENODEV;
 
-	base = kmalloc(ALIGN(sizeof(struct coh901318_base), 4) +
-		       pdata->max_channels *
-		       sizeof(struct coh901318_chan),
-		       GFP_KERNEL);
+	base = devm_kzalloc(&pdev->dev,
+			    ALIGN(sizeof(struct coh901318_base), 4) +
+			    pdata->max_channels *
+			    sizeof(struct coh901318_chan),
+			    GFP_KERNEL);
 	if (!base)
-		goto err_alloc_coh_dma_channels;
+		return -ENOMEM;
 
 	base->chans = ((void *)base) + ALIGN(sizeof(struct coh901318_base), 4);
 
-	base->virtbase = ioremap(io->start, resource_size(io));
-	if (!base->virtbase) {
-		err = -ENOMEM;
-		goto err_no_ioremap;
-	}
+	base->virtbase = devm_ioremap(&pdev->dev, io->start, resource_size(io));
+	if (!base->virtbase)
+		return -ENOMEM;
 
 	base->dev = &pdev->dev;
 	base->platform = pdata;
@@ -1474,25 +1472,20 @@ static int __init coh901318_probe(struct platform_device *pdev)
 
 	COH901318_DEBUGFS_ASSIGN(debugfs_dma_base, base);
 
-	platform_set_drvdata(pdev, base);
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-		goto err_no_irq;
-
-	err = request_irq(irq, dma_irq_handler, IRQF_DISABLED,
-			  "coh901318", base);
-	if (err) {
-		dev_crit(&pdev->dev,
-			 "Cannot allocate IRQ for DMA controller!\n");
-		goto err_request_irq;
-	}
+		return irq;
+
+	err = devm_request_irq(&pdev->dev, irq, dma_irq_handler, IRQF_DISABLED,
+			       "coh901318", base);
+	if (err)
+		return err;
 
 	err = coh901318_pool_create(&base->pool, &pdev->dev,
 				    sizeof(struct coh901318_lli),
 				    32);
 	if (err)
-		goto err_pool_create;
+		return err;
 
 	/* init channels for device transfers */
 	coh901318_base_init(&base->dma_slave,  base->platform->chans_slave,
@@ -1538,6 +1531,7 @@ static int __init coh901318_probe(struct platform_device *pdev)
 	if (err)
 		goto err_register_memcpy;
 
+	platform_set_drvdata(pdev, base);
 	dev_info(&pdev->dev, "Initialized COH901318 DMA on virtual base 0x%08x\n",
 		(u32) base->virtbase);
 
@@ -1547,19 +1541,6 @@ static int __init coh901318_probe(struct platform_device *pdev)
 	dma_async_device_unregister(&base->dma_slave);
  err_register_slave:
 	coh901318_pool_destroy(&base->pool);
- err_pool_create:
-	free_irq(platform_get_irq(pdev, 0), base);
- err_request_irq:
- err_no_irq:
-	iounmap(base->virtbase);
- err_no_ioremap:
-	kfree(base);
- err_alloc_coh_dma_channels:
- err_no_platformdata:
-	release_mem_region(pdev->resource->start,
-			   resource_size(pdev->resource));
- err_request_mem:
- err_get_resource:
 	return err;
 }
 
@@ -1570,11 +1551,6 @@ static int __exit coh901318_remove(struct platform_device *pdev)
 	dma_async_device_unregister(&base->dma_memcpy);
 	dma_async_device_unregister(&base->dma_slave);
 	coh901318_pool_destroy(&base->pool);
-	free_irq(platform_get_irq(pdev, 0), base);
-	iounmap(base->virtbase);
-	kfree(base);
-	release_mem_region(pdev->resource->start,
-			   resource_size(pdev->resource));
 	return 0;
 }
 
-- 
1.7.9.2

