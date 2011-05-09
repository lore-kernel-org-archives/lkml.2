Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab1EIKWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 06:22:34 -0400
Received: from service87.mimecast.com ([94.185.240.25]:37693 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751508Ab1EIKWd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 06:22:33 -0400
Subject: Re: [PATCH v5 02/19] ARM: LPAE: add ISBs around MMU enabling code
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <Will.Deacon@arm.com>
In-Reply-To: <20110508214101.GO27807@n2100.arm.linux.org.uk>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
	 <1304859098-10760-3-git-send-email-catalin.marinas@arm.com>
	 <20110508214101.GO27807@n2100.arm.linux.org.uk>
Organization: ARM Limited
Date: Mon, 09 May 2011 11:22:19 +0100
Message-ID: <1304936539.7658.31.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 09 May 2011 10:22:23.0882 (UTC) FILETIME=[FCC4EEA0:01CC0E32]
X-MC-Unique: 111050911222704301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-08 at 22:41 +0100, Russell King - ARM Linux wrote:
> On Sun, May 08, 2011 at 01:51:21PM +0100, Catalin Marinas wrote:
> > From: Will Deacon <will.deacon@arm.com>
> >
> > Before we enable the MMU, we must ensure that the TTBR registers contain
> > sane values. After the MMU has been enabled, we jump to the *virtual*
> > address of the following function, so we also need to ensure that the
> > SCTLR write has taken effect.
> >
> > This patch adds ISB instructions around the SCTLR write to ensure the
> > visibility of the above.
> 
> Maybe this should be extended to the arch/arm/kernel/sleep.S code too?

Yes.

> >  __turn_mmu_on:
> >       mov     r0, r0
> > +     instr_sync
> >       mcr     p15, 0, r0, c1, c0, 0           @ write control reg
> >       mrc     p15, 0, r3, c0, c0, 0           @ read id reg
> > +     instr_sync
> >       mov     r3, r3
> >       mov     r3, r13
> >       mov     pc, r3
> 
> Could we avoid the second isb by doing something like this instead:
> 
>         mrc     p15, 0, r3, c0, c0, 0           @ read id reg
>         and     r3, r3, r13
>         orr     r3, r3, r13
>         mov     pc, r3
> 
> The read from the ID register must complete before the branch can be
> taken as the value is involved in computing the address to jump to
> (even though that value has no actual effect on that address.)  This
> assumes that the read from CP15 can't complete until the previous
> write has completed.

I'm not entirely sure this would work on all (future) implementations.
There may be a slight difference between completion vs visibility to
subsequent instructions.

The MMU enable bit status may be already sampled by instructions in the
pipeline. Even if the "mov pc, r3" waits (pipeline stalled) for the read
back from SCTLR, it may still consider the MMU as being disabled by
having sampled the corresponding bit earlier. That's why CP15 operations
changing translations etc. require ISB and A15 is more restrictive here
(or we could say more relaxed on when the CP15 operation have an
effect).

Alternatively an exception return would do as well (like movs pc, lr)
but I think we still add some code for setting up the SPSR.

> What I'm concerned about is adding additional code to this path - we
> know it has some strict alignment requirements on some CPUs which
> otherwise misbehave, normally by faulting in some way.

The code path would be only changed on ARMv6+, otherwise the macro is
empty. Have you seen any issues with changing this code on newer CPUs?

-- 
Catalin


