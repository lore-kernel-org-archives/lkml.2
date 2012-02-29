Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab2B2Ooa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:44:30 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:16422 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab2B2Oo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:44:28 -0500
X-IronPort-AV: E=Sophos;i="4.73,502,1325462400"; 
   d="scan'208";a="11012055"
Message-ID: <1330526664.4270.128.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall number
 to the hypervisor
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Dave Martin <dave.martin@linaro.org>
CC: Peter Maydell <peter.maydell@linaro.org>,
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
Date: Wed, 29 Feb 2012 14:44:24 +0000
In-Reply-To: <20120229125826.GC2077@linaro.org>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
	 <1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <1330360043.8557.302.camel@zakaz.uk.xensource.com>
	 <20120227180355.GB2023@linaro.org>
	 <1330371219.10008.34.camel@dagon.hellion.org.uk>
	 <20120228102040.GB2063@linaro.org>
	 <1330426133.31269.70.camel@zakaz.uk.xensource.com>
	 <alpine.DEB.2.00.1202281149210.23091@kaball-desktop>
	 <20120229093436.GA2077@linaro.org>
	 <1330509362.4270.20.camel@zakaz.uk.xensource.com>
	 <20120229125826.GC2077@linaro.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 12:58 +0000, Dave Martin wrote:
> On Wed, Feb 29, 2012 at 09:56:02AM +0000, Ian Campbell wrote:
> > On Wed, 2012-02-29 at 09:34 +0000, Dave Martin wrote:
> > > On Tue, Feb 28, 2012 at 12:28:29PM +0000, Stefano Stabellini wrote:
> > 
> > > > I don't have a very strong opinion on which register we should use, but
> > > > I would like to avoid r7 if it is already actively used by gcc.
> > > 
> > > But there is no framepointer for Thumb-2 code (?)
> > 
> > Peter Maydell suggested there was:
> > > r7 is (used by gcc as) the Thumb frame pointer; I don't know if this
> > > makes it worth avoiding in this context.
> > 
> > Sounds like it might be a gcc-ism, possibly a non-default option?
> > 
> > Anyway, I think r12 will be fine for our purposes so the point is rather
> > moot.
> 
> Just had a chat with some tools guys -- apparently, when passing register
> arguments to gcc inline asms there really isn't a guarantee that those
> variables will be in the expected registers on entry to the inline asm.
> 
> If gcc reorders other function calls or other code around the inline asm
> (which it can do, except under certain controlled situations), then
> intervening code can clobber any registers in general.
> 
> Or, to summarise another way, there is no way to control which register
> is used to pass something to an inline asm in general (often we get away
> with this, and there are a lot of inline asms in the kernel that assume
> it works, but the more you inline the more likely you are to get nasty
> surprises).  There is no workaroud, except on some architectures where
> special asm constraints allow specific individual registers to be
> specified for operands (i386 for example).

I had assumed I just couldn't find the right syntax. Useful to know that
I couldn't find it because it doesn't exist!

> If you need a specific register, this means that you must set up that
> register explicitly inside the asm if you want a guarantee that the
> code will work:
> 
> 	asm volatile (
> 		"movw	r12, %[hvc_num]\n\t"

Is gcc (or gas?) smart enough to optimise this away if it turns out that
%[hvc_num] == r12?

> 		...
> 		"hvc	#0"
> 		:: [hvc_num] "i" (NUMBER) : "r12"
> 	);
> 
> Of course, if you need to set up more than about 5 or 6 registers in
> this way, the doubled register footprint means that the compiler will
> have to start spilling stuff to the stack.
> 
> 
> This is the kind of problem which goes away when out-of-lining the
> hvc wrapper behind a C function interface, since the ABI then provides
> guarantees about how values are mershaled into and out of that code.

I don't think anything would stop gcc from clobbering an argument
register right on function entry (e..g it might move r0 to r8 and
clobber r0, for whatever reason), so that they are no longer where you
expect them to be when you hit the asm. Unlikely perhaps but no more so
than the other issues you've raised?
	
Or did you mean out-of-line as in "written in a .S file" as well as out
of line?

> Notwithstanding the above, even if we do make theoretically unsound
> (but often true) assumptions about inline asms, ARM will be no worse
> than other arches in this respect.

This is true.

> Other than serving as a reminder that inline asm is a deep can of
> worms, this doesn't really give us a neat solution...

How are system calls implemented on the userspace side? I confess I
don't know what the ARM syscall ABI looks like -- is it all registers or
is some of it on the stack? It sounds like the solution ought to be
pretty similar though.

Ian.

