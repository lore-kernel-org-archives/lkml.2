Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346Ab2ILX4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:56:55 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63342 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab2ILX4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:56:51 -0400
X-AuditID: 9c93016f-b7bffae000003557-9c-505121401570
Date: Thu, 13 Sep 2012 08:58:55 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Kyungmin Park <kmpark@infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: cma: Discard clean pages during contiguous
 allocation instead of migration
Message-ID: <20120912235855.GB2766@bbox>
References: <1347324112-14134-1-git-send-email-minchan@kernel.org>
 <20120912130732.99ecf764.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912130732.99ecf764.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 01:07:32PM -0700, Andrew Morton wrote:
> On Tue, 11 Sep 2012 09:41:52 +0900
> Minchan Kim <minchan@kernel.org> wrote:
> 
> > This patch drops clean cache pages instead of migration during
> > alloc_contig_range() to minimise allocation latency by reducing the amount
> > of migration is necessary. It's useful for CMA because latency of migration
> > is more important than evicting the background processes working set.
> > In addition, as pages are reclaimed then fewer free pages for migration
> > targets are required so it avoids memory reclaiming to get free pages,
> > which is a contributory factor to increased latency.
> > 
> > * from v1
> >   * drop migrate_mode_t
> >   * add reclaim_clean_pages_from_list instad of MIGRATE_DISCARD support - Mel
> > 
> > I measured elapsed time of __alloc_contig_migrate_range which migrates
> > 10M in 40M movable zone in QEMU machine.
> > 
> > Before - 146ms, After - 7ms
> > 
> > ...
> >
> > @@ -758,7 +760,9 @@ static unsigned long shrink_page_list(struct list_head *page_list,
> >  			wait_on_page_writeback(page);
> >  		}
> >  
> > -		references = page_check_references(page, sc);
> > +		if (!force_reclaim)
> > +			references = page_check_references(page, sc);
> 
> grumble.  Could we please document `enum page_references' and
> page_check_references()?
> 
> And the `force_reclaim' arg could do with some documentation.  It only
> forces reclaim under certain circumstances.  They should be described,
> and a reson should be provided.

I will give it a shot by another patch.

> 
> Why didn't this patch use PAGEREF_RECLAIM_CLEAN?  It is possible for
> someone to dirty one of these pages after we tested its cleanness and
> we'll then go off and write it out, but we won't be reclaiming it?

Absolutely.
Thanks Andrew!

Here it goes.

====== 8< ======

>From 90022feb9ecf8e9a4efba7cbf49d7cead777020f Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Thu, 13 Sep 2012 08:45:58 +0900
Subject: [PATCH] mm: cma: reclaim only clean pages

It is possible for pages to be dirty after the check
in reclaim_clean_pages_from_list so that it ends up
paging out the pages, which is never what we want for speed up.

This patch fixes it.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f8f56f8..1ee4b69 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -694,7 +694,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		struct address_space *mapping;
 		struct page *page;
 		int may_enter_fs;
-		enum page_references references = PAGEREF_RECLAIM;
+		enum page_references references = PAGEREF_RECLAIM_CLEAN;
 
 		cond_resched();
 
-- 
1.7.9.5

-- 
Kind regards,
Minchan Kim
