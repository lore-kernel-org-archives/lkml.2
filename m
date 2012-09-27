Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab2I0N3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:29:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54447 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2I0N3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:29:42 -0400
Message-ID: <506454C2.2080807@gmail.com>
Date: Thu, 27 Sep 2012 08:29:38 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 3/4] pinctrl/nomadik: use simple or linear IRQ domain
References: <1348751639-17457-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1348751639-17457-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 08:13 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This alters the Nomadik pinctrl driver to:
> 
> - Call irqdomain_add_linear() for the DT case so we get
>   all independent from IRQ numbers in this case.
> - Call irqdomain_add_simple() for the legacy case, which
>   allocates the IRQ descriptors for the Nomadik pin controller
>   dynamically.
> 
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/pinctrl/pinctrl-nomadik.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
> index e031c84..6aab107 100644
> --- a/drivers/pinctrl/pinctrl-nomadik.c
> +++ b/drivers/pinctrl/pinctrl-nomadik.c
> @@ -1286,9 +1286,19 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
>  
>  	platform_set_drvdata(dev, nmk_chip);
>  
> -	nmk_chip->domain = irq_domain_add_legacy(np, NMK_GPIO_PER_CHIP,
> -						NOMADIK_GPIO_TO_IRQ(pdata->first_gpio),
> -						0, &nmk_gpio_irq_simple_ops, nmk_chip);
> +	if (np) {
> +		/* The DT case will just grab a set of IRQ numbers */
> +		nmk_chip->domain = irq_domain_add_linear(np, NMK_GPIO_PER_CHIP,
> +				&nmk_gpio_irq_simple_ops, nmk_chip);


irq_start = -1;

if (!np)
	irq_start = NOMADIK_GPIO_TO_IRQ(pdata->first_gpio);

and then always call irq_domain_add_simple.

Rob

> +	} else {
> +		/* Non-DT legacy mode, use hardwired IRQ numbers */
> +		int irq_start;
> +
> +		irq_start = NOMADIK_GPIO_TO_IRQ(pdata->first_gpio);
> +		nmk_chip->domain = irq_domain_add_simple(NULL,
> +				NMK_GPIO_PER_CHIP, irq_start,
> +				&nmk_gpio_irq_simple_ops, nmk_chip);
> +	}
>  	if (!nmk_chip->domain) {
>  		dev_err(&dev->dev, "failed to create irqdomain\n");
>  		ret = -ENOSYS;
> 
