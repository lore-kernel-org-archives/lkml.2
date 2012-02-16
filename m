Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab2BPALH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 19:11:07 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60291 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab2BPALC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 19:11:02 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Feb 2012 09:09:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memcg: fix page_referencies cgroup filter on global
 reclaim
Message-Id: <20120216090939.ce2d1f28.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120215162830.13902.60256.stgit@zurg>
References: <20120215162830.13902.60256.stgit@zurg>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012 20:28:30 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Global memory reclaimer should't skip referencies for any pages,
> even if they are shared between different cgroups.
> 
> This patch adds scan_control->current_mem_cgroup, which points to currently
> shrinking sub-cgroup in hierarchy, at global reclaim it always NULL.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

seems ok to me. How about you, Johannes ?

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
>  mm/vmscan.c |   18 ++++++++++++++----
>  1 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 531abcc..b069fac 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -109,6 +109,12 @@ struct scan_control {
>  	struct mem_cgroup *target_mem_cgroup;
>  
>  	/*
> +	 * Currently reclaiming memory cgroup in hierarchy,
> +	 * NULL for global reclaim.
> +	 */
> +	struct mem_cgroup *current_mem_cgroup;
> +
> +	/*
>  	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
>  	 * are scanned.
>  	 */
> @@ -703,13 +709,13 @@ enum page_references {
>  };
>  
>  static enum page_references page_check_references(struct page *page,
> -						  struct mem_cgroup_zone *mz,
>  						  struct scan_control *sc)
>  {
>  	int referenced_ptes, referenced_page;
>  	unsigned long vm_flags;
>  
> -	referenced_ptes = page_referenced(page, 1, mz->mem_cgroup, &vm_flags);
> +	referenced_ptes = page_referenced(page, 1,
> +			sc->current_mem_cgroup, &vm_flags);
>  	referenced_page = TestClearPageReferenced(page);
>  
>  	/* Lumpy reclaim - ignore references */
> @@ -830,7 +836,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  			}
>  		}
>  
> -		references = page_check_references(page, mz, sc);
> +		references = page_check_references(page, sc);
>  		switch (references) {
>  		case PAGEREF_ACTIVATE:
>  			goto activate_locked;
> @@ -1744,7 +1750,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
>  			continue;
>  		}
>  
> -		if (page_referenced(page, 0, mz->mem_cgroup, &vm_flags)) {
> +		if (page_referenced(page, 0, sc->current_mem_cgroup, &vm_flags)) {
>  			nr_rotated += hpage_nr_pages(page);
>  			/*
>  			 * Identify referenced, file-backed active pages and
> @@ -2163,6 +2169,9 @@ static void shrink_zone(int priority, struct zone *zone,
>  			.zone = zone,
>  		};
>  
> +		if (!global_reclaim(sc))
> +			sc->current_mem_cgroup = memcg;
> +
>  		shrink_mem_cgroup_zone(priority, &mz, sc);
>  		/*
>  		 * Limit reclaim has historically picked one memcg and
> @@ -2478,6 +2487,7 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *memcg,
>  		.may_swap = !noswap,
>  		.order = 0,
>  		.target_mem_cgroup = memcg,
> +		.current_mem_cgroup = memcg,
>  	};
>  	struct mem_cgroup_zone mz = {
>  		.mem_cgroup = memcg,
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

