Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2KGSM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 13:12:57 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57030 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab2KGSMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 13:12:55 -0500
MIME-Version: 1.0
In-Reply-To: <1352299488-11351-4-git-send-email-peter.ujfalusi@ti.com>
References: <1352299488-11351-1-git-send-email-peter.ujfalusi@ti.com>
	<1352299488-11351-4-git-send-email-peter.ujfalusi@ti.com>
Date: Wed, 7 Nov 2012 20:12:54 +0200
Message-ID: <CANOLnONc29=cDZE=UXubs7DYOUWbgLJspPPVT2Hfq9E3zXkgVQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] pwm: New driver to support PWM driven LEDs on
 TWL4030/6030 series of PMICs
From: Grazvydas Ignotas <notasas@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Tero Kristo <t-kristo@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 7, 2012 at 4:44 PM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> The driver supports the following LED outputs as generic PWM driver:
> TWL4030 LEDA and LEDB (PWMA and PWMB)
> TWL6030 Charging indicator LED (PWM LED)
>
> On TWL6030 when the PWM requested LED is configured to be controlled by SW.
> In this case the user can enable/disable and set the duty period freely.
> When the PWM has been freed, the LED driver is put back to HW control.
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/pwm/Kconfig       |  10 ++
>  drivers/pwm/Makefile      |   1 +
>  drivers/pwm/pwm-twl-led.c | 287 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 298 insertions(+)
>  create mode 100644 drivers/pwm/pwm-twl-led.c
>
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index c577db9..49c2082 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -152,6 +152,16 @@ config PWM_TWL
>           To compile this driver as a module, choose M here: the module
>           will be called pwm-twl.
>
> +config PWM_TWL_LED
> +       tristate "TWL4030/6030 PWM support for LED drivers"
> +       select HAVE_PWM
> +       depends on TWL4030_CORE
> +       help
> +         Generic PWM framework driver for TWL4030/6030 LED.
> +
> +         To compile this driver as a module, choose M here: the module
> +         will be called pwm-twl-led.
> +
>  config PWM_VT8500
>         tristate "vt8500 pwm support"
>         depends on ARCH_VT8500
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index 3324c06..5f26134 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -12,4 +12,5 @@ obj-$(CONFIG_PWM_TEGRA)               += pwm-tegra.o
>  obj-$(CONFIG_PWM_TIECAP)       += pwm-tiecap.o
>  obj-$(CONFIG_PWM_TIEHRPWM)     += pwm-tiehrpwm.o
>  obj-$(CONFIG_PWM_TWL)          += pwm-twl.o
> +obj-$(CONFIG_PWM_TWL_LED)      += pwm-twl-led.o
>  obj-$(CONFIG_PWM_VT8500)       += pwm-vt8500.o
> diff --git a/drivers/pwm/pwm-twl-led.c b/drivers/pwm/pwm-twl-led.c
> new file mode 100644
> index 0000000..4d6ddc9
> --- /dev/null
> +++ b/drivers/pwm/pwm-twl-led.c
> @@ -0,0 +1,287 @@
> +/*
> + * Driver for TWL4030/6030 Pulse Width Modulator used as LED driver
> + *
> + * Copyright (C) 2012 Texas Instruments
> + * Author: Peter Ujfalusi <peter.ujfalusi@ti.com>
> + *
> + * This driver is a complete rewrite of the former pwm-twl6030.c authorded by:
> + * Hemanth V <hemanthv@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +#include <linux/i2c/twl.h>
> +#include <linux/slab.h>
> +
> +#define TWL4030_LED_MAX                0x7f
> +#define TWL6030_LED_MAX                0xff
> +
> +/* Registers, bits and macro for TWL4030 */
> +#define TWL4030_LEDEN_REG      0x00
> +#define TWL4030_PWMA_REG       0x01
> +
> +#define TWL4030_LEDXON         (1 << 0)
> +#define TWL4030_LEDXPWM                (1 << 4)
> +#define TWL4030_LED_PINS       (TWL4030_LEDXON | TWL4030_LEDXPWM)
> +#define TWL4030_LED_TOGGLE(led, x)     ((x) << (led))
> +
> +/* Register, bits and macro for TWL6030 */
> +#define TWL6030_LED_PWM_CTRL1  0xf4
> +#define TWL6030_LED_PWM_CTRL2  0xf5
> +
> +#define TWL6040_LED_MODE_HW    0x00
> +#define TWL6040_LED_MODE_ON    0x01
> +#define TWL6040_LED_MODE_OFF   0x02
> +#define TWL6040_LED_MODE_MASK  0x03
> +
> +struct twl_pwmled_chip {
> +       struct pwm_chip chip;
> +};
> +
> +static int twl4030_pwmled_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +                             int duty_ns, int period_ns)
> +{
> +       int duty_cycle = (duty_ns * TWL4030_LED_MAX) / period_ns;
> +       u8 on_time;
> +       u8 pwm_config[2];
> +       int base, ret;
> +
> +       if (duty_cycle >= TWL4030_LED_MAX)
> +               on_time = TWL4030_LED_MAX;
> +       else if (!duty_cycle)
> +               on_time = TWL4030_LED_MAX - 1;
> +       else
> +               on_time = TWL4030_LED_MAX - duty_cycle;
> +
> +       base = pwm->hwpwm * 2 + TWL4030_PWMA_REG;
> +
> +       pwm_config[0] = on_time;
> +       pwm_config[1] = TWL4030_LED_MAX;
> +
> +       ret = twl_i2c_write(TWL4030_MODULE_LED, pwm_config, base, 2);

Shouldn't this use TWL4030_MODULE_PWMA and TWL4030_MODULE_PWMB as
first argument? I can guess it works your way too, but
TWL4030_MODULE_PWMx would match the TRM better.


-- 
Gražvydas
