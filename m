Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab2IZQEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:04:39 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:46549 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab2IZQEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:04:38 -0400
Message-ID: <50632767.5050607@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2012 21:33:51 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Chuansheng Liu <chuansheng.liu@intel.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: [PATCH RESEND] x86/fixup_irq: Clean the offlining CPU from the
 irq affinity mask
References: <1348681092.19514.10.camel@cliu38-desktop-build> <1348703122.19514.17.camel@cliu38-desktop-build>
In-Reply-To: <1348703122.19514.17.camel@cliu38-desktop-build>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092616-9574-0000-0000-00000499214A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 05:15 AM, Chuansheng Liu wrote:
> 
> When one CPU is going offline, and fixup_irqs() will re-set the
> irq affinity in some cases, we should clean the offlining CPU from
> the irq affinity.
> 
> The reason is setting offlining CPU as of the affinity is useless.
> Moreover, the smp_affinity value will be confusing when the
> offlining CPU come back again.
> 
> Example:
> For irq 93 with 4 CPUS, the default affinity f(1111),
> normal cases: 4 CPUS will receive the irq93 interrupts.
> 
> When echo 0 > /sys/devices/system/cpu/cpu3/online, just CPU0,1,2 will
> receive the interrupts.
> 
> But after the CPU3 is online again, we will not set affinity,the result
> will be:
> the smp_affinity is f, but still just CPU0,1,2 can receive the interrupts.
> 
> So we should clean the offlining CPU from irq affinity mask
> in fixup_irqs().
> 

I have some fundamental questions here:
1. Why was the CPU never removed from the affinity masks in the original
code? I find it hard to believe that it was just an oversight, because the
whole point of fixup_irqs() is to affine the interrupts to other CPUs, IIUC.
So, is that really a bug or is the existing code correct for some reason
which I don't know of?

2. In case this is indeed a bug, why are the warnings ratelimited when the
interrupts can't be affined to other CPUs? Are they not serious enough to
report? Put more strongly, why do we even silently return with a warning
instead of reporting that the CPU offline operation failed?? Is that because
we have come way too far in the hotplug sequence and we can't easily roll
back? Or are we still actually OK in that situation?

Suresh, I'd be grateful if you could kindly throw some light on these
issues... I'm actually debugging an issue where an offline CPU gets apic timer
interrupts (and in one case, I even saw a device interrupt), which I have
reported in another thread at: https://lkml.org/lkml/2012/9/26/119
But this issue in fixup_irqs() that Liu brought to light looks even more
surprising to me..

Regards,
Srivatsa S. Bhat

> ---
>  arch/x86/kernel/irq.c |   21 +++++++++++++++++----
>  1 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index d44f782..ead0807 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -239,10 +239,13 @@ void fixup_irqs(void)
>  	struct irq_desc *desc;
>  	struct irq_data *data;
>  	struct irq_chip *chip;
> +	int cpu = smp_processor_id();
> 
>  	for_each_irq_desc(irq, desc) {
>  		int break_affinity = 0;
>  		int set_affinity = 1;
> +		bool set_ret = false;
> +
>  		const struct cpumask *affinity;
> 
>  		if (!desc)
> @@ -256,7 +259,8 @@ void fixup_irqs(void)
>  		data = irq_desc_get_irq_data(desc);
>  		affinity = data->affinity;
>  		if (!irq_has_action(irq) || irqd_is_per_cpu(data) ||
> -		    cpumask_subset(affinity, cpu_online_mask)) {
> +		    cpumask_subset(affinity, cpu_online_mask) ||
> +		    !cpumask_test_cpu(cpu, data->affinity)) {
>  			raw_spin_unlock(&desc->lock);
>  			continue;
>  		}
> @@ -277,9 +281,18 @@ void fixup_irqs(void)
>  		if (!irqd_can_move_in_process_context(data) && chip->irq_mask)
>  			chip->irq_mask(data);
> 
> -		if (chip->irq_set_affinity)
> -			chip->irq_set_affinity(data, affinity, true);
> -		else if (!(warned++))
> +		if (chip->irq_set_affinity) {
> +			struct cpumask mask;
> +			cpumask_copy(&mask, affinity);
> +			cpumask_clear_cpu(cpu, &mask);
> +			switch (chip->irq_set_affinity(data, &mask, true)) {
> +			case IRQ_SET_MASK_OK:
> +				cpumask_copy(data->affinity, &mask);
> +			case IRQ_SET_MASK_OK_NOCOPY:
> +				set_ret = true;
> +			}
> +		}
> +		if ((!set_ret) && !(warned++))
>  			set_affinity = 0;
> 
>  		/*
> 


