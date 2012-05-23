Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965293Ab2EWQCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:02:55 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58222 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965178Ab2EWQCw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:02:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAH3Oq6T905+3fkF43NAMMFvJvq7dsk_so6T2vQ8ZJrA5xiU3YA@mail.gmail.com>
References: <CAH3Oq6T-OVj_=kVBdDXxize5v5hovp8FQSDhxCHvF_kcX4QPuA@mail.gmail.com>
	<alpine.LFD.2.02.1205212308590.3231@ionos>
	<CAH3Oq6S64c9ttsAStn05FTkg+VC0o27Ad4DhHs=b4E7AKjWdjA@mail.gmail.com>
	<alpine.LFD.2.02.1205221048140.3231@ionos>
	<CAH3Oq6T905+3fkF43NAMMFvJvq7dsk_so6T2vQ8ZJrA5xiU3YA@mail.gmail.com>
Date: Thu, 24 May 2012 00:02:49 +0800
Message-ID: <CAH3Oq6QW-ku2EdCGrc9yHnYBdwYfNOkkCmgdpkq_d-FdrK-sng@mail.gmail.com>
Subject: Re: Add IRQS_PENDING for nested and simple irq handler as well
From: Ning Jiang <ning.n.jiang@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/22 Ning Jiang <ning.n.jiang@gmail.com>:
> 2012/5/22 Thomas Gleixner <tglx@linutronix.de>:
>> On Tue, 22 May 2012, Ning Jiang wrote:
>>
>> Please do not top post.
>>
>>> Sorry that I do not make myself clear.
>>>
>>> First, we should keep all the handle_*_irq behave in pretty much the
>>> same way even just for the beauty of it. Every interrupt disabled in
>>> suspend operation needs the ability to abort suspend if there is a
>>> pending irq.
>>>
>>> Second, let's take look at a example:
>>>
>>>               |
>>>        +---------+
>>>         |   INTC  |
>>>        +---------+
>>>                   |  GPIO_IRQ
>>>             +------------+
>>>              | gpio-exp  |
>>>             +------------+
>>>                |            |
>>>    GPIO0_IRQ  GPIO1_IRQ
>>>
>>> In the above diagram, gpio expander has irq number GPIO_IRQ, it is
>>> connected with two sub GPIO pins, GPIO0 and GPIO1.
>>>
>>> During suspend, normally we want to set IRQF_NO_SUSPEND for GPIO_IRQ
>>> so that gpio expander driver can handle the sub irq GPIO0_IRQ and
>>> GPIO1_IRQ, and these two irqs themselves are handled by simple or
>>> nested irq in some drivers(typically gpio and mfd driver), if they are
>>> disabled during suspend, we want them to be able to abort suspend too.
>>
>> Ok, that makes a lot of sense and should be part of the changelog, so
>> we know in a year from now why we did this change. Care to resend with
>> a fixed up changelog ?
>>
>> Thanks,
>>
>>        tglx
>
> Thanks for your guidance on commit changelog. It's really helpful.
> Here is the comments formatted patch, please help to review.
>
>
> From 40c31a11049726761fe5c7c629200f48950d4229 Mon Sep 17 00:00:00 2001
> From: Ning Jiang <ning.n.jiang@gmail.com>
> Date: Tue, 22 May 2012 00:19:20 +0800
> Subject: [PATCH] genirq: Add IRQS_PENDING for nested and simple irq
> handler as well
>
> We should keep all the handle_*_irq behave in pretty much the same
> way even just for the beauty of it. Every interrupt disabled in
> suspend operation needs the ability to abort suspend if there is a
> pending irq.
>
> Let's take look at an example:
>
>            |
>       +---------+
>       |   INTC  |
>       +---------+
>               | GPIO_IRQ
>            +------------+
>            |  gpio-exp  |
>            +------------+
>              |        |
>         GPIO0_IRQ  GPIO1_IRQ
>
> In the above diagram, gpio expander has irq number GPIO_IRQ, it is
> connected with two sub GPIO pins, GPIO0 and GPIO1.
>
> During suspend, normally we want to set IRQF_NO_SUSPEND for GPIO_IRQ
> so that gpio expander driver can handle the sub irq GPIO0_IRQ and
> GPIO1_IRQ, and these two irqs themselves can further be handled by
> simple or nested irq in some drivers(typically gpio and mfd driver).
> If they are disabled during suspend and used as wakeup sources, we
> want them to be able to abort suspend too.
>
> Set IRQS_PENDING flag in handle_nested_irq() and handle_simple_irq()
> when the irq is disabled will make check_wakeup_irqs() check for irqs
> like GPIO0_IRQ and GPIO1_IRQ to abort suspend.
>
> Signed-off-by: Ning Jiang <ning.n.jiang@gmail.com>
> ---
>  kernel/irq/chip.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index 741f836..5bec667 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -275,8 +275,10 @@ void handle_nested_irq(unsigned int irq)
>        kstat_incr_irqs_this_cpu(irq, desc);
>
>        action = desc->action;
> -       if (unlikely(!action || irqd_irq_disabled(&desc->irq_data)))
> +       if (unlikely(!action || irqd_irq_disabled(&desc->irq_data))) {
> +               desc->istate |= IRQS_PENDING;
>                goto out_unlock;
> +       }
>
>        irqd_set(&desc->irq_data, IRQD_IRQ_INPROGRESS);
>        raw_spin_unlock_irq(&desc->lock);
> @@ -324,8 +326,10 @@ handle_simple_irq(unsigned int irq, struct irq_desc *desc)
>        desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
>        kstat_incr_irqs_this_cpu(irq, desc);
>
> -       if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data)))
> +       if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
> +               desc->istate |= IRQS_PENDING;
>                goto out_unlock;
> +       }
>
>        handle_irq_event(desc);
>
> --
> 1.7.1
>
> Thanks,
> Ning

Hi Thomas,
Is there any problem to merge this patch?

Thanks,
Ning
