Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab2ICMPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 08:15:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59425 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab2ICMPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 08:15:37 -0400
MIME-Version: 1.0
In-Reply-To: <1345809612-30992-1-git-send-email-lee.jones@linaro.org>
References: <1345809612-30992-1-git-send-email-lee.jones@linaro.org>
Date: Mon, 3 Sep 2012 14:15:35 +0200
Message-ID: <CACRpkdZX=bHYJ-BOZg68wjPZ6ZxwBq5BTL+0yR8sRdYAYAm9pw@mail.gmail.com>
Subject: Re: [PATCH] ARM: ux500: Provide SMSC911x fixed-regulator when not
 booting DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 2:00 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The SMSC911x Ethernet chip requires a fixed-regulator in order to
> function correctly.

Thanks for fixing this.

> +#ifdef CONFIG_REGULATOR_FIXED_VOLTAGE

No, just select REGULATOR_FIXED_VOLTAGE in apropriate
Kconfig entry, that's simpler. (Suspect under MACH_MOP500.)

(...)
> diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
> index de10f8f..0e904c8 100644
> --- a/arch/arm/mach-ux500/board-mop500.c
> +++ b/arch/arm/mach-ux500/board-mop500.c
> @@ -23,6 +23,7 @@
>  #include <linux/spi/spi.h>
>  #include <linux/mfd/abx500/ab8500.h>
>  #include <linux/regulator/ab8500.h>
> +#include <linux/regulator/fixed.h>
>  #include <linux/mfd/tc3589x.h>
>  #include <linux/mfd/tps6105x.h>
>  #include <linux/mfd/abx500/ab8500-gpio.h>
> @@ -75,6 +76,25 @@ static struct platform_device snowball_led_dev = {
>         },
>  };
>
> +#ifdef CONFIG_REGULATOR_FIXED_VOLTAGE

Here too, get rid of the #ifdef.

> +static struct fixed_voltage_config snowball_gpio_en_3v3_data = {
> +       .supply_name            = "EN-3V3",
> +       .gpio                   = SNOWBALL_EN_3V3_ETH_GPIO,
> +       .microvolts             = 3300000,
> +       .enable_high            = 1,
> +       .init_data              = &gpio_en_3v3_regulator,
> +       .startup_delay          = 5000, /* 1200us */
> +};
> +
> +static struct platform_device snowball_gpio_en_3v3_regulator_dev = {
> +       .name   = "reg-fixed-voltage",
> +       .id     = 1,
> +       .dev    = {
> +               .platform_data  = &snowball_gpio_en_3v3_data,
> +       },
> +};
> +#endif

(...)
>  static struct ab8500_gpio_platform_data ab8500_gpio_pdata = {
>         .gpio_base              = MOP500_AB8500_PIN_GPIO(1),
>         .irq_base               = MOP500_AB8500_VIR_GPIO_IRQ_BASE,
> @@ -585,6 +605,7 @@ static struct platform_device *snowball_platform_devs[] __initdata = {
>         &snowball_led_dev,
>         &snowball_key_dev,
>         &snowball_sbnet_dev,
> +       &snowball_gpio_en_3v3_regulator_dev,

Since as you're not #ifdef:in around this entry it will not compile anyway
without fixed regulators.

(...)
>  /* Snowball specific GPIO assignments, this board has no GPIO expander */
> +#define SNOWBALL_EN_3V3_ETH_GPIO       26
>  #define SNOWBALL_ACCEL_INT1_GPIO       163
>  #define SNOWBALL_ACCEL_INT2_GPIO       164
>  #define SNOWBALL_MAGNET_DRDY_GPIO      165
> @@ -76,7 +77,6 @@
>  #define SNOWBALL_PM_GPIO4_GPIO         MOP500_AB8500_PIN_GPIO(4)       /* SYSCLKREQ6/GPIO4 */
>  #define SNOWBALL_EN_3V6_GPIO           MOP500_AB8500_PIN_GPIO(16)      /* PWMOUT3/GPIO16 */
>  #define SNOWBALL_PME_ETH_GPIO          MOP500_AB8500_PIN_GPIO(24)      /* SYSCLKREQ7/GPIO24 */
> -#define SNOWBALL_EN_3V3_ETH_GPIO       MOP500_AB8500_PIN_GPIO(26)      /* GPIO26 */

As noted by Philippe, please drop this hunk off the patch for now.
The AB8500 GPIO is the right one... Probably you're lucky that U-boot
draws the pin high and activates this voltage.

BTW: disablingt the AB8500 pin 26 and thus noting that ethernet screws
up may be a good test for the AB8500 GPIO driver.

Yours,
Linus Walleij
