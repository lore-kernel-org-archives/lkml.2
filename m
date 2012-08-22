Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab2HVGKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:10:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:22527 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab2HVGKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:10:19 -0400
X-IronPort-AV: E=Sophos;i="4.77,808,1336320000"; 
   d="scan'208";a="5691300"
Message-ID: <50347906.4030101@cn.fujitsu.com>
Date: Wed, 22 Aug 2012 14:15:34 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: qiuxishi <qiuxishi@gmail.com>
CC: akpm@linux-foundation.org, liuj97@gmail.com, paul.gortmaker@windriver.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        bessel.wang@huawei.com, wujianguo@huawei.com, qiuxishi@huawei.com,
        jiang.liu@huawei.com, guohanjun@huawei.com, chenkeping@huawei.com,
        yinghai@kernel.org
Subject: Re: [PATCH] memory-hotplug: add build zonelists when offline pages
References: <5033843E.8000902@gmail.com>
In-Reply-To: <5033843E.8000902@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/22 14:10:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/22 14:10:17,
	Serialize complete at 2012/08/22 14:10:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 08/21/2012 08:51 PM, qiuxishi Wrote:
> From: Xishi Qiu <qiuxishi@huawei.com>
> 
> online_pages() does build_all_zonelists() and zone_pcp_update(),
> I think offline_pages() should do it too. The node has no memory
> to allocate, so remove this node's zones form other nodes' zonelists.
> 
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> ---
>  mm/memory_hotplug.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index bc7e7a2..5172bd4 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -979,7 +979,11 @@ repeat:
>  	if (!node_present_pages(node)) {
>  		node_clear_state(node, N_HIGH_MEMORY);
>  		kswapd_stop(node);
> -	}
> +		mutex_lock(&zonelists_mutex);
> +		build_all_zonelists(NODE_DATA(node), NULL);

The node is still onlined now, so there is no need to pass
this node's pgdat to build_all_zonelists().

I think we should build all zonelists when the zone has no
pages.

> +		mutex_unlock(&zonelists_mutex);
> +	} else
> +		zone_pcp_update(zone);

There is more than one zone in a node. So the zone can have
no pages when the node has some pages.

And we have called drain_all_pages(), I think there is no need
to call zone_pcp_update() here.

Thanks
Wen Congyang

> 
>  	vm_total_pages = nr_free_pagecache_pages();
>  	writeback_set_ratelimit();

