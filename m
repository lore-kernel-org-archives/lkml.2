Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab1DNIkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:40:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:42543 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757920Ab1DNIkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:40:12 -0400
Date: Thu, 14 Apr 2011 08:39:51 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-317f394160e9beb97d19a84c39b7e5eb3d7815a8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152729.515897185@chello.nl>
References: <20110405152729.515897185@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Move the second half of ttwu() to the remote cpu
Git-Commit-ID: 317f394160e9beb97d19a84c39b7e5eb3d7815a8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:39:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  317f394160e9beb97d19a84c39b7e5eb3d7815a8
Gitweb:     http://git.kernel.org/tip/317f394160e9beb97d19a84c39b7e5eb3d7815a8
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:41 +0200

sched: Move the second half of ttwu() to the remote cpu

Now that we've removed the rq->lock requirement from the first part of
ttwu() and can compute placement without holding any rq->lock, ensure
we execute the second half of ttwu() on the actual cpu we want the
task to run on.

This avoids having to take rq->lock and doing the task enqueue
remotely, saving lots on cacheline transfers.

As measured using: http://oss.oracle.com/~mason/sembench.c

  $ for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor ; do echo performance > $i; done
  $ echo 4096 32000 64 128 > /proc/sys/kernel/sem
  $ ./sembench -t 2048 -w 1900 -o 0

  unpatched: run time 30 seconds 647278 worker burns per second
  patched:   run time 30 seconds 816715 worker burns per second

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110405152729.515897185@chello.nl
---
 include/linux/sched.h   |    3 +-
 init/Kconfig            |    5 ++++
 kernel/sched.c          |   56 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_features.h |    6 +++++
 4 files changed, 69 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25c5031..e09dafa 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1203,6 +1203,7 @@ struct task_struct {
 	int lock_depth;		/* BKL lock depth */
 
 #ifdef CONFIG_SMP
+	struct task_struct *wake_entry;
 	int on_cpu;
 #endif
 	int on_rq;
@@ -2192,7 +2193,7 @@ extern void set_task_comm(struct task_struct *tsk, char *from);
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
-static inline void scheduler_ipi(void) { }
+void scheduler_ipi(void);
 extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
 #else
 static inline void scheduler_ipi(void) { }
diff --git a/init/Kconfig b/init/Kconfig
index 56240e7..32745bf 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -827,6 +827,11 @@ config SCHED_AUTOGROUP
 	  desktop applications.  Task group autogeneration is currently based
 	  upon task session.
 
+config SCHED_TTWU_QUEUE
+	bool
+	depends on !SPARC32
+	default y
+
 config MM_OWNER
 	bool
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 7d8b85f..9e3ede1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -556,6 +556,10 @@ struct rq {
 	unsigned int ttwu_count;
 	unsigned int ttwu_local;
 #endif
+
+#ifdef CONFIG_SMP
+	struct task_struct *wake_list;
+#endif
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
@@ -2516,10 +2520,61 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 	return ret;
 }
 
+#ifdef CONFIG_SMP
+static void sched_ttwu_pending(void)
+{
+	struct rq *rq = this_rq();
+	struct task_struct *list = xchg(&rq->wake_list, NULL);
+
+	if (!list)
+		return;
+
+	raw_spin_lock(&rq->lock);
+
+	while (list) {
+		struct task_struct *p = list;
+		list = list->wake_entry;
+		ttwu_do_activate(rq, p, 0);
+	}
+
+	raw_spin_unlock(&rq->lock);
+}
+
+void scheduler_ipi(void)
+{
+	sched_ttwu_pending();
+}
+
+static void ttwu_queue_remote(struct task_struct *p, int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	struct task_struct *next = rq->wake_list;
+
+	for (;;) {
+		struct task_struct *old = next;
+
+		p->wake_entry = next;
+		next = cmpxchg(&rq->wake_list, old, p);
+		if (next == old)
+			break;
+	}
+
+	if (!next)
+		smp_send_reschedule(cpu);
+}
+#endif
+
 static void ttwu_queue(struct task_struct *p, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 
+#if defined(CONFIG_SMP) && defined(CONFIG_SCHED_TTWU_QUEUE)
+	if (sched_feat(TTWU_QUEUE) && cpu != smp_processor_id()) {
+		ttwu_queue_remote(p, cpu);
+		return;
+	}
+#endif
+
 	raw_spin_lock(&rq->lock);
 	ttwu_do_activate(rq, p, 0);
 	raw_spin_unlock(&rq->lock);
@@ -6331,6 +6386,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DYING:
+		sched_ttwu_pending();
 		/* Update our root-domain */
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 68e69ac..be40f73 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -64,3 +64,9 @@ SCHED_FEAT(OWNER_SPIN, 1)
  * Decrement CPU power based on irq activity
  */
 SCHED_FEAT(NONIRQ_POWER, 1)
+
+/*
+ * Queue remote wakeups on the target CPU and process them
+ * using the scheduler IPI. Reduces rq->lock contention/bounces.
+ */
+SCHED_FEAT(TTWU_QUEUE, 1)
