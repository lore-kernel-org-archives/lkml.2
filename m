Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030250Ab2CAJvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:51:53 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45975 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965838Ab2CAJvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:51:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dave.martin@linaro.org designates 10.204.153.206 as permitted sender) smtp.mail=dave.martin@linaro.org
Date: Thu, 1 Mar 2012 09:51:39 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall number
 to the hypervisor
Message-ID: <20120301095139.GC2034@linaro.org>
References: <1330360043.8557.302.camel@zakaz.uk.xensource.com>
 <20120227180355.GB2023@linaro.org>
 <1330371219.10008.34.camel@dagon.hellion.org.uk>
 <20120228102040.GB2063@linaro.org>
 <1330426133.31269.70.camel@zakaz.uk.xensource.com>
 <alpine.DEB.2.00.1202281149210.23091@kaball-desktop>
 <20120229093436.GA2077@linaro.org>
 <1330509362.4270.20.camel@zakaz.uk.xensource.com>
 <20120229125826.GC2077@linaro.org>
 <alpine.DEB.2.00.1202291435400.23091@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202291435400.23091@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 02:52:38PM +0000, Stefano Stabellini wrote:
> On Wed, 29 Feb 2012, Dave Martin wrote:
> > On Wed, Feb 29, 2012 at 09:56:02AM +0000, Ian Campbell wrote:
> > > On Wed, 2012-02-29 at 09:34 +0000, Dave Martin wrote:
> > > > On Tue, Feb 28, 2012 at 12:28:29PM +0000, Stefano Stabellini wrote:
> > > 
> > > > > I don't have a very strong opinion on which register we should use, but
> > > > > I would like to avoid r7 if it is already actively used by gcc.
> > > > 
> > > > But there is no framepointer for Thumb-2 code (?)
> > > 
> > > Peter Maydell suggested there was:
> > > > r7 is (used by gcc as) the Thumb frame pointer; I don't know if this
> > > > makes it worth avoiding in this context.
> > > 
> > > Sounds like it might be a gcc-ism, possibly a non-default option?
> > > 
> > > Anyway, I think r12 will be fine for our purposes so the point is rather
> > > moot.
> > 
> > Just had a chat with some tools guys -- apparently, when passing register
> > arguments to gcc inline asms there really isn't a guarantee that those
> > variables will be in the expected registers on entry to the inline asm.
> > 
> > If gcc reorders other function calls or other code around the inline asm
> > (which it can do, except under certain controlled situations), then
> > intervening code can clobber any registers in general.
> > 
> > Or, to summarise another way, there is no way to control which register
> > is used to pass something to an inline asm in general (often we get away
> > with this, and there are a lot of inline asms in the kernel that assume
> > it works, but the more you inline the more likely you are to get nasty
> > surprises).  There is no workaroud, except on some architectures where
> > special asm constraints allow specific individual registers to be
> > specified for operands (i386 for example).
> > 
> > If you need a specific register, this means that you must set up that
> > register explicitly inside the asm if you want a guarantee that the
> > code will work:
> > 
> > 	asm volatile (
> > 		"movw	r12, %[hvc_num]\n\t"
> > 		...
> > 		"hvc	#0"
> > 		:: [hvc_num] "i" (NUMBER) : "r12"
> > 	);
> > 
> 
> OK, we can arrange the hypercall code to be like that.
> Also with your patch series it would be "_hvc" because of the .macro,
> right?

Yes, but I would avoid making too many assumptions about the final form
of that patch -- it looks like there's significant work to do there,
since I made some unsafe assumptions about how the tools work...

We might end up with a magic #define after all.

> > This is the kind of problem which goes away when out-of-lining the
> > hvc wrapper behind a C function interface, since the ABI then provides
> > guarantees about how values are mershaled into and out of that code.
> 
> Do you mean implementing the entire HYPERVISOR_example_op in assembly
> and calling it from C?
> Because I guess that gcc would still be free to mess with the registers
> between the C function entry point and any inline assembly code.

gcc can arrange for the relevant things to be already in r0-r3 and the
relevant stack slots before branching to a function just as for inline
asm.  The only differences are that the compiler cannot choose which
registers to use, and the branch cannot be optimised away by the compiler
(the CPU may be able to optimise the branch away at runtime of course,
but that's another story...)

What libc appears to do is wrap each syscall in a separate function.
This means that it's not necessary to shuffle all the arguments by
one position when invoking the actual syscall.  (The generic "syscall"
function does of course need to shuffle the arguments so as to
displace the syscall number from the first argument to r7 --
but that's hard to avoid without inlining.)

For example:

00090b50 <shmdt>:
   90b50:       e52d7004        push    {r7}            ; (str r7, [sp, #-4]!)
   90b54:       e59f7010        ldr     r7, [pc, #16]   ; 90b6c <shmdt+0x1c>
   90b58:       ef000000        svc     0x00000000
   90b5c:       e49d7004        pop     {r7}            ; (ldr r7, [sp], #4)
   90b60:       e3700a01        cmn     r0, #4096       ; 0x1000
...

Syscalls with more than 4 args still need to load the extra ones
from the stack, of course:

00090090 <getsockopt>:
   90090:       e92d0090        push    {r4, r7}
   90094:       e59d4008        ldr     r4, [sp, #8]
   90098:       e59f7010        ldr     r7, [pc, #16]   ; 900b0 <getsockopt+0x20>
   9009c:       ef000000        svc     0x00000000
...


I don't know whether that makes sense for a hypervisor... it partly
depends on how many different hypercalls there are.

By all means implement it both ways and measure the performance
difference, if possible.

Cheers
---Dave
