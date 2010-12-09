Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab0LIRw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:52:27 -0500
Received: from claw.goop.org ([74.207.240.146]:35578 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756208Ab0LIRw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:52:26 -0500
Message-ID: <4D011758.6010501@goop.org>
Date: Thu, 09 Dec 2010 09:52:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH RFC] x86: initialize initial_page_table before paravirt
 jumps
References: <201012091229.46430.rusty@rustcorp.com.au>
In-Reply-To: <201012091229.46430.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 05:59 PM, Rusty Russell wrote:
> As of v2.6.36-rc8-54-gb40827f, initial_page_table needs to be set up to boot.
> My initial fix for lguest was to cut & paste in the initialization code, but
> as it's simply byte-twiddling (which could be done at compile time if we
> were clever enough), it seems better to do it unconditionally.
>
> Jeremy, Ingo does this make sense to you?  Given it's rc5, I have an
> lguest-specific patch ready as an alternative...

We have already committed a Xen-specific fix for this (twice!).  Your
patch is a no-op for Xen because we never ended up using that entry path
through head_32.S, so if it fixes things for lguest then go for it.

    J

> Thanks,
> Rusty.
>
> Subject: x86: initialize initial_page_table before paravirt jumps
>
> v2.6.36-rc8-54-gb40827f (x86-32, mm: Add an initial page table for
> core bootstrapping) made x86 boot using initial_page_table and broke
> lguest.
>
> Rather than cut & paste initialization code into lguest, let's just
> do that init before the paravirt jump (and remove the max_pfn_mapped
> setting in lguest, since this code does it).
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  arch/x86/kernel/head_32.S |   73 +++++++++++++++++++++++-----------------------
>  arch/x86/lguest/boot.c    |    3 -
>  2 files changed, 37 insertions(+), 39 deletions(-)
>
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -137,39 +137,6 @@ 1:
>  	movl %eax, pa(olpc_ofw_pgd)
>  #endif
>  
> -#ifdef CONFIG_PARAVIRT
> -	/* This is can only trip for a broken bootloader... */
> -	cmpw $0x207, pa(boot_params + BP_version)
> -	jb default_entry
> -
> -	/* Paravirt-compatible boot parameters.  Look to see what architecture
> -		we're booting under. */
> -	movl pa(boot_params + BP_hardware_subarch), %eax
> -	cmpl $num_subarch_entries, %eax
> -	jae bad_subarch
> -
> -	movl pa(subarch_entries)(,%eax,4), %eax
> -	subl $__PAGE_OFFSET, %eax
> -	jmp *%eax
> -
> -bad_subarch:
> -WEAK(lguest_entry)
> -WEAK(xen_entry)
> -	/* Unknown implementation; there's really
> -	   nothing we can do at this point. */
> -	ud2a
> -
> -	__INITDATA
> -
> -subarch_entries:
> -	.long default_entry		/* normal x86/PC */
> -	.long lguest_entry		/* lguest hypervisor */
> -	.long xen_entry			/* Xen hypervisor */
> -	.long default_entry		/* Moorestown MID */
> -num_subarch_entries = (. - subarch_entries) / 4
> -.previous
> -#endif /* CONFIG_PARAVIRT */
> -
>  /*
>   * Initialize page tables.  This creates a PDE and a set of page
>   * tables, which are located immediately beyond __brk_base.  The variable
> @@ -179,7 +146,6 @@ num_subarch_entries = (. - subarch_entri
>   *
>   * Note that the stack is not yet set up!
>   */
> -default_entry:
>  #ifdef CONFIG_X86_PAE
>  
>  	/*
> @@ -259,7 +225,42 @@ 11:
>  	movl $pa(initial_pg_fixmap)+PDE_IDENT_ATTR,%eax
>  	movl %eax,pa(initial_page_table+0xffc)
>  #endif
> -	jmp 3f
> +
> +#ifdef CONFIG_PARAVIRT
> +	/* This is can only trip for a broken bootloader... */
> +	cmpw $0x207, pa(boot_params + BP_version)
> +	jb default_entry
> +
> +	/* Paravirt-compatible boot parameters.  Look to see what architecture
> +		we're booting under. */
> +	movl pa(boot_params + BP_hardware_subarch), %eax
> +	cmpl $num_subarch_entries, %eax
> +	jae bad_subarch
> +
> +	movl pa(subarch_entries)(,%eax,4), %eax
> +	subl $__PAGE_OFFSET, %eax
> +	jmp *%eax
> +
> +bad_subarch:
> +WEAK(lguest_entry)
> +WEAK(xen_entry)
> +	/* Unknown implementation; there's really
> +	   nothing we can do at this point. */
> +	ud2a
> +
> +	__INITDATA
> +
> +subarch_entries:
> +	.long default_entry		/* normal x86/PC */
> +	.long lguest_entry		/* lguest hypervisor */
> +	.long xen_entry			/* Xen hypervisor */
> +	.long default_entry		/* Moorestown MID */
> +num_subarch_entries = (. - subarch_entries) / 4
> +.previous
> +#else
> +	jmp default_entry
> +#endif /* CONFIG_PARAVIRT */
> +
>  /*
>   * Non-boot CPU entry point; entered from trampoline.S
>   * We can't lgdt here, because lgdt itself uses a data segment, but
> @@ -280,7 +281,7 @@ ENTRY(startup_32_smp)
>  	movl %eax,%fs
>  	movl %eax,%gs
>  #endif /* CONFIG_SMP */
> -3:
> +default_entry:
>  
>  /*
>   *	New page tables may be in 4Mbyte page mode and may
> diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
> --- a/arch/x86/lguest/boot.c
> +++ b/arch/x86/lguest/boot.c
> @@ -1349,9 +1349,6 @@ __init void lguest_init(void)
>  	 */
>  	switch_to_new_gdt(0);
>  
> -	/* We actually boot with all memory mapped, but let's say 128MB. */
> -	max_pfn_mapped = (128*1024*1024) >> PAGE_SHIFT;
> -
>  	/*
>  	 * The Host<->Guest Switcher lives at the top of our address space, and
>  	 * the Host told us how big it is when we made LGUEST_INIT hypercall:
>

