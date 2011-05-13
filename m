Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab1EMFqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 01:46:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37036 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab1EMFqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 01:46:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DCCC61F.80408@jp.fujitsu.com>
Date: Fri, 13 May 2011 14:48:15 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] cpuset: fix cpuset_cpus_allowed_fallback() don't
 update tsk->rt.nr_cpus_allowed
References: <20110428161149.GA15658@redhat.com>	 <20110502194416.2D61.A69D9226@jp.fujitsu.com>	 <20110502195657.2D68.A69D9226@jp.fujitsu.com> <1305129929.2914.247.camel@laptop>
In-Reply-To: <1305129929.2914.247.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Mon, 2011-05-02 at 19:55 +0900, KOSAKI Motohiro wrote:
>> The rule is, we have to update tsk->rt.nr_cpus_allowed too if we change
>> tsk->cpus_allowed. Otherwise RT scheduler may confuse.
>>
>> This patch fixes it.
>>
>> btw, system_state checking is very important. current boot sequence is (1) smp_init
>> (ie secondary cpus up and created cpu bound kthreads). (2) sched_init_smp().
>> Then following bad scenario can be happen,
>>
>> (1) cpuup call notifier(CPU_UP_PREPARE)
>> (2) A cpu notifier consumer create FIFO kthread
>> (3) It call kthread_bind()
>>     ... but, now secondary cpu haven't ONLINE
>
> isn't

thanks, correction.

>
>> (3) schedule() makes fallback and cpuset_cpus_allowed_fallback
>>      change task->cpus_allowed
>
> I'm failing to see how this is happening, surely that kthread isn't
> actually running that early?

If my understand correctly, current call graph is below.

kernel_init()
         smp_init();
		cpu_up()
			... cpu hotplug notification
				kthread_create()
         sched_init_smp();


So, cpu hotplug event is happen before sched_init_smp(). The old rule is,
all kthreads of using cpu-up notification have to use kthread_bind(). It
protected from sched load balance.

but, now cpuset_cpus_allowed_fallback() forcedly change kthread's cpumask.
Why is this works? the point are two.

- rcu_cpu_kthread_should_stop() call set_cpus_allowed_ptr() again periodically.
   then, it can reset cpumask if cpuset_cpus_allowed_fallback() change it.
   my debug print obseve following cpumask change occur at boot time.
      1) kthread_bind: bind cpu1
      2) cpuset_cpus_allowed_fallback: bind possible cpu
      3) rcu_cpu_kthread_should_stop: rebind cpu1
- while tsk->rt.nr_cpus_allowed == 1, sched load balancer never be crash.


>
>> (4) find_lowest_rq() touch local_cpu_mask if task->rt.nr_cpus_allowed != 1,
>>      but it haven't been initialized.
>>
>> RCU folks plan to introduce such FIFO kthread and our testing hitted the
>> above issue. Then this patch also protect it.
>
> I'm fairly sure it doesn't, normal cpu-hotplug doesn't poke at
> system_state.

If my understand correctly. it's pure scheduler issue. because

- rcuc keep the old rule (ie an early spawned kthread have to call kthread_bind)
- cpuset_cpus_allowed_fallback() is called from scheduler internal
- crash is happen in find_lowest_rq(). (following line)


static int find_lowest_rq(struct task_struct *task)
{
   (snip)
         if (cpumask_test_cpu(cpu, lowest_mask))   // HERE


IOW, I think cpuset_cpus_allowed_fallback() should NOT be changed
tsk->cpus_allowed until to finish sched_init_smp().

Do you have an any alternative idea for this?


>> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>> Cc: Oleg Nesterov<oleg@redhat.com>
>> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
>> Cc: Ingo Molnar<mingo@elte.hu>
>> ---
>>   include/linux/cpuset.h |    1 +
>>   kernel/cpuset.c        |    1 +
>>   kernel/sched.c         |    4 ++++
>>   3 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
>> index f20eb8f..42dcbdc 100644
>> --- a/include/linux/cpuset.h
>> +++ b/include/linux/cpuset.h
>> @@ -147,6 +147,7 @@ static inline void cpuset_cpus_allowed(struct task_struct *p,
>>   static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
>>   {
>>   	cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
>> +	p->rt.nr_cpus_allowed = cpumask_weight(&p->cpus_allowed);
>>   	return cpumask_any(cpu_active_mask);
>>   }
>>
>> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>> index 1ceeb04..6e5bbe8 100644
>> --- a/kernel/cpuset.c
>> +++ b/kernel/cpuset.c
>> @@ -2220,6 +2220,7 @@ int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
>>   		cpumask_copy(&tsk->cpus_allowed, cpu_possible_mask);
>>   		cpu = cpumask_any(cpu_active_mask);
>>   	}
>> +	tsk->rt.nr_cpus_allowed = cpumask_weight(&tsk->cpus_allowed);
>>
>>   	return cpu;
>>   }
>
> I don't really see the point of doing this separately from your second
> patch, please fold them.

Ok. Will do.

>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index fd4625f..bfcd219 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -2352,6 +2352,10 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
>>   	if (dest_cpu<  nr_cpu_ids)
>>   		return dest_cpu;
>>
>> +	/* Don't worry. It's temporary mismatch. */
>> +	if (system_state<  SYSTEM_RUNNING)
>> +		return cpu;
>> +
>>   	/* No more Mr. Nice Guy. */
>>   	dest_cpu = cpuset_cpus_allowed_fallback(p);
>>   	/*
>
> Like explained, I don't believe this actually fixes your problem (its
> also disgusting).

If anybody have an alternative idea, I have no reason to refuse it.

Thanks.


