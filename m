Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab2JYDdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 23:33:07 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:52596 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503Ab2JYDdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 23:33:04 -0400
Message-ID: <5088B2DF.9050705@linux.vnet.ibm.com>
Date: Thu, 25 Oct 2012 11:32:47 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Huacai Chen <chenhc@lemote.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH] sched: Fix a deadlock of cpu-hotplug
References: <1351070714-17676-1-git-send-email-chenhc@lemote.com> <1351071502.13456.54.camel@twins>
In-Reply-To: <1351071502.13456.54.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12102503-0260-0000-0000-000002081A44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 05:38 PM, Peter Zijlstra wrote:
> On Wed, 2012-10-24 at 17:25 +0800, Huacai Chen wrote:
>> We found poweroff sometimes fails on our computers, so we have the
>> lock debug options configured. Then, when we do poweroff or take a
>> cpu down via cpu-hotplug, kernel complain as below. To resove this,
>> we modify sched_ttwu_pending(), disable the local irq when acquire
>> rq->lock.
>>
>> [   83.066406] =================================
>> [   83.066406] [ INFO: inconsistent lock state ]
>> [   83.066406] 3.5.0-3.lemote #428 Not tainted
>> [   83.066406] ---------------------------------
>> [   83.066406] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
>> [   83.066406] migration/1/7 [HC0[0]:SC0[0]:HE1:SE1] takes:
>> [   83.066406]  (&rq->lock){?.-.-.}, at: [<ffffffff802585ac>] sched_ttwu_pending+0x64/0x98
>> [   83.066406] {IN-HARDIRQ-W} state was registered at:
>> [   83.066406]   [<ffffffff8027c9ac>] __lock_acquire+0x80c/0x1cc0
>> [   83.066406]   [<ffffffff8027e3d0>] lock_acquire+0x60/0x9c
>> [   83.066406]   [<ffffffff8074ba04>] _raw_spin_lock+0x3c/0x50
>> [   83.066406]   [<ffffffff8025a2fc>] scheduler_tick+0x48/0x178
>> [   83.066406]   [<ffffffff8023b334>] update_process_times+0x54/0x70
>> [   83.066406]   [<ffffffff80277568>] tick_handle_periodic+0x2c/0x9c
>> [   83.066406]   [<ffffffff8020a818>] c0_compare_interrupt+0x8c/0x94
>> [   83.066406]   [<ffffffff8029ec8c>] handle_irq_event_percpu+0x7c/0x248
>> [   83.066406]   [<ffffffff802a2774>] handle_percpu_irq+0x8c/0xc0
>> [   83.066406]   [<ffffffff8029e2c8>] generic_handle_irq+0x48/0x58
>> [   83.066406]   [<ffffffff80205c04>] do_IRQ+0x18/0x24
>> [   83.066406]   [<ffffffff802016e4>] mach_irq_dispatch+0xe4/0x124
>> [   83.066406]   [<ffffffff80203ca0>] ret_from_irq+0x0/0x4
>> [   83.066406]   [<ffffffff8022d114>] console_unlock+0x3e8/0x4c0
>> [   83.066406]   [<ffffffff811ff0d0>] con_init+0x370/0x398
>> [   83.066406]   [<ffffffff811fe3e0>] console_init+0x34/0x50
>> [   83.066406]   [<ffffffff811e4844>] start_kernel+0x2f8/0x4e0
>> [   83.066406] irq event stamp: 971
>> [   83.066406] hardirqs last  enabled at (971): [<ffffffff8021c384>] local_flush_tlb_all+0x134/0x17c
>> [   83.066406] hardirqs last disabled at (970): [<ffffffff8021c298>] local_flush_tlb_all+0x48/0x17c
>> [   83.066406] softirqs last  enabled at (0): [<ffffffff802298a4>] copy_process+0x510/0x117c
>> [   83.066406] softirqs last disabled at (0): [<          (null)>] (null)
>> [   83.066406]
>> [   83.066406] other info that might help us debug this:
>> [   83.066406]  Possible unsafe locking scenario:
>> [   83.066406]
>> [   83.066406]        CPU0
>> [   83.066406]        ----
>> [   83.066406]   lock(&rq->lock);
>> [   83.066406]   <Interrupt>
>> [   83.066406]     lock(&rq->lock);
>> [   83.066406]
>> [   83.066406]  *** DEADLOCK ***
>> [   83.066406]
>> [   83.066406] no locks held by migration/1/7.
>> [   83.066406]
>> [   83.066406] stack backtrace:
>> [   83.066406] Call Trace:
>> [   83.066406] [<ffffffff80747544>] dump_stack+0x8/0x34
>> [   83.066406] [<ffffffff8027ba04>] print_usage_bug+0x2ec/0x314
>> [   83.066406] [<ffffffff8027be28>] mark_lock+0x3fc/0x774
>> [   83.066406] [<ffffffff8027ca48>] __lock_acquire+0x8a8/0x1cc0
>> [   83.066406] [<ffffffff8027e3d0>] lock_acquire+0x60/0x9c
>> [   83.066406] [<ffffffff8074ba04>] _raw_spin_lock+0x3c/0x50
>> [   83.066406] [<ffffffff802585ac>] sched_ttwu_pending+0x64/0x98
>> [   83.066406] [<ffffffff80745ff4>] migration_call+0x10c/0x2e0
>> [   83.066406] [<ffffffff80253110>] notifier_call_chain+0x44/0x94
>> [   83.066406] [<ffffffff8022eae0>] __cpu_notify+0x30/0x5c
>> [   83.066406] [<ffffffff8072b598>] take_cpu_down+0x5c/0x70
>> [   83.066406] [<ffffffff80299ba4>] stop_machine_cpu_stop+0x104/0x1e8
>> [   83.066406] [<ffffffff802997cc>] cpu_stopper_thread+0x110/0x1ac
>> [   83.066406] [<ffffffff8024c940>] kthread+0x88/0x90
>> [   83.066406] [<ffffffff80205ee4>] kernel_thread_helper+0x10/0x18
> 
> Weird, that's from a CPU_DYING call, I thought those were with IRQs
> disabled. 
> 
> Look at how __stop_machine() calls the function with IRQs disabled for !
> stop_machine_initialized or !SMP. Also stop_machine_cpu_stop() seems to
> disabled interrupts, so how do we end up calling take_cpu_down() with
> IRQs enabled?

