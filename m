Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab2CLRxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:53:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41124 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2CLRxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:53:54 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] gpio/davinci: fix enabling unbanked GPIO IRQs
To: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
In-Reply-To: <1331469972-2638-3-git-send-email-nsekhar@ti.com>
References: <1331469972-2638-1-git-send-email-nsekhar@ti.com> <1331469972-2638-3-git-send-email-nsekhar@ti.com>
Date: Mon, 12 Mar 2012 11:53:51 -0600
Message-Id: <20120312175351.EA12E3E07B0@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2012 18:16:12 +0530, Sekhar Nori <nsekhar@ti.com> wrote:
> Unbanked GPIO IRQ handling code made a copy of just
> the irq_chip structure for GPIO IRQ lines which caused
> problems after the generic IRQ chip conversion because
> there was no valid irq_chip_type structure with the
> right "regs" populated. irq_gc_mask_set_bit() was
> therefore accessing random addresses.
> 
> Fix it by making a copy of irq_chip_type structure
> instead. This will ensure sane register offsets.
> 
> Cc: <stable@vger.kernel.org> # v3.0.x+
> Reported-by: Jon Povey <Jon.Povey@racelogic.co.uk>
> Tested-by: Jon Povey <Jon.Povey@racelogic.co.uk>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>

Applied, thx.

g.

> ---
>  drivers/gpio/gpio-davinci.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
> index a6777e5..3d00016 100644
> --- a/drivers/gpio/gpio-davinci.c
> +++ b/drivers/gpio/gpio-davinci.c
> @@ -386,7 +386,7 @@ static int __init davinci_gpio_irq_setup(void)
>  	 * IRQ mux conflicts; gpio_irq_type_unbanked() is only for GPIOs.
>  	 */
>  	if (soc_info->gpio_unbanked) {
> -		static struct irq_chip gpio_irqchip_unbanked;
> +		static struct irq_chip_type gpio_unbanked;
>  
>  		/* pass "bank 0" GPIO IRQs to AINTC */
>  		chips[0].chip.to_irq = gpio_to_irq_unbanked;
> @@ -394,9 +394,10 @@ static int __init davinci_gpio_irq_setup(void)
>  
>  		/* AINTC handles mask/unmask; GPIO handles triggering */
>  		irq = bank_irq;
> -		gpio_irqchip_unbanked = *irq_get_chip(irq);
> -		gpio_irqchip_unbanked.name = "GPIO-AINTC";
> -		gpio_irqchip_unbanked.irq_set_type = gpio_irq_type_unbanked;
> +		gpio_unbanked = *container_of(irq_get_chip(irq),
> +					      struct irq_chip_type, chip);
> +		gpio_unbanked.chip.name = "GPIO-AINTC";
> +		gpio_unbanked.chip.irq_set_type = gpio_irq_type_unbanked;
>  
>  		/* default trigger: both edges */
>  		g = gpio2regs(0);
> @@ -405,7 +406,7 @@ static int __init davinci_gpio_irq_setup(void)
>  
>  		/* set the direct IRQs up to use that irqchip */
>  		for (gpio = 0; gpio < soc_info->gpio_unbanked; gpio++, irq++) {
> -			irq_set_chip(irq, &gpio_irqchip_unbanked);
> +			irq_set_chip(irq, &gpio_unbanked.chip);
>  			irq_set_handler_data(irq, &chips[gpio / 32]);
>  			irq_set_status_flags(irq, IRQ_TYPE_EDGE_BOTH);
>  		}
> -- 
> 1.7.0.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
