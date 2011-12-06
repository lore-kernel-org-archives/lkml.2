Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab1LFKt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:49:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61550 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933092Ab1LFKtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:49:24 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, vinod.koul@intel.com, linaro-dev@lists.linaro.org,
        patches@linaro.org
Subject: [PATCH 1/2] DMA: PL330: Remove pm_runtime_xxx calls from pl330 probe/remove
Date: Tue,  6 Dec 2011 16:15:54 +0530
Message-Id: <1323168355-2764-2-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1323168355-2764-1-git-send-email-tushar.behera@linaro.org>
References: <1323168355-2764-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amba_probe() now calls pm_runtime_get_noresume() and pm_runtime_enable()
for the devices before the device probe is called. Hence we don't need
to call pm_runtime_get_xxx and pm_runtime_enable() in device probe again.
In the same way, since amba_remove() calls the respective pm_runtime
functions, those functions need not be called from device remove.

This patch fixes following run time error with pl330 driver.

dma-pl330 dma-pl330.0: Unbalanced pm_runtime_enable!
dma-pl330 dma-pl330.0: failed to get runtime pm

Signed-off-by: Giridhar Maruthy <giridhar.maruthy@linaro.org>
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/dma/pl330.c |   17 ++---------------
 1 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index a626e15..cd07121 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -834,17 +834,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 
 	amba_set_drvdata(adev, pdmac);
 
-#ifdef CONFIG_PM_RUNTIME
-	/* to use the runtime PM helper functions */
-	pm_runtime_enable(&adev->dev);
-
-	/* enable the power domain */
-	if (pm_runtime_get_sync(&adev->dev)) {
-		dev_err(&adev->dev, "failed to get runtime pm\n");
-		ret = -ENODEV;
-		goto probe_err1;
-	}
-#else
+#ifndef CONFIG_PM_RUNTIME
 	/* enable dma clk */
 	clk_enable(pdmac->clk);
 #endif
@@ -977,10 +967,7 @@ static int __devexit pl330_remove(struct amba_device *adev)
 	res = &adev->res;
 	release_mem_region(res->start, resource_size(res));
 
-#ifdef CONFIG_PM_RUNTIME
-	pm_runtime_put(&adev->dev);
-	pm_runtime_disable(&adev->dev);
-#else
+#ifndef CONFIG_PM_RUNTIME
 	clk_disable(pdmac->clk);
 #endif
 
-- 
1.7.4.1

