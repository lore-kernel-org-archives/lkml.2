Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab1ESLMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:12:01 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:54858 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab1ESLL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:11:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=o2Iq3F5DYxaqWkE0uxnAR5kBw6+MaHF/fgFQSJJO94Ha9nOylMJ+190FI/O9u9GAzM
         K0mVOOZ7R0YFs8WoQVVJ0tJ3592/hymWL2IroM1H1tifJfzBclTnEpmzg7QM8aulzf6S
         bhCoNxTsM6w451FGYyI/y92TndTtbfWQF5rHI=
MIME-Version: 1.0
In-Reply-To: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 19 May 2011 19:11:37 +0800
Message-ID: <BANLkTi=poU17RqAzp28CPjWHrN_+aFiyag@mail.gmail.com>
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to drivers/gpio
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4JBCVVd009273

2011/4/27 Linus Walleij <linus.walleij@stericsson.com>:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> This rewrites the U300 GPIO driver using gpiolib and the irq_chip
> abstractions, makes it runtime-configured rather than compile-time,
> and moves it to the drivers/gpio subsystem where it belongs,
> depopulating the ARM tree of one more driver.
>
> Cc: Jonas Aaberg <jonas.aberg@stericsson.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  arch/arm/Kconfig                       |    2 +-
>  arch/arm/mach-u300/Kconfig             |    1 +
>  arch/arm/mach-u300/Makefile            |    6 +-
>  arch/arm/mach-u300/core.c              |   31 ++-
>  arch/arm/mach-u300/gpio.c              |  700 --------------------------
>  arch/arm/mach-u300/include/mach/gpio.h |  163 +------
>  arch/arm/mach-u300/include/mach/irqs.h |   25 +-
>  drivers/gpio/Kconfig                   |    9 +
>  drivers/gpio/Makefile                  |    1 +
>  drivers/gpio/u300-gpio.c               |  836 ++++++++++++++++++++++++++++++++
>  include/linux/gpio/u300.h              |   32 ++
>  11 files changed, 932 insertions(+), 874 deletions(-)
>  delete mode 100644 arch/arm/mach-u300/gpio.c
>  create mode 100644 drivers/gpio/u300-gpio.c
>  create mode 100644 include/linux/gpio/u300.h
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 377a7a5..5fb980d 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -820,7 +820,7 @@ config ARCH_U300
>        select ARM_VIC
>        select GENERIC_CLOCKEVENTS
>        select CLKDEV_LOOKUP
> -       select GENERIC_GPIO
> +       select ARCH_REQUIRE_GPIOLIB
>        help
>          Support for ST-Ericsson U300 series mobile platforms.
>
> diff --git a/arch/arm/mach-u300/Kconfig b/arch/arm/mach-u300/Kconfig
> index 32a7b0f..7b5c229 100644
> --- a/arch/arm/mach-u300/Kconfig
> +++ b/arch/arm/mach-u300/Kconfig
> @@ -6,6 +6,7 @@ comment "ST-Ericsson Mobile Platform Products"
>
>  config MACH_U300
>        bool "U300"
> +       select GPIO_U300
>
>  comment "ST-Ericsson U300/U330/U335/U365 Feature Selections"
>
> diff --git a/arch/arm/mach-u300/Makefile b/arch/arm/mach-u300/Makefile
> index fab46fe..73da230 100644
> --- a/arch/arm/mach-u300/Makefile
> +++ b/arch/arm/mach-u300/Makefile
> @@ -2,11 +2,7 @@
>  # Makefile for the linux kernel, U300 machine.
>  #
>
> -obj-y          := core.o clock.o timer.o gpio.o padmux.o
> -obj-m          :=
> -obj-n          :=
> -obj-           :=
> -
> +obj-y                          := core.o clock.o timer.o padmux.o
>  obj-$(CONFIG_ARCH_U300)                  += u300.o
>  obj-$(CONFIG_MMC)                 += mmc.o
>  obj-$(CONFIG_SPI_PL022)           += spi.o
> diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
> index 513d6ab..ddb604c 100644
> --- a/arch/arm/mach-u300/core.c
> +++ b/arch/arm/mach-u300/core.c
> @@ -25,6 +25,7 @@
>  #include <linux/err.h>
>  #include <linux/mtd/nand.h>
>  #include <linux/mtd/fsmc.h>
> +#include <linux/gpio/u300.h>
>
>  #include <asm/types.h>
>  #include <asm/setup.h>
> @@ -239,7 +240,7 @@ static struct resource gpio_resources[] = {
>                .end   = IRQ_U300_GPIO_PORT2,
>                .flags = IORESOURCE_IRQ,
>        },
> -#ifdef U300_COH901571_3
> +#if defined(CONFIG_MACH_U300_BS365) || defined(CONFIG_MACH_U300_BS335)
>        {
>                .name  = "gpio3",
>                .start = IRQ_U300_GPIO_PORT3,
> @@ -252,6 +253,7 @@ static struct resource gpio_resources[] = {
>                .end   = IRQ_U300_GPIO_PORT4,
>                .flags = IORESOURCE_IRQ,
>        },
> +#endif
>  #ifdef CONFIG_MACH_U300_BS335
>        {
>                .name  = "gpio5",
> @@ -266,7 +268,6 @@ static struct resource gpio_resources[] = {
>                .flags = IORESOURCE_IRQ,
>        },
>  #endif /* CONFIG_MACH_U300_BS335 */
> -#endif /* U300_COH901571_3 */
>  };
>
>  static struct resource keypad_resources[] = {
> @@ -1556,11 +1557,35 @@ static struct platform_device i2c1_device = {
>        .resource = i2c1_resources,
>  };
>
> +/*
> + * The different variants have a few different versions of the
> + * GPIO block, with different number of ports.
> + */
> +static struct u300_gpio_platform u300_gpio_plat = {
> +#if defined(CONFIG_MACH_U300_BS2X) || defined(CONFIG_MACH_U300_BS330)
> +       .variant = U300_GPIO_COH901335,
> +       .ports = 3,
> +#endif
> +#ifdef CONFIG_MACH_U300_BS335
> +       .variant = U300_GPIO_COH901571_3_BS335,
> +       .ports = 7,
> +#endif
> +#ifdef CONFIG_MACH_U300_BS365
> +       .variant = U300_GPIO_COH901571_3_BS365,
> +       .ports = 5,
> +#endif
> +       .gpio_base = 0,
> +       .gpio_irq_base = IRQ_U300_GPIO_BASE,
> +};
> +
>  static struct platform_device gpio_device = {
>        .name = "u300-gpio",
>        .id = -1,
>        .num_resources = ARRAY_SIZE(gpio_resources),
>        .resource = gpio_resources,
> +       .dev = {
> +               .platform_data = &u300_gpio_plat,
> +       },
>  };
>
>  static struct platform_device keypad_device = {
> @@ -1666,7 +1691,7 @@ void __init u300_init_irq(void)
>        BUG_ON(IS_ERR(clk));
>        clk_enable(clk);
>
> -       for (i = 0; i < NR_IRQS; i++)
> +       for (i = 0; i < U300_VIC_IRQS_END; i++)
>                set_bit(i, (unsigned long *) &mask[0]);
>        vic_init((void __iomem *) U300_INTCON0_VBASE, 0, mask[0], mask[0]);
>        vic_init((void __iomem *) U300_INTCON1_VBASE, 32, mask[1], mask[1]);
> diff --git a/arch/arm/mach-u300/gpio.c b/arch/arm/mach-u300/gpio.c
> deleted file mode 100644
> index d927901..0000000
> --- a/arch/arm/mach-u300/gpio.c
> +++ /dev/null
> @@ -1,700 +0,0 @@
> -/*
> - *
> - * arch/arm/mach-u300/gpio.c
> - *
> - *
> - * Copyright (C) 2007-2009 ST-Ericsson AB
> - * License terms: GNU General Public License (GPL) version 2
> - * U300 GPIO module.
> - * This can driver either of the two basic GPIO cores
> - * available in the U300 platforms:
> - * COH 901 335   - Used in DB3150 (U300 1.0) and DB3200 (U330 1.0)
> - * COH 901 571/3 - Used in DB3210 (U365 2.0) and DB3350 (U335 1.0)
> - * Notice that you also have inline macros in <asm-arch/gpio.h>
> - * Author: Linus Walleij <linus.walleij@stericsson.com>
> - * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
> - *
> - */
> -#include <linux/module.h>
> -#include <linux/interrupt.h>
> -#include <linux/delay.h>
> -#include <linux/errno.h>
> -#include <linux/io.h>
> -#include <linux/clk.h>
> -#include <linux/err.h>
> -#include <linux/platform_device.h>
> -#include <linux/gpio.h>
> -
> -/* Reference to GPIO block clock */
> -static struct clk *clk;
> -
> -/* Memory resource */
> -static struct resource *memres;
> -static void __iomem *virtbase;
> -static struct device *gpiodev;
> -
> -struct u300_gpio_port {
> -       const char *name;
> -       int irq;
> -       int number;
> -};
> -
> -
> -static struct u300_gpio_port gpio_ports[] = {
> -       {
> -               .name = "gpio0",
> -               .number = 0,
> -       },
> -       {
> -               .name = "gpio1",
> -               .number = 1,
> -       },
> -       {
> -               .name = "gpio2",
> -               .number = 2,
> -       },
> -#ifdef U300_COH901571_3
> -       {
> -               .name = "gpio3",
> -               .number = 3,
> -       },
> -       {
> -               .name = "gpio4",
> -               .number = 4,
> -       },
> -#ifdef CONFIG_MACH_U300_BS335
> -       {
> -               .name = "gpio5",
> -               .number = 5,
> -       },
> -       {
> -               .name = "gpio6",
> -               .number = 6,
> -       },
> -#endif
> -#endif
> -
> -};
> -
> -
> -#ifdef U300_COH901571_3
> -
> -/* Default input value */
> -#define DEFAULT_OUTPUT_LOW   0
> -#define DEFAULT_OUTPUT_HIGH  1
> -
> -/* GPIO Pull-Up status */
> -#define DISABLE_PULL_UP  0
> -#define ENABLE_PULL_UP  1
> -
> -#define GPIO_NOT_USED 0
> -#define GPIO_IN       1
> -#define GPIO_OUT      2
> -
> -struct u300_gpio_configuration_data {
> -       unsigned char pin_usage;
> -       unsigned char default_output_value;
> -       unsigned char pull_up;
> -};
> -
> -/* Initial configuration */
> -const struct u300_gpio_configuration_data
> -u300_gpio_config[U300_GPIO_NUM_PORTS][U300_GPIO_PINS_PER_PORT] = {
> -#ifdef CONFIG_MACH_U300_BS335
> -       /* Port 0, pins 0-7 */
> -       {
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_HIGH,  DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP}
> -       },
> -       /* Port 1, pins 0-7 */
> -       {
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_HIGH,  DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP}
> -       },
> -       /* Port 2, pins 0-7 */
> -       {
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP}
> -       },
> -       /* Port 3, pins 0-7 */
> -       {
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP}
> -       },
> -       /* Port 4, pins 0-7 */
> -       {
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP}
> -       },
> -       /* Port 5, pins 0-7 */
> -       {
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP}
> -       },
> -       /* Port 6, pind 0-7 */
> -       {
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP}
> -       }
> -#endif
> -
> -#ifdef CONFIG_MACH_U300_BS365
> -       /* Port 0, pins 0-7 */
> -       {
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP}
> -       },
> -       /* Port 1, pins 0-7 */
> -       {
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_HIGH,  DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP}
> -       },
> -       /* Port 2, pins 0-7 */
> -       {
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP}
> -       },
> -       /* Port 3, pins 0-7 */
> -       {
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP}
> -       },
> -       /* Port 4, pins 0-7 */
> -       {
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               /* These 4 pins doesn't exist on DB3210 */
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
> -               {GPIO_OUT, DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP}
> -       }
> -#endif
> -};
> -#endif
> -
> -
> -/* No users == we can power down GPIO */
> -static int gpio_users;
> -
> -struct gpio_struct {
> -       int (*callback)(void *);
> -       void *data;
> -       int users;
> -};
> -
> -static struct gpio_struct gpio_pin[U300_GPIO_MAX];
> -
> -/*
> - * Let drivers register callback in order to get notified when there is
> - * an interrupt on the gpio pin
> - */
> -int gpio_register_callback(unsigned gpio, int (*func)(void *arg), void *data)
> -{
> -       if (gpio_pin[gpio].callback)
> -               dev_warn(gpiodev, "%s: WARNING: callback already "
> -                        "registered for gpio pin#%d\n", __func__, gpio);
> -       gpio_pin[gpio].callback = func;
> -       gpio_pin[gpio].data = data;
> -
> -       return 0;
> -}
> -EXPORT_SYMBOL(gpio_register_callback);
> -
> -int gpio_unregister_callback(unsigned gpio)
> -{
> -       if (!gpio_pin[gpio].callback)
> -               dev_warn(gpiodev, "%s: WARNING: callback already "
> -                        "unregistered for gpio pin#%d\n", __func__, gpio);
> -       gpio_pin[gpio].callback = NULL;
> -       gpio_pin[gpio].data = NULL;
> -
> -       return 0;
> -}
> -EXPORT_SYMBOL(gpio_unregister_callback);
> -
> -/* Non-zero means valid */
> -int gpio_is_valid(int number)
> -{
> -       if (number >= 0 &&
> -           number < (U300_GPIO_NUM_PORTS * U300_GPIO_PINS_PER_PORT))
> -               return 1;
> -       return 0;
> -}
> -EXPORT_SYMBOL(gpio_is_valid);
> -
> -int gpio_request(unsigned gpio, const char *label)
> -{
> -       if (gpio_pin[gpio].users)
> -               return -EINVAL;
> -       else
> -               gpio_pin[gpio].users++;
> -
> -       gpio_users++;
> -
> -       return 0;
> -}
> -EXPORT_SYMBOL(gpio_request);
> -
> -void gpio_free(unsigned gpio)
> -{
> -       gpio_users--;
> -       gpio_pin[gpio].users--;
> -       if (unlikely(gpio_pin[gpio].users < 0)) {
> -               dev_warn(gpiodev, "warning: gpio#%d release mismatch\n",
> -                        gpio);
> -               gpio_pin[gpio].users = 0;
> -       }
> -
> -       return;
> -}
> -EXPORT_SYMBOL(gpio_free);
> -
> -/* This returns zero or nonzero */
> -int gpio_get_value(unsigned gpio)
> -{
> -       return readl(virtbase + U300_GPIO_PXPDIR +
> -         PIN_TO_PORT(gpio) * U300_GPIO_PORTX_SPACING) & (1 << (gpio & 0x07));
> -}
> -EXPORT_SYMBOL(gpio_get_value);
> -
> -/*
> - * We hope that the compiler will optimize away the unused branch
> - * in case "value" is a constant
> - */
> -void gpio_set_value(unsigned gpio, int value)
> -{
> -       u32 val;
> -       unsigned long flags;
> -
> -       local_irq_save(flags);
> -       if (value) {
> -               /* set */
> -               val = readl(virtbase + U300_GPIO_PXPDOR +
> -                 PIN_TO_PORT(gpio) * U300_GPIO_PORTX_SPACING)
> -                 & (1 << (gpio & 0x07));
> -               writel(val | (1 << (gpio & 0x07)), virtbase +
> -                 U300_GPIO_PXPDOR +
> -                 PIN_TO_PORT(gpio) * U300_GPIO_PORTX_SPACING);
> -       } else {
> -               /* clear */
> -               val = readl(virtbase + U300_GPIO_PXPDOR +
> -                 PIN_TO_PORT(gpio) * U300_GPIO_PORTX_SPACING)
> -                 & (1 << (gpio & 0x07));
> -               writel(val & ~(1 << (gpio & 0x07)), virtbase +
> -                 U300_GPIO_PXPDOR +
> -                 PIN_TO_PORT(gpio) * U300_GPIO_PORTX_SPACING);
> -       }
> -       local_irq_restore(flags);
> -}
> -EXPORT_SYMBOL(gpio_set_value);
> -
> -int gpio_direction_input(unsigned gpio)
> -{
> -       unsigned long flags;
> -       u32 val;
> -
> -       if (gpio > U300_GPIO_MAX)
> -               return -EINVAL;
> -
> -       local_irq_save(flags);
> -       val = readl(virtbase + U300_GPIO_PXPCR + PIN_TO_PORT(gpio) *
> -                               U300_GPIO_PORTX_SPACING);
> -       /* Mask out this pin*/
> -       val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK << ((gpio & 0x07) << 1));
> -       /* This is not needed since it sets the bits to zero.*/
> -       /* val |= (U300_GPIO_PXPCR_PIN_MODE_INPUT << (gpio*2)); */
> -       writel(val, virtbase + U300_GPIO_PXPCR + PIN_TO_PORT(gpio) *
> -                               U300_GPIO_PORTX_SPACING);
> -       local_irq_restore(flags);
> -       return 0;
> -}
> -EXPORT_SYMBOL(gpio_direction_input);
> -
> -int gpio_direction_output(unsigned gpio, int value)
> -{
> -       unsigned long flags;
> -       u32 val;
> -
> -       if (gpio > U300_GPIO_MAX)
> -               return -EINVAL;
> -
> -       local_irq_save(flags);
> -       val = readl(virtbase + U300_GPIO_PXPCR + PIN_TO_PORT(gpio) *
> -                               U300_GPIO_PORTX_SPACING);
> -       /* Mask out this pin */
> -       val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK << ((gpio & 0x07) << 1));
> -       /*
> -        * FIXME: configure for push/pull, open drain or open source per pin
> -        * in setup. The current driver will only support push/pull.
> -        */
> -       val |= (U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL
> -                       << ((gpio & 0x07) << 1));
> -       writel(val, virtbase + U300_GPIO_PXPCR + PIN_TO_PORT(gpio) *
> -                               U300_GPIO_PORTX_SPACING);
> -       gpio_set_value(gpio, value);
> -       local_irq_restore(flags);
> -       return 0;
> -}
> -EXPORT_SYMBOL(gpio_direction_output);
> -
> -/*
> - * Enable an IRQ, edge is rising edge (!= 0) or falling edge (==0).
> - */
> -void enable_irq_on_gpio_pin(unsigned gpio, int edge)
> -{
> -       u32 val;
> -       unsigned long flags;
> -       local_irq_save(flags);
> -
> -       val = readl(virtbase + U300_GPIO_PXIEN + PIN_TO_PORT(gpio) *
> -                               U300_GPIO_PORTX_SPACING);
> -       val |= (1 << (gpio & 0x07));
> -       writel(val, virtbase + U300_GPIO_PXIEN + PIN_TO_PORT(gpio) *
> -                               U300_GPIO_PORTX_SPACING);
> -       val = readl(virtbase + U300_GPIO_PXICR + PIN_TO_PORT(gpio) *
> -                               U300_GPIO_PORTX_SPACING);
> -       if (edge)
> -               val |= (1 << (gpio & 0x07));
> -       else
> -               val &= ~(1 << (gpio & 0x07));
> -       writel(val, virtbase + U300_GPIO_PXICR + PIN_TO_PORT(gpio) *
> -                               U300_GPIO_PORTX_SPACING);
> -       local_irq_restore(flags);
> -}
> -EXPORT_SYMBOL(enable_irq_on_gpio_pin);
> -
> -void disable_irq_on_gpio_pin(unsigned gpio)
> -{
> -       u32 val;
> -       unsigned long flags;
> -
> -       local_irq_save(flags);
> -       val = readl(virtbase + U300_GPIO_PXIEN + PIN_TO_PORT(gpio) *
> -                               U300_GPIO_PORTX_SPACING);
> -       val &= ~(1 << (gpio & 0x07));
> -       writel(val, virtbase + U300_GPIO_PXIEN + PIN_TO_PORT(gpio) *
> -                               U300_GPIO_PORTX_SPACING);
> -       local_irq_restore(flags);
> -}
> -EXPORT_SYMBOL(disable_irq_on_gpio_pin);
> -
> -/* Enable (value == 0) or disable (value == 1) internal pullup */
> -void gpio_pullup(unsigned gpio, int value)
> -{
> -       u32 val;
> -       unsigned long flags;
> -
> -       local_irq_save(flags);
> -       if (value) {
> -               val = readl(virtbase + U300_GPIO_PXPER + PIN_TO_PORT(gpio) *
> -                                       U300_GPIO_PORTX_SPACING);
> -               writel(val | (1 << (gpio & 0x07)), virtbase + U300_GPIO_PXPER +
> -                               PIN_TO_PORT(gpio) * U300_GPIO_PORTX_SPACING);
> -       } else {
> -               val = readl(virtbase + U300_GPIO_PXPER + PIN_TO_PORT(gpio) *
> -                                       U300_GPIO_PORTX_SPACING);
> -               writel(val & ~(1 << (gpio & 0x07)), virtbase + U300_GPIO_PXPER +
> -                               PIN_TO_PORT(gpio) * U300_GPIO_PORTX_SPACING);
> -       }
> -       local_irq_restore(flags);
> -}
> -EXPORT_SYMBOL(gpio_pullup);
> -
> -static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
> -{
> -       struct u300_gpio_port *port = dev_id;
> -       u32 val;
> -       int pin;
> -
> -       /* Read event register */
> -       val = readl(virtbase + U300_GPIO_PXIEV + port->number *
> -                               U300_GPIO_PORTX_SPACING);
> -       /* Mask with enable register */
> -       val &= readl(virtbase + U300_GPIO_PXIEV + port->number *
> -                               U300_GPIO_PORTX_SPACING);
> -       /* Mask relevant bits */
> -       val &= U300_GPIO_PXIEV_ALL_IRQ_EVENT_MASK;
> -       /* ACK IRQ (clear event) */
> -       writel(val, virtbase + U300_GPIO_PXIEV + port->number *
> -                               U300_GPIO_PORTX_SPACING);
> -       /* Print message */
> -       while (val != 0) {
> -               unsigned gpio;
> -
> -               pin = __ffs(val);
> -               /* mask off this pin */
> -               val &= ~(1 << pin);
> -               gpio = (port->number << 3) + pin;
> -
> -               if (gpio_pin[gpio].callback)
> -                       (void)gpio_pin[gpio].callback(gpio_pin[gpio].data);
> -               else
> -                       dev_dbg(gpiodev, "stray GPIO IRQ on line %d\n",
> -                              gpio);
> -       }
> -       return IRQ_HANDLED;
> -}
> -
> -static void gpio_set_initial_values(void)
> -{
> -#ifdef U300_COH901571_3
> -       int i, j;
> -       unsigned long flags;
> -       u32 val;
> -
> -       /* Write default values to all pins */
> -       for (i = 0; i < U300_GPIO_NUM_PORTS; i++) {
> -               val = 0;
> -               for (j = 0; j < 8; j++)
> -                       val |= (u32) (u300_gpio_config[i][j].default_output_value != DEFAULT_OUTPUT_LOW) << j;
> -               local_irq_save(flags);
> -               writel(val, virtbase + U300_GPIO_PXPDOR + i * U300_GPIO_PORTX_SPACING);
> -               local_irq_restore(flags);
> -       }
> -
> -       /*
> -        * Put all pins that are set to either 'GPIO_OUT' or 'GPIO_NOT_USED'
> -        * to output and 'GPIO_IN' to input for each port. And initialize
> -        * default value on outputs.
> -        */
> -       for (i = 0; i < U300_GPIO_NUM_PORTS; i++) {
> -               for (j = 0; j < U300_GPIO_PINS_PER_PORT; j++) {
> -                       local_irq_save(flags);
> -                       val = readl(virtbase + U300_GPIO_PXPCR +
> -                                        i * U300_GPIO_PORTX_SPACING);
> -                       /* Mask out this pin */
> -                       val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK << (j << 1));
> -
> -                       if (u300_gpio_config[i][j].pin_usage != GPIO_IN)
> -                               val |= (U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL << (j << 1));
> -                       writel(val, virtbase + U300_GPIO_PXPCR +
> -                                        i * U300_GPIO_PORTX_SPACING);
> -                       local_irq_restore(flags);
> -               }
> -       }
> -
> -       /* Enable or disable the internal pull-ups in the GPIO ASIC block */
> -       for (i = 0; i < U300_GPIO_MAX; i++) {
> -               val = 0;
> -               for (j = 0; j < 8; j++)
> -                       val |= (u32)((u300_gpio_config[i][j].pull_up == DISABLE_PULL_UP) << j);
> -               local_irq_save(flags);
> -               writel(val, virtbase + U300_GPIO_PXPER + i * U300_GPIO_PORTX_SPACING);
> -               local_irq_restore(flags);
> -       }
> -#endif
> -}
> -
> -static int __init gpio_probe(struct platform_device *pdev)
> -{
> -       u32 val;
> -       int err = 0;
> -       int i;
> -       int num_irqs;
> -
> -       gpiodev = &pdev->dev;
> -       memset(gpio_pin, 0, sizeof(gpio_pin));
> -
> -       /* Get GPIO clock */
> -       clk = clk_get(&pdev->dev, NULL);
> -       if (IS_ERR(clk)) {
> -               err = PTR_ERR(clk);
> -               dev_err(gpiodev, "could not get GPIO clock\n");
> -               goto err_no_clk;
> -       }
> -       err = clk_enable(clk);
> -       if (err) {
> -               dev_err(gpiodev, "could not enable GPIO clock\n");
> -               goto err_no_clk_enable;
> -       }
> -
> -       memres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       if (!memres)
> -               goto err_no_resource;
> -
> -       if (request_mem_region(memres->start, memres->end - memres->start, "GPIO Controller")
> -           == NULL) {
> -               err = -ENODEV;
> -               goto err_no_ioregion;
> -       }
> -
> -       virtbase = ioremap(memres->start, resource_size(memres));
> -       if (!virtbase) {
> -               err = -ENOMEM;
> -               goto err_no_ioremap;
> -       }
> -       dev_info(gpiodev, "remapped 0x%08x to %p\n",
> -                memres->start, virtbase);
> -
> -#ifdef U300_COH901335
> -       dev_info(gpiodev, "initializing GPIO Controller COH 901 335\n");
> -       /* Turn on the GPIO block */
> -       writel(U300_GPIO_CR_BLOCK_CLOCK_ENABLE, virtbase + U300_GPIO_CR);
> -#endif
> -
> -#ifdef U300_COH901571_3
> -       dev_info(gpiodev, "initializing GPIO Controller COH 901 571/3\n");
> -       val = readl(virtbase + U300_GPIO_CR);
> -       dev_info(gpiodev, "COH901571/3 block version: %d, " \
> -              "number of cores: %d\n",
> -              ((val & 0x0000FE00) >> 9),
> -              ((val & 0x000001FC) >> 2));
> -       writel(U300_GPIO_CR_BLOCK_CLKRQ_ENABLE, virtbase + U300_GPIO_CR);
> -#endif
> -
> -       gpio_set_initial_values();
> -
> -       for (num_irqs = 0 ; num_irqs < U300_GPIO_NUM_PORTS; num_irqs++) {
> -
> -               gpio_ports[num_irqs].irq =
> -                       platform_get_irq_byname(pdev,
> -                                               gpio_ports[num_irqs].name);
> -
> -               err = request_irq(gpio_ports[num_irqs].irq,
> -                                 gpio_irq_handler, IRQF_DISABLED,
> -                                 gpio_ports[num_irqs].name,
> -                                 &gpio_ports[num_irqs]);
> -               if (err) {
> -                       dev_err(gpiodev, "cannot allocate IRQ for %s!\n",
> -                               gpio_ports[num_irqs].name);
> -                       goto err_no_irq;
> -               }
> -               /* Turns off PortX_irq_force */
> -               writel(0x0, virtbase + U300_GPIO_PXIFR +
> -                                num_irqs * U300_GPIO_PORTX_SPACING);
> -       }
> -
> -       return 0;
> -
> - err_no_irq:
> -       for (i = 0; i < num_irqs; i++)
> -               free_irq(gpio_ports[i].irq, &gpio_ports[i]);
> -       iounmap(virtbase);
> - err_no_ioremap:
> -       release_mem_region(memres->start, memres->end - memres->start);
> - err_no_ioregion:
> - err_no_resource:
> -       clk_disable(clk);
> - err_no_clk_enable:
> -       clk_put(clk);
> - err_no_clk:
> -       dev_info(gpiodev, "module ERROR:%d\n", err);
> -       return err;
> -}
> -
> -static int __exit gpio_remove(struct platform_device *pdev)
> -{
> -       int i;
> -
> -       /* Turn off the GPIO block */
> -       writel(0x00000000U, virtbase + U300_GPIO_CR);
> -       for (i = 0 ; i < U300_GPIO_NUM_PORTS; i++)
> -               free_irq(gpio_ports[i].irq, &gpio_ports[i]);
> -       iounmap(virtbase);
> -       release_mem_region(memres->start, memres->end - memres->start);
> -       clk_disable(clk);
> -       clk_put(clk);
> -       return 0;
> -}
> -
> -static struct platform_driver gpio_driver = {
> -       .driver         = {
> -               .name   = "u300-gpio",
> -       },
> -       .remove         = __exit_p(gpio_remove),
> -};
> -
> -
> -static int __init u300_gpio_init(void)
> -{
> -       return platform_driver_probe(&gpio_driver, gpio_probe);
> -}
> -
> -static void __exit u300_gpio_exit(void)
> -{
> -       platform_driver_unregister(&gpio_driver);
> -}
> -
> -arch_initcall(u300_gpio_init);
> -module_exit(u300_gpio_exit);

