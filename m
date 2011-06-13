Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab1FMJEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 05:04:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61123 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab1FMJEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 05:04:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=nsSmgSZ/kvGue2JBFGUqic6hMh3MRAL0fM5ndQOUjyC46witC3wLGyecC9ZVwFupQn
         GGZeBAqkYjT2e/BYRzS5FPKiJewcjX5qna5hTmt8EFmvKyNUHTpxRkitRDfFFyughl6p
         4Bygx9XYkAb4yo4K3v60wXaaPST+Ks13QyCQg=
MIME-Version: 1.0
In-Reply-To: <1307954539-5681-1-git-send-email-linus.walleij@stericsson.com>
References: <1307954539-5681-1-git-send-email-linus.walleij@stericsson.com>
From: Eric Miao <eric.miao@linaro.org>
Date: Mon, 13 Jun 2011 17:03:50 +0800
X-Google-Sender-Auth: _k81L7oeqHIg41Fl0F8dji2GSEg
Message-ID: <BANLkTikkT6ZvsSycu13Fnsek43f9+YUkVA@mail.gmail.com>
Subject: Re: [PATCH] gpio/plat-pxa: fix clash with gpiolib namespace
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 4:42 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> The PXA platform code has a static inline helper called
> gpio_to_chip which clashes with the gpiolib namespace if we
> try to expose the function with the same name from gpiolib,
> and it's still confusing even if we don't do that. So rename
> it to gpio_to_pxachip().
>
> Reported-by: H Hartley Sweeten <hartleys@visionengravers.com>
> Cc: Eric Miao <eric.miao@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

OK, applied to 'devel'.

> ---
>  arch/arm/plat-pxa/gpio.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm/plat-pxa/gpio.c b/arch/arm/plat-pxa/gpio.c
> index 48ebb94..a11dc36 100644
> --- a/arch/arm/plat-pxa/gpio.c
> +++ b/arch/arm/plat-pxa/gpio.c
> @@ -50,7 +50,7 @@ static inline void __iomem *gpio_chip_base(struct gpio_chip *c)
>        return container_of(c, struct pxa_gpio_chip, chip)->regbase;
>  }
>
> -static inline struct pxa_gpio_chip *gpio_to_chip(unsigned gpio)
> +static inline struct pxa_gpio_chip *gpio_to_pxachip(unsigned gpio)
>  {
>        return &pxa_gpio_chips[gpio_to_bank(gpio)];
>  }
> @@ -161,7 +161,7 @@ static int pxa_gpio_irq_type(struct irq_data *d, unsigned int type)
>        int gpio = irq_to_gpio(d->irq);
>        unsigned long gpdr, mask = GPIO_bit(gpio);
>
> -       c = gpio_to_chip(gpio);
> +       c = gpio_to_pxachip(gpio);
>
>        if (type == IRQ_TYPE_PROBE) {
>                /* Don't mess with enabled GPIOs using preconfigured edges or
> @@ -230,7 +230,7 @@ static void pxa_gpio_demux_handler(unsigned int irq, struct irq_desc *desc)
>  static void pxa_ack_muxed_gpio(struct irq_data *d)
>  {
>        int gpio = irq_to_gpio(d->irq);
> -       struct pxa_gpio_chip *c = gpio_to_chip(gpio);
> +       struct pxa_gpio_chip *c = gpio_to_pxachip(gpio);
>
>        __raw_writel(GPIO_bit(gpio), c->regbase + GEDR_OFFSET);
>  }
> @@ -238,7 +238,7 @@ static void pxa_ack_muxed_gpio(struct irq_data *d)
>  static void pxa_mask_muxed_gpio(struct irq_data *d)
>  {
>        int gpio = irq_to_gpio(d->irq);
> -       struct pxa_gpio_chip *c = gpio_to_chip(gpio);
> +       struct pxa_gpio_chip *c = gpio_to_pxachip(gpio);
>        uint32_t grer, gfer;
>
>        c->irq_mask &= ~GPIO_bit(gpio);
> @@ -252,7 +252,7 @@ static void pxa_mask_muxed_gpio(struct irq_data *d)
>  static void pxa_unmask_muxed_gpio(struct irq_data *d)
>  {
>        int gpio = irq_to_gpio(d->irq);
> -       struct pxa_gpio_chip *c = gpio_to_chip(gpio);
> +       struct pxa_gpio_chip *c = gpio_to_pxachip(gpio);
>
>        c->irq_mask |= GPIO_bit(gpio);
>        update_edge_detect(c);
> --
> 1.7.3.2
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
