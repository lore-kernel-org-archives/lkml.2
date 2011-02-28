Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab1B1NtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 08:49:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:42897 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab1B1NtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 08:49:10 -0500
Subject: Re: [CFS Bandwidth Control v4 3/7] sched: throttle cfs_rq entities
 which exceed their local quota
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
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
In-Reply-To: <AANLkTimydWA5xyROhdXeW5as3t8aqfR1H2dqc-42C+6=@mail.gmail.com>
References: <20110216031831.571628191@google.com>
	 <20110216031841.068673650@google.com> <1298467933.2217.765.camel@twins>
	 <AANLkTimydWA5xyROhdXeW5as3t8aqfR1H2dqc-42C+6=@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Feb 2011 14:48:15 +0100
Message-ID: <1298900895.2428.10831.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 19:10 -0800, Paul Turner wrote:

> >> @@ -761,7 +788,11 @@ static void update_cfs_load(struct cfs_r
> >>       u64 now, delta;
> >>       unsigned long load = cfs_rq->load.weight;
> >>
> >> -     if (cfs_rq->tg == &root_task_group)
> >> +     /*
> >> +      * Don't maintain averages for the root task group, or while we are
> >> +      * throttled.
> >> +      */
> >> +     if (cfs_rq->tg == &root_task_group || cfs_rq_throttled(cfs_rq))
> >>               return;
> >>
> >>       now = rq_of(cfs_rq)->clock_task;
> >
> > Placing the return there avoids updating the timestamps, so once we get
> > unthrottled we'll observe a very long period and skew the load avg?
> >
> 
> It's easier to avoid this by fixing up the load average on unthrottle,
> since there's no point in moving up the intermediate timestamps on
> each throttled update.
> 
> The one "gotcha" in either case is that it's possible for time to
> drift on the child of a throttled group and I don't see an easy way
> around this.

drift how? running while being throttled due to non-preempt and other
things?

> > Ideally we'd never call this on throttled groups to begin with and
> > handle them like full dequeue/enqueue like things.
> >
> 
> This is what is attempted -- however it's still possible actions such
> as wakeup which may still occur against throttled groups regardless of
> their queue state.
> 
> In this case we still need to preserve the correct child hierarchy
> state so that it can be re-enqueued when there is again bandwidth.

If wakeup is the one sore spot, why not terminate the hierarchy
iteration in enqueue_task_fair that does all the load bits?

> >> @@ -1015,6 +1046,14 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
> >>        * Update run-time statistics of the 'current'.
> >>        */
> >>       update_curr(cfs_rq);
> >> +
> >> +
> >> +#ifdef CONFIG_CFS_BANDWIDTH
> >> +     if (!entity_is_task(se) && (cfs_rq_throttled(group_cfs_rq(se)) ||
> >> +          !group_cfs_rq(se)->nr_running))
> >> +             return;
> >> +#endif
> >> +
> >>       update_cfs_load(cfs_rq, 0);
> >>       account_entity_enqueue(cfs_rq, se);
> >>       update_cfs_shares(cfs_rq);
> >> @@ -1087,6 +1126,11 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
> >>        */
> >>       update_curr(cfs_rq);
> >>
> >> +#ifdef CONFIG_CFS_BANDWIDTH
> >> +     if (!entity_is_task(se) && cfs_rq_throttled(group_cfs_rq(se)))
> >> +             return;
> >> +#endif
> >> +
> >>       update_stats_dequeue(cfs_rq, se);
> >>       if (flags & DEQUEUE_SLEEP) {
> >>  #ifdef CONFIG_SCHEDSTATS
> >
> > These make me very nervous, on enqueue you bail after adding
> > min_vruntime to ->vruntime and calling update_curr(), but on dequeue you
> > bail before subtracting min_vruntime from ->vruntime.
> >
> 
> min_vruntime shouldn't be added in enqueue since unthrottling is
> treated as a wakeup (which results in placement versus min as opposed
> to normalization).

Sure, but at least put a comment there, I mean that's a glaring
asymmetry.

> >> @@ -1363,6 +1407,9 @@ enqueue_task_fair(struct rq *rq, struct
> >>                       break;
> >>               cfs_rq = cfs_rq_of(se);
> >>               enqueue_entity(cfs_rq, se, flags);
> >> +             /* don't continue to enqueue if our parent is throttled */
> >> +             if (cfs_rq_throttled(cfs_rq))
> >> +                     break;
> >>               flags = ENQUEUE_WAKEUP;
> >>       }
> >>
> >> @@ -1390,8 +1437,11 @@ static void dequeue_task_fair(struct rq
> >>               cfs_rq = cfs_rq_of(se);
> >>               dequeue_entity(cfs_rq, se, flags);
> >>
> >> -             /* Don't dequeue parent if it has other entities besides us */
> >> -             if (cfs_rq->load.weight)
> >> +             /*
> >> +              * Don't dequeue parent if it has other entities besides us,
> >> +              * or if it is throttled
> >> +              */
> >> +             if (cfs_rq->load.weight || cfs_rq_throttled(cfs_rq))
> >>                       break;
> >>               flags |= DEQUEUE_SLEEP;
> >>       }
> >
> > How could we even be running if our parent was throttled?
> >
> 
> It's possible we throttled within the preceding dequeue_entity -- the
> partial update_curr against cfs_rq might be just enough to push it
> over the edge.  In which case that entity has already been dequeued
> and we want to bail out.

right.

> 
> >> @@ -1430,6 +1480,42 @@ static u64 tg_request_cfs_quota(struct t
> >>       return delta;
> >>  }
> >>
> >> +static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
> >> +{
> >> +     struct sched_entity *se;
> >> +
> >> +     se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
> >> +
> >> +     /* account load preceeding throttle */
> >> +     update_cfs_load(cfs_rq, 0);
> >> +
> >> +     /* prevent previous buddy nominations from re-picking this se */
> >> +     clear_buddies(cfs_rq_of(se), se);
> >> +
> >> +     /*
> >> +      * It's possible for the current task to block and re-wake before task
> >> +      * switch, leading to a throttle within enqueue_task->update_curr()
> >> +      * versus an an entity that has not technically been enqueued yet.
> >
> > I'm not quite seeing how this would happen.. care to expand on this?
> >
> 
> I'm not sure the example Bharata gave is correct -- I'm going to treat
> that discussion separately as it's not the intent here.
> 
> Here the task _is_ running.
> 
> Specifically:
> 
> - Suppose the current task on a cfs_rq blocks
> - Accordingly we issue dequeue against that task (however it remains
> as curr until the put)
> - Before we get to the put some other activity (e.g. network bottom
> half) gets to run and re-wake the task
> - The time elapsed for this is charged to the task, which might push
> it over its reservation, it then gets throttled while we're trying to
> queue it
> 
> BUT
> 
> We haven't actually done any of the enqueue work yet so there's
> nothing to do to take it off rq.  So what we just mark it throttled
> and make sure that the rest of the enqueue work gets short circuited.
> 
> The clock_task helps reduce the occurrence of this since the task will
> be spared the majority of the SI time but it's still possible to push
> it over.

Ah, uhm, so this is all due to us dropping rq->lock after dequeue,
right? Would 

  https://lkml.org/lkml/2011/1/4/228

help here?

> >> +      * In this case, since we haven't actually done the enqueue yet, cut
> >> +      * out and allow enqueue_entity() to short-circuit
> >> +      */
> >> +     if (!se->on_rq)
> >> +             goto out_throttled;
> >> +
> >> +     for_each_sched_entity(se) {
> >> +             struct cfs_rq *cfs_rq = cfs_rq_of(se);
> >> +
> >> +             dequeue_entity(cfs_rq, se, 1);
> >> +             if (cfs_rq->load.weight || cfs_rq_throttled(cfs_rq))
> >> +                     break;
> >> +     }
> >> +
> >> +out_throttled:
> >> +     cfs_rq->throttled = 1;
> >> +     update_cfs_rq_load_contribution(cfs_rq, 1);
> >> +}
> >> +
> >>  static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
> >>               unsigned long delta_exec)
> >>  {
> >> @@ -1438,10 +1524,16 @@ static void account_cfs_rq_quota(struct
> >>
> >>       cfs_rq->quota_used += delta_exec;
> >>
> >> -     if (cfs_rq->quota_used < cfs_rq->quota_assigned)
> >> +     if (cfs_rq_throttled(cfs_rq) ||
> >> +             cfs_rq->quota_used < cfs_rq->quota_assigned)
> >>               return;
> >
> > So we are throttled but running anyway, I suppose this comes from the PI
> > ceiling muck?
> >
> 
> No -- this is just the fact that there are cases where reschedule
> can't evict the task immediately.
> 
> e.g. softirq or any kernel time without config_preempt
> 
> Once we're throttled we know there's no time left or point in trying
> to acquire it so just short circuit these until we get to a point
> where this task can be removed from rq.

Right, but like I argued in another email, it could be refreshed on
another cpu and you now miss it.. :-)

> >> +     if (!entity_on_rq(pse))
> >> +             return;
> >> +#endif
> >
> > Ideally that #ifdef'ery would go away too.
> 
> This can 100% go away (and is already in the #ifdefs), but it will
> always be true in the !BANDWIDTH case, so it's a micro-overhead.
> Accompanying micro-optimization isn't really needed :)

Wouldn't gcc be able to optimize if (!true) stmt; with DCE ?
