Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab2JQEMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 00:12:39 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45544 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab2JQEMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 00:12:38 -0400
From: Inderpal Singh <inderpal.singh@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jassisinghbrar@gmail.com, vinod.koul@intel.com, boojin.kim@samsung.com,
        kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH] DMA: PL330: Add runtime pm support
Date: Wed, 17 Oct 2012 09:42:31 +0530
Message-Id: <1350447151-16737-1-git-send-email-inderpal.singh@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the pl330's probe point the device is already in runtime resume state.
Hence to manage the device with runtime, the probe should do pm_runtime_put
and remove should do pm_runtime_get to balance with probe.

And in between, the device is being get/put at alloc_chan_resources and
free_chan_resources.

Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
---
This patch is based on slave-dma's next branch and on top
of the clean up patches at [1].

[1] https://lkml.org/lkml/2012/10/5/169

 drivers/dma/pl330.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 2ee1538..5ae19ea 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -25,6 +25,7 @@
 #include <linux/amba/pl330.h>
 #include <linux/scatterlist.h>
 #include <linux/of.h>
+#include <linux/pm_runtime.h>
 
 #include "dmaengine.h"
 #define PL330_MAX_CHAN		8
@@ -2384,6 +2385,8 @@ static int pl330_alloc_chan_resources(struct dma_chan *chan)
 	struct dma_pl330_dmac *pdmac = pch->dmac;
 	unsigned long flags;
 
+	pm_runtime_get_sync(pdmac->ddma.dev);
+
 	spin_lock_irqsave(&pch->lock, flags);
 
 	dma_cookie_init(chan);
@@ -2392,6 +2395,7 @@ static int pl330_alloc_chan_resources(struct dma_chan *chan)
 	pch->pl330_chid = pl330_request_channel(&pdmac->pif);
 	if (!pch->pl330_chid) {
 		spin_unlock_irqrestore(&pch->lock, flags);
+		pm_runtime_put(pdmac->ddma.dev);
 		return -ENOMEM;
 	}
 
@@ -2470,6 +2474,8 @@ static void pl330_free_chan_resources(struct dma_chan *chan)
 		list_splice_tail_init(&pch->work_list, &pch->dmac->desc_pool);
 
 	spin_unlock_irqrestore(&pch->lock, flags);
+
+	pm_runtime_put(pch->dmac->ddma.dev);
 }
 
 static enum dma_status
@@ -2974,6 +2980,8 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 		pi->pcfg.data_bus_width / 8, pi->pcfg.num_chan,
 		pi->pcfg.num_peri, pi->pcfg.num_events);
 
+	pm_runtime_put(pd->dev);
+
 	return 0;
 
 probe_err5:
@@ -3017,6 +3025,8 @@ static int __devexit pl330_remove(struct amba_device *adev)
 			return -EBUSY;
 	}
 
+	pm_runtime_get(pdmac->ddma.dev);
+
 	dma_async_device_unregister(&pdmac->ddma);
 
 	amba_set_drvdata(adev, NULL);
-- 
1.7.9.5

