Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030423Ab2B2ETA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 23:19:00 -0500
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:36431 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207Ab2B2ES5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 23:18:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tarun.kanti@ti.com designates 10.224.187.140 as permitted sender) smtp.mail=tarun.kanti@ti.com
MIME-Version: 1.0
In-Reply-To: <87r4xeyexm.fsf@ti.com>
References: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com>
	<1329999031-6914-4-git-send-email-tarun.kanti@ti.com>
	<87ty2bu91e.fsf@ti.com>
	<CAC83ZvJ97uRSLU-JmO2mnaOuziU=SotghASSJjPvESWL+eATuQ@mail.gmail.com>
	<87r4xeyexm.fsf@ti.com>
Date: Wed, 29 Feb 2012 09:48:56 +0530
Message-ID: <CAC83ZvJ21Y-pSLuxd68W_NpKFDseh6YW45ruPZLUnsNKN9koRQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] gpio/omap: remove suspend_wakeup field from struct gpio_bank
From: "DebBarma, Tarun Kanti" <tarun.kanti@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: linux-omap@vger.kernel.org, grant.likely@secretlab.ca, tony@atomide.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 12:15 AM, Kevin Hilman <khilman@ti.com> wrote:
> "DebBarma, Tarun Kanti" <tarun.kanti@ti.com> writes:
>
>> On Tue, Feb 28, 2012 at 5:24 AM, Kevin Hilman <khilman@ti.com> wrote:
>>> Tarun Kanti DebBarma <tarun.kanti@ti.com> writes:
>>>
>>>> Since we already have bank->context.wake_en to keep track
>>>> of gpios which are wakeup enabled, there is no need to have
>>>> this field any more.
>>>>
>>>> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>
>>>
>>> I'm not crazy about this change...
>>>
>>>> ---
>>>>  drivers/gpio/gpio-omap.c |   11 +++++------
>>>>  1 files changed, 5 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
>>>> index 64f15d5..b62e861 100644
>>>> --- a/drivers/gpio/gpio-omap.c
>>>> +++ b/drivers/gpio/gpio-omap.c
>>>> @@ -53,7 +53,6 @@ struct gpio_bank {
>>>>       void __iomem *base;
>>>>       u16 irq;
>>>>       u16 virtual_irq_start;
>>>> -     u32 suspend_wakeup;
>>>>       u32 non_wakeup_gpios;
>>>>       u32 enabled_non_wakeup_gpios;
>>>>       struct gpio_regs context;
>>>> @@ -497,9 +496,9 @@ static int _set_gpio_wakeup(struct gpio_bank *bank, int gpio, int enable)
>>>>
>>>>       spin_lock_irqsave(&bank->lock, flags);
>>>>       if (enable)
>>>> -             bank->suspend_wakeup |= gpio_bit;
>>>> +             bank->context.wake_en |= gpio_bit;
>>>>       else
>>>> -             bank->suspend_wakeup &= ~gpio_bit;
>>>> +             bank->context.wake_en &= ~gpio_bit;
>>>
>>> The bank->context values are expected to be copies of the actual
>>> register contents, and here that is clearly not the case.
>> Right, it should have been this:
>>
>>         if (enable)
>> -               bank->suspend_wakeup |= gpio_bit;
>> +               bank->context.wake_en |= gpio_bit;
>>         else
>> -               bank->suspend_wakeup &= ~gpio_bit;
>> +               bank->context.wake_en &= ~gpio_bit;
>> +
>> +       __raw_writel(bank->context.wake_en, bank->base + bank->regs->wkup_en);
>>
>>>
>>> With this change, you're using the context register to track changes
>>> that you *might* eventually write to the register.
>> The above change ensures that bank->context.wake_en reflects the
>> latest register value.
>
> OK, but that changes the behavior of the current code.
Agreed.

>
> The current code *only* writes this register in suspend and resume.
> _set_gpio_wakeup() just records the value that is going to be written in
> suspend.
Yes.
>
> Now, I'm not saying we shouldn't make the changes you propose above.  We
> probably should be updating the wake-enable register whenever
> _set_gpio_wakeup() is run so that GPIO wakeups work across runtime
> suspend/resume as well.
>
> However, you should probably make that functional change a separate
> patch *before* you do $SUBJECT patch which just changes the variable
> used to cache the register contents.
Sure, I will make this change.
--
Tarun
>
> Kevin
>
>
>> There are two distinct paths through which bank->context.wake_en is
>> updated now, viz:
>> Path1:-
>> chip.irq_set_type() --> gpio_irq_type() --> _set_gpio_triggering() -->
>> set_gpio_trigger()
>>
>> Path2:-
>> chip.irq_set_wake() --> gpio_wake_enable() --> irq_set_wake()
>>
>>>
>>> IMO, this is more confusing than having a separate field to track this.
>> So, there is no need have a separate field to keep track of this.
>> I hope my understanding is right.
>> --
>> Tarun
>>
>>>
>>> Kevin
>>>
>>>>       spin_unlock_irqrestore(&bank->lock, flags);
>>>>
>>>> @@ -772,7 +771,7 @@ static int omap_mpuio_suspend_noirq(struct device *dev)
>>>>
>>>>       spin_lock_irqsave(&bank->lock, flags);
>>>>       bank->context.wake_en = __raw_readl(mask_reg);
>>>> -     __raw_writel(0xffff & ~bank->suspend_wakeup, mask_reg);
>>>> +     __raw_writel(0xffff & ~bank->context.wake_en, mask_reg);
>>>>       spin_unlock_irqrestore(&bank->lock, flags);
>>>>
>>>>       return 0;
>>>> @@ -1137,12 +1136,12 @@ static int omap_gpio_suspend(struct device *dev)
>>>>       if (!bank->mod_usage || !bank->loses_context)
>>>>               return 0;
>>>>
>>>> -     if (!bank->regs->wkup_en || !bank->suspend_wakeup)
>>>> +     if (!bank->regs->wkup_en || !bank->context.wake_en)
>>>>               return 0;
>>>>
>>>>       spin_lock_irqsave(&bank->lock, flags);
>>>>       _gpio_rmw(base, bank->regs->wkup_en, 0xffffffff, 0);
>>>> -     _gpio_rmw(base, bank->regs->wkup_en, bank->suspend_wakeup, 1);
>>>> +     _gpio_rmw(base, bank->regs->wkup_en, bank->context.wake_en, 1);
>>>>       spin_unlock_irqrestore(&bank->lock, flags);
>>>>
>>>>       return 0;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
