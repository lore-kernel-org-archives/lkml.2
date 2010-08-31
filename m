Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab0HaHQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 03:16:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52198 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab0HaHQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 03:16:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FjnVnTSKqH9I1deqZzgpebvkdt6dfwmdvyhhj9iytci1NQkf3k6AoTUY3pjn7UQUPz
         0GHvSgXjcSf3BbIr622wV8naWI2gowciKmiLu4TFVIcSoMrDY9zuaBiA9aBRKzlsy4hk
         NjS4qXlMdsm4gMicwkJZ5Fc5kWOLNRbc9mcjI=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=RgZcykxPnUcneGfZnETo9nK_72Qoa=8rKh2rD@mail.gmail.com>
References: <1282814339-10934-1-git-send-email-mark.brown314@gmail.com>
 <1282814339-10934-5-git-send-email-mark.brown314@gmail.com>
 <AANLkTimvudYv4fwyGWjL5c10QrM9GtC2SXjPZzcV20_s@mail.gmail.com>
 <AANLkTinEtFhC6kB3asuBXLxCgYf9yOTLTTwRQJXKcu2n@mail.gmail.com>
 <AANLkTi=0ECTN8ro3H6=CUZy5qzJjhC0C02yPKzS-+0r5@mail.gmail.com> <AANLkTi=RgZcykxPnUcneGfZnETo9nK_72Qoa=8rKh2rD@mail.gmail.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 31 Aug 2010 15:15:44 +0800
