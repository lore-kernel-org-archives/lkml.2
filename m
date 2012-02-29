Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab2B2Opx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:45:53 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:52161 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059Ab2B2Opv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:45:51 -0500
X-IronPort-AV: E=Sophos;i="4.73,502,1325462400"; 
   d="scan'208";a="11012105"
Date: Wed, 29 Feb 2012 14:52:38 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Dave Martin <dave.martin@linaro.org>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        Peter Maydell <peter.maydell@linaro.org>,
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
In-Reply-To: <20120229125826.GC2077@linaro.org>
Message-ID: <alpine.DEB.2.00.1202291435400.23091@kaball-desktop>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop> <1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com> <1330360043.8557.302.camel@zakaz.uk.xensource.com> <20120227180355.GB2023@linaro.org> <1330371219.10008.34.camel@dagon.hellion.org.uk>
 <20120228102040.GB2063@linaro.org> <1330426133.31269.70.camel@zakaz.uk.xensource.com> <alpine.DEB.2.00.1202281149210.23091@kaball-desktop> <20120229093436.GA2077@linaro.org> <1330509362.4270.20.camel@zakaz.uk.xensource.com>
 <20120229125826.GC2077@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012, Dave Martin wrote:
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
> 
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

OK, we can arrange the hypercall code to be like that.
Also with your patch series it would be "_hvc" because of the .macro,
right?



> This is the kind of problem which goes away when out-of-lining the
> hvc wrapper behind a C function interface, since the ABI then provides
> guarantees about how values are mershaled into and out of that code.

Do you mean implementing the entire HYPERVISOR_example_op in assembly
and calling it from C?
Because I guess that gcc would still be free to mess with the registers
between the C function entry point and any inline assembly code.
