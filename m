Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab1EaQ5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:57:20 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:36107 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751368Ab1EaQ5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:57:18 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: oTDN7xIVM1l6HnuM_LEwGVf_J0iyGKEEEES9KzujlLhdH1c
 b.LyY2xHM4y2UNcV7Bymy3FmgNoWgihoFdIUUep5rO8v68EoBbWYIk2P54In
 B86om9LxByOlJ4wcNi7bZusWFXRRePvB3kHpoCsiB9OpKVq4sxQHmEFR8GKn
 pMuCUK3A2SrqKUq_SkaNf4dRvWje1PO4AeVQvTGUNry.RXoXj8CIH2Qxslzy
 3gUU2dNENQIJHBSFWj_BBRCHenTE7.RBaaViXu7Czv7AM0Bh7Zvhz4tcnPjn
 rhZHXHO.VU6kt_jrBw0htDQIpHZlPRjLeEztFCDnp0m17KUrF
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 31 May 2011 11:57:15 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv6 02/17] slub: Do not use frozen page flag but a bit in
 the page counters
In-Reply-To: <alpine.DEB.2.00.1105261417550.10790@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1105311156140.19928@router.home>
References: <20110526181442.789868308@linux.com> <20110526181502.558602037@linux.com> <alpine.DEB.2.00.1105261417550.10790@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011, David Rientjes wrote:

> > Also all page start out as frozen pages so set the bit
> > when the page is allocated.
> >
>
> This comment is probably intended for the next patch in the series, which
> modifies new_slab() to set the bit on allocation.  There's no new behavior
> introduced by this patch.

Right.

> The PG_slub_frozen entry in enum pageflags also needs to be removed.

Ok.

Subject: slub: Do not use frozen page flag but a bit in the page counters

Do not use a page flag for the frozen bit. It needs to be part
of the state that is handled with cmpxchg_double(). So use a bit
in the counter struct in the page struct for that purpose.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 include/linux/mm_types.h   |    5 +++--
 include/linux/page-flags.h |    5 -----
 mm/slub.c                  |   12 ++++++------
 3 files changed, 9 insertions(+), 13 deletions(-)

Index: linux-2.6/include/linux/mm_types.h
===================================================================
--- linux-2.6.orig/include/linux/mm_types.h	2011-05-31 09:40:57.402990070 -0500
+++ linux-2.6/include/linux/mm_types.h	2011-05-31 09:42:53.632989323 -0500
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
--- linux-2.6.orig/include/linux/page-flags.h	2011-05-31 09:40:57.392990068 -0500
+++ linux-2.6/include/linux/page-flags.h	2011-05-31 09:43:25.402989115 -0500
@@ -124,9 +124,6 @@ enum pageflags {

 	/* SLOB */
 	PG_slob_free = PG_private,
-
-	/* SLUB */
-	PG_slub_frozen = PG_active,
 };

 #ifndef __GENERATING_BOUNDS_H
@@ -212,8 +209,6 @@ PAGEFLAG(SwapBacked, swapbacked) __CLEAR

 __PAGEFLAG(SlobFree, slob_free)

-__PAGEFLAG(SlubFrozen, slub_frozen)
-
 /*
  * Private page markings that may be used by the filesystem that owns the page
  * for its own purposes.
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-31 09:42:08.102989621 -0500
+++ linux-2.6/mm/slub.c	2011-05-31 09:42:53.632989323 -0500
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
@@ -1424,7 +1424,7 @@ static inline int lock_and_freeze_slab(s
 {
 	if (slab_trylock(page)) {
 		__remove_partial(n, page);
-		__SetPageSlubFrozen(page);
+		page->frozen = 1;
 		return 1;
 	}
 	return 0;
@@ -1538,7 +1538,7 @@ static void unfreeze_slab(struct kmem_ca
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));

-	__ClearPageSlubFrozen(page);
+	page->frozen = 0;
 	if (page->inuse) {

 		if (page->freelist) {
@@ -1868,7 +1868,7 @@ new_slab:
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
