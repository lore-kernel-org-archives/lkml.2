Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1DVQfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:35:38 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:40515 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab1DVQfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:35:12 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v2 2/5] dmaengine: at_hdmac: add cyclic DMA operation support
Date: Fri, 22 Apr 2011 19:41:58 +0200
Message-Id: <94c5d55fc23a20db0607457ef1740c6e9683035a.1303493836.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1301678094.git.nicolas.ferre@atmel.com>
References: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1301678094.git.nicolas.ferre@atmel.com>
In-Reply-To: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1303493836.git.nicolas.ferre@atmel.com>
References: <3ee5a0e314a22339ad7a15a5425045f5ed244eab.1303493836.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
v2:	- remove debug directives
	- split atc_prep_dma_cyclic() into function to ease code readability.
	- atc_desc_chain() helper function will be use in a folling patch series for
	  other prep_ functions.

 drivers/dma/at_hdmac.c      |  231 ++++++++++++++++++++++++++++++++++++++++---
 drivers/dma/at_hdmac_regs.h |   14 +++-
 2 files changed, 229 insertions(+), 16 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 13050e6..ed9d924 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -165,6 +165,29 @@ static void atc_desc_put(struct at_dma_chan *atchan, struct at_desc *desc)
 }
 
 /**
+ * atc_desc_chain - build chain adding a descripor
+ * @first: address of first descripor of the chain
+ * @prev: address of previous descripor of the chain
+ * @desc: descriptor to queue
+ *
+ * Called from prep_* functions
+ */
+static void atc_desc_chain(struct at_desc **first, struct at_desc **prev,
+			   struct at_desc *desc)
+{
+	if (!(*first)) {
+		*first = desc;
+	} else {
+		/* inform the HW lli about chaining */
+		(*prev)->lli.dscr = desc->txd.phys;
+		/* insert the link descriptor to the LD ring */
+		list_add_tail(&desc->desc_node,
+				&(*first)->tx_list);
+	}
+	*prev = desc;
+}
+
+/**
  * atc_assign_cookie - compute and assign new cookie
  * @atchan: channel we work on
  * @desc: descriptor to asign cookie for
@@ -237,16 +260,12 @@ static void atc_dostart(struct at_dma_chan *atchan, struct at_desc *first)
 static void
 atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 {
-	dma_async_tx_callback		callback;
-	void				*param;
 	struct dma_async_tx_descriptor	*txd = &desc->txd;
 
 	dev_vdbg(chan2dev(&atchan->chan_common),
 		"descriptor %u complete\n", txd->cookie);
 
 	atchan->completed_cookie = txd->cookie;
-	callback = txd->callback;
-	param = txd->callback_param;
 
 	/* move children to free_list */
 	list_splice_init(&desc->tx_list, &atchan->free_list);
@@ -278,12 +297,19 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 		}
 	}
 
-	/*
-	 * The API requires that no submissions are done from a
-	 * callback, so we don't need to drop the lock here
-	 */
-	if (callback)
-		callback(param);
+	/* for cyclic transfers,
+	 * no need to replay callback function while stopping */
+	if (!test_bit(ATC_IS_CYCLIC, &atchan->status)) {
+		dma_async_tx_callback	callback = txd->callback;
+		void			*param = txd->callback_param;
+
+		/*
+		 * The API requires that no submissions are done from a
+		 * callback, so we don't need to drop the lock here
+		 */
+		if (callback)
+			callback(param);
+	}
 
 	dma_run_dependencies(txd);
 }
@@ -419,6 +445,26 @@ static void atc_handle_error(struct at_dma_chan *atchan)
 	atc_chain_complete(atchan, bad_desc);
 }
 
+/**
+ * atc_handle_cyclic - at the end of a period, run callback function
+ * @atchan: channel used for cyclic operations
+ *
+ * Called with atchan->lock held and bh disabled
+ */
+static void atc_handle_cyclic(struct at_dma_chan *atchan)
+{
+	struct at_desc			*first = atc_first_active(atchan);
+	struct dma_async_tx_descriptor	*txd = &first->txd;
+	dma_async_tx_callback		callback = txd->callback;
+	void				*param = txd->callback_param;
+
+	dev_vdbg(chan2dev(&atchan->chan_common),
+			"new cyclic period llp 0x%08x\n",
+			channel_readl(atchan, DSCR));
+
+	if (callback)
+		callback(param);
+}
 
 /*--  IRQ & Tasklet  ---------------------------------------------------*/
 
@@ -434,8 +480,10 @@ static void atc_tasklet(unsigned long data)
 	}
 
 	spin_lock(&atchan->lock);
-	if (test_and_clear_bit(0, &atchan->error_status))
+	if (test_and_clear_bit(ATC_IS_ERROR, &atchan->status))
 		atc_handle_error(atchan);
