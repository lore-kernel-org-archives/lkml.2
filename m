Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1I1IXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:23:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46362 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1I1IX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:23:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Sep 2011 17:22:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Michael Wolf <mjwolf@us.ibm.com>
Subject: Re: [PATCH 7/9] kstaled: add histogram sampling functionality
Message-Id: <20110928172235.f86746a6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1317170947-17074-8-git-send-email-walken@google.com>
References: <1317170947-17074-1-git-send-email-walken@google.com>
	<1317170947-17074-8-git-send-email-walken@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011 17:49:05 -0700
Michel Lespinasse <walken@google.com> wrote:

> Add statistics for pages that have been idle for 1,2,5,15,30,60,120 or
> 240 scan intervals into /dev/cgroup/*/memory.idle_page_stats
> 
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> ---
>  include/linux/mmzone.h |    2 +
>  mm/memcontrol.c        |  108 ++++++++++++++++++++++++++++++++++++++----------
>  mm/memory_hotplug.c    |    6 +++
>  3 files changed, 94 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 272fbed..d8eca1b 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -633,6 +633,8 @@ typedef struct pglist_data {
>  					     range, including holes */
>  #ifdef CONFIG_KSTALED
>  	unsigned long node_idle_scan_pfn;
> +	u8 *node_idle_page_age;           /* number of scan intervals since
> +					     each page was referenced */
>  #endif
>  	int node_id;
>  	wait_queue_head_t kswapd_wait;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b468867..cfe812b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -207,6 +207,11 @@ struct mem_cgroup_eventfd_list {
>  static void mem_cgroup_threshold(struct mem_cgroup *mem);
>  static void mem_cgroup_oom_notify(struct mem_cgroup *mem);
>  
> +#ifdef CONFIG_KSTALED
> +static const int kstaled_buckets[] = {1, 2, 5, 15, 30, 60, 120, 240};
> +#define NUM_KSTALED_BUCKETS ARRAY_SIZE(kstaled_buckets)
> +#endif
> +
>  /*
>   * The memory controller data structure. The memory controller controls both
>   * page cache and RSS per cgroup. We would eventually like to provide
> @@ -292,7 +297,8 @@ struct mem_cgroup {
>  		unsigned long idle_clean;
>  		unsigned long idle_dirty_file;
>  		unsigned long idle_dirty_swap;
> -	} idle_page_stats, idle_scan_stats;
> +	} idle_page_stats[NUM_KSTALED_BUCKETS],
> +	  idle_scan_stats[NUM_KSTALED_BUCKETS];
>  	unsigned long idle_page_scans;
>  #endif
>  };
> @@ -4686,18 +4692,29 @@ static int mem_cgroup_idle_page_stats_read(struct cgroup *cgrp,
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
>  	unsigned int seqcount;
> -	struct idle_page_stats stats;
> +	struct idle_page_stats stats[NUM_KSTALED_BUCKETS];
>  	unsigned long scans;
> +	int bucket;
>  
>  	do {
>  		seqcount = read_seqcount_begin(&memcg->idle_page_stats_lock);
> -		stats = memcg->idle_page_stats;
> +		memcpy(stats, memcg->idle_page_stats, sizeof(stats));
>  		scans = memcg->idle_page_scans;
>  	} while (read_seqcount_retry(&memcg->idle_page_stats_lock, seqcount));
>  
> -	cb->fill(cb, "idle_clean", stats.idle_clean * PAGE_SIZE);
> -	cb->fill(cb, "idle_dirty_file", stats.idle_dirty_file * PAGE_SIZE);
> -	cb->fill(cb, "idle_dirty_swap", stats.idle_dirty_swap * PAGE_SIZE);
> +	for (bucket = 0; bucket < NUM_KSTALED_BUCKETS; bucket++) {
> +		char basename[32], name[32];
> +		if (!bucket)
> +			sprintf(basename, "idle");
> +		else
> +			sprintf(basename, "idle_%d", kstaled_buckets[bucket]);
> +		sprintf(name, "%s_clean", basename);
> +		cb->fill(cb, name, stats[bucket].idle_clean * PAGE_SIZE);
> +		sprintf(name, "%s_dirty_file", basename);
> +		cb->fill(cb, name, stats[bucket].idle_dirty_file * PAGE_SIZE);
> +		sprintf(name, "%s_dirty_swap", basename);
> +		cb->fill(cb, name, stats[bucket].idle_dirty_swap * PAGE_SIZE);
> +	}
>  	cb->fill(cb, "scans", scans);
>  
>  	return 0;
> @@ -5619,12 +5636,25 @@ __setup("swapaccount=", enable_swap_account);
>  static unsigned int kstaled_scan_seconds;
>  static DECLARE_WAIT_QUEUE_HEAD(kstaled_wait);
>  
> -static unsigned kstaled_scan_page(struct page *page)
> +static inline struct idle_page_stats *
> +kstaled_idle_stats(struct mem_cgroup *memcg, int age)
> +{
> +	int bucket = 0;
> +
> +	while (age >= kstaled_buckets[bucket + 1])
> +		if (++bucket == NUM_KSTALED_BUCKETS - 1)
> +			break;
> +	return memcg->idle_scan_stats + bucket;
> +}
> +
> +static unsigned kstaled_scan_page(struct page *page, u8 *idle_page_age)
>  {
>  	bool is_locked = false;
>  	bool is_file;
>  	struct page_referenced_info info;
>  	struct page_cgroup *pc;
> +	struct mem_cgroup *memcg;
> +	int age;
>  	struct idle_page_stats *stats;
>  	unsigned nr_pages;
>  
> @@ -5704,17 +5734,25 @@ static unsigned kstaled_scan_page(struct page *page)
>  
>  	/* Find out if the page is idle. Also test for pending mlock. */
>  	page_referenced_kstaled(page, is_locked, &info);
> -	if ((info.pr_flags & PR_REFERENCED) || (info.vm_flags & VM_LOCKED))
> +	if ((info.pr_flags & PR_REFERENCED) || (info.vm_flags & VM_LOCKED)) {
> +		*idle_page_age = 0;
>  		goto out;
> +	}
>  
>  	/* Locate kstaled stats for the page's cgroup. */
>  	pc = lookup_page_cgroup(page);
>  	if (!pc)
>  		goto out;
>  	lock_page_cgroup(pc);
> +	memcg = pc->mem_cgroup;
>  	if (!PageCgroupUsed(pc))
>  		goto unlock_page_cgroup_out;
> -	stats = &pc->mem_cgroup->idle_scan_stats;
> +
> +	/* Page is idle, increment its age and get the right stats bucket */
> +	age = *idle_page_age;
> +	if (age < 255)
> +		*idle_page_age = ++age;
> +	stats = kstaled_idle_stats(memcg, age);
>  
>  	/* Finally increment the correct statistic for this page. */
>  	if (!(info.pr_flags & PR_DIRTY) &&
> @@ -5740,11 +5778,22 @@ static bool kstaled_scan_node(pg_data_t *pgdat, int scan_seconds, bool reset)
>  {
>  	unsigned long flags;
>  	unsigned long pfn, end, node_end;
> +	u8 *idle_page_age;
>  
>  	pgdat_resize_lock(pgdat, &flags);
>  
> +	if (!pgdat->node_idle_page_age) {
> +		pgdat->node_idle_page_age = vmalloc(pgdat->node_spanned_pages);

Hmm, on 2T host, this requires 

   1024 * 1024 * 1024 * 1024 * 2 / 4096 = 512MB at least..
And will includes huge memory holes ;)

Can't you use some some calculation as load_avg or some ?

Thanks,
-Kame

