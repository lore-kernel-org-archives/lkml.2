Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386Ab1EZSSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:18:05 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:27473 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758258Ab1EZSPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:15:08 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: PRORF_wVM1nU3KLuObphtMnAHCg3jqO2kPZ9nDfM0noP85r
 6ZuDe5GrtI1LcFTpeYZUddd.CxFTSWnNC3E2HhxDg5xFvjknzIkxLJg5yZLB
 28UqkcqnD5RkE9K6QsoGSNGQkjiMt0kspBKngUsQfpNMB0xRgnEA.fiK1EMh
 h8ODDjYEqUi9r6ybf5lC4OWNXnKweWxNOJaCiEh1gNNNc6vxQ9NuYGAERAY0
 FKRg5MHLZKbLdRzvb.BB4T2Y1qqV1eI6adQsCRrasIwsGSxt6lCrYlKumBgl
 .6f2UhGFTYyz7OAbGRtv0UC_PW3A9cUwvU7jNV7LWL3D98XtT
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110526181506.008690257@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 13:14:50 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv6 08/17] slub: Pass kmem_cache struct to lock and freeze slab
References: <20110526181442.789868308@linux.com>
Content-Disposition: inline; filename=pass_kmem_cache_to_lock_and_freeze
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need more information about the slab for the cmpxchg implementation.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-16 11:46:58.311463052 -0500
+++ linux-2.6/mm/slub.c	2011-05-16 11:47:01.591463049 -0500
@@ -1444,8 +1444,8 @@ static inline void remove_partial(struct
  *
  * Must hold list_lock.
  */
-static inline int lock_and_freeze_slab(struct kmem_cache_node *n,
-							struct page *page)
+static inline int lock_and_freeze_slab(struct kmem_cache *s,
+		struct kmem_cache_node *n, struct page *page)
 {
 	if (slab_trylock(page)) {
 		remove_partial(n, page);
@@ -1457,7 +1457,8 @@ static inline int lock_and_freeze_slab(s
 /*
  * Try to allocate a partial slab from a specific node.
  */
-static struct page *get_partial_node(struct kmem_cache_node *n)
+static struct page *get_partial_node(struct kmem_cache *s,
+					struct kmem_cache_node *n)
 {
 	struct page *page;
 
@@ -1472,7 +1473,7 @@ static struct page *get_partial_node(str
 
 	spin_lock(&n->list_lock);
 	list_for_each_entry(page, &n->partial, lru)
-		if (lock_and_freeze_slab(n, page))
+		if (lock_and_freeze_slab(s, n, page))
 			goto out;
 	page = NULL;
 out:
@@ -1523,7 +1524,7 @@ static struct page *get_any_partial(stru
 
 		if (n && cpuset_zone_allowed_hardwall(zone, flags) &&
 				n->nr_partial > s->min_partial) {
-			page = get_partial_node(n);
+			page = get_partial_node(s, n);
 			if (page) {
 				put_mems_allowed();
 				return page;
@@ -1543,7 +1544,7 @@ static struct page *get_partial(struct k
 	struct page *page;
 	int searchnode = (node == NUMA_NO_NODE) ? numa_node_id() : node;
 
-	page = get_partial_node(get_node(s, searchnode));
+	page = get_partial_node(s, get_node(s, searchnode));
 	if (page || node != NUMA_NO_NODE)
 		return page;
 

