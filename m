Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab2G0NDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 09:03:33 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:58447 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2G0NDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 09:03:12 -0400
X-IronPort-AV: E=Sophos;i="4.77,667,1336348800"; 
   d="scan'208";a="13734970"
Date: Fri, 27 Jul 2012 14:02:18 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 02/24] xen/arm: hypercalls
In-Reply-To: <1343380659.6812.106.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1207271350370.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>  <1343316846-25860-2-git-send-email-stefano.stabellini@eu.citrix.com>  <20120726163352.GC9222@phenom.dumpdata.com> <1343380659.6812.106.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012, Ian Campbell wrote:
> On Thu, 2012-07-26 at 17:33 +0100, Konrad Rzeszutek Wilk wrote:
> > On Thu, Jul 26, 2012 at 04:33:44PM +0100, Stefano Stabellini wrote:
> > > Use r12 to pass the hypercall number to the hypervisor.
> > > 
> > > We need a register to pass the hypercall number because we might not
> > > know it at compile time and HVC only takes an immediate argument.
> > > 
> > > Among the available registers r12 seems to be the best choice because it
> > > is defined as "intra-procedure call scratch register".
> > > 
> > > Use the ISS to pass an hypervisor specific tag.
> > > 
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > ---
> > >  arch/arm/include/asm/xen/hypercall.h |   50 ++++++++++++++++++++++++++
> > >  arch/arm/xen/Makefile                |    2 +-
> > >  arch/arm/xen/hypercall.S             |   65 ++++++++++++++++++++++++++++++++++
> > >  3 files changed, 116 insertions(+), 1 deletions(-)
> > >  create mode 100644 arch/arm/include/asm/xen/hypercall.h
> > >  create mode 100644 arch/arm/xen/hypercall.S
> > > 
> > > diff --git a/arch/arm/include/asm/xen/hypercall.h b/arch/arm/include/asm/xen/hypercall.h
> > > new file mode 100644
> > > index 0000000..4ac0624
> > > --- /dev/null
> > > +++ b/arch/arm/include/asm/xen/hypercall.h
> > > @@ -0,0 +1,50 @@
> > > +/******************************************************************************
> > > + * hypercall.h
> > > + *
> > > + * Linux-specific hypervisor handling.
> > > + *
> > > + * Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Citrix, 2012
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > + * modify it under the terms of the GNU General Public License version 2
> > > + * as published by the Free Software Foundation; or, when distributed
> > > + * separately from the Linux kernel or incorporated into other
> > > + * software packages, subject to the following license:
> > > + *
> > > + * Permission is hereby granted, free of charge, to any person obtaining a copy
> > > + * of this source file (the "Software"), to deal in the Software without
> > > + * restriction, including without limitation the rights to use, copy, modify,
> > > + * merge, publish, distribute, sublicense, and/or sell copies of the Software,
> > > + * and to permit persons to whom the Software is furnished to do so, subject to
> > > + * the following conditions:
> > > + *
> > > + * The above copyright notice and this permission notice shall be included in
> > > + * all copies or substantial portions of the Software.
> > > + *
> > > + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> > > + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> > > + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> > > + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> > > + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> > > + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
> > > + * IN THE SOFTWARE.
> > > + */
> > > +
> > > +#ifndef _ASM_ARM_XEN_HYPERCALL_H
> > > +#define _ASM_ARM_XEN_HYPERCALL_H
> > > +
> > > +#include <xen/interface/xen.h>
> > > +
> > > +long privcmd_call(unsigned call, unsigned long a1,
> > > +		unsigned long a2, unsigned long a3,
> > > +		unsigned long a4, unsigned long a5);
> > > +int HYPERVISOR_xen_version(int cmd, void *arg);
> > > +int HYPERVISOR_console_io(int cmd, int count, char *str);
> > > +int HYPERVISOR_grant_table_op(unsigned int cmd, void *uop, unsigned int count);
> > > +int HYPERVISOR_sched_op(int cmd, void *arg);
> > > +int HYPERVISOR_event_channel_op(int cmd, void *arg);
> > > +unsigned long HYPERVISOR_hvm_op(int op, void *arg);
> > > +int HYPERVISOR_memory_op(unsigned int cmd, void *arg);
> > > +int HYPERVISOR_physdev_op(int cmd, void *arg);
> > > +
> > > +#endif /* _ASM_ARM_XEN_HYPERCALL_H */
> > > diff --git a/arch/arm/xen/Makefile b/arch/arm/xen/Makefile
> > > index 0bad594..b9d6acc 100644
> > > --- a/arch/arm/xen/Makefile
> > > +++ b/arch/arm/xen/Makefile
> > > @@ -1 +1 @@
> > > -obj-y		:= enlighten.o
> > > +obj-y		:= enlighten.o hypercall.o
> > > diff --git a/arch/arm/xen/hypercall.S b/arch/arm/xen/hypercall.S
> > > new file mode 100644
> > > index 0000000..038cc5b
> > > --- /dev/null
> > > +++ b/arch/arm/xen/hypercall.S
> > > @@ -0,0 +1,65 @@
> > > +/******************************************************************************
> > > + * hypercall.S
> > > + *
> > > + * Xen hypercall wrappers
> > > + *
> > > + * The Xen hypercall calling convention is very similar to the ARM
> > > + * procedure calling convention: the first paramter is passed in r0, the
> > > + * second in r1, the third in r2 and the third in r3. Considering that
> > 
> > I think you meant 'and the fourth in r3'.
> > 
> > So where does the similarity end?  Just in that we use r12?
> 
> The standard ARM function calling convention is arguments 1-4 on r0-r3
> and arguments 5+ on the stack. r12 is a scratch register which can be
> clobbered by the *linker* on subroutine call (r12 is also called "ip"
> the intra-procedure call scratch register).
> 
> The hypervisor doesn't want to be accessing hypercall arguments off the
> guest stack, for obvious reasons, so we use r4 for the fifth argument
> (and if we even implemented 6 argument hypercalls we'd use r5, etc).
> There is no equivalent to the hypercall number in the procedure calling
> convention so we picked r12 because it is up and out of the way and is
> otherwise a scratch register. Obviously that you must not make a
> procedure call between setting the hypercall number in r12 and calling
> the hvc instruction.
> 
> > 
> > > + * Xen hypercalls have 5 arguments at most, the fifth paramter is passed
> > > + * in r4, differently from the procedure calling convention of using the
> > 
> > > + * stack for that case.
> > > + *
> > > + * The hypercall number is passed in r12.
> > > + *
> > > + * The return value is in r0.
> > > + *
> > > + * The hvc ISS is required to be 0xEA1, that is the Xen specific ARM
> > > + * hypercall tag.
> > > + *
> > > + * Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Citrix, 2012
> > > + */
> > > +
> > > +#include <linux/linkage.h>
> > > +#include <asm/assembler.h>
> > > +#include <xen/interface/xen.h>
> > > +
> > > +
> > > +/* HVC 0xEA1 */
> > > +#ifdef CONFIG_THUMB2_KERNEL
> > > +#define xen_hvc .word 0xf7e08ea1
> > > +#else
> > > +#define xen_hvc .word 0xe140ea71
> > > +#endif
> > > +
> > > +/* We need to save and restore r4, because Xen clobbers it. */
> > 
> > Hmm, the comment says r4, but right below I see r12?
> 
> The ARM procedure calling convention allows a subroutine to clobber
> r1..r3 (r0 is the return value) but not r4 which must be preserved. But
> the hypervisor ABI clobbers all argument registers so the caller has to
> specially preserve r4 in this context whenever there is a 5 argument
> hypercall.
> 
> I presume that none of the hypercalls defined below have 5 arguments and
> therefore we don't need to preserve r4 except in the generic
> privcmd_call function. 
> 
> To be honest I prefer the style which we use on x86 which is to define
> hypercall{0,1,2,3,4,5} macros and to wrap those with the specific names
> using inline functions.
> 
> I find the x86 way more self documenting, and being in C prevents errors
> around the number of arguments. It also allows for better in-lining and
> exposes to gcc the actual clobbers, which might allow it to avoid saving
> r4 on the stack at all etc.

