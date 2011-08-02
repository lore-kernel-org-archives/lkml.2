Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab1HBRZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 13:25:06 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:20368 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754411Ab1HBRZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 13:25:02 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: pw8h_B4VM1n6UR_NKIYNGTEdPjRfAnR5337HwYYF8fmwIaG
 Xe6vJPD.h1h14lKaCFZhyKMiBn9pqHCrlsXIPhWfGxRXHCUTRG2aFQOKHjZQ
 9Lh_7w0HNu12agA_mtwWu6iqRrHiQqt.eXUgNqFMn8VYmf409ImLVSW4Yypq
 nxOGrqU8.CHDqnmcfDQ.wTUK4U1lrWnuna3wKxKEfcUqjf3gvWFvZc8rt6I7
 .QI_wqdYGj74QeRGGUfzk7I6_H2Pmye_cCFwqknyRFy_x0c3bC1hxyBEALaV
 l14vEdE8EOLA_RMs4hMw8NcoEe2ypNkv__Z0RQF._G8JWqIXQdU0BpRvuorp
 1MkZnWwO7eJCXq__q3Ig4f8JF
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 2 Aug 2011 12:24:57 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Tejun Heo <tj@kernel.org>,
        Metathronius Galabant <m.galabant@googlemail.com>,
        Matt Mackall <mpm@selenic.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Adrian Drzewiecki <z@drze.net>, linux-kernel@vger.kernel.org
Subject: Re: [slub p3 6/7] slub: per cpu cache for partial pages
In-Reply-To: <20110801162852.402457122@linux.com>
Message-ID: <alpine.DEB.2.00.1108021220490.21126@router.home>
References: <20110801162823.755182213@linux.com> <20110801162852.402457122@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New revision of the patch. Allows dynamic configuration of the number of
objects to be kept on the per cpu partial lists (this means that the
number of partial slabs may vary based on the ratio of object availability
in those partial slabs).

This also allows us to avoid a loop over an array of page pointers in the
hotpaths. Which should improve performance.



Subject: slub: per cpu cache for partial pages

Allow filling out the rest of the kmem_cache_cpu cacheline with pointers to
partial pages. The partial page list is used in slab_free() to avoid
per node lock taking.

In __slab_alloc() we can then take multiple partial pages off the per
node partial list in one go reducing node lock pressure.

We can also use the per cpu partial list in slab_alloc() to avoid scanning
partial lists for pages with free objects.


The main effect of a per cpu partial list is that the per node list_lock
is taken for batches of partial pages instead of individual ones.

1. The "unfreeze()" function should have common code with
   deactivate_slab(). Maybe those can be unified.

Future enhancements:

1. The pickup from the partial list could be perhaps be done without disabling
   interrupts with some work. The free path already puts the page into the
   per cpu partial list without disabling interrupts.

2. The __slab_free() likely has some code path that are unnecessary now or
   where code is duplicated.

3. We dump all partials if the per cpu array overflows. There must be some other
   better algorithm.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 include/linux/mm_types.h |    9 +
 include/linux/slub_def.h |    4
 mm/slub.c                |  333 ++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 298 insertions(+), 48 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2011-08-02 12:07:33.565281487 -0500
+++ linux-2.6/include/linux/slub_def.h	2011-08-02 12:07:35.225281476 -0500
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
--- linux-2.6.orig/mm/slub.c	2011-08-02 12:07:33.585281487 -0500
+++ linux-2.6/mm/slub.c	2011-08-02 12:13:11.345279324 -0500
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
@@ -1926,6 +1928,135 @@ redo:
 	}
 }

