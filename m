Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab2LUAtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 19:49:43 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46508 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2LUAti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 19:49:38 -0500
X-AuditID: 9c93016f-b7cf2ae0000069e9-99-50d3b21f0c67
Date: Fri, 21 Dec 2012 09:49:35 +0900
From: Minchan Kim <minchan@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] compaction: fix build error in CMA && !COMPACTION
Message-ID: <20121221004935.GC2686@blaptop>
References: <1355981130-2382-1-git-send-email-minchan@kernel.org>
 <20121220104707.GB10819@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121220104707.GB10819@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 10:47:07AM +0000, Mel Gorman wrote:
> On Thu, Dec 20, 2012 at 02:25:30PM +0900, Minchan Kim wrote:
> > isolate_freepages_block and isolate_migratepages_range is used for CMA
> > as well as compaction so it breaks build for CONFIG_CMA &&
> > !CONFIG_COMPACTION.
> > 
> > This patch fixes it.
> > 
> > Cc: Mel Gorman <mgorman@suse.de>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  mm/compaction.c |   26 ++++++++++++++++++++------
> >  1 file changed, 20 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/compaction.c b/mm/compaction.c
> > index 5ad7f4f..70f4443 100644
> > --- a/mm/compaction.c
> > +++ b/mm/compaction.c
> > @@ -17,6 +17,21 @@
> >  #include <linux/balloon_compaction.h>
> >  #include "internal.h"
> >  
> > +#ifdef CONFIG_COMPACTION
> > +static inline void count_compact_event(enum vm_event_item item)
> > +{
> > +	count_vm_event(item);
> > +}
> > +
> > +static inline void count_compact_events(enum vm_event_item item, long delta)
> > +{
> > +	count_vm_events(item, delta);
> > +}
> > +#else
> > +#define count_compact_event(item)
> > +#define count_compact_events(item, delta)
> > +#endif
> > +
> 
> That should be
> 
> do {} while (0)
> 
> otherwise a block like this
> 
> if (foo)
> 	count_compact_event(COMPACTFREE_SCANNED)
> bar;
> 
> will get parsed as
> 
> if (foo)
> 	bar;
> 
> which is wrong.

Indeed.

> 
> Now that I look at the do {} while (0) thing it is also strictly speaking
> wrong for count_vm_numa_events() too because it would do the wrong thing for

If I noticed it, I should named it as count_vm_compact_events for the consistency.

> 
> count_compact_events(COMPACTFREE_SCANNED, foo++);
> 
> There happens to be no examples where we depend on such side-effects but

Agreed.

> I've taken a TODO item to fix it up in the New Year.

Andrew picked up the patch with your fix. Please correct it for New Year's
present. :)

Thanks, Mel.

> 
> -- 
> Mel Gorman
> SUSE Labs
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
