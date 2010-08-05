Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab0HEEru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 00:47:50 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:56252 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab0HEErr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 00:47:47 -0400
Date: Thu, 5 Aug 2010 06:48:05 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>,
        "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
        "greg@kroah.com" <greg@kroah.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86-32: Fix crashes with CPU hotplug on AMD
 machines
Message-ID: <20100805044805.GA11719@aftab>
References: <1280940316-7966-1-git-send-email-bp@amd64.org>
 <1280940316-7966-2-git-send-email-bp@amd64.org>
 <4C59F24B.1010702@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C59F24B.1010702@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, Aug 04, 2010 at 07:05:47PM -0400

> On 08/04/2010 09:45 AM, Borislav Petkov wrote:
> > 
> >         2. Do not use swapper_pg_dir to boot secondary CPUs like 64-bit
> >         does.
> > 
> > This patch implements solution 2. It introduces a trampoline_pg_dir
> > which has the same layout as swapper_pg_dir with low_mappings. This page
> > table is used as the initial page table of the booting CPU. Later in the
> > bringup process, it switches to swapper_pg_dir and does a global TLB
> > flush. This fixes the crashes in our test cases.
> > 
> 
> I would like to keep around a page directory with the low mappings
> around -- and not use it for kernel threads -- at all times *anyway*.
> This means we can remove any current hacks that we have to do around S3
> entry and exit, for example.
> 
> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -328,7 +328,7 @@ ENTRY(startup_32_smp)
>  /*
>   * Enable paging
>   */
> -	movl $pa(swapper_pg_dir),%eax
> +	movl pa(initial_page_table), %eax
>  	movl %eax,%cr3		/* set the page table pointer.. */
>  	movl %cr0,%eax
>  	orl  $X86_CR0_PG,%eax
> @@ -608,6 +608,8 @@ ignore_int:
>  .align 4
>  ENTRY(initial_code)
>  	.long i386_start_kernel
> +ENTRY(initial_page_table)
> +	.long pa(swapper_pg_dir)
> 
>  /*
>   * BSS section
> @@ -623,6 +625,10 @@ ENTRY(swapper_pg_dir)
>  #endif
>  swapper_pg_fixmap:
>  	.fill 1024,4,0
> +#ifdef CONFIG_X86_TRAMPOLINE
> +ENTRY(trampoline_pg_dir)
> +	.fill 1024,4,0
> +#endif
> 
> I don't really see why this makes sense, though.  It would make more
> sense that the initial page table we set up becomes trampoline_pg_dir;
> we can then set up and change to swapper_pg_dir almost immediately.

Yeah, now we use swapper_pg_dir at all times and zap the low mappings.
However, this is not perfectly clean, as this case in point shows how
unrelated CPUs might establish TLB entries speculatively. Now imagine
if they don't mcheck about it but silently and merrily continue on.
In this particular case, there were no improper accesses due to the
user/kernel permissions mismatch but imagine if suddenly kernel code
started accessing userspace and this not through copy_to_user() et al.

So it really does make sense to have an initial page table and copy
swapper_pg_dir from it. Which would be a perfect exercise for someone
who would like to play with the boot code a bit more, ^hint hint^, if
Joerg doesn't beat me to it.

But I'd suggest we get those fixes in now if there are no objections and
later adjustments should come ontop after excessive testing. And what
about backporting those fixes to .32 and .34, would you be ok with that?
Greg, what about you?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
