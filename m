Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab2KEKDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:03:17 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46941 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab2KEKCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:02:12 -0500
X-AuditID: cbfee61b-b7f616d00000319b-00-50978ea3d61f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 18/20] async_tx: do DMA unmap in core for PQ_VAL operations
Date: Mon, 05 Nov 2012 11:00:29 +0100
Message-id: <1352109631-3385-19-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t9jAd3FfdMDDL6v5ba4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZH6bpFtwUqXg1aTd7A+MOgS5GTg4JAROJ1Wu/MUHYYhIX7q1n
	62Lk4hASWMQosfFOExOEs5pJYtqRS6wgVWwCVhIT21cxgtgiAgoSm3ufsYIUMQs8Y5SYcbub
	GSQhLOAt8XnLVLCxLAKqEucXPGAHsXkFPCT+3GplgVgnL/H0fh8biM0JFG9smAK2QEjAXeJy
	53HmCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIE+/yZ9A7GVQ0WhxgFOBiVeHg/
	SUwPEGJNLCuuzD3EKMHBrCTCy8EAFOJNSaysSi3Kjy8qzUktPsQozcGiJM7b7JESICSQnliS
	mp2aWpBaBJNl4uCUamCUX3HVtLaJiXeZwfKtTrnGW+admLqv6nfbtJvHq1z2/nW8ZPBoipDL
	uZvqk565dLRMrXmbLnMmZqF5vfL6Z2HyZ1td0qJ/zy8sLfPeE+bS/j1+kVPKvENOZ2Uv3RY3
	dH06JZznW/nZmwWzA0sCFb6llpt5bf8yfRmX5bLzjoeTPd/ZzAoXdb2pxFKckWioxVxUnAgA
	wb57rPUBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert core async_tx code (async_syndrome_val()) to do
DMA unmapping itself using the ->callback functionality.

Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 crypto/async_tx/async_pq.c | 40 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 2848fe8..9e5500e 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -292,6 +292,26 @@ pq_val_chan(struct async_submit_ctl *submit, struct page **blocks, int disks, si
 				     disks, len);
 }
 
+static void async_syndrome_val_cb(void *dma_async_param)
+{
+	struct dma_async_tx_descriptor *tx = dma_async_param;
+	struct dma_device *dev = tx->chan->device;
+	int i;
+
+	for (i = tx->dma_src_cnt; i < tx->dma_src_cnt + 2; i++) {
+		if (tx->dma_src[i])
+			dma_unmap_page(dev->dev, tx->dma_src[i], tx->dma_len,
+				       DMA_TO_DEVICE);
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
  * async_syndrome_val - asynchronously validate a raid6 syndrome
  * @blocks: source blocks from idx 0..disks-3, P @ disks-2 and Q @ disks-1
@@ -335,15 +355,17 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 
 		pr_debug("%s: (async) disks: %d len: %zu\n",
 			 __func__, disks, len);
-		if (!P(blocks, disks))
+		if (!P(blocks, disks)) {
+			pq[0] = 0;
 			dma_flags |= DMA_PREP_PQ_DISABLE_P;
-		else
+		} else
 			pq[0] = dma_map_page(dev, P(blocks, disks),
 					     offset, len,
 					     DMA_TO_DEVICE);
-		if (!Q(blocks, disks))
+		if (!Q(blocks, disks)) {
+			pq[1] = 0;
 			dma_flags |= DMA_PREP_PQ_DISABLE_Q;
-		else
+		} else
 			pq[1] = dma_map_page(dev, Q(blocks, disks),
 					     offset, len,
 					     DMA_TO_DEVICE);
@@ -370,7 +392,15 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 			async_tx_quiesce(&submit->depend_tx);
 			dma_async_issue_pending(chan);
 		}
-		async_tx_submit(chan, tx, submit);
+
+		tx->dma_src[src_cnt] = pq[0];
+		tx->dma_src[src_cnt + 1] = pq[1];
+		for (i = 0; i < src_cnt; i++)
+			tx->dma_src[i] = dma_src[i];
+		tx->dma_src_cnt = src_cnt;
+		tx->dma_len = len;
+
+		__async_tx_submit(chan, tx, async_syndrome_val_cb, tx, submit);
 
 		return tx;
 	} else {
-- 
1.8.0

