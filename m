Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab1DESlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:41:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64813 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1DESln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:41:43 -0400
Message-ID: <4D9B6245.9000600@kernel.org>
Date: Tue, 05 Apr 2011 11:41:09 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/14] x86-32, NUMA: Move lowmem address space reservation
 to init_alloc_remap()
References: <1301955840-7246-1-git-send-email-tj@kernel.org> <1301955840-7246-10-git-send-email-tj@kernel.org>
In-Reply-To: <1301955840-7246-10-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D9B6253.010E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2011 03:23 PM, Tejun Heo wrote:
> Remap alloc init is done in the following stages.
>
> 1. init_alloc_remap() calculates how much memory is necessary for each
>     node and reserves node local memory.
>
> 2. initmem_init() collects how much each node needs and reserves a
>     single contiguous lowmem area which can contain all.
>
> 3. init_remap_allocator() initializes allocator parameters from the
>     determined lowmem address and per-node offsets.
>
> 4. Actual remap happens.
>
> There is no reason for the lowmem remap area to be reserved as a
> single contiguous area at one go.  They don't interact with each other
> and the memblock allocator will put them side-by-side anyway.
>
> This patch breaks up the single lowmem address reservation and put
> per-node lowmem address reservation into init_alloc_remap() and
> initializes allocator parameters directly in the function as all the
> addresses are determined there.  This merges steps 2 and 3 into 1.
>
> While at it, remove now largely irrelevant comments in
> init_alloc_remap().
>
> This change causes the following behavior changes.
>
> * Remap lowmem areas are allocated in smaller per-node chunks.
>
> * Remap lowmem area reservation failure fail future remap allocations
>    instead of panicking.
>
> * Remap allocator initialization is less verbose.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Yinghai Lu<yinghai@kernel.org>
> Cc: David Rientjes<rientjes@google.com>
> Cc: Thomas Gleixner<tglx@linutronix.de
> Cc: Ingo Molnar<mingo@redhat.com>
> Cc: "H. Peter Anvin"<hpa@zytor.com>
> ---
>   arch/x86/mm/numa_32.c |   82 +++++++++++++++----------------------------------
>   1 files changed, 25 insertions(+), 57 deletions(-)
>
> diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
> index c127543..12bb34c 100644
> --- a/arch/x86/mm/numa_32.c
> +++ b/arch/x86/mm/numa_32.c
> @@ -108,9 +108,6 @@ static unsigned long node_remap_size[MAX_NUMNODES];
>   static void *node_remap_start_vaddr[MAX_NUMNODES];
>   void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
>
> -static unsigned long kva_start_pfn;
> -static unsigned long kva_pages;
> -
>   int __cpuinit numa_cpu_node(int cpu)
>   {
>   	return apic->x86_32_numa_cpu_node(cpu);
> @@ -266,7 +263,8 @@ void resume_map_numa_kva(pgd_t *pgd_base)
>   static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
>   {
>   	unsigned long size;
> -	u64 node_pa;
> +	u64 node_pa, remap_pa;
> +	void *remap_va;
>
>   	/*
>   	 * The acpi/srat node info can show hot-add memroy zones where
> @@ -287,6 +285,7 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
>   	size += ALIGN(sizeof(pg_data_t), PAGE_SIZE);
>   	size = ALIGN(size, LARGE_PAGE_BYTES);
>
> +	/* allocate node memory and the lowmem remap area */
>   	node_pa = memblock_find_in_range(node_start_pfn[nid]<<  PAGE_SHIFT,
>   					 (u64)node_end_pfn[nid]<<  PAGE_SHIFT,
>   					 size, LARGE_PAGE_BYTES);
> @@ -295,45 +294,35 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
>   			   size, nid);
>   		return 0;
>   	}
> +	memblock_x86_reserve_range(node_pa, node_pa + size, "KVA RAM");
> +
> +	remap_pa = memblock_find_in_range(min_low_pfn<<  PAGE_SHIFT,
> +					  max_low_pfn<<  PAGE_SHIFT,
> +					  size, LARGE_PAGE_BYTES);
> +	if (remap_pa == MEMBLOCK_ERROR) {
> +		pr_warning("remap_alloc: failed to allocate %lu bytes remap area for node %d\n",
> +			   size, nid);
> +		memblock_x86_free_range(node_pa, node_pa + size);
> +		return 0;
> +	}
> +	memblock_x86_reserve_range(remap_pa, remap_pa + size, "KVA PG");
> +	remap_va = phys_to_virt(remap_pa);
>
> +	/* initialize remap allocator parameters */
> +	node_remap_start_pfn[nid] = node_pa>>  PAGE_SHIFT;
>   	node_remap_size[nid] = size>>  PAGE_SHIFT;
>   	node_remap_offset[nid] = offset;
> -	printk(KERN_DEBUG "Reserving %ld pages of KVA for lmem_map of node %d at %llx\n",
> -	       size>>  PAGE_SHIFT, nid, node_pa>>  PAGE_SHIFT);
>
> -	/*
> -	 *  prevent kva address below max_low_pfn want it on system
> -	 *  with less memory later.
> -	 *  layout will be: KVA address , KVA RAM
> -	 *
> -	 *  we are supposed to only record the one less then
> -	 *  max_low_pfn but we could have some hole in high memory,
> -	 *  and it will only check page_is_ram(pfn)&&
> -	 *  !page_is_reserved_early(pfn) to decide to use it as free.
> -	 *  So memblock_x86_reserve_range here, hope we don't run out
> -	 *  of that array
> -	 */
> -	memblock_x86_reserve_range(node_pa, node_pa + size, "KVA RAM");
> +	node_remap_start_vaddr[nid] = remap_va;
> +	node_remap_end_vaddr[nid] = remap_va + size;
> +	node_remap_alloc_vaddr[nid] = remap_va + ALIGN(sizeof(pg_data_t), PAGE_SIZE);
>
> -	node_remap_start_pfn[nid] = node_pa>>  PAGE_SHIFT;
> +	printk(KERN_DEBUG "remap_alloc: node %d [%08llx-%08llx) ->  [%p-%p)\n",
> +	       nid, node_pa, node_pa + size, remap_va, remap_va + size);
>
>   	return size>>  PAGE_SHIFT;
>   }
>
> -static void init_remap_allocator(int nid)
> -{
> -	node_remap_start_vaddr[nid] = pfn_to_kaddr(
> -			kva_start_pfn + node_remap_offset[nid]);
> -	node_remap_end_vaddr[nid] = node_remap_start_vaddr[nid] +
> -		(node_remap_size[nid] * PAGE_SIZE);
> -	node_remap_alloc_vaddr[nid] = node_remap_start_vaddr[nid] +
> -		ALIGN(sizeof(pg_data_t), PAGE_SIZE);
> -
> -	printk(KERN_DEBUG "node %d will remap to vaddr %08lx - %08lx\n", nid,
> -		(ulong) node_remap_start_vaddr[nid],
> -		(ulong) node_remap_end_vaddr[nid]);
> -}
> -
>   void __init initmem_init(void)
>   {
>   	unsigned long reserve_pages = 0;
> @@ -352,25 +341,7 @@ void __init initmem_init(void)
>
>   	for_each_online_node(nid)
>   		reserve_pages += init_alloc_remap(nid, reserve_pages);
> -	kva_pages = roundup(reserve_pages, PTRS_PER_PTE);
> -	printk(KERN_INFO "Reserving total of %lx pages for numa KVA remap\n",
> -			reserve_pages);
> -
> -	kva_start_pfn = memblock_find_in_range(min_low_pfn<<  PAGE_SHIFT,
> -				max_low_pfn<<  PAGE_SHIFT,
> -				kva_pages<<  PAGE_SHIFT,
> -				PTRS_PER_PTE<<  PAGE_SHIFT)>>  PAGE_SHIFT;
> -	if (kva_start_pfn == MEMBLOCK_ERROR)
> -		panic("Can not get kva space\n");
> -
> -	printk(KERN_INFO "kva_start_pfn ~ %lx max_low_pfn ~ %lx\n",
> -		kva_start_pfn, max_low_pfn);
> -	printk(KERN_INFO "max_pfn = %lx\n", max_pfn);
> -
> -	/* avoid clash with initrd */
> -	memblock_x86_reserve_range(kva_start_pfn<<PAGE_SHIFT,
> -		      (kva_start_pfn + kva_pages)<<PAGE_SHIFT,
> -		     "KVA PG");
> +
>   #ifdef CONFIG_HIGHMEM
>   	highstart_pfn = highend_pfn = max_pfn;
>   	if (max_pfn>  max_low_pfn)
> @@ -390,11 +361,8 @@ void __init initmem_init(void)
>
>   	printk(KERN_DEBUG "Low memory ends at vaddr %08lx\n",
>   			(ulong) pfn_to_kaddr(max_low_pfn));
> -	for_each_online_node(nid) {
> -		init_remap_allocator(nid);
> -
> +	for_each_online_node(nid)
>   		allocate_pgdat(nid);
> -	}
>   	remap_numa_kva();
>
>   	printk(KERN_DEBUG "High memory starts at vaddr %08lx\n",

Acked-by: Yinghai Lu <yinghai@kernel.org>
