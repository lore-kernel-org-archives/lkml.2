Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422781Ab2LFJpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:45:52 -0500
Received: from outmail007.snc4.facebook.com ([66.220.144.141]:49724 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422768Ab2LFJpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:45:49 -0500
Subject: [PATCH 07/12] async_xor_val: convert to dmaengine_unmap_data
To: linux-kernel@vger.kernel.org
From: Dan Williams <djbw@fb.com>
Cc: linux@arm.linux.org.uk,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        vinod.koul@intel.com, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dave.jiang@intel.com
Date: Thu, 06 Dec 2012 01:25:48 -0800
Message-ID: <20121206092548.17085.19899.stgit@dev279.prn1.facebook.com>
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
 crypto/async_tx/async_xor.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 46bbdb3..d6e1dc0 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -278,18 +278,17 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 	struct dma_chan *chan = xor_val_chan(submit, dest, src_list, src_cnt, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
-	dma_addr_t *dma_src = NULL;
+	struct dmaengine_unmap_data *unmap = NULL;
 
 	BUG_ON(src_cnt <= 1);
 
-	if (submit->scribble)
-		dma_src = submit->scribble;
-	else if (sizeof(dma_addr_t) <= sizeof(struct page *))
-		dma_src = (dma_addr_t *) src_list;
+	if (device)
+		unmap = dmaengine_get_unmap_data(device->dev, src_cnt, GFP_NOIO);
 
-	if (dma_src && device && src_cnt <= device->max_xor &&
+	if (unmap && src_cnt <= device->max_xor &&
 	    is_dma_xor_aligned(device, offset, 0, len)) {
-		unsigned long dma_prep_flags = 0;
+		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
+					       DMA_COMPL_SKIP_DEST_UNMAP;
 		int i;
 
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
@@ -298,11 +297,15 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 			dma_prep_flags |= DMA_PREP_INTERRUPT;
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_prep_flags |= DMA_PREP_FENCE;
-		for (i = 0; i < src_cnt; i++)
-			dma_src[i] = dma_map_page(device->dev, src_list[i],
-						  offset, len, DMA_TO_DEVICE);
 
-		tx = device->device_prep_dma_xor_val(chan, dma_src, src_cnt,
+		for (i = 0; i < src_cnt; i++) {
+			unmap->addr[i] = dma_map_page(device->dev, src_list[i],
+                                          offset, len, DMA_TO_DEVICE);
+			unmap->to_cnt++;
+		}
+		unmap->len = len;
+
+		tx = device->device_prep_dma_xor_val(chan, unmap->addr, src_cnt,
 						     len, result,
 						     dma_prep_flags);
 		if (unlikely(!tx)) {
@@ -311,11 +314,11 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 			while (!tx) {
 				dma_async_issue_pending(chan);
 				tx = device->device_prep_dma_xor_val(chan,
-					dma_src, src_cnt, len, result,
+					unmap->addr, src_cnt, len, result,
 					dma_prep_flags);
 			}
 		}
-
+		dma_set_unmap(tx, unmap);
 		async_tx_submit(chan, tx, submit);
 	} else {
 		enum async_tx_flags flags_orig = submit->flags;
@@ -337,6 +340,7 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 		async_tx_sync_epilog(submit);
 		submit->flags = flags_orig;
 	}
+	dmaengine_unmap_put(unmap);
 
 	return tx;
 }

