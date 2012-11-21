Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab2KUO6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:58:47 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45252 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab2KUO6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:58:46 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/7] gpio/em: convert to linear IRQ domain
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <damm@opensource.se>
In-Reply-To: <1350415340-2825-1-git-send-email-linus.walleij@linaro.org>
References: <1350415340-2825-1-git-send-email-linus.walleij@linaro.org>
Date: Wed, 21 Nov 2012 14:58:42 +0000
Message-Id: <20121121145842.5A45B3E0A47@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012 21:22:20 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> The code in the em driver seems to want to try to do the job of
> the linear IRQ domain (allocate descriptors and grab a virtual
> range). So why not just use the linear IRQ domain?
> 
> Also fixed the FIXME to remove the domain after use.

Applied, thanks.

g.

> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Magnus Damm <damm@opensource.se>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/gpio/gpio-em.c | 22 +++-------------------
>  1 file changed, 3 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-em.c b/drivers/gpio/gpio-em.c
> index efb4c2d..aac5c75 100644
> --- a/drivers/gpio/gpio-em.c
> +++ b/drivers/gpio/gpio-em.c
> @@ -35,7 +35,6 @@
>  struct em_gio_priv {
>  	void __iomem *base0;
>  	void __iomem *base1;
> -	unsigned int irq_base;
>  	spinlock_t sense_lock;
>  	struct platform_device *pdev;
>  	struct gpio_chip gpio_chip;
> @@ -239,33 +238,18 @@ static int __devinit em_gio_irq_domain_init(struct em_gio_priv *p)
>  	struct platform_device *pdev = p->pdev;
>  	struct gpio_em_config *pdata = pdev->dev.platform_data;
>  
> -	p->irq_base = irq_alloc_descs(pdata->irq_base, 0,
> -				      pdata->number_of_pins, numa_node_id());
> -	if (p->irq_base < 0) {
> -		dev_err(&pdev->dev, "cannot get irq_desc\n");
> -		return p->irq_base;
> -	}
> -	pr_debug("gio: hw base = %d, nr = %d, sw base = %d\n",
> -		 pdata->gpio_base, pdata->number_of_pins, p->irq_base);
> -
> -	p->irq_domain = irq_domain_add_legacy(pdev->dev.of_node,
> +	p->irq_domain = irq_domain_add_linear(pdev->dev.of_node,
>  					      pdata->number_of_pins,
> -					      p->irq_base, 0,
>  					      &em_gio_irq_domain_ops, p);
> -	if (!p->irq_domain) {
> -		irq_free_descs(p->irq_base, pdata->number_of_pins);
> +	if (!p->irq_domain)
>  		return -ENXIO;
> -	}
>  
>  	return 0;
>  }
>  
>  static void em_gio_irq_domain_cleanup(struct em_gio_priv *p)
>  {
> -	struct gpio_em_config *pdata = p->pdev->dev.platform_data;
> -
> -	irq_free_descs(p->irq_base, pdata->number_of_pins);
> -	/* FIXME: irq domain wants to be freed! */
> +	irq_domain_remove(p->irq_domain);
>  }
>  
>  static int __devinit em_gio_probe(struct platform_device *pdev)
> -- 
> 1.7.11.7
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
