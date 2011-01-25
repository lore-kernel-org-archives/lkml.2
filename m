Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab1AYPmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 10:42:12 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35168 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab1AYPmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 10:42:11 -0500
Date: Tue, 25 Jan 2011 15:41:33 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Colin Cross <ccross@android.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, olof@lixom.net,
        konkers@android.com, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/28] ARM: mm: cache-l2x0: Add support for
	re-enabling l2x0
Message-ID: <20110125154133.GB17280@n2100.arm.linux.org.uk>
References: <1295834493-5019-1-git-send-email-ccross@android.com> <1295834493-5019-5-git-send-email-ccross@android.com> <1295968464.10109.264.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295968464.10109.264.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 03:14:24PM +0000, Catalin Marinas wrote:
> On Mon, 2011-01-24 at 02:01 +0000, Colin Cross wrote:
> > --- a/arch/arm/mm/cache-l2x0.c
> > +++ b/arch/arm/mm/cache-l2x0.c
> > @@ -252,16 +252,26 @@ static void l2x0_flush_range(unsigned long start, unsigned long end)
> >         spin_unlock_irqrestore(&l2x0_lock, flags);
> >  }
> > 
> > +/* enables l2x0 after l2x0_disable, does not invalidate */
> > +void l2x0_enable(void)
> > +{
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&l2x0_lock, flags);
> > +       writel_relaxed(1, l2x0_base + L2X0_CTRL);
> > +       spin_unlock_irqrestore(&l2x0_lock, flags);
> > +}
> > +
> >  static void l2x0_disable(void)
> >  {
> >         unsigned long flags;
> > 
> >         spin_lock_irqsave(&l2x0_lock, flags);
> > -       writel(0, l2x0_base + L2X0_CTRL);
> > +       writel_relaxed(0, l2x0_base + L2X0_CTRL);
> >         spin_unlock_irqrestore(&l2x0_lock, flags);
> >  }
> > 
> > -void __init l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask)
> > +void l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask)
> >  {
> >         __u32 aux;
> >         __u32 cache_id;
> 
> So this assumes that the L2 registers are accessible. I suspect the
> platform code calling it should know this.
> 
> The patch looks fine.
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

I think we need to come up with some proper way to deal with cpuidle
which doesn't involve adding lots of globally visible functions to all
sorts of bits of code and having platforms call them individually,
otherwise this is going to get _really_ messy in the future.

Maybe we need a notifier list which can be told when cpuidle events
happen, so that parts of the system such as VFP and L2 cache support
can do the right thing without having platforms add lots of stuff like

	gic_secondary_init();
	gic_restore_interrupt_types();
	vfp_enable();
	l2x0_enable();
	twd_enable();
	... etc ...

in their SoC specific code.
