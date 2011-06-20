Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1FTPdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 11:33:09 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:48377 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752737Ab1FTPdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 11:33:03 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: YopSmzQVM1ma1136axL67G6g39SHti4V.fOIL0LnTzsR6Zh
 BqSnE5utdWLwVq310j9rA0VtQJ2Jl9lSX1GYV66wjNsQ_WgIQlofrmLcJlnH
 UNSAyRRulvkK7qQDks3w7RXIRRKx6rDHeVl2_lGfcEyO1TPh8JwvAy9YGGqo
 Fgp918EDGxb9H4OlcCR1OYkagaKaEiuoAM1bQXcWhaAdpWoGLIOtFD0h_pmo
 jwCUAv2CtjVw_hrx8R65Y94ZuxfyvOq8JY.xd0VAnfqyDFrCSdmCkltut3Eo
 lCfImIYTbPmQF4XJetw9RX.O5q.pPm4i_otTuSZPZTkwUnQvq
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Message-Id: <20110620153300.609512936@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 20 Jun 2011 10:32:48 -0500
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
Subject: [slub p2 4/4] slub: [RFC] per cpu cache for partial pages
References: <20110620153244.214038140@linux.com>
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

This is only a first stab at this. There are some limitations:

1. We have to scan through an percpu array of page pointers. That is fast
   since we stick to a cacheline size.

2. The pickup in __slab_alloc() could consider NUMA locality instead of
   blindly picking the first partial block.

3. The "unfreeze()" function should have common code with deactivate_slab().
   Maybe those can be unified.

Future enhancements:

1. The pickup from the partial list could be perhaps be done without disabling
   interrupts with some work. The free path already puts the page into the
   per cpu partial list without disabling interrupts.

2. Configure the size of the per cpu partial blocks dynamically like the other
   aspects of slab operations.

3. The __slab_free() likely has some code path that are unnecessary now or
   where code is duplicated.

4. We dump all partials if the per cpu array overflows. There must be some other
   better algorithm.

5. We could reduce list_lock overhead further by allocation a set of partial
   lists in slab alloc instead of only one.

Performance:

				Before		After
./hackbench 100 process 200000
				Time: 2299.072	1742.454
./hackbench 100 process 20000
				Time: 224.654	182.393
./hackbench 100 process 20000
				Time: 227.126	182.780
./hackbench 100 process 20000
				Time: 219.608	182.899
./hackbench 10 process 20000
				Time: 21.769	18.756
./hackbench 10 process 20000
				Time: 21.657	18.938
./hackbench 10 process 20000
				Time: 23.193	19.537
./hackbench 1 process 20000
				Time: 2.337	2.263
./hackbench 1 process 20000
				Time: 2.223	2.271
./hackbench 1 process 20000
				Time: 2.269	2.301

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 include/linux/slub_def.h |    4 
 mm/slub.c                |  286 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 243 insertions(+), 47 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2011-06-20 10:02:19.927683344 -0500
