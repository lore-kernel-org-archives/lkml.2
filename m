Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab2FCLx7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 07:53:59 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:57792 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab2FCLx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 07:53:58 -0400
Message-ID: <4FCB5017.40001@linux.vnet.ibm.com>
Date: Sun, 03 Jun 2012 17:22:55 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        vatsa@linux.vnet.ibm.com, rjw@sisk.pl, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, nikunj@linux.vnet.ibm.com,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, linux-cris-kernel@axis.com
Subject: Re: [PATCH 23/27] cris, smpboot: Use generic SMP booting infrastructure
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091534.31979.34403.stgit@srivatsabhat.in.ibm.com> <20120603084145.GC16829@zhy>
In-Reply-To: <20120603084145.GC16829@zhy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12060311-4790-0000-0000-0000030FA2F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2012 02:11 PM, Yong Zhang wrote:

> On Fri, Jun 01, 2012 at 02:45:40PM +0530, Srivatsa S. Bhat wrote:
>> Convert cris to use the generic framework to boot secondary CPUs.
>>
>> Cc: Mikael Starvik <starvik@axis.com>
>> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Eric Dumazet <eric.dumazet@gmail.com>
>> Cc: Mike Frysinger <vapier@gentoo.org>
>> Cc: linux-cris-kernel@axis.com
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>>  arch/cris/arch-v32/kernel/smp.c |   14 ++++++--------
>>  1 files changed, 6 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
>> index ebe2cb3..357114a 100644
>> --- a/arch/cris/arch-v32/kernel/smp.c
>> +++ b/arch/cris/arch-v32/kernel/smp.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/cpumask.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/module.h>
>> +#include <linux/smpboot.h>
>>  
>>  #define IPI_SCHEDULE 1
>>  #define IPI_CALL 2
>> @@ -145,8 +146,11 @@ smp_boot_one_cpu(int cpuid, struct task_struct idle)
>>   * specific stuff such as the local timer and the MMU. */
>>  void __init smp_callin(void)
>>  {
>> -	extern void cpu_idle(void);
>> +	smpboot_start_secondary(NULL);
>> +}
>>  
>> +void __cpuinit __cpu_pre_starting(void *unused)
>> +{
>>  	int cpu = cpu_now_booting;
>>  	reg_intr_vect_rw_mask vect_mask = {0};
>>  
>> @@ -161,16 +165,10 @@ void __init smp_callin(void)
>>  	/* Setup local timer. */
>>  	cris_timer_init();
>>  
>> -	/* Enable IRQ and idle */
>> +	/* Enable IRQ */
> 
> I don't know cris; is the comments right?
> 
>>  	REG_WR(intr_vect, irq_regs[cpu], rw_mask, vect_mask);
>>  	crisv32_unmask_irq(IPI_INTR_VECT);
>>  	crisv32_unmask_irq(TIMER0_INTR_VECT);
>> -	preempt_disable();
>> -	notify_cpu_starting(cpu);
>> -	local_irq_enable();
>> -
>> -	set_cpu_online(cpu, true);
>> -	cpu_idle();
> 
> Before your patch, the comments seems end here.
> 


Good catch! I will remove that comment then, keeping the code in the
patch untouched.

Regards,
Srivatsa S. Bhat

>>  }
>>  
>>  /* Stop execution on this CPU.*/
> 

