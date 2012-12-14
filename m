Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab2LNJFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 04:05:11 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45970 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab2LNJFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 04:05:01 -0500
Subject: Re: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
From: anish kumar <anish198519851985@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        Tony Lindgren <tony@atomide.com>, Benoit <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        linux-omap@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Jon Hunter <jon-hunter@ti.com>
In-Reply-To: <20121214180553.5eb62c0c@notabene.brown>
References: <20120825214459.7333a376@notabene.brown>
	 <CAMQu2gz0-U4GxEpZFfmJec+0FRs7ugy8EYS3HyYhb1jwbMBjug@mail.gmail.com>
	 <20120827085312.75957354@notabene.brown>
	 <CAMQu2gwH0O+NHV7H2aF375qmv0=TKb6RweOLohTHtB4UhQ-1gQ@mail.gmail.com>
	 <CAMQu2gw2b8HHDPuSRuHXVYn3sJ5BYi_PuOT=snpa3zD5ert=QQ@mail.gmail.com>
	 <20120906130510.32b0b877@notabene.brown>
	 <CAMQu2gxGNJ+NW_rcRiXNE=OMTq8Hb81_1hDZnNen6mjc2cf6BQ@mail.gmail.com>
	 <20120906170245.10e97bdd@notabene.brown>
	 <87627pldkj.fsf@deeprootsystems.com>
	 <CAMQu2gwSCvw_4gVE-giD6MSzmRCNoNu4NoFBSao_dh9YnojfuA@mail.gmail.com>
	 <87ipblahho.fsf@deeprootsystems.com>
	 <20121214180553.5eb62c0c@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Dec 2012 01:04:53 -0800
Message-ID: <1355475893.26515.20.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-14 at 18:05 +1100, NeilBrown wrote:
> On Mon, 10 Sep 2012 10:57:07 -0700 Kevin Hilman <khilman@deeprootsystems.com>
> wrote:
> 
> 
> > OK thanks, I'll queue this up for v3.6-rc as this should qualify as a
> > regression.
> 
> I don't think this did actually get queued.  At least I'm still seeing the
> bug in 3.7 and I cannot see a patch in the git history that looks right.
> But then I don't remember what we ended up with - it was 3 months ago!!!
> 
> This is the last thing I can find in my email history - it still seems to
> apply and still seems to work.
> 
> NeilBrown
> 
> 
> From: NeilBrown <neilb@suse.de>
> Date: Mon, 10 Sep 2012 14:09:06 +1000
> Subject: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
> 
> Current kernel will wake from suspend on an event an any active
> GPIO event if enable_irq_wake() wasn't called.
Should it read this way "Current kernel will wake from suspend on any
active gpio event if enable_irq_wake() wasn't called" ?
> 
> There are two reasons that the hardware wake-enable bit should be set:
> 
> 1/ while non-suspended the CPU might go into a deep sleep (off_mode)
>   in which the wake-enable bit is needed for an interrupt to be
"in which case"
>   recognised.
> 2/ while suspended the GPIO interrupt should wake from suspend if and
>    only if irq_wake as been enabled.
"has been enabled"
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
> +		return 0;
> +
> +	spin_lock_irqsave(&bank->lock, flags);
> +	_gpio_rmw(base, bank->regs->wkup_en, 0xffffffff, 0);
> +	_gpio_rmw(base, bank->regs->wkup_en, bank->suspend_wakeup, 1);
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
> 
> [signature.asc  application/pgp-signature (828 bytes)] 


