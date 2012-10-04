Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab2JDLOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 07:14:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36001 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754841Ab2JDLOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 07:14:15 -0400
Date: Thu, 4 Oct 2012 12:14:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Fabio Estevam <festevam@gmail.com>, sameo@linux.intel.com,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 2/6] mfd: da9052: Introduce da9052-irq.c
Message-ID: <20121004111412.GJ4360@opensource.wolfsonmicro.com>
References: <1349320509-26930-1-git-send-email-festevam@gmail.com>
 <1349320509-26930-2-git-send-email-festevam@gmail.com>
 <201210040712.48516.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210040712.48516.arnd@arndb.de>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 07:12:48AM +0000, Arnd Bergmann wrote:
> On Thursday 04 October 2012, Fabio Estevam wrote:

> > +int da9052_enable_irq(struct da9052 *da9052, int irq)
> > +{
> > +       irq = da9052_map_irq(da9052, irq);
> > +       if (irq < 0)
> > +               return irq;
> > +
> > +       enable_irq(irq);
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(da9052_enable_irq);

> This looks correct, but I'm not sure it's actually simpler
> than letting the sub-drivers deal with calling regmap_irq_get_virq().

> Can't each driver just call regmap_irq_get_virq once at init time and
> then call the regular irq management functions?

> Maybe I just don't see the real purpose of these functions. If I'm
> contradicting what Mark said, listen to him instead.

Aside from hiding the lookup of the irqdomian a bit there's a couple of
reasons for existing devices having them:

 - With some devices like WM8994 the interrupts are optional so it's
   useful to eat errors due to the interrupts not existing.  With the
   ability to use linear domains this doesn't matter terribly much as we
   can just allocate the interrupts even if there's no way they can
   fire, it was more of an issue when irqdomain wasn't available.

 - With Arizona we've actually got a bunch of interrupt controllers the
   interrupts might be allocated to and these functions allow us to hide
   this mapping from the subdrivers.  This is pretty specialist though.

but if the interrupts are always requestable it really makes little
odds, just a matter of taste.
