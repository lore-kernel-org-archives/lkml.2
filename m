Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab2KOIX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:23:28 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:52589 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab2KOIX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:23:26 -0500
Message-ID: <50A4A67C.2040306@atmel.com>
Date: Thu, 15 Nov 2012 09:23:24 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>, Linus Walleij <linus.walleij@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RESEND 3/4] pinctrl: at91: Prevent NULL dereference if
 of_match_device returns NULL
References: <1352955096.6793.1.camel@phoenix> <1352955266.6793.4.camel@phoenix> <1352955480.6793.8.camel@phoenix>
In-Reply-To: <1352955480.6793.8.camel@phoenix>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2012 05:58 AM, Axel Lin :
> of_match_device() may return NULL.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Seems sensible,

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
> This resend CC Jean-Christophe.
> 
>  drivers/pinctrl/pinctrl-at91.c |   17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index 8490a55..32006c8 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -829,13 +829,18 @@ static int __devinit at91_pinctrl_probe_dt(struct platform_device *pdev,
>  	uint32_t *tmp;
>  	struct device_node *np = pdev->dev.of_node;
>  	struct device_node *child;
> +	const struct of_device_id *match;
>  
>  	if (!np)
>  		return -ENODEV;
>  
> +	match = of_match_device(at91_pinctrl_of_match, &pdev->dev)->data;
> +	if (!match)
> +		return -ENODEV;
> +
>  	info->dev = &pdev->dev;
> -	info->ops = (struct at91_pinctrl_mux_ops*)
> -		of_match_device(at91_pinctrl_of_match, &pdev->dev)->data;
> +	info->ops = (struct at91_pinctrl_mux_ops *) match->data;
> +
>  	at91_pinctrl_child_count(info, np);
>  
>  	if (info->nbanks < 1) {
> @@ -1359,6 +1364,7 @@ static struct of_device_id at91_gpio_of_match[] __devinitdata = {
>  static int __devinit at91_gpio_probe(struct platform_device *pdev)
>  {
>  	struct device_node *np = pdev->dev.of_node;
> +	const struct of_device_id *match;
>  	struct resource *res;
>  	struct at91_gpio_chip *at91_chip = NULL;
>  	struct gpio_chip *chip;
> @@ -1399,8 +1405,11 @@ static int __devinit at91_gpio_probe(struct platform_device *pdev)
>  		goto err;
>  	}
>  
> -	at91_chip->ops = (struct at91_pinctrl_mux_ops*)
> -		of_match_device(at91_gpio_of_match, &pdev->dev)->data;
> +	match = of_match_device(at91_gpio_of_match, &pdev->dev);
> +	if (!match)
> +		return -ENODEV;
> +
> +	at91_chip->ops = (struct at91_pinctrl_mux_ops *) match->data;
>  	at91_chip->pioc_virq = irq;
>  	at91_chip->pioc_idx = alias_idx;
>  
> 


-- 
Nicolas Ferre
