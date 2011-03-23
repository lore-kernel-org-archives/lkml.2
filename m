Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab1CWM7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:59:15 -0400
Received: from fifo99.com ([67.223.236.141]:43027 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422Ab1CWM7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:59:14 -0400
Subject: Re: [PATCH] msm: Add gpio support for 8960
From: Daniel Walker <dwalker@fifo99.com>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: davidb@codeaurora.org, bryanh@codeaurora.org, linux@arm.linux.org.uk,
        dima@android.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
In-Reply-To: <1300402640-23995-1-git-send-email-rvaswani@codeaurora.org>
References: <1300402640-23995-1-git-send-email-rvaswani@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 05:59:11 -0700
Message-ID: <1300885151.6117.11.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 15:57 -0700, Rohit Vaswani wrote:
> This patch adds GPIO support for 8960. The board file includes the
> gpiomux configs and we now use gpio-v2 for 8960.
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>  arch/arm/mach-msm/Makefile                      |    4 +--
>  arch/arm/mach-msm/board-msm8960.c               |   21 ++++++++++++
>  arch/arm/mach-msm/gpio-v2.c                     |   13 ++++---
>  arch/arm/mach-msm/include/mach/irqs-8960.h      |   38 +++++++++++-----------
>  arch/arm/mach-msm/include/mach/irqs-8x60.h      |   24 +++++++-------
>  arch/arm/mach-msm/include/mach/msm_iomap-8960.h |    3 ++
>  arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    5 +--
>  arch/arm/mach-msm/include/mach/msm_iomap.h      |    1 +
>  arch/arm/mach-msm/io.c                          |    2 +
>  9 files changed, 68 insertions(+), 43 deletions(-)
> 
> diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
> index 5ab09a1..a4f55ec 100644
> --- a/arch/arm/mach-msm/Makefile
> +++ b/arch/arm/mach-msm/Makefile
> @@ -30,11 +30,9 @@ obj-$(CONFIG_ARCH_MSM8960) += board-msm8960.o devices-msm8960.o
>  obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-v1.o gpiomux.o
>  obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-v1.o gpiomux.o
>  obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-v2.o gpiomux.o
> +obj-$(CONFIG_ARCH_MSM8960) += gpiomux-v2.o gpiomux.o
>  ifdef CONFIG_MSM_V2_TLMM
> -ifndef CONFIG_ARCH_MSM8960
> -# TODO: TLMM Mapping issues need to be resolved
>  obj-y	+= gpio-v2.o
> -endif
>  else
>  obj-y	+= gpio.o
>  endif
> diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
> index 052cb35..1f003ba 100644
> --- a/arch/arm/mach-msm/board-msm8960.c
> +++ b/arch/arm/mach-msm/board-msm8960.c
> @@ -29,6 +29,25 @@
>  #include <mach/msm_iomap.h>
>  
>  #include "devices.h"
> +#include "gpiomux.h"
> +
> +static struct msm_gpiomux_config msm8960_gpiomux_configs[NR_GPIO_IRQS] = {};
> +
> +static int __init gpiomux_init(void)
> +{
> +	int rc;
> +
> +	rc = msm_gpiomux_init(NR_GPIO_IRQS);
> +	if (rc) {
> +		printk(KERN_ERR "msm_gpiomux_init failed %d\n", rc);
> +		return rc;
> +	}
> +
> +	msm_gpiomux_install(msm8960_gpiomux_configs,
> +			ARRAY_SIZE(msm8960_gpiomux_configs));
> +
> +	return 0;
> +}
>  
>  static void __init msm8960_map_io(void)
>  {
> @@ -68,12 +87,14 @@ static struct platform_device *rumi3_devices[] __initdata = {
>  static void __init msm8960_sim_init(void)
>  {
>  	msm_clock_init(msm_clocks_8960, msm_num_clocks_8960);
> +	gpiomux_init();
>  	platform_add_devices(sim_devices, ARRAY_SIZE(sim_devices));
>  }
>  
>  static void __init msm8960_rumi3_init(void)
>  {
>  	msm_clock_init(msm_clocks_8960, msm_num_clocks_8960);
> +	gpiomux_init();
>  	platform_add_devices(rumi3_devices, ARRAY_SIZE(rumi3_devices));
>  }
>  
> diff --git a/arch/arm/mach-msm/gpio-v2.c b/arch/arm/mach-msm/gpio-v2.c
> index fb52d6d..6a37695 100644
> --- a/arch/arm/mach-msm/gpio-v2.c
> +++ b/arch/arm/mach-msm/gpio-v2.c
> @@ -1,4 +1,4 @@
> -/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
> +/* Copyright (c) 2010-2011 Code Aurora Forum. All rights reserved.
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 and
> @@ -326,6 +326,7 @@ static int msm_gpio_irq_set_type(unsigned int irq, unsigned int flow_type)
>  static void msm_summary_irq_handler(unsigned int irq, struct irq_desc *desc)
>  {
>  	unsigned long i;
> +	struct irq_chip *chip = get_irq_desc_chip(desc);
>  
>  	for (i = find_first_bit(msm_gpio.enabled_irqs, NR_GPIO_IRQS);
>  	     i < NR_GPIO_IRQS;
> @@ -334,7 +335,7 @@ static void msm_summary_irq_handler(unsigned int irq, struct irq_desc *desc)
>  			generic_handle_irq(msm_gpio_to_irq(&msm_gpio.gpio_chip,
>  							   i));
>  	}
> -	desc->chip->ack(irq);
> +	chip->irq_ack(&desc->irq_data);
>  }

It looks like your fixing something above, but you've not spelled out
what your doing in the commit text.

>  static int msm_gpio_irq_set_wake(unsigned int irq, unsigned int on)
> @@ -343,12 +344,12 @@ static int msm_gpio_irq_set_wake(unsigned int irq, unsigned int on)
>  
>  	if (on) {
>  		if (bitmap_empty(msm_gpio.wake_irqs, NR_GPIO_IRQS))
> -			set_irq_wake(TLMM_SCSS_SUMMARY_IRQ, 1);
> +			set_irq_wake(TLMM_MSM_SUMMARY_IRQ, 1);
>  		set_bit(gpio, msm_gpio.wake_irqs);
>  	} else {
>  		clear_bit(gpio, msm_gpio.wake_irqs);
>  		if (bitmap_empty(msm_gpio.wake_irqs, NR_GPIO_IRQS))
> -			set_irq_wake(TLMM_SCSS_SUMMARY_IRQ, 0);
> +			set_irq_wake(TLMM_MSM_SUMMARY_IRQ, 0);
>  	}

Again looks like another fix, but your not telling us what your doing.

>  	return 0;
> @@ -382,7 +383,7 @@ static int __devinit msm_gpio_probe(struct platform_device *dev)
>  		set_irq_flags(irq, IRQF_VALID);
>  	}
>  
> -	set_irq_chained_handler(TLMM_SCSS_SUMMARY_IRQ,
> +	set_irq_chained_handler(TLMM_MSM_SUMMARY_IRQ,
>  				msm_summary_irq_handler);

Ok, so looks like a rename. Can you add this to the commit text along
with descriptions of everything else your doing?
> diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
> index cec6ed1..2285682 100644
> --- a/arch/arm/mach-msm/io.c
> +++ b/arch/arm/mach-msm/io.c
> @@ -106,6 +106,7 @@ static struct map_desc msm8x60_io_desc[] __initdata = {
>  	MSM_CHIP_DEVICE(QGIC_CPU, MSM8X60),
>  	MSM_CHIP_DEVICE(TMR, MSM8X60),
>  	MSM_CHIP_DEVICE(TMR0, MSM8X60),
> +	MSM_CHIP_DEVICE(TLMM, MSM8X60),
>  	MSM_DEVICE(ACC),
>  	MSM_DEVICE(GCC),
>  };
> @@ -122,6 +123,7 @@ static struct map_desc msm8960_io_desc[] __initdata = {
>  	MSM_CHIP_DEVICE(QGIC_CPU, MSM8960),
>  	MSM_CHIP_DEVICE(TMR, MSM8960),
>  	MSM_CHIP_DEVICE(TMR0, MSM8960),
> +	MSM_CHIP_DEVICE(TLMM, MSM8960),
>  };
>  
>  void __init msm_map_msm8960_io(void)

If it were me I'd break this up into multiple patches.. It just feels
like your doing too much here, but that's just me.

Daniel