+/*
+ * Unfreeze a page. Page cannot be full. May be empty. If n is passed then the list lock on that
+ * node was taken. The functions return the pointer to the list_lock that was eventually taken in
+ * this function.
+ *
+ * Races are limited to concurrency with __slab_free since the page is frozen and it is not the
+ * current slab used for allocation. Meaning that the number of free objects in a slab may increase
+ * but not decrease.
+ */
+struct kmem_cache_node *unfreeze(struct kmem_cache *s, struct page *page, struct kmem_cache_node *n)
+{
+	enum slab_modes { M_PARTIAL, M_FREE };
+	enum slab_modes l = M_FREE, m = M_FREE;
+	struct page new;
+	struct page old;
+
+	do {
+
+		old.freelist = page->freelist;
+		old.counters = page->counters;
+		VM_BUG_ON(!old.frozen);
+
+		new.counters = old.counters;
+		new.freelist = old.freelist;
+
+		new.frozen = 0;
+
+		if (!new.inuse && (!n || n->nr_partial < s->min_partial))
+			m = M_FREE;
+		else {
+			struct kmem_cache_node *n2 = get_node(s, page_to_nid(page));
+
+			m = M_PARTIAL;
+			if (n != n2) {
+				if (n)
+					spin_unlock(&n->list_lock);
+
+				n = n2;
+				spin_lock(&n->list_lock);
+			}
+		}
+
+		if (l != m) {
+			if (l == M_PARTIAL)
+				remove_partial(n, page);
+			else
+				add_partial(n, page, 1);
+
+			l = m;
+		}
+
+	} while (!cmpxchg_double_slab(s, page,
+				old.freelist, old.counters,
+				new.freelist, new.counters,
+				"unfreezing slab"));
+
+	if (m == M_FREE) {
+		stat(s, DEACTIVATE_EMPTY);
+		discard_slab(s, page);
+		stat(s, FREE_SLAB);
+	}
+	return n;
+}
+
+/* Unfreeze all the cpu partial slabs */
+static void unfreeze_partials(struct kmem_cache *s)
+{
+	struct kmem_cache_node *n = NULL;
+	struct kmem_cache_cpu *c = this_cpu_ptr(s->cpu_slab);
+	struct page *page;
+
+	while ((page = c->partial)) {
+		c->partial = page->next;
+		n = unfreeze(s, page, n);
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
@@ -1941,8 +2072,12 @@ static inline void __flush_cpu_slab(stru
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
@@ -2066,8 +2201,6 @@ static inline void *new_slab_objects(str
  * Slow path. The lockless freelist is empty or we need to perform
  * debugging duties.
  *
- * Interrupts are disabled.
- *
  * Processing is still very fast if new objects have been freed to the
  * regular freelist. In that case we simply take over the regular freelist
  * as the lockless freelist and zap the regular freelist.
@@ -2100,7 +2233,7 @@ static void *__slab_alloc(struct kmem_ca

 	if (!c->page)
 		goto new_slab;
-
+redo:
 	if (unlikely(!node_match(c, node))) {
 		stat(s, ALLOC_NODE_MISMATCH);
 		deactivate_slab(s, c);
@@ -2133,7 +2266,7 @@ static void *__slab_alloc(struct kmem_ca
 			NULL, new.counters,
 			"__slab_alloc"));

-	if (unlikely(!object)) {
+	if (!object) {
 		c->page = NULL;
 		stat(s, DEACTIVATE_BYPASS);
 		goto new_slab;
@@ -2148,6 +2281,17 @@ load_freelist:
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
@@ -2341,16 +2485,29 @@ static void __slab_free(struct kmem_cach
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

@@ -2360,7 +2517,15 @@ static void __slab_free(struct kmem_cach
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
@@ -2427,7 +2592,6 @@ static __always_inline void slab_free(st
 	slab_free_hook(s, x);

 redo:
-
 	/*
 	 * Determine the currently cpus per cpu slab.
 	 * The cpu may change afterward. However that does not matter since
@@ -2917,7 +3081,10 @@ static int kmem_cache_open(struct kmem_c
 	 * The larger the object size is, the more pages we want on the partial
 	 * list to avoid pounding the page allocator excessively.
 	 */
-	set_min_partial(s, ilog2(s->size));
+	set_min_partial(s, ilog2(s->size) / 2);
+
+	s->cpu_partial = 50;
+
 	s->refcount = 1;
 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 1000;
@@ -4325,6 +4492,7 @@ static ssize_t show_slab_objects(struct

 		for_each_possible_cpu(cpu) {
 			struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
+			struct page *page;

 			if (!c || c->node < 0)
 				continue;
@@ -4340,6 +4508,13 @@ static ssize_t show_slab_objects(struct
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
@@ -4491,6 +4666,27 @@ static ssize_t min_partial_store(struct
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
@@ -4529,6 +4725,43 @@ static ssize_t objects_partial_show(stru
 }
 SLAB_ATTR_RO(objects_partial);

+static ssize_t slabs_cpu_partial_show(struct kmem_cache *s, char *buf)
+{
+	unsigned long sum  = 0;
+	unsigned long pages = 0;
+	int cpu;
+	int len;
+	int *data = kmalloc(nr_cpu_ids * sizeof(int), GFP_KERNEL);
+
+	if (!data)
+		return -ENOMEM;
+
+	for_each_online_cpu(cpu) {
+		unsigned x = 0;
+		struct page *page;
+
+		page = per_cpu_ptr(s->cpu_slab, cpu)->partial;
+		if (page) {
+			pages += page->pages;
+			x = page->pobjects;
+		}
+		data[cpu] = x;
+		sum += x;
+	}
+
+	len = sprintf(buf, "%lu(%lu)", sum, pages);
+
+#ifdef CONFIG_SMP
+	for_each_online_cpu(cpu) {
+		if (data[cpu] && len < PAGE_SIZE - 20)
+			len += sprintf(buf + len, " C%d=%u", cpu, data[cpu]);
+	}
+#endif
+	kfree(data);
+	return len + sprintf(buf + len, "\n");
+}
+SLAB_ATTR_RO(slabs_cpu_partial);
+
 static ssize_t reclaim_account_show(struct kmem_cache *s, char *buf)
 {
 	return sprintf(buf, "%d\n", !!(s->flags & SLAB_RECLAIM_ACCOUNT));
@@ -4851,6 +5084,8 @@ STAT_ATTR(DEACTIVATE_BYPASS, deactivate_
 STAT_ATTR(ORDER_FALLBACK, order_fallback);
 STAT_ATTR(CMPXCHG_DOUBLE_CPU_FAIL, cmpxchg_double_cpu_fail);
 STAT_ATTR(CMPXCHG_DOUBLE_FAIL, cmpxchg_double_fail);
+STAT_ATTR(CPU_PARTIAL_ALLOC, cpu_partial_alloc);
+STAT_ATTR(CPU_PARTIAL_FREE, cpu_partial_free);
 #endif

 static struct attribute *slab_attrs[] = {
@@ -4859,6 +5094,7 @@ static struct attribute *slab_attrs[] =
 	&objs_per_slab_attr.attr,
 	&order_attr.attr,
 	&min_partial_attr.attr,
+	&cpu_partial_attr.attr,
 	&objects_attr.attr,
 	&objects_partial_attr.attr,
 	&partial_attr.attr,
@@ -4871,6 +5107,7 @@ static struct attribute *slab_attrs[] =
 	&destroy_by_rcu_attr.attr,
 	&shrink_attr.attr,
 	&reserved_attr.attr,
+	&slabs_cpu_partial_attr.attr,
 #ifdef CONFIG_SLUB_DEBUG
 	&total_objects_attr.attr,
 	&slabs_attr.attr,
@@ -4912,6 +5149,8 @@ static struct attribute *slab_attrs[] =
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
--- linux-2.6.orig/include/linux/mm_types.h	2011-08-02 12:07:33.575281487 -0500
+++ linux-2.6/include/linux/mm_types.h	2011-08-02 12:07:35.225281476 -0500
@@ -79,9 +79,16 @@ struct page {
 	};

 	/* Third double word block */
-	struct list_head lru;		/* Pageout list, eg. active_list
+	union {
+		struct list_head lru;	/* Pageout list, eg. active_list
 					 * protected by zone->lru_lock !
 					 */
+		struct {		/* SLUB pages in frozen state */
+			struct page *next;	/* Next partial slab */
+			short int pages;	/* Nr of partial slabs left */
+			short int pobjects;	/* Approximate # of objects */
+		};
+	};

 	/* Remainder is not double word aligned */
 	union {