+	else if (test_bit(ATC_IS_CYCLIC, &atchan->status))
+		atc_handle_cyclic(atchan);
 	else
 		atc_advance_work(atchan);
 
@@ -469,7 +517,7 @@ static irqreturn_t at_dma_interrupt(int irq, void *dev_id)
 					/* Disable channel on AHB error */
 					dma_writel(atdma, CHDR, atchan->mask);
 					/* Give information to tasklet */
-					set_bit(0, &atchan->error_status);
+					set_bit(ATC_IS_ERROR, &atchan->status);
 				}
 				tasklet_schedule(&atchan->tasklet);
 				ret = IRQ_HANDLED;
@@ -759,6 +807,148 @@ err_desc_get:
 	return NULL;
 }
 
+/**
+ * atc_dma_cyclic_check_values
+ * Check for too big/unaligned periods and unaligned DMA buffer
+ */
+static int
+atc_dma_cyclic_check_values(unsigned int reg_width, dma_addr_t buf_addr,
+		size_t period_len, enum dma_data_direction direction)
+{
+	if (period_len > (ATC_BTSIZE_MAX << reg_width))
+		goto err_out;
+	if (unlikely(period_len & ((1 << reg_width) - 1)))
+		goto err_out;
+	if (unlikely(buf_addr & ((1 << reg_width) - 1)))
+		goto err_out;
+	if (unlikely(!(direction & (DMA_TO_DEVICE | DMA_FROM_DEVICE))))
+		goto err_out;
+
+	return 0;
+
+err_out:
+	return -EINVAL;
+}
+
+/**
+ * atc_dma_cyclic_fill_desc - Fill one period decriptor
+ */
+static int
+atc_dma_cyclic_fill_desc(struct at_dma_slave *atslave, struct at_desc *desc,
+		unsigned int period_index, dma_addr_t buf_addr,
+		size_t period_len, enum dma_data_direction direction)
+{
+	u32		ctrla;
+	unsigned int	reg_width = atslave->reg_width;
+
+	/* prepare common CRTLA value */
+	ctrla =   ATC_DEFAULT_CTRLA | atslave->ctrla
+		| ATC_DST_WIDTH(reg_width)
+		| ATC_SRC_WIDTH(reg_width)
+		| period_len >> reg_width;
+
+	switch (direction) {
+	case DMA_TO_DEVICE:
+		desc->lli.saddr = buf_addr + (period_len * period_index);
+		desc->lli.daddr = atslave->tx_reg;
+		desc->lli.ctrla = ctrla;
+		desc->lli.ctrlb = ATC_DEFAULT_CTRLB
+				| ATC_DST_ADDR_MODE_FIXED
+				| ATC_SRC_ADDR_MODE_INCR
+				| ATC_FC_MEM2PER;
+		break;
+
+	case DMA_FROM_DEVICE:
+		desc->lli.saddr = atslave->rx_reg;
+		desc->lli.daddr = buf_addr + (period_len * period_index);
+		desc->lli.ctrla = ctrla;
+		desc->lli.ctrlb = ATC_DEFAULT_CTRLB
+				| ATC_DST_ADDR_MODE_INCR
+				| ATC_SRC_ADDR_MODE_FIXED
+				| ATC_FC_PER2MEM;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * atc_prep_dma_cyclic - prepare the cyclic DMA transfer
+ * @chan: the DMA channel to prepare
+ * @buf_addr: physical DMA address where the buffer starts
+ * @buf_len: total number of bytes for the entire buffer
+ * @period_len: number of bytes for each period
+ * @direction: transfer direction, to or from device
+ */
+static struct dma_async_tx_descriptor *
+atc_prep_dma_cyclic(struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
+		size_t period_len, enum dma_data_direction direction)
+{
+	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
+	struct at_dma_slave	*atslave = chan->private;
+	struct at_desc		*first = NULL;
+	struct at_desc		*prev = NULL;
+	unsigned long		was_cyclic;
+	unsigned int		periods = buf_len / period_len;
+	unsigned int		i;
+
+	dev_vdbg(chan2dev(chan), "prep_dma_cyclic: %s buf@0x%08x - %d (%d/%d)\n",
+			direction == DMA_TO_DEVICE ? "TO DEVICE" : "FROM DEVICE",
+			buf_addr,
+			periods, buf_len, period_len);
+
+	if (unlikely(!atslave || !buf_len || !period_len)) {
+		dev_dbg(chan2dev(chan), "prep_dma_cyclic: length is zero!\n");
+		return NULL;
+	}
+
+	was_cyclic = test_and_set_bit(ATC_IS_CYCLIC, &atchan->status);
+	if (was_cyclic) {
+		dev_dbg(chan2dev(chan), "prep_dma_cyclic: channel in use!\n");
+		return NULL;
+	}
+
+	/* Check for too big/unaligned periods and unaligned DMA buffer */
+	if (atc_dma_cyclic_check_values(atslave->reg_width, buf_addr,
+					period_len, direction))
+		goto err_out;
+
+	/* build cyclic linked list */
+	for (i = 0; i < periods; i++) {
+		struct at_desc	*desc;
+
+		desc = atc_desc_get(atchan);
+		if (!desc)
+			goto err_desc_get;
+
+		if (atc_dma_cyclic_fill_desc(atslave, desc, i, buf_addr,
+						period_len, direction))
+			goto err_desc_get;
+
+		atc_desc_chain(&first, &prev, desc);
+	}
+
+	/* lets make a cyclic list */
+	prev->lli.dscr = first->txd.phys;
+
+	/* First descriptor of the chain embedds additional information */
+	first->txd.cookie = -EBUSY;
+	first->len = buf_len;
+
+	return &first->txd;
+
+err_desc_get:
+	dev_err(chan2dev(chan), "not enough descriptors available\n");
+	atc_desc_put(atchan, first);
+err_out:
+	clear_bit(ATC_IS_CYCLIC, &atchan->status);
+	return NULL;
+}
+
+
 static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		       unsigned long arg)
 {
@@ -793,6 +983,9 @@ static int atc_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	list_for_each_entry_safe(desc, _desc, &list, desc_node)
 		atc_chain_complete(atchan, desc);
 
+	/* if channel dedicated to cyclic operations, free it */
+	clear_bit(ATC_IS_CYCLIC, &atchan->status);
+
 	spin_unlock_bh(&atchan->lock);
 
 	return 0;
@@ -853,6 +1046,10 @@ static void atc_issue_pending(struct dma_chan *chan)
 
 	dev_vdbg(chan2dev(chan), "issue_pending\n");
 
+	/* Not needed for cyclic transfers */
+	if (test_bit(ATC_IS_CYCLIC, &atchan->status))
+		return;
+
 	spin_lock_bh(&atchan->lock);
 	if (!atc_chan_is_enabled(atchan)) {
 		atc_advance_work(atchan);
@@ -959,6 +1156,7 @@ static void atc_free_chan_resources(struct dma_chan *chan)
 	}
 	list_splice_init(&atchan->free_list, &list);
 	atchan->descs_allocated = 0;
+	atchan->status = 0;
 
 	dev_vdbg(chan2dev(chan), "free_chan_resources: done\n");
 }
@@ -1092,10 +1290,15 @@ static int __init at_dma_probe(struct platform_device *pdev)
 	if (dma_has_cap(DMA_MEMCPY, atdma->dma_common.cap_mask))
 		atdma->dma_common.device_prep_dma_memcpy = atc_prep_dma_memcpy;
 
-	if (dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask)) {
+	if (dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask))
 		atdma->dma_common.device_prep_slave_sg = atc_prep_slave_sg;
