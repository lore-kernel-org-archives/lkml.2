Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab2B2M6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 07:58:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36542 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab2B2M6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 07:58:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dave.martin@linaro.org designates 10.204.132.72 as permitted sender) smtp.mail=dave.martin@linaro.org
Date: Wed, 29 Feb 2012 12:58:26 +0000
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
Message-ID: <20120229125826.GC2077@linaro.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330509362.4270.20.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 09:56:02AM +0000, Ian Campbell wrote:
> On Wed, 2012-02-29 at 09:34 +0000, Dave Martin wrote:
> > On Tue, Feb 28, 2012 at 12:28:29PM +0000, Stefano Stabellini wrote:
> 
> > > I don't have a very strong opinion on which register we should use, but
> > > I would like to avoid r7 if it is already actively used by gcc.
> > 
> > But there is no framepointer for Thumb-2 code (?)
> 
> Peter Maydell suggested there was:
> > r7 is (used by gcc as) the Thumb frame pointer; I don't know if this
> > makes it worth avoiding in this context.
> 
> Sounds like it might be a gcc-ism, possibly a non-default option?
> 
> Anyway, I think r12 will be fine for our purposes so the point is rather
> moot.

Just had a chat with some tools guys -- apparently, when passing register
arguments to gcc inline asms there really isn't a guarantee that those
variables will be in the expected registers on entry to the inline asm.

If gcc reorders other function calls or other code around the inline asm
(which it can do, except under certain controlled situations), then
intervening code can clobber any registers in general.

Or, to summarise another way, there is no way to control which register
is used to pass something to an inline asm in general (often we get away
with this, and there are a lot of inline asms in the kernel that assume
it works, but the more you inline the more likely you are to get nasty
surprises).  There is no workaroud, except on some architectures where
special asm constraints allow specific individual registers to be
specified for operands (i386 for example).

If you need a specific register, this means that you must set up that
register explicitly inside the asm if you want a guarantee that the
code will work:

	asm volatile (
		"movw	r12, %[hvc_num]\n\t"
		...
		"hvc	#0"
		:: [hvc_num] "i" (NUMBER) : "r12"
	);

Of course, if you need to set up more than about 5 or 6 registers in
this way, the doubled register footprint means that the compiler will
have to start spilling stuff to the stack.


This is the kind of problem which goes away when out-of-lining the
hvc wrapper behind a C function interface, since the ABI then provides
guarantees about how values are mershaled into and out of that code.


Notwithstanding the above, even if we do make theoretically unsound
(but often true) assumptions about inline asms, ARM will be no worse
than other arches in this respect.


Other than serving as a reminder that inline asm is a deep can of
worms, this doesn't really give us a neat solution...

---Dave
