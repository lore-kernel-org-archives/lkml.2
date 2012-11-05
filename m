Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab2KEKDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:03:49 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46872 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab2KEKB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:01:58 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-cf-50978e899c01
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 13/20] async_tx: do DMA unmap in core for XOR operations
Date: Mon, 05 Nov 2012 11:00:24 +0100
Message-id: <1352109631-3385-14-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t9jAd3OvukBBh83mVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mc8cbmQv2hlYs6Z7P3sB4zbWLkZNDQsBE4uu7VcwQtpjEhXvr
	2boYuTiEBBYxSjSeesEE4axmkrjSsokVpIpNwEpiYvsqRhBbREBBYnPvM1aQImaBZ4wSM253
	g40SFvCQ2HbhLZjNIqAq8Wn+NrBmXqD4r+3H2SHWyUs8vd/HBmJzAsUbG6aA1QgJuEtc7jzO
	PIGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2MYK8/k9rBuLLB4hCjAAejEg/vTLHp
	AUKsiWXFlbmHGCU4mJVEeDkYgEK8KYmVValF+fFFpTmpxYcYpTlYlMR5mz1SAoQE0hNLUrNT
	UwtSi2CyTBycUg2MzTvOTVvnoNtwmXvPoiOX+T7c857cFxRovD5xUp/fOftOjRCn0xnHVa6l
	cMpujwj5+qOXm/Hl5bwZk9bMb0l2unI03+LF1GwRz4vTfs7PyBZmztNfOT2J+7T3zvPWuYXf
	bt3cI5t0Ke3zUz4ZH03li+t+ld/fUVTZ4jXXwqmA7e7lLN6/3xJWK7EUZyQaajEXFScCAEcF
	81P2AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In struct dma_async_tx_descriptor convert dma_[src,dst] fields to
arrays and also add dma_src_cnt field.  Then convert core async_tx
code (do_async_xor()) to do DMA unmapping itself using the ->callback
functionality.

Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 crypto/async_tx/async_memcpy.c |  8 ++---
 crypto/async_tx/async_xor.c    | 80 +++++++++++++++++++++++++++++++-----------
 drivers/dma/dmaengine.c        | 26 +++++++-------
 include/linux/dmaengine.h      | 14 +++++---
 4 files changed, 87 insertions(+), 41 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index b6d5dab..cb0628e 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -35,8 +35,8 @@ static void async_memcpy_cb(void *dma_async_param)
 	struct dma_async_tx_descriptor *tx = dma_async_param;
 	struct dma_device *dev = tx->chan->device;
 
-	dma_unmap_page(dev->dev, tx->dma_src, tx->dma_len, DMA_TO_DEVICE);
-	dma_unmap_page(dev->dev, tx->dma_dst, tx->dma_len, DMA_FROM_DEVICE);
+	dma_unmap_page(dev->dev, tx->dma_src[0], tx->dma_len, DMA_TO_DEVICE);
+	dma_unmap_page(dev->dev, tx->dma_dst[0], tx->dma_len, DMA_FROM_DEVICE);
 
 	if (tx->orig_callback)
 		tx->orig_callback(tx->orig_callback_param);
