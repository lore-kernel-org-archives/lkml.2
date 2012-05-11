Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350Ab2EKPpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:45:30 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50855 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab2EKPp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:45:28 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdaVsBswz8uO_nTjbfbzt+T+YcxunpvoDvOn4+=DTwjG3A@mail.gmail.com>
References: <20120511094103.16423.51840.sendpatchset@w520>
	<CACRpkdaVsBswz8uO_nTjbfbzt+T+YcxunpvoDvOn4+=DTwjG3A@mail.gmail.com>
Date: Sat, 12 May 2012 00:45:27 +0900
Message-ID: <CANqRtoRx0VDmrPz=foD03z+ZYdb605Km8SEDKQQwCzbrZ54m3Q@mail.gmail.com>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-sh@vger.kernel.org, horms@verge.net.au,
        grant.likely@secretlab.ca, lethal@linux-sh.org, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Thanks for your review!

On Fri, May 11, 2012 at 10:10 PM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Fri, May 11, 2012 at 11:41 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
>
>> +config GPIO_EM
>> +       tristate "Emma Mobile GPIO"
>> +       depends on ARM
>
> ARM really? Why should all ARM systems have the option of configuring in an Emma
> controller?

Well, first of all, the Emma Mobile line of SoCs are ARM based. You
may think of MIPS based Emma devices. I don' t know so much about
them, but if you happen to know where I can find docs then I'd be very
interested in looking at them to see if I can share any of my recently
developed drivers.

Not sure if your point is that this has nothing to do with the CPU
core itself - at least I usually prefer to omit CPU dependencies for
I/O devices and have as few dependencies as possible to get as much as
compile time testing done. In this particular case I've added ARM as
dependency because I was asked so for the UART driver 8250_em. Either
way is fine with me, so it's up to you GPIO maintainers to decide what
you want. As long as I can enable it on the ARM based SoC family I'm
happy. =)

>> +static inline unsigned long em_gio_read(struct em_gio_priv *p, int offs)
>> +{
>> +       if (offs < GIO_IDT0)
>> +               return ioread32(p->base0 + offs);
>> +       else
>> +               return ioread32(p->base1 + (offs - GIO_IDT0));
>> +}
>> +
>> +static inline void em_gio_write(struct em_gio_priv *p, int offs,
>> +                               unsigned long value)
>> +{
>> +       if (offs < GIO_IDT0)
>> +               iowrite32(value, p->base0 + offs);
>> +       else
>> +               iowrite32(value, p->base1 + (offs - GIO_IDT0));
>> +}
>
> Isn't ioread()/iowrite() some ISA I/O-space operations? What's wrong with
> readl_[relaxed] and writel_[relaxed]()?

Nothing wrong with readl/writel, I've just have a habit of using the
ioread/iowrite ones. I find the code that allows platforms to select
PORT or IOMEM in lib/iomap.c rather neat.

>> +static struct em_gio_priv *irq_to_priv(unsigned int irq)
>> +{
>> +       struct irq_chip *chip = irq_get_chip(irq);
>> +       return container_of(chip, struct em_gio_priv, irq_chip);
>> +}
>
> Should this be inline maybe?

I have not checked if they actually turn out inline with my ARM
compiler, but gcc for SH was always rather good at deciding when to
inline by itself. Its a bit like likely()/unlikely() in my mind, it
may be good to give hints for the compiler but in the majority of the
cases the compiler will be fine by itself. I guess this particular
function may end up as just a few instructions.

