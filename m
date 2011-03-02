Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab1CBWX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:23:59 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:54645 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920Ab1CBWXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:23:35 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, leoli@freescale.com,
        dan.j.williams@intel.com, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH v2 8/9] fsldma: reduce locking during descriptor cleanup
Date: Wed,  2 Mar 2011 14:23:20 -0800
Message-Id: <1299104601-15447-9-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1299104601-15447-1-git-send-email-iws@ovro.caltech.edu>
References: <1299104601-15447-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Wed, 02 Mar 2011 14:23:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This merges the fsl_chan_ld_cleanup() function into the dma_do_tasklet()
function to reduce locking overhead. In the best case, we will be able
to keep the DMA controller busy while we are freeing used descriptors.
In all cases, the spinlock is grabbed two times fewer than before on
each transaction.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/fsldma.c |  114 +++++++++++++++++++++----------------------------
 1 files changed, 49 insertions(+), 65 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 48e48c7..40babc1 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -879,67 +879,16 @@ static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
 }
 
 /**
- * fsl_chan_ld_cleanup - Clean up link descriptors
- * @chan : Freescale DMA channel
- *
- * This function is run after the queue of running descriptors has been
- * executed by the DMA engine. It will run any callbacks, and then free
- * the descriptors.
- *
- * HARDWARE STATE: idle
- */
-static void fsl_chan_ld_cleanup(struct fsldma_chan *chan)
-{
-	struct fsl_desc_sw *desc, *_desc;
-	const char *name = chan->name;
-	LIST_HEAD(ld_cleanup);
-	unsigned long flags;
-
-	spin_lock_irqsave(&chan->desc_lock, flags);
-
-	/* update the cookie if we have some descriptors to cleanup */
-	if (!list_empty(&chan->ld_running)) {
-		dma_cookie_t cookie;
-
-		desc = to_fsl_desc(chan->ld_running.prev);
-		cookie = desc->async_tx.cookie;
-
-		chan->completed_cookie = cookie;
-		dev_dbg(chan->dev, "%s: completed_cookie=%d\n", name, cookie);
-	}
-
-	/*
-	 * move the descriptors to a temporary list so we can drop the lock
-	 * during the entire cleanup operation
-	 */
-	list_splice_tail_init(&chan->ld_running, &ld_cleanup);
-
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
-
-	/* Run the callback for each descriptor, in order */
-	list_for_each_entry_safe(desc, _desc, &ld_cleanup, node) {
-
-		/* Remove from the list of transactions */
-		list_del(&desc->node);
-
-		/* Run all cleanup for this descriptor */
-		fsldma_cleanup_descriptor(chan, desc);
-	}
-}
-
-/**
  * fsl_chan_xfer_ld_queue - transfer any pending transactions
  * @chan : Freescale DMA channel
  *
  * HARDWARE STATE: idle
+ * LOCKING: must hold chan->desc_lock
  */
 static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
 {
 	const char *name = chan->name;
 	struct fsl_desc_sw *desc;
-	unsigned long flags;
-
-	spin_lock_irqsave(&chan->desc_lock, flags);
 
 	/*
 	 * If the list of pending descriptors is empty, then we
@@ -947,7 +896,7 @@ static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
 	 */
 	if (list_empty(&chan->ld_pending)) {
 		dev_dbg(chan->dev, "%s: no pending LDs\n", name);
-		goto out_unlock;
+		return;
 	}
 
 	/*
@@ -957,7 +906,7 @@ static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
 	 */
 	if (!chan->idle) {
 		dev_dbg(chan->dev, "%s: DMA controller still busy\n", name);
-		goto out_unlock;
+		return;
 	}
 
 	/*
@@ -995,9 +944,6 @@ static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
 
 	dma_start(chan);
 	chan->idle = false;
-
-out_unlock:
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
 }
 
 /**
@@ -1007,7 +953,11 @@ out_unlock:
 static void fsl_dma_memcpy_issue_pending(struct dma_chan *dchan)
 {
 	struct fsldma_chan *chan = to_fsl_chan(dchan);
+	unsigned long flags;
+
+	spin_lock_irqsave(&chan->desc_lock, flags);
 	fsl_chan_xfer_ld_queue(chan);
+	spin_unlock_irqrestore(&chan->desc_lock, flags);
 }
 
 /**
@@ -1109,21 +1059,55 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
 static void dma_do_tasklet(unsigned long data)
 {
 	struct fsldma_chan *chan = (struct fsldma_chan *)data;
+	struct fsl_desc_sw *desc, *_desc;
+	const char *name = chan->name;
+	LIST_HEAD(ld_cleanup);
 	unsigned long flags;
 
-	dev_dbg(chan->dev, "%s: tasklet entry\n", chan->name);
+	dev_dbg(chan->dev, "%s: tasklet entry\n", name);
 
-	/* run all callbacks, free all used descriptors */
-	fsl_chan_ld_cleanup(chan);
-
-	/* the channel is now idle */
 	spin_lock_irqsave(&chan->desc_lock, flags);
+
+	/* update the cookie if we have some descriptors to cleanup */
+	if (!list_empty(&chan->ld_running)) {
+		dma_cookie_t cookie;
+
+		desc = to_fsl_desc(chan->ld_running.prev);
+		cookie = desc->async_tx.cookie;
+
+		chan->completed_cookie = cookie;
+		dev_dbg(chan->dev, "%s: completed_cookie=%d\n", name, cookie);
+	}
+
+	/*
+	 * move the descriptors to a temporary list so we can drop the lock
+	 * during the entire cleanup operation
+	 */
+	list_splice_tail_init(&chan->ld_running, &ld_cleanup);
+
+	/* the hardware is now idle and ready for more */
 	chan->idle = true;
-	spin_unlock_irqrestore(&chan->desc_lock, flags);
 
-	/* start any pending transactions automatically */
+	/*
+	 * Start any pending transactions automatically
+	 *
+	 * In the ideal case, we keep the DMA controller busy while we go
+	 * ahead and free the descriptors below.
+	 */
 	fsl_chan_xfer_ld_queue(chan);
-	dev_dbg(chan->dev, "%s: tasklet exit\n", chan->name);
+	spin_unlock_irqrestore(&chan->desc_lock, flags);
+
+	/* Run the callback for each descriptor, in order */
+	list_for_each_entry_safe(desc, _desc, &ld_cleanup, node) {
+
+		/* Remove from the list of transactions */
+		list_del(&desc->node);
+
+		/* Run all cleanup for this descriptor */
+		fsldma_cleanup_descriptor(chan, desc);
+	}
+
+	dev_dbg(chan->dev, "%s: tasklet exit\n", name);
 }
 
 static irqreturn_t fsldma_ctrl_irq(int irq, void *data)
-- 
1.7.3.4

