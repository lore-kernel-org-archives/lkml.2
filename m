Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab2BQLdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 06:33:00 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54833 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2BQLc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 06:32:59 -0500
MIME-Version: 1.0
In-Reply-To: <1329411510.2293.254.camel@twins>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
 <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com> <1329411510.2293.254.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Fri, 17 Feb 2012 03:32:28 -0800
Message-ID: <CAPM31R+xLCnPE10SZRYnTMe=O=j5mZEoutH=e3npw5xKOS_s7w@mail.gmail.com>
Subject: Re: [RFC PATCH 14/14] sched: implement usage tracking
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 8:58 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-02-01 at 17:38 -0800, Paul Turner wrote:
>>  struct sched_avg {
>>         u64 runnable_avg_sum, runnable_avg_period;
>>         u64 last_runnable_update, decay_count;
>> +       u32 usage_avg_sum;
>
> 4 byte hole
>
>>         unsigned long load_avg_contrib;
>>
>>         int contributes_blocked_load;
>>};
>
>
> A) Running/Runnable
>    - uses last_runnable_update to track
>        runnable_avg_sum, usage_avg_sum and runnable_avg_period

Yes, with the runnable average being runnable_avg_sum / runnable_avg_period

>
> B) Blocked
>    - uses decay_count to keep track of sleeptime

Not quite (we could track sleep-time explicitly about clock_task after all).

We need decay-count to synchronize against entity_tick /
update_blocked_shares accounting decays against
cfs_rq->blocked_load_sum.

Since we do not know where we slept relative to the tick, unless we
explicitly track where this occurred we don't know for a "n.y" jiffy
sleep whether the "0.y" fraction included an extra decay.  It's
important to get this right to reduce instability, since when the
entity wakes back up we need to charge an equivalent decay against
it's contribution before we can remove it from the blocked_load_sum.

For the common case of a short sleep whether we charge an extra period
(if y included a jiffy edge) or not is significant to stability since
getting it wrong means we leave a little extra load in blocked_load.

Further complicating this we need to be able to do said
synchronization in the annoying cases of wake-up migration (where we
don't hold the lock on previous rq) and 32-bit machines (where
everything sucks).

>
> C) 'Migrate'
>    - uses contributes_blocked_load to check if we actually did migrate?
>

We actually use se->avg.decay_count to check whether we were migrated
(setting it appropriately at migration); contributes_blocked_load is
just a convenience variable to track whether we're a part of
cfs_rq->blocked_load_avg or not.

I have to double-check everything but I think the sign of
se->decay_count can be used equivalently so I'll likely just remove it
in favor of that.  Although in order to keep things readable I'll
replace it a similarly named function that does this sign check.)

> So there's a number of things I don't get, why have
> remove_task_load_avg_async() in set_task_rq()? enqueue_entity_load_avg()
> can do the __synchronize_entity_decay() thing (and actually does) just
> fine, right?

Wake-up migration is the nuisance here.

In this case we:
A) Don't know where we came from in enqueue_entity_load_avg to
synchronize the decay against
B) Need to be able to remove the blocked load possessed by said waking
entity against its former cfs_rq->blocked_load_sum

There's a one or two other paths (than ttwu) that this matters for,
using set_task_rq() gets them all.

>
> Similarly, why not use last_runnable_update (as last_update) to track
> both A and B since a task cannot be in both states at the same time
> anyway. If you always update the timestamp you can use it to either
> track runnable/usage or decay for sleep.

This is pretty much exactly what we do (use it to track both A and B);
modulo the complications surrounding decay for sleep explained above
and below.

There's two things at play here:
1) An entity's runnable_avg :=  runnable_avg_sum / runnable_avg_period
2) An entity's load contribution := runnable_avg_sum /
runnable_avg_period * entity_weight

The load contribution is what we added to blocked_load_sum.  When we
wake back up we synchronize decays against this and remove it from the
sum.  However, decay into this is really just an imperfect
approximation (alignment of when we actually slept vs tick)

As soon as it's actually running again we:
- Adjust our load contrib by decay so that we can remove the right
amount from blocked_load_sum
- Charge the time since last_runnable_update as not running
- Compute a new, *accurate* load_contrib from (1) above, throwing away
the decayed previous one
- Add the new accurate calculation into the running load sum

The nice thing is that when we start this cycle again when the entity
next blocks we don't compound the losses of precision due to aligning
decay vs ticks since we get to throw away that number and do an
accurate accounting based on runnable_avg again.

>
> That would get rid of decay_count and contributes_blocked_load, no?
