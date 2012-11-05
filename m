Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab2KEKBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:01:21 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46716 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2KEKBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:01:17 -0500
X-AuditID: cbfee61b-b7f616d00000319b-5b-50978e6c487c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 06/20] DMA: do DMA unmap in core for MEMCPY operations
Date: Mon, 05 Nov 2012 11:00:17 +0100
Message-id: <1352109631-3385-7-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t9jAd2cvukBBl9+y1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MjXvqCuYbVEyb8p6xgfGqRhcjJ4eEgInExEufGCFsMYkL99az
	dTFycQgJLGKUuH7gIiOEs5pJ4unfI6wgVWwCVhIT21eBdYgIKEhs7n3GClLELPCMUWLG7W5m
	kISwgJvE37Pz2EFsFgFViYVr97GA2LwC7hKLv71gg1gnL/H0fh+YzSngIdHYMAVsgRBQzeXO
	48wTGHkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAj2+TPpHYyrGiwOMQpwMCrx8H6S
	mB4gxJpYVlyZe4hRgoNZSYSXgwEoxJuSWFmVWpQfX1Sak1p8iFGag0VJnLfZIyVASCA9sSQ1
	OzW1ILUIJsvEwSnVwDjJ7uj9V/yi9uKTdhw+0hYbUyQto70gqVJjeVnTx0mP6jvtNm5efiO7
	eyvXvYnuSbPLD7M+n362/0ztpuPfo3d1VXy+7Wswc13XVG/1nucTlkXUsJ5Y3XvJfsm+aUsf
	fQgumtpmYhCTvdtmn0vFf7GvUvMLxK1q/Xbntl63Mm//lRDN3SKU56PEUpyRaKjFXFScCADX
	fwpa9QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dma_src, dma_dst and dma_len to struct dma_async_tx_descriptor
for storing DMA mapping data and convert core DMA engine code
(dma_async_memcpy_buf_to_buf(), dma_async_memcpy_buf_to_pg() and
dma_async_memcpy_pg_to_pg()) to do DMA unmapping itself using
the ->callback functionality.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/dma/dmaengine.c   | 62 +++++++++++++++++++++++++++++++++++++++++------
 include/linux/dmaengine.h |  6 +++++
 2 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index a815d44..1b9c02a 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -853,6 +853,15 @@ void dma_async_device_unregister(struct dma_device *device)
 }
 EXPORT_SYMBOL(dma_async_device_unregister);
 
