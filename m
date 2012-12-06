Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422876Ab2LFJsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:48:09 -0500
Received: from outmail025.snc4.facebook.com ([66.220.144.159]:49029 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422783Ab2LFJpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:45:55 -0500
Subject: [PATCH 08/12] async_raid6_recov: convert to dmaengine_unmap_data
To: linux-kernel@vger.kernel.org
From: Dan Williams <djbw@fb.com>
Cc: linux@arm.linux.org.uk,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        vinod.koul@intel.com, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dave.jiang@intel.com
Date: Thu, 06 Dec 2012 01:25:54 -0800
Message-ID: <20121206092553.17085.38552.stgit@dev279.prn1.facebook.com>
In-Reply-To: <20121206091055.17085.47979.stgit@dev279.prn1.facebook.com>
References: <20121206091055.17085.47979.stgit@dev279.prn1.facebook.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic unmap object to unmap dma buffers.

Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Dan Williams <djbw@fb.com>
---
 crypto/async_tx/async_raid6_recov.c |   69 ++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 21 deletions(-)

diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index a9f08a6..20aea04 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -26,6 +26,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
+#include <linux/dmaengine.h>
 
 static struct dma_async_tx_descriptor *
 async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
@@ -34,35 +35,47 @@ async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
 						      &dest, 1, srcs, 2, len);
 	struct dma_device *dma = chan ? chan->device : NULL;
+	struct dmaengine_unmap_data *unmap = NULL;
 	const u8 *amul, *bmul;
 	u8 ax, bx;
 	u8 *a, *b, *c;
 
-	if (dma) {
-		dma_addr_t dma_dest[2];
-		dma_addr_t dma_src[2];
+	if (dma)
+		unmap = dmaengine_get_unmap_data(dma->dev, 3, GFP_NOIO);
+
+	if (unmap) {
 		struct device *dev = dma->dev;
+		dma_addr_t pq[2];
 		struct dma_async_tx_descriptor *tx;
-		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
+		enum dma_ctrl_flags dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
+						DMA_COMPL_SKIP_DEST_UNMAP |
+						DMA_PREP_PQ_DISABLE_P;
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
-		dma_dest[1] = dma_map_page(dev, dest, 0, len, DMA_BIDIRECTIONAL);
-		dma_src[0] = dma_map_page(dev, srcs[0], 0, len, DMA_TO_DEVICE);
-		dma_src[1] = dma_map_page(dev, srcs[1], 0, len, DMA_TO_DEVICE);
-		tx = dma->device_prep_dma_pq(chan, dma_dest, dma_src, 2, coef,
+		unmap->addr[0] = dma_map_page(dev, srcs[0], 0, len, DMA_TO_DEVICE);
+		unmap->addr[1] = dma_map_page(dev, srcs[1], 0, len, DMA_TO_DEVICE);
+		unmap->to_cnt = 2;
+
+		unmap->addr[2] = dma_map_page(dev, dest, 0, len, DMA_BIDIRECTIONAL);
+		unmap->bidi_cnt = 1;
+		/* engine only looks at Q, but expects it to follow P */
+		pq[1] = unmap->addr[2];
+
+		unmap->len = len;
+		tx = dma->device_prep_dma_pq(chan, pq, unmap->addr, 2, coef,
 					     len, dma_flags);
 		if (tx) {
+			dma_set_unmap(tx, unmap);
 			async_tx_submit(chan, tx, submit);
+			dmaengine_unmap_put(unmap);
 			return tx;
 		}
 
 		/* could not get a descriptor, unmap and fall through to
 		 * the synchronous path
 		 */
-		dma_unmap_page(dev, dma_dest[1], len, DMA_BIDIRECTIONAL);
-		dma_unmap_page(dev, dma_src[0], len, DMA_TO_DEVICE);
-		dma_unmap_page(dev, dma_src[1], len, DMA_TO_DEVICE);
+		dmaengine_unmap_put(unmap);
 	}
 
 	/* run the operation synchronously */
@@ -89,23 +102,38 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 	struct dma_chan *chan = async_tx_find_channel(submit, DMA_PQ,
 						      &dest, 1, &src, 1, len);
 	struct dma_device *dma = chan ? chan->device : NULL;
+	struct dmaengine_unmap_data *unmap = NULL;
 	const u8 *qmul; /* Q multiplier table */
 	u8 *d, *s;
 
-	if (dma) {
-		dma_addr_t dma_dest[2];
-		dma_addr_t dma_src[1];
+	if (dma)
+		unmap = dmaengine_get_unmap_data(dma->dev, 3, GFP_NOIO);
+
+	if (unmap) {
 		struct device *dev = dma->dev;
 		struct dma_async_tx_descriptor *tx;
-		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
+		enum dma_ctrl_flags dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
+						DMA_COMPL_SKIP_DEST_UNMAP |
+						DMA_PREP_PQ_DISABLE_P;
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
-		dma_dest[1] = dma_map_page(dev, dest, 0, len, DMA_BIDIRECTIONAL);
-		dma_src[0] = dma_map_page(dev, src, 0, len, DMA_TO_DEVICE);
-		tx = dma->device_prep_dma_pq(chan, dma_dest, dma_src, 1, &coef,
-					     len, dma_flags);
+		unmap->addr[0] = dma_map_page(dev, src, 0, len, DMA_TO_DEVICE);
+		unmap->to_cnt++;
+		unmap->addr[1] = dma_map_page(dev, dest, 0, len, DMA_BIDIRECTIONAL);
+		unmap->bidi_cnt++;
+		unmap->len = len;
+
+		/* this looks funny, but the engine looks for Q at
+		 * unmap->addr[1] and ignores unmap->addr[0] as a dest
+		 * due to DMA_PREP_PQ_DISABLE_P
+		 */
+		tx = dma->device_prep_dma_pq(chan, unmap->addr, unmap->addr,
+					     1, &coef, len, dma_flags);
+
 		if (tx) {
+			dma_set_unmap(tx, unmap);
+			dmaengine_unmap_put(unmap);
 			async_tx_submit(chan, tx, submit);
 			return tx;
 		}
@@ -113,8 +141,7 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 		/* could not get a descriptor, unmap and fall through to
 		 * the synchronous path
 		 */
-		dma_unmap_page(dev, dma_dest[1], len, DMA_BIDIRECTIONAL);
-		dma_unmap_page(dev, dma_src[0], len, DMA_TO_DEVICE);
+		dmaengine_unmap_put(unmap);
 	}
 
 	/* no channel available, or failed to allocate a descriptor, so

