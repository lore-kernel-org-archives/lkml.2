Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab2CAKLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 05:11:17 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58234 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2CAKLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 05:11:15 -0500
Date: Thu, 1 Mar 2012 10:10:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Martin <dave.martin@linaro.org>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall
	number to the hypervisor
Message-ID: <20120301101029.GB7363@n2100.arm.linux.org.uk>
References: <1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com> <1330360043.8557.302.camel@zakaz.uk.xensource.com> <20120227180355.GB2023@linaro.org> <1330371219.10008.34.camel@dagon.hellion.org.uk> <20120228102040.GB2063@linaro.org> <1330426133.31269.70.camel@zakaz.uk.xensource.com> <alpine.DEB.2.00.1202281149210.23091@kaball-desktop> <20120229093436.GA2077@linaro.org> <1330509362.4270.20.camel@zakaz.uk.xensource.com> <20120229125826.GC2077@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120229125826.GC2077@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 12:58:26PM +0000, Dave Martin wrote:
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

The best you can do is:

	register unsigned int foo asm("r7") = value;

	asm("blah %0" : : "r" (foo));

and ensure that your assembly checks that %0 _is_ r7 and produces a build
error if not.  See the __asmeq() macro in asm/system.h to find out how to
do that.

This feature has been missing from ARM GCC for quite a long time - it's
used extensively on x86 GCC, where they have one register class per
register, so they can do stuff like:

	asm("blah %0" : : "a" (value));

and be guaranteed that %0 will be eax.

> If you need a specific register, this means that you must set up that
> register explicitly inside the asm if you want a guarantee that the
> code will work:
> 
> 	asm volatile (
> 		"movw	r12, %[hvc_num]\n\t"
> 		...
> 		"hvc	#0"
> 		:: [hvc_num] "i" (NUMBER) : "r12"
> 	);
> 
> Of course, if you need to set up more than about 5 or 6 registers in
> this way, the doubled register footprint means that the compiler will
> have to start spilling stuff to the stack.

No it won't - it will barf instead - think about it.  If you're clobbering
r0 - r5, but need to pass in six values in registers, gcc can't use r0-r5
for that, so it must use the remaining registers.  It gets rather unhappy
with that, and starts erroring out (iirc 'too many reloads' or some similar
error.)  I've been there.

If you want to do it that way, your only option is to store them to memory
and pass the address of the block into the assembly, and reload them there.
Which is extremely sucky and inefficient.

Practically, the register variable plus asm() does seem to work, and seems
to work for virtually all gcc versions out there (there have been the odd
buggy version, but those bugs appear to get fixed.)

