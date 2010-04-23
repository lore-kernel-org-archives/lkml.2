Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab0DWKu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:50:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:40692 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757112Ab0DWKuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:50:25 -0400
Date: Fri, 23 Apr 2010 10:49:58 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, chase.douglas@canonical.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, chase.douglas@canonical.com,
       mingo@elte.hu
In-Reply-To: <1271934490.1776.343.camel@laptop>
References: <1271934490.1776.343.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Cure load average vs NO_HZ woes
Message-ID: <tip-74f5187ac873042f502227701ed1727e7c5fbfa9@git.kernel.org>
Git-Commit-ID: 74f5187ac873042f502227701ed1727e7c5fbfa9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Apr 2010 10:49:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74f5187ac873042f502227701ed1727e7c5fbfa9
Gitweb:     http://git.kernel.org/tip/74f5187ac873042f502227701ed1727e7c5fbfa9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 22 Apr 2010 21:50:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 23 Apr 2010 11:02:02 +0200

sched: Cure load average vs NO_HZ woes

Chase reported that due to us decrementing calc_load_task prematurely
(before the next LOAD_FREQ sample), the load average could be scewed
by as much as the number of CPUs in the machine.

This patch, based on Chase's patch, cures the problem by keeping the
delta of the CPU going into NO_HZ idle separately and folding that in
on the next LOAD_FREQ update.

This restores the balance and we get strict LOAD_FREQ period samples.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Chase Douglas <chase.douglas@canonical.com>
LKML-Reference: <1271934490.1776.343.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c          |   80 +++++++++++++++++++++++++++++++++++++++-------
 kernel/sched_idletask.c |    3 +-
 2 files changed, 68 insertions(+), 15 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index de0da71..0cc913a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1815,7 +1815,7 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 }
 #endif
 
-static void calc_load_account_active(struct rq *this_rq);
+static void calc_load_account_idle(struct rq *this_rq);
 static void update_sysctl(void);
 static int get_update_sysctl_factor(void);
 
@@ -2950,6 +2950,61 @@ static unsigned long calc_load_update;
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
@@ -2996,20 +3051,22 @@ void calc_global_load(void)
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
@@ -3041,10 +3098,7 @@ static void update_cpu_load(struct rq *this_rq)
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
 
