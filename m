Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab2GOMRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 08:17:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36734 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534Ab2GOMRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 08:17:18 -0400
Date: Sun, 15 Jul 2012 13:16:44 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120715121644.GB10597@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
 <201207071927.13135.arnd@arndb.de>
 <20120710071023.GA10456@gmail.com>
 <20120710101018.GE15120@arm.com>
 <20120714093032.GA23316@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120714093032.GA23316@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 10:30:32AM +0100, Pavel Machek wrote:
> > > > Agreed. It's clear from the code that it started out as a copy 
> > > > of the 32 bit ARM code base, which I think was a mistake, but 
> > > > it has also moved on since then and many areas of the 64 bit 
> > > > code are now much cleaner because they don't have to worry 
> > > > about breaking legacy code. We're also more flexible with 
> > > > trying out stuff without having to worry about breaking some 
> > > > 10 year old board code.
> > > 
> > > Just for the record, you guys are repeating all the same 
> > > arguments that led to the x86_64 fork a decade ago...
> > 
> > As I stated already, comparing AArch64 to x86_64 is not right. So even
> > if the arguments may look the same, the context is *different*. AArch64
> > is *not* an extension to the AArch32 mode.
> 
> Is it possible to boot 32-bit OS on aarch64 machine?
> 
> IOW, is it compatible in supervisor mode, too?

The AArch32 execution mode is optional, so it depends on the actual CPU
implementation (while AArch64 is mandatory). If the implementation
supports it, the most likely scenario for AArch32 at kernel level is in
virtual machines or the secure OS. I'll explain below why.

The exception (or privilege) levels on an ARMv8 architecture look like
this:

Secure World	Normal World
+-----+
| EL3 |				- Secure monitor
+-----+
		+-----+
		| EL2 |		- Hypervisor (normal world only)
		+-----+
+-----+		+-----+
| EL1 |		| EL1 |		- OS kernel (secure or normal)
+-----+		+-----+
+-----+		+-----+
| EL0 |		| EL0 |		- User apps (secure or normal)
+-----+		+-----+

In theory, each of these levels (implementation specific) can run both
AArch32 and AArch64 modes. There is however a restriction on how the
mode switching is done - this can only happen on a change of exception
level. When going up the EL the register width (RW) can never go down. A
lower EL can never have a higher RW than a higher EL.

Additionally, the RW (the AArch32/AArch64 mode) for an EL is controlled
by the next higher level (with EL3 hard-wired). An EL cannot cause
itself to switch between AArch32 and AArch64.

AArch64 Linux always runs in normal world because that's where we have
virtualisation support for KVM etc. It is normally started at EL2 (but
falling shortly to EL1) unless it is a guest OS which does not have
access to the virtualisation features.

The secure world on the left hand side runs some dedicated secure
software and the communication between the two worlds is handled via
EL3. That's also the reset mode, so SoC firmware needs to run there. The
secure OS could be a 32-bit one given the investment security companies
put in certification (and that's one reason to have AArch32 support at
EL1)

On the Linux side, to be able to start a 32-bit ARM kernel the firmware
at EL3 would have to configure the lower modes as AArch32. Once that's
done, lower mode would never be able to upgrade itself to AArch64
(rendering all the AArch64 features pretty much unusable). So we require
that any SoC firmware starts the next stage boot-loader or non-secure OS
in AArch64. AArch64 Linux is able to change the execution mode for user
at EL0 (as it is lower). Guest OSes could also run in AArch32 long as
the host Linux has control of EL2.

So while it is possible, the primary target for 32-bit at the OS kernel
level is virtualisation. We also don't plan to support a 32-bit SoC on
ARMv8 systems, given that the compat layer is fully functional.

-- 
Catalin
