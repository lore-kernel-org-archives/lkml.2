Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab0JKVUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 17:20:43 -0400
Received: from smtp-out.google.com ([74.125.121.35]:23313 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab0JKVUm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 17:20:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jv4ofLTgHea+Zif6lHK4S/5jJvOwCBUx0L7quU/+awjtl0jEkFKhjhCWNPoyG7jk8/
         BITjJhiWv7IyZvNA2ueA==
MIME-Version: 1.0
In-Reply-To: <1285715096.2623.37.camel@sbsiddha-MOBL3>
References: <1285633798-26886-1-git-send-email-ncrao@google.com>
 <1285633798-26886-3-git-send-email-ncrao@google.com> <1285715096.2623.37.camel@sbsiddha-MOBL3>
From: Nikhil Rao <ncrao@google.com>
Date: Mon, 11 Oct 2010 14:20:17 -0700
Message-ID: <AANLkTi=wKmOBDBf9RD07_3M9hfMbOT7A+X22rGvqsk3=@mail.gmail.com>
Subject: Re: [PATCH 2/3] sched: drop group_capacity to 1 only if remote group
 has no running tasks
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, Venkatesh Pallipadi <venki@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suresh,

Sorry for the delayed reply.

On Tue, Sep 28, 2010 at 4:04 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Mon, 2010-09-27 at 17:29 -0700, Nikhil Rao wrote:
>> When SD_PREFER_SIBLING is set on a sched domain, drop group_capacity to 1
>> only if the remote sched group has no running tasks. This addresses the case
>> where you have two tasks on one socket and the other socket is idle, in which
>> case you drop the capacity to 1. If the remote group has >=1 running task, then
>> there is no difference from a cache-sharing perspective.
>>
>> Signed-off-by: Nikhil Rao <ncrao@google.com>
>> ---
>>  kernel/sched_fair.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> index de8a6a0..33a7985 100644
>> --- a/kernel/sched_fair.c
>> +++ b/kernel/sched_fair.c
>> @@ -2548,7 +2548,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
>>                * first, lower the sg capacity to one so that we'll try
>>                * and move all the excess tasks away.
>>                */
>> -             if (prefer_sibling)
>> +             if (prefer_sibling && !sgs.sum_nr_running)
>>                       sgs.group_capacity = min(sgs.group_capacity, 1UL);
>>
>>               if (local_group) {
>
> Nikhil, Doesn't this break the case of:
>
> two sockets with dual-core and HT. Four tasks currently scheduled as:
> three on socket-0 (two threads on core-0 running two tasks and 1 thread
> on core-1 running one task). One on socket-1 (one thread on core-0
> running a task, with other core-1 idle)
>
> We would like to move the task from core-0 socket-0 to core-1 socket-1,
> while we are load balancing at the socket level (it might be smp or numa
> level depending on system).
>
> thanks,
> suresh
>

Thanks for raising this issue. Yes, when you have a quad-core,
dual-socket machine, the additional check will prevent group_capacity
from dropping down to 1. In this situation, we want to decrease
group_capacity if the local group has extra capacity (i.e.
this_nr_running < this_group_weight) [credit goes to Venki for this
insight]. This also works when you have a niced task, which is what
this patch was trying to fix. I have attached a modified version of
the patch below. Does this look OK?

-Thanks,
Nikhil

---
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index de8a6a0..e0f697a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2030,6 +2030,7 @@ struct sd_lb_stats {
        unsigned long this_load;
        unsigned long this_load_per_task;
        unsigned long this_nr_running;
+       unsigned long this_group_capacity;

        /* Statistics of the busiest group */
        unsigned long max_load;
@@ -2548,7 +2549,8 @@ static inline void update_sd_lb_stats(struct
sched_domain *sd, int this_cpu,
                 * first, lower the sg capacity to one so that we'll try
                 * and move all the excess tasks away.
                 */
-               if (prefer_sibling)
+               if (prefer_sibling && !local_group &&
+                   sds->this_nr_running < sds->this_group_capacity)
                        sgs.group_capacity = min(sgs.group_capacity, 1UL);

                if (local_group) {
@@ -2556,6 +2558,7 @@ static inline void update_sd_lb_stats(struct
sched_domain *sd, int this_cpu,
                        sds->this = sg;
                        sds->this_nr_running = sgs.sum_nr_running;
                        sds->this_load_per_task = sgs.sum_weighted_load;
+                       sds->this_group_capacity = sgs.group_capacity;
                } else if (update_sd_pick_busiest(sd, sds, sg, &sgs,
this_cpu)) {
                        sds->max_load = sgs.avg_load;
                        sds->busiest = sg;
