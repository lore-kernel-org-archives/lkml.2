Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2K2CU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 21:20:29 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:6481 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab2K2CU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 21:20:28 -0500
Message-ID: <50B6C66A.5020308@hp.com>
Date: Wed, 28 Nov 2012 18:20:26 -0800
From: Chegu Vinod <chegu_vinod@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
CC: KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 RFC 1/2] sched: Bail out of yield_to when source and
 target runqueue has one task
References: <20121126120740.2595.33651.sendpatchset@codeblue> <20121126120754.2595.37316.sendpatchset@codeblue> <20121126133501.GA9830@turtle.usersys.redhat.com> <50B49658.7080507@linux.vnet.ibm.com> <50B4CCC8.60401@hp.com> <50B6B5B5.5060108@hp.com>
In-Reply-To: <50B6B5B5.5060108@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 5:09 PM, Chegu Vinod wrote:
> On 11/27/2012 6:23 AM, Chegu Vinod wrote:
>> On 11/27/2012 2:30 AM, Raghavendra K T wrote:
>>> On 11/26/2012 07:05 PM, Andrew Jones wrote:
>>>> On Mon, Nov 26, 2012 at 05:37:54PM +0530, Raghavendra K T wrote:
>>>>> From: Peter Zijlstra <peterz@infradead.org>
>>>>>
>>>>> In case of undercomitted scenarios, especially in large guests
>>>>> yield_to overhead is significantly high. when run queue length of
>>>>> source and target is one, take an opportunity to bail out and return
>>>>> -ESRCH. This return condition can be further exploited to quickly 
>>>>> come
>>>>> out of PLE handler.
>>>>>
>>>>> (History: Raghavendra initially worked on break out of kvm ple 
>>>>> handler upon
>>>>>   seeing source runqueue length = 1, but it had to export rq length).
>>>>>   Peter came up with the elegant idea of return -ESRCH in 
>>>>> scheduler core.
>>>>>
>>>>> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>>>>> Raghavendra, Checking the rq length of target vcpu condition 
>>>>> added.(thanks Avi)
>>>>> Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>>>>> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>>>>> ---
>>>>>
>>>>>   kernel/sched/core.c |   25 +++++++++++++++++++------
>>>>>   1 file changed, 19 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>>>>> index 2d8927f..fc219a5 100644
>>>>> --- a/kernel/sched/core.c
>>>>> +++ b/kernel/sched/core.c
>>>>> @@ -4289,7 +4289,10 @@ EXPORT_SYMBOL(yield);
>>>>>    * It's the caller's job to ensure that the target task struct
>>>>>    * can't go away on us before we can do any checks.
>>>>>    *
>>>>> - * Returns true if we indeed boosted the target task.
>>>>> + * Returns:
>>>>> + *    true (>0) if we indeed boosted the target task.
>>>>> + *    false (0) if we failed to boost the target.
>>>>> + *    -ESRCH if there's no task to yield to.
>>>>>    */
>>>>>   bool __sched yield_to(struct task_struct *p, bool preempt)
>>>>>   {
>>>>> @@ -4303,6 +4306,15 @@ bool __sched yield_to(struct task_struct 
>>>>> *p, bool preempt)
>>>>>
>>>>>   again:
>>>>>       p_rq = task_rq(p);
>>>>> +    /*
>>>>> +     * If we're the only runnable task on the rq and target rq also
>>>>> +     * has only one task, there's absolutely no point in yielding.
>>>>> +     */
>>>>> +    if (rq->nr_running == 1 && p_rq->nr_running == 1) {
>>>>> +        yielded = -ESRCH;
>>>>> +        goto out_irq;
>>>>> +    }
>>>>> +
>>>>>       double_rq_lock(rq, p_rq);
>>>>>       while (task_rq(p) != p_rq) {
>>>>>           double_rq_unlock(rq, p_rq);
>>>>> @@ -4310,13 +4322,13 @@ again:
>>>>>       }
>>>>>
>>>>>       if (!curr->sched_class->yield_to_task)
>>>>> -        goto out;
>>>>> +        goto out_unlock;
>>>>>
>>>>>       if (curr->sched_class != p->sched_class)
>>>>> -        goto out;
>>>>> +        goto out_unlock;
>>>>>
>>>>>       if (task_running(p_rq, p) || p->state)
>>>>> -        goto out;
>>>>> +        goto out_unlock;
>>>>>
>>>>>       yielded = curr->sched_class->yield_to_task(rq, p, preempt);
>>>>>       if (yielded) {
>>>>> @@ -4329,11 +4341,12 @@ again:
>>>>>               resched_task(p_rq->curr);
>>>>>       }
>>>>>
>>>>> -out:
>>>>> +out_unlock:
>>>>>       double_rq_unlock(rq, p_rq);
>>>>> +out_irq:
>>>>>       local_irq_restore(flags);
>>>>>
>>>>> -    if (yielded)
>>>>> +    if (yielded > 0)
>>>>>           schedule();
>>>>>
>>>>>       return yielded;
>>>>>
>>>>
>>>> Acked-by: Andrew Jones <drjones@redhat.com>
>>>>
>>>
>>> Thank you Drew.
>>>
>>> Marcelo Gleb.. Please let me know if you have comments / concerns on 
>>> the patches..
>>>
>>> Andrew, Vinod, IMO, the patch set looks good for undercommit scenarios
>>> especially for large guests where we do have overhead of vcpu iteration
>>> of ple handler..
>>>
>>> .
>>>
>> Thanks Raghu. Will try to get this latest patch set evaluated and get 
>> back to you.
>>
>> Vinod
>>
>

< Resending as prev. email to the kvm and lkml email aliases bounced 
twice... Apologies for any repeats! >

> Hi Raghu,
>
> Here is some preliminary data with your latest set ofPLE patches (& 
> also with Andrew's throttled yield_to() change).
>
> Ran a single guest on a 80 core Westmere platform. [Note: Host and 
> Guest had the latest kernel from kvm.git and also using the latestqemu 
> from qemu.git as of yesterday morning].
>
> The guest was running a AIM7 high_systime workload. (Note: 
> high_systime is a kernel intensive micro-benchmark but in this case it 
> was run just as a workload in the guest to trigger spinlock etc. 
> contention in the guest OS and hence PLE (i.e. this is not a real 
> benchmark run). 'have run this workload with a constant # (i.e. 2000) 
> users with 100 jobs per user. The numbers below represent the # of 
> jobs per minute (JPM) -higher the better) .
>
> 40VCPU60VCPU80VCPU
>
> a) 3.7.0-rc6+ w/ ple_gap=0~102K~88K~81K
>
>
> b) 3.7.0-rc6+~53K~25K~18-20K
>
> c) 3.7.0-rc6+ w/ PLE patches~100K~81K~48K-69K<- lot of variation from 
> run to run.
>
> d) 3.7.0-rc6+ w/throttled
>
> yield_to() change~101K~87K~78K
>
> ---
>
> The PLE patches case (c) does show improvements in this non-overcommit 
> large guest case when compared to the case (b). However at 80way 
> started to observe quite a bit of variation from run to run and the 
> JPM was lower when compared with the throttled yield_to() change case (d).
>
> For this 80way in case (c) also noticed that average time spent in the 
> PLE exit (as reported by a small samplings from perf kvm stat) was 
> varying quite a bit and was at times much greater when compared with 
> the case of throttled yield_to() change case (d). More details are 
> included below.
>
> --
>
> Thanks
>
> Vinod
>
> Case c :PLE patches(80-way)
>
> -------------------------------
>
> Analyze events for all VCPUs:
>
> VM-EXITSamplesSamples%Time%Avg time
>
> PAUSE_INSTRUCTION247814491.97%96.71%88.38us ( +-1.63% )
>
> MSR_WRITE1593845.91%1.05%14.90us ( +-1.07% )
>
> EXTERNAL_INTERRUPT395071.47%1.31%74.91us ( +-25.57% )
>
> PENDING_INTERRUPT136070.50%0.12%20.60us ( +-7.64% )
>
> HLT16730.06%0.73%985.40us ( +-1.30% )
>
> CPUID15080.06%0.01%10.48us ( +-3.64% )
>
> EXCEPTION_NMI5130.02%0.01%50.90us ( +-12.10% )
>
> EPT_MISCONFIG2200.01%0.06%598.15us ( +-23.24% )
>
> MSR_READ600.00%0.00%101.37us ( +-78.48% )
>
> RDPMC220.00%0.00%14.30us ( +- 22.46% )
>
> CR_ACCESS20.00%0.00%18.07us ( +-55.64% )
>
> NMI_WINDOW10.00%0.00%6.81us ( +--nan% )
>
> Total Samples:2694641, Total events handled time:226458587.95us.
>
> Case d:throttled yield_to() change (80-way)
>
> ----------------------------------------------
>
> Analyze events for all VCPUs:
>
> VM-EXITSamplesSamples%Time%Avg time
>
> MSR_WRITE133508034.82%0.52%5.70us ( +-0.08% )
>
> HLT94545824.66%98.67%1513.60us ( +-1.04% )
>
> PAUSE_INSTRUCTION79223620.66%0.42%7.66us ( +-0.18% )
>
> EXTERNAL_INTERRUPT44680311.65%0.34%11.01us ( +-0.16% )
>
> CPUID1589864.15%0.02%1.78us ( +-0.25% )
>
> PENDING_INTERRUPT1111642.90%0.02%2.32us ( +-0.22% )
>
> EXCEPTION_NMI417701.09%0.01%3.83us ( +-0.69% )
>
> EPT_MISCONFIG 16520.04%0.00%29.02us ( +-3.56% )
>
> MSR_READ6180.02%0.00%3.30us ( +-4.16% )
>
> RDPMC2280.01%0.00%2.16us ( +-1.38% )
>
> CR_ACCESS90.00%0.00%4.94us ( +-8.58% )
>
> NMI_WINDOW80.00%0.00%1.95us ( +-4.33% )
>
> IO_INSTRUCTION10.00%0.00%15.48us ( +--nan% )
>
> EPT_VIOLATION10.00%0.00%752.38us ( +--nan% )
>
> Total Samples:3834014, Total events handled time:1450387642.32us.
>

