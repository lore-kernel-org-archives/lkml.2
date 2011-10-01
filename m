Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1JAHkb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 03:40:31 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:34790 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1JAHk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 03:40:26 -0400
Date: Sat, 1 Oct 2011 09:38:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL, v2] scheduler fixes
Message-ID: <20111001073856.GA18912@elte.hu>
References: <20110930183651.GA22879@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930183651.GA22879@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://tesla.tglx.de/git/linux-2.6-tip.git sched-urgent-for-linus

[ Note, the diffstat is different from the v1 version, a new fix was 
  added.]

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      posix-cpu-timers: Cure SMP wobbles

Shawn Bohrer (1):
      sched/rt: Migrate equal priority tasks to available CPUs

Simon Kirby (1):
      sched: Fix up wchan borkage


 include/linux/sched.h     |    1 -
 kernel/posix-cpu-timers.c |    5 +++--
 kernel/sched.c            |   26 +-------------------------
 kernel/sched_rt.c         |    4 ++--
 4 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ac2c05..41d0237 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1956,7 +1956,6 @@ static inline void disable_sched_clock_irqtime(void) {}
 
 extern unsigned long long
 task_sched_runtime(struct task_struct *task);
-extern unsigned long long thread_group_sched_runtime(struct task_struct *task);
 
 /* sched_exec is called by processes performing an exec */
 #ifdef CONFIG_SMP
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 58f405b..c8008dd 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -250,7 +250,7 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 	do {
 		times->utime = cputime_add(times->utime, t->utime);
 		times->stime = cputime_add(times->stime, t->stime);
-		times->sum_exec_runtime += t->se.sum_exec_runtime;
+		times->sum_exec_runtime += task_sched_runtime(t);
 	} while_each_thread(tsk, t);
 out:
 	rcu_read_unlock();
@@ -312,7 +312,8 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = thread_group_sched_runtime(p);
+		thread_group_cputime(p, &cputime);
+		cpu->sched = cputime.sum_exec_runtime;
 		break;
 	}
 	return 0;
diff --git a/kernel/sched.c b/kernel/sched.c
index ec5f472..b50b0f0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3725,30 +3725,6 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 }
 
 /*
- * Return sum_exec_runtime for the thread group.
- * In case the task is currently running, return the sum plus current's
- * pending runtime that have not been accounted yet.
- *
- * Note that the thread group might have other running tasks as well,
- * so the return value not includes other pending runtime that other
- * running tasks might have.
- */
-unsigned long long thread_group_sched_runtime(struct task_struct *p)
-{
-	struct task_cputime totals;
-	unsigned long flags;
-	struct rq *rq;
-	u64 ns;
-
-	rq = task_rq_lock(p, &flags);
-	thread_group_cputime(p, &totals);
-	ns = totals.sum_exec_runtime + do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, p, &flags);
-
-	return ns;
-}
-
-/*
  * Account user cpu time to a process.
  * @p: the process that the cpu time gets accounted to
  * @cputime: the cpu time spent in user space since the last update
@@ -4372,7 +4348,7 @@ static inline void sched_submit_work(struct task_struct *tsk)
 		blk_schedule_flush_plug(tsk);
 }
 
-asmlinkage void schedule(void)
+asmlinkage void __sched schedule(void)
 {
 	struct task_struct *tsk = current;
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 97540f0..af11778 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1050,7 +1050,7 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 	 */
 	if (curr && unlikely(rt_task(curr)) &&
 	    (curr->rt.nr_cpus_allowed < 2 ||
-	     curr->prio < p->prio) &&
+	     curr->prio <= p->prio) &&
 	    (p->rt.nr_cpus_allowed > 1)) {
 		int target = find_lowest_rq(p);
 
@@ -1581,7 +1581,7 @@ static void task_woken_rt(struct rq *rq, struct task_struct *p)
 	    p->rt.nr_cpus_allowed > 1 &&
 	    rt_task(rq->curr) &&
 	    (rq->curr->rt.nr_cpus_allowed < 2 ||
-	     rq->curr->prio < p->prio))
+	     rq->curr->prio <= p->prio))
 		push_rt_tasks(rq);
 }
 
