Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab1EZSTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:19:01 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:26525 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757985Ab1EZSPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:15:05 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: X7JlPZgVM1lv1yfB_lKkqlkFwiQCdhlXPTv2XkSbzXSlr6e
 GiP35XAOuX8UGKmDrehPTtT0QgK9u3D4x.Rz7KcV4Z__vEw4YPcNevRP1IPE
 Tw.X_Tl3zs0UTfWzrvHTlWeQHcxEEUoUlApGxBXD9oPL6.l11o_tQaQjzXKz
 LQuDI9X3spHMt.z77XgJq21MmOX5AnK691RvqTBO2hVRxnstUmSJwfR9v2DN
 ZM4GgsvyAeMpjT4ptDFskNAGyBLTfIB99nCXj9Ggg0SWX18M0apIOOcIFkEL
 BLTMkVJBbah1u0_mZ2aSi0duSIa7nYZ9okXhV9.Cw.u4IKX2EGeCywBP_NO0
 PeGKsV0I7G6GHa8RvCCCBOKvH
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110526181503.129943104@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 13:14:45 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv6 03/17] slub: Move page->frozen handling near where the page->freelist handling occurs
References: <20110526181442.789868308@linux.com>
Content-Disposition: inline; filename=frozen_move
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is necessary because the frozen bit has to be handled in the same cmpxchg_double
with the freelist and the counters.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-24 09:40:08.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-05-24 09:40:37.644875159 -0500
@@ -1284,6 +1284,7 @@ static struct page *new_slab(struct kmem
 
 	page->freelist = start;
 	page->inuse = 0;
+	page->frozen = 1;
 out:
 	return page;
 }
@@ -1422,7 +1423,6 @@ static inline int lock_and_freeze_slab(s
 {
 	if (slab_trylock(page)) {
 		__remove_partial(n, page);
-		page->frozen = 1;
 		return 1;
 	}
 	return 0;
@@ -1536,7 +1536,6 @@ static void unfreeze_slab(struct kmem_ca
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 
-	page->frozen = 0;
 	if (page->inuse) {
 
 		if (page->freelist) {
@@ -1669,6 +1668,7 @@ static void deactivate_slab(struct kmem_
 	}
 	c->page = NULL;
 	c->tid = next_tid(c->tid);
+	page->frozen = 0;
 	unfreeze_slab(s, page, tail);
 }
 
@@ -1829,6 +1829,8 @@ static void *__slab_alloc(struct kmem_ca
 	stat(s, ALLOC_REFILL);
 
 load_freelist:
+	VM_BUG_ON(!page->frozen);
+
 	object = page->freelist;
 	if (unlikely(!object))
 		goto another_slab;
@@ -1853,6 +1855,7 @@ new_slab:
 	page = get_partial(s, gfpflags, node);
 	if (page) {
 		stat(s, ALLOC_FROM_PARTIAL);
+		page->frozen = 1;
 		c->node = page_to_nid(page);
 		c->page = page;
 		goto load_freelist;
@@ -2373,6 +2376,7 @@ static void early_kmem_cache_node_alloc(
 	BUG_ON(!n);
 	page->freelist = get_freepointer(kmem_cache_node, n);
 	page->inuse++;
+	page->frozen = 0;
 	kmem_cache_node->node[node] = n;
 #ifdef CONFIG_SLUB_DEBUG
 	init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);

