Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab2FKVdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:33:13 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:50405 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2FKVdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:33:11 -0400
MIME-Version: 1.0
In-Reply-To: <1339428307-3850-9-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
	<1339428307-3850-9-git-send-email-lee.jones@linaro.org>
Date: Mon, 11 Jun 2012 23:33:10 +0200
Message-ID: <CACRpkdaZ1OZdaqo=_YvQpyYazpcmhLT8QF4jz1WUQMSAsTM8Sw@mail.gmail.com>
Subject: Re: [PATCH 08/14] mfd: Add IRQ domain support for the AB8500
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Michel Jaouen <michel.jaouen@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 5:25 PM, Lee Jones <lee.jones@linaro.org> wrote:

> As the AB8500 is an IRQ controller in its own right, here we provide
> the AB8500 driver with IRQ domain support. This is required if we wish
> to reference any of its IRQs from a platform's Device Tree.

OK..

> diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
(...)
> -static int ab8500_irq_init(struct ab8500 *ab8500)
> +/**
> + * ab8500_irq_get_virq(): Map an interrupt on a chip to a virtual IRQ
> + *
> + * Useful for drivers to request their own IRQs.

Check style against Documentation/kernel-doc-nano-HOWTO.txt
verbos explanation follows argument documentation.

> + *
> + * @ab8500: ab8500_irq controller to operate on.
> + * @irq: index of the interrupt requested in the chip IRQs
> + */
> +int ab8500_irq_get_virq(struct ab8500 *ab8500, int irq)
>  {
> -       int base = ab8500->irq_base;
> -       int irq;
> -       int num_irqs;
> +       if (!ab8500)
> +               return -EINVAL;
>
> -       if (is_ab9540(ab8500))
> -               num_irqs = AB9540_NR_IRQS;
> -       else if (is_ab8505(ab8500))
> -               num_irqs = AB8505_NR_IRQS;
> -       else
> -               num_irqs = AB8500_NR_IRQS;
> +       return irq_create_mapping(ab8500->domain, irq);
> +}
> +EXPORT_SYMBOL_GPL(ab8500_irq_get_virq);
(...)
> @@ -1233,11 +1256,9 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
>
>        if (plat)
>                ab8500->irq_base = plat->irq_base;
> -       else if (np)
> -               ret = of_property_read_u32(np, "stericsson,irq-base", &ab8500->irq_base);

So if we're not using the irq base thing anymore, should you also
delete it from the binding document too? (If there is no binding
doc something is wrong and you need to create it I guess...)

> diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
> index 91dd3ef..48f126c 100644
> --- a/include/linux/mfd/abx500/ab8500.h
> +++ b/include/linux/mfd/abx500/ab8500.h
> @@ -227,6 +227,7 @@ enum ab8500_version {
>  * @irq_lock: genirq bus lock
>  * @transfer_ongoing: 0 if no transfer ongoing
>  * @irq: irq line
> + * @irq_domain: irq domain
>  * @version: chip version id (e.g. ab8500 or ab9540)
>  * @chip_id: chip revision id
>  * @write: register write
> @@ -247,6 +248,7 @@ struct ab8500 {
>        atomic_t        transfer_ongoing;
>        int             irq_base;
>        int             irq;
> +       struct irq_domain  *domain;

Don't you need to forward-declare struct irq_domain?
I think you're just lucky to have it compiling... (Something
else included  <linux/irqdomain.h> on the way here.)

Yours,
Linus Walleij
