Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab2IKCtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 22:49:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52913 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754850Ab2IKCtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 22:49:51 -0400
X-IronPort-AV: E=Sophos;i="4.80,401,1344182400"; 
   d="scan'208";a="5817600"
Message-ID: <504EA827.3000700@cn.fujitsu.com>
Date: Tue, 11 Sep 2012 10:55:35 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [V4 PATCH 02/26] memory_hotplug: fix missing nodemask management
References: <1347267558-6707-1-git-send-email-laijs@cn.fujitsu.com> <1347267558-6707-3-git-send-email-laijs@cn.fujitsu.com>
In-Reply-To: <1347267558-6707-3-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/11 10:49:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/11 10:49:17,
	Serialize complete at 2012/09/11 10:49:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 09/10/2012 04:58 PM, Lai Jiangshan Wrote:
> Currently memory_hotplug only manages the node_states[N_HIGH_MEMORY],
> it forgot to manage node_states[N_NORMAL_MEMORY]. fix it.
> 
> Add check_nodemasks_changes_online() and check_nodemasks_changes_offline
> to detect do node_states[N_HIGH_MEMORY] and node_states[N_NORMAL_MEMORY]
> are changed while hotplug.
> 
> Also add @status_change_nid_normal to struct memory_notify, thus
> the memory hotplug callbacks know whether the node_states[N_NORMAL_MEMORY]
> are changed.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  Documentation/memory-hotplug.txt |    5 ++-
>  include/linux/memory.h           |    1 +
>  mm/memory_hotplug.c              |   94 +++++++++++++++++++++++++++++++------
>  3 files changed, 83 insertions(+), 17 deletions(-)
> 
> diff --git a/Documentation/memory-hotplug.txt b/Documentation/memory-hotplug.txt
> index 6d0c251..6e6cbc7 100644
> --- a/Documentation/memory-hotplug.txt
> +++ b/Documentation/memory-hotplug.txt
> @@ -377,15 +377,18 @@ The third argument is passed by pointer of struct memory_notify.
>  struct memory_notify {
>         unsigned long start_pfn;
>         unsigned long nr_pages;
> +       int status_change_nid_normal;
>         int status_change_nid;
>  }
>  
>  start_pfn is start_pfn of online/offline memory.
>  nr_pages is # of pages of online/offline memory.
> +status_change_nid_normal is set node id when N_NORMAL_MEMORY of nodemask
> +is (will be) set/clear, if this is -1, then nodemask status is not changed.
>  status_change_nid is set node id when N_HIGH_MEMORY of nodemask is (will be)
>  set/clear. It means a new(memoryless) node gets new memory by online and a
>  node loses all memory. If this is -1, then nodemask status is not changed.
> -If status_changed_nid >= 0, callback should create/discard structures for the
> +If status_changed_nid* >= 0, callback should create/discard structures for the
>  node if necessary.
>  
>  --------------
> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index 1ac7f6e..6b9202b 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -53,6 +53,7 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
>  struct memory_notify {
>  	unsigned long start_pfn;
>  	unsigned long nr_pages;
> +	int status_change_nid_normal;
>  	int status_change_nid;
>  };
>  
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 3ad25f9..8c3bcf6 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -456,6 +456,34 @@ static int online_pages_range(unsigned long start_pfn, unsigned long nr_pages,
>  	return 0;
>  }
>  
> +static void check_nodemasks_changes_online(unsigned long nr_pages,
> +	struct zone *zone, struct memory_notify *arg)
> +{
> +	int nid = zone_to_nid(zone);
> +	enum zone_type zone_last = ZONE_NORMAL;
> +
> +	if (N_HIGH_MEMORY == N_NORMAL_MEMORY)
> +		zone_last = ZONE_MOVABLE;
> +
> +	if (zone_idx(zone) <= zone_last && !node_state(nid, N_NORMAL_MEMORY))
> +		arg->status_change_nid_normal = nid;
> +	else
> +		arg->status_change_nid_normal = -1;
> +
> +	if (!node_state(nid, N_HIGH_MEMORY))
> +		arg->status_change_nid = nid;
> +	else
> +		arg->status_change_nid = -1;
> +}
> +
> +static void set_nodemasks(int node, struct memory_notify *arg)
> +{
> +	if (arg->status_change_nid_normal >= 0)
> +		node_set_state(node, N_NORMAL_MEMORY);
> +
> +	node_set_state(node, N_HIGH_MEMORY);
> +}
> +
>  
>  int __ref online_pages(unsigned long pfn, unsigned long nr_pages)
>  {
> @@ -467,13 +495,18 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages)
>  	struct memory_notify arg;
>  
>  	lock_memory_hotplug();
> +	/*
> +	 * This doesn't need a lock to do pfn_to_page().
> +	 * The section can't be removed here because of the
> +	 * memory_block->state_mutex.
> +	 */

