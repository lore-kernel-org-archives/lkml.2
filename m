Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab2LSJRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 04:17:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:19053 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab2LSJQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 04:16:58 -0500
X-IronPort-AV: E=Sophos;i="4.84,315,1355068800"; 
   d="scan'208";a="6432553"
Message-ID: <50D185CB.3020200@cn.fujitsu.com>
Date: Wed, 19 Dec 2012 17:15:55 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: jiang.liu@huawei.com, wujianguo@huawei.com, hpa@zytor.com,
        akpm@linux-foundation.org, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v4 3/6] ACPI: Restructure movablecore_map with memory
 info from SRAT.
References: <1355904903-22699-1-git-send-email-tangchen@cn.fujitsu.com> <1355904903-22699-4-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1355904903-22699-4-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/19 17:15:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/19 17:15:57,
	Serialize complete at 2012/12/19 17:15:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 04:15 PM, Tang Chen wrote:
> The Hot Plugable bit in SRAT flags specifys if the memory range
> could be hotplugged.
>
> If user specified movablecore_map=nn[KMG]@ss[KMG], reset
> movablecore_map.map to the intersection of hotpluggable ranges from
> SRAT and old movablecore_map.map.
> Else if user specified movablecore_map=acpi, just use the hotpluggable
> ranges from SRAT.
> Otherwise, do nothing. The kernel will use all the memory in all nodes
> evenly.
>
> The idea "getting info from SRAT" was from Liu Jiang<jiang.liu@huawei.com>.
> And the idea "do more limit for memblock" was from Wu Jianguo<wujianguo@huawei.com>
>
> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
> Tested-by: Gu Zheng<guz.fnst@cn.fujitsu.com>
> ---
>   arch/x86/mm/srat.c |   38 +++++++++++++++++++++++++++++++++++---
>   1 files changed, 35 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
> index 4ddf497..947a2b5 100644
> --- a/arch/x86/mm/srat.c
> +++ b/arch/x86/mm/srat.c
> @@ -146,7 +146,12 @@ int __init
>   acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
>   {
>   	u64 start, end;
> +	u32 hotpluggable;
>   	int node, pxm;
> +#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
> +	int overlap;
> +	unsigned long start_pfn, end_pfn;
> +#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
>
>   	if (srat_disabled())
>   		return -1;
> @@ -157,8 +162,10 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
>   	if ((ma->flags&  ACPI_SRAT_MEM_ENABLED) == 0)
>   		return -1;
>
> -	if ((ma->flags&  ACPI_SRAT_MEM_HOT_PLUGGABLE)&&  !save_add_info())
> +	hotpluggable = ma->flags&  ACPI_SRAT_MEM_HOT_PLUGGABLE;
> +	if (hotpluggable&&  !save_add_info())
>   		return -1;
> +
>   	start = ma->base_address;
>   	end = start + ma->length;
>   	pxm = ma->proximity_domain;
> @@ -178,9 +185,34 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
>
>   	node_set(node, numa_nodes_parsed);
>
> -	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
> +	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx] %s\n",
>   	       node, pxm,
> -	       (unsigned long long) start, (unsigned long long) end - 1);
> +	       (unsigned long long) start, (unsigned long long) end - 1,
> +	       hotpluggable ? "Hot Pluggable": "");
> +
> +#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
> +	start_pfn = PFN_DOWN(start);
> +	end_pfn = PFN_UP(end);
> +
> +	if (!hotpluggable) {
> +		/* Clear the range overlapped in movablecore_map.map */
> +		remove_movablecore_map(start_pfn, end_pfn);
> +		goto out;
> +	}
> +
> +	/* If not using SRAT, don't modify user configuration. */
> +	if (!movablecore_map.acpi)
> +		goto out;

Here, forgot to do some check. Please see the new resent one.

Thanks. :)

> +
> +	/* If user chose to use SRAT info, insert the range anyway. */
> +	if (insert_movablecore_map(start_pfn, end_pfn))
> +		pr_err("movablecore_map: too many entries;"
> +			" ignoring [mem %#010llx-%#010llx]\n",
> +			(unsigned long long) start,
> +			(unsigned long long) (end - 1));
> +
> +out:
> +#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
>   	return 0;
>   }
>

