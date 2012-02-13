Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab2BMRWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:22:47 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50316 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab2BMRWq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:22:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAJd=RBD+x8SHkMPqxRGwmm90wvj2b_2bAdexxo6w39_ngGgHdA@mail.gmail.com>
References: <CADZ9YHhOfVm7qNj6oznmRCUuyyA4BQfmsd-M7FzrmWB9SxMgzg@mail.gmail.com>
	<CAJd=RBD+x8SHkMPqxRGwmm90wvj2b_2bAdexxo6w39_ngGgHdA@mail.gmail.com>
Date: Mon, 13 Feb 2012 23:22:45 +0600
Message-ID: <CADZ9YHhGWd9DToiQDbvv4=BvN4DZLJMuvyLNUHjWqErGE3nXzQ@mail.gmail.com>
Subject: Re: [ANNOUNCEMENT] The Barbershop Load Distribution algorithm for
 Linux kernel scheduler.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hillf,

On Mon, Feb 13, 2012 at 8:05 PM, Hillf Danton <dhillf@gmail.com> wrote:
> Hello Rakib
>
> Just nitpicks
>
> On Mon, Feb 13, 2012 at 2:52 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> [...]
>> --- /dev/null
>> +++ b/kernel/sched/bld.h
>> @@ -0,0 +1,112 @@
>> +#ifdef CONFIG_BLD
>> +
>> +static DEFINE_RWLOCK(disp_list_lock);
>
> What is the advantage of rwlock, compared with spin lock?
>
It separates reader writers and allows multiple readers can be at a
same critical reason.

>> +static LIST_HEAD(rq_head);
>> +
>> +static inline int list_is_first(const struct list_head *list,
>
> Where is this helper used?
>
I forget to remove this function. Actually, this whole bld is under
development, I'm constantly trying to improve it. Above helper was
used to find out - whether a particular rq is the first (lowest
loaded) list in this doubly linked list or not. But, later on it
wasn't used due to introduction of "rq->pos" field. The purpose of
->pos field is to indicate whether a rq is a last or first or in
between last and first. In this way, we can
 check whether a rq is the last or first or in between last and first
without holding rwlock.

>> +                               const struct list_head *head)
>> +{
>> +       return list == head->next;
>> +}
>> +
>> +static inline int select_cpu_for_wakeup(struct task_struct *p, int
>> sd_flags, int wake_flags)
>
> Looks @sd_flags not used.

Yes, sd_flag isn't needed here. Will remove it.

> Why is the arch specifics negligible?

I'm not clear what you're trying to say.

> Also looks message corrupted due to mail agent?
>
Perhaps, will be careful later on.

