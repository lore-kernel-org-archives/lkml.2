Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0JOQNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 12:13:32 -0400
Received: from smtp-out.google.com ([74.125.121.35]:15120 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab0JOQNb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 12:13:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=se/eR8mjBUUUiwXBfq5CwWF0qD1hQjlKW8SXExwoj7D4htPuuAoY2q878Q7fhey0r5
         EOaVdY068nd75YiiLcUw==
MIME-Version: 1.0
In-Reply-To: <1287143423.29097.1460.camel@twins>
References: <1286996978-7007-4-git-send-email-ncrao@google.com>
 <1287035281-25579-1-git-send-email-ncrao@google.com> <1287143423.29097.1460.camel@twins>
From: Nikhil Rao <ncrao@google.com>
Date: Fri, 15 Oct 2010 09:13:04 -0700
Message-ID: <AANLkTinotiJqfvr9D2yTkuaLDKPcaUaG1dU1goRK8Bi+@mail.gmail.com>
Subject: Re: [PATCH 3/4] sched: drop group_capacity to 1 only if local group
 has extra capacity
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 4:50 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-10-13 at 22:48 -0700, Nikhil Rao wrote:
>> Resending this patch since the original patch was munged. Thanks to Mike
>> Galbraith for pointing this out.
>>
>> When SD_PREFER_SIBLING is set on a sched domain, drop group_capacity to 1
>> only if the local group has extra capacity. For niced task balancing, we pull
>> low weight tasks away from a sched group as long as there is capacity in other
>> groups. When all other groups are saturated, we do not drop capacity of the
>> niced group down to 1. This prevents active balance from kicking out the low
>> weight threads and which hurts system utilization.
>>
>> Signed-off-by: Nikhil Rao <ncrao@google.com>
>> ---
>>  kernel/sched_fair.c |    8 ++++++--
>>  1 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> index 0dd1021..da0c688 100644
>> --- a/kernel/sched_fair.c
>> +++ b/kernel/sched_fair.c
>> @@ -2030,6 +2030,7 @@ struct sd_lb_stats {
>>       unsigned long this_load;
>>       unsigned long this_load_per_task;
>>       unsigned long this_nr_running;
>> +     unsigned long this_group_capacity;
>>
>>       /* Statistics of the busiest group */
>>       unsigned long max_load;
>> @@ -2546,15 +2547,18 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
>>               /*
>>                * In case the child domain prefers tasks go to siblings
>>                * first, lower the sg capacity to one so that we'll try
>> -              * and move all the excess tasks away.
>> +              * and move all the excess tasks away. We lower capacity only
>> +              * if the local group can handle the extra capacity.
>>                */
>> -             if (prefer_sibling)
>> +             if (prefer_sibling && !local_group &&
>> +                 sds->this_nr_running < sds->this_group_capacity)
>>                       sgs.group_capacity = min(sgs.group_capacity, 1UL);
>>
>>               if (local_group) {
>>                       sds->this_load = sgs.avg_load;
>>                       sds->this = sg;
>>                       sds->this_nr_running = sgs.sum_nr_running;
>> +                     sds->this_group_capacity = sgs.group_capacity;
>>                       sds->this_load_per_task = sgs.sum_weighted_load;
>>               } else if (update_sd_pick_busiest(sd, sds, sg, &sgs, this_cpu)) {
>>                       sds->max_load = sgs.avg_load;
>
>
> OK, this thing confuses me, that changelog nor the comment actually seem
> to help with understanding this..
>

Here's some context for this patch. Consider a 16-cpu quad-core
quad-socket machine with MC and NUMA scheduling domains. Let's say we
spawn 15 nice0 tasks and one nice-15 task, and each task is running on
one core. In this case, we observe the following events when balancing
at the NUMA domain:
- find_busiest_group() will always pick the sched group containing the
niced task to be the busiest group.
- find_busiest_queue() will then always pick one of the cpus running
the nice0 task (never picks the cpu with the nice -15 task since
weighted_cpuload > imbalance).
- The load balancer fails to migrate the task since it is the running
task and increments sd->nr_balance_failed.
- It repeats the above steps a few more times until
sd->nr_balance_failed > 5, at which point it kicks off the active load
balancer, wakes up the migration thread and kicks the nice 0 task off
the cpu.

The load balancer doesn't stop until we kick out all nice 0 tasks from
the sched group, leaving you with 3 idle cpus and one cpu running the
nice -15 task.

The problem is that, when balancing at the NUMA domain, we always drop
sgs.group_capacity to 1 if the child domain (in this case MC) has
SD_PREFER_SIBLING set.  Once we drop the sgs.group_capacity, the
subsequent load comparisons were kinda irrelevant because the niced
task has so much weight. In this patch, we add an extra condition to
the "if(prefer_sibling)" check in update_sd_lb_stats(). We drop the
capacity of a group only if the local group has extra capacity (i.e.
if local_group->sum_nr_running < local_group->group_capacity). If I
understand correctly, the original intent of the prefer_siblings check
was to spread tasks across the system in low utilization scenarios.
This patch preserves that intent but also fixes the case above.

It helps in the following ways:
- In low utilization cases (where nr_tasks << nr_cpus), we still drop
group_capacity down to 1 if we prefer siblings -- nothing changes.
- On very busy systems (where nr_tasks >> nr_cpus), sgs.nr_running
will most likely be > sgs.group_capacity, so again -- nothing changes.
- When balancing large weight tasks, if the local group does not have
extra capacity, we do not pick the group with the niced task as the
busiest group. This prevents failed balances, active migration and the
under-utilization described above.

Hope that clarifies the intent of this patch. I will refresh this
patch with a better changelog and comment.

-Thanks,
Nikhil
