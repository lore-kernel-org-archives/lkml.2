Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362Ab2IGVhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 17:37:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57551 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab2IGVhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 17:37:19 -0400
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
Date: Fri, 07 Sep 2012 14:37:16 -0700
In-Reply-To: <20120906170245.10e97bdd@notabene.brown> (NeilBrown's message of
	"Thu, 6 Sep 2012 17:02:45 +1000")
Message-ID: <87627pldkj.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

NeilBrown <neilb@suse.de> writes:

> On Thu, 6 Sep 2012 11:18:09 +0530 "Shilimkar, Santosh"
> <santosh.shilimkar@ti.com> wrote:
>
>> On Thu, Sep 6, 2012 at 8:35 AM, NeilBrown <neilb@suse.de> wrote:
>> > On Mon, 3 Sep 2012 22:59:06 -0700 "Shilimkar, Santosh"
>> > <santosh.shilimkar@ti.com> wrote:
>
>> >> After thinking bit more on this, the problem seems to be coming
>> >> mainly because the gpio device is runtime suspended bit early than
>> >> it should be. Similar issue seen with i2c driver as well. The i2c issue
>> >> was discussed with Rafael at LPC last week. The idea is to move
>> >> the pm_runtime_enable/disable() calls entirely up to the
>> >> _late/_early stage of device suspend/resume.
>> >> Will update this thread once I have further update.
>> >
>> > This won't be late enough.  IRQCHIP_MASK_ON_SUSPEND takes effect after all
>> > the _late callbacks have been called.
>> > I, too, spoke to Rafael about this in San Diego.  He seemed to agree with me
>> > that the interrupt needs to be masked in the ->suspend callback.  any later
>> > is too late.
>> >
>> Thanks for information about your discussion. Will wait for the patch then.
>> 
>> Regards
>> santosh
>
> I already sent a patch - that is what started this thread :-)
>
> I include it below.
> You said "The patch doesn't seems to be correct" but didn't expand on why.
> Do you still think it is not correct?  I wouldn't be surprised if there is
> some case that it doesn't handle quite right, but it seems right to me.
>
> Thanks,
> NeilBrown
>
>
> From: NeilBrown <neilb@suse.de>
> Subject: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
>
> Current kernel will wake from suspend on an event on any active
> GPIO even if enable_irq_wake() wasn't called.
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

I think the direction is right here.  We never should've separated the
handling of idle vs suspend wakeups.  However, I have a few
questions/doubts below...

> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Cousson Benoit <b-cousson@ti.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Govindraj.R <govindraj.raja@ti.com>
>
> Signed-off-by: NeilBrown <neilb@suse.de>
>
> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> index 4fbc208..fdbad70 100644
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
> @@ -522,11 +523,12 @@ static int _set_gpio_wakeup(struct gpio_bank *bank, int gpio, int enable)
>  
>  	spin_lock_irqsave(&bank->lock, flags);
>  	if (enable)
> -		bank->context.wake_en |= gpio_bit;
> +		bank->suspend_wakeup |= gpio_bit;
>  	else
> -		bank->context.wake_en &= ~gpio_bit;
> +		bank->suspend_wakeup &= ~gpio_bit;
>  
> -	__raw_writel(bank->context.wake_en, bank->base + bank->regs->wkup_en);
> +	if (!bank->loses_context)
> +		__raw_writel(bank->suspend_wakeup, bank->base + bank->regs->wkup_en);

This doesn't look right for bank 1 (the only one that doesn't lose
context.)  If I'm not mistaken, this will overrides the idle wake_en
settings (from context.wake_en), will disable GPIO IRQ triggering for
any of the non IRQ wake-enabled GPIO IRQs in this bank...

>  	spin_unlock_irqrestore(&bank->lock, flags);
>  
>  	return 0;
> @@ -1157,6 +1159,51 @@ static int __devinit omap_gpio_probe(struct platform_device *pdev)
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
> +	if (!bank->mod_usage || !bank->loses_context)
> +		return 0;

... probably, we just need to drop the bank->loses_context check here,
so the late writing of bank->suspend_wakeup will happen even for bank 0.

Kevin

> +
> +	if (!bank->regs->wkup_en || !bank->context.wake_en)
> +		return 0;
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
> +	if (!bank->mod_usage || !bank->loses_context)
> +		return 0;
> +	if (!bank->regs->wkup_en || !bank->context.wake_en)
> +		return 0;
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
> @@ -1386,11 +1433,14 @@ static void omap_gpio_restore_context(struct gpio_bank *bank)
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
