Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2IZPso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 11:48:44 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56738 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab2IZPsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 11:48:43 -0400
Message-ID: <506323AD.4070509@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2012 21:17:57 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Chuansheng Liu <chuansheng.liu@intel.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH RESEND] x86/fixup_irq: Clean the offlining CPU from the
 irq affinity mask
References: <1348681092.19514.10.camel@cliu38-desktop-build> <1348703122.19514.17.camel@cliu38-desktop-build>
In-Reply-To: <1348703122.19514.17.camel@cliu38-desktop-build>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092615-3864-0000-0000-000004CD9BD7
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
> Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

:-)

OK, so here is the general rule: You shouldn't automatically add
Reviewed-by tags.. You can include them only if the reviewer _explicitly_
lets you know that he is fine with the patch. Often, review happens in
multiple iterations/stages. So just because you addressed all the review
comments raised in iteration 'n' doesn't mean there won't be issues in
iteration 'n+1', perhaps because the way you addressed the concern might
not be the best approach.. or the reviewer might find more issues in
iteration 'n+1' which he might have over-looked in iteration 'n'.
So please refrain from adding such tags automatically!

> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
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

This last check is superfluous, because it already checks if 'affinity'
is a subset of cpu_online_mask. Note that this cpu was already removed
from the cpu_online_mask before coming here.

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

It is good to avoid allocating huge cpumask bitmasks like this on stack.
If we really can't do without a temp mask, you could perhaps do something like:
		cpumask_var_t mask;

		alloc_cpumask_var(&mask, GFP_ATOMIC);

> +			cpumask_copy(&mask, affinity);
> +			cpumask_clear_cpu(cpu, &mask);
> +			switch (chip->irq_set_affinity(data, &mask, true)) {
> +			case IRQ_SET_MASK_OK:
> +				cpumask_copy(data->affinity, &mask);

This is again not required. __ioapic_set_affinity() copies the mask for you.
(And __ioapic_set_affinity() is called in every ->irq_set_affinity implementation,
if I read the source code correctly).


Regards,
Srivatsa S. Bhat

> +			case IRQ_SET_MASK_OK_NOCOPY:
> +				set_ret = true;
> +			}
> +		}
> +		if ((!set_ret) && !(warned++))
>  			set_affinity = 0;
> 
>  		/*
> 

