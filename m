Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab2GOVeO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 17:34:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52974 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919Ab2GOVeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 17:34:12 -0400
Date: Sun, 15 Jul 2012 22:33:37 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120715213336.GA25830@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20120714093032.GA23316@elf.ucw.cz>
 <20120715121644.GB10597@arm.com>
 <201207151943.08183.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207151943.08183.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2012 at 08:43:07PM +0100, Arnd Bergmann wrote:
> On Sunday 15 July 2012, Catalin Marinas wrote:
> > The AArch32 execution mode is optional, so it depends on the actual CPU
> > implementation (while AArch64 is mandatory). If the implementation
> > supports it, the most likely scenario for AArch32 at kernel level is in
> > virtual machines or the secure OS. I'll explain below why.
> > 
> > The exception (or privilege) levels on an ARMv8 architecture look like
> > this:
> > 
> > Secure World    Normal World
> > +-----+
> > | EL3 |                         - Secure monitor
> > +-----+
> >                 +-----+
> >                 | EL2 |         - Hypervisor (normal world only)
> >                 +-----+
> > +-----+         +-----+
> > | EL1 |         | EL1 |         - OS kernel (secure or normal)
> > +-----+         +-----+
> > +-----+         +-----+
> > | EL0 |         | EL0 |         - User apps (secure or normal)
> > +-----+         +-----+
> > 
> > In theory, each of these levels (implementation specific) can run both
> > AArch32 and AArch64 modes. There is however a restriction on how the
> > mode switching is done - this can only happen on a change of exception
> > level. When going up the EL the register width (RW) can never go down. A
> > lower EL can never have a higher RW than a higher EL.
> > 
> > Additionally, the RW (the AArch32/AArch64 mode) for an EL is controlled
> > by the next higher level (with EL3 hard-wired). An EL cannot cause
> > itself to switch between AArch32 and AArch64.
> 
> So is the highest level always hardwired to 64-bit on ARMv8?

If an implementation supports AArch32 at EL3 there could be some
physical (or some FPGA config) switch to choose between the two. But
since AArch64 is mandated, I don't see why one would force AArch32 at
EL3 and therefore all lower exception levels (and make a big part of the
processor unused).

It's also impossible for some software to detect whether it runs in
AArch32 or AArch64. The instruction encodings are different, so any
instructions would have to be targeted at one mode or the other,
otherwise they are undefined.

> On a related note: how does the endianess change between
> exception levels on ARMv8? Can you switch endianess every time you
> move from one level to another? Can any of the levels pick the
> endianess for itself?

Yes, a level higher than 0 can pick the endianness for itself using the
SCTLR_ELx.EE bit. For user apps, the endianness is set by the kernel.
The SETEND instruction to switch the endianness on the fly (usually in
user space) is not available in AArch64 and has also been deprecated in
AArch32 on ARMv8. It wasn't too popular.

-- 
Catalin
