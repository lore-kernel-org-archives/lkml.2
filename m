Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1DETPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 15:15:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63279 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab1DETPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 15:15:48 -0400
Message-ID: <4D9B6A4A.4030003@kernel.org>
Date: Tue, 05 Apr 2011 12:15:22 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/14] x86-32, NUMA: Remove now useless node_remap_offset[]
References: <1301955840-7246-1-git-send-email-tj@kernel.org> <1301955840-7246-13-git-send-email-tj@kernel.org>
In-Reply-To: <1301955840-7246-13-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D9B6A55.0046,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2011 03:23 PM, Tejun Heo wrote:
> With lowmem address reservation moved into init_alloc_remap(),
> node_remap_offset[] is no longer useful.  Remove it and related offset
> handling code.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Yinghai Lu<yinghai@kernel.org>
> Cc: David Rientjes<rientjes@google.com>
> Cc: Thomas Gleixner<tglx@linutronix.de
> Cc: Ingo Molnar<mingo@redhat.com>
> Cc: "H. Peter Anvin"<hpa@zytor.com>
> ---
>   arch/x86/mm/numa_32.c |   17 ++++++-----------
>   1 files changed, 6 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
> index 0184a9f..960ea7b 100644
> --- a/arch/x86/mm/numa_32.c
> +++ b/arch/x86/mm/numa_32.c
> @@ -187,7 +187,6 @@ static void __init allocate_pgdat(int nid)
>   static unsigned long node_remap_start_pfn[MAX_NUMNODES];
>   static void *node_remap_end_vaddr[MAX_NUMNODES];
>   static void *node_remap_alloc_vaddr[MAX_NUMNODES];
> -static unsigned long node_remap_offset[MAX_NUMNODES];
>
>   void *alloc_remap(int nid, unsigned long size)
>   {
> @@ -239,7 +238,7 @@ void resume_map_numa_kva(pgd_t *pgd_base)
>   }
>   #endif
>
> -static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
> +static __init void init_alloc_remap(int nid)
>   {
>   	unsigned long size, pfn;
>   	u64 node_pa, remap_pa;
> @@ -252,9 +251,9 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
>   	printk(KERN_DEBUG "node %d pfn: [%lx - %lx]\n",
>   	       nid, node_start_pfn[nid], node_end_pfn[nid]);
>   	if (node_start_pfn[nid]>  max_pfn)
> -		return 0;
> +		return;
>   	if (!node_end_pfn[nid])
> -		return 0;
> +		return;
>   	if (node_end_pfn[nid]>  max_pfn)
>   		node_end_pfn[nid] = max_pfn;
>
> @@ -271,7 +270,7 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
>   	if (node_pa == MEMBLOCK_ERROR) {
>   		pr_warning("remap_alloc: failed to allocate %lu bytes for node %d\n",
>   			   size, nid);
> -		return 0;
> +		return;
>   	}
>   	memblock_x86_reserve_range(node_pa, node_pa + size, "KVA RAM");
>
> @@ -282,7 +281,7 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
>   		pr_warning("remap_alloc: failed to allocate %lu bytes remap area for node %d\n",
>   			   size, nid);
>   		memblock_x86_free_range(node_pa, node_pa + size);
> -		return 0;
> +		return;
>   	}
>   	memblock_x86_reserve_range(remap_pa, remap_pa + size, "KVA PG");
>   	remap_va = phys_to_virt(remap_pa);
> @@ -296,7 +295,6 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
>   	/* initialize remap allocator parameters */
>   	node_remap_start_pfn[nid] = node_pa>>  PAGE_SHIFT;
>   	node_remap_size[nid] = size>>  PAGE_SHIFT;
> -	node_remap_offset[nid] = offset;
>
>   	node_remap_start_vaddr[nid] = remap_va;
>   	node_remap_end_vaddr[nid] = remap_va + size;
> @@ -304,13 +302,10 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
>
>   	printk(KERN_DEBUG "remap_alloc: node %d [%08llx-%08llx) ->  [%p-%p)\n",
>   	       nid, node_pa, node_pa + size, remap_va, remap_va + size);
> -
> -	return size>>  PAGE_SHIFT;
>   }
>
>   void __init initmem_init(void)
>   {
> -	unsigned long reserve_pages = 0;
>   	int nid;
>
>   	/*
> @@ -325,7 +320,7 @@ void __init initmem_init(void)
>   	numa_init_array();
>
>   	for_each_online_node(nid)
> -		reserve_pages += init_alloc_remap(nid, reserve_pages);
> +		init_alloc_remap(nid);
>
>   #ifdef CONFIG_HIGHMEM
>   	highstart_pfn = highend_pfn = max_pfn;

Acked-by: Yinghai Lu <yinghai@kernel.org>
