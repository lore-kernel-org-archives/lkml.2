Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab2HULrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:47:43 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:50496 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754726Ab2HULrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:47:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120821105333.GW10347@arwen.pp.htv.fi>
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
	<1345545940-2232-5-git-send-email-sourav.poddar@ti.com>
	<20120821105333.GW10347@arwen.pp.htv.fi>
Date: Tue, 21 Aug 2012 17:17:37 +0530
Message-ID: <CAKdam56DiFpnoQwrHe1tjQWLMy5vP9ynstNj_n=OyMxkJJAUOA@mail.gmail.com>
Subject: Re: [RFC/PATCH 4/4] gpio: smscece: Add support for gpio IO expander feature
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: balbi@ti.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 21, 2012 at 4:23 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Aug 21, 2012 at 04:15:40PM +0530, Sourav Poddar wrote:
>> smsc can be used as an gpio io expander device also. So adding
>> support for configuring smsc pins as a gpio.
>>
>> Cc: Benoit Cousson <b-cousson@ti.com>
>> Cc: Felipe Balbi <balbi@ti.com>
>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
>> ---
>>  drivers/gpio/Kconfig        |    7 +
>>  drivers/gpio/Makefile       |    1 +
>>  drivers/gpio/gpio-smscece.c |  373 +++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 381 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/gpio/gpio-smscece.c
>>
>> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
>> index b16c8a7..e883929 100644
>> --- a/drivers/gpio/Kconfig
>> +++ b/drivers/gpio/Kconfig
>> @@ -444,6 +444,13 @@ config GPIO_ADP5588_IRQ
>>         Say yes here to enable the adp5588 to be used as an interrupt
>>         controller. It requires the driver to be built in the kernel.
>>
>> +config GPIO_SMSCECE
>> +     tristate "SMSCECE 1099 I2C GPIO expander"
>> +     depends on I2C
>> +     help
>> +       This option enables support for 18 GPIOs found
>> +       on SMSC ECE 1099 GPIO Expanders.
>> +
>>  comment "PCI GPIO expanders:"
>>
>>  config GPIO_CS5535
>> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
>> index 153cace..7c803c5 100644
>> --- a/drivers/gpio/Makefile
>> +++ b/drivers/gpio/Makefile
>> @@ -12,6 +12,7 @@ obj-$(CONFIG_GPIO_74X164)   += gpio-74x164.o
>>  obj-$(CONFIG_GPIO_AB8500)    += gpio-ab8500.o
>>  obj-$(CONFIG_GPIO_ADP5520)   += gpio-adp5520.o
>>  obj-$(CONFIG_GPIO_ADP5588)   += gpio-adp5588.o
>> +obj-$(CONFIG_GPIO_SMSCECE)      += gpio-smscece.o
>>  obj-$(CONFIG_GPIO_AMD8111)   += gpio-amd8111.o
>>  obj-$(CONFIG_GPIO_ARIZONA)   += gpio-arizona.o
>>  obj-$(CONFIG_GPIO_BT8XX)     += gpio-bt8xx.o
>> diff --git a/drivers/gpio/gpio-smscece.c b/drivers/gpio/gpio-smscece.c
>> new file mode 100644
>> index 0000000..0cb0959
>> --- /dev/null
>> +++ b/drivers/gpio/gpio-smscece.c
>> @@ -0,0 +1,373 @@
>> +/*
>> + * GPIO Chip driver for smsc
>> + * SMSC I/O Expander and QWERTY Keypad Controller
>> + *
>> + * Copyright 2012 Texas Instruments Inc.
>> + *
>> + * Licensed under the GPL-2 or later.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/kernel.h>
>> +#include <linux/slab.h>
>> +#include <linux/init.h>
>> +#include <linux/i2c.h>
>> +#include <linux/gpio.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/irqdomain.h>
>> +#include <linux/irq.h>
>> +#include <linux/mfd/smsc.h>
>> +#include <linux/err.h>
>> +
>> +struct smsc_gpio {
>> +     struct device *dev;
>> +     struct smsc *smsc;
>> +     struct gpio_chip gpio_chip;
>> +     struct mutex lock;      /* protect cached dir, dat_out */
>> +     /* protect serialized access to the interrupt controller bus */
>> +     struct mutex irq_lock;
>> +     unsigned gpio_start;
>> +     int type;
>> +     int flags;
>> +     int irq;
>> +     int irq_base;
>> +     unsigned int gpio_base;
>> +     unsigned int dat_out[5];
>> +     unsigned int dir[5];
>> +     unsigned int int_lvl[5];
>> +     unsigned int int_en[5];
>> +     unsigned int irq_mask[5];
>> +     unsigned int irq_stat[5];
>> +};
>> +
>> +static int smsc_gpio_get_value(struct gpio_chip *chip, unsigned off)
>> +{
>> +     struct smsc_gpio *sg =
>> +             container_of(chip, struct smsc_gpio, gpio_chip);
>> +     unsigned int get;
>> +     return !!(smsc_read(sg->dev,
>> +             (SMSC_GPIO_DATA_IN_START + SMSC_BANK(off)) & SMSC_BIT(off),
>> +                                     &get));
>> +}
>> +
>> +static void smsc_gpio_set_value(struct gpio_chip *chip,
>> +                     unsigned off, int val)
>> +{
>> +     unsigned bank, bit;
>> +     struct smsc_gpio *sg =
>> +             container_of(chip, struct smsc_gpio, gpio_chip);
>> +
>> +     bank = SMSC_BANK(off);
>> +     bit = SMSC_BIT(off);
>> +
>> +     mutex_lock(&sg->lock);
>> +     if (val)
>> +             sg->dat_out[bank] |= bit;
>> +     else
>> +             sg->dat_out[bank] &= ~bit;
>> +
>> +     smsc_write(sg->dev, SMSC_GPIO_DATA_OUT_START + bank,
>> +                        sg->dat_out[bank]);
>> +     mutex_unlock(&sg->lock);
>> +}
>> +
>> +static int smsc_gpio_direction_input(struct gpio_chip *chip, unsigned off)
>> +{
>> +     unsigned int reg;
>> +     struct smsc_gpio *sg =
>> +         container_of(chip, struct smsc_gpio, gpio_chip);
>> +     int reg_dir;
>> +
>> +     mutex_lock(&sg->lock);
>> +     reg_dir = SMSC_CFG_START + off;
>> +     smsc_read(sg->dev, reg_dir, &reg);
>> +     reg |= SMSC_GPIO_INPUT_LOW;
>> +     mutex_unlock(&sg->lock);
>> +
>> +     return smsc_write(sg->dev, reg_dir, reg);
>> +}
>> +
>> +static int smsc_gpio_direction_output(struct gpio_chip *chip,
>> +                                      unsigned off, int val)
>> +{
>> +     unsigned int reg;
>> +     struct smsc_gpio *sg =
>> +         container_of(chip, struct smsc_gpio, gpio_chip);
>> +     int reg_dir;
>> +
>> +     mutex_lock(&sg->lock);
>> +     reg_dir = SMSC_CFG_START + off;
>> +     smsc_read(sg->dev, reg_dir, &reg);
>> +     reg |= SMSC_GPIO_OUTPUT_PP;
>> +     mutex_unlock(&sg->lock);
>> +
>> +     return smsc_write(sg->dev, reg_dir, reg);
>> +}
>> +
>> +static int smsc_gpio_to_irq(struct gpio_chip *chip, unsigned off)
>> +{
>> +     struct smsc_gpio *sg =
>> +             container_of(chip, struct smsc_gpio, gpio_chip);
>> +     return sg->irq_base + off;
>> +}
>> +
>> +static void smsc_irq_bus_lock(struct irq_data *d)
>> +{
>> +     struct smsc_gpio *sg = irq_data_get_irq_chip_data(d);
>> +
>> +     mutex_lock(&sg->irq_lock);
>> +}
>> +
>> +static void smsc_irq_bus_sync_unlock(struct irq_data *d)
>> +{
>> +     struct smsc_gpio *sg = irq_data_get_irq_chip_data(d);
>> +     int i;
>> +
>> +     for (i = 0; i < SMSC_BANK(SMSC_MAXGPIO); i++)
>> +             if (sg->int_en[i] ^ sg->irq_mask[i]) {
>> +                     sg->int_en[i] = sg->irq_mask[i];
>> +                     smsc_write(sg->dev, SMSC_GPIO_INT_MASK_START + i,
>> +                                        sg->int_en[i]);
>> +             }
>> +
>> +     mutex_unlock(&sg->irq_lock);
>> +}
>> +
>> +static void smsc_irq_mask(struct irq_data *d)
>> +{
>> +     struct smsc_gpio *sg = irq_data_get_irq_chip_data(d);
>> +     unsigned gpio = d->irq - sg->irq_base;
>> +
>> +     sg->irq_mask[SMSC_BANK(gpio)] &= ~SMSC_BIT(gpio);
>> +}
>> +
>> +static void smsc_irq_unmask(struct irq_data *d)
>> +{
>> +     struct smsc_gpio *sg = irq_data_get_irq_chip_data(d);
>> +     unsigned gpio = d->irq - sg->irq_base;
>> +
>> +     sg->irq_mask[SMSC_BANK(gpio)] |= SMSC_BIT(gpio);
>> +}
>> +
>> +static int smsc_irq_set_type(struct irq_data *d, unsigned int type)
>> +{
>> +     struct smsc_gpio *sg = irq_data_get_irq_chip_data(d);
>> +     uint16_t gpio = d->irq - sg->irq_base;
>> +     unsigned bank, bit;
>> +
>> +     if ((type & IRQ_TYPE_EDGE_BOTH)) {
>> +             dev_err(sg->dev, "irq %d: unsupported type %d\n",
>> +                     d->irq, type);
>> +             return -EINVAL;
>> +     }
>> +
>> +     bank = SMSC_BANK(gpio);
>> +     bit = SMSC_BIT(gpio);
>> +
>> +     if (type & IRQ_TYPE_LEVEL_HIGH)
>> +             sg->int_lvl[bank] |= bit;
>> +     else if (type & IRQ_TYPE_LEVEL_LOW)
>> +             sg->int_lvl[bank] &= ~bit;
>> +     else
>> +             return -EINVAL;
>
> this looks wrong. You could have a user who wants to trigger on both
> HIGH and LOW levels, no ?
>
Yes, I think there can be a scenario where gpio_keys are attached
to this driver and signals a "key press" at low and "key release" at
high. ?
 Will figure out a way to add support to check for case where
both High and low levels are used.
>> +     smsc_gpio_direction_input(&sg->gpio_chip, gpio);
>> +     smsc_write(sg->dev, SMSC_CFG_START + gpio,
>> +                     sg->int_lvl[bank]);
>> +
>> +     return 0;
>> +}
>> +
>> +static struct irq_chip smsc_irq_chip = {
>> +     .name                   = "smsc",
>> +     .irq_mask               = smsc_irq_mask,
>> +     .irq_unmask             = smsc_irq_unmask,
>> +     .irq_bus_lock           = smsc_irq_bus_lock,
>> +     .irq_bus_sync_unlock    = smsc_irq_bus_sync_unlock,
>> +     .irq_set_type           = smsc_irq_set_type,
>> +};
>> +
>> +static int smsc_gpio_read_intstat(struct smsc_gpio *sg,
>> +                             unsigned int *buf, int i)
>> +{
>> +     int ret = smsc_read(sg->dev,
>> +                     SMSC_GPIO_INT_STAT_START + i, buf);
>> +
>> +     if (ret < 0)
>> +             dev_err(sg->dev, "Read INT_STAT Error\n");
>> +
>> +     return ret;
>> +}
>> +
>> +static irqreturn_t smsc_irq_handler(int irq, void *devid)
>> +{
>> +     struct smsc_gpio *sg = devid;
>> +     unsigned int status, bank, pending;
>> +     int ret;
>> +     smsc_read(sg->dev, GRP_INT_STAT, &status);
>> +
>> +     if (!(status & SMSC_GPI_INT))
>> +             goto out;
>> +
>> +     for (bank = 0; bank <= SMSC_BANK(SMSC_MAXGPIO);
>> +             bank++) {
>> +             pending = sg->irq_stat[bank] & sg->irq_mask[bank];
>> +             ret = smsc_gpio_read_intstat(sg,
>> +                             &sg->irq_stat[bank], bank);
>> +             if (ret < 0)
>> +                     memset(&sg->irq_stat[bank], 0,
>> +                             ARRAY_SIZE(sg->irq_stat));
>> +
>> +             while (pending) {
>> +                     unsigned long   bit = __ffs(pending);
>> +                     unsigned int    irq;
>> +
>> +                     pending &= ~BIT(bit);
>> +                     irq = bit + sg->irq_base;
>> +                     handle_nested_irq(irq);
>> +             }
>> +     }
>> +
>> +out:
>> +     smsc_write(sg->dev, GRP_INT_STAT, status); /* Status is W1C */
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +static int smsc_irq_setup(struct smsc_gpio *sg)
>> +{
>> +     unsigned gpio;
>> +     int ret;
>> +
>> +     mutex_init(&sg->irq_lock);
>> +
>> +     for (gpio = 0; gpio < sg->gpio_chip.ngpio; gpio++) {
>> +             int irq = gpio + sg->irq_base;
>> +             irq_set_chip_data(irq, sg);
>> +             irq_set_chip_and_handler(irq, &smsc_irq_chip,
>> +                             handle_level_irq);
>> +             irq_set_nested_thread(irq, 1);
>> +#ifdef CONFIG_ARM
>> +             set_irq_flags(irq, IRQF_VALID);
>> +#else
>> +             irq_set_noprobe(irq);
>> +#endif
>> +     }
>> +
>> +     ret = request_threaded_irq(sg->irq, NULL,
>> +                     smsc_irq_handler, sg->flags,
>> +                     "smsc_gpio", sg);
>
> would be nice to stick to devm_request_threaded_irq() like on the other
> patch.
>
Yes, will change.
>> +     if (ret) {
>> +             dev_err(sg->dev, "failed to request irq %d\n",
>> +                     sg->irq);
>> +     }
>> +
>> +     sg->gpio_chip.to_irq = smsc_gpio_to_irq;
>> +
>> +     return 0;
>> +}
>> +
>> +static int __devinit smsc_gpio_probe(struct platform_device *pdev)
>> +{
>> +     struct smsc_gpio *sg;
>> +     struct gpio_chip *gc;
>> +     struct smsc *smsc = dev_get_drvdata(pdev->dev.parent);
>> +     int ret, i, temp;
>> +     struct device *dev = &pdev->dev;
>> +     struct device_node *np = dev->of_node;
>> +     int irq_base;
>> +
>> +     sg = devm_kzalloc(dev, sizeof(*sg), GFP_KERNEL);
>> +     if (sg == NULL) {
>> +             dev_err(&pdev->dev, "failed to alloc memory\n");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     sg->irq = platform_get_irq(pdev, 0);
>> +     if (np) {
>> +             of_property_read_u32(np, "gpio,base", &temp);
>> +             of_property_read_u32(np, "flags", &sg->flags);
>> +     }
>> +
>> +     gc = &sg->gpio_chip;
>> +     gc->direction_input = smsc_gpio_direction_input;
>> +     gc->direction_output = smsc_gpio_direction_output;
>> +     gc->get = smsc_gpio_get_value;
>> +     gc->set = smsc_gpio_set_value;
>> +     gc->can_sleep = 1;
>> +
>> +     gc->base = temp;
>> +     gc->ngpio = SMSC_MAXGPIO;
>> +     gc->owner = THIS_MODULE;
>> +
>> +     sg->smsc = smsc;
>> +     sg->dev = dev;
>> +     mutex_init(&sg->lock);
>> +
>> +     for (i = 0; i <= SMSC_BANK(SMSC_MAXGPIO); i++)
>> +             smsc_read(sg->dev, SMSC_GPIO_DATA_OUT_START + i,
>> +                                     &sg->dat_out[i]);
>> +
>> +     for (i = 0; i < SMSC_MAXGPIO; i++)
>> +             smsc_read(sg->dev, SMSC_CFG_START + i, &sg->dir[i]);
>> +
>> +     irq_base = irq_alloc_descs(-1, 0, sg->gpio_chip.ngpio, 0);
>> +     if (IS_ERR_VALUE(irq_base)) {
>> +             dev_err(sg->dev, "Fail to allocate IRQ descs\n");
>> +             return irq_base;
>> +     }
>> +     sg->irq_base = irq_base;
>> +
>> +     irq_domain_add_legacy(pdev->dev.of_node, sg->gpio_chip.ngpio,
>> +             sg->irq_base, 0, &irq_domain_simple_ops, NULL);
>> +
>> +     ret = smsc_irq_setup(sg);
>> +     if (ret)
>> +             goto err;
>> +
>> +     ret = gpiochip_add(&sg->gpio_chip);
>> +     if (ret)
>> +             goto err;
>> +
>> +     return 0;
>> +
>> +err:
>> +     kfree(sg);
>
> using devm_kzalloc(), not needed to free.
>
True, will change.
>> +
>> +     return ret;
>> +}
>> +
>> +static int __devexit smsc_gpio_remove(struct platform_device *pdev)
>> +{
>> +     struct smsc_gpio *sg = dev_get_drvdata(&pdev->dev);
>> +     int ret;
>> +
>> +     ret = gpiochip_remove(&sg->gpio_chip);
>> +     if (ret) {
>> +             dev_err(&pdev->dev, "gpiochip_remove failed %d\n", ret);
>> +             return ret;
>> +     }
>
> this will leak the irq (please move to devm_request_threaded_irq).
>
> It's also leaking irq_descs and irq_domain, you need to free those
> resources by calling irq_domain_remove and irq_free_descs.
>
Ok. will add the above apis in the next version.
> --
> balbi