+
+	if (dma_has_cap(DMA_CYCLIC, atdma->dma_common.cap_mask))
+		atdma->dma_common.device_prep_dma_cyclic = atc_prep_dma_cyclic;
+
+	if (dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask) ||
+	    dma_has_cap(DMA_CYCLIC, atdma->dma_common.cap_mask))
 		atdma->dma_common.device_control = atc_control;
-	}
 
 	dma_writel(atdma, EN, AT_DMA_ENABLE);
 
diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
index 8303306..c79a9e0 100644
--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -181,12 +181,22 @@ txd_to_at_desc(struct dma_async_tx_descriptor *txd)
 /*--  Channels  --------------------------------------------------------*/
 
 /**
+ * atc_status - information bits stored in channel status flag
+ *
+ * Manipulated with atomic operations.
+ */
+enum atc_status {
+	ATC_IS_ERROR = 0,
+	ATC_IS_CYCLIC = 24,
+};
+
+/**
  * struct at_dma_chan - internal representation of an Atmel HDMAC channel
  * @chan_common: common dmaengine channel object members
  * @device: parent device
  * @ch_regs: memory mapped register base
  * @mask: channel index in a mask
- * @error_status: transmit error status information from irq handler
+ * @status: transmit status information from irq/prep* functions
  *                to tasklet (use atomic operations)
  * @tasklet: bottom half to finish transaction work
  * @lock: serializes enqueue/dequeue operations to descriptors lists
@@ -201,7 +211,7 @@ struct at_dma_chan {
 	struct at_dma		*device;
 	void __iomem		*ch_regs;
 	u8			mask;
-	unsigned long		error_status;
+	unsigned long		status;
 	struct tasklet_struct	tasklet;
 
 	spinlock_t		lock;
-- 
1.7.3

