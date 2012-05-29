Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab2E2IbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 04:31:08 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:39492 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2E2IbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 04:31:05 -0400
Message-ID: <4FC48915.3000900@linux.vnet.ibm.com>
Date: Tue, 29 May 2012 14:00:13 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org, ralf@linux-mips.org, sshtylyov@mvista.com,
        david.daney@cavium.com, nikunj@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, axboe@kernel.dk, mingo@kernel.org,
        tglx@linutronix.de, peterz@infradead.org, akpm@linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [UPDATED] [RFC PATCH 08/10] SPARC: smp: remove call to ipi_call_lock_irq()/ipi_call_unlock_irq()
References: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com> <1338275765-3217-9-git-send-email-yong.zhang0@gmail.com> <4FC48272.9040904@linux.vnet.ibm.com> <20120529082732.GA4250@zhy>
In-Reply-To: <20120529082732.GA4250@zhy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052908-5816-0000-0000-000002E9515E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 01:57 PM, Yong Zhang wrote:

> On Tue, May 29, 2012 at 01:31:54PM +0530, Srivatsa S. Bhat wrote:
>> This looks odd. IRQs must not have been enabled at this point.
>> Just remove the call to local_irq_enable() that is found a few lines above
>> this line and then you won't have to add this call to local_irq_disable().
> 
> Yeah, have thought about it. But because I was not sure there is
> special need to enalbe irq that early (don't know much about sparc),
> I decided to make minor change :)
> 
> Since we have gotten confirmation from David, I'm sending out the
> new version. Please check it.
> 
> Thanks,
> Yong
> 
> ---
> From: Yong Zhang <yong.zhang@windriver.com>
> Date: Tue, 29 May 2012 12:56:08 +0800
> Subject: [UPDATED] [RFC PATCH 8/10] SPARC: smp: remove call to
>  ipi_call_lock_irq()/ipi_call_unlock_irq()
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
> And also delay irq enable to after set_cpu_online().
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: sparclinux@vger.kernel.org

> ---


Looks good.
Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

>  arch/sparc/kernel/smp_64.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
> index f591598..781bcb1 100644
> --- a/arch/sparc/kernel/smp_64.c
> +++ b/arch/sparc/kernel/smp_64.c
> @@ -103,8 +103,6 @@ void __cpuinit smp_callin(void)
>  	if (cheetah_pcache_forced_on)
>  		cheetah_enable_pcache();
> 
> -	local_irq_enable();
> -
>  	callin_flag = 1;
>  	__asm__ __volatile__("membar #Sync\n\t"
>  			     "flush  %%g6" : : : "memory");
> @@ -124,9 +122,8 @@ void __cpuinit smp_callin(void)
>  	while (!cpumask_test_cpu(cpuid, &smp_commenced_mask))
>  		rmb();
> 
> -	ipi_call_lock_irq();
>  	set_cpu_online(cpuid, true);
> -	ipi_call_unlock_irq();
> +	local_irq_enable();
> 
>  	/* idle thread is expected to have preempt disabled */
>  	preempt_disable();
> @@ -1308,9 +1305,7 @@ int __cpu_disable(void)
>  	mdelay(1);
>  	local_irq_disable();
> 
> -	ipi_call_lock();
>  	set_cpu_online(cpu, false);
> -	ipi_call_unlock();
> 
>  	cpu_map_rebuild();
> 

