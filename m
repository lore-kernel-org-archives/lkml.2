Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab1BZACx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 19:02:53 -0500
Received: from smtp-out.google.com ([74.125.121.67]:61906 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab1BZACw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 19:02:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OPtWzmJSaHZVQ2pJw4bgDlz9BtHqg42mitfQN7fKbnBJaLaeuWrwWZyLTKY9ZH+LkL
         YaX4MlMHi10n0IXPJZ9g==
MIME-Version: 1.0
In-Reply-To: <1298467932.2217.764.camel@twins>
References: <20110216031831.571628191@google.com> <20110216031841.161743484@google.com>
 <1298467932.2217.764.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Fri, 25 Feb 2011 16:02:18 -0800
Message-ID: <AANLkTikROL_rE=5-P8POpT=VeHeNNeGmmaQ2b-8_CjFw@mail.gmail.com>
Subject: Re: [CFS Bandwidth Control v4 4/7] sched: unthrottle cfs_rq(s) who
 ran out of quota at period refresh
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

Oops missed this one before:

On Wed, Feb 23, 2011 at 5:32 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-02-15 at 19:18 -0800, Paul Turner wrote:
>
>> +static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
>> +{
>> +     struct rq *rq = rq_of(cfs_rq);
>> +     struct sched_entity *se;
>> +
>> +     se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
>> +
>> +     update_rq_clock(rq);
>> +     /* (Try to) avoid maintaining share statistics for idle time */
>> +     cfs_rq->load_stamp = cfs_rq->load_last = rq->clock_task;
>
> Ok, so here you try to compensate for some of the weirdness from the
> previous patch.. wouldn't it be much saner to fully consider the
> throttled things dequeued for the load calculation etc.?
>

That's attempted -- but there's no to control wakeups which will
trigger the usual updates so we do have to do something.

The alternative is more invasive re-ordering of the dequeue/enqueue
paths which I think actually ends up pretty ugly without improving
things.

>> +
>> +     cfs_rq->throttled = 0;
>> +     for_each_sched_entity(se) {
>> +             if (se->on_rq)
>> +                     break;
>> +
>> +             cfs_rq = cfs_rq_of(se);
>> +             enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
>> +             if (cfs_rq_throttled(cfs_rq))
>> +                     break;
>
> That's just weird, it was throttled, you enqueued it but find it
> throttled.
>

Two reasons:

a) We might be unthrottling a child in a throttled hierarchy.  This
can occur regardless of conformancy (e.g. different periods)
b) edge case: suppose there's no bandwidth already and the enqueue
pushes things back into a throttled state.

>> +     }
>> +
>> +     /* determine whether we need to wake up potentally idle cpu */
>
> SP: potentially, also isn't there a determiner missing?

Spelling fixed, I think the determiner is ok though:

- We know nr_running must have been zero before since rq->curr ==
rq->idle, (also if this *has* changed then there's already a resched
for that in flight and we don't need to.  This also implies that
rq->cfs.nr_running was == 0.

- Root cfs_rq.nr_running now being greater than zero tells us that our
unthrottle was root visible (specifically, it was not a throttled
child of another throttled hierachy) which tells us that there's a
task waiting.

Am I missing a case?

>
>> +     if (rq->curr == rq->idle && rq->cfs.nr_running)
>> +             resched_task(rq->curr);
>> +}
>> +
>>  static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
>>               unsigned long delta_exec)
>>  {
>> @@ -1535,8 +1569,46 @@ static void account_cfs_rq_quota(struct
>>
>>  static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
>>  {
>> -     return 1;
>> +     int i, idle = 1;
>> +     u64 delta;
>> +     const struct cpumask *span;
>> +
>> +     if (cfs_b->quota == RUNTIME_INF)
>> +             return 1;
>> +
>> +     /* reset group quota */
>> +     raw_spin_lock(&cfs_b->lock);
>> +     cfs_b->runtime = cfs_b->quota;
>
> Shouldn't that be something like:
>
> cfs_b->runtime =
>   min(cfs_b->runtime + overrun * cfs_b->quota, cfs_b->quota);
>
> afaict runtime can go negative in which case we need to compensate for
> that, but we cannot ever get more than quota because we allow for
> overcommit, so not limiting things would allow us to accrue an unlimited
> amount of runtime.
>
> Or can only the per-cpu quota muck go negative?

The over-run can only occur on a local cpu (e.g. due to us being
unable to immediately evict a throttled entity).  By injecting a
constant amount of bandwidth into the global pool we are able to
correct that over-run in the subsequent period.

> In that case it should
> probably be propagated back into the global bw on throttle, otherwise
> you can get deficits on CPUs that remain unused for a while.
>

I think you mean surplus :).  Yes there is potentially a small amount
of surplus quota in the system, the "hard" bound is that across N
periods you can receive [N periods + (slice size * NR_CPUs)] quota,
since this is what may be outstanding as above surpluses.  Since the
slice size is fairly small this over-run is also fairly tight to the
stated bounds (as well as being manageable through the slice size
sysctl when required).


>> +     raw_spin_unlock(&cfs_b->lock);
>> +
>> +     span = sched_bw_period_mask();
>> +     for_each_cpu(i, span) {
>> +             struct rq *rq = cpu_rq(i);
>> +             struct cfs_rq *cfs_rq = cfs_bandwidth_cfs_rq(cfs_b, i);
>> +
>> +             if (cfs_rq->nr_running)
>> +                     idle = 0;
>> +
>> +             if (!cfs_rq_throttled(cfs_rq))
>> +                     continue;
>> +
>> +             delta = tg_request_cfs_quota(cfs_rq->tg);
>> +
>> +             if (delta) {
>> +                     raw_spin_lock(&rq->lock);
>> +                     cfs_rq->quota_assigned += delta;
>> +
>> +                     /* avoid race with tg_set_cfs_bandwidth */
>
> *what* race, and *how*
>

When a user sets a new bandwidth limit for the cgroup (e.g. removes
it, sets unlimited bandwidth).  That process may in itself unthrottle
the group.  Since we synchronize on rq->lock, rechecking this
condition is sufficient to avoid a double unthrottle here.

>> +                     if (cfs_rq_throttled(cfs_rq) &&
>> +                          cfs_rq->quota_used < cfs_rq->quota_assigned)
>> +                             unthrottle_cfs_rq(cfs_rq);
>> +                     raw_spin_unlock(&rq->lock);
>> +             }
>> +     }
>> +
>> +     return idle;
>>  }
>
> This whole positive quota muck makes my head hurt, whatever did you do
> that for? Also it doesn't deal with wrapping, which admittedly won't
> really happen but still.
>

Ah-ha! In going through and swapping things to a single counter I
remember the reason now:

It's that since we can overflow usage on the per-cpu tracking, in
using a single counter care must be taken to avoid collision with
RUNTIME_INF since it's (-1).

Now I'm debating whether the ugliness of these checks is worth it.
Perhaps moving RUNTIME_INF out of quota_remaining and having a
separate per-cpu quota enabled indicator would be the cleanest of all
three.

>
>
>
