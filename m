Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab1CBWZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:25:35 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:54624 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757846Ab1CBWXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:23:33 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, leoli@freescale.com,
        dan.j.williams@intel.com, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH v2 3/9] fsldma: use channel name in printk output
Date: Wed,  2 Mar 2011 14:23:15 -0800
Message-Id: <1299104601-15447-4-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1299104601-15447-1-git-send-email-iws@ovro.caltech.edu>
References: <1299104601-15447-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Wed, 02 Mar 2011 14:23:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes debugging the driver much easier when multiple channels are
running concurrently. In addition, you can see how much descriptor
memory each channel has allocated via the dmapool API in sysfs.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/fsldma.c |   60 +++++++++++++++++++++++++++----------------------
 drivers/dma/fsldma.h |    1 +
 2 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 2e1af45..6e3d3d7 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -37,7 +37,7 @@
 
 #include "fsldma.h"
 
-static const char msg_ld_oom[] = "No free memory for link descriptor\n";
+static const char msg_ld_oom[] = "No free memory for link descriptor";
 
 /*
  * Register Helpers
@@ -207,7 +207,7 @@ static void dma_halt(struct fsldma_chan *chan)
 	}
 
 	if (!dma_is_idle(chan))
-		dev_err(chan->dev, "DMA halt timeout!\n");
+		dev_err(chan->dev, "%s: DMA halt timeout!\n", chan->name);
 }
 
 /**
@@ -400,12 +400,13 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 static struct fsl_desc_sw *fsl_dma_alloc_descriptor(
 					struct fsldma_chan *chan)
 {
+	const char *name = chan->name;
 	struct fsl_desc_sw *desc;
 	dma_addr_t pdesc;
 
 	desc = dma_pool_alloc(chan->desc_pool, GFP_ATOMIC, &pdesc);
 	if (!desc) {
-		dev_dbg(chan->dev, "out of memory for link desc\n");
+		dev_dbg(chan->dev, "%s: out of memory for link desc\n", name);
 		return NULL;
 	}
 
@@ -439,13 +440,12 @@ static int fsl_dma_alloc_chan_resources(struct dma_chan *dchan)
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
+		dev_err(chan->dev, "%s: unable to allocate descriptor pool\n",
+				   chan->name);
 		return -ENOMEM;
 	}
 
@@ -491,7 +491,7 @@ static void fsl_dma_free_chan_resources(struct dma_chan *dchan)
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
 	unsigned long flags;
 
-	dev_dbg(chan->dev, "Free all channel resources.\n");
+	dev_dbg(chan->dev, "%s: Free all channel resources.\n", chan->name);
 	spin_lock_irqsave(&chan->desc_lock, flags);
 	fsldma_free_desc_list(chan, &chan->ld_pending);
 	fsldma_free_desc_list(chan, &chan->ld_running);
@@ -514,7 +514,7 @@ fsl_dma_prep_interrupt(struct dma_chan *dchan, unsigned long flags)
 
 	new = fsl_dma_alloc_descriptor(chan);
 	if (!new) {
-		dev_err(chan->dev, msg_ld_oom);
+		dev_err(chan->dev, "%s: %s\n", chan->name, msg_ld_oom);
 		return NULL;
 	}
 
@@ -551,11 +551,11 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 		/* Allocate the link descriptor from DMA pool */
 		new = fsl_dma_alloc_descriptor(chan);
 		if (!new) {
-			dev_err(chan->dev, msg_ld_oom);
+			dev_err(chan->dev, "%s: %s\n", chan->name, msg_ld_oom);
 			goto fail;
 		}
 #ifdef FSL_DMA_LD_DEBUG
-		dev_dbg(chan->dev, "new link desc alloc %p\n", new);
+		dev_dbg(chan->dev, "%s: new link desc alloc %p\n", chan->name, new);
 #endif
 
 		copy = min(len, (size_t)FSL_DMA_BCR_MAX_CNT);
