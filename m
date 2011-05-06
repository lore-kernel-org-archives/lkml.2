Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab1EFSKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:10:52 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:36188 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755029Ab1EFSG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:06:57 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: vKY6KcEVM1nlXxaYwv6RzTn6U_L_S.He4pXeLXpwKlwCkX4
 HwqFCd3r_4Oii5Bqm4kv..ZvM2CqKgiLJI0E832pYNbC03l7LCkIwgtspIBm
 RbHfn2uMpLZ7a4swOvO2vJRoSZmzUne0SGlCxM7l9ha.NPrXO11Y3XgoE70Y
 2saNt1WCmMr1q2luZ59.1cR7tHMZH4jGaeAie_ivSy99CiNRJggt.mUWHLyD
 cPNvhuMfRswpYkJrjxJLxoGYyNZA4O6Nca9sh.tN80ce5YqXcG4p.MwTaaq9
 d4dmSn0NSZCPUX7zHwPKt0sKkFu_StouMWfKCNtXf8wyuOHPi
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110506180655.858875712@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 May 2011 13:05:44 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv4 03/16] slub: Move page->frozen handling near where the page->freelist handling occurs
References: <20110506180541.990069206@linux.com>
Content-Disposition: inline; filename=frozen_move
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is necessary because the frozen bit has to be handled in the same cmpxchg_double
with the freelist and the counters.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-05 15:28:45.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-05-05 15:29:17.000000000 -0500
@@ -1264,6 +1264,7 @@ static struct page *new_slab(struct kmem
 
 	page->freelist = start;
 	page->inuse = 0;
+	page->frozen = 1;
 out:
 	return page;
 }
@@ -1402,7 +1403,6 @@ static inline int lock_and_freeze_slab(s
 {
 	if (slab_trylock(page)) {
 		__remove_partial(n, page);
-		page->frozen = 1;
 		return 1;
 	}
 	return 0;
@@ -1516,7 +1516,6 @@ static void unfreeze_slab(struct kmem_ca
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 
-	page->frozen = 0;
 	if (page->inuse) {
 
 		if (page->freelist) {
@@ -1649,6 +1648,7 @@ static void deactivate_slab(struct kmem_
 	}
 	c->page = NULL;
 	c->tid = next_tid(c->tid);
+	page->frozen = 0;
 	unfreeze_slab(s, page, tail);
 }
 
@@ -1809,6 +1809,8 @@ static void *__slab_alloc(struct kmem_ca
 	stat(s, ALLOC_REFILL);
 
 load_freelist:
+	VM_BUG_ON(!page->frozen);
+
 	object = page->freelist;
 	if (unlikely(!object))
 		goto another_slab;
@@ -1833,6 +1835,7 @@ new_slab:
 	page = get_partial(s, gfpflags, node);
 	if (page) {
 		stat(s, ALLOC_FROM_PARTIAL);
+		page->frozen = 1;
 load_from_page:
 		c->node = page_to_nid(page);
 		c->page = page;
@@ -1855,7 +1858,6 @@ load_from_page:
 			flush_slab(s, c);
 
 		slab_lock(page);
-		page->frozen = 1;
 
 		goto load_from_page;
 	}
@@ -2375,6 +2377,7 @@ static void early_kmem_cache_node_alloc(
 	BUG_ON(!n);
 	page->freelist = get_freepointer(kmem_cache_node, n);
 	page->inuse++;
+	page->frozen = 0;
 	kmem_cache_node->node[node] = n;
 #ifdef CONFIG_SLUB_DEBUG
 	init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);

