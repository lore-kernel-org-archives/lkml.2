Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab1FANr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 09:47:26 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:40749 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757299Ab1FANrX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 09:47:23 -0400
MIME-Version: 1.0
In-Reply-To: <1306927051-8937-5-git-send-email-peter.ujfalusi@ti.com>
References: <1306927051-8937-1-git-send-email-peter.ujfalusi@ti.com>
	<1306927051-8937-5-git-send-email-peter.ujfalusi@ti.com>
Date: Wed, 1 Jun 2011 19:17:21 +0530
Message-ID: <BANLkTi=3Xw8Ti80oreBiN4_a-=ekDfFM6A@mail.gmail.com>
Subject: Re: [PATCH 4/8] mfd: twl6040: Add initial support
From: "T Krishnamoorthy, Balaji" <balajitk@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Jorge Eduardo Candelaria <jorge.candelaria@ti.com>,
        Margarita Olaya Cabrera <magi.olaya@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 4:47 PM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> From: Misael Lopez Cruz <misael.lopez@ti.com>
>
> TWL6040 IC provides analog high-end audio codec functions for
> handset applications. It contains several audio analog inputs
> and outputs as well as vibrator support. It's connected to the
> host processor via PDM interface for audio data communication.
> The audio modules are controlled by internal registers that
> can be accessed by I2C and PDM interface.
>
> TWL6040 MFD will be registered as a child of TWL-CORE, and will
> have two children of its own: twl6040-codec and twl6040-vibra.
>
> This driver is based on TWL4030 and WM8350 MFD drivers.
>
> Signed-off-by: Misael Lopez Cruz <misael.lopez@ti.com>
> Signed-off-by: Jorge Eduardo Candelaria <jorge.candelaria@ti.com>
> Signed-off-by: Margarita Olaya Cabrera <magi.olaya@ti.com>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  arch/arm/plat-omap/include/plat/irqs.h |   12 +-
>  drivers/mfd/Kconfig                    |    6 +
>  drivers/mfd/Makefile                   |    1 +
>  drivers/mfd/twl-core.c                 |    5 +-
>  drivers/mfd/twl6040-core.c             |  589 ++++++++++++++++++++++++++++++++
>  drivers/mfd/twl6040-irq.c              |  205 +++++++++++
>  include/linux/i2c/twl.h                |    1 +
>  include/linux/mfd/twl6040.h            |  260 ++++++++++++++
>  8 files changed, 1074 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/mfd/twl6040-core.c
>  create mode 100644 drivers/mfd/twl6040-irq.c
>  create mode 100644 include/linux/mfd/twl6040.h
>
> diff --git a/arch/arm/plat-omap/include/plat/irqs.h b/arch/arm/plat-omap/include/plat/irqs.h
> index 5a25098..2cfba51 100644
> --- a/arch/arm/plat-omap/include/plat/irqs.h
> +++ b/arch/arm/plat-omap/include/plat/irqs.h
> @@ -407,11 +407,19 @@
>  #endif
>  #define TWL6030_IRQ_END                (TWL6030_IRQ_BASE + TWL6030_BASE_NR_IRQS)
>
> +#define TWL6040_CODEC_IRQ_BASE TWL6030_IRQ_END
> +#ifdef CONFIG_TWL6040_CODEC
> +#define TWL6040_CODEC_NR_IRQS  6
> +#else
> +#define TWL6040_CODEC_NR_IRQS  0
> +#endif
> +#define TWL6040_CODEC_IRQ_END  (TWL6040_CODEC_IRQ_BASE + TWL6040_CODEC_NR_IRQS)
> +
>  /* Total number of interrupts depends on the enabled blocks above */
> -#if (TWL4030_GPIO_IRQ_END > TWL6030_IRQ_END)
> +#if (TWL4030_GPIO_IRQ_END > TWL6040_CODEC_IRQ_END)
>  #define TWL_IRQ_END            TWL4030_GPIO_IRQ_END
>  #else
> -#define TWL_IRQ_END            TWL6030_IRQ_END
> +#define TWL_IRQ_END            TWL6040_CODEC_IRQ_END
>  #endif
>
>  /* GPMC related */
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 3a6f76a..ac6b4ae 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -233,6 +233,12 @@ config TWL6030_PWM
>          Say yes here if you want support for TWL6030 PWM.
>          This is used to control charging LED brightness.
>
> +config TWL6040_CORE
> +       bool
> +       depends on TWL4030_CORE && GENERIC_HARDIRQS
> +       select MFD_CORE
> +       default n
> +
>  config MFD_STMPE
>        bool "Support STMicroelectronics STMPE"
>        depends on I2C=y && GENERIC_HARDIRQS
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 4cf9465..41f3b61 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -42,6 +42,7 @@ obj-$(CONFIG_TWL4030_MADC)      += twl4030-madc.o
>  obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
>  obj-$(CONFIG_MFD_TWL4030_AUDIO)        += twl4030-audio.o
>  obj-$(CONFIG_TWL6030_PWM)      += twl6030-pwm.o
> +obj-$(CONFIG_TWL6040_CORE)     += twl6040-core.o twl6040-irq.o
>
>  obj-$(CONFIG_MFD_MC13XXX)      += mc13xxx-core.o
>
> diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> index f9d7880..a2eddc7 100644
> --- a/drivers/mfd/twl-core.c
> +++ b/drivers/mfd/twl-core.c
> @@ -110,7 +110,7 @@
>  #endif
>
>  #if defined(CONFIG_TWL4030_CODEC) || defined(CONFIG_TWL4030_CODEC_MODULE) ||\
> -       defined(CONFIG_SND_SOC_TWL6040) || defined(CONFIG_SND_SOC_TWL6040_MODULE)
> +       defined(CONFIG_TWL6040_CORE) || defined(CONFIG_TWL6040_CORE_MODULE)
>  #define twl_has_codec()        true
>  #else
>  #define twl_has_codec()        false
> @@ -824,10 +824,9 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
>                        return PTR_ERR(child);
>        }
>
> -       /* Phoenix codec driver is probed directly atm */
>        if (twl_has_codec() && pdata->audio && twl_class_is_6030()) {
>                sub_chip_id = twl_map[TWL_MODULE_AUDIO_VOICE].sid;
> -               child = add_child(sub_chip_id, "twl6040-codec",
> +               child = add_child(sub_chip_id, "twl6040",
>                                pdata->audio, sizeof(*pdata->audio),
>                                false, 0, 0);
>                if (IS_ERR(child))
> diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
> new file mode 100644
> index 0000000..bb36862
> --- /dev/null
> +++ b/drivers/mfd/twl6040-core.c
> @@ -0,0 +1,589 @@
> +/*
> + * MFD driver for TWL6040 audio device
> + *
> + * Authors:    Misael Lopez Cruz <misael.lopez@ti.com>
> + *             Jorge Eduardo Candelaria <jorge.candelaria@ti.com>
> + *             Peter Ujfalusi <peter.ujfalusi@ti.com>
> + *
> + * Copyright:  (C) 2011 Texas Instruments, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/gpio.h>
> +#include <linux/delay.h>
> +#include <linux/i2c/twl.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/twl6040.h>
> +
> +static struct platform_device *twl6040_dev;
> +
> +int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg)
> +{
> +       int ret;
> +       u8 val = 0;
> +
> +       mutex_lock(&twl6040->io_mutex);
> +       ret = twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &val, reg);

Can this dependency on twl_i2c_[read/write] be removed,
Since TWL6040 is a separate IC which can get its own i2c_client in
twl6040-core.c and
create its own mfd devices like vibra, audio-codec ... while creating
twl6040-core.c

> +       if (ret < 0) {
> +               mutex_unlock(&twl6040->io_mutex);
> +               return ret;
> +       }
> +       mutex_unlock(&twl6040->io_mutex);
> +
> +       return val;
> +}
> +EXPORT_SYMBOL(twl6040_reg_read);
> +
