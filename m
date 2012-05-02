Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab2EBINf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 04:13:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:53101 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab2EBINc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 04:13:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="137831604"
Date: Wed, 2 May 2012 11:14:47 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linus.walleij@stericsson.com
Subject: Re: [PATCH v2] gpio: langwell: convert to use irq_domain
Message-ID: <20120502081447.GR16266@intel.com>
References: <1335509632-5118-1-git-send-email-mika.westerberg@linux.intel.com>
 <20120427162251.360723E0B4D@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427162251.360723E0B4D@localhost>
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 10:22:51AM -0600, Grant Likely wrote:
> On Fri, 27 Apr 2012 09:53:52 +0300, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> > irq_domain already provides a facility to translate from hardware IRQ
> > numbers to Linux IRQ numbers so use that instead of open-coding the logic
> > in the driver.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Hi Mika,
> 
> Comments below...
> 
> > ---
> > Changes to previous version:
> > 	- use linear mapping instead of legacy as suggested by Grant.
> > 
> >  drivers/gpio/Kconfig         |    1 +
> >  drivers/gpio/gpio-langwell.c |   45 +++++++++++++++++++++++++----------------
> >  2 files changed, 28 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> > index e03653d..0a85d95 100644
> > --- a/drivers/gpio/Kconfig
> > +++ b/drivers/gpio/Kconfig
> > @@ -399,6 +399,7 @@ config GPIO_BT8XX
> >  config GPIO_LANGWELL
> >  	bool "Intel Langwell/Penwell GPIO support"
> >  	depends on PCI && X86
> > +	select IRQ_DOMAIN
> >  	help
> >  	  Say Y here to support Intel Langwell/Penwell GPIO.
> >  
> > diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
> > index 52f00d3..4b3da8c 100644
> > --- a/drivers/gpio/gpio-langwell.c
> > +++ b/drivers/gpio/gpio-langwell.c
> > @@ -36,6 +36,7 @@
> >  #include <linux/gpio.h>
> >  #include <linux/slab.h>
> >  #include <linux/pm_runtime.h>
> > +#include <linux/irqdomain.h>
> >  
> >  /*
> >   * Langwell chip has 64 pins and thus there are 2 32bit registers to control
> > @@ -66,8 +67,8 @@ struct lnw_gpio {
> >  	struct gpio_chip		chip;
> >  	void				*reg_base;
> >  	spinlock_t			lock;
> > -	unsigned			irq_base;
> >  	struct pci_dev			*pdev;
> > +	struct irq_domain		*domain;
> >  };
> >  
> >  static void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
> > @@ -176,13 +177,13 @@ static int lnw_gpio_direction_output(struct gpio_chip *chip,
> >  static int lnw_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> >  {
> >  	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
> > -	return lnw->irq_base + offset;
> > +	return irq_create_mapping(lnw->domain, offset);
> >  }
> >  
> >  static int lnw_irq_type(struct irq_data *d, unsigned type)
> >  {
> >  	struct lnw_gpio *lnw = irq_data_get_irq_chip_data(d);
> > -	u32 gpio = d->irq - lnw->irq_base;
> > +	u32 gpio = irqd_to_hwirq(d);
> >  	unsigned long flags;
> >  	u32 value;
> >  	void __iomem *grer = gpio_reg(&lnw->chip, gpio, GRER);
> > @@ -256,7 +257,7 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
> >  			pending &= ~mask;
> >  			/* Clear before handling so we can't lose an edge */
> >  			writel(mask, gedr);
> > -			generic_handle_irq(lnw->irq_base + base + gpio);
> > +			generic_handle_irq(gpio_to_irq(base + gpio));
> 
> Don't use gpio_to_irq() here. irq_find_mapping() is intended for this
> purpose.

Ok.

> 
> >  		}
> >  	}
> >  
> > @@ -281,6 +282,24 @@ static void lnw_irq_init_hw(struct lnw_gpio *lnw)
> >  	}
> >  }
> >  
> > +static int lnw_gpio_irq_map(struct irq_domain *d, unsigned int virq,
> > +			    irq_hw_number_t hw)
> > +{
> > +	struct lnw_gpio *lnw = d->host_data;
> > +
> > +	irq_set_chip_and_handler_name(virq, &lnw_irqchip, handle_simple_irq,
> > +				      "demux");
> > +	irq_set_chip_data(virq, lnw);
> > +	irq_set_irq_type(virq, IRQ_TYPE_NONE);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct irq_domain_ops lnw_gpio_irq_ops = {
> > +	.map = lnw_gpio_irq_map,
> > +	.xlate = irq_domain_xlate_twocell,
> > +};
> > +
> >  #ifdef CONFIG_PM
> >  static int lnw_gpio_runtime_resume(struct device *dev)
> >  {
> > @@ -318,7 +337,6 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
> >  			const struct pci_device_id *id)
> >  {
> >  	void *base;
> > -	int i;
> >  	resource_size_t start, len;
> >  	struct lnw_gpio *lnw;
> >  	u32 irq_base;
> 
> There are stale references to irq_base in this file after applying
> this patch.

Right. I'll remove the irq_base as it is not used at all.

> I also wonder if gpio_base can also be removed and use dynamic
> allocation of the gpio number too.

I'm not sure how that is going to work. Drivers get the GPIO numbers from
the platform code and they are pretty much hard-coded (either they are
taken from the SFI table which is static table composed by BIOS, or they
are specified in arch/x86/platform/mrst/mrst.c).

> Otherwise the patch looks pretty good.

Thanks. I'll send a new version in a moment.
