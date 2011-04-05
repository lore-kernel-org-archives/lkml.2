Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab1DETAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 15:00:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48481 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab1DETAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 15:00:10 -0400
Message-ID: <4D9B669E.2020907@kernel.org>
Date: Tue, 05 Apr 2011 11:59:42 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/14] x86-32, NUMA: Move remapping for remap allocator
 into init_alloc_remap()
References: <1301955840-7246-1-git-send-email-tj@kernel.org> <1301955840-7246-11-git-send-email-tj@kernel.org>
In-Reply-To: <1301955840-7246-11-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D9B66A9.0057,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2011 03:23 PM, Tejun Heo wrote:
> There's no reason to perform the actual remapping separately.
> Collapse remap_numa_kva() into init_alloc_remap() and, while at it,
> make it less verbose.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Cc: Yinghai Lu<yinghai@kernel.org>
> Cc: David Rientjes<rientjes@google.com>
> Cc: Thomas Gleixner<tglx@linutronix.de
> Cc: Ingo Molnar<mingo@redhat.com>
> Cc: "H. Peter Anvin"<hpa@zytor.com>
> ---
>   arch/x86/mm/numa_32.c |   29 +++++++----------------------
>   1 files changed, 7 insertions(+), 22 deletions(-)
>
> diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
> index 12bb34c..53ec13a 100644
> --- a/arch/x86/mm/numa_32.c
> +++ b/arch/x86/mm/numa_32.c
> @@ -205,26 +205,6 @@ void *alloc_remap(int nid, unsigned long size)
>   	return allocation;
>   }
>
> -static void __init remap_numa_kva(void)
> -{
> -	void *vaddr;
> -	unsigned long pfn;
> -	int node;
> -
> -	for_each_online_node(node) {
> -		printk(KERN_DEBUG "remap_numa_kva: node %d\n", node);
> -		for (pfn=0; pfn<  node_remap_size[node]; pfn += PTRS_PER_PTE) {
> -			vaddr = node_remap_start_vaddr[node]+(pfn<<PAGE_SHIFT);
> -			printk(KERN_DEBUG "remap_numa_kva: %08lx to pfn %08lx\n",
> -				(unsigned long)vaddr,
> -				node_remap_start_pfn[node] + pfn);
> -			set_pmd_pfn((ulong) vaddr,
> -				node_remap_start_pfn[node] + pfn,
> -				PAGE_KERNEL_LARGE);
> -		}
> -	}
> -}
> -
>   #ifdef CONFIG_HIBERNATION
>   /**
>    * resume_map_numa_kva - add KVA mapping to the temporary page tables created
> @@ -262,7 +242,7 @@ void resume_map_numa_kva(pgd_t *pgd_base)
>
>   static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
>   {
> -	unsigned long size;
> +	unsigned long size, pfn;
>   	u64 node_pa, remap_pa;
>   	void *remap_va;
>
> @@ -308,6 +288,12 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
>   	memblock_x86_reserve_range(remap_pa, remap_pa + size, "KVA PG");
>   	remap_va = phys_to_virt(remap_pa);
>
> +	/* perform actual remap */
> +	for (pfn = 0; pfn<  size>>  PAGE_SHIFT; pfn += PTRS_PER_PTE)
> +		set_pmd_pfn((unsigned long)remap_va + (pfn<<  PAGE_SHIFT),
> +			    (node_pa>>  PAGE_SHIFT) + pfn,
> +			    PAGE_KERNEL_LARGE);
> +
>   	/* initialize remap allocator parameters */
>   	node_remap_start_pfn[nid] = node_pa>>  PAGE_SHIFT;
>   	node_remap_size[nid] = size>>  PAGE_SHIFT;
> @@ -363,7 +349,6 @@ void __init initmem_init(void)
>   			(ulong) pfn_to_kaddr(max_low_pfn));
>   	for_each_online_node(nid)
>   		allocate_pgdat(nid);
> -	remap_numa_kva();
>
>   	printk(KERN_DEBUG "High memory starts at vaddr %08lx\n",
>   			(ulong) pfn_to_kaddr(highstart_pfn));

Acked-by: Yinghai Lu <yinghai@kernel.org>
