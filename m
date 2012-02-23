Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab2BWWco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:32:44 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52037 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab2BWWbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:31:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.212.3 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, akpm@linux-foundation.org,
        hughd@google.com
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, dpshah@google.com, ctalbott@google.com,
        rni@google.com, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 3/8] mempool, percpu: implement percpu mempool
Date: Thu, 23 Feb 2012 14:30:41 -0800
Message-Id: <1330036246-21633-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1330036246-21633-1-git-send-email-tj@kernel.org>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements mempool for percpu memory areas.  Percpu mempool
is mostly identical to regular mempool and shares most of code but has
some peculiarities.

Percpu memory allocator requires %GFP_KERNEL during allocation, which
comes from its on-demand nature and vmalloc area usage.  In most
cases, it's not a good idea to allocate percpu memory from more
constricted context and this doesn't cause a problem; however, there
are rare cases where opportunistic allocation from NOIO path makes
sense.

To ease such use cases, percpu mempool comes with refill mechanism
which can behave both synchronously and asynchronously depending on
the specified gfp mask.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/mempool.h |   80 ++++++++++++++++++++++++++++++++++
 mm/mempool.c            |  111 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 191 insertions(+), 0 deletions(-)

diff --git a/include/linux/mempool.h b/include/linux/mempool.h
index 7c08052..129acbe 100644
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -5,6 +5,7 @@
 #define _LINUX_MEMPOOL_H
 
 #include <linux/wait.h>
+#include <linux/workqueue.h>
 
 struct kmem_cache;
 
@@ -70,4 +71,83 @@ static inline mempool_t *mempool_create_page_pool(int min_nr, int order)
 			      (void *)(long)order);
 }
 
+/*
+ * Percpu mempool - mempool backed by percpu memory allocator.
+ *
+ * Along with the usual mempool role, because percpu allocator doesn't
+ * support NOIO allocations, percpu mempool is useful as allocation buffer
+ * which is filled from IO context and consumed from atomic or non-IO one.
+ * To help this usage, percpu_mempool has built-in mechanism to refill the
+ * pool which supports both sync and async operations.  Refer to
+ * percpu_mempool_refill() for details.
+ */
+struct percpu_mempool {
+	mempool_t		pool;
+	size_t			size;		/* size of elements */
+	size_t			align;		/* align of elements */
+	struct work_struct	refill_work;	/* work item for async refill */
+};
+
+struct percpu_mempool *percpu_mempool_create(int min_nr, size_t size,
+					     size_t align);
+int percpu_mempool_refill(struct percpu_mempool *pcpu_pool, gfp_t gfp_mask);
+void percpu_mempool_destroy(struct percpu_mempool *pcpu_pool);
+
+/**
+ * percpu_mempool_resize - resize an existing percpu mempool
+ * @pcpu_pool:	percpu mempool to resize
+ * @new_min_nr:	new minimum number of elements guaranteed to be allocated
+ * @gfp_mask:	allocation mask to use
+ *
+ * Counterpart of mempool_resize().  If @gfp_mask doesn't contain
+ * %__GFP_IO, resizing itself may succeed but the implied filling (if
+ * necessary) will fail.
+ */
+static inline int percpu_mempool_resize(struct percpu_mempool *pcpu_pool,
+					int new_min_nr, gfp_t gfp_mask)
+{
+	return mempool_resize(&pcpu_pool->pool, new_min_nr, gfp_mask);
+}
+
+/**
+ * percpu_mempool_alloc - allocate an element from a percpu mempool
+ * @pcpu_pool:	percpu mempool to allocate from
+ * @gfp_mask:	allocation mask to use
+ *
+ * Counterpart of mempool_alloc().  If @gfp_mask doesn't contain %__GFP_IO,
+ * allocation is always from the reserved pool.
+ */
+static inline void __percpu *
+percpu_mempool_alloc(struct percpu_mempool *pcpu_pool, gfp_t gfp_mask)
+{
+	void *p = mempool_alloc(&pcpu_pool->pool, gfp_mask);
+
+	return (void __percpu __force *)p;
+}
+
+/**
+ * percpu_mempool_free - free an element to a percpu mempool
+ * @elem:	element being freed
+ * @pcpu_pool:	percpu mempool to free to
+ */
+static inline void percpu_mempool_free(void __percpu *elem,
+				       struct percpu_mempool *pcpu_pool)
+{
+	void *p = (void __kernel __force *)elem;
+
+	mempool_free(p, &pcpu_pool->pool);
+}
+
+/**
+ * percpu_mempool_nr_elems - return nr of reserved elems in a percpu mempool
+ * @pcpu_pool:	percpu mempool of interest
+ *
+ * Returns the number of reserved elements in @pcpu_pool.  Mostly useful
+ * for deciding when to refill.
+ */
+static inline int percpu_mempool_nr_elems(struct percpu_mempool *pcpu_pool)
+{
+	return pcpu_pool->pool.curr_nr;
+}
+
 #endif /* _LINUX_MEMPOOL_H */
