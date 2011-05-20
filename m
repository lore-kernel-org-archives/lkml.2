Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934224Ab1ETP3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:29:06 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:50148 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934140Ab1ETP3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:29:04 -0400
Date: Fri, 20 May 2011 17:17:27 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 15/19] ARM: LPAE: Add support for
 cpu_v7_do_(suspend|resume)
Message-ID: <20110520151727.GW15292@game.jcrosoft.org>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
 <1304859098-10760-16-git-send-email-catalin.marinas@arm.com>
 <20110518072737.GC6815@atomide.com>
 <1305897667.2788.98.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305897667.2788.98.camel@e102109-lin.cambridge.arm.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 9852468610239671107
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:21 Fri 20 May     , Catalin Marinas wrote:
> Tony,
> 
> On Wed, 2011-05-18 at 08:27 +0100, Tony Lindgren wrote:
> > * Catalin Marinas <catalin.marinas@arm.com> [110508 15:52]:
> > > --- a/arch/arm/mm/proc-v7.S
> > > +++ b/arch/arm/mm/proc-v7.S
> > > @@ -260,19 +260,32 @@ cpu_v7_name:
> > > 
> > >  /* Suspend/resume support: derived from arch/arm/mach-s5pv210/sleep.S */
> > >  .globl       cpu_v7_suspend_size
> > > +#ifdef CONFIG_ARM_LPAE
> > > +.equ cpu_v7_suspend_size, 4 * 10
> > > +#else
> > >  .equ cpu_v7_suspend_size, 4 * 8
> > > +#endif
> > >  #ifdef CONFIG_PM_SLEEP
> > >  ENTRY(cpu_v7_do_suspend)
> > >       stmfd   sp!, {r4 - r11, lr}
> > >       mrc     p15, 0, r4, c13, c0, 0  @ FCSE/PID
> > >       mrc     p15, 0, r5, c13, c0, 1  @ Context ID
> > >       mrc     p15, 0, r6, c3, c0, 0   @ Domain ID
> > > +#ifdef CONFIG_ARM_LPAE
> > > +     mrrc    p15, 0, r7, r8, c2      @ TTB 0
> > > +     mrrc    p15, 1, r2, r3, c2      @ TTB 1
> > > +#else
> > >       mrc     p15, 0, r7, c2, c0, 0   @ TTB 0
> > >       mrc     p15, 0, r8, c2, c0, 1   @ TTB 1
> > > +#endif
> > >       mrc     p15, 0, r9, c1, c0, 0   @ Control register
> > >       mrc     p15, 0, r10, c1, c0, 1  @ Auxiliary control register
> > >       mrc     p15, 0, r11, c1, c0, 2  @ Co-processor access control
> > > +#ifdef CONFIG_ARM_LPAE
> > > +     stmia   r0, {r2 - r11}
> > > +#else
> > >       stmia   r0, {r4 - r11}
> > > +#endif
> > >       ldmfd   sp!, {r4 - r11, pc}
> > >  ENDPROC(cpu_v7_do_suspend)
> > > 
> > > @@ -280,12 +293,21 @@ ENTRY(cpu_v7_do_resume)
> > >       mov     ip, #0
> > >       mcr     p15, 0, ip, c8, c7, 0   @ invalidate TLBs
> > >       mcr     p15, 0, ip, c7, c5, 0   @ invalidate I cache
> > > +#ifdef CONFIG_ARM_LPAE
> > > +     ldmia   r0, {r2 - r11}
> > > +#else
> > >       ldmia   r0, {r4 - r11}
> > > +#endif
> > >       mcr     p15, 0, r4, c13, c0, 0  @ FCSE/PID
> > >       mcr     p15, 0, r5, c13, c0, 1  @ Context ID
> > >       mcr     p15, 0, r6, c3, c0, 0   @ Domain ID
> > > +#ifdef CONFIG_ARM_LPAE
> > > +     mcrr    p15, 0, r7, r8, c2      @ TTB 0
> > > +     mcrr    p15, 1, r2, r3, c2      @ TTB 1
> > > +#else
> > >       mcr     p15, 0, r7, c2, c0, 0   @ TTB 0
> > >       mcr     p15, 0, r8, c2, c0, 1   @ TTB 1
> > > +#endif
> > >       mcr     p15, 0, ip, c2, c0, 2   @ TTB control register
> > >       mcr     p15, 0, r10, c1, c0, 1  @ Auxiliary control register
> > >       mcr     p15, 0, r11, c1, c0, 2  @ Co-processor access control
> > 
> > Do we really need all this ifdef else throughout this series?
> > 
> > I think we already have things in place to do this dynamically
> > like we already do for thumb, smp_on_up, v6 vs v7 and so on.
> 
> By dynamically, do you mean at run-time? We won't be able to compile
> both classic and LPAE in the same kernel, there is just too much
> difference between them (2 vs 3 levels of page tables - LPAE is an
> entirely new format).
> 
> If you mean some simpler macros like what we have for ARM/THUMB to
> reduce the number of lines, I'm fine with it though we don't always have
> a 1:1 mapping between LPAE and non-LPAE instructions.
create the same macro as done do arm/thumb is good will make the code more
readable
> 
> Alternatively, I'm happy to create a separate proc-v7lpae.S file.
maybe a good idea

Best Regards,
J.
