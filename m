Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab2KLNNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 08:13:18 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:59331 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab2KLNNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 08:13:16 -0500
MIME-Version: 1.0
In-Reply-To: <20121109164631.GA16082@e103034-lin>
References: <1349595838-31274-1-git-send-email-vincent.guittot@linaro.org>
	<1349595838-31274-4-git-send-email-vincent.guittot@linaro.org>
	<50880750.4060809@ti.com>
	<CAKfTPtC29LA15zkgi3gDcet2F841pnqza2_UBwEs6nYUpyKuOQ@mail.gmail.com>
	<5093A63B.2070700@ti.com>
	<20121109164631.GA16082@e103034-lin>
Date: Mon, 12 Nov 2012 14:13:14 +0100
Message-ID: <CAKfTPtAhgj-azt5i1vU+LXFZSj+_rZ=H6F+YCM2dvpxuZ1D+GQ@mail.gmail.com>
Subject: Re: [RFC 3/6] sched: pack small tasks
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "pjt@google.com" <pjt@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 November 2012 17:46, Morten Rasmussen <Morten.Rasmussen@arm.com> wrote:
> On Fri, Nov 02, 2012 at 10:53:47AM +0000, Santosh Shilimkar wrote:
>> On Monday 29 October 2012 06:42 PM, Vincent Guittot wrote:
>> > On 24 October 2012 17:20, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
>> >> Vincent,
>> >>
>> >> Few comments/questions.
>> >>
>> >>
>> >> On Sunday 07 October 2012 01:13 PM, Vincent Guittot wrote:
>> >>>
>> >>> During sched_domain creation, we define a pack buddy CPU if available.
>> >>>
>> >>> On a system that share the powerline at all level, the buddy is set to -1
>> >>>
>> >>> On a dual clusters / dual cores system which can powergate each core and
>> >>> cluster independantly, the buddy configuration will be :
>> >>>         | CPU0 | CPU1 | CPU2 | CPU3 |
>> >>> -----------------------------------
>> >>> buddy | CPU0 | CPU0 | CPU0 | CPU2 |
>> >>
>> >>                          ^
>> >> Is that a typo ? Should it be CPU2 instead of
>> >> CPU0 ?
>> >
>> > No it's not a typo.
>> > The system packs at each scheduling level. It starts to pack in
>> > cluster because each core can power gate independently so CPU1 tries
>> > to pack its tasks in CPU0 and CPU3 in CPU2. Then, it packs at CPU
>> > level so CPU2 tries to pack in the cluster of CPU0 and CPU0 packs in
>> > itself
>> >
>> I get it. Though in above example a task may migrate from say
>> CPU3->CPU2->CPU0 as part of packing. I was just thinking whether
>> moving such task from say CPU3 to CPU0 might be best instead.
>
> To me it seems suboptimal to pack the task twice, but the alternative is
> not good either. If you try to move the task directly to CPU0 you may
> miss packing opportunities if CPU0 is already busy, while CPU2 might
> have enough capacity to take it. It would probably be better to check
> the business of CPU0 and then back off and try CPU2 if CP0 is busy. This
> would require a buddy list for each CPU rather just a single buddy and
> thus might become expensive.
>
>>
>> >>
>> >>> Small tasks tend to slip out of the periodic load balance.
>> >>> The best place to choose to migrate them is at their wake up.
>> >>>
>> >> I have tried this series since I was looking at some of these packing
>> >> bits. On Mobile workloads like OSIdle with Screen ON, MP3, gallary,
>> >> I did see some additional filtering of threads with this series
>> >> but its not making much difference in power. More on this below.
>> >
>> > Can I ask you which configuration you have used ? how many cores and
>> > cluster ?  Can they be power gated independently ?
>> >
>> I have been trying with couple of setups. Dual Core ARM machine and
>> Quad core X86 box with single package thought most of the mobile
>> workload analysis I was doing on ARM machine. On both setups
>> CPUs can be gated independently.
>>
>> >>
>> >>
>> >>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> >>> ---
>> >>>    kernel/sched/core.c  |    1 +
>> >>>    kernel/sched/fair.c  |  109
>> >>> ++++++++++++++++++++++++++++++++++++++++++++++++++
>> >>>    kernel/sched/sched.h |    1 +
>> >>>    3 files changed, 111 insertions(+)
>> >>>
>> >>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> >>> index dab7908..70cadbe 100644
>> >>> --- a/kernel/sched/core.c
>> >>> +++ b/kernel/sched/core.c
>> >>> @@ -6131,6 +6131,7 @@ cpu_attach_domain(struct sched_domain *sd, struct
>> >>> root_domain *rd, int cpu)
>> >>>          rcu_assign_pointer(rq->sd, sd);
>> >>>          destroy_sched_domains(tmp, cpu);
>> >>>
>> >>> +       update_packing_domain(cpu);
>> >>>          update_top_cache_domain(cpu);
>> >>>    }
>> >>>
>> >>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> >>> index 4f4a4f6..8c9d3ed 100644
>> >>> --- a/kernel/sched/fair.c
>> >>> +++ b/kernel/sched/fair.c
>> >>> @@ -157,6 +157,63 @@ void sched_init_granularity(void)
>> >>>          update_sysctl();
>> >>>    }
>> >>>
>> >>> +
>> >>> +/*
>> >>> + * Save the id of the optimal CPU that should be used to pack small tasks
>> >>> + * The value -1 is used when no buddy has been found
>> >>> + */
>> >>> +DEFINE_PER_CPU(int, sd_pack_buddy);
>> >>> +
>> >>> +/* Look for the best buddy CPU that can be used to pack small tasks
>> >>> + * We make the assumption that it doesn't wort to pack on CPU that share
>> >>> the
>> >>
>> >> s/wort/worth
>> >
>> > yes
>> >
>> >>
>> >>> + * same powerline. We looks for the 1st sched_domain without the
>> >>> + * SD_SHARE_POWERLINE flag. Then We look for the sched_group witht the
>> >>> lowest
>> >>> + * power per core based on the assumption that their power efficiency is
>> >>> + * better */
>> >>
>> >> Commenting style..
>> >> /*
>> >>   *
>> >>   */
>> >>
>> >
>> > yes
>> >
>> >> Can you please expand the why the assumption is right ?
>> >> "it doesn't wort to pack on CPU that share the same powerline"
>> >
>> > By "share the same power-line", I mean that the CPUs can't power off
>> > independently. So if some CPUs can't power off independently, it's
>> > worth to try to use most of them to race to idle.
>> >
>> In that case I suggest we use different word here. Power line can be
>> treated as voltage line, power domain.
>> May be SD_SHARE_CPU_POWERDOMAIN ?
>>
>
> How about just SD_SHARE_POWERDOMAIN ?

