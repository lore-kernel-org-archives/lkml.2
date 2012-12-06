Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab2LFPK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:10:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:54903 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489Ab2LFPKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:10:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,230,1355126400"; 
   d="scan'208";a="253015767"
Message-ID: <50C0B579.3040602@intel.com>
Date: Thu, 06 Dec 2012 23:10:49 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Alex Shi <lkml.alex@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>, Tejun Heo <tj@kernel.org>
Subject: Re: weakness of runnable load tracking?
References: <CAGjg+kFZ2+tzxOS4SVo3PTzEDJJ=B0gZJ0aEOhNHvTycFuVT6Q@mail.gmail.com> <50C00D41.1010800@intel.com> <CAPM31RKV-2arH6Jd+6XE0PyeicPJzWkuJ__A9XBj0VHaYCesDQ@mail.gmail.com>
In-Reply-To: <CAPM31RKV-2arH6Jd+6XE0PyeicPJzWkuJ__A9XBj0VHaYCesDQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Hi Paul & Ingo:
>>
>> In a short word of this issue: burst forking/waking tasks have no time
>> accumulate the load contribute, their runnable load are taken as zero.
>> that make select_task_rq do a wrong decision on which group is idlest.
> 
> So these aren't strictly comparable; bursting and forking tasks have
> fairly different characteristics here.

Many thanks for looking into this. :)
> 
> When we fork a task we intentionally reset the previous history.  This
> means that a forked task that immediately runs is going to show up as
> 100% runnable and then converge to it's true value.  This was fairly
> intentionally chosen so that tasks would "start" fast rather than
> having to worry about ramp up.

I am sorry for didn't see the 100% runnable for a new forked task. 
I believe the code need the following patch to initialize decay_count, 
and load_avg_contrib. otherwise they are random value. 
In enqueue_entity_load_avg() p->se.avg.runnable_avg_sum for new forked 
task is always zero, either because se.avg.last_runnable_update is set
 as clock_task due to decay_count <=0, or just do 
__synchronize_entity_decay not update_entity_load_avg.

===========
>From a161000dbece6e95bf3b81e9246d51784589d393 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Mon, 3 Dec 2012 17:30:39 +0800
Subject: [PATCH 05/12] sched: load tracking bug fix

We need initialize the se.avg.{decay_count, load_avg_contrib} to zero
after a new task forked.
Otherwise random values of above variable give a incorrect statistic
data when do new task enqueue:
    enqueue_task_fair
        enqueue_entity
            enqueue_entity_load_avg

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5dae0d2..e6533e1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1534,6 +1534,8 @@ static void __sched_fork(struct task_struct *p)
 #if defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)
 	p->se.avg.runnable_avg_period = 0;
 	p->se.avg.runnable_avg_sum = 0;
+	p->se.avg.decay_count = 0;
+	p->se.avg.load_avg_contrib = 0;
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
-- 
1.7.5.4


Yes, the runnable load will quick become 100%, after se->on_rq set, and passed 
one tick. 
If we are forking many tasks in one tick. I didn't find a useful chance to update 
load avg for new tasks.
So, guess we need the following patch:

==========
>From 6de8083606b6e0b55e201eadbb945c60fe7631b6 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Thu, 6 Dec 2012 22:48:24 +0800
Subject: [PATCH 12/12] sched: set initial load avg of new forked task as its
 load weight

New task has no runnable sum at its first runnable time, that make
burst forking just select few idle cpus to put tasks.
Set initial load avg of new forked task as its load weight to resolve
this issue.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |    2 +-
 kernel/sched/fair.c   |   18 ++++++++++++++++--
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e483ccb..12063fa 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1043,6 +1043,7 @@ struct sched_domain;
 #else
 #define ENQUEUE_WAKING		0
 #endif
+#define ENQUEUE_NEWTASK		8
 
 #define DEQUEUE_SLEEP		1
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 980904d..6a4d225 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1643,7 +1643,7 @@ void wake_up_new_task(struct task_struct *p)
 #endif
 
 	rq = __task_rq_lock(p);
-	activate_task(rq, p, 0);
+	activate_task(rq, p, ENQUEUE_NEWTASK);
 	p->on_rq = 1;
 	trace_sched_wakeup_new(p, true);
 	check_preempt_curr(rq, p, WF_FORK);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5d6eb91..f15b0ac 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1289,8 +1289,9 @@ static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
 /* Add the load generated by se into cfs_rq's child load-average */
 static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 						  struct sched_entity *se,
