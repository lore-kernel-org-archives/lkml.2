Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2KOGds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 01:33:48 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43605 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2KOGdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 01:33:47 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, sachin.kamat@linaro.org, patches@linaro.org,
        Jassi Brar <jassisinghbrar@gmail.com>
Subject: [PATCH 1/1] DMA: PL330: Use devm_* functions
Date: Thu, 15 Nov 2012 11:57:50 +0530
Message-Id: <1352960870-6023-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_* functions are device managed and make the code and error
handling a bit simpler.

Cc: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/dma/pl330.c |   37 ++++++++++---------------------------
 1 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 665668b..68aa24c 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2866,7 +2866,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	pdat = adev->dev.platform_data;
 
 	/* Allocate a new DMAC and its Channels */
-	pdmac = kzalloc(sizeof(*pdmac), GFP_KERNEL);
+	pdmac = devm_kzalloc(&adev->dev, sizeof(*pdmac), GFP_KERNEL);
 	if (!pdmac) {
 		dev_err(&adev->dev, "unable to allocate mem\n");
 		return -ENOMEM;
@@ -2878,13 +2878,9 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	pi->mcbufsz = pdat ? pdat->mcbuf_sz : 0;
 
 	res = &adev->res;
-	request_mem_region(res->start, resource_size(res), "dma-pl330");
-
-	pi->base = ioremap(res->start, resource_size(res));
-	if (!pi->base) {
-		ret = -ENXIO;
-		goto probe_err1;
-	}
+	pi->base = devm_request_and_ioremap(&adev->dev, res);
+	if (!pi->base)
+		return -ENXIO;
 
 	amba_set_drvdata(adev, pdmac);
 
@@ -2892,11 +2888,11 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	ret = request_irq(irq, pl330_irq_handler, 0,
 			dev_name(&adev->dev), pi);
 	if (ret)
-		goto probe_err2;
+		return ret;
 
 	ret = pl330_add(pi);
 	if (ret)
-		goto probe_err3;
+		goto probe_err1;
 
 	INIT_LIST_HEAD(&pdmac->desc_pool);
 	spin_lock_init(&pdmac->pool_lock);
@@ -2918,7 +2914,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	if (!pdmac->peripherals) {
 		ret = -ENOMEM;
 		dev_err(&adev->dev, "unable to allocate pdmac->peripherals\n");
-		goto probe_err4;
+		goto probe_err2;
 	}
 
 	for (i = 0; i < num_chan; i++) {
@@ -2962,7 +2958,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	ret = dma_async_device_register(pd);
 	if (ret) {
 		dev_err(&adev->dev, "unable to register DMAC\n");
-		goto probe_err4;
+		goto probe_err2;
 	}
 
 	dev_info(&adev->dev,
@@ -2975,15 +2971,10 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 
 	return 0;
 
-probe_err4:
-	pl330_del(pi);
-probe_err3:
-	free_irq(irq, pi);
 probe_err2:
-	iounmap(pi->base);
+	pl330_del(pi);
 probe_err1:
-	release_mem_region(res->start, resource_size(res));
-	kfree(pdmac);
+	free_irq(irq, pi);
 
 	return ret;
 }
@@ -2993,7 +2984,6 @@ static int __devexit pl330_remove(struct amba_device *adev)
 	struct dma_pl330_dmac *pdmac = amba_get_drvdata(adev);
 	struct dma_pl330_chan *pch, *_p;
 	struct pl330_info *pi;
-	struct resource *res;
 	int irq;
 
 	if (!pdmac)
@@ -3020,13 +3010,6 @@ static int __devexit pl330_remove(struct amba_device *adev)
 	irq = adev->irq[0];
 	free_irq(irq, pi);
 
-	iounmap(pi->base);
-
-	res = &adev->res;
-	release_mem_region(res->start, resource_size(res));
-
-	kfree(pdmac);
-
 	return 0;
 }
 
-- 
1.7.4.1

