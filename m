Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab1CJEBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 23:01:21 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:44216 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab1CJEBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 23:01:19 -0500
Date: Thu, 10 Mar 2011 09:31:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg: fix event counter breakage with THP.
Message-ID: <20110310040102.GR2868@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110304164450.4cf80ef1.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110304164450.4cf80ef1.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2011-03-04 16:44:50]:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> memcg: Fix event counter, event leak with THP
> 
> With THP, event counter is updated by the size of large page because
> event counter is for catching the change in usage.
> This is now used for threshold notifier and soft limit.
> 
> Current event counter cathces the event by mask, as
> 
>    !(counter & mask)
> 
> Before THP, counter is always updated by 1, this never misses target.
> But now, this can miss.
> 
> This patch makes the trigger for event as
> 
>   counter > target.
> 
> target is updated when the event happens.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/memcontrol.c |   59 ++++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 45 insertions(+), 14 deletions(-)
> 
> Index: mmotm-0303/mm/memcontrol.c
> ===================================================================
> --- mmotm-0303.orig/mm/memcontrol.c
> +++ mmotm-0303/mm/memcontrol.c
> @@ -73,15 +73,6 @@ static int really_do_swap_account __init
>  #define do_swap_account		(0)
>  #endif
> 
> -/*
> - * Per memcg event counter is incremented at every pagein/pageout. This counter
> - * is used for trigger some periodic events. This is straightforward and better
> - * than using jiffies etc. to handle periodic memcg event.
> - *
> - * These values will be used as !((event) & ((1 <<(thresh)) - 1))
> - */
> -#define THRESHOLDS_EVENTS_THRESH (7) /* once in 128 */
> -#define SOFTLIMIT_EVENTS_THRESH (10) /* once in 1024 */
> 
>  /*
>   * Statistics for memory cgroup.
> @@ -105,10 +96,24 @@ enum mem_cgroup_events_index {
>  	MEM_CGROUP_EVENTS_COUNT,	/* # of pages paged in/out */
>  	MEM_CGROUP_EVENTS_NSTATS,
>  };
> +/*
> + * Per memcg event counter is incremented at every pagein/pageout. With THP,
> + * it will be incremated by the number of pages. This counter is used for
> + * for trigger some periodic events. This is straightforward and better
> + * than using jiffies etc. to handle periodic memcg event.
> + */
> +enum mem_cgroup_events_target {
> +        MEM_CGROUP_TARGET_THRESH,
> +        MEM_CGROUP_TARGET_SOFTLIMIT,
> +        MEM_CGROUP_NTARGETS,
> +};
> +#define THRESHOLDS_EVENTS_TARGET (128)
> +#define SOFTLIMIT_EVENTS_TARGET (1024)
> 
>  struct mem_cgroup_stat_cpu {
>  	long count[MEM_CGROUP_STAT_NSTATS];
>  	unsigned long events[MEM_CGROUP_EVENTS_NSTATS];
> +        unsigned long targets[MEM_CGROUP_NTARGETS];

I see spaces as opposed to tabs.

>  };
> 
>  /*
> @@ -634,13 +639,34 @@ static unsigned long mem_cgroup_get_loca
>  	return total;
>  }
> 
> -static bool __memcg_event_check(struct mem_cgroup *mem, int event_mask_shift)
> +static bool __memcg_event_check(struct mem_cgroup *mem, int target)
>  {
> -	unsigned long val;
> +	unsigned long val, next;
> 
>  	val = this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
> +	next = this_cpu_read(mem->stat->targets[target]);
> +        /* from time_after() in jiffies.h */
> +	return ((long)next - (long)val < 0);
> +}
> 
> -	return !(val & ((1 << event_mask_shift) - 1));
> +static void __mem_cgroup_target_update(struct mem_cgroup *mem, int target)
> +{
> +        unsigned long val, next;
> +
> +	val = this_cpu_read(mem->stat->events[MEM_CGROUP_EVENTS_COUNT]);
> +
> +        switch (target) {

The formatting seems to be off, could you please check the coding
style

> +        case MEM_CGROUP_TARGET_THRESH:
> +		next = val + THRESHOLDS_EVENTS_TARGET;
> +            	break;
> +        case MEM_CGROUP_TARGET_SOFTLIMIT:
> +		next = val + SOFTLIMIT_EVENTS_TARGET;
> +            	break;
> +	default:
> +		return;
> +        }
> +
> +        this_cpu_write(mem->stat->targets[target], next);
>  }
> 
>  /*
> @@ -650,10 +676,15 @@ static bool __memcg_event_check(struct m
>  static void memcg_check_events(struct mem_cgroup *mem, struct page *page)
>  {
>  	/* threshold event is triggered in finer grain than soft limit */
> -	if (unlikely(__memcg_event_check(mem, THRESHOLDS_EVENTS_THRESH))) {
> +	if (unlikely(__memcg_event_check(mem, MEM_CGROUP_TARGET_THRESH))) {
>  		mem_cgroup_threshold(mem);
> -		if (unlikely(__memcg_event_check(mem, SOFTLIMIT_EVENTS_THRESH)))
> +                __mem_cgroup_target_update(mem, MEM_CGROUP_TARGET_THRESH);
> +		if (unlikely(__memcg_event_check(mem,
> +			MEM_CGROUP_TARGET_SOFTLIMIT))){
>  			mem_cgroup_update_tree(mem, page);
> +			__mem_cgroup_target_update(mem,
> +				MEM_CGROUP_TARGET_SOFTLIMIT);
> +		}
>  	}
>  }
> 
> 

-- 
	Three Cheers,
	Balbir