looks like the driver can't be a real module, is the module_exit suitable?

> -
> -MODULE_AUTHOR("Linus Walleij <linus.walleij@stericsson.com>");
> -
> -#ifdef U300_COH901571_3
> -MODULE_DESCRIPTION("ST-Ericsson AB COH 901 571/3 GPIO driver");
> -#endif
> -
> -#ifdef U300_COH901335
> -MODULE_DESCRIPTION("ST-Ericsson AB COH 901 335 GPIO driver");
> -#endif
> -
> -MODULE_LICENSE("GPL");
> diff --git a/arch/arm/mach-u300/include/mach/gpio.h b/arch/arm/mach-u300/include/mach/gpio.h
> index d5a71ab..6fc3205 100644
> --- a/arch/arm/mach-u300/include/mach/gpio.h
> +++ b/arch/arm/mach-u300/include/mach/gpio.h
> @@ -17,127 +17,13 @@
>  #include <linux/io.h>
>  #include <mach/hardware.h>
>  #include <asm/irq.h>
> +#include <asm-generic/gpio.h>
>
> -/* Switch type depending on platform/chip variant */
> -#if defined(CONFIG_MACH_U300_BS2X) || defined(CONFIG_MACH_U300_BS330)
> -#define U300_COH901335
> -#endif
> -#if defined(CONFIG_MACH_U300_BS365) || defined(CONFIG_MACH_U300_BS335)
> -#define U300_COH901571_3
> -#endif
> -
> -/* Get base address for regs here */
> -#include "u300-regs.h"
> -/* IRQ numbers */
> -#include "irqs.h"
> -
> -/*
> - * This is the GPIO block definitions. GPIO (General Purpose I/O) can be
> - * used for anything, and often is. The event/enable etc figures are for
> - * the lowermost pin (pin 0 on each port), shift this left to match your
> - * pin if you're gonna use these values.
> - */
> -#ifdef U300_COH901335
> -#define U300_GPIO_PORTX_SPACING                                (0x1C)
> -/* Port X Pin Data Register 32bit, this is both input and output (R/W) */
> -#define U300_GPIO_PXPDIR                               (0x00)
> -#define U300_GPIO_PXPDOR                               (0x00)
> -/* Port X Pin Config Register 32bit (R/W) */
> -#define U300_GPIO_PXPCR                                        (0x04)
> -#define U300_GPIO_PXPCR_ALL_PINS_MODE_MASK             (0x0000FFFFUL)
> -#define U300_GPIO_PXPCR_PIN_MODE_MASK                  (0x00000003UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_SHIFT                 (0x00000002UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_INPUT                 (0x00000000UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL      (0x00000001UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_DRAIN     (0x00000002UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_SOURCE    (0x00000003UL)
> -/* Port X Interrupt Event Register 32bit (R/W) */
> -#define U300_GPIO_PXIEV                                        (0x08)
> -#define U300_GPIO_PXIEV_ALL_IRQ_EVENT_MASK             (0x000000FFUL)
> -#define U300_GPIO_PXIEV_IRQ_EVENT                      (0x00000001UL)
> -/* Port X Interrupt Enable Register 32bit (R/W) */
> -#define U300_GPIO_PXIEN                                        (0x0C)
> -#define U300_GPIO_PXIEN_ALL_IRQ_ENABLE_MASK            (0x000000FFUL)
> -#define U300_GPIO_PXIEN_IRQ_ENABLE                     (0x00000001UL)
> -/* Port X Interrupt Force Register 32bit (R/W) */
> -#define U300_GPIO_PXIFR                                        (0x10)
> -#define U300_GPIO_PXIFR_ALL_IRQ_FORCE_MASK             (0x000000FFUL)
> -#define U300_GPIO_PXIFR_IRQ_FORCE                      (0x00000001UL)
> -/* Port X Interrupt Config Register 32bit (R/W) */
> -#define U300_GPIO_PXICR                                        (0x14)
> -#define U300_GPIO_PXICR_ALL_IRQ_CONFIG_MASK            (0x000000FFUL)
> -#define U300_GPIO_PXICR_IRQ_CONFIG_MASK                        (0x00000001UL)
> -#define U300_GPIO_PXICR_IRQ_CONFIG_FALLING_EDGE                (0x00000000UL)
> -#define U300_GPIO_PXICR_IRQ_CONFIG_RISING_EDGE         (0x00000001UL)
> -/* Port X Pull-up Enable Register 32bit (R/W) */
> -#define U300_GPIO_PXPER                                        (0x18)
> -#define U300_GPIO_PXPER_ALL_PULL_UP_DISABLE_MASK       (0x000000FFUL)
> -#define U300_GPIO_PXPER_PULL_UP_DISABLE                        (0x00000001UL)
> -/* Control Register 32bit (R/W) */
> -#define U300_GPIO_CR                                   (0x54)
> -#define U300_GPIO_CR_BLOCK_CLOCK_ENABLE                        (0x00000001UL)
> -/* three ports of 8 bits each = GPIO pins 0..23 */
> -#define U300_GPIO_NUM_PORTS 3
> -#define U300_GPIO_PINS_PER_PORT 8
> -#define U300_GPIO_MAX  (U300_GPIO_PINS_PER_PORT * U300_GPIO_NUM_PORTS - 1)
> -#endif
> -
> -#ifdef U300_COH901571_3
> -/*
> - * Control Register 32bit (R/W)
> - * bit 15-9 (mask 0x0000FE00) contains the number of cores. 8*cores
> - * gives the number of GPIO pins.
> - * bit 8-2  (mask 0x000001FC) contains the core version ID.
> - */
> -#define U300_GPIO_CR                                   (0x00)
> -#define U300_GPIO_CR_SYNC_SEL_ENABLE                   (0x00000002UL)
> -#define U300_GPIO_CR_BLOCK_CLKRQ_ENABLE                        (0x00000001UL)
> -#define U300_GPIO_PORTX_SPACING                                (0x30)
> -/* Port X Pin Data INPUT Register 32bit (R/W) */
> -#define U300_GPIO_PXPDIR                               (0x04)
> -/* Port X Pin Data OUTPUT Register 32bit (R/W) */
> -#define U300_GPIO_PXPDOR                               (0x08)
> -/* Port X Pin Config Register 32bit (R/W) */
> -#define U300_GPIO_PXPCR                                        (0x0C)
> -#define U300_GPIO_PXPCR_ALL_PINS_MODE_MASK             (0x0000FFFFUL)
> -#define U300_GPIO_PXPCR_PIN_MODE_MASK                  (0x00000003UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_SHIFT                 (0x00000002UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_INPUT                 (0x00000000UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL      (0x00000001UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_DRAIN     (0x00000002UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_SOURCE    (0x00000003UL)
> -/* Port X Pull-up Enable Register 32bit (R/W) */
> -#define U300_GPIO_PXPER                                        (0x10)
> -#define U300_GPIO_PXPER_ALL_PULL_UP_DISABLE_MASK       (0x000000FFUL)
> -#define U300_GPIO_PXPER_PULL_UP_DISABLE                        (0x00000001UL)
> -/* Port X Interrupt Event Register 32bit (R/W) */
> -#define U300_GPIO_PXIEV                                        (0x14)
> -#define U300_GPIO_PXIEV_ALL_IRQ_EVENT_MASK             (0x000000FFUL)
> -#define U300_GPIO_PXIEV_IRQ_EVENT                      (0x00000001UL)
> -/* Port X Interrupt Enable Register 32bit (R/W) */
> -#define U300_GPIO_PXIEN                                        (0x18)
> -#define U300_GPIO_PXIEN_ALL_IRQ_ENABLE_MASK            (0x000000FFUL)
> -#define U300_GPIO_PXIEN_IRQ_ENABLE                     (0x00000001UL)
> -/* Port X Interrupt Force Register 32bit (R/W) */
> -#define U300_GPIO_PXIFR                                        (0x1C)
> -#define U300_GPIO_PXIFR_ALL_IRQ_FORCE_MASK             (0x000000FFUL)
> -#define U300_GPIO_PXIFR_IRQ_FORCE                      (0x00000001UL)
> -/* Port X Interrupt Config Register 32bit (R/W) */
> -#define U300_GPIO_PXICR                                        (0x20)
> -#define U300_GPIO_PXICR_ALL_IRQ_CONFIG_MASK            (0x000000FFUL)
> -#define U300_GPIO_PXICR_IRQ_CONFIG_MASK                        (0x00000001UL)
> -#define U300_GPIO_PXICR_IRQ_CONFIG_FALLING_EDGE                (0x00000000UL)
> -#define U300_GPIO_PXICR_IRQ_CONFIG_RISING_EDGE         (0x00000001UL)
> -#ifdef CONFIG_MACH_U300_BS335
> -/* seven ports of 8 bits each = GPIO pins 0..55 */
> -#define U300_GPIO_NUM_PORTS 7
> -#else
> -/* five ports of 8 bits each = GPIO pins 0..39 */
> -#define U300_GPIO_NUM_PORTS 5
> -#endif
> -#define U300_GPIO_PINS_PER_PORT 8
> -#define U300_GPIO_MAX (U300_GPIO_PINS_PER_PORT * U300_GPIO_NUM_PORTS - 1)
> -#endif
> +/* Map these overrides to gpiolib functions, simply */
> +#define gpio_get_value  __gpio_get_value
> +#define gpio_set_value  __gpio_set_value
> +#define gpio_cansleep   __gpio_cansleep
> +#define gpio_to_irq     __gpio_to_irq
>
>  /*
>  * Individual pin assignments for the B26/S26. Notice that the
> @@ -254,41 +140,4 @@
>
>  #endif
>
> -/* translates a pin number to a port number */
> -#define PIN_TO_PORT(val) (val >> 3)
> -
> -/* These can be found in arch/arm/mach-u300/gpio.c */
> -extern int gpio_is_valid(int number);
> -extern int gpio_request(unsigned gpio, const char *label);
> -extern void gpio_free(unsigned gpio);
> -extern int gpio_direction_input(unsigned gpio);
> -extern int gpio_direction_output(unsigned gpio, int value);
> -extern int gpio_register_callback(unsigned gpio,
> -                                 int (*func)(void *arg),
> -                                 void *);
> -extern int gpio_unregister_callback(unsigned gpio);
> -extern void enable_irq_on_gpio_pin(unsigned gpio, int edge);
> -extern void disable_irq_on_gpio_pin(unsigned gpio);
> -extern void gpio_pullup(unsigned gpio, int value);
> -extern int gpio_get_value(unsigned gpio);
> -extern void gpio_set_value(unsigned gpio, int value);
> -
> -#define gpio_get_value_cansleep gpio_get_value
> -#define gpio_set_value_cansleep gpio_set_value
> -
> -/* wrappers to sleep-enable the previous two functions */
> -static inline unsigned gpio_to_irq(unsigned gpio)
> -{
> -       return PIN_TO_PORT(gpio) + IRQ_U300_GPIO_PORT0;
> -}
> -
> -static inline unsigned irq_to_gpio(unsigned irq)
> -{
> -       /*
> -        * FIXME: This is no 1-1 mapping at all, it points to the
> -        * whole block of 8 pins.
> -        */
> -       return (irq - IRQ_U300_GPIO_PORT0) << 3;
> -}
> -
>  #endif
> diff --git a/arch/arm/mach-u300/include/mach/irqs.h b/arch/arm/mach-u300/include/mach/irqs.h
> index 09b1b28..d270fea 100644
> --- a/arch/arm/mach-u300/include/mach/irqs.h
> +++ b/arch/arm/mach-u300/include/mach/irqs.h
> @@ -72,7 +72,7 @@
>
>  /* DB3150 and DB3200 have only 45 IRQs */
>  #if defined(CONFIG_MACH_U300_BS2X) || defined(CONFIG_MACH_U300_BS330)
> -#define U300_NR_IRQS                   45
> +#define U300_VIC_IRQS_END              45
>  #endif
>
>  /* The DB3350-specific interrupt lines */
> @@ -88,7 +88,7 @@
>  #define IRQ_U300_GPIO_PORT4            53
>  #define IRQ_U300_GPIO_PORT5            54
>  #define IRQ_U300_GPIO_PORT6            55
> -#define U300_NR_IRQS                   56
> +#define U300_VIC_IRQS_END              56
>  #endif
>
>  /* The DB3210-specific interrupt lines */
> @@ -106,16 +106,25 @@
>  #define IRQ_U300_NFIF                  45
>  #define IRQ_U300_NFIF2                 46
>  #define IRQ_U300_SYSCON_PLL_LOCK       47
> -#define U300_NR_IRQS                   48
> +#define U300_VIC_IRQS_END              48
>  #endif
>
> -#ifdef CONFIG_AB3550_CORE
> -#define IRQ_AB3550_BASE                        (U300_NR_IRQS)
> -#define IRQ_AB3550_END                 (IRQ_AB3550_BASE + 37)
> +/* Maximum 8*7 GPIO lines */
> +#ifdef CONFIG_GPIO_U300
> +#define IRQ_U300_GPIO_BASE             (U300_VIC_IRQS_END)
> +#define IRQ_U300_GPIO_END              (IRQ_U300_GPIO_BASE + 56)
> +#else
> +#define IRQ_U300_GPIO_END              (U300_VIC_IRQS_END)
> +#endif
>
> -#define NR_IRQS                                (IRQ_AB3550_END + 1)
> +/* Optional AB3550 mixsig chip */
> +#ifdef CONFIG_AB3550_CORE
> +#define IRQ_AB3550_BASE                        (IRQ_U300_GPIO_END)
> +#define IRQ_AB3550_END                 (IRQ_AB3550_BASE + 38)
>  #else
> -#define NR_IRQS U300_NR_IRQS
> +#define IRQ_AB3550_END                 (IRQ_U300_GPIO_END)
>  #endif
>
> +#define NR_IRQS                                (IRQ_AB3550_END)
> +
>  #endif
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index d3b2953..cc89dfa 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -119,6 +119,15 @@ config GPIO_SCH
>          This driver can also be built as a module. If so, the module
>          will be called sch-gpio.
>
> +config GPIO_U300
> +       bool "ST-Ericsson U300 COH 901 335/571 GPIO"
> +       depends on GPIOLIB && ARCH_U300
> +       help
> +         Say yes here to support GPIO interface on ST-Ericsson U300.
> +         The names of the two IP block variants supported are
> +         COH 901 335 and COH 901 571/3. They contain 3, 5 or 7
> +         ports of 8 GPIO pins each.
> +
>  config GPIO_VX855
>        tristate "VIA VX855/VX875 GPIO"
>        depends on GPIOLIB && MFD_SUPPORT && PCI
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index becef59..26032b1 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -37,6 +37,7 @@ obj-$(CONFIG_GPIO_WM831X)     += wm831x-gpio.o
>  obj-$(CONFIG_GPIO_WM8350)      += wm8350-gpiolib.o
>  obj-$(CONFIG_GPIO_WM8994)      += wm8994-gpio.o
>  obj-$(CONFIG_GPIO_SCH)         += sch_gpio.o
> +obj-$(CONFIG_GPIO_U300)                += u300-gpio.o
>  obj-$(CONFIG_GPIO_RDC321X)     += rdc321x-gpio.o
>  obj-$(CONFIG_GPIO_JANZ_TTL)    += janz-ttl.o
>  obj-$(CONFIG_GPIO_SX150X)      += sx150x.o
> diff --git a/drivers/gpio/u300-gpio.c b/drivers/gpio/u300-gpio.c
> new file mode 100644
> index 0000000..d85a116
> --- /dev/null
> +++ b/drivers/gpio/u300-gpio.c
> @@ -0,0 +1,836 @@
> +/*
> + * Copyright (C) 2007-2011 ST-Ericsson AB
> + * License terms: GNU General Public License (GPL) version 2
> + * U300 GPIO module.
> + * This can driver either of the two basic GPIO cores
> + * available in the U300 platforms:
> + * COH 901 335   - Used in DB3150 (U300 1.0) and DB3200 (U330 1.0)
> + * COH 901 571/3 - Used in DB3210 (U365 2.0) and DB3350 (U335 1.0)
> + * Author: Linus Walleij <linus.walleij@linaro.org>
> + * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
> + */
> +#include <linux/module.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/io.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/gpio.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
> +#include <linux/gpio/u300.h>
> +
> +/*
> + * Register definitions for COH 901 335 variant
> + */
> +#define U300_335_PORT_STRIDE                           (0x1C)
> +/* Port X Pin Data Register 32bit, this is both input and output (R/W) */
> +#define U300_335_PXPDIR                                        (0x00)
> +#define U300_335_PXPDOR                                        (0x00)
> +/* Port X Pin Config Register 32bit (R/W) */
> +#define U300_335_PXPCR                                 (0x04)
> +/* This register layout is the same in both blocks */
> +#define U300_GPIO_PXPCR_ALL_PINS_MODE_MASK             (0x0000FFFFUL)
> +#define U300_GPIO_PXPCR_PIN_MODE_MASK                  (0x00000003UL)
> +#define U300_GPIO_PXPCR_PIN_MODE_SHIFT                 (0x00000002UL)
> +#define U300_GPIO_PXPCR_PIN_MODE_INPUT                 (0x00000000UL)
> +#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL      (0x00000001UL)
> +#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_DRAIN     (0x00000002UL)
> +#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_SOURCE    (0x00000003UL)
> +/* Port X Interrupt Event Register 32bit (R/W) */
> +#define U300_335_PXIEV                                 (0x08)
> +/* Port X Interrupt Enable Register 32bit (R/W) */
> +#define U300_335_PXIEN                                 (0x0C)
> +/* Port X Interrupt Force Register 32bit (R/W) */
> +#define U300_335_PXIFR                                 (0x10)
> +/* Port X Interrupt Config Register 32bit (R/W) */
> +#define U300_335_PXICR                                 (0x14)
> +/* This register layout is the same in both blocks */
> +#define U300_GPIO_PXICR_ALL_IRQ_CONFIG_MASK            (0x000000FFUL)
> +#define U300_GPIO_PXICR_IRQ_CONFIG_MASK                        (0x00000001UL)
> +#define U300_GPIO_PXICR_IRQ_CONFIG_FALLING_EDGE                (0x00000000UL)
> +#define U300_GPIO_PXICR_IRQ_CONFIG_RISING_EDGE         (0x00000001UL)
> +/* Port X Pull-up Enable Register 32bit (R/W) */
> +#define U300_335_PXPER                                 (0x18)
> +/* This register layout is the same in both blocks */
> +#define U300_GPIO_PXPER_ALL_PULL_UP_DISABLE_MASK       (0x000000FFUL)
> +#define U300_GPIO_PXPER_PULL_UP_DISABLE                        (0x00000001UL)
> +/* Control Register 32bit (R/W) */
> +#define U300_335_CR                                    (0x54)
> +#define U300_335_CR_BLOCK_CLOCK_ENABLE                 (0x00000001UL)
> +
> +/*
> + * Register definitions for COH 901 571 / 3 variant
> + */
> +#define U300_571_PORT_STRIDE                           (0x30)
> +/*
> + * Control Register 32bit (R/W)
> + * bit 15-9 (mask 0x0000FE00) contains the number of cores. 8*cores
> + * gives the number of GPIO pins.
> + * bit 8-2  (mask 0x000001FC) contains the core version ID.
> + */
> +#define U300_571_CR                                    (0x00)
> +#define U300_571_CR_SYNC_SEL_ENABLE                    (0x00000002UL)
> +#define U300_571_CR_BLOCK_CLKRQ_ENABLE                 (0x00000001UL)
> +/*
> + * These registers have the same layout and function as the corresponding
> + * COH 901 335 registers, just at different offset.
> + */
> +#define U300_571_PXPDIR                                        (0x04)
> +#define U300_571_PXPDOR                                        (0x08)
> +#define U300_571_PXPCR                                 (0x0C)
> +#define U300_571_PXPER                                 (0x10)
> +#define U300_571_PXIEV                                 (0x14)
> +#define U300_571_PXIEN                                 (0x18)
> +#define U300_571_PXIFR                                 (0x1C)
> +#define U300_571_PXICR                                 (0x20)
> +
> +/* 8 bits per port, no version has more than 7 ports */
> +#define U300_GPIO_PINS_PER_PORT 8
> +#define U300_GPIO_MAX (U300_GPIO_PINS_PER_PORT * 7)
> +
> +struct u300_gpio {
> +       struct gpio_chip chip;
> +       struct list_head port_list;
> +       struct clk *clk;
> +       struct resource *memres;
> +       void __iomem *base;
> +       struct device *dev;
> +       int irq_base;
> +       int users;
> +       u32 stride;
> +       /* Register offsets */
> +       u32 pcr;
> +       u32 dor;
> +       u32 dir;
> +       u32 per;
> +       u32 icr;
> +       u32 ien;
> +       u32 iev;
> +};
> +
> +struct u300_gpio_port {
> +       struct list_head node;
> +       struct u300_gpio *gpio;
> +       char name[8];
> +       int irq;
> +       int number;
> +};
> +
> +/*
> + * Macro to expand to read a specific register found in the "gpio"
> + * struct. It requires the struct u300_gpio *gpio variable to exist in
> + * its context. It calculates the port offset from the given pin
> + * offset, muliplies by the port stride and adds the register offset
> + * so it provides a pointer to the desired register.
> + */
> +#define U300_PIN_REG(pin, reg) \
> +       (gpio->base + (pin >> 3) * gpio->stride + gpio->reg)
> +
> +/*
> + * Provides a bitmask for a specific gpio pin inside an 8-bit GPIO
> + * register.
> + */
> +#define U300_PIN_BIT(pin) \
> +       (1 << (pin & 0x07))
> +
> +struct u300_gpio_confdata {
> +       u16 bias_mode;
> +       bool output;
> +       int outval;
> +};
> +
> +/* BS335 has seven ports of 8 bits each = GPIO pins 0..55 */
> +#define BS335_GPIO_NUM_PORTS 7
> +/* BS365 has five ports of 8 bits each = GPIO pins 0..39 */
> +#define BS365_GPIO_NUM_PORTS 5
> +
> +#define U300_FLOATING_INPUT { \
> +       .bias_mode = GPIO_CONFIG_BIAS_FLOAT, \
> +       .output = false, \
> +}
> +
> +#define U300_PULL_UP_INPUT { \
> +       .bias_mode = GPIO_CONFIG_BIAS_PULL_UP, \
> +       .output = false, \
> +}
> +
> +#define U300_OUTPUT_LOW { \
> +       .output = true, \
> +       .outval = 0, \
> +}
> +
> +#define U300_OUTPUT_HIGH { \
> +       .output = true, \
> +       .outval = 1, \
> +}
> +
> +
> +/* Initial configuration */
> +static struct __initdata u300_gpio_confdata
> +bs335_gpio_config[BS335_GPIO_NUM_PORTS][U300_GPIO_PINS_PER_PORT] = {
> +       /* Port 0, pins 0-7 */
> +       {
> +               U300_FLOATING_INPUT,
> +               U300_OUTPUT_HIGH,
> +               U300_FLOATING_INPUT,
> +               U300_OUTPUT_LOW,
> +               U300_OUTPUT_LOW,
> +               U300_OUTPUT_LOW,
> +               U300_OUTPUT_LOW,
> +               U300_OUTPUT_LOW,
> +       },
> +       /* Port 1, pins 0-7 */
> +       {
> +               U300_OUTPUT_LOW,
> +               U300_OUTPUT_LOW,
> +               U300_OUTPUT_LOW,
> +               U300_PULL_UP_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_OUTPUT_HIGH,
> +               U300_OUTPUT_LOW,
> +               U300_OUTPUT_LOW,
> +       },
> +       /* Port 2, pins 0-7 */
> +       {
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_OUTPUT_LOW,
> +               U300_PULL_UP_INPUT,
> +               U300_OUTPUT_LOW,
> +               U300_PULL_UP_INPUT,
> +       },
> +       /* Port 3, pins 0-7 */
> +       {
> +               U300_PULL_UP_INPUT,
> +               U300_OUTPUT_LOW,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +       },
> +       /* Port 4, pins 0-7 */
> +       {
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +       },
> +       /* Port 5, pins 0-7 */
> +       {
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +       },
> +       /* Port 6, pind 0-7 */
> +       {
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +       }
> +};
> +
> +static struct __initdata u300_gpio_confdata
> +bs365_gpio_config[BS365_GPIO_NUM_PORTS][U300_GPIO_PINS_PER_PORT] = {
> +       /* Port 0, pins 0-7 */
> +       {
> +               U300_FLOATING_INPUT,
> +               U300_OUTPUT_LOW,
> +               U300_FLOATING_INPUT,
> +               U300_OUTPUT_LOW,
> +               U300_OUTPUT_LOW,
> +               U300_OUTPUT_LOW,
> +               U300_PULL_UP_INPUT,
> +               U300_FLOATING_INPUT,
> +       },
> +       /* Port 1, pins 0-7 */
> +       {
> +               U300_OUTPUT_LOW,
> +               U300_FLOATING_INPUT,
> +               U300_OUTPUT_LOW,
> +               U300_FLOATING_INPUT,
> +               U300_FLOATING_INPUT,
> +               U300_OUTPUT_HIGH,
> +               U300_OUTPUT_LOW,
> +               U300_OUTPUT_LOW,
> +       },
> +       /* Port 2, pins 0-7 */
> +       {
> +               U300_FLOATING_INPUT,
> +               U300_PULL_UP_INPUT,
> +               U300_OUTPUT_LOW,
> +               U300_OUTPUT_LOW,
> +               U300_PULL_UP_INPUT,
> +               U300_PULL_UP_INPUT,
> +               U300_PULL_UP_INPUT,
> +               U300_PULL_UP_INPUT,
> +       },
> +       /* Port 3, pins 0-7 */
> +       {
> +               U300_PULL_UP_INPUT,
> +               U300_PULL_UP_INPUT,
> +               U300_PULL_UP_INPUT,
> +               U300_PULL_UP_INPUT,
> +               U300_PULL_UP_INPUT,
> +               U300_PULL_UP_INPUT,
> +               U300_PULL_UP_INPUT,
> +               U300_PULL_UP_INPUT,
> +       },
> +       /* Port 4, pins 0-7 */
> +       {
> +               U300_PULL_UP_INPUT,
> +               U300_PULL_UP_INPUT,
> +               U300_PULL_UP_INPUT,
> +               U300_PULL_UP_INPUT,
> +               /* These 4 pins doesn't exist on DB3210 */
> +               U300_OUTPUT_LOW,
> +               U300_OUTPUT_LOW,
> +               U300_OUTPUT_LOW,
> +               U300_OUTPUT_LOW,
> +       }
> +};
> +
> +/**
> + * to_u300_gpio() - get the pointer to u300_gpio
> + * @chip: the gpio chip member of the structure u300_gpio
> + */
> +static inline struct u300_gpio *to_u300_gpio(struct gpio_chip *chip)
> +{
> +       return container_of(chip, struct u300_gpio, chip);
> +}
> +
> +static int u300_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct u300_gpio *gpio = to_u300_gpio(chip);
> +
> +       return readl(U300_PIN_REG(offset, dir)) & U300_PIN_BIT(offset);
> +}
> +
> +static void u300_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +       struct u300_gpio *gpio = to_u300_gpio(chip);
> +       unsigned long flags;
> +       u32 val;
> +
> +       local_irq_save(flags);
> +
> +       val = readl(U300_PIN_REG(offset, dor));
> +       if (value)
> +               writel(val | U300_PIN_BIT(offset), U300_PIN_REG(offset, dor));
> +       else
> +               writel(val & ~U300_PIN_BIT(offset), U300_PIN_REG(offset, dor));
> +
> +       local_irq_restore(flags);
> +}
> +
> +static int u300_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct u300_gpio *gpio = to_u300_gpio(chip);
> +       unsigned long flags;
> +       u32 val;
> +
> +       local_irq_save(flags);
> +       val = readl(U300_PIN_REG(offset, pcr));
> +       /* Mask out this pin, note 2 bits per setting */
> +       val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK << ((offset & 0x07) << 1));
> +       writel(val, U300_PIN_REG(offset, pcr));
> +       local_irq_restore(flags);
> +       return 0;
> +}
> +
> +static int u300_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
> +                                     int value)
> +{
> +       struct u300_gpio *gpio = to_u300_gpio(chip);
> +       unsigned long flags;
> +       u32 oldmode;
> +       u32 val;
> +
> +       local_irq_save(flags);
> +       val = readl(U300_PIN_REG(offset, pcr));
> +       /*
> +        * Drive mode must be set by the special mode set function, set
> +        * push/pull mode by default if no mode has been selected.
> +        */
> +       oldmode = val & (U300_GPIO_PXPCR_PIN_MODE_MASK <<
> +                        ((offset & 0x07) << 1));
> +       /* mode = 0 means input, else some mode is already set */
> +       if (oldmode == 0) {
> +               val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK <<
> +                        ((offset & 0x07) << 1));
> +               val |= (U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL
> +                       << ((offset & 0x07) << 1));
> +               writel(val, U300_PIN_REG(offset, pcr));
> +       }
> +       u300_gpio_set(chip, offset, value);
> +       local_irq_restore(flags);
> +       return 0;
> +}
> +
> +static int u300_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
> +{
> +       struct u300_gpio *gpio = to_u300_gpio(chip);
> +       int retirq = gpio->irq_base + offset;
> +
> +       dev_dbg(gpio->dev, "request IRQ for GPIO %d, return %d\n", offset,
> +               retirq);
> +       return retirq;
> +}
> +
> +static int u300_gpio_config(struct gpio_chip *chip, unsigned offset,
> +                            u16 param, unsigned long *data)
> +{
> +       struct u300_gpio *gpio = to_u300_gpio(chip);
> +       unsigned long flags;
> +       u32 val;
> +
> +       local_irq_save(flags);
> +       switch (param) {
> +       case GPIO_CONFIG_BIAS_UNKNOWN:
> +       case GPIO_CONFIG_BIAS_FLOAT:
> +               val = readl(U300_PIN_REG(offset, per));
> +               writel(val & ~U300_PIN_BIT(offset), U300_PIN_REG(offset, per));
> +               break;
> +       case GPIO_CONFIG_BIAS_PULL_UP:
> +               val = readl(U300_PIN_REG(offset, per));
> +               writel(val | U300_PIN_BIT(offset), U300_PIN_REG(offset, per));
> +               break;
> +       case GPIO_CONFIG_DRIVE_PUSH_PULL:
> +               val = readl(U300_PIN_REG(offset, pcr));
> +               val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK
> +                        << ((offset & 0x07) << 1));
> +               val |= (U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL
> +                       << ((offset & 0x07) << 1));
> +               writel(val, U300_PIN_REG(offset, pcr));
> +               break;
> +       case GPIO_CONFIG_DRIVE_OPEN_DRAIN:
> +               val = readl(U300_PIN_REG(offset, pcr));
> +               val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK
> +                        << ((offset & 0x07) << 1));
> +               val |= (U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_DRAIN
> +                       << ((offset & 0x07) << 1));
> +               writel(val, U300_PIN_REG(offset, pcr));
> +               break;
> +       case GPIO_CONFIG_DRIVE_OPEN_SOURCE:
> +               val = readl(U300_PIN_REG(offset, pcr));
> +               val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK
> +                        << ((offset & 0x07) << 1));
> +               val |= (U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_SOURCE
> +                       << ((offset & 0x07) << 1));
> +               writel(val, U300_PIN_REG(offset, pcr));
> +               break;
> +       default:
> +               local_irq_restore(flags);
> +               dev_err(gpio->dev, "illegal configuration requested\n");
> +               return -EINVAL;
> +       }
> +       local_irq_restore(flags);
> +       return 0;
> +}
> +
> +static struct gpio_chip u300_gpio_chip = {
> +       .label                  = "u300-gpio-chip",
> +       .owner                  = THIS_MODULE,
> +       .get                    = u300_gpio_get,
> +       .set                    = u300_gpio_set,
> +       .config                 = u300_gpio_config,
> +       .direction_input        = u300_gpio_direction_input,
> +       .direction_output       = u300_gpio_direction_output,
> +       .to_irq                 = u300_gpio_to_irq,
> +};
> +
> +static int u300_gpio_irq_type(struct irq_data *d, unsigned trigger)
> +{
> +       struct u300_gpio *gpio = irq_data_get_irq_chip_data(d);
> +       int offset = d->irq - gpio->irq_base;
> +       u32 val;
> +
> +       val = readl(U300_PIN_REG(offset, icr));
> +       if (trigger & IRQF_TRIGGER_RISING)
> +               writel(val | U300_PIN_BIT(offset), U300_PIN_REG(offset, icr));
> +       else
> +               writel(val & ~U300_PIN_BIT(offset), U300_PIN_REG(offset, icr));
> +
> +       return 0;
> +}
> +
> +static void u300_gpio_irq_enable(struct irq_data *d)
> +{
> +       struct u300_gpio *gpio = irq_data_get_irq_chip_data(d);
> +       int offset = d->irq - gpio->irq_base;
> +       u32 val;
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +       val = readl(U300_PIN_REG(offset, ien));
> +       writel(val | U300_PIN_BIT(offset), U300_PIN_REG(offset, ien));
> +       local_irq_restore(flags);
> +}
> +
> +static void u300_gpio_irq_disable(struct irq_data *d)
> +{
> +       struct u300_gpio *gpio = irq_data_get_irq_chip_data(d);
> +       int offset = d->irq - gpio->irq_base;
> +       u32 val;
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +       val = readl(U300_PIN_REG(offset, ien));
> +       writel(val & ~U300_PIN_BIT(offset), U300_PIN_REG(offset, ien));
> +       local_irq_restore(flags);
> +}
> +
> +static struct irq_chip u300_gpio_irqchip = {
> +       .name                   = "u300-gpio-irqchip",
> +       .irq_enable             = u300_gpio_irq_enable,
> +       .irq_disable            = u300_gpio_irq_disable,
> +       .irq_set_type           = u300_gpio_irq_type,
> +
> +};
> +
> +static void u300_gpio_irq_handler(unsigned irq, struct irq_desc *desc)
> +{
> +       struct u300_gpio_port *port = irq_get_handler_data(irq);
> +       struct u300_gpio *gpio = port->gpio;
> +       int pinoffset = port->number << 3; /* get the right stride */
> +       unsigned long val;
> +
> +       desc->irq_data.chip->irq_ack(&desc->irq_data);
> +       /* Read event register */
> +       val = readl(U300_PIN_REG(pinoffset, iev));
> +       /* Mask relevant bits */
> +       val &= 0xFFU; /* 8 bits per port */
> +       /* ACK IRQ (clear event) */
> +       writel(val, U300_PIN_REG(pinoffset, iev));
> +
> +       /* Call IRQ handler */
> +       if (val != 0) {
> +               int irqoffset;
> +
> +               for_each_set_bit(irqoffset, &val, U300_GPIO_PINS_PER_PORT) {
> +                       int pin_irq = gpio->irq_base + (port->number << 3)
> +                               + irqoffset;
> +
> +                       dev_dbg(gpio->dev, "GPIO IRQ on pin %d\n", pin_irq);
> +                       generic_handle_irq(pin_irq);
> +               }
> +       }
> +       desc->irq_data.chip->irq_unmask(&desc->irq_data);
> +}
> +
> +static void __init u300_gpio_init_pin(struct u300_gpio *gpio,
> +                                     int offset,
> +                                     struct u300_gpio_confdata *conf)
> +{
> +       /* Set mode: input or output */
> +       if (conf->output) {
> +               u300_gpio_direction_output(&gpio->chip, offset, conf->outval);
> +
> +               /* Deactivate bias mode for output */
> +               u300_gpio_config(&gpio->chip, offset, GPIO_CONFIG_BIAS_FLOAT,
> +                                NULL);
> +
> +               /* Set drive mode for output */
> +               u300_gpio_config(&gpio->chip, offset,
> +                                GPIO_CONFIG_DRIVE_PUSH_PULL, NULL);
> +
> +               dev_dbg(gpio->dev, "set up pin %d as output, value: %d\n",
> +                       offset, conf->outval);
> +       } else {
> +               u300_gpio_direction_input(&gpio->chip, offset);
> +
> +               /* Always set output low on input pins */
> +               u300_gpio_set(&gpio->chip, offset, 0);
> +
> +               /* Set bias mode for input */
> +               u300_gpio_config(&gpio->chip, offset, conf->bias_mode, NULL);
> +
> +               dev_dbg(gpio->dev, "set up pin %d as input, bias: %d\n",
> +                       offset, conf->bias_mode);
> +       }
> +}
> +
> +static void __init u300_gpio_init_coh901571(struct u300_gpio *gpio,
> +                                    struct u300_gpio_platform *plat)
> +{
> +       int i, j;
> +
> +       /* Write default config and values to all pins */
> +       for (i = 0; i < plat->ports; i++) {
> +               for (j = 0; j < 8; j++) {
> +                       struct u300_gpio_confdata *conf;
> +                       int offset = (i*8) + j;
> +
> +                       if (plat->variant == U300_GPIO_COH901571_3_BS335)
> +                               conf = &bs335_gpio_config[i][j];
> +                       else if (plat->variant == U300_GPIO_COH901571_3_BS365)
> +                               conf = &bs365_gpio_config[i][j];
> +                       else
> +                               break;
> +
> +                       u300_gpio_init_pin(gpio, offset, conf);
> +               }
> +       }
> +}
> +
> +static inline void u300_gpio_free_ports(struct u300_gpio *gpio)
> +{
> +       struct u300_gpio_port *port;
> +       struct list_head *p, *n;
> +
> +       list_for_each_safe(p, n, &gpio->port_list) {
> +               port = list_entry(p, struct u300_gpio_port, node);
> +               list_del(&port->node);
> +               free_irq(port->irq, port);
> +               kfree(port);
> +       }
> +}
> +
> +static int __init u300_gpio_probe(struct platform_device *pdev)
> +{
> +       struct u300_gpio_platform *plat = dev_get_platdata(&pdev->dev);
> +       struct u300_gpio *gpio;
> +       int err = 0;
> +       int portno;
> +       u32 val;
> +       u32 ifr;
> +       int i;
> +
> +       gpio = kzalloc(sizeof(struct u300_gpio), GFP_KERNEL);
> +       if (gpio == NULL) {
> +               dev_err(&pdev->dev, "failed to allocate memory\n");
> +               return -ENOMEM;
> +       }
> +
> +       gpio->chip = u300_gpio_chip;
> +       gpio->chip.ngpio = plat->ports * U300_GPIO_PINS_PER_PORT;
> +       gpio->irq_base = plat->gpio_irq_base;
> +       gpio->chip.dev = &pdev->dev;
> +       gpio->chip.base = plat->gpio_base;
> +       gpio->dev = &pdev->dev;
> +
> +       /* Get GPIO clock */
> +       gpio->clk = clk_get(gpio->dev, NULL);
> +       if (IS_ERR(gpio->clk)) {
> +               err = PTR_ERR(gpio->clk);
> +               dev_err(gpio->dev, "could not get GPIO clock\n");
> +               goto err_no_clk;
> +       }
> +       err = clk_enable(gpio->clk);
> +       if (err) {
> +               dev_err(gpio->dev, "could not enable GPIO clock\n");
> +               goto err_no_clk_enable;
> +       }
> +
> +       gpio->memres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!gpio->memres) {
> +               dev_err(gpio->dev, "could not get GPIO memory resource\n");
> +               err = -ENODEV;
> +               goto err_no_resource;
> +       }
> +
> +       if (request_mem_region(gpio->memres->start,
> +                              gpio->memres->end - gpio->memres->start,
> +                              "GPIO Controller")
> +           == NULL) {
> +               dev_err(gpio->dev, "could not reserve GPIO memory region\n");
> +               err = -ENODEV;
> +               goto err_no_ioregion;
> +       }
> +
> +       gpio->base = ioremap(gpio->memres->start, resource_size(gpio->memres));
> +       if (!gpio->base) {
> +               err = -ENOMEM;
> +               goto err_no_ioremap;
> +       }
> +
> +       if (plat->variant == U300_GPIO_COH901335) {
> +               dev_info(gpio->dev,
> +                        "initializing GPIO Controller COH 901 335\n");
> +               gpio->stride = U300_335_PORT_STRIDE;
> +               gpio->pcr = U300_335_PXPCR;
> +               gpio->dor = U300_335_PXPDOR;
> +               gpio->dir = U300_335_PXPDIR;
> +               gpio->per = U300_335_PXPER;
> +               gpio->icr = U300_335_PXICR;
> +               gpio->ien = U300_335_PXIEN;
> +               gpio->iev = U300_335_PXIEV;
> +               ifr = U300_335_PXIFR;
> +
> +               /* Turn on the GPIO block */
> +               writel(U300_335_CR_BLOCK_CLOCK_ENABLE,
> +                      gpio->base + U300_335_CR);
> +       } else if (plat->variant == U300_GPIO_COH901571_3_BS335 ||
> +                  plat->variant == U300_GPIO_COH901571_3_BS365) {
> +               dev_info(gpio->dev,
> +                        "initializing GPIO Controller COH 901 571/3\n");
> +               gpio->stride = U300_571_PORT_STRIDE;
> +               gpio->pcr = U300_571_PXPCR;
> +               gpio->dor = U300_571_PXPDOR;
> +               gpio->dir = U300_571_PXPDIR;
> +               gpio->per = U300_571_PXPER;
> +               gpio->icr = U300_571_PXICR;
> +               gpio->ien = U300_571_PXIEN;
> +               gpio->iev = U300_571_PXIEV;
> +               ifr = U300_571_PXIFR;
> +
> +               val = readl(gpio->base + U300_571_CR);
> +               dev_info(gpio->dev, "COH901571/3 block version: %d, " \
> +                        "number of cores: %d\n",
> +                        ((val & 0x0000FE00) >> 9),
> +                        ((val & 0x000001FC) >> 2));
> +               writel(U300_571_CR_BLOCK_CLKRQ_ENABLE,
> +                      gpio->base + U300_571_CR);
> +               u300_gpio_init_coh901571(gpio, plat);
> +       } else {
> +               dev_err(gpio->dev, "unknown block variant\n");
> +               err = -ENODEV;
> +               goto err_unknown_variant;
> +       }
> +
> +       /* Add each port with its IRQ separately */
> +       INIT_LIST_HEAD(&gpio->port_list);
> +       for (portno = 0 ; portno < plat->ports; portno++) {
> +               struct u300_gpio_port *port =
> +                       kmalloc(sizeof(struct u300_gpio_port), GFP_KERNEL);
> +
> +               if (!port) {
> +                       dev_err(gpio->dev, "out of memory\n");
> +                       err = -ENOMEM;
> +                       goto err_no_port;
> +               }
> +
> +               snprintf(port->name, 8, "gpio%d", portno);
> +               port->number = portno;
> +               port->gpio = gpio;
> +
> +               port->irq = platform_get_irq_byname(pdev,
> +                                                   port->name);
> +
> +               dev_dbg(gpio->dev, "register IRQ %d for %s\n", port->irq,
> +                       port->name);
> +
> +               irq_set_chained_handler(port->irq, u300_gpio_irq_handler);
> +               irq_set_handler_data(port->irq, port);
> +
> +               /* Then for each GPIO pin set the unique IRQ handler */
> +               for (i = 0; i < U300_GPIO_PINS_PER_PORT; i++) {
> +                       int irqno = gpio->irq_base + (portno << 3) + i;
> +
> +                       dev_dbg(gpio->dev, "handler for IRQ %d on %s\n",
> +                               irqno, port->name);
> +                       irq_set_chip_and_handler(irqno, &u300_gpio_irqchip,
> +                                                handle_simple_irq);
> +                       set_irq_flags(irqno, IRQF_VALID);
> +                       irq_set_chip_data(irqno, gpio);
> +               }
> +
> +               /* Turns off irq force (test register) for this port */
> +               writel(0x0, gpio->base + portno * gpio->stride + ifr);
> +
> +               list_add_tail(&port->node, &gpio->port_list);
> +       }
> +
> +       err = gpiochip_add(&gpio->chip);
> +       if (err) {
> +               dev_err(gpio->dev, "unable to add gpiochip: %d\n", err);
> +               goto err_no_chip;
> +       }
> +
> +       platform_set_drvdata(pdev, gpio);
> +
> +       return 0;
> +
> +err_no_chip:
> +err_no_port:
> +       u300_gpio_free_ports(gpio);
> +err_unknown_variant:
> +       iounmap(gpio->base);
> +err_no_ioremap:
> +       release_mem_region(gpio->memres->start,
> +                          gpio->memres->end - gpio->memres->start);
> +err_no_ioregion:
> +err_no_resource:
> +       clk_disable(gpio->clk);
> +err_no_clk_enable:
> +       clk_put(gpio->clk);
> +err_no_clk:
> +       kfree(gpio);
> +       dev_info(&pdev->dev, "module ERROR:%d\n", err);
> +       return err;
> +}
> +
> +static int __exit u300_gpio_remove(struct platform_device *pdev)
> +{
> +       struct u300_gpio_platform *plat = dev_get_platdata(&pdev->dev);
> +       struct u300_gpio *gpio = platform_get_drvdata(pdev);
> +       int err;
> +
> +       /* Turn off the GPIO block */
> +       if (plat->variant == U300_GPIO_COH901335)
> +               writel(0x00000000U, gpio->base + U300_335_CR);
> +       if (plat->variant == U300_GPIO_COH901571_3_BS335 ||
> +           plat->variant == U300_GPIO_COH901571_3_BS365)
> +               writel(0x00000000U, gpio->base + U300_571_CR);
> +
> +       err = gpiochip_remove(&gpio->chip);
> +       if (err < 0) {
> +               dev_err(gpio->dev, "unable to remove gpiochip: %d\n", err);
> +               return err;
> +       }
> +       u300_gpio_free_ports(gpio);
> +       iounmap(gpio->base);
> +       release_mem_region(gpio->memres->start,
> +                          gpio->memres->end - gpio->memres->start);
> +       clk_disable(gpio->clk);
> +       clk_put(gpio->clk);
> +       platform_set_drvdata(pdev, NULL);
> +       kfree(gpio);
> +       return 0;
> +}
> +
> +static struct platform_driver u300_gpio_driver = {
> +       .driver         = {
> +               .name   = "u300-gpio",
> +       },
> +       .remove         = __exit_p(u300_gpio_remove),
> +};
> +
> +
> +static int __init u300_gpio_init(void)
> +{
> +       return platform_driver_probe(&u300_gpio_driver, u300_gpio_probe);
> +}
> +
> +static void __exit u300_gpio_exit(void)
> +{
> +       platform_driver_unregister(&u300_gpio_driver);
> +}
> +
> +arch_initcall(u300_gpio_init);
> +module_exit(u300_gpio_exit);
> +
> +MODULE_AUTHOR("Linus Walleij <linus.walleij@stericsson.com>");
> +MODULE_DESCRIPTION("ST-Ericsson AB COH 901 335/COH 901 571/3 GPIO driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/gpio/u300.h b/include/linux/gpio/u300.h
> new file mode 100644
> index 0000000..38cd064
> --- /dev/null
> +++ b/include/linux/gpio/u300.h
> @@ -0,0 +1,32 @@
> +/*
> + * U300 GPIO platform data header
> + * Copyright (C) 2011 ST-Ericsson SA
> + * Written on behalf of Linaro for ST-Ericsson
> + *
> + * Author: Linus Walleij <linus.walleij@linaro.org>
> + *
> + * License terms: GNU General Public License (GPL) version 2
> + */
> +
> +/**
> + * enum u300_gpio_variant - the type of U300 GPIO employed
> + */
> +enum u300_gpio_variant {
> +       U300_GPIO_COH901335,
> +       U300_GPIO_COH901571_3_BS335,
> +       U300_GPIO_COH901571_3_BS365,
> +};
> +
> +/**
> + * struct u300_gpio_platform - U300 GPIO platform data
> + * @variant: IP block variant
> + * @ports: number of GPIO block ports
> + * @gpio_base: first GPIO number for this block (use a free range)
> + * @gpio_irq_base: first GPIO IRQ number for this block (use a free range)
> + */
> +struct u300_gpio_platform {
> +       enum u300_gpio_variant variant;
> +       u8 ports;
> +       int gpio_base;
> +       int gpio_irq_base;
> +};
> --
> 1.7.3.2
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
