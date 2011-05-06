Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab1EFSKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:10:53 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:24558 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754901Ab1EFSG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:06:57 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: KpYTzuoVM1mkpCf1F6IQ3BA4npnV2Sktth5Tp20tgnKmNYx
 QW3oD8KxfK99MRQN5tsS6wZv86LwJNcCZ_Zyse76sft2_TpgWj0awpApMw5g
 bI3PyVMBSrmanvdd1kK_sWFm1l4X0PLKOz.AKZmWPgjTSrD2jUtuzwbSwCc3
 9A.Egh10jpcmCqOHSVyBRHWgu_KM0gbcql.Ga574fYjAvT.bhGAdcPpDJJgu
 M50viE.eitAeJRd5LTelWsf4TrEOlXTk3SM3yeXOIuMC0wYVo0YdkXTRfpWv
 J1VPh7soVrCZB81bAVGQz4_UhVIAgr3QHtoiQfyf4XuP0xCt5dpBcDCtIsyF
 5jIkvXvQXZjeztIZyJi1bIr7r
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110506180655.268539417@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 May 2011 13:05:43 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv4 02/16] slub: Do not use frozen page flag but a bit in the page counters
References: <20110506180541.990069206@linux.com>
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
--- linux-2.6.orig/include/linux/mm_types.h	2011-05-03 08:48:24.000000000 -0500
+++ linux-2.6/include/linux/mm_types.h	2011-05-05 15:28:45.000000000 -0500
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
--- linux-2.6.orig/include/linux/page-flags.h	2011-05-03 08:48:24.000000000 -0500
+++ linux-2.6/include/linux/page-flags.h	2011-05-05 15:28:45.000000000 -0500
@@ -212,8 +212,6 @@ PAGEFLAG(SwapBacked, swapbacked) __CLEAR
 
 __PAGEFLAG(SlobFree, slob_free)
 
-__PAGEFLAG(SlubFrozen, slub_frozen)
-
 /*
  * Private page markings that may be used by the filesystem that owns the page
  * for its own purposes.
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-05 15:28:33.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-05-05 15:28:45.000000000 -0500
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
@@ -1855,7 +1855,7 @@ load_from_page:
 			flush_slab(s, c);
 
 		slab_lock(page);
-		__SetPageSlubFrozen(page);
+		page->frozen = 1;
 
 		goto load_from_page;
 	}
@@ -2048,7 +2048,7 @@ static void __slab_free(struct kmem_cach
 	page->freelist = object;
 	page->inuse--;
 
-	if (unlikely(PageSlubFrozen(page))) {
+	if (unlikely(page->frozen)) {
 		stat(s, FREE_FROZEN);
 		goto out_unlock;
 	}

