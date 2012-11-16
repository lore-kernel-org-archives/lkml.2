Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab2KPKQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 05:16:42 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:47344 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2KPKQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 05:16:40 -0500
Message-ID: <50A61253.5020003@linux.vnet.ibm.com>
Date: Fri, 16 Nov 2012 15:45:47 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        Benjamin Segall <bsegall@google.com>
CC: paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        amit.kucheria@linaro.org, Morten.Rasmussen@arm.com,
        paul.mckenney@linaro.org, akpm@linux-foundation.org,
        svaidy@linux.vnet.ibm.com, arjan@linux.intel.com, mingo@kernel.org,
        pjt@google.com, venki@google.com, robin.randhawa@arm.com,
        linaro-dev@lists.linaro.org, suresh.b.siddha@intel.com,
        mjg59@srcf.ucam.org, deepthi@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, Arvind.Chauhan@arm.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC v2 PATCH 2/2] sched: Use Per-Entity-Load-Tracking metric
 for load balancing
References: <20121115164730.17426.36051.stgit@preeti.in.ibm.com> <20121115165422.17426.3978.stgit@preeti.in.ibm.com> <CAKfTPtB3D99tNFK+fu6a3Pok2r3CcfTufiR0kTRkc4T54WkLAQ@mail.gmail.com>
In-Reply-To: <CAKfTPtB3D99tNFK+fu6a3Pok2r3CcfTufiR0kTRkc4T54WkLAQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12111610-1618-0000-0000-000002DC13CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,
Thank you for your review.

On 11/15/2012 11:43 PM, Vincent Guittot wrote:
> Hi Preeti,
> 
> On 15 November 2012 17:54, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>> Currently the load balancer weighs a task based upon its priority,and this
>> weight consequently gets added up to the weight of the run queue that it is
>> on.It is this weight of the runqueue that sums up to a sched group's load
>> which is used to decide the busiest or the idlest group and the runqueue
>> thereof.
>>
>> The Per-Entity-Load-Tracking metric however measures how long a task has
>> been runnable over the duration of its lifetime.This gives us a hint of
>> the amount of CPU time that the task can demand.This metric takes care of the
>> task priority as well.Therefore apart from the priority of a task we also
>> have an idea of the live behavior of the task.This seems to be a more
>> realistic metric to use to compute task weight which adds upto the run queue
>> weight and the weight of the sched group.Consequently they can be used for
>> load balancing.
>>
>> The semantics of load balancing is left untouched.The two functions
>> load_balance() and select_task_rq_fair() perform the task of load
>> balancing.These two paths have been browsed through in this patch to make
>> necessary changes.
>>
>> weighted_cpuload() and task_h_load() provide the run queue weight and the
>> weight of the task respectively.They have been modified to provide the
>> Per-Entity-Load-Tracking metric as relevant for each.
>> The rest of the modifications had to be made to suit these two changes.
>>
>> Completely Fair Scheduler class is the only sched_class which contributes to
>> the run queue load.Therefore the rq->load.weight==cfs_rq->load.weight when
>> the cfs_rq is the root cfs_rq (rq->cfs) of the hierarchy.When replacing this
>> with Per-Entity-Load-Tracking metric,cfs_rq->runnable_load_avg needs to be
>> used as this is the right reflection of the run queue load when
>> the cfs_rq is the root cfs_rq (rq->cfs) of the hierarchy.This metric reflects
>> the percentage uptime of the tasks that are queued on it and hence that contribute
>> to the load.Thus cfs_rq->runnable_load_avg replaces the metric earlier used in
>> weighted_cpuload().
>>
>> The task load is aptly captured by se.avg.load_avg_contrib which captures the
>> runnable time vs the alive time of the task against its priority.This metric
>> replaces the earlier metric used in task_h_load().
>>
>> The consequent changes appear as data type changes for the helper variables;
>> they abound in number.Because cfs_rq->runnable_load_avg needs to be big enough
>> to capture the tasks' load often and accurately.
> 
> You are now using cfs_rq->runnable_load_avg instead of
> cfs_rq->load.weight for calculation of cpu_load but
> cfs_rq->runnable_load_avg is smaller or equal to cfs_rq->load.weight
> value. This implies that the new value is smaller or equal to the old
> statistic so you should be able to keep the same variable width for
> the computation of cpu_load

