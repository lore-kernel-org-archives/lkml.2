Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab2IDMVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:21:04 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64030 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab2IDMVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:21:02 -0400
From: benjamin.gaignard@linaro.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        ying.huang@intel.com, imre.deak@nokia.com
Cc: Benjamin Gaignard <benjamin.gaignard@stericsson.com>
Subject: [PATCH] genalloc: add best fit algorithm
Date: Tue,  4 Sep 2012 14:20:29 +0200
Message-Id: <1346761229-27228-1-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Gaignard <benjamin.gaignard@stericsson.com>

Allow genalloc to use another algorithm than first-fit one.
Add a best-fit algorithm.

Change-Id: Ie783c9f9687c08195b4cb1914856cd6aca50c611
Signed-off-by: Benjamin Gaignard <benjamin.gaignard@stericsson.com>
---
 include/linux/genalloc.h |   28 +++++++++++++++
 lib/genalloc.c           |   85 +++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 109 insertions(+), 4 deletions(-)

diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index 5e98eeb..b974998 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -36,6 +36,13 @@ struct gen_pool {
 	spinlock_t lock;
 	struct list_head chunks;	/* list of chunks in this pool */
 	int min_alloc_order;		/* minimum allocation order */
+
+	unsigned long (*algo)(void *priv,
+			unsigned long *map,
+			unsigned long size,
+			unsigned long start,
+			unsigned int nr);
+	void *priv_data;
 };
 
 /*
@@ -78,4 +85,25 @@ extern void gen_pool_for_each_chunk(struct gen_pool *,
 	void (*)(struct gen_pool *, struct gen_pool_chunk *, void *), void *);
 extern size_t gen_pool_avail(struct gen_pool *);
 extern size_t gen_pool_size(struct gen_pool *);
+
+extern void gen_pool_set_algo(struct gen_pool *pool, void *priv,
+	unsigned long (*algo)(
+		void *priv,
+		unsigned long *map,
+		unsigned long size,
+		unsigned long start,
+		unsigned int nr));
+
+extern unsigned long gen_pool_first_fit(void *priv,
+			unsigned long *map,
+			unsigned long size,
+			unsigned long start,
+			unsigned int nr);
+
+extern unsigned long gen_pool_best_fit(void *priv,
+			unsigned long *map,
+			unsigned long size,
+			unsigned long start,
+			unsigned int nr);
+
 #endif /* __GENALLOC_H__ */
diff --git a/lib/genalloc.c b/lib/genalloc.c
index 6bc04aa..fdc4e72 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -152,6 +152,8 @@ struct gen_pool *gen_pool_create(int min_alloc_order, int nid)
 		spin_lock_init(&pool->lock);
 		INIT_LIST_HEAD(&pool->chunks);
 		pool->min_alloc_order = min_alloc_order;
+		pool->algo = gen_pool_first_fit;
+		pool->priv_data = NULL;
 	}
 	return pool;
 }
@@ -255,8 +257,9 @@ EXPORT_SYMBOL(gen_pool_destroy);
  * @size: number of bytes to allocate from the pool
  *
  * Allocate the requested number of bytes from the specified pool.
- * Uses a first-fit algorithm. Can not be used in NMI handler on
- * architectures without NMI-safe cmpxchg implementation.
+ * Uses the pool allocation function (first-fit algorithm by default).
+ * Can not be used in NMI handler on architectures without
+ * NMI-safe cmpxchg implementation.
  */
 unsigned long gen_pool_alloc(struct gen_pool *pool, size_t size)
 {
@@ -280,8 +283,8 @@ unsigned long gen_pool_alloc(struct gen_pool *pool, size_t size)
 
 		end_bit = (chunk->end_addr - chunk->start_addr) >> order;
 retry:
-		start_bit = bitmap_find_next_zero_area(chunk->bits, end_bit,
-						       start_bit, nbits, 0);
+		start_bit = pool->algo(pool->priv_data, chunk->bits, end_bit,
+				       start_bit, nbits);
 		if (start_bit >= end_bit)
 			continue;
 		remain = bitmap_set_ll(chunk->bits, start_bit, nbits);
@@ -400,3 +403,77 @@ size_t gen_pool_size(struct gen_pool *pool)
 	return size;
 }
 EXPORT_SYMBOL_GPL(gen_pool_size);
+
+/**
+ * gen_pool_set_algo - set the allocation algorithm
+ * @pool: pool to change allocation algorithm
+ * @priv: private data to be pass to algorithm function
+ * @algo: custom algorithm function
+ */
+void gen_pool_set_algo(struct gen_pool *pool, void *priv,
+	unsigned long (*algo)(void *priv, unsigned long *map,
+	unsigned long size, unsigned long start, unsigned int nr))
+{
+	rcu_read_lock();
+
+	pool->algo = algo;
+	if (!pool->algo)
+		pool->algo = gen_pool_first_fit;
+
+	pool->priv_data = priv;
+
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(gen_pool_set_algo);
+
+/**
+ * gen_pool_first_fit - find the first available region
+ * of memory macthing the size requirement (no alignment constraint)
+ * @priv: private data - unused
+ * @map: The address to base the search on
+ * @size: The bitmap size in bits
+ * @start: The bitnumber to start searching at
+ * @nr: The number of zeroed bits we're looking for
+ */
+unsigned long gen_pool_first_fit(void *priv, unsigned long *map,
+		unsigned long size,	unsigned long start, unsigned int nr)
+{
+	return bitmap_find_next_zero_area(map, size, start, nr, 0);
+}
+EXPORT_SYMBOL(gen_pool_first_fit);
+
+/**
+ * gen_pool_best_fit - find the best fiting region of memory
+ * @priv: private data - unused
+ * @map: The address to base the search on
+ * @size: The bitmap size in bits
+ * @start: The bitnumber to start searching at
+ * @nr: The number of zeroed bits we're looking for
+ *
+ * iterate over the bitmap to find the smaller region where we
+ * can allocate the memory.
+ */
+unsigned long gen_pool_best_fit(void *priv, unsigned long *map,
+		unsigned long size,	unsigned long start, unsigned int nr)
+{
+	unsigned long start_bit = size;
+	unsigned long len = size + 1;
+	unsigned long index;
+
+	index = bitmap_find_next_zero_area(map, size, start, nr, 0);
+
+	while (index < size) {
+		int next_bit = find_next_bit(map, size, index + nr);
+		if ((next_bit - index) < len) {
+			len = next_bit - index;
+			start_bit = index;
+			if (len == nr)
+				return start_bit;
+		}
+		index = bitmap_find_next_zero_area(map, size,
+						   next_bit + 1, nr, 0);
+	}
+
+	return start_bit;
+}
+EXPORT_SYMBOL(gen_pool_best_fit);
-- 
1.7.10

