Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab2IGGpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:45:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59462 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213Ab2IGGo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:44:57 -0400
From: Inderpal Singh <inderpal.singh@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, vinod.koul@intel.com, patches@linaro.org,
        boojin.kim@samsung.com, jassisinghbrar@gmail.com,
        Inderpal Singh <inderpal.singh@linaro.org>
Subject: [PATCH 2/2] DMA: PL330: Remove redundant runtime_suspend/resume functions
Date: Fri,  7 Sep 2012 12:14:48 +0530
Message-Id: <1347000288-20441-3-git-send-email-inderpal.singh@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347000288-20441-1-git-send-email-inderpal.singh@linaro.org>
References: <1347000288-20441-1-git-send-email-inderpal.singh@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver's  runtime_suspend/resume functions just disable/enable
the clock which is already being managed at AMBA bus level
runtime_suspend/resume functions.

Hence, remove the driver's runtime_suspend/resume functions.

Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
---
 drivers/dma/pl330.c |   61 +++++----------------------------------------------
 1 file changed, 5 insertions(+), 56 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index f70e783..d9e1433 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -23,7 +23,6 @@
 #include <linux/dmaengine.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/pl330.h>
-#include <linux/pm_runtime.h>
 #include <linux/scatterlist.h>
 #include <linux/of.h>
 
@@ -586,8 +585,6 @@ struct dma_pl330_dmac {
 
 	/* Peripheral channels connected to this DMAC */
 	struct dma_pl330_chan *peripherals; /* keep at end */
-
-	struct clk *clk;
 };
 
 struct dma_pl330_desc {
@@ -2887,24 +2884,17 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 		goto probe_err1;
 	}
 
-	pdmac->clk = clk_get(&adev->dev, "dma");
-	if (IS_ERR(pdmac->clk)) {
-		dev_err(&adev->dev, "Cannot get operation clock.\n");
-		ret = -EINVAL;
-		goto probe_err2;
-	}
-
 	amba_set_drvdata(adev, pdmac);
 
 	irq = adev->irq[0];
 	ret = request_irq(irq, pl330_irq_handler, 0,
 			dev_name(&adev->dev), pi);
 	if (ret)
-		goto probe_err3;
+		goto probe_err2;
 
 	ret = pl330_add(pi);
 	if (ret)
-		goto probe_err4;
+		goto probe_err3;
 
 	INIT_LIST_HEAD(&pdmac->desc_pool);
 	spin_lock_init(&pdmac->pool_lock);
@@ -2964,7 +2954,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	ret = dma_async_device_register(pd);
 	if (ret) {
 		dev_err(&adev->dev, "unable to register DMAC\n");
-		goto probe_err5;
+		goto probe_err4;
 	}
 
 	dev_info(&adev->dev,
@@ -2977,12 +2967,10 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 
 	return 0;
 
-probe_err5:
-	pl330_del(pi);
 probe_err4:
-	free_irq(irq, pi);
+	pl330_del(pi);
 probe_err3:
-	clk_put(pdmac->clk);
+	free_irq(irq, pi);
 probe_err2:
 	iounmap(pi->base);
 probe_err1:
@@ -3044,49 +3032,10 @@ static struct amba_id pl330_ids[] = {
 
 MODULE_DEVICE_TABLE(amba, pl330_ids);
 
-#ifdef CONFIG_PM_RUNTIME
-static int pl330_runtime_suspend(struct device *dev)
-{
-	struct dma_pl330_dmac *pdmac = dev_get_drvdata(dev);
-
-	if (!pdmac) {
-		dev_err(dev, "failed to get dmac\n");
-		return -ENODEV;
-	}
-
-	clk_disable(pdmac->clk);
-
-	return 0;
-}
-
-static int pl330_runtime_resume(struct device *dev)
-{
-	struct dma_pl330_dmac *pdmac = dev_get_drvdata(dev);
-
-	if (!pdmac) {
-		dev_err(dev, "failed to get dmac\n");
-		return -ENODEV;
-	}
-
-	clk_enable(pdmac->clk);
-
-	return 0;
-}
-#else
-#define pl330_runtime_suspend	NULL
-#define pl330_runtime_resume	NULL
-#endif /* CONFIG_PM_RUNTIME */
-
-static const struct dev_pm_ops pl330_pm_ops = {
-	.runtime_suspend = pl330_runtime_suspend,
-	.runtime_resume = pl330_runtime_resume,
-};
-
 static struct amba_driver pl330_driver = {
 	.drv = {
 		.owner = THIS_MODULE,
 		.name = "dma-pl330",
-		.pm = &pl330_pm_ops,
 	},
 	.id_table = pl330_ids,
 	.probe = pl330_probe,
-- 
1.7.9.5

