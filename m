Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab2I0FNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:13:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39445 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab2I0FNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:13:15 -0400
Message-ID: <5063E06A.6000205@nvidia.com>
Date: Wed, 26 Sep 2012 23:13:14 -0600
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] pinctrl/nomadik: allocate IRQ descriptors dynamically
References: <1348679887-2135-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1348679887-2135-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 11:18 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This allocates the IRQ descriptors for the Nomadik pin controller
> dynamically so that we don't have to rely on some other mechanism
> doing it, and moving a step closer to a linear IRQ domain.
> 
> Cc: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/pinctrl/pinctrl-nomadik.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
> index 3dde653..29921d1 100644
> --- a/drivers/pinctrl/pinctrl-nomadik.c
> +++ b/drivers/pinctrl/pinctrl-nomadik.c
> @@ -1185,6 +1185,8 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
>  	struct clk *clk;
>  	int secondary_irq;
>  	void __iomem *base;
> +	int irq_start;
> +	int irq_base;
>  	int irq;
>  	int ret;
>  
> @@ -1288,9 +1290,22 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
>  
>  	platform_set_drvdata(dev, nmk_chip);
>  
> +	/*
> +	 * Allocate descriptors and IRQ domain using the legacy model, this
> +	 * should eventually be replaced with a linear IRQ domain as we get
> +	 * independent from the irq numbers with the switch to device tree.
> +	 */
> +	irq_start = NOMADIK_GPIO_TO_IRQ(pdata->first_gpio);

Presumably that's a 1:1 mapping...

> +	irq_base = irq_alloc_descs(irq_start, 0, NMK_GPIO_PER_CHIP,
> +				   numa_node_id());
> +	if (IS_ERR_VALUE(irq_base)) {
> +		WARN(1, "Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
> +		     irq_start);
> +		irq_base = irq_start;
> +	}

Hmmm. Is this code targetting the DT case or the non-DT case or both? I
think typically you'd call irq_domain_add_linear without forcing a
particular IRQ base for the DT case, and only call irq_alloc_descs() for
the non-DT case, right?

>  	nmk_chip->domain = irq_domain_add_legacy(np, NMK_GPIO_PER_CHIP,
> -						NOMADIK_GPIO_TO_IRQ(pdata->first_gpio),
> -						0, &nmk_gpio_irq_simple_ops, nmk_chip);
> +				irq_base, 0,
> +				&nmk_gpio_irq_simple_ops, nmk_chip);
>  	if (!nmk_chip->domain) {
>  		dev_err(&dev->dev, "failed to create irqdomain\n");
>  		ret = -ENOSYS;

