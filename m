Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab1ARQPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 11:15:48 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56060 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab1ARQPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 11:15:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=J4cYwYOFY6xjeBL8rsCXuXh6CCzXyejc1pNtDLA8371K2r9zyqxaGCYL0eAdx8Bc+G
         fDtO7wxkGBdLho1u3s9K4tEXc1z4QrR/SXnikvZJKsMHtj8kEhLecXWqigtldw70JAEq
         wz5vJ6gynQ2FD18Xpb398zNAHp9aKXtPn8xy0=
MIME-Version: 1.0
In-Reply-To: <4D357DC0.2030006@metafoo.de>
References: <1295338561.2003.3.camel@sven> <1295338738-4129-1-git-send-email-s.neumann@raumfeld.com>
 <4D357DC0.2030006@metafoo.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 18 Jan 2011 08:15:22 -0800
Message-ID: <AANLkTi=gGDZHukdSuupg22Gb9te+Vk_rsu6-vREeQRVE@mail.gmail.com>
Subject: Re: [PATCH] pxa3xx: fix PXA GPIO IRQ handling
To: Lars-Peter Clausen <lars@metafoo.de>,
        Lennert Buijtenhek <buytenh@wantstofly.org>
Cc: Sven Neumann <s.neumann@raumfeld.com>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@caiaq.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 3:47 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 01/18/2011 09:18 AM, Sven Neumann wrote:
>> From: Lars-Peter Clausen <lars@metafoo.de>
>>
>> Set the "set_wake" field of the irq_chip struct before calling
>> set_irq_chip() for all of the IRQs, so that the compat handler
>> actually gets installed.

Not really sure if this is necessary. Lennert has done the transition to
irq_data to those _set_wake() functions as well, so it should be OK
that compat handler doesn't get installed.

Now I'm not against moving this above, just wondering if there were
any consequences/errors coming out?

>>
>> Tested-by: Sven Neumann <s.neumann@raumfeld.com>
>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>
>> ---
>>  arch/arm/mach-pxa/irq.c    |    7 ++++---
>>  arch/arm/mach-pxa/pxa3xx.c |    4 ++--
>>  2 files changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
>> index 1beb40f..a5b42a7 100644
>> --- a/arch/arm/mach-pxa/irq.c
>> +++ b/arch/arm/mach-pxa/irq.c
>> @@ -111,13 +111,13 @@ static void __init pxa_init_low_gpio_irq(set_wake_t fn)
>>       GRER0 &= ~0x3;
>>       GEDR0 = 0x3;
>>
>> +     pxa_low_gpio_chip.set_wake = fn;
>> +
>>       for (irq = IRQ_GPIO0; irq <= IRQ_GPIO1; irq++) {
>>               set_irq_chip(irq, &pxa_low_gpio_chip);
>>               set_irq_handler(irq, handle_edge_irq);
>>               set_irq_flags(irq, IRQF_VALID);
>>       }
>> -
>> -     pxa_low_gpio_chip.set_wake = fn;
>>  }
>>
>>  void __init pxa_init_irq(int irq_nr, set_wake_t fn)
>> @@ -142,13 +142,14 @@ void __init pxa_init_irq(int irq_nr, set_wake_t fn)
>>       /* only unmasked interrupts kick us out of idle */
>>       ICCR = 1;
>>
>> +     pxa_internal_irq_chip.set_wake = fn;
>> +
>>       for (irq = PXA_IRQ(0); irq < PXA_IRQ(irq_nr); irq++) {
>>               set_irq_chip(irq, &pxa_internal_irq_chip);
>>               set_irq_handler(irq, handle_level_irq);
>>               set_irq_flags(irq, IRQF_VALID);
>>       }
>>
>> -     pxa_internal_irq_chip.set_wake = fn;
>>       pxa_init_low_gpio_irq(fn);
>>  }
>>
>> diff --git a/arch/arm/mach-pxa/pxa3xx.c b/arch/arm/mach-pxa/pxa3xx.c
>> index 276e8fb..5a8fe5c 100644
>> --- a/arch/arm/mach-pxa/pxa3xx.c
>> +++ b/arch/arm/mach-pxa/pxa3xx.c
>> @@ -567,13 +567,13 @@ static void __init pxa_init_ext_wakeup_irq(set_wake_t fn)
>>  {
>>       int irq;
>>
>> +     pxa_ext_wakeup_chip.set_wake = fn;
>> +
>>       for (irq = IRQ_WAKEUP0; irq <= IRQ_WAKEUP1; irq++) {
>>               set_irq_chip(irq, &pxa_ext_wakeup_chip);
>>               set_irq_handler(irq, handle_edge_irq);
>>               set_irq_flags(irq, IRQF_VALID);
>>       }
>> -
>> -     pxa_ext_wakeup_chip.set_wake = fn;
>>  }
>>
>>  void __init pxa3xx_init_irq(void)
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
