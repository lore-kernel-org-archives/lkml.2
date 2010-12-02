Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab0LBVyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:54:45 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:47187 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758069Ab0LBVyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:54:05 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: fv8RrTAVM1lE430LKNC0UzkTS0Sgp1Px8wAdEedMt_ir6rs
 HWZpHHbExmWqHlJRgR.z9aLi8CTkFf9REijljGRA302rvpKcWHI4Eb3IL7Z0
 xdgpK2g6CFYEUvyQ7.kdnUZz.801h4OgbvPBqHmuaX7LCU0sy4Q3iP9Kh7JX
 RTITrVtLzDCpaKltgWGEWapOFfy_bUySGDX67u5P8N7jjkuGNB5Cuq47XOUm
 USeMCVJrXDozHOtZ5CNA3ffpceX3UMMLdPOgXP98JaSsVW9RSSvWa
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101202215402.974066360@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 02 Dec 2010 15:53:47 -0600
From: Christoph Lameter <cl@linux.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tejun Heo <tj@kernel.org>
Subject: [rfc: cpuops adv V1 7/8] slub: Add PageSlubPartial
References: <20101202215340.562309713@linux.com>
Content-Disposition: inline; filename=slub_flag_partial
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The condition for a page being on the partial list is established by a set
of combinations of values in the page struct (inuse > 0 && freelist != NULL).

With the lockless updates that set may become temporarily incoherent.
Use an explit flag to signal that a page is on a partial list and allow
multiple adds and removes from the partial list.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 include/linux/page-flags.h |    2 ++
 mm/slub.c                  |   25 +++++++++++++++----------
 2 files changed, 17 insertions(+), 10 deletions(-)

Index: linux-2.6/include/linux/page-flags.h
===================================================================
--- linux-2.6.orig/include/linux/page-flags.h	2010-12-02 14:53:16.000000000 -0600
+++ linux-2.6/include/linux/page-flags.h	2010-12-02 15:01:35.000000000 -0600
@@ -128,6 +128,7 @@ enum pageflags {
 
 	/* SLUB */
 	PG_slub_frozen = PG_active,
+	PG_slub_partial = PG_error,
 };
 
 #ifndef __GENERATING_BOUNDS_H
@@ -214,6 +215,7 @@ PAGEFLAG(SwapBacked, swapbacked) __CLEAR
 __PAGEFLAG(SlobFree, slob_free)
 
 __PAGEFLAG(SlubFrozen, slub_frozen)
+__PAGEFLAG(SlubPartial, slub_partial) TESTSCFLAG(SlubPartial, slub_partial)
 
 /*
  * Private page markings that may be used by the filesystem that owns the page
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-12-02 14:58:48.000000000 -0600
+++ linux-2.6/mm/slub.c	2010-12-02 15:29:50.000000000 -0600
@@ -1308,13 +1308,15 @@ static __always_inline int slab_trylock(
 static void add_partial(struct kmem_cache_node *n,
 				struct page *page, int tail)
 {
-	spin_lock(&n->list_lock);
-	n->nr_partial++;
-	if (tail)
-		list_add_tail(&page->lru, &n->partial);
-	else
-		list_add(&page->lru, &n->partial);
-	spin_unlock(&n->list_lock);
+	if (!TestSetPageSlubPartial(page)) {
+		spin_lock(&n->list_lock);
+		n->nr_partial++;
+		if (tail)
+			list_add_tail(&page->lru, &n->partial);
+		else
+			list_add(&page->lru, &n->partial);
+		spin_unlock(&n->list_lock);
+	}
 }
 
 static inline void __remove_partial(struct kmem_cache_node *n,
@@ -1322,15 +1324,18 @@ static inline void __remove_partial(stru
 {
 	list_del(&page->lru);
 	n->nr_partial--;
+	__ClearPageSlubPartial(page);
 }
 
 static void remove_partial(struct kmem_cache *s, struct page *page)
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 
-	spin_lock(&n->list_lock);
-	__remove_partial(n, page);
-	spin_unlock(&n->list_lock);
+	if (TestClearPageSlubPartial(page)) {
+		spin_lock(&n->list_lock);
+		__remove_partial(n, page);
+		spin_unlock(&n->list_lock);
+	}
 }
 
 /*

