Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534Ab2GLAMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 20:12:32 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60395 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab2GLAMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 20:12:30 -0400
MIME-Version: 1.0
In-Reply-To: <1341489508.19870.30.camel@laptop>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
 <20120628022415.30496.57167.stgit@kitami.mtv.corp.google.com> <1341489508.19870.30.camel@laptop>
From: Paul Turner <pjt@google.com>
Date: Wed, 11 Jul 2012 17:11:59 -0700
Message-ID: <CAPM31RJoLTCM+DPpPk7bsks6Nb8mLNba9CC+Et4vBnMM3rdENw@mail.gmail.com>
Subject: Re: [PATCH 12/16] sched: refactor update_shares_cpu() -> update_blocked_avgs()
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 4:58 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-06-27 at 19:24 -0700, Paul Turner wrote:
>> Now that running entities maintain their own load-averages the work we must do
>> in update_shares() is largely restricted to the periodic decay of blocked
>> entities.  This allows us to be a little less pessimistic regarding our
>> occupancy on rq->lock and the associated rq->clock updates required.
>
> So what you're saying is that since 'weight' now includes runtime
> behaviour (where we hope the recent past matches the near future) we
> don't need to update shares quite as often since the effect of
> sleep-wakeup cycles isn't near as big since they're already anticipated.


Not quite: This does not decrease the frequency of updates.

Rather:
The old code used to take and release rq->lock (nested under rcu)
about updating *every* single task-group.

This is because the amount of work that we would have to do to update
a group was not deterministic (we did not know how many times  we'd
have to fold our load average sums).  The new code just says, since
this work is deterministic, let's thrash that lock less.  I suspect 10
is an incredibly conservative value, we probably want something more
like 100.  (But on the flip-side, I don't want to time out on the
wacko machine with 2000 cgroups, so I do have to release at SOME
point.)


> So how is the decay of blocked load still significant, surely that too
> is mostly part of the anticipated sleep/wake cycle already caught in the
> runtime behaviour.

RIght but the run-time behavior only lets us update things while
they're running.

This maintains periodic updates (and hence load-decay) on a group
that's sent everything to sleep.

>
> Or is this the primary place where we decay? If so that wasn't obvious
> and thus wants a comment someplace.
>

For a group with no runnable entities, yes.  For a group with runnable
entities this will also occur naturally about updates for the
aforementioned runnables.

I'll add a comment calling out the blocked case.

>> Signed-off-by: Paul Turner <pjt@google.com>
>> ---
>
>> +static void update_blocked_averages(int cpu)
>>  {
>>       struct rq *rq = cpu_rq(cpu);
>> +     struct cfs_rq *cfs_rq;
>> +
>> +     unsigned long flags;
>> +     int num_updates = 0;
>>
>>       rcu_read_lock();
>> +     raw_spin_lock_irqsave(&rq->lock, flags);
>> +     update_rq_clock(rq);
>>       /*
>>        * Iterates the task_group tree in a bottom up fashion, see
>>        * list_add_leaf_cfs_rq() for details.
>>        */
>>       for_each_leaf_cfs_rq(rq, cfs_rq) {
>> +             __update_blocked_averages_cpu(cfs_rq->tg, rq->cpu);
>>
>> +             /*
>> +              * Periodically release the lock so that a cfs_rq with many
>> +              * children cannot hold it for an arbitrary period of time.
>> +              */
>> +             if (num_updates++ % 20 == 0) {
>> +                     raw_spin_unlock_irqrestore(&rq->lock, flags);
>> +                     cpu_relax();
>> +                     raw_spin_lock_irqsave(&rq->lock, flags);
>
> Gack.. that's not real pretty is it.. Esp. since we're still holding RCU
> lock and are thus (mostly) still not preemptable.
>
> How much of a problem was this?, the changelog is silent on this.

So the holding of RCU about these operations is nothing new (and
indeed they should be much faster than before).

As above, the bound is only for the crazy-large-numbers of cgroups
case where we don't want to sit on with interrupts disabled forever.
I suspect it wants to be larger, but picked a fairly conservative
number to start with since I also think it's not a big performance
factor either way.

>
>> +                     update_rq_clock(rq);
>> +             }
>>       }
>> +
>> +     raw_spin_unlock_irqrestore(&rq->lock, flags);
>>       rcu_read_unlock();
>>  }
>>
>
>
>
