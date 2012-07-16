Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab2GPMRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 08:17:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57964 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab2GPMRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:17:07 -0400
Date: Mon, 16 Jul 2012 14:16:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120716121651.GA18859@elf.ucw.cz>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20120714093032.GA23316@elf.ucw.cz>
 <20120715121644.GB10597@arm.com>
 <201207151943.08183.arnd@arndb.de>
 <20120715213336.GA25830@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120715213336.GA25830@arm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > The AArch32 execution mode is optional, so it depends on the actual CPU
> > > implementation (while AArch64 is mandatory). If the implementation
> > > supports it, the most likely scenario for AArch32 at kernel level is in
> > > virtual machines or the secure OS. I'll explain below why.
> > > 
> > > The exception (or privilege) levels on an ARMv8 architecture look like
> > > this:
> > > 
> > > Secure World    Normal World
> > > +-----+
> > > | EL3 |                         - Secure monitor
> > > +-----+
> > >                 +-----+
> > >                 | EL2 |         - Hypervisor (normal world only)
> > >                 +-----+
> > > +-----+         +-----+
> > > | EL1 |         | EL1 |         - OS kernel (secure or normal)
> > > +-----+         +-----+
> > > +-----+         +-----+
> > > | EL0 |         | EL0 |         - User apps (secure or normal)
> > > +-----+         +-----+
> > > 
> > > In theory, each of these levels (implementation specific) can run both
> > > AArch32 and AArch64 modes. There is however a restriction on how the
> > > mode switching is done - this can only happen on a change of exception
> > > level. When going up the EL the register width (RW) can never go down. A
> > > lower EL can never have a higher RW than a higher EL.
> > > 
> > > Additionally, the RW (the AArch32/AArch64 mode) for an EL is controlled
> > > by the next higher level (with EL3 hard-wired). An EL cannot cause
> > > itself to switch between AArch32 and AArch64.
> > 
> > So is the highest level always hardwired to 64-bit on ARMv8?
> 
> If an implementation supports AArch32 at EL3 there could be some
> physical (or some FPGA config) switch to choose between the two. But
> since AArch64 is mandated, I don't see why one would force AArch32 at
> EL3 and therefore all lower exception levels (and make a big part of the
> processor unused).

Actually I see one ... and I can bet it will happen.

So you create that shiny new ARMv8 compliant CPU, 8 cores, 2GHz. HTC
will want to use it with 1GB of RAM... and put around exiting OMAP
perihepals.

At that point they will have choice of either:

1) going arm64, with no advantages and disadvantage of having to
debug/stabilize arm64 kernel+toolchain (+hardware; yes, early 64bit
hardware usually has security bugs), and to port the omap code from
arch/arm to arch/arm64

2) just putting that 8 cores into arm32 mode. Yes, a bit of silicion
is unused. But if the ARMv8 has most cores/biggest performance, it
still makes sense, and 32bits is inherently faster due to pointers
being smaller.

I know I did boot early amd64 machines in 32bit mode; avoiding all the
64bit complexity. I'm pretty sure someone will want to do that on arm.

Now, you may say "we'll just refuse to merge 32-bit support for 64-bit
capable machines"... I believe that's unneccessarily cruel... and may
rule out multi-user servers due to security problems.

      		      	     	  	       	       	       	  Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
