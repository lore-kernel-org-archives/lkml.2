Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab0LNDob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 22:44:31 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39290 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab0LNDoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 22:44:30 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4D06E7FE.5000600@jp.fujitsu.com>
Date: Tue, 14 Dec 2010 12:43:58 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Takao Indoh <indou.takao@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, vgoyal@redhat.com, nhorman@tuxdriver.com,
        horms@verge.net.au
Subject: Re: [PATCH v2][EFI] Run EFI in physical mode
References: <F7CB3D97D99F33indou.takao@jp.fujitsu.com>
In-Reply-To: <F7CB3D97D99F33indou.takao@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tested this patch on the system that has large amount of memory (1TB),
and I encountered the immediate system reset problem that happens every
time I modify the EFI boot entry using efibootmgr command. It seems that
triple fault happens due to the incorrect page table setup.

> +void __init efi_pagetable_init(void)
> +{
(snip.)
> +	pgd = efi_pgd + pgd_index(PAGE_OFFSET);
> +	set_pgd(pgd, *pgd_offset_k(PAGE_OFFSET));
> +	pgd = efi_pgd + pgd_index(__START_KERNEL_map);
> +	set_pgd(pgd, *pgd_offset_k(__START_KERNEL_map));
> +}

Maybe we need to map whole kernel address space. The problem doesn't
happen by modifying as follows.

	clone_pgd_range(efi_pgd + KERNEL_PGD_BOUNDARY,
			swapper_pg_dir + KERNEL_PGD_BOUNDARY, KERNEL_PGD_PTRS);

Regards,
Kenji Kaneshige



