Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab2DFOpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 10:45:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51628 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab2DFOor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 10:44:47 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/3] gpio: langwell: clear IRQ edge detect registers at init
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
In-Reply-To: <1333617317-28437-3-git-send-email-mika.westerberg@linux.intel.com>
References: <1333617317-28437-1-git-send-email-mika.westerberg@linux.intel.com> <1333617317-28437-3-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 05 Apr 2012 21:39:49 -0700
Message-Id: <20120406043949.BDE543E0E10@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Apr 2012 12:15:17 +0300, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> The boot firmware might leave the registers configured causing interrupts
> to happen even when no handler for them is yet registered. Fix this by
> clearing the IRQ edge detect registers at init.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied, thanks

g.

> ---
>  drivers/gpio/gpio-langwell.c |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
> index bc15ae3..52f00d3 100644
> --- a/drivers/gpio/gpio-langwell.c
> +++ b/drivers/gpio/gpio-langwell.c
> @@ -263,6 +263,24 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
>  	chip->irq_eoi(data);
>  }
>  
> +static void lnw_irq_init_hw(struct lnw_gpio *lnw)
> +{
> +	void __iomem *reg;
> +	unsigned base;
> +
> +	for (base = 0; base < lnw->chip.ngpio; base += 32) {
> +		/* Clear the rising-edge detect register */
> +		reg = gpio_reg(&lnw->chip, base, GRER);
> +		writel(0, reg);
> +		/* Clear the falling-edge detect register */
> +		reg = gpio_reg(&lnw->chip, base, GFER);
> +		writel(0, reg);
> +		/* Clear the edge detect status register */
> +		reg = gpio_reg(&lnw->chip, base, GEDR);
> +		writel(~0, reg);
> +	}
> +}
> +
>  #ifdef CONFIG_PM
>  static int lnw_gpio_runtime_resume(struct device *dev)
>  {
> @@ -371,6 +389,9 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
>  		dev_err(&pdev->dev, "langwell gpiochip_add error %d\n", retval);
>  		goto err4;
>  	}
> +
> +	lnw_irq_init_hw(lnw);
> +
>  	irq_set_handler_data(pdev->irq, lnw);
>  	irq_set_chained_handler(pdev->irq, lnw_irq_handler);
>  	for (i = 0; i < lnw->chip.ngpio; i++) {
> -- 
> 1.7.9.1
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
