Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138Ab1IIOTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 10:19:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:34065 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1IIOTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 10:19:11 -0400
Date: Fri, 9 Sep 2011 16:19:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Salter <msalter@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ming.lei@canonical.com, stern@rowland.harvard.edu
Subject: Re: [PATCH 10/24] C6X: time management
In-Reply-To: <1314826019-22330-11-git-send-email-msalter@redhat.com>
Message-ID: <alpine.LFD.2.02.1109091612150.2723@ionos>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com> <1314826019-22330-11-git-send-email-msalter@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Aug 2011, Mark Salter wrote:
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
> +}
> +
> +static void event_handler(struct clock_event_device *dev)
> +{
> +}

You don't need a handler function. The core code sets one for you.

> +static irqreturn_t timer_interrupt(int irq, void *dev_id)
> +{
> +	struct clock_event_device *cd = &t64_clockevent_device;
> +
> +	cd->event_handler(cd);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +
> +void __init timer64_init(void)
> +{
> +	struct clock_event_device *cd = &t64_clockevent_device;
 ...
> +	cd->name	= "TIMER64_EVT32_TIMER";
> +	cd->features	= CLOCK_EVT_FEAT_ONESHOT;

Please move those into a static initializer of t64_clockevent_device.

> +	/* Calculate the min / max delta */
> +	/* Find a shift value */
> +	for (shift = 32; shift > 0; shift--) {
> +		temp = (u64)(c6x_core_freq / TIMER_DIVISOR);
> +		temp <<=  shift;
> +
> +		do_div(temp, NSEC_PER_SEC);
> +		if ((temp >> 32) == 0)
> +			break;
> +	}
> +	cd->shift = shift;
> +	cd->mult = (u32) temp;

  clockevents_calc_mult_shift() please

> +	cd->rating		= 200;
> +	cd->set_mode		= set_clock_mode;

  static initializer

> +	cd->event_handler	= event_handler;

  Please drop

> +	cd->set_next_event	= next_event;

  static initializer

> +	cd->cpumask		= cpumask_of(smp_processor_id());
> +
> +	clockevents_register_device(cd);
> +
> +	/* Set handler */
> +	if (cd->irq != NO_IRQ)

How does a timer device work w/o interrupt ?

> +		request_irq(cd->irq, timer_interrupt,
> +			    IRQF_DISABLED | IRQF_TIMER, "timer", NULL);

  Please drop IRQF_DISABLED it's about to vanish.

Thanks,

	tglx
