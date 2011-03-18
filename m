Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1CRFGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 01:06:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53897 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab1CRFGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 01:06:38 -0400
Date: Thu, 17 Mar 2011 23:06:35 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: "Du, Alek" <alek.du@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        "Tang, Feng" <feng.tang@intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 5/5] [RFC] gpio: langwell: Clear edge bit before handling
Message-ID: <20110318050635.GD18545@angua.secretlab.ca>
References: <20110317192247.722047296@linutronix.de>
 <20110317192449.845775901@linutronix.de>
 <1865303E0DED764181A9D882DEF65FB688211171FD@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1865303E0DED764181A9D882DEF65FB688211171FD@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 10:33:56AM +0800, Du, Alek wrote:
> On Fri, 18 Mar 2011 03:32:58 +0800
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > I don't have the specs for this beast, but it looks a lot like the PXA
> > GPIO block. Though I bet it's the same IP and the driver should have
> > reused the PXA code.
> > 
> 
> I think so.
> 
> > Acknowleding the edge detect status after handling one or more gpio
> > interrupts looks wrong. We might lose an edge which came in while we
> > handled the previous one.
> > 
> 
> Thanks for it. Although losing interrupt can always happen if the pending
> IRQs are more than 1, but your patch will reduce the possibility.

I'll take that as an ack.  Unless you tell me otherwise, I'll pick it
up and ask Linus to pull it shortly.

g.

> 
> Thanks,
> Alek
> 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Feng Tang <feng.tang@intel.com>
> > Cc: Alek Du <alek.du@intel.com>
> > Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > 
> > ---
> >  drivers/gpio/langwell_gpio.c |   13 ++++++-------
> >  1 file changed, 6 insertions(+), 7 deletions(-)
> > 
> > Index: linux-2.6-tip/drivers/gpio/langwell_gpio.c
> > ===================================================================
> > --- linux-2.6-tip.orig/drivers/gpio/langwell_gpio.c
> > +++ linux-2.6-tip/drivers/gpio/langwell_gpio.c
> > @@ -190,23 +190,22 @@ static void lnw_irq_handler(unsigned irq
> >  	struct irq_data *data = irq_desc_get_irq_data(desc);
> >  	struct lnw_gpio *lnw = irq_data_get_irq_handler_data(data);
> >  	struct irq_chip *chip = irq_data_get_irq_chip(data);
> > -	u32 base, gpio, gedr_v;
> > +	u32 base, gpio, mask;
> >  	unsigned long pending;
> >  	void __iomem *gedr;
> >  
> >  	/* check GPIO controller to check which pin triggered the interrupt */
> >  	for (base = 0; base < lnw->chip.ngpio; base += 32) {
> >  		gedr = gpio_reg(&lnw->chip, base, GEDR);
> > -		gedr_v = pending = readl(gedr);
> > -		if (!gedr_v)
> > -			continue;
> > +		pending = readl(gedr);
> >  		while (pending) {
> >  			gpio = __ffs(pending) - 1;
> > -			pending &= ~BIT(gpio);
> > +			mask = BIT(gpio);
> > +			pending &= ~mask;
> > +			/* Clear before handling so we can't lose an edge */
> > +			writel(mask, gedr);
> >  			generic_handle_irq(lnw->irq_base + base + gpio);
> >  		}
> > -		/* clear the edge detect status bit */
> > -		writel(gedr_v, gedr);
> >  	}
> >  
> >  	chip->irq_eoi(data);
> > 
> > 
> 
