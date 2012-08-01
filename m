Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab2HAJO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 05:14:59 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:58993
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753534Ab2HAJO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 05:14:56 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: <qiang.liu@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <dan.j.williams@gmail.com>
CC: <kim.phillips@freescale.com>, <herbert@gondor.hengli.com.au>,
        <davem@davemloft.net>, Qiang Liu <qiang.liu@freescale.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Li Yang <leoli@freescale.com>
Subject: [PATCH v5 4/6] fsl-dma: move the function ahead of its invoke function
Date: Wed, 1 Aug 2012 16:49:43 +0800
Message-ID: <1343810983-25412-1-git-send-email-qiang.liu@freescale.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qiang Liu <qiang.liu@freescale.com>

Move the function fsldma_cleanup_descriptor() and fsl_chan_xfer_ld_queue()
ahead of its invoke function for avoiding redundant definition.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---
 drivers/dma/fsldma.c |  252 +++++++++++++++++++++++++-------------------------
 1 files changed, 124 insertions(+), 128 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 87f52c0..bb883c0 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -400,9 +400,6 @@ out_splice:
 	list_splice_tail_init(&desc->tx_list, &chan->ld_pending);
 }

-static void fsldma_cleanup_descriptor(struct fsldma_chan *chan);
-static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan);
-
 /**
  * fsldma_clean_completed_descriptor - free all descriptors which
  * has been completed and acked
@@ -519,6 +516,130 @@ fsldma_clean_running_descriptor(struct fsldma_chan *chan,
 	return 0;
 }

+/**
+ * fsl_chan_xfer_ld_queue - transfer any pending transactions
+ * @chan : Freescale DMA channel
+ *
+ * HARDWARE STATE: idle
+ * LOCKING: must hold chan->desc_lock
+ */
+static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
+{
+	struct fsl_desc_sw *desc;
+
+	/*
+	 * If the list of pending descriptors is empty, then we
+	 * don't need to do any work at all
+	 */
+	if (list_empty(&chan->ld_pending)) {
+		chan_dbg(chan, "no pending LDs\n");
+		return;
+	}
+
+	/*
+	 * The DMA controller is not idle, which means that the interrupt
+	 * handler will start any queued transactions when it runs after
+	 * this transaction finishes
+	 */
+	if (!chan->idle) {
+		chan_dbg(chan, "DMA controller still busy\n");
+		return;
+	}
+
+	/*
+	 * If there are some link descriptors which have not been
+	 * transferred, we need to start the controller
+	 */
+
+	/*
+	 * Move all elements from the queue of pending transactions
+	 * onto the list of running transactions
+	 */
+	chan_dbg(chan, "idle, starting controller\n");
+	desc = list_first_entry(&chan->ld_pending, struct fsl_desc_sw, node);
+	list_splice_tail_init(&chan->ld_pending, &chan->ld_running);
+
+	/*
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
+	 * Program the descriptor's address into the DMA controller,
+	 * then start the DMA transaction
+	 */
+	set_cdar(chan, desc->async_tx.phys);
+	get_cdar(chan);
+
+	dma_start(chan);
+	chan->idle = false;
+}
+
+/**
+ * fsldma_cleanup_descriptor - cleanup and free a single link descriptor
+ * @chan: Freescale DMA channel
+ * @desc: descriptor to cleanup and free
+ *
+ * This function is used on a descriptor which has been executed by the DMA
+ * controller. It will run any callbacks, submit any dependencies, and then
+ * free the descriptor.
+ */
+static void fsldma_cleanup_descriptor(struct fsldma_chan *chan)
+{
+	struct fsl_desc_sw *desc, *_desc;
+	dma_cookie_t cookie = 0;
+	dma_addr_t curr_phys = get_cdar(chan);
+	int idle = dma_is_idle(chan);
+	int seen_current = 0;
+
+	fsldma_clean_completed_descriptor(chan);
+
+	/* Run the callback for each descriptor, in order */
+	list_for_each_entry_safe(desc, _desc, &chan->ld_running, node) {
+		/*
+		 * do not advance past the current descriptor loaded into the
+		 * hardware channel, subsequent descriptors are either in
+		 * process or have not been submitted
+		 */
+		if (seen_current)
+			break;
+
+		/*
+		 * stop the search if we reach the current descriptor and the
+		 * channel is busy
+		 */
+		if (desc->async_tx.phys == curr_phys) {
+			seen_current = 1;
+			if (!idle)
+				break;
+		}
+
+		cookie = fsldma_run_tx_complete_actions(desc, chan, cookie);
+
+		if (fsldma_clean_running_descriptor(chan, desc))
+			break;
+	}
+
+	/*
+	 * Start any pending transactions automatically
+	 *
+	 * In the ideal case, we keep the DMA controller busy while we go
+	 * ahead and free the descriptors below.
+	 */
+	fsl_chan_xfer_ld_queue(chan);
+
+	if (cookie > 0)
+		chan->common.completed_cookie = cookie;
+}
+
 static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 {
 	struct fsldma_chan *chan = to_fsl_chan(tx->chan);
@@ -932,131 +1053,6 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
 }

 /**
- * fsldma_cleanup_descriptor - cleanup and free a single link descriptor
- * @chan: Freescale DMA channel
- * @desc: descriptor to cleanup and free
- *
- * This function is used on a descriptor which has been executed by the DMA
- * controller. It will run any callbacks, submit any dependencies, and then
- * free the descriptor.
- */
-static void fsldma_cleanup_descriptor(struct fsldma_chan *chan)
-{
-	struct fsl_desc_sw *desc, *_desc;
-	dma_cookie_t cookie = 0;
-	dma_addr_t curr_phys = get_cdar(chan);
-	int idle = dma_is_idle(chan);
-	int seen_current = 0;
-
-	fsldma_clean_completed_descriptor(chan);
-
-	/* Run the callback for each descriptor, in order */
-	list_for_each_entry_safe(desc, _desc, &chan->ld_running, node) {
-		/*
-		 * do not advance past the current descriptor loaded into the
-		 * hardware channel, subsequent descriptors are either in
-		 * process or have not been submitted
-		 */
-		if (seen_current)
-			break;
-
-		/*
-		 * stop the search if we reach the current descriptor and the
-		 * channel is busy
-		 */
-		if (desc->async_tx.phys == curr_phys) {
-			seen_current = 1;
-			if (!idle)
-				break;
-		}
-
-		cookie = fsldma_run_tx_complete_actions(desc, chan, cookie);
-
-		if (fsldma_clean_running_descriptor(chan, desc))
-			break;
-
-	}
-
-	/*
-	 * Start any pending transactions automatically
-	 *
-	 * In the ideal case, we keep the DMA controller busy while we go
-	 * ahead and free the descriptors below.
-	 */
-	fsl_chan_xfer_ld_queue(chan);
-
-	if (cookie > 0)
-		chan->common.completed_cookie = cookie;
-}
-
-/**
- * fsl_chan_xfer_ld_queue - transfer any pending transactions
- * @chan : Freescale DMA channel
- *
- * HARDWARE STATE: idle
- * LOCKING: must hold chan->desc_lock
- */
-static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan)
-{
-	struct fsl_desc_sw *desc;
-
-	/*
-	 * If the list of pending descriptors is empty, then we
-	 * don't need to do any work at all
-	 */
-	if (list_empty(&chan->ld_pending)) {
-		chan_dbg(chan, "no pending LDs\n");
-		return;
-	}
-
-	/*
-	 * The DMA controller is not idle, which means that the interrupt
-	 * handler will start any queued transactions when it runs after
-	 * this transaction finishes
-	 */
-	if (!chan->idle) {
-		chan_dbg(chan, "DMA controller still busy\n");
-		return;
-	}
-
-	/*
-	 * If there are some link descriptors which have not been
-	 * transferred, we need to start the controller
-	 */
-
-	/*
-	 * Move all elements from the queue of pending transactions
-	 * onto the list of running transactions
-	 */
-	chan_dbg(chan, "idle, starting controller\n");
-	desc = list_first_entry(&chan->ld_pending, struct fsl_desc_sw, node);
-	list_splice_tail_init(&chan->ld_pending, &chan->ld_running);
-
-	/*
-	 * The 85xx DMA controller doesn't clear the channel start bit
-	 * automatically at the end of a transfer. Therefore we must clear
-	 * it in software before starting the transfer.
-	 */
-	if ((chan->feature & FSL_DMA_IP_MASK) == FSL_DMA_IP_85XX) {
-		u32 mode;
-
-		mode = DMA_IN(chan, &chan->regs->mr, 32);
-		mode &= ~FSL_DMA_MR_CS;
-		DMA_OUT(chan, &chan->regs->mr, mode, 32);
-	}
-
-	/*
-	 * Program the descriptor's address into the DMA controller,
-	 * then start the DMA transaction
-	 */
-	set_cdar(chan, desc->async_tx.phys);
-	get_cdar(chan);
-
-	dma_start(chan);
-	chan->idle = false;
-}
-
-/**
  * fsl_dma_memcpy_issue_pending - Issue the DMA start command
  * @chan : Freescale DMA channel
  */
--
1.7.5.1


