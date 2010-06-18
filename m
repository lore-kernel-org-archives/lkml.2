Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab0FRGFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 02:05:22 -0400
Received: from smtp.nokia.com ([192.100.122.230]:50972 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab0FRGFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 02:05:20 -0400
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, ext-phil.2.carmody@nokia.com,
       linux-omap@vger.kernel.org, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH 1/1] kmemleak: Fix false positive with alias
Date: Fri, 18 Jun 2010 09:04:15 +0300
Message-Id: <1276841055-13843-2-git-send-email-Hiroshi.DOYU@nokia.com>
X-Mailer: git-send-email 1.7.1.rc2
In-Reply-To: <20100602.143458.232754971.Hiroshi.DOYU@nokia.com>
References: <20100602.143458.232754971.Hiroshi.DOYU@nokia.com>
X-OriginalArrivalTime: 18 Jun 2010 06:04:26.0728 (UTC) FILETIME=[1B69E680:01CB0EAC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a false positive case that a pointer is calculated by other
methods than the usual container_of macro. "kmemleak_ignore" can cover
such a false positive, but it would loose the advantage of memory leak
detection. This patch allows kmemleak to work with such false
positives by aliasing of address. A client module can register an
alias address to an original pointer.

A typical use case could be the IOMMU pagetable allocation which
stores pointers to the second level of page tables with some
conversion, for example, a physical address with attribute bits. Right
now I don't have other use cases but I hope that there could be some
that this special scan works with.

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 include/linux/kmemleak.h |    4 +
 mm/kmemleak.c            |  198 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 168 insertions(+), 34 deletions(-)

diff --git a/include/linux/kmemleak.h b/include/linux/kmemleak.h
index 99d9a67..0a4ccee 100644
--- a/include/linux/kmemleak.h
+++ b/include/linux/kmemleak.h
@@ -34,6 +34,7 @@ extern void kmemleak_not_leak(const void *ptr) __ref;
 extern void kmemleak_ignore(const void *ptr) __ref;
 extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
 extern void kmemleak_no_scan(const void *ptr) __ref;
+extern void kmemleak_add_alias(const void *ptr, const void *new)  __ref;
 
 static inline void kmemleak_alloc_recursive(const void *ptr, size_t size,
 					    int min_count, unsigned long flags,
@@ -92,6 +93,9 @@ static inline void kmemleak_erase(void **ptr)
 static inline void kmemleak_no_scan(const void *ptr)
 {
 }
+static inline void kmemleak_add_alias(const void *ptr, const void *new)
+{
+}
 
 #endif	/* CONFIG_DEBUG_KMEMLEAK */
 
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 2c0d032..fa20304 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -157,6 +157,13 @@ struct kmemleak_object {
 	unsigned long jiffies;		/* creation timestamp */
 	pid_t pid;			/* pid of the current task */
 	char comm[TASK_COMM_LEN];	/* executable name */
+	struct kmemleak_alias *alias;	/* if a pointer is modified */
+};
+
+struct kmemleak_alias {
+	struct list_head alias_list;
+	struct prio_tree_node tree_node;
+	struct kmemleak_object *object;
 };
 
 /* flag representing the memory block allocation status */
@@ -179,13 +186,18 @@ struct kmemleak_object {
 static LIST_HEAD(object_list);
 /* the list of gray-colored objects (see color_gray comment below) */
 static LIST_HEAD(gray_list);
+/* the list of objects with alias (see alias comment below) */
+static LIST_HEAD(alias_list);
 /* prio search tree for object boundaries */
 static struct prio_tree_root object_tree_root;
+/* prio search tree for alias object boundaries */
+static struct prio_tree_root alias_tree_root;
 /* rw_lock protecting the access to object_list and prio_tree_root */
 static DEFINE_RWLOCK(kmemleak_lock);
 
 /* allocation caches for kmemleak internal data */
 static struct kmem_cache *object_cache;
+static struct kmem_cache *alias_cache;
 static struct kmem_cache *scan_area_cache;
 
 /* set if tracing memory operations is enabled */
@@ -269,6 +281,8 @@ static void kmemleak_disable(void);
 	kmemleak_disable();		\
 } while (0)
 
+#define to_address(obj) ((obj)->tree_node.start)
+
 /*
  * Printing of the objects hex dump to the seq file. The number of lines to be
  * printed is limited to HEX_MAX_LINES to prevent seq file spamming. The
@@ -369,7 +383,7 @@ static void dump_object_info(struct kmemleak_object *object)
 	trace.entries = object->trace;
 
 	pr_notice("Object 0x%08lx (size %zu):\n",
-		  object->tree_node.start, object->size);
+		  to_address(object), object->size);
 	pr_notice("  comm \"%s\", pid %d, jiffies %lu\n",
 		  object->comm, object->pid, object->jiffies);
 	pr_notice("  min_count = %d\n", object->min_count);
@@ -436,6 +450,8 @@ static void free_object_rcu(struct rcu_head *rcu)
 		hlist_del(elem);
 		kmem_cache_free(scan_area_cache, area);
 	}
+	if (object->alias)
+		kmem_cache_free(alias_cache, object->alias);
 	kmem_cache_free(object_cache, object);
 }
 
@@ -479,6 +495,41 @@ static struct kmemleak_object *find_and_get_object(unsigned long ptr, int alias)
 	return object;
 }
 
+static struct kmemleak_object *find_and_get_object_by_alias(unsigned long ptr,
+							    int alias)
+{
+	struct kmemleak_object *object = NULL;
+	struct kmemleak_alias *ao = NULL;
+	struct prio_tree_node *node;
+	struct prio_tree_iter iter;
+	unsigned long flags;
+
+	if (likely(prio_tree_empty(&alias_tree_root)))
+		return NULL;
+
+	rcu_read_lock();
+	read_lock_irqsave(&kmemleak_lock, flags);
+
+	prio_tree_iter_init(&iter, &alias_tree_root, ptr, ptr);
+	node = prio_tree_next(&iter);
+	if (node) {
+		ao = prio_tree_entry(node, struct kmemleak_alias, tree_node);
+		if (!alias && to_address(ao) != ptr) {
+			kmemleak_warn("Found object by alias");
+			ao = NULL;
+		}
+	}
+
+	read_unlock_irqrestore(&kmemleak_lock, flags);
+
+	if (ao && get_object(ao->object))
+		object = ao->object;
+
+	rcu_read_unlock();
+
+	return object;
+}
+
 /*
  * Save stack trace to the given array of MAX_TRACE size.
  */
@@ -524,6 +575,7 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 	object->count = 0;			/* white color initially */
 	object->jiffies = jiffies;
 	object->checksum = 0;
+	object->alias = NULL;
 
 	/* task information */
 	if (in_irq()) {
@@ -547,7 +599,7 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 	object->trace_len = __save_stack_trace(object->trace);
 
 	INIT_PRIO_TREE_NODE(&object->tree_node);
-	object->tree_node.start = ptr;
+	to_address(object) = ptr;
 	object->tree_node.last = ptr + size - 1;
 
 	write_lock_irqsave(&kmemleak_lock, flags);
@@ -577,6 +629,40 @@ out:
 	return object;
 }
 
+static void create_alias_object(struct kmemleak_object *object,
+				unsigned long ptr)
+{
+	struct kmemleak_alias *alias;
+	struct prio_tree_node *node;
+	unsigned long flags;
+
+	alias = kmem_cache_alloc(alias_cache, GFP_KERNEL);
+	if (!alias) {
+		kmemleak_stop("Cannot allocate a kmemleak_alias structure\n");
+		return;
+	}
+	INIT_LIST_HEAD(&alias->alias_list);
+	INIT_PRIO_TREE_NODE(&alias->tree_node);
+	to_address(alias) = ptr;
+
+	spin_lock_irqsave(&object->lock, flags);
+	alias->tree_node.last = ptr + object->size - 1;
+	alias->object = object;
+	object->alias = alias;
+	spin_unlock_irqrestore(&object->lock, flags);
+
+	write_lock_irqsave(&kmemleak_lock, flags);
+
+	node = prio_tree_insert(&alias_tree_root, &alias->tree_node);
+	if (!node) {
+		kmemleak_warn("Cannot allocate a kmemleak_alias structure\n");
+		kmem_cache_free(alias_cache, alias);
+	}
+	list_add_tail_rcu(&alias->alias_list, &alias_list);
+
+	write_unlock_irqrestore(&kmemleak_lock, flags);
+}
+
 /*
  * Remove the metadata (struct kmemleak_object) for a memory block from the
  * object_list and object_tree_root and decrement its use_count.
@@ -588,6 +674,10 @@ static void __delete_object(struct kmemleak_object *object)
 	write_lock_irqsave(&kmemleak_lock, flags);
 	prio_tree_remove(&object_tree_root, &object->tree_node);
 	list_del_rcu(&object->object_list);
+	if (object->alias) {
+		prio_tree_remove(&alias_tree_root, &object->alias->tree_node);
+		list_del_rcu(&object->alias->alias_list);
+	}
 	write_unlock_irqrestore(&kmemleak_lock, flags);
 
 	WARN_ON(!(object->flags & OBJECT_ALLOCATED));
@@ -630,7 +720,7 @@ static void delete_object_full(unsigned long ptr)
  */
 static void delete_object_part(unsigned long ptr, size_t size)
 {
-	struct kmemleak_object *object;
+	struct kmemleak_object *object, *new;
 	unsigned long start, end;
 
 	object = find_and_get_object(ptr, 1);
@@ -652,12 +742,24 @@ static void delete_object_part(unsigned long ptr, size_t size)
 	 */
 	start = object->pointer;
 	end = object->pointer + object->size;
-	if (ptr > start)
-		create_object(start, ptr - start, object->min_count,
-			      GFP_KERNEL);
-	if (ptr + size < end)
-		create_object(ptr + size, end - ptr - size, object->min_count,
-			      GFP_KERNEL);
+	if (ptr > start) {
+		new = create_object(start, ptr - start, object->min_count,
+				    GFP_KERNEL);
+		if (new && unlikely(object->alias))
+			create_alias_object(new, to_address(object->alias));
+	}
+	if (ptr + size < end) {
+		new = create_object(ptr + size, end - ptr - size,
+				    object->min_count, GFP_KERNEL);
+		if (new && unlikely(object->alias)) {
+			unsigned long alias_ptr;
+
+			alias_ptr = to_address(object->alias);
+			alias_ptr += ptr - start + size;
+
+			create_alias_object(new, alias_ptr);
+		}
+	}
 
 	put_object(object);
 }
@@ -944,6 +1046,22 @@ void __ref kmemleak_no_scan(const void *ptr)
 }
 EXPORT_SYMBOL(kmemleak_no_scan);
 
+void kmemleak_add_alias(const void *ptr, const void *alias)
+{
+	struct kmemleak_object *object;
+
+	pr_debug("%s(0x%p -> 0x%p)\n", __func__, ptr, alias);
+
+	object = find_and_get_object((unsigned long)ptr, 0);
+	if (!object) {
+		kmemleak_warn("Aliasing unknown object at 0x%p\n", ptr);
+		return;
+	}
+	create_alias_object(object, (unsigned long)alias);
+	put_object(object);
+}
+EXPORT_SYMBOL(kmemleak_add_alias);
+
 /*
  * Update an object's checksum and return true if it was modified.
  */
@@ -979,37 +1097,21 @@ static int scan_should_stop(void)
 	return 0;
 }
 
