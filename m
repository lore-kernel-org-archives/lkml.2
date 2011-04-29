Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760384Ab1D2RX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 13:23:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43914 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760309Ab1D2RXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 13:23:54 -0400
Message-ID: <4DBAF40F.8030207@kernel.org>
Date: Fri, 29 Apr 2011 10:23:27 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, rientjes@google.com, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/25] x86-64, NUMA: simplify nodedata allocation
References: <1304090924-8197-1-git-send-email-tj@kernel.org> <1304090924-8197-4-git-send-email-tj@kernel.org>
In-Reply-To: <1304090924-8197-4-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DBAF418.00BF,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2011 08:28 AM, Tejun Heo wrote:
> With top-down memblock allocation, the allocation range limits in
> ealry_node_mem() can be simplified - try node-local first, then any
> node but in any case don't allocate below DMA limit.
> 
> Remove early_node_mem() and implement simplified allocation directly
> in setup_node_bootmem().

keep early_node_mem would be better?

Yinghai

> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/mm/numa_64.c |   53 +++++++++++++++---------------------------------
>  1 files changed, 17 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
> index 5e0dfc5..59d8a1c 100644
> --- a/arch/x86/mm/numa_64.c
> +++ b/arch/x86/mm/numa_64.c
> @@ -37,38 +37,6 @@ __initdata
>  static int numa_distance_cnt;
>  static u8 *numa_distance;
>  
> -static void * __init early_node_mem(int nodeid, unsigned long start,
> -				    unsigned long end, unsigned long size,
> -				    unsigned long align)
> -{
> -	unsigned long mem;
> -
> -	/*
> -	 * put it on high as possible
> -	 * something will go with NODE_DATA
> -	 */
> -	if (start < (MAX_DMA_PFN<<PAGE_SHIFT))
> -		start = MAX_DMA_PFN<<PAGE_SHIFT;
> -	if (start < (MAX_DMA32_PFN<<PAGE_SHIFT) &&
> -	    end > (MAX_DMA32_PFN<<PAGE_SHIFT))
> -		start = MAX_DMA32_PFN<<PAGE_SHIFT;
> -	mem = memblock_x86_find_in_range_node(nodeid, start, end, size, align);
> -	if (mem != MEMBLOCK_ERROR)
> -		return __va(mem);
> -
> -	/* extend the search scope */
> -	end = max_pfn_mapped << PAGE_SHIFT;
> -	start = MAX_DMA_PFN << PAGE_SHIFT;
> -	mem = memblock_find_in_range(start, end, size, align);
> -	if (mem != MEMBLOCK_ERROR)
> -		return __va(mem);
> -
> -	printk(KERN_ERR "Cannot find %lu bytes in node %d\n",
> -		       size, nodeid);
> -
> -	return NULL;
> -}
> -
>  static int __init numa_add_memblk_to(int nid, u64 start, u64 end,
>  				     struct numa_meminfo *mi)
>  {
> @@ -130,6 +98,8 @@ int __init numa_add_memblk(int nid, u64 start, u64 end)
>  void __init
>  setup_node_bootmem(int nid, unsigned long start, unsigned long end)
>  {
> +	const u64 nd_low = (u64)MAX_DMA_PFN << PAGE_SHIFT;
> +	const u64 nd_high = (u64)max_pfn_mapped << PAGE_SHIFT;
>  	const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
>  	unsigned long nd_pa;
>  	int tnid;
> @@ -146,18 +116,29 @@ setup_node_bootmem(int nid, unsigned long start, unsigned long end)
>  	printk(KERN_INFO "Initmem setup node %d %016lx-%016lx\n",
>  	       nid, start, end);
>  
> -	node_data[nid] = early_node_mem(nid, start, end, nd_size,
> -					SMP_CACHE_BYTES);
> -	if (node_data[nid] == NULL)
> +	/*
> +	 * Try to allocate node data on local node and then fall back to
> +	 * all nodes.  Never allocate in DMA zone.
> +	 */
> +	nd_pa = memblock_x86_find_in_range_node(nid, nd_low, nd_high,
> +						nd_size, SMP_CACHE_BYTES);
> +	if (nd_pa == MEMBLOCK_ERROR)
> +		nd_pa = memblock_find_in_range(nd_low, nd_high,
> +					       nd_size, SMP_CACHE_BYTES);
> +	if (nd_pa == MEMBLOCK_ERROR) {
> +		pr_err("Cannot find %lu bytes in node %d\n", nd_size, nid);
>  		return;
> -	nd_pa = __pa(node_data[nid]);
> +	}
>  	memblock_x86_reserve_range(nd_pa, nd_pa + nd_size, "NODE_DATA");
> +
> +	/* report and initialize */
>  	printk(KERN_INFO "  NODE_DATA [%016lx - %016lx]\n",
>  	       nd_pa, nd_pa + nd_size - 1);
>  	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
>  	if (tnid != nid)
>  		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nid, tnid);
>  
> +	node_data[nid] = __va(nd_pa);
>  	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
>  	NODE_DATA(nid)->node_id = nid;
>  	NODE_DATA(nid)->node_start_pfn = start >> PAGE_SHIFT;

