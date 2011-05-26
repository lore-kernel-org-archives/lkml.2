Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab1EZSPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:15:11 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:32847 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757976Ab1EZSPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:15:04 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Pudt9nMVM1knQRfp8aS4MHv9.F4vJu54COiBQoWvgerFlxN
 9ssnGfKc9QEB7KEpkcGSFUfnpqeJxy.iHx2JahKwO6C9Nab_Jx2AuHuaEHvL
 wvdxv3SLFY_j_RvtBf.jmkVn.ngBztz7KvpZ8DNaYfzvrv5tP55X5k7DT2eD
 yk3Nrb_1m7IJd8FHtDozQEgewahBJMPgmjnmVEwQpVKPOnJrRTPhvUeNYdEC
 XuSJ0fjfe4ddfe16yRHXGATwokeCYQ4c0pB2YpndvKwsWfkvSXGSgv4LBEM9
 6eGMqHX1E1DN3I5a0MjyOjJ.XvbDpfXyvEDecnQQwUmEftWrf
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110526181502.558602037@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 13:14:44 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv6 02/17] slub: Do not use frozen page flag but a bit in the page counters
References: <20110526181442.789868308@linux.com>
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
--- linux-2.6.orig/include/linux/mm_types.h	2011-05-19 13:54:29.271151992 -0500
+++ linux-2.6/include/linux/mm_types.h	2011-05-19 13:59:28.551151643 -0500
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
--- linux-2.6.orig/include/linux/page-flags.h	2011-05-19 13:54:29.281151992 -0500
+++ linux-2.6/include/linux/page-flags.h	2011-05-19 13:59:28.551151643 -0500
@@ -212,8 +212,6 @@ PAGEFLAG(SwapBacked, swapbacked) __CLEAR
 
 __PAGEFLAG(SlobFree, slob_free)
 
-__PAGEFLAG(SlubFrozen, slub_frozen)
-
 /*
  * Private page markings that may be used by the filesystem that owns the page
  * for its own purposes.
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-19 13:59:24.981151647 -0500
+++ linux-2.6/mm/slub.c	2011-05-19 13:59:28.561151643 -0500
@@ -166,7 +166,7 @@ static inline int kmem_cache_debug(struc
 
 #define OO_SHIFT	16
 #define OO_MASK		((1 << OO_SHIFT) - 1)
-#define MAX_OBJS_PER_PAGE	65535 /* since page.objects is u16 */
+#define MAX_OBJS_PER_PAGE	32767 /* since page.objects is u15 */
 
 /* Internal SLUB flags */
 #define __OBJECT_POISON		0x80000000UL /* Poison object */
@@ -1025,7 +1025,7 @@ static noinline int free_debug_processin
 	}
 
 	/* Special debug activities for freeing objects */
-	if (!PageSlubFrozen(page) && !page->freelist)
+	if (!page->frozen && !page->freelist)
 		remove_full(s, page);
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, object, TRACK_FREE, addr);
@@ -1421,7 +1421,7 @@ static inline int lock_and_freeze_slab(s
 {
 	if (slab_trylock(page)) {
 		__remove_partial(n, page);
-		__SetPageSlubFrozen(page);
+		page->frozen = 1;
 		return 1;
 	}
 	return 0;
@@ -1535,7 +1535,7 @@ static void unfreeze_slab(struct kmem_ca
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 
-	__ClearPageSlubFrozen(page);
+	page->frozen = 0;
 	if (page->inuse) {
 
 		if (page->freelist) {
@@ -1866,7 +1866,7 @@ new_slab:
 			flush_slab(s, c);
 
 		slab_lock(page);
-		__SetPageSlubFrozen(page);
+		page->frozen = 1;
 		c->node = page_to_nid(page);
 		c->page = page;
 		goto load_freelist;
@@ -2048,7 +2048,7 @@ static void __slab_free(struct kmem_cach
 	page->freelist = object;
 	page->inuse--;
 
-	if (unlikely(PageSlubFrozen(page))) {
+	if (unlikely(page->frozen)) {
 		stat(s, FREE_FROZEN);
 		goto out_unlock;
 	}

