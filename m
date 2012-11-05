Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab2KEKB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:01:59 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46872 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab2KEKB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:01:56 -0500
X-AuditID: cbfee61b-b7f616d00000319b-29-50978e81ccfb
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 11/20] async_tx: do DMA unmap in core for MEMSET operations
Date: Mon, 05 Nov 2012 11:00:22 +0100
Message-id: <1352109631-3385-12-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t9jAd3GvukBBnMmm1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mnhl9rAU3BSp+zp/G1sB4j7eLkZNDQsBE4sWLVjYIW0ziwr31
	QDYXh5DAIkaJ5m9vWSGc1UwSa5d+ZwWpYhOwkpjYvooRxBYRUJDY3PsMrIhZ4BmjxIzb3cwg
	CWEBb4mdZ64BFXFwsAioSszZyA8S5hXwkNj97Qo7xDZ5iaf3+8A2cwLFGxumgM0XEnCXuNx5
	nHkCI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGME+fya9g3FVg8UhRgEORiUe3k8S
	0wOEWBPLiitzDzFKcDArifByMACFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8zZ7pAQICaQnlqRm
	p6YWpBbBZJk4OKUaGLekRK9yv5Jn7cVgvcvt9TuV+RXBE05O+Be8ncmsQEPD/6FTJOf3UuY1
	leIcmstSQj7aeH6e5PHYrv/rKe63Gzn8kuL0Cv6fOpDyvTFcYOb8x46SPH6Xrq5Oyr9xlHl+
	irrtyoqcd9N3pL064NC4cDvzVbMnu5Ojt7rvZOypOCw4++C0mVuP7lFiKc5INNRiLipOBACI
	40t+9QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert core async_tx code (async_memset()) to do DMA unmapping
itself using the ->callback functionality.

Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 crypto/async_tx/async_memset.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index a6a667b..cf30bf1 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -30,6 +30,17 @@
 #include <linux/dma-mapping.h>
 #include <linux/async_tx.h>
 
+static void async_memset_cb(void *dma_async_param)
+{
+	struct dma_async_tx_descriptor *tx = dma_async_param;
+	struct dma_device *dev = tx->chan->device;
+
+	dma_unmap_page(dev->dev, tx->dma_dst, tx->dma_len, DMA_FROM_DEVICE);
+
+	if (tx->orig_callback)
+		tx->orig_callback(tx->orig_callback_param);
+}
+
 /**
  * async_memset - attempt to fill memory with a dma engine.
  * @dest: destination page
@@ -47,10 +58,11 @@ async_memset(struct page *dest, int val, unsigned int offset, size_t len,
 						      &dest, 1, NULL, 0, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
+	dma_addr_t dma_dest;
 
 	if (device && is_dma_fill_aligned(device, offset, 0, len)) {
-		dma_addr_t dma_dest;
-		unsigned long dma_prep_flags = 0;
+		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
+					       DMA_COMPL_SKIP_DEST_UNMAP;
 
 		if (submit->cb_fn)
 			dma_prep_flags |= DMA_PREP_INTERRUPT;
@@ -68,7 +80,11 @@ async_memset(struct page *dest, int val, unsigned int offset, size_t len,
 
 	if (tx) {
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
-		async_tx_submit(chan, tx, submit);
+
+		tx->dma_dst = dma_dest;
+		tx->dma_len = len;
+
+		__async_tx_submit(chan, tx, async_memset_cb, tx, submit);
 	} else { /* run the memset synchronously */
 		void *dest_buf;
 		pr_debug("%s: (sync) len: %zu\n", __func__, len);
-- 
1.8.0