+++ linux-2.6/include/linux/slub_def.h	2011-06-20 10:03:40.787682827 -0500
@@ -36,6 +36,8 @@ enum stat_item {
 	ORDER_FALLBACK,		/* Number of times fallback was necessary */
 	CMPXCHG_DOUBLE_CPU_FAIL,/* Failure of this_cpu_cmpxchg_double */
 	CMPXCHG_DOUBLE_FAIL,	/* Number of times that cmpxchg double did not match */
+	CPU_PARTIAL_ALLOC,	/* Used cpu partial on alloc */
+	CPU_PARTIAL_FREE,	/* USed cpu partial on free */
 	NR_SLUB_STAT_ITEMS };
 
 struct kmem_cache_cpu {
@@ -46,6 +48,7 @@ struct kmem_cache_cpu {
 #ifdef CONFIG_SLUB_STATS
 	unsigned stat[NR_SLUB_STAT_ITEMS];
 #endif
+	struct page *partial[];	/* Partially allocated frozen slabs */
 };
 
 struct kmem_cache_node {
@@ -79,6 +82,7 @@ struct kmem_cache {
 	int size;		/* The size of an object including meta data */
 	int objsize;		/* The size of an object without meta data */
 	int offset;		/* Free pointer offset. */
+	int cpu_partial;	/* Number of per cpu partial pages to keep around */
 	struct kmem_cache_order_objects oo;
 
 	/* Allocation and freeing of slabs */
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-06-20 10:02:32.987683261 -0500
+++ linux-2.6/mm/slub.c	2011-06-20 10:16:42.027677825 -0500
@@ -1454,7 +1454,7 @@ static inline void remove_partial(struct
  */
 static inline void *acquire_slab(struct kmem_cache *s,
 		struct kmem_cache_node *n, struct page *page,
-		struct kmem_cache_cpu *c)
+		int mode)
 {
 	void *freelist;
 	unsigned long counters;
@@ -1469,7 +1469,8 @@ static inline void *acquire_slab(struct
 		freelist = page->freelist;
 		counters = page->counters;
 		new.counters = counters;
-		new.inuse = page->objects;
+		if (mode)
+			new.inuse = page->objects;
 
 		VM_BUG_ON(new.frozen);
 		new.frozen = 1;
@@ -1480,24 +1481,7 @@ static inline void *acquire_slab(struct
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
 
 /*
@@ -1506,8 +1490,9 @@ static inline void *acquire_slab(struct
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
@@ -1519,13 +1504,26 @@ static void *get_partial_node(struct kme
 		return NULL;
 
 	spin_lock(&n->list_lock);
-	list_for_each_entry(page, &n->partial, lru) {
-		object = acquire_slab(s, n, page, c);
-		if (object)
-			goto out;
+	list_for_each_entry_safe(page, page2, &n->partial, lru) {
+		void *t = acquire_slab(s, n, page, count == 0);
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
+		} else {
+			c->partial[count++] = page;
+			page->freelist = t;
+		}
+
+ 		if (count > s->cpu_partial / 2)
+			break;
 	}
-	object = NULL;
-out:
 	spin_unlock(&n->list_lock);
 	return object;
 }
@@ -1820,6 +1818,104 @@ redo:
 	}
 }
 
+/*
+ * Unfreeze a page. Page cannot be full. May be empty. If n is passed then the list lock on that
+ * node was taken. The functions return the pointer to the list_lock that was eventually taken in
+ * this function.
+ *
+ * Races are limited to __slab_free. Meaning that the number of free objects may increase but not
+ * decrease.
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
+/* Batch free the partial pages */
+static void __unfreeze_partials(struct kmem_cache *s, struct page *page)
+{
+	int i;
+	struct kmem_cache_node *n = NULL;
+
+	if (page)
+		n = unfreeze(s, page, NULL);
+
+	for (i = 0; i < s->cpu_partial; i++) {
+		page = this_cpu_read(s->cpu_slab->partial[i]);
+
+		if (page) {
+			this_cpu_write(s->cpu_slab->partial[i], NULL);
+			n = unfreeze(s, page, n);
+		}
+
+	}
+
+	if (n)
+		spin_unlock(&n->list_lock);
+}
+
+static void unfreeze_partials(struct kmem_cache *s, struct page *page)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	__unfreeze_partials(s, page);
+
+	local_irq_restore(flags);
+}
+
+
 static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
 	stat(s, CPUSLAB_FLUSH);
@@ -1835,8 +1931,12 @@ static inline void __flush_cpu_slab(stru
 {
 	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
 
-	if (likely(c && c->page))
-		flush_slab(s, c);
+	if (likely(c)) {
+		if (c->page)
+			flush_slab(s, c);
+
+		__unfreeze_partials(s, NULL);
+	}
 }
 
 static void flush_cpu_slab(void *d)
@@ -1981,6 +2081,7 @@ static void *__slab_alloc(struct kmem_ca
 	unsigned long flags;
 	struct page new;
 	unsigned long counters;
+	int i;
 
 	local_irq_save(flags);
 #ifdef CONFIG_PREEMPT
@@ -1997,7 +2098,7 @@ static void *__slab_alloc(struct kmem_ca
 
 	if (!c->page)
 		goto new_slab;
-
+redo:
 	if (unlikely(!node_match(c, node))) {
 		stat(s, ALLOC_NODE_MISMATCH);
 		deactivate_slab(s, c);
@@ -2045,6 +2146,18 @@ load_freelist:
 	return object;
 
 new_slab:
+	/* First try our cache of partially allocated pages */
+	for (i = 0; i < s->cpu_partial; i++)
+		if (c->partial[i]) {
+			c->page = c->partial[i];
+			c->freelist = NULL;
+			c->partial[i] = NULL;
+			c->node = page_to_nid(c->page);
+			stat(s, CPU_PARTIAL_ALLOC);
+			goto redo;
+		}
+
+	/* Then do expensive stuff like retrieving pages from the partial lists */
 	object = get_partial(s, gfpflags, node, c);
 
 	if (unlikely(!object)) {
@@ -2239,16 +2352,29 @@ static void __slab_free(struct kmem_cach
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
+				 * We can defer the list move and freeze it easily.
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
 
@@ -2258,7 +2384,23 @@ static void __slab_free(struct kmem_cach
 		"__slab_free"));
 
 	if (likely(!n)) {
-                /*
+       		if (new.frozen && !was_frozen) {
+			int i;
+
+			for (i = 0; i < s->cpu_partial; i++)
+				if (this_cpu_cmpxchg(s->cpu_slab->partial[i], NULL, page) == NULL) {
+					stat(s, CPU_PARTIAL_FREE);
+					return;
+				}
+
+			/*
+			 * partial array is overflowing. Drop them all as well as the one we just
+			 * froze.
+			 */
+			unfreeze_partials(s, page);
+		}
+
+         	/*
 		 * The list lock was not taken therefore no list
 		 * activity can be necessary.
 		 */
@@ -2325,7 +2467,6 @@ static __always_inline void slab_free(st
 	slab_free_hook(s, x);
 
 redo:
-
 	/*
 	 * Determine the currently cpus per cpu slab.
 	 * The cpu may change afterward. However that does not matter since
@@ -2540,6 +2681,9 @@ init_kmem_cache_node(struct kmem_cache_n
 
 static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
 {
+	int size = sizeof(struct kmem_cache_cpu) + s->cpu_partial * sizeof(void *);
+	int align = 2 * sizeof(void *);
+
 	BUILD_BUG_ON(PERCPU_DYNAMIC_EARLY_SIZE <
 			SLUB_PAGE_SHIFT * sizeof(struct kmem_cache_cpu));
 
@@ -2547,9 +2691,7 @@ static inline int alloc_kmem_cache_cpus(
 	 * Must align to double word boundary for the double cmpxchg
 	 * instructions to work; see __pcpu_double_call_return_bool().
 	 */
-	s->cpu_slab = __alloc_percpu(sizeof(struct kmem_cache_cpu),
-				     2 * sizeof(void *));
-
+	s->cpu_slab = __alloc_percpu(size, align);
 	if (!s->cpu_slab)
 		return 0;
 
@@ -2815,7 +2957,10 @@ static int kmem_cache_open(struct kmem_c
 	 * The larger the object size is, the more pages we want on the partial
 	 * list to avoid pounding the page allocator excessively.
 	 */
-	set_min_partial(s, ilog2(s->size));
+	set_min_partial(s, ilog2(s->size) / 2);
+	s->cpu_partial = min_t(int, (cache_line_size() -
+			sizeof(struct kmem_cache_cpu)) / sizeof(void),
+				s->min_partial / 2);
 	s->refcount = 1;
 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 1000;
@@ -4353,6 +4498,12 @@ static ssize_t min_partial_store(struct
 }
 SLAB_ATTR(min_partial);
 
+static ssize_t cpu_partial_show(struct kmem_cache *s, char *buf)
+{
+	return sprintf(buf, "%u\n", s->cpu_partial);
+}
+SLAB_ATTR_RO(cpu_partial);
+
 static ssize_t ctor_show(struct kmem_cache *s, char *buf)
 {
 	if (!s->ctor)
@@ -4391,6 +4542,41 @@ static ssize_t objects_partial_show(stru
 }
 SLAB_ATTR_RO(objects_partial);
 
+static ssize_t slabs_cpu_partial_show(struct kmem_cache *s, char *buf)
+{
+	unsigned long sum  = 0;
+	int cpu;
+	int len;
+	int *data = kmalloc(nr_cpu_ids * sizeof(int), GFP_KERNEL);
+
+	if (!data)
+		return -ENOMEM;
+
+	for_each_online_cpu(cpu) {
+		unsigned x = 0;
+		int i;
+
+		for (i = 0; i < s->cpu_partial; i++)
+			if (per_cpu_ptr(s->cpu_slab, cpu)->partial[i])
+				x++;
+
+		data[cpu] = x;
+		sum += x;
+	}
+
+	len = sprintf(buf, "%lu", sum);
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
@@ -4713,6 +4899,8 @@ STAT_ATTR(DEACTIVATE_BYPASS, deactivate_
 STAT_ATTR(ORDER_FALLBACK, order_fallback);
 STAT_ATTR(CMPXCHG_DOUBLE_CPU_FAIL, cmpxchg_double_cpu_fail);
 STAT_ATTR(CMPXCHG_DOUBLE_FAIL, cmpxchg_double_fail);
+STAT_ATTR(CPU_PARTIAL_ALLOC, cpu_partial_alloc);
+STAT_ATTR(CPU_PARTIAL_FREE, cpu_partial_free);
 #endif
 
 static struct attribute *slab_attrs[] = {
@@ -4721,6 +4909,7 @@ static struct attribute *slab_attrs[] =
 	&objs_per_slab_attr.attr,
 	&order_attr.attr,
 	&min_partial_attr.attr,
+	&cpu_partial_attr.attr,
 	&objects_attr.attr,
 	&objects_partial_attr.attr,
 	&partial_attr.attr,
@@ -4733,6 +4922,7 @@ static struct attribute *slab_attrs[] =
 	&destroy_by_rcu_attr.attr,
 	&shrink_attr.attr,
 	&reserved_attr.attr,
+	&slabs_cpu_partial_attr.attr,
 #ifdef CONFIG_SLUB_DEBUG
 	&total_objects_attr.attr,
 	&slabs_attr.attr,
@@ -4774,6 +4964,8 @@ static struct attribute *slab_attrs[] =
 	&order_fallback_attr.attr,
 	&cmpxchg_double_fail_attr.attr,
 	&cmpxchg_double_cpu_fail_attr.attr,
+	&cpu_partial_alloc_attr.attr,
+	&cpu_partial_free_attr.attr,
 #endif
 #ifdef CONFIG_FAILSLAB
 	&failslab_attr.attr,

