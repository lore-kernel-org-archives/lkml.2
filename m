Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1HIVN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 17:13:58 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:36034 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752894Ab1HIVNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 17:13:05 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: mnny03UVM1lmoEoEHtaxES1PXoZIpqzEShozUaw0hTlWND_
 y7ItIk7kkZiDLia9u1pnnWrSPvtneRYZvuTR85Rasqz3yNbbHEWqR.f5LAxc
 foRB66H1ajoQnMhP0vVNURK6alKb5MJvIa3BsQsBt5siUPTRz4KV8v1vPxIs
 N7cVVmXFfLnjCJr1BRDRq5ZirgGNvi1lrsAbI34DFxshg7ehsiSrvrlR.Emm
 LoPS13VDDkRXrotIOE1FpmBmaT.q7aS5hagc6uOkZURvp91fk5rqZ_4x6TLy
 6zYfpAr4poy2nvXdIcEcDeAkhQ7Mew7Ai8M1fOxxGxpY3S6zFL0PWd1v5.Ej
 x2ZWQsboh4no8p8rdMTDJnsSaspT2ZOU9mNtOOD42YTN4ccQjSF0dI53L4Cm
 37nHNn61Ks39ITHXFJxCCIQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Message-Id: <20110809211302.222722588@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 09 Aug 2011 16:12:27 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: tj@kernel.org
Cc: Metathronius Galabant <m.galabant@googlemail.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Adrian Drzewiecki <z@drze.net>
Cc: linux-kernel@vger.kernel.org
Subject: [slub p4 6/7] slub: per cpu cache for partial pages
References: <20110809211221.831975979@linux.com>
Content-Disposition: inline; filename=per_cpu_partial
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow filling out the rest of the kmem_cache_cpu cacheline with pointers to
partial pages. The partial page list is used in slab_free() to avoid
per node lock taking.

In __slab_alloc() we can then take multiple partial pages off the per
node partial list in one go reducing node lock pressure.

We can also use the per cpu partial list in slab_alloc() to avoid scanning
partial lists for pages with free objects.

The main effect of a per cpu partial list is that the per node list_lock
is taken for batches of partial pages instead of individual ones.

Potential future enhancements:

1. The pickup from the partial list could be perhaps be done without disabling
   interrupts with some work. The free path already puts the page into the
   per cpu partial list without disabling interrupts.

2. __slab_free() may have some code paths that could use optimization.

Performance:

				Before		After
./hackbench 100 process 200000
				Time: 1953.047	1564.614
./hackbench 100 process 20000
				Time: 207.176   156.940
./hackbench 100 process 20000
				Time: 204.468	156.940
./hackbench 100 process 20000
				Time: 204.879	158.772
./hackbench 10 process 20000
				Time: 20.153	15.853
./hackbench 10 process 20000
				Time: 20.153	15.986
./hackbench 10 process 20000
				Time: 19.363	16.111
./hackbench 1 process 20000
				Time: 2.518	2.307
./hackbench 1 process 20000
				Time: 2.258	2.339
./hackbench 1 process 20000
				Time: 2.864	2.163

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 include/linux/mm_types.h |   14 +
 include/linux/slub_def.h |    4 
 mm/slub.c                |  339 ++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 309 insertions(+), 48 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2011-08-05 12:06:57.561873039 -0500
