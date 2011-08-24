Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab1HXA41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 20:56:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:16424 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847Ab1HXA4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 20:56:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,272,1312182000"; 
   d="scan'208";a="41723776"
Subject: Re: [patch 2/2]slub: add a type for slab partial list position
From: Shaohua Li <shaohua.li@intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "Shi, Alex" <alex.shi@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <alpine.DEB.2.00.1108231023470.21267@router.home>
References: <1314059823.29510.19.camel@sli10-conroe>
	 <alpine.DEB.2.00.1108231023470.21267@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 08:57:52 +0800
Message-ID: <1314147472.29510.25.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 23:25 +0800, Christoph Lameter wrote:
> On Tue, 23 Aug 2011, Shaohua Li wrote:
> 
> > Adding slab to partial list head/tail is sensentive to performance.
> > So adding a type to document it to avoid we get it wrong.
> 
> I think that if you want to make it more descriptive then using the stats
> values (DEACTIVATE_TO_TAIL/HEAD) would avoid having to introduce an
> additional enum and it would also avoid the if statement in the stat call.
ok, that's better.

Subject: slub: explicitly document position of inserting slab to partial list

Adding slab to partial list head/tail is sensitive to performance.
So explicitly uses DEACTIVATE_TO_TAIL/DEACTIVATE_TO_HEAD to document
it to avoid we get it wrong.

Signed-off-by: Shaohua Li <shli@kernel.org>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 mm/slub.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c	2011-08-24 08:46:27.000000000 +0800
+++ linux/mm/slub.c	2011-08-24 08:49:41.000000000 +0800
@@ -1534,7 +1534,7 @@ static inline void add_partial(struct km
 				struct page *page, int tail)
 {
 	n->nr_partial++;
-	if (tail)
+	if (tail == DEACTIVATE_TO_TAIL)
 		list_add_tail(&page->lru, &n->partial);
 	else
 		list_add(&page->lru, &n->partial);
@@ -1781,13 +1781,13 @@ static void deactivate_slab(struct kmem_
 	enum slab_modes l = M_NONE, m = M_NONE;
 	void *freelist;
 	void *nextfree;
-	int tail = 0;
+	int tail = DEACTIVATE_TO_HEAD;
 	struct page new;
 	struct page old;
 
 	if (page->freelist) {
 		stat(s, DEACTIVATE_REMOTE_FREES);
-		tail = 1;
+		tail = DEACTIVATE_TO_TAIL;
 	}
 
 	c->tid = next_tid(c->tid);
@@ -1893,7 +1893,7 @@ redo:
 		if (m == M_PARTIAL) {
 
 			add_partial(n, page, tail);
-			stat(s, tail ? DEACTIVATE_TO_TAIL : DEACTIVATE_TO_HEAD);
+			stat(s, tail);
 
 		} else if (m == M_FULL) {
 
@@ -2377,7 +2377,7 @@ static void __slab_free(struct kmem_cach
 		 */
 		if (unlikely(!prior)) {
 			remove_full(s, page);
-			add_partial(n, page, 1);
+			add_partial(n, page, DEACTIVATE_TO_TAIL);
 			stat(s, FREE_ADD_PARTIAL);
 		}
 	}
@@ -2695,7 +2695,7 @@ static void early_kmem_cache_node_alloc(
 	init_kmem_cache_node(n, kmem_cache_node);
 	inc_slabs_node(kmem_cache_node, node, page->objects);
 
-	add_partial(n, page, 0);
+	add_partial(n, page, DEACTIVATE_TO_HEAD);
 }
 
 static void free_kmem_cache_nodes(struct kmem_cache *s)


