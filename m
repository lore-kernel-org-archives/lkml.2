Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab2IJSRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:17:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36640 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab2IJSRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:17:37 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: NeilBrown <neilb@suse.de>
Cc: "Shilimkar\, Santosh" <santosh.shilimkar@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        Tony Lindgren <tony@atomide.com>, Benoit <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        linux-omap@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Jon Hunter <jon-hunter@ti.com>
Subject: Re: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
Organization: Deep Root Systems, LLC
References: <20120825214459.7333a376@notabene.brown>
	<CAMQu2gz0-U4GxEpZFfmJec+0FRs7ugy8EYS3HyYhb1jwbMBjug@mail.gmail.com>
	<20120827085312.75957354@notabene.brown>
	<CAMQu2gwH0O+NHV7H2aF375qmv0=TKb6RweOLohTHtB4UhQ-1gQ@mail.gmail.com>
	<CAMQu2gw2b8HHDPuSRuHXVYn3sJ5BYi_PuOT=snpa3zD5ert=QQ@mail.gmail.com>
	<20120906130510.32b0b877@notabene.brown>
	<CAMQu2gxGNJ+NW_rcRiXNE=OMTq8Hb81_1hDZnNen6mjc2cf6BQ@mail.gmail.com>
	<20120906170245.10e97bdd@notabene.brown>
	<87627pldkj.fsf@deeprootsystems.com>
	<20120910141029.64a8b403@notabene.brown>
Date: Mon, 10 Sep 2012 11:17:33 -0700
In-Reply-To: <20120910141029.64a8b403@notabene.brown> (NeilBrown's message of
	"Mon, 10 Sep 2012 14:10:29 +1000")
Message-ID: <874nn5agjm.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown <neilb@suse.de> writes:

[...]

> Yes,  I see that now.  Thanks.
>
> follow patch folds those to fixes in.
>
> NeilBrown
>
> From bd9d5e9f8742c9cdc795e3d9b895f74defddb6d9 Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Mon, 10 Sep 2012 14:09:06 +1000
> Subject: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
>
> Current kernel will wake from suspend on an event an any active
> GPIO event if enable_irq_wake() wasn't called.
>
> There are two reasons that the hardware wake-enable bit should be set:
>
> 1/ while non-suspended the CPU might go into a deep sleep (off_mode)
>   in which the wake-enable bit is needed for an interrupt to be
>   recognised.
> 2/ while suspended the GPIO interrupt should wake from suspend if and
>    only if irq_wake as been enabled.
>
> The code currently doesn't keep these two reasons separate so they get
> confused and sometimes the wakeup flags is set incorrectly.
>
> This patch reverts:
>  commit 9c4ed9e6c01e7a8bd9079da8267e1f03cb4761fc
>     gpio/omap: remove suspend/resume callbacks
> and
>  commit 0aa2727399c0b78225021413022c164cb99fbc5e
>     gpio/omap: remove suspend_wakeup field from struct gpio_bank
>
> and makes some minor changes so that we have separate flags for "GPIO
> should wake from deep idle" and "GPIO should wake from suspend".
>
> With this patch, the GPIO from my touch screen doesn't wake my device
> any more, which is what I want.
>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Govindraj.R <govindraj.raja@ti.com>
>
> Signed-off-by: NeilBrown <neilb@suse.de>
>
> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> index 4fbc208..79e1340 100644
> --- a/drivers/gpio/gpio-omap.c
> +++ b/drivers/gpio/gpio-omap.c
> @@ -57,6 +57,7 @@ struct gpio_bank {
>  	u16 irq;
>  	int irq_base;
>  	struct irq_domain *domain;
> +	u32 suspend_wakeup;
>  	u32 non_wakeup_gpios;
>  	u32 enabled_non_wakeup_gpios;
>  	struct gpio_regs context;
> @@ -522,11 +523,9 @@ static int _set_gpio_wakeup(struct gpio_bank *bank, int gpio, int enable)
>  
>  	spin_lock_irqsave(&bank->lock, flags);
>  	if (enable)
> -		bank->context.wake_en |= gpio_bit;
> +		bank->suspend_wakeup |= gpio_bit;
>  	else
> -		bank->context.wake_en &= ~gpio_bit;
> -
> -	__raw_writel(bank->context.wake_en, bank->base + bank->regs->wkup_en);
> +		bank->suspend_wakeup &= ~gpio_bit;
>  	spin_unlock_irqrestore(&bank->lock, flags);
>  
>  	return 0;
> @@ -1157,6 +1156,49 @@ static int __devinit omap_gpio_probe(struct platform_device *pdev)
>  #ifdef CONFIG_ARCH_OMAP2PLUS
>  
>  #if defined(CONFIG_PM_RUNTIME)
> +
> +#if defined(CONFIG_PM_SLEEP)
> +static int omap_gpio_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct gpio_bank *bank = platform_get_drvdata(pdev);
> +	void __iomem *base = bank->base;
> +	unsigned long flags;
> +
> +	if (!bank->mod_usage ||
> +	    !bank->regs->wkup_en ||
> +	    !bank->context.wake_en)

nit: the context->wake_en check isn't really needed here.

> +		return 0;
> +
> +	spin_lock_irqsave(&bank->lock, flags);
> +	_gpio_rmw(base, bank->regs->wkup_en, 0xffffffff, 0);
> +	_gpio_rmw(base, bank->regs->wkup_en, bank->suspend_wakeup, 1);

I know we had the duplicate read/modify/writes here before, but that causes
a bunch of unnecessary register accesses.  Simply writing
bank->suspend_wakeup should suffice here...

> +	spin_unlock_irqrestore(&bank->lock, flags);
> +
> +	return 0;
> +}
> +
> +static int omap_gpio_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct gpio_bank *bank = platform_get_drvdata(pdev);
> +	void __iomem *base = bank->base;
> +	unsigned long flags;
> +
> +	if (!bank->mod_usage ||
> +	    !bank->regs->wkup_en ||
> +	    !bank->context.wake_en)
> +		return 0;
> +
> +	spin_lock_irqsave(&bank->lock, flags);
> +	_gpio_rmw(base, bank->regs->wkup_en, 0xffffffff, 0);
> +	_gpio_rmw(base, bank->regs->wkup_en, bank->context.wake_en, 1);

...similarily, simply writing context.wake_en should suffice here (after
removing the check for non-zero wake_en above so that we're sure that
the setting of suspend_wakeup is undone.)

Kevin

> +	spin_unlock_irqrestore(&bank->lock, flags);
> +
> +	return 0;
> +}
> +#endif /* CONFIG_PM_SLEEP */
> +
>  static void omap_gpio_restore_context(struct gpio_bank *bank);
>  
>  static int omap_gpio_runtime_suspend(struct device *dev)
> @@ -1386,11 +1428,14 @@ static void omap_gpio_restore_context(struct gpio_bank *bank)
>  }
>  #endif /* CONFIG_PM_RUNTIME */
>  #else
> +#define omap_gpio_suspend NULL
> +#define omap_gpio_resume NULL
>  #define omap_gpio_runtime_suspend NULL
>  #define omap_gpio_runtime_resume NULL
>  #endif
>  
>  static const struct dev_pm_ops gpio_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(omap_gpio_suspend, omap_gpio_resume)
>  	SET_RUNTIME_PM_OPS(omap_gpio_runtime_suspend, omap_gpio_runtime_resume,
>  									NULL)
>  };
