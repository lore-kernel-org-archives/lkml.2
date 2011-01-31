Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab1AaXwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:52:46 -0500
Received: from smtp.outflux.net ([198.145.64.163]:33620 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242Ab1AaXwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:52:45 -0500
Date: Mon, 31 Jan 2011 15:52:31 -0800
From: Kees Cook <kees.cook@canonical.com>
To: matthieu castet <castet.matthieu@free.fr>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [BUG] broken ebba638ae723d8a8fc2f7abce5ec18b688b791d7
Message-ID: <20110131235231.GJ4557@outflux.net>
References: <4D41E86D.8060205@free.fr>
 <20110127230013.GO4981@outflux.net>
 <4D4228CE.5090601@zytor.com>
 <20110131213847.GF4557@outflux.net>
 <4D474194.2000709@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D474194.2000709@free.fr>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthieu,

On Tue, Feb 01, 2011 at 12:11:16AM +0100, matthieu castet wrote:
> Kees Cook a écrit :
> >On Thu, Jan 27, 2011 at 06:24:14PM -0800, H. Peter Anvin wrote:
> >>On 01/27/2011 03:00 PM, Kees Cook wrote:
> >>>Yikes, good catch.
> >>>
> >>>arch/x86/kernel/trampoline_64.S uses:
> >>>        movw    $(trampoline_stack_end - r_base), %sp
> >>>
> >>>arch/x86/boot/compressed/head_64.S uses:
> >>>        movl    $boot_stack_end, %eax
> >>>        addl    %ebp, %eax
> >>>        movl    %eax, %esp
> >>>
> >>>what would be safe for arch/x86/kernel/head_32.S ? It uses "stack_start",
> >>>but later after paging set-up. Is the following sane to solve this?
> >>>
> >>To run it before paging is set up, you can't use stack, start; you
> >>have to use a pointer based on physical address.  You have two
> >>problems with using stack_start: you're using a linear address to
> >>access stack_start, and stack_start itself contains a linear
> >>address.
> >>
> >>It's not entirely clear to me why we don't initialize %ss to
> >>__BOOT_DS with the other segment registers, but it would make most
> >>sense to me:
> >>
> >>diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> >>index fc293dc..c10f9ba 100644
> >>--- a/arch/x86/kernel/head_32.S
> >>+++ b/arch/x86/kernel/head_32.S
> >>@@ -99,7 +99,12 @@ ENTRY(startup_32)
> >>        movl %eax,%es
> >>        movl %eax,%fs
> >>        movl %eax,%gs
> >>+       movl %eax,%ss
> >> 2:
> >>+/*
> >>+ * Set up an initial stack
> >>+ */
> >>+       movl $pa(init_thread_union+THREAD_SIZE), %esp
> >>
> >> /*
> >>  * Clear BSS first so that there are no surprises...
> >
> >This doesn't appear to work for me. While I can boot fine, doing CPU
> >hotplugging hangs the system. :(
> >
> This is weird because the patch only touch first cpu (startup_32
> entry) and cpu hotplug go to startup_32_smp.
> 
> Here a untested patch that move the stack setup in the common path.
> 
> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
> index fc293dc..5df3432 100644
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -284,6 +284,12 @@ ENTRY(startup_32_smp)
>  	movl %eax,%gs
>  #endif /* CONFIG_SMP */
>  default_entry:
> +	/*
> +	 * Set up an initial stack
> +	 */
> +	movl $(__BOOT_DS),%eax
> +	movl %eax,%ss
> +	movl $pa(init_thread_union+THREAD_SIZE), %esp
>  
>  /*
>   *	New page tables may be in 4Mbyte page mode and may

This worked, thanks! If this tests cleanly for you in qemu, we should get
this committed.

-Kees

-- 
Kees Cook
Ubuntu Security Team