@@ -91,8 +91,8 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 	if (tx) {
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
 
-		tx->dma_src = dma_src;
-		tx->dma_dst = dma_dest;
+		tx->dma_src[0] = dma_src;
+		tx->dma_dst[0] = dma_dest;
 		tx->dma_len = len;
 
 		__async_tx_submit(chan, tx, async_memcpy_cb, tx, submit);
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 154cc84..59a4af3 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -31,6 +31,26 @@
 #include <linux/raid/xor.h>
 #include <linux/async_tx.h>
 
+static void do_async_xor_cb(void *dma_async_param)
+{
+	struct dma_async_tx_descriptor *tx = dma_async_param;
+	struct dma_device *dev = tx->chan->device;
+	int i;
+
+	dma_unmap_page(dev->dev, tx->dma_dst[0], tx->dma_len,
+		       DMA_BIDIRECTIONAL);
+
+	for (i = 0; i < tx->dma_src_cnt; i++) {
+		if (tx->dma_src[i] == tx->dma_dst[0])
+			continue;
+		dma_unmap_page(dev->dev, tx->dma_src[i], tx->dma_len,
+			       DMA_TO_DEVICE);
+	}
+
+	if (tx->orig_callback)
+		tx->orig_callback(tx->orig_callback_param);
+}
+
 /* do_async_xor - dma map the pages and perform the xor with an engine */
 static __async_inline struct dma_async_tx_descriptor *
 do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
@@ -39,42 +59,34 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 {
 	struct dma_device *dma = chan->device;
 	struct dma_async_tx_descriptor *tx = NULL;
-	int src_off = 0;
-	int i;
+	int i, j;
 	dma_async_tx_callback cb_fn_orig = submit->cb_fn;
 	void *cb_param_orig = submit->cb_param;
 	enum async_tx_flags flags_orig = submit->flags;
 	enum dma_ctrl_flags dma_flags;
 	int xor_src_cnt = 0;
+	int src_list_cnt = 0;
+	int extra_ent = 0;
 	dma_addr_t dma_dest;
 
-	/* map the dest bidrectional in case it is re-used as a source */
-	dma_dest = dma_map_page(dma->dev, dest, offset, len, DMA_BIDIRECTIONAL);
 	for (i = 0; i < src_cnt; i++) {
-		/* only map the dest once */
 		if (!src_list[i])
 			continue;
-		if (unlikely(src_list[i] == dest)) {
-			dma_src[xor_src_cnt++] = dma_dest;
-			continue;
-		}
-		dma_src[xor_src_cnt++] = dma_map_page(dma->dev, src_list[i], offset,
-						      len, DMA_TO_DEVICE);
+		xor_src_cnt++;
 	}
 	src_cnt = xor_src_cnt;
 
 	while (src_cnt) {
 		submit->flags = flags_orig;
-		dma_flags = 0;
+		dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
+			    DMA_COMPL_SKIP_DEST_UNMAP;
 		xor_src_cnt = min(src_cnt, (int)dma->max_xor);
-		/* if we are submitting additional xors, leave the chain open,
-		 * clear the callback parameters, and leave the destination
-		 * buffer mapped
+		/* if we are submitting additional xors, leave the chain open
+		 * and clear the callback parameters
 		 */
 		if (src_cnt > xor_src_cnt) {
 			submit->flags &= ~ASYNC_TX_ACK;
 			submit->flags |= ASYNC_TX_FENCE;
-			dma_flags = DMA_COMPL_SKIP_DEST_UNMAP;
 			submit->cb_fn = NULL;
 			submit->cb_param = NULL;
 		} else {
@@ -85,11 +97,32 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 			dma_flags |= DMA_PREP_INTERRUPT;
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
+
+		/* map it bidirectional as it can be re-used as a source */
+		dma_dest = dma_map_page(dma->dev, dest, offset, len,
+					DMA_BIDIRECTIONAL);
+		j = 0;
+		if (extra_ent)
+			dma_src[j++] = dma_dest;
+		for (i = src_list_cnt; j < xor_src_cnt; i++) {
+			/* only map the dest once */
+			if (!src_list[i])
+				continue;
+			if (unlikely(src_list[i] == dest)) {
+				dma_src[j++] = dma_dest;
+				continue;
+			}
+			dma_src[j++] = dma_map_page(dma->dev, src_list[i],
+						    offset, len, DMA_TO_DEVICE);
+		}
+
+		src_list_cnt = i;
+
 		/* Since we have clobbered the src_list we are committed
 		 * to doing this asynchronously.  Drivers force forward progress
 		 * in case they can not provide a descriptor
 		 */
-		tx = dma->device_prep_dma_xor(chan, dma_dest, &dma_src[src_off],
+		tx = dma->device_prep_dma_xor(chan, dma_dest, &dma_src[0],
 					      xor_src_cnt, len, dma_flags);
 
 		if (unlikely(!tx))
@@ -99,22 +132,27 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 		while (unlikely(!tx)) {
 			dma_async_issue_pending(chan);
 			tx = dma->device_prep_dma_xor(chan, dma_dest,
-						      &dma_src[src_off],
+						      &dma_src[0],
 						      xor_src_cnt, len,
 						      dma_flags);
 		}
 
-		async_tx_submit(chan, tx, submit);
+		for (i = 0; i < xor_src_cnt; i++)
+			tx->dma_src[i] = dma_src[i];
+		tx->dma_src_cnt = xor_src_cnt;
+		tx->dma_dst[0] = dma_dest;
+		tx->dma_len = len;
+
+		__async_tx_submit(chan, tx, do_async_xor_cb, tx, submit);
 		submit->depend_tx = tx;
 
 		if (src_cnt > xor_src_cnt) {
 			/* drop completed sources */
 			src_cnt -= xor_src_cnt;
-			src_off += xor_src_cnt;
 
 			/* use the intermediate result a source */
-			dma_src[--src_off] = dma_dest;
 			src_cnt++;
+			extra_ent = 1;
 		} else
 			break;
 	}
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 1b9c02a..5573e86 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -858,8 +858,10 @@ static void dma_async_memcpy_buf_to_buf_cb(void *dma_async_param)
 	struct dma_async_tx_descriptor *tx = dma_async_param;
 	struct dma_device *dev = tx->chan->device;
 
-	dma_unmap_single(dev->dev, tx->dma_src, tx->dma_len, DMA_TO_DEVICE);
-	dma_unmap_single(dev->dev, tx->dma_dst, tx->dma_len, DMA_FROM_DEVICE);
+	dma_unmap_single(dev->dev, tx->dma_src[0], tx->dma_len,
+			 DMA_TO_DEVICE);
+	dma_unmap_single(dev->dev, tx->dma_dst[0], tx->dma_len,
+			 DMA_FROM_DEVICE);
 }
 
 /**
@@ -896,8 +898,8 @@ dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
 		return -ENOMEM;
 	}
 
-	tx->dma_src = dma_src;
-	tx->dma_dst = dma_dest;
+	tx->dma_src[0] = dma_src;
+	tx->dma_dst[0] = dma_dest;
 	tx->dma_len = len;
 
 	tx->callback = dma_async_memcpy_buf_to_buf_cb;
@@ -919,8 +921,8 @@ static void dma_async_memcpy_buf_to_pg_cb(void *dma_async_param)
 	struct dma_async_tx_descriptor *tx = dma_async_param;
 	struct dma_device *dev = tx->chan->device;
 
-	dma_unmap_single(dev->dev, tx->dma_src, tx->dma_len, DMA_TO_DEVICE);
-	dma_unmap_page(dev->dev, tx->dma_dst, tx->dma_len, DMA_FROM_DEVICE);
+	dma_unmap_single(dev->dev, tx->dma_src[0], tx->dma_len, DMA_TO_DEVICE);
+	dma_unmap_page(dev->dev, tx->dma_dst[0], tx->dma_len, DMA_FROM_DEVICE);
 }
 
 /**
@@ -958,8 +960,8 @@ dma_async_memcpy_buf_to_pg(struct dma_chan *chan, struct page *page,
 		return -ENOMEM;
 	}
 
-	tx->dma_src = dma_src;
-	tx->dma_dst = dma_dest;
+	tx->dma_src[0] = dma_src;
+	tx->dma_dst[0] = dma_dest;
 	tx->dma_len = len;
 
 	tx->callback = dma_async_memcpy_buf_to_pg_cb;
@@ -981,8 +983,8 @@ static void dma_async_memcpy_pg_to_pg_cb(void *dma_async_param)
 	struct dma_async_tx_descriptor *tx = dma_async_param;
 	struct dma_device *dev = tx->chan->device;
 
-	dma_unmap_page(dev->dev, tx->dma_src, tx->dma_len, DMA_TO_DEVICE);
-	dma_unmap_page(dev->dev, tx->dma_dst, tx->dma_len, DMA_FROM_DEVICE);
+	dma_unmap_page(dev->dev, tx->dma_src[0], tx->dma_len, DMA_TO_DEVICE);
+	dma_unmap_page(dev->dev, tx->dma_dst[0], tx->dma_len, DMA_FROM_DEVICE);
 }
 
 /**
@@ -1023,8 +1025,8 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
 		return -ENOMEM;
 	}
 
-	tx->dma_src = dma_src;
-	tx->dma_dst = dma_dest;
+	tx->dma_src[0] = dma_src;
+	tx->dma_dst[0] = dma_dest;
 	tx->dma_len = len;
 
 	tx->callback = dma_async_memcpy_pg_to_pg_cb;
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 440b609..0df69f1 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -392,6 +392,10 @@ void dma_chan_cleanup(struct kref *kref);
 typedef bool (*dma_filter_fn)(struct dma_chan *chan, void *filter_param);
 
 typedef void (*dma_async_tx_callback)(void *dma_async_param);
+
+/* max value of ->max_xor from struct dma_device */
+#define DMA_ASYNC_TX_MAX_ENT 128
+
 /**
  * struct dma_async_tx_descriptor - async transaction descriptor
  * ---dma generic offload fields---
@@ -402,8 +406,9 @@ typedef void (*dma_async_tx_callback)(void *dma_async_param);
  * @phys: physical address of the descriptor
  * @chan: target channel for this operation
  * @tx_submit: set the prepared descriptor(s) to be executed by the engine
- * @dma_src: DMA source address (needed for DMA unmap)
- * @dma_dst: DMA destination address (needed for DMA unmap)
+ * @dma_src: DMA source addresses (needed for DMA unmap)
+ * @dma_src_cnt: number of DMA source addresses (needed for DMA unmap)
+ * @dma_dst: DMA destination addresses (needed for DMA unmap)
  * @dma_len: DMA length (needed for DMA unmap)
  * @callback: routine to call after this operation is complete
  * @callback_param: general parameter to pass to the callback routine
@@ -420,8 +425,9 @@ struct dma_async_tx_descriptor {
 	dma_addr_t phys;
 	struct dma_chan *chan;
 	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
-	dma_addr_t dma_src;
-	dma_addr_t dma_dst;
+	dma_addr_t dma_src[DMA_ASYNC_TX_MAX_ENT];
+	unsigned int dma_src_cnt;
+	dma_addr_t dma_dst[DMA_ASYNC_TX_MAX_ENT];
 	size_t dma_len;
 	dma_async_tx_callback callback;
 	void *callback_param;
-- 
1.8.0

