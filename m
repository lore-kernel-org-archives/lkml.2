Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab2K0Kf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:35:57 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:36290 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2K0Kfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:35:55 -0500
Message-ID: <50B49658.7080507@linux.vnet.ibm.com>
Date: Tue, 27 Nov 2012 16:00:48 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [PATCH V3 RFC 1/2] sched: Bail out of yield_to when source and
 target runqueue has one task
References: <20121126120740.2595.33651.sendpatchset@codeblue> <20121126120754.2595.37316.sendpatchset@codeblue> <20121126133501.GA9830@turtle.usersys.redhat.com>
In-Reply-To: <20121126133501.GA9830@turtle.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12112710-8878-0000-0000-000004F20C2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 07:05 PM, Andrew Jones wrote:
> On Mon, Nov 26, 2012 at 05:37:54PM +0530, Raghavendra K T wrote:
>> From: Peter Zijlstra <peterz@infradead.org>
>>
>> In case of undercomitted scenarios, especially in large guests
>> yield_to overhead is significantly high. when run queue length of
>> source and target is one, take an opportunity to bail out and return
>> -ESRCH. This return condition can be further exploited to quickly come
>> out of PLE handler.
>>
>> (History: Raghavendra initially worked on break out of kvm ple handler upon
>>   seeing source runqueue length = 1, but it had to export rq length).
>>   Peter came up with the elegant idea of return -ESRCH in scheduler core.
>>
>> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>> Raghavendra, Checking the rq length of target vcpu condition added.(thanks Avi)
>> Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>> ---
>>
>>   kernel/sched/core.c |   25 +++++++++++++++++++------
>>   1 file changed, 19 insertions(+), 6 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 2d8927f..fc219a5 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -4289,7 +4289,10 @@ EXPORT_SYMBOL(yield);
>>    * It's the caller's job to ensure that the target task struct
>>    * can't go away on us before we can do any checks.
>>    *
>> - * Returns true if we indeed boosted the target task.
>> + * Returns:
>> + *	true (>0) if we indeed boosted the target task.
>> + *	false (0) if we failed to boost the target.
>> + *	-ESRCH if there's no task to yield to.
>>    */
>>   bool __sched yield_to(struct task_struct *p, bool preempt)
>>   {
>> @@ -4303,6 +4306,15 @@ bool __sched yield_to(struct task_struct *p, bool preempt)
>>
>>   again:
>>   	p_rq = task_rq(p);
>> +	/*
>> +	 * If we're the only runnable task on the rq and target rq also
>> +	 * has only one task, there's absolutely no point in yielding.
>> +	 */
>> +	if (rq->nr_running == 1 && p_rq->nr_running == 1) {
>> +		yielded = -ESRCH;
>> +		goto out_irq;
>> +	}
>> +
>>   	double_rq_lock(rq, p_rq);
>>   	while (task_rq(p) != p_rq) {
>>   		double_rq_unlock(rq, p_rq);
>> @@ -4310,13 +4322,13 @@ again:
>>   	}
>>
>>   	if (!curr->sched_class->yield_to_task)
>> -		goto out;
>> +		goto out_unlock;
>>
>>   	if (curr->sched_class != p->sched_class)
>> -		goto out;
>> +		goto out_unlock;
>>
>>   	if (task_running(p_rq, p) || p->state)
>> -		goto out;
>> +		goto out_unlock;
>>
>>   	yielded = curr->sched_class->yield_to_task(rq, p, preempt);
>>   	if (yielded) {
>> @@ -4329,11 +4341,12 @@ again:
>>   			resched_task(p_rq->curr);
>>   	}
>>
>> -out:
>> +out_unlock:
>>   	double_rq_unlock(rq, p_rq);
>> +out_irq:
>>   	local_irq_restore(flags);
>>
>> -	if (yielded)
>> +	if (yielded > 0)
>>   		schedule();
>>
>>   	return yielded;
>>
>
> Acked-by: Andrew Jones <drjones@redhat.com>
>

Thank you Drew.

Marcelo Gleb.. Please let me know if you have comments / concerns on the 
patches..

Andrew, Vinod, IMO, the patch set looks good for undercommit scenarios
especially for large guests where we do have overhead of vcpu iteration
of ple handler..

