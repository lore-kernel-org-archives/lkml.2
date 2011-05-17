Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1EQIJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:09:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:18452 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab1EQIIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:08:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,224,1304319600"; 
   d="scan'208";a="2661636"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/9] lib, Make gen_pool memory allocator lockless
Date: Tue, 17 May 2011 16:08:33 +0800
Message-Id: <1305619719-7480-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
References: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version of the gen_pool memory allocator supports lockless
operation.

This makes it safe to use in NMI handlers and other special
unblockable contexts that could otherwise deadlock on locks.  This is
implemented by using atomic operations and retries on any conflicts.
The disadvantage is that there may be livelocks in extreme cases.  For
better scalability, one gen_pool allocator can be used for each CPU.

The lockless operation only works if there is enough memory available.
If new memory is added to the pool a lock has to be still taken.  So
any user relying on locklessness has to ensure that sufficient memory
is preallocated.

The basic atomic operation of this allocator is cmpxchg on long.  On
architectures that don't have NMI-safe cmpxchg implementation, the
allocator can NOT be used in NMI handler.  So code uses the allocator
in NMI handler should depend on CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/bitmap.h   |    1 
 include/linux/genalloc.h |   37 +++++-
 lib/bitmap.c             |    2 
 lib/genalloc.c           |  284 ++++++++++++++++++++++++++++++++++++++---------
 4 files changed, 267 insertions(+), 57 deletions(-)

