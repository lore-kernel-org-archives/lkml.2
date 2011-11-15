Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab1KOVOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:14:05 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52927 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab1KOVOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:14:03 -0500
From: Benjamin Segall <bsegall@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 3/3] From: Ben Segall <bsegall@google.com>
References: <20111108042632.977080206@google.com>
	<20111108042736.683407863@google.com> <4EBB3742.7060404@google.com>
	<1321272116.1421.11.camel@twins>
Date: Tue, 15 Nov 2011 13:14:00 -0800
In-Reply-To: <1321272116.1421.11.camel@twins> (Peter Zijlstra's message of
	"Mon, 14 Nov 2011 13:01:56 +0100")
Message-ID: <xm26d3ctytpj.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> On Wed, 2011-11-09 at 18:30 -0800, Paul Turner wrote:
>> 
>> sched: update task accounting on throttle so that idle_balance() will trigger
>> From: Ben Segall <bsegall@google.com>
>> 
>> Since throttling occurs in the put_prev_task() path we do not get to observe
>> this delta against nr_running when making the decision to idle_balance().
>> 
>> Fix this by first enumerating cfs_rq throttle states so that we can distinguish
>> throttling cfs_rqs.  Then remove tasks that will be throttled in put_prev_task
>> from rq->nr_running/cfs_rq->h_nr_running when in account_cfs_rq_runtime,
>> rather than delaying until put_prev_task.
>> 
>> This allows schedule() to call idle_balance when we go idle due to throttling.
>> 
>> Using Kamalesh's nested-cgroup test case[1] we see the following improvement on
>> a 16 core system:
>> baseline: Average CPU Idle percentage 13.9667%
>>    +patch: Average CPU Idle percentage 3.53333%
>> [1]: https://lkml.org/lkml/2011/9/15/261
>> 
>> Signed-off-by: Ben Segall <bsegall@google.com>
>> Signed-off-by: Paul Turner <pjt@google.com>
>
> I really don't like this patch... There's something wrong about
> decoupling the dequeue from nr_running accounting.
>
> That said, I haven't got a bright idea either.. anyway, I think the
> patch is somewhat too big for 3.2 at this point.

Since we can't really throttle until schedule or so, the simplest
solution would be to move it from put_prev_task to a prev_schedule hook
so that it could be before idle_balance, but that seems a bit heavy just
for cfs bandwidth.

>
>> ---
>>   kernel/sched.c      |   24 ++++++++----
>>   kernel/sched_fair.c |  101 ++++++++++++++++++++++++++++++++++++----------------
>>   2 files changed, 87 insertions(+), 38 deletions(-)
>> 
>> Index: tip/kernel/sched.c
>> ===================================================================
>> --- tip.orig/kernel/sched.c
>> +++ tip/kernel/sched.c
>> @@ -269,6 +269,13 @@ struct cfs_bandwidth {
>>   #endif
>>   };
>> 
>> +enum runtime_state {
>> +       RUNTIME_UNLIMITED,
>> +       RUNTIME_AVAILABLE,
>> +       RUNTIME_THROTTLING,
>> +       RUNTIME_THROTTLED
>> +};
>
> What's the difference between throttling and throttled? Throttling is
> between actually getting throttled and put_prev_task() getting called?
> This all wants a comment.

Yes, although THROTTLING->AVAILABLE (or even ->UNLIMITED) is also possible.

