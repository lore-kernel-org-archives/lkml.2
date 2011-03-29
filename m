Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab1C2SQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 14:16:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60305 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab1C2SQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 14:16:15 -0400
Message-ID: <4D9221DA.90900@kernel.org>
Date: Tue, 29 Mar 2011 11:15:54 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: another pagetable initialization crash on xen
References: <alpine.DEB.2.00.1103281729190.5516@kaball-desktop> <alpine.DEB.2.00.1103281929390.5516@kaball-desktop> <alpine.DEB.2.00.1103291620560.16492@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1103291620560.16492@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D9221EA.0114,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 10:25 AM, Stefano Stabellini wrote:
> I kept working on refactoring this code, and I think I was able to come
> up with a slightly better patch.
> Do you think this is acceptable?
>
>
>
> commit c576ff205060e92b36224e80a989492b245e806d
> Author: Stefano Stabellini<stefano.stabellini@eu.citrix.com>
> Date:   Tue Mar 29 10:59:02 2011 +0000
>
>      x86: introduce kernel_pagetable hooks
>
>      Introduce two new pvop hooks:
>
>      - kernel_pagetable_alloc is used to allocate the initial kernel
>      pagetable pages;
>
>      - kernel_pagetable_reserve is used to reserved the kernel pagetable
>      memory range;
>
>      Signed-off-by: Stefano Stabellini<stefano.stabellini@eu.citrix.com>
>
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index 7db7723..a3ab967 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -299,6 +299,12 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
>   /* Install a pte for a particular vaddr in kernel space. */
>   void set_pte_vaddr(unsigned long vaddr, pte_t pte);
>
> +struct map_range;
> +void native_kernel_pagetable_alloc(struct map_range *mr,
> +		unsigned long *pgt_start,
> +		unsigned long *pgt_top);
> +void native_kernel_pagetable_reserve(unsigned long pgt_start,
> +		unsigned long pgt_end);
>   #ifdef CONFIG_X86_32
>   extern void native_pagetable_setup_start(pgd_t *base);
>   extern void native_pagetable_setup_done(pgd_t *base);
> diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
> index 643ebf2..984ce6f 100644
> --- a/arch/x86/include/asm/x86_init.h
> +++ b/arch/x86/include/asm/x86_init.h
> @@ -69,10 +69,26 @@ struct x86_init_oem {
>
>   /**
>    * struct x86_init_paging - platform specific paging functions
> + * @kernel_pagetable_alloc:	platform specific kernel pagetable
> + *                                      allocation function
> + * @kernel_pagetable_reserve:	platform specific kernel pagetable
> + *                                      reserve memory function
>    * @pagetable_setup_start:	platform specific pre paging_init() call
>    * @pagetable_setup_done:	platform specific post paging_init() call
>    */
>   struct x86_init_paging {
> +	/* @mr:     (in) memory range to map
> +	 * @pgt_start - @pgt_top:  (out) memory allocated for the kernel
> +	 *								pagetable pages
> +	 */
> +	void (*kernel_pagetable_alloc)(struct map_range *mr,
> +		unsigned long *pgt_start,
> +		unsigned long *pgt_top);
> +	/* @pgt_start - @pgt_end: memory region used for the kernel
> +	 *							pagetable pages
> +	 */
> +	void (*kernel_pagetable_reserve)(unsigned long pgt_start,
> +			unsigned long pgt_end);
>   	void (*pagetable_setup_start)(pgd_t *base);
>   	void (*pagetable_setup_done)(pgd_t *base);
>   };
> diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
> index c11514e..1048a3d 100644
> --- a/arch/x86/kernel/x86_init.c
> +++ b/arch/x86/kernel/x86_init.c
> @@ -62,6 +62,8 @@ struct x86_init_ops x86_init __initdata = {
>   	},
>
>   	.paging = {
> +		.kernel_pagetable_alloc = native_kernel_pagetable_alloc,
> +		.kernel_pagetable_reserve = native_kernel_pagetable_reserve,
>   		.pagetable_setup_start	= native_pagetable_setup_start,
>   		.pagetable_setup_done	= native_pagetable_setup_done,
>   	},
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 286d289..67d0792 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -30,11 +30,21 @@ int direct_gbpages
>   #endif
>   ;
>
> -static void __init find_early_table_space(unsigned long end, int use_pse,
> -					  int use_gbpages)
> +struct map_range {
> +	unsigned long start;
> +	unsigned long end;
> +	unsigned page_size_mask;
> +};
> +
> +void __init native_kernel_pagetable_alloc(struct map_range *mr,
> +		unsigned long *pgt_start,
> +		unsigned long *pgt_top)
>   {
> -	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
> +	unsigned long puds, pmds, ptes, tables, start = 0,
> +	end = mr->end, good_end = end;
>   	phys_addr_t base;
> +	int use_pse = mr->page_size_mask&  PG_LEVEL_2M;
> +	int use_gbpages = mr->page_size_mask&  PG_LEVEL_1G;
>
>   	puds = (end + PUD_SIZE - 1)>>  PUD_SHIFT;
>   	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
> @@ -73,19 +83,20 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
>   	if (base == MEMBLOCK_ERROR)
>   		panic("Cannot find space for the kernel page tables");
>
> -	pgt_buf_start = base>>  PAGE_SHIFT;
> -	pgt_buf_end = pgt_buf_start;
> -	pgt_buf_top = pgt_buf_start + (tables>>  PAGE_SHIFT);
> +	*pgt_start = base>>  PAGE_SHIFT;
> +	*pgt_top = *pgt_start + (tables>>  PAGE_SHIFT);
>
>   	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
> -		end, pgt_buf_start<<  PAGE_SHIFT, pgt_buf_top<<  PAGE_SHIFT);
> +		end, *pgt_start<<  PAGE_SHIFT, *pgt_top<<  PAGE_SHIFT);
>   }
>
> -struct map_range {
> -	unsigned long start;
> -	unsigned long end;
> -	unsigned page_size_mask;
> -};
> +void __init native_kernel_pagetable_reserve(unsigned long pgt_start,
> +		unsigned long pgt_end)
> +{
> +	if (pgt_start>  pgt_end)
> +		memblock_x86_reserve_range(pgt_start<<  PAGE_SHIFT,
> +				pgt_end<<  PAGE_SHIFT, "PGTABLE");
> +}
>
>   #ifdef CONFIG_X86_32
>   #define NR_RANGE_MR 3
> @@ -257,9 +268,15 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>   	 * memory mapped. Unfortunately this is done currently before the
>   	 * nodes are discovered.
>   	 */
> -	if (!after_bootmem)
> -		find_early_table_space(end, use_pse, use_gbpages);
> -
> +	if (!after_bootmem) {
> +		struct map_range map;
> +		map.start = start;
> +		map.end = end;
> +		map.page_size_mask = page_size_mask;
> +		x86_init.paging.kernel_pagetable_alloc(&map,&pgt_buf_start,&pgt_buf_top);
> +		pgt_buf_end = pgt_buf_start;
> +	}
> +		
>   	for (i = 0; i<  nr_range; i++)
>   		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
>   						   mr[i].page_size_mask);
> @@ -272,9 +289,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>
>   	__flush_tlb_all();
>
> -	if (!after_bootmem&&  pgt_buf_end>  pgt_buf_start)
> -		memblock_x86_reserve_range(pgt_buf_start<<  PAGE_SHIFT,
> -				 pgt_buf_end<<  PAGE_SHIFT, "PGTABLE");
> +	if (!after_bootmem)
> +		x86_init.paging.kernel_pagetable_reserve(pgt_buf_start, pgt_buf_end);
>
>   	if (!after_bootmem)
>   		early_memtest(start, end);

1. x86_init.paging is the right place for those two functions?
2. native_kernel_pagetable_alloc... should be function that do FIND + RESERVE.
    or We just have one function : free_not_used with (pgt_buf_end, pgt_buf_top) ?

Thanks

Yinghai