>> +{
>> +       int cpu = smp_processor_id(), prev_cpu = task_cpu(p), i;
>
>            int this_cpu = smp_processor_id();
>            int prev_cpu = task_cpu(p);
>            int cpu;
>
>> +       /*bool sync = wake_flags & WF_SYNC; */
>> +       unsigned long load, min_load = ULONG_MAX;
>> +       struct cpumask *mask;
>> +
>> +       if (wake_flags & WF_SYNC) {
>> +               if (cpu == prev_cpu)
>> +                       return cpu;
>> +               mask = sched_group_cpus(cpu_rq(prev_cpu)->sd->groups);
>> +       } else
>> +               mask = sched_domain_span(cpu_rq(prev_cpu)->sd);
>> +
>> +       for_each_cpu(i, mask) {
>> +               load = cpu_rq(i)->load.weight;
>> +               if (load < min_load) {
>> +                       min_load = load;
>> +                       cpu = i;
>> +               }
>> +       }
>> +       return cpu;
>> +}
>> +
>> +static int bld_select_task_rq(struct task_struct *p, int sd_flags,
>> int wake_flags)
>
> Message corrupted?
>
>> +{
>> +       struct rq *tmp;
>> +       unsigned long flag;
>> +       unsigned int cpu = smp_processor_id();
>> +
>> +       if (&p->cpus_allowed) {
>> +               struct cpumask *taskmask;
>> +               unsigned long min_load = ULONG_MAX, load, i;
>> +               taskmask = tsk_cpus_allowed(p);
>> +               for_each_cpu(i, taskmask) {
>> +                       load = cpu_rq(i)->load.weight;
>> +                       if (load < min_load) {
>> +                               min_load = load;
>> +                               cpu = i;
>> +                       }
>> +               }
>> +       } else  if (sd_flags & SD_BALANCE_WAKE) {
>> +               cpu = select_cpu_for_wakeup(p, sd_flags, wake_flags);
>> +               return cpu;
>> +       } else {
>> +               read_lock_irqsave(&disp_list_lock, flag);
>> +               list_for_each_entry(tmp, &rq_head, disp_load_balance) {
>> +                       cpu = cpu_of(tmp);
>> +                       if (cpu_online(cpu))
>> +                               break;
>> +               }
>> +               read_unlock_irqrestore(&disp_list_lock, flag);
>> +       }
>> +       return cpu;
>> +}
>> +
>> +static void bld_track_load_activate(struct rq *rq)
>> +{
>> +       unsigned long  flag;
>> +       rq->this_cpu_load = rq->load.weight;
>
> Well ->this_cpu_load looks unnecessary?
>
->this_cpu_load was used intentionally to maintain a separate field
cause a cross rq check is required later
and I'm not sure whether doing over rq->load.weight is safe or not.

>> +
>> +       if (rq->pos != 2) {     /* if rq isn't the last one */
>> +               struct rq *last;
>> +               write_lock_irqsave(&disp_list_lock, flag);
>
>                    if (rq->pos != 2)
>                             goto out;
>
At this point, we're checking whether this task is activating on a rq
which is the last (hightest loaded) rq or not. If rq->pos != 2, it
stands we're not activating a task at the highest loaded rq, so a
check will be made with the highest loaded rq to make sure - this rq's
loaded didn't exceed the highest loaded rq. If rq's load
exceed - list will be removed from it's place and will be placed as a
last entry of rq_head and thus it becomes the highest loaded rq. So,
what you proposed here isn't what was intended.

>> +               last = list_entry(rq_head.prev, struct rq, disp_load_balance);
>
> Could disp_list_lock serialize updating this_cpu_load?
>
>> +               if (rq->this_cpu_load > last->this_cpu_load) {
>> +                       list_del(&rq->disp_load_balance);
>> +                       list_add_tail(&rq->disp_load_balance, &rq_head);
>> +                       rq->pos = 2; last->pos = 1;
>> +               }
>
> out:
>
>> +               write_unlock_irqrestore(&disp_list_lock, flag);
>> +       }
>> +}
>> +
>> +static void bld_track_load_deactivate(struct rq *rq)
>> +{
>> +       unsigned long flag;
>> +
>> +       rq->this_cpu_load = rq->load.weight;
>> +
>> +       if (rq->pos != 0) { /* If rq isn't first one */
>> +               struct rq *first;
>> +               first = list_entry(rq_head.prev, struct rq, disp_load_balance);
>> +               write_lock_irqsave(&disp_list_lock, flag);
>> +               if (rq->this_cpu_load <= first->this_cpu_load) {
>> +                       list_del(&rq->disp_load_balance);
>> +                       list_add_tail(&rq->disp_load_balance, &rq_head);
>> +                       rq->pos = 0; first->pos = 1;
>> +               }
>> +               write_unlock_irqrestore(&disp_list_lock, flag);
>> +       }
>> +}
>> +#else
>> +static inline void bld_track_load_activate(struct rq *rq)
>> +{
>> +}
>> +
>> +static inline void bld_track_load_deactivate(struct rq *rq)
>> +{
>> +}
>> +#endif /* CONFIG_BLD */
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 5255c9d..cff20e1 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -24,6 +24,8 @@
>>  *  2007-07-01  Group scheduling enhancements by Srivatsa Vaddagiri
>>  *  2007-11-29  RT balancing improvements by Steven Rostedt, Gregory Haskins,
>>  *              Thomas Gleixner, Mike Kravetz
>> + *  2012-Feb   The Barbershop Load Distribution (BLD) algorithm, an alternate
>> + *             load distribution algorithm by Rakib Mullick.
>>  */
>>
>>  #include <linux/mm.h>
>> @@ -81,6 +83,7 @@
>>
>>  #include "sched.h"
>>  #include "../workqueue_sched.h"
>> +#include "bld.h"
>>
>>  #define CREATE_TRACE_POINTS
>>  #include <trace/events/sched.h>
>> @@ -578,6 +581,7 @@ unlock:
>>  */
>>  void wake_up_idle_cpu(int cpu)
>>  {
>> +#ifndef CONFIG_BLD
>>        struct rq *rq = cpu_rq(cpu);
>>
>>        if (cpu == smp_processor_id())
>> @@ -604,6 +608,7 @@ void wake_up_idle_cpu(int cpu)
>>        smp_mb();
>>        if (!tsk_is_polling(rq->idle))
>>                smp_send_reschedule(cpu);
>> +#endif
>>  }
>>
>>  static inline bool got_nohz_idle_kick(void)
>> @@ -730,6 +735,7 @@ void activate_task(struct rq *rq, struct
>> task_struct *p, int flags)
>>                rq->nr_uninterruptible--;
>>
>>        enqueue_task(rq, p, flags);
>> +       bld_track_load_activate(rq);
>
> Looks better if sorting rq folded in enqueue_task()?
>
Any particular reason for that?

>>  }
>>
>>  void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
>> @@ -738,6 +744,7 @@ void deactivate_task(struct rq *rq, struct
>> task_struct *p, int flags)
>>                rq->nr_uninterruptible++;
>>
>>        dequeue_task(rq, p, flags);
>> +       bld_track_load_deactivate(rq);
>>  }
>>
>>  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
>> @@ -1297,7 +1304,12 @@ static int select_fallback_rq(int cpu, struct
>> task_struct *p)
>>  static inline
>>  int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
>>  {
>> -       int cpu = p->sched_class->select_task_rq(p, sd_flags, wake_flags);
>> +       int cpu;
>> +#ifdef CONFIG_BLD
>> +       cpu = bld_select_task_rq(p, sd_flags, wake_flags);
>
> What if @p is RT?
>
bld_select_task_rq() will be called. :)

Hiff, did you ran the patch? Would like to know.

Thanks,
Rakib
