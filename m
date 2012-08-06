Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab2HFK4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:56:41 -0400
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:40378
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755837Ab2HFK4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:56:39 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: <qiang.liu@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>,
        <dan.j.williams@gmail.com>, <vinod.koul@intel.com>
CC: <kim.phillips@freescale.com>, <herbert@gondor.hengli.com.au>,
        <davem@davemloft.net>, <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Qiang Liu <qiang.liu@freescale.com>, Li Yang <leoli@freescale.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH v6 4/8] fsl-dma: move functions to avoid forward declarations
Date: Mon, 6 Aug 2012 18:14:18 +0800
Message-ID: <1344248058-9238-1-git-send-email-qiang.liu@freescale.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Qiang Liu <qiang.liu@freescale.com>

These functions will be modified in the next patch in the series. By
moving the function in a patch separate from the changes, it will make
review easier.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dan Williams <dan.j.williams@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Li Yang <leoli@freescale.com>
Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---
 drivers/dma/fsldma.c |  230 +++++++++++++++++++++++++-------------------------
 1 files changed, 115 insertions(+), 115 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index d4720d3..36490a3 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -472,6 +472,121 @@ static struct fsl_desc_sw *fsl_dma_alloc_descriptor(struct fsldma_chan *chan)
 }

 /**
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
+	fsl_dma_free_descriptor(chan, desc);
+}
+
+/**
  * fsl_dma_alloc_chan_resources - Allocate resources for DMA channel.
  * @chan : Freescale DMA channel
  *
@@ -816,121 +931,6 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
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
-static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
-				      struct fsl_desc_sw *desc)
-{
-	struct dma_async_tx_descriptor *txd = &desc->async_tx;
-	struct device *dev = chan->common.device->dev;
-	dma_addr_t src = get_desc_src(chan, desc);
-	dma_addr_t dst = get_desc_dst(chan, desc);
-	u32 len = get_desc_cnt(chan, desc);
-
-	/* Run the link descriptor callback function */
-	if (txd->callback) {
-#ifdef FSL_DMA_LD_DEBUG
-		chan_dbg(chan, "LD %p callback\n", desc);
-#endif
-		txd->callback(txd->callback_param);
-	}
-
-	/* Run any dependencies */
-	dma_run_dependencies(txd);
-
-	/* Unmap the dst buffer, if requested */
-	if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
-		if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
-			dma_unmap_single(dev, dst, len, DMA_FROM_DEVICE);
-		else
-			dma_unmap_page(dev, dst, len, DMA_FROM_DEVICE);
-	}
-
-	/* Unmap the src buffer, if requested */
-	if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-		if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
-			dma_unmap_single(dev, src, len, DMA_TO_DEVICE);
-		else
-			dma_unmap_page(dev, src, len, DMA_TO_DEVICE);
-	}
-
-	fsl_dma_free_descriptor(chan, desc);
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


