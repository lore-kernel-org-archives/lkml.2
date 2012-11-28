Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab2K1Rwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:52:34 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57921 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab2K1Rw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:52:29 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/4] cputime: Move thread_group_cputime() to sched code
Date: Wed, 28 Nov 2012 18:52:17 +0100
Message-Id: <1354125140-9294-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1354125140-9294-1-git-send-email-fweisbec@gmail.com>
References: <1354125140-9294-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thread_group_cputime() is a general cputime API that is not only
used by posix cpu timer. Let's move this helper to sched code.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/posix-cpu-timers.c |   24 ------------------------
 kernel/sched/cputime.c    |   28 ++++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 125cb67..d738402 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -217,30 +217,6 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 	return 0;
 }
 
-void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
-{
-	struct signal_struct *sig = tsk->signal;
-	struct task_struct *t;
-
-	times->utime = sig->utime;
-	times->stime = sig->stime;
-	times->sum_exec_runtime = sig->sum_sched_runtime;
-
-	rcu_read_lock();
-	/* make sure we can trust tsk->thread_group list */
-	if (!likely(pid_alive(tsk)))
-		goto out;
-
-	t = tsk;
-	do {
-		times->utime += t->utime;
-		times->stime += t->stime;
-		times->sum_exec_runtime += task_sched_runtime(t);
-	} while_each_thread(tsk, t);
-out:
-	rcu_read_unlock();
-}
-
 static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
 {
 	if (b->utime > a->utime)
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 8d859da..e56f138 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -288,6 +288,34 @@ static __always_inline bool steal_account_process_tick(void)
 	return false;
 }
 
+/*
+ * Accumulate raw cputime values of dead tasks (sig->[us]time) and live
+ * tasks (sum on group iteration) belonging to @tsk's group.
+ */
+void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
+{
+	struct signal_struct *sig = tsk->signal;
+	struct task_struct *t;
+
+	times->utime = sig->utime;
+	times->stime = sig->stime;
+	times->sum_exec_runtime = sig->sum_sched_runtime;
+
+	rcu_read_lock();
+	/* make sure we can trust tsk->thread_group list */
+	if (!likely(pid_alive(tsk)))
+		goto out;
+
+	t = tsk;
+	do {
+		times->utime += t->utime;
+		times->stime += t->stime;
+		times->sum_exec_runtime += task_sched_runtime(t);
+	} while_each_thread(tsk, t);
+out:
+	rcu_read_unlock();
+}
+
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
-- 
1.7.5.4

