Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422893Ab2LFJsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:48:53 -0500
Received: from outmail025.ash2.facebook.com ([66.220.155.159]:44818 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422758Ab2LFJpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:45:44 -0500
Subject: [PATCH 05/12] async_memset: convert to dmaengine_unmap_data
To: linux-kernel@vger.kernel.org
From: Dan Williams <djbw@fb.com>
Cc: linux@arm.linux.org.uk,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        vinod.koul@intel.com, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dave.jiang@intel.com
Date: Thu, 06 Dec 2012 01:25:37 -0800
Message-ID: <20121206092536.17085.7308.stgit@dev279.prn1.facebook.com>
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
 crypto/async_tx/async_memset.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index 05a4d1e..ffca53b 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -47,17 +47,22 @@ async_memset(struct page *dest, int val, unsigned int offset, size_t len,
 						      &dest, 1, NULL, 0, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
+	struct dmaengine_unmap_data *unmap = NULL;
 
-	if (device && is_dma_fill_aligned(device, offset, 0, len)) {
-		dma_addr_t dma_dest;
-		unsigned long dma_prep_flags = 0;
+	if (device)
+		unmap = dmaengine_get_unmap_data(device->dev, 1, GFP_NOIO);
+
+	if (unmap && is_dma_fill_aligned(device, offset, 0, len)) {
+		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
+					       DMA_COMPL_SKIP_DEST_UNMAP;
 
 		if (submit->cb_fn)
 			dma_prep_flags |= DMA_PREP_INTERRUPT;
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_prep_flags |= DMA_PREP_FENCE;
-		dma_dest = dma_map_page(device->dev, dest, offset, len,
-					DMA_FROM_DEVICE);
+		unmap->from_cnt = 1;
+		unmap->addr[0] = dma_map_page(device->dev, dest, offset, len,
+					      DMA_FROM_DEVICE);
 
 		tx = device->device_prep_dma_memset(chan, dma_dest, val, len,
 						    dma_prep_flags);
@@ -65,6 +70,8 @@ async_memset(struct page *dest, int val, unsigned int offset, size_t len,
 
 	if (tx) {
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
+
+		dma_set_unmap(tx, unmap);
 		async_tx_submit(chan, tx, submit);
 	} else { /* run the memset synchronously */
 		void *dest_buf;
@@ -79,6 +86,7 @@ async_memset(struct page *dest, int val, unsigned int offset, size_t len,
 
 		async_tx_sync_epilog(submit);
 	}
+	dmaengine_unmap_put(unmap);
 
 	return tx;
 }