Considering that we cannot do the same thing that we do on x86 (see this
thread http://marc.info/?l=linux-kernel&m=133052035426427&w=2), I
decided to go for the assembly implementation because it is much shorter
and easier to understand (for me at least, being just 3 lines of code in
the generic case and just one macro) and this way we can exploit the
code generated by gcc to put the arguments in the right registers.

Also I like the fact that it is the same strategy used by libc to issue
syscalls.

As you can see it results in 3 lines of code for all the hypercalls
except the ones that might take more than 4 arguments, that right now is
just privcmd.



> > Should this comment be by 'privcmd_call'?
> 
> When we add a 5 argument hypercall I suppose we'll see the required
> push/pop of r4 added to this macro too.

For performance and simplicity I would add a second macro that push/pop
r4, only required for hypercalls with more than 4 arguments.


> > > +#define HYPERCALL(hypercall)			\
> > > +ENTRY(HYPERVISOR_##hypercall)			\
> > > +	mov r12, #__HYPERVISOR_##hypercall;	\
> > > +	xen_hvc;							\
> > > +	mov pc, lr;							\
> > > +ENDPROC(HYPERVISOR_##hypercall)
> > > +
> > > +                .text
> > > +
> > > +HYPERCALL(xen_version);
> > > +HYPERCALL(console_io);
> > > +HYPERCALL(grant_table_op);
> > > +HYPERCALL(sched_op);
> > > +HYPERCALL(event_channel_op);
> > > +HYPERCALL(hvm_op);
> > > +HYPERCALL(memory_op);
> > > +HYPERCALL(physdev_op);
> > > +
> > > +ENTRY(privcmd_call)
> > > +	stmdb	sp!, {r4}
> > > +	mov r12, r0
> > > +	mov r0, r1
> > > +	mov r1, r2
> > > +	mov r2, r3
> > > +	ldr r3, [sp, #8]
> > > +	ldr r4, [sp, #4]
> > > +	xen_hvc
> > > +	pop {r4}
> 
> Why not ldmdb for symmetry?

Yep, I can do that.
