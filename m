Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab2KHJIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 04:08:04 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50777 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab2KHJHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 04:07:55 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <509B7658.1020807@jp.fujitsu.com>
Date: Thu, 08 Nov 2012 18:07:36 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sha Zhengju <handai.szj@gmail.com>
CC: linux-mm@kvack.org, cgroups@vger.kernel.org, mhocko@suse.cz,
        akpm@linux-foundation.org, rientjes@google.com,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 1/2] memcg, oom: provide more precise dump info while
 memcg oom happening
References: <1352277602-21687-1-git-send-email-handai.szj@taobao.com> <1352277696-21724-1-git-send-email-handai.szj@taobao.com>
In-Reply-To: <1352277696-21724-1-git-send-email-handai.szj@taobao.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/07 17:41), Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj@taobao.com>
> 
> Current, when a memcg oom is happening the oom dump messages is still global
> state and provides few useful info for users. This patch prints more pointed
> memcg page statistics for memcg-oom.
> 
> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>   mm/memcontrol.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++-------
>   mm/oom_kill.c   |    6 +++-
>   2 files changed, 66 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0eab7d5..2df5e72 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -118,6 +118,14 @@ static const char * const mem_cgroup_events_names[] = {
>   	"pgmajfault",
>   };
>   
> +static const char * const mem_cgroup_lru_names[] = {
> +	"inactive_anon",
> +	"active_anon",
> +	"inactive_file",
> +	"active_file",
> +	"unevictable",
> +};
> +

Is this for the same strings with show_free_areas() ?


>   /*
>    * Per memcg event counter is incremented at every pagein/pageout. With THP,
>    * it will be incremated by the number of pages. This counter is used for
> @@ -1501,8 +1509,59 @@ static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
>   	spin_unlock_irqrestore(&memcg->move_lock, *flags);
>   }
>   
> +#define K(x) ((x) << (PAGE_SHIFT-10))
> +static void mem_cgroup_print_oom_stat(struct mem_cgroup *memcg)
> +{
> +	struct mem_cgroup *mi;
> +	unsigned int i;
> +
> +	if (!memcg->use_hierarchy && memcg != root_mem_cgroup) {

Why do you need to have this condition check ?

> +		for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
> +			if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
> +				continue;
> +			printk(KERN_CONT "%s:%ldKB ", mem_cgroup_stat_names[i],
> +				K(mem_cgroup_read_stat(memcg, i)));

Hm, how about using the same style with show_free_areas() ?

> +		}
> +
> +		for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++)
> +			printk(KERN_CONT "%s:%lu ", mem_cgroup_events_names[i],
> +				mem_cgroup_read_events(memcg, i));
> +

I don't think EVENTS info is useful for oom.

> +		for (i = 0; i < NR_LRU_LISTS; i++)
> +			printk(KERN_CONT "%s:%luKB ", mem_cgroup_lru_names[i],
> +				K(mem_cgroup_nr_lru_pages(memcg, BIT(i))));

How far does your new information has different format than usual oom ?
Could you show a sample and difference in changelog ?

Of course, I prefer both of them has similar format.





> +	} else {
> +
> +		for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
> +			long long val = 0;
> +
> +			if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
> +				continue;
> +			for_each_mem_cgroup_tree(mi, memcg)
> +				val += mem_cgroup_read_stat(mi, i);
> +			printk(KERN_CONT "%s:%lldKB ", mem_cgroup_stat_names[i], K(val));
> +		}
> +
> +		for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++) {
> +			unsigned long long val = 0;
> +
> +			for_each_mem_cgroup_tree(mi, memcg)
> +				val += mem_cgroup_read_events(mi, i);
> +			printk(KERN_CONT "%s:%llu ",
> +				mem_cgroup_events_names[i], val);
> +		}
> +
> +		for (i = 0; i < NR_LRU_LISTS; i++) {
> +			unsigned long long val = 0;
> +
> +			for_each_mem_cgroup_tree(mi, memcg)
> +				val += mem_cgroup_nr_lru_pages(mi, BIT(i));
> +			printk(KERN_CONT "%s:%lluKB ", mem_cgroup_lru_names[i], K(val));
> +		}
> +	}
> +	printk(KERN_CONT "\n");
> +}




>   /**
> - * mem_cgroup_print_oom_info: Called from OOM with tasklist_lock held in read mode.
>    * @memcg: The memory cgroup that went over limit
>    * @p: Task that is going to be killed
>    *
> @@ -1569,6 +1628,8 @@ done:
>   		res_counter_read_u64(&memcg->kmem, RES_USAGE) >> 10,
>   		res_counter_read_u64(&memcg->kmem, RES_LIMIT) >> 10,
>   		res_counter_read_u64(&memcg->kmem, RES_FAILCNT));
> +
> +	mem_cgroup_print_oom_stat(memcg);
>   }

please put directly in print_oom_info()



Thanks,
-Kame