Message-ID: <AANLkTi==d-YW4mVT7Pvr_NqfiHeXZ=DZjv69Z_Dhg6Gb@mail.gmail.com>
Subject: Re: [PATCH 4/5] ARM: pxa168: added special case handler for keypad interrupts
To: "Mark F. Brown" <mark.brown314@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 3:13 PM, Mark F. Brown <mark.brown314@gmail.com> wrote:
> On Tue, Aug 31, 2010 at 3:05 AM, Eric Miao <eric.y.miao@gmail.com> wrote:
>> On Tue, Aug 31, 2010 at 2:28 PM, Mark F. Brown <mark.brown314@gmail.com> wrote:
>>> On Tue, Aug 31, 2010 at 12:53 AM, Haojian Zhuang
>>> <haojian.zhuang@gmail.com> wrote:
>>>> On Thu, Aug 26, 2010 at 5:18 PM, Mark F. Brown <mark.brown314@gmail.com> wrote:
>>>>> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
>>>>> ---
>>>>>  arch/arm/mach-mmp/irq-pxa168.c |   23 ++++++++++++++++++++++-
>>>>>  1 files changed, 22 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm/mach-mmp/irq-pxa168.c b/arch/arm/mach-mmp/irq-pxa168.c
>>>>> index 52ff2f0..bfb0984 100644
>>>>> --- a/arch/arm/mach-mmp/irq-pxa168.c
>>>>> +++ b/arch/arm/mach-mmp/irq-pxa168.c
>>>>> @@ -17,6 +17,8 @@
>>>>>  #include <linux/io.h>
>>>>>
>>>>>  #include <mach/regs-icu.h>
>>>>> +#include <mach/regs-apmu.h>
>>>>> +#include <mach/cputype.h>
>>>>>
>>>>>  #include "common.h"
>>>>>
>>>>> @@ -42,6 +44,19 @@ static struct irq_chip icu_irq_chip = {
>>>>>        .unmask = icu_unmask_irq,
>>>>>  };
>>>>>
>>>>> +void handle_pxa168_keypad_irq(unsigned int irq, struct irq_desc *desc)
>>>>> +{
>>>>> +       uint32_t val;
>>>>> +       uint32_t mask = APMU_PXA168_KP_WAKE_CLR;
>>>>> +
>>>>> +       /* clear keypad wake event */
>>>>> +       val = __raw_readl(APMU_WAKE_CLR);
>>>>> +       __raw_writel(val |  mask, APMU_WAKE_CLR);
>>>>> +
>>>>> +       /* handle irq */
>>>>> +       handle_level_irq(irq, desc);
>>>>> +}
>>>>> +
>>>>
>>>> Why should you clear wakeup event status in IRQ handler? If system is
>>>> resumed by keypad event, you should clear this wakeup source in resume
>>>> code. I think that IRQ code should not be binded with wakeup event at
>>>> here.
>>>>
>>>>>  void __init icu_init_irq(void)
>>>>>  {
>>>>>        int irq;
>>>>> @@ -49,7 +64,13 @@ void __init icu_init_irq(void)
>>>>>        for (irq = 0; irq < 64; irq++) {
>>>>>                icu_mask_irq(irq);
>>>>>                set_irq_chip(irq, &icu_irq_chip);
>>>>> -               set_irq_handler(irq, handle_level_irq);
>>>>> +
>>>>> +               /* special handler for keypad */
>>>>> +               if (cpu_is_pxa168() && irq == IRQ_PXA168_KEYPAD)
>>>>> +                       set_irq_handler(irq, handle_pxa168_keypad_irq);
>>>>> +               else
>>>>> +                       set_irq_handler(irq, handle_level_irq);
>>>>> +
>>>>>                set_irq_flags(irq, IRQF_VALID);
>>>>>        }
>>>>>  }
>>>>> --
>>>>> 1.7.0.4
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>>
>>>>
>>>
>>> Haojian, this is an usual case, but without that clear wake event you
>>> will not be able to clear the keypad interrupt. For my push to open
>>> source I re-wrote the workaround code and added it as a special case
>>> IRQ handler. In the Marvell pxa168 code base it is actually located in
>>> the keypad interrupt handler as the function clear_wakeup(). I felt it
>>> was better to isolate this code in the mmp common code base instead.
>>
>> I'd rather the irq handler not being changed and use platform_data instead.
>> How about something below:
>>
>> diff --git a/arch/arm/mach-mmp/include/mach/pxa168.h
>> b/arch/arm/mach-mmp/include/mach/pxa168.h
>> index 27e1bc7..d2b7946 100644
>> --- a/arch/arm/mach-mmp/include/mach/pxa168.h
>> +++ b/arch/arm/mach-mmp/include/mach/pxa168.h
>> @@ -5,6 +5,7 @@ struct sys_timer;
>>
>>  extern struct sys_timer pxa168_timer;
>>  extern void __init pxa168_init_irq(void);
>> +extern void pxa168_clear_keypad_wakeup(void);
>>
>>  #include <linux/i2c.h>
>>  #include <mach/devices.h>
>> @@ -97,4 +98,10 @@ static inline int pxa168_add_nand(struct
>> pxa3xx_nand_platform_data *info)
>>  {
>>        return pxa_register_device(&pxa168_device_nand, info, sizeof(*info));
>>  }
>> +
>> +static inline int pxa168_add_keypad(struct pxa27x_keypad_platform_data *info)
>> +{
>> +       info->clear_wakeup = pxa168_clear_keypad_wakeup;
>> +       return pxa_register_device(&pxa168_device_keypad, info, sizeof(*info));
>> +}
>>  #endif /* __ASM_MACH_PXA168_H */
>> diff --git a/arch/arm/mach-pxa/include/mach/pxa27x_keypad.h
>> b/arch/arm/mach-pxa/include/mach/pxa27x_keypad.h
>> index 7b4eadc..3a6bfe7 100644
>> --- a/arch/arm/mach-pxa/include/mach/pxa27x_keypad.h
>> +++ b/arch/arm/mach-pxa/include/mach/pxa27x_keypad.h
>> @@ -52,6 +52,7 @@ struct pxa27x_keypad_platform_data {
>>
>>        /* key debounce interval */
>>        unsigned int    debounce_interval;
>> +       void            (*clear_wakeup);
>>  };
>>
>>  extern void pxa_set_keypad_info(struct pxa27x_keypad_platform_data *info);
>> diff --git a/drivers/input/keyboard/pxa27x_keypad.c
>> b/drivers/input/keyboard/pxa27x_keypad.c
>> index f32404f..3fb94fe 100644
>> --- a/drivers/input/keyboard/pxa27x_keypad.c
>> +++ b/drivers/input/keyboard/pxa27x_keypad.c
>> @@ -330,10 +330,20 @@ static void pxa27x_keypad_scan_direct(struct
>> pxa27x_keypad *keypad)
>>        keypad->direct_key_state = new_state;
>>  }
>>
>> +static void clear_wakeup(struct pxa27x_keypad *keypad)
>> +{
>> +       struct pxa27x_keypad_platform_data *pdata = keypad->pdata;
>> +
>> +       if (pdata->clear_wakeup)
>> +               (pdata->clear_wakeup)();
>> +}
>> +
>>  static irqreturn_t pxa27x_keypad_irq_handler(int irq, void *dev_id)
>>  {
>>        struct pxa27x_keypad *keypad = dev_id;
>> -       unsigned long kpc = keypad_readl(KPC);
>> +       unsigned long kpc;
>> +
>> +       kpc = keypad_readl(KPC);
>>
>>        if (kpc & KPC_DI)
>>                pxa27x_keypad_scan_direct(keypad);
>>
>
> Ok if you are fine with that I will make that change and resubmit!
>

Thanks.
