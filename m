Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab2DFOpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 10:45:03 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51628 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327Ab2DFOol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 10:44:41 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/3] gpio: langwell: use devm_* helpers to simplify probe
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
In-Reply-To: <1333617317-28437-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1333617317-28437-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 05 Apr 2012 21:26:03 -0700
Message-Id: <20120406042603.5F0953E03FF@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Apr 2012 12:15:15 +0300, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> Use devm_* helper functions where possible to make the error handling in
> the probe function simpler.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied, thanks.

g.

> ---
>  drivers/gpio/gpio-langwell.c |   18 +++++++-----------
>  1 files changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
> index 00692e8..0bea41b 100644
> --- a/drivers/gpio/gpio-langwell.c
> +++ b/drivers/gpio/gpio-langwell.c
> @@ -309,7 +309,7 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
>  
>  	retval = pci_enable_device(pdev);
>  	if (retval)
> -		goto done;
> +		return retval;
>  
>  	retval = pci_request_regions(pdev, "langwell_gpio");
>  	if (retval) {
> @@ -331,18 +331,18 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
>  	/* get the register base from bar0 */
>  	start = pci_resource_start(pdev, 0);
>  	len = pci_resource_len(pdev, 0);
> -	base = ioremap_nocache(start, len);
> +	base = devm_ioremap_nocache(&pdev->dev, start, len);
>  	if (!base) {
>  		dev_err(&pdev->dev, "error mapping bar0\n");
>  		retval = -EFAULT;
>  		goto err3;
>  	}
>  
> -	lnw = kzalloc(sizeof(struct lnw_gpio), GFP_KERNEL);
> +	lnw = devm_kzalloc(&pdev->dev, sizeof(struct lnw_gpio), GFP_KERNEL);
>  	if (!lnw) {
>  		dev_err(&pdev->dev, "can't allocate langwell_gpio chip data\n");
>  		retval = -ENOMEM;
> -		goto err4;
> +		goto err3;
>  	}
>  	lnw->reg_base = base;
>  	lnw->irq_base = irq_base;
> @@ -361,7 +361,7 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
>  	retval = gpiochip_add(&lnw->chip);
>  	if (retval) {
>  		dev_err(&pdev->dev, "langwell gpiochip_add error %d\n", retval);
> -		goto err5;
> +		goto err3;
>  	}
>  	irq_set_handler_data(pdev->irq, lnw);
>  	irq_set_chained_handler(pdev->irq, lnw_irq_handler);
> @@ -376,16 +376,12 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
>  	pm_runtime_put_noidle(&pdev->dev);
>  	pm_runtime_allow(&pdev->dev);
>  
> -	goto done;
> -err5:
> -	kfree(lnw);
> -err4:
> -	iounmap(base);
> +	return 0;
> +
>  err3:
>  	pci_release_regions(pdev);
>  err2:
>  	pci_disable_device(pdev);
> -done:
>  	return retval;
>  }
>  
> -- 
> 1.7.9.1
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
