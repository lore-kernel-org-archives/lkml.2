Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422842Ab2LFJq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:46:29 -0500
Received: from outmail006.ash2.facebook.com ([66.220.155.140]:34607 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754910Ab2LFJqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:46:23 -0500
Subject: [PATCH 10/12] async_pq_val: convert to dmaengine_unmap_data
To: linux-kernel@vger.kernel.org
From: Dan Williams <djbw@fb.com>
Cc: linux@arm.linux.org.uk,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        vinod.koul@intel.com, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dave.jiang@intel.com
Date: Thu, 06 Dec 2012 01:26:05 -0800
Message-ID: <20121206092605.17085.40510.stgit@dev279.prn1.facebook.com>
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
 crypto/async_tx/async_pq.c |   58 +++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 1d78984..e5ddb31 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -288,50 +288,60 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 	struct dma_async_tx_descriptor *tx;
 	unsigned char coefs[disks-2];
 	enum dma_ctrl_flags dma_flags = submit->cb_fn ? DMA_PREP_INTERRUPT : 0;
-	dma_addr_t *dma_src = NULL;
-	int src_cnt = 0;
+	struct dmaengine_unmap_data *unmap = NULL;
 
 	BUG_ON(disks < 4);
 
-	if (submit->scribble)
-		dma_src = submit->scribble;
-	else if (sizeof(dma_addr_t) <= sizeof(struct page *))
-		dma_src = (dma_addr_t *) blocks;
+	if (device)
+		unmap = dmaengine_get_unmap_data(device->dev, disks, GFP_NOIO);
 
-	if (dma_src && device && disks <= dma_maxpq(device, 0) &&
+	if (unmap && disks <= dma_maxpq(device, 0) &&
 	    is_dma_pq_aligned(device, offset, 0, len)) {
 		struct device *dev = device->dev;
-		dma_addr_t *pq = &dma_src[disks-2];
-		int i;
+		dma_addr_t pq[2];
+		int i, j = 0, src_cnt = 0;
 
 		pr_debug("%s: (async) disks: %d len: %zu\n",
 			 __func__, disks, len);
-		if (!P(blocks, disks))
+
+		unmap->len = len;
+		for (i = 0; i < disks-2; i++)
+			if (likely(blocks[i])) {
+				unmap->addr[j] = dma_map_page(dev, blocks[i],
+							      offset, len,
+							      DMA_TO_DEVICE);
+				coefs[j] = raid6_gfexp[i];
+				unmap->to_cnt++;
+				src_cnt++;
+				j++;
+			}
+
+		if (!P(blocks, disks)) {
+			pq[0] = 0;
 			dma_flags |= DMA_PREP_PQ_DISABLE_P;
-		else
+		} else {
 			pq[0] = dma_map_page(dev, P(blocks, disks),
 					     offset, len,
 					     DMA_TO_DEVICE);
-		if (!Q(blocks, disks))
+			unmap->addr[j++] = pq[0];
+			unmap->to_cnt++;
+		}
+		if (!Q(blocks, disks)) {
+			pq[1] = 0;
 			dma_flags |= DMA_PREP_PQ_DISABLE_Q;
-		else
+		} else {
 			pq[1] = dma_map_page(dev, Q(blocks, disks),
 					     offset, len,
 					     DMA_TO_DEVICE);
+			unmap->addr[j++] = pq[1];
+			unmap->to_cnt++;
+		}
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
-		for (i = 0; i < disks-2; i++)
-			if (likely(blocks[i])) {
-				dma_src[src_cnt] = dma_map_page(dev, blocks[i],
-								offset, len,
-								DMA_TO_DEVICE);
-				coefs[src_cnt] = raid6_gfexp[i];
-				src_cnt++;
-			}
-
 		for (;;) {
-			tx = device->device_prep_dma_pq_val(chan, pq, dma_src,
+			tx = device->device_prep_dma_pq_val(chan, pq,
+							    unmap->addr,
 							    src_cnt,
 							    coefs,
 							    len, pqres,
@@ -341,6 +351,8 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 			async_tx_quiesce(&submit->depend_tx);
 			dma_async_issue_pending(chan);
 		}
+
+		dma_set_unmap(tx, unmap);
 		async_tx_submit(chan, tx, submit);
 
 		return tx;