+++ linux-2.6/include/linux/slub_def.h	2011-08-09 13:05:13.181582001 -0500
@@ -36,12 +36,15 @@ enum stat_item {
 	ORDER_FALLBACK,		/* Number of times fallback was necessary */
 	CMPXCHG_DOUBLE_CPU_FAIL,/* Failure of this_cpu_cmpxchg_double */
 	CMPXCHG_DOUBLE_FAIL,	/* Number of times that cmpxchg double did not match */
+	CPU_PARTIAL_ALLOC,	/* Used cpu partial on alloc */
+	CPU_PARTIAL_FREE,	/* USed cpu partial on free */
 	NR_SLUB_STAT_ITEMS };
 
 struct kmem_cache_cpu {
 	void **freelist;	/* Pointer to next available object */
 	unsigned long tid;	/* Globally unique transaction id */
 	struct page *page;	/* The slab from which we are allocating */
+	struct page *partial;	/* Partially allocated frozen slabs */
 	int node;		/* The node of the page (or -1 for debug) */
 #ifdef CONFIG_SLUB_STATS
 	unsigned stat[NR_SLUB_STAT_ITEMS];
@@ -79,6 +82,7 @@ struct kmem_cache {
 	int size;		/* The size of an object including meta data */
 	int objsize;		/* The size of an object without meta data */
 	int offset;		/* Free pointer offset. */
+	int cpu_partial;	/* Number of per cpu partial pages to keep around */
 	struct kmem_cache_order_objects oo;
 
 	/* Allocation and freeing of slabs */
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-08-09 13:05:12.321582002 -0500
+++ linux-2.6/mm/slub.c	2011-08-09 13:05:13.181582001 -0500
@@ -1560,7 +1560,7 @@ static inline void remove_partial(struct
  */
 static inline void *acquire_slab(struct kmem_cache *s,
 		struct kmem_cache_node *n, struct page *page,
-		struct kmem_cache_cpu *c)
+		int mode)
 {
 	void *freelist;
 	unsigned long counters;
@@ -1575,7 +1575,8 @@ static inline void *acquire_slab(struct
 		freelist = page->freelist;
 		counters = page->counters;
 		new.counters = counters;
-		new.inuse = page->objects;
+		if (mode)
+			new.inuse = page->objects;
 
 		VM_BUG_ON(new.frozen);
 		new.frozen = 1;
@@ -1586,34 +1587,20 @@ static inline void *acquire_slab(struct
 			"lock and freeze"));
 
 	remove_partial(n, page);
-
-	if (freelist) {
-		/* Populate the per cpu freelist */
-		c->page = page;
-		c->node = page_to_nid(page);
-		stat(s, ALLOC_FROM_PARTIAL);
-
-		return freelist;
-	} else {
-		/*
-		 * Slab page came from the wrong list. No object to allocate
-		 * from. Put it onto the correct list and continue partial
-		 * scan.
-		 */
-		printk(KERN_ERR "SLUB: %s : Page without available objects on"
-			" partial list\n", s->name);
-		return NULL;
-	}
+	return freelist;
 }
 
+static int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain);
+
 /*
  * Try to allocate a partial slab from a specific node.
  */
 static void *get_partial_node(struct kmem_cache *s,
 		struct kmem_cache_node *n, struct kmem_cache_cpu *c)
 {
-	struct page *page;
-	void *object;
+	struct page *page, *page2;
+	void *object = NULL;
+	int count = 0;
 
 	/*
 	 * Racy check. If we mistakenly see no partial slabs then we
@@ -1625,13 +1612,28 @@ static void *get_partial_node(struct kme
 		return NULL;
 
 	spin_lock(&n->list_lock);
-	list_for_each_entry(page, &n->partial, lru) {
-		object = acquire_slab(s, n, page, c);
-		if (object)
-			goto out;
+	list_for_each_entry_safe(page, page2, &n->partial, lru) {
+		void *t = acquire_slab(s, n, page, count == 0);
+		int available;
+
+		if (!t)
+			break;
+
+		if (!count) {
+			c->page = page;
+			c->node = page_to_nid(page);
+			stat(s, ALLOC_FROM_PARTIAL);
+			count++;
+			object = t;
+			available =  page->objects - page->inuse;
+		} else {
+			page->freelist = t;
+			available = put_cpu_partial(s, page, 0);
+		}
+		if (kmem_cache_debug(s) || available > s->cpu_partial / 2)
+			break;
+
 	}
-	object = NULL;
-out:
 	spin_unlock(&n->list_lock);
 	return object;
 }
@@ -1926,6 +1928,123 @@ redo:
 	}
 }
 
+/* Unfreeze all the cpu partial slabs */
+static void unfreeze_partials(struct kmem_cache *s)
+{
+	struct kmem_cache_node *n = NULL;
+	struct kmem_cache_cpu *c = this_cpu_ptr(s->cpu_slab);
+	struct page *page;
+
+	while ((page = c->partial)) {
+		enum slab_modes { M_PARTIAL, M_FREE };
+		enum slab_modes l, m;
+		struct page new;
+		struct page old;
+
+		c->partial = page->next;
+		l = M_FREE;
+
+		do {
+
+			old.freelist = page->freelist;
+			old.counters = page->counters;
+			VM_BUG_ON(!old.frozen);
+
+			new.counters = old.counters;
+			new.freelist = old.freelist;
+
+			new.frozen = 0;
+
+			if (!new.inuse && (!n || n->nr_partial < s->min_partial))
+				m = M_FREE;
+			else {
+				struct kmem_cache_node *n2 = get_node(s,
+							page_to_nid(page));
+
+				m = M_PARTIAL;
+				if (n != n2) {
+					if (n)
+						spin_unlock(&n->list_lock);
+
+					n = n2;
+					spin_lock(&n->list_lock);
+				}
+			}
+
+			if (l != m) {
+				if (l == M_PARTIAL)
+					remove_partial(n, page);
+				else
+					add_partial(n, page, 1);
+
+				l = m;
+			}
+
+		} while (!cmpxchg_double_slab(s, page,
+				old.freelist, old.counters,
+				new.freelist, new.counters,
+				"unfreezing slab"));
+
+		if (m == M_FREE) {
+			stat(s, DEACTIVATE_EMPTY);
+			discard_slab(s, page);
+			stat(s, FREE_SLAB);
+		}
+	}
+
+	if (n)
+		spin_unlock(&n->list_lock);
+}
+
+/*
+ * Put a page that was just frozen (in __slab_free) into a partial page
+ * slot if available. This is done without interrupts disabled and without
+ * preemption disabled. The cmpxchg is racy and may put the partial page
+ * onto a random cpus partial slot.
+ *
+ * If we did not find a slot then simply move all the partials to the
+ * per node partial list.
+ */
+int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
+{
+	struct page *oldpage;
+	int pages;
+	int pobjects;
+
+	do {
+		pages = 0;
+		pobjects = 0;
+		oldpage = this_cpu_read(s->cpu_slab->partial);
+
+		if (oldpage) {
+			pobjects = oldpage->pobjects;
+			pages = oldpage->pages;
+			if (drain && pobjects > s->cpu_partial) {
+				unsigned long flags;
+				/*
+				 * partial array is full. Move the existing
+				 * set to the per node partial list.
+				 */
+				local_irq_save(flags);
+				unfreeze_partials(s);
+				local_irq_restore(flags);
+				pobjects = 0;
+				pages = 0;
+			}
+		}
+
+		pages++;
+		pobjects += page->objects - page->inuse;
+
+		page->pages = pages;
+		page->pobjects = pobjects;
+		page->next = oldpage;
+
+	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page) != oldpage);
+	stat(s, CPU_PARTIAL_FREE);
+	return pobjects;
+}
+
 static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
 	stat(s, CPUSLAB_FLUSH);
@@ -1941,8 +2060,12 @@ static inline void __flush_cpu_slab(stru
 {
 	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
 
-	if (likely(c && c->page))
-		flush_slab(s, c);
+	if (likely(c)) {
+		if (c->page)
+			flush_slab(s, c);
+
+		unfreeze_partials(s);
+	}
 }
 
 static void flush_cpu_slab(void *d)
@@ -2066,8 +2189,6 @@ static inline void *new_slab_objects(str
  * Slow path. The lockless freelist is empty or we need to perform
  * debugging duties.
  *
- * Interrupts are disabled.
- *
  * Processing is still very fast if new objects have been freed to the
  * regular freelist. In that case we simply take over the regular freelist
  * as the lockless freelist and zap the regular freelist.
@@ -2100,7 +2221,7 @@ static void *__slab_alloc(struct kmem_ca
 
 	if (!c->page)
 		goto new_slab;
-
+redo:
 	if (unlikely(!node_match(c, node))) {
 		stat(s, ALLOC_NODE_MISMATCH);
 		deactivate_slab(s, c);
@@ -2133,7 +2254,7 @@ static void *__slab_alloc(struct kmem_ca
 			NULL, new.counters,
 			"__slab_alloc"));
 
-	if (unlikely(!object)) {
+	if (!object) {
 		c->page = NULL;
 		stat(s, DEACTIVATE_BYPASS);
 		goto new_slab;
@@ -2148,6 +2269,17 @@ load_freelist:
 	return object;
 
 new_slab:
+
+	if (c->partial) {
+		c->page = c->partial;
+		c->partial = c->page->next;
+		c->node = page_to_nid(c->page);
+		stat(s, CPU_PARTIAL_ALLOC);
+		c->freelist = NULL;
+		goto redo;
+	}
+
+	/* Then do expensive stuff like retrieving pages from the partial lists */
 	object = get_partial(s, gfpflags, node, c);
 
 	if (unlikely(!object)) {
@@ -2341,16 +2473,29 @@ static void __slab_free(struct kmem_cach
 		was_frozen = new.frozen;
 		new.inuse--;
 		if ((!new.inuse || !prior) && !was_frozen && !n) {
-                        n = get_node(s, page_to_nid(page));
-			/*
-			 * Speculatively acquire the list_lock.
-			 * If the cmpxchg does not succeed then we may
-			 * drop the list_lock without any processing.
-			 *
-			 * Otherwise the list_lock will synchronize with
-			 * other processors updating the list of slabs.
-			 */
-                        spin_lock_irqsave(&n->list_lock, flags);
+
+			if (!kmem_cache_debug(s) && !prior)
+
+				/*
+				 * Slab was on no list before and will be partially empty
+				 * We can defer the list move and instead freeze it.
+				 */
+				new.frozen = 1;
+
+			else { /* Needs to be taken off a list */
+
+	                        n = get_node(s, page_to_nid(page));
+				/*
+				 * Speculatively acquire the list_lock.
+				 * If the cmpxchg does not succeed then we may
+				 * drop the list_lock without any processing.
+				 *
+				 * Otherwise the list_lock will synchronize with
+				 * other processors updating the list of slabs.
+				 */
+				spin_lock_irqsave(&n->list_lock, flags);
+
+			}
 		}
 		inuse = new.inuse;
 
@@ -2360,7 +2505,15 @@ static void __slab_free(struct kmem_cach
 		"__slab_free"));
 
 	if (likely(!n)) {
-                /*
+
+		/*
+		 * If we just froze the page then put it onto the
+		 * per cpu partial list.
+		 */
+       		if (new.frozen && !was_frozen)
+			put_cpu_partial(s, page, 1);
+
+         	/*
 		 * The list lock was not taken therefore no list
 		 * activity can be necessary.
 		 */
@@ -2429,7 +2582,6 @@ static __always_inline void slab_free(st
 	slab_free_hook(s, x);
 
 redo:
-
 	/*
 	 * Determine the currently cpus per cpu slab.
 	 * The cpu may change afterward. However that does not matter since
@@ -2919,7 +3071,34 @@ static int kmem_cache_open(struct kmem_c
 	 * The larger the object size is, the more pages we want on the partial
 	 * list to avoid pounding the page allocator excessively.
 	 */
-	set_min_partial(s, ilog2(s->size));
+	set_min_partial(s, ilog2(s->size) / 2);
+
+	/*
+	 * cpu_partial determined the maximum number of objects kept in the
+	 * per cpu partial lists of a processor.
+	 *
+	 * Per cpu partial lists mainly contain slabs that just have one
+	 * object freed. If they are used for allocation then they can be
+	 * filled up again with minimal effort. The slab will never hit the
+	 * per node partial lists and therefore no locking will be required.
+	 *
+	 * This setting also determines
+	 *
+	 * A) The number of objects from per cpu partial slabs dumped to the
+	 *    per node list when we reach the limit.
+	 * B) The number of objects in partial partial slabs to extract from the
+	 *    per node list when we run out of per cpu objects. We only fetch 50%
+	 *    to keep some capacity around for frees.
+	 */
+	if (s->size >= PAGE_SIZE)
+		s->cpu_partial = 2;
+	else if (s->size >= 1024)
+		s->cpu_partial = 6;
+	else if (s->size >= 256)
+		s->cpu_partial = 13;
+	else
+		s->cpu_partial = 30;
+
 	s->refcount = 1;
 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 1000;
@@ -4327,6 +4506,7 @@ static ssize_t show_slab_objects(struct
 
 		for_each_possible_cpu(cpu) {
 			struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
+			struct page *page;
 
 			if (!c || c->node < 0)
 				continue;
@@ -4342,6 +4522,13 @@ static ssize_t show_slab_objects(struct
 				total += x;
 				nodes[c->node] += x;
 			}
+			page = c->partial;
+
+			if (page) {
+				x = page->pobjects;
+                                total += x;
+                                nodes[c->node] += x;
+			}
 			per_cpu[c->node]++;
 		}
 	}
@@ -4493,6 +4680,27 @@ static ssize_t min_partial_store(struct
 }
 SLAB_ATTR(min_partial);
 
+static ssize_t cpu_partial_show(struct kmem_cache *s, char *buf)
+{
+	return sprintf(buf, "%u\n", s->cpu_partial);
+}
+
+static ssize_t cpu_partial_store(struct kmem_cache *s, const char *buf,
+				 size_t length)
+{
+	unsigned long objects;
+	int err;
+
+	err = strict_strtoul(buf, 10, &objects);
+	if (err)
+		return err;
+
+	s->cpu_partial = objects;
+	flush_all(s);
+	return length;
+}
+SLAB_ATTR(cpu_partial);
+
 static ssize_t ctor_show(struct kmem_cache *s, char *buf)
 {
 	if (!s->ctor)
@@ -4531,6 +4739,37 @@ static ssize_t objects_partial_show(stru
 }
 SLAB_ATTR_RO(objects_partial);
 
+static ssize_t slabs_cpu_partial_show(struct kmem_cache *s, char *buf)
+{
+	int objects = 0;
+	int pages = 0;
+	int cpu;
+	int len;
+
+	for_each_online_cpu(cpu) {
+		struct page *page = per_cpu_ptr(s->cpu_slab, cpu)->partial;
+
+		if (page) {
+			pages += page->pages;
+			objects += page->pobjects;
+		}
+	}
+
+	len = sprintf(buf, "%d(%d)", objects, pages);
+
+#ifdef CONFIG_SMP
+	for_each_online_cpu(cpu) {
+		struct page *page = per_cpu_ptr(s->cpu_slab, cpu) ->partial;
+
+		if (page && len < PAGE_SIZE - 20)
+			len += sprintf(buf + len, " C%d=%d(%d)", cpu,
+				page->pobjects, page->pages);
+	}
+#endif
+	return len + sprintf(buf + len, "\n");
+}
+SLAB_ATTR_RO(slabs_cpu_partial);
+
 static ssize_t reclaim_account_show(struct kmem_cache *s, char *buf)
 {
 	return sprintf(buf, "%d\n", !!(s->flags & SLAB_RECLAIM_ACCOUNT));
@@ -4853,6 +5092,8 @@ STAT_ATTR(DEACTIVATE_BYPASS, deactivate_
 STAT_ATTR(ORDER_FALLBACK, order_fallback);
 STAT_ATTR(CMPXCHG_DOUBLE_CPU_FAIL, cmpxchg_double_cpu_fail);
 STAT_ATTR(CMPXCHG_DOUBLE_FAIL, cmpxchg_double_fail);
+STAT_ATTR(CPU_PARTIAL_ALLOC, cpu_partial_alloc);
+STAT_ATTR(CPU_PARTIAL_FREE, cpu_partial_free);
 #endif
 
 static struct attribute *slab_attrs[] = {
@@ -4861,6 +5102,7 @@ static struct attribute *slab_attrs[] =
 	&objs_per_slab_attr.attr,
 	&order_attr.attr,
 	&min_partial_attr.attr,
+	&cpu_partial_attr.attr,
 	&objects_attr.attr,
 	&objects_partial_attr.attr,
 	&partial_attr.attr,
@@ -4873,6 +5115,7 @@ static struct attribute *slab_attrs[] =
 	&destroy_by_rcu_attr.attr,
 	&shrink_attr.attr,
 	&reserved_attr.attr,
+	&slabs_cpu_partial_attr.attr,
 #ifdef CONFIG_SLUB_DEBUG
 	&total_objects_attr.attr,
 	&slabs_attr.attr,
@@ -4914,6 +5157,8 @@ static struct attribute *slab_attrs[] =
 	&order_fallback_attr.attr,
 	&cmpxchg_double_fail_attr.attr,
 	&cmpxchg_double_cpu_fail_attr.attr,
+	&cpu_partial_alloc_attr.attr,
+	&cpu_partial_free_attr.attr,
 #endif
 #ifdef CONFIG_FAILSLAB
 	&failslab_attr.attr,
Index: linux-2.6/include/linux/mm_types.h
===================================================================
--- linux-2.6.orig/include/linux/mm_types.h	2011-08-05 12:06:57.571873039 -0500
+++ linux-2.6/include/linux/mm_types.h	2011-08-09 13:05:13.201582001 -0500
@@ -79,9 +79,21 @@ struct page {
 	};
 
 	/* Third double word block */
-	struct list_head lru;		/* Pageout list, eg. active_list
+	union {
+		struct list_head lru;	/* Pageout list, eg. active_list
 					 * protected by zone->lru_lock !
 					 */
+		struct {		/* slub per cpu partial pages */
+			struct page *next;	/* Next partial slab */
+#ifdef CONFIG_64BIT
+			int pages;	/* Nr of partial slabs left */
+			int pobjects;	/* Approximate # of objects */
+#else
+			short int pages;
+			short int pobjects;
+#endif
+		};
+	};
 
 	/* Remainder is not double word aligned */
 	union {

