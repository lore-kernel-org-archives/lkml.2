Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1HAQ3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:29:36 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:39399 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753313Ab1HAQ2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:28:53 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: YMHMyOkVM1k4UGOZm_l0BiS44OeRBBwEQlIA0PzCzIboOtp
 26DIBjEL9b.Gm.42GtA8xe28HJSEP0qkGdKhxL7fSQxYVXWwb9ja_pXHzewI
 SaBwAMIY_yROUZ8XDxPRQeWLzTG74drEXifPZVHNZhvvLoMbikoQsEUxerOY
 m37rTLQjrhesdRXM2o0LWI4oAMeiVW380fVrkxKp2eYmGmwekas6F7WT5xOf
 YFuoatEirt5tTa_JLvK1B0Yo.cx.hOwe.CKQGH0Pbt28Sq9Uk.cWroIG7gQj
 mR.a5wlGc_tg2uWaEEpoU04XgJ69t5F8sZJfht3RO5q2xkHMi
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Message-Id: <20110801162851.180201727@linux.com>
User-Agent: quilt/0.48-1
Date: Mon, 01 Aug 2011 11:28:27 -0500
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
Subject: [slub p3 4/7] slub: pass kmem_cache_cpu pointer to get_partial()
References: <20110801162823.755182213@linux.com>
Content-Disposition: inline; filename=push_c_into_get_partial
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass the kmem_cache_cpu pointer to get_partial(). That way
we can avoid the this_cpu_write() statements.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 mm/slub.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-08-01 11:04:26.025858912 -0500
+++ linux-2.6/mm/slub.c	2011-08-01 11:04:29.985858887 -0500
@@ -1557,7 +1557,8 @@ static inline void remove_partial(struct
  * Must hold list_lock.
  */
 static inline int acquire_slab(struct kmem_cache *s,
-		struct kmem_cache_node *n, struct page *page)
+		struct kmem_cache_node *n, struct page *page,
+		struct kmem_cache_cpu *c)
 {
 	void *freelist;
 	unsigned long counters;
@@ -1586,9 +1587,9 @@ static inline int acquire_slab(struct km
 
 	if (freelist) {
 		/* Populate the per cpu freelist */
-		this_cpu_write(s->cpu_slab->freelist, freelist);
-		this_cpu_write(s->cpu_slab->page, page);
-		this_cpu_write(s->cpu_slab->node, page_to_nid(page));
+		c->freelist = freelist;
+		c->page = page;
+		c->node = page_to_nid(page);
 		return 1;
 	} else {
 		/*
@@ -1606,7 +1607,7 @@ static inline int acquire_slab(struct km
  * Try to allocate a partial slab from a specific node.
  */
 static struct page *get_partial_node(struct kmem_cache *s,
-					struct kmem_cache_node *n)
+		struct kmem_cache_node *n, struct kmem_cache_cpu *c)
 {
 	struct page *page;
 
@@ -1621,7 +1622,7 @@ static struct page *get_partial_node(str
 
 	spin_lock(&n->list_lock);
 	list_for_each_entry(page, &n->partial, lru)
-		if (acquire_slab(s, n, page))
+		if (acquire_slab(s, n, page, c))
 			goto out;
 	page = NULL;
 out:
@@ -1632,7 +1633,8 @@ out:
 /*
  * Get a page from somewhere. Search in increasing NUMA distances.
  */
-static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags)
+static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags,
+		struct kmem_cache_cpu *c)
 {
 #ifdef CONFIG_NUMA
 	struct zonelist *zonelist;
@@ -1672,7 +1674,7 @@ static struct page *get_any_partial(stru
 
 		if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
 				n->nr_partial > s->min_partial) {
-			page = get_partial_node(s, n);
+			page = get_partial_node(s, n, c);
 			if (page) {
 				put_mems_allowed();
 				return page;
@@ -1687,16 +1689,17 @@ static struct page *get_any_partial(stru
 /*
  * Get a partial page, lock it and return it.
  */
-static struct page *get_partial(struct kmem_cache *s, gfp_t flags, int node)
+static struct page *get_partial(struct kmem_cache *s, gfp_t flags, int node,
+		struct kmem_cache_cpu *c)
 {
 	struct page *page;
 	int searchnode = (node == NUMA_NO_NODE) ? numa_node_id() : node;
 
-	page = get_partial_node(s, get_node(s, searchnode));
+	page = get_partial_node(s, get_node(s, searchnode), c);
 	if (page || node != NUMA_NO_NODE)
 		return page;
 
-	return get_any_partial(s, flags);
+	return get_any_partial(s, flags, c);
 }
 
 #ifdef CONFIG_PREEMPT
@@ -1765,9 +1768,6 @@ void init_kmem_cache_cpus(struct kmem_ca
 	for_each_possible_cpu(cpu)
 		per_cpu_ptr(s->cpu_slab, cpu)->tid = init_tid(cpu);
 }
-/*
- * Remove the cpu slab
- */
 
 /*
  * Remove the cpu slab
@@ -2116,7 +2116,7 @@ load_freelist:
 	return object;
 
 new_slab:
-	page = get_partial(s, gfpflags, node);
+	page = get_partial(s, gfpflags, node, c);
 	if (page) {
 		stat(s, ALLOC_FROM_PARTIAL);
 		object = c->freelist;