(2010/08/17 8:07), Takao Indoh wrote:
> Hi all,
>
> Thanks for many comments. I just changed some variables according to
> Huang's comment.
>
> On Mon, 16 Aug 2010 09:43:56 +0800, huang ying wrote:
>> efi_flags and save_cr3 should be per-CPU, because they now will be
>> used after SMP is enabled.
>
> Ok, what I should do next is:
>
> - x86 support
>       As I wrote, I don't have x86 machine where EFI works. Any
>       volunteer?
> - ia64 support
>       I'm not sure we should do this, but I'll try if we need.
> - Using common page tables instead of EFI own page table
>       Now I'm checking the thread below...
> http://marc.info/?i=1280940316-7966-1-git-send-email-bp@amd64.org
>
>
> Signed-off-by: Takao Indoh<indou.takao@jp.fujitsu.com>
> ---
>   arch/x86/include/asm/efi.h |    3
>   arch/x86/kernel/efi.c      |  142 ++++++++++++++++++++++++++++++++++-
>   arch/x86/kernel/efi_32.c   |    4
>   arch/x86/kernel/efi_64.c   |   96 ++++++++++++++++++++++-
>   include/linux/efi.h        |    1
>   include/linux/init.h       |    1
>   init/main.c                |   16 +++
>   7 files changed, 256 insertions(+), 7 deletions(-)
>
> diff -Nurp linux-2.6.35.org/arch/x86/include/asm/efi.h linux-2.6.35/arch/x86/include/asm/efi.h
> --- linux-2.6.35.org/arch/x86/include/asm/efi.h	2010-08-16 17:45:06.547622377 -0400
> +++ linux-2.6.35/arch/x86/include/asm/efi.h	2010-08-16 17:45:39.021626213 -0400
> @@ -93,6 +93,9 @@ extern int add_efi_memmap;
>   extern void efi_reserve_early(void);
>   extern void efi_call_phys_prelog(void);
>   extern void efi_call_phys_epilog(void);
> +extern void efi_call_phys_prelog_in_physmode(void);
> +extern void efi_call_phys_epilog_in_physmode(void);
> +extern void efi_pagetable_init(void);
>
>   #ifndef CONFIG_EFI
>   /*
> diff -Nurp linux-2.6.35.org/arch/x86/kernel/efi.c linux-2.6.35/arch/x86/kernel/efi.c
> --- linux-2.6.35.org/arch/x86/kernel/efi.c	2010-08-16 17:45:06.500622377 -0400
> +++ linux-2.6.35/arch/x86/kernel/efi.c	2010-08-16 17:45:39.022633025 -0400
> @@ -57,6 +57,7 @@ struct efi_memory_map memmap;
>
>   static struct efi efi_phys __initdata;
>   static efi_system_table_t efi_systab __initdata;
> +static efi_runtime_services_t phys_runtime;
>
>   static int __init setup_noefi(char *arg)
>   {
> @@ -171,7 +172,7 @@ static efi_status_t __init phys_efi_set_
>   	return status;
>   }
>
> -static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
> +static efi_status_t __init phys_efi_get_time_early(efi_time_t *tm,
>   					     efi_time_cap_t *tc)
>   {
>   	efi_status_t status;
> @@ -182,6 +183,112 @@ static efi_status_t __init phys_efi_get_
>   	return status;
>   }
>
> +static efi_status_t phys_efi_get_time(efi_time_t *tm,
> +				      efi_time_cap_t *tc)
> +{
> +	efi_status_t status;
> +
> +	efi_call_phys_prelog_in_physmode();
> +	status = efi_call_phys2((void*)phys_runtime.get_time, tm, tc);
> +	efi_call_phys_epilog_in_physmode();
> +	return status;
> +}
> +
> +static efi_status_t __init phys_efi_set_time(efi_time_t *tm)
> +{
> +	efi_status_t status;
> +
> +	efi_call_phys_prelog_in_physmode();
> +	status = efi_call_phys1((void*)phys_runtime.set_time, tm);
> +	efi_call_phys_epilog_in_physmode();
> +	return status;
> +}
> +
> +static efi_status_t phys_efi_get_wakeup_time(efi_bool_t *enabled,
> +                                             efi_bool_t *pending,
> +                                             efi_time_t *tm)
> +{
> +	efi_status_t status;
> +
> +	efi_call_phys_prelog_in_physmode();
> +	status = efi_call_phys3((void*)phys_runtime.get_wakeup_time, enabled,
> +				pending, tm);
> +	efi_call_phys_epilog_in_physmode();
> +	return status;
> +}
> +
> +static efi_status_t phys_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
> +{
> +	efi_status_t status;
> +	efi_call_phys_prelog_in_physmode();
> +	status = efi_call_phys2((void*)phys_runtime.set_wakeup_time, enabled,
> +				tm);
> +	efi_call_phys_epilog_in_physmode();
> +	return status;
> +}
> +
> +static efi_status_t phys_efi_get_variable(efi_char16_t *name,
> +					  efi_guid_t *vendor,
> +					  u32 *attr,
> +					  unsigned long *data_size,
> +					  void *data)
> +{
> +	efi_status_t status;
> +	efi_call_phys_prelog_in_physmode();
> +	status = efi_call_phys5((void*)phys_runtime.get_variable, name, vendor,
> +				attr, data_size, data);
> +	efi_call_phys_epilog_in_physmode();
> +	return status;
> +}
> +
> +static efi_status_t phys_efi_get_next_variable(unsigned long *name_size,
> +					       efi_char16_t *name,
> +					       efi_guid_t *vendor)
> +{
> +	efi_status_t status;
> +
> +	efi_call_phys_prelog_in_physmode();
> +	status = efi_call_phys3((void*)phys_runtime.get_next_variable,
> +				name_size, name, vendor);
> +	efi_call_phys_epilog_in_physmode();
> +	return status;
> +}
> +
> +static efi_status_t phys_efi_set_variable(efi_char16_t *name,
> +					  efi_guid_t *vendor,
> +					  unsigned long attr,
> +					  unsigned long data_size,
> +					  void *data)
> +{
> +	efi_status_t status;
> +	efi_call_phys_prelog_in_physmode();
> +	status = efi_call_phys5((void*)phys_runtime.set_variable, name,
> +				vendor, attr, data_size, data);
> +	efi_call_phys_epilog_in_physmode();
> +	return status;
> +}
> +
> +static efi_status_t phys_efi_get_next_high_mono_count(u32 *count)
> +{
> +	efi_status_t status;
> +	efi_call_phys_prelog_in_physmode();
> +	status = efi_call_phys1((void*)phys_runtime.get_next_high_mono_count,
> +				count);
> +	efi_call_phys_epilog_in_physmode();
> +	return status;
> +}
> +
> +static void phys_efi_reset_system(int reset_type,
> +                                  efi_status_t status,
> +                                  unsigned long data_size,
> +                                  efi_char16_t *data)
> +{
> +	efi_call_phys_prelog_in_physmode();
> +	efi_call_phys4((void*)phys_runtime.reset_system, reset_type, status,
> +				data_size, data);
> +	efi_call_phys_epilog_in_physmode();
> +}
> +
>   int efi_set_rtc_mmss(unsigned long nowtime)
>   {
>   	int real_seconds, real_minutes;
> @@ -434,7 +541,9 @@ void __init efi_init(void)
>   		 * Make efi_get_time can be called before entering
>   		 * virtual mode.
>   		 */
> -		efi.get_time = phys_efi_get_time;
> +		efi.get_time = phys_efi_get_time_early;
> +
> +		memcpy(&phys_runtime, runtime, sizeof(efi_runtime_services_t));
>   	} else
>   		printk(KERN_ERR "Could not map the EFI runtime service "
>   		       "table!\n");
> @@ -465,6 +574,14 @@ void __init efi_init(void)
>   #if EFI_DEBUG
>   	print_efi_memmap();
>   #endif
> +
> +#ifndef CONFIG_X86_64
> +	/*
> +	 * Only x86_64 supports physical mode as of now. Use virtual mode
> +	 * forcibly.
> +	 */
> +	usevirtefi = 1;
> +#endif
>   }
>
>   static void __init runtime_code_page_mkexec(void)
> @@ -578,6 +695,27 @@ void __init efi_enter_virtual_mode(void)
>   	memmap.map = NULL;
>   }
>
> +void __init efi_setup_physical_mode(void)
> +{
> +#ifdef CONFIG_X86_64
> +	efi_pagetable_init();
> +#endif
> +	efi.get_time = phys_efi_get_time;
> +	efi.set_time = phys_efi_set_time;
> +	efi.get_wakeup_time = phys_efi_get_wakeup_time;
> +	efi.set_wakeup_time = phys_efi_set_wakeup_time;
> +	efi.get_variable = phys_efi_get_variable;
> +	efi.get_next_variable = phys_efi_get_next_variable;
> +	efi.set_variable = phys_efi_set_variable;
> +	efi.get_next_high_mono_count =
> +		phys_efi_get_next_high_mono_count;
> +	efi.reset_system = phys_efi_reset_system;
> +	efi.set_virtual_address_map = NULL; /* Not needed */
> +
> +	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
> +	memmap.map = NULL;
> +}
> +
>   /*
>    * Convenience functions to obtain memory types and attributes
>    */
> diff -Nurp linux-2.6.35.org/arch/x86/kernel/efi_32.c linux-2.6.35/arch/x86/kernel/efi_32.c
> --- linux-2.6.35.org/arch/x86/kernel/efi_32.c	2010-08-16 17:45:06.522621888 -0400
> +++ linux-2.6.35/arch/x86/kernel/efi_32.c	2010-08-16 17:45:39.022633025 -0400
> @@ -110,3 +110,7 @@ void efi_call_phys_epilog(void)
>
>   	local_irq_restore(efi_rt_eflags);
>   }
> +
> +void efi_call_phys_prelog_in_physmode(void) { /* Not supported */ }
> +void efi_call_phys_epilog_in_physmode(void) { /* Not supported */ }
> +
> diff -Nurp linux-2.6.35.org/arch/x86/kernel/efi_64.c linux-2.6.35/arch/x86/kernel/efi_64.c
> --- linux-2.6.35.org/arch/x86/kernel/efi_64.c	2010-08-16 17:45:06.499622447 -0400
> +++ linux-2.6.35/arch/x86/kernel/efi_64.c	2010-08-16 17:45:39.023650384 -0400
> @@ -39,7 +39,9 @@
>   #include<asm/fixmap.h>
>
>   static pgd_t save_pgd __initdata;
> -static unsigned long efi_flags __initdata;
> +static DEFINE_PER_CPU(unsigned long, efi_flags);
> +static DEFINE_PER_CPU(unsigned long, save_cr3);
> +static pgd_t efi_pgd[PTRS_PER_PGD] __page_aligned_bss;
>
>   static void __init early_mapping_set_exec(unsigned long start,
>   					  unsigned long end,
> @@ -80,7 +82,7 @@ void __init efi_call_phys_prelog(void)
>   	unsigned long vaddress;
>
>   	early_runtime_code_mapping_set_exec(1);
> -	local_irq_save(efi_flags);
> +	local_irq_save(get_cpu_var(efi_flags));
>   	vaddress = (unsigned long)__va(0x0UL);
>   	save_pgd = *pgd_offset_k(0x0UL);
>   	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
> @@ -94,10 +96,23 @@ void __init efi_call_phys_epilog(void)
>   	 */
>   	set_pgd(pgd_offset_k(0x0UL), save_pgd);
>   	__flush_tlb_all();
> -	local_irq_restore(efi_flags);
> +	local_irq_restore(get_cpu_var(efi_flags));
>   	early_runtime_code_mapping_set_exec(0);
>   }
>
> +void efi_call_phys_prelog_in_physmode(void)
> +{
> +	local_irq_save(get_cpu_var(efi_flags));
> +	get_cpu_var(save_cr3)= read_cr3();
> +	write_cr3(virt_to_phys(efi_pgd));
> +}
> +
> +void efi_call_phys_epilog_in_physmode(void)
> +{
> +	write_cr3(get_cpu_var(save_cr3));
> +	local_irq_restore(get_cpu_var(efi_flags));
> +}
> +
>   void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
>   				 u32 type)
>   {
> @@ -112,3 +127,78 @@ void __iomem *__init efi_ioremap(unsigne
>
>   	return (void __iomem *)__va(phys_addr);
>   }
> +
> +static pud_t *fill_pud(pgd_t *pgd, unsigned long vaddr)
> +{
> +	if (pgd_none(*pgd)) {
> +		pud_t *pud = (pud_t *)get_zeroed_page(GFP_ATOMIC);
> +		set_pgd(pgd, __pgd(_PAGE_TABLE | __pa(pud)));
> +		if (pud != pud_offset(pgd, 0))
> +			printk(KERN_ERR "EFI PAGETABLE BUG #00! %p<->  %p\n",
> +			       pud, pud_offset(pgd, 0));
> +	}
> +	return pud_offset(pgd, vaddr);
> +}
> +
> +static pmd_t *fill_pmd(pud_t *pud, unsigned long vaddr)
> +{
> +	if (pud_none(*pud)) {
> +		pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_ATOMIC);
> +		set_pud(pud, __pud(_PAGE_TABLE | __pa(pmd)));
> +		if (pmd != pmd_offset(pud, 0))
> +			printk(KERN_ERR "EFI PAGETABLE BUG #01! %p<->  %p\n",
> +			       pmd, pmd_offset(pud, 0));
> +	}
> +	return pmd_offset(pud, vaddr);
> +}
> +
> +static pte_t *fill_pte(pmd_t *pmd, unsigned long vaddr)
> +{
> +	if (pmd_none(*pmd)) {
> +		pte_t *pte = (pte_t *)get_zeroed_page(GFP_ATOMIC);
> +		set_pmd(pmd, __pmd(_PAGE_TABLE | __pa(pte)));
> +		if (pte != pte_offset_kernel(pmd, 0))
> +			printk(KERN_ERR "EFI PAGETABLE BUG #02!\n");
> +	}
> +	return pte_offset_kernel(pmd, vaddr);
> +}
> +
> +void __init efi_pagetable_init(void)
> +{
> +	efi_memory_desc_t *md;
> +	unsigned long size;
> +	u64 start_pfn, end_pfn, pfn, vaddr;
> +	void *p;
> +	pgd_t *pgd;
> +	pud_t *pud;
> +	pmd_t *pmd;
> +	pte_t *pte;
> +
> +	memset(efi_pgd, 0, sizeof(efi_pgd));
> +	for (p = memmap.map; p<  memmap.map_end; p += memmap.desc_size) {
> +		md = p;
> +		if (!(md->type&  EFI_RUNTIME_SERVICES_CODE)&&
> +		    !(md->type&  EFI_RUNTIME_SERVICES_DATA))
> +			continue;
> +
> +		start_pfn = md->phys_addr>>  PAGE_SHIFT;
> +		size = md->num_pages<<  EFI_PAGE_SHIFT;
> +		end_pfn = PFN_UP(md->phys_addr + size);
> +
> +		for (pfn = start_pfn; pfn<= end_pfn; pfn++) {
> +			vaddr = pfn<<  PAGE_SHIFT;
> +			pgd = efi_pgd + pgd_index(vaddr);
> +			pud = fill_pud(pgd, vaddr);
> +			pmd = fill_pmd(pud, vaddr);
> +			pte = fill_pte(pmd, vaddr);
> +			if (md->type&  EFI_RUNTIME_SERVICES_CODE)
> +				set_pte(pte, pfn_pte(pfn, PAGE_KERNEL_EXEC));
> +			else
> +				set_pte(pte, pfn_pte(pfn, PAGE_KERNEL));
> +		}
> +	}
> +	pgd = efi_pgd + pgd_index(PAGE_OFFSET);
> +	set_pgd(pgd, *pgd_offset_k(PAGE_OFFSET));
> +	pgd = efi_pgd + pgd_index(__START_KERNEL_map);
> +	set_pgd(pgd, *pgd_offset_k(__START_KERNEL_map));
> +}
> diff -Nurp linux-2.6.35.org/include/linux/efi.h linux-2.6.35/include/linux/efi.h
> --- linux-2.6.35.org/include/linux/efi.h	2010-08-16 17:45:06.015622308 -0400
> +++ linux-2.6.35/include/linux/efi.h	2010-08-16 17:45:39.023650384 -0400
> @@ -290,6 +290,7 @@ extern void efi_map_pal_code (void);
>   extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
>   extern void efi_gettimeofday (struct timespec *ts);
>   extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
> +extern void efi_setup_physical_mode(void);
>   extern u64 efi_get_iobase (void);
>   extern u32 efi_mem_type (unsigned long phys_addr);
>   extern u64 efi_mem_attributes (unsigned long phys_addr);
> diff -Nurp linux-2.6.35.org/include/linux/init.h linux-2.6.35/include/linux/init.h
> --- linux-2.6.35.org/include/linux/init.h	2010-08-16 17:45:06.059622448 -0400
> +++ linux-2.6.35/include/linux/init.h	2010-08-16 17:45:39.024651054 -0400
> @@ -142,6 +142,7 @@ extern int do_one_initcall(initcall_t fn
>   extern char __initdata boot_command_line[];
>   extern char *saved_command_line;
>   extern unsigned int reset_devices;
> +extern unsigned int usevirtefi;
>
>   /* used by init/main.c */
>   void setup_arch(char **);
> diff -Nurp linux-2.6.35.org/init/main.c linux-2.6.35/init/main.c
> --- linux-2.6.35.org/init/main.c	2010-08-16 17:45:05.729683838 -0400
> +++ linux-2.6.35/init/main.c	2010-08-16 17:45:39.025650051 -0400
> @@ -200,6 +200,14 @@ static int __init set_reset_devices(char
>
>   __setup("reset_devices", set_reset_devices);
>
> +unsigned int usevirtefi;
> +static int __init set_virt_efi(char *str)
> +{
> +	usevirtefi = 1;
> +	return 1;
> +}
> +__setup("virtefi", set_virt_efi);
> +
>   static char * argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
>   char * envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
>   static const char *panic_later, *panic_param;
> @@ -676,8 +684,12 @@ asmlinkage void __init start_kernel(void
>   	pidmap_init();
>   	anon_vma_init();
>   #ifdef CONFIG_X86
> -	if (efi_enabled)
> -		efi_enter_virtual_mode();
> +	if (efi_enabled) {
> +		if (usevirtefi)
> +			efi_enter_virtual_mode();
> +		else
> +			efi_setup_physical_mode();
> +	}
>   #endif
>   	thread_info_cache_init();
>   	cred_init();
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>


