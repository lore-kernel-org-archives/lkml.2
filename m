Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab1CCRzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:55:50 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:39016 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab1CCRzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:55:10 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, leoli@freescale.com,
        dan.j.williams@intel.com, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH v3 7/9] fsldma: support async_tx dependencies and automatic unmapping
Date: Thu,  3 Mar 2011 09:54:59 -0800
Message-Id: <1299174901-16762-8-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1299174901-16762-1-git-send-email-iws@ovro.caltech.edu>
References: <1299174901-16762-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Thu, 03 Mar 2011 09:55:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous to this patch, the dma_run_dependencies() function has been
called while holding desc_lock. This function can call tx_submit() for
other descriptors, which may try to re-grab the lock. Avoid this by
moving the descriptors to be cleaned up to a temporary list, and
dropping the lock before cleanup.

At the same time, add support for automatic unmapping of src and dst
buffers, as offered by the DMAEngine API.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/fsldma.c |  131 ++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 95 insertions(+), 36 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 6e9ad6e..526579d 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -83,6 +83,11 @@ static void set_desc_cnt(struct fsldma_chan *chan,
 	hw->count = CPU_TO_DMA(chan, count, 32);
 }
 
+static u32 get_desc_cnt(struct fsldma_chan *chan, struct fsl_desc_sw *desc)
+{
+	return DMA_TO_CPU(chan, desc->hw.count, 32);
+}
+
 static void set_desc_src(struct fsldma_chan *chan,
 			 struct fsl_dma_ld_hw *hw, dma_addr_t src)
 {
@@ -93,6 +98,16 @@ static void set_desc_src(struct fsldma_chan *chan,
 	hw->src_addr = CPU_TO_DMA(chan, snoop_bits | src, 64);
 }
 
+static dma_addr_t get_desc_src(struct fsldma_chan *chan,
+			       struct fsl_desc_sw *desc)
+{
+	u64 snoop_bits;
+
+	snoop_bits = ((chan->feature & FSL_DMA_IP_MASK) == FSL_DMA_IP_85XX)
+		? ((u64)FSL_DMA_SATR_SREADTYPE_SNOOP_READ << 32) : 0;
+	return DMA_TO_CPU(chan, desc->hw.src_addr, 64) & ~snoop_bits;
+}
+
 static void set_desc_dst(struct fsldma_chan *chan,
 			 struct fsl_dma_ld_hw *hw, dma_addr_t dst)
 {
@@ -103,6 +118,16 @@ static void set_desc_dst(struct fsldma_chan *chan,
 	hw->dst_addr = CPU_TO_DMA(chan, snoop_bits | dst, 64);
 }
 
+static dma_addr_t get_desc_dst(struct fsldma_chan *chan,
+			       struct fsl_desc_sw *desc)
+{
+	u64 snoop_bits;
+
+	snoop_bits = ((chan->feature & FSL_DMA_IP_MASK) == FSL_DMA_IP_85XX)
+		? ((u64)FSL_DMA_DATR_DWRITETYPE_SNOOP_WRITE << 32) : 0;
+	return DMA_TO_CPU(chan, desc->hw.dst_addr, 64) & ~snoop_bits;
+}
+
 static void set_desc_next(struct fsldma_chan *chan,
 			  struct fsl_dma_ld_hw *hw, dma_addr_t next)
 {
@@ -806,6 +831,57 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 }
 
 /**
+ * fsldma_cleanup_descriptor - cleanup and free a single link descriptor
+ * @chan: Freescale DMA channel
+ * @desc: descriptor to cleanup and free
+ *
+ * This function is used on a descriptor which has been executed by the DMA
+ * controller. It will run any callbacks, submit any dependencies, and then
+ * free the descriptor.
+ */
+static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
+				      struct fsl_desc_sw *desc)
+{
+	struct dma_async_tx_descriptor *txd = &desc->async_tx;
+	struct device *dev = chan->common.device->dev;
+	dma_addr_t src = get_desc_src(chan, desc);
+	dma_addr_t dst = get_desc_dst(chan, desc);
+	u32 len = get_desc_cnt(chan, desc);
+
+	/* Run the link descriptor callback function */
+	if (txd->callback) {
+#ifdef FSL_DMA_LD_DEBUG
+		chan_dbg(chan, "LD %p callback\n", desc);
+#endif
+		txd->callback(txd->callback_param);
+	}
+
+	/* Run any dependencies */
+	dma_run_dependencies(txd);
+
+	/* Unmap the dst buffer, if requested */
+	if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
+		if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
+			dma_unmap_single(dev, dst, len, DMA_FROM_DEVICE);
+		else
+			dma_unmap_page(dev, dst, len, DMA_FROM_DEVICE);
+	}
+
+	/* Unmap the src buffer, if requested */
+	if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
+		if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
+			dma_unmap_single(dev, src, len, DMA_TO_DEVICE);
+		else
+			dma_unmap_page(dev, src, len, DMA_TO_DEVICE);
+	}
+
+#ifdef FSL_DMA_LD_DEBUG
+	chan_dbg(chan, "LD %p free\n", desc);
+#endif
+	dma_pool_free(chan->desc_pool, desc, txd->phys);
+}
+
+/**
  * fsl_chan_ld_cleanup - Clean up link descriptors
  * @chan : Freescale DMA channel
  *
@@ -818,56 +894,39 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 static void fsl_chan_ld_cleanup(struct fsldma_chan *chan)
 {
 	struct fsl_desc_sw *desc, *_desc;
+	LIST_HEAD(ld_cleanup);
 	unsigned long flags;
 
 	spin_lock_irqsave(&chan->desc_lock, flags);
 
-	/* if the ld_running list is empty, there is nothing to do */
-	if (list_empty(&chan->ld_running)) {
-		chan_dbg(chan, "no descriptors to cleanup\n");
-		goto out_unlock;
+	/* update the cookie if we have some descriptors to cleanup */
+	if (!list_empty(&chan->ld_running)) {
+		dma_cookie_t cookie;
+
+		desc = to_fsl_desc(chan->ld_running.prev);
+		cookie = desc->async_tx.cookie;
+
+		chan->completed_cookie = cookie;
+		chan_dbg(chan, "completed cookie=%d\n", cookie);
 	}
 
 	/*
-	 * Get the last descriptor, update the cookie to it
-	 *
-	 * This is done before callbacks run so that clients can check the
-	 * status of their DMA transfer inside the callback.
+	 * move the descriptors to a temporary list so we can drop the lock
+	 * during the entire cleanup operation
 	 */
-	desc = to_fsl_desc(chan->ld_running.prev);
-	chan->completed_cookie = desc->async_tx.cookie;
-	chan_dbg(chan, "completed_cookie = %d\n", chan->completed_cookie);
+	list_splice_tail_init(&chan->ld_running, &ld_cleanup);
+
+	spin_unlock_irqrestore(&chan->desc_lock, flags);
 
 	/* Run the callback for each descriptor, in order */
-	list_for_each_entry_safe(desc, _desc, &chan->ld_running, node) {
-		dma_async_tx_callback callback;
-		void *callback_param;
+	list_for_each_entry_safe(desc, _desc, &ld_cleanup, node) {
 
-		/* Remove from the list of running transactions */
+		/* Remove from the list of transactions */
 		list_del(&desc->node);
 
-		/* Run the link descriptor callback function */
-		callback = desc->async_tx.callback;
-		callback_param = desc->async_tx.callback_param;
-		if (callback) {
-			spin_unlock_irqrestore(&chan->desc_lock, flags);
-#ifdef FSL_DMA_LD_DEBUG
-			chan_dbg(chan, "LD %p callback\n", desc);
-#endif
-			callback(callback_param);
-			spin_lock_irqsave(&chan->desc_lock, flags);
-		}
-
-		/* Run any dependencies, then free the descriptor */
-		dma_run_dependencies(&desc->async_tx);
-#ifdef FSL_DMA_LD_DEBUG
-		chan_dbg(chan, "LD %p free\n", desc);
-#endif
-		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
+		/* Run all cleanup for this descriptor */
+		fsldma_cleanup_descriptor(chan, desc);
 	}
-
-out_unlock:
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
 }
 
 /**
-- 
1.7.3.4

