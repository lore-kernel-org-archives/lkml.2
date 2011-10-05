Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934576Ab1JEMMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:12:38 -0400
Received: from mx2.parallels.com ([64.131.90.16]:45445 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934503Ab1JEMMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:12:37 -0400
Message-ID: <4E8C4990.1050704@parallels.com>
Date: Wed, 5 Oct 2011 16:12:00 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 05/10] Make total_forks per-cgroup
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>  <1317583287-18300-6-git-send-email-glommer@parallels.com> <1317805535.6766.6.camel@twins>
In-Reply-To: <1317805535.6766.6.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 01:05 PM, Peter Zijlstra wrote:
> On Sun, 2011-10-02 at 23:21 +0400, Glauber Costa wrote:
>> This patch counts the total number of forks per-cgroup.
>> The information is propagated to the parent, so the total
>> number of forks in the system, is the parent cgroup's one.
>>
>> To achieve that, total_forks is made per-cpu. There is no
>> particular reason to do that, but by doing this, we are
>> able to bundle it inside the cpustat structure already
>> present.
>
> I think fweisbec is also doing something with forks and cgroups.

I am all ears...

Frederic, does it conflict with what you're doing ?

>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> ---
>>   include/linux/kernel_stat.h |    1 +
>>   include/linux/sched.h       |    1 +
>>   kernel/fork.c               |    7 ++-----
>>   kernel/sched.c              |    9 ++++++++-
>>   4 files changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
>> index 71a69a0..9fb0dda 100644
>> --- a/include/linux/kernel_stat.h
>> +++ b/include/linux/kernel_stat.h
>> @@ -29,6 +29,7 @@ enum cpu_usage_stat {
>>   	GUEST_NICE,
>>   	IDLE_BASE,
>>   	IOWAIT_BASE,
>> +	TOTAL_FORKS,
>>   	NR_STATS,
>>   };
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 64c5ba5..4ba9dde 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -2716,6 +2716,7 @@ struct cgroup;
>>   struct cftype;
>>   int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
>>   			 struct seq_file *p);
>> +void task_group_new_fork(struct task_struct *p);
>>   #endif /* __KERNEL__ */
>>
>>   #endif
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index 8e6b6f4..ec2b729 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -76,10 +76,6 @@
>>
>>   #include<trace/events/sched.h>
>>
>> -/*
>> - * Protected counters by write_lock_irq(&tasklist_lock)
>> - */
>> -unsigned long total_forks;	/* Handle normal Linux uptimes. */
>>   int nr_threads;			/* The idle threads do not count.. */
>>
>>   int max_threads;		/* tunable limit on nr_threads */
>> @@ -1372,7 +1368,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>>   		nr_threads++;
>>   	}
>>
>> -	total_forks++;
>> +	task_group_new_fork(p);
>> +
>>   	spin_unlock(&current->sighand->siglock);
>>   	write_unlock_irq(&tasklist_lock);
>>   	proc_fork_connector(p);
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 89d2248..5a8181e 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -691,6 +691,11 @@ static inline void task_group_account_field(struct task_struct *p,
>>   }
>>   #endif /* CONFIG_CGROUP_SCHED */
>>
>> +void task_group_new_fork(struct task_struct *p)
>> +{
>> +	task_group_account_field(p, 1, TOTAL_FORKS);
>> +}
>> +
>>   static void update_rq_clock_task(struct rq *rq, s64 delta);
>>
>>   static void update_rq_clock(struct rq *rq)
>> @@ -9161,6 +9166,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
>>   	u64 guest, guest_nice;
>>   	u64 sum = 0;
>>   	u64 sum_softirq = 0;
>> +	u64 total_forks = 0;
>>   	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
>>   	struct timespec boottime;
>>   #ifdef CONFIG_CGROUP_SCHED
>> @@ -9201,6 +9207,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
>>   		steal += kstat->cpustat[STEAL];
>>   		guest += kstat->cpustat[GUEST];
>>   		guest_nice += kstat->cpustat[GUEST_NICE];
>> +		total_forks += kstat->cpustat[TOTAL_FORKS];
>>   		sum += kstat_cpu_irqs_sum(i);
>>   		sum += arch_irq_stat_cpu(i);
>>
>> @@ -9272,7 +9279,7 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft,
>>   	seq_printf(p,
>>   		"\nctxt %llu\n"
>>   		"btime %lu\n"
>> -		"processes %lu\n"
>> +		"processes %llu\n"
>>   		"procs_running %lu\n"
>>   		"procs_blocked %lu\n",
>>   		nr_context_switches(),
>

