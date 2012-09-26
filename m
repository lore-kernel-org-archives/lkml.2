Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2IZIt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:49:56 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:45582 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab2IZItz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:49:55 -0400
Message-ID: <5062C183.20301@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2012 14:19:07 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Chuansheng Liu <chuansheng.liu@intel.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH RESEND] x86/fixup_irq: Clean the offlining CPU from the
 irq affinity mask
References: <1348681092.19514.10.camel@cliu38-desktop-build>
In-Reply-To: <1348681092.19514.10.camel@cliu38-desktop-build>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12092608-7014-0000-0000-000001F28884
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 11:08 PM, Chuansheng Liu wrote:
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

Please hold on.. I'm not yet done reviewing, I might have more comments :-)

> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  arch/x86/kernel/irq.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index d44f782..08bb905 100644
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
> @@ -277,8 +278,11 @@ void fixup_irqs(void)
>  		if (!irqd_can_move_in_process_context(data) && chip->irq_mask)
>  			chip->irq_mask(data);
> 
> -		if (chip->irq_set_affinity)
> -			chip->irq_set_affinity(data, affinity, true);
> +		if ((chip->irq_set_affinity) &&
> +			!chip->irq_set_affinity(data, affinity, true)) {

A return value of 0 and 1 are acceptable. So this check isn't correct.

Regards,
Srivatsa S. Bhat

> +			if (cpumask_test_cpu(cpu, data->affinity))
> +				cpumask_clear_cpu(cpu, data->affinity);

OMG, why did you drop the other hunk which cleared the cpu *before*
invoking ->irq_set_affinity()? IMO, altering irq affinity involves more work
than just altering the mask; that's why you have that ->irq_set_affinity()
function. So, if you alter the mask *after* calling ->irq_set_affinity(),
its not right.. 

Regards,
Srivatsa S. Bhat
 
> +		}
>  		else if (!(warned++))
>  			set_affinity = 0;
> 

