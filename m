Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422766Ab2LFJpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:45:45 -0500
Received: from outmail024.ash2.facebook.com ([66.220.155.158]:34529 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422707Ab2LFJpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:45:38 -0500
Subject: [PATCH 04/12] async_memcpy: convert to dmaengine_unmap_data
To: linux-kernel@vger.kernel.org
From: Dan Williams <djbw@fb.com>
Cc: linux@arm.linux.org.uk,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        vinod.koul@intel.com, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dave.jiang@intel.com
Date: Thu, 06 Dec 2012 01:25:31 -0800
Message-ID: <20121206092531.17085.71257.stgit@dev279.prn1.facebook.com>
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
 crypto/async_tx/async_memcpy.c |   39 ++++++++++++++++++++++-----------------
 drivers/dma/dmaengine.c        |    3 ++-
 include/linux/dmaengine.h      |    2 ++
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 9e62fef..ca95c4c 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -50,33 +50,36 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 						      &dest, 1, &src, 1, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
+	struct dmaengine_unmap_data *unmap = NULL;
 
-	if (device && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
-		dma_addr_t dma_dest, dma_src;
-		unsigned long dma_prep_flags = 0;
+	if (device)
+		unmap = dmaengine_get_unmap_data(device->dev, 2, GFP_NOIO);
+
+	if (unmap && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
+		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
+					       DMA_COMPL_SKIP_DEST_UNMAP;
 
 		if (submit->cb_fn)
 			dma_prep_flags |= DMA_PREP_INTERRUPT;
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_prep_flags |= DMA_PREP_FENCE;
-		dma_dest = dma_map_page(device->dev, dest, dest_offset, len,
-					DMA_FROM_DEVICE);
-
-		dma_src = dma_map_page(device->dev, src, src_offset, len,
-				       DMA_TO_DEVICE);
-
-		tx = device->device_prep_dma_memcpy(chan, dma_dest, dma_src,
-						    len, dma_prep_flags);
-		if (!tx) {
-			dma_unmap_page(device->dev, dma_dest, len,
-				       DMA_FROM_DEVICE);
-			dma_unmap_page(device->dev, dma_src, len,
-				       DMA_TO_DEVICE);
-		}
+
+		unmap->to_cnt = 1;
+		unmap->addr[0] = dma_map_page(device->dev, src, src_offset, len,
+		                              DMA_TO_DEVICE);
+		unmap->from_cnt = 1;
+		unmap->addr[1] = dma_map_page(device->dev, dest, dest_offset, len,
+					      DMA_FROM_DEVICE);
+
+		tx = device->device_prep_dma_memcpy(chan, unmap->addr[1],
+						    unmap->addr[0], len,
+						    dma_prep_flags);
 	}
 
 	if (tx) {
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
+
+		dma_set_unmap(tx, unmap);
 		async_tx_submit(chan, tx, submit);
 	} else {
 		void *dest_buf, *src_buf;
@@ -96,6 +99,8 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 		async_tx_sync_epilog(submit);
 	}
 
+	dmaengine_unmap_put(unmap);
+
 	return tx;
 }
 EXPORT_SYMBOL_GPL(async_memcpy);
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 00f0baf..1b76227 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -965,7 +965,7 @@ static int dmaengine_init_unmap_pool(void)
 	return -ENOMEM;
 }
 
-static struct dmaengine_unmap_data *
+struct dmaengine_unmap_data *
 dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags)
 {
 	struct dmaengine_unmap_data *unmap;
@@ -981,6 +981,7 @@ dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags)
 
 	return unmap;
 }
+EXPORT_SYMBOL(dmaengine_get_unmap_data);
 
 /**
  * dma_async_memcpy_pg_to_pg - offloaded copy from page to page
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index c90d6b6..e954e9f 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -443,6 +443,8 @@ static inline void dma_set_unmap(struct dma_async_tx_descriptor *tx,
 	tx->unmap = unmap;
 }
 
+struct dmaengine_unmap_data *
+dmaengine_get_unmap_data(struct device *dev, int nr, gfp_t flags);
 void dmaengine_unmap_put(struct dmaengine_unmap_data *unmap);
 
 static inline void dma_descriptor_unmap(struct dma_async_tx_descriptor *tx)

