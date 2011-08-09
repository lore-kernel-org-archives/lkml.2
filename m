Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab1HIVNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 17:13:09 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:22127 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752812Ab1HIVND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 17:13:03 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: W.xoSfkVM1k6YJV9yDgnRYbOZKVkdji9q316QAQsPaVZ13z
 0eRrwxn8JnSeSr1zwQ2SKNP8tMqp7SEwJgLKD.LesRF.3U.BOgHJXIOeQUdr
 ipxccQn148lpuCUAWmthrJYTw_pNaXC6Ip.dRJocv5W4_iqyB.m9wVG2b_GV
 eJXhm6b4jlfMYfuqRx8QaTNB.LFzfZU2IZC7vmGZtDk52JCYwH22b20rqoT3
 gf706vZLE9DYaRcpp6HNTjYHiZ_unLr4CLcS_uPmLgk4.wlOEHdTcUxh_8sB
 Fv6SM5oNPDNqnPZKRx_pL99YVLM6mpBMxSwwIZ6Ta741Lv6enxpnD_bD39hP
 UO9moNpdtrZz5cclkMKC39dc8XTfz4FN9QBpjzgFp.Lk0UB_HM73EN07_Rsm
 mYVzjMRswn1gWF9PI5KvPvA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Message-Id: <20110809211301.008837864@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 09 Aug 2011 16:12:25 -0500
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
Subject: [slub p4 4/7] slub: pass kmem_cache_cpu pointer to get_partial()
References: <20110809211221.831975979@linux.com>
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

