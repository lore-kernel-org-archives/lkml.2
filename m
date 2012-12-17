Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab2LQUFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 15:05:51 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:56857 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab2LQUFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 15:05:50 -0500
Date: Mon, 17 Dec 2012 21:05:47 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Satoru Moriya <satoru.moriya@hds.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/7] mm: vmscan: clarify how swappiness, highest
 priority, memcg interact
Message-ID: <20121217200547.GC16375@dhcp22.suse.cz>
References: <1355767957-4913-1-git-send-email-hannes@cmpxchg.org>
 <1355767957-4913-4-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355767957-4913-4-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 17-12-12 13:12:33, Johannes Weiner wrote:
> A swappiness of 0 has a slightly different meaning for global reclaim
> (may swap if file cache really low) and memory cgroup reclaim (never
> swap, ever).
> 
> In addition, global reclaim at highest priority will scan all LRU
> lists equal to their size and ignore other balancing heuristics.
> UNLESS swappiness forbids swapping, then the lists are balanced based
> on recent reclaim effectiveness.  UNLESS file cache is running low,
> then anonymous pages are force-scanned.
> 
> This (total mess of a) behaviour is implicit and not obvious from the
> way the code is organized.  At least make it apparent in the code flow
> and document the conditions.  It will be it easier to come up with
> sane semantics later.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

Thanks!

> ---
>  mm/vmscan.c | 39 ++++++++++++++++++++++++++++++---------
>  1 file changed, 30 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 648a4db..c37deaf 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1644,7 +1644,6 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>  	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
>  	u64 fraction[2], denominator;
>  	enum lru_list lru;
> -	int noswap = 0;
>  	bool force_scan = false;
>  	struct zone *zone = lruvec_zone(lruvec);
>  
> @@ -1665,13 +1664,38 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>  
>  	/* If we have no swap space, do not bother scanning anon pages. */
>  	if (!sc->may_swap || (nr_swap_pages <= 0)) {
> -		noswap = 1;
>  		fraction[0] = 0;
>  		fraction[1] = 1;
>  		denominator = 1;
>  		goto out;
>  	}
>  
> +	/*
> +	 * Global reclaim will swap to prevent OOM even with no
> +	 * swappiness, but memcg users want to use this knob to
> +	 * disable swapping for individual groups completely when
> +	 * using the memory controller's swap limit feature would be
> +	 * too expensive.
> +	 */
> +	if (!global_reclaim(sc) && !vmscan_swappiness(sc)) {
> +		fraction[0] = 0;
> +		fraction[1] = 1;
> +		denominator = 1;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Do not apply any pressure balancing cleverness when the
> +	 * system is close to OOM, scan both anon and file equally
> +	 * (unless the swappiness setting disagrees with swapping).
> +	 */
> +	if (!sc->priority && vmscan_swappiness(sc)) {
> +		fraction[0] = 1;
> +		fraction[1] = 1;
> +		denominator = 1;
> +		goto out;
> +	}
> +
>  	anon  = get_lru_size(lruvec, LRU_ACTIVE_ANON) +
>  		get_lru_size(lruvec, LRU_INACTIVE_ANON);
>  	file  = get_lru_size(lruvec, LRU_ACTIVE_FILE) +
> @@ -1753,13 +1777,10 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>  		unsigned long scan;
>  
>  		size = get_lru_size(lruvec, lru);
> -		if (sc->priority || noswap || !vmscan_swappiness(sc)) {
> -			scan = size >> sc->priority;
> -			if (!scan && force_scan)
> -				scan = min(size, SWAP_CLUSTER_MAX);
> -			scan = div64_u64(scan * fraction[file], denominator);
> -		} else
> -			scan = size;
> +		scan = size >> sc->priority;
> +		if (!scan && force_scan)
> +			scan = min(size, SWAP_CLUSTER_MAX);
> +		scan = div64_u64(scan * fraction[file], denominator);
>  		nr[lru] = scan;
>  	}
>  }
> -- 
> 1.7.11.7
> 

-- 
Michal Hocko
SUSE Labs
