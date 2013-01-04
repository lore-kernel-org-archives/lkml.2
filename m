Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab3ADMWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 07:22:01 -0500
Received: from multi.imgtec.com ([194.200.65.239]:54483 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab3ADMV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 07:21:58 -0500
Message-ID: <50E6C961.40009@imgtec.com>
Date: Fri, 4 Jan 2013 12:21:53 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 22/44] metag: Time keeping
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com> <1354723742-6195-23-git-send-email-james.hogan@imgtec.com> <50E6A987.207@synopsys.com>
In-Reply-To: <50E6A987.207@synopsys.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_04_12_21_54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/13 10:05, Vineet Gupta wrote:
> Hi James,
> 
> On Wednesday 05 December 2012 09:38 PM, James Hogan wrote:
> 
>> +static unsigned int hwtimer_freq = HARDWARE_FREQ;
>> +static DEFINE_PER_CPU(struct clock_event_device, local_clockevent);
>> +static DEFINE_PER_CPU(char [11], local_clockevent_name);
> 
>> +void __cpuinit local_timer_setup(unsigned int cpu)
>> +{
>> +	unsigned int txdivtime;
>> +	struct clock_event_device *clk = &per_cpu(local_clockevent, cpu);
>> +	char *name = per_cpu(local_clockevent_name, cpu);
>> +
>> +	txdivtime = TBI_GETREG(TXDIVTIME);
>> +
>> +	txdivtime &= ~TXDIVTIME_DIV_BITS;
>> +	txdivtime |= (HARDWARE_DIV & TXDIVTIME_DIV_BITS);
>> +
>> +	TBI_SETREG(TXDIVTIME, txdivtime);
>> +
>> +	sprintf(name, "META %d", cpu);
>> +	clk->name = name;
>> +	clk->features = CLOCK_EVT_FEAT_ONESHOT,
>> +
>> +	clk->rating = 200,
>> +	clk->shift = 12,
>> +	clk->irq = TBID_SIGNUM_TRT,
>> +	clk->set_mode = metag_timer_set_mode,
>> +	clk->set_next_event = metag_timer_set_next_event,
>> +
>> +	clk->mult = div_sc(hwtimer_freq, NSEC_PER_SEC, clk->shift);
>> +	clk->max_delta_ns = clockevent_delta2ns(0x7fffffff, clk);
>> +	clk->min_delta_ns = clockevent_delta2ns(0xf, clk);
>> +	clk->cpumask = cpumask_of(cpu);
>> +
>> +	clockevents_register_device(clk);
>> +
>> +	/*
>> +	 * For all non-boot CPUs we need to synchronize our free
>> +	 * running clock (TXTIMER) with the boot CPU's clock.
>> +	 *
>> +	 * While this won't be accurate, it should be close enough.
>> +	 */
>> +	if (cpu) {
>> +		unsigned int thread0 = cpu_2_hwthread_id[0];
>> +		unsigned long val;
>> +
>> +		val = core_reg_read(TXUCT_ID, TXTIMER_REGNUM, thread0);
>> +
>> +		asm volatile("MOV TXTIMER, %0\n" : : "r" (val));
>> +	}
>> +}
>> +
>> +void __init time_init(void)
>> +{
>> +	/*
>> +	 * On Meta 2 SoCs, the actual frequency of the timer is based on the
>> +	 * Meta core clock speed divided by an integer, so it is only
>> +	 * approximately 1MHz. Calculating the real frequency here drastically
>> +	 * reduces clock skew on these SoCs.
>> +	 */
>> +#ifdef CONFIG_METAG_META21
>> +	hwtimer_freq = get_coreclock() / (metag_in32(EXPAND_TIMER_DIV) + 1);
>> +#endif
>> +	clocksource_register_hz(&clocksource_metag, hwtimer_freq);
>> +
>> +	setup_irq(TBID_SIGNUM_TRT, &metag_timer_irq);
>> +
>> +	local_timer_setup(smp_processor_id());
>> +}
> 
> I have a kludge in ARC port in this subsystem - which I hope you could help clear.
> 
> ARC also has a local timer device used for clockevent on each CPU. A one-time
> setup_irq() with IRQF_PERCPU - would indeed setup the generic IRQ subsystem - for
> making registration effective for all CPUs. However don't you need some per-cpu
> magic - say enabling the IRQ at cpu or embedded interrupt controller level -
> assuming you starts off with all IRQs disabled (which ARC Linux does).

Hi Vineet,

For Meta this is done in secondary_start_kernel in
arch/metag/kernel/smp.c (see
https://github.com/jahogan/metag-linux/blob/metag-core/arch/metag/kernel/smp.c#L276).
It uses tbi_startup_interrupt which is also called by the irq_startup
callback for the root irq_chip.

> So we end up using different APIs - request_percpu_irq() as equivalent of
> setup_irq() on boot-cpu only and then each CPU calling enable_percpu_irq() to do
> the local magic. request_percpu_irq() in turn requires an apriori call to
> irq_set_percpu_devid().

For Meta we could probably do something similar if we moved it's root
irq_startup irq_chip callback code into irq_enable or irq_unmask.

Cheers
James

> 
> https://lkml.org/lkml/2012/11/7/128
> 
> Do don't seem to be requiring all of this hence I'm wondering how it works for you!
> 
> -Vineet
> 

