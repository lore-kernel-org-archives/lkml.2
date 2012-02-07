Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab2BGNGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:06:37 -0500
Received: from smtp-out-121.synserver.de ([212.40.185.121]:1182 "EHLO
	smtp-out-108.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756288Ab2BGNGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:06:35 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 30098
Message-ID: <4F31220A.2050708@metafoo.de>
Date: Tue, 07 Feb 2012 14:07:22 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: Yong Zhang <yong.zhang0@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] genirq: Race condition in ONESHOT IRQ handler disabling
 IRQ forever
References: <20271.35831.227679.177366@ipc1.ka-ro> <20120207090305.GB32736@zhy> <20272.63074.235023.783459@ipc1.ka-ro> <20120207123455.GA2452@zhy> <20273.7808.730105.307619@ipc1.ka-ro>
In-Reply-To: <20273.7808.730105.307619@ipc1.ka-ro>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 01:52 PM, Lothar Waßmann wrote:
> Hi,
> 
> Yong Zhang writes:
>> On Tue, Feb 07, 2012 at 11:01:06AM +0100, Lothar Waßmann wrote:
>>> Hi,
>>>
>>>> On Mon, Feb 06, 2012 at 09:14:47AM +0100, Lothar Waßmann wrote:
>>>>> Hi,
>>>>>
>>>>> I already sent this to <linux-kernel@vger.kernel.org> on Feb. 1, 2012
>>>>> but did not get any response there. So resending to a wider audience
>>>>> with improved subject line:
>>>>>
>>>>> there is a race condition in the threaded IRQ handler code for oneshot
>>>>> interrupts that may lead to disabling an IRQ indefinitely. IRQs are
>>>>> masked before calling the hard-irq handler and are unmasked only after
>>>>> the soft-irq handler has been run. Thus if the hard-irq handler
>>>>> returns IRQ_HANDLED instead of IRQ_WAKE_THREAD, meaning the soft-irq
>>>>> will not be called, the interrupt will remain masked forever.
>>>>>
>>>>> This can happen due to a short pulse on the interrupt line, that
>>>>> triggers the interrupt logic, but goes undetected by the hard-irq
>>>>> handler. The problem can be reproduced with the TSC2007 touch
>>>>> controller driver that uses ONESHOT interrupts.
>>>>
>>>> Isn't it the responsibility of the driver (say TSC2007)?
>>>>
>>>> In this case, TSC2007 should return IRQ_WAKE_THREAD IMHO.
>>>>
>>> That would mean it had to return IRQ_WAKE_THREAD unconditionally
>>> making the return code useless.
>>> And it would cause an extra useless loop through the softirq
>>> handler.
>>
>> Yeah, it's the default behavior when we introduce 'theadirqs',
>> and it's safe.
>>
> So, the correct solution would be to remove the check for
> IRQ_WAKE_THREAD in handle_irq_event_percpu() and always invoke the
> softirq handler?
> Note that this problem is not specific to the TSC2007 driver, but may
> occur with any hardware.
> 
> Or maybe do the unmasking in handle_irq_event() as proposed by
> Lars-Peter Clausen in <4F2FAE93.5020205@metafoo.de>?
> Like that:
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index f7c543a..fbf68c7 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -343,6 +343,8 @@ EXPORT_SYMBOL_GPL(handle_simple_irq);
>  void
>  handle_level_irq(unsigned int irq, struct irq_desc *desc)
>  {
> +	int ret;

This should be irqreturn_t

> +
>  	raw_spin_lock(&desc->lock);
>  	mask_ack_irq(desc);
>  
> @@ -360,10 +362,12 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
>  	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data)))
>  		goto out_unlock;
>  
> -	handle_irq_event(desc);
> +	ret = handle_irq_event(desc);
>  
> -	if (!irqd_irq_disabled(&desc->irq_data) && !(desc->istate & IRQS_ONESHOT))
> +	if (!irqd_irq_disabled(&desc->irq_data) &&
> +		(!(desc->istate & IRQS_ONESHOT) || ret != IRQ_WAKE_THREAD))

As I said, check for the bit, not for the value. This will ensure that will
also work with shared interrupts. So something like this:

		!((desc->istate & IRQS_ONESHOT) && (ret & IRQ_WAKE_THREAD)))

>  		unmask_irq(desc);
> +
>  out_unlock:
>  	raw_spin_unlock(&desc->lock);
>  }
> 
> 
> Lothar Waßmann