If we hotremove memory, we remove the section without memory_block->state_mutex,
it is fixed by the following patch:
https://lkml.org/lkml/2012/9/5/162

Thanks
Wen Congyang

> +	zone = page_zone(pfn_to_page(pfn));
> +
>  	arg.start_pfn = pfn;
>  	arg.nr_pages = nr_pages;
> -	arg.status_change_nid = -1;
> +	check_nodemasks_changes_online(nr_pages, zone, &arg);
>  
>  	nid = page_to_nid(pfn_to_page(pfn));
> -	if (node_present_pages(nid) == 0)
> -		arg.status_change_nid = nid;
>  
>  	ret = memory_notify(MEM_GOING_ONLINE, &arg);
>  	ret = notifier_to_errno(ret);
> @@ -483,12 +516,6 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages)
>  		return ret;
>  	}
>  	/*
> -	 * This doesn't need a lock to do pfn_to_page().
> -	 * The section can't be removed here because of the
> -	 * memory_block->state_mutex.
> -	 */
> -	zone = page_zone(pfn_to_page(pfn));
> -	/*
>  	 * If this zone is not populated, then it is not in zonelist.
>  	 * This means the page allocator ignores this zone.
>  	 * So, zonelist must be updated after online.
> @@ -513,7 +540,7 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages)
>  	zone->present_pages += onlined_pages;
>  	zone->zone_pgdat->node_present_pages += onlined_pages;
>  	if (onlined_pages) {
> -		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
> +		set_nodemasks(zone_to_nid(zone), &arg);
>  		if (need_zonelists_rebuild)
>  			build_all_zonelists(NULL, zone);
>  		else
> @@ -866,6 +893,44 @@ check_pages_isolated(unsigned long start_pfn, unsigned long end_pfn)
>  	return offlined;
>  }
>  
> +static void check_nodemasks_changes_offline(unsigned long nr_pages,
> +		struct zone *zone, struct memory_notify *arg)
> +{
> +	struct pglist_data *pgdat = zone->zone_pgdat;
> +	unsigned long present_pages = 0;
> +	enum zone_type zt, zone_last = ZONE_NORMAL;
> +
> +	if (N_HIGH_MEMORY == N_NORMAL_MEMORY)
> +		zone_last = ZONE_MOVABLE;
> +
> +	for (zt = 0; zt <= zone_last; zt++)
> +		present_pages += pgdat->node_zones[zt].present_pages;
> +	if (zone_idx(zone) <= zone_last && nr_pages >= present_pages)
> +		arg->status_change_nid_normal = zone_to_nid(zone);
> +	else
> +		arg->status_change_nid_normal = -1;
> +
> +	zone_last = ZONE_MOVABLE;
> +	for (; zt <= zone_last; zt++)
> +		present_pages += pgdat->node_zones[zt].present_pages;
> +	if (nr_pages >= present_pages)
> +		arg->status_change_nid = zone_to_nid(zone);
> +	else
> +		arg->status_change_nid = -1;
> +}
> +
> +static void clear_nodemasks(int node, struct memory_notify *arg)
> +{
> +	if (arg->status_change_nid_normal >= 0)
> +		node_clear_state(node, N_NORMAL_MEMORY);
> +
> +	if (N_HIGH_MEMORY == N_NORMAL_MEMORY)
> +		return;
> +
> +	if (arg->status_change_nid >= 0)
> +		node_clear_state(node, N_HIGH_MEMORY);
> +}
> +
>  static int __ref offline_pages(unsigned long start_pfn,
>  		  unsigned long end_pfn, unsigned long timeout)
>  {
> @@ -899,9 +964,7 @@ static int __ref offline_pages(unsigned long start_pfn,
>  
>  	arg.start_pfn = start_pfn;
>  	arg.nr_pages = nr_pages;
> -	arg.status_change_nid = -1;
> -	if (nr_pages >= node_present_pages(node))
> -		arg.status_change_nid = node;
> +	check_nodemasks_changes_offline(nr_pages, zone, &arg);
>  
>  	ret = memory_notify(MEM_GOING_OFFLINE, &arg);
>  	ret = notifier_to_errno(ret);
> @@ -969,10 +1032,9 @@ repeat:
>  	if (!populated_zone(zone))
>  		zone_pcp_reset(zone);
>  
> -	if (!node_present_pages(node)) {
> -		node_clear_state(node, N_HIGH_MEMORY);
> +	clear_nodemasks(node, &arg);
> +	if (arg.status_change_nid >= 0)
>  		kswapd_stop(node);
> -	}
>  
>  	vm_total_pages = nr_free_pagecache_pages();
>  	writeback_set_ratelimit();

