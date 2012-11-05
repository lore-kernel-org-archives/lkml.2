Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab2KEKBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:01:24 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26098 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab2KEKBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:01:22 -0500
X-AuditID: cbfee61b-b7f616d00000319b-9a-50978e7044ad
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 07/20] async_tx: do DMA unmap in core for MEMCPY operations
Date: Mon, 05 Nov 2012 11:00:18 +0100
Message-id: <1352109631-3385-8-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t9jAd2CvukBBitXWlpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MDRu3shU81a24vP4kcwPjArUuRk4OCQETiaapD1ghbDGJC/fW
	s3UxcnEICSxilPh/+TILhLOaSeJp71l2kCo2ASuJie2rGEFsEQEFic29z1hBipgFnjFKzLjd
	zQySEBbwlujsmMUEYrMIqEr8m34QLM4r4C4x6c4ZqHXyEk/v97GB2JwCHhKNDVPA4kJANZc7
	jzNPYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyPY68+kdzCuarA4xCjAwajEw/tJ
	YnqAEGtiWXFl7iFGCQ5mJRFeDgagEG9KYmVValF+fFFpTmrxIUZpDhYlcd5mj5QAIYH0xJLU
	7NTUgtQimCwTB6dUA6NHbmbv5k8P/vptC1/gPVk/bsH0tnOiW/+Fq11d8qJnj2DHQgWe0C5W
	m4sThP/3i83nKvhvEmxpM6tK3m1v5JN9UkeFbxfxRjLyZswtm1/NejjkSZKJky9/qtIjuVC5
	7qTJEitK1n4XfBfxYl1AqabNnt8t9+cZNWzJ/qO0uLHr//eYdScYpJVYijMSDbWYi4oTAcET
	kgD2AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add orig_callback and orig_callback_param to struct
dma_async_tx_descriptor for storing original dma_async_tx_callback
function and its parameter.  Teach async_tx_submit() about these
new parameters, to allow passing them to async_tx_submit(), rename
the function to __async_tx_submit(), add the new async_tx_submit()
wrapper to preserve the original functionality and convert core
async_tx code (async_memcpy()) to do DMA unmapping itself using
the ->callback functionality.

Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 crypto/async_tx/async_memcpy.c | 24 +++++++++++++++++++++---
 crypto/async_tx/async_tx.c     | 25 +++++++++++++++++++++----
 include/linux/async_tx.h       |  4 ++++
 include/linux/dmaengine.h      |  4 ++++
 4 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 9e62fef..b6d5dab 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -30,6 +30,18 @@
 #include <linux/dma-mapping.h>
 #include <linux/async_tx.h>
 
+static void async_memcpy_cb(void *dma_async_param)
+{
+	struct dma_async_tx_descriptor *tx = dma_async_param;
+	struct dma_device *dev = tx->chan->device;
+
+	dma_unmap_page(dev->dev, tx->dma_src, tx->dma_len, DMA_TO_DEVICE);
+	dma_unmap_page(dev->dev, tx->dma_dst, tx->dma_len, DMA_FROM_DEVICE);
+
+	if (tx->orig_callback)
+		tx->orig_callback(tx->orig_callback_param);
+}
+
 /**
  * async_memcpy - attempt to copy memory with a dma engine.
  * @dest: destination page
@@ -50,10 +62,11 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 						      &dest, 1, &src, 1, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	struct dma_async_tx_descriptor *tx = NULL;
+	dma_addr_t dma_dest, dma_src;
 
 	if (device && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
-		dma_addr_t dma_dest, dma_src;
-		unsigned long dma_prep_flags = 0;
+		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
+					       DMA_COMPL_SKIP_DEST_UNMAP;
 
 		if (submit->cb_fn)
 			dma_prep_flags |= DMA_PREP_INTERRUPT;
@@ -77,7 +90,12 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 
 	if (tx) {
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
-		async_tx_submit(chan, tx, submit);
+
+		tx->dma_src = dma_src;
+		tx->dma_dst = dma_dest;
+		tx->dma_len = len;
+
+		__async_tx_submit(chan, tx, async_memcpy_cb, tx, submit);
 	} else {
 		void *dest_buf, *src_buf;
 		pr_debug("%s: (sync) len: %zu\n", __func__, len);
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 8421209..d4335fe 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -153,13 +153,22 @@ enum submit_disposition {
 };
 
 void
-async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
-		struct async_submit_ctl *submit)
+__async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
+		  dma_async_tx_callback cb_fn, void *cb_param,
+		  struct async_submit_ctl *submit)
 {
 	struct dma_async_tx_descriptor *depend_tx = submit->depend_tx;
 
-	tx->callback = submit->cb_fn;
-	tx->callback_param = submit->cb_param;
+	if (cb_fn) {
+		tx->orig_callback = submit->cb_fn;
+		tx->orig_callback_param = submit->cb_param;
+
+		tx->callback = cb_fn;
+		tx->callback_param = cb_param;
+	} else {
+		tx->callback = submit->cb_fn;
+		tx->callback_param = submit->cb_param;
+	}
 
 	if (depend_tx) {
 		enum submit_disposition s;
@@ -220,6 +229,14 @@ async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
 	if (depend_tx)
 		async_tx_ack(depend_tx);
 }
+EXPORT_SYMBOL_GPL(__async_tx_submit);
+
+void
+async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
+		struct async_submit_ctl *submit)
+{
+	__async_tx_submit(chan, tx, NULL, NULL, submit);
+}
 EXPORT_SYMBOL_GPL(async_tx_submit);
 
 /**
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index a1c486a..cf21d49 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -165,6 +165,10 @@ init_async_submit(struct async_submit_ctl *args, enum async_tx_flags flags,
 	args->scribble = scribble;
 }
 
+void __async_tx_submit(struct dma_chan *chan,
+		       struct dma_async_tx_descriptor *tx,
+		       dma_async_tx_callback cb_fn, void *cb_param,
+		       struct async_submit_ctl *submit);
 void async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
 		     struct async_submit_ctl *submit);
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 8741d57..440b609 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -408,6 +408,8 @@ typedef void (*dma_async_tx_callback)(void *dma_async_param);
  * @callback: routine to call after this operation is complete
  * @callback_param: general parameter to pass to the callback routine
  * ---async_tx api specific fields---
+ * @orig_callback: optional routine to call from the callback routine
+ * @orig_callback_param: parameter to pass to the orig_callback routine
  * @next: at completion submit this descriptor
  * @parent: pointer to the next level up in the dependency chain
  * @lock: protect the parent and next pointers
@@ -423,6 +425,8 @@ struct dma_async_tx_descriptor {
 	size_t dma_len;
 	dma_async_tx_callback callback;
 	void *callback_param;
+	dma_async_tx_callback orig_callback;
+	void *orig_callback_param;
 #ifdef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	struct dma_async_tx_descriptor *next;
 	struct dma_async_tx_descriptor *parent;
-- 
1.8.0

