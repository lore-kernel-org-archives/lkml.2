Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab2E2ILf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 04:11:35 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:48409 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab2E2ILb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 04:11:31 -0400
Message-ID: <4FC48272.9040904@linux.vnet.ibm.com>
Date: Tue, 29 May 2012 13:31:54 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org, ralf@linux-mips.org, sshtylyov@mvista.com,
        david.daney@cavium.com, nikunj@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, axboe@kernel.dk, mingo@kernel.org,
        tglx@linutronix.de, peterz@infradead.org, akpm@linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [PATCH 08/10] SPARC: smp: remove call to ipi_call_lock_irq()/ipi_call_unlock_irq()
References: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com> <1338275765-3217-9-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1338275765-3217-9-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12052908-2000-0000-0000-000007BB60C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 12:46 PM, Yong Zhang wrote:

> From: Yong Zhang <yong.zhang@windriver.com>
> 
> 1) call_function.lock used in smp_call_function_many() is just to protect
>    call_function.queue and &data->refs, cpu_online_mask is outside of the
>    lock. And it's not necessary to protect cpu_online_mask,
>    because data->cpumask is pre-calculate and even if a cpu is brougt up
>    when calling arch_send_call_function_ipi_mask(), it's harmless because
>    validation test in generic_smp_call_function_interrupt() will take care
>    of it.
> 
> 2) For cpu down issue, stop_machine() will guarantee that no concurrent
>    smp_call_fuction() is processing.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: sparclinux@vger.kernel.org
> ---
>  arch/sparc/kernel/smp_64.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
> index f591598..60e745c 100644
> --- a/arch/sparc/kernel/smp_64.c
> +++ b/arch/sparc/kernel/smp_64.c
> @@ -124,9 +124,9 @@ void __cpuinit smp_callin(void)
>  	while (!cpumask_test_cpu(cpuid, &smp_commenced_mask))
>  		rmb();
> 
> -	ipi_call_lock_irq();
> +	local_irq_disable();


This looks odd. IRQs must not have been enabled at this point.
Just remove the call to local_irq_enable() that is found a few lines above
this line and then you won't have to add this call to local_irq_disable().

>  	set_cpu_online(cpuid, true);
> -	ipi_call_unlock_irq();
> +	local_irq_enable();
> 

>  	/* idle thread is expected to have preempt disabled */

>  	preempt_disable();
> @@ -1308,9 +1308,7 @@ int __cpu_disable(void)
>  	mdelay(1);
>  	local_irq_disable();
> 
> -	ipi_call_lock();
>  	set_cpu_online(cpu, false);
> -	ipi_call_unlock();
> 
>  	cpu_map_rebuild();
> 



Regards,
Srivatsa S. Bhat

