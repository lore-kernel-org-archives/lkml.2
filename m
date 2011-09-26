Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1IZTOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 15:14:09 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57772 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab1IZTOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 15:14:07 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: [PATCH 2/6] [RFC] sched: Add support for SCHED_STAYAWAKE flag
Date: Mon, 26 Sep 2011 12:13:50 -0700
Message-Id: <1317064434-1829-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a draft proof of concept on how a stayawake scheduler flag
could be used to inhibit suspend from userland.

I'm in no way married to this specific api, but this acts a a concrete
example of the following idea I'd like to propose:

First there is some method for a task to mark and unmark itself as
"important".

While there are any "important" tasks, no matter if they are runnable
or not, suspend could not occur (this is not unlike Android's userland
wakelocks).

Now, If an "important" task were to block on a device that the kernel
knows to be a wake-up source, the kerenl can choose to de-boost the
"important" task, so that while blocked, it would not be considered
"important".

Upon task wakeup, the kernel would re-boost the task back to its prior
level of importance.

One can sort of imagine this as an upside-down priority inheritance.

This patch provides the API for a task to mark and umark itself as
"important" and block suspend, as well as the hook on wakeup to
reboost any de-boosted tasks.

Now, for corrrectness, in order to avoid races with suspend attempts
that might occur after a wakeup event but before the "important" task
is reboosted on wakeup, there would need to be over-lapping pm_stay_awake
and pm_relax chaining, so the entire IRQ->task wakeup path prohibited
suspend.

CC: Rafael J. Wysocki <rjw@sisk.pl>
CC: arve@android.com
CC: markgross@thegnar.org
CC: Alan Stern <stern@rowland.harvard.edu>
CC: amit.kucheria@linaro.org
CC: farrowg@sg.ibm.com
CC: Dmitry Fink (Palm GBU) <Dmitry.Fink@palm.com>
CC: linux-pm@lists.linux-foundation.org
CC: khilman@ti.com
CC: Magnus Damm <damm@opensource.se>
CC: mjg@redhat.com 
CC: peterz@infradead.org 
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/sched.h |   12 ++++++
 kernel/exit.c         |    2 +
 kernel/fork.c         |    2 +
 kernel/sched.c        |  101 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 117 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ac2c05..3557838 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -41,6 +41,8 @@
 #define SCHED_IDLE		5
 /* Can be ORed in to make sure the process is reverted back to SCHED_NORMAL on fork */
 #define SCHED_RESET_ON_FORK     0x40000000
+#define SCHED_STAYAWAKE		0x0f000000
+
 
 #ifdef __KERNEL__
 
@@ -1566,6 +1568,10 @@ struct task_struct {
 		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
+
+	int task_active_count;
+	int task_active_boosted;
+
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 	atomic_t ptrace_bp_refcnt;
 #endif
@@ -1753,6 +1759,12 @@ static inline void put_task_struct(struct task_struct *t)
 extern void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
 extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st);
 
+
+extern void sched_inc_active_count(void);
+extern void sched_dec_active_count(void);
+extern void sched_deboost_task_active_count(struct task_struct *p);
+extern void sched_boost_task_active_count(struct task_struct *p);
+
 /*
  * Per process flags
  */
diff --git a/kernel/exit.c b/kernel/exit.c
index 2913b35..71f7bd4 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -994,6 +994,8 @@ NORET_TYPE void do_exit(long code)
 	 */
 	perf_event_exit_task(tsk);
 
+	sched_deboost_task_active_count(tsk);
+
 	cgroup_exit(tsk, 1);
 
 	if (group_dead)
diff --git a/kernel/fork.c b/kernel/fork.c
index 8e6b6f4..c79c4fb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1213,6 +1213,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->memcg_batch.do_batch = 0;
 	p->memcg_batch.memcg = NULL;
 #endif
+	p->task_active_count = 0;
+	p->task_active_boosted = 0;
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p);
diff --git a/kernel/sched.c b/kernel/sched.c
index ec5f472..a134129 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -852,6 +852,96 @@ static inline u64 global_rt_runtime(void)
 # define finish_arch_switch(prev)	do { } while (0)
 #endif
 
