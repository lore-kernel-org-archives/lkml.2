Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab2GTDWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 23:22:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44778 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2GTDWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 23:22:01 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5008CE38.2020300@jp.fujitsu.com>
Date: Fri, 20 Jul 2012 12:19:20 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "andi.kleen" <andi.kleen@intel.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cgroup: Fix memory accounting scalability in shrink_page_list
References: <1342740866.13492.50.camel@schen9-DESK>
In-Reply-To: <1342740866.13492.50.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/20 8:34), Tim Chen wrote:
> Hi,
>
> I noticed in a multi-process parallel files reading benchmark I ran on a
> 8 socket machine,  throughput slowed down by a factor of 8 when I ran
> the benchmark within a cgroup container.  I traced the problem to the
> following code path (see below) when we are trying to reclaim memory
> from file cache.  The res_counter_uncharge function is called on every
> page that's reclaimed and created heavy lock contention.  The patch
> below allows the reclaimed pages to be uncharged from the resource
> counter in batch and recovered the regression.
>
> Tim
>
>       40.67%           usemem  [kernel.kallsyms]                   [k] _raw_spin_lock
>                        |
>                        --- _raw_spin_lock
>                           |
>                           |--92.61%-- res_counter_uncharge
>                           |          |
>                           |          |--100.00%-- __mem_cgroup_uncharge_common
>                           |          |          |
>                           |          |          |--100.00%-- mem_cgroup_uncharge_cache_page
>                           |          |          |          __remove_mapping
>                           |          |          |          shrink_page_list
>                           |          |          |          shrink_inactive_list
>                           |          |          |          shrink_mem_cgroup_zone
>                           |          |          |          shrink_zone
>                           |          |          |          do_try_to_free_pages
>                           |          |          |          try_to_free_pages
>                           |          |          |          __alloc_pages_nodemask
>                           |          |          |          alloc_pages_current
>
>

Thank you very much !!

When I added batching, I didn't touch page-reclaim path because it delays
res_counter_uncharge() and make more threads run into page reclaim.
But, from above score, bactching seems required.

And because of current design of per-zone-per-memcg-LRU, batching
works very very well....all lru pages shrink_page_list() scans are on
the same memcg.

BTW, it's better to show 'how much improved' in patch description..


> ---
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 33dc256..aac5672 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -779,6 +779,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>
>   	cond_resched();
>
> +	mem_cgroup_uncharge_start();
>   	while (!list_empty(page_list)) {
>   		enum page_references references;
>   		struct address_space *mapping;
> @@ -1026,6 +1027,7 @@ keep_lumpy:
>
>   	list_splice(&ret_pages, page_list);
>   	count_vm_events(PGACTIVATE, pgactivate);
> +	mem_cgroup_uncharge_end();

I guess placing mem_cgroup_uncharge_end() just after the loop may be better looking.

Anyway,
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

But please show 'how much improved' in patch description.

Thanks,
-Kame

