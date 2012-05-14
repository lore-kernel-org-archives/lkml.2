Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab2ENNu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:50:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58329 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2ENNu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:50:57 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Jiang Liu <jiang.liu@huawei.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>
Subject: [RFC PATCH v2 5/7] dmaengine: enhance ASYNC_TX subsystem to support DMA device hotplug
Date: Mon, 14 May 2012 21:47:07 +0800
Message-Id: <1337003229-9158-6-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1337003229-9158-1-git-send-email-jiang.liu@huawei.com>
References: <1337003229-9158-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Enhance ASYNC_TX subsystem to correctly update DMA channel reference counts,
so it won't break DMA device hotplug logic.

Signed-off-by: Jiang Liu <liuj97@gmail.com>
---
 crypto/async_tx/async_memcpy.c      |    2 ++
 crypto/async_tx/async_memset.c      |    2 ++
 crypto/async_tx/async_pq.c          |   10 ++++++++--
 crypto/async_tx/async_raid6_recov.c |    8 ++++++--
 crypto/async_tx/async_tx.c          |    6 +++---
 crypto/async_tx/async_xor.c         |   13 +++++++++----
 include/linux/async_tx.h            |   13 +++++++++++++
 include/linux/dmaengine.h           |   14 ++++++++++++++
 8 files changed, 57 insertions(+), 11 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 361b5e8..0cbd90e 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -90,6 +90,8 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 		async_tx_sync_epilog(submit);
 	}
 
+	async_tx_put_channel(chan);
+
 	return tx;
 }
 EXPORT_SYMBOL_GPL(async_memcpy);
diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index 58e4a87..ec568bb 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -79,6 +79,8 @@ async_memset(struct page *dest, int val, unsigned int offset, size_t len,
 		async_tx_sync_epilog(submit);
 	}
 
+	async_tx_put_channel(chan);
+
 	return tx;
 }
 EXPORT_SYMBOL_GPL(async_memset);
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 91d5d38..ae2070c 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -203,6 +203,7 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 						      blocks, src_cnt, len);
 	struct dma_device *device = chan ? chan->device : NULL;
 	dma_addr_t *dma_src = NULL;
+	struct dma_async_tx_descriptor *tx;
 
 	BUG_ON(disks > 255 || !(P(blocks, disks) || Q(blocks, disks)));
 
@@ -218,12 +219,15 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
 		/* run the p+q asynchronously */
 		pr_debug("%s: (async) disks: %d len: %zu\n",
 			 __func__, disks, len);
-		return do_async_gen_syndrome(chan, blocks, raid6_gfexp, offset,
-					     disks, len, dma_src, submit);
+		tx = do_async_gen_syndrome(chan, blocks, raid6_gfexp, offset,
+					   disks, len, dma_src, submit);
+		async_tx_put_channel(chan);
+		return tx;
 	}
 
 	/* run the pq synchronously */
 	pr_debug("%s: (sync) disks: %d len: %zu\n", __func__, disks, len);
+	async_tx_put_channel(chan);
 
 	/* wait for any prerequisite operations */
 	async_tx_quiesce(&submit->depend_tx);
@@ -331,6 +335,7 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 			dma_async_issue_pending(chan);
 		}
 		async_tx_submit(chan, tx, submit);
+		async_tx_put_channel(chan);
 
 		return tx;
 	} else {
@@ -344,6 +349,7 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
 
 		pr_debug("%s: (sync) disks: %d len: %zu\n",
 			 __func__, disks, len);
+		async_tx_put_channel(chan);
 
 		/* caller must provide a temporary result buffer and
 		 * allow the input parameters to be preserved
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index a9f08a6..0f54d7c 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -54,6 +54,7 @@ async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 					     len, dma_flags);
 		if (tx) {
 			async_tx_submit(chan, tx, submit);
+			async_tx_put_channel(chan);
 			return tx;
 		}
 
@@ -66,6 +67,7 @@ async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 	}
 
 	/* run the operation synchronously */
+	async_tx_put_channel(chan);
 	async_tx_quiesce(&submit->depend_tx);
 	amul = raid6_gfmul[coef[0]];
 	bmul = raid6_gfmul[coef[1]];
@@ -107,6 +109,7 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 					     len, dma_flags);
 		if (tx) {
 			async_tx_submit(chan, tx, submit);
+			async_tx_put_channel(chan);
 			return tx;
 		}
 
@@ -120,6 +123,7 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 	/* no channel available, or failed to allocate a descriptor, so
 	 * perform the operation synchronously
 	 */
+	async_tx_put_channel(chan);
 	async_tx_quiesce(&submit->depend_tx);
 	qmul  = raid6_gfmul[coef];
 	d = page_address(dest);
@@ -339,7 +343,7 @@ async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
 	 * available' case be sure to use the scribble buffer to
 	 * preserve the content of 'blocks' as the caller intended.
 	 */
