Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab2INJwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 05:52:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55046 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab2INJwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 05:52:37 -0400
Date: Fri, 14 Sep 2012 10:52:30 +0100
From: Mel Gorman <mgorman@suse.de>
To: qiuxishi <qiuxishi@gmail.com>
Cc: akpm@linux-foundation.org, tony.luck@intel.com,
        Jiang Liu <jiang.liu@huawei.com>, qiuxishi@huawei.com,
        bessel.wang@huawei.com, wujianguo@huawei.com,
        paul.gortmaker@windriver.com, kamezawa.hiroyu@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com, rientjes@google.com,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH RESEND] memory hotplug: fix a double register section
 info bug
Message-ID: <20120914095230.GE11266@suse.de>
References: <5052A7DF.4050301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <5052A7DF.4050301@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 11:43:27AM +0800, qiuxishi wrote:
> There may be a bug when registering section info. For example, on
> my Itanium platform, the pfn range of node0 includes the other nodes,
> so other nodes' section info will be double registered, and memmap's
> page count will equal to 3.
> 
> node0: start_pfn=0x100,    spanned_pfn=0x20fb00, present_pfn=0x7f8a3, => 0x000100-0x20fc00
> node1: start_pfn=0x80000,  spanned_pfn=0x80000,  present_pfn=0x80000, => 0x080000-0x100000
> node2: start_pfn=0x100000, spanned_pfn=0x80000,  present_pfn=0x80000, => 0x100000-0x180000
> node3: start_pfn=0x180000, spanned_pfn=0x80000,  present_pfn=0x80000, => 0x180000-0x200000
> 

This is an unusual configuration but it's not unheard of. PPC64 in rare
(and usually broken) configurations can have one node span another. Tony
should know if such a configuration is normally allowed on Itanium or if
this should be considered a platform bug. Tony?

> free_all_bootmem_node()
> 	register_page_bootmem_info_node()
> 		register_page_bootmem_info_section()
> 
> When hot remove memory, we can't free the memmap's page because
> page_count() is 2 after put_page_bootmem().
> 
> sparse_remove_one_section()
> 	free_section_usemap()
> 		free_map_bootmem()
> 			put_page_bootmem()
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  mm/memory_hotplug.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 2adbcac..cf493c7 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -126,9 +126,6 @@ static void register_page_bootmem_info_section(unsigned long start_pfn)
>  	struct mem_section *ms;
>  	struct page *page, *memmap;
> 
> -	if (!pfn_valid(start_pfn))
> -		return;
> -
>  	section_nr = pfn_to_section_nr(start_pfn);
>  	ms = __nr_to_section(section_nr);
> 
> @@ -187,9 +184,10 @@ void register_page_bootmem_info_node(struct pglist_data *pgdat)
>  	end_pfn = pfn + pgdat->node_spanned_pages;
> 
>  	/* register_section info */
> -	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION)
> -		register_page_bootmem_info_section(pfn);
> -
> +	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> +		if (pfn_valid(pfn) && (pfn_to_nid(pfn) == node))
> +			register_page_bootmem_info_section(pfn);
> +	}

Functionally what the patch does is check if the PFN is both valid *and*
belongs to the expected node to catch a situation where nodes overlap. As
there are no other callers of register_page_bootmem_info_section() this
patch seems reasonable to me so

Acked-by: Mel Gorman <mgorman@suse.de>

I think it would also be ok to consider this a -stable candidate.

>  }
>  #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
> 
> -- 
> 1.7.1

-- 
Mel Gorman
SUSE Labs
