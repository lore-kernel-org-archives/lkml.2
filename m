Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab2B0Tst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 14:48:49 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:57398 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab2B0Tsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 14:48:47 -0500
X-IronPort-AV: E=Sophos;i="4.73,492,1325462400"; 
   d="scan'208";a="10965291"
Message-ID: <1330372125.10008.47.camel@dagon.hellion.org.uk>
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall number
 to the hypervisor
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Dave Martin <dave.martin@linaro.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 27 Feb 2012 19:48:45 +0000
In-Reply-To: <20120227175327.GA2023@linaro.org>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
	 <1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <20120227175327.GA2023@linaro.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 17:53 +0000, Dave Martin wrote:
> On Thu, Feb 23, 2012 at 05:48:22PM +0000, Stefano Stabellini wrote:
> > We need a register to pass the hypercall number because we might not
> > know it at compile time and HVC only takes an immediate argument.
> > 
> > Among the available registers r12 seems to be the best choice because it
> > is defined as "intra-procedure call scratch register".
> 
> This would be massively simplified if you didn't try to inline the HVC.
> Does it really need to be inline?
>
> > +#define __HYPERCALL ".word 0xe1400070 + " __HVC_IMM(XEN_HYPERCALL_TAG)
> 
> Please, do not do this.  It won't work in Thumb, where the encodings are
> different.
> 
> It is reasonable to expect anyone building Xen to have reasonably new
> tools, you you can justifiably use
> 
> AFLAGS_thisfile.o := -Wa,-march=armv7-a+virt
> 
> in the Makefile and just use the hvc instruction directly.

Our aim is for guest kernel binaries not to be specific to Xen -- i.e.
they should be able to run on baremetal and other hypervisors as well.
The differences should only be in the device-tree passed to the kernel.

> Of course, this is only practical if the HVC invocation is not inlined.

I suppose we could make the stub functions out of line, we just copied
what Xen does on x86.

The only thing which springs to mind is that 5 argument hypercalls will
end up pushing the fifth argument to the stack only to pop it back into
r4 for the hypercall and IIRC it also needs to preserve r4 (callee saved
reg) which is going to involve some small amount of code to move stuff
around too.

So by inlining the functions we avoid some thunking because the compiler
would know exactly what was happening at the hypercall site.

We don't currently have any 6 argument hypercalls but the same would
extend there.

> If we can't avoid macro-ising HVC, we should do it globally, not locally
> to the Xen code.  That way we at least keep all the horror in one place.

That sounds like a good idea to me.

Given that Stefano is proposing to make the ISS a (per-hypervisor)
constant we could consider just defining the Thumb and non-Thumb
constants instead of doing all the construction with the __HVC_IMM stuff
-- that would remove a big bit of the macroization.

Ian.

