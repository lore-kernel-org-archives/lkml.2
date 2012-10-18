Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab2JRGVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 02:21:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab2JRGVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 02:21:49 -0400
Date: Thu, 18 Oct 2012 14:22:11 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 4/7] gpio/mxs: convert to use linear irqdomain
Message-ID: <20121018062208.GB4513@S2101-09.ap.freescale.net>
References: <1350415376-3217-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350415376-3217-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 09:22:56PM +0200, Linus Walleij wrote:
> The MXS driver tries to do the work of irq_domain_add_linear()
> by reserving a bunch of descriptors somewhere and keeping track
> of the base offset, then calling irq_domain_add_legacy(). Let's
> stop doing that and simply use the linear IRQ domain.
> 
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/gpio/gpio-mxs.c | 19 ++++++-------------
>  1 file changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
> index 796fb13..71fd5b1 100644
> --- a/drivers/gpio/gpio-mxs.c
> +++ b/drivers/gpio/gpio-mxs.c
> @@ -223,7 +223,6 @@ static int __devinit mxs_gpio_probe(struct platform_device *pdev)
>  	static void __iomem *base;
>  	struct mxs_gpio_port *port;
>  	struct resource *iores = NULL;
> -	int irq_base;

...

>  	int err;
>  
>  	port = devm_kzalloc(&pdev->dev, sizeof(*port), GFP_KERNEL);
> @@ -272,16 +271,10 @@ static int __devinit mxs_gpio_probe(struct platform_device *pdev)
>  	/* clear address has to be used to clear IRQSTAT bits */
>  	writel(~0U, port->base + PINCTRL_IRQSTAT(port) + MXS_CLR);
>  
> -	irq_base = irq_alloc_descs(-1, 0, 32, numa_node_id());
> -	if (irq_base < 0)
> -		return irq_base;
> -
> -	port->domain = irq_domain_add_legacy(np, 32, irq_base, 0,
> +	port->domain = irq_domain_add_linear(np, 32,
>  					     &irq_domain_simple_ops, NULL);
> -	if (!port->domain) {
> -		err = -ENODEV;
> -		goto out_irqdesc_free;
> -	}
> +	if (!port->domain)
> +		return -ENODEV;
>  
>  	/* gpio-mxs can be a generic irq chip */
>  	mxs_gpio_init_gc(port, irq_base);
                               ^^^^^^^^

So I know this one is not compile-tested.

This is exactly the reason why I have to use irq_domain_add_legacy
other than irq_domain_add_linear when I add irqdomain support for the
driver.  The driver uses generic-irq infrastructural which needs
irq_base for setup.  So sadly, before generic-irq gets improved, any
irq chip that uses generic-irq will have to use irq_domain_add_legacy.

Shawn

> @@ -295,7 +288,7 @@ static int __devinit mxs_gpio_probe(struct platform_device *pdev)
>  			 port->base + PINCTRL_DOUT(port), NULL,
>  			 port->base + PINCTRL_DOE(port), NULL, 0);
>  	if (err)
> -		goto out_irqdesc_free;
> +		goto out_irqdomain_remove;
>  
>  	port->bgc.gc.to_irq = mxs_gpio_to_irq;
>  	port->bgc.gc.base = port->id * 32;
> @@ -308,8 +301,8 @@ static int __devinit mxs_gpio_probe(struct platform_device *pdev)
>  
>  out_bgpio_remove:
>  	bgpio_remove(&port->bgc);
> -out_irqdesc_free:
> -	irq_free_descs(irq_base, 32);
> +out_irqdomain_remove:
> +	irq_domain_remove(port->domain);
>  	return err;
>  }
>  
> -- 
> 1.7.11.7
> 
