Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab0HJPtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 11:49:39 -0400
Received: from smtp.nokia.com ([192.100.122.230]:51702 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab0HJPtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 11:49:33 -0400
Date: Tue, 10 Aug 2010 18:49:03 +0300 (EEST)
Message-Id: <20100810.184903.214240645.Hiroshi.DOYU@nokia.com>
To: catalin.marinas@arm.com
Cc: linux-kernel@vger.kernel.org, ext-phil.2.carmody@nokia.com,
        linux-omap@vger.kernel.org
Subject: Re: [RFC][PATCH 0/1] kmemleak: Fix false positive with alias
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <20100629.074423.71111160.Hiroshi.DOYU@nokia.com>
References: <1276841055-13843-1-git-send-email-Hiroshi.DOYU@nokia.com>
	<1277736372.25271.102.camel@e102109-lin.cambridge.arm.com>
	<20100629.074423.71111160.Hiroshi.DOYU@nokia.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2010 15:49:10.0210 (UTC) FILETIME=[92B12A20:01CB38A3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: Re: [RFC][PATCH 0/1] kmemleak: Fix false positive with alias
Date: Tue, 29 Jun 2010 07:44:23 +0300 (EEST)

> From: ext Catalin Marinas <catalin.marinas@arm.com>
> Subject: Re: [RFC][PATCH 0/1] kmemleak: Fix false positive with alias
> Date: Mon, 28 Jun 2010 16:46:12 +0200
> 
>> Hi,
>> 
>> (and sorry for the delay)
>> 
>> On Fri, 2010-06-18 at 07:04 +0100, Hiroshi DOYU wrote:
>>> This is another version of "kmemleak: Fix false positive", which
>>> introduces another alias tree to keep track of all alias address of
>>> each objects, based on the discussion(*1)
>>> 
>>> You can also find the previous one(*2), which uses special scan area
>>> for alias addresses with a conversion function.
>>> 
>>> Compared with both methods, it seems that the current one takes a bit
>>> longer to scan as below, tested with 512 elementes of (*3).
>>> 
>>> "kmemleak: Fix false positive with alias":
>>> # time echo scan > /mnt/kmemleak
>>> real    0m 8.40s
>>> user    0m 0.00s
>>> sys     0m 8.40s
>>> 
>>> "kmemleak: Fix false positive with special scan":
>>> # time echo scan > /mnt/kmemleak
>>> real    0m 3.96s
>>> user    0m 0.00s
>>> sys     0m 3.96s
>> 
>> Have you tried without your patches (just the test module but without
>> aliasing the pointers)? I'm curious what's the impact of your first set
>> of patches.
> 
> IIRC, not much difference against the one with the first patches. I'll
> measure it again later.
> 
>>> For our case(*4) to reduce false positives for the 2nd level IOMMU
>>> pagetable allocation, the previous special scan  seems to be enough
>>> lightweight, although there might be possiblity to improve alias
>>> one and also I might misunderstand the original proposal of aliasing.
>> 
>> The performance impact is indeed pretty high, though some parts of the
>> code look over-engineered to me (the __scan_block function with a loop
>> going through an array of two function pointers - I think the compiler
>> cannot figure out what to inline). You could just extend the
>> find_and_get_object() to search both trees under a single spinlock
>> region (as locking also takes time).
> 
> Ok, a good point.

Now there's not much difference with the attached patch, a new version
of alias.

/ # modprobe kmemleak-special-test use_alias=0
/ # time echo scan > /sys/kernel/debug/kmemleak
real    0m 2.30s
user    0m 0.00s
sys     0m 2.30s

/ # modprobe kmemleak-special-test use_alias=1
/ # time echo scan > /sys/kernel/debug/kmemleak
real    0m 3.91s
user    0m 0.00s
sys     0m 3.91s

>From a5670d69b2cafe85f6f26f6951097210d3b9917f Mon Sep 17 00:00:00 2001
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Date: Thu, 17 Jun 2010 13:36:45 +0300
Subject: [PATCH 1/1] kmemleak: Fix false positive with address alias

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
 include/linux/kmemleak.h |    8 ++
 mm/kmemleak.c            |  208 +++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 204 insertions(+), 12 deletions(-)

diff --git a/include/linux/kmemleak.h b/include/linux/kmemleak.h
index 99d9a67..9e2af3a 100644
--- a/include/linux/kmemleak.h
+++ b/include/linux/kmemleak.h
@@ -34,6 +34,8 @@ extern void kmemleak_not_leak(const void *ptr) __ref;
 extern void kmemleak_ignore(const void *ptr) __ref;
 extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
 extern void kmemleak_no_scan(const void *ptr) __ref;
+extern void kmemleak_add_alias(const void *ptr, const void *new) __ref;
+extern void kmemleak_unalias(const void *alias) __ref;
 
 static inline void kmemleak_alloc_recursive(const void *ptr, size_t size,
 					    int min_count, unsigned long flags,
@@ -92,6 +94,12 @@ static inline void kmemleak_erase(void **ptr)
 static inline void kmemleak_no_scan(const void *ptr)
 {
 }
+static inline void kmemleak_add_alias(const void *ptr, const void *new)
+{
+}
+static inline void kmemleak_unalias(const void *alias)
+{
+}
 
 #endif	/* CONFIG_DEBUG_KMEMLEAK */
 
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 2c0d032..3875cb7 100644
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
 
@@ -460,12 +476,11 @@ static void put_object(struct kmemleak_object *object)
 /*
  * Look up an object in the prio search tree and increase its use_count.
  */
-static struct kmemleak_object *find_and_get_object(unsigned long ptr, int alias)
+static struct kmemleak_object *__find_and_get_object(unsigned long ptr, int alias)
 {
 	unsigned long flags;
 	struct kmemleak_object *object = NULL;
 
-	rcu_read_lock();
 	read_lock_irqsave(&kmemleak_lock, flags);
 	if (ptr >= min_addr && ptr < max_addr)
 		object = lookup_object(ptr, alias);
@@ -474,6 +489,75 @@ static struct kmemleak_object *find_and_get_object(unsigned long ptr, int alias)
 	/* check whether the object is still available */
 	if (object && !get_object(object))
 		object = NULL;
+
+	return object;
+}
+
+static struct kmemleak_object *find_and_get_object(unsigned long ptr, int alias)
+{
+	struct kmemleak_object *object;
+
+	rcu_read_lock();
+	object = __find_and_get_object(ptr, alias);
+	rcu_read_unlock();
+
+	return object;
+}
+
+static struct kmemleak_object *__find_and_get_alias(unsigned long ptr, int alias)
+{
+	struct kmemleak_object *object = NULL;
+	struct kmemleak_alias *ao = NULL;
+	struct prio_tree_node *node;
+	struct prio_tree_iter iter;
+	unsigned long flags;
+
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
+	return object;
+}
+
+static struct kmemleak_object *find_and_get_alias(unsigned long ptr, int alias)
+{
+	struct kmemleak_object *object = NULL;
+
+	rcu_read_lock();
+	object = __find_and_get_alias(ptr, alias);
+	rcu_read_unlock();
+
+	return object;
+}
+
+/*
+ * Try to find object first, and then with alias address if not found.
+ */
+static struct kmemleak_object *find_and_get_object_with_alias(unsigned long ptr,
+							      int alias)
+{
+	struct kmemleak_object *object = NULL;
+
+	rcu_read_lock();
+
+	object = __find_and_get_object(ptr, alias);
+	if (!object &&
+	    !prio_tree_empty(&alias_tree_root))
+		object = __find_and_get_alias(ptr, alias);
+
 	rcu_read_unlock();
 
 	return object;
@@ -524,6 +608,7 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 	object->count = 0;			/* white color initially */
 	object->jiffies = jiffies;
 	object->checksum = 0;
+	object->alias = NULL;
 
 	/* task information */
 	if (in_irq()) {
@@ -547,7 +632,7 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
 	object->trace_len = __save_stack_trace(object->trace);
 
 	INIT_PRIO_TREE_NODE(&object->tree_node);
-	object->tree_node.start = ptr;
+	to_address(object) = ptr;
 	object->tree_node.last = ptr + size - 1;
 
 	write_lock_irqsave(&kmemleak_lock, flags);
@@ -577,6 +662,57 @@ out:
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
+static void __delete_alias_object(struct kmemleak_object *object)
+{
+	prio_tree_remove(&alias_tree_root, &object->alias->tree_node);
+	list_del_rcu(&object->alias->alias_list);
+	kmem_cache_free(alias_cache, object->alias);
+	object->alias = NULL;
+}
+
+static void delete_alias_object(struct kmemleak_object *object)
+{
+	unsigned long flags;
+
+	write_lock_irqsave(&kmemleak_lock, flags);
+	__delete_alias_object(object);
+	write_unlock_irqrestore(&kmemleak_lock, flags);
+}
+
 /*
  * Remove the metadata (struct kmemleak_object) for a memory block from the
  * object_list and object_tree_root and decrement its use_count.
@@ -588,6 +724,8 @@ static void __delete_object(struct kmemleak_object *object)
 	write_lock_irqsave(&kmemleak_lock, flags);
 	prio_tree_remove(&object_tree_root, &object->tree_node);
 	list_del_rcu(&object->object_list);
+	if (object->alias)
+		__delete_alias_object(object);
 	write_unlock_irqrestore(&kmemleak_lock, flags);
 
 	WARN_ON(!(object->flags & OBJECT_ALLOCATED));
@@ -630,7 +768,7 @@ static void delete_object_full(unsigned long ptr)
  */
 static void delete_object_part(unsigned long ptr, size_t size)
 {
-	struct kmemleak_object *object;
+	struct kmemleak_object *object, *new;
 	unsigned long start, end;
 
 	object = find_and_get_object(ptr, 1);
@@ -652,12 +790,24 @@ static void delete_object_part(unsigned long ptr, size_t size)
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
@@ -944,6 +1094,38 @@ void __ref kmemleak_no_scan(const void *ptr)
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
+void kmemleak_unalias(const void *alias)
+{
+	struct kmemleak_object *object;
+
+	pr_debug("%s(0x%p)\n", __func__, alias);
+
+	object = find_and_get_alias((unsigned long)alias, 0);
+	if (!object) {
+		kmemleak_warn("Aliasing unknown object at 0x%p\n", alias);
+		return;
+	}
+	delete_alias_object(object);
+	put_object(object);
+}
+EXPORT_SYMBOL(kmemleak_unalias);
+
 /*
  * Update an object's checksum and return true if it was modified.
  */
@@ -1007,7 +1189,7 @@ static void scan_block(void *_start, void *_end,
 
 		pointer = *ptr;
 
-		object = find_and_get_object(pointer, 1);
+		object = find_and_get_object_with_alias(pointer, 1);
 		if (!object)
 			continue;
 		if (object == scanned) {
@@ -1620,8 +1802,10 @@ void __init kmemleak_init(void)
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

