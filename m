Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab0JVQnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:43:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60053 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab0JVQnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:43:06 -0400
Date: Fri, 22 Oct 2010 17:42:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        avictor.za@gmail.com, plagnioj@jcrosoft.com
Subject: Re: [PATCH 2/2] AT91: pm: make sure that r0 is 0 when dealing with
	cache operations
Message-ID: <20101022164247.GB29119@n2100.arm.linux.org.uk>
References: <af311282c5a0076ec618be68facdd3ad98d509b8.1287767949.git.nicolas.ferre@atmel.com> <86bb15f5a1aa3f21066ed13d7ee3f9f500d11087.1287767949.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86bb15f5a1aa3f21066ed13d7ee3f9f500d11087.1287767949.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 07:29:00PM +0200, Nicolas Ferre wrote:
> When using CP15 cache operations (c7), we make sure that Rd (r0)
> is actually 0 as ARM 926 TRM is saying.

Err, no.  From the GCC manual:

|    Note that even a volatile `asm' instruction can be moved in ways
| that appear insignificant to the compiler, such as across jump
| instructions.  You can't expect a sequence of volatile `asm'
| instructions to remain perfectly consecutive.  If you want consecutive
| output, use a single `asm'.  Also, GCC will perform some optimizations
| across a volatile `asm' instruction; GCC does not "forget everything"
| when it encounters a volatile `asm' instruction the way some other
| compilers do.

So:

	asm volatile("foo");
	asm volatile("bar");

is not guaranteed to produce the following uninterrupted code sequence:

	foo
	bar

The compiler is free to insert other instructions inbetween these two
asm statements.

It's also not permitted to modify registers without telling gcc that
they've been modified.

> +			asm("mov r0, #0");			/* clear r0 for CP15 accesses */
>  			asm("b 1f; .align 5; 1:");
>  			asm("mcr p15, 0, r0, c7, c10, 4");	/* drain write buffer */

That means the above is completely unacceptable.  It should be:

	asm("mov r0, #0;"
	"b 1f;"
	".align 5;"
	"1: mcr p15, 0, r0, c7, c10, 4" : : : "r0");



>  			saved_lpr = sdram_selfrefresh_enable();
> diff --git a/arch/arm/mach-at91/pm.h b/arch/arm/mach-at91/pm.h
> index 2c4424b..be081c9 100644
> --- a/arch/arm/mach-at91/pm.h
> +++ b/arch/arm/mach-at91/pm.h
> @@ -21,7 +21,7 @@ static inline u32 sdram_selfrefresh_enable(void)
>  }
>  
>  #define sdram_selfrefresh_disable(saved_lpr)	at91_sys_write(AT91_SDRAMC_LPR, saved_lpr)
> -#define wait_for_interrupt_enable()		asm("mcr p15, 0, r0, c7, c0, 4")
> +#define wait_for_interrupt_enable()		asm("mcr p15, 0, r0, c7, c0, 4") /* r0 is 0 here */

No, r0 is not guaranteed to be zero here.  Use dsb() here instead which
gets it right.


>  #elif defined(CONFIG_ARCH_AT91CAP9)
>  #include <mach/at91cap9_ddrsdr.h>
> diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
> index b6b00a1..f7922a4 100644
> --- a/arch/arm/mach-at91/pm_slowclock.S
> +++ b/arch/arm/mach-at91/pm_slowclock.S
> @@ -124,6 +124,7 @@ ENTRY(at91_slow_clock)
>  	ldr	r5, .at91_va_base_ramc1
>  
>  	/* Drain write buffer */
> +	mov	r0, #0
>  	mcr	p15, 0, r0, c7, c10, 4

This one being in asm code is fine.