-						  int wakeup)
+						  int flags)
 {
+	int wakeup = flags & ENQUEUE_WAKEUP;
 	/*
 	 * We track migrations using entity decay_count <= 0, on a wake-up
 	 * migration we use a negative decay count to track the remote decays
@@ -1324,6 +1325,13 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 		update_entity_load_avg(se, 0);
 	}
 
+	/*
+	 * set the initial load avg of new task same as its load
+	 * in order to avoid brust fork make few cpu too heavier
+	 */
+	if (flags & ENQUEUE_NEWTASK)
+		se->avg.load_avg_contrib = se->load.weight;
+
 	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
 	/* we force update consideration on load-balancer moves */
 	update_cfs_rq_blocked_load(cfs_rq, !wakeup);
@@ -1488,7 +1496,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	 */
 	update_curr(cfs_rq);
 	account_entity_enqueue(cfs_rq, se);
-	enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
+	enqueue_entity_load_avg(cfs_rq, se, flags &
+				(ENQUEUE_WAKEUP | ENQUEUE_NEWTASK));
 
 	if (flags & ENQUEUE_WAKEUP) {
 		place_entity(cfs_rq, se, 0);
@@ -2580,6 +2589,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	int newtask = flags & ENQUEUE_NEWTASK;
 
 	for_each_sched_entity(se) {
 		if (se->on_rq)
@@ -2598,6 +2608,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		cfs_rq->h_nr_running++;
 
 		flags = ENQUEUE_WAKEUP;
+		flags &= ~ENQUEUE_NEWTASK;
 	}
 
 	for_each_sched_entity(se) {
@@ -2616,6 +2627,9 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		inc_nr_running(rq);
 	}
 	hrtick_update(rq);
+	if (newtask)
+		printk(KERN_ERR "rq avg data on a new task avg rum %ld avg contrib %ld\n", 
+			rq->avg.runnable_avg_sum, rq->avg.load_avg_contrib);
 }
 
 static void set_next_buddy(struct sched_entity *se);
-- 
1.7.5.4


My sleepy brain nearly stall. Will think over your other suggestion in weekend. :)

> 
> The treatment of a burst wake-up however is a little more interesting.
>  There are two reasonable trains of thought one can follow, the first
> is that:
> - If it IS truly bursty you don't really want it factoring into long
> term averages since steady state is not going to include that task;
> hence a low average is ok.  Anything that's more frequent then this is
> going to show up by definition of being within the periods.
> - The other is that if it truly is idle for _enormous_ amounts of time
> we want to give some cognizance to the fact that it might be more
> bursty when it wakes up.
> 
> It is my intuition that the greatest carnage here is actually caused
> by wake-up load-balancing getting in the way of periodic in
> establishing a steady state.  That these entities happen to not be
> runnable very often is just a red herring; they don't contribute
> enough load average to matter in the periodic case.  Increasing their
> load isn't going to really help this -- stronger, you don't want them
> affecting the steady state.  I suspect more mileage would result from
> reducing the interference wake-up load-balancing has with steady
> state.
> 
> e.g. One thing you can think about is considering tasks moved by
> wake-up load balance as "stolen", and allow periodic load-balance to
> re-settle things as if select_idle_sibling had not ignored it :-)
> 
>>
>> There is still 3 kinds of solution is helpful for this issue.
>>
>> a, set a unzero minimum value for the long time sleeping task. but it
>> seems unfair for other tasks these just sleep a short while.
>>
> 
> I think this is  reasonable to do regardless, we set such a cap in the
> cgroup case already.  Although you still obviously want this
> threshhold to be fairly low.  I suspect this is a weak improvement.
> 
>> b, just use runnable load contrib in load balance. Still using
>> nr_running to judge idlest group in select_task_rq_fair. but that may
>> cause a bit more migrations in future load balance.
> 
> I don't think this is a good approach.  The whole point of using
> blocked load is so that you can converge on a steady state where you
> don't NEED to move tasks.  What disrupts this is we naturally prefer
> idle cpus on wake-up balance to reduce wake-up latency.  As above, I
> think the better answer is making these two processes more
> co-operative.
> 
>>
>> c, consider both runnable load and nr_running in the group: like in the
>> searching domain, the nr_running number increased a certain number, like
>> double of the domain span, in a certain time. we will think it's a burst
>> forking/waking happened, then just count the nr_running as the idlest
>> group criteria.
> 
> This feels like a bit of a hack.  I suspect this is more binary:
> 
> If there's already something running on all the cpus then we should
> let the periodic load balancer do placement taking averages into
> account.
> 
> Otherwise, we're in wake-idle and we throw the cat in the bathwater.
> 
>>
>> IMHO, I like the 3rd one a bit more. as to the certain time to judge if
>> a burst happened, since we will calculate the runnable avg at very tick,
>> so if increased nr_running is beyond sd->span_weight in 2 ticks, means
>> burst happening. What's your opinion of this?
>>
> 
> What are you defining as the "right" behavior for a group of tasks
> waking up that want to use only a short burst?
> 
> This seems to suggest you think spreading them is the best answer?
> What's the motivation for that?  Also: What does your topology look
> like that's preventing select_idle_sibling from pushing tasks (and
> then new-idle subsequently continuing to pull)?
> 
> Certainly putting a lower bound on a tasks weight would help new-idle
> find the right cpu to pull these from.
> 
>> Any comments are appreciated!
>>
>> 
