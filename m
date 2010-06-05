Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362Ab0FEN4H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 09:56:07 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58723 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab0FEN4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 09:56:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B9HVYCeiXksoRr/R6F3rLs58QaqYc2uijCg6PGaFGdwregV+yDVTe24dKb3gVkoTy+
         BxiprKLiyUR6Bmg0vU4HyckbabVUKAvyPFEjUaeQ1gc6L6OzUw/yBbovgTf6AGggOqVe
         kvLbfMiw6OwvoohHxpF+zeTI6TKM+nm/cGMtw=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006042343150.2933@localhost.localdomain>
References: <1275686352.2970.2.camel@eha.doredevelopment.dk>
	<alpine.LFD.2.00.1006042343150.2933@localhost.localdomain>
Date: Sat, 5 Jun 2010 15:56:01 +0200
Message-ID: <AANLkTilb7---Qg1oLwzanKP1RGe04fkAXDtZzz0w9MGz@mail.gmail.com>
Subject: Re: [RFC][PATCH] irq: support IRQ_NESTED_THREAD with non-threaded 
	interrupt handlers
From: Esben Haabendal <esbenhaabendal@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Esben Haabendal <eha@doredevelopment.dk>, linux-kernel@vger.kernel.org,
       maz@misterjones.org, mingo@elte.hu, joachim.eastwood@jotron.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a board with an I2C PCA9535 chip with two PHY interrupt lines
hooked up to. The pca953x driver calls set_irq_nested_thread on all
irq's on initialization. The PHY driver then calls request_irq, and has
no idea that it should actually be using a threaded handler.

With this patch, the PHY driver is able to work in this scenario
without changes (and so should any other driver using request_irq).

/Esben

On Fri, Jun 4, 2010 at 11:46 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 4 Jun 2010, Esben Haabendal wrote:
>
>> set_irq_nested_thread() might be called by interrupt controller to
>> supported nested irq thread handling, and with this change, drivers
>> with non-threaded irq handlers can still use the irqs.
>
> What's the problem you are trying to solve ? The above changelog is
> not very useful ?
>
> Thanks,
>
>        tglx
>
>> Signed-off-by: Esben Haabendal <eha@doredevelopment.dk>
>> ---
>>  kernel/irq/chip.c   |    9 ++++++++-
>>  kernel/irq/manage.c |    4 +---
>>  2 files changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
>> index b7091d5..8202993 100644
>> --- a/kernel/irq/chip.c
>> +++ b/kernel/irq/chip.c
>> @@ -405,7 +405,14 @@ void handle_nested_irq(unsigned int irq)
>>       desc->status |= IRQ_INPROGRESS;
>>       raw_spin_unlock_irq(&desc->lock);
>>
>> -     action_ret = action->thread_fn(action->irq, action->dev_id);
>> +     if (desc->status & IRQ_NESTED_THREAD && action->thread_fn)
>> +             action_ret = action->thread_fn(action->irq, action->dev_id);
>> +     else {
>> +             local_irq_disable();
>> +             action_ret = action->handler(action->irq, action->dev_id);
>> +             local_irq_enable();
>> +     }
>> +
>>       if (!noirqdebug)
>>               note_interrupt(irq, desc, action_ret);
>>
>> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
>> index 3164ba7..e7bca04 100644
>> --- a/kernel/irq/manage.c
>> +++ b/kernel/irq/manage.c
>> @@ -681,10 +681,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>>        * Check whether the interrupt nests into another interrupt
>>        * thread.
>>        */
>> -     nested = desc->status & IRQ_NESTED_THREAD;
>> +     nested = (desc->status & IRQ_NESTED_THREAD) && new->thread_fn;
>>       if (nested) {
>> -             if (!new->thread_fn)
>> -                     return -EINVAL;
>>               /*
>>                * Replace the primary handler which was provided from
>>                * the driver for non nested interrupt handling by the
>> --
>> 1.7.1
>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Esben Haabendal, Senior Software Consultant
DoréDevelopment ApS, Ved Stranden 1, 9560 Hadsund, DK-Denmark
Phone: +45 51 92 53 93, E-mail: eha@doredevelopment.dk
WWW: http://www.doredevelopment.dk
