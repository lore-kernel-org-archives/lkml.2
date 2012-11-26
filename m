Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab2KZPhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 10:37:39 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:52568 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab2KZPhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 10:37:37 -0500
MIME-Version: 1.0
In-Reply-To: <1351792722-15250-1-git-send-email-pawel.moll@arm.com>
References: <1351792722-15250-1-git-send-email-pawel.moll@arm.com>
From: Vasily Khoruzhick <anarsoul@gmail.com>
Date: Mon, 26 Nov 2012 18:37:15 +0300
Message-ID: <CA+E=qVcjKz-3CAKrDVG+ymij5HAB5H=a9+4G0KOR0tTKLGJu4w@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds: Add generic support for memory mapped LEDs
To: Pawel Moll <pawel.moll@arm.com>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 8:58 PM, Pawel Moll <pawel.moll@arm.com> wrote:
> LEDs are often controlled by writing to memory mapped
> register. This patch adds:
>
> 1. Generic functions for platform code and drivers to create
>    class device for LEDs controlled by arbitrary bit masks.
>    The control register value is read, modified by logic AND
>    and OR operations with respective mask and written back.
>
> 2. A platform driver for simple use case when one or more LED
>    are controlled by consecutive bits in a register pointed
>    at by the platform device's memory resource. It can be
>    particularly useful for MFD cells being part of an other
>    device.

Hi

This MMIO controls some latch (or whatever) which is actually GPIO.
So implementing generic GPIO MMIO driver and using leds-gpio on top of
it appears to be a better solution for me.

Regards
Vasily

> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
>  drivers/leds/Kconfig     |    8 ++
>  drivers/leds/Makefile    |    1 +
>  drivers/leds/leds-mmio.c |  250 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/leds.h     |   38 +++++++
>  4 files changed, 297 insertions(+)
>  create mode 100644 drivers/leds/leds-mmio.c
>
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index f508def..93707e6 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -457,6 +457,14 @@ config LEDS_BLINKM
>           This option enables support for the BlinkM RGB LED connected
>           through I2C. Say Y to enable support for the BlinkM LED.
>
> +config LEDS_MMIO
> +       tristate "Generic LED support for memory mapped peripherals"
> +       depends on LEDS_CLASS
> +       depends on HAS_IOMEM
> +       help
> +         This option enables generic support for LEDs controlled via
> +         memory mapped registers.
> +
>  config LEDS_TRIGGERS
>         bool "LED Trigger support"
>         depends on LEDS_CLASS
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index 3fb9641..8e5d0c8 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -51,6 +51,7 @@ obj-$(CONFIG_LEDS_RENESAS_TPU)                += leds-renesas-tpu.o
>  obj-$(CONFIG_LEDS_MAX8997)             += leds-max8997.o
>  obj-$(CONFIG_LEDS_LM355x)              += leds-lm355x.o
>  obj-$(CONFIG_LEDS_BLINKM)              += leds-blinkm.o
> +obj-$(CONFIG_LEDS_MMIO)                        += leds-mmio.o
>
>  # LED SPI Drivers
>  obj-$(CONFIG_LEDS_DAC124S085)          += leds-dac124s085.o
> diff --git a/drivers/leds/leds-mmio.c b/drivers/leds/leds-mmio.c
> new file mode 100644
> index 0000000..1ef0cda
> --- /dev/null
> +++ b/drivers/leds/leds-mmio.c
> @@ -0,0 +1,250 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * Copyright (C) 2012 ARM Limited
> + */
> +
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/leds.h>
> +#include <linux/mfd/core.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +
> +
> +static u32 mmio_led_read(void __iomem *reg, unsigned reg_size)
> +{
> +       switch (reg_size) {
> +       case 32:
> +               return readl(reg);
> +       case 16:
> +               return readw(reg);
> +       case 8:
> +               return readb(reg);
> +       }
> +       return 0;
> +}
> +
> +static void mmio_led_write(void __iomem *reg, unsigned reg_size, u32 val)
> +{
> +       switch (reg_size) {
> +       case 32:
> +               writel(val, reg);
> +               return;
> +       case 16:
> +               writew(val, reg);
> +               return;
> +       case 8:
> +               writeb(val, reg);
> +               return;
> +       }
> +}
> +
> +
> +struct mmio_led {
> +       struct led_classdev cdev;
> +       spinlock_t *lock;
> +       void __iomem *reg;
> +       unsigned reg_size;
> +       u32 off_and_mask, off_or_mask;
> +       u32 on_and_mask, on_or_mask;
> +};
> +
> +static void mmio_led_brightness_set(struct led_classdev *cdev,
> +               enum led_brightness brightness)
> +{
> +       struct mmio_led *led = container_of(cdev, struct mmio_led, cdev);
> +       unsigned long uninitialized_var(flags);
> +       u32 val;
> +
> +       if (led->lock)
> +               spin_lock_irqsave(led->lock, flags);
> +
> +       val = mmio_led_read(led->reg, led->reg_size);
> +       if (brightness == LED_OFF) {
> +               val &= led->off_and_mask;
> +               val |= led->off_or_mask;
> +       } else {
> +               val &= led->on_and_mask;
> +               val |= led->on_or_mask;
> +       }
> +       mmio_led_write(led->reg, led->reg_size, val);
> +
> +       if (led->lock)
> +               spin_unlock_irqrestore(led->lock, flags);
> +};
> +
> +static enum led_brightness mmio_led_brightness_get(struct led_classdev *cdev)
> +{
> +       struct mmio_led *led = container_of(cdev, struct mmio_led, cdev);
> +       unsigned long uninitialized_var(flags);
> +       u32 val;
> +
> +       if (led->lock)
> +               spin_lock_irqsave(led->lock, flags);
> +       val = mmio_led_read(led->reg, led->reg_size);
> +       if (led->lock)
> +               spin_unlock_irqrestore(led->lock, flags);
> +
> +       if (((val & led->on_and_mask) | led->on_or_mask) == val)
> +               return LED_FULL;
> +       else
> +               return LED_OFF;
> +}
> +
> +struct mmio_led *mmio_led_register(struct device *parent, spinlock_t *lock,
> +               const char *name, const char *default_trigger,
> +               void __iomem *reg, unsigned reg_size, u32 off_and_mask,
> +               u32 off_or_mask, u32 on_and_mask, u32 on_or_mask)
> +{
> +       struct mmio_led *led;
> +       int err;
> +
> +       if (WARN_ON(reg_size != 8 && reg_size != 16 && reg_size != 32))
> +               return ERR_PTR(-EINVAL);
> +
> +       led = kzalloc(sizeof(*led), GFP_KERNEL);
> +       if (!led)
> +               return ERR_PTR(-ENOMEM);
> +
> +       led->cdev.brightness_set = mmio_led_brightness_set;
> +       led->cdev.brightness_get = mmio_led_brightness_get;
> +       led->cdev.name = name;
> +       led->cdev.default_trigger = default_trigger;
> +
> +       led->lock = lock;
> +       led->reg = reg;
> +       led->reg_size = reg_size;
> +       led->off_and_mask = off_and_mask;
> +       led->off_or_mask = off_or_mask;
> +       led->on_and_mask = on_and_mask;
> +       led->on_or_mask = on_or_mask;
> +
> +       err = led_classdev_register(parent, &led->cdev);
> +       if (err) {
> +               kfree(led);
> +               return ERR_PTR(err);
> +       }
> +
> +       return led;
> +}
> +EXPORT_SYMBOL_GPL(mmio_led_register);
> +
> +void mmio_led_unregister(struct mmio_led *led)
> +{
> +       led_classdev_unregister(&led->cdev);
> +       kfree(led);
> +}
> +EXPORT_SYMBOL_GPL(mmio_led_unregister);
> +
> +
> +struct mmio_simple_leds {
> +       spinlock_t lock;
> +       int num_leds;
> +       struct mmio_led *leds[0];
> +};
> +
> +static int __devinit mmio_simple_leds_probe(struct platform_device *pdev)
> +{
> +       struct mmio_simple_leds_platform_data *pdata = pdev->dev.platform_data;
> +       struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       struct mmio_simple_leds *leds;
> +       void __iomem *reg;
> +       u32 val, mask;
> +       int i;
> +
> +       if (!pdata)
> +               return -EINVAL;
> +
> +       if (pdata->reg_size != 8 && pdata->reg_size != 16 &&
> +                       pdata->reg_size != 32)
> +               return -EFAULT;
> +
> +       leds = devm_kzalloc(&pdev->dev, sizeof(*leds) +
> +                       sizeof(leds->leds) * pdata->width, GFP_KERNEL);
> +       if (!leds)
> +               return -ENOMEM;
> +       spin_lock_init(&leds->lock);
> +
> +       if ((!pdev->mfd_cell || !pdev->mfd_cell->ignore_resource_conflicts) &&
> +                       !devm_request_mem_region(&pdev->dev, res->start,
> +                       resource_size(res), pdev->name))
> +               return -EBUSY;
> +
> +       reg = devm_ioremap(&pdev->dev, res->start, resource_size(res));
> +       if (!reg)
> +               return -ENOMEM;
> +
> +       val = mmio_led_read(reg, pdata->reg_size);
> +       mask = ((1 << pdata->width) - 1) << pdata->shift;
> +       if ((pdata->init_full && pdata->active_low) ||
> +                       (pdata->init_off && !pdata->active_low))
> +               val &= ~mask;
> +       else if ((pdata->init_off && pdata->active_low) ||
> +                       (pdata->init_full && !pdata->active_low))
> +               val |= mask;
> +       mmio_led_write(reg, pdata->reg_size, val);
> +
> +       leds->num_leds = pdata->width;
> +       for (i = 0; i < leds->num_leds; i++) {
> +               unsigned shift = pdata->shift + i;
> +               u32 and_mask = ~BIT(shift);
> +               u32 off_or_mask = pdata->active_low ? BIT(shift) : 0;
> +               u32 on_or_mask = pdata->active_low ? 0 : BIT(shift);
> +               struct mmio_led *led = mmio_led_register(&pdev->dev,
> +                               &leds->lock, pdata->names[i],
> +                               pdata->default_triggers ?
> +                               pdata->default_triggers[i] : NULL,
> +                               reg, pdata->reg_size, and_mask, off_or_mask,
> +                               and_mask, on_or_mask);
> +
> +               if (IS_ERR(led)) {
> +                       while (--i >= 0)
> +                               mmio_led_unregister(leds->leds[i]);
> +                       return PTR_ERR(led);
> +               }
> +               leds->leds[i] = led;
> +       }
> +
> +       platform_set_drvdata(pdev, leds);
> +
> +       return 0;
> +}
> +
> +static int __devexit mmio_simple_leds_remove(struct platform_device *pdev)
> +{
> +       struct mmio_simple_leds *leds = platform_get_drvdata(pdev);
> +       int i;
> +
> +       platform_set_drvdata(pdev, NULL);
> +
> +       for (i = 0; i < leds->num_leds; i++)
> +               mmio_led_unregister(leds->leds[i]);
> +
> +       return 0;
> +}
> +
> +static struct platform_driver mmio_simple_leds_driver = {
> +       .probe          = mmio_simple_leds_probe,
> +       .remove         = __devexit_p(mmio_simple_leds_remove),
> +       .driver         = {
> +               .name   = "leds-mmio-simple",
> +               .owner  = THIS_MODULE,
> +       },
> +};
> +
> +module_platform_driver(mmio_simple_leds_driver);
> +
> +MODULE_AUTHOR("Pawel Moll <pawel.moll@arm.com>");
> +MODULE_DESCRIPTION("MMIO LED driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:leds-mmio-simple");
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 6e53bb3..a6338b0 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -241,6 +241,44 @@ struct gpio_led_platform_data {
>  struct platform_device *gpio_led_register_device(
>                 int id, const struct gpio_led_platform_data *pdata);
>
> +/* For the leds-mmio driver */
> +
> +struct mmio_led;
> +
> +#if defined(CONFIG_LEDS_MMIO)
> +/* Returns ERR_PTR in case of error */
> +struct mmio_led *mmio_led_register(struct device *parent, spinlock_t *lock,
> +               const char *name, const char *default_trigger,
> +               void __iomem *reg, unsigned reg_size, u32 off_and_mask,
> +               u32 off_or_mask, u32 on_and_mask, u32 on_or_mask);
> +void mmio_led_unregister(struct mmio_led *led);
> +#else
> +struct mmio_led *mmio_led_register(struct device *parent, spinlock_t *lock,
> +               const char *name, const char *default_trigger,
> +               void __iomem *reg, unsigned reg_size, u32 off_and_mask,
> +               u32 off_or_mask, u32 on_and_mask, u32 on_or_mask)
> +{
> +       return NULL;
> +}
> +
> +void mmio_led_unregister(struct mmio_led *led)
> +{
> +}
> +#endif
> +
> +struct mmio_simple_leds_platform_data {
> +       unsigned reg_size; /* Register size (8/16/32) */
> +       unsigned shift; /* First bit controlling LEDs */
> +       unsigned width; /* Number of consecutive bits */
> +       const char **names; /* Must define 'width' names */
> +       const char **default_triggers; /* NULL or 'width' strings */
> +       bool active_low;
> +       bool init_full;
> +       bool init_off;
> +};
> +
> +/* CPU led trigger */
> +
>  enum cpu_led_event {
>         CPU_LED_IDLE_START,     /* CPU enters idle */
>         CPU_LED_IDLE_END,       /* CPU idle ends */
> --
> 1.7.10.4
>
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
