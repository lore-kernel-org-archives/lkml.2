Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759155Ab2EIJzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:55:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:53028 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759065Ab2EIJzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:55:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163869714"
Date: Wed, 9 May 2012 12:56:24 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linus.walleij@stericsson.com
Subject: Re: [PATCH v3] gpio: langwell: convert to use irq_domain
Message-ID: <20120509095624.GK31494@intel.com>
References: <1335946550-3092-1-git-send-email-mika.westerberg@linux.intel.com>
 <20120508174434.80D773E05D0@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120508174434.80D773E05D0@localhost>
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 11:44:34AM -0600, Grant Likely wrote:
> On Wed,  2 May 2012 11:15:50 +0300, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> > irq_domain already provides a facility to translate from hardware IRQ
> > numbers to Linux IRQ numbers so use that instead of open-coding the logic
> > in the driver.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Applied, thanks.

Thanks.

> BTW, I noticed a bug below (unrelated to this patch)...
> 
> > ---
> >  static int lnw_irq_type(struct irq_data *d, unsigned type)
> >  {
> >  	struct lnw_gpio *lnw = irq_data_get_irq_chip_data(d);
> > -	u32 gpio = d->irq - lnw->irq_base;
> > +	u32 gpio = irqd_to_hwirq(d);
> >  	unsigned long flags;
> >  	u32 value;
> >  	void __iomem *grer = gpio_reg(&lnw->chip, gpio, GRER);
> > @@ -256,7 +257,8 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
> >  			pending &= ~mask;
> >  			/* Clear before handling so we can't lose an edge */
> >  			writel(mask, gedr);
> > -			generic_handle_irq(lnw->irq_base + base + gpio);
> > +			generic_handle_irq(irq_find_mapping(lnw->domain,
> > +							    base + gpio));
> >  		}
> >  	}
> 
> This while loop is actually buggy.  After handling each pending irq
> bit the status register should be re-read.  Otherwise if the same irq
> gets raised again after it is handled, then this loop will ignore it.
> 
> It's not a major issue, but it would mean unnecessary exiting and
> reentering the handler function.

Indeed. I'll take a look.
