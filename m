Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab2AWXDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:03:01 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45391 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754144Ab2AWXDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:03:00 -0500
Message-ID: <4F1DE6FE.4000603@fb.com>
Date: Mon, 23 Jan 2012 15:02:22 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] trace: reset sleep/block start time on task switch
References: <1327026020-32376-1-git-send-email-asharma@fb.com>  <1327318449.2446.5.camel@twins> <4F1DA9D0.6090208@fb.com> <1327352631.2446.22.camel@twins>
In-Reply-To: <1327352631.2446.22.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.211,0.0.0000
 definitions=2012-01-23_05:2012-01-23,2012-01-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/12 1:03 PM, Peter Zijlstra wrote:

> This would limit the stores to the blocking case, your suggestion of
> moving them to the same cacheline will then get us back where we started
> in terms of performance.
>
> Or did I miss something?
>
>
> ---
>   kernel/sched/fair.c |    3 +++
>   1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 84adb2d..60f9ab9 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1191,6 +1191,9 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>   		if (entity_is_task(se)) {
>   			struct task_struct *tsk = task_of(se);
>
> +			se->statistics.sleep_start = 0;
> +			se->statistics.block_start = 0;
> +

We might still need some additional logic to ignore sleep_start if the 
last context switch was a preemption. Test case Andrew Vagin posted on 
12/21:

nanosleep();
s = time(NULL);
while (time(NULL) - s < 4);

During the busy wait while loop, sleep_start is non-zero and the first 
sample from sched_stat_sleeptime() and anyone else doing the (now - 
sleep_start) computation would get a bogus value until the next dequeue.

I can't think of an obvious way to pass an extra parameter (bool 
preempted) to the tracepoint. Would something like this be too
intrusive?


diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index df00cb0..b69bb9a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1908,7 +1908,8 @@ prepare_task_switch(struct rq *rq, struct 
task_struct *prev,
  * with the lock held can cause deadlocks; see schedule() for
  * details.)
  */
-static void finish_task_switch(struct rq *rq, struct task_struct *prev)
+static void finish_task_switch(struct rq *rq, struct task_struct *prev,
+			       bool preempted)
	__releases(rq->lock)
{
	struct mm_struct *mm = rq->prev_mm;
@@ -1997,7 +1998,7 @@ asmlinkage void schedule_tail(struct task_struct 
*prev)
{
	struct rq *rq = this_rq();

-	finish_task_switch(rq, prev);
+	finish_task_switch(rq, prev, false);

	/*
	 * FIXME: do we need to worry about rq being invalidated by the
@@ -2019,7 +2020,7 @@ asmlinkage void schedule_tail(struct task_struct 
*prev)
  */
static inline void
context_switch(struct rq *rq, struct task_struct *prev,
-	       struct task_struct *next)
+	       struct task_struct *next, bool preempted)
{
	struct mm_struct *mm, *oldmm;

@@ -2064,7 +2065,7 @@ context_switch(struct rq *rq, struct task_struct 
*prev,
	 * CPUs since it called schedule(), thus the 'rq' on its stack
	 * frame will be invalid.
	 */
-	finish_task_switch(this_rq(), prev);
+	finish_task_switch(this_rq(), prev, preempted);
}

/*
@@ -3155,9 +3156,9 @@ pick_next_task(struct rq *rq)
static void __sched __schedule(void)
{
	struct task_struct *prev, *next;
-	unsigned long *switch_count;
	struct rq *rq;
	int cpu;
+	bool preempted;

need_resched:
	preempt_disable();
@@ -3173,7 +3174,7 @@ need_resched:

	raw_spin_lock_irq(&rq->lock);

-	switch_count = &prev->nivcsw;
+	preempted = true;
	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
		if (unlikely(signal_pending_state(prev->state, prev))) {
			prev->state = TASK_RUNNING;
@@ -3194,7 +3195,7 @@ need_resched:
					try_to_wake_up_local(to_wakeup);
			}
		}
-		switch_count = &prev->nvcsw;
+		preempted = false;
	}

	pre_schedule(rq, prev);
@@ -3210,9 +3211,12 @@ need_resched:
	if (likely(prev != next)) {
		rq->nr_switches++;
		rq->curr = next;
-		++*switch_count;
+		if (preempted)
+			 prev->nivcsw++;
+		else
+			 prev->nvcsw++;

-		context_switch(rq, prev, next); /* unlocks the rq */
+		context_switch(rq, prev, next, preempted); /* unlocks the rq */
		/*
		 * The context switch have flipped the stack from under us
		 * and restored the local variables which were saved when

  -Arun
