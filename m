Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab1CAIbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:31:43 -0500
Received: from smtp-out.google.com ([74.125.121.67]:23517 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab1CAIbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:31:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rzq3FINdVkHFgB1nH5Gi6IiFFIKtENPfESxNl8+bBAnS88r0+MpHt+3htOV3CV2T6R
         ZP8GxBEKLe2vXj0g0icA==
MIME-Version: 1.0
In-Reply-To: <1298900895.2428.10831.camel@twins>
References: <20110216031831.571628191@google.com> <20110216031841.068673650@google.com>
 <1298467933.2217.765.camel@twins> <AANLkTimydWA5xyROhdXeW5as3t8aqfR1H2dqc-42C+6=@mail.gmail.com>
 <1298900895.2428.10831.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Tue, 1 Mar 2011 00:31:05 -0800
Message-ID: <AANLkTimiscCKoDb3V3AF8Aj8mHetCL_Vuaq=gc3eL7cq@mail.gmail.com>
Subject: Re: [CFS Bandwidth Control v4 3/7] sched: throttle cfs_rq entities
 which exceed their local quota
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

On Mon, Feb 28, 2011 at 5:48 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2011-02-24 at 19:10 -0800, Paul Turner wrote:
>
>> >> @@ -761,7 +788,11 @@ static void update_cfs_load(struct cfs_r
>> >>       u64 now, delta;
>> >>       unsigned long load = cfs_rq->load.weight;
>> >>
>> >> -     if (cfs_rq->tg == &root_task_group)
>> >> +     /*
>> >> +      * Don't maintain averages for the root task group, or while we are
>> >> +      * throttled.
>> >> +      */
>> >> +     if (cfs_rq->tg == &root_task_group || cfs_rq_throttled(cfs_rq))
>> >>               return;
>> >>
>> >>       now = rq_of(cfs_rq)->clock_task;
>> >
>> > Placing the return there avoids updating the timestamps, so once we get
>> > unthrottled we'll observe a very long period and skew the load avg?
>> >
>>
>> It's easier to avoid this by fixing up the load average on unthrottle,
>> since there's no point in moving up the intermediate timestamps on
>> each throttled update.
>>
>> The one "gotcha" in either case is that it's possible for time to
>> drift on the child of a throttled group and I don't see an easy way
>> around this.
>
> drift how? running while being throttled due to non-preempt and other
> things?
>

Not quite -- that time will actually be omitted since we nuke the
last_update on unthrottle.

What I was referring to here is that it's not easy (and not currently
done) to freeze the load average clock for descendants of a throttled
entity.

Plugging this properly is actually rather annoying since we'd have to
do a tree walk at both throttle and unthrottle (it's not sufficient to
just fix things up at unthrottle because wakeups can lead to updates
in the interim, meaning we'd need to mark some state).

Whether this drift is worth all that hassle is questionable at this point.

>> > Ideally we'd never call this on throttled groups to begin with and
>> > handle them like full dequeue/enqueue like things.
>> >
>>
>> This is what is attempted -- however it's still possible actions such
>> as wakeup which may still occur against throttled groups regardless of
>> their queue state.
>>
>> In this case we still need to preserve the correct child hierarchy
>> state so that it can be re-enqueued when there is again bandwidth.
>
> If wakeup is the one sore spot, why not terminate the hierarchy
> iteration in enqueue_task_fair that does all the load bits?
>

It does actually terminate early already, the problem here is the
processing for children has already occurred since it's a bottom up
enqueue.

Perhaps this can be simplified:

If we do a single walk at the start to validate whether the entity is
throttled (we can use entity_on_rq to keep things clean) then we can
pass a flag into enqueue_entity indicating whether it is part of a
throttled hierarchy.

This would allow us to skip the accounting and keep things accurate
above without having to do all the tree walks at throttle/unthrottle.

Let me see what this looks like for the next posting.

>> >> @@ -1015,6 +1046,14 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
>> >>        * Update run-time statistics of the 'current'.
>> >>        */
>> >>       update_curr(cfs_rq);
>> >> +
>> >> +
>> >> +#ifdef CONFIG_CFS_BANDWIDTH
>> >> +     if (!entity_is_task(se) && (cfs_rq_throttled(group_cfs_rq(se)) ||
>> >> +          !group_cfs_rq(se)->nr_running))
>> >> +             return;
>> >> +#endif
>> >> +
>> >>       update_cfs_load(cfs_rq, 0);
>> >>       account_entity_enqueue(cfs_rq, se);
>> >>       update_cfs_shares(cfs_rq);
>> >> @@ -1087,6 +1126,11 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
>> >>        */
>> >>       update_curr(cfs_rq);
>> >>
>> >> +#ifdef CONFIG_CFS_BANDWIDTH
>> >> +     if (!entity_is_task(se) && cfs_rq_throttled(group_cfs_rq(se)))
>> >> +             return;
>> >> +#endif
>> >> +
>> >>       update_stats_dequeue(cfs_rq, se);
>> >>       if (flags & DEQUEUE_SLEEP) {
>> >>  #ifdef CONFIG_SCHEDSTATS
>> >
>> > These make me very nervous, on enqueue you bail after adding
>> > min_vruntime to ->vruntime and calling update_curr(), but on dequeue you
>> > bail before subtracting min_vruntime from ->vruntime.
>> >
>>
>> min_vruntime shouldn't be added in enqueue since unthrottling is
>> treated as a wakeup (which results in placement versus min as opposed
>> to normalization).
>
> Sure, but at least put a comment there, I mean that's a glaring
> asymmetry.
>
>> >> @@ -1363,6 +1407,9 @@ enqueue_task_fair(struct rq *rq, struct
>> >>                       break;
>> >>               cfs_rq = cfs_rq_of(se);
>> >>               enqueue_entity(cfs_rq, se, flags);
>> >> +             /* don't continue to enqueue if our parent is throttled */
>> >> +             if (cfs_rq_throttled(cfs_rq))
>> >> +                     break;
>> >>               flags = ENQUEUE_WAKEUP;
>> >>       }
>> >>
>> >> @@ -1390,8 +1437,11 @@ static void dequeue_task_fair(struct rq
>> >>               cfs_rq = cfs_rq_of(se);
>> >>               dequeue_entity(cfs_rq, se, flags);
>> >>
>> >> -             /* Don't dequeue parent if it has other entities besides us */
>> >> -             if (cfs_rq->load.weight)
>> >> +             /*
>> >> +              * Don't dequeue parent if it has other entities besides us,
>> >> +              * or if it is throttled
>> >> +              */
>> >> +             if (cfs_rq->load.weight || cfs_rq_throttled(cfs_rq))
>> >>                       break;
>> >>               flags |= DEQUEUE_SLEEP;
>> >>       }
>> >
>> > How could we even be running if our parent was throttled?
>> >
>>
>> It's possible we throttled within the preceding dequeue_entity -- the
>> partial update_curr against cfs_rq might be just enough to push it
>> over the edge.  In which case that entity has already been dequeued
>> and we want to bail out.
>
> right.
>
>>
>> >> @@ -1430,6 +1480,42 @@ static u64 tg_request_cfs_quota(struct t
>> >>       return delta;
>> >>  }
>> >>
>> >> +static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
>> >> +{
>> >> +     struct sched_entity *se;
>> >> +
>> >> +     se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
>> >> +
>> >> +     /* account load preceeding throttle */
>> >> +     update_cfs_load(cfs_rq, 0);
>> >> +
>> >> +     /* prevent previous buddy nominations from re-picking this se */
>> >> +     clear_buddies(cfs_rq_of(se), se);
>> >> +
>> >> +     /*
>> >> +      * It's possible for the current task to block and re-wake before task
>> >> +      * switch, leading to a throttle within enqueue_task->update_curr()
>> >> +      * versus an an entity that has not technically been enqueued yet.
>> >
>> > I'm not quite seeing how this would happen.. care to expand on this?
>> >
>>
>> I'm not sure the example Bharata gave is correct -- I'm going to treat
>> that discussion separately as it's not the intent here.
>>
>> Here the task _is_ running.
>>
>> Specifically:
>>
>> - Suppose the current task on a cfs_rq blocks
>> - Accordingly we issue dequeue against that task (however it remains
>> as curr until the put)
>> - Before we get to the put some other activity (e.g. network bottom
>> half) gets to run and re-wake the task
>> - The time elapsed for this is charged to the task, which might push
>> it over its reservation, it then gets throttled while we're trying to
>> queue it
>>
>> BUT
>>
>> We haven't actually done any of the enqueue work yet so there's
>> nothing to do to take it off rq.  So what we just mark it throttled
>> and make sure that the rest of the enqueue work gets short circuited.
>>
>> The clock_task helps reduce the occurrence of this since the task will
>> be spared the majority of the SI time but it's still possible to push
>> it over.
>
> Ah, uhm, so this is all due to us dropping rq->lock after dequeue,
> right? Would
>
>  https://lkml.org/lkml/2011/1/4/228
>
> help here?
>

omm at a glance, it'll still be cfs_rq->curr until we actually issue the put.

I don't think we can skip update_curr in the !p->on_rq case since for
the non-preempt kernel case we should be counting that time; so I
think this case would unfortunately still exist.

>> >> +      * In this case, since we haven't actually done the enqueue yet, cut
>> >> +      * out and allow enqueue_entity() to short-circuit
>> >> +      */
>> >> +     if (!se->on_rq)
>> >> +             goto out_throttled;
>> >> +
>> >> +     for_each_sched_entity(se) {
>> >> +             struct cfs_rq *cfs_rq = cfs_rq_of(se);
>> >> +
>> >> +             dequeue_entity(cfs_rq, se, 1);
>> >> +             if (cfs_rq->load.weight || cfs_rq_throttled(cfs_rq))
>> >> +                     break;
>> >> +     }
>> >> +
>> >> +out_throttled:
>> >> +     cfs_rq->throttled = 1;
>> >> +     update_cfs_rq_load_contribution(cfs_rq, 1);
>> >> +}
>> >> +
>> >>  static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
>> >>               unsigned long delta_exec)
>> >>  {
>> >> @@ -1438,10 +1524,16 @@ static void account_cfs_rq_quota(struct
>> >>
>> >>       cfs_rq->quota_used += delta_exec;
>> >>
>> >> -     if (cfs_rq->quota_used < cfs_rq->quota_assigned)
>> >> +     if (cfs_rq_throttled(cfs_rq) ||
>> >> +             cfs_rq->quota_used < cfs_rq->quota_assigned)
>> >>               return;
>> >
>> > So we are throttled but running anyway, I suppose this comes from the PI
>> > ceiling muck?
>> >
>>
>> No -- this is just the fact that there are cases where reschedule
>> can't evict the task immediately.
>>
>> e.g. softirq or any kernel time without config_preempt
>>
>> Once we're throttled we know there's no time left or point in trying
>> to acquire it so just short circuit these until we get to a point
>> where this task can be removed from rq.
>
> Right, but like I argued in another email, it could be refreshed on
> another cpu and you now miss it.. :-)
>

Yes, that would be non-desirable.. hum, synchronizing the check under
rq->lock in do_sched_cfs_period_timer() should cover this.

>> >> +     if (!entity_on_rq(pse))
>> >> +             return;
>> >> +#endif
>> >
>> > Ideally that #ifdef'ery would go away too.
>>
>> This can 100% go away (and is already in the #ifdefs), but it will
>> always be true in the !BANDWIDTH case, so it's a micro-overhead.
>> Accompanying micro-optimization isn't really needed :)
>
> Wouldn't gcc be able to optimize if (!true) stmt; with DCE ?
>

it's p->on_rq so it's a memory ref, I don't think the gcc can reduce
it since the path from ttwu -> check_preempt goes through a function
pointer.

although if it can handle that bifurcation then I'm super impressed :)
-- ill check against the disassembly.
