Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab1DFHXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 03:23:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:9418 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab1DFHXD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 03:23:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=sJKeCx1cbvoW3vWeurCucLlFAqyILlQdyqy5yYXcBNChwTMxTsTglp4/Yc9JtcL8B4
         lX8acYYRWXyUJhS1ilIw==
MIME-Version: 1.0
In-Reply-To: <1302010089.2225.1313.camel@twins>
References: <20110323030326.789836913@google.com> <20110323030449.941304760@google.com>
 <1302010089.2225.1313.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Wed, 6 Apr 2011 00:22:29 -0700
Message-ID: <BANLkTimOP_EtyxEZ9pOEpgJPqEEic21eCA@mail.gmail.com>
Subject: Re: [patch 13/15] sched: expire slack quota using generation counters
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 6:28 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-03-22 at 20:03 -0700, Paul Turner wrote:
>
> Argh, this patch is terrible for the reason that it changes the whole
> accounting just introduced and me having to re-open all the previous
> patches to look up hth stuff worked before.

I didn't think it was too drastic -- the introduction of the
generation is more incremental.  However I agree it does cause
unnecessary churn within the accounting functions across the series.
Given that expiring quota is a requirement, this can be streamlined by
introducing some of these notions earlier in the series as opposed to
bootstrapping them at the end here -- will clean it up.

>
>> @@ -436,8 +438,10 @@ void init_cfs_bandwidth(struct cfs_bandw
>>       raw_spin_lock_init(&cfs_b->lock);
>>       cfs_b->quota = cfs_b->runtime = quota;
>>       cfs_b->period = ns_to_ktime(period);
>> +     cfs_b->quota_generation = 0;
>>       INIT_LIST_HEAD(&cfs_b->throttled_cfs_rq);
>>
>> +
>>       hrtimer_init(&cfs_b->period_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>>       cfs_b->period_timer.function = sched_cfs_period_timer;
>
> We're in desperate need of more whitespace there? :-)

8< 8<

>
>> @@ -9333,6 +9337,8 @@ static int tg_set_cfs_bandwidth(struct t
>>       raw_spin_lock_irq(&cfs_b->lock);
>>       cfs_b->period = ns_to_ktime(period);
>>       cfs_b->runtime = cfs_b->quota = quota;
>> +
>> +     cfs_bump_quota_generation(cfs_b);
>>       raw_spin_unlock_irq(&cfs_b->lock);
>>
>>       for_each_possible_cpu(i) {
>> Index: tip/kernel/sched_fair.c
>> ===================================================================
>> --- tip.orig/kernel/sched_fair.c
>> +++ tip/kernel/sched_fair.c
>> @@ -1331,11 +1331,25 @@ static void check_cfs_rq_quota(struct cf
>>       resched_task(rq_of(cfs_rq)->curr);
>>  }
>>
>> +static void cfs_bump_quota_generation(struct cfs_bandwidth *cfs_b)
>> +{
>> +     cfs_b->quota_generation++;
>> +     smp_mb();
>> +}
>
> Memory barriers come in pairs and with a comment, you fail on both
> counts.
>

scratches head... erm right, I meant to pair this with a read barrier
on querying the generation but balked when I realized that still
yields an lfence on x86 since I didn't want to introduce that to the
update_curr() path.

While we can probably do away with the barrier completely (it's not
critical that we line them up perfectly with the new generation), I've
been thinking about this one and I think I have something a little
nicer that also reduces the shared cache hits.

We can take advantage of the fact that sched_clocks are already
synchronized within 2 jiffies and store the quota's expiration,
instead of a generation, when we refresh.

This effectively yields a fairly simple control flow (we can use
rq->clock since we're always paired with update_rq_clock operations):
a) our rq->clock < expiration always implies quota is valid

Obviously if our cpu clock is ahead of the one that issued the quota,
our quota is still valid since the real deadline is even further
behind
Even if our cpu's clock is behind the max 1.99 jiffies the amount of
time that the stale quota can remain valid is basically already within
our potential margin of error since for a long running process we
check on each tick edge anyway.

 b) our rq->clock > expiration

Again there's two cases, if our cpu clock is behind (or equal) then
the deadline has indeed passed and the quota is expired.  This can be
confirmed by comparing the global deadline with our local one (the
global expiration will have advanced with quota refresh for this to be
true).

We can also catch that our cpu is potentially ahead -- by the fact
that our rq->clock > expiration but that the global expiration has not
yet advanced.  In this case we recognize that our quota is still valid
and extend our local expiration time by either the maximum margin of
error or some fraction there of (say 1 jiffy) which is guaranteed to
push us back in case a) above.  Again this is within our existing
margin of error due to entity_tick() alignment.

This ends up looking a lot simpler and avoids much of the pressure on
the global variable since we need to compare against it in the case
where our clock passes expiration, once a quota period (as the
extension will put us in case a where we know we don't need to
consider it).

This ends up simpler than the generation muck and can be introduced
cleanly earlier in the series, avoiding the churn mentioned above.

Make sense?

>> +
>> +static inline int cfs_rq_quota_current(struct cfs_rq *cfs_rq)
>> +{
>> +     struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
>> +
>> +     return cfs_rq->quota_generation == cfs_b->quota_generation;
>> +}
>> +
>>  static void request_cfs_rq_quota(struct cfs_rq *cfs_rq)
>>  {
>>       struct task_group *tg = cfs_rq->tg;
>>       struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
>>       u64 amount = 0, min_amount;
>> +     int generation;
>
> Not initialized,
>
>>       min_amount = sched_cfs_bandwidth_slice() + (-cfs_rq->quota_remaining);
>>
>> @@ -1347,10 +1361,18 @@ static void request_cfs_rq_quota(struct
>>               } else {
>>                       amount = min_amount;
>>               }
>> +             generation = cfs_b->quota_generation;
>>               raw_spin_unlock(&cfs_b->lock);
>>       }
>
> and since there's an if there, one can fail it, leaving generation
> uninitialized,
>
>>
>> +     /* a deficit should be carried forwards, surplus should be dropped */
>> +
>> +     if (generation != cfs_rq->quota_generation &&
>> +         cfs_rq->quota_remaining > 0)
>> +             cfs_rq->quota_remaining = 0;
>> +
>>       cfs_rq->quota_remaining += amount;
>> +     cfs_rq->quota_generation = generation;
>>  }
>
> Resulting in uninitialized usage right there.
>

Truth
