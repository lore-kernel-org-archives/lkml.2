Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab1BYDe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 22:34:27 -0500
Received: from smtp-out.google.com ([216.239.44.51]:18704 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab1BYDeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 22:34:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hjKcR1C9yZIr6JEQ93yUKe0/krgV/9V+GCxX3x//20UtBev25XeTWWJurFjwgo2Chy
         gYtkw1AvwI+euIALUr4w==
MIME-Version: 1.0
In-Reply-To: <1298467934.2217.766.camel@twins>
References: <20110216031831.571628191@google.com> <20110216031840.979831163@google.com>
 <1298467934.2217.766.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Thu, 24 Feb 2011 19:33:53 -0800
Message-ID: <AANLkTik0t6LJNEwN5vYn6Dvx-xg6Agf=W7R6Hqh0s0Y+@mail.gmail.com>
Subject: Re: [CFS Bandwidth Control v4 2/7] sched: accumulate per-cfs_rq cpu usage
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
>> @@ -609,6 +631,9 @@ static void update_curr(struct cfs_rq *c
>>               cpuacct_charge(curtask, delta_exec);
>>               account_group_exec_runtime(curtask, delta_exec);
>>       }
>> +#ifdef CONFIG_CFS_BANDWIDTH
>> +     account_cfs_rq_quota(cfs_rq, delta_exec);
>> +#endif
>>  }
>
> Not too hard to make the #ifdef'ery go away I'd guess.
>

Done

>>  static inline void
>> @@ -1382,6 +1407,43 @@ static void dequeue_task_fair(struct rq
>>  }
>>
>>  #ifdef CONFIG_CFS_BANDWIDTH
>> +static u64 tg_request_cfs_quota(struct task_group *tg)
>> +{
>> +     struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
>> +     u64 delta = 0;
>> +
>> +     if (cfs_b->runtime > 0 || cfs_b->quota == RUNTIME_INF) {
>> +             raw_spin_lock(&cfs_b->lock);
>> +             /*
>> +              * it's possible a bandwidth update has changed the global
>> +              * pool.
>> +              */
>> +             if (cfs_b->quota == RUNTIME_INF)
>> +                     delta = sched_cfs_bandwidth_slice();
>
> Why do we bother at all when there's infinite time? Shouldn't the action
> that sets it to infinite also make cfs_rq->quota_assinged to to
> RUNTIME_INF, in which case the below check will make it all go away?
>

The request for bandwidth might be racing with an entity's request for
bandwidth.

e.g. someone updates cpu.cfs_quota_us to infinite while there's
bandwidth distribution in flight.

In this case we need to return some sane value so that the thread
requesting bandwidth can complete that operation (releasing the lock
which will then be taken to set quota_assigned to INF).

But more importantly we don't want to decrement the value doled out
FROM cfs_b->runtime since that would change it from the magic
RUNTIME_INF.  That's why the check exists.


>> +             else {
>> +                     delta = min(cfs_b->runtime,
>> +                                     sched_cfs_bandwidth_slice());
>> +                     cfs_b->runtime -= delta;
>> +             }
>> +             raw_spin_unlock(&cfs_b->lock);
>> +     }
>> +     return delta;
>> +}
>
> Also, shouldn't this all try and steal time from other cpus when the
> global limit ran out? Suppose you have say 24 cpus, and you had a short
> burst where all 24 cpus had some runtime, so you distribute 240ms. But
> 23 of those cpus only ran for 0.5ms, leaving 23.5ms of unused time on 23
> cpus while your one active cpu will then throttle.
>

In practice this only affects the first period since that slightly
stale bandwidth is then available on those other 23 cpus the next time
a micro-burst occurs.  In testing this has resulted in very stable
performance and "smooth" perturbations that resemble hardcapping by
affinity (for integer points).

The notion of stealing could certainly be introduced, the juncture of
reaching the zero point here would be a possible place to consider
that (although we would need to do a steal that avoids the asymptotic
convergence problem of RT).

I think returning (most) of the bandwidth to the global pool on
(voluntary) dequeue is a more scalable solution

> I would much rather see all the accounting tight first and optimize
> later than start with leaky stuff and try and plug holes later.
>

The complexity this introduces is non-trivial since the idea of
returning quota to the pool means you need to introduce the notion of
when that quota came to life (otherwise you get leaks in the reverse
direction!) -- as well as reversing some of the lock ordering.

While generations do this they don't greatly increase the efficacy and
I think there is value in performing the detailed review we are doing
now in isolation of that.

It's also still consistent regarding leakage since in that in any N
consecutive periods the maximum additional quota (by a user abusing
this) that can be received is N+1.  Does the complexity trade-off
merit improving this bound at this point?

>> +
>> +static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
>> +             unsigned long delta_exec)
>> +{
>> +     if (cfs_rq->quota_assigned == RUNTIME_INF)
>> +             return;
>> +
>> +     cfs_rq->quota_used += delta_exec;
>> +
>> +     if (cfs_rq->quota_used < cfs_rq->quota_assigned)
>> +             return;
>> +
>> +     cfs_rq->quota_assigned += tg_request_cfs_quota(cfs_rq->tg);
>> +}
>
> So why isn't this hierarchical?,

It is naturally (since charging occurs within the existing hierarchal
accounting)

> also all this positive quota stuff
> looks weird, why not decrement and try to supplement when negative?
>

I thought I had a good reason for this.. at least I remember at one
point I think I did.. but I cannot see any need for it in the current
form.  I will revise it to a single decremented quota_remaining.
