Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab1A3Q2I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 11:28:08 -0500
Received: from service87.mimecast.com ([94.185.240.25]:51240 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750807Ab1A3Q2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 11:28:06 -0500
Subject: Re: [PATCH] ARM: Fix SMP_ON_UP for non ARM ltd. implementations
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20110130122027.GA22677@n2100.arm.linux.org.uk>
References: <1296083052-20034-1-git-send-email-sboyd@codeaurora.org>
	 <20110130122027.GA22677@n2100.arm.linux.org.uk>
Date: Sun, 30 Jan 2011 16:27:55 +0000
Message-ID: <1296404875.6192.10.camel@jazzbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2
X-OriginalArrivalTime: 30 Jan 2011 16:27:58.0745 (UTC) FILETIME=[A8122890:01CBC09A]
X-MC-Unique: 111013016280200901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Sun, 2011-01-30 at 12:20 +0000, Russell King - ARM Linux wrote:
> On Wed, Jan 26, 2011 at 03:04:12PM -0800, Stephen Boyd wrote:
> > @@ -393,20 +393,25 @@ ENDPROC(__turn_mmu_on)
> >  #ifdef CONFIG_SMP_ON_UP
> >  __fixup_smp:
> >       mov     r4, #0x00070000
> > -     orr     r3, r4, #0xff000000     @ mask 0xff070000
> > -     orr     r4, r4, #0x41000000     @ val 0x41070000
> > -     and     r0, r9, r3
> > -     teq     r0, r4                  @ ARM CPU and ARMv6/v7?
> > +     and     r0, r9, r4
> > +     teq     r0, r4                  @ ARMv6/v7?
> >       bne     __fixup_smp_on_up       @ no, assume UP
> > 
> > +     orr     r3, r4, #0xff000000     @ mask 0xff070000
> >       orr     r3, r3, #0x0000ff00
> >       orr     r3, r3, #0x000000f0     @ mask 0xff07fff0
> > +     orr     r4, r4, #0x41000000     @ val 0x41070000
> >       orr     r4, r4, #0x0000b000
> >       orr     r4, r4, #0x00000020     @ val 0x4107b020
> >       and     r0, r9, r3
> >       teq     r0, r4                  @ ARM 11MPCore?
> >       moveq   pc, lr                  @ yes, assume SMP
> > 
> > +     mov     r4, #0x00070000
> > +     and     r0, r9, #0x000f0000
> > +     teq     r0, r4                  @ ARMv6?
> > +     beq     __fixup_smp_on_up       @ yes, assume UP
> > +
> 
> Wouldn't it be better to check for CPUID presence first, then ARM11MPcore,
> and lastly preserve of MPIDR-flagged extensions?
> 

Yes, the v6 catch-all at the end is pretty horrible.


> Will - can you check whether the below is correct?
> 
>  arch/arm/kernel/head.S |   17 +++++++----------
>  1 files changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index 17a97b5..f6b31c4 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -390,19 +390,16 @@ ENDPROC(__turn_mmu_on)
> 
>  #ifdef CONFIG_SMP_ON_UP
>  __fixup_smp:
> -       mov     r4, #0x00070000
> -       orr     r3, r4, #0xff000000     @ mask 0xff070000
> -       orr     r4, r4, #0x41000000     @ val 0x41070000
> -       and     r0, r9, r3
> -       teq     r0, r4                  @ ARM CPU and ARMv6/v7?
> +       and     r3, r9, #0x000f0000     @ architecture version
> +       teq     r3, #0x000f00000        @ CPU ID supported?


You've got an extra 0x0 on the end of that constant.


>         bne     __fixup_smp_on_up       @ no, assume UP
> 
> -       orr     r3, r3, #0x0000ff00
> -       orr     r3, r3, #0x000000f0     @ mask 0xff07fff0
> +       bic     r3, r9, #0x00ff0000
> +       bic     r3, r3, #0x0000000f     @ mask 0xff00fff0
> +       mov     r4, #0x41000000
>         orr     r4, r4, #0x0000b000
> -       orr     r4, r4, #0x00000020     @ val 0x4107b020
> -       and     r0, r9, r3
> -       teq     r0, r4                  @ ARM 11MPCore?
> +       orr     r4, r4, #0x00000020     @ val 0x4100b020
> +       teq     r3, r4                  @ ARM 11MPCore?
>         moveq   pc, lr                  @ yes, assume SMP
> 

Yup, that looks correct to me. 11MPCore has 0xf for the architecture
field so we'll end up identifying it correctly here.


>         mrc     p15, 0, r0, c0, c0, 5   @ read MPIDR


The code following this does:

tst     r0, #1 << 31
movne   pc, lr                  @ bit 31 => SMP

As an optimisation, we could also check that bit 30 is zero so that
we patch out the SMP stuff for single-core A5/A9/A15. Up to you.

With the typo fixed:

Acked-by: Will Deacon <will.deacon@arm.com>

Will