The patch is no doubt wrong...

The discuss in:

https://lkml.org/lkml/2012/7/19/164

Which also faced the issue that the timer interrupt come in after apic
was shut down, I'm not sure whether this could do help to Huacai, just
as a clue...

Regards,
Michael Wang

> 
> That simply doesn't make any sense.
> 
>> Signed-off-by: Huacai Chen <chenhc@lemote.com>
>> ---
>>  kernel/sched/core.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 36e2666..703754a 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -1468,9 +1468,10 @@ static void sched_ttwu_pending(void)
>>  {
>>  	struct rq *rq = this_rq();
>>  	struct llist_node *llist = llist_del_all(&rq->wake_list);
>> +	unsigned long flags;
>>  	struct task_struct *p;
>>  
>> -	raw_spin_lock(&rq->lock);
>> +	raw_spin_lock_irqsave(&rq->lock, flags);
>>  
>>  	while (llist) {
>>  		p = llist_entry(llist, struct task_struct, wake_entry);
>> @@ -1478,7 +1479,7 @@ static void sched_ttwu_pending(void)
>>  		ttwu_do_activate(rq, p, 0);
>>  	}
>>  
>> -	raw_spin_unlock(&rq->lock);
>> +	raw_spin_unlock_irqrestore(&rq->lock, flags);
>>  }
>>  
>>  void scheduler_ipi(void)
> 
> 
> That's wrong though, you add the cost to the common case instead of the
> hardly ever ran hotplug case.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