-/*
- * Scan a memory block (exclusive range) for valid pointers and add those
- * found to the gray list.
- */
-static void scan_block(void *_start, void *_end,
-		       struct kmemleak_object *scanned, int allow_resched)
+static void __scan_block(unsigned long *ptr, struct kmemleak_object *scanned)
 {
-	unsigned long *ptr;
-	unsigned long *start = PTR_ALIGN(_start, BYTES_PER_POINTER);
-	unsigned long *end = _end - (BYTES_PER_POINTER - 1);
+	int i;
+	unsigned long pointer = *ptr;
+	typedef struct kmemleak_object *(*fn_t)(unsigned long, int);
+	fn_t fns[] = { find_and_get_object, find_and_get_object_by_alias, };
 
-	for (ptr = start; ptr < end; ptr++) {
-		struct kmemleak_object *object;
+	for (i = 0; i < ARRAY_SIZE(fns); i++) {
 		unsigned long flags;
-		unsigned long pointer;
-
-		if (allow_resched)
-			cond_resched();
-		if (scan_should_stop())
-			break;
-
-		/* don't scan uninitialized memory */
-		if (!kmemcheck_is_obj_initialized((unsigned long)ptr,
-						  BYTES_PER_POINTER))
-			continue;
-
-		pointer = *ptr;
+		struct kmemleak_object *object;
 
-		object = find_and_get_object(pointer, 1);
+		object = fns[i](pointer, 1);
 		if (!object)
 			continue;
+
 		if (object == scanned) {
 			/* self referenced, ignore */
 			put_object(object);
@@ -1049,6 +1151,32 @@ static void scan_block(void *_start, void *_end,
 }
 
 /*
+ * Scan a memory block (exclusive range) for valid pointers and add those
+ * found to the gray list.
+ */
+static void scan_block(void *_start, void *_end,
+		       struct kmemleak_object *scanned, int allow_resched)
+{
+	unsigned long *ptr;
+	unsigned long *start = PTR_ALIGN(_start, BYTES_PER_POINTER);
+	unsigned long *end = _end - (BYTES_PER_POINTER - 1);
+
+	for (ptr = start; ptr < end; ptr++) {
+		if (allow_resched)
+			cond_resched();
+		if (scan_should_stop())
+			break;
+
+		/* don't scan uninitialized memory */
+		if (!kmemcheck_is_obj_initialized((unsigned long)ptr,
+						  BYTES_PER_POINTER))
+			continue;
+
+		__scan_block(ptr, scanned);
+	}
+}
+
+/*
  * Scan a memory block corresponding to a kmemleak_object. A condition is
  * that object->use_count >= 1.
  */
@@ -1620,8 +1748,10 @@ void __init kmemleak_init(void)
 	jiffies_scan_wait = msecs_to_jiffies(SECS_SCAN_WAIT * 1000);
 
 	object_cache = KMEM_CACHE(kmemleak_object, SLAB_NOLEAKTRACE);
+	alias_cache = KMEM_CACHE(kmemleak_alias, SLAB_NOLEAKTRACE);
 	scan_area_cache = KMEM_CACHE(kmemleak_scan_area, SLAB_NOLEAKTRACE);
 	INIT_PRIO_TREE_ROOT(&object_tree_root);
+	INIT_PRIO_TREE_ROOT(&alias_tree_root);
 
 	/* the kernel is still in UP mode, so disabling the IRQs is enough */
 	local_irq_save(flags);
-- 
1.7.1.rc2

