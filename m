Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab1I0Xla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 19:41:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:57178 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1I0Xl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 19:41:27 -0400
Date: Wed, 28 Sep 2011 01:41:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Salter <msalter@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v3 11/24] C6X: time management
In-Reply-To: <1317155405-26235-12-git-send-email-msalter@redhat.com>
Message-ID: <alpine.LFD.2.02.1109280130570.2711@ionos>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <1317155405-26235-12-git-send-email-msalter@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011, Mark Salter wrote:

> The C6X architecture includes a 64-bit free running core clock counter which
> is used as the clocksource. The SoCs have a number of 64-bit programmable
> timers. One of these is used as the clockevent timer.
> 
> + *  Port on Texas Instruments TMS320C6x architecture
> + *
> + *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
> + *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
> + *
> + *  Modified for 2.6.34: Mark Salter <msalter@redhat.com>

Hmm. Who wrote that code and who is assigned the authorship? If the
original Author is Aurelian, then this patch is missing:

  - An extra From: ....

  - A SOB from the orginal author or an explnation why it's not
    available.

If not, then this want's to be documented in a proper form.

Please do not attribute other peoples code to yourself w/o a fcking
good reason. And porting forward itself is not considered to be one.

> +/*
> + * This should be close enough...

What's the point of that comment ?

> + */
> +#define CLOCK_TICK_RATE ((1000 * 1000000UL) / 6)
> +
> +/* 64-bit timestamp */
> +typedef unsigned long long cycles_t;

...

> +static int next_event(unsigned long delta,
> +		      struct clock_event_device *evt)
> +{
> +	soc_writel(soc_readl(&timer->tcr) & ~TCR_ENAMODELO_MASK, &timer->tcr);
> +	soc_writel(delta - 1, &timer->prdlo);
> +	soc_writel(0, &timer->cntlo);
> +	soc_writel(soc_readl(&timer->tcr) | TCR_ENAMODELO_ONCE, &timer->tcr);
> +
> +	return 0;
> +}
> +
> +static void set_clock_mode(enum clock_event_mode mode,
> +			   struct clock_event_device *evt)
> +{

So there is no way to disable that thing ?

> +}
> +
> +static struct clock_event_device t64_clockevent_device = {
> +	.name		= "TIMER64_EVT32_TIMER",
> +	.features	= CLOCK_EVT_FEAT_ONESHOT,
> +	.rating		= 200,
> +	.set_mode	= set_clock_mode,
> +	.set_next_event	= next_event,
> +};
> +
> +static irqreturn_t timer_interrupt(int irq, void *dev_id)
> +{
> +	struct clock_event_device *cd = &t64_clockevent_device;

If proper set up, then you can just hand in dev_id to the handler.

> +
> +	cd->event_handler(cd);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static struct irqaction timer_iact = {
> +	.name		= "timer",
> +	.flags		= IRQF_TIMER,
> +	.handler	= timer_interrupt,
> +	.dev_id		= &t64_clockevent_device,

Which seems to be the case :)

Thanks,

	tglx