+static void dma_async_memcpy_buf_to_buf_cb(void *dma_async_param)
+{
+	struct dma_async_tx_descriptor *tx = dma_async_param;
+	struct dma_device *dev = tx->chan->device;
+
+	dma_unmap_single(dev->dev, tx->dma_src, tx->dma_len, DMA_TO_DEVICE);
+	dma_unmap_single(dev->dev, tx->dma_dst, tx->dma_len, DMA_FROM_DEVICE);
+}
+
 /**
  * dma_async_memcpy_buf_to_buf - offloaded copy between virtual addresses
  * @chan: DMA channel to offload copy to
@@ -877,9 +886,8 @@ dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
 
 	dma_src = dma_map_single(dev->dev, src, len, DMA_TO_DEVICE);
 	dma_dest = dma_map_single(dev->dev, dest, len, DMA_FROM_DEVICE);
-	flags = DMA_CTRL_ACK |
-		DMA_COMPL_SRC_UNMAP_SINGLE |
-		DMA_COMPL_DEST_UNMAP_SINGLE;
+	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_SRC_UNMAP |
+		DMA_COMPL_SKIP_DEST_UNMAP;
 	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, flags);
 
 	if (!tx) {
@@ -888,7 +896,13 @@ dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
 		return -ENOMEM;
 	}
 
-	tx->callback = NULL;
+	tx->dma_src = dma_src;
+	tx->dma_dst = dma_dest;
+	tx->dma_len = len;
+
+	tx->callback = dma_async_memcpy_buf_to_buf_cb;
+	tx->callback_param = tx;
+
 	cookie = tx->tx_submit(tx);
 
 	preempt_disable();
@@ -900,6 +914,15 @@ dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
 }
 EXPORT_SYMBOL(dma_async_memcpy_buf_to_buf);
 
+static void dma_async_memcpy_buf_to_pg_cb(void *dma_async_param)
+{
+	struct dma_async_tx_descriptor *tx = dma_async_param;
+	struct dma_device *dev = tx->chan->device;
+
+	dma_unmap_single(dev->dev, tx->dma_src, tx->dma_len, DMA_TO_DEVICE);
+	dma_unmap_page(dev->dev, tx->dma_dst, tx->dma_len, DMA_FROM_DEVICE);
+}
+
 /**
  * dma_async_memcpy_buf_to_pg - offloaded copy from address to page
  * @chan: DMA channel to offload copy to
@@ -925,7 +948,8 @@ dma_async_memcpy_buf_to_pg(struct dma_chan *chan, struct page *page,
 
 	dma_src = dma_map_single(dev->dev, kdata, len, DMA_TO_DEVICE);
 	dma_dest = dma_map_page(dev->dev, page, offset, len, DMA_FROM_DEVICE);
-	flags = DMA_CTRL_ACK | DMA_COMPL_SRC_UNMAP_SINGLE;
+	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_SRC_UNMAP |
+		DMA_COMPL_SKIP_DEST_UNMAP;
 	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, flags);
 
 	if (!tx) {
@@ -934,7 +958,13 @@ dma_async_memcpy_buf_to_pg(struct dma_chan *chan, struct page *page,
 		return -ENOMEM;
 	}
 
-	tx->callback = NULL;
+	tx->dma_src = dma_src;
+	tx->dma_dst = dma_dest;
+	tx->dma_len = len;
+
+	tx->callback = dma_async_memcpy_buf_to_pg_cb;
+	tx->callback_param = tx;
+
 	cookie = tx->tx_submit(tx);
 
 	preempt_disable();
@@ -946,6 +976,15 @@ dma_async_memcpy_buf_to_pg(struct dma_chan *chan, struct page *page,
 }
 EXPORT_SYMBOL(dma_async_memcpy_buf_to_pg);
 
+static void dma_async_memcpy_pg_to_pg_cb(void *dma_async_param)
+{
+	struct dma_async_tx_descriptor *tx = dma_async_param;
+	struct dma_device *dev = tx->chan->device;
+
+	dma_unmap_page(dev->dev, tx->dma_src, tx->dma_len, DMA_TO_DEVICE);
+	dma_unmap_page(dev->dev, tx->dma_dst, tx->dma_len, DMA_FROM_DEVICE);
+}
+
 /**
  * dma_async_memcpy_pg_to_pg - offloaded copy from page to page
  * @chan: DMA channel to offload copy to
@@ -974,7 +1013,8 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
 	dma_src = dma_map_page(dev->dev, src_pg, src_off, len, DMA_TO_DEVICE);
 	dma_dest = dma_map_page(dev->dev, dest_pg, dest_off, len,
 				DMA_FROM_DEVICE);
-	flags = DMA_CTRL_ACK;
+	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_SRC_UNMAP |
+		DMA_COMPL_SKIP_DEST_UNMAP;
 	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, flags);
 
 	if (!tx) {
@@ -983,7 +1023,13 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
 		return -ENOMEM;
 	}
 
-	tx->callback = NULL;
+	tx->dma_src = dma_src;
+	tx->dma_dst = dma_dest;
+	tx->dma_len = len;
+
+	tx->callback = dma_async_memcpy_pg_to_pg_cb;
+	tx->callback_param = tx;
+
 	cookie = tx->tx_submit(tx);
 
 	preempt_disable();
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index d3201e4..8741d57 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -402,6 +402,9 @@ typedef void (*dma_async_tx_callback)(void *dma_async_param);
  * @phys: physical address of the descriptor
  * @chan: target channel for this operation
  * @tx_submit: set the prepared descriptor(s) to be executed by the engine
+ * @dma_src: DMA source address (needed for DMA unmap)
+ * @dma_dst: DMA destination address (needed for DMA unmap)
+ * @dma_len: DMA length (needed for DMA unmap)
  * @callback: routine to call after this operation is complete
  * @callback_param: general parameter to pass to the callback routine
  * ---async_tx api specific fields---
@@ -415,6 +418,9 @@ struct dma_async_tx_descriptor {
 	dma_addr_t phys;
 	struct dma_chan *chan;
 	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
+	dma_addr_t dma_src;
+	dma_addr_t dma_dst;
+	size_t dma_len;
 	dma_async_tx_callback callback;
 	void *callback_param;
 #ifdef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
-- 
1.8.0

