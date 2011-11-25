Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab1KYPgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 10:36:38 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37947 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab1KYPgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 10:36:36 -0500
MIME-Version: 1.0
In-Reply-To: <edeb4da00527914f0e1038461539843c46ab0b50.1322171620.git.nicolas.ferre@atmel.com>
References: <167b5ccfc31d9637186c5201cd83cb62df81fc0f.1322171620.git.nicolas.ferre@atmel.com>
	<edeb4da00527914f0e1038461539843c46ab0b50.1322171620.git.nicolas.ferre@atmel.com>
Date: Fri, 25 Nov 2011 09:36:36 -0600
Message-ID: <CAL_JsqLnNtou2gPzEJ4U3_m=RB5FZx3HLoNU5WFAGZBAWSj1tw@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: at91/gpio: add irqdomain to gpio interrupts
From: Rob Herring <robherring2@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        plagnioj@jcrosoft.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 3:56 PM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> ---
>  arch/arm/mach-at91/gpio.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
> index 74d6783..45a39d0 100644
> --- a/arch/arm/mach-at91/gpio.c
> +++ b/arch/arm/mach-at91/gpio.c
> @@ -20,6 +20,7 @@
>  #include <linux/list.h>
>  #include <linux/module.h>
>  #include <linux/io.h>
> +#include <linux/irqdomain.h>
>
>  #include <mach/hardware.h>
>  #include <mach/at91_pio.h>
> @@ -32,6 +33,7 @@ struct at91_gpio_chip {
>        int                     id;             /* ID of register bank */
>        void __iomem            *regbase;       /* Base of register bank */
>        struct clk              *clock;         /* associated clock */
> +       struct irq_domain       domain;         /* associated irq domain */
>  };
>
>  #define to_at91_gpio_chip(c) container_of(c, struct at91_gpio_chip, chip)
> @@ -483,6 +485,20 @@ postcore_initcall(at91_gpio_debugfs_init);
>  /*--------------------------------------------------------------------------*/
>
>  /*
> + * irqdomain initialization: pile up irqdomains on top of AIC range
> + */
> +static void __init at91_gpio_irqdomain(struct at91_gpio_chip *at91_gpio)
> +{
> +       struct irq_domain       *gpio_irq_d = &at91_gpio->domain;
> +
> +       gpio_irq_d->irq_base =
> +               gpio_irq_d->hwirq_base = gpio_to_irq(at91_gpio->chip.base);

This is wrong. hwirq_base is the first irq number relative to the
irq_chip and is generally 0.

irq_base should come from the platform if you need it hardcoded.
Otherwise, it should come from irq_alloc_descs.

> +       gpio_irq_d->nr_irq = at91_gpio->chip.ngpio;
> +       gpio_irq_d->ops = &irq_domain_simple_ops;
> +       irq_domain_add(gpio_irq_d);
> +}
> +
> +/*
>  * This lock class tells lockdep that GPIO irqs are in a different
>  * category than their parents, so it won't report false recursion.
>  */
> @@ -517,6 +533,9 @@ void __init at91_gpio_irq_setup(void)
>                        set_irq_flags(irq, IRQF_VALID);
>                }
>
> +               /* setup irq domain for this GPIO controller */
> +               at91_gpio_irqdomain(this);

I would just inline this code.

Can you use the generic irqchip here? I'm working on a patch to add
irqdomain support to that.

Rob
