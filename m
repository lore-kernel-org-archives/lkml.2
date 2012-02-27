Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab2B0SEC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:04:02 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40845 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab2B0SD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:03:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dave.martin@linaro.org designates 10.180.92.229 as permitted sender) smtp.mail=dave.martin@linaro.org
Date: Mon, 27 Feb 2012 18:03:55 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
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
Message-ID: <20120227180355.GB2023@linaro.org>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
 <1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com>
 <1330360043.8557.302.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330360043.8557.302.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 04:27:23PM +0000, Ian Campbell wrote:
> On Thu, 2012-02-23 at 17:48 +0000, Stefano Stabellini wrote:
> > We need a register to pass the hypercall number because we might not
> > know it at compile time and HVC only takes an immediate argument.
> > 
> > Among the available registers r12 seems to be the best choice because it
> > is defined as "intra-procedure call scratch register".
> 
> R12 is not accessible from the 16 bit "T1" Thumb encoding of mov
> immediate (which can only target r0..r7).

This is untrue.  The important instructions, like MOV Rd, Rn can access
all the regs.  But anyway, there is no such thing as a Thumb-1 kernel,
so we won't really care.

> Since we support only ARMv7+ there are "T2" and "T3" encodings available
> which do allow direct mov of an immediate into R12, but are 32 bit Thumb
> instructions.
> 
> Should we use r7 instead to maximise instruction density for Thumb code?

The difference seems trivial when put into context, even if you code a
special Thumb version of the code to maximise density (the Thumb-2 code
which gets built from assembler in the kernel is very suboptimal in
size, but there simply isn't a high proportion of asm code in the kernel
anyway.)  I wouldn't consider the ARM/Thumb differences as an important
factor when deciding on a register.

One argument for _not_ using r12 for this purpose is that it is then
harder to put a generic "HVC" function (analogous to the "syscall"
syscall) out-of-line, since r12 could get destroyed by the call.  

If you don't think you will ever care about putting HVC out of line
though, it may not matter.

Cheers
---Dave
