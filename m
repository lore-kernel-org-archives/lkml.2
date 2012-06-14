Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab2FNG1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 02:27:53 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:27837 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab2FNG1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 02:27:52 -0400
Message-ID: <4FD9839B.2080307@huawei.com>
Date: Thu, 14 Jun 2012 14:24:27 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Keping Chen <chenkeping@huawei.com>,
        Tony Luck <tony.luck@intel.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Xishi Qiu <qiuxishi@huawei.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH] memory hotplug: fix invalid memory access caused by stale
 kswapd pointer
References: <1339645491-5656-1-git-send-email-jiang.liu@huawei.com> <4FD97718.6060008@kernel.org>
In-Reply-To: <4FD97718.6060008@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,
	Thanks for comments and will send out a separate patch for
readability soon based on your version.
	Thanks!
        Gerry

On 2012-6-14 13:31, Minchan Kim wrote:
> Hi,
> 
> On 06/14/2012 12:44 PM, Jiang Liu wrote:
> 
>> Function kswapd_stop() will be called to destroy the kswapd work thread
>> when all memory of a NUMA node has been offlined. But kswapd_stop() only
>> terminates the work thread without resetting NODE_DATA(nid)->kswapd to NULL.
>> The stale pointer will prevent kswapd_run() from creating a new work thread
>> when adding memory to the memory-less NUMA node again. Eventually the stale
>> pointer may cause invalid memory access.
>>
>> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
>> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> 
> 
> Reviewed-by: Minchan Kim <minchan@kernel.org>
> 
> Nitpick:
> 
> I saw kswapd_run and doubt why following line is there.
> 
> 	if (pgdat->kswapd)
> 		return 0;
> 
> As looking thorough hotplug, I realized one can hotplug pages which are within different zones but same node.
> Because kswapd live in per-node, that code is for checking kswapd already run. Right?
Yes, I think so. We could also add new memory pages to existing zones too.

> 
> IMHO, better readable code is following as
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index b967eda..9425c0e 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -299,6 +299,7 @@ static inline void scan_unevictable_unregister_node(struct node *node)
>  }
>  #endif
>  
> +extern bool is_kswapd_running(int nid);
>  extern int kswapd_run(int nid);
>  extern void kswapd_stop(int nid);
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 0d7e3ec..60f9155 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -522,7 +522,8 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages)
>         init_per_zone_wmark_min();
>  
>         if (onlined_pages) {
> -               kswapd_run(zone_to_nid(zone));
> +               if (!is_kswapd_running(zone_to_nid(zone))
> +                       kswapd_run(zone_to_nid(zone));
>                 node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
>         }
>  
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index eeb3bc9..f331904 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2932,6 +2932,14 @@ static int __devinit cpu_callback(struct notifier_block *nfb,
>         return NOTIFY_OK;
>  }
>  
> +bool is_kswapd_running(int nid)
> +{
> +       pg_data_t *pgdat = NODE_DATA(nid);
> +       if (pgdat->kswapd)
> +               return true;
> +       return false;
> +}
> +
>  /*
>   * This kswapd start function will be called by init and node-hot-add.
>   * On node-hot-add, kswapd will moved to proper cpus if cpus are hot-added.
> @@ -2941,9 +2949,6 @@ int kswapd_run(int nid)
>         pg_data_t *pgdat = NODE_DATA(nid);
>         int ret = 0;
>  
> -       if (pgdat->kswapd)
> -               return 0;
> -
>         pgdat->kswapd = kthread_run(kswapd, pgdat, "kswapd%d", nid);
>         if (IS_ERR(pgdat->kswapd)) {
>                 /* failure at boot is fatal */
> 
> Anyway, it's a preference and trivial but I hope you fix that, too if you don't mind
> Of course, my nitpick shouldn't prevent merging your good fix.
> If you mind it, I don't care of it. :)
> 
> Thanks.


