Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965091Ab0GPKr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 06:47:28 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59646 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965031Ab0GPKr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 06:47:27 -0400
Date: Fri, 16 Jul 2010 11:47:10 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Subject: Re: [PATCH 2/7] memcg: mem_cgroup_shrink_node_zone() doesn't need
	sc.nodemask
Message-ID: <20100716104710.GF13117@csn.ul.ie>
References: <20100716191006.7369.A69D9226@jp.fujitsu.com> <20100716191334.736F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100716191334.736F.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 07:14:15PM +0900, KOSAKI Motohiro wrote:
> Currently mem_cgroup_shrink_node_zone() call shrink_zone() directly.
> thus it doesn't need to initialize sc.nodemask. shrink_zone() doesn't
> use it at all.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  include/linux/swap.h |    3 +--
>  mm/memcontrol.c      |    3 +--
>  mm/vmscan.c          |    8 ++------
>  3 files changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index ff4acea..bf4eb62 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -244,8 +244,7 @@ extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
>  extern unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
>  						gfp_t gfp_mask, bool noswap,
>  						unsigned int swappiness,
> -						struct zone *zone,
> -						int nid);
> +						struct zone *zone);
>  extern int __isolate_lru_page(struct page *page, int mode, int file);
>  extern unsigned long shrink_all_memory(unsigned long nr_pages);
>  extern int vm_swappiness;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index aba4310..01f38ff 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1307,8 +1307,7 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
>  		/* we use swappiness of local cgroup */
>  		if (check_soft)
>  			ret = mem_cgroup_shrink_node_zone(victim, gfp_mask,
> -				noswap, get_swappiness(victim), zone,
> -				zone->zone_pgdat->node_id);
> +				noswap, get_swappiness(victim), zone);
>  		else
>  			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
>  						noswap, get_swappiness(victim));
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bd1d035..be860a0 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1929,7 +1929,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>  unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
>  						gfp_t gfp_mask, bool noswap,
>  						unsigned int swappiness,
> -						struct zone *zone, int nid)
> +						struct zone *zone)
>  {
>  	struct scan_control sc = {
>  		.nr_to_reclaim = SWAP_CLUSTER_MAX,
> @@ -1940,13 +1940,9 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
>  		.order = 0,
>  		.mem_cgroup = mem,
>  	};
> -	nodemask_t nm  = nodemask_of_node(nid);
> -
>  	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
>  			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
> -	sc.nodemask = &nm;
> -	sc.nr_reclaimed = 0;
> -	sc.nr_scanned = 0;
> +

Removing the initialisation of nr_reclaimed and nr_scanned is slightly
outside the scope of the patch but harmless.

I see no problem with the patch but it's also not related to tracepoints
so should be part of a separate series. Still, I didn't see any problem
with it.

Acked-by: Mel Gorman <mel@csn.ul.ie>

>  	/*
>  	 * NOTE: Although we can get the priority field, using it
>  	 * here is not a good idea, since it limits the pages we can scan.
> -- 
> 1.6.5.2
> 
> 
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
