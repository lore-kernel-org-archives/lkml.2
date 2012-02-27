Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab2B0Tdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 14:33:43 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:43964 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab2B0Tdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 14:33:41 -0500
X-IronPort-AV: E=Sophos;i="4.73,492,1325462400"; 
   d="scan'208";a="10965141"
Message-ID: <1330371219.10008.34.camel@dagon.hellion.org.uk>
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall number
 to the hypervisor
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Dave Martin <dave.martin@linaro.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 27 Feb 2012 19:33:39 +0000
In-Reply-To: <20120227180355.GB2023@linaro.org>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
	 <1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com>
	 <1330360043.8557.302.camel@zakaz.uk.xensource.com>
	 <20120227180355.GB2023@linaro.org>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 18:03 +0000, Dave Martin wrote:
> On Mon, Feb 27, 2012 at 04:27:23PM +0000, Ian Campbell wrote:
> > On Thu, 2012-02-23 at 17:48 +0000, Stefano Stabellini wrote:
> > > We need a register to pass the hypercall number because we might not
> > > know it at compile time and HVC only takes an immediate argument.
> > > 
> > > Among the available registers r12 seems to be the best choice because it
> > > is defined as "intra-procedure call scratch register".
> > 
> > R12 is not accessible from the 16 bit "T1" Thumb encoding of mov
> > immediate (which can only target r0..r7).
> 
> This is untrue.  The important instructions, like MOV Rd, Rn can access
> all the regs.  But anyway, there is no such thing as a Thumb-1 kernel,
> so we won't really care.

I did say "mov immediate", which is the one which matters when loading a
constant hypercall number (the common case). AFAIK the "mov Rd, #imm" T1
encoding cannot access all registers.

The "mov rd,rn" form only helps for syscall(2) like functions, which are
unusual, at least for Xen, although as Stefano says, they do exist.

> > Since we support only ARMv7+ there are "T2" and "T3" encodings available
> > which do allow direct mov of an immediate into R12, but are 32 bit Thumb
> > instructions.
> > 
> > Should we use r7 instead to maximise instruction density for Thumb code?
> 
> The difference seems trivial when put into context, even if you code a
> special Thumb version of the code to maximise density (the Thumb-2 code
> which gets built from assembler in the kernel is very suboptimal in
> size, but there simply isn't a high proportion of asm code in the kernel
> anyway.)  I wouldn't consider the ARM/Thumb differences as an important
> factor when deciding on a register.

OK, that's useful information. thanks.

> One argument for _not_ using r12 for this purpose is that it is then
> harder to put a generic "HVC" function (analogous to the "syscall"
> syscall) out-of-line, since r12 could get destroyed by the call.

For an out of line syscall(2) wouldn't the syscall number either be in a
standard C calling convention argument register or on the stack when the
function was called, since it is just a normal argument at that point?
As you point out it cannot be passed in r12 (and could never be, due to
the clobbering).

The syscall function itself would have to move the arguments and syscall
nr etc around before issuing the syscall.

I think the same is true of a similar hypercall(2)

> If you don't think you will ever care about putting HVC out of line
> though, it may not matter.

Ian.

