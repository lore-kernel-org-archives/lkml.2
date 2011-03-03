Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab1CCR4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:56:37 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:38998 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab1CCRzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:55:09 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, leoli@freescale.com,
        dan.j.williams@intel.com, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH v3 4/9] fsldma: improve link descriptor debugging
Date: Thu,  3 Mar 2011 09:54:56 -0800
Message-Id: <1299174901-16762-5-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1299174901-16762-1-git-send-email-iws@ovro.caltech.edu>
References: <1299174901-16762-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Thu, 03 Mar 2011 09:55:08 -0800 (PST)
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
index e535cd1..82b8e9f 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -420,6 +420,10 @@ static struct fsl_desc_sw *fsl_dma_alloc_descriptor(
 	desc->async_tx.tx_submit = fsl_dma_tx_submit;
 	desc->async_tx.phys = pdesc;
 
+#ifdef FSL_DMA_LD_DEBUG
+	chan_dbg(chan, "LD %p allocated\n", desc);
+#endif
+
 	return desc;
 }
 
@@ -470,6 +474,9 @@ static void fsldma_free_desc_list(struct fsldma_chan *chan,
 
 	list_for_each_entry_safe(desc, _desc, list, node) {
 		list_del(&desc->node);
+#ifdef FSL_DMA_LD_DEBUG
+		chan_dbg(chan, "LD %p free\n", desc);
+#endif
 		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
 	}
 }
@@ -481,6 +488,9 @@ static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
 
 	list_for_each_entry_safe_reverse(desc, _desc, list, node) {
 		list_del(&desc->node);
+#ifdef FSL_DMA_LD_DEBUG
+		chan_dbg(chan, "LD %p free\n", desc);
+#endif
 		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
 	}
 }
@@ -557,9 +567,6 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 			chan_err(chan, "%s\n", msg_ld_oom);
 			goto fail;
 		}
-#ifdef FSL_DMA_LD_DEBUG
-		chan_dbg(chan, "new link desc alloc %p\n", new);
-#endif
 
 		copy = min(len, (size_t)FSL_DMA_BCR_MAX_CNT);
 
@@ -645,9 +652,6 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_sg(struct dma_chan *dchan,
 			chan_err(chan, "%s\n", msg_ld_oom);
 			goto fail;
 		}
-#ifdef FSL_DMA_LD_DEBUG
-		chan_dbg(chan, "new link desc alloc %p\n", new);
-#endif
 
 		set_desc_cnt(chan, &new->hw, len);
 		set_desc_src(chan, &new->hw, src);
@@ -882,13 +886,18 @@ static void fsl_chan_ld_cleanup(struct fsldma_chan *chan)
 		callback_param = desc->async_tx.callback_param;
 		if (callback) {
 			spin_unlock_irqrestore(&chan->desc_lock, flags);
+#ifdef FSL_DMA_LD_DEBUG
 			chan_dbg(chan, "LD %p callback\n", desc);
+#endif
 			callback(callback_param);
 			spin_lock_irqsave(&chan->desc_lock, flags);
 		}
 
 		/* Run any dependencies, then free the descriptor */
 		dma_run_dependencies(&desc->async_tx);
+#ifdef FSL_DMA_LD_DEBUG
+		chan_dbg(chan, "LD %p free\n", desc);
+#endif
 		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
 	}
 
-- 
1.7.3.4

