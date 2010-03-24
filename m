Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab0CXVZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:25:56 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:38126 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab0CXVZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:25:53 -0400
Date: Wed, 24 Mar 2010 16:25:47 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: Potential stack overflow
In-Reply-To: <alpine.DEB.2.00.1003241613350.16858@router.home>
Message-ID: <alpine.DEB.2.00.1003241624580.17362@router.home>
References: <1269430856.3213.27.camel@edumazet-laptop>  <alpine.DEB.2.00.1003241414270.14329@router.home>  <1269458528.2849.2.camel@edumazet-laptop>  <alpine.DEB.2.00.1003241443520.14329@router.home> <1269464591.2849.15.camel@edumazet-laptop>
 <alpine.DEB.2.00.1003241608270.16858@router.home> <alpine.DEB.2.00.1003241613350.16858@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patch for the second case. I think its better since it results
in an error display and it avoids the alloc for each slab. Add this piece
to your patch?

V1->V2 Fix missing kfree

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-03-24 16:23:19.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-03-24 16:24:21.000000000 -0500
@@ -3648,10 +3648,10 @@ static int add_location(struct loc_track
 }

 static void process_slab(struct loc_track *t, struct kmem_cache *s,
-		struct page *page, enum track_item alloc)
+		struct page *page, enum track_item alloc,
+		unsigned long *map)
 {
 	void *addr = page_address(page);
-	DECLARE_BITMAP(map, page->objects);
 	void *p;

 	bitmap_zero(map, page->objects);
@@ -3670,8 +3670,10 @@ static int list_locations(struct kmem_ca
 	unsigned long i;
 	struct loc_track t = { 0, 0, NULL };
 	int node;
+	unsigned long *map = kmalloc(BITS_TO_LONGS(oo_objects(s->max)) *
+				sizeof(unsigned long), GFP_KERNEL);

-	if (!alloc_loc_track(&t, PAGE_SIZE / sizeof(struct location),
+	if (!map || !alloc_loc_track(&t, PAGE_SIZE / sizeof(struct location),
 			GFP_TEMPORARY))
 		return sprintf(buf, "Out of memory\n");

@@ -3688,11 +3690,12 @@ static int list_locations(struct kmem_ca

 		spin_lock_irqsave(&n->list_lock, flags);
 		list_for_each_entry(page, &n->partial, lru)
-			process_slab(&t, s, page, alloc);
+			process_slab(&t, s, page, alloc, map);
 		list_for_each_entry(page, &n->full, lru)
-			process_slab(&t, s, page, alloc);
+			process_slab(&t, s, page, alloc, map);
 		spin_unlock_irqrestore(&n->list_lock, flags);
 	}
+	kfree(map);

 	for (i = 0; i < t.count; i++) {
 		struct location *l = &t.loc[i];
