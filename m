Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965079Ab2CAJfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 04:35:52 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50854 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2CAJfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 04:35:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dave.martin@linaro.org designates 10.204.154.133 as permitted sender) smtp.mail=dave.martin@linaro.org
Date: Thu, 1 Mar 2012 09:35:33 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Peter Maydell <peter.maydell@linaro.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
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
Message-ID: <20120301093533.GB2034@linaro.org>
References: <1330360043.8557.302.camel@zakaz.uk.xensource.com>
 <20120227180355.GB2023@linaro.org>
 <1330371219.10008.34.camel@dagon.hellion.org.uk>
 <20120228102040.GB2063@linaro.org>
 <1330426133.31269.70.camel@zakaz.uk.xensource.com>
 <alpine.DEB.2.00.1202281149210.23091@kaball-desktop>
 <20120229093436.GA2077@linaro.org>
 <1330509362.4270.20.camel@zakaz.uk.xensource.com>
 <20120229125826.GC2077@linaro.org>
 <1330526664.4270.128.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330526664.4270.128.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 02:44:24PM +0000, Ian Campbell wrote:
> On Wed, 2012-02-29 at 12:58 +0000, Dave Martin wrote:
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
> 
> I had assumed I just couldn't find the right syntax. Useful to know that
> I couldn't find it because it doesn't exist!
> 
> > If you need a specific register, this means that you must set up that
> > register explicitly inside the asm if you want a guarantee that the
> > code will work:
> > 
> > 	asm volatile (
> > 		"movw	r12, %[hvc_num]\n\t"
> 
> Is gcc (or gas?) smart enough to optimise this away if it turns out that
> %[hvc_num] == r12?

No, unfortunately.  Except for the information defined by the constraints,
the inline asm block is completely opaque to the compiler (except for
pasting in operands -- which is a string operation done with no knowledge
of what the text means for the assembler).

> 
> > 		...
> > 		"hvc	#0"
> > 		:: [hvc_num] "i" (NUMBER) : "r12"
> > 	);
> > 
> > Of course, if you need to set up more than about 5 or 6 registers in
> > this way, the doubled register footprint means that the compiler will
> > have to start spilling stuff to the stack.
> > 
> > 
> > This is the kind of problem which goes away when out-of-lining the
> > hvc wrapper behind a C function interface, since the ABI then provides
> > guarantees about how values are mershaled into and out of that code.
> 
> I don't think anything would stop gcc from clobbering an argument
> register right on function entry (e..g it might move r0 to r8 and
> clobber r0, for whatever reason), so that they are no longer where you
> expect them to be when you hit the asm. Unlikely perhaps but no more so
> than the other issues you've raised?
> 	
> Or did you mean out-of-line as in "written in a .S file" as well as out
> of line?

Yes.  Some toolchains have a concept of out-of-line assembler functions
in a .c file, but gcc doesn't -- the asm is always inline in its
immediate context, even if the containing function won't be inlined.

However, the compiler would have to be applying pretty creative
optimizations to break cases cases where an inlinable function contains,
say, nothing except for declarations, the asm() and a return statement.

I feel that the kernel implicitly relies on such things working in too
many places for breakage of that assumption to go unnoticed.

> 
> > Notwithstanding the above, even if we do make theoretically unsound
> > (but often true) assumptions about inline asms, ARM will be no worse
> > than other arches in this respect.
> 
> This is true.
> 
> > Other than serving as a reminder that inline asm is a deep can of
> > worms, this doesn't really give us a neat solution...
> 
> How are system calls implemented on the userspace side? I confess I
> don't know what the ARM syscall ABI looks like -- is it all registers or
> is some of it on the stack? It sounds like the solution ought to be
> pretty similar though.

I _believe_ it's now out of line in most cases.

I'm not sure I totally understand it all, though:

http://www.eglibc.org/cgi-bin/viewvc.cgi/trunk/ports/sysdeps/unix/sysv/linux/arm/eabi/

There is an internal inline syscall wrapper INTERNAL_SYSCALL_RAW(), but
I can't see where it is used.  For Thumb code it actually just munges
registers around and calls an out-of-line function.

If I grep the disassembly of a recent EABI libc, there appear to be only
207 svc call sites, and most of them look like they are out-of-linux
wrappers, generated from the DO_CALL macro in
ports/sysdeps/unix/sysv/linux/arm/eabi/sysdep.h

That's based on a hasty reading of the code though... I'm not very
familiar with the way libc works.  (Disassembling stripped arm binaries
can also be a bit unrelieable.)

It's also worth nothing that the inline asm sycall macros which used
to exist in userspace <asm/unistd.h> are gone (at least for EABI).

Cheers
---Dave
