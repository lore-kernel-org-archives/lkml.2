Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab2I1FkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 01:40:15 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63450 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2I1FkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 01:40:12 -0400
X-AuditID: 9c93016f-b7b1eae000000815-c7-5065383a8180
Date: Fri, 28 Sep 2012 14:43:30 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: CMA broken in next-20120926
Message-ID: <20120928054330.GA27594@bbox>
References: <20120927112911.GA25959@avionic-0098.mockup.avionic-design.de>
 <20120927151159.4427fc8f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927151159.4427fc8f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 03:11:59PM -0700, Andrew Morton wrote:
> On Thu, 27 Sep 2012 13:29:11 +0200
> Thierry Reding <thierry.reding@avionic-design.de> wrote:
> 
> > Hi Marek,
> > 
> > any idea why CMA might be broken in next-20120926. I see that there
> > haven't been any major changes to CMA itself, but there's been quite a
> > bit of restructuring of various memory allocation bits lately. I wasn't
> > able to track the problem down, though.
> > 
> > What I see is this during boot (with CMA_DEBUG enabled):
> > 
> > [    0.266904] cma: dma_alloc_from_contiguous(cma db474f80, count 64, align 6)
> > [    0.284469] cma: dma_alloc_from_contiguous(): memory range at c09d7000 is busy, retrying
> > [    0.293648] cma: dma_alloc_from_contiguous(): memory range at c09d7800 is busy, retrying
> > ...
> > [    2.648619] DMA: failed to allocate 256 KiB pool for atomic coherent allocation
> > ...
> > [    4.196193] WARNING: at /home/thierry.reding/src/kernel/linux-ipmp.git/arch/arm/mm/dma-mapping.c:485 __alloc_from_pool+0xdc/0x110()
> > [    4.207988] coherent pool not initialised!
> > 
> > So the pool isn't getting initialized properly because CMA can't get at
> > the memory. Do you have any hints as to what might be going on? If it's
> > any help, I started seeing this with next-20120926 and it is in today's
> > next as well.
> > 
> 
> Bart and Minchan have made recent changes to CMA.  Let us cc them.

Hi all,

I have no time now so I look over the problem during short time
so I mighte be wrong. Even I should leave the office soon and
Korea will have long vacation from now on so I will be off by next week.
So it's hard to reach on me.

I hope this patch fixes the bug. If this patch fixes the problem
but has some problem about description or someone has better idea,
feel free to modify and resend to akpm, Please.

Thierry, Could you test below patch?

>From 24a547855fa2bd4212a779cc73997837148310b3 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Fri, 28 Sep 2012 14:28:32 +0900
Subject: [PATCH] revert mm: compaction: iron out isolate_freepages_block()
 and isolate_freepages_range()

[1] made bug on CMA.
The nr_scanned should be never equal to total_isolated for successful CMA.
This patch reverts part of the patch.

[1] mm: compaction: iron out isolate_freepages_block() and isolate_freepages_range()

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/compaction.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 5037399..7721197 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -269,13 +269,14 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 		int isolated, i;
 		struct page *page = cursor;
 
-		nr_scanned++;
 		if (!pfn_valid_within(blockpfn))
-			continue;
+			goto strict_check;
+		nr_scanned++;
+
 		if (!valid_page)
 			valid_page = page;
 		if (!PageBuddy(page))
-			continue;
+			goto strict_check;
 
 		/*
 		 * The zone lock must be held to isolate freepages.
@@ -296,12 +297,12 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 
 		/* Recheck this is a buddy page under lock */
 		if (!PageBuddy(page))
-			continue;
+			goto strict_check;
 
 		/* Found a free page, break it into order-0 pages */
 		isolated = split_free_page(page);
 		if (!isolated && strict)
-			break;
+			goto strict_check;
 		total_isolated += isolated;
 		for (i = 0; i < isolated; i++) {
 			list_add(&page->lru, freelist);
@@ -313,18 +314,20 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 			blockpfn += isolated - 1;
 			cursor += isolated - 1;
 		}
+
+		continue;
+
+strict_check:
+		/* Abort isolation if the caller requested strict isolation */
+		if (strict) {
+			total_isolated = 0;
+			goto out;
+		}
 	}
 
 	trace_mm_compaction_isolate_freepages(nr_scanned, total_isolated);
 
-	/*
-	 * If strict isolation is requested by CMA then check that all the
-	 * pages scanned were isolated. If there were any failures, 0 is
-	 * returned and CMA will fail.
-	 */
-	if (strict && nr_scanned != total_isolated)
-		total_isolated = 0;
-
+out:
 	if (locked)
 		spin_unlock_irqrestore(&cc->zone->lock, flags);
 
-- 
1.7.9.5



> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
