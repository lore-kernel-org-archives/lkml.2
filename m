Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab0GITMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:12:31 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:34392 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab0GITMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:12:25 -0400
Message-Id: <20100709190900.425400590@quilx.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 14:07:24 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>
Subject: [S+Q2 18/19] SLUB: Remove MAX_OBJS limitation
References: <20100709190706.938177313@quilx.com>
Content-Disposition: inline; filename=sled_unlimited_objects
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need anymore for the "inuse" field in the page struct.
Extend the objects field to 32 bit allowing a practically unlimited
number of objects.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/mm_types.h |    5 +----
 mm/slub.c                |    7 -------
 2 files changed, 1 insertion(+), 11 deletions(-)

Index: linux-2.6/include/linux/mm_types.h
===================================================================
--- linux-2.6.orig/include/linux/mm_types.h	2010-07-07 10:54:05.000000000 -0500
+++ linux-2.6/include/linux/mm_types.h	2010-07-07 10:54:36.000000000 -0500
@@ -40,10 +40,7 @@ struct page {
 					 * to show when page is mapped
 					 * & limit reverse map searches.
 					 */
-		struct {		/* SLUB */
-			u16 inuse;
-			u16 objects;
-		};
+		u32 objects;		/* SLUB */
 	};
 	union {
 	    struct {
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-07 10:54:33.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-07-07 10:54:36.000000000 -0500
@@ -145,7 +145,6 @@ static inline int kmem_cache_debug(struc
 
 #define OO_SHIFT	16
 #define OO_MASK		((1 << OO_SHIFT) - 1)
-#define MAX_OBJS_PER_PAGE	65535 /* since page.objects is u16 */
 
 /* Internal SLUB flags */
 #define __OBJECT_POISON		0x80000000UL /* Poison object */
@@ -768,9 +767,6 @@ static int verify_slab(struct kmem_cache
 			max_objects = ((void *)page->freelist - start) / s->size;
 	}
 
-	if (max_objects > MAX_OBJS_PER_PAGE)
-		max_objects = MAX_OBJS_PER_PAGE;
-
 	if (page->objects != max_objects) {
 		slab_err(s, page, "Wrong number of objects. Found %d but "
 			"should be %d", page->objects, max_objects);
@@ -1984,9 +1980,6 @@ static inline int slab_order(int size, i
 	int rem;
 	int min_order = slub_min_order;
 
-	if ((PAGE_SIZE << min_order) / size > MAX_OBJS_PER_PAGE)
-		return get_order(size * MAX_OBJS_PER_PAGE) - 1;
-
 	for (order = max(min_order,
 				fls(min_objects * size - 1) - PAGE_SHIFT);
 			order <= max_order; order++) {