Right.But cfs_rq->runnable_load_avg is a 64 bit unsigned integer as per
the Per-entity-load-tracking patchset.I could not figure out why this is
the case although as you mention, its value will not exceed
cfs_rq->load.weight.In order to retain the data type of
cfs_rq->runnable_load_avg as it is,these changes had to be made to suit
it.It would be good if someone would clarify why it is a 64 bit
integer,will save a lot of trouble if we could consider this the same
length as cfs_rq->load.weight.Ben,Paul? can you clarify this point?
> 
>>
>> The following patch does not consider CONFIG_FAIR_GROUP_SCHED AND
>> CONFIG_SCHED_NUMA.This is done so as to evaluate this approach starting from the
>> simplest scenario.Earlier discussions can be found in the link below.
>>
>> Link: https://lkml.org/lkml/2012/10/25/162
>> Signed-off-by: Preeti U Murthy<preeti@linux.vnet.ibm.com>
>> ---
>>  include/linux/sched.h |    2 +-
>>  kernel/sched/core.c   |   12 +++++----
>>  kernel/sched/fair.c   |   64 +++++++++++++++++++++++++------------------------
>>  kernel/sched/sched.h  |    2 +-
>>  4 files changed, 40 insertions(+), 40 deletions(-)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 087dd20..302756e 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -924,7 +924,7 @@ struct sched_domain {
>>         unsigned int lb_count[CPU_MAX_IDLE_TYPES];
>>         unsigned int lb_failed[CPU_MAX_IDLE_TYPES];
>>         unsigned int lb_balanced[CPU_MAX_IDLE_TYPES];
>> -       unsigned int lb_imbalance[CPU_MAX_IDLE_TYPES];
>> +       u64 lb_imbalance[CPU_MAX_IDLE_TYPES];
>>         unsigned int lb_gained[CPU_MAX_IDLE_TYPES];
>>         unsigned int lb_hot_gained[CPU_MAX_IDLE_TYPES];
>>         unsigned int lb_nobusyg[CPU_MAX_IDLE_TYPES];
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 24d8b9b..4dea057 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -2415,8 +2415,8 @@ static const unsigned char
>>   * would be when CPU is idle and so we just decay the old load without
>>   * adding any new load.
>>   */
>> -static unsigned long
>> -decay_load_missed(unsigned long load, unsigned long missed_updates, int idx)
>> +static u64
>> +decay_load_missed(u64 load, unsigned long missed_updates, int idx)
>>  {
>>         int j = 0;
>>
>> @@ -2444,7 +2444,7 @@ decay_load_missed(unsigned long load, unsigned long missed_updates, int idx)
>>   * scheduler tick (TICK_NSEC). With tickless idle this will not be called
>>   * every tick. We fix it up based on jiffies.
>>   */
>> -static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>> +static void __update_cpu_load(struct rq *this_rq, u64 this_load,
>>                               unsigned long pending_updates)
>>  {
>>         int i, scale;
>> @@ -2454,7 +2454,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>>         /* Update our load: */
>>         this_rq->cpu_load[0] = this_load; /* Fasttrack for idx 0 */
>>         for (i = 1, scale = 2; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
>> -               unsigned long old_load, new_load;
>> +               u64 old_load, new_load;
>>
>>                 /* scale is effectively 1 << i now, and >> i divides by scale */
>>
>> @@ -2496,7 +2496,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>>  void update_idle_cpu_load(struct rq *this_rq)
>>  {
>>         unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
>> -       unsigned long load = this_rq->load.weight;
>> +       u64 load = this_rq->cfs.runnable_load_avg;
>>         unsigned long pending_updates;
>>
>>         /*
>> @@ -2546,7 +2546,7 @@ static void update_cpu_load_active(struct rq *this_rq)
>>          * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
>>          */
>>         this_rq->last_load_update_tick = jiffies;
>> -       __update_cpu_load(this_rq, this_rq->load.weight, 1);
>> +       __update_cpu_load(this_rq, this_rq->cfs.runnable_load_avg, 1);
>>
>>         calc_load_account_active(this_rq);
>>  }
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index a9cdc8f..f8f3a29 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -2935,9 +2935,9 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>>
>>  #ifdef CONFIG_SMP
>>  /* Used instead of source_load when we know the type == 0 */
>> -static unsigned long weighted_cpuload(const int cpu)
>> +static u64 weighted_cpuload(const int cpu)
>>  {
>> -       return cpu_rq(cpu)->load.weight;
>> +       return cpu_rq(cpu)->cfs.runnable_load_avg;
>>  }
>>
>>  /*
>> @@ -2947,10 +2947,10 @@ static unsigned long weighted_cpuload(const int cpu)
>>   * We want to under-estimate the load of migration sources, to
>>   * balance conservatively.
>>   */
>> -static unsigned long source_load(int cpu, int type)
>> +static u64 source_load(int cpu, int type)
>>  {
>>         struct rq *rq = cpu_rq(cpu);
>> -       unsigned long total = weighted_cpuload(cpu);
>> +       u64 total = weighted_cpuload(cpu);
>>
>>         if (type == 0 || !sched_feat(LB_BIAS))
>>                 return total;
>> @@ -2962,10 +2962,10 @@ static unsigned long source_load(int cpu, int type)
>>   * Return a high guess at the load of a migration-target cpu weighted
>>   * according to the scheduling class and "nice" value.
>>   */
>> -static unsigned long target_load(int cpu, int type)
>> +static u64 target_load(int cpu, int type)
>>  {
>>         struct rq *rq = cpu_rq(cpu);
>> -       unsigned long total = weighted_cpuload(cpu);
>> +       u64 total = weighted_cpuload(cpu);
>>
>>         if (type == 0 || !sched_feat(LB_BIAS))
>>                 return total;
>> @@ -2978,13 +2978,13 @@ static unsigned long power_of(int cpu)
>>         return cpu_rq(cpu)->cpu_power;
>>  }
>>
>> -static unsigned long cpu_avg_load_per_task(int cpu)
>> +static u64 cpu_avg_load_per_task(int cpu)
>>  {
>>         struct rq *rq = cpu_rq(cpu);
>>         unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
>>
>>         if (nr_running)
>> -               return rq->load.weight / nr_running;
>> +               return rq->cfs.runnable_load_avg / nr_running;
> 
> You now need to use div_u64 for all division of a 64bits variable like
> runnable_load_avg otherwise it can't compile on 32bits platform like
> ARM. This one is obvious because it appears in your patch but other
> division could be now 64bits division

Ah yes,there will be some trouble here,Explicit do_div() calls need to
be inserted,and there will be plenty such cases.But as I mentioned
above,once we are clear about why the width of cfs_rq->runnable_load_avg
is 64 bit, we can sort this out.We will need someone to clarify this.

I am at a loss to see the solution around making the above changes if
for some reason the width of cfs_rq->runnable_load_avg has to be
maintained as is.any thoughts on this?
> 
> Regards,
> Vincent

Regards
Preeti U Murthy

