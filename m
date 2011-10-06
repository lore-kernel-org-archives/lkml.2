Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab1JFKPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 06:15:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41760 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131Ab1JFKPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 06:15:15 -0400
Date: Thu, 6 Oct 2011 04:15:11 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] gpio: langwell: ensure alternate function is cleared
Message-ID: <20111006101511.GM3009@ponder.secretlab.ca>
References: <1317641767-2942-1-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317641767-2942-1-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 02:36:07PM +0300, Adrian Hunter wrote:
> Alternate function must be zero for the pin to act as
> a GPIO.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Applied, thanks.

g.

> ---
>  drivers/gpio/gpio-langwell.c |   27 +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
> index d2eb57c..00692e8 100644
> --- a/drivers/gpio/gpio-langwell.c
> +++ b/drivers/gpio/gpio-langwell.c
> @@ -59,6 +59,7 @@ enum GPIO_REG {
>  	GRER,		/* rising edge detect */
>  	GFER,		/* falling edge detect */
>  	GEDR,		/* edge detect result */
> +	GAFR,		/* alt function */
>  };
>  
>  struct lnw_gpio {
> @@ -81,6 +82,31 @@ static void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
>  	return ptr;
>  }
>  
> +static void __iomem *gpio_reg_2bit(struct gpio_chip *chip, unsigned offset,
> +				   enum GPIO_REG reg_type)
> +{
> +	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
> +	unsigned nreg = chip->ngpio / 32;
> +	u8 reg = offset / 16;
> +	void __iomem *ptr;
> +
> +	ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg * 4);
> +	return ptr;
> +}
> +
> +static int lnw_gpio_request(struct gpio_chip *chip, unsigned offset)
> +{
> +	void __iomem *gafr = gpio_reg_2bit(chip, offset, GAFR);
> +	u32 value = readl(gafr);
> +	int shift = (offset % 16) << 1, af = (value >> shift) & 3;
> +
> +	if (af) {
> +		value &= ~(3 << shift);
> +		writel(value, gafr);
> +	}
> +	return 0;
> +}
> +
>  static int lnw_gpio_get(struct gpio_chip *chip, unsigned offset)
>  {
>  	void __iomem *gplr = gpio_reg(chip, offset, GPLR);
> @@ -321,6 +347,7 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
>  	lnw->reg_base = base;
>  	lnw->irq_base = irq_base;
>  	lnw->chip.label = dev_name(&pdev->dev);
> +	lnw->chip.request = lnw_gpio_request;
>  	lnw->chip.direction_input = lnw_gpio_direction_input;
>  	lnw->chip.direction_output = lnw_gpio_direction_output;
>  	lnw->chip.get = lnw_gpio_get;
> -- 
> 1.7.6
> 