>> +
>> +static void em_gio_irq_disable(struct irq_data *data)
>> +{
>> +       struct em_gio_priv *p = irq_to_priv(data->irq);
>> +       int offset = data->irq - p->irq_base;
>> +
>> +       em_gio_write(p, GIO_IDS, 1 << offset);
>
> Suggest:
> #include <linux/bitops.h>
> em_gio_write(p, GIO_IDS, BIT(offset));
>
> (No big deal, just having fun...)

Sure, why not?

>> +static irqreturn_t em_gio_irq_handler(int irq, void *dev_id)
>> +{
>> +       struct em_gio_priv *p = dev_id;
>> +       unsigned long tmp, status;
>> +       unsigned int offset;
>> +
>> +       status = tmp = em_gio_read(p, GIO_MST);
>> +       if (!status)
>> +               return IRQ_NONE;
>> +
>> +       while (status) {
>> +               offset = __ffs(status);
>> +               generic_handle_irq(p->irq_base + offset);
>
> Pleas use irqdomain to translate the IRQ numbers.

Is this mandatory for regular platform devices not using DT?

I don't object to your idea, but I was planning on adding that in my
DT feature patch.

>> +               status &= ~(1 << offset);
>> +       }
>
> We've recently patched a log of IRQ handlers to re-read the IRQ
> status register on each iteration. I suspect that is needed here
> as well.

Doesn't that depend on how the hardware works? OTOH, it may be a safe
way to implement correct code for all kinds of controllers, not sure.

> while (status = em_gio_read(p, GIO_MST)) {
>
>> +
>> +       em_gio_write(p, GIO_IIR, tmp);
>
> And then I guess this would need to be moved into the
> loop to clear one bit at the time instead.

I guess it can be done like that, but wouldn't that lead to potential
starvation of IRQs with bits that happen to be processed first in the
word?

>> +static struct em_gio_priv *gpio_to_priv(struct gpio_chip *chip)
>> +{
>> +       return container_of(chip, struct em_gio_priv, gpio_chip);
>> +}
>
> inline?

Sure, if you think that is absolutely necessary. May I ask, is it
important for you, or is it ok if I skip and keep this driver in line
with my other ones? =)

>> +static int __devinit em_gio_probe(struct platform_device *pdev)
>> +{
>> +       struct gpio_em_config *pdata = pdev->dev.platform_data;
>> +       struct em_gio_priv *p;
>> +       struct resource *io[2], *irq[2];
>> +       struct gpio_chip *gpio_chip;
>> +       struct irq_chip *irq_chip;
>> +       const char *name = dev_name(&pdev->dev);
>> +       int k, ret;
>> +
>> +       p = kzalloc(sizeof(*p), GFP_KERNEL);
>
> Use devm_kzalloc() and friends?

I tend to prefer not to. This because I need to perform proper error
handling anyway.

> Which makes the error path all much simpler.

Maybe so, perhaps I should look into that anyway though.

>> +       p->base0 = ioremap_nocache(io[0]->start, resource_size(io[0]));
>> +       if (!p->base0) {
>> +               dev_err(&pdev->dev, "failed to remap low I/O memory\n");
>> +               ret = -ENXIO;
>> +               goto err1;
>> +       }
>> +
>> +       p->base1 = ioremap_nocache(io[1]->start, resource_size(io[1]));
>> +       if (!p->base1) {
>> +               dev_err(&pdev->dev, "failed to remap high I/O memory\n");
>> +               ret = -ENXIO;
>> +               goto err2;
>> +       }
>
> I usually also request the memory region request_mem_region(),
> I don't know if I'm particularly picky though.

I have left that out myself of pure laziness in my drivers. It may be
good to add. In general I find that there are a few commonly
duplicated operations in the drivers. I realize each function serve a
certain purpose, but at the same time I have a feeling that every
driver ends up moving data from struct resource into other formats and
then perform the same couple of request_irq() or request_mem_region()
and ioremap(). It would be neat to have some helpers operating on
struct resource directly.

> Isn't there a new nice inline that will both request and
> remap a piece of memory?

If so then that would be excellent. Especially together with
ioread/iowrite so the code can work both for IOMEM and PORT
transparently.

>> +       p->irq_base = irq_alloc_descs(pdata->irq_base, 0,
>> +                                     pdata->number_of_pins, numa_node_id());
>> +       if (IS_ERR_VALUE(p->irq_base)) {
>> +               dev_err(&pdev->dev, "cannot get irq_desc\n");
>> +               ret = -ENXIO;
>> +               goto err3;
>> +       }
>> +
>> +       pr_debug("gio: hw base = %d, nr = %d, sw base = %d\n",
>> +                pdata->gpio_base, pdata->number_of_pins, p->irq_base);
>> +
>> +       irq_chip->name = name;
>> +       irq_chip->irq_mask = em_gio_irq_disable;
>> +       irq_chip->irq_unmask = em_gio_irq_enable;
>> +       irq_chip->irq_enable = em_gio_irq_enable;
>> +       irq_chip->irq_disable = em_gio_irq_disable;
>> +       irq_chip->irq_set_type = em_gio_irq_set_type;
>> +       irq_chip->flags = IRQCHIP_SKIP_SET_WAKE;
>> +
>> +       for (k = p->irq_base; k < (p->irq_base + pdata->number_of_pins); k++) {
>> +               irq_set_chip_and_handler_name(k, irq_chip, handle_level_irq,
>> +                                             "level");
>> +               set_irq_flags(k, IRQF_VALID); /* kill me now */
>> +       }
>> +
>> +       if (request_irq(irq[0]->start, em_gio_irq_handler, 0, name, p)) {
>> +               dev_err(&pdev->dev, "failed to request low IRQ\n");
>> +               ret = -ENOENT;
>> +               goto err4;
>> +       }
>> +
>> +       if (request_irq(irq[1]->start, em_gio_irq_handler, 0, name, p)) {
>> +               dev_err(&pdev->dev, "failed to request high IRQ\n");
>> +               ret = -ENOENT;
>> +               goto err5;
>> +       }
>
> Can you try to use irqdomain for IRQ translation of the base?

I was thinking of doing that as part of my DT enabling work, would that be ok?

Do you have any good suggestion what to use to unregister my irqchip?
I believe this version of the driver isn't doing that properly.

Thanks for your help!

Cheers,

/ magnus
