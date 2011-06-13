Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab1FMPtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 11:49:32 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49814 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1FMPtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 11:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=fGjayXwTEjfYLTHnJq3zYgrq/osgwLwcQks0p4u9ipqREIWnivZlVP/zwah7gyIoLT
         +kEBMMRXPWHkHP7H5alLwX20r7R3YN+k7aQV59CzR1VzNj6Sf/wyx7uxXNMwBJFD5Hjq
         +ItlEE6uXopPPk9FHfy75xYxb5sIMSk6OWIGY=
MIME-Version: 1.0
In-Reply-To: <20110613150247.GA18161@ponder.secretlab.ca>
References: <1307954539-5681-1-git-send-email-linus.walleij@stericsson.com>
 <BANLkTikkT6ZvsSycu13Fnsek43f9+YUkVA@mail.gmail.com> <20110613150247.GA18161@ponder.secretlab.ca>
From: Eric Miao <eric.miao@linaro.org>
Date: Mon, 13 Jun 2011 23:49:10 +0800
X-Google-Sender-Auth: h3e4XUFEyud31vuYzxY9Y2rYXHo
Message-ID: <BANLkTiky1GrQu7ooxgUNGfLQsW8haTF4sA@mail.gmail.com>
Subject: Re: [PATCH] gpio/plat-pxa: fix clash with gpiolib namespace
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 11:02 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Mon, Jun 13, 2011 at 05:03:50PM +0800, Eric Miao wrote:
>> On Mon, Jun 13, 2011 at 4:42 PM, Linus Walleij
>> <linus.walleij@stericsson.com> wrote:
>> > From: Linus Walleij <linus.walleij@linaro.org>
>> >
>> > The PXA platform code has a static inline helper called
>> > gpio_to_chip which clashes with the gpiolib namespace if we
>> > try to expose the function with the same name from gpiolib,
>> > and it's still confusing even if we don't do that. So rename
>> > it to gpio_to_pxachip().
>> >
>> > Reported-by: H Hartley Sweeten <hartleys@visionengravers.com>
>> > Cc: Eric Miao <eric.miao@linaro.org>
>> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> OK, applied to 'devel'.
>
> Is the pxa gpio driver going to be moved to drivers/gpio this cycle?
> If so, you'll probably want to keep the gpio changes in a separate
> branch that can be merged both into gpio/next and your devel branch,
> just in case there ends up being merge issues between our branches in
> linux-next.

Working on that - the problem is the tight coupling of IRQ subsystem and
PXA's odd interrupt routing scheme (GPIO0, GPIO1 have dedicated IRQs,
yet GPIO2 and above they share a single GPIO), while some other PXAs
they all share a single IRQ line. Would work on that for some time
though, so yeah I'll possibly keep this in seperate branch.

>
> g.
>
>>
>> > ---
>> >  arch/arm/plat-pxa/gpio.c |   10 +++++-----
>> >  1 files changed, 5 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/arch/arm/plat-pxa/gpio.c b/arch/arm/plat-pxa/gpio.c
>> > index 48ebb94..a11dc36 100644
>> > --- a/arch/arm/plat-pxa/gpio.c
>> > +++ b/arch/arm/plat-pxa/gpio.c
>> > @@ -50,7 +50,7 @@ static inline void __iomem *gpio_chip_base(struct gpio_chip *c)
>> >        return container_of(c, struct pxa_gpio_chip, chip)->regbase;
>> >  }
>> >
>> > -static inline struct pxa_gpio_chip *gpio_to_chip(unsigned gpio)
>> > +static inline struct pxa_gpio_chip *gpio_to_pxachip(unsigned gpio)
>> >  {
>> >        return &pxa_gpio_chips[gpio_to_bank(gpio)];
>> >  }
>> > @@ -161,7 +161,7 @@ static int pxa_gpio_irq_type(struct irq_data *d, unsigned int type)
>> >        int gpio = irq_to_gpio(d->irq);
>> >        unsigned long gpdr, mask = GPIO_bit(gpio);
>> >
>> > -       c = gpio_to_chip(gpio);
>> > +       c = gpio_to_pxachip(gpio);
>> >
>> >        if (type == IRQ_TYPE_PROBE) {
>> >                /* Don't mess with enabled GPIOs using preconfigured edges or
>> > @@ -230,7 +230,7 @@ static void pxa_gpio_demux_handler(unsigned int irq, struct irq_desc *desc)
>> >  static void pxa_ack_muxed_gpio(struct irq_data *d)
>> >  {
>> >        int gpio = irq_to_gpio(d->irq);
>> > -       struct pxa_gpio_chip *c = gpio_to_chip(gpio);
>> > +       struct pxa_gpio_chip *c = gpio_to_pxachip(gpio);
>> >
>> >        __raw_writel(GPIO_bit(gpio), c->regbase + GEDR_OFFSET);
>> >  }
>> > @@ -238,7 +238,7 @@ static void pxa_ack_muxed_gpio(struct irq_data *d)
>> >  static void pxa_mask_muxed_gpio(struct irq_data *d)
>> >  {
>> >        int gpio = irq_to_gpio(d->irq);
>> > -       struct pxa_gpio_chip *c = gpio_to_chip(gpio);
>> > +       struct pxa_gpio_chip *c = gpio_to_pxachip(gpio);
>> >        uint32_t grer, gfer;
>> >
>> >        c->irq_mask &= ~GPIO_bit(gpio);
>> > @@ -252,7 +252,7 @@ static void pxa_mask_muxed_gpio(struct irq_data *d)
>> >  static void pxa_unmask_muxed_gpio(struct irq_data *d)
>> >  {
>> >        int gpio = irq_to_gpio(d->irq);
>> > -       struct pxa_gpio_chip *c = gpio_to_chip(gpio);
>> > +       struct pxa_gpio_chip *c = gpio_to_pxachip(gpio);
>> >
>> >        c->irq_mask |= GPIO_bit(gpio);
>> >        update_edge_detect(c);
>> > --
>> > 1.7.3.2
>> >
>> >
>> > _______________________________________________
>> > linux-arm-kernel mailing list
>> > linux-arm-kernel@lists.infradead.org
>> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>> >
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
