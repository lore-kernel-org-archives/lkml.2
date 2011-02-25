Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1BYUy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:54:28 -0500
Received: from smtp-out.google.com ([216.239.44.51]:28482 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab1BYUy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:54:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=sxq0C9jIWdAaT5clgQfx46GdQucoufe5mt+FGeJq8sbO/L1yTgKwvqH1CBY3nJSXRO
         6/GnWRKr06398wIGBmtQ==
MIME-Version: 1.0
In-Reply-To: <1298467934.2217.767.camel@twins>
References: <20110216031831.571628191@google.com> <20110216031840.878320737@google.com>
 <1298467934.2217.767.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Fri, 25 Feb 2011 12:53:54 -0800
Message-ID: <AANLkTim8yv5iB-CPW5zd3L7=iQzor7B+QuBG4jCgo73V@mail.gmail.com>
Subject: Re: [CFS Bandwidth Control v4 1/7] sched: introduce primitives to
 account for CFS bandwidth tracking
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 5:32 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-02-15 at 19:18 -0800, Paul Turner wrote:
>
>> @@ -245,6 +248,15 @@ struct cfs_rq;
>>
>>  static LIST_HEAD(task_groups);
>>
>> +#ifdef CONFIG_CFS_BANDWIDTH
>> +struct cfs_bandwidth {
>> +     raw_spinlock_t          lock;
>> +     ktime_t                 period;
>> +     u64                     runtime, quota;
>> +     struct hrtimer          period_timer;
>> +};
>> +#endif
>
> If you write that as:
>
> struct cfs_bandwidth {
> #ifdef CONFIG_CFS_BANDWIDTH
>        ...
> #endif
> };
>
>>  /* task group related information */
>>  struct task_group {
>>       struct cgroup_subsys_state css;
>> @@ -276,6 +288,10 @@ struct task_group {
>>  #ifdef CONFIG_SCHED_AUTOGROUP
>>       struct autogroup *autogroup;
>>  #endif
>> +
>> +#ifdef CONFIG_CFS_BANDWIDTH
>> +     struct cfs_bandwidth cfs_bandwidth;
>> +#endif
>>  };
>
> You can avoid the #ifdef'ery here
>
>>  /* task_group_lock serializes the addition/removal of task groups */
>> @@ -370,9 +386,76 @@ struct cfs_rq {
>
>> +#ifdef CONFIG_CFS_BANDWIDTH
>> +static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun);
>> +
>> +static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
>> +{
>> +     struct cfs_bandwidth *cfs_b =
>> +             container_of(timer, struct cfs_bandwidth, period_timer);
>> +     ktime_t now;
>> +     int overrun;
>> +     int idle = 0;
>> +
>> +     for (;;) {
>> +             now = hrtimer_cb_get_time(timer);
>> +             overrun = hrtimer_forward(timer, now, cfs_b->period);
>> +
>> +             if (!overrun)
>> +                     break;
>> +
>> +             idle = do_sched_cfs_period_timer(cfs_b, overrun);
>> +     }
>> +
>> +     return idle ? HRTIMER_NORESTART : HRTIMER_RESTART;
>> +}
>> +
>> +static
>> +void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b, u64 quota, u64 period)
>> +{
>> +     raw_spin_lock_init(&cfs_b->lock);
>> +     cfs_b->quota = cfs_b->runtime = quota;
>> +     cfs_b->period = ns_to_ktime(period);
>> +
>> +     hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>> +     cfs_b->period_timer.function = sched_cfs_period_timer;
>> +}
>> +
>> +static
>> +void init_cfs_rq_quota(struct cfs_rq *cfs_rq)
>> +{
>> +     cfs_rq->quota_used = 0;
>> +     if (cfs_rq->tg->cfs_bandwidth.quota == RUNTIME_INF)
>> +             cfs_rq->quota_assigned = RUNTIME_INF;
>> +     else
>> +             cfs_rq->quota_assigned = 0;
>> +}
>> +
>> +static void start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
>> +{
>> +     if (cfs_b->quota == RUNTIME_INF)
>> +             return;
>> +
>> +     if (hrtimer_active(&cfs_b->period_timer))
>> +             return;
>> +
>> +     raw_spin_lock(&cfs_b->lock);
>> +     start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period);
>> +     raw_spin_unlock(&cfs_b->lock);
>> +}
>> +
>> +static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
>> +{
>> +     hrtimer_cancel(&cfs_b->period_timer);
>> +}
>> +#endif
>
> and #else
>
> stubs
> #endif
>
>>  /* Real-Time classes' related field in a runqueue: */
>>  struct rt_rq {
>>       struct rt_prio_array active;
>> @@ -8038,6 +8121,9 @@ static void init_tg_cfs_entry(struct tas
>>       tg->cfs_rq[cpu] = cfs_rq;
>>       init_cfs_rq(cfs_rq, rq);
>>       cfs_rq->tg = tg;
>> +#ifdef CONFIG_CFS_BANDWIDTH
>> +     init_cfs_rq_quota(cfs_rq);
>> +#endif
>
> also avoids #ifdef'ery here
>
>>       tg->se[cpu] = se;
>>       /* se could be NULL for root_task_group */
>> @@ -8173,6 +8259,10 @@ void __init sched_init(void)
>>                * We achieve this by letting root_task_group's tasks sit
>>                * directly in rq->cfs (i.e root_task_group->se[] = NULL).
>>                */
>> +#ifdef CONFIG_CFS_BANDWIDTH
>> +             init_cfs_bandwidth(&root_task_group.cfs_bandwidth,
>> +                             RUNTIME_INF, sched_cfs_bandwidth_period);
>> +#endif
>
> and here
>
>>               init_tg_cfs_entry(&root_task_group, &rq->cfs, NULL, i, NULL);
>>  #endif /* CONFIG_FAIR_GROUP_SCHED */
>>
>> @@ -8415,6 +8505,10 @@ static void free_fair_sched_group(struct
>>  {
>>       int i;
>>
>> +#ifdef CONFIG_CFS_BANDWIDTH
>> +     destroy_cfs_bandwidth(&tg->cfs_bandwidth);
>> +#endif
>
> and here
>
>>       for_each_possible_cpu(i) {
>>               if (tg->cfs_rq)
>>                       kfree(tg->cfs_rq[i]);
>> @@ -8442,7 +8536,10 @@ int alloc_fair_sched_group(struct task_g
>>               goto err;
>>
>>       tg->shares = NICE_0_LOAD;
>> -
>> +#ifdef CONFIG_CFS_BANDWIDTH
>> +     init_cfs_bandwidth(&tg->cfs_bandwidth, RUNTIME_INF,
>> +                     sched_cfs_bandwidth_period);
>> +#endif
>
> and here
>
>>       for_each_possible_cpu(i) {
>>               rq = cpu_rq(i);
>>
>
>> @@ -9107,6 +9204,116 @@ static u64 cpu_shares_read_u64(struct cg
>>
>>       return (u64) tg->shares;
>>  }
>> +
>> +#ifdef CONFIG_CFS_BANDWIDTH
>> +static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
>> +{
>> +     int i;
>> +     static DEFINE_MUTEX(mutex);
>> +
>> +     if (tg == &root_task_group)
>> +             return -EINVAL;
>> +
>> +     if (!period)
>> +             return -EINVAL;
>> +
>> +     /*
>> +      * Ensure we have at least one tick of bandwidth every period.  This is
>> +      * to prevent reaching a state of large arrears when throttled via
>> +      * entity_tick() resulting in prolonged exit starvation.
>> +      */
>> +     if (NS_TO_JIFFIES(quota) < 1)
>> +             return -EINVAL;
>> +
>> +     mutex_lock(&mutex);
>> +     raw_spin_lock_irq(&tg->cfs_bandwidth.lock);
>> +     tg->cfs_bandwidth.period = ns_to_ktime(period);
>> +     tg->cfs_bandwidth.runtime = tg->cfs_bandwidth.quota = quota;
>> +     raw_spin_unlock_irq(&tg->cfs_bandwidth.lock);
>> +
>> +     for_each_possible_cpu(i) {
>> +             struct cfs_rq *cfs_rq = tg->cfs_rq[i];
>> +             struct rq *rq = rq_of(cfs_rq);
>> +
>> +             raw_spin_lock_irq(&rq->lock);
>> +             init_cfs_rq_quota(cfs_rq);
>> +             raw_spin_unlock_irq(&rq->lock);
>
> Any particular reason you didn't mirror rt_rq->rt_runtime_lock?
>

Missed this in original reply -- just that no additional locking is
required so we can avoid the overhead.  The existing rq->lock
synchronization against cfs_rq is sufficient.

>> +     }
>> +     mutex_unlock(&mutex);
>> +
>> +     return 0;
>> +}
>
>
>> Index: tip/kernel/sched_fair.c
>> ===================================================================
>> --- tip.orig/kernel/sched_fair.c
>> +++ tip/kernel/sched_fair.c
>> @@ -88,6 +88,15 @@ const_debug unsigned int sysctl_sched_mi
>>   */
>>  unsigned int __read_mostly sysctl_sched_shares_window = 10000000UL;
>>
>> +
>> +#ifdef CONFIG_CFS_BANDWIDTH
>> +/*
>> + * default period for cfs group bandwidth.
>> + * default: 0.5s, units: nanoseconds
>> + */
>> +static u64 sched_cfs_bandwidth_period = 500000000ULL;
>> +#endif
>> +
>>  static const struct sched_class fair_sched_class;
>>
>>  /**************************************************************
>> @@ -397,6 +406,9 @@ static void __enqueue_entity(struct cfs_
>>
>>       rb_link_node(&se->run_node, parent, link);
>>       rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
>> +#ifdef CONFIG_CFS_BANDWIDTH
>> +     start_cfs_bandwidth(&cfs_rq->tg->cfs_bandwidth);
>> +#endif
>>  }
>
> This really needs to life elsewhere, __*_entity() functions are for
> rb-tree muck.
>
>>  static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
>
>
>
