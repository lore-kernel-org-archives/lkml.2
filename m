Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0DVLIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 07:08:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab0DVLIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 07:08:19 -0400
Subject: Re: [REGRESSION 2.6.30][PATCH v3] sched: update load count only
 once per cpu in 10 tick update window
From: Peter Zijlstra <peterz@infradead.org>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-team <kernel-team@lists.ubuntu.com>
In-Reply-To: <1271200751-18697-1-git-send-email-chase.douglas@canonical.com>
References: <1271200751-18697-1-git-send-email-chase.douglas@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Apr 2010 13:08:10 +0200
Message-ID: <1271934490.1776.343.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 16:19 -0700, Chase Douglas wrote:
> 
> There's a period of 10 ticks where calc_load_tasks is updated by all the
> cpus for the load avg. Usually all the cpus do this during the first
> tick. If any cpus go idle, calc_load_tasks is decremented accordingly.
> However, if they wake up calc_load_tasks is not incremented. Thus, if
> cpus go idle during the 10 tick period, calc_load_tasks may be
> decremented to a non-representative value. This issue can lead to
> systems having a load avg of exactly 0, even though the real load avg
> could theoretically be up to NR_CPUS.
> 
> This change defers calc_load_tasks accounting after each cpu updates the
> count until after the 10 tick update window.
> 
> A few points:
> 
> * A global atomic deferral counter, and not per-cpu vars, is needed
>   because a cpu may go NOHZ idle and not be able to update the global
>   calc_load_tasks variable for subsequent load calculations.
> * It is not enough to add calls to account for the load when a cpu is
>   awakened:
>   - Load avg calculation must be independent of cpu load.
>   - If a cpu is awakend by one tasks, but then has more scheduled before
>     the end of the update window, only the first task will be accounted.
> 

Ok, so delaying the whole ILB angle for now, the below is a similar
approach to yours but with a more explicit code flow.

Does that work for you?

---
 kernel/sched.c          |   80 +++++++++++++++++++++++++++++++++++++++-------
 kernel/sched_idletask.c |    3 +-
 2 files changed, 68 insertions(+), 15 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 95eaecc..8ac02a9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1815,7 +1815,7 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 }
 #endif
 
-static void calc_load_account_active(struct rq *this_rq);
+static void calc_load_account_idle(struct rq *this_rq);
 static void update_sysctl(void);
 static int get_update_sysctl_factor(void);
 
@@ -2907,6 +2907,61 @@ static unsigned long calc_load_update;
 unsigned long avenrun[3];
 EXPORT_SYMBOL(avenrun);
 
+static long calc_load_fold_active(struct rq *this_rq)
+{
+	long nr_active, delta = 0;
+
+	nr_active = this_rq->nr_running;
+	nr_active += (long) this_rq->nr_uninterruptible;
+
+	if (nr_active != this_rq->calc_load_active) {
+		delta = nr_active - this_rq->calc_load_active;
+		this_rq->calc_load_active = nr_active;
+	}
+
+	return delta;
+}
+
+#ifdef CONFIG_NO_HZ
+/*
+ * For NO_HZ we delay the active fold to the next LOAD_FREQ update.
+ *
+ * When making the ILB scale, we should try to pull this in as well.
+ */
+static atomic_long_t calc_load_tasks_idle;
+
+static void calc_load_account_idle(struct rq *this_rq)
+{
+	long delta;
+       
+	delta = calc_load_fold_active(this_rq);
+	if (delta)
+		atomic_long_add(delta, &calc_load_tasks_idle);
+}
+
+static long calc_load_fold_idle(void)
+{
+	long delta = 0;
+
+	/*
+	 * Its got a race, we don't care...
+	 */
+	if (atomic_long_read(&calc_load_tasks_idle))
+		delta = atomic_long_xchg(&calc_load_tasks_idle, 0);
+
+	return delta;
+}
+#else
+static void calc_load_account_idle(struct rq *this_rq)
+{
+}
+
+static inline long calc_load_fold_idle(void)
+{
+	return 0;
+}
+#endif
+
 /**
  * get_avenrun - get the load average array
  * @loads:	pointer to dest load array
@@ -2953,20 +3008,22 @@ void calc_global_load(void)
 }
 
 /*
- * Either called from update_cpu_load() or from a cpu going idle
+ * Called from update_cpu_load() to periodically update this CPU's
+ * active count.
  */
 static void calc_load_account_active(struct rq *this_rq)
 {
-	long nr_active, delta;
+	long delta;
 
-	nr_active = this_rq->nr_running;
-	nr_active += (long) this_rq->nr_uninterruptible;
+	if (time_before(jiffies, this_rq->calc_load_update))
+		return;
 
-	if (nr_active != this_rq->calc_load_active) {
-		delta = nr_active - this_rq->calc_load_active;
-		this_rq->calc_load_active = nr_active;
+	delta  = calc_load_fold_active(this_rq);
+	delta += calc_load_fold_idle();
+	if (delta)
 		atomic_long_add(delta, &calc_load_tasks);
-	}
+
+	this_rq->calc_load_update += LOAD_FREQ;
 }
 
 /*
@@ -2998,10 +3055,7 @@ static void update_cpu_load(struct rq *this_rq)
 		this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
 	}
 
-	if (time_after_eq(jiffies, this_rq->calc_load_update)) {
-		this_rq->calc_load_update += LOAD_FREQ;
-		calc_load_account_active(this_rq);
-	}
+	calc_load_account_active(this_rq);
 }
 
 #ifdef CONFIG_SMP
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index bea2b8f..9fa0f40 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -23,8 +23,7 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int fl
 static struct task_struct *pick_next_task_idle(struct rq *rq)
 {
 	schedstat_inc(rq, sched_goidle);
-	/* adjust the active tasks as we might go into a long sleep */
-	calc_load_account_active(rq);
+	calc_load_account_idle(rq);
 	return rq->idle;
 }
 