@@ -639,11 +639,11 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_sg(struct dma_chan *dchan,
 		/* allocate and populate the descriptor */
 		new = fsl_dma_alloc_descriptor(chan);
 		if (!new) {
-			dev_err(chan->dev, msg_ld_oom);
+			dev_err(chan->dev, "%s: %s\n", chan->name, msg_ld_oom);
 			goto fail;
 		}
 #ifdef FSL_DMA_LD_DEBUG
-		dev_dbg(chan->dev, "new link desc alloc %p\n", new);
+		dev_dbg(chan->dev, "%s: new link desc alloc %p\n", chan->name, new);
 #endif
 
 		set_desc_cnt(chan, &new->hw, len);
@@ -815,7 +815,7 @@ static void fsl_dma_update_completed_cookie(struct fsldma_chan *chan)
 	spin_lock_irqsave(&chan->desc_lock, flags);
 
 	if (list_empty(&chan->ld_running)) {
-		dev_dbg(chan->dev, "no running descriptors\n");
+		dev_dbg(chan->dev, "%s: no running descriptors\n", chan->name);
 		goto out_unlock;
 	}
 
@@ -859,11 +859,13 @@ static enum dma_status fsldma_desc_status(struct fsldma_chan *chan,
 static void fsl_chan_ld_cleanup(struct fsldma_chan *chan)
 {
 	struct fsl_desc_sw *desc, *_desc;
+	const char *name = chan->name;
 	unsigned long flags;
 
 	spin_lock_irqsave(&chan->desc_lock, flags);
 
-	dev_dbg(chan->dev, "chan completed_cookie = %d\n", chan->completed_cookie);
+	dev_dbg(chan->dev, "%s: chan completed_cookie = %d\n",
+			   name, chan->completed_cookie);
 	list_for_each_entry_safe(desc, _desc, &chan->ld_running, node) {
 		dma_async_tx_callback callback;
 		void *callback_param;
@@ -879,7 +881,7 @@ static void fsl_chan_ld_cleanup(struct fsldma_chan *chan)
 		callback_param = desc->async_tx.callback_param;
 		if (callback) {
 			spin_unlock_irqrestore(&chan->desc_lock, flags);
-			dev_dbg(chan->dev, "LD %p callback\n", desc);
+			dev_dbg(chan->dev, "%s: LD %p callback\n", name, desc);
 			callback(callback_param);
 			spin_lock_irqsave(&chan->desc_lock, flags);
 		}
@@ -903,6 +905,7 @@ static void fsl_chan_ld_cleanup(struct fsldma_chan *chan)
  */
 static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
 {
+	const char *name = chan->name;
 	struct fsl_desc_sw *desc;
 	unsigned long flags;
 
@@ -913,7 +916,7 @@ static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
 	 * don't need to do any work at all
 	 */
 	if (list_empty(&chan->ld_pending)) {
-		dev_dbg(chan->dev, "no pending LDs\n");
+		dev_dbg(chan->dev, "%s: no pending LDs\n", name);
 		goto out_unlock;
 	}
 
@@ -923,7 +926,7 @@ static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
 	 * at the end of the current transaction
 	 */
 	if (!dma_is_idle(chan)) {
-		dev_dbg(chan->dev, "DMA controller still busy\n");
+		dev_dbg(chan->dev, "%s: DMA controller still busy\n", name);
 		goto out_unlock;
 	}
 
@@ -996,6 +999,7 @@ static enum dma_status fsl_tx_status(struct dma_chan *dchan,
 static irqreturn_t fsldma_chan_irq(int irq, void *data)
 {
 	struct fsldma_chan *chan = data;
+	const char *name = chan->name;
 	int update_cookie = 0;
 	int xfer_ld_q = 0;
 	u32 stat;
@@ -1003,14 +1007,14 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	/* save and clear the status register */
 	stat = get_sr(chan);
 	set_sr(chan, stat);
-	dev_dbg(chan->dev, "irq: channel %d, stat = 0x%x\n", chan->id, stat);
+	dev_dbg(chan->dev, "%s: irq: stat = 0x%x\n", name, stat);
 
 	stat &= ~(FSL_DMA_SR_CB | FSL_DMA_SR_CH);
 	if (!stat)
 		return IRQ_NONE;
 
 	if (stat & FSL_DMA_SR_TE)
-		dev_err(chan->dev, "Transfer Error!\n");
+		dev_err(chan->dev, "%s: Transfer Error!\n", name);
 
 	/*
 	 * Programming Error
@@ -1018,7 +1022,7 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	 * triger a PE interrupt.
 	 */
 	if (stat & FSL_DMA_SR_PE) {
-		dev_dbg(chan->dev, "irq: Programming Error INT\n");
+		dev_dbg(chan->dev, "%s: irq: Programming Error INT\n", name);
 		if (get_bcr(chan) == 0) {
 			/* BCR register is 0, this is a DMA_INTERRUPT async_tx.
 			 * Now, update the completed cookie, and continue the
@@ -1035,8 +1039,9 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	 * we will recycle the used descriptor.
 	 */
 	if (stat & FSL_DMA_SR_EOSI) {
-		dev_dbg(chan->dev, "irq: End-of-segments INT\n");
-		dev_dbg(chan->dev, "irq: clndar 0x%llx, nlndar 0x%llx\n",
+		dev_dbg(chan->dev, "%s: irq: End-of-segments INT\n", name);
+		dev_dbg(chan->dev, "%s: irq: clndar 0x%llx, nlndar 0x%llx\n",
+			name,
 			(unsigned long long)get_cdar(chan),
 			(unsigned long long)get_ndar(chan));
 		stat &= ~FSL_DMA_SR_EOSI;
@@ -1048,7 +1053,7 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	 * and start the next transfer if it exist.
 	 */
 	if (stat & FSL_DMA_SR_EOCDI) {
-		dev_dbg(chan->dev, "irq: End-of-Chain link INT\n");
+		dev_dbg(chan->dev, "%s: irq: End-of-Chain link INT\n", name);
 		stat &= ~FSL_DMA_SR_EOCDI;
 		update_cookie = 1;
 		xfer_ld_q = 1;
@@ -1060,7 +1065,7 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	 * prepare next transfer.
 	 */
 	if (stat & FSL_DMA_SR_EOLNI) {
-		dev_dbg(chan->dev, "irq: End-of-link INT\n");
+		dev_dbg(chan->dev, "%s: irq: End-of-link INT\n", name);
 		stat &= ~FSL_DMA_SR_EOLNI;
 		xfer_ld_q = 1;
 	}
@@ -1070,9 +1075,9 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	if (xfer_ld_q)
 		fsl_chan_xfer_ld_queue(chan);
 	if (stat)
-		dev_dbg(chan->dev, "irq: unhandled sr 0x%02x\n", stat);
+		dev_dbg(chan->dev, "%s: irq: unhandled sr 0x%02x\n", name, stat);
 
-	dev_dbg(chan->dev, "irq: Exit\n");
+	dev_dbg(chan->dev, "%s: irq: Exit\n", name);
 	tasklet_schedule(&chan->tasklet);
 	return IRQ_HANDLED;
 }
@@ -1242,6 +1247,7 @@ static int __devinit fsl_dma_chan_probe(struct fsldma_device *fdev,
 
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

