Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab1CBWY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:24:57 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:54643 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886Ab1CBWXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:23:34 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, leoli@freescale.com,
        dan.j.williams@intel.com, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH v2 6/9] fsldma: fix controller lockups
Date: Wed,  2 Mar 2011 14:23:18 -0800
Message-Id: <1299104601-15447-7-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1299104601-15447-1-git-send-email-iws@ovro.caltech.edu>
References: <1299104601-15447-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Wed, 02 Mar 2011 14:23:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling poisoning in the dmapool API quickly showed that the DMA
controller was fetching descriptors that should not have been in use.
This has caused intermittent controller lockups during testing.

I have been unable to figure out the exact set of conditions which cause
this to happen. However, I believe it is related to the driver using the
hardware registers to track whether the controller is busy or not. The
code can incorrectly decide that the hardware is idle due to lag between
register writes and the hardware actually becoming busy.

To fix this, the driver has been reworked to explicitly track the state
of the hardware, rather than try to guess what it is doing based on the
register values.

This has passed dmatest with 10 threads per channel, 100000 iterations
per thread several times without error. Previously, this would fail
within a few seconds.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/fsldma.c |  225 ++++++++++++++++++++++----------------------------
 drivers/dma/fsldma.h |    1 +
 2 files changed, 101 insertions(+), 125 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 06421c0..e9bb51e 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -63,11 +63,6 @@ static dma_addr_t get_cdar(struct fsldma_chan *chan)
 	return DMA_IN(chan, &chan->regs->cdar, 64) & ~FSL_DMA_SNEN;
 }
 
