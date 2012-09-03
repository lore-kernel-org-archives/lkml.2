Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab2ICKJC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 06:09:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204Ab2ICKJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 06:09:00 -0400
Date: Mon, 3 Sep 2012 11:08:55 +0100
From: Mel Gorman <mgorman@suse.de>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 1/2] slab:  do ClearSlabPfmemalloc() for all pages of slab
Message-ID: <20120903100855.GA11266@suse.de>
References: <Yes>
 <1345903871-1921-1-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1345903871-1921-1-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It took me a while to getting around to reviewing this due to attending
kernel summit. Sorry about that.

On Sat, Aug 25, 2012 at 11:11:10PM +0900, Joonsoo Kim wrote:
> Now, we just do ClearSlabPfmemalloc() for first page of slab
> when we clear SlabPfmemalloc flag. It is a problem because we sometimes
> test flag of page which is not first page of slab in __ac_put_obj().
> 

Well spotted.

The impact is marginal as far as pfmemalloc protection is concerned. I do not
believe that any of the slabs that use high-order allocations are used in for
the swap-over-network paths. It would be unfortunate if that ever changed.

> So add code to do ClearSlabPfmemalloc for all pages of slab.
> 

I would prefer if the pfmemalloc information was kept on the head page.
Would the following patch also address your concerns?

diff --git a/mm/slab.c b/mm/slab.c
index 811af03..d34a903 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1000,7 +1000,7 @@ static void *__ac_get_obj(struct kmem_cache *cachep, struct array_cache *ac,
 		l3 = cachep->nodelists[numa_mem_id()];
 		if (!list_empty(&l3->slabs_free) && force_refill) {
 			struct slab *slabp = virt_to_slab(objp);
-			ClearPageSlabPfmemalloc(virt_to_page(slabp->s_mem));
+			ClearPageSlabPfmemalloc(virt_to_head_page(slabp->s_mem));
 			clear_obj_pfmemalloc(&objp);
 			recheck_pfmemalloc_active(cachep, ac);
 			return objp;
@@ -1032,7 +1032,7 @@ static void *__ac_put_obj(struct kmem_cache *cachep, struct array_cache *ac,
 {
 	if (unlikely(pfmemalloc_active)) {
 		/* Some pfmemalloc slabs exist, check if this is one */
-		struct page *page = virt_to_page(objp);
+		struct page *page = virt_to_head_page(objp);
 		if (PageSlabPfmemalloc(page))
 			set_obj_pfmemalloc(&objp);
 	}

-- 
Mel Gorman
SUSE Labs
