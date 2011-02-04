Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab1BDXoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 18:44:13 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59103 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1BDXoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 18:44:12 -0500
Date: Fri, 4 Feb 2011 23:43:31 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Colin Cross <ccross@android.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Linus Walleij <linus.walleij@stericsson.com>, konkers@android.com,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 04/28] ARM: mm: cache-l2x0: Add support for
	re-enabling l2x0
Message-ID: <20110204234331.GF8732@n2100.arm.linux.org.uk>
References: <1295834493-5019-1-git-send-email-ccross@android.com> <1295834493-5019-5-git-send-email-ccross@android.com> <1295968464.10109.264.camel@e102109-lin.cambridge.arm.com> <20110125154133.GB17280@n2100.arm.linux.org.uk> <1295979242.10109.308.camel@e102109-lin.cambridge.arm.com> <2f97ec8a084e590220e1548fc927b60e@mail.gmail.com> <-8932138696981683633@unknownmsgid> <AANLkTi=cTXmQFm_s5OL2pGyyaFv5UR_f9MV=S5Ajx0tu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=cTXmQFm_s5OL2pGyyaFv5UR_f9MV=S5Ajx0tu@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 05:32:26PM -0600, Colin Cross wrote:
> On Tue, Jan 25, 2011 at 12:39 PM, Will Deacon <will.deacon@arm.com> wrote:
> > Well if you set the priority fields in the notifier blocks correctly
> > then you can just return NOTIFY_STOP when you've saved/restored as much
> > as you want. This assumes of course that you can identify which power
> > mode you're entering/leaving and that each one is `deeper' than the previous.
> 
> I doubt its possible to create an order that will work for all
> architectures, and returning NOTIFY_STOP would require the decision on
> when to finish to be made by the notifier block instead of the
> platform code.
> 
> Tegra has three possible idle modes:
> 
> 1.  WFI - nothing reset
> 2.  CPU, TWD, L1, GIC lost, L2 needs to be disabled but not reset
> 3.  CPU, TWD, L1, GIC, and L2 lost

(2) and (3) don't sound like per-cpu modes but system modes.  If you're
having to disable L2, then your other CPU can't be active.

> CPU and L1 are already handled by the platform-specific suspend code.
> TWD is handled by the clockevents broadcast notifiers.  That leaves L2
> and GIC.

GIC can be handled in just the same way - upon a CPU idling and it
being decided that the CPU should enter low power mode, the idle states
are entered which does what's required with TWD, L1, VFP, Neon, etc.
We just need the GIC CPU interface included in there.

When both CPUs are idled, then the L2 comes into play, and then modes
(2) and (3) become possible and this is where you start doing the extra
stuff.

Note that you have to do it that way anyway, because you can't save
the state of the other CPU's GIC without doing an IPI call, which
could kick it out of its idle mode.
