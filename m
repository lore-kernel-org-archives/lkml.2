Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714Ab2HQItM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 04:49:12 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39152 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab2HQIn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 04:43:56 -0400
MIME-Version: 1.0
In-Reply-To: <1345028738.31459.82.camel@twins>
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Fri, 17 Aug 2012 01:43:25 -0700
Message-ID: <CAPM31RKZOk92NS5jrbQXiY7hZO5LRdfPWKt9+pSOS3OvkSrRng@mail.gmail.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in scheduler
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alex Shi <alex.shi@intel.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 4:05 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2012-08-13 at 20:21 +0800, Alex Shi wrote:
>> Since there is no power saving consideration in scheduler CFS, I has a
>> very rough idea for enabling a new power saving schema in CFS.
>
> Adding Thomas, he always delights poking holes in power schemes.
>
>> It bases on the following assumption:
>> 1, If there are many task crowd in system, just let few domain cpus
>> running and let other cpus idle can not save power. Let all cpu take the
>> load, finish tasks early, and then get into idle. will save more power
>> and have better user experience.
>
> I'm not sure this is a valid assumption. I've had it explained to me by
> various people that race-to-idle isn't always the best thing. It has to
> do with the cost of switching power states and the duration of execution
> and other such things.
>
>> 2, schedule domain, schedule group perfect match the hardware, and
>> the power consumption unit. So, pull tasks out of a domain means
>> potentially this power consumption unit idle.
>
> I'm not sure I understand what you're saying, sorry.
>
>> So, according Peter mentioned in commit 8e7fbcbc22c(sched: Remove stale
>> power aware scheduling), this proposal will adopt the
>> sched_balance_policy concept and use 2 kind of policy: performance, power.
>
> Yay, ideally we'd also provide a 3rd option: auto, which simply switches
> between the two based on AC/BAT, UPS status and simple things like that.
> But this seems like a later concern, you have to have something to pick
> between before you can pick :-)
>
>> And in scheduling, 2 place will care the policy, load_balance() and in
>> task fork/exec: select_task_rq_fair().
>
> ack
>
>> Here is some pseudo code try to explain the proposal behaviour in
>> load_balance() and select_task_rq_fair();
>
> Oh man.. A few words outlining the general idea would've been nice.
>
>> load_balance() {
>>       update_sd_lb_stats(); //get busiest group, idlest group data.
>>
>>       if (sd->nr_running > sd's capacity) {
>>               //power saving policy is not suitable for
>>               //this scenario, it runs like performance policy
>>               mv tasks from busiest cpu in busiest group to
>>               idlest  cpu in idlest group;
>
> Once upon a time we talked about adding a factor to the capacity for
> this. So say you'd allow 2*capacity before overflowing and waking
> another power group.
>
> But I think we should not go on nr_running here, PJTs per-entity load
> tracking stuff gives us much better measures -- also, repost that series
> already Paul! :-)

Yes -- I just got back from Africa this week.  It's updated for almost
all the previous comments but I ran out of time before I left to
re-post.  I'm just about caught up enough that I should be able to get
this done over the upcoming weekend.  Monday at the latest.

>
> Also, I'm not sure this is entirely correct, the thing you want to do
> for power aware stuff is to minimize the number of active power domains,
> this means you don't want idlest, you want least busy non-idle.
>
>>       } else {// the sd has enough capacity to hold all tasks.
>>               if (sg->nr_running > sg's capacity) {
>>                       //imbalanced between groups
>>                       if (schedule policy == performance) {
>>                               //when 2 busiest group at same busy
>>                               //degree, need to prefer the one has
>>                               // softest group??
>>                               move tasks from busiest group to
>>                                       idletest group;
>
> So I'd leave the currently implemented scheme as performance, and I
> don't think the above describes the current state.
>
>>                       } else if (schedule policy == power)
>>                               move tasks from busiest group to
>>                               idlest group until busiest is just full
>>                               of capacity.
>>                               //the busiest group can balance
>>                               //internally after next time LB,
>
> There's another thing we need to do, and that is collect tasks in a
> minimal amount of power domains. The old code (that got deleted) did
> something like that, you can revive some of the that code if needed -- I
> just killed everything to be able to start with a clean slate.
>
>
>>               } else {
>>                       //all groups has enough capacity for its tasks.
>>                       if (schedule policy == performance)
>>                               //all tasks may has enough cpu
>>                               //resources to run,
>>                               //mv tasks from busiest to idlest group?
>>                               //no, at this time, it's better to keep
>>                               //the task on current cpu.
>>                               //so, it is maybe better to do balance
>>                               //in each of groups
>>                               for_each_imbalance_groups()
>>                                       move tasks from busiest cpu to
>>                                       idlest cpu in each of groups;
>>                       else if (schedule policy == power) {
>>                               if (no hard pin in idlest group)
>>                                       mv tasks from idlest group to
>>                                       busiest until busiest full.
>>                               else
>>                                       mv unpin tasks to the biggest
>>                                       hard pin group.
>>                       }
>>               }
>>       }
>> }
>
> OK, so you only start to group later.. I think we can do better than
> that.
>
>>
>> sub proposal:
>> 1, If it's possible to balance task on idlest cpu not appointed 'balance
>> cpu'. If so, it may can reduce one more time balancing.
>> The idlest cpu can prefer the new idle cpu;  and is the least load cpu;
>> 2, se or task load is good for running time setting.
>> but it should the second basis in load balancing. The first basis of LB
>> is running tasks' number in group/cpu. Since whatever of the weight of
>> groups is, if the tasks number is less than cpu number, the group is
>> still has capacity to take more tasks. (will consider the SMT cpu power
>> or other big/little cpu capacity on ARM.)
>
> Ah, no we shouldn't balance on nr_running, but on the amount of time
> consumed. Imagine two tasks being woken at the same time, both tasks
> will only run a fraction of the available time, you don't want this to
> exceed your capacity because ran back to back the one cpu will still be
> mostly idle.
>
> What you want it to keep track of a per-cpu utilization level (inverse
> of idle-time) and using PJTs per-task runnable avg see if placing the
> new task on will exceed the utilization limit.

Observations of the runnable average also have the nice property that
it quickly converges to 100% when over-scheduled.

Since we also have the usage average for a single task the ratio of
used avg:runnable avg is likely a useful pointwise estimate.

>
> I think some of the Linaro people actually played around with this,
> Vincent?
>
>> unsolved issues:
>> 1, like current scheduler, it didn't handled cpu affinity well in
>> load_balance.
>
> cpu affinity is always 'fun'.. while there's still a few fun sites in
> the current load-balancer we do better than we did a while ago.
>
>> 2, task group that isn't consider well in this rough proposal.
>
> You mean the cgroup mess?
>
>> It isn't consider well and may has mistaken . So just share my ideas and
>> hope it become better and workable in your comments and discussion.
>
> Very simplistically the current scheme is a 'spread' the load scheme
> (SD_PREFER_SIBLING if you will). We spread load to maximize per-task
> cache and cpu power.
>
> The power scheme should be a 'pack' scheme, where we minimize the active
> power domains.
>
> One way to implement this is to keep track of an active and
> under-utilized power domain (the target) and fail the regular (pull)
> load-balance for all cpus not in that domain. For the cpu that are in
> that domain we'll have find_busiest select from all other under-utilized
> domains pulling tasks to fill our target, once full, we pick a new
> target, goto 1.
>
>
