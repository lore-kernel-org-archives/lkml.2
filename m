Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422824Ab2LFJqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:46:17 -0500
Received: from outmail018.snc4.facebook.com ([66.220.144.152]:63990 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422780Ab2LFJqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:46:12 -0500
Subject: [PATCH 11/12] dmaengine: remove DMA unmap from drivers
To: linux-kernel@vger.kernel.org
From: Dan Williams <djbw@fb.com>
Cc: linux@arm.linux.org.uk,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Vinod Koul <vinod.koul@intel.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dave.jiang@intel.com
Date: Thu, 06 Dec 2012 01:26:11 -0800
Message-ID: <20121206092610.17085.73347.stgit@dev279.prn1.facebook.com>
In-Reply-To: <20121206091055.17085.47979.stgit@dev279.prn1.facebook.com>
References: <20121206091055.17085.47979.stgit@dev279.prn1.facebook.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Remove support for DMA unmapping from drivers as it is no longer
needed (DMA core code is now handling it).

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Dan Williams <djbw@fb.com>
---
 arch/arm/include/asm/hardware/iop3xx-adma.h |   30 ---
 arch/arm/include/asm/hardware/iop_adma.h    |    4 
 arch/arm/mach-iop13xx/include/mach/adma.h   |   26 ---
 drivers/dma/amba-pl08x.c                    |   31 ---
 drivers/dma/at_hdmac.c                      |   25 ---
 drivers/dma/dw_dmac.c                       |   20 --
 drivers/dma/ep93xx_dma.c                    |   29 ---
 drivers/dma/fsldma.c                        |   16 --
 drivers/dma/ioat/dma.c                      |   16 --
 drivers/dma/ioat/dma.h                      |   12 -
 drivers/dma/ioat/dma_v2.c                   |    1 
 drivers/dma/ioat/dma_v3.c                   |  126 -------------
 drivers/dma/iop-adma.c                      |   98 ----------
 drivers/dma/mv_xor.c                        |   45 -----
 drivers/dma/ppc4xx/adma.c                   |  269 ---------------------------
 drivers/dma/timb_dma.c                      |   36 ----
 drivers/dma/txx9dmac.c                      |   24 --
 17 files changed, 3 insertions(+), 805 deletions(-)

diff --git a/arch/arm/include/asm/hardware/iop3xx-adma.h b/arch/arm/include/asm/hardware/iop3xx-adma.h
index 9b28f12..240b29e 100644
--- a/arch/arm/include/asm/hardware/iop3xx-adma.h
+++ b/arch/arm/include/asm/hardware/iop3xx-adma.h
@@ -393,36 +393,6 @@ static inline int iop_chan_zero_sum_slot_count(size_t len, int src_cnt,
 	return slot_cnt;
 }
 
-static inline int iop_desc_is_pq(struct iop_adma_desc_slot *desc)
-{
-	return 0;
-}
-
-static inline u32 iop_desc_get_dest_addr(struct iop_adma_desc_slot *desc,
-					struct iop_adma_chan *chan)
-{
-	union iop3xx_desc hw_desc = { .ptr = desc->hw_desc, };
-
-	switch (chan->device->id) {
-	case DMA0_ID:
-	case DMA1_ID:
-		return hw_desc.dma->dest_addr;
-	case AAU_ID:
-		return hw_desc.aau->dest_addr;
-	default:
-		BUG();
-	}
-	return 0;
-}
-
-
-static inline u32 iop_desc_get_qdest_addr(struct iop_adma_desc_slot *desc,
-					  struct iop_adma_chan *chan)
-{
-	BUG();
-	return 0;
-}
-
 static inline u32 iop_desc_get_byte_count(struct iop_adma_desc_slot *desc,
 					struct iop_adma_chan *chan)
 {
diff --git a/arch/arm/include/asm/hardware/iop_adma.h b/arch/arm/include/asm/hardware/iop_adma.h
index 122f86d..250760e 100644
--- a/arch/arm/include/asm/hardware/iop_adma.h
+++ b/arch/arm/include/asm/hardware/iop_adma.h
@@ -82,8 +82,6 @@ struct iop_adma_chan {
  * @slot_cnt: total slots used in an transaction (group of operations)
  * @slots_per_op: number of slots per operation
  * @idx: pool index
- * @unmap_src_cnt: number of xor sources
- * @unmap_len: transaction bytecount
  * @tx_list: list of descriptors that are associated with one operation
  * @async_tx: support for the async_tx api
  * @group_list: list of slots that make up a multi-descriptor transaction
@@ -99,8 +97,6 @@ struct iop_adma_desc_slot {
 	u16 slot_cnt;
 	u16 slots_per_op;
 	u16 idx;
-	u16 unmap_src_cnt;
-	size_t unmap_len;
 	struct list_head tx_list;
 	struct dma_async_tx_descriptor async_tx;
 	union {
diff --git a/arch/arm/mach-iop13xx/include/mach/adma.h b/arch/arm/mach-iop13xx/include/mach/adma.h
index 6d3782d..a86fd0e 100644
--- a/arch/arm/mach-iop13xx/include/mach/adma.h
+++ b/arch/arm/mach-iop13xx/include/mach/adma.h
@@ -218,20 +218,6 @@ iop_chan_xor_slot_count(size_t len, int src_cnt, int *slots_per_op)
 #define iop_chan_pq_slot_count iop_chan_xor_slot_count
 #define iop_chan_pq_zero_sum_slot_count iop_chan_xor_slot_count
 
-static inline u32 iop_desc_get_dest_addr(struct iop_adma_desc_slot *desc,
-					struct iop_adma_chan *chan)
-{
-	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
-	return hw_desc->dest_addr;
-}
-
-static inline u32 iop_desc_get_qdest_addr(struct iop_adma_desc_slot *desc,
-					  struct iop_adma_chan *chan)
-{
-	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
-	return hw_desc->q_dest_addr;
-}
-
 static inline u32 iop_desc_get_byte_count(struct iop_adma_desc_slot *desc,
 					struct iop_adma_chan *chan)
 {
@@ -350,18 +336,6 @@ iop_desc_init_pq(struct iop_adma_desc_slot *desc, int src_cnt,
 	hw_desc->desc_ctrl = u_desc_ctrl.value;
 }
 
-static inline int iop_desc_is_pq(struct iop_adma_desc_slot *desc)
-{
-	struct iop13xx_adma_desc_hw *hw_desc = desc->hw_desc;
-	union {
-		u32 value;
-		struct iop13xx_adma_desc_ctrl field;
-	} u_desc_ctrl;
-
-	u_desc_ctrl.value = hw_desc->desc_ctrl;
-	return u_desc_ctrl.field.pq_xfer_en;
-}
-
 static inline void
 iop_desc_init_pq_zero_sum(struct iop_adma_desc_slot *desc, int src_cnt,
 			  unsigned long flags)
diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 4cb2f23..6ff6547 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1050,43 +1050,12 @@ static void pl08x_free_txd(struct pl08x_driver_data *pl08x,
 	kfree(txd);
 }
 
-static void pl08x_unmap_buffers(struct pl08x_txd *txd)
-{
-	struct device *dev = txd->vd.tx.chan->device->dev;
-	struct pl08x_sg *dsg;
-
-	if (!(txd->vd.tx.flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-		if (txd->vd.tx.flags & DMA_COMPL_SRC_UNMAP_SINGLE)
-			list_for_each_entry(dsg, &txd->dsg_list, node)
-				dma_unmap_single(dev, dsg->src_addr, dsg->len,
-						DMA_TO_DEVICE);
-		else {
-			list_for_each_entry(dsg, &txd->dsg_list, node)
-				dma_unmap_page(dev, dsg->src_addr, dsg->len,
-						DMA_TO_DEVICE);
-		}
-	}
-	if (!(txd->vd.tx.flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
-		if (txd->vd.tx.flags & DMA_COMPL_DEST_UNMAP_SINGLE)
-			list_for_each_entry(dsg, &txd->dsg_list, node)
-				dma_unmap_single(dev, dsg->dst_addr, dsg->len,
-						DMA_FROM_DEVICE);
-		else
-			list_for_each_entry(dsg, &txd->dsg_list, node)
-				dma_unmap_page(dev, dsg->dst_addr, dsg->len,
-						DMA_FROM_DEVICE);
-	}
-}
-
 static void pl08x_desc_free(struct virt_dma_desc *vd)
 {
 	struct pl08x_txd *txd = to_pl08x_txd(&vd->tx);
 	struct pl08x_dma_chan *plchan = to_pl08x_chan(vd->tx.chan);
 
 	dma_descriptor_unmap(txd);
-	if (!plchan->slave)
-		pl08x_unmap_buffers(txd);
-
 	if (!txd->done)
 		pl08x_release_mux(plchan);
 
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 280ce87..154f9df 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -252,32 +252,7 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 	/* move myself to free_list */
 	list_move(&desc->desc_node, &atchan->free_list);
 
-	/* unmap dma addresses (not on slave channels) */
 	dma_descriptor_unmap(txd);
-	if (!atchan->chan_common.private) {
-		struct device *parent = chan2parent(&atchan->chan_common);
-		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
-			if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
-				dma_unmap_single(parent,
-						desc->lli.daddr,
-						desc->len, DMA_FROM_DEVICE);
-			else
-				dma_unmap_page(parent,
-						desc->lli.daddr,
-						desc->len, DMA_FROM_DEVICE);
-		}
-		if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-			if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
-				dma_unmap_single(parent,
-						desc->lli.saddr,
-						desc->len, DMA_TO_DEVICE);
-			else
-				dma_unmap_page(parent,
-						desc->lli.saddr,
-						desc->len, DMA_TO_DEVICE);
-		}
-	}
-
 	/* for cyclic transfers,
 	 * no need to replay callback function while stopping */
 	if (!atc_chan_is_cyclic(atchan)) {
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 5d0b58c..f626deb 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -327,26 +327,6 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
 	list_move(&desc->desc_node, &dwc->free_list);
 
 	dma_descriptor_unmap(txd);
-	if (!dwc->chan.private) {
-		struct device *parent = chan2parent(&dwc->chan);
-		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
-			if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
-				dma_unmap_single(parent, desc->lli.dar,
-						desc->len, DMA_FROM_DEVICE);
-			else
-				dma_unmap_page(parent, desc->lli.dar,
-						desc->len, DMA_FROM_DEVICE);
-		}
-		if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-			if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
-				dma_unmap_single(parent, desc->lli.sar,
-						desc->len, DMA_TO_DEVICE);
-			else
-				dma_unmap_page(parent, desc->lli.sar,
-						desc->len, DMA_TO_DEVICE);
-		}
-	}
-
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	if (callback_required && callback)
diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index 5d08aeb..493392e 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -733,28 +733,6 @@ static void ep93xx_dma_advance_work(struct ep93xx_dma_chan *edmac)
 	spin_unlock_irqrestore(&edmac->lock, flags);
 }
 
-static void ep93xx_dma_unmap_buffers(struct ep93xx_dma_desc *desc)
-{
-	struct device *dev = desc->txd.chan->device->dev;
-
-	if (!(desc->txd.flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-		if (desc->txd.flags & DMA_COMPL_SRC_UNMAP_SINGLE)
-			dma_unmap_single(dev, desc->src_addr, desc->size,
-					 DMA_TO_DEVICE);
-		else
-			dma_unmap_page(dev, desc->src_addr, desc->size,
-				       DMA_TO_DEVICE);
-	}
-	if (!(desc->txd.flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
-		if (desc->txd.flags & DMA_COMPL_DEST_UNMAP_SINGLE)
-			dma_unmap_single(dev, desc->dst_addr, desc->size,
-					 DMA_FROM_DEVICE);
-		else
-			dma_unmap_page(dev, desc->dst_addr, desc->size,
-				       DMA_FROM_DEVICE);
-	}
-}
-
 static void ep93xx_dma_tasklet(unsigned long data)
 {
 	struct ep93xx_dma_chan *edmac = (struct ep93xx_dma_chan *)data;
@@ -787,14 +765,7 @@ static void ep93xx_dma_tasklet(unsigned long data)
 
 	/* Now we can release all the chained descriptors */
 	list_for_each_entry_safe(desc, d, &list, node) {
-		/*
-		 * For the memcpy channels the API requires us to unmap the
-		 * buffers unless requested otherwise.
-		 */
 		dma_descriptor_unmap(&desc->txd);
-		if (!edmac->chan.private)
-			ep93xx_dma_unmap_buffers(desc);
-
 		ep93xx_dma_desc_put(edmac, desc);
 	}
 
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 7e4e44c..e3aad8d 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -869,22 +869,6 @@ static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
 	dma_run_dependencies(txd);
 
 	dma_descriptor_unmap(txd);
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
 #ifdef FSL_DMA_LD_DEBUG
 	chan_dbg(chan, "LD %p free\n", desc);
 #endif
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 38918cf..b01df57 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -531,21 +531,6 @@ static void ioat1_cleanup_event(unsigned long data)
 	writew(IOAT_CHANCTRL_RUN, ioat->base.reg_base + IOAT_CHANCTRL_OFFSET);
 }
 
-void ioat_dma_unmap(struct ioat_chan_common *chan, enum dma_ctrl_flags flags,
-		    size_t len, struct ioat_dma_descriptor *hw)
-{
-	struct pci_dev *pdev = chan->device->pdev;
-	size_t offset = len - hw->size;
-
-	if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP))
-		ioat_unmap(pdev, hw->dst_addr - offset, len,
-			   PCI_DMA_FROMDEVICE, flags, 1);
-
-	if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP))
-		ioat_unmap(pdev, hw->src_addr - offset, len,
-			   PCI_DMA_TODEVICE, flags, 0);
-}
-
 dma_addr_t ioat_get_current_completion(struct ioat_chan_common *chan)
 {
 	dma_addr_t phys_complete;
@@ -603,7 +588,6 @@ static void __cleanup(struct ioat_dma_chan *ioat, dma_addr_t phys_complete)
 		if (tx->cookie) {
 			dma_cookie_complete(tx);
 			dma_descriptor_unmap(tx);
-			ioat_dma_unmap(chan, tx->flags, desc->len, desc->hw);
 			ioat->active -= desc->hw->tx_cnt;
 			if (tx->callback) {
 				tx->callback(tx->callback_param);
diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 5e8fe01..4e9e027 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -293,16 +293,6 @@ static inline bool is_ioat_bug(unsigned long err)
 	return !!err;
 }
 
-static inline void ioat_unmap(struct pci_dev *pdev, dma_addr_t addr, size_t len,
-			      int direction, enum dma_ctrl_flags flags, bool dst)
-{
-	if ((dst && (flags & DMA_COMPL_DEST_UNMAP_SINGLE)) ||
-	    (!dst && (flags & DMA_COMPL_SRC_UNMAP_SINGLE)))
-		pci_unmap_single(pdev, addr, len, direction);
-	else
-		pci_unmap_page(pdev, addr, len, direction);
-}
-
 int __devinit ioat_probe(struct ioatdma_device *device);
 int __devinit ioat_register(struct ioatdma_device *device);
 int __devinit ioat1_dma_probe(struct ioatdma_device *dev, int dca);
@@ -315,8 +305,6 @@ void ioat_init_channel(struct ioatdma_device *device,
 		       struct ioat_chan_common *chan, int idx);
 enum dma_status ioat_dma_tx_status(struct dma_chan *c, dma_cookie_t cookie,
 				   struct dma_tx_state *txstate);
-void ioat_dma_unmap(struct ioat_chan_common *chan, enum dma_ctrl_flags flags,
-		    size_t len, struct ioat_dma_descriptor *hw);
 bool ioat_cleanup_preamble(struct ioat_chan_common *chan,
 			   dma_addr_t *phys_complete);
 void ioat_kobject_add(struct ioatdma_device *device, struct kobj_type *type);
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 2714b0e..e786ef6 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -149,7 +149,6 @@ static void __cleanup(struct ioat2_dma_chan *ioat, dma_addr_t phys_complete)
 		dump_desc_dbg(ioat, desc);
 		if (tx->cookie) {
 			dma_descriptor_unmap(tx);
-			ioat_dma_unmap(chan, tx->flags, desc->len, desc->hw);
 			dma_cookie_complete(tx);
 			if (tx->callback) {
 				tx->callback(tx->callback_param);
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 70385d5..cdf37ff 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -79,13 +79,6 @@ static const u8 xor_idx_to_field[] = { 1, 4, 5, 6, 7, 0, 1, 2 };
 static const u8 pq_idx_to_desc = 0xf8;
 static const u8 pq_idx_to_field[] = { 1, 4, 5, 0, 1, 2, 4, 5 };
 
-static dma_addr_t xor_get_src(struct ioat_raw_descriptor *descs[2], int idx)
-{
-	struct ioat_raw_descriptor *raw = descs[xor_idx_to_desc >> idx & 1];
-
-	return raw->field[xor_idx_to_field[idx]];
-}
-
 static void xor_set_src(struct ioat_raw_descriptor *descs[2],
 			dma_addr_t addr, u32 offset, int idx)
 {
@@ -111,124 +104,6 @@ static void pq_set_src(struct ioat_raw_descriptor *descs[2],
 	pq->coef[idx] = coef;
 }
 
-static void ioat3_dma_unmap(struct ioat2_dma_chan *ioat,
-			    struct ioat_ring_ent *desc, int idx)
-{
-	struct ioat_chan_common *chan = &ioat->base;
-	struct pci_dev *pdev = chan->device->pdev;
-	size_t len = desc->len;
-	size_t offset = len - desc->hw->size;
-	struct dma_async_tx_descriptor *tx = &desc->txd;
-	enum dma_ctrl_flags flags = tx->flags;
-
-	switch (desc->hw->ctl_f.op) {
-	case IOAT_OP_COPY:
-		if (!desc->hw->ctl_f.null) /* skip 'interrupt' ops */
-			ioat_dma_unmap(chan, flags, len, desc->hw);
-		break;
-	case IOAT_OP_FILL: {
-		struct ioat_fill_descriptor *hw = desc->fill;
-
-		if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP))
-			ioat_unmap(pdev, hw->dst_addr - offset, len,
-				   PCI_DMA_FROMDEVICE, flags, 1);
-		break;
-	}
-	case IOAT_OP_XOR_VAL:
-	case IOAT_OP_XOR: {
-		struct ioat_xor_descriptor *xor = desc->xor;
-		struct ioat_ring_ent *ext;
-		struct ioat_xor_ext_descriptor *xor_ex = NULL;
-		int src_cnt = src_cnt_to_sw(xor->ctl_f.src_cnt);
-		struct ioat_raw_descriptor *descs[2];
-		int i;
-
-		if (src_cnt > 5) {
-			ext = ioat2_get_ring_ent(ioat, idx + 1);
-			xor_ex = ext->xor_ex;
-		}
-
-		if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-			descs[0] = (struct ioat_raw_descriptor *) xor;
-			descs[1] = (struct ioat_raw_descriptor *) xor_ex;
-			for (i = 0; i < src_cnt; i++) {
-				dma_addr_t src = xor_get_src(descs, i);
-
-				ioat_unmap(pdev, src - offset, len,
-					   PCI_DMA_TODEVICE, flags, 0);
-			}
-
-			/* dest is a source in xor validate operations */
-			if (xor->ctl_f.op == IOAT_OP_XOR_VAL) {
-				ioat_unmap(pdev, xor->dst_addr - offset, len,
-					   PCI_DMA_TODEVICE, flags, 1);
-				break;
-			}
-		}
-
-		if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP))
-			ioat_unmap(pdev, xor->dst_addr - offset, len,
-				   PCI_DMA_FROMDEVICE, flags, 1);
-		break;
-	}
-	case IOAT_OP_PQ_VAL:
-	case IOAT_OP_PQ: {
-		struct ioat_pq_descriptor *pq = desc->pq;
-		struct ioat_ring_ent *ext;
-		struct ioat_pq_ext_descriptor *pq_ex = NULL;
-		int src_cnt = src_cnt_to_sw(pq->ctl_f.src_cnt);
-		struct ioat_raw_descriptor *descs[2];
-		int i;
-
-		if (src_cnt > 3) {
-			ext = ioat2_get_ring_ent(ioat, idx + 1);
-			pq_ex = ext->pq_ex;
-		}
-
-		/* in the 'continue' case don't unmap the dests as sources */
-		if (dmaf_p_disabled_continue(flags))
-			src_cnt--;
-		else if (dmaf_continue(flags))
-			src_cnt -= 3;
-
-		if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-			descs[0] = (struct ioat_raw_descriptor *) pq;
-			descs[1] = (struct ioat_raw_descriptor *) pq_ex;
-			for (i = 0; i < src_cnt; i++) {
-				dma_addr_t src = pq_get_src(descs, i);
-
-				ioat_unmap(pdev, src - offset, len,
-					   PCI_DMA_TODEVICE, flags, 0);
-			}
-
-			/* the dests are sources in pq validate operations */
-			if (pq->ctl_f.op == IOAT_OP_XOR_VAL) {
-				if (!(flags & DMA_PREP_PQ_DISABLE_P))
-					ioat_unmap(pdev, pq->p_addr - offset,
-						   len, PCI_DMA_TODEVICE, flags, 0);
-				if (!(flags & DMA_PREP_PQ_DISABLE_Q))
-					ioat_unmap(pdev, pq->q_addr - offset,
-						   len, PCI_DMA_TODEVICE, flags, 0);
-				break;
-			}
-		}
-
-		if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
-			if (!(flags & DMA_PREP_PQ_DISABLE_P))
-				ioat_unmap(pdev, pq->p_addr - offset, len,
-					   PCI_DMA_BIDIRECTIONAL, flags, 1);
-			if (!(flags & DMA_PREP_PQ_DISABLE_Q))
-				ioat_unmap(pdev, pq->q_addr - offset, len,
-					   PCI_DMA_BIDIRECTIONAL, flags, 1);
-		}
-		break;
-	}
-	default:
-		dev_err(&pdev->dev, "%s: unknown op type: %#x\n",
-			__func__, desc->hw->ctl_f.op);
-	}
-}
-
 static bool desc_has_ext(struct ioat_ring_ent *desc)
 {
 	struct ioat_dma_descriptor *hw = desc->hw;
@@ -280,7 +155,6 @@ static void __cleanup(struct ioat2_dma_chan *ioat, dma_addr_t phys_complete)
 		if (tx->cookie) {
 			dma_cookie_complete(tx);
 			dma_descriptor_unmap(tx);
-			ioat3_dma_unmap(ioat, desc, idx + i);
 			if (tx->callback) {
 				tx->callback(tx->callback_param);
 				tx->callback = NULL;
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 32f5d46..4175bb2 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -61,80 +61,6 @@ static void iop_adma_free_slots(struct iop_adma_desc_slot *slot)
 	}
 }
 
-static void
-iop_desc_unmap(struct iop_adma_chan *iop_chan, struct iop_adma_desc_slot *desc)
-{
-	struct dma_async_tx_descriptor *tx = &desc->async_tx;
-	struct iop_adma_desc_slot *unmap = desc->group_head;
-	struct device *dev = &iop_chan->device->pdev->dev;
-	u32 len = unmap->unmap_len;
-	enum dma_ctrl_flags flags = tx->flags;
-	u32 src_cnt;
-	dma_addr_t addr;
-	dma_addr_t dest;
-
-	src_cnt = unmap->unmap_src_cnt;
-	dest = iop_desc_get_dest_addr(unmap, iop_chan);
-	if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
-		enum dma_data_direction dir;
-
-		if (src_cnt > 1) /* is xor? */
-			dir = DMA_BIDIRECTIONAL;
-		else
-			dir = DMA_FROM_DEVICE;
-
-		dma_unmap_page(dev, dest, len, dir);
-	}
-
-	if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-		while (src_cnt--) {
-			addr = iop_desc_get_src_addr(unmap, iop_chan, src_cnt);
-			if (addr == dest)
-				continue;
-			dma_unmap_page(dev, addr, len, DMA_TO_DEVICE);
-		}
-	}
-	desc->group_head = NULL;
-}
-
-static void
-iop_desc_unmap_pq(struct iop_adma_chan *iop_chan, struct iop_adma_desc_slot *desc)
-{
-	struct dma_async_tx_descriptor *tx = &desc->async_tx;
-	struct iop_adma_desc_slot *unmap = desc->group_head;
-	struct device *dev = &iop_chan->device->pdev->dev;
-	u32 len = unmap->unmap_len;
-	enum dma_ctrl_flags flags = tx->flags;
-	u32 src_cnt = unmap->unmap_src_cnt;
-	dma_addr_t pdest = iop_desc_get_dest_addr(unmap, iop_chan);
-	dma_addr_t qdest = iop_desc_get_qdest_addr(unmap, iop_chan);
-	int i;
-
-	if (tx->flags & DMA_PREP_CONTINUE)
-		src_cnt -= 3;
-
-	if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP) && !desc->pq_check_result) {
-		dma_unmap_page(dev, pdest, len, DMA_BIDIRECTIONAL);
-		dma_unmap_page(dev, qdest, len, DMA_BIDIRECTIONAL);
-	}
-
-	if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-		dma_addr_t addr;
-
-		for (i = 0; i < src_cnt; i++) {
-			addr = iop_desc_get_src_addr(unmap, iop_chan, i);
-			dma_unmap_page(dev, addr, len, DMA_TO_DEVICE);
-		}
-		if (desc->pq_check_result) {
-			dma_unmap_page(dev, pdest, len, DMA_TO_DEVICE);
-			dma_unmap_page(dev, qdest, len, DMA_TO_DEVICE);
-		}
-	}
-
-	desc->group_head = NULL;
-}
-
-
 static dma_cookie_t
 iop_adma_run_tx_complete_actions(struct iop_adma_desc_slot *desc,
 	struct iop_adma_chan *iop_chan, dma_cookie_t cookie)
