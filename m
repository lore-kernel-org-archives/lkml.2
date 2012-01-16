Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab2APJWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 04:22:48 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:48908 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753592Ab2APJWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 04:22:45 -0500
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
From: Matt Fleming <matt@console-pimps.org>
To: Keith Packard <keithp@keithp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1323962963.314.14.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1323648762-2148-1-git-send-email-keithp@keithp.com>
	 <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com>
	 <867h22jwj1.fsf@sumi.keithp.com> <4EE575E3.7090206@zytor.com>
	 <8639cqjvyn.fsf@sumi.keithp.com>
	 <1323684083.3669.15.camel@mfleming-mobl1.ger.corp.intel.com>
	 <86sjkpiw8i.fsf@sumi.keithp.com>
	 <1323962963.314.14.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jan 2012 09:22:37 +0000
Message-ID: <1326705757.3629.18.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On Thu, 2011-12-15 at 15:29 +0000, Matt Fleming wrote:
> On Mon, 2011-12-12 at 08:35 -0800, Keith Packard wrote:
> > On Mon, 12 Dec 2011 10:01:23 +0000, Matt Fleming <matt@console-pimps.org> wrote:
> > 
> > > How about the dmesg from a kernel with this revert applied?
> > 
> > Happy to oblige. Here's the first few seconds (until X starts):
> 
> Thanks Keith. I think I see what the problem is now. Your memory map
> shows that there are some regions that need runtime mappings that
> weren't being setup with the original patch because they're not of type
> EFI_RUNTIME_SERVICES_DATA. What the patch should do is check for the
> EFI_MEMORY_RUNTIME attribute.
> 
> Can you try this patch and see if your MacBook Air still boots?
> 
> From 58994e0a535af52faec068cf030069672107cae0 Mon Sep 17 00:00:00 2001
> From: Matt Fleming <matt.fleming@intel.com>
> Date: Mon, 10 Oct 2011 13:30:03 +0100
> Subject: [PATCH] x86, efi: Delete efi_ioremap() and fix CONFIG_X86_32 oops
> 
> This patch reimplements the fix from e8c7106280a3 ("x86, efi: Calling
> __pa() with an ioremap()ed address is invalid") which was reverted in
> e1ad783b12ec because it caused a regression on some MacBooks (they
> hung at boot). The regression was caused because the commit only
> marked EFI_RUNTIME_SERVICES_DATA as E820_RESERVED_EFI, when it should
> have marked all regions that have the EFI_MEMORY_RUNTIME attribute.
> 
> Calling __pa() with an ioremap'd address is invalid. If we encounter
> an efi_memory_desc_t without EFI_MEMORY_WB set in ->attribute we
> currently call set_memory_uc(), which in turn calls __pa() on a
> potentially ioremap'd address. On CONFIG_X86_32 this results in the
> following oops,
> 
>   BUG: unable to handle kernel paging request at f7f22280
>   IP: [<c10257b9>] reserve_ram_pages_type+0x89/0x210
>   *pdpt = 0000000001978001 *pde = 0000000001ffb067 *pte = 0000000000000000
>   Oops: 0000 [#1] PREEMPT SMP
>   Modules linked in:
> 
>   Pid: 0, comm: swapper Not tainted 3.0.0-acpi-efi-0805 #3
>    EIP: 0060:[<c10257b9>] EFLAGS: 00010202 CPU: 0
>    EIP is at reserve_ram_pages_type+0x89/0x210
>    EAX: 0070e280 EBX: 38714000 ECX: f7814000 EDX: 00000000
>    ESI: 00000000 EDI: 38715000 EBP: c189fef0 ESP: c189fea8
>    DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
>   Process swapper (pid: 0, ti=c189e000 task=c18bbe60 task.ti=c189e000)
>   Stack:
>    80000200 ff108000 00000000 c189ff00 00038714 00000000 00000000 c189fed0
>    c104f8ca 00038714 00000000 00038715 00000000 00000000 00038715 00000000
>    00000010 38715000 c189ff48 c1025aff 38715000 00000000 00000010 00000000
>   Call Trace:
>    [<c104f8ca>] ? page_is_ram+0x1a/0x40
>    [<c1025aff>] reserve_memtype+0xdf/0x2f0
>    [<c1024dc9>] set_memory_uc+0x49/0xa0
>    [<c19334d0>] efi_enter_virtual_mode+0x1c2/0x3aa
>    [<c19216d4>] start_kernel+0x291/0x2f2
>    [<c19211c7>] ? loglevel+0x1b/0x1b
>    [<c19210bf>] i386_start_kernel+0xbf/0xc8
> 
> A better approach to this problem is to map the memory region with the
> correct attributes from the start, instead of modifying them after the
> fact.
> 
> Despite first impressions, it's not possible to use ioremap_cache() to
> map all cached memory regions on CONFIG_X86_64 because of the way that
> the memory map might be configured as detailed in the following bug
> report,
> 
> 	https://bugzilla.redhat.com/show_bug.cgi?id=748516
> 
> Therefore, we need to ensure that any regions requiring a runtime
> mapping are covered by the direct kernel mapping table. Previously,
> this was taken care of by efi_ioremap() but if we handle this case
> earlier, in setup_arch(), we can delete the CONFIG_X86_32 and
> CONFIG_X86_64 efi_ioremap() implementations entirely.
> 
> To accomplish this we now mark any regions that need a runtime mapping
> as E820_RESERVED_EFI and map them via the direct kernel mapping in
> setup_arch().
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Huang Ying <huang.ying.caritas@gmail.com>
> Cc: Keith Packard <keithp@keithp.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/x86/include/asm/e820.h    |    7 +++++++
>  arch/x86/include/asm/efi.h     |    5 -----
>  arch/x86/kernel/e820.c         |    3 ++-
>  arch/x86/kernel/setup.c        |   21 ++++++++++++++++++++-
>  arch/x86/platform/efi/efi.c    |   37 ++++++++++++++++++++++++-------------
>  arch/x86/platform/efi/efi_64.c |   17 -----------------
>  6 files changed, 53 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
> index 908b969..bc0a9c0 100644
> --- a/arch/x86/include/asm/e820.h
> +++ b/arch/x86/include/asm/e820.h
> @@ -53,6 +53,12 @@
>   */
>  #define E820_RESERVED_KERN        128
>  
> +/*
> + * Address ranges that need to be mapped by the kernel direct mapping
> + * because they require a runtime mapping. See setup_arch().
> + */
> +#define E820_RESERVED_EFI         129
> +
>  #ifndef __ASSEMBLY__
>  #include <linux/types.h>
>  struct e820entry {
> @@ -115,6 +121,7 @@ static inline void early_memtest(unsigned long start, unsigned long end)
>  }
>  #endif
>  
> +extern unsigned long e820_end_pfn(unsigned long limit_pfn, unsigned type);
>  extern unsigned long e820_end_of_ram_pfn(void);
>  extern unsigned long e820_end_of_low_ram_pfn(void);
>  extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 7093e4a..b8d8bfc 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -33,8 +33,6 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
>  #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
>  	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
>  
> -#define efi_ioremap(addr, size, type)		ioremap_cache(addr, size)
> -
>  #else /* !CONFIG_X86_32 */
>  
>  extern u64 efi_call0(void *fp);
> @@ -84,9 +82,6 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
>  	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
>  		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
>  
> -extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
> -				 u32 type);
> -
>  #endif /* CONFIG_X86_32 */
>  
>  extern int add_efi_memmap;
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index 303a0e4..65ffd11 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -135,6 +135,7 @@ static void __init e820_print_type(u32 type)
>  		printk(KERN_CONT "(usable)");
>  		break;
>  	case E820_RESERVED:
> +	case E820_RESERVED_EFI:
>  		printk(KERN_CONT "(reserved)");
>  		break;
>  	case E820_ACPI:
> @@ -783,7 +784,7 @@ u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
>  /*
>   * Find the highest page frame number we have available
>   */
> -static unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
> +unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
>  {
>  	int i;
>  	unsigned long last_pfn = 0;
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index afaf384..28c2402 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -691,6 +691,8 @@ early_param("reservelow", parse_reservelow);
>  
>  void __init setup_arch(char **cmdline_p)
>  {
> +	unsigned long end_pfn;
> +
>  #ifdef CONFIG_X86_32
>  	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
>  	visws_early_detect();
> @@ -932,7 +934,24 @@ void __init setup_arch(char **cmdline_p)
>  	init_gbpages();
>  
>  	/* max_pfn_mapped is updated here */
> -	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
> +	end_pfn = max_low_pfn;
> +
> +#ifdef CONFIG_X86_64
> +	/*
> +	 * There may be regions after the last E820_RAM region that we
> +	 * want to include in the kernel direct mapping because their
> +	 * contents are needed at runtime.
> +	 */
> +	if (efi_enabled) {
> +		unsigned long efi_end;
> +
> +		efi_end = e820_end_pfn(MAXMEM>>PAGE_SHIFT, E820_RESERVED_EFI);
> +		if (efi_end > end_pfn)
> +			end_pfn = efi_end;
> +	}
> +#endif
> +
> +	max_low_pfn_mapped = init_memory_mapping(0, end_pfn << PAGE_SHIFT);
>  	max_pfn_mapped = max_low_pfn_mapped;
>  
>  #ifdef CONFIG_X86_64
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 37718f0..f5c22d4 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -323,13 +323,20 @@ static void __init do_add_efi_memmap(void)
>  		case EFI_UNUSABLE_MEMORY:
>  			e820_type = E820_UNUSABLE;
>  			break;
> +		case EFI_MEMORY_MAPPED_IO:
> +		case EFI_MEMORY_MAPPED_IO_PORT_SPACE:
> +			e820_type = E820_RESERVED;
> +			break;
>  		default:
>  			/*
>  			 * EFI_RESERVED_TYPE EFI_RUNTIME_SERVICES_CODE
> -			 * EFI_RUNTIME_SERVICES_DATA EFI_MEMORY_MAPPED_IO
> -			 * EFI_MEMORY_MAPPED_IO_PORT_SPACE EFI_PAL_CODE
> +			 * EFI_RUNTIME_SERVICES_DATA
> +			 * EFI_PAL_CODE
>  			 */
> -			e820_type = E820_RESERVED;
> +			if (md->attribute & EFI_MEMORY_RUNTIME)
> +				e820_type = E820_RESERVED_EFI;
> +			else
> +				e820_type = E820_RESERVED;
>  			break;
>  		}
>  		e820_add_region(start, size, e820_type);
> @@ -671,10 +678,21 @@ void __init efi_enter_virtual_mode(void)
>  		end_pfn = PFN_UP(end);
>  		if (end_pfn <= max_low_pfn_mapped
>  		    || (end_pfn > (1UL << (32 - PAGE_SHIFT))
> -			&& end_pfn <= max_pfn_mapped))
> +			&& end_pfn <= max_pfn_mapped)) {
>  			va = __va(md->phys_addr);
> -		else
> -			va = efi_ioremap(md->phys_addr, size, md->type);
> +
> +			if (!(md->attribute & EFI_MEMORY_WB)) {
> +				addr = (u64) (unsigned long)va;
> +				npages = md->num_pages;
> +				memrange_efi_to_native(&addr, &npages);
> +				set_memory_uc(addr, npages);
> +			}
> +		} else {
> +			if (!(md->attribute & EFI_MEMORY_WB))
> +				va = ioremap_nocache(md->phys_addr, size);
> +			else
> +				va = ioremap_cache(md->phys_addr, size);
> +		}
>  
>  		md->virt_addr = (u64) (unsigned long) va;
>  
> @@ -684,13 +702,6 @@ void __init efi_enter_virtual_mode(void)
>  			continue;
>  		}
>  
> -		if (!(md->attribute & EFI_MEMORY_WB)) {
> -			addr = md->virt_addr;
> -			npages = md->num_pages;
> -			memrange_efi_to_native(&addr, &npages);
> -			set_memory_uc(addr, npages);
> -		}
> -
>  		systab = (u64) (unsigned long) efi_phys.systab;
>  		if (md->phys_addr <= systab && systab < end) {
>  			systab += md->virt_addr - md->phys_addr;
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index ac3aa54..312250c 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -80,20 +80,3 @@ void __init efi_call_phys_epilog(void)
>  	local_irq_restore(efi_flags);
>  	early_code_mapping_set_exec(0);
>  }
> -
> -void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
> -				 u32 type)
> -{
> -	unsigned long last_map_pfn;
> -
> -	if (type == EFI_MEMORY_MAPPED_IO)
> -		return ioremap(phys_addr, size);
> -
> -	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
> -	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size) {
> -		unsigned long top = last_map_pfn << PAGE_SHIFT;
> -		efi_ioremap(top, size - (top - phys_addr), type);
> -	}
> -
> -	return (void __iomem *)__va(phys_addr);
> -}


-- 
Matt Fleming, Intel Open Source Technology Center

