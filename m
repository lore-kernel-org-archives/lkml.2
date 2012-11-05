Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab2KEKCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:02:13 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26202 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2KEKCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:02:09 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-65-50978e9f2eac
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 17/20] async_tx: do DMA unmap in core for PQ operations
Date: Mon, 05 Nov 2012 11:00:28 +0100
Message-id: <1352109631-3385-18-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t9jAd35fdMDDBY9EbW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZz65eYCk4r1txePoc9gbGp8pdjJwcEgImEmdPHGKFsMUkLtxb
	z9bFyMUhJLCIUeLDw9ksEM5qJomnjdeYQKrYBKwkJravYgSxRQQUJDb3PmMFKWIWeMYoMeN2
	NzNIQljAXeL21QlsIDaLgKrE6c1PwFbwCnhIXD7YzgixTl7i6f0+sBpOoHhjwxSwGiGg3sud
	x5knMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRHs9WdSOxhXNlgcYhTgYFTi4Z0p
	Nj1AiDWxrLgy9xCjBAezkggvBwNQiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+zR0qAkEB6Yklq
	dmpqQWoRTJaJg1OqgfHiN2azlQvFCnsj95/i18vaWFjZsdXFUte76eTnP7NmvTz7xC902ffz
	HXy9aZefXJwmYqftNGHNwezFumK3Xbg0Xz7/HHereNWt+5GeJf4x+Z/FGUMyLi/89qjWvvjk
	lXO1uszdknu2/Fd5r86yP3D7zKdNjStUWjk67CO5jnsfYS6cttfqxiQlluKMREMt5qLiRAAr
	Dc0o9gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert core async_tx code (do_async_gen_syndrome()) to do
DMA unmapping itself using the ->callback functionality.

Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 crypto/async_tx/async_pq.c | 90 +++++++++++++++++++++++++++++++++-------------
 include/linux/dmaengine.h  |  2 +-
 2 files changed, 66 insertions(+), 26 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 91d5d38..2848fe8 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -42,6 +42,26 @@ static struct page *pq_scribble_page;
 #define P(b, d) (b[d-2])
 #define Q(b, d) (b[d-1])
 
+static void do_async_gen_syndrome_cb(void *dma_async_param)
+{
+	struct dma_async_tx_descriptor *tx = dma_async_param;
+	struct dma_device *dev = tx->chan->device;
+	int i;
+
+	for (i = 0; i < 2; i++) {
+		if (tx->dma_dst[i])
+			dma_unmap_page(dev->dev, tx->dma_dst[i], tx->dma_len,
+				       DMA_BIDIRECTIONAL);
+	}
+
+	for (i = 0; i < tx->dma_src_cnt; i++)
+		dma_unmap_page(dev->dev, tx->dma_src[i], tx->dma_len,
+			       DMA_TO_DEVICE);
+
+	if (tx->orig_callback)
+		tx->orig_callback(tx->orig_callback_param);
+}
+
 /**
  * do_async_gen_syndrome - asynchronously calculate P and/or Q
  */