>> @@ -1401,14 +1422,33 @@ static void __account_cfs_rq_runtime(str
>>          * if we're unable to extend our runtime we resched so that the active
>>          * hierarchy can be throttled
>>          */
>> -       if (!assign_cfs_rq_runtime(cfs_rq) && likely(cfs_rq->curr))
>> -               resched_task(rq_of(cfs_rq)->curr);
>> +       if (assign_cfs_rq_runtime(cfs_rq))
>> +               return;
>> +
>> +       if (unlikely(!cfs_rq->curr) || throttled_hierarchy(cfs_rq) ||
>> +          cfs_rq->runtime_state == RUNTIME_THROTTLING)
>> +               return;
>
> How exactly can we get here if we're throttling already?

A wakeup in the same to-be-throttled cfs_rq before need_resched is
handled. The simplest trigger would be three tasks on the same cfs_rq,
only one of which is running. If it tries to wake both of the other
tasks just as it runs out of runtime, we would hit this.

And the patch updated for these and your other comments:

-- 8< --
From: Benjamin Segall <bsegall@google.com>
Subject: sched: update task accounting on throttle so that idle_balance() will trigger

Since throttling occurs in the put_prev_task() path we do not get to observe
this delta against nr_running when making the decision to idle_balance().

Fix this by first enumerating cfs_rq throttle states so that we can distinguish
throttling cfs_rqs.  Then remove tasks that will be throttled in put_prev_task
from rq->nr_running/cfs_rq->h_nr_running when in account_cfs_rq_runtime,
rather than delaying until put_prev_task.

This allows schedule() to call idle_balance when we go idle due to throttling.

Using Kamalesh's nested-cgroup test case[1] we see the following improvement on
a 16 core system:
baseline: Average CPU Idle percentage 13.9667%
  +patch: Average CPU Idle percentage 3.53333%
[1]: https://lkml.org/lkml/2011/9/15/261

Signed-off-by: Ben Segall <bsegall@google.com>
Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched.c      |   28 +++++++++++---
 kernel/sched_fair.c |  100 +++++++++++++++++++++++++++++++++++----------------
 2 files changed, 90 insertions(+), 38 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 7c1b2f5..0af1680 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -269,6 +269,17 @@ struct cfs_bandwidth {
 #endif
 };
 
+/*
+ * THROTTLING tasks have been removed from nr_running, but have not
+ * yet been dequeued. THROTTLED tasks have been entirely dequeued.
+ */
+enum runtime_state {
+	RUNTIME_UNLIMITED,
+	RUNTIME_AVAILABLE,
+	RUNTIME_THROTTLING,
+	RUNTIME_THROTTLED
+};
+
 /* task group related information */
 struct task_group {
 	struct cgroup_subsys_state css;
@@ -402,12 +413,12 @@ struct cfs_rq {
 	unsigned long load_contribution;
 #endif
 #ifdef CONFIG_CFS_BANDWIDTH
-	int runtime_enabled;
+	enum runtime_state runtime_state;
 	u64 runtime_expires;
 	s64 runtime_remaining;
 
 	u64 throttled_timestamp;
-	int throttled, throttle_count;
+	int throttle_count;
 	struct list_head throttled_list;
 #endif
 #endif
@@ -470,7 +481,7 @@ static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 
 static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
-	cfs_rq->runtime_enabled = 0;
+	cfs_rq->runtime_state = RUNTIME_UNLIMITED;
 	INIT_LIST_HEAD(&cfs_rq->throttled_list);
 }
 
@@ -6368,7 +6379,7 @@ static void unthrottle_offline_cfs_rqs(struct rq *rq)
 	for_each_leaf_cfs_rq(rq, cfs_rq) {
 		struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 
-		if (!cfs_rq->runtime_enabled)
+		if (!cfs_rq_runtime_enabled(cfs_rq))
 			continue;
 
 		/*
@@ -9263,11 +9274,14 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 		struct rq *rq = rq_of(cfs_rq);
 
 		raw_spin_lock_irq(&rq->lock);
-		cfs_rq->runtime_enabled = runtime_enabled;
-		cfs_rq->runtime_remaining = 0;
-
 		if (cfs_rq_throttled(cfs_rq))
 			unthrottle_cfs_rq(cfs_rq);
+
+		if (runtime_enabled)
+			cfs_rq->runtime_state = RUNTIME_AVAILABLE;
+		else
+			cfs_rq->runtime_state = RUNTIME_UNLIMITED;
+		cfs_rq->runtime_remaining = 0;
 		raw_spin_unlock_irq(&rq->lock);
 	}
 out_unlock:
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3539569..7dc5c19 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1387,6 +1387,27 @@ static void expire_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 	}
 }
 
+static void account_nr_throttling(struct cfs_rq *cfs_rq, long delta)
+{
+	struct sched_entity *se;
+
+	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+
+	for_each_sched_entity(se) {
+		struct cfs_rq *qcfs_rq = cfs_rq_of(se);
+		if (!se->on_rq)
+			break;
+
+		qcfs_rq->h_nr_running += delta;
+
+		if (qcfs_rq->runtime_state == RUNTIME_THROTTLING)
+			break;
+	}
+
+	if (!se)
+		rq_of(cfs_rq)->nr_running += delta;
+}
+
 static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 				     unsigned long delta_exec)
 {
@@ -1401,14 +1422,33 @@ static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 	 * if we're unable to extend our runtime we resched so that the active
 	 * hierarchy can be throttled
 	 */
-	if (!assign_cfs_rq_runtime(cfs_rq) && likely(cfs_rq->curr))
-		resched_task(rq_of(cfs_rq)->curr);
+	if (assign_cfs_rq_runtime(cfs_rq))
+		return;
+
+	if (unlikely(!cfs_rq->curr) || throttled_hierarchy(cfs_rq) ||
+	    cfs_rq->runtime_state == RUNTIME_THROTTLING)
+		return;
+
+	resched_task(rq_of(cfs_rq)->curr);
+
+	/*
+	 * Remove us from nr_running/h_nr_running so
+	 * that idle_balance gets called if necessary
+	 */
+	account_nr_throttling(cfs_rq, -cfs_rq->h_nr_running);
+	cfs_rq->runtime_state = RUNTIME_THROTTLING;
+}
+
+static inline int cfs_rq_runtime_enabled(struct cfs_rq *cfs_rq)
+{
+	return cfs_bandwidth_used() &&
+		cfs_rq->runtime_state != RUNTIME_UNLIMITED;
 }
 
 static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 						   unsigned long delta_exec)
 {
-	if (!cfs_bandwidth_used() || !cfs_rq->runtime_enabled)
+	if (!cfs_rq_runtime_enabled(cfs_rq))
 		return;
 
 	__account_cfs_rq_runtime(cfs_rq, delta_exec);
@@ -1416,7 +1456,8 @@ static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {
-	return cfs_bandwidth_used() && cfs_rq->throttled;
+	return cfs_bandwidth_used() &&
+		cfs_rq->runtime_state >= RUNTIME_THROTTLING;
 }
 
 /* check whether cfs_rq, or any parent, is throttled */
@@ -1483,7 +1524,6 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	struct rq *rq = rq_of(cfs_rq);
 	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
 	struct sched_entity *se;
-	long task_delta, dequeue = 1;
 
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
@@ -1492,25 +1532,19 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	walk_tg_tree_from(cfs_rq->tg, tg_throttle_down, tg_nop, (void *)rq);
 	rcu_read_unlock();
 
-	task_delta = cfs_rq->h_nr_running;
 	for_each_sched_entity(se) {
 		struct cfs_rq *qcfs_rq = cfs_rq_of(se);
 		/* throttled entity or throttle-on-deactivate */
 		if (!se->on_rq)
 			break;
 
-		if (dequeue)
-			dequeue_entity(qcfs_rq, se, DEQUEUE_SLEEP);
-		qcfs_rq->h_nr_running -= task_delta;
+		dequeue_entity(qcfs_rq, se, DEQUEUE_SLEEP);
 
 		if (qcfs_rq->load.weight)
-			dequeue = 0;
+			break;
 	}
 
-	if (!se)
-		rq->nr_running -= task_delta;
-
-	cfs_rq->throttled = 1;
+	cfs_rq->runtime_state = RUNTIME_THROTTLED;
 	cfs_rq->throttled_timestamp = rq->clock;
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
@@ -1525,9 +1559,15 @@ static void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	int enqueue = 1;
 	long task_delta;
 
+	if (cfs_rq->runtime_state == RUNTIME_THROTTLING) {
+		/* do only the partial unthrottle */
+		account_nr_throttling(cfs_rq, cfs_rq->h_nr_running);
+		return;
+	}
+
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
 
-	cfs_rq->throttled = 0;
+	cfs_rq->runtime_state = RUNTIME_AVAILABLE;
 	raw_spin_lock(&cfs_b->lock);
 	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_timestamp;
 	list_del_rcu(&cfs_rq->throttled_list);
@@ -1743,10 +1783,7 @@ static void __return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 
 static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
-	if (!cfs_bandwidth_used())
-		return;
-
-	if (!cfs_rq->runtime_enabled || cfs_rq->nr_running)
+	if (!cfs_rq_runtime_enabled(cfs_rq) || cfs_rq->nr_running)
 		return;
 
 	__return_cfs_rq_runtime(cfs_rq);
@@ -1791,15 +1828,12 @@ static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
  */
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq)
 {
-	if (!cfs_bandwidth_used())
-		return;
-
 	/* an active group must be handled by the update_curr()->put() path */
-	if (!cfs_rq->runtime_enabled || cfs_rq->curr)
+	if (!cfs_rq_runtime_enabled(cfs_rq) || cfs_rq->curr)
 		return;
 
 	/* ensure the group is not already throttled */
-	if (cfs_rq_throttled(cfs_rq))
+	if (cfs_rq->runtime_state == RUNTIME_THROTTLED)
 		return;
 
 	/* update runtime allocation */
@@ -1814,17 +1848,21 @@ static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 	if (!cfs_bandwidth_used())
 		return;
 
-	if (likely(!cfs_rq->runtime_enabled || cfs_rq->runtime_remaining > 0))
+	if (likely(cfs_rq->runtime_state != RUNTIME_THROTTLING))
 		return;
 
 	/*
-	 * it's possible for a throttled entity to be forced into a running
-	 * state (e.g. set_curr_task), in this case we're finished.
+	* it is possible for additional bandwidth to arrive between
+	* when we call resched_task for being out of runtime and we
+	* call put_prev_task, in which case reaccount the now running
+	* tasks
 	 */
-	if (cfs_rq_throttled(cfs_rq))
-		return;
-
-	throttle_cfs_rq(cfs_rq);
+	if (unlikely(cfs_rq->runtime_remaining > 0)) {
+		account_nr_throttling(cfs_rq, cfs_rq->h_nr_running);
+		cfs_rq->runtime_state = RUNTIME_AVAILABLE;
+	} else {
+		throttle_cfs_rq(cfs_rq);
+	}
 }
 #else
 static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
