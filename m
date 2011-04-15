Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab1DOUva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:51:30 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:25087 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756493Ab1DOUrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:47:51 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: dia_PSAVM1nvWHa5Ghg9xRZS5yETr27WAOtA4YhFMnh0pM7
 3pngqmRi3N6KBUU9BM.4rjlpnqFzab56si.gQMmXBRluACNvxzfYRKVfQHtR
 1q.TWoNo_hrv6v6qNtWsarwd2vPIvxD9bcj.aXXSw8PyphxfSj87Op4QastV
 qjq.m60MQMGDxLSIoPZi7t_Axp5BNA0xk40F1tj0Lw3RciqzzRNQMa.Bqlm3
 L3LwRuwLHuR1F8KZO5Fpm3pW1SkquT8.eG2a_gXamnSEekFUjyfJ52Sq8KJJ
 dAjfYTuBsAJiEvdJyxYxXKoZk.SjwB14XXUOsRhVp8NQs70z7QHSLS98IScB
 4ErZqdJ0v.jGCvUdL_IWen_4Z
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110415204750.100336990@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Apr 2011 15:47:37 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Subject: [slubllv3 07/21] slub: Do not use frozen page flag but a bit in the page counters
References: <20110415204730.326790555@linux.com>
Content-Disposition: inline; filename=frozen_field
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not use a page flag for the frozen bit. It needs to be part
of the state that is handled with cmpxchg_double(). So use a bit
in the counter struct in the page struct for that purpose.

Also all page start out as frozen pages so set the bit
when the page is allocated.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 include/linux/mm_types.h   |    5 +++--
 include/linux/page-flags.h |    2 --
 mm/slub.c                  |   12 ++++++------
 3 files changed, 9 insertions(+), 10 deletions(-)

Index: linux-2.6/include/linux/mm_types.h
===================================================================
--- linux-2.6.orig/include/linux/mm_types.h	2011-04-15 12:54:32.000000000 -0500
+++ linux-2.6/include/linux/mm_types.h	2011-04-15 13:14:36.000000000 -0500
@@ -41,8 +41,9 @@ struct page {
 					 * & limit reverse map searches.
 					 */
 		struct {		/* SLUB */
-			u16 inuse;
-			u16 objects;
+			unsigned inuse:16;
+			unsigned objects:15;
+			unsigned frozen:1;
 		};
 	};
 	union {
Index: linux-2.6/include/linux/page-flags.h
===================================================================
--- linux-2.6.orig/include/linux/page-flags.h	2011-04-15 12:54:32.000000000 -0500
+++ linux-2.6/include/linux/page-flags.h	2011-04-15 13:14:36.000000000 -0500
@@ -212,8 +212,6 @@ PAGEFLAG(SwapBacked, swapbacked) __CLEAR
 
 __PAGEFLAG(SlobFree, slob_free)
 
-__PAGEFLAG(SlubFrozen, slub_frozen)
-
 /*
  * Private page markings that may be used by the filesystem that owns the page
  * for its own purposes.
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-04-15 13:11:25.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-04-15 13:14:36.000000000 -0500
@@ -166,7 +166,7 @@ static inline int kmem_cache_debug(struc
 
 #define OO_SHIFT	16
 #define OO_MASK		((1 << OO_SHIFT) - 1)
-#define MAX_OBJS_PER_PAGE	65535 /* since page.objects is u16 */
+#define MAX_OBJS_PER_PAGE	32767 /* since page.objects is u15 */
 
 /* Internal SLUB flags */
 #define __OBJECT_POISON		0x80000000UL /* Poison object */
@@ -1013,7 +1013,7 @@ static noinline int free_debug_processin
 	}
 
 	/* Special debug activities for freeing objects */
-	if (!PageSlubFrozen(page) && !page->freelist)
+	if (!page->frozen && !page->freelist)
 		remove_full(s, page);
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, object, TRACK_FREE, addr);
@@ -1402,7 +1402,7 @@ static inline int lock_and_freeze_slab(s
 {
 	if (slab_trylock(page)) {
 		__remove_partial(n, page);
-		__SetPageSlubFrozen(page);
+		page->frozen = 1;
 		return 1;
 	}
 	return 0;
@@ -1516,7 +1516,7 @@ static void unfreeze_slab(struct kmem_ca
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 
-	__ClearPageSlubFrozen(page);
+	page->frozen = 0;
 	if (page->inuse) {
 
 		if (page->freelist) {
@@ -1867,7 +1867,7 @@ load_from_page:
 			flush_slab(s, c);
 
 		slab_lock(page);
-		__SetPageSlubFrozen(page);
+		page->frozen = 1;
 
 		goto load_from_page;
 	}
@@ -2081,7 +2081,7 @@ static void __slab_free(struct kmem_cach
 	page->freelist = object;
 	page->inuse--;
 
-	if (unlikely(PageSlubFrozen(page))) {
+	if (unlikely(page->frozen)) {
 		stat(s, FREE_FROZEN);
 		goto out_unlock;
 	}

