Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422737Ab2LFJph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:45:37 -0500
Received: from outmail018.snc4.facebook.com ([66.220.144.152]:63901 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422707Ab2LFJpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:45:21 -0500
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2012 04:45:21 EST
Subject: [PATCH 02/12] dmaengine: prepare for generic 'unmap' data
To: linux-kernel@vger.kernel.org
From: Dan Williams <djbw@fb.com>
Cc: vinod.koul@intel.com, linux@arm.linux.org.uk, dave.jiang@intel.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Thu, 06 Dec 2012 01:25:20 -0800
Message-ID: <20121206092519.17085.38983.stgit@dev279.prn1.facebook.com>
In-Reply-To: <20121206091055.17085.47979.stgit@dev279.prn1.facebook.com>
References: <20121206091055.17085.47979.stgit@dev279.prn1.facebook.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a hook for a common dma unmap implementation to enable removal of
the per driver custom unmap code.  (A reworked version of Bartlomiej
Zolnierkiewicz's patches to remove the custom callbacks and the size
increase of dma_async_tx_descriptor for drivers that don't care about raid).

Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Dan Williams <djbw@fb.com>
---
 drivers/dma/amba-pl08x.c  |    1 +
 drivers/dma/at_hdmac.c    |    1 +
 drivers/dma/dw_dmac.c     |    1 +
 drivers/dma/ep93xx_dma.c  |    1 +
 drivers/dma/fsldma.c      |    1 +
 drivers/dma/ioat/dma.c    |    1 +
 drivers/dma/ioat/dma_v2.c |    1 +
 drivers/dma/ioat/dma_v3.c |    1 +
 drivers/dma/iop-adma.c    |    1 +
 drivers/dma/mv_xor.c      |    1 +
 drivers/dma/ppc4xx/adma.c |    1 +
 drivers/dma/timb_dma.c    |    1 +
 drivers/dma/txx9dmac.c    |    1 +
 include/linux/dmaengine.h |   26 ++++++++++++++++++++++++++
 14 files changed, 39 insertions(+)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index d1cc579..4cb2f23 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1083,6 +1083,7 @@ static void pl08x_desc_free(struct virt_dma_desc *vd)
 	struct pl08x_txd *txd = to_pl08x_txd(&vd->tx);
 	struct pl08x_dma_chan *plchan = to_pl08x_chan(vd->tx.chan);
 
+	dma_descriptor_unmap(txd);
 	if (!plchan->slave)
 		pl08x_unmap_buffers(txd);
 
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 13a02f4..280ce87 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -253,6 +253,7 @@ atc_chain_complete(struct at_dma_chan *atchan, struct at_desc *desc)
 	list_move(&desc->desc_node, &atchan->free_list);
 
 	/* unmap dma addresses (not on slave channels) */
+	dma_descriptor_unmap(txd);
 	if (!atchan->chan_common.private) {
 		struct device *parent = chan2parent(&atchan->chan_common);
 		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index c4b0eb3..5d0b58c 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -326,6 +326,7 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
 	list_splice_init(&desc->tx_list, &dwc->free_list);
 	list_move(&desc->desc_node, &dwc->free_list);
 
+	dma_descriptor_unmap(txd);
 	if (!dwc->chan.private) {
 		struct device *parent = chan2parent(&dwc->chan);
 		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
index bcfde40..5d08aeb 100644
--- a/drivers/dma/ep93xx_dma.c
+++ b/drivers/dma/ep93xx_dma.c
@@ -791,6 +791,7 @@ static void ep93xx_dma_tasklet(unsigned long data)
 		 * For the memcpy channels the API requires us to unmap the
 		 * buffers unless requested otherwise.
 		 */
+		dma_descriptor_unmap(&desc->txd);
 		if (!edmac->chan.private)
 			ep93xx_dma_unmap_buffers(desc);
 
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 094437b..7e4e44c 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -868,6 +868,7 @@ static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
 	/* Run any dependencies */
 	dma_run_dependencies(txd);
 
+	dma_descriptor_unmap(txd);
 	/* Unmap the dst buffer, if requested */
 	if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
 		if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 464138a..38918cf 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -602,6 +602,7 @@ static void __cleanup(struct ioat_dma_chan *ioat, dma_addr_t phys_complete)
 		dump_desc_dbg(ioat, desc);
 		if (tx->cookie) {
 			dma_cookie_complete(tx);
+			dma_descriptor_unmap(tx);
 			ioat_dma_unmap(chan, tx->flags, desc->len, desc->hw);
 			ioat->active -= desc->hw->tx_cnt;
 			if (tx->callback) {
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index b9d6678..2714b0e 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -148,6 +148,7 @@ static void __cleanup(struct ioat2_dma_chan *ioat, dma_addr_t phys_complete)
 		tx = &desc->txd;
 		dump_desc_dbg(ioat, desc);
 		if (tx->cookie) {
+			dma_descriptor_unmap(tx);
 			ioat_dma_unmap(chan, tx->flags, desc->len, desc->hw);
 			dma_cookie_complete(tx);
 			if (tx->callback) {
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index e52cf1e..70385d5 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -279,6 +279,7 @@ static void __cleanup(struct ioat2_dma_chan *ioat, dma_addr_t phys_complete)
 		tx = &desc->txd;
 		if (tx->cookie) {
 			dma_cookie_complete(tx);
+			dma_descriptor_unmap(tx);
 			ioat3_dma_unmap(ioat, desc, idx + i);
 			if (tx->callback) {
 				tx->callback(tx->callback_param);
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index 79e3eba..32f5d46 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -152,6 +152,7 @@ iop_adma_run_tx_complete_actions(struct iop_adma_desc_slot *desc,
 		if (tx->callback)
 			tx->callback(tx->callback_param);
 
+		dma_descriptor_unmap(tx);
 		/* unmap dma addresses
 		 * (unmap_single vs unmap_page?)
 		 */
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index e362e2b..4a5c073 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -303,6 +303,7 @@ mv_xor_run_tx_complete_actions(struct mv_xor_desc_slot *desc,
 			desc->async_tx.callback(
 				desc->async_tx.callback_param);
 
+		dma_descriptor_unmap(&desc->async_tx);
 		/* unmap dma addresses
 		 * (unmap_single vs unmap_page?)
 		 */
diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index f72348d..883b343 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -1765,6 +1765,7 @@ static dma_cookie_t ppc440spe_adma_run_tx_complete_actions(
 			desc->async_tx.callback(
 				desc->async_tx.callback_param);
 
+		dma_descriptor_unmap(&desc->async_tx);
 		/* unmap dma addresses
 		 * (unmap_single vs unmap_page?)
 		 *
diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 4e0dff5..4b82112 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -293,6 +293,7 @@ static void __td_finish(struct timb_dma_chan *td_chan)
 
 	list_move(&td_desc->desc_node, &td_chan->free_list);
 
+	dma_descriptor_unmap(txd);
 	if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP))
 		__td_unmap_descs(td_desc,
 			txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE);
diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index 913f55c..041b675 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -419,6 +419,7 @@ txx9dmac_descriptor_complete(struct txx9dmac_chan *dc,
 	list_splice_init(&desc->tx_list, &dc->free_list);
 	list_move(&desc->desc_node, &dc->free_list);
 
+	dma_descriptor_unmap(txd);
 	if (!ds) {
 		dma_addr_t dmaaddr;
 		if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 1750e09..da58d79 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -392,6 +392,17 @@ void dma_chan_cleanup(struct kref *kref);
 typedef bool (*dma_filter_fn)(struct dma_chan *chan, void *filter_param);
 
 typedef void (*dma_async_tx_callback)(void *dma_async_param);
+
+struct dmaengine_unmap_data {
+	u8 to_cnt;
+	u8 from_cnt;
+	u8 bidi_cnt;
+	struct device *dev;
+	struct kref kref;
+	size_t len;
+	dma_addr_t addr[0];
+};
+
 /**
  * struct dma_async_tx_descriptor - async transaction descriptor
  * ---dma generic offload fields---
@@ -417,6 +428,7 @@ struct dma_async_tx_descriptor {
 	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
 	dma_async_tx_callback callback;
 	void *callback_param;
+	struct dmaengine_unmap_data *unmap;
 #ifdef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	struct dma_async_tx_descriptor *next;
 	struct dma_async_tx_descriptor *parent;
@@ -424,6 +436,20 @@ struct dma_async_tx_descriptor {
 #endif
 };
 
+static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
+				 struct dmaengine_unmap_data *unmap)
+{
+	kref_get(&unmap->kref);
+	tx->unmap = unmap;
+}
+
+static inline void dma_descriptor_unmap(struct dma_async_tx_descriptor *tx)
+{
+	if (tx->unmap) {
+		tx->unmap = NULL;
+	}
+}
+
 #ifndef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
 static inline void txd_lock(struct dma_async_tx_descriptor *txd)
 {