--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -142,6 +142,7 @@ extern void bitmap_release_region(unsign
 extern int bitmap_allocate_region(unsigned long *bitmap, int pos, int order);
 extern void bitmap_copy_le(void *dst, const unsigned long *src, int nbits);
 
+#define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) % BITS_PER_LONG))
 #define BITMAP_LAST_WORD_MASK(nbits)					\
 (									\
 	((nbits) % BITS_PER_LONG) ?					\
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -1,8 +1,28 @@
+#ifndef GENALLOC_H
+#define GENALLOC_H
 /*
- * Basic general purpose allocator for managing special purpose memory
- * not managed by the regular kmalloc/kfree interface.
- * Uses for this includes on-device special memory, uncached memory
- * etc.
+ * Basic general purpose allocator for managing special purpose
+ * memory, for example, memory that is not managed by the regular
+ * kmalloc/kfree interface.  Uses for this includes on-device special
+ * memory, uncached memory etc.
+ *
+ * It is safe to use the allocator in NMI handlers and other special
+ * unblockable contexts that could otherwise deadlock on locks.  This
+ * is implemented by using atomic operations and retries on any
+ * conflicts.  The disadvantage is that there may be livelocks in
+ * extreme cases.  For better scalability, one allocator can be used
+ * for each CPU.
+ *
+ * The lockless operation only works if there is enough memory
+ * available.  If new memory is added to the pool a lock has to be
+ * still taken.  So any user relying on locklessness has to ensure
+ * that sufficient memory is preallocated.
+ *
+ * The basic atomic operation of this allocator is cmpxchg on long.
+ * On architectures that don't have NMI-safe cmpxchg implementation,
+ * the allocator can NOT be used in NMI handler.  So code uses the
+ * allocator in NMI handler should depend on
+ * CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
  *
  * This source code is licensed under the GNU General Public License,
  * Version 2.  See the file COPYING for more details.
@@ -13,7 +33,7 @@
  *  General purpose special memory pool descriptor.
  */
 struct gen_pool {
-	rwlock_t lock;
+	spinlock_t lock;
 	struct list_head chunks;	/* list of chunks in this pool */
 	int min_alloc_order;		/* minimum allocation order */
 };
@@ -22,8 +42,8 @@ struct gen_pool {
  *  General purpose special memory pool chunk descriptor.
  */
 struct gen_pool_chunk {
-	spinlock_t lock;
 	struct list_head next_chunk;	/* next chunk in pool */
+	atomic_t avail;
 	unsigned long start_addr;	/* starting address of memory chunk */
 	unsigned long end_addr;		/* ending address of memory chunk */
 	unsigned long bits[0];		/* bitmap for allocating memory chunk */
@@ -34,3 +54,8 @@ extern int gen_pool_add(struct gen_pool
 extern void gen_pool_destroy(struct gen_pool *);
 extern unsigned long gen_pool_alloc(struct gen_pool *, size_t);
 extern void gen_pool_free(struct gen_pool *, unsigned long, size_t);
+extern void gen_pool_for_each_chunk(struct gen_pool *,
+	void (*)(struct gen_pool *, struct gen_pool_chunk *, void *), void *);
+extern size_t gen_pool_avail(struct gen_pool *);
+extern size_t gen_pool_size(struct gen_pool *);
+#endif /* GENALLOC_H */
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -271,8 +271,6 @@ int __bitmap_weight(const unsigned long
 }
 EXPORT_SYMBOL(__bitmap_weight);
 
-#define BITMAP_FIRST_WORD_MASK(start) (~0UL << ((start) % BITS_PER_LONG))
-
 void bitmap_set(unsigned long *map, int start, int nr)
 {
 	unsigned long *p = map + BIT_WORD(start);
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -1,8 +1,26 @@
 /*
- * Basic general purpose allocator for managing special purpose memory
- * not managed by the regular kmalloc/kfree interface.
- * Uses for this includes on-device special memory, uncached memory
- * etc.
+ * Basic general purpose allocator for managing special purpose
+ * memory, for example, memory that is not managed by the regular
+ * kmalloc/kfree interface.  Uses for this includes on-device special
+ * memory, uncached memory etc.
+ *
+ * It is safe to use the allocator in NMI handlers and other special
+ * unblockable contexts that could otherwise deadlock on locks.  This
+ * is implemented by using atomic operations and retries on any
+ * conflicts.  The disadvantage is that there may be livelocks in
+ * extreme cases.  For better scalability, one allocator can be used
+ * for each CPU.
+ *
+ * The lockless operation only works if there is enough memory
+ * available.  If new memory is added to the pool a lock has to be
+ * still taken.  So any user relying on locklessness has to ensure
+ * that sufficient memory is preallocated.
+ *
+ * The basic atomic operation of this allocator is cmpxchg on long.
+ * On architectures that don't have NMI-safe cmpxchg implementation,
+ * the allocator can NOT be used in NMI handler.  So code uses the
+ * allocator in NMI handler should depend on
+ * CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG.
  *
  * Copyright 2005 (C) Jes Sorensen <jes@trained-monkey.org>
  *
@@ -13,8 +31,109 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/bitmap.h>
+#include <linux/rculist.h>
+#include <linux/interrupt.h>
 #include <linux/genalloc.h>
 
+static int set_bits_ll(unsigned long *addr, unsigned long mask_to_set)
+{
+	unsigned long val, nval;
+
+	nval = *addr;
+	do {
+		val = nval;
+		if (val & mask_to_set)
+			return -EBUSY;
+		cpu_relax();
+	} while ((nval = cmpxchg(addr, val, val | mask_to_set)) != val);
+
+	return 0;
+}
+
+static int clear_bits_ll(unsigned long *addr, unsigned long mask_to_clear)
+{
+	unsigned long val, nval;
+
+	nval = *addr;
+	do {
+		val = nval;
+		if ((val & mask_to_clear) != mask_to_clear)
+			return -EBUSY;
+		cpu_relax();
+	} while ((nval = cmpxchg(addr, val, val & ~mask_to_clear)) != val);
+
+	return 0;
+}
+
+/*
+ * bitmap_set_ll - set the specified number of bits at the specified position
+ * @map: pointer to a bitmap
+ * @start: a bit position in @map
+ * @nr: number of bits to set
+ *
+ * Set @nr bits start from @start in @map lock-lessly. Several users
+ * can set/clear the same bitmap simultaneously without lock. If two
+ * users set the same bit, one user will return remain bits, otherwise
+ * return 0.
+ */
+static int bitmap_set_ll(unsigned long *map, int start, int nr)
+{
+	unsigned long *p = map + BIT_WORD(start);
+	const int size = start + nr;
+	int bits_to_set = BITS_PER_LONG - (start % BITS_PER_LONG);
+	unsigned long mask_to_set = BITMAP_FIRST_WORD_MASK(start);
+
+	while (nr - bits_to_set >= 0) {
+		if (set_bits_ll(p, mask_to_set))
+			return nr;
+		nr -= bits_to_set;
+		bits_to_set = BITS_PER_LONG;
+		mask_to_set = ~0UL;
+		p++;
+	}
+	if (nr) {
+		mask_to_set &= BITMAP_LAST_WORD_MASK(size);
+		if (set_bits_ll(p, mask_to_set))
+			return nr;
+	}
+
+	return 0;
+}
+
+/*
+ * bitmap_clear_ll - clear the specified number of bits at the specified position
+ * @map: pointer to a bitmap
+ * @start: a bit position in @map
+ * @nr: number of bits to set
+ *
+ * Clear @nr bits start from @start in @map lock-lessly. Several users
+ * can set/clear the same bitmap simultaneously without lock. If two
+ * users clear the same bit, one user will return remain bits,
+ * otherwise return 0.
+ */
+static int bitmap_clear_ll(unsigned long *map, int start, int nr)
+{
+	unsigned long *p = map + BIT_WORD(start);
+	const int size = start + nr;
+	int bits_to_clear = BITS_PER_LONG - (start % BITS_PER_LONG);
+	unsigned long mask_to_clear = BITMAP_FIRST_WORD_MASK(start);
+
+	while (nr - bits_to_clear >= 0) {
+		if (clear_bits_ll(p, mask_to_clear))
+			return nr;
+		nr -= bits_to_clear;
+		bits_to_clear = BITS_PER_LONG;
+		mask_to_clear = ~0UL;
+		p++;
+	}
+	if (nr) {
+		mask_to_clear &= BITMAP_LAST_WORD_MASK(size);
+		if (clear_bits_ll(p, mask_to_clear))
+			return nr;
+	}
+
+	return 0;
+}
 
 /**
  * gen_pool_create - create a new special memory pool
@@ -30,7 +149,7 @@ struct gen_pool *gen_pool_create(int min
 
 	pool = kmalloc_node(sizeof(struct gen_pool), GFP_KERNEL, nid);
 	if (pool != NULL) {
-		rwlock_init(&pool->lock);
+		spin_lock_init(&pool->lock);
 		INIT_LIST_HEAD(&pool->chunks);
 		pool->min_alloc_order = min_alloc_order;
 	}
@@ -58,15 +177,15 @@ int gen_pool_add(struct gen_pool *pool,
 
 	chunk = kmalloc_node(nbytes, GFP_KERNEL | __GFP_ZERO, nid);
 	if (unlikely(chunk == NULL))
-		return -1;
+		return -ENOMEM;
 
-	spin_lock_init(&chunk->lock);
 	chunk->start_addr = addr;
 	chunk->end_addr = addr + size;
+	atomic_set(&chunk->avail, size);
 
-	write_lock(&pool->lock);
-	list_add(&chunk->next_chunk, &pool->chunks);
-	write_unlock(&pool->lock);
+	spin_lock(&pool->lock);
+	list_add_rcu(&chunk->next_chunk, &pool->chunks);
+	spin_unlock(&pool->lock);
 
 	return 0;
 }
@@ -86,7 +205,6 @@ void gen_pool_destroy(struct gen_pool *p
 	int order = pool->min_alloc_order;
 	int bit, end_bit;
 
-
 	list_for_each_safe(_chunk, _next_chunk, &pool->chunks) {
 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
 		list_del(&chunk->next_chunk);
@@ -108,44 +226,50 @@ EXPORT_SYMBOL(gen_pool_destroy);
  * @size: number of bytes to allocate from the pool
  *
  * Allocate the requested number of bytes from the specified pool.
- * Uses a first-fit algorithm.
+ * Uses a first-fit algorithm. Can not be used in NMI handler on
+ * architectures without NMI-safe cmpxchg implementation.
  */
 unsigned long gen_pool_alloc(struct gen_pool *pool, size_t size)
 {
-	struct list_head *_chunk;
 	struct gen_pool_chunk *chunk;
-	unsigned long addr, flags;
+	unsigned long addr = 0;
 	int order = pool->min_alloc_order;
-	int nbits, start_bit, end_bit;
+	int nbits, start_bit = 0, end_bit, remain;
+
+#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+	BUG_ON(in_nmi());
+#endif
 
 	if (size == 0)
 		return 0;
 
 	nbits = (size + (1UL << order) - 1) >> order;
-
-	read_lock(&pool->lock);
-	list_for_each(_chunk, &pool->chunks) {
-		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
+	rcu_read_lock();
+	list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk) {
+		if (size > atomic_read(&chunk->avail))
+			continue;
 
 		end_bit = (chunk->end_addr - chunk->start_addr) >> order;
-
-		spin_lock_irqsave(&chunk->lock, flags);
-		start_bit = bitmap_find_next_zero_area(chunk->bits, end_bit, 0,
-						nbits, 0);
-		if (start_bit >= end_bit) {
-			spin_unlock_irqrestore(&chunk->lock, flags);
+retry:
+		start_bit = bitmap_find_next_zero_area(chunk->bits, end_bit,
+						       start_bit, nbits, 0);
+		if (start_bit >= end_bit)
 			continue;
+		remain = bitmap_set_ll(chunk->bits, start_bit, nbits);
+		if (remain) {
+			remain = bitmap_clear_ll(chunk->bits, start_bit,
+						 nbits - remain);
+			BUG_ON(remain);
+			goto retry;
 		}
 
 		addr = chunk->start_addr + ((unsigned long)start_bit << order);
-
-		bitmap_set(chunk->bits, start_bit, nbits);
-		spin_unlock_irqrestore(&chunk->lock, flags);
-		read_unlock(&pool->lock);
-		return addr;
+		size = nbits << order;
+		atomic_sub(size, &chunk->avail);
+		break;
 	}
-	read_unlock(&pool->lock);
-	return 0;
+	rcu_read_unlock();
+	return addr;
 }
 EXPORT_SYMBOL(gen_pool_alloc);
 
@@ -155,33 +279,95 @@ EXPORT_SYMBOL(gen_pool_alloc);
  * @addr: starting address of memory to free back to pool
  * @size: size in bytes of memory to free
  *
- * Free previously allocated special memory back to the specified pool.
+ * Free previously allocated special memory back to the specified
+ * pool.  Can not be used in NMI handler on architectures without
+ * NMI-safe cmpxchg implementation.
  */
 void gen_pool_free(struct gen_pool *pool, unsigned long addr, size_t size)
 {
-	struct list_head *_chunk;
 	struct gen_pool_chunk *chunk;
-	unsigned long flags;
 	int order = pool->min_alloc_order;
-	int bit, nbits;
-
-	nbits = (size + (1UL << order) - 1) >> order;
+	int start_bit, nbits, remain;
 
-	read_lock(&pool->lock);
-	list_for_each(_chunk, &pool->chunks) {
-		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
+#ifndef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
+	BUG_ON(in_nmi());
+#endif
 
+	nbits = (size + (1UL << order) - 1) >> order;
+	rcu_read_lock();
+	list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk) {
 		if (addr >= chunk->start_addr && addr < chunk->end_addr) {
 			BUG_ON(addr + size > chunk->end_addr);
-			spin_lock_irqsave(&chunk->lock, flags);
-			bit = (addr - chunk->start_addr) >> order;
-			while (nbits--)
-				__clear_bit(bit++, chunk->bits);
-			spin_unlock_irqrestore(&chunk->lock, flags);
-			break;
+			start_bit = (addr - chunk->start_addr) >> order;
+			remain = bitmap_clear_ll(chunk->bits, start_bit, nbits);
+			BUG_ON(remain);
+			size = nbits << order;
+			atomic_add(size, &chunk->avail);
+			rcu_read_unlock();
+			return;
 		}
 	}
-	BUG_ON(nbits > 0);
-	read_unlock(&pool->lock);
+	rcu_read_unlock();
+	BUG();
 }
 EXPORT_SYMBOL(gen_pool_free);
+
+/**
+ * gen_pool_for_each_chunk - call func for every chunk of generic memory pool
+ * @pool:	the generic memory pool
+ * @func:	func to call
+ * @data:	additional data used by @func
+ *
+ * Call @func for every chunk of generic memory pool.  The @func is
+ * called with rcu_read_lock held.
+ */
+void gen_pool_for_each_chunk(struct gen_pool *pool,
+	void (*func)(struct gen_pool *pool, struct gen_pool_chunk *chunk, void *data),
+	void *data)
+{
+	struct gen_pool_chunk *chunk;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(chunk, &(pool)->chunks, next_chunk)
+		func(pool, chunk, data);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(gen_pool_for_each_chunk);
+
+/**
+ * gen_pool_avail - get available free space of the pool
+ * @pool: pool to get available free space
+ *
+ * Return available free space of the specified pool.
+ */
+size_t gen_pool_avail(struct gen_pool *pool)
+{
+	struct gen_pool_chunk *chunk;
+	size_t avail = 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk)
+		avail += atomic_read(&chunk->avail);
+	rcu_read_unlock();
+	return avail;
+}
+EXPORT_SYMBOL_GPL(gen_pool_avail);
+
+/**
+ * gen_pool_size - get size in bytes of memory managed by the pool
+ * @pool: pool to get size
+ *
+ * Return size in bytes of memory managed by the pool.
+ */
+size_t gen_pool_size(struct gen_pool *pool)
+{
+	struct gen_pool_chunk *chunk;
+	size_t size = 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(chunk, &pool->chunks, next_chunk)
+		size += chunk->end_addr - chunk->start_addr;
+	rcu_read_unlock();
+	return size;
+}
+EXPORT_SYMBOL_GPL(gen_pool_size);
