Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab1CRCeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 22:34:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:17283 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab1CRCeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 22:34:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,203,1299484800"; 
   d="scan'208";a="721440151"
From: "Du, Alek" <alek.du@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "Tang, Feng" <feng.tang@intel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 18 Mar 2011 10:33:56 +0800
Subject: RE: [patch 5/5] [RFC] gpio: langwell: Clear edge bit before handling
Thread-Topic: [patch 5/5] [RFC] gpio: langwell: Clear edge bit before
 handling
Thread-Index: Acvk2iNaVi/AIImXQoWisR6UKlfRbgAOqXRA
Message-ID: <1865303E0DED764181A9D882DEF65FB688211171FD@shsmsx502.ccr.corp.intel.com>
References: <20110317192247.722047296@linutronix.de>
 <20110317192449.845775901@linutronix.de>
In-Reply-To: <20110317192449.845775901@linutronix.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011 03:32:58 +0800
Thomas Gleixner <tglx@linutronix.de> wrote:

> I don't have the specs for this beast, but it looks a lot like the PXA
> GPIO block. Though I bet it's the same IP and the driver should have
> reused the PXA code.
> 

I think so.

> Acknowleding the edge detect status after handling one or more gpio
> interrupts looks wrong. We might lose an edge which came in while we
> handled the previous one.
> 

Thanks for it. Although losing interrupt can always happen if the pending
IRQs are more than 1, but your patch will reduce the possibility.

Thanks,
Alek

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Feng Tang <feng.tang@intel.com>
> Cc: Alek Du <alek.du@intel.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
> ---
>  drivers/gpio/langwell_gpio.c |   13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6-tip/drivers/gpio/langwell_gpio.c
> ===================================================================
> --- linux-2.6-tip.orig/drivers/gpio/langwell_gpio.c
> +++ linux-2.6-tip/drivers/gpio/langwell_gpio.c
> @@ -190,23 +190,22 @@ static void lnw_irq_handler(unsigned irq
>  	struct irq_data *data = irq_desc_get_irq_data(desc);
>  	struct lnw_gpio *lnw = irq_data_get_irq_handler_data(data);
>  	struct irq_chip *chip = irq_data_get_irq_chip(data);
> -	u32 base, gpio, gedr_v;
> +	u32 base, gpio, mask;
>  	unsigned long pending;
>  	void __iomem *gedr;
>  
>  	/* check GPIO controller to check which pin triggered the interrupt */
>  	for (base = 0; base < lnw->chip.ngpio; base += 32) {
>  		gedr = gpio_reg(&lnw->chip, base, GEDR);
> -		gedr_v = pending = readl(gedr);
> -		if (!gedr_v)
> -			continue;
> +		pending = readl(gedr);
>  		while (pending) {
>  			gpio = __ffs(pending) - 1;
> -			pending &= ~BIT(gpio);
> +			mask = BIT(gpio);
> +			pending &= ~mask;
> +			/* Clear before handling so we can't lose an edge */
> +			writel(mask, gedr);
>  			generic_handle_irq(lnw->irq_base + base + gpio);
>  		}
> -		/* clear the edge detect status bit */
> -		writel(gedr_v, gedr);
>  	}
>  
>  	chip->irq_eoi(data);
> 
> 