@@ -153,15 +79,8 @@ iop_adma_run_tx_complete_actions(struct iop_adma_desc_slot *desc,
 			tx->callback(tx->callback_param);
 
 		dma_descriptor_unmap(tx);
-		/* unmap dma addresses
-		 * (unmap_single vs unmap_page?)
-		 */
-		if (desc->group_head && desc->unmap_len) {
-			if (iop_desc_is_pq(desc))
-				iop_desc_unmap_pq(iop_chan, desc);
-			else
-				iop_desc_unmap(iop_chan, desc);
-		}
+		if (desc->group_head)
+			desc->group_head = NULL;
 	}
 
 	/* run dependent operations */
@@ -592,7 +511,6 @@ iop_adma_prep_dma_interrupt(struct dma_chan *chan, unsigned long flags)
 	if (sw_desc) {
 		grp_start = sw_desc->group_head;
 		iop_desc_init_interrupt(grp_start, iop_chan);
-		grp_start->unmap_len = 0;
 		sw_desc->async_tx.flags = flags;
 	}
 	spin_unlock_bh(&iop_chan->lock);
@@ -624,8 +542,6 @@ iop_adma_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dma_dest,
 		iop_desc_set_byte_count(grp_start, iop_chan, len);
 		iop_desc_set_dest_addr(grp_start, iop_chan, dma_dest);
 		iop_desc_set_memcpy_src_addr(grp_start, dma_src);
