Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263Ab1IKOwA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 10:52:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:54454 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab1IKOv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 10:51:58 -0400
Subject: Re: [patch v3 21/36] Hexagon: Add SMP support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linas Vepstas <linas@codeaurora.org>
In-Reply-To: <20110909010916.709728186@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org>
	 <20110909010916.709728186@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Sep 2011 11:51:52 -0300
Message-ID: <1315752712.455.50.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-08 at 20:09 -0500, Richard Kuo wrote:

> +irqreturn_t handle_ipi(int irq, void *desc)
> +{
> +	int cpu = smp_processor_id();
> +	struct ipi_data *ipi = &per_cpu(ipi_data, cpu);
> +	unsigned long ops;
> +
> +	while ((ops = xchg(&ipi->bits, 0)) != 0)
> +		__handle_ipi(&ops, ipi, cpu);
> +	return IRQ_HANDLED;
> +}

So on the consumer side you are using xchg() ...

> +void send_ipi(const struct cpumask *cpumask, enum ipi_message_type msg)
> +{
> +	unsigned long flags;
> +	unsigned long cpu;
> +	unsigned long retval;
> +
> +	local_irq_save(flags);
> +
> +	for_each_cpu(cpu, cpumask) {
> +		struct ipi_data *ipi = &per_cpu(ipi_data, cpu);
> +
> +		spin_lock(&ipi->lock);
> +		ipi->bits |= 1 << msg;  /*  one bit per message  */
> +		spin_unlock(&ipi->lock);
> +
> +		retval = __vmintop_post(BASE_IPI_IRQ+cpu);
> +		if (retval != 0) {
> +			printk(KERN_ERR "interrupt %ld not configured?\n",
> +				BASE_IPI_IRQ+cpu);
> +		}
> +	}
> +
> +	local_irq_restore(flags);
> +}

And on the producer side, a spinlock for one or... that looks like wheel
re-inventing to me :-)

In fact your bit iteration loop also re-invents find_*_bit interfaces.

Any reason why you don't simply use bitops or atomics here ?

Also what is your memory model ? ordered or weakly ordered ? Do you need
some kind of memory barrier between setting ipi->bits and
__vmintop_post() ?

Cheers,
Ben.


