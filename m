Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab2DFOon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 10:44:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51628 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab2DFOol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 10:44:41 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/3] gpio: langwell: allocate IRQ descriptors dynamically for SPARSE_IRQ
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
In-Reply-To: <1333617317-28437-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1333617317-28437-1-git-send-email-mika.westerberg@linux.intel.com> <1333617317-28437-2-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 05 Apr 2012 21:34:14 -0700
Message-Id: <20120406043414.3B8FF3E0DD7@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Apr 2012 12:15:16 +0300, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> Since x86 is using SPARSE_IRQ by default nowadays it means that we need to
> allocate IRQ descriptors dynamically using irq_alloc_descs() otherwise the
> genirq code fails to convert our irq numbers to suitable descriptors.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied, thakns.

While you're in this driver, you should look at converting to using an
irq_domain for irq <==> hwirq mapping.  At the very least,
irq_data->hwirq should be used instead of abusing irq_set_chip_data().

g.

> ---
>  drivers/gpio/gpio-langwell.c |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
> index 0bea41b..bc15ae3 100644
> --- a/drivers/gpio/gpio-langwell.c
> +++ b/drivers/gpio/gpio-langwell.c
> @@ -306,6 +306,7 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
>  	u32 irq_base;
>  	u32 gpio_base;
>  	int retval = 0;
> +	int ngpio = id->driver_data;
>  
>  	retval = pci_enable_device(pdev);
>  	if (retval)
> @@ -344,8 +345,15 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
>  		retval = -ENOMEM;
>  		goto err3;
>  	}
> +
> +	retval = irq_alloc_descs(-1, irq_base, ngpio, 0);
> +	if (retval < 0) {
> +		dev_err(&pdev->dev, "can't allocate IRQ descs\n");
> +		goto err3;
> +	}
> +	lnw->irq_base = retval;
> +
>  	lnw->reg_base = base;
> -	lnw->irq_base = irq_base;
>  	lnw->chip.label = dev_name(&pdev->dev);
>  	lnw->chip.request = lnw_gpio_request;
>  	lnw->chip.direction_input = lnw_gpio_direction_input;
> @@ -354,14 +362,14 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
>  	lnw->chip.set = lnw_gpio_set;
>  	lnw->chip.to_irq = lnw_gpio_to_irq;
>  	lnw->chip.base = gpio_base;
> -	lnw->chip.ngpio = id->driver_data;
> +	lnw->chip.ngpio = ngpio;
>  	lnw->chip.can_sleep = 0;
>  	lnw->pdev = pdev;
>  	pci_set_drvdata(pdev, lnw);
>  	retval = gpiochip_add(&lnw->chip);
>  	if (retval) {
>  		dev_err(&pdev->dev, "langwell gpiochip_add error %d\n", retval);
> -		goto err3;
> +		goto err4;
>  	}
>  	irq_set_handler_data(pdev->irq, lnw);
>  	irq_set_chained_handler(pdev->irq, lnw_irq_handler);
> @@ -378,6 +386,8 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
>  
>  	return 0;
>  
> +err4:
> +	irq_free_descs(lnw->irq_base, ngpio);
>  err3:
>  	pci_release_regions(pdev);
>  err2:
> -- 
> 1.7.9.1
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
