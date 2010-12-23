Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab0LWJ6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 04:58:49 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:46300 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab0LWJ6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 04:58:47 -0500
From: Florian Fainelli <ffainelli@freebox.fr>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/trampoline: fallback to fixed trampoline address if no e820 map is provided
Date: Thu, 23 Dec 2010 10:57:34 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-server; KDE/4.5.1; x86_64; ; )
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, sodaville@linutronix.de,
        Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>
References: <201012142219.40062.ffainelli@freebox.fr>
In-Reply-To: <201012142219.40062.ffainelli@freebox.fr>
Organization: Freebox
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012231057.35021.ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 December 2010 22:19:39 Florian Fainelli wrote:
> From: Florian Fainelli <ffainelli@freebox.fr>
> 
> Since 893f38d1 (x86: Use find_e820() instead of hard coded trampoline
> address), the trampoline base address should be provided by the BIOS as an
> e820 area. Some minimalistic BIOSes (like CEFDK on CE4100) may not provide
> any e820 area, still we should fallback to a fixed trampoline base address
> for SMP to work correctly.
> 
> Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
> Cc: sodaville@linutronix.de
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>

Ingo, Yinghai, anything wrong with that patch? Thank you.

> ---
> diff --git a/arch/x86/include/asm/trampoline.h
> b/arch/x86/include/asm/trampoline.h index f4500fb..908b395 100644
> --- a/arch/x86/include/asm/trampoline.h
> +++ b/arch/x86/include/asm/trampoline.h
> @@ -16,6 +16,7 @@ extern unsigned long initial_code;
>  extern unsigned long initial_gs;
> 
>  #define TRAMPOLINE_SIZE roundup(trampoline_end - trampoline_data,
> PAGE_SIZE) +#define TRAMPOLINE_BASE 0x6000
> 
>  extern unsigned long setup_trampoline(void);
>  extern void __init reserve_trampoline_memory(void);
> diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
> index f1488a3..d025aae 100644
> --- a/arch/x86/kernel/trampoline.c
> +++ b/arch/x86/kernel/trampoline.c
> @@ -21,8 +21,11 @@ void __init reserve_trampoline_memory(void)
> 
>  	/* Has to be in very low memory so we can execute real-mode AP code. */
>  	mem = find_e820_area(0, 1<<20, TRAMPOLINE_SIZE, PAGE_SIZE);
> -	if (mem == -1L)
> -		panic("Cannot allocate trampoline\n");
> +	if (mem == -1L) {
> +		printk(KERN_INFO "BIOS did not provide e820 area for trampoline"
> +				" ,using static trampoline address\n");
> +		mem = TRAMPOLINE_BASE;
> +	}
> 
>  	trampoline_base = __va(mem);
>  	reserve_early(mem, mem + TRAMPOLINE_SIZE, "TRAMPOLINE");
