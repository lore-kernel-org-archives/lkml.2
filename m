Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab2GQKq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:46:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62416 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421Ab2GQKqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:46:24 -0400
Date: Tue, 17 Jul 2012 11:45:48 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120717104547.GA18349@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <20120714093032.GA23316@elf.ucw.cz>
 <20120715121644.GB10597@arm.com>
 <201207151943.08183.arnd@arndb.de>
 <20120715213336.GA25830@arm.com>
 <20120716121651.GA18859@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120716121651.GA18859@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 16, 2012 at 01:16:51PM +0100, Pavel Machek wrote:
> > > > The AArch32 execution mode is optional, so it depends on the actual CPU
> > > > implementation (while AArch64 is mandatory). If the implementation
> > > > supports it, the most likely scenario for AArch32 at kernel level is in
> > > > virtual machines or the secure OS. I'll explain below why.
> > > > 
> > > > The exception (or privilege) levels on an ARMv8 architecture look like
> > > > this:
> > > > 
> > > > Secure World    Normal World
> > > > +-----+
> > > > | EL3 |                         - Secure monitor
> > > > +-----+
> > > >                 +-----+
> > > >                 | EL2 |         - Hypervisor (normal world only)
> > > >                 +-----+
> > > > +-----+         +-----+
> > > > | EL1 |         | EL1 |         - OS kernel (secure or normal)
> > > > +-----+         +-----+
> > > > +-----+         +-----+
> > > > | EL0 |         | EL0 |         - User apps (secure or normal)
> > > > +-----+         +-----+
> > > > 
> > > > In theory, each of these levels (implementation specific) can run both
> > > > AArch32 and AArch64 modes. There is however a restriction on how the
> > > > mode switching is done - this can only happen on a change of exception
> > > > level. When going up the EL the register width (RW) can never go down. A
> > > > lower EL can never have a higher RW than a higher EL.
> > > > 
> > > > Additionally, the RW (the AArch32/AArch64 mode) for an EL is controlled
> > > > by the next higher level (with EL3 hard-wired). An EL cannot cause
> > > > itself to switch between AArch32 and AArch64.
> > > 
> > > So is the highest level always hardwired to 64-bit on ARMv8?
> > 
> > If an implementation supports AArch32 at EL3 there could be some
> > physical (or some FPGA config) switch to choose between the two. But
> > since AArch64 is mandated, I don't see why one would force AArch32 at
> > EL3 and therefore all lower exception levels (and make a big part of the
> > processor unused).
> 
> Actually I see one ... and I can bet it will happen.
> 
> So you create that shiny new ARMv8 compliant CPU, 8 cores, 2GHz. HTC
> will want to use it with 1GB of RAM...

By the time we get ARMv8 silicon, 1GB RAM is no longer the norm. There
are smartphones as Galaxy S3 with this amount of RAM already.

> and put around exiting OMAP perihepals.

Such peripherals must be supported by code under drivers/. There is a
lot of work that Arnd and Olof are doing on the ARM SoC code, so even on
AArch32 a lot of this code is cleaned up.

> At that point they will have choice of either:
> 
> 1) going arm64, with no advantages and disadvantage of having to
> debug/stabilize arm64 kernel+toolchain (+hardware; yes, early 64bit
> hardware usually has security bugs), and to port the omap code from
> arch/arm to arch/arm64

We no longer accept platform code in the way that we had on 32-bit ARM
years ago. New platform code must follow strict rules on AArch32 already
and on AArch64 we ask for even more standardisation together with single
kernel image by default. With a standard booting protocol and CPU power
management, FDT and the peripherals code into drivers/ there isn't much
(if any) left for the arch code.

> 2) just putting that 8 cores into arm32 mode. Yes, a bit of silicion
> is unused. But if the ARMv8 has most cores/biggest performance, it
> still makes sense, and 32bits is inherently faster due to pointers
> being smaller.

One of the key aspects that ARM partners try to achieve is lower power.
They would not go for an ARMv8 unless they need 64-bit processing. Even
if half of the core is not used, it still uses power (leakage) that
would drain the battery.

If one needs bigger physical address space now, there is Cortex-A15
already.

-- 
Catalin
