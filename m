Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1FBTLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 15:11:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:46420 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753850Ab1FBTLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 15:11:22 -0400
Content-Type: text/plain; charset="utf-8"
Date: Thu, 02 Jun 2011 21:11:19 +0200
From: "Gerhard Pircher" <gerhard_pircher@gmx.net>
In-Reply-To: <20110601180456.801265664@duck.linux-mips.net>
Message-ID: <20110602191119.302850@gmx.net>
MIME-Version: 1.0
References: <20110601180456.801265664@duck.linux-mips.net>
Subject: Re: [patch 00/14] Sort out i8253 and PC speaker locking and headers
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
X-Authenticated: #6097454
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18w5/dFYqkwDxkMXxcR8UnF8t7xluvojvRb01NyA4
 5fGVYQxYBslvCxtlMZPZkr0/HU0NV7IfccLQ== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: b9fSeTgxTiE+Wl1rOmRwhZZ9ZUVSRNcl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
> Datum: Wed, 01 Jun 2011 19:04:56 +0100
> Von: ralf@linux-mips.org
> An: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-alpha@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-mips@linux-mips.org
> Betreff: [patch 00/14] Sort out i8253 and PC speaker locking and headers

> No longer terribly relevant these days but still broken and just an
> eyesore mess of neglience just as I've already raised it a few days 
> ago.  Time to sort this.
> 
> drivers/input/misc/pcspkr.c:
> 
> #if defined(CONFIG_MIPS) || defined(CONFIG_X86)
> /* Use the global PIT lock ! */
> #include <asm/i8253.h>
> #else
> #include <asm/8253pit.h>
> static DEFINE_RAW_SPINLOCK(i8253_lock);
> #endif
> 
> sound/drivers/pcsp/pcsp.h:
> 
> #if defined(CONFIG_MIPS) || defined(CONFIG_X86)
> /* Use the global PIT lock ! */
> #include <asm/i8253.h>
> #else
> #include <asm/8253pit.h>
> static DEFINE_RAW_SPINLOCK(i8253_lock);
> 
> $ git grep -F pcsp.h sound/drivers/pcsp
> sound/drivers/pcsp/pcsp.c:#include "pcsp.h"
> sound/drivers/pcsp/pcsp_input.c:#include "pcsp.h"
> sound/drivers/pcsp/pcsp_lib.c:#include "pcsp.h"
> sound/drivers/pcsp/pcsp_mixer.c:#include "pcsp.h"
> $ git grep -w i8253_lock sound/drivers/pcsp/
> sound/drivers/pcsp/pcsp.h:static DEFINE_RAW_SPINLOCK(i8253_lock);
> sound/drivers/pcsp/pcsp_input.c:        raw_spin_lock_irqsave(&i8253_lock,
> flags
> sound/drivers/pcsp/pcsp_input.c:       
> raw_spin_unlock_irqrestore(&i8253_lock, 
> sound/drivers/pcsp/pcsp_lib.c:          raw_spin_lock_irqsave(&i8253_lock,
> flags
> sound/drivers/pcsp/pcsp_lib.c:         
> raw_spin_unlock_irqrestore(&i8253_lock, 
> sound/drivers/pcsp/pcsp_lib.c:  raw_spin_lock(&i8253_lock);
> sound/drivers/pcsp/pcsp_lib.c:  raw_spin_unlock(&i8253_lock);
> sound/drivers/pcsp/pcsp_lib.c:  raw_spin_lock(&i8253_lock);
> sound/drivers/pcsp/pcsp_lib.c:  raw_spin_unlock(&i8253_lock);
> 
> Locks are great, everybody should have their own lock!
> 
> $ find . -name 8253pit.h
> ./arch/powerpc/include/asm/8253pit.h
> ./arch/alpha/include/asm/8253pit.h
> $ cat arch/*/include/asm/8253pit.h
> /*
>  * 8253/8254 Programmable Interval Timer
>  */
> /*
>  * 8253/8254 Programmable Interval Timer
>  */
> $
> 
> Eh...
> 
> $ git grep -w PCSPKR_PLATFORM 
> arch/mips/Kconfig:      select PCSPKR_PLATFORM
> arch/mips/Kconfig:      select PCSPKR_PLATFORM
> arch/mips/Kconfig:      select PCSPKR_PLATFORM
> arch/powerpc/platforms/amigaone/Kconfig:        select PCSPKR_PLATFORM
> drivers/input/misc/Kconfig:     depends on PCSPKR_PLATFORM
> init/Kconfig:config PCSPKR_PLATFORM
> sound/drivers/Kconfig:  depends on PCSPKR_PLATFORM && X86 &&
> HIGH_RES_TIMERS
> 
> So the status is:
> 
>  Alpha:	There is no PCSPKR_PLATFORM so while a platform device is
> 		being installed no drivers will be built.  I don't know
> 		which Alpha platforms or even if all of Alpha should be
> 		doing a PCSPKR_PLATFORM so I haven't even tried to sort
> 		this.
>  ARM:		No PC speaker supported, yeah :)
>  PowerPC:	Should compile but the locking is wrong but only the 
>    		AmigaOne platforms should be affected.
The Kconfig dependencies cleanup patch for CHRP, PSERIES, etc. should
also apply to the AmigaOne. Can you resend it with a fix for the
AmigaOne, or should I send a patch?
I'll check next week, if the PC speaker is still working on my AmigaOne.

Thanks,
Gerhard

-- 
Empfehlen Sie GMX DSL Ihren Freunden und Bekannten und wir
belohnen Sie mit bis zu 50,- Euro! https://freundschaftswerbung.gmx.de