+/* XXX This should be per-cpu or soemthing that scales */
+static int global_task_active_count = 0;
+static DEFINE_SPINLOCK(global_task_active_lock);
+static struct wakeup_source *wakelock;
+
+static int __init wakelock_init(void)
+{
+       wakelock = wakeup_source_register("wakelock");
+       return 0;
+}
+core_initcall(wakelock_init);
+
+
+static void __sched_inc_global_active_count(int count)
+{
+	if (!global_task_active_count && count)
+		__pm_stay_awake(wakelock);
+	global_task_active_count += count;
+}
+
+static void __sched_dec_global_active_count(int count)
+{
+	WARN_ON(count > global_task_active_count);
+	global_task_active_count -= count;
+	if (!global_task_active_count && count)
+		__pm_relax(wakelock);
+}
+
+void sched_inc_active_count(void)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&global_task_active_lock, flags);
+
+	current->task_active_boosted = 1;
+	current->task_active_count++;
+	__sched_inc_global_active_count(1);
+
+	spin_unlock_irqrestore(&global_task_active_lock, flags);
+}
+
+void sched_dec_active_count(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&global_task_active_lock, flags);
+
+	WARN_ON(current->task_active_count == 0);
+
+	current->task_active_count--;
+	if (current->task_active_count == 0)
+		current->task_active_boosted = 0;
+	__sched_dec_global_active_count(1);
+
+	spin_unlock_irqrestore(&global_task_active_lock, flags);
+
+}
+
+void sched_deboost_task_active_count(struct task_struct *p)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&global_task_active_lock, flags);
+
+	if (p->task_active_boosted)
+		__sched_dec_global_active_count(p->task_active_count);
+	p->task_active_boosted = 0;
+
+	spin_unlock_irqrestore(&global_task_active_lock, flags);
+
+}
+
+void sched_boost_task_active_count(struct task_struct *p)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&global_task_active_lock, flags);
+	if (!p->task_active_boosted)
+		__sched_inc_global_active_count(p->task_active_count);
+	if (p->task_active_count)
+		p->task_active_boosted = 1;
+	spin_unlock_irqrestore(&global_task_active_lock, flags);
+}
+
+static inline int is_task_active(struct task_struct *p)
+{
+	return !!p->task_active_count;
+}
+
+
+
 static inline int task_current(struct rq *rq, struct task_struct *p)
 {
 	return rq->curr == p;
@@ -2727,6 +2817,8 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 	p->sched_contributes_to_load = !!task_contributes_to_load(p);
 	p->state = TASK_WAKING;
 
+	sched_boost_task_active_count(p);
+
 	if (p->sched_class->task_waking)
 		p->sched_class->task_waking(p);
 
@@ -5113,6 +5205,7 @@ static int __sched_setscheduler(struct task_struct *p, int policy,
 	const struct sched_class *prev_class;
 	struct rq *rq;
 	int reset_on_fork;
+	int stayawake=0;
 
 	/* may grab non-irq protected spin_locks */
 	BUG_ON(in_interrupt());
@@ -5125,6 +5218,9 @@ recheck:
 		reset_on_fork = !!(policy & SCHED_RESET_ON_FORK);
 		policy &= ~SCHED_RESET_ON_FORK;
 
+		stayawake = !!(policy & SCHED_STAYAWAKE);
+		policy &= ~SCHED_STAYAWAKE;
+
 		if (policy != SCHED_FIFO && policy != SCHED_RR &&
 				policy != SCHED_NORMAL && policy != SCHED_BATCH &&
 				policy != SCHED_IDLE)
@@ -5202,6 +5298,11 @@ recheck:
 		return -EINVAL;
 	}
 
+	if (stayawake && !is_task_active(p))
+		sched_inc_active_count();
+	else if (!stayawake && is_task_active(p))
+		sched_dec_active_count();
+
 	/*
 	 * If not changing anything there's no need to proceed further:
 	 */
-- 
1.7.3.2.146.gca209

