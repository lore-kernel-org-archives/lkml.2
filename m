Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab1DLRlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:41:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22063 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab1DLRlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:41:17 -0400
Message-ID: <4DA48EA9.70109@kernel.org>
Date: Tue, 12 Apr 2011 10:40:57 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: stefano.stabellini@eu.citrix.com
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, jeremy@goop.org, hpa@linux.intel.com,
        mingo@elte.hu, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/4] x86,xen: introduce x86_init.mapping.pagetable_reserve
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop> <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DA48EAF.014F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2011 04:19 AM, stefano.stabellini@eu.citrix.com wrote:
> From: Stefano Stabellini<stefano.stabellini@eu.citrix.com>
>
> Introduce a new x86_init hook called pagetable_reserve that during the
> initial memory mapping is used to reserve a range of memory addresses for
> kernel pagetable usage.
>
> On native it just calls memblock_x86_reserve_range while on xen it also
> takes care of setting the spare memory previously allocated
> for kernel pagetable pages from RO to RW, so that it can be used for
> other purposes.
>
> Signed-off-by: Stefano Stabellini<stefano.stabellini@eu.citrix.com>
> Cc: Yinghai Lu<yinghai@kernel.org>
> Cc: H. Peter Anvin<hpa@zytor.com>
> Cc: Ingo Molnar<mingo@elte.hu>

Acked-by: Yinghai Lu <yinghai@kernel.org>

> ---
>   arch/x86/include/asm/pgtable_types.h |    1 +
>   arch/x86/include/asm/x86_init.h      |    9 +++++++++
>   arch/x86/kernel/x86_init.c           |    4 ++++
>   arch/x86/mm/init.c                   |    9 +++++++--
>   arch/x86/xen/mmu.c                   |   15 +++++++++++++++
>   5 files changed, 36 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index 7db7723..d56187c 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -299,6 +299,7 @@ int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
>   /* Install a pte for a particular vaddr in kernel space. */
>   void set_pte_vaddr(unsigned long vaddr, pte_t pte);
>
> +extern void native_pagetable_reserve(u64 start, u64 end);
>   #ifdef CONFIG_X86_32
>   extern void native_pagetable_setup_start(pgd_t *base);
>   extern void native_pagetable_setup_done(pgd_t *base);
> diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
> index 643ebf2..d66b3a2 100644
> --- a/arch/x86/include/asm/x86_init.h
> +++ b/arch/x86/include/asm/x86_init.h
> @@ -68,6 +68,14 @@ struct x86_init_oem {
>   };
>
>   /**
> + * struct x86_init_mapping - platform specific initial kernel pagetable setup
> + * @pagetable_reserve:	reserve a range of addresses for kernel pagetable usage
> + */
> +struct x86_init_mapping {
> +	void (*pagetable_reserve)(u64 start, u64 end);
> +};
> +
> +/**
>    * struct x86_init_paging - platform specific paging functions
>    * @pagetable_setup_start:	platform specific pre paging_init() call
>    * @pagetable_setup_done:	platform specific post paging_init() call
> @@ -123,6 +131,7 @@ struct x86_init_ops {
>   	struct x86_init_mpparse		mpparse;
>   	struct x86_init_irqs		irqs;
>   	struct x86_init_oem		oem;
> +	struct x86_init_mapping		mapping;
>   	struct x86_init_paging		paging;
>   	struct x86_init_timers		timers;
>   	struct x86_init_iommu		iommu;
> diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
> index c11514e..75ef4b1 100644
> --- a/arch/x86/kernel/x86_init.c
> +++ b/arch/x86/kernel/x86_init.c
> @@ -61,6 +61,10 @@ struct x86_init_ops x86_init __initdata = {
>   		.banner			= default_banner,
>   	},
>
> +	.mapping = {
> +		.pagetable_reserve		= native_pagetable_reserve,
> +	},
> +
>   	.paging = {
>   		.pagetable_setup_start	= native_pagetable_setup_start,
>   		.pagetable_setup_done	= native_pagetable_setup_done,
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 286d289..ed0650b 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -81,6 +81,11 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
>   		end, pgt_buf_start<<  PAGE_SHIFT, pgt_buf_top<<  PAGE_SHIFT);
>   }
>
> +void native_pagetable_reserve(u64 start, u64 end)
> +{
> +	memblock_x86_reserve_range(start, end, "PGTABLE");
> +}
> +
>   struct map_range {
>   	unsigned long start;
>   	unsigned long end;
> @@ -273,8 +278,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>   	__flush_tlb_all();
>
>   	if (!after_bootmem&&  pgt_buf_end>  pgt_buf_start)
> -		memblock_x86_reserve_range(pgt_buf_start<<  PAGE_SHIFT,
> -				 pgt_buf_end<<  PAGE_SHIFT, "PGTABLE");
> +		x86_init.mapping.pagetable_reserve(PFN_PHYS(pgt_buf_start),
> +				PFN_PHYS(pgt_buf_end));
>
>   	if (!after_bootmem)
>   		early_memtest(start, end);
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 6b833db..fec8680 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1275,6 +1275,20 @@ static __init void xen_pagetable_setup_start(pgd_t *base)
>   {
>   }
>
> +static __init void xen_mapping_pagetable_reserve(u64 start, u64 end)
> +{
> +	/* reserve the range used */
> +	memblock_x86_reserve_range(start, end, "PGTABLE");
> +
> +	/* set as RW the rest */
> +	printk(KERN_DEBUG "xen: setting RW the range %llx - %llx\n", end,
> +			PFN_PHYS(pgt_buf_top));
> +	while (end<  PFN_PHYS(pgt_buf_top)) {
> +		make_lowmem_page_readwrite(__va(end));
> +		end += PAGE_SIZE;
> +	}
> +}
> +

it would be more cleaner to xen code if you make mark start/end to RO, and not make them all before as RO.

Thanks

Yinghai Lu

