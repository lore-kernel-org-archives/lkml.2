Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab1FCTWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 15:22:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:37783 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755394Ab1FCTWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 15:22:34 -0400
Cc: benh@kernel.crashing.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-alpha@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@linux-mips.org
Content-Type: text/plain; charset="utf-8"
Date: Fri, 03 Jun 2011 21:22:30 +0200
From: "Gerhard Pircher" <gerhard_pircher@gmx.net>
In-Reply-To: <20110603180038.GA13239@linux-mips.org>
Message-ID: <20110603192230.246630@gmx.net>
MIME-Version: 1.0
References: <20110601180456.801265664@duck.linux-mips.net>
 <20110602191119.302850@gmx.net> <20110603180038.GA13239@linux-mips.org>
Subject: Re: [patch 00/14] Sort out i8253 and PC speaker locking and headers
To: Ralf Baechle <ralf@linux-mips.org>
X-Authenticated: #6097454
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18K9bI4TecKnQl0LIFRJILuFBXWNwsVtPMNBnKxN0
 cLVaDc6YahRvoVEjPYRfU8eyB/4h5dOBB2mQ== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: OUGIKT4Ba0A7Q09lKDEze/I/Njh6dA7z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
> Datum: Fri, 3 Jun 2011 19:00:38 +0100
> Von: Ralf Baechle <ralf@linux-mips.org>
> An: Gerhard Pircher <gerhard_pircher@gmx.net>
> CC: linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Betreff: Re: [patch 00/14] Sort out i8253 and PC speaker locking and headers

> On Thu, Jun 02, 2011 at 09:11:19PM +0200, Gerhard Pircher wrote:
> 
> > > #if defined(CONFIG_MIPS) || defined(CONFIG_X86)
> > > /* Use the global PIT lock ! */
> > > #include <asm/i8253.h>
> > > #else
> > > #include <asm/8253pit.h>
> > > static DEFINE_RAW_SPINLOCK(i8253_lock);
> > > #endif
> > > 
> > > sound/drivers/pcsp/pcsp.h:
> > > 
> > > #if defined(CONFIG_MIPS) || defined(CONFIG_X86)
> > > /* Use the global PIT lock ! */
> > > #include <asm/i8253.h>
> > > #else
> > > #include <asm/8253pit.h>
> > > static DEFINE_RAW_SPINLOCK(i8253_lock);
> > > 
> > > $ git grep -F pcsp.h sound/drivers/pcsp
> > > sound/drivers/pcsp/pcsp.c:#include "pcsp.h"
> > > sound/drivers/pcsp/pcsp_input.c:#include "pcsp.h"
> > > sound/drivers/pcsp/pcsp_lib.c:#include "pcsp.h"
> > > sound/drivers/pcsp/pcsp_mixer.c:#include "pcsp.h"
> > > $ git grep -w i8253_lock sound/drivers/pcsp/
> > > sound/drivers/pcsp/pcsp.h:static DEFINE_RAW_SPINLOCK(i8253_lock);
> > > sound/drivers/pcsp/pcsp_input.c:       
> raw_spin_lock_irqsave(&i8253_lock,
> > > flags
> > > sound/drivers/pcsp/pcsp_input.c:       
> > > raw_spin_unlock_irqrestore(&i8253_lock, 
> > > sound/drivers/pcsp/pcsp_lib.c:         
> raw_spin_lock_irqsave(&i8253_lock,
> > > flags
> > > sound/drivers/pcsp/pcsp_lib.c:         
> > > raw_spin_unlock_irqrestore(&i8253_lock, 
> > > sound/drivers/pcsp/pcsp_lib.c:  raw_spin_lock(&i8253_lock);
> > > sound/drivers/pcsp/pcsp_lib.c:  raw_spin_unlock(&i8253_lock);
> > > sound/drivers/pcsp/pcsp_lib.c:  raw_spin_lock(&i8253_lock);
> > > sound/drivers/pcsp/pcsp_lib.c:  raw_spin_unlock(&i8253_lock);
> > > 
> > > Locks are great, everybody should have their own lock!
> > > 
> > > $ find . -name 8253pit.h
> > > ./arch/powerpc/include/asm/8253pit.h
> > > ./arch/alpha/include/asm/8253pit.h
> > > $ cat arch/*/include/asm/8253pit.h
> > > /*
> > >  * 8253/8254 Programmable Interval Timer
> > >  */
> > > /*
> > >  * 8253/8254 Programmable Interval Timer
> > >  */
> > > $
> > > 
> > > Eh...
> > > 
> > > $ git grep -w PCSPKR_PLATFORM 
> > > arch/mips/Kconfig:      select PCSPKR_PLATFORM
> > > arch/mips/Kconfig:      select PCSPKR_PLATFORM
> > > arch/mips/Kconfig:      select PCSPKR_PLATFORM
> > > arch/powerpc/platforms/amigaone/Kconfig:        select PCSPKR_PLATFORM
> > > drivers/input/misc/Kconfig:     depends on PCSPKR_PLATFORM
> > > init/Kconfig:config PCSPKR_PLATFORM
> > > sound/drivers/Kconfig:  depends on PCSPKR_PLATFORM && X86 &&
> > > HIGH_RES_TIMERS
> > > 
> > > So the status is:
> > > 
> > >  Alpha:	There is no PCSPKR_PLATFORM so while a platform device is
> > > 		being installed no drivers will be built.  I don't know
> > > 		which Alpha platforms or even if all of Alpha should be
> > > 		doing a PCSPKR_PLATFORM so I haven't even tried to sort
> > > 		this.
> > >  ARM:		No PC speaker supported, yeah :)
> > >  PowerPC:	Should compile but the locking is wrong but only the 
> > >    		AmigaOne platforms should be affected.
> > The Kconfig dependencies cleanup patch for CHRP, PSERIES, etc. should
> > also apply to the AmigaOne. Can you resend it with a fix for the
> > AmigaOne, or should I send a patch?
> 
> I can sort that; it's easy enough.
Thanks a lot!

> > I'll check next week, if the PC speaker is still working on my
> > AmigaOne.
> 
> I can't imagine that it's going to break - the code is sorta simple ;-)
That's true, but testing the most recent Linux kernel on the AmigaOne is
never wrong. :-)

> One obscurity I noticed is this bit in the amigaone.dts:
> 
>         timer@40 {
>                 // Also adds pcspkr to platform devices.
>                 compatible = "pnpPNP,100";
>                 reg = <1 0x00000040 0x00000020>;
>         };
> 
> Shouldn't that rather be something like the following?
> 
>         pcspeaker@61 {
>                 device_type = "sound";
>                 compatible = "pnpPNP,800";
>                 reg = <1 0x61 1>;
>         };
> 
> pnpPNP,100 is the i8253 timer as I understand and pnpPNP,800 the PC
> speaker.
> If you interpret pnpPNP,100 to imply the presence of a PC speaker you
> can't express a system that has a i8253 but no PCspeaker in a DT so
> maybe amigaone.dts and arch/powerpc/kernel/setup-common.c should be
> changed to use pnpPNP,800 instead?

That would be cleaner, but I guess it would break CHRP and PSERIES.
These platforms probably only provide a pnpPNP,100 entry in the device
tree (at least that's the case on the Pegasos2 CHRP machine AFAICT).

Gerhard
-- 
NEU: FreePhone - kostenlos mobil telefonieren!			
Jetzt informieren: http://www.gmx.net/de/go/freephone
