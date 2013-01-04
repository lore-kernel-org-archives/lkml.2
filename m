Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3ADKGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 05:06:32 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:41390 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab3ADKG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 05:06:28 -0500
Message-ID: <50E6A987.207@synopsys.com>
Date: Fri, 4 Jan 2013 15:35:59 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 22/44] metag: Time keeping
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com> <1354723742-6195-23-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1354723742-6195-23-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Wednesday 05 December 2012 09:38 PM, James Hogan wrote:

> +static unsigned int hwtimer_freq = HARDWARE_FREQ;
> +static DEFINE_PER_CPU(struct clock_event_device, local_clockevent);
> +static DEFINE_PER_CPU(char [11], local_clockevent_name);

> +void __cpuinit local_timer_setup(unsigned int cpu)
> +{
> +	unsigned int txdivtime;
> +	struct clock_event_device *clk = &per_cpu(local_clockevent, cpu);
> +	char *name = per_cpu(local_clockevent_name, cpu);
> +
> +	txdivtime = TBI_GETREG(TXDIVTIME);
> +
> +	txdivtime &= ~TXDIVTIME_DIV_BITS;
> +	txdivtime |= (HARDWARE_DIV & TXDIVTIME_DIV_BITS);
> +
> +	TBI_SETREG(TXDIVTIME, txdivtime);
> +
> +	sprintf(name, "META %d", cpu);
> +	clk->name = name;
> +	clk->features = CLOCK_EVT_FEAT_ONESHOT,
> +
> +	clk->rating = 200,
> +	clk->shift = 12,
> +	clk->irq = TBID_SIGNUM_TRT,
> +	clk->set_mode = metag_timer_set_mode,
> +	clk->set_next_event = metag_timer_set_next_event,
> +
> +	clk->mult = div_sc(hwtimer_freq, NSEC_PER_SEC, clk->shift);
> +	clk->max_delta_ns = clockevent_delta2ns(0x7fffffff, clk);
> +	clk->min_delta_ns = clockevent_delta2ns(0xf, clk);
> +	clk->cpumask = cpumask_of(cpu);
> +
> +	clockevents_register_device(clk);
> +
> +	/*
> +	 * For all non-boot CPUs we need to synchronize our free
> +	 * running clock (TXTIMER) with the boot CPU's clock.
> +	 *
> +	 * While this won't be accurate, it should be close enough.
> +	 */
> +	if (cpu) {
> +		unsigned int thread0 = cpu_2_hwthread_id[0];
> +		unsigned long val;
> +
> +		val = core_reg_read(TXUCT_ID, TXTIMER_REGNUM, thread0);
> +
> +		asm volatile("MOV TXTIMER, %0\n" : : "r" (val));
> +	}
> +}
> +
> +void __init time_init(void)
> +{
> +	/*
> +	 * On Meta 2 SoCs, the actual frequency of the timer is based on the
> +	 * Meta core clock speed divided by an integer, so it is only
> +	 * approximately 1MHz. Calculating the real frequency here drastically
> +	 * reduces clock skew on these SoCs.
> +	 */
> +#ifdef CONFIG_METAG_META21
> +	hwtimer_freq = get_coreclock() / (metag_in32(EXPAND_TIMER_DIV) + 1);
> +#endif
> +	clocksource_register_hz(&clocksource_metag, hwtimer_freq);
> +
> +	setup_irq(TBID_SIGNUM_TRT, &metag_timer_irq);
> +
> +	local_timer_setup(smp_processor_id());
> +}

I have a kludge in ARC port in this subsystem - which I hope you could help clear.

ARC also has a local timer device used for clockevent on each CPU. A one-time
setup_irq() with IRQF_PERCPU - would indeed setup the generic IRQ subsystem - for
making registration effective for all CPUs. However don't you need some per-cpu
magic - say enabling the IRQ at cpu or embedded interrupt controller level -
assuming you starts off with all IRQs disabled (which ARC Linux does).

So we end up using different APIs - request_percpu_irq() as equivalent of
setup_irq() on boot-cpu only and then each CPU calling enable_percpu_irq() to do
the local magic. request_percpu_irq() in turn requires an apriori call to
irq_set_percpu_devid().

https://lkml.org/lkml/2012/11/7/128

Do don't seem to be requiring all of this hence I'm wondering how it works for you!

-Vineet
