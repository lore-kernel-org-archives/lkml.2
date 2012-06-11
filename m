Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab2FKKh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:37:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8241 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab2FKKh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:37:58 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-88-4fd5ca848b54
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v10] mm: compaction: handle incorrect MIGRATE_UNMOVABLE
 type pageblocks
Date: Mon, 11 Jun 2012 12:37:22 +0200
User-Agent: KMail/1.13.2 (Linux/3.2.6; KDE/4.4.5; i686; ; )
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Dave Jones <davej@redhat.com>, Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <201206081046.32382.b.zolnierkie@samsung.com>
 <20120608141833.d105153e.akpm@linux-foundation.org>
In-reply-to: <20120608141833.d105153e.akpm@linux-foundation.org>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201206111237.22739.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jQd2WU1f9Dc6+VbS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZLaumsxfsD6to79zG1sC4xbWLkZNDQsBEYtLjNnYIW0ziwr31
	bCC2kMB0Romze4Mh7NVMEqtW8oDYbAJWEhPbVzGC2CICuhKrnu9iBrGFBWIldqzbwwpiswio
	SizcuY0FxBYVsJY4euEeWD2zwBNmiYOnXCFm5kvse3UbbBengINE84KtYDavgKDEj8n3WCDq
	tSSa32yC6pWX2LzmLTNEjaXEzJZtLBMYBWYhaZmFpGUWkpYFjMyrGEVTC5ILipPScw31ihNz
	i0vz0vWS83M3MYLD75nUDsaVDRaHGAU4GJV4eF9sveovxJpYVlyZe4hRgoNZSYR3WwVQiDcl
	sbIqtSg/vqg0J7X4EKM0B4uSOG+T9QV/IYH0xJLU7NTUgtQimCwTB6dUA+PUVh4zFZ3vsa9e
	NIS1Xbr6Z5XAgoK90QLvpwf5vvXyO/03hvVB99s+5z/Tuxp8Fn0r+r+ivjAk+L10wGPBPfV/
	W+afyTK9M3vOmtLfLXmOnR4vru5duPtghZNB0WSj9sK4FZPKDL3L3k/Z2f9JZoeugie3wqd3
	toez196vejrv14QSk8fVGy4rsRRnJBpqMRcVJwIANU6m1DsCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 June 2012 23:18:33 Andrew Morton wrote:
> On Fri, 08 Jun 2012 10:46:32 +0200
> Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:
> 
> > 
> > Hi,
> > 
> > This version is much simpler as it just uses __count_immobile_pages()
> > instead of using its own open coded version and it integrates changes
> > from Minchan Kim (without page_count change as it doesn't seem correct
> > and __count_immobile_pages() does the check in the standard way; if it
> > still is a problem I think that removing 1st phase check altogether
> > would be better instead of adding more locking complexity).
> > 
> > The patch also adds compact_rescued_unmovable_blocks vmevent to vmstats
> > to make it possible to easily check if the code is working in practice.
> > 
> > Best regards,
> > --
> > Bartlomiej Zolnierkiewicz
> > Samsung Poland R&D Center
> > 
> > 
> > From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Subject: [PATCH v10] mm: compaction: handle incorrect MIGRATE_UNMOVABLE type pageblocks
> > 
> > When MIGRATE_UNMOVABLE pages are freed from MIGRATE_UNMOVABLE
> > type pageblock (and some MIGRATE_MOVABLE pages are left in it)
> > waiting until an allocation takes ownership of the block may
> > take too long.  The type of the pageblock remains unchanged
> > so the pageblock cannot be used as a migration target during
> > compaction.
> > 
> > Fix it by:
> > 
> > * Adding enum compact_mode (COMPACT_ASYNC_[MOVABLE,UNMOVABLE],
> >   and COMPACT_SYNC) and then converting sync field in struct
> >   compact_control to use it.
> > 
> > * Adding nr_pageblocks_skipped field to struct compact_control
> >   and tracking how many destination pageblocks were of
> >   MIGRATE_UNMOVABLE type.  If COMPACT_ASYNC_MOVABLE mode compaction
> >   ran fully in try_to_compact_pages() (COMPACT_COMPLETE) it implies
> >   that there is not a suitable page for allocation.  In this case
> >   then check how if there were enough MIGRATE_UNMOVABLE pageblocks
> >   to try a second pass in COMPACT_ASYNC_UNMOVABLE mode.
> > 
> > * Scanning the MIGRATE_UNMOVABLE pageblocks (during COMPACT_SYNC
> >   and COMPACT_ASYNC_UNMOVABLE compaction modes) and building
> >   a count based on finding PageBuddy pages, page_count(page) == 0
> >   or PageLRU pages.  If all pages within the MIGRATE_UNMOVABLE
> >   pageblock are in one of those three sets change the whole
> >   pageblock type to MIGRATE_MOVABLE.
> > 
> > My particular test case (on a ARM EXYNOS4 device with 512 MiB,
> > which means 131072 standard 4KiB pages in 'Normal' zone) is to:
> > - allocate 95000 pages for kernel's usage
> > - free every second page (47500 pages) of memory just allocated
> > - allocate and use 60000 pages from user space
> > - free remaining 60000 pages of kernel memory
> > (now we have fragmented memory occupied mostly by user space pages)
> > - try to allocate 100 order-9 (2048 KiB) pages for kernel's usage
> > 
> > The results:
> > - with compaction disabled I get 10 successful allocations
> > - with compaction enabled - 11 successful allocations
> > - with this patch I'm able to get 25 successful allocations
> > 
> > NOTE: If we can make kswapd aware of order-0 request during
> > compaction, we can enhance kswapd with changing mode to
> > COMPACT_ASYNC_FULL (COMPACT_ASYNC_MOVABLE + COMPACT_ASYNC_UNMOVABLE).
> > Please see the following thread:
> > 
> > 	http://marc.info/?l=linux-mm&m=133552069417068&w=2
> > 
> >
> > ...
> >
> > --- a/include/linux/compaction.h	2012-06-08 09:01:32.041681656 +0200
> > +++ b/include/linux/compaction.h	2012-06-08 09:01:35.697681651 +0200
> > @@ -1,6 +1,8 @@
> >  #ifndef _LINUX_COMPACTION_H
> >  #define _LINUX_COMPACTION_H
> >  
> > +#include <linux/node.h>
> 
> Why was this addition needed?  (I think I asked this before)