-static dma_addr_t get_ndar(struct fsldma_chan *chan)
-{
-	return DMA_IN(chan, &chan->regs->ndar, 64);
-}
-
 static u32 get_bcr(struct fsldma_chan *chan)
 {
 	return DMA_IN(chan, &chan->regs->bcr, 32);
@@ -138,13 +133,11 @@ static void dma_init(struct fsldma_chan *chan)
 	case FSL_DMA_IP_85XX:
 		/* Set the channel to below modes:
 		 * EIE - Error interrupt enable
-		 * EOSIE - End of segments interrupt enable (basic mode)
 		 * EOLNIE - End of links interrupt enable
 		 * BWC - Bandwidth sharing among channels
 		 */
 		DMA_OUT(chan, &chan->regs->mr, FSL_DMA_MR_BWC
-				| FSL_DMA_MR_EIE | FSL_DMA_MR_EOLNIE
-				| FSL_DMA_MR_EOSIE, 32);
+				| FSL_DMA_MR_EIE | FSL_DMA_MR_EOLNIE, 32);
 		break;
 	case FSL_DMA_IP_83XX:
 		/* Set the channel to below modes:
@@ -163,25 +156,32 @@ static int dma_is_idle(struct fsldma_chan *chan)
 	return (!(sr & FSL_DMA_SR_CB)) || (sr & FSL_DMA_SR_CH);
 }
 
+/*
+ * Start the DMA controller
+ *
+ * Preconditions:
+ * - the CDAR register must point to the start descriptor
+ * - the MRn[CS] bit must be cleared
+ */
 static void dma_start(struct fsldma_chan *chan)
 {
 	u32 mode;
 
 	mode = DMA_IN(chan, &chan->regs->mr, 32);
 
-	if ((chan->feature & FSL_DMA_IP_MASK) == FSL_DMA_IP_85XX) {
-		if (chan->feature & FSL_DMA_CHAN_PAUSE_EXT) {
-			DMA_OUT(chan, &chan->regs->bcr, 0, 32);
-			mode |= FSL_DMA_MR_EMP_EN;
-		} else {
-			mode &= ~FSL_DMA_MR_EMP_EN;
-		}
+	if (chan->feature & FSL_DMA_CHAN_PAUSE_EXT) {
+		DMA_OUT(chan, &chan->regs->bcr, 0, 32);
+		mode |= FSL_DMA_MR_EMP_EN;
+	} else {
+		mode &= ~FSL_DMA_MR_EMP_EN;
 	}
 
-	if (chan->feature & FSL_DMA_CHAN_START_EXT)
+	if (chan->feature & FSL_DMA_CHAN_START_EXT) {
 		mode |= FSL_DMA_MR_EMS_EN;
-	else
+	} else {
+		mode &= ~FSL_DMA_MR_EMS_EN;
 		mode |= FSL_DMA_MR_CS;
+	}
 
 	DMA_OUT(chan, &chan->regs->mr, mode, 32);
 }
@@ -757,14 +757,15 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 
 	switch (cmd) {
 	case DMA_TERMINATE_ALL:
+		spin_lock_irqsave(&chan->desc_lock, flags);
+
 		/* Halt the DMA engine */
 		dma_halt(chan);
 
-		spin_lock_irqsave(&chan->desc_lock, flags);
-
 		/* Remove and free all of the descriptors in the LD queue */
 		fsldma_free_desc_list(chan, &chan->ld_pending);
 		fsldma_free_desc_list(chan, &chan->ld_running);
+		chan->idle = true;
 
 		spin_unlock_irqrestore(&chan->desc_lock, flags);
 		return 0;
@@ -802,78 +803,45 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 }
 
 /**
- * fsl_dma_update_completed_cookie - Update the completed cookie.
+ * fsl_chan_ld_cleanup - Clean up link descriptors
  * @chan : Freescale DMA channel
  *
- * CONTEXT: hardirq
+ * This function is run after the queue of running descriptors has been
+ * executed by the DMA engine. It will run any callbacks, and then free
+ * the descriptors.
+ *
+ * HARDWARE STATE: idle
  */
-static void fsl_dma_update_completed_cookie(struct fsldma_chan *chan)
+static void fsl_chan_ld_cleanup(struct fsldma_chan *chan)
 {
-	struct fsl_desc_sw *desc;
+	struct fsl_desc_sw *desc, *_desc;
+	const char *name = chan->name;
 	unsigned long flags;
-	dma_cookie_t cookie;
 
 	spin_lock_irqsave(&chan->desc_lock, flags);
 
+	/* if the ld_running list is empty, there is nothing to do */
 	if (list_empty(&chan->ld_running)) {
-		dev_dbg(chan->dev, "%s: no running descriptors\n", chan->name);
+		dev_dbg(chan->dev, "%s: no descriptors to cleanup\n", name);
 		goto out_unlock;
 	}
 
-	/* Get the last descriptor, update the cookie to that */
+	/*
+	 * Get the last descriptor, update the cookie to it
+	 *
+	 * This is done before callbacks run so that clients can check the
+	 * status of their DMA transfer inside the callback.
+	 */
 	desc = to_fsl_desc(chan->ld_running.prev);
-	if (dma_is_idle(chan))
-		cookie = desc->async_tx.cookie;
-	else {
-		cookie = desc->async_tx.cookie - 1;
-		if (unlikely(cookie < DMA_MIN_COOKIE))
-			cookie = DMA_MAX_COOKIE;
-	}
-
-	chan->completed_cookie = cookie;
-
-out_unlock:
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
-}
-
-/**
- * fsldma_desc_status - Check the status of a descriptor
- * @chan: Freescale DMA channel
- * @desc: DMA SW descriptor
- *
- * This function will return the status of the given descriptor
- */
-static enum dma_status fsldma_desc_status(struct fsldma_chan *chan,
-					  struct fsl_desc_sw *desc)
-{
-	return dma_async_is_complete(desc->async_tx.cookie,
-				     chan->completed_cookie,
-				     chan->common.cookie);
-}
-
-/**
- * fsl_chan_ld_cleanup - Clean up link descriptors
- * @chan : Freescale DMA channel
- *
- * This function clean up the ld_queue of DMA channel.
- */
-static void fsl_chan_ld_cleanup(struct fsldma_chan *chan)
-{
-	struct fsl_desc_sw *desc, *_desc;
-	const char *name = chan->name;
-	unsigned long flags;
-
-	spin_lock_irqsave(&chan->desc_lock, flags);
-
-	dev_dbg(chan->dev, "%s: chan completed_cookie = %d\n",
+	chan->completed_cookie = desc->async_tx.cookie;
+	dev_dbg(chan->dev, "%s: completed_cookie = %d\n",
 			   name, chan->completed_cookie);
+
+	/* Run the callback for each descriptor, in order */
 	list_for_each_entry_safe(desc, _desc, &chan->ld_running, node) {
 		dma_async_tx_callback callback;
 		void *callback_param;
 
-		if (fsldma_desc_status(chan, desc) == DMA_IN_PROGRESS)
-			break;
-
 		/* Remove from the list of running transactions */
 		list_del(&desc->node);
 
@@ -897,6 +865,7 @@ static void fsl_chan_ld_cleanup(struct fsldma_chan *chan)
 		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
 	}
 
+out_unlock:
 	spin_unlock_irqrestore(&chan->desc_lock, flags);
 }
 
@@ -904,10 +873,7 @@ static void fsl_chan_ld_cleanup(struct fsldma_chan *chan)
  * fsl_chan_xfer_ld_queue - transfer any pending transactions
  * @chan : Freescale DMA channel
  *
- * This will make sure that any pending transactions will be run.
- * If the DMA controller is idle, it will be started. Otherwise,
- * the DMA controller's interrupt handler will start any pending
- * transactions when it becomes idle.
+ * HARDWARE STATE: idle
  */
 static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
 {
@@ -927,23 +893,16 @@ static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
 	}
 
 	/*
-	 * The DMA controller is not idle, which means the interrupt
-	 * handler will start any queued transactions when it runs
-	 * at the end of the current transaction
+	 * The DMA controller is not idle, which means that the interrupt
+	 * handler will start any queued transactions when it runs after
+	 * this transaction finishes
 	 */
-	if (!dma_is_idle(chan)) {
+	if (!chan->idle) {
 		dev_dbg(chan->dev, "%s: DMA controller still busy\n", name);
 		goto out_unlock;
 	}
 
 	/*
-	 * TODO:
-	 * make sure the dma_halt() function really un-wedges the
-	 * controller as much as possible
-	 */
-	dma_halt(chan);
-
-	/*
 	 * If there are some link descriptors which have not been
 	 * transferred, we need to start the controller
 	 */
@@ -952,15 +911,32 @@ static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
 	 * Move all elements from the queue of pending transactions
 	 * onto the list of running transactions
 	 */
+	dev_dbg(chan->dev, "%s: idle, starting controller\n", name);
 	desc = list_first_entry(&chan->ld_pending, struct fsl_desc_sw, node);
 	list_splice_tail_init(&chan->ld_pending, &chan->ld_running);
 
 	/*
+	 * The 85xx DMA controller doesn't clear the channel start bit
+	 * automatically at the end of a transfer. Therefore we must clear
+	 * it in software before starting the transfer.
+	 */
+	if ((chan->feature & FSL_DMA_IP_MASK) == FSL_DMA_IP_85XX) {
+		u32 mode;
+
+		mode = DMA_IN(chan, &chan->regs->mr, 32);
+		mode &= ~FSL_DMA_MR_CS;
+		DMA_OUT(chan, &chan->regs->mr, mode, 32);
+	}
+
+	/*
 	 * Program the descriptor's address into the DMA controller,
 	 * then start the DMA transaction
 	 */
 	set_cdar(chan, desc->async_tx.phys);
+	get_cdar(chan);
+
 	dma_start(chan);
+	chan->idle = false;
 
 out_unlock:
 	spin_unlock_irqrestore(&chan->desc_lock, flags);
@@ -985,16 +961,18 @@ static enum dma_status fsl_tx_status(struct dma_chan *dchan,
 					struct dma_tx_state *txstate)
 {
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
-	dma_cookie_t last_used;
 	dma_cookie_t last_complete;
+	dma_cookie_t last_used;
+	unsigned long flags;
 
-	fsl_chan_ld_cleanup(chan);
+	spin_lock_irqsave(&chan->desc_lock, flags);
 
-	last_used = dchan->cookie;
 	last_complete = chan->completed_cookie;
+	last_used = dchan->cookie;
 
-	dma_set_tx_state(txstate, last_complete, last_used, 0);
+	spin_unlock_irqrestore(&chan->desc_lock, flags);
 
+	dma_set_tx_state(txstate, last_complete, last_used, 0);
 	return dma_async_is_complete(cookie, last_complete, last_used);
 }
 
@@ -1006,8 +984,6 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 {
 	struct fsldma_chan *chan = data;
 	const char *name = chan->name;
-	int update_cookie = 0;
-	int xfer_ld_q = 0;
 	u32 stat;
 
 	/* save and clear the status register */
@@ -1015,6 +991,7 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	set_sr(chan, stat);
 	dev_dbg(chan->dev, "%s: irq: stat = 0x%x\n", name, stat);
 
+	/* check that this was really our device */
 	stat &= ~(FSL_DMA_SR_CB | FSL_DMA_SR_CH);
 	if (!stat)
 		return IRQ_NONE;
@@ -1029,29 +1006,9 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	 */
 	if (stat & FSL_DMA_SR_PE) {
 		dev_dbg(chan->dev, "%s: irq: Programming Error INT\n", name);
-		if (get_bcr(chan) == 0) {
-			/* BCR register is 0, this is a DMA_INTERRUPT async_tx.
-			 * Now, update the completed cookie, and continue the
-			 * next uncompleted transfer.
-			 */
-			update_cookie = 1;
-			xfer_ld_q = 1;
-		}
 		stat &= ~FSL_DMA_SR_PE;
-	}
-
-	/*
-	 * If the link descriptor segment transfer finishes,
-	 * we will recycle the used descriptor.
-	 */
-	if (stat & FSL_DMA_SR_EOSI) {
-		dev_dbg(chan->dev, "%s: irq: End-of-segments INT\n", name);
-		dev_dbg(chan->dev, "%s: irq: clndar 0x%llx, nlndar 0x%llx\n",
-			name,
-			(unsigned long long)get_cdar(chan),
-			(unsigned long long)get_ndar(chan));
-		stat &= ~FSL_DMA_SR_EOSI;
-		update_cookie = 1;
+		if (get_bcr(chan) != 0)
+			dev_err(chan->dev, "%s: Programming Error!\n", name);
 	}
 
 	/*
@@ -1061,8 +1018,6 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	if (stat & FSL_DMA_SR_EOCDI) {
 		dev_dbg(chan->dev, "%s: irq: End-of-Chain link INT\n", name);
 		stat &= ~FSL_DMA_SR_EOCDI;
-		update_cookie = 1;
-		xfer_ld_q = 1;
 	}
 
 	/*
@@ -1073,25 +1028,44 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 	if (stat & FSL_DMA_SR_EOLNI) {
 		dev_dbg(chan->dev, "%s: irq: End-of-link INT\n", name);
 		stat &= ~FSL_DMA_SR_EOLNI;
-		xfer_ld_q = 1;
 	}
 
-	if (update_cookie)
-		fsl_dma_update_completed_cookie(chan);
-	if (xfer_ld_q)
-		fsl_chan_xfer_ld_queue(chan);
+	/* check that the DMA controller is really idle */
+	if (!dma_is_idle(chan))
+		dev_err(chan->dev, "%s: irq: controller not idle!\n", name);
+
+	/* check that we handled all of the bits */
 	if (stat)
-		dev_dbg(chan->dev, "%s: irq: unhandled sr 0x%02x\n", name, stat);
+		dev_err(chan->dev, "%s: irq: unhandled sr 0x%02x\n", name, stat);
 
-	dev_dbg(chan->dev, "%s: irq: Exit\n", name);
+	/*
+	 * Schedule the tasklet to handle all cleanup of the current
+	 * transaction. It will start a new transaction if there is
+	 * one pending.
+	 */
 	tasklet_schedule(&chan->tasklet);
+	dev_dbg(chan->dev, "%s: irq: Exit\n", name);
 	return IRQ_HANDLED;
 }
 
 static void dma_do_tasklet(unsigned long data)
 {
 	struct fsldma_chan *chan = (struct fsldma_chan *)data;
+	unsigned long flags;
+
+	dev_dbg(chan->dev, "%s: tasklet entry\n", chan->name);
+
+	/* run all callbacks, free all used descriptors */
 	fsl_chan_ld_cleanup(chan);
+
+	/* the channel is now idle */
+	spin_lock_irqsave(&chan->desc_lock, flags);
+	chan->idle = true;
+	spin_unlock_irqrestore(&chan->desc_lock, flags);
+
+	/* start any pending transactions automatically */
+	fsl_chan_xfer_ld_queue(chan);
+	dev_dbg(chan->dev, "%s: tasklet exit\n", chan->name);
 }
 
 static irqreturn_t fsldma_ctrl_irq(int irq, void *data)
@@ -1274,6 +1248,7 @@ static int __devinit fsl_dma_chan_probe(struct fsldma_device *fdev,
 	spin_lock_init(&chan->desc_lock);
 	INIT_LIST_HEAD(&chan->ld_pending);
 	INIT_LIST_HEAD(&chan->ld_running);
+	chan->idle = true;
 
 	chan->common.device = &fdev->common;
 
diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
index 49189da..9cb5aa5 100644
--- a/drivers/dma/fsldma.h
+++ b/drivers/dma/fsldma.h
@@ -148,6 +148,7 @@ struct fsldma_chan {
 	int id;				/* Raw id of this channel */
 	struct tasklet_struct tasklet;
 	u32 feature;
+	bool idle;			/* DMA controller is idle */
 
 	void (*toggle_ext_pause)(struct fsldma_chan *fsl_chan, int enable);
 	void (*toggle_ext_start)(struct fsldma_chan *fsl_chan, int enable);
-- 
1.7.3.4

