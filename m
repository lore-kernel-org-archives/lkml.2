Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab1DNIih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:38:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:49776 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757612Ab1DNIid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:38:33 -0400
Date: Thu, 14 Apr 2011 08:38:09 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-e4a52bcb9a18142d79e231b6733cabdbf2e67c1f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152729.354401150@chello.nl>
References: <20110405152729.354401150@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Remove rq->lock from the first half of ttwu()
Git-Commit-ID: e4a52bcb9a18142d79e231b6733cabdbf2e67c1f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:38:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4a52bcb9a18142d79e231b6733cabdbf2e67c1f
Gitweb:     http://git.kernel.org/tip/e4a52bcb9a18142d79e231b6733cabdbf2e67c1f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:54 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:39 +0200

sched: Remove rq->lock from the first half of ttwu()

Currently ttwu() does two rq->lock acquisitions, once on the task's
old rq, holding it over the p->state fiddling and load-balance pass.
Then it drops the old rq->lock to acquire the new rq->lock.

By having serialized ttwu(), p->sched_class, p->cpus_allowed with
p->pi_lock, we can now drop the whole first rq->lock acquisition.

The p->pi_lock serializing concurrent ttwu() calls protects p->state,
which we will set to TASK_WAKING to bridge possible p->pi_lock to
rq->lock gaps and serialize set_task_cpu() calls against
task_rq_lock().

The p->pi_lock serialization of p->sched_class allows us to call
scheduling class methods without holding the rq->lock, and the
serialization of p->cpus_allowed allows us to do the load-balancing
bits without races.

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110405152729.354401150@chello.nl
---
 kernel/sched.c |   65 +++++++++++++++++++++++++++++++------------------------
 1 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1be1a09..871dd9e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2493,69 +2493,78 @@ ttwu_post_activation(struct task_struct *p, struct rq *rq, int wake_flags)
  * Returns %true if @p was woken up, %false if it was already running
  * or @state didn't match @p's state.
  */
-static int try_to_wake_up(struct task_struct *p, unsigned int state,
-			  int wake_flags)
+static int
+try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 {
-	int cpu, orig_cpu, this_cpu, success = 0;
+	int cpu, this_cpu, success = 0;
 	unsigned long flags;
-	unsigned long en_flags = ENQUEUE_WAKEUP;
 	struct rq *rq;
 
 	this_cpu = get_cpu();
 
 	smp_wmb();
 	raw_spin_lock_irqsave(&p->pi_lock, flags);
-	rq = __task_rq_lock(p);
 	if (!(p->state & state))
 		goto out;
 
 	cpu = task_cpu(p);
 
-	if (p->on_rq)
-		goto out_running;
+	if (p->on_rq) {
+		rq = __task_rq_lock(p);
+		if (p->on_rq)
+			goto out_running;
+		__task_rq_unlock(rq);
+	}
 
-	orig_cpu = cpu;
 #ifdef CONFIG_SMP
-	if (unlikely(task_running(rq, p)))
-		goto out_activate;
+	while (p->on_cpu) {
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+		/*
+		 * If called from interrupt context we could have landed in the
+		 * middle of schedule(), in this case we should take care not
+		 * to spin on ->on_cpu if p is current, since that would
+		 * deadlock.
+		 */
+		if (p == current)
+			goto out_activate;
+#endif
+		cpu_relax();
+	}
+	/*
+	 * Pairs with the smp_wmb() in finish_lock_switch().
+	 */
+	smp_rmb();
 
 	p->sched_contributes_to_load = !!task_contributes_to_load(p);
 	p->state = TASK_WAKING;
 
-	if (p->sched_class->task_waking) {
+	if (p->sched_class->task_waking)
 		p->sched_class->task_waking(p);
-		en_flags |= ENQUEUE_WAKING;
-	}
 
 	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu)
-		set_task_cpu(p, cpu);
-	__task_rq_unlock(rq);
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+out_activate:
+#endif
+#endif /* CONFIG_SMP */
 
 	rq = cpu_rq(cpu);
 	raw_spin_lock(&rq->lock);
 
-	/*
-	 * We migrated the task without holding either rq->lock, however
-	 * since the task is not on the task list itself, nobody else
-	 * will try and migrate the task, hence the rq should match the
-	 * cpu we just moved it to.
-	 */
-	WARN_ON(task_cpu(p) != cpu);
-	WARN_ON(p->state != TASK_WAKING);
+#ifdef CONFIG_SMP
+	if (cpu != task_cpu(p))
+		set_task_cpu(p, cpu);
 
 	if (p->sched_contributes_to_load)
 		rq->nr_uninterruptible--;
+#endif
 
-out_activate:
-#endif /* CONFIG_SMP */
-	ttwu_activate(rq, p, en_flags);
+	ttwu_activate(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
 out_running:
 	ttwu_post_activation(p, rq, wake_flags);
 	ttwu_stat(rq, p, cpu, wake_flags);
 	success = 1;
-out:
 	__task_rq_unlock(rq);
+out:
 	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 	put_cpu();
 
