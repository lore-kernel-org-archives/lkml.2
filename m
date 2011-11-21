Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab1KUMpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 07:45:20 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15336 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab1KUMpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 07:45:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 21 Nov 2011 04:44:55 -0800
Date: Mon, 21 Nov 2011 14:44:52 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Olof Johansson <olof@lixom.net>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 03/10] arm/tegra: prepare clock code for multiple tegra
 variants
Message-ID: <20111121124452.GM19069@tbergstrom-lnx.Nvidia.com>
References: <1321546766-26770-1-git-send-email-pdeschrijver@nvidia.com>
 <1321546766-26770-4-git-send-email-pdeschrijver@nvidia.com>
 <20111118190649.GB31678@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111118190649.GB31678@quad.lixom.net>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 08:06:49PM +0100, Olof Johansson wrote:
> Hi,
> 
> A nit and two comments below.
> 
> On Thu, Nov 17, 2011 at 06:19:17PM +0200, Peter De Schrijver wrote:
> > Rework the tegra20 clock code to support multiple tegra variants :
> > 
> >  * remove tegra2_periph_reset_assert/tegra2_periph_reset_deassert. This
> >    functionality should be in clock.c.
> >  * compile tegra_sdmmc_tap_delay only on tegra20 as this feature will not
> >    be available in future variants.
> >  * don't export clk_measure_input_freq as its functionality is also available
> >    using clk_get_rate().
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > ---
> >  arch/arm/mach-tegra/clock.c         |   14 +++++++++-----
> >  arch/arm/mach-tegra/clock.h         |    3 ---
> >  arch/arm/mach-tegra/tegra2_clocks.c |   14 +-------------
> >  arch/arm/mach-tegra/timer.c         |   12 ++++++++----
> >  4 files changed, 18 insertions(+), 25 deletions(-)
> > 
> > diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
> > index f8d41ff..47f6366 100644
> > --- a/arch/arm/mach-tegra/clock.c
> > +++ b/arch/arm/mach-tegra/clock.c
> > @@ -387,13 +387,15 @@ EXPORT_SYMBOL(tegra_clk_init_from_table);
> >  
> >  void tegra_periph_reset_deassert(struct clk *c)
> >  {
> > -	tegra2_periph_reset_deassert(c);
> > +	BUG_ON(!c->ops->reset);
> > +	c->ops->reset(c, false);
> >  }
> >  EXPORT_SYMBOL(tegra_periph_reset_deassert);
> >  
> >  void tegra_periph_reset_assert(struct clk *c)
> >  {
> > -	tegra2_periph_reset_assert(c);
> > +	BUG_ON(!c->ops->reset);
> > +	c->ops->reset(c, true);
> >  }
> >  EXPORT_SYMBOL(tegra_periph_reset_assert);
> >  
> > @@ -403,10 +405,11 @@ void __init tegra_init_clock(void)
> >  }
> >  
> >  /*
> > - * The SDMMC controllers have extra bits in the clock source register that
> > - * adjust the delay between the clock and data to compenstate for delays
> > - * on the PCB.
> > + * The SDMMC controllers on tegra20 have extra bits in the clock source
> > + * register that adjust the delay between the clock and data to compenstate
> > + * for delays on the PCB.
> >   */
> > +#ifdef CONFIG_ARCH_TEGRA_2x_SOC
> >  void tegra_sdmmc_tap_delay(struct clk *c, int delay)
> >  {
> >  	unsigned long flags;
> > @@ -415,6 +418,7 @@ void tegra_sdmmc_tap_delay(struct clk *c, int delay)
> >  	tegra2_sdmmc_tap_delay(c, delay);
> >  	spin_unlock_irqrestore(&c->spinlock, flags);
> >  }
> > +#endif
> 
> Ifdeffing this out doesn't quite make sense. Better to do a #ifdef in the
> include file with an #else case that fills in an empty function. This
> needs to be abstracted differently for the two platforms anyway but
> that can be done separately from this. Does tegra3 have tap delay setup
> as well? (I don't have the TRM handy right now).
> 

I couldn't find it in the tegra30 TRM.

Cheers,

Peter.