-	if (!async_dma_find_channel(DMA_PQ) || !scribble) {
+	if (!async_tx_has_capability(DMA_PQ) || !scribble) {
 		void **ptrs = scribble ? scribble : (void **) blocks;
 
 		async_tx_quiesce(&submit->depend_tx);
@@ -415,7 +419,7 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 	 * available' case be sure to use the scribble buffer to
 	 * preserve the content of 'blocks' as the caller intended.
 	 */
-	if (!async_dma_find_channel(DMA_PQ) || !scribble) {
+	if (!async_tx_has_capability(DMA_PQ) || !scribble) {
 		void **ptrs = scribble ? scribble : (void **) blocks;
 
 		async_tx_quiesce(&submit->depend_tx);
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 8421209..6fe6561 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -47,8 +47,8 @@ module_init(async_tx_init);
 module_exit(async_tx_exit);
 
 /**
- * __async_tx_find_channel - find a channel to carry out the operation or let
- *	the transaction execute synchronously
+ * __async_tx_find_channel - find and hold a channel to carry out the
+ * operation or let the transaction execute synchronously
  * @submit: transaction dependency and submission modifiers
  * @tx_type: transaction type
  */
@@ -61,7 +61,7 @@ __async_tx_find_channel(struct async_submit_ctl *submit,
 	/* see if we can keep the chain on one channel */
 	if (depend_tx &&
 	    dma_has_cap(tx_type, depend_tx->chan->device->cap_mask))
-		return depend_tx->chan;
+		return async_dma_get_channel(depend_tx->chan);
 	return async_dma_find_channel(tx_type);
 }
 EXPORT_SYMBOL_GPL(__async_tx_find_channel);
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index 154cc84..056e248 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -190,6 +190,7 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 						      &dest, 1, src_list,
 						      src_cnt, len);
 	dma_addr_t *dma_src = NULL;
+	struct dma_async_tx_descriptor *tx = NULL;
 
 	BUG_ON(src_cnt <= 1);
 
@@ -202,8 +203,8 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 		/* run the xor asynchronously */
 		pr_debug("%s (async): len: %zu\n", __func__, len);
 
-		return do_async_xor(chan, dest, src_list, offset, src_cnt, len,
-				    dma_src, submit);
+		tx = do_async_xor(chan, dest, src_list, offset, src_cnt, len,
+				  dma_src, submit);
 	} else {
 		/* run the xor synchronously */
 		pr_debug("%s (sync): len: %zu\n", __func__, len);
@@ -222,9 +223,11 @@ async_xor(struct page *dest, struct page **src_list, unsigned int offset,
 		async_tx_quiesce(&submit->depend_tx);
 
 		do_sync_xor(dest, src_list, offset, src_cnt, len, submit);
-
-		return NULL;
 	}
+
+	async_tx_put_channel(chan);
+
+	return tx;
 }
 EXPORT_SYMBOL_GPL(async_xor);
 
@@ -330,6 +333,8 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 		submit->flags = flags_orig;
 	}
 
+	async_tx_put_channel(chan);
+
 	return tx;
 }
 EXPORT_SYMBOL_GPL(async_xor_val);
diff --git a/include/linux/async_tx.h b/include/linux/async_tx.h
index a1c486a..35dea72 100644
--- a/include/linux/async_tx.h
+++ b/include/linux/async_tx.h
@@ -104,6 +104,10 @@ static inline void async_tx_issue_pending(struct dma_async_tx_descriptor *tx)
 		dma->device_issue_pending(chan);
 	}
 }
+
+#define async_tx_put_channel(c)		async_dma_put_channel(c)
+#define async_tx_has_capability(c)	async_dma_has_capability(c)
+
 #ifdef CONFIG_ARCH_HAS_ASYNC_TX_FIND_CHANNEL
 #include <asm/async_tx.h>
 #else
@@ -132,6 +136,15 @@ async_tx_find_channel(struct async_submit_ctl *submit,
 {
 	return NULL;
 }
+
+static inline void async_tx_put_channel(struct dma_chan *chan)
+{
+}
+
+static inline bool async_tx_has_capability(enum dma_transaction_type type)
+{
+	return false;
+}
 #endif
 
 /**
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index e099b28..197bb71 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -785,6 +785,9 @@ static inline void net_dmaengine_put(void)
 #else
 #define async_dma_find_channel(type) dma_find_channel(type)
 #endif /* CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH */
+#define async_dma_get_channel(chan) dma_get_channel(chan)
+#define async_dma_put_channel(chan) dma_put_channel(chan)
+#define async_dma_has_capability(c) dma_has_capability(c)
 #else
 static inline void async_dmaengine_get(void)
 {
@@ -797,6 +800,17 @@ async_dma_find_channel(enum dma_transaction_type type)
 {
 	return NULL;
 }
+static inline struct dma_chan *async_dma_get_channel(struct dma_chan *chan)
+{
+	return chan;
+}
+static inline void async_dma_put_channel(struct dma_chan *chan)
+{
+}
+static inline bool async_dma_has_capability(enum dma_transaction_type type)
+{
+	return false;
+}
 #endif /* CONFIG_ASYNC_TX_DMA */
 
 dma_cookie_t dma_async_memcpy_buf_to_buf(struct dma_chan *chan,
-- 
1.7.9.5

