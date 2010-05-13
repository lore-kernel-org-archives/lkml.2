Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab0EMKsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:48:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:60570 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757Ab0EMKsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:48:43 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 4/4] sched: add hooks for workqueue
Date: Thu, 13 May 2010 12:48:25 +0200
Message-Id: <1273747705-7829-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273747705-7829-1-git-send-email-tj@kernel.org>
References: <1273747705-7829-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 10:48:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Concurrency managed workqueue needs to know when workers are going to
sleep and waking up, and, when a worker goes to sleep, be able to wake
up another worker to maintain adequate concurrency.  This patch
introduces PF_WQ_WORKER to identify workqueue workers and adds the
following two hooks.

* wq_worker_waking_up(): called when a worker is woken up.

* wq_worker_sleeping(): called when a worker is going to sleep and may
  return a pointer to a local task which should be woken up.  The
  returned task is woken up using try_to_wake_up_local() which is
  simplified ttwu which is called under rq lock and can only wake up
  local tasks.

Both hooks are currently defined as noop in kernel/workqueue_sched.h.
Later cmwq implementation will replace them with proper
implementation.

These hooks are hard coded as they'll always be enabled.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h    |    1 +
 kernel/fork.c            |    2 +-
 kernel/sched.c           |   53 ++++++++++++++++++++++++++++++++++++++++++++-
 kernel/workqueue_sched.h |   16 +++++++++++++
 4 files changed, 69 insertions(+), 3 deletions(-)
 create mode 100644 kernel/workqueue_sched.h

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ef6067c..553ffae 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1702,6 +1702,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
 #define PF_VCPU		0x00000010	/* I'm a virtual CPU */
+#define PF_WQ_WORKER	0x00000020	/* I'm a workqueue worker */
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
 #define PF_MCE_PROCESS  0x00000080      /* process policy on mce errors */
 #define PF_SUPERPRIV	0x00000100	/* used super-user privileges */
diff --git a/kernel/fork.c b/kernel/fork.c
index 44b0791..1440f90 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -900,7 +900,7 @@ static void copy_flags(unsigned long clone_flags, struct task_struct *p)
 {
 	unsigned long new_flags = p->flags;
 
-	new_flags &= ~PF_SUPERPRIV;
+	new_flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER);
 	new_flags |= PF_FORKNOEXEC;
 	new_flags |= PF_STARTING;
 	p->flags = new_flags;
diff --git a/kernel/sched.c b/kernel/sched.c
index 0b6da84..460b176 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -77,6 +77,7 @@
 #include <asm/irq_regs.h>
 
 #include "sched_cpupri.h"
+#include "workqueue_sched.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
@@ -2361,6 +2362,9 @@ static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
 		rq->idle_stamp = 0;
 	}
 #endif
+	/* if a worker is waking up, notify workqueue */
+	if ((p->flags & PF_WQ_WORKER) && success)
+		wq_worker_waking_up(p, cpu_of(rq));
 }
 
 /**
@@ -2469,6 +2473,37 @@ out:
 }
 
 /**
+ * try_to_wake_up_local - try to wake up a local task with rq lock held
+ * @p: the thread to be awakened
+ *
+ * Put @p on the run-queue if it's not alredy there.  The caller must
+ * ensure that this_rq() is locked, @p is bound to this_rq() and not
+ * the current task.  this_rq() stays locked over invocation.
+ */
+static void try_to_wake_up_local(struct task_struct *p)
+{
+	struct rq *rq = task_rq(p);
+	bool success = false;
+
+	BUG_ON(rq != this_rq());
+	BUG_ON(p == current);
+	lockdep_assert_held(&rq->lock);
+
+	if (!(p->state & TASK_NORMAL))
+		return;
+
+	if (!p->se.on_rq) {
+		if (likely(!task_running(rq, p))) {
+			schedstat_inc(rq, ttwu_count);
+			schedstat_inc(rq, ttwu_local);
+		}
+		ttwu_activate(p, rq, false, false, true, ENQUEUE_WAKEUP);
+		success = true;
+	}
+	ttwu_post_activation(p, rq, 0, success);
+}
+
+/**
  * wake_up_process - Wake up a specific process
  * @p: The process to be woken up.
  *
@@ -3673,10 +3708,24 @@ need_resched_nonpreemptible:
 	clear_tsk_need_resched(prev);
 
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
-		if (unlikely(signal_pending_state(prev->state, prev)))
+		if (unlikely(signal_pending_state(prev->state, prev))) {
 			prev->state = TASK_RUNNING;
-		else
+		} else {
+			/*
+			 * If a worker is going to sleep, notify and
+			 * ask workqueue whether it wants to wake up a
+			 * task to maintain concurrency.  If so, wake
+			 * up the task.
+			 */
+			if (prev->flags & PF_WQ_WORKER) {
+				struct task_struct *to_wakeup;
+
+				to_wakeup = wq_worker_sleeping(prev, cpu);
+				if (to_wakeup)
+					try_to_wake_up_local(to_wakeup);
+			}
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
+		}
 		switch_count = &prev->nvcsw;
 	}
 
diff --git a/kernel/workqueue_sched.h b/kernel/workqueue_sched.h
new file mode 100644
index 0000000..af040ba
--- /dev/null
+++ b/kernel/workqueue_sched.h
@@ -0,0 +1,16 @@
+/*
+ * kernel/workqueue_sched.h
+ *
+ * Scheduler hooks for concurrency managed workqueue.  Only to be
+ * included from sched.c and workqueue.c.
+ */
+static inline void wq_worker_waking_up(struct task_struct *task,
+				       unsigned int cpu)
+{
+}
+
+static inline struct task_struct *wq_worker_sleeping(struct task_struct *task,
+						     unsigned int cpu)
+{
+	return NULL;
+}
-- 
1.6.4.2