@@ -61,37 +81,21 @@ do_async_gen_syndrome(struct dma_chan *chan, struct page **blocks,
 	unsigned char coefs[src_cnt];
 	unsigned short pq_src_cnt;
 	dma_addr_t dma_dest[2];
-	int src_off = 0;
+	int blocks_cnt = 0;
 	int idx;
 	int i;
 
-	/* DMAs use destinations as sources, so use BIDIRECTIONAL mapping */
-	if (P(blocks, disks))
-		dma_dest[0] = dma_map_page(dma->dev, P(blocks, disks), offset,
-					   len, DMA_BIDIRECTIONAL);
-	else
-		dma_flags |= DMA_PREP_PQ_DISABLE_P;
-	if (Q(blocks, disks))
-		dma_dest[1] = dma_map_page(dma->dev, Q(blocks, disks), offset,
-					   len, DMA_BIDIRECTIONAL);
-	else
-		dma_flags |= DMA_PREP_PQ_DISABLE_Q;
-
-	/* convert source addresses being careful to collapse 'empty'
-	 * sources and update the coefficients accordingly
-	 */
 	for (i = 0, idx = 0; i < src_cnt; i++) {
 		if (blocks[i] == NULL)
 			continue;
-		dma_src[idx] = dma_map_page(dma->dev, blocks[i], offset, len,
-					    DMA_TO_DEVICE);
-		coefs[idx] = scfs[i];
 		idx++;
 	}
 	src_cnt = idx;
 
 	while (src_cnt > 0) {
 		submit->flags = flags_orig;
+		dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
+			    DMA_COMPL_SKIP_DEST_UNMAP;
 		pq_src_cnt = min(src_cnt, dma_maxpq(dma, dma_flags));
 		/* if we are submitting additional pqs, leave the chain open,
 		 * clear the callback parameters, and leave the destination
@@ -100,11 +104,9 @@ do_async_gen_syndrome(struct dma_chan *chan, struct page **blocks,
 		if (src_cnt > pq_src_cnt) {
 			submit->flags &= ~ASYNC_TX_ACK;
 			submit->flags |= ASYNC_TX_FENCE;
-			dma_flags |= DMA_COMPL_SKIP_DEST_UNMAP;
 			submit->cb_fn = NULL;
 			submit->cb_param = NULL;
 		} else {
-			dma_flags &= ~DMA_COMPL_SKIP_DEST_UNMAP;
 			submit->cb_fn = cb_fn_orig;
 			submit->cb_param = cb_param_orig;
 			if (cb_fn_orig)
@@ -113,15 +115,46 @@ do_async_gen_syndrome(struct dma_chan *chan, struct page **blocks,
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
 
+		/*
+		 * DMAs use destinations as sources,
+		 * so use BIDIRECTIONAL mapping
+		 */
+		if (P(blocks, disks))
+			dma_dest[0] = dma_map_page(dma->dev, P(blocks, disks),
+						offset, len, DMA_BIDIRECTIONAL);
+		else {
+			dma_dest[0] = 0;
+			dma_flags |= DMA_PREP_PQ_DISABLE_P;
+		}
+		if (Q(blocks, disks))
+			dma_dest[1] = dma_map_page(dma->dev, Q(blocks, disks),
+						offset, len, DMA_BIDIRECTIONAL);
+		else {
+			dma_dest[1] = 0;
+			dma_flags |= DMA_PREP_PQ_DISABLE_Q;
+		}
+
+		/* convert source addresses being careful to collapse 'empty'
+		 * sources and update the coefficients accordingly
+		 */
+		for (i = blocks_cnt, idx = 0; idx < pq_src_cnt; i++) {
+			if (blocks[i] == NULL)
+				continue;
+			dma_src[idx] = dma_map_page(dma->dev, blocks[i], offset,
+						    len, DMA_TO_DEVICE);
+			coefs[idx] = scfs[i];
+			idx++;
+		}
+
 		/* Since we have clobbered the src_list we are committed
 		 * to doing this asynchronously.  Drivers force forward
 		 * progress in case they can not provide a descriptor
 		 */
 		for (;;) {
 			tx = dma->device_prep_dma_pq(chan, dma_dest,
-						     &dma_src[src_off],
+						     &dma_src[0],
 						     pq_src_cnt,
-						     &coefs[src_off], len,
+						     &coefs[0], len,
 						     dma_flags);
 			if (likely(tx))
 				break;
@@ -129,12 +162,19 @@ do_async_gen_syndrome(struct dma_chan *chan, struct page **blocks,
 			dma_async_issue_pending(chan);
 		}
 
-		async_tx_submit(chan, tx, submit);
+		for (i = 0; i < pq_src_cnt; i++)
+			tx->dma_src[i] = dma_src[i];
+		tx->dma_src_cnt = pq_src_cnt;
+		tx->dma_dst[0] = dma_dest[0];
+		tx->dma_dst[1] = dma_dest[1];
+		tx->dma_len = len;
+
+		__async_tx_submit(chan, tx, do_async_gen_syndrome_cb, tx,
+				  submit);
 		submit->depend_tx = tx;
 
 		/* drop completed sources */
 		src_cnt -= pq_src_cnt;
-		src_off += pq_src_cnt;
 
 		dma_flags |= DMA_PREP_CONTINUE;
 	}
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 0df69f1..af3b941 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -393,7 +393,7 @@ typedef bool (*dma_filter_fn)(struct dma_chan *chan, void *filter_param);
 
 typedef void (*dma_async_tx_callback)(void *dma_async_param);
 
-/* max value of ->max_xor from struct dma_device */
+/* max value of ->max_[xor,pq] from struct dma_device */
 #define DMA_ASYNC_TX_MAX_ENT 128
 
 /**
-- 
1.8.0

