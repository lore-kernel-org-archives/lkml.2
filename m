Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab2JOHWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:22:48 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:60124 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2JOHWp convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Mon, 15 Oct 2012 03:22:45 -0400
Message-Id: <507BD5DF02000078000A13EE@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 15 Oct 2012 08:22:39 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matt Fleming" <matt.fleming@intel.com>
Cc: <mingo@kernel.org>, <x86@kernel.org>, <mjg@redhat.com>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86, mm: Include the entire kernel memory map
 in trampoline_pgd
References: <1349269157-25956-1-git-send-email-matt@console-pimps.org>
 <1349269157-25956-2-git-send-email-matt@console-pimps.org>
 <506C4C3A020000780008D041@nat28.tlf.novell.com>
 <1349273028.7223.35.camel@mfleming-mobl1.ger.corp.intel.com>
 <506D4988020000780009F86E@nat28.tlf.novell.com>
 <1349342304.15966.25.camel@mfleming-mobl1.ger.corp.intel.com>
 <506D7A93020000780009F98E@nat28.tlf.novell.com>
 <1349865920.15966.327.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1349865920.15966.327.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10.10.12 at 12:45, Matt Fleming <matt.fleming@intel.com> wrote:
> On Thu, 2012-10-04 at 11:01 +0100, Jan Beulich wrote:
>> >>> On 04.10.12 at 11:18, Matt Fleming <matt.fleming@intel.com> wrote:
>> > On Thu, 2012-10-04 at 07:32 +0100, Jan Beulich wrote:
>> >> Btw., once this set of yours is in - will I need to resubmit the
>> >> time handling patch that actually triggered this work, or will
>> >> you just reinstate it without further action on my part?
>> > 
>> > It's up to you. If you don't want to make any changes to your original
>> > patch then I'll just re-apply it on top of this series, updating the
>> > commit log to note why it got reverted and why it's now OK to re-apply.
>> 
>> Afaict no changes should be necessary (so long as the patch
>> still applies).
> 
> How does this look?

Perfectly fine - thanks!

Jan

