Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab1KPL45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:56:57 -0500
Received: from mx2.parallels.com ([64.131.90.16]:56779 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523Ab1KPL4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:56:55 -0500
Message-ID: <4EC3A4E5.7080206@parallels.com>
Date: Wed, 16 Nov 2011 09:56:21 -0200
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <a.p.zijlstra@chello.nl>, <jbottomley@parallels.com>,
        <cgroups@vger.kernel.org>
Subject: Re: [PATCH 3/4] Keep scheduler statistics per cgroup
References: <1321372757-1581-1-git-send-email-glommer@parallels.com> <1321372757-1581-4-git-send-email-glommer@parallels.com> <4EC36004.8050605@google.com>
In-Reply-To: <4EC36004.8050605@google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.130.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 05:02 AM, Paul Turner wrote:
> On 11/15/2011 07:59 AM, Glauber Costa wrote:
>> This patch makes the scheduler statistics, such as user ticks,
>> system ticks, etc, per-cgroup. With this information, we are
>> able to display the same information we currently do in cpuacct
>> cgroup, but within the normal cpu cgroup.
>>
>
> Hmm,
>
> So this goes a little beyond the existing stats exported by cpuacct.
>
> Currently we have:
>
> CPUACCT_STAT_USER
> CPUACCT_STAT_SYSTEM (in cpuacct.info)
> and
> cpuacct.usage / cpuacct.usage_per_cpu
>
> Arguably the last two stats are the *most* useful information exported
> by cpuacct (and the ones we get for free from existing sched_entity
> accounting). But their functionality is not maintained.
Of course it is. But not in *this* patchset. If you look at the last one 
I sent, with all the functionality, before a split attempt, you will see 
that this is indeed used.

What I tried to achieve here, i

> As proposed in: https://lkml.org/lkml/2011/11/11/265
> I'm not sure we really want to bring the other stats /within/ the CPU
> controller.
>
> Furthermore, given your stated goal of changing virtualizing some of the
> /proc interfaces using this export it definitely seems like these fields
> (and any future behavioral changes using them may enable) be independent
> from core cpu.
>
> (/me ... reads through patch then continues thoughts at bottom.)

>> +static struct jump_label_key sched_cgroup_enabled;
>
> This name does not really suggest what this jump-label is used for.
>
> Something like task_group_sched_stats_enabled is much clearer.
OK.


>> +static int sched_has_sched_stats = 0;
>> +
>> +struct kernel_cpustat *task_group_kstat(struct task_struct *p)
>> +{
>> + if (static_branch(&sched_cgroup_enabled)) {
>> + struct task_group *tg;
>> + tg = task_group(p);
>> + return tg->cpustat;
>> + }
>> +
>> + return&kernel_cpustat;
>> +}
>> +EXPORT_SYMBOL(task_group_kstat);
>> +
>> /* Change a task's cfs_rq and parent entity if it moves across
>> CPUs/groups */
>> static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
>> {
>> @@ -784,9 +806,36 @@ static inline struct task_group
>> *task_group(struct task_struct *p)
>> {
>> return NULL;
>> }
>> -
>> #endif /* CONFIG_CGROUP_SCHED */
>>
>> +static inline void task_group_account_field(struct task_struct *p,
>> + u64 tmp, int index)
>> +{
>> + /*
>> + * Since all updates are sure to touch the root cgroup, we
>> + * get ourselves ahead and touch it first. If the root cgroup
>> + * is the only cgroup, then nothing else should be necessary.
>> + *
>> + */
>> + __get_cpu_var(kernel_cpustat).cpustat[index] += tmp;
>
>> +
>> +#ifdef CONFIG_CGROUP_SCHED
>> + if (static_branch(&sched_cgroup_enabled)) {
>> + struct kernel_cpustat *kcpustat;
>> + struct task_group *tg;
>> +
>> + rcu_read_lock();
>> + tg = task_group(p);
>> + while (tg&& (tg !=&root_task_group)) {
>
> You could use for_each_entity starting from &p->se here.

Yes, but note that I explicitly need to skip the root. So in the end I 
think that could do more operations than this.

>> + kcpustat = this_cpu_ptr(tg->cpustat);
>
> This is going to have to do the this_cpu_ptr work at every level; we
> already know what cpu we're on it and can reference it directly.
How exactly? I thought this_cpu_ptr was always needed in the case of 
dynamic allocated percpu variables.

>> local_irq_save(flags);
>> latest_ns = this_cpu_read(cpu_hardirq_time);
>> + kstat_lock();
>
> This protects ?

This is basically an rcu (or nothing in the disabled case) that 
guarantees that the task group won't go away while we read it.

>> struct cgroup_subsys cpu_cgroup_subsys = {
>
> So I'm not seeing any touch-points that intrinsically benefit from being
> a part of the cpu sub-system. The hierarchy walk in
> task_group_account_field() is completely independent from the rest of
> the controller.

Indeed we gain more in cpuusage, which is left out of this patchset due 
to your early request.

>
> The argument for merging {usage, usage_per_cpu} into cpu is almost
> entirely performance based -- the stats are very useful from a
> management perspective and we already maintain (hidden) versions of them
> in cpu. Whereas, as it stands these this really would seem not to suffer
> at all from being in its own controller. I previously suggested that
> this might want to be a "co-controller" (e.g. one that only ever exists
> mounted adjacent to cpu so that we could leverage the existing hierarchy
> without over-loading the core of "cpu"). But I'm not even sure that is
> required or beneficial given that this isn't going to add value or make
> anything cheaper.

Please take a look on how I address the cpuusage problem in my original 
patchset, and see if you keep your opinion about this. (continue below)

>  From that perspective, perhaps what you're looking for *really* is best
> served just by greatly extending the stats exported by cpuacct (as above).

I myself don't care in which cgroup this lives, as long as I can export 
the cpustat information easily.

But in the end, I still believe having one sched-related cgroup instead 
of 2 is

1) simpler, since the grouping already exist in task_groups
2) cheaper, specially when we account cpuusage.

You seem to put more stress in the fact that statistics are logically 
separate from the controlling itself, which still works for me. But 
looking from another perspective, there is no harm in leaving the 
statistics be collected close to their natural grouping.

> We'll still pull {usage, usage_per_cpu} into "cpu" for the common case
> but those who really want everything else could continue using "cpuacct".
>
> Reasonable?

I don't think so, unless we can rip cpuusage in cpuacct. If you think 
about it, the common case will really be to have both enabled. And then, 
the performance hit is there anyway - which defeats the point of moving 
cpuusage to the cpu cgroup in the first place.

Way I see it, there are two possible ways to do it:
1) Everything in the cpu cgroup, including cpuusage.
2) All the stats in cpuacct, including cpuusage.
