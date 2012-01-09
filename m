Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab2AINlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 08:41:23 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:40410 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab2AINlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 08:41:19 -0500
Date: Mon, 9 Jan 2012 14:41:08 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [RESEND, PATCH 6/6] memcg: cleanup memcg_check_events()
Message-ID: <20120109134108.GF3588@cmpxchg.org>
References: <1325883472-5614-1-git-send-email-kirill@shutemov.name>
 <1325883472-5614-6-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325883472-5614-6-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 10:57:52PM +0200, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill@shutemov.name>
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
>  mm/memcontrol.c |   42 ++++++++++++++++++++++++------------------
>  1 files changed, 24 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2eddcb5..0a13afa 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -108,11 +108,12 @@ enum mem_cgroup_events_index {
>   * than using jiffies etc. to handle periodic memcg event.
>   */
>  enum mem_cgroup_events_target {
> -	MEM_CGROUP_TARGET_THRESH,
> -	MEM_CGROUP_TARGET_SOFTLIMIT,
> -	MEM_CGROUP_TARGET_NUMAINFO,
> -	MEM_CGROUP_NTARGETS,
> +	MEM_CGROUP_TARGET_THRESH	= BIT(1),
> +	MEM_CGROUP_TARGET_SOFTLIMIT	= BIT(2),
> +	MEM_CGROUP_TARGET_NUMAINFO	= BIT(3),
>  };
> +#define MEM_CGROUP_NTARGETS 3

That really asks for the next guy forgetting to increase the number
when adding another bit.

> @@ -734,7 +735,7 @@ static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
>  	return total;
>  }
>  
> -static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
> +static int mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
>  				       enum mem_cgroup_events_target target)
>  {
>  	unsigned long val, next;
> @@ -757,9 +758,9 @@ static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
>  			break;
>  		}
>  		__this_cpu_write(memcg->stat->targets[target], next);
> -		return true;
> +		return target;
>  	}
> -	return false;
> +	return 0;

Really weird interface - I'll return what you passed in, or zero...?

> @@ -768,29 +769,34 @@ static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
>   */
>  static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
>  {
> +	int flags;
> +
>  	preempt_disable();
> -	/* threshold event is triggered in finer grain than soft limit */
> -	if (unlikely(mem_cgroup_event_ratelimit(memcg,
> -						MEM_CGROUP_TARGET_THRESH))) {
> -		bool do_softlimit, do_numainfo;
> +	flags = mem_cgroup_event_ratelimit(memcg, MEM_CGROUP_TARGET_THRESH);
>  
> -		do_softlimit = mem_cgroup_event_ratelimit(memcg,
> +	/*
> +	 * Threshold event is triggered in finer grain than soft limit
> +	 * and numainfo
> +	 */
> +	if (unlikely(flags)) {
> +		flags |= mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_SOFTLIMIT);
>  #if MAX_NUMNODES > 1
> -		do_numainfo = mem_cgroup_event_ratelimit(memcg,
> +		flags |= mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_NUMAINFO);
>  #endif
> -		preempt_enable();
> +	}
> +	preempt_enable();
>  
> +	if (unlikely(flags)) {
>  		mem_cgroup_threshold(memcg);
> -		if (unlikely(do_softlimit))
> +		if (unlikely(flags & MEM_CGROUP_TARGET_SOFTLIMIT))
>  			mem_cgroup_update_tree(memcg, page);
>  #if MAX_NUMNODES > 1
> -		if (unlikely(do_numainfo))
> +		if (unlikely(flags & MEM_CGROUP_TARGET_NUMAINFO))
>  			atomic_inc(&memcg->numainfo_events);
>  #endif
> -	} else
> -		preempt_enable();
> +	}
>  }

I'm about to remove the soft limit part of this code, so we'll be able
to condense this back into a single #if block again, anyway.

I would much prefer having the extra #if in the code over this patch
just to silence the warning for now.