diff --git a/mm/mempool.c b/mm/mempool.c
index 1ed8d5e..75e01c4 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -14,6 +14,7 @@
 #include <linux/mempool.h>
 #include <linux/blkdev.h>
 #include <linux/writeback.h>
+#include <linux/percpu.h>
 
 static void add_element(mempool_t *pool, void *element)
 {
@@ -398,3 +399,113 @@ void mempool_free_pages(void *element, void *pool_data)
 	__free_pages(element, order);
 }
 EXPORT_SYMBOL(mempool_free_pages);
+
+/*
+ * Mempool for percpu memory.
+ */
+static void *percpu_mempool_alloc_fn(gfp_t gfp_mask, void *data)
+{
+	struct percpu_mempool *pcpu_pool = data;
+	void __percpu *p;
+
+	/*
+	 * Percpu allocator doesn't do NOIO.  This makes percpu mempool
+	 * always try reserved elements first, which isn't such a bad idea
+	 * given that percpu allocator is pretty heavy and percpu areas are
+	 * expensive.
+	 */
+	if ((gfp_mask & GFP_KERNEL) != GFP_KERNEL)
+		return NULL;
+
+	p = __alloc_percpu(pcpu_pool->size, pcpu_pool->align);
+	return (void __kernel __force *)p;
+}
+
+static void percpu_mempool_free_fn(void *elem, void *data)
+{
+	void __percpu *p = (void __percpu __force *)elem;
+
+	free_percpu(p);
+}
+
+static void percpu_mempool_refill_workfn(struct work_struct *work)
+{
+	struct percpu_mempool *pcpu_pool =
+		container_of(work, struct percpu_mempool, refill_work);
+
+	percpu_mempool_refill(pcpu_pool, GFP_KERNEL);
+}
+
+/**
+ * percpu_mempool_create - create mempool for percpu memory
+ * @min_nr:	the minimum number of elements guaranteed to be
+ *		allocated for this pool.
+ * @size:	size of percpu memory areas in this pool
+ * @align:	alignment of percpu memory areas in this pool
+ *
+ * This is counterpart of mempool_create() for percpu memory areas.
+ * Allocations from the pool will return @size bytes percpu memory areas
+ * aligned at @align bytes.
+ */
+struct percpu_mempool *percpu_mempool_create(int min_nr, size_t size,
+					     size_t align)
+{
+	struct percpu_mempool *pcpu_pool;
+	mempool_t *pool;
+
+	BUILD_BUG_ON(offsetof(struct percpu_mempool, pool));
+
+	pool = __mempool_create(min_nr, percpu_mempool_alloc_fn,
+				percpu_mempool_free_fn, NULL, NUMA_NO_NODE,
+				sizeof(*pcpu_pool));
+	if (!pool)
+		return NULL;
+
+	/* fill in pcpu_pool part and set pool_data to self */
+	pcpu_pool = container_of(pool, struct percpu_mempool, pool);
+	pcpu_pool->size = size;
+	pcpu_pool->align = align;
+	INIT_WORK(&pcpu_pool->refill_work, percpu_mempool_refill_workfn);
+	pcpu_pool->pool.pool_data = pcpu_pool;
+
+	/* Pre-allocate the guaranteed number of buffers */
+	if (mempool_fill(&pcpu_pool->pool, GFP_KERNEL)) {
+		mempool_destroy(&pcpu_pool->pool);
+		return NULL;
+	}
+
+	return pcpu_pool;
+}
+EXPORT_SYMBOL_GPL(percpu_mempool_create);
+
+/**
+ * percpu_mempool_refill - refill a percpu mempool
+ * @pcpu_pool:	percpu mempool to refill
+ * @gfp_mask:	allocation mask to use
+ *
+ * Refill @pcpu_pool upto the configured min_nr using @gfp_mask.
+ *
+ * Percpu memory allocation depends on %GFP_KERNEL.  If @gfp_mask doesn't
+ * contain it, this function will schedule a work item to refill the pool
+ * and return -%EAGAIN indicating refilling is in progress.
+ */
+int percpu_mempool_refill(struct percpu_mempool *pcpu_pool, gfp_t gfp_mask)
+{
+	if ((gfp_mask & GFP_KERNEL) == GFP_KERNEL)
+		return mempool_fill(&pcpu_pool->pool, gfp_mask);
+
+	schedule_work(&pcpu_pool->refill_work);
+	return -EAGAIN;
+}
+EXPORT_SYMBOL_GPL(percpu_mempool_refill);
+
+/**
+ * percpu_mempool_destroy - destroy a percpu mempool
+ * @pcpu_pool:	percpu mempool to destroy
+ */
+void percpu_mempool_destroy(struct percpu_mempool *pcpu_pool)
+{
+	cancel_work_sync(&pcpu_pool->refill_work);
+	mempool_destroy(&pcpu_pool->pool);
+}
+EXPORT_SYMBOL_GPL(percpu_mempool_destroy);
-- 
1.7.7.3