> Matthew do you still want your Acked-by to be applied?
> 
> ---
> 
> From 194b1acd3f39e479c484a4aba50e034a2b58e0d6 Mon Sep 17 00:00:00 2001
> From: Jan Beulich <JBeulich@suse.com>
> Date: Fri, 25 May 2012 16:20:31 +0100
> Subject: [PATCH] x86-64/efi: Use EFI to deal with platform wall clock 
> (again)
> 
> Other than ix86, x86-64 on EFI so far didn't set the
> {g,s}et_wallclock accessors to the EFI routines, thus
> incorrectly using raw RTC accesses instead.
> 
> Simply removing the #ifdef around the respective code isn't
> enough, however: While so far early get-time calls were done in
> physical mode, this doesn't work properly for x86-64, as virtual
> addresses would still need to be set up for all runtime regions
> (which wasn't the case on the system I have access to), so
> instead the patch moves the call to efi_enter_virtual_mode()
> ahead (which in turn allows to drop all code related to calling
> efi-get-time in physical mode).
> 
> Additionally the earlier calling of efi_set_executable()
> requires the CPA code to cope, i.e. during early boot it must be
> avoided to call cpa_flush_array(), as the first thing this
> function does is a BUG_ON(irqs_disabled()).
> 
> Also make the two EFI functions in question here static -
> they're not being referenced elsewhere.
> 
> History:
> 
>     This commit was originally merged as bacef661acdb ("x86-64/efi:
>     Use EFI to deal with platform wall clock") but it resulted in some
>     ASUS machines no longer booting due to a firmware bug, and so was
>     reverted in f026cfa82f62. A pre-emptive fix for the buggy ASUS
>     firmware was merged in 03a1c254975e ("x86, efi: 1:1 pagetable
>     mapping for virtual EFI calls") so now this patch can be
>     reapplied.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Tested-by: Matt Fleming <matt.fleming@intel.com>
> Acked-by: Matthew Garrett <mjg@redhat.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com> [added commit history]
> ---
>  arch/x86/mm/pageattr.c      | 10 ++++++----
>  arch/x86/platform/efi/efi.c | 30 ++++--------------------------
>  include/linux/efi.h         |  2 --
>  init/main.c                 |  8 ++++----
>  4 files changed, 14 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index a718e0d..931930a 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -919,11 +919,13 @@ static int change_page_attr_set_clr(unsigned long 
> *addr, int numpages,
>  
>  	/*
>  	 * On success we use clflush, when the CPU supports it to
> -	 * avoid the wbindv. If the CPU does not support it and in the
> -	 * error case we fall back to cpa_flush_all (which uses
> -	 * wbindv):
> +	 * avoid the wbindv. If the CPU does not support it, in the
> +	 * error case, and during early boot (for EFI) we fall back
> +	 * to cpa_flush_all (which uses wbinvd):
>  	 */
> -	if (!ret && cpu_has_clflush) {
> +	if (early_boot_irqs_disabled)
> +		__cpa_flush_all((void *)(long)cache);
> +	else if (!ret && cpu_has_clflush) {
>  		if (cpa.flags & (CPA_PAGES_ARRAY | CPA_ARRAY)) {
>  			cpa_flush_array(addr, numpages, cache,
>  					cpa.flags, pages);
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index aded2a9..7578344 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -235,22 +235,7 @@ static efi_status_t __init 
> phys_efi_set_virtual_address_map(
>  	return status;
>  }
>  
> -static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
> -					     efi_time_cap_t *tc)
> -{
> -	unsigned long flags;
> -	efi_status_t status;
> -
> -	spin_lock_irqsave(&rtc_lock, flags);
> -	efi_call_phys_prelog();
> -	status = efi_call_phys2(efi_phys.get_time, virt_to_phys(tm),
> -				virt_to_phys(tc));
> -	efi_call_phys_epilog();
> -	spin_unlock_irqrestore(&rtc_lock, flags);
> -	return status;
> -}
> -
> -int efi_set_rtc_mmss(unsigned long nowtime)
> +static int efi_set_rtc_mmss(unsigned long nowtime)
>  {
>  	int real_seconds, real_minutes;
>  	efi_status_t 	status;
> @@ -279,7 +264,7 @@ int efi_set_rtc_mmss(unsigned long nowtime)
>  	return 0;
>  }
>  
> -unsigned long efi_get_time(void)
> +static unsigned long efi_get_time(void)
>  {
>  	efi_status_t status;
>  	efi_time_t eft;
> @@ -635,18 +620,13 @@ static int __init efi_runtime_init(void)
>  	}
>  	/*
>  	 * We will only need *early* access to the following
> -	 * two EFI runtime services before set_virtual_address_map
> +	 * EFI runtime service before set_virtual_address_map
>  	 * is invoked.
>  	 */
> -	efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
>  	efi_phys.set_virtual_address_map =
>  		(efi_set_virtual_address_map_t *)
>  		runtime->set_virtual_address_map;
> -	/*
> -	 * Make efi_get_time can be called before entering
> -	 * virtual mode.
> -	 */
> -	efi.get_time = phys_efi_get_time;
> +
>  	early_iounmap(runtime, sizeof(efi_runtime_services_t));
>  
>  	return 0;
> @@ -734,12 +714,10 @@ void __init efi_init(void)
>  		efi_enabled = 0;
>  		return;
>  	}
> -#ifdef CONFIG_X86_32
>  	if (efi_native) {
>  		x86_platform.get_wallclock = efi_get_time;
>  		x86_platform.set_wallclock = efi_set_rtc_mmss;
>  	}
> -#endif
>  
>  #if EFI_DEBUG
>  	print_efi_memmap();
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 337aefb..5e2308d 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -516,8 +516,6 @@ extern u64 efi_mem_attribute (unsigned long phys_addr, 
> unsigned long size);
>  extern int __init efi_uart_console_only (void);
>  extern void efi_initialize_iomem_resources(struct resource *code_resource,
>  		struct resource *data_resource, struct resource *bss_resource);
> -extern unsigned long efi_get_time(void);
> -extern int efi_set_rtc_mmss(unsigned long nowtime);
>  extern void efi_reserve_boot_services(void);
>  extern struct efi_memory_map memmap;
>  
> diff --git a/init/main.c b/init/main.c
> index db34c0e..5297109 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -461,6 +461,10 @@ static void __init mm_init(void)
>  	percpu_init_late();
>  	pgtable_cache_init();
>  	vmalloc_init();
> +#ifdef CONFIG_X86
> +	if (efi_enabled)
> +		efi_enter_virtual_mode();
> +#endif
>  }
>  
>  asmlinkage void __init start_kernel(void)
> @@ -602,10 +606,6 @@ asmlinkage void __init start_kernel(void)
>  	calibrate_delay();
>  	pidmap_init();
>  	anon_vma_init();
> -#ifdef CONFIG_X86
> -	if (efi_enabled)
> -		efi_enter_virtual_mode();
> -#endif
>  	thread_info_cache_init();
>  	cred_init();
>  	fork_init(totalram_pages);
> -- 
> 1.7.11.4


