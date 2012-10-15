Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab2JOJyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 05:54:20 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56270 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2JOJyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 05:54:18 -0400
Message-ID: <507BDD45.1070705@suse.cz>
Date: Mon, 15 Oct 2012 11:54:13 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Valdis.Kletnieks@vt.edu, Jiri Slaby <jirislaby@gmail.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kswapd0: excessive CPU usage
References: <507688CC.9000104@suse.cz> <106695.1349963080@turing-police.cc.vt.edu> <5076E700.2030909@suse.cz> <118079.1349978211@turing-police.cc.vt.edu> <50770905.5070904@suse.cz> <119175.1349979570@turing-police.cc.vt.edu> <5077434D.7080008@suse.cz> <50780F26.7070007@suse.cz> <20121012135726.GY29125@suse.de>
In-Reply-To: <20121012135726.GY29125@suse.de>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 03:57 PM, Mel Gorman wrote:
> mm: vmscan: scale number of pages reclaimed by reclaim/compaction only in direct reclaim
> 
> Jiri Slaby reported the following:
> 
> 	(It's an effective revert of "mm: vmscan: scale number of pages
> 	reclaimed by reclaim/compaction based on failures".)
> 	Given kswapd had hours of runtime in ps/top output yesterday in the
> 	morning and after the revert it's now 2 minutes in sum for the last 24h,
> 	I would say, it's gone.
> 
> The intention of the patch in question was to compensate for the loss of
> lumpy reclaim. Part of the reason lumpy reclaim worked is because it
> aggressively reclaimed pages and this patch was meant to be a
> sane compromise.
> 
> When compaction fails, it gets deferred and both compaction and
> reclaim/compaction is deferred avoid excessive reclaim. However, since
> commit c6543459 (mm: remove __GFP_NO_KSWAPD), kswapd is woken up each time
> and continues reclaiming which was not taken into account when the patch
> was developed.
> 
> As it is not taking deferred compaction into account in this path it scans
> aggressively before falling out and making the compaction_deferred check in
> compaction_ready. This patch avoids kswapd scaling pages for reclaim and
> leaves the aggressive reclaim to the process attempting the THP
> allocation.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  mm/vmscan.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 2624edc..2b7edfa 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1763,14 +1763,20 @@ static bool in_reclaim_compaction(struct scan_control *sc)
>  #ifdef CONFIG_COMPACTION
>  /*
>   * If compaction is deferred for sc->order then scale the number of pages
> - * reclaimed based on the number of consecutive allocation failures
> + * reclaimed based on the number of consecutive allocation failures. This
> + * scaling only happens for direct reclaim as it is about to attempt
> + * compaction. If compaction fails, future allocations will be deferred
> + * and reclaim avoided. On the other hand, kswapd does not take compaction
> + * deferral into account so if it scaled, it could scan excessively even
> + * though allocations are temporarily not being attempted.
>   */
>  static unsigned long scale_for_compaction(unsigned long pages_for_compaction,
>  			struct lruvec *lruvec, struct scan_control *sc)
>  {
>  	struct zone *zone = lruvec_zone(lruvec);
>  
> -	if (zone->compact_order_failed <= sc->order)
> +	if (zone->compact_order_failed <= sc->order &&
> +	    !current_is_kswapd())
>  		pages_for_compaction <<= zone->compact_defer_shift;
>  	return pages_for_compaction;
>  }

Yes, applying this instead of the revert fixes the issue as well.

thanks,
-- 
js
suse labs
