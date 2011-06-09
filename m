Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab1FIVE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:04:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56078 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab1FIVE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:04:26 -0400
Date: Thu, 9 Jun 2011 15:04:22 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Prafulla Wadaskar <prafulla.wadaskar@st.com>
Subject: Re: [PATCH] gpio/nomadik: fix sleepmode for elder Nomadik
Message-ID: <20110609210422.GF5800@ponder.secretlab.ca>
References: <1307610527-2754-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307610527-2754-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 11:08:47AM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> The mach-nomadik machine did not compile properly due to bad
> ux500-specific functions being called. Introduce new state
> variables to fix this up.
> 
> Reported-by: Axel Lin <axel.lin@gmail.com>
> Cc: Alessandro Rubini <rubini@unipv.it>
> Cc: Prafulla Wadaskar <prafulla.wadaskar@st.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Merged, thanks.

g.

> ---
>  arch/arm/mach-ux500/cpu-db8500.c          |    3 ++
>  arch/arm/plat-nomadik/include/plat/gpio.h |    1 +
>  drivers/gpio/gpio-nomadik.c               |   40 +++++++++++++++++++++--------
>  3 files changed, 33 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
> index c3c4176..4598b06 100644
> --- a/arch/arm/mach-ux500/cpu-db8500.c
> +++ b/arch/arm/mach-ux500/cpu-db8500.c
> @@ -159,6 +159,9 @@ static void __init db8500_add_gpios(void)
>  		/* No custom data yet */
>  	};
>  
> +	if (cpu_is_u8500v2())
> +		pdata.supports_sleepmode = true;
> +
>  	dbx500_add_gpios(ARRAY_AND_SIZE(db8500_gpio_base),
>  			 IRQ_DB8500_GPIO0, &pdata);
>  }
> diff --git a/arch/arm/plat-nomadik/include/plat/gpio.h b/arch/arm/plat-nomadik/include/plat/gpio.h
> index ea19a5b..d5d7e65 100644
> --- a/arch/arm/plat-nomadik/include/plat/gpio.h
> +++ b/arch/arm/plat-nomadik/include/plat/gpio.h
> @@ -90,6 +90,7 @@ struct nmk_gpio_platform_data {
>  	int num_gpio;
>  	u32 (*get_secondary_status)(unsigned int bank);
>  	void (*set_ioforce)(bool enable);
> +	bool supports_sleepmode;
>  };
>  
>  #endif /* __ASM_PLAT_GPIO_H */
> diff --git a/drivers/gpio/gpio-nomadik.c b/drivers/gpio/gpio-nomadik.c
> index 4961ef9..2c212c7 100644
> --- a/drivers/gpio/gpio-nomadik.c
> +++ b/drivers/gpio/gpio-nomadik.c
> @@ -4,6 +4,7 @@
>   * Copyright (C) 2008,2009 STMicroelectronics
>   * Copyright (C) 2009 Alessandro Rubini <rubini@unipv.it>
>   *   Rewritten based on work by Prafulla WADASKAR <prafulla.wadaskar@st.com>
> + * Copyright (C) 2011 Linus Walleij <linus.walleij@linaro.org>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -49,6 +50,7 @@ struct nmk_gpio_chip {
>  	u32 (*get_secondary_status)(unsigned int bank);
>  	void (*set_ioforce)(bool enable);
>  	spinlock_t lock;
> +	bool sleepmode;
>  	/* Keep track of configured edges */
>  	u32 edge_rising;
>  	u32 edge_falling;
> @@ -393,14 +395,25 @@ EXPORT_SYMBOL(nmk_config_pins_sleep);
>   * @gpio: pin number
>   * @mode: NMK_GPIO_SLPM_INPUT or NMK_GPIO_SLPM_NOCHANGE,
>   *
> - * Sets the sleep mode of a pin.  If @mode is NMK_GPIO_SLPM_INPUT, the pin is
> - * changed to an input (with pullup/down enabled) in sleep and deep sleep.  If
> - * @mode is NMK_GPIO_SLPM_NOCHANGE, the pin remains in the state it was
> - * configured even when in sleep and deep sleep.
> + * This register is actually in the pinmux layer, not the GPIO block itself.
> + * The GPIO1B_SLPM register defines the GPIO mode when SLEEP/DEEP-SLEEP
> + * mode is entered (i.e. when signal IOFORCE is HIGH by the platform code).
> + * Each GPIO can be configured to be forced into GPIO mode when IOFORCE is
> + * HIGH, overriding the normal setting defined by GPIO_AFSELx registers.
> + * When IOFORCE returns LOW (by software, after SLEEP/DEEP-SLEEP exit),
> + * the GPIOs return to the normal setting defined by GPIO_AFSELx registers.
>   *
> - * On DB8500v2 onwards, this setting loses the previous meaning and instead
> - * indicates if wakeup detection is enabled on the pin.  Note that
> - * enable_irq_wake() will automatically enable wakeup detection.
> + * If @mode is NMK_GPIO_SLPM_INPUT, the corresponding GPIO is switched to GPIO
> + * mode when signal IOFORCE is HIGH (i.e. when SLEEP/DEEP-SLEEP mode is
> + * entered) regardless of the altfunction selected. Also wake-up detection is
> + * ENABLED.
> + *
> + * If @mode is NMK_GPIO_SLPM_NOCHANGE, the corresponding GPIO remains
> + * controlled by NMK_GPIO_DATC, NMK_GPIO_DATS, NMK_GPIO_DIR, NMK_GPIO_PDIS
> + * (for altfunction GPIO) or respective on-chip peripherals (for other
> + * altfuncs) when IOFORCE is HIGH. Also wake-up detection DISABLED.
> + *
> + * Note that enable_irq_wake() will automatically enable wakeup detection.
>   */
>  int nmk_gpio_set_slpm(int gpio, enum nmk_gpio_slpm mode)
>  {
> @@ -551,6 +564,12 @@ static void __nmk_gpio_irq_modify(struct nmk_gpio_chip *nmk_chip,
>  static void __nmk_gpio_set_wake(struct nmk_gpio_chip *nmk_chip,
>  				int gpio, bool on)
>  {
> +	if (nmk_chip->sleepmode) {
> +		__nmk_gpio_set_slpm(nmk_chip, gpio - nmk_chip->chip.base,
> +				    on ? NMK_GPIO_SLPM_WAKEUP_ENABLE
> +				    : NMK_GPIO_SLPM_WAKEUP_DISABLE);
> +	}
> +
>  	__nmk_gpio_irq_modify(nmk_chip, gpio, WAKE, on);
>  }
>  
> @@ -901,7 +920,7 @@ void nmk_gpio_wakeups_suspend(void)
>  		writel(chip->fwimsc & chip->real_wake,
>  		       chip->addr + NMK_GPIO_FWIMSC);
>  
> -		if (cpu_is_u8500v2()) {
> +		if (chip->sleepmode) {
>  			chip->slpm = readl(chip->addr + NMK_GPIO_SLPC);
>  
>  			/* 0 -> wakeup enable */
> @@ -923,7 +942,7 @@ void nmk_gpio_wakeups_resume(void)
>  		writel(chip->rwimsc, chip->addr + NMK_GPIO_RWIMSC);
>  		writel(chip->fwimsc, chip->addr + NMK_GPIO_FWIMSC);
>  
> -		if (cpu_is_u8500v2())
> +		if (chip->sleepmode)
>  			writel(chip->slpm, chip->addr + NMK_GPIO_SLPC);
>  	}
>  }
> @@ -1010,6 +1029,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
>  	nmk_chip->secondary_parent_irq = secondary_irq;
>  	nmk_chip->get_secondary_status = pdata->get_secondary_status;
>  	nmk_chip->set_ioforce = pdata->set_ioforce;
> +	nmk_chip->sleepmode = pdata->supports_sleepmode;
>  	spin_lock_init(&nmk_chip->lock);
>  
>  	chip = &nmk_chip->chip;
> @@ -1065,5 +1085,3 @@ core_initcall(nmk_gpio_init);
>  MODULE_AUTHOR("Prafulla WADASKAR and Alessandro Rubini");
>  MODULE_DESCRIPTION("Nomadik GPIO Driver");
>  MODULE_LICENSE("GPL");
> -
> -
> -- 
> 1.7.3.2
> 
