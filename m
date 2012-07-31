Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab2GaHmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 03:42:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54104 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab2GaHmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 03:42:31 -0400
X-IronPort-AV: E=Sophos;i="4.77,682,1336320000"; 
   d="scan'208";a="5517796"
Message-ID: <50178C9B.8090408@cn.fujitsu.com>
Date: Tue, 31 Jul 2012 15:43:23 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>, Minchan Kim <minchan@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jiang Liu <liuj97@gmail.com>,
        Wei Wang <Bessel.Wang@huawei.com>
Subject: Re: [PATCH 3/4] mm/hotplug: free zone->pageset when a zone becomes
 empty
References: <1341481532-1700-1-git-send-email-jiang.liu@huawei.com> <1341481532-1700-3-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1341481532-1700-3-git-send-email-jiang.liu@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/31 15:38:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/31 15:39:11,
	Serialize complete at 2012/07/31 15:39:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 07/05/2012 05:45 PM, Jiang Liu Wrote:
> When a zone becomes empty after memory offlining, free zone->pageset.
> Otherwise it will cause memory leak when adding memory to the empty
> zone again because build_all_zonelists() will allocate zone->pageset
> for an empty zone.
> 
> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> Signed-off-by: Wei Wang <Bessel.Wang@huawei.com>
> ---
>  include/linux/mm.h  |    1 +
>  mm/memory_hotplug.c |    3 +++
>  mm/page_alloc.c     |   13 +++++++++++++
>  3 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index b36d08c..f8b62f2 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1331,6 +1331,7 @@ void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...);
>  extern void setup_per_cpu_pageset(void);
>  
>  extern void zone_pcp_update(struct zone *zone);
> +extern void zone_pcp_reset(struct zone *zone);
>  
>  /* nommu.c */
>  extern atomic_long_t mmap_pages_allocated;
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index bce80c7..998b792 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -966,6 +966,9 @@ repeat:
>  
>  	init_per_zone_wmark_min();
>  
> +	if (!populated_zone(zone))
> +		zone_pcp_reset(zone);
> +
>  	if (!node_present_pages(node)) {
>  		node_clear_state(node, N_HIGH_MEMORY);
>  		kswapd_stop(node);
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ebf319d..5964b7a 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5872,6 +5872,19 @@ void free_contig_range(unsigned long pfn, unsigned nr_pages)
>  #endif
>  
>  #ifdef CONFIG_MEMORY_HOTREMOVE
> +void zone_pcp_reset(struct zone *zone)
> +{
> +	unsigned long flags;
> +
> +	/* avoid races with drain_pages()  */
> +	local_irq_save(flags);

drain_pages() may run on another cpu, so it cann't avoid
races with drain_pages().

Thanks
Wen Congyang

> +	if (zone->pageset != &boot_pageset) {
> +		free_percpu(zone->pageset);
> +		zone->pageset = &boot_pageset;
> +	}
> +	local_irq_restore(flags);
> +}
> +
>  /*
>   * All pages in the range must be isolated before calling this.
>   */

