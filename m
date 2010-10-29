Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627Ab0J2IgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 04:36:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60789 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760687Ab0J2IgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 04:36:07 -0400
Date: Fri, 29 Oct 2010 10:35:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20101029083559.GA13093@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      sched, cgroup: Fixup broken cgroup movement

Rakib Mullick (1):
      sched_stat: Update sched_info_queue/dequeue() code comments


 include/linux/sched.h |    2 +-
 kernel/sched.c        |    8 ++++----
 kernel/sched_fair.c   |   25 +++++++++++++++++++------
 kernel/sched_stats.h  |   20 +-------------------
 4 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2cca9a9..be312c1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1073,7 +1073,7 @@ struct sched_class {
 					 struct task_struct *task);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	void (*moved_group) (struct task_struct *p, int on_rq);
+	void (*task_move_group) (struct task_struct *p, int on_rq);
 #endif
 };
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 5998222..3fe253e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8498,12 +8498,12 @@ void sched_move_task(struct task_struct *tsk)
 	if (unlikely(running))
 		tsk->sched_class->put_prev_task(rq, tsk);
 
-	set_task_rq(tsk, task_cpu(tsk));
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	if (tsk->sched_class->moved_group)
-		tsk->sched_class->moved_group(tsk, on_rq);
+	if (tsk->sched_class->task_move_group)
+		tsk->sched_class->task_move_group(tsk, on_rq);
+	else
 #endif
+		set_task_rq(tsk, task_cpu(tsk));
 
 	if (unlikely(running))
 		tsk->sched_class->set_curr_task(rq);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 74cccfa..3acc2a4 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3866,13 +3866,26 @@ static void set_curr_task_fair(struct rq *rq)
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-static void moved_group_fair(struct task_struct *p, int on_rq)
+static void task_move_group_fair(struct task_struct *p, int on_rq)
 {
-	struct cfs_rq *cfs_rq = task_cfs_rq(p);
-
-	update_curr(cfs_rq);
+	/*
+	 * If the task was not on the rq at the time of this cgroup movement
+	 * it must have been asleep, sleeping tasks keep their ->vruntime
+	 * absolute on their old rq until wakeup (needed for the fair sleeper
+	 * bonus in place_entity()).
+	 *
+	 * If it was on the rq, we've just 'preempted' it, which does convert
+	 * ->vruntime to a relative base.
+	 *
+	 * Make sure both cases convert their relative position when migrating
+	 * to another cgroup's rq. This does somewhat interfere with the
+	 * fair sleeper stuff for the first placement, but who cares.
+	 */
+	if (!on_rq)
+		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
+	set_task_rq(p, task_cpu(p));
 	if (!on_rq)
-		place_entity(cfs_rq, &p->se, 1);
+		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
 }
 #endif
 
@@ -3924,7 +3937,7 @@ static const struct sched_class fair_sched_class = {
 	.get_rr_interval	= get_rr_interval_fair,
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
-	.moved_group		= moved_group_fair,
+	.task_move_group	= task_move_group_fair,
 #endif
 };
 
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 25c2f96..48ddf43 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -157,15 +157,7 @@ static inline void sched_info_reset_dequeued(struct task_struct *t)
 }
 
 /*
- * Called when a process is dequeued from the active array and given
- * the cpu.  We should note that with the exception of interactive
- * tasks, the expired queue will become the active queue after the active
- * queue is empty, without explicitly dequeuing and requeuing tasks in the
- * expired queue.  (Interactive tasks may be requeued directly to the
- * active queue, thus delaying tasks in the expired queue from running;
- * see scheduler_tick()).
- *
- * Though we are interested in knowing how long it was from the *first* time a
+ * We are interested in knowing how long it was from the *first* time a
  * task was queued to the time that it finally hit a cpu, we call this routine
  * from dequeue_task() to account for possible rq->clock skew across cpus. The
  * delta taken on each cpu would annul the skew.
@@ -203,16 +195,6 @@ static void sched_info_arrive(struct task_struct *t)
 }
 
 /*
- * Called when a process is queued into either the active or expired
- * array.  The time is noted and later used to determine how long we
- * had to wait for us to reach the cpu.  Since the expired queue will
- * become the active queue after active queue is empty, without dequeuing
- * and requeuing any tasks, we are interested in queuing to either. It
- * is unusual but not impossible for tasks to be dequeued and immediately
- * requeued in the same or another array: this can happen in sched_yield(),
- * set_user_nice(), and even load_balance() as it moves tasks from runqueue
- * to runqueue.
- *
  * This function is only called from enqueue_task(), but also only updates
  * the timestamp if it is already not set.  It's assumed that
  * sched_info_dequeued() will clear that stamp when appropriate.
