Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab1CCR4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:56:38 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:38995 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344Ab1CCRzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:55:09 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, leoli@freescale.com,
        dan.j.williams@intel.com, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH v3 3/9] fsldma: use channel name in printk output
Date: Thu,  3 Mar 2011 09:54:55 -0800
Message-Id: <1299174901-16762-4-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1299174901-16762-1-git-send-email-iws@ovro.caltech.edu>
References: <1299174901-16762-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Thu, 03 Mar 2011 09:55:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes debugging the driver much easier when multiple channels are
running concurrently. In addition, you can see how much descriptor
memory each channel has allocated via the dmapool API in sysfs.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/fsldma.c |   69 +++++++++++++++++++++++++------------------------
 drivers/dma/fsldma.h |    1 +
 2 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 2e1af45..e535cd1 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -37,7 +37,12 @@
 
 #include "fsldma.h"
 
-static const char msg_ld_oom[] = "No free memory for link descriptor\n";
+#define chan_dbg(chan, fmt, arg...)					\
+	dev_dbg(chan->dev, "%s: " fmt, chan->name, ##arg)
+#define chan_err(chan, fmt, arg...)					\
+	dev_err(chan->dev, "%s: " fmt, chan->name, ##arg)
+
+static const char msg_ld_oom[] = "No free memory for link descriptor";
 
 /*
  * Register Helpers
@@ -207,7 +212,7 @@ static void dma_halt(struct fsldma_chan *chan)
 	}
 
 	if (!dma_is_idle(chan))
-		dev_err(chan->dev, "DMA halt timeout!\n");
+		chan_err(chan, "DMA halt timeout!\n");
 }
 
 /**
@@ -405,7 +410,7 @@ static struct fsl_desc_sw *fsl_dma_alloc_descriptor(
 
 	desc = dma_pool_alloc(chan->desc_pool, GFP_ATOMIC, &pdesc);
 	if (!desc) {
-		dev_dbg(chan->dev, "out of memory for link desc\n");
+		chan_dbg(chan, "out of memory for link descriptor\n");
 		return NULL;
 	}
 
@@ -439,13 +444,11 @@ static int fsl_dma_alloc_chan_resources(struct dma_chan *dchan)
 	 * We need the descriptor to be aligned to 32bytes
 	 * for meeting FSL DMA specification requirement.
 	 */
-	chan->desc_pool = dma_pool_create("fsl_dma_engine_desc_pool",
-					  chan->dev,
+	chan->desc_pool = dma_pool_create(chan->name, chan->dev,
 					  sizeof(struct fsl_desc_sw),
 					  __alignof__(struct fsl_desc_sw), 0);
 	if (!chan->desc_pool) {
-		dev_err(chan->dev, "unable to allocate channel %d "
-				   "descriptor pool\n", chan->id);
+		chan_err(chan, "unable to allocate descriptor pool\n");
 		return -ENOMEM;
 	}
 
@@ -491,7 +494,7 @@ static void fsl_dma_free_chan_resources(struct dma_chan *dchan)
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
 	unsigned long flags;
 
-	dev_dbg(chan->dev, "Free all channel resources.\n");
+	chan_dbg(chan, "free all channel resources\n");
 	spin_lock_irqsave(&chan->desc_lock, flags);
 	fsldma_free_desc_list(chan, &chan->ld_pending);
 	fsldma_free_desc_list(chan, &chan->ld_running);
@@ -514,7 +517,7 @@ fsl_dma_prep_interrupt(struct dma_chan *dchan, unsigned long flags)
 
 	new = fsl_dma_alloc_descriptor(chan);
 	if (!new) {
-		dev_err(chan->dev, msg_ld_oom);
+		chan_err(chan, "%s\n", msg_ld_oom);
 		return NULL;
 	}
 
@@ -551,11 +554,11 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 		/* Allocate the link descriptor from DMA pool */
 		new = fsl_dma_alloc_descriptor(chan);
 		if (!new) {
-			dev_err(chan->dev, msg_ld_oom);
+			chan_err(chan, "%s\n", msg_ld_oom);
 			goto fail;
 		}
 #ifdef FSL_DMA_LD_DEBUG
-		dev_dbg(chan->dev, "new link desc alloc %p\n", new);
+		chan_dbg(chan, "new link desc alloc %p\n", new);
 #endif
 
 		copy = min(len, (size_t)FSL_DMA_BCR_MAX_CNT);
@@ -639,11 +642,11 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_sg(struct dma_chan *dchan,
 		/* allocate and populate the descriptor */
 		new = fsl_dma_alloc_descriptor(chan);
 		if (!new) {
-			dev_err(chan->dev, msg_ld_oom);
+			chan_err(chan, "%s\n", msg_ld_oom);
 			goto fail;
 		}
 #ifdef FSL_DMA_LD_DEBUG
-		dev_dbg(chan->dev, "new link desc alloc %p\n", new);
+		chan_dbg(chan, "new link desc alloc %p\n", new);
 #endif
 
 		set_desc_cnt(chan, &new->hw, len);
@@ -815,7 +818,7 @@ static void fsl_dma_update_completed_cookie(struct fsldma_chan *chan)
 	spin_lock_irqsave(&chan->desc_lock, flags);
 
 	if (list_empty(&chan->ld_running)) {
-		dev_dbg(chan->dev, "no running descriptors\n");
+		chan_dbg(chan, "no running descriptors\n");
 		goto out_unlock;
 	}
 
@@ -863,7 +866,7 @@ static void fsl_chan_ld_cleanup(struct fsldma_chan *chan)
 
 	spin_lock_irqsave(&chan->desc_lock, flags);
 
-	dev_dbg(chan->dev, "chan completed_cookie = %d\n", chan->completed_cookie);
+	chan_dbg(chan, "chan completed_cookie = %d\n", chan->completed_cookie);
 	list_for_each_entry_safe(desc, _desc, &chan->ld_running, node) {
 		dma_async_tx_callback callback;
 		void *callback_param;
@@ -879,7 +882,7 @@ static void fsl_chan_ld_cleanup(struct fsldma_chan *chan)
 		callback_param = desc->async_tx.callback_param;
 		if (callback) {
 			spin_unlock_irqrestore(&chan->desc_lock, flags);
-			dev_dbg(chan->dev, "LD %p callback\n", desc);
+			chan_dbg(chan, "LD %p callback\n", desc);
 			callback(callback_param);
 			spin_lock_irqsave(&chan->desc_lock, flags);
 		}
@@ -913,7 +916,7 @@ static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
 	 * don't need to do any work at all
 	 */
 	if (list_empty(&chan->ld_pending)) {
-		dev_dbg(chan->dev, "no pending LDs\n");
+		chan_dbg(chan, "no pending LDs\n");
 		goto out_unlock;
 	}
 
@@ -923,7 +926,7 @@ static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
 	 * at the end of the current transaction
 	 */
 	if (!dma_is_idle(chan)) {
-		dev_dbg(chan->dev, "DMA controller still busy\n");
+		chan_dbg(chan, "DMA controller still busy\n");
 		goto out_unlock;
 	}
 
@@ -1003,14 +1006,14 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	/* save and clear the status register */
 	stat = get_sr(chan);
 	set_sr(chan, stat);
-	dev_dbg(chan->dev, "irq: channel %d, stat = 0x%x\n", chan->id, stat);
+	chan_dbg(chan, "irq: stat = 0x%x\n", stat);
 
 	stat &= ~(FSL_DMA_SR_CB | FSL_DMA_SR_CH);
 	if (!stat)
 		return IRQ_NONE;
 
 	if (stat & FSL_DMA_SR_TE)
-		dev_err(chan->dev, "Transfer Error!\n");
+		chan_err(chan, "Transfer Error!\n");
 
 	/*
 	 * Programming Error
@@ -1018,7 +1021,7 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	 * triger a PE interrupt.
 	 */
 	if (stat & FSL_DMA_SR_PE) {
-		dev_dbg(chan->dev, "irq: Programming Error INT\n");
+		chan_dbg(chan, "irq: Programming Error INT\n");
 		if (get_bcr(chan) == 0) {
 			/* BCR register is 0, this is a DMA_INTERRUPT async_tx.
 			 * Now, update the completed cookie, and continue the
@@ -1035,8 +1038,8 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	 * we will recycle the used descriptor.
 	 */
 	if (stat & FSL_DMA_SR_EOSI) {
-		dev_dbg(chan->dev, "irq: End-of-segments INT\n");
-		dev_dbg(chan->dev, "irq: clndar 0x%llx, nlndar 0x%llx\n",
+		chan_dbg(chan, "irq: End-of-segments INT\n");
+		chan_dbg(chan, "irq: clndar 0x%llx, nlndar 0x%llx\n",
 			(unsigned long long)get_cdar(chan),
 			(unsigned long long)get_ndar(chan));
 		stat &= ~FSL_DMA_SR_EOSI;
@@ -1048,7 +1051,7 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	 * and start the next transfer if it exist.
 	 */
 	if (stat & FSL_DMA_SR_EOCDI) {
-		dev_dbg(chan->dev, "irq: End-of-Chain link INT\n");
+		chan_dbg(chan, "irq: End-of-Chain link INT\n");
 		stat &= ~FSL_DMA_SR_EOCDI;
 		update_cookie = 1;
 		xfer_ld_q = 1;
@@ -1060,7 +1063,7 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	 * prepare next transfer.
 	 */
 	if (stat & FSL_DMA_SR_EOLNI) {
-		dev_dbg(chan->dev, "irq: End-of-link INT\n");
+		chan_dbg(chan, "irq: End-of-link INT\n");
 		stat &= ~FSL_DMA_SR_EOLNI;
 		xfer_ld_q = 1;
 	}
@@ -1070,9 +1073,9 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	if (xfer_ld_q)
 		fsl_chan_xfer_ld_queue(chan);
 	if (stat)
-		dev_dbg(chan->dev, "irq: unhandled sr 0x%02x\n", stat);
+		chan_dbg(chan, "irq: unhandled sr 0x%08x\n", stat);
 
-	dev_dbg(chan->dev, "irq: Exit\n");
+	chan_dbg(chan, "irq: Exit\n");
 	tasklet_schedule(&chan->tasklet);
 	return IRQ_HANDLED;
 }
@@ -1128,7 +1131,7 @@ static void fsldma_free_irqs(struct fsldma_device *fdev)
 	for (i = 0; i < FSL_DMA_MAX_CHANS_PER_DEVICE; i++) {
 		chan = fdev->chan[i];
 		if (chan && chan->irq != NO_IRQ) {
-			dev_dbg(fdev->dev, "free channel %d IRQ\n", chan->id);
+			chan_dbg(chan, "free per-channel IRQ\n");
 			free_irq(chan->irq, chan);
 		}
 	}
@@ -1155,19 +1158,16 @@ static int fsldma_request_irqs(struct fsldma_device *fdev)
 			continue;
 
 		if (chan->irq == NO_IRQ) {
-			dev_err(fdev->dev, "no interrupts property defined for "
-					   "DMA channel %d. Please fix your "
-					   "device tree\n", chan->id);
+			chan_err(chan, "interrupts property missing in device tree\n");
 			ret = -ENODEV;
 			goto out_unwind;
 		}
 
-		dev_dbg(fdev->dev, "request channel %d IRQ\n", chan->id);
+		chan_dbg(chan, "request per-channel IRQ\n");
 		ret = request_irq(chan->irq, fsldma_chan_irq, IRQF_SHARED,
 				  "fsldma-chan", chan);
 		if (ret) {
-			dev_err(fdev->dev, "unable to request IRQ for DMA "
-					   "channel %d\n", chan->id);
+			chan_err(chan, "unable to request per-channel IRQ\n");
 			goto out_unwind;
 		}
 	}
@@ -1242,6 +1242,7 @@ static int __devinit fsl_dma_chan_probe(struct fsldma_device *fdev,
 
 	fdev->chan[chan->id] = chan;
 	tasklet_init(&chan->tasklet, dma_do_tasklet, (unsigned long)chan);
+	snprintf(chan->name, sizeof(chan->name), "chan%d", chan->id);
 
 	/* Initialize the channel */
 	dma_init(chan);
diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
index ba9f403..113e713 100644
--- a/drivers/dma/fsldma.h
+++ b/drivers/dma/fsldma.h
@@ -135,6 +135,7 @@ struct fsldma_device {
 #define FSL_DMA_CHAN_START_EXT	0x00002000
 
 struct fsldma_chan {
+	char name[8];			/* Channel name */
 	struct fsldma_chan_regs __iomem *regs;
 	dma_cookie_t completed_cookie;	/* The maximum cookie completed */
 	spinlock_t desc_lock;		/* Descriptor operation lock */
-- 
1.7.3.4

