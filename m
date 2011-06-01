Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385Ab1FARag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:30:36 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:24525 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758946Ab1FAR0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:26:15 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Bz0Ez5gVM1m81qMAdnpj9XcoOjksqhHCPvFTVPWyrRxBAtI
 mD6lCqaqZaU_oI02Pcp9xv61RuTfGD7Llge5PwRFmo8UznbA8G3qMk38JvUl
 Ale8gafwHoQd.Wo2oesxX2TvOs58A.gI9zdDjth3aWB8dR7N7LsVs3D1yo04
 Vtu_TEqfUeIk5tk5nDaYGAfZPu.yikot3qfdapvJ2hT4U47XllyDrS3FSTmr
 J5o04RXLAQ0duJt.b3axD8xkIOEp4O5VR9DGIoO.lJhEPg9H2cv_CMePatiP
 SCz_arFjkS_2tOTH8si8I2U1XefBZzwzhaIfjBJwoglVPl9yf
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110601172612.935727237@linux.com>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 12:25:45 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv7 02/17] slub: Do not use frozen page flag but a bit in the page counters
References: <20110601172543.437240675@linux.com>
Content-Disposition: inline; filename=frozen_field
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

