Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab2EKNKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 09:10:10 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:65342 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab2EKNKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 09:10:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120511094103.16423.51840.sendpatchset@w520>
References: <20120511094103.16423.51840.sendpatchset@w520>
Date: Fri, 11 May 2012 15:10:06 +0200
Message-ID: <CACRpkdaVsBswz8uO_nTjbfbzt+T+YcxunpvoDvOn4+=DTwjG3A@mail.gmail.com>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-sh@vger.kernel.org, horms@verge.net.au,
        grant.likely@secretlab.ca, lethal@linux-sh.org, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 11:41 AM, Magnus Damm <magnus.damm@gmail.com> wrote:

> +config GPIO_EM
> +       tristate "Emma Mobile GPIO"
> +       depends on ARM

ARM really? Why should all ARM systems have the option of configuring in an Emma
controller?

> +static inline unsigned long em_gio_read(struct em_gio_priv *p, int offs)
> +{
> +       if (offs < GIO_IDT0)
> +               return ioread32(p->base0 + offs);
> +       else
> +               return ioread32(p->base1 + (offs - GIO_IDT0));
> +}
> +
> +static inline void em_gio_write(struct em_gio_priv *p, int offs,
> +                               unsigned long value)
> +{
> +       if (offs < GIO_IDT0)
> +               iowrite32(value, p->base0 + offs);
> +       else
> +               iowrite32(value, p->base1 + (offs - GIO_IDT0));
> +}

Isn't ioread()/iowrite() some ISA I/O-space operations? What's wrong with
readl_[relaxed] and writel_[relaxed]()?

> +static struct em_gio_priv *irq_to_priv(unsigned int irq)
> +{
> +       struct irq_chip *chip = irq_get_chip(irq);
> +       return container_of(chip, struct em_gio_priv, irq_chip);
> +}

Should this be inline maybe?

> +
> +static void em_gio_irq_disable(struct irq_data *data)
> +{
> +       struct em_gio_priv *p = irq_to_priv(data->irq);
> +       int offset = data->irq - p->irq_base;
> +
> +       em_gio_write(p, GIO_IDS, 1 << offset);

Suggest:
#include <linux/bitops.h>
em_gio_write(p, GIO_IDS, BIT(offset));

(No big deal, just having fun...)

> +static void em_gio_irq_enable(struct irq_data *data)
> +{
> +       struct em_gio_priv *p = irq_to_priv(data->irq);
> +       int offset = data->irq - p->irq_base;
> +
> +       em_gio_write(p, GIO_IEN, 1 << offset);
> +}

Dito.

> +       /* disable the interrupt in IIA */
> +       tmp = em_gio_read(p, GIO_IIA);
> +       tmp &= ~(1 << offset);

Dito.
(etc)

> +static irqreturn_t em_gio_irq_handler(int irq, void *dev_id)
> +{
> +       struct em_gio_priv *p = dev_id;
> +       unsigned long tmp, status;
> +       unsigned int offset;
> +
> +       status = tmp = em_gio_read(p, GIO_MST);
> +       if (!status)
> +               return IRQ_NONE;
> +
> +       while (status) {
> +               offset = __ffs(status);
> +               generic_handle_irq(p->irq_base + offset);

Pleas use irqdomain to translate the IRQ numbers.

> +               status &= ~(1 << offset);
> +       }

We've recently patched a log of IRQ handlers to re-read the IRQ
status register on each iteration. I suspect that is needed here
as well.

while (status = em_gio_read(p, GIO_MST)) {

> +
> +       em_gio_write(p, GIO_IIR, tmp);

And then I guess this would need to be moved into the
loop to clear one bit at the time instead.

> +static struct em_gio_priv *gpio_to_priv(struct gpio_chip *chip)
> +{
> +       return container_of(chip, struct em_gio_priv, gpio_chip);
> +}

inline?

> +static int __devinit em_gio_probe(struct platform_device *pdev)
> +{
> +       struct gpio_em_config *pdata = pdev->dev.platform_data;
> +       struct em_gio_priv *p;
> +       struct resource *io[2], *irq[2];
> +       struct gpio_chip *gpio_chip;
> +       struct irq_chip *irq_chip;
> +       const char *name = dev_name(&pdev->dev);
> +       int k, ret;
> +
> +       p = kzalloc(sizeof(*p), GFP_KERNEL);

Use devm_kzalloc() and friends?

Which makes the error path all much simpler.

> +       p->base0 = ioremap_nocache(io[0]->start, resource_size(io[0]));
> +       if (!p->base0) {
> +               dev_err(&pdev->dev, "failed to remap low I/O memory\n");
> +               ret = -ENXIO;
> +               goto err1;
> +       }
> +
> +       p->base1 = ioremap_nocache(io[1]->start, resource_size(io[1]));
> +       if (!p->base1) {
> +               dev_err(&pdev->dev, "failed to remap high I/O memory\n");
> +               ret = -ENXIO;
> +               goto err2;
> +       }

I usually also request the memory region request_mem_region(),
I don't know if I'm particularly picky though.

Isn't there a new nice inline that will both request and
remap a piece of memory?

> +       p->irq_base = irq_alloc_descs(pdata->irq_base, 0,
> +                                     pdata->number_of_pins, numa_node_id());
> +       if (IS_ERR_VALUE(p->irq_base)) {
> +               dev_err(&pdev->dev, "cannot get irq_desc\n");
> +               ret = -ENXIO;
> +               goto err3;
> +       }
> +
> +       pr_debug("gio: hw base = %d, nr = %d, sw base = %d\n",
> +                pdata->gpio_base, pdata->number_of_pins, p->irq_base);
> +
> +       irq_chip->name = name;
> +       irq_chip->irq_mask = em_gio_irq_disable;
> +       irq_chip->irq_unmask = em_gio_irq_enable;
> +       irq_chip->irq_enable = em_gio_irq_enable;
> +       irq_chip->irq_disable = em_gio_irq_disable;
> +       irq_chip->irq_set_type = em_gio_irq_set_type;
> +       irq_chip->flags = IRQCHIP_SKIP_SET_WAKE;
> +
> +       for (k = p->irq_base; k < (p->irq_base + pdata->number_of_pins); k++) {
> +               irq_set_chip_and_handler_name(k, irq_chip, handle_level_irq,
> +                                             "level");
> +               set_irq_flags(k, IRQF_VALID); /* kill me now */
> +       }
> +
> +       if (request_irq(irq[0]->start, em_gio_irq_handler, 0, name, p)) {
> +               dev_err(&pdev->dev, "failed to request low IRQ\n");
> +               ret = -ENOENT;
> +               goto err4;
> +       }
> +
> +       if (request_irq(irq[1]->start, em_gio_irq_handler, 0, name, p)) {
> +               dev_err(&pdev->dev, "failed to request high IRQ\n");
> +               ret = -ENOENT;
> +               goto err5;
> +       }

Can you try to use irqdomain for IRQ translation of the base?

Yours,
Linus Walleij
