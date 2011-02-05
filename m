Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab1BEHv2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 02:51:28 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:56724 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914Ab1BEHv1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 02:51:27 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com><1295834493-5019-5-git-send-email-ccross@android.com><1295968464.10109.264.camel@e102109-lin.cambridge.arm.com><20110125154133.GB17280@n2100.arm.linux.org.uk><1295979242.10109.308.camel@e102109-lin.cambridge.arm.com><2f97ec8a084e590220e1548fc927b60e@mail.gmail.com><-8932138696981683633@unknownmsgid><AANLkTi=cTXmQFm_s5OL2pGyyaFv5UR_f9MV=S5Ajx0tu@mail.gmail.com><20110204234331.GF8732@n2100.arm.linux.org.uk>
 <AANLkTi=fHnivHXHnYrQvdP6JWbEA3t1X3DuBxj5gN3H0@mail.gmail.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcvE1kdkGgdILBQYTtKi9oOpw3zaCgAMhJ4g
In-Reply-To: <AANLkTi=fHnivHXHnYrQvdP6JWbEA3t1X3DuBxj5gN3H0@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Date: Sat, 5 Feb 2011 13:21:24 +0530
Message-ID: <1bebe4b5c8590059b70a146d5486fa6a@mail.gmail.com>
Subject: RE: [PATCH v2 04/28] ARM: mm: cache-l2x0: Add support for re-enabling l2x0
To: Colin Cross <ccross@android.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Linus Walleij <linus.walleij@stericsson.com>, konkers@android.com,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: ccross@google.com [mailto:ccross@google.com] On Behalf Of
> Colin Cross
> Sent: Saturday, February 05, 2011 7:15 AM
> To: Russell King - ARM Linux
> Cc: Will Deacon; Santosh Shilimkar; Catalin Marinas; Linus Walleij;
> konkers@android.com; Tony Lindgren; linux-kernel@vger.kernel.org;
> linux-tegra@vger.kernel.org; olof@lixom.net; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH v2 04/28] ARM: mm: cache-l2x0: Add support for
> re-enabling l2x0
>
> On Fri, Feb 4, 2011 at 5:43 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Fri, Feb 04, 2011 at 05:32:26PM -0600, Colin Cross wrote:
> >> On Tue, Jan 25, 2011 at 12:39 PM, Will Deacon
> <will.deacon@arm.com> wrote:
> >> > Well if you set the priority fields in the notifier blocks
> correctly
> >> > then you can just return NOTIFY_STOP when you've saved/restored
> as much
> >> > as you want. This assumes of course that you can identify which
> power
> >> > mode you're entering/leaving and that each one is `deeper' than
> the previous.
> >>
> >> I doubt its possible to create an order that will work for all
> >> architectures, and returning NOTIFY_STOP would require the
> decision on
> >> when to finish to be made by the notifier block instead of the
> >> platform code.
> >>
> >> Tegra has three possible idle modes:
> >>
> >> 1.  WFI - nothing reset
> >> 2.  CPU, TWD, L1, GIC lost, L2 needs to be disabled but not reset
> >> 3.  CPU, TWD, L1, GIC, and L2 lost
> >
> > (2) and (3) don't sound like per-cpu modes but system modes.  If
> you're
> > having to disable L2, then your other CPU can't be active.
>
> Yes, 2 and 3 require both CPUs to be idle.  Unfortunately, on Tegra,
> it is important to use at least 2 as much as possible, because the
> two
> CPUs are not individually power gated.
>
> >> CPU and L1 are already handled by the platform-specific suspend
> code.
> >> TWD is handled by the clockevents broadcast notifiers.  That
> leaves L2
> >> and GIC.
> >
> > GIC can be handled in just the same way - upon a CPU idling and it
> > being decided that the CPU should enter low power mode, the idle
> states
> > are entered which does what's required with TWD, L1, VFP, Neon,
> etc.
> > We just need the GIC CPU interface included in there.
> >
> > When both CPUs are idled, then the L2 comes into play, and then
> modes
> > (2) and (3) become possible and this is where you start doing the
> extra
> > stuff.
>
> Are you suggesting that the idle notifiers only handle TWD, L1, VFP,
> Neon, and GIC?  That would simplify things, as there are probably no
> ordering requirements, and they should be the same for any platform
> that uses them.
>
> > Note that you have to do it that way anyway, because you can't
> save
> > the state of the other CPU's GIC without doing an IPI call, which
> > could kick it out of its idle mode.
>
> There is currently no state that needs to be saved in the GIC CPU
> registers, they can all be reinitialized.
GIC save/restore on OMAP follows different strategy. There is a
Predefined layout to save content and restore is done atomically
by boot ROM code.
L2 cache also same case. Only AUXCTRL needs to be programmed on
wakeup from low power mode and that too with secure call. Rest
of the registers are managed by boot ROM code.

TWD is already managed through framework. Othe CPU low power
sequence is very small and OMAP has restrictions on the last
core to go down and first to wakeup.

So at least I don't see any use of common notifiers for GIC
and L2 will help OMAP lower power code.

Regards,
Santosh
