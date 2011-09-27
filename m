Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab1I0QHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:07:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab1I0QG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:06:59 -0400
Date: Tue, 27 Sep 2011 18:06:48 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, akpm@linux-foundation.org,
        Johannes Weiner <hannes@cmpxchg.org>, aarcange@redhat.com
Subject: Re: [PATCH v2 -mm] limit direct reclaim for higher order allocations
Message-ID: <20110927160648.GA16878@redhat.com>
References: <20110927105246.164e2fc7@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927105246.164e2fc7@annuminas.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 10:52:46AM -0400, Rik van Riel wrote:
> When suffering from memory fragmentation due to unfreeable pages,
> THP page faults will repeatedly try to compact memory.  Due to
> the unfreeable pages, compaction fails.
> 
> Needless to say, at that point page reclaim also fails to create
> free contiguous 2MB areas.  However, that doesn't stop the current
> code from trying, over and over again, and freeing a minimum of
> 4MB (2UL << sc->order pages) at every single invocation.
> 
> This resulted in my 12GB system having 2-3GB free memory, a
> corresponding amount of used swap and very sluggish response times.
> 
> This can be avoided by having the direct reclaim code not reclaim
> from zones that already have plenty of free memory available for
> compaction.
> 
> If compaction still fails due to unmovable memory, doing additional
> reclaim will only hurt the system, not help.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> 
> ---
> -v2: shrink_zones now uses the same thresholds as used by compaction itself,
>      not only is this conceptually nicer, it also results in kswapd doing
>      some actual work; before all the page freeing work was done by THP
>      allocators, I seem to see fewer application stalls after this change.
> 
>  mm/vmscan.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b7719ec..117eb4d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2083,6 +2083,16 @@ static void shrink_zones(int priority, struct zonelist *zonelist,
>  				continue;
>  			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
>  				continue;	/* Let kswapd poll it */
> +			if (COMPACTION_BUILD) {
> +				/*
> +				 * If we already have plenty of memory free
> +				 * for compaction, don't free any more.
> +				 */
> +				if (sc->order > PAGE_ALLOC_COSTLY_ORDER &&
> +					(compaction_suitable(zone, sc->order) ||
> +					 compaction_deferred(zone)))
> +					continue;
> +			}

I don't think the comment is complete in combination with the check
for order > PAGE_ALLOC_COSTLY_ORDER, as compaction is invoked for all
non-zero orders.

But the traditional behaviour does less harm if the orders are small
and your problem was triggered by THP allocations, so I agree with the
code itself.

Acked-by: Johannes Weiner <jweiner@redhat.com>
