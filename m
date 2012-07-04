Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab2GDIbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:31:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45247 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab2GDIba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:31:30 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FF3FED6.9010700@jp.fujitsu.com>
Date: Wed, 04 Jul 2012 17:29:10 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sha Zhengju <handai.szj@gmail.com>
CC: linux-mm@kvack.org, cgroups@vger.kernel.org, gthelen@google.com,
        yinghan@google.com, akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 7/7] memcg: print more detailed info while memcg oom happening
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com> <1340881609-5935-1-git-send-email-handai.szj@taobao.com>
In-Reply-To: <1340881609-5935-1-git-send-email-handai.szj@taobao.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/28 20:06), Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj@taobao.com>
> 
> While memcg oom happening, the dump info is limited, so add this
> to provide memcg page stat.
> 
> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>

Could you split this into a different series ?
seems good to me in general but...one concern is hierarchy handling.

IIUC, the passed 'memcg' is the root of hierarchy which gets OOM.
So, the LRU info, which is local to the root memcg, may not contain any good
information. I think you should visit all memcg under the tree.

Thanks,
-Kame

> ---
>   mm/memcontrol.c |   42 ++++++++++++++++++++++++++++++++++--------
>   1 files changed, 34 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8493119..3ed41e9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -101,6 +101,14 @@ static const char * const mem_cgroup_events_names[] = {
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
>   /*
>    * Per memcg event counter is incremented at every pagein/pageout. With THP,
>    * it will be incremated by the number of pages. This counter is used for
> @@ -1358,6 +1366,30 @@ static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
>   	spin_unlock_irqrestore(&memcg->move_lock, *flags);
>   }
>   
> +#define K(x) ((x) << (PAGE_SHIFT-10))
> +static void mem_cgroup_print_oom_stat(struct mem_cgroup *memcg)
> +{
> +	int i;
> +
> +	printk(KERN_INFO "Memory cgroup stat:\n");
> +	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
> +		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
> +			continue;
> +		printk(KERN_CONT "%s:%ldKB ", mem_cgroup_stat_names[i],
> +			   K(mem_cgroup_read_stat(memcg, i)));
> +	}
> +
> +	for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++)
> +		printk(KERN_CONT "%s:%lu ", mem_cgroup_events_names[i],
> +			   mem_cgroup_read_events(memcg, i));
> +
> +	for (i = 0; i < NR_LRU_LISTS; i++)
> +		printk(KERN_CONT "%s:%luKB ", mem_cgroup_lru_names[i],
> +			   K(mem_cgroup_nr_lru_pages(memcg, BIT(i))));
> +	printk(KERN_CONT "\n");
> +
> +}
> +
>   /**
>    * mem_cgroup_print_oom_info: Called from OOM with tasklist_lock held in read mode.
>    * @memcg: The memory cgroup that went over limit
> @@ -1422,6 +1454,8 @@ done:
>   		res_counter_read_u64(&memcg->memsw, RES_USAGE) >> 10,
>   		res_counter_read_u64(&memcg->memsw, RES_LIMIT) >> 10,
>   		res_counter_read_u64(&memcg->memsw, RES_FAILCNT));
> +
> +	mem_cgroup_print_oom_stat(memcg);
>   }
>   
>   /*
> @@ -4043,14 +4077,6 @@ static int mem_control_numa_stat_show(struct cgroup *cont, struct cftype *cft,
>   }
>   #endif /* CONFIG_NUMA */
>   
> -static const char * const mem_cgroup_lru_names[] = {
> -	"inactive_anon",
> -	"active_anon",
> -	"inactive_file",
> -	"active_file",
> -	"unevictable",
> -};
> -
>   static inline void mem_cgroup_lru_names_not_uptodate(void)
>   {
>   	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
> 