It looks better than SD_SHARE_POWERLINE. I will replace the name

>
>> >>
>> >> Think about a scenario where you have quad core, ducal cluster system
>> >>
>> >>          |Cluster1|                      |cluster 2|
>> >> | CPU0 | CPU1 | CPU2 | CPU3 |   | CPU0 | CPU1 | CPU2 | CPU3 |
>> >>
>> >>
>> >> Both clusters run from same voltage rail and have same PLL
>> >> clocking them. But the cluster have their own power domain
>> >> and all CPU's can power gate them-self to low power states.
>> >> Clusters also have their own level2 caches.
>> >>
>> >> In this case, you will still save power if you try to pack
>> >> load on one cluster. No ?
>> >
>> > yes, I need to update the description of SD_SHARE_POWERLINE because
>> > I'm afraid I was not clear enough. SD_SHARE_POWERLINE includes the
>> > power gating capacity of each core. For your example above, the
>> > SD_SHARE_POWERLINE shoud be cleared at both MC and CPU level.
>> >
>> Thanks for clarification.
>>
>> >>
>> >>
>> >>> +void update_packing_domain(int cpu)
>> >>> +{
>> >>> +       struct sched_domain *sd;
>> >>> +       int id = -1;
>> >>> +
>> >>> +       sd = highest_flag_domain(cpu, SD_SHARE_POWERLINE);
>> >>> +       if (!sd)
>> >>> +               sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd);
>> >>> +       else
>> >>> +               sd = sd->parent;
>> >>> +
>> >>> +       while (sd) {
>> >>> +               struct sched_group *sg = sd->groups;
>> >>> +               struct sched_group *pack = sg;
>> >>> +               struct sched_group *tmp = sg->next;
>> >>> +
>> >>> +               /* 1st CPU of the sched domain is a good candidate */
>> >>> +               if (id == -1)
>> >>> +                       id = cpumask_first(sched_domain_span(sd));
>> >>> +
>> >>> +               /* loop the sched groups to find the best one */
>> >>> +               while (tmp != sg) {
>> >>> +                       if (tmp->sgp->power * sg->group_weight <
>> >>> +                                       sg->sgp->power *
>> >>> tmp->group_weight)
>> >>> +                               pack = tmp;
>> >>> +                       tmp = tmp->next;
>> >>> +               }
>> >>> +
>> >>> +               /* we have found a better group */
>> >>> +               if (pack != sg)
>> >>> +                       id = cpumask_first(sched_group_cpus(pack));
>> >>> +
>> >>> +               /* Look for another CPU than itself */
>> >>> +               if ((id != cpu)
>> >>> +                || ((sd->parent) && !(sd->parent->flags &&
>> >>> SD_LOAD_BALANCE)))
>> >>
>> >> Is the condition "!(sd->parent->flags && SD_LOAD_BALANCE)" for
>> >> big.LITTLE kind of system where SD_LOAD_BALANCE may not be used ?
>> >
>> > No, packing small tasks is part of the load balance so if the
>> > LOAD_BALANCE flag is cleared, we will not try to pack which is a kind
>> > of load balance. There is no link with big.LITTLE
>> >
>> Now it make sense to me.
>>
>> >>
>> >>
>> >>> +                       break;
>> >>> +
>> >>> +               sd = sd->parent;
>> >>> +       }
>> >>> +
>> >>> +       pr_info(KERN_INFO "CPU%d packing on CPU%d\n", cpu, id);
>> >>> +       per_cpu(sd_pack_buddy, cpu) = id;
>> >>> +}
>> >>> +
>> >>>    #if BITS_PER_LONG == 32
>> >>>    # define WMULT_CONST  (~0UL)
>> >>>    #else
>> >>> @@ -3073,6 +3130,55 @@ static int select_idle_sibling(struct task_struct
>> >>> *p, int target)
>> >>>          return target;
>> >>>    }
>> >>>
>> >>> +static inline bool is_buddy_busy(int cpu)
>> >>> +{
>> >>> +       struct rq *rq = cpu_rq(cpu);
>> >>> +
>> >>> +       /*
>> >>> +        * A busy buddy is a CPU with a high load or a small load with a
>> >>> lot of
>> >>> +        * running tasks.
>> >>> +        */
>> >>> +       return ((rq->avg.usage_avg_sum << rq->nr_running) >
>> >>> +                       rq->avg.runnable_avg_period);
>> >>
>> >> I agree busy CPU is the one with high load, but many small threads may
>> >> not make CPU fully busy, right ? Should we just stick to the load
>> >> parameter alone here ?
>> >
>> > IMO, the busy state of a CPU isn't only the load but also how many
>> > threads are waiting for running on it. This formula tries to take into
>> > account both inputs. If you have dozen of small tasks on a CPU, the
>> > latency can be large even if the tasks are small.
>> >
>> Sure. Your point is to avoid throttling and probably use race for
>> idle.
>>
>> >>
>> >>
>> >>> +}
>> >>> +
>> >>> +static inline bool is_light_task(struct task_struct *p)
>> >>> +{
>> >>> +       /* A light task runs less than 25% in average */
>> >>> +       return ((p->se.avg.usage_avg_sum << 2) <
>> >>> p->se.avg.runnable_avg_period);
>> >>> +}
>> >>
>> >> Since the whole packing logic relies on the light threads only, the
>> >> overall effectiveness is not significant. Infact with multiple tries on
>> >> Dual core system, I didn't see any major improvement in power. I think
>> >> we need to be more aggressive here. From the cover letter, I noticed
>> >> that, you were concerned about any performance drop due to packing and
>> >> may be that is the reason you chose the conservative threshold. But the
>> >> fact is, if we want to save meaningful power, there will be slight
>> >> performance drop which is expected.
>> >
>> > I think that everybody agrees that packing small tasks will save power
>> > whereas it seems to be not so obvious for heavy task. But I may have
>> > set the threshold a bit too low
>> >
>> I agree on packing saves power part for sure.
>>
>
> I'm not fully convinced that packing always saves power. For systems
> with multiple cpu clusters where each cluster is a power domain and the
> cpus have no individual power saving states it would probably be more
> power efficient to spread the tasks and hope for more opportunities for
> hitting cluster shutdown. If all tasks are packed on one cpu it will
> keep the whole cluster up, while the remaining cpus are idling without
> possibility for entering efficient power states.
>
> Regards,
> Morten
>
>> > Up to which load, you would like to pack on 1 core of your dual core system ?
>> > Can you provide more details of your load ? Have you got a trace that
>> > you can share ?
>> >
>> More than how much load to pack, I was more looking from the power
>> savings delta we can achieve by doing it. Some of the usecases like
>> osidle, mp3, gallary are already very low power and that might be
>> the reason I didn't notice major mA delta. Though the perf
>> traces did show some filtering even at 25 % load. i tried upto
>> 50 % threshold to see the effectiveness and there was more
>> improvement and hence the suggestion about aggressiveness.
>>
>> May be you can try some of these use-cases on your setup instead of
>> synthetic workload and see the results.
>>
>> Regards
>> Santosh
>>
>>
>>
>>
>> _______________________________________________
>> linaro-dev mailing list
>> linaro-dev@lists.linaro.org
>> http://lists.linaro.org/mailman/listinfo/linaro-dev
>>
>
