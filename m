Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab1DNIj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:39:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:42372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758592Ab1DNIjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:39:52 -0400
Date: Thu, 14 Apr 2011 08:39:28 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-c05fbafba1c5482bee399b360288fa405415e126@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152729.475848012@chello.nl>
References: <20110405152729.475848012@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Restructure ttwu() some more
Git-Commit-ID: c05fbafba1c5482bee399b360288fa405415e126
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:39:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c05fbafba1c5482bee399b360288fa405415e126
Gitweb:     http://git.kernel.org/tip/c05fbafba1c5482bee399b360288fa405415e126
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:40 +0200

sched: Restructure ttwu() some more

Factor our helper functions to make the inner workings of try_to_wake_up()
more obvious, this also allows for adding remote queues.

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110405152729.475848012@chello.nl
---
 kernel/sched.c |   91 +++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 58 insertions(+), 33 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e309dba..7d8b85f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2483,6 +2483,48 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 #endif
 }
 
+static void
+ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags)
+{
+#ifdef CONFIG_SMP
+	if (p->sched_contributes_to_load)
+		rq->nr_uninterruptible--;
+#endif
+
+	ttwu_activate(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
+	ttwu_do_wakeup(rq, p, wake_flags);
+}
+
+/*
+ * Called in case the task @p isn't fully descheduled from its runqueue,
+ * in this case we must do a remote wakeup. Its a 'light' wakeup though,
+ * since all we need to do is flip p->state to TASK_RUNNING, since
+ * the task is still ->on_rq.
+ */
+static int ttwu_remote(struct task_struct *p, int wake_flags)
+{
+	struct rq *rq;
+	int ret = 0;
+
+	rq = __task_rq_lock(p);
+	if (p->on_rq) {
+		ttwu_do_wakeup(rq, p, wake_flags);
+		ret = 1;
+	}
+	__task_rq_unlock(rq);
+
+	return ret;
+}
+
+static void ttwu_queue(struct task_struct *p, int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	raw_spin_lock(&rq->lock);
+	ttwu_do_activate(rq, p, 0);
+	raw_spin_unlock(&rq->lock);
+}
+
 /**
  * try_to_wake_up - wake up a thread
  * @p: the thread to be awakened
@@ -2501,27 +2543,25 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 static int
 try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 {
-	int cpu, this_cpu, success = 0;
 	unsigned long flags;
-	struct rq *rq;
-
-	this_cpu = get_cpu();
+	int cpu, success = 0;
 
 	smp_wmb();
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	if (!(p->state & state))
 		goto out;
 
+	success = 1; /* we're going to change ->state */
 	cpu = task_cpu(p);
 
-	if (p->on_rq) {
-		rq = __task_rq_lock(p);
-		if (p->on_rq)
-			goto out_running;
-		__task_rq_unlock(rq);
-	}
+	if (p->on_rq && ttwu_remote(p, wake_flags))
+		goto stat;
 
 #ifdef CONFIG_SMP
+	/*
+	 * If the owning (remote) cpu is still in the middle of schedule() with
+	 * this task as prev, wait until its done referencing the task.
+	 */
 	while (p->on_cpu) {
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 		/*
@@ -2530,8 +2570,10 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 		 * to spin on ->on_cpu if p is current, since that would
 		 * deadlock.
 		 */
-		if (p == current)
-			goto out_activate;
+		if (p == current) {
+			ttwu_queue(p, cpu);
+			goto stat;
+		}
 #endif
 		cpu_relax();
 	}
@@ -2547,32 +2589,15 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 		p->sched_class->task_waking(p);
 
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
-out_activate:
-#endif
-#endif /* CONFIG_SMP */
-
-	rq = cpu_rq(cpu);
-	raw_spin_lock(&rq->lock);
-
-#ifdef CONFIG_SMP
-	if (cpu != task_cpu(p))
+	if (task_cpu(p) != cpu)
 		set_task_cpu(p, cpu);
+#endif /* CONFIG_SMP */
 
-	if (p->sched_contributes_to_load)
-		rq->nr_uninterruptible--;
-#endif
-
-	ttwu_activate(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
-out_running:
-	ttwu_do_wakeup(rq, p, wake_flags);
-	success = 1;
-	__task_rq_unlock(rq);
-
+	ttwu_queue(p, cpu);
+stat:
 	ttwu_stat(p, cpu, wake_flags);
 out:
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
-	put_cpu();
 
 	return success;
 }
