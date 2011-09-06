Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab1IFJxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 05:53:07 -0400
Received: from lebrac.rtp-net.org ([88.191.135.105]:60203 "EHLO
	lebrac.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab1IFJxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 05:53:00 -0400
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>, Ben Hutchings <ben@decadent.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: [PATCH] gpio: rewrite U300 GPIO to use gpiolib
Organization: RtpNet
References: <1315297950-12720-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 06 Sep 2011 11:51:41 +0200
In-Reply-To: <1315297950-12720-1-git-send-email-linus.walleij@stericsson.com>
	(Linus Walleij's message of "Tue, 6 Sep 2011 10:32:30 +0200")
Message-ID: <87vct65782.fsf@lebrac.rtp-net.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij <linus.walleij@stericsson.com> writes:

Hi,


> From: Linus Walleij <linus.walleij@linaro.org>
>
> This rewrites the U300 GPIO so as to use gpiolib and
> struct gpio_chip instead of just generic GPIO, hiding
> all the platform specifics and passing in GPIO chip
> variant as platform data at runtime instead of the
> compiletime kludges.
>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Debian kernel maintainers <debian-kernel@lists.debian.org>
> Reported-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-nu: Linus Walleij <linus.walleij@linaro.org>
> ---
> First I though that I had to have runtime pin configuration
> to solve this, but it turns out that all users of the config
> functionality were inside the U300 GPIO driver itself, so
> I just made that functionality private to the driver.
>
> This solves the problem observed by Ben Hutchings that some
> touchscreen input devices wouldn't work with certain ARM
> machines still using just generic GPIO.
>
> This is based on top of the pending GPIO cleanups in Russells
> tree, if I can get some ACK on this I presume Russell can
> apply it to his branch.
> ---
>  arch/arm/Kconfig                            |    1 +
>  arch/arm/mach-u300/Kconfig                  |    1 +
>  arch/arm/mach-u300/core.c                   |   31 +-
>  arch/arm/mach-u300/include/mach/gpio-u300.h |  149 +---
>  arch/arm/mach-u300/include/mach/gpio.h      |   40 +-
>  arch/arm/mach-u300/include/mach/irqs.h      |   25 +-
>  drivers/gpio/Kconfig                        |    9 +
>  drivers/gpio/gpio-u300.c                    | 1191 ++++++++++++++++-----------
>  8 files changed, 795 insertions(+), 652 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index f23712d..3f38a7f 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -831,6 +831,7 @@ config ARCH_U300
>  	select CLKDEV_LOOKUP
>  	select HAVE_MACH_CLKDEV
>  	select GENERIC_GPIO
> +	select ARCH_REQUIRE_GPIOLIB
>  	help
>  	  Support for ST-Ericsson U300 series mobile platforms.
>  
> diff --git a/arch/arm/mach-u300/Kconfig b/arch/arm/mach-u300/Kconfig
> index 966a5a0..39e077e 100644
> --- a/arch/arm/mach-u300/Kconfig
> +++ b/arch/arm/mach-u300/Kconfig
> @@ -6,6 +6,7 @@ comment "ST-Ericsson Mobile Platform Products"
>  
>  config MACH_U300
>  	bool "U300"
> +	select GPIO_U300
>  
>  comment "ST-Ericsson U300/U330/U335/U365 Feature Selections"
>  
> diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
> index 724037e..2f1d758 100644
> --- a/arch/arm/mach-u300/core.c
> +++ b/arch/arm/mach-u300/core.c
> @@ -38,6 +38,7 @@
>  #include <mach/hardware.h>
>  #include <mach/syscon.h>
>  #include <mach/dma_channels.h>
> +#include <mach/gpio-u300.h>
>  
>  #include "clock.h"
>  #include "mmc.h"
> @@ -223,7 +224,7 @@ static struct resource gpio_resources[] = {
>  		.end   = IRQ_U300_GPIO_PORT2,
>  		.flags = IORESOURCE_IRQ,
>  	},
> -#ifdef U300_COH901571_3
> +#if defined(CONFIG_MACH_U300_BS365) || defined(CONFIG_MACH_U300_BS335)
>  	{
>  		.name  = "gpio3",
>  		.start = IRQ_U300_GPIO_PORT3,
> @@ -236,6 +237,7 @@ static struct resource gpio_resources[] = {
>  		.end   = IRQ_U300_GPIO_PORT4,
>  		.flags = IORESOURCE_IRQ,
>  	},
> +#endif

hmm.. silly question: Now that u300 gpios can/will be added through
gpiochip_add, is it still required to used #ifdef instead of
machine_is_foo() or use some different platform devices for that like it
was done on mxc ?

>  #ifdef CONFIG_MACH_U300_BS335
>  	{
>  		.name  = "gpio5",
> @@ -250,7 +252,6 @@ static struct resource gpio_resources[] = {
>  		.flags = IORESOURCE_IRQ,
>  	},
>  #endif /* CONFIG_MACH_U300_BS335 */
> -#endif /* U300_COH901571_3 */
>  };
>  
>  static struct resource keypad_resources[] = {
> @@ -1495,11 +1496,35 @@ static struct platform_device i2c1_device = {
>  	.resource = i2c1_resources,
>  };
>  
> +/*
> + * The different variants have a few different versions of the
> + * GPIO block, with different number of ports.
> + */
> +static struct u300_gpio_platform u300_gpio_plat = {
> +#if defined(CONFIG_MACH_U300_BS2X) || defined(CONFIG_MACH_U300_BS330)
> +	.variant = U300_GPIO_COH901335,
> +	.ports = 3,
> +#endif
> +#ifdef CONFIG_MACH_U300_BS335
> +	.variant = U300_GPIO_COH901571_3_BS335,
> +	.ports = 7,
> +#endif
> +#ifdef CONFIG_MACH_U300_BS365
> +	.variant = U300_GPIO_COH901571_3_BS365,
> +	.ports = 5,
> +#endif
> +	.gpio_base = 0,
> +	.gpio_irq_base = IRQ_U300_GPIO_BASE,
> +};
> +
>  static struct platform_device gpio_device = {
>  	.name = "u300-gpio",
>  	.id = -1,
>  	.num_resources = ARRAY_SIZE(gpio_resources),
>  	.resource = gpio_resources,
> +	.dev = {
> +		.platform_data = &u300_gpio_plat,
> +	},
>  };
>  
>  static struct platform_device keypad_device = {
> @@ -1596,7 +1621,7 @@ void __init u300_init_irq(void)
>  	BUG_ON(IS_ERR(clk));
>  	clk_enable(clk);
>  
> -	for (i = 0; i < NR_IRQS; i++)
> +	for (i = 0; i < U300_VIC_IRQS_END; i++)
>  		set_bit(i, (unsigned long *) &mask[0]);
>  	vic_init((void __iomem *) U300_INTCON0_VBASE, 0, mask[0], mask[0]);
>  	vic_init((void __iomem *) U300_INTCON1_VBASE, 32, mask[1], mask[1]);
> diff --git a/arch/arm/mach-u300/include/mach/gpio-u300.h b/arch/arm/mach-u300/include/mach/gpio-u300.h
> index a611906..0c2b202 100644
> --- a/arch/arm/mach-u300/include/mach/gpio-u300.h
> +++ b/arch/arm/mach-u300/include/mach/gpio-u300.h
> @@ -9,132 +9,6 @@
>  #ifndef __MACH_U300_GPIO_U300_H
>  #define __MACH_U300_GPIO_U300_H
>  
> -#include <linux/kernel.h>
> -#include <linux/io.h>
> -#include <mach/hardware.h>
> -#include <asm/irq.h>
> -
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
> -#define U300_GPIO_PORTX_SPACING				(0x1C)
> -/* Port X Pin Data Register 32bit, this is both input and output (R/W) */
> -#define U300_GPIO_PXPDIR				(0x00)
> -#define U300_GPIO_PXPDOR				(0x00)
> -/* Port X Pin Config Register 32bit (R/W) */
> -#define U300_GPIO_PXPCR					(0x04)
> -#define U300_GPIO_PXPCR_ALL_PINS_MODE_MASK		(0x0000FFFFUL)
> -#define U300_GPIO_PXPCR_PIN_MODE_MASK			(0x00000003UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_SHIFT			(0x00000002UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_INPUT			(0x00000000UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL	(0x00000001UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_DRAIN	(0x00000002UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_SOURCE	(0x00000003UL)
> -/* Port X Interrupt Event Register 32bit (R/W) */
> -#define U300_GPIO_PXIEV					(0x08)
> -#define U300_GPIO_PXIEV_ALL_IRQ_EVENT_MASK		(0x000000FFUL)
> -#define U300_GPIO_PXIEV_IRQ_EVENT			(0x00000001UL)
> -/* Port X Interrupt Enable Register 32bit (R/W) */
> -#define U300_GPIO_PXIEN					(0x0C)
> -#define U300_GPIO_PXIEN_ALL_IRQ_ENABLE_MASK		(0x000000FFUL)
> -#define U300_GPIO_PXIEN_IRQ_ENABLE			(0x00000001UL)
> -/* Port X Interrupt Force Register 32bit (R/W) */
> -#define U300_GPIO_PXIFR					(0x10)
> -#define U300_GPIO_PXIFR_ALL_IRQ_FORCE_MASK		(0x000000FFUL)
> -#define U300_GPIO_PXIFR_IRQ_FORCE			(0x00000001UL)
> -/* Port X Interrupt Config Register 32bit (R/W) */
> -#define U300_GPIO_PXICR					(0x14)
> -#define U300_GPIO_PXICR_ALL_IRQ_CONFIG_MASK		(0x000000FFUL)
> -#define U300_GPIO_PXICR_IRQ_CONFIG_MASK			(0x00000001UL)
> -#define U300_GPIO_PXICR_IRQ_CONFIG_FALLING_EDGE		(0x00000000UL)
> -#define U300_GPIO_PXICR_IRQ_CONFIG_RISING_EDGE		(0x00000001UL)
> -/* Port X Pull-up Enable Register 32bit (R/W) */
> -#define U300_GPIO_PXPER					(0x18)
> -#define U300_GPIO_PXPER_ALL_PULL_UP_DISABLE_MASK	(0x000000FFUL)
> -#define U300_GPIO_PXPER_PULL_UP_DISABLE			(0x00000001UL)
> -/* Control Register 32bit (R/W) */
> -#define U300_GPIO_CR					(0x54)
> -#define U300_GPIO_CR_BLOCK_CLOCK_ENABLE			(0x00000001UL)
> -/* three ports of 8 bits each = GPIO pins 0..23 */
> -#define U300_GPIO_NUM_PORTS 3
> -#define U300_GPIO_PINS_PER_PORT 8
> -#define U300_GPIO_MAX	(U300_GPIO_PINS_PER_PORT * U300_GPIO_NUM_PORTS - 1)
> -#endif
> -
> -#ifdef U300_COH901571_3
> -/*
> - * Control Register 32bit (R/W)
> - * bit 15-9 (mask 0x0000FE00) contains the number of cores. 8*cores
> - * gives the number of GPIO pins.
> - * bit 8-2  (mask 0x000001FC) contains the core version ID.
> - */
> -#define U300_GPIO_CR					(0x00)
> -#define U300_GPIO_CR_SYNC_SEL_ENABLE			(0x00000002UL)
> -#define U300_GPIO_CR_BLOCK_CLKRQ_ENABLE			(0x00000001UL)
> -#define U300_GPIO_PORTX_SPACING				(0x30)
> -/* Port X Pin Data INPUT Register 32bit (R/W) */
> -#define U300_GPIO_PXPDIR				(0x04)
> -/* Port X Pin Data OUTPUT Register 32bit (R/W) */
> -#define U300_GPIO_PXPDOR				(0x08)
> -/* Port X Pin Config Register 32bit (R/W) */
> -#define U300_GPIO_PXPCR					(0x0C)
> -#define U300_GPIO_PXPCR_ALL_PINS_MODE_MASK		(0x0000FFFFUL)
> -#define U300_GPIO_PXPCR_PIN_MODE_MASK			(0x00000003UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_SHIFT			(0x00000002UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_INPUT			(0x00000000UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL	(0x00000001UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_DRAIN	(0x00000002UL)
> -#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_SOURCE	(0x00000003UL)
> -/* Port X Pull-up Enable Register 32bit (R/W) */
> -#define U300_GPIO_PXPER					(0x10)
> -#define U300_GPIO_PXPER_ALL_PULL_UP_DISABLE_MASK	(0x000000FFUL)
> -#define U300_GPIO_PXPER_PULL_UP_DISABLE			(0x00000001UL)
> -/* Port X Interrupt Event Register 32bit (R/W) */
> -#define U300_GPIO_PXIEV					(0x14)
> -#define U300_GPIO_PXIEV_ALL_IRQ_EVENT_MASK		(0x000000FFUL)
> -#define U300_GPIO_PXIEV_IRQ_EVENT			(0x00000001UL)
> -/* Port X Interrupt Enable Register 32bit (R/W) */
> -#define U300_GPIO_PXIEN					(0x18)
> -#define U300_GPIO_PXIEN_ALL_IRQ_ENABLE_MASK		(0x000000FFUL)
> -#define U300_GPIO_PXIEN_IRQ_ENABLE			(0x00000001UL)
> -/* Port X Interrupt Force Register 32bit (R/W) */
> -#define U300_GPIO_PXIFR					(0x1C)
> -#define U300_GPIO_PXIFR_ALL_IRQ_FORCE_MASK		(0x000000FFUL)
> -#define U300_GPIO_PXIFR_IRQ_FORCE			(0x00000001UL)
> -/* Port X Interrupt Config Register 32bit (R/W) */
> -#define U300_GPIO_PXICR					(0x20)
> -#define U300_GPIO_PXICR_ALL_IRQ_CONFIG_MASK		(0x000000FFUL)
> -#define U300_GPIO_PXICR_IRQ_CONFIG_MASK			(0x00000001UL)
> -#define U300_GPIO_PXICR_IRQ_CONFIG_FALLING_EDGE		(0x00000000UL)
> -#define U300_GPIO_PXICR_IRQ_CONFIG_RISING_EDGE		(0x00000001UL)
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
> -
>  /*
>   * Individual pin assignments for the B26/S26. Notice that the
>   * actual usage of these pins depends on the PAD MUX settings, that
> @@ -250,4 +124,27 @@
>  
>  #endif
>  
> +/**
> + * enum u300_gpio_variant - the type of U300 GPIO employed
> + */
> +enum u300_gpio_variant {
> +	U300_GPIO_COH901335,
> +	U300_GPIO_COH901571_3_BS335,
> +	U300_GPIO_COH901571_3_BS365,
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
> +	enum u300_gpio_variant variant;
> +	u8 ports;
> +	int gpio_base;
> +	int gpio_irq_base;
> +};
> +
>  #endif /* __MACH_U300_GPIO_U300_H */
> diff --git a/arch/arm/mach-u300/include/mach/gpio.h b/arch/arm/mach-u300/include/mach/gpio.h
> index 430a054..ba224b5 100644
> --- a/arch/arm/mach-u300/include/mach/gpio.h
> +++ b/arch/arm/mach-u300/include/mach/gpio.h
> @@ -13,35 +13,15 @@
>  #ifndef __MACH_U300_GPIO_H
>  #define __MACH_U300_GPIO_H
>  
> -#define __ARM_GPIOLIB_COMPLEX
> +#include <linux/io.h>
> +#include <mach/hardware.h>
> +#include <asm/irq.h>
> +#include <asm-generic/gpio.h>
>  
> -/* These can be found in arch/arm/mach-u300/gpio.c */
> -extern int gpio_is_valid(int number);
> -extern int gpio_request(unsigned gpio, const char *label);
> -extern void gpio_free(unsigned gpio);
> -extern int gpio_direction_input(unsigned gpio);
> -extern int gpio_direction_output(unsigned gpio, int value);
> -extern int gpio_register_callback(unsigned gpio,
> -				  int (*func)(void *arg),
> -				  void *);
> -extern int gpio_unregister_callback(unsigned gpio);
> -extern void enable_irq_on_gpio_pin(unsigned gpio, int edge);
> -extern void disable_irq_on_gpio_pin(unsigned gpio);
> -extern void gpio_pullup(unsigned gpio, int value);
> -extern int gpio_get_value(unsigned gpio);
> -extern void gpio_set_value(unsigned gpio, int value);
> +/* Map these overrides to gpiolib functions, simply */
> +#define gpio_get_value  __gpio_get_value
> +#define gpio_set_value  __gpio_set_value
> +#define gpio_cansleep   __gpio_cansleep
> +#define gpio_to_irq     __gpio_to_irq
>  
> -#define gpio_get_value_cansleep gpio_get_value
> -#define gpio_set_value_cansleep gpio_set_value
> -
> -/* translates a pin number to a port number */
> -#define PIN_TO_PORT(val) (val >> 3)
> -
> -/* wrappers to sleep-enable the previous two functions */
> -static inline unsigned gpio_to_irq(unsigned gpio)
> -{
> -	return PIN_TO_PORT(gpio) + IRQ_U300_GPIO_PORT0;
> -}
> -#define gpio_to_irq gpio_to_irq
> -
> -#endif /* __MACH_U300_GPIO_H */
> +#endif
> diff --git a/arch/arm/mach-u300/include/mach/irqs.h b/arch/arm/mach-u300/include/mach/irqs.h
> index 09b1b28..d270fea 100644
> --- a/arch/arm/mach-u300/include/mach/irqs.h
> +++ b/arch/arm/mach-u300/include/mach/irqs.h
> @@ -72,7 +72,7 @@
>  
>  /* DB3150 and DB3200 have only 45 IRQs */
>  #if defined(CONFIG_MACH_U300_BS2X) || defined(CONFIG_MACH_U300_BS330)
> -#define U300_NR_IRQS			45
> +#define U300_VIC_IRQS_END		45
>  #endif
>  
>  /* The DB3350-specific interrupt lines */
> @@ -88,7 +88,7 @@
>  #define IRQ_U300_GPIO_PORT4		53
>  #define IRQ_U300_GPIO_PORT5		54
>  #define IRQ_U300_GPIO_PORT6		55
> -#define U300_NR_IRQS			56
> +#define U300_VIC_IRQS_END		56
>  #endif
>  
>  /* The DB3210-specific interrupt lines */
> @@ -106,16 +106,25 @@
>  #define IRQ_U300_NFIF			45
>  #define IRQ_U300_NFIF2			46
>  #define IRQ_U300_SYSCON_PLL_LOCK	47
> -#define U300_NR_IRQS			48
> +#define U300_VIC_IRQS_END		48
>  #endif
>  
> -#ifdef CONFIG_AB3550_CORE
> -#define IRQ_AB3550_BASE			(U300_NR_IRQS)
> -#define IRQ_AB3550_END			(IRQ_AB3550_BASE + 37)
> +/* Maximum 8*7 GPIO lines */
> +#ifdef CONFIG_GPIO_U300
> +#define IRQ_U300_GPIO_BASE		(U300_VIC_IRQS_END)
> +#define IRQ_U300_GPIO_END		(IRQ_U300_GPIO_BASE + 56)
> +#else
> +#define IRQ_U300_GPIO_END		(U300_VIC_IRQS_END)
> +#endif
>  
> -#define NR_IRQS				(IRQ_AB3550_END + 1)
> +/* Optional AB3550 mixsig chip */
> +#ifdef CONFIG_AB3550_CORE
> +#define IRQ_AB3550_BASE			(IRQ_U300_GPIO_END)
> +#define IRQ_AB3550_END			(IRQ_AB3550_BASE + 38)
>  #else
> -#define NR_IRQS U300_NR_IRQS
> +#define IRQ_AB3550_END			(IRQ_U300_GPIO_END)
>  #endif
>  
> +#define NR_IRQS				(IRQ_AB3550_END)
> +
>  #endif
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index d539efd..4caa3d3 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -178,6 +178,15 @@ config GPIO_SCH
>  	  The Intel Tunnel Creek processor has 5 GPIOs powered by the
>  	  core power rail and 9 from suspend power supply.
>  
> +config GPIO_U300
> +	bool "ST-Ericsson U300 COH 901 335/571 GPIO"
> +	depends on GPIOLIB && ARCH_U300
> +	help
> +	  Say yes here to support GPIO interface on ST-Ericsson U300.
> +	  The names of the two IP block variants supported are
> +	  COH 901 335 and COH 901 571/3. They contain 3, 5 or 7
> +	  ports of 8 GPIO pins each.
> +
>  config GPIO_VX855
>  	tristate "VIA VX855/VX875 GPIO"
>  	depends on MFD_SUPPORT && PCI
> diff --git a/drivers/gpio/gpio-u300.c b/drivers/gpio/gpio-u300.c
> index 92f2b8c..8e011d5 100644
> --- a/drivers/gpio/gpio-u300.c
> +++ b/drivers/gpio/gpio-u300.c
> @@ -1,18 +1,17 @@
>  /*
>   * U300 GPIO module.
>   *
> - * Copyright (C) 2007-2009 ST-Ericsson AB
> + * Copyright (C) 2007-2011 ST-Ericsson AB
>   * License terms: GNU General Public License (GPL) version 2
>   * This can driver either of the two basic GPIO cores
>   * available in the U300 platforms:
>   * COH 901 335   - Used in DB3150 (U300 1.0) and DB3200 (U330 1.0)
>   * COH 901 571/3 - Used in DB3210 (U365 2.0) and DB3350 (U335 1.0)
> - * Notice that you also have inline macros in <asm-arch/gpio.h>
> - * Author: Linus Walleij <linus.walleij@stericsson.com>
> + * Author: Linus Walleij <linus.walleij@linaro.org>
>   * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
> - *
>   */
>  #include <linux/module.h>
> +#include <linux/irq.h>
>  #include <linux/interrupt.h>
>  #include <linux/delay.h>
>  #include <linux/errno.h>
> @@ -21,678 +20,900 @@
>  #include <linux/err.h>
>  #include <linux/platform_device.h>
>  #include <linux/gpio.h>
> +#include <linux/list.h>
> +#include <linux/slab.h>
>  #include <mach/gpio-u300.h>
>  
> -/* Reference to GPIO block clock */
> -static struct clk *clk;
> +/*
> + * Bias modes for U300 GPIOs
> + *
> + * GPIO_U300_CONFIG_BIAS_UNKNOWN: this bias mode is not known to us
> + * GPIO_U300_CONFIG_BIAS_FLOAT: no specific bias, the GPIO will float or state
> + *	is not controlled by software
> + * GPIO_U300_CONFIG_BIAS_PULL_UP: the GPIO will be pulled up (usually with high
> + *	impedance to VDD)
> + */
> +#define GPIO_U300_CONFIG_BIAS_UNKNOWN	0x1000
> +#define GPIO_U300_CONFIG_BIAS_FLOAT	0x1001
> +#define GPIO_U300_CONFIG_BIAS_PULL_UP	0x1002
> +
> +/*
> + * Drive modes for U300 GPIOs (output)
> + *
> + * GPIO_U300_CONFIG_DRIVE_PUSH_PULL: the GPIO will be driven actively high and
> + *	low, this is the most typical case and is typically achieved with two
> + *	active transistors on the output
> + * GPIO_U300_CONFIG_DRIVE_OPEN_DRAIN: the GPIO will be driven with open drain
> + *	(open collector) which means it is usually wired with other output
> + *	ports which are then pulled up with an external resistor
> + * GPIO_U300_CONFIG_DRIVE_OPEN_SOURCE: the GPIO will be driven with open drain
> + *	(open emitter) which is the same as open drain mutatis mutandis but
> + *	pulled to ground
> + */
> +#define GPIO_U300_CONFIG_DRIVE_PUSH_PULL	0x2000
> +#define GPIO_U300_CONFIG_DRIVE_OPEN_DRAIN	0x2001
> +#define GPIO_U300_CONFIG_DRIVE_OPEN_SOURCE	0x2002
> +
> +/*
> + * Register definitions for COH 901 335 variant
> + */
> +#define U300_335_PORT_STRIDE				(0x1C)
> +/* Port X Pin Data Register 32bit, this is both input and output (R/W) */
> +#define U300_335_PXPDIR					(0x00)
> +#define U300_335_PXPDOR					(0x00)
> +/* Port X Pin Config Register 32bit (R/W) */
> +#define U300_335_PXPCR					(0x04)
> +/* This register layout is the same in both blocks */
> +#define U300_GPIO_PXPCR_ALL_PINS_MODE_MASK		(0x0000FFFFUL)
> +#define U300_GPIO_PXPCR_PIN_MODE_MASK			(0x00000003UL)
> +#define U300_GPIO_PXPCR_PIN_MODE_SHIFT			(0x00000002UL)
> +#define U300_GPIO_PXPCR_PIN_MODE_INPUT			(0x00000000UL)
> +#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL	(0x00000001UL)
> +#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_DRAIN	(0x00000002UL)
> +#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_SOURCE	(0x00000003UL)
> +/* Port X Interrupt Event Register 32bit (R/W) */
> +#define U300_335_PXIEV					(0x08)
> +/* Port X Interrupt Enable Register 32bit (R/W) */
> +#define U300_335_PXIEN					(0x0C)
> +/* Port X Interrupt Force Register 32bit (R/W) */
> +#define U300_335_PXIFR					(0x10)
> +/* Port X Interrupt Config Register 32bit (R/W) */
> +#define U300_335_PXICR					(0x14)
> +/* This register layout is the same in both blocks */
> +#define U300_GPIO_PXICR_ALL_IRQ_CONFIG_MASK		(0x000000FFUL)
> +#define U300_GPIO_PXICR_IRQ_CONFIG_MASK			(0x00000001UL)
> +#define U300_GPIO_PXICR_IRQ_CONFIG_FALLING_EDGE		(0x00000000UL)
> +#define U300_GPIO_PXICR_IRQ_CONFIG_RISING_EDGE		(0x00000001UL)
> +/* Port X Pull-up Enable Register 32bit (R/W) */
> +#define U300_335_PXPER					(0x18)
> +/* This register layout is the same in both blocks */
> +#define U300_GPIO_PXPER_ALL_PULL_UP_DISABLE_MASK	(0x000000FFUL)
> +#define U300_GPIO_PXPER_PULL_UP_DISABLE			(0x00000001UL)
> +/* Control Register 32bit (R/W) */
> +#define U300_335_CR					(0x54)
> +#define U300_335_CR_BLOCK_CLOCK_ENABLE			(0x00000001UL)
>  
> -/* Memory resource */
> -static struct resource *memres;
> -static void __iomem *virtbase;
> -static struct device *gpiodev;
> +/*
> + * Register definitions for COH 901 571 / 3 variant
> + */
> +#define U300_571_PORT_STRIDE				(0x30)
> +/*
> + * Control Register 32bit (R/W)
> + * bit 15-9 (mask 0x0000FE00) contains the number of cores. 8*cores
> + * gives the number of GPIO pins.
> + * bit 8-2  (mask 0x000001FC) contains the core version ID.
> + */
> +#define U300_571_CR					(0x00)
> +#define U300_571_CR_SYNC_SEL_ENABLE			(0x00000002UL)
> +#define U300_571_CR_BLOCK_CLKRQ_ENABLE			(0x00000001UL)
> +/*
> + * These registers have the same layout and function as the corresponding
> + * COH 901 335 registers, just at different offset.
> + */
> +#define U300_571_PXPDIR					(0x04)
> +#define U300_571_PXPDOR					(0x08)
> +#define U300_571_PXPCR					(0x0C)
> +#define U300_571_PXPER					(0x10)
> +#define U300_571_PXIEV					(0x14)
> +#define U300_571_PXIEN					(0x18)
> +#define U300_571_PXIFR					(0x1C)
> +#define U300_571_PXICR					(0x20)
> +
> +/* 8 bits per port, no version has more than 7 ports */
> +#define U300_GPIO_PINS_PER_PORT 8
> +#define U300_GPIO_MAX (U300_GPIO_PINS_PER_PORT * 7)
> +
> +struct u300_gpio {
> +	struct gpio_chip chip;
> +	struct list_head port_list;
> +	struct clk *clk;
> +	struct resource *memres;
> +	void __iomem *base;
> +	struct device *dev;
> +	int irq_base;
> +	int users;
> +	u32 stride;
> +	/* Register offsets */
> +	u32 pcr;
> +	u32 dor;
> +	u32 dir;
> +	u32 per;
> +	u32 icr;
> +	u32 ien;
> +	u32 iev;
> +};

Do you really need all theses ? I'm thinking of the 'users' field but
there are maybe others ?

>  
>  struct u300_gpio_port {
> -	const char *name;
> +	struct list_head node;
> +	struct u300_gpio *gpio;
> +	char name[8];
>  	int irq;
>  	int number;
> +	u8 toggle_edge_mode;
>  };
>  
> +/*
> + * Macro to expand to read a specific register found in the "gpio"
> + * struct. It requires the struct u300_gpio *gpio variable to exist in
> + * its context. It calculates the port offset from the given pin
> + * offset, muliplies by the port stride and adds the register offset
> + * so it provides a pointer to the desired register.
> + */
> +#define U300_PIN_REG(pin, reg) \
> +	(gpio->base + (pin >> 3) * gpio->stride + gpio->reg)
>  
> -static struct u300_gpio_port gpio_ports[] = {
> -	{
> -		.name = "gpio0",
> -		.number = 0,
> -	},
> -	{
> -		.name = "gpio1",
> -		.number = 1,
> -	},
> -	{
> -		.name = "gpio2",
> -		.number = 2,
> -	},
> -#ifdef U300_COH901571_3
> -	{
> -		.name = "gpio3",
> -		.number = 3,
> -	},
> -	{
> -		.name = "gpio4",
> -		.number = 4,
> -	},
> -#ifdef CONFIG_MACH_U300_BS335
> -	{
> -		.name = "gpio5",
> -		.number = 5,
> -	},
> -	{
> -		.name = "gpio6",
> -		.number = 6,
> -	},
> -#endif
> -#endif
> +/*
> + * Provides a bitmask for a specific gpio pin inside an 8-bit GPIO
> + * register.
> + */
> +#define U300_PIN_BIT(pin) \
> +	(1 << (pin & 0x07))
>  
> +struct u300_gpio_confdata {
> +	u16 bias_mode;
> +	bool output;
> +	int outval;
>  };
>  
> +/* BS335 has seven ports of 8 bits each = GPIO pins 0..55 */
> +#define BS335_GPIO_NUM_PORTS 7
> +/* BS365 has five ports of 8 bits each = GPIO pins 0..39 */
> +#define BS365_GPIO_NUM_PORTS 5
>  
> -#ifdef U300_COH901571_3
> +#define U300_FLOATING_INPUT { \
> +	.bias_mode = GPIO_U300_CONFIG_BIAS_FLOAT, \
> +	.output = false, \
> +}
>  
> -/* Default input value */
> -#define DEFAULT_OUTPUT_LOW   0
> -#define DEFAULT_OUTPUT_HIGH  1
> +#define U300_PULL_UP_INPUT { \
> +	.bias_mode = GPIO_U300_CONFIG_BIAS_PULL_UP, \
> +	.output = false, \
> +}
>  
> -/* GPIO Pull-Up status */
> -#define DISABLE_PULL_UP  0
> -#define ENABLE_PULL_UP  1
> +#define U300_OUTPUT_LOW { \
> +	.output = true, \
> +	.outval = 0, \
> +}
>  
> -#define GPIO_NOT_USED 0
> -#define GPIO_IN       1
> -#define GPIO_OUT      2
> +#define U300_OUTPUT_HIGH { \
> +	.output = true, \
> +	.outval = 1, \
> +}
>  
> -struct u300_gpio_configuration_data {
> -	unsigned char pin_usage;
> -	unsigned char default_output_value;
> -	unsigned char pull_up;
> -};
>  
>  /* Initial configuration */
> -const struct u300_gpio_configuration_data
> -u300_gpio_config[U300_GPIO_NUM_PORTS][U300_GPIO_PINS_PER_PORT] = {
> -#ifdef CONFIG_MACH_U300_BS335
> +static struct __initdata u300_gpio_confdata
> +bs335_gpio_config[BS335_GPIO_NUM_PORTS][U300_GPIO_PINS_PER_PORT] = {

looks like const has been lost ?


Arnaud
