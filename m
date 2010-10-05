Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab0JES6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:58:22 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:28109 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754189Ab0JES6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:58:16 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ePZUSBcVM1mVuhkmFL7kjzWAnWAZGOWBcDxj7MVPSgr.llK
 RXYHSgkJLLuOIe6EmO5btECGbht6mExmif5QXmlTOTsbXSg3IwO5R33BHHPe
 ZfXkQWSxri7hULEp3li6ZzQuMMZdpRJxXr0Wk3cnrEDt7j7OpTokbpQfdgAr
 cqujdC2nr3uwpsbeDebBJHbSSix49Jwk02NTOmXKNmQBU8aWyVa5vFRMHcfe
 Gt0LXIwySCiete.FIB.s43PF4k9NBFIrX7a9T8rOca3rQEWei
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101005185814.694864612@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 05 Oct 2010 13:57:30 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>
Subject: [UnifiedV4 05/16] slub: Remove MAX_OBJS limitation
References: <20101005185725.088808842@linux.com>
Content-Disposition: inline; filename=unified_unlimited
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
--- linux-2.6.orig/include/linux/mm_types.h	2010-10-04 08:14:26.000000000 -0500
+++ linux-2.6/include/linux/mm_types.h	2010-10-04 08:26:05.000000000 -0500
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
--- linux-2.6.orig/mm/slub.c	2010-10-04 08:26:02.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-10-04 08:26:05.000000000 -0500
@@ -143,7 +143,6 @@ static inline int kmem_cache_debug(struc
 
 #define OO_SHIFT	16
 #define OO_MASK		((1 << OO_SHIFT) - 1)
-#define MAX_OBJS_PER_PAGE	65535 /* since page.objects is u16 */
 
 /* Internal SLUB flags */
 #define __OBJECT_POISON		0x80000000UL /* Poison object */
@@ -783,9 +782,6 @@ static int verify_slab(struct kmem_cache
 			max_objects = ((void *)page->freelist - start) / s->size;
 	}
 
-	if (max_objects > MAX_OBJS_PER_PAGE)
-		max_objects = MAX_OBJS_PER_PAGE;
-
 	if (page->objects != max_objects) {
 		slab_err(s, page, "Wrong number of objects. Found %d but "
 			"should be %d", page->objects, max_objects);
@@ -2097,9 +2093,6 @@ static inline int slab_order(int size, i
 	int rem;
 	int min_order = slub_min_order;
 
-	if ((PAGE_SIZE << min_order) / size > MAX_OBJS_PER_PAGE)
-		return get_order(size * MAX_OBJS_PER_PAGE) - 1;
-
 	for (order = max(min_order,
 				fls(min_objects * size - 1) - PAGE_SHIFT);
 			order <= max_order; order++) {

