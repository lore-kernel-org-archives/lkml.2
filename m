Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab1BZAY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 19:24:57 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:57729 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933037Ab1BZAXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 19:23:34 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, leoli@freescale.com,
        dan.j.williams@intel.com, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 3/8] fsldma: improve link descriptor debugging
Date: Fri, 25 Feb 2011 16:23:20 -0800
Message-Id: <1298679805-14108-4-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298679805-14108-1-git-send-email-iws@ovro.caltech.edu>
References: <1298679805-14108-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Fri, 25 Feb 2011 16:23:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds better tracking to link descriptor allocations, callbacks, and
frees. This makes it much easier to track errors with link descriptors.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/fsldma.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 6e3d3d7..851993c 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -416,6 +416,10 @@ static struct fsl_desc_sw *fsl_dma_alloc_descriptor(
 	desc->async_tx.tx_submit = fsl_dma_tx_submit;
 	desc->async_tx.phys = pdesc;
 
+#ifdef FSL_DMA_LD_DEBUG
+	dev_dbg(chan->dev, "%s: LD %p allocated\n", chan->name, desc);
+#endif
+
 	return desc;
 }
 
@@ -467,6 +471,9 @@ static void fsldma_free_desc_list(struct fsldma_chan *chan,
 
 	list_for_each_entry_safe(desc, _desc, list, node) {
 		list_del(&desc->node);
+#ifdef FSL_DMA_LD_DEBUG
+		dev_dbg(chan->dev, "%s: LD %p free\n", chan->name, desc);
+#endif
 		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
 	}
 }
@@ -478,6 +485,9 @@ static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
 
 	list_for_each_entry_safe_reverse(desc, _desc, list, node) {
 		list_del(&desc->node);
+#ifdef FSL_DMA_LD_DEBUG
+		dev_dbg(chan->dev, "%s: LD %p free\n", chan->name, desc);
+#endif
 		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
 	}
 }
@@ -554,9 +564,6 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 			dev_err(chan->dev, "%s: %s\n", chan->name, msg_ld_oom);
 			goto fail;
 		}
-#ifdef FSL_DMA_LD_DEBUG
-		dev_dbg(chan->dev, "%s: new link desc alloc %p\n", chan->name, new);
-#endif
 
 		copy = min(len, (size_t)FSL_DMA_BCR_MAX_CNT);
 
@@ -642,9 +649,6 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_sg(struct dma_chan *dchan,
 			dev_err(chan->dev, "%s: %s\n", chan->name, msg_ld_oom);
 			goto fail;
 		}
-#ifdef FSL_DMA_LD_DEBUG
-		dev_dbg(chan->dev, "%s: new link desc alloc %p\n", chan->name, new);
-#endif
 
 		set_desc_cnt(chan, &new->hw, len);
 		set_desc_src(chan, &new->hw, src);
@@ -881,13 +885,18 @@ static void fsl_chan_ld_cleanup(struct fsldma_chan *chan)
 		callback_param = desc->async_tx.callback_param;
 		if (callback) {
 			spin_unlock_irqrestore(&chan->desc_lock, flags);
+#ifdef FSL_DMA_LD_DEBUG
 			dev_dbg(chan->dev, "%s: LD %p callback\n", name, desc);
+#endif
 			callback(callback_param);
 			spin_lock_irqsave(&chan->desc_lock, flags);
 		}
 
 		/* Run any dependencies, then free the descriptor */
 		dma_run_dependencies(&desc->async_tx);
+#ifdef FSL_DMA_LD_DEBUG
+		dev_dbg(chan->dev, "%s: LD %p free\n", name, desc);
+#endif
 		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
 	}
 
-- 
1.7.3.4