You did. :)

It is needed to fix build failure, please see:
http://www.spinics.net/lists/linux-mm/msg33901.html

> >  /* Return values for compact_zone() and try_to_compact_pages() */
> >  /* compaction didn't start as it was not possible or direct reclaim was more suitable */
> >  #define COMPACT_SKIPPED		0
> >
> > ...
> >
> > +static bool can_rescue_unmovable_pageblock(struct page *page)
> > +{
> > +	struct zone *zone;
> > +	unsigned long pfn, start_pfn, end_pfn;
> > +	struct page *start_page;
> > +
> > +	zone = page_zone(page);
> > +	pfn = page_to_pfn(page);
> > +	start_pfn = pfn & ~(pageblock_nr_pages - 1);
> > +	start_page = pfn_to_page(start_pfn);
> > +
> > +	/*
> > +	 * Race with page allocator/reclaimer can happen so that it can
> > +	 * deceive unmovable block to migratable type on this pageblock.
> > +	 * It could regress on anti-fragmentation but it's rare and not
> > +	 * critical.
> > +	 */
> 
> This is quite ungramattical and needs a rewrite, please.  Suggest the
> use of well-understood terms MIGRATE_UNMOVABLE, MIGRATE_MOVABLE etc
> rather than "unmovable block", etc.
> 
> Please explain "could regress" and also explain why it is "not critical".

Ok.

> > +	return __count_immobile_pages(zone, start_page, 0);
> > +}
> > +
> > +static void rescue_unmovable_pageblock(struct page *page)
> > +{
> > +	set_pageblock_migratetype(page, MIGRATE_MOVABLE);
> > +	move_freepages_block(page_zone(page), page, MIGRATE_MOVABLE);
> > +
> > +	count_vm_event(COMPACT_RESCUED_UNMOVABLE_BLOCKS);
> > +}
> > +
> > +/*
> > + * MIGRATE_TARGET : good for migration target
> > + * RESCUE_UNMOVABLE_TARTET : good only if we can rescue the unmovable pageblock.
> 
> s/TARTET/TARGET/
> 
> > + * UNMOVABLE_TARGET : can't migrate because it's a page in unmovable pageblock.
> > + * SKIP_TARGET : can't migrate by another reasons.
> > + */
> > +enum smt_result {
> > +	MIGRATE_TARGET,
> > +	RESCUE_UNMOVABLE_TARGET,
> > +	UNMOVABLE_TARGET,
> > +	SKIP_TARGET,
> > +};
> >  
> >
> > ...
> >
> > @@ -5476,8 +5476,7 @@ void set_pageblock_flags_group(struct pa
> >   * page allocater never alloc memory from ISOLATE block.
> >   */
> >  
> > -static int
> > -__count_immobile_pages(struct zone *zone, struct page *page, int count)
> > +int __count_immobile_pages(struct zone *zone, struct page *page, int count)
> 
> We may as well fix the return type of this while we're in there.  It
> should be bool.
> 
> Also, the comment over __count_immobile_pages() is utter rubbish.  Can
> we please cook up a new one?  Something human-readable which also
> describes the return value.

Ok.

> >  {
> >  	unsigned long pfn, iter, found;
> >  	int mt;
> > @@ -5500,6 +5499,11 @@ __count_immobile_pages(struct zone *zone
> >  			continue;
> >  
> >  		page = pfn_to_page(check);
> > +
> > +		/* Do not deal with pageblocks that overlap zones */
> > +		if (page_zone(page) != zone)
> > +			return false;
> 
> I don't really understand this bit.  Wasn't it wrong to walk across
> zones in the original code?  Did you do something which will newly
> cause this to walk between zones?  It doesn't seem to be changelogged,
> and the comment commits the common mistake of explaining "what" but not
> "why".

Minchan explained this in his mail (https://lkml.org/lkml/2012/6/10/212):

"I saw similar function in isolate_freepages and remember Mel said. 

"
Node-0 Node-1 Node-0
DMA DMA DMA
0-1023 1024-2047 2048-4096

In that case, a PFN scanner can enter a new node and zone but the migrate
and free scanners have not necessarily met. This configuration is *extremely*
rare but it happens on messed-up LPAR configurations on POWER
"
http://lkml.indiana.edu/hypermail/linux/kernel/1002.2/01140.html"

but I wonder if it is really needed as __count_immobile_pages() is called per
pageblock and the code only walks inside one pageblock at time..

> 
> >  		if (!page_count(page)) {
> >  			if (PageBuddy(page))
> >  				iter += (1 << page_order(page)) - 1;
> >
> > ...
> >
> 
> A few tweaks:

Thanks!

My incremental fixes on top of your patch:

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: mm-compaction-handle-incorrect-migrate_unmovable-type-pageblocks-fix-2

Fix can_rescue_unmovable_pageblock() comment and __count_immobile_pages()
documentation.

Cc: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Cong Wang <amwang@redhat.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 mm/compaction.c |    9 +++++----
 mm/page_alloc.c |   16 +++++++++++-----
 2 files changed, 16 insertions(+), 9 deletions(-)

Index: b/mm/compaction.c
===================================================================
--- a/mm/compaction.c	2012-06-11 11:43:08.619790227 +0200
+++ b/mm/compaction.c	2012-06-11 11:48:32.263790242 +0200
@@ -374,10 +374,11 @@ static bool can_rescue_unmovable_pageblo
 	start_page = pfn_to_page(start_pfn);
 
 	/*
-	 * Race with page allocator/reclaimer can happen so that it can
-	 * deceive unmovable block to migratable type on this pageblock.
-	 * It could regress on anti-fragmentation but it's rare and not
-	 * critical.
+	 * Race with page allocator/reclaimer can happen so it is possible
+	 * that MIGRATE_UNMOVABLE type page will end up in MIGRATE_MOVABLE
+	 * type pageblock.  However such situation is rare and not critical
+	 * (because page allocator fallback mechanism can also allocate
+	 * MIGRATE_UNMOVABLE type pages in MIGRATE_MOVABLE type pageblock).
 	 */
 	return __count_immobile_pages(zone, start_page, 0);
 }
Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c	2012-06-11 11:49:31.603790172 +0200
+++ b/mm/page_alloc.c	2012-06-11 12:14:41.231789996 +0200
@@ -5469,12 +5469,18 @@ void set_pageblock_flags_group(struct pa
 			__clear_bit(bitidx + start_bitidx, bitmap);
 }
 
-/*
- * This is designed as sub function...plz see page_isolation.c also.
- * set/clear page block's type to be ISOLATE.
- * page allocater never alloc memory from ISOLATE block.
+/**
+ * __count_immobile_pages - Check pageblock for MIGRATE_UNMOVABLE type pages.
+ * @zone: Zone pages are in.
+ * @page: The first page in the pageblock.
+ * @count: The count of allowed MIGRATE_UNMOVABLE type pages.
+ *
+ * Count the number of MIGRATE_UNMOVABLE type pages in the pageblock
+ * starting with @page.  Returns true If the @zone is of ZONE_MOVABLE
+ * type or the pageblock is of MIGRATE_MOVABLE or MIGRATE_CMA type.
+ * If the number of MIGRATE_UNMOVABLE type pages inside the pageblock
+ * is higher than given by @count returns false, true otherwise.
  */
-
 bool __count_immobile_pages(struct zone *zone, struct page *page, int count)
 {
 	unsigned long pfn, iter, found;
