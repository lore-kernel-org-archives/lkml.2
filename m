Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316Ab1FARaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:30:11 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:47769 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759005Ab1FAR0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:26:15 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Kr9jMYIVM1nxmT71H7jwTswRcGDmE7bWe6GtU9LmmkWkfqZ
 .WUPa6OoEPX.Ga8c7vlUTvca__saQg7AwJ0bDynTZVxvBNnyaeWbzEBXGu1P
 AbzOnFlK86LFKvp9nev47uk.GxG1GlO.c.fby_zdueXSonGwRQyzMJjHjt1s
 kCagaW8HrMYaAU3tmhfhH9tos8v4MOUX.kt5TDqkIhc8_HtLn3L5hsvOwKZl
 1.humACYNPpQze1OMRM7DyxIXigKTt6priT66QWkg2KkUBquqjeZzAbaLZgv
 jTZMBJ5aLZEoega_47v1vSCykfQkHbHWbPp.lKUDDCmWTOfG0_D0S5ckXIb6
 Rcq2ytSGThiQ.xKDt2xYwgmkcRA--
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110601172613.589622062@linux.com>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 12:25:46 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv7 03/17] slub: Move page->frozen handling near where the page->freelist handling occurs
References: <20110601172543.437240675@linux.com>
Content-Disposition: inline; filename=frozen_move
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is necessary because the frozen bit has to be handled in the same cmpxchg_double
with the freelist and the counters.

Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>

---
 mm/slub.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-31 09:42:53.632989323 -0500
+++ linux-2.6/mm/slub.c	2011-05-31 09:43:48.312988970 -0500
@@ -1286,6 +1286,7 @@ static struct page *new_slab(struct kmem
 
 	page->freelist = start;
 	page->inuse = 0;
+	page->frozen = 1;
 out:
 	return page;
 }
@@ -1424,7 +1425,6 @@ static inline int lock_and_freeze_slab(s
 {
 	if (slab_trylock(page)) {
 		__remove_partial(n, page);
-		page->frozen = 1;
 		return 1;
 	}
 	return 0;
@@ -1538,7 +1538,6 @@ static void unfreeze_slab(struct kmem_ca
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 
-	page->frozen = 0;
 	if (page->inuse) {
 
 		if (page->freelist) {
@@ -1671,6 +1670,7 @@ static void deactivate_slab(struct kmem_
 	}
 	c->page = NULL;
 	c->tid = next_tid(c->tid);
+	page->frozen = 0;
 	unfreeze_slab(s, page, tail);
 }
 
@@ -1831,6 +1831,8 @@ static void *__slab_alloc(struct kmem_ca
 	stat(s, ALLOC_REFILL);
 
 load_freelist:
+	VM_BUG_ON(!page->frozen);
+
 	object = page->freelist;
 	if (unlikely(!object))
 		goto another_slab;
@@ -1854,6 +1856,7 @@ new_slab:
 	page = get_partial(s, gfpflags, node);
 	if (page) {
 		stat(s, ALLOC_FROM_PARTIAL);
+		page->frozen = 1;
 		c->node = page_to_nid(page);
 		c->page = page;
 		goto load_freelist;
@@ -2375,6 +2378,7 @@ static void early_kmem_cache_node_alloc(
 	BUG_ON(!n);
 	page->freelist = get_freepointer(kmem_cache_node, n);
 	page->inuse++;
+	page->frozen = 0;
 	kmem_cache_node->node[node] = n;
 #ifdef CONFIG_SLUB_DEBUG
 	init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);

