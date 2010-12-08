Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab0LHKOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 05:14:46 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:38911 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab0LHKOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 05:14:43 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <201011301754.17829.arnd@arndb.de>
In-Reply-To: <201011301754.17829.arnd@arndb.de>
Subject: RE: [PATCH] Unicore architecture patch review, part 2
Date: Wed, 8 Dec 2010 18:14:35 +0800
Message-ID: <011401cb96c0$b7dca8d0$2795fa70$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQEGWQxFgenXGrFHNnUO9LkE1o8/SZUb7fpA
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-
> rc2/arch/unicore32/kernel/calls.S linux-
> 2.6.37.y/arch/unicore32/kernel/calls.S
> > --- linux-2.6.37-rc2/arch/unicore32/kernel/calls.S	1970-01-01
> 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/kernel/calls.S	2010-11-19
> 14:33:16.973569009 +0800
> > @@ -0,0 +1,390 @@
> > +/* 0 */		CALL(sys_restart_syscall)
> > +		CALL(sys_exit)
> > +		CALL(sys_fork_wrapper)
> > +		CALL(sys_read)
> > +		CALL(sys_write)
> > +/* 5 */		CALL(sys_open)
> > +		CALL(sys_close)
> 
> When you start using the generic unistd.h file, you can also replace this
table
> with something like arch/tile/kernel/sys.c.
Well. I will use the generic unistd.h in UniCore-64 version.


> > + * Handle all unrecognised system calls.
> > + *  0x9f0000 - 0x9fffff are some more esoteric system calls  */
> > +#define NR(x) ((__UNICORE_NR_##x) - __UNICORE_NR_BASE)
> asmlinkage int
> > +uc32_syscall(int no, struct pt_regs *regs)
> 
> This function looks very obscure and it seems to deal with legacy ARM
issues
> that were copied here.
> 
> Better make the unicore specific interfaces regular syscalls
(sys_breakpoint,
> sys_cacheflush, sys_cmpxchg, ...).
We need to handle cacheflush and cmpxchg in this way for compatibility with 
Existing binary files.

> > diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-
> rc2/arch/unicore32/lib/copy_template.S linux-
> 2.6.37.y/arch/unicore32/lib/copy_template.S
> > --- linux-2.6.37-rc2/arch/unicore32/lib/copy_template.S	1970-01-01
> 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/lib/copy_template.S	2010-11-16
> 18:30:56.013566876 +0800
> > @@ -0,0 +1,214 @@
> > +/*
> > + * linux/arch/unicore32/lib/copy_template.S
> 
> This is a copy of the ARM-optimized memcpy code. Is it really better than
the
> libgcc version on unicore?
Yes, we have the similar optimization method with ARM.
And we do the optimization work for the kernel and libgcc in the meantime.

> A similar question can be asked for much of the assembly code in
> arch/unicore/lib. The code is rather old and compilers have gotten a lot
> better in the meantime, so I could imagine that you'd be better off just
using
> the C versions.
To avoid the same code in two different place, I have shrinked the unicore32
kernel code.

> > diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-
> rc2/arch/unicore32/lib/delay.S linux-2.6.37.y/arch/unicore32/lib/delay.S
> > --- linux-2.6.37-rc2/arch/unicore32/lib/delay.S	1970-01-01
> 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/lib/delay.S	2010-11-16
> 18:30:56.015567130 +0800
> > +
> > +/*
> > + * loops = r0 * HZ * loops_per_jiffy / 1000000
> > + *
> > + * Oh, if only we had a cycle counter...
> > + */
> > +
> > +@ Delay routine
> > +ENTRY(__delay)
> > +		sub.a	r0, r0, #2
> > +		bua	__delay
> > +		mov	pc, lr
> > +ENDPROC(__udelay)
> 
> Hmm, when the architecture was being defined, why didn't you ask for a
> cycle counter? It really improves the delay code a lot.
No software readable cycle counter in UniCore32.

> If you have a good time base by now, you should use it. Is the OST_OSCR
> something you could use here?
OST_OSCR is much coarse in here, which is 14.318M Hz.

> > diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-
> rc2/arch/unicore32/mach-puv3/clock.c linux-2.6.37.y/arch/unicore32/mach-
> puv3/clock.c
> > --- linux-2.6.37-rc2/arch/unicore32/mach-puv3/clock.c	1970-01-01
> 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/mach-puv3/clock.c	2010-11-16
> 18:30:56.020566930 +0800
> > @@ -0,0 +1,389 @@
> > +/*
> > + * linux/arch/unicore32/mach-puv3/clock.c
> 
> I would not plan to have multiple mach- directories if you only need one
> today. It makes sense on ARM, which has dozens of different machines, but
> in your case, I would hope that you control it well enough to keep
machines
> mostly compatible with each other.
Yes, the mach dir and kernel dir are combined.

> > +/*
> > + * Very simple clock implementation
> > + */
> > +struct clk {
> > +	struct list_head	node;
> > +	unsigned long		rate;
> > +	const char		*name;
> > +};
> 
> There are currently patches under discussion for the ARM architecture that
> unify the various struct clk definitions. It probably makes sense for you
to use
> the same definition.
At present, clk struct works well, and it is enough for UniCore32.
I will reconsider this problem later.

> > diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-
> rc2/arch/unicore32/mach-puv3/core.c linux-2.6.37.y/arch/unicore32/mach-
> puv3/core.c
> > --- linux-2.6.37-rc2/arch/unicore32/mach-puv3/core.c	1970-01-01
> 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/mach-puv3/core.c	2010-11-19
> 17:55:34.949943687 +0800
> > +static struct resource puv3_usb_resources[] = {
> > +	/* order is significant! */
> > +	{
> > +		.start		= PKUNITY_USB_BASE,
> > +		.end		= PKUNITY_USB_BASE + 0x3ff,
> > +		.flags		= IORESOURCE_MEM,
> > +	}, {
> > +		.start		= IRQ_USB,
> > +		.flags		= IORESOURCE_IRQ,
> > +	}, {
> > +		.start		= IRQ_USB,
> > +		.flags		= IORESOURCE_IRQ,
> > +	},
> > +};
> > +
> > +static struct musb_hdrc_config	puv3_usb_config[] = {
> > +	{
> > +		.num_eps = 16,
> > +		.multipoint = 1,
> > +#ifdef CONFIG_USB_INVENTRA_DMA
> > +		.dma = 1,
> > +		.dma_channels = 8,
> > +#endif
> > +	},
> > +};
> > +
> > +static struct musb_hdrc_platform_data puv3_usb_plat = {
> > +	.mode		= MUSB_HOST,
> > +	.min_power 	= 100,
> > +	.clock		= 0,
> > +	.config		= puv3_usb_config,
> > +};
> 
> Please have a look at the flattened device tree format as a way to define
the
> SoC components. Defining all the platform data statically is generally not
a
> scalable way to support multiple SOCs in the long run, or even multiple
> boards based on the same SOC in different configurations.
Also, I will reconsider this problem lator. Thanks.

> Why do you even need to fix up alignment exceptions, can't you just always
> send SIGBUS in this case?
We must handle alignment exception in software.

> > diff -uprN -X linux-2.6.37-rc2/Documentation/dontdiff linux-2.6.37-
> rc2/arch/unicore32/mm/dma-mapping.c linux-
> 2.6.37.y/arch/unicore32/mm/dma-mapping.c
> > --- linux-2.6.37-rc2/arch/unicore32/mm/dma-mapping.c	1970-01-01
> 08:00:00.000000000 +0800
> > +++ linux-2.6.37.y/arch/unicore32/mm/dma-mapping.c	2010-11-16
> 18:30:56.024566880 +0800
> 
> This file will look very different when you use swiotlb. Given the
restrictions
> on your PCI bus, I don't think your current version even works in general
for
> PCI devices.
Also, I will reconsider this problem lator. Thanks.

> When you have addressed the review comments you got up to now, it would
> be good to start posting the code as separate patches by email to the
linux-
> kernel and linux-arch mailing lists as described in the
> Documentation/SubmittingPatches file. I recommend posting at most 10-20
> patches at a time, and if you have patches to include/asm-generic or other
> common kernel code, please make them self-contained with a proper
> changelog so we can apply them independent of the architecture tree.
Thanks again.

Guan Xuetao


