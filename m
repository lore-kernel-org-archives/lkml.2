Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab2KEKCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:02:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62749 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab2KEKCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:02:17 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-48-50978e9bfb7a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 16/20] async_tx: do DMA unmap in async_raid6_recov.c for PQ
 operations
Date: Mon, 05 Nov 2012 11:00:27 +0100
Message-id: <1352109631-3385-17-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t9jAd3ZfdMDDH71s1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mp2c/Mhe8kquY8vMNawPjCskuRk4OCQETibkXVrJD2GISF+6t
	Z+ti5OIQEljEKHFj0g5mkISQwGomiQ1vZEFsNgEriYntqxhBbBEBBYnNvc9YQRqYBZ4xSsy4
	3Q3WICwQIfHqwTFWEJtFQFXi5OUzbCA2r4CHxP0v71ghtslLPL3fBxbnBIo3NkxhhVjmLnG5
	8zjzBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCff5MagfjygaLQ4wCHIxKPLwz
	xaYHCLEmlhVX5h5ilOBgVhLh5WAACvGmJFZWpRblxxeV5qQWH2KU5mBREudt9kgJEBJITyxJ
	zU5NLUgtgskycXBKNTBGycf/ctwvpmUu5MaqUBEed7ah3mvnvFM9tzNtX7+VueoyTYPToUiF
	LVQ5Ururx/PJ/9Lbcxwuz10tUqFhwtgZmvuXv3sFxyRjT3PG9+XcHixZKnYi/N/5JjPP6E/4
	OME18M++ol9cXIzTmW89PFe7TGtviMKj4gNPZsl83PO4q/bsv32LwpVYijMSDbWYi4oTAV96
	okz1AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert core async_tx code (async_sum_product() and async_mult())
to do DMA unmapping itself using the ->callback functionality.

Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 crypto/async_tx/async_raid6_recov.c | 50 ++++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 4 deletions(-)

diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index a9f08a6..3db97aa 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -27,6 +27,20 @@
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
 
+static void async_sum_product_cb(void *dma_async_param)
+{
+	struct dma_async_tx_descriptor *tx = dma_async_param;
+	struct dma_device *dev = tx->chan->device;
+
+	dma_unmap_page(dev->dev, tx->dma_dst[1], tx->dma_len,
+		       DMA_BIDIRECTIONAL);
+	dma_unmap_page(dev->dev, tx->dma_src[0], tx->dma_len, DMA_TO_DEVICE);
+	dma_unmap_page(dev->dev, tx->dma_src[1], tx->dma_len, DMA_TO_DEVICE);
+
+	if (tx->orig_callback)
+		tx->orig_callback(tx->orig_callback_param);
+}
+
 static struct dma_async_tx_descriptor *
 async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 		  size_t len, struct async_submit_ctl *submit)
@@ -43,7 +57,9 @@ async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 		dma_addr_t dma_src[2];
 		struct device *dev = dma->dev;
 		struct dma_async_tx_descriptor *tx;
-		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
+		enum dma_ctrl_flags dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
+						DMA_COMPL_SKIP_DEST_UNMAP |
+						DMA_PREP_PQ_DISABLE_P;
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
@@ -53,7 +69,13 @@ async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 		tx = dma->device_prep_dma_pq(chan, dma_dest, dma_src, 2, coef,
 					     len, dma_flags);
 		if (tx) {
-			async_tx_submit(chan, tx, submit);
+			tx->dma_dst[1] = dma_dest[1];
+			tx->dma_src[0] = dma_src[0];
+			tx->dma_src[1] = dma_src[1];
+			tx->dma_len = len;
+
+			__async_tx_submit(chan, tx, async_sum_product_cb, tx,
+					  submit);
 			return tx;
 		}
 
@@ -82,6 +104,20 @@ async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 	return NULL;
 }
 
+static void async_mult_cb(void *dma_async_param)
+{
+	struct dma_async_tx_descriptor *tx = dma_async_param;
+	struct dma_device *dev = tx->chan->device;
+
+	dma_unmap_page(dev->dev, tx->dma_dst[1], tx->dma_len,
+		       DMA_BIDIRECTIONAL);
+	dma_unmap_page(dev->dev, tx->dma_src[0], tx->dma_len,
+		       DMA_TO_DEVICE);
+
+	if (tx->orig_callback)
+		tx->orig_callback(tx->orig_callback_param);
+}
+
 static struct dma_async_tx_descriptor *
 async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 	   struct async_submit_ctl *submit)
@@ -97,7 +133,9 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 		dma_addr_t dma_src[1];
 		struct device *dev = dma->dev;
 		struct dma_async_tx_descriptor *tx;
-		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
+		enum dma_ctrl_flags dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
+						DMA_COMPL_SKIP_DEST_UNMAP |
+						DMA_PREP_PQ_DISABLE_P;
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
@@ -106,7 +144,11 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 		tx = dma->device_prep_dma_pq(chan, dma_dest, dma_src, 1, &coef,
 					     len, dma_flags);
 		if (tx) {
-			async_tx_submit(chan, tx, submit);
+			tx->dma_dst[1] = dma_dest[1];
+			tx->dma_src[0] = dma_src[0];
+			tx->dma_len = len;
+
+			__async_tx_submit(chan, tx, async_mult_cb, tx, submit);
 			return tx;
 		}
 
-- 
1.8.0

