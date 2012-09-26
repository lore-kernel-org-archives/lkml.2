Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab2IZGpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 02:45:11 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:43305 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab2IZGpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 02:45:02 -0400
Message-ID: <5062A442.2030207@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2012 12:14:18 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Chuansheng Liu <chuansheng.liu@intel.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] x86/fixup_irq: Clean the offlining CPU from the irq affinity
 mask
References: <1348669924.19514.6.camel@cliu38-desktop-build>
In-Reply-To: <1348669924.19514.6.camel@cliu38-desktop-build>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092606-9264-0000-0000-000002664302
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 08:02 PM, Chuansheng Liu wrote:
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
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  arch/x86/kernel/irq.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index d44f782..671d462 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -239,6 +239,7 @@ void fixup_irqs(void)
>  	struct irq_desc *desc;
>  	struct irq_data *data;
>  	struct irq_chip *chip;
> +	int cpu = smp_processor_id();
> 
>  	for_each_irq_desc(irq, desc) {
>  		int break_affinity = 0;
> @@ -271,7 +272,8 @@ void fixup_irqs(void)
>  		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
>  			break_affinity = 1;
>  			affinity = cpu_online_mask;
> -		}
> +		} else if (cpumask_test_cpu(cpu, data->affinity))
> +			cpumask_clear_cpu(cpu, data->affinity);
> 

You meant to use 'affinity' (instead of data->affinity) in the above 2 statements
right? Note that we do chip->irq_set_affinity(data, affinity, true); further down.

Regards,
Srivatsa S. Bhat

>  		chip = irq_data_get_irq_chip(data);
>  		if (!irqd_can_move_in_process_context(data) && chip->irq_mask)
> 

