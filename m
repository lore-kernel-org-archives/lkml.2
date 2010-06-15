Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab0FOUM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 16:12:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754280Ab0FOUM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 16:12:57 -0400
Date: Tue, 15 Jun 2010 13:12:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Bean <gbean@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brown <davidb@codeaurora.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>
Subject: Re: [PATCH 2/2 v2] gpio: msm7200a: Add irq support to msm-gpiolib.
Message-Id: <20100615131225.7ea7437c.akpm@linux-foundation.org>
In-Reply-To: <1276301969-31385-3-git-send-email-gbean@codeaurora.org>
References: <1276301969-31385-1-git-send-email-gbean@codeaurora.org>
	<1276301969-31385-3-git-send-email-gbean@codeaurora.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 17:19:29 -0700
Gregory Bean <gbean@codeaurora.org> wrote:

>
> ...
>
> +/*
> + * The INT_STATUS register latches both edge- and level-detection events,
> + * which is atypical.  Turning on DONT_LATCH_LEVEL_IRQS causes level irq
> + * triggers to be forgotten across mask/unmask calls, emulating a more
> + * traditional setup.
> + */
> +#define MSM_GPIO_DONT_LATCH_LEVEL_IRQS 1

It's unusual to require a source-code edit to enable a compile-time
feature.

If this knob is actually useful then I'd suggest making it a Kconfig
thing.  Or, much much better, a module parameter settable at modprobe
time.  Or, much much better, a /sys knob (or whatever) which can be set
at runtime.  Or, much much better, just autodetect the desired
behaviour and don't hassle the nice users ;)

>
> ...
>
> +static int msm_gpio_irq_set_type(unsigned int irq, unsigned int flow_type)
> +{
> +	unsigned long irq_flags;
> +	struct msm_gpio_dev *msm_gpio = get_irq_chip_data(irq);
> +	unsigned offset = irq - msm_gpio->irq_base;
> +
> +	if ((flow_type & (IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING)) ==
> +		(IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING))
> +		return -ENOTSUPP;
> +
> +	if ((flow_type & (IRQF_TRIGGER_HIGH | IRQF_TRIGGER_LOW)) ==
> +		(IRQF_TRIGGER_HIGH | IRQF_TRIGGER_LOW))
> +		return -ENOTSUPP;

According to the code comments, ENOTSUPP is "Defined for the NFSv3
protocol".  I'd imagine that cellphone software developers who haven't
even configured nfs3 into their builds will get a bit puzzled if this
comes out.

I'd suggest using something simple and generic: EIO, EINVAL, etc.

>
> ...
>
> +static void msm_gpio_irq_mask_ack(unsigned int irq)
> +{
> +	msm_gpio_irq_mask(irq);
> +}
> +
> +static int msm_gpio_irq_set_affinity(unsigned int irq,
> +				const struct cpumask *dest)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static int msm_gpio_irq_retrigger(unsigned int irq)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static int msm_gpio_irq_set_wake(unsigned int irq, unsigned int on)
> +{
> +	return -ENOTSUPP;
> +}

dittoes.

> +static irqreturn_t msm_gpio_irq_handler(int irq, void *dev)
> +{
> +	unsigned long irq_flags;
> +	int b, m;
> +	unsigned e, s, v;
> +
> +	struct msm_gpio_dev *msm_gpio = (struct msm_gpio_dev *)dev;

Didn't need that blank line there.

Unneeded cast.

> +	/*
> +	 * The int_status register latches trigger events whether or not
> +	 * the gpio line is enabled as an interrupt source.  Therefore,
> +	 * the set of pins which defines the interrupts which need to fire
> +	 * is the intersection of int_status and int_en - int_status
> +	 * alone provides an incomplete picture.
> +	 */
> +	spin_lock_irqsave(&msm_gpio->lock, irq_flags);
> +	s = readl(msm_gpio->regs.int_status);
> +	e = readl(msm_gpio->regs.int_en);
> +	v = s & e;
> +	if (v)
> +		writel(v, msm_gpio->regs.int_clear);
> +	spin_unlock_irqrestore(&msm_gpio->lock, irq_flags);

Plain old spin_lock() is probably OK in the IRQ handler.  It won't be
interrupting itself.

> +	if (!v)
> +		return IRQ_NONE;
> +
> +	while (v) {
> +		m = v & -v;
> +		b = fls(m) - 1;
> +		v &= ~m;
> +		generic_handle_irq(msm_gpio->irq_base + b);
> +	}
> +	return IRQ_HANDLED;
> +}
> +
>
> ...
>

