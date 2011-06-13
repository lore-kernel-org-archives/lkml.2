Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab1FMPCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 11:02:51 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:54796 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab1FMPCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 11:02:50 -0400
Date: Mon, 13 Jun 2011 09:02:47 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Eric Miao <eric.miao@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] gpio/plat-pxa: fix clash with gpiolib namespace
Message-ID: <20110613150247.GA18161@ponder.secretlab.ca>
References: <1307954539-5681-1-git-send-email-linus.walleij@stericsson.com>
 <BANLkTikkT6ZvsSycu13Fnsek43f9+YUkVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikkT6ZvsSycu13Fnsek43f9+YUkVA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 05:03:50PM +0800, Eric Miao wrote:
> On Mon, Jun 13, 2011 at 4:42 PM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:
> > From: Linus Walleij <linus.walleij@linaro.org>
> >
> > The PXA platform code has a static inline helper called
> > gpio_to_chip which clashes with the gpiolib namespace if we
> > try to expose the function with the same name from gpiolib,
> > and it's still confusing even if we don't do that. So rename
> > it to gpio_to_pxachip().
> >
> > Reported-by: H Hartley Sweeten <hartleys@visionengravers.com>
> > Cc: Eric Miao <eric.miao@linaro.org>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> OK, applied to 'devel'.

Is the pxa gpio driver going to be moved to drivers/gpio this cycle?
If so, you'll probably want to keep the gpio changes in a separate
branch that can be merged both into gpio/next and your devel branch,
just in case there ends up being merge issues between our branches in
linux-next.

g.

> 
> > ---
> >  arch/arm/plat-pxa/gpio.c |   10 +++++-----
> >  1 files changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm/plat-pxa/gpio.c b/arch/arm/plat-pxa/gpio.c
> > index 48ebb94..a11dc36 100644
> > --- a/arch/arm/plat-pxa/gpio.c
> > +++ b/arch/arm/plat-pxa/gpio.c
> > @@ -50,7 +50,7 @@ static inline void __iomem *gpio_chip_base(struct gpio_chip *c)
> >        return container_of(c, struct pxa_gpio_chip, chip)->regbase;
> >  }
> >
> > -static inline struct pxa_gpio_chip *gpio_to_chip(unsigned gpio)
> > +static inline struct pxa_gpio_chip *gpio_to_pxachip(unsigned gpio)
> >  {
> >        return &pxa_gpio_chips[gpio_to_bank(gpio)];
> >  }
> > @@ -161,7 +161,7 @@ static int pxa_gpio_irq_type(struct irq_data *d, unsigned int type)
> >        int gpio = irq_to_gpio(d->irq);
> >        unsigned long gpdr, mask = GPIO_bit(gpio);
> >
> > -       c = gpio_to_chip(gpio);
> > +       c = gpio_to_pxachip(gpio);
> >
> >        if (type == IRQ_TYPE_PROBE) {
> >                /* Don't mess with enabled GPIOs using preconfigured edges or
> > @@ -230,7 +230,7 @@ static void pxa_gpio_demux_handler(unsigned int irq, struct irq_desc *desc)
> >  static void pxa_ack_muxed_gpio(struct irq_data *d)
> >  {
> >        int gpio = irq_to_gpio(d->irq);
> > -       struct pxa_gpio_chip *c = gpio_to_chip(gpio);
> > +       struct pxa_gpio_chip *c = gpio_to_pxachip(gpio);
> >
> >        __raw_writel(GPIO_bit(gpio), c->regbase + GEDR_OFFSET);
> >  }
> > @@ -238,7 +238,7 @@ static void pxa_ack_muxed_gpio(struct irq_data *d)
> >  static void pxa_mask_muxed_gpio(struct irq_data *d)
> >  {
> >        int gpio = irq_to_gpio(d->irq);
> > -       struct pxa_gpio_chip *c = gpio_to_chip(gpio);
> > +       struct pxa_gpio_chip *c = gpio_to_pxachip(gpio);
> >        uint32_t grer, gfer;
> >
> >        c->irq_mask &= ~GPIO_bit(gpio);
> > @@ -252,7 +252,7 @@ static void pxa_mask_muxed_gpio(struct irq_data *d)
> >  static void pxa_unmask_muxed_gpio(struct irq_data *d)
> >  {
> >        int gpio = irq_to_gpio(d->irq);
> > -       struct pxa_gpio_chip *c = gpio_to_chip(gpio);
> > +       struct pxa_gpio_chip *c = gpio_to_pxachip(gpio);
> >
> >        c->irq_mask |= GPIO_bit(gpio);
> >        update_edge_detect(c);
> > --
> > 1.7.3.2
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> >