-		sw_desc->unmap_src_cnt = 1;
-		sw_desc->unmap_len = len;
 		sw_desc->async_tx.flags = flags;
 	}
 	spin_unlock_bh(&iop_chan->lock);
@@ -657,8 +573,6 @@ iop_adma_prep_dma_memset(struct dma_chan *chan, dma_addr_t dma_dest,
 		iop_desc_set_byte_count(grp_start, iop_chan, len);
 		iop_desc_set_block_fill_val(grp_start, value);
 		iop_desc_set_dest_addr(grp_start, iop_chan, dma_dest);
-		sw_desc->unmap_src_cnt = 1;
-		sw_desc->unmap_len = len;
 		sw_desc->async_tx.flags = flags;
 	}
 	spin_unlock_bh(&iop_chan->lock);
@@ -691,8 +605,6 @@ iop_adma_prep_dma_xor(struct dma_chan *chan, dma_addr_t dma_dest,
 		iop_desc_init_xor(grp_start, src_cnt, flags);
 		iop_desc_set_byte_count(grp_start, iop_chan, len);
 		iop_desc_set_dest_addr(grp_start, iop_chan, dma_dest);
-		sw_desc->unmap_src_cnt = src_cnt;
-		sw_desc->unmap_len = len;
 		sw_desc->async_tx.flags = flags;
 		while (src_cnt--)
 			iop_desc_set_xor_src_addr(grp_start, src_cnt,
@@ -728,8 +640,6 @@ iop_adma_prep_dma_xor_val(struct dma_chan *chan, dma_addr_t *dma_src,
 		grp_start->xor_check_result = result;
 		pr_debug("\t%s: grp_start->xor_check_result: %p\n",
 			__func__, grp_start->xor_check_result);
-		sw_desc->unmap_src_cnt = src_cnt;
-		sw_desc->unmap_len = len;
 		sw_desc->async_tx.flags = flags;
 		while (src_cnt--)
 			iop_desc_set_zero_sum_src_addr(grp_start, src_cnt,
@@ -782,8 +692,6 @@ iop_adma_prep_dma_pq(struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
 			dst[0] = dst[1] & 0x7;
 
 		iop_desc_set_pq_addr(g, dst);
-		sw_desc->unmap_src_cnt = src_cnt;
-		sw_desc->unmap_len = len;
 		sw_desc->async_tx.flags = flags;
 		for (i = 0; i < src_cnt; i++)
 			iop_desc_set_pq_src_addr(g, i, src[i], scf[i]);
@@ -838,8 +746,6 @@ iop_adma_prep_dma_pq_val(struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
 		g->pq_check_result = pqres;
 		pr_debug("\t%s: g->pq_check_result: %p\n",
 			__func__, g->pq_check_result);
-		sw_desc->unmap_src_cnt = src_cnt+2;
-		sw_desc->unmap_len = len;
 		sw_desc->async_tx.flags = flags;
 		while (src_cnt--)
 			iop_desc_set_pq_zero_sum_src_addr(g, src_cnt,
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 4a5c073..7d0ba4a 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -57,14 +57,6 @@ static u32 mv_desc_get_dest_addr(struct mv_xor_desc_slot *desc)
 	return hw_desc->phy_dest_addr;
 }
 
-static u32 mv_desc_get_src_addr(struct mv_xor_desc_slot *desc,
-				int src_idx)
-{
-	struct mv_xor_desc *hw_desc = desc->hw_desc;
-	return hw_desc->phy_src_addr[src_idx];
-}
-
-
 static void mv_desc_set_byte_count(struct mv_xor_desc_slot *desc,
 				   u32 byte_count)
 {
@@ -304,43 +296,8 @@ mv_xor_run_tx_complete_actions(struct mv_xor_desc_slot *desc,
 				desc->async_tx.callback_param);
 
 		dma_descriptor_unmap(&desc->async_tx);
-		/* unmap dma addresses
-		 * (unmap_single vs unmap_page?)
-		 */
-		if (desc->group_head && desc->unmap_len) {
-			struct mv_xor_desc_slot *unmap = desc->group_head;
-			struct device *dev =
-				&mv_chan->device->pdev->dev;
-			u32 len = unmap->unmap_len;
-			enum dma_ctrl_flags flags = desc->async_tx.flags;
-			u32 src_cnt;
-			dma_addr_t addr;
-			dma_addr_t dest;
-
-			src_cnt = unmap->unmap_src_cnt;
-			dest = mv_desc_get_dest_addr(unmap);
-			if (!(flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
-				enum dma_data_direction dir;
-
-				if (src_cnt > 1) /* is xor ? */
-					dir = DMA_BIDIRECTIONAL;
-				else
-					dir = DMA_FROM_DEVICE;
-				dma_unmap_page(dev, dest, len, dir);
-			}
-
-			if (!(flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-				while (src_cnt--) {
-					addr = mv_desc_get_src_addr(unmap,
-								    src_cnt);
-					if (addr == dest)
-						continue;
-					dma_unmap_page(dev, addr, len,
-						       DMA_TO_DEVICE);
-				}
-			}
+		if (desc->group_head)
 			desc->group_head = NULL;
-		}
 	}
 
 	/* run dependent operations */
diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index 883b343..4c7f53b 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -802,218 +802,6 @@ static void ppc440spe_desc_set_link(struct ppc440spe_adma_chan *chan,
 }
 
 /**
- * ppc440spe_desc_get_src_addr - extract the source address from the descriptor
- */
-static u32 ppc440spe_desc_get_src_addr(struct ppc440spe_adma_desc_slot *desc,
-				struct ppc440spe_adma_chan *chan, int src_idx)
-{
-	struct dma_cdb *dma_hw_desc;
-	struct xor_cb *xor_hw_desc;
-
-	switch (chan->device->id) {
-	case PPC440SPE_DMA0_ID:
-	case PPC440SPE_DMA1_ID:
-		dma_hw_desc = desc->hw_desc;
-		/* May have 0, 1, 2, or 3 sources */
-		switch (dma_hw_desc->opc) {
-		case DMA_CDB_OPC_NO_OP:
-		case DMA_CDB_OPC_DFILL128:
-			return 0;
-		case DMA_CDB_OPC_DCHECK128:
-			if (unlikely(src_idx)) {
-				printk(KERN_ERR "%s: try to get %d source for"
-				    " DCHECK128\n", __func__, src_idx);
-				BUG();
-			}
-			return le32_to_cpu(dma_hw_desc->sg1l);
-		case DMA_CDB_OPC_MULTICAST:
-		case DMA_CDB_OPC_MV_SG1_SG2:
-			if (unlikely(src_idx > 2)) {
-				printk(KERN_ERR "%s: try to get %d source from"
-				    " DMA descr\n", __func__, src_idx);
-				BUG();
-			}
-			if (src_idx) {
-				if (le32_to_cpu(dma_hw_desc->sg1u) &
-				    DMA_CUED_XOR_WIN_MSK) {
-					u8 region;
-
-					if (src_idx == 1)
-						return le32_to_cpu(
-						    dma_hw_desc->sg1l) +
-							desc->unmap_len;
-
-					region = (le32_to_cpu(
-					    dma_hw_desc->sg1u)) >>
-						DMA_CUED_REGION_OFF;
-
-					region &= DMA_CUED_REGION_MSK;
-					switch (region) {
-					case DMA_RXOR123:
-						return le32_to_cpu(
-						    dma_hw_desc->sg1l) +
-							(desc->unmap_len << 1);
-					case DMA_RXOR124:
-						return le32_to_cpu(
-						    dma_hw_desc->sg1l) +
-							(desc->unmap_len * 3);
-					case DMA_RXOR125:
-						return le32_to_cpu(
-						    dma_hw_desc->sg1l) +
-							(desc->unmap_len << 2);
-					default:
-						printk(KERN_ERR
-						    "%s: try to"
-						    " get src3 for region %02x"
-						    "PPC440SPE_DESC_RXOR12?\n",
-						    __func__, region);
-						BUG();
-					}
-				} else {
-					printk(KERN_ERR
-						"%s: try to get %d"
-						" source for non-cued descr\n",
-						__func__, src_idx);
-					BUG();
-				}
-			}
-			return le32_to_cpu(dma_hw_desc->sg1l);
-		default:
-			printk(KERN_ERR "%s: unknown OPC 0x%02x\n",
-				__func__, dma_hw_desc->opc);
-			BUG();
-		}
-		return le32_to_cpu(dma_hw_desc->sg1l);
-	case PPC440SPE_XOR_ID:
-		/* May have up to 16 sources */
-		xor_hw_desc = desc->hw_desc;
-		return xor_hw_desc->ops[src_idx].l;
-	}
-	return 0;
-}
-
-/**
- * ppc440spe_desc_get_dest_addr - extract the destination address from the
- * descriptor
- */
-static u32 ppc440spe_desc_get_dest_addr(struct ppc440spe_adma_desc_slot *desc,
-				struct ppc440spe_adma_chan *chan, int idx)
-{
-	struct dma_cdb *dma_hw_desc;
-	struct xor_cb *xor_hw_desc;
-
-	switch (chan->device->id) {
-	case PPC440SPE_DMA0_ID:
-	case PPC440SPE_DMA1_ID:
-		dma_hw_desc = desc->hw_desc;
-
-		if (likely(!idx))
-			return le32_to_cpu(dma_hw_desc->sg2l);
-		return le32_to_cpu(dma_hw_desc->sg3l);
-	case PPC440SPE_XOR_ID:
-		xor_hw_desc = desc->hw_desc;
-		return xor_hw_desc->cbtal;
-	}
-	return 0;
-}
-
-/**
- * ppc440spe_desc_get_src_num - extract the number of source addresses from
- * the descriptor
- */
-static u32 ppc440spe_desc_get_src_num(struct ppc440spe_adma_desc_slot *desc,
-				struct ppc440spe_adma_chan *chan)
-{
-	struct dma_cdb *dma_hw_desc;
-	struct xor_cb *xor_hw_desc;
-
-	switch (chan->device->id) {
-	case PPC440SPE_DMA0_ID:
-	case PPC440SPE_DMA1_ID:
-		dma_hw_desc = desc->hw_desc;
-
-		switch (dma_hw_desc->opc) {
-		case DMA_CDB_OPC_NO_OP:
-		case DMA_CDB_OPC_DFILL128:
-			return 0;
-		case DMA_CDB_OPC_DCHECK128:
-			return 1;
-		case DMA_CDB_OPC_MV_SG1_SG2:
-		case DMA_CDB_OPC_MULTICAST:
-			/*
-			 * Only for RXOR operations we have more than
-			 * one source
-			 */
-			if (le32_to_cpu(dma_hw_desc->sg1u) &
-			    DMA_CUED_XOR_WIN_MSK) {
-				/* RXOR op, there are 2 or 3 sources */
-				if (((le32_to_cpu(dma_hw_desc->sg1u) >>
-				    DMA_CUED_REGION_OFF) &
-				      DMA_CUED_REGION_MSK) == DMA_RXOR12) {
-					/* RXOR 1-2 */
-					return 2;
-				} else {
-					/* RXOR 1-2-3/1-2-4/1-2-5 */
-					return 3;
-				}
-			}
-			return 1;
-		default:
-			printk(KERN_ERR "%s: unknown OPC 0x%02x\n",
-				__func__, dma_hw_desc->opc);
-			BUG();
-		}
-	case PPC440SPE_XOR_ID:
-		/* up to 16 sources */
-		xor_hw_desc = desc->hw_desc;
-		return xor_hw_desc->cbc & XOR_CDCR_OAC_MSK;
-	default:
-		BUG();
-	}
-	return 0;
-}
-
-/**
- * ppc440spe_desc_get_dst_num - get the number of destination addresses in
- * this descriptor
- */
-static u32 ppc440spe_desc_get_dst_num(struct ppc440spe_adma_desc_slot *desc,
-				struct ppc440spe_adma_chan *chan)
-{
-	struct dma_cdb *dma_hw_desc;
-
-	switch (chan->device->id) {
-	case PPC440SPE_DMA0_ID:
-	case PPC440SPE_DMA1_ID:
-		/* May be 1 or 2 destinations */
-		dma_hw_desc = desc->hw_desc;
-		switch (dma_hw_desc->opc) {
-		case DMA_CDB_OPC_NO_OP:
-		case DMA_CDB_OPC_DCHECK128:
-			return 0;
-		case DMA_CDB_OPC_MV_SG1_SG2:
-		case DMA_CDB_OPC_DFILL128:
-			return 1;
-		case DMA_CDB_OPC_MULTICAST:
-			if (desc->dst_cnt == 2)
-				return 2;
-			else
-				return 1;
-		default:
-			printk(KERN_ERR "%s: unknown OPC 0x%02x\n",
-				__func__, dma_hw_desc->opc);
-			BUG();
-		}
-	case PPC440SPE_XOR_ID:
-		/* Always only 1 destination */
-		return 1;
-	default:
-		BUG();
-	}
-	return 0;
-}
-
-/**
  * ppc440spe_desc_get_link - get the address of the descriptor that
  * follows this one
  */
@@ -1705,43 +1493,6 @@ static void ppc440spe_adma_free_slots(struct ppc440spe_adma_desc_slot *slot,
 	}
 }
 
-static void ppc440spe_adma_unmap(struct ppc440spe_adma_chan *chan,
-				 struct ppc440spe_adma_desc_slot *desc)
-{
-	u32 src_cnt, dst_cnt;
-	dma_addr_t addr;
-
-	/*
-	 * get the number of sources & destination
-	 * included in this descriptor and unmap
-	 * them all
-	 */
-	src_cnt = ppc440spe_desc_get_src_num(desc, chan);
-	dst_cnt = ppc440spe_desc_get_dst_num(desc, chan);
-
-	/* unmap destinations */
-	if (!(desc->async_tx.flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
-		while (dst_cnt--) {
-			addr = ppc440spe_desc_get_dest_addr(
-				desc, chan, dst_cnt);
-			dma_unmap_page(chan->device->dev,
-					addr, desc->unmap_len,
-					DMA_FROM_DEVICE);
-		}
-	}
-
-	/* unmap sources */
-	if (!(desc->async_tx.flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-		while (src_cnt--) {
-			addr = ppc440spe_desc_get_src_addr(
-				desc, chan, src_cnt);
-			dma_unmap_page(chan->device->dev,
-					addr, desc->unmap_len,
-					DMA_TO_DEVICE);
-		}
-	}
-}
-
 /**
  * ppc440spe_adma_run_tx_complete_actions - call functions to be called
  * upon completion
@@ -1766,26 +1517,6 @@ static dma_cookie_t ppc440spe_adma_run_tx_complete_actions(
 				desc->async_tx.callback_param);
 
 		dma_descriptor_unmap(&desc->async_tx);
-		/* unmap dma addresses
-		 * (unmap_single vs unmap_page?)
-		 *
-		 * actually, ppc's dma_unmap_page() functions are empty, so
-		 * the following code is just for the sake of completeness
-		 */
-		if (chan && chan->needs_unmap && desc->group_head &&
-		     desc->unmap_len) {
-			struct ppc440spe_adma_desc_slot *unmap =
-							desc->group_head;
-			/* assume 1 slot per op always */
-			u32 slot_count = unmap->slot_cnt;
-
-			/* Run through the group list and unmap addresses */
-			for (i = 0; i < slot_count; i++) {
-				BUG_ON(!unmap);
-				ppc440spe_adma_unmap(chan, unmap);
-				unmap = unmap->hw_next;
-			}
-		}
 	}
 
 	/* run dependent operations */
diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 4b82112..866a97c 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -154,38 +154,6 @@ static bool __td_dma_done_ack(struct timb_dma_chan *td_chan)
 	return done;
 }
 
-static void __td_unmap_desc(struct timb_dma_chan *td_chan, const u8 *dma_desc,
-	bool single)
-{
-	dma_addr_t addr;
-	int len;
-
-	addr = (dma_desc[7] << 24) | (dma_desc[6] << 16) | (dma_desc[5] << 8) |
-		dma_desc[4];
-
-	len = (dma_desc[3] << 8) | dma_desc[2];
-
-	if (single)
-		dma_unmap_single(chan2dev(&td_chan->chan), addr, len,
-			DMA_TO_DEVICE);
-	else
-		dma_unmap_page(chan2dev(&td_chan->chan), addr, len,
-			DMA_TO_DEVICE);
-}
-
-static void __td_unmap_descs(struct timb_dma_desc *td_desc, bool single)
-{
-	struct timb_dma_chan *td_chan = container_of(td_desc->txd.chan,
-		struct timb_dma_chan, chan);
-	u8 *descs;
-
-	for (descs = td_desc->desc_list; ; descs += TIMB_DMA_DESC_SIZE) {
-		__td_unmap_desc(td_chan, descs, single);
-		if (descs[0] & 0x02)
-			break;
-	}
-}
-
 static int td_fill_desc(struct timb_dma_chan *td_chan, u8 *dma_desc,
 	struct scatterlist *sg, bool last)
 {
@@ -294,10 +262,6 @@ static void __td_finish(struct timb_dma_chan *td_chan)
 	list_move(&td_desc->desc_node, &td_chan->free_list);
 
 	dma_descriptor_unmap(txd);
-	if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP))
-		__td_unmap_descs(td_desc,
-			txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE);
-
 	/*
 	 * The API requires that no submissions are done from a
 	 * callback, so we don't need to drop the lock here
diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index 041b675..aee38a7 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -420,30 +420,6 @@ txx9dmac_descriptor_complete(struct txx9dmac_chan *dc,
 	list_move(&desc->desc_node, &dc->free_list);
 
 	dma_descriptor_unmap(txd);
-	if (!ds) {
-		dma_addr_t dmaaddr;
-		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
-			dmaaddr = is_dmac64(dc) ?
-				desc->hwdesc.DAR : desc->hwdesc32.DAR;
-			if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
-				dma_unmap_single(chan2parent(&dc->chan),
-					dmaaddr, desc->len, DMA_FROM_DEVICE);
-			else
-				dma_unmap_page(chan2parent(&dc->chan),
-					dmaaddr, desc->len, DMA_FROM_DEVICE);
-		}
-		if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
-			dmaaddr = is_dmac64(dc) ?
-				desc->hwdesc.SAR : desc->hwdesc32.SAR;
-			if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
-				dma_unmap_single(chan2parent(&dc->chan),
-					dmaaddr, desc->len, DMA_TO_DEVICE);
-			else
-				dma_unmap_page(chan2parent(&dc->chan),
-					dmaaddr, desc->len, DMA_TO_DEVICE);
-		}
-	}
-
 	/*
 	 * The API requires that no submissions are done from a
 	 * callback, so we don't need to drop the lock here

