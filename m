Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab1CAUeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:34:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36582 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab1CAUeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:34:03 -0500
Date: Tue, 1 Mar 2011 20:32:35 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Simon Glass <sjg@chromium.org>
Cc: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ARM: Use generic BUG() handler
Message-ID: <20110301203235.GE27107@n2100.arm.linux.org.uk>
References: <1298939263-16421-1-git-send-email-sjg@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298939263-16421-1-git-send-email-sjg@chromium.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 04:27:43PM -0800, Simon Glass wrote:
> @@ -55,7 +56,8 @@ static void dump_mem(const char *, const char *, unsigned long, unsigned long);
>  void dump_backtrace_entry(unsigned long where, unsigned long from, unsigned long frame)
>  {
>  #ifdef CONFIG_KALLSYMS
> -	printk("[<%08lx>] (%pS) from [<%08lx>] (%pS)\n", where, (void *)where, from, (void *)from);
> +	printk(" [<%08lx>] (%pS) from [<%08lx>] (%pS)\n", where, (void *)where,
> +	       from, (void *)from);
>  #else
>  	printk("Function entered at [<%08lx>] from [<%08lx>]\n", where, from);
>  #endif
> @@ -171,7 +173,7 @@ static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
>  	unsigned int fp, mode;
>  	int ok = 1;
>  
> -	printk("Backtrace: ");
> +	printk("Backtrace:\n");
>  
>  	if (!tsk)
>  		tsk = current;

Why are you changing the way backtraces are printed?  This introduces a
useless blank line in the oops dump.  The previous hunk increases the
probability of mailers wrapping the backtrace making it harder to read.

If you're going to change the formatting of the Oops dump, please do it
as a separate patch and explain carefully why the change is necessary.

> diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
> index d2cb0b3..3f065bd 100644
> --- a/arch/arm/kernel/unwind.c
> +++ b/arch/arm/kernel/unwind.c
> @@ -355,6 +355,7 @@ void unwind_backtrace(struct pt_regs *regs, struct task_struct *tsk)
>  	register unsigned long current_sp asm ("sp");
>  
>  	pr_debug("%s(regs = %p tsk = %p)\n", __func__, regs, tsk);
> +	printk("Backtrace:\n");

Err, no.  This is in the wrong place.

> diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
> index 86b66f3..591ab50 100644
> --- a/arch/arm/kernel/vmlinux.lds.S
> +++ b/arch/arm/kernel/vmlinux.lds.S
> @@ -72,6 +72,18 @@ SECTIONS
>  
>  	PERCPU(PAGE_SIZE)
>  
> +	/*
> +	 * .exit.text is discarded at runtime, not link time, to deal with
> +	 *  references from bug_table
> +	 */
> +	.exit.text : AT(ADDR(.exit.text)) {
> +		EXIT_TEXT
> +	}
> +
> +	.exit.data : AT(ADDR(.exit.data)) {
> +		EXIT_DATA
> +	}
> +
>  #ifndef CONFIG_XIP_KERNEL
>  	. = ALIGN(PAGE_SIZE);
>  	__init_end = .;
> @@ -246,7 +258,6 @@ SECTIONS
>  		__tcm_end = .;
>  	}
>  #endif
> -
>  	BSS_SECTION(0, 0, 0)
>  	_end = .;
>  
> @@ -254,7 +265,7 @@ SECTIONS
>  	.comment 0 : { *(.comment) }
>  
>  	/* Default discards */
> -	DISCARDS
> +	/*DISCARDS*/
>  
>  #ifndef CONFIG_SMP_ON_UP
>  	/DISCARD/ : {

And this is a mess.
