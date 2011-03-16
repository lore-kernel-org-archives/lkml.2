Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab1CPAy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 20:54:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36445 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab1CPAyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 20:54:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: matthieu castet <castet.matthieu@free.fr>
Subject: Re: [PATCH 1/2] v2 merge 32 and 64 realmode wakeup code
Date: Wed, 16 Mar 2011 01:55:05 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: x86@kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <4D7FE5C5.3040106@free.fr>
In-Reply-To: <4D7FE5C5.3040106@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103160155.05307.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 15, 2011, matthieu castet wrote:
> - this mean less ifdef in code
> - we could remove now unused field in wakeup_header (pmode_*)
> 
> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  arch/x86/kernel/acpi/realmode/wakeup.S |   26 --------------------------
>  arch/x86/kernel/acpi/sleep.c           |   27 ++++++++++-----------------
>  arch/x86/kernel/trampoline_32.S        |    4 ----
>  3 files changed, 10 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/kernel/acpi/realmode/wakeup.S
> index ead21b6..150a734 100644
> --- a/arch/x86/kernel/acpi/realmode/wakeup.S
> +++ b/arch/x86/kernel/acpi/realmode/wakeup.S
> @@ -93,36 +93,10 @@ wakeup_code:
>  
>  	/* Do any other stuff... */
>  
> -#ifndef CONFIG_64BIT
> -	/* This could also be done in C code... */
> -	movl	pmode_cr3, %eax
> -	movl	%eax, %cr3
> -
> -	movl	pmode_cr4, %ecx
> -	jecxz	1f
> -	movl	%ecx, %cr4
> -1:
> -	movl	pmode_efer, %eax
> -	movl	pmode_efer + 4, %edx
> -	movl	%eax, %ecx
> -	orl	%edx, %ecx
> -	jz	1f
> -	movl	$MSR_EFER, %ecx
> -	wrmsr
> -1:
> -
> -	lgdtl	pmode_gdt
> -
> -	/* This really couldn't... */
> -	movl	pmode_cr0, %eax
> -	movl	%eax, %cr0
> -	jmp	pmode_return
> -#else
>  	pushw	$0
>  	pushw	trampoline_segment
>  	pushw	$0
>  	lret
> -#endif
>  
>  bogus_real_magic:
>  1:
> diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
> index 4572c58..2558a05 100644
> --- a/arch/x86/kernel/acpi/sleep.c
> +++ b/arch/x86/kernel/acpi/sleep.c
> @@ -20,7 +20,7 @@
>  
>  unsigned long acpi_realmode_flags;
>  
> -#if defined(CONFIG_SMP) && defined(CONFIG_64BIT)
> +#ifdef CONFIG_SMP
>  static char temp_stack[4096];
>  #endif
>  
> @@ -67,34 +67,27 @@ int acpi_save_state_mem(void)
>  	header->wakeup_gdt[2] =
>  		GDT_ENTRY(0x8093, acpi_wakeup_address, 0xfffff);
>  
> -#ifndef CONFIG_64BIT
> -	store_gdt((struct desc_ptr *)&header->pmode_gdt);
> -
> -	if (rdmsr_safe(MSR_EFER, &header->pmode_efer_low,
> -		       &header->pmode_efer_high))
> -		header->pmode_efer_low = header->pmode_efer_high = 0;
> -#endif /* !CONFIG_64BIT */
> -
>  	header->pmode_cr0 = read_cr0();
>  	header->pmode_cr4 = read_cr4_safe();
>  	header->realmode_flags = acpi_realmode_flags;
>  	header->real_magic = 0x12345678;
> -
> -#ifndef CONFIG_64BIT
> -	header->pmode_entry = (u32)&wakeup_pmode_return;
> -	header->pmode_cr3 = (u32)__pa(&initial_page_table);
> -	saved_magic = 0x12345678;
> -#else /* CONFIG_64BIT */
>  	header->trampoline_segment = trampoline_address() >> 4;
>  #ifdef CONFIG_SMP
>  	stack_start = (unsigned long)temp_stack + sizeof(temp_stack);
>  	early_gdt_descr.address =
>  			(unsigned long)get_cpu_gdt_table(smp_processor_id());
> +#ifdef CONFIG_64BIT
>  	initial_gs = per_cpu_offset(smp_processor_id());
>  #endif
> +#endif
> +
> +#ifdef CONFIG_64BIT
>  	initial_code = (unsigned long)wakeup_long64;
> -       saved_magic = 0x123456789abcdef0L;
> -#endif /* CONFIG_64BIT */
> +	saved_magic = 0x123456789abcdef0L;
> +#else
> +	initial_code = (unsigned long)&wakeup_pmode_return;
> +	saved_magic = 0x12345678;
> +#endif
>  
>  	return 0;
>  }
> diff --git a/arch/x86/kernel/trampoline_32.S b/arch/x86/kernel/trampoline_32.S
> index 451c0a7..a726f60 100644
> --- a/arch/x86/kernel/trampoline_32.S
> +++ b/arch/x86/kernel/trampoline_32.S
> @@ -32,8 +32,6 @@
>  #include <asm/segment.h>
>  #include <asm/page_types.h>
>  
> -#ifdef CONFIG_SMP
> -
>  	.section ".x86_trampoline","a"
>  	.balign PAGE_SIZE
>  	.code16
> @@ -79,5 +77,3 @@ ENTRY(trampoline_status)
>  
>  .globl trampoline_end
>  trampoline_end:
> -
> -#endif /* CONFIG_SMP */
> 

