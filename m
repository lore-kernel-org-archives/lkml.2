Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437Ab1DNIf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:35:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:49589 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757609Ab1DNIfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:35:22 -0400
Date: Thu, 14 Apr 2011 08:34:11 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-013fdb8086acaae5f8eb96f9ad48fcd98882ac46@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152728.990364093@chello.nl>
References: <20110405152728.990364093@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Serialize p->cpus_allowed and ttwu() using p->pi_lock
Git-Commit-ID: 013fdb8086acaae5f8eb96f9ad48fcd98882ac46
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:34:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  013fdb8086acaae5f8eb96f9ad48fcd98882ac46
Gitweb:     http://git.kernel.org/tip/013fdb8086acaae5f8eb96f9ad48fcd98882ac46
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:45 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:35 +0200

sched: Serialize p->cpus_allowed and ttwu() using p->pi_lock

Currently p->pi_lock already serializes p->sched_class, also put
p->cpus_allowed and try_to_wake_up() under it, this prepares the way
to do the first part of ttwu() without holding rq->lock.

By having p->sched_class and p->cpus_allowed serialized by p->pi_lock,
we prepare the way to call select_task_rq() without holding rq->lock.

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110405152728.990364093@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   37 ++++++++++++++++---------------------
 1 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dece28e..d398f2f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2340,7 +2340,7 @@ EXPORT_SYMBOL_GPL(kick_process);
 
 #ifdef CONFIG_SMP
 /*
- * ->cpus_allowed is protected by either TASK_WAKING or rq->lock held.
+ * ->cpus_allowed is protected by both rq->lock and p->pi_lock
  */
 static int select_fallback_rq(int cpu, struct task_struct *p)
 {
@@ -2373,7 +2373,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 }
 
 /*
- * The caller (fork, wakeup) owns TASK_WAKING, ->cpus_allowed is stable.
+ * The caller (fork, wakeup) owns p->pi_lock, ->cpus_allowed is stable.
  */
 static inline
 int select_task_rq(struct rq *rq, struct task_struct *p, int sd_flags, int wake_flags)
@@ -2499,7 +2499,8 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 	this_cpu = get_cpu();
 
 	smp_wmb();
-	rq = task_rq_lock(p, &flags);
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
+	rq = __task_rq_lock(p);
 	if (!(p->state & state))
 		goto out;
 
@@ -2557,7 +2558,8 @@ out_running:
 	ttwu_stat(rq, p, cpu, wake_flags);
 	success = 1;
 out:
-	task_rq_unlock(rq, &flags);
+	__task_rq_unlock(rq);
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 	put_cpu();
 
 	return success;
@@ -4694,6 +4696,8 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
+	lockdep_assert_held(&p->pi_lock);
+
 	rq = task_rq_lock(p, &flags);
 
 	trace_sched_pi_setprio(p, prio);
@@ -5317,7 +5321,6 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
 {
 	struct task_struct *p;
 	unsigned long flags;
-	struct rq *rq;
 	int retval;
 
 	get_online_cpus();
@@ -5332,9 +5335,9 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
 	if (retval)
 		goto out_unlock;
 
-	rq = task_rq_lock(p, &flags);
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	cpumask_and(mask, &p->cpus_allowed, cpu_online_mask);
-	task_rq_unlock(rq, &flags);
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
 out_unlock:
 	rcu_read_unlock();
@@ -5882,18 +5885,8 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 	unsigned int dest_cpu;
 	int ret = 0;
 
-	/*
-	 * Serialize against TASK_WAKING so that ttwu() and wunt() can
-	 * drop the rq->lock and still rely on ->cpus_allowed.
-	 */
-again:
-	while (task_is_waking(p))
-		cpu_relax();
-	rq = task_rq_lock(p, &flags);
-	if (task_is_waking(p)) {
-		task_rq_unlock(rq, &flags);
-		goto again;
-	}
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
+	rq = __task_rq_lock(p);
 
 	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
 		ret = -EINVAL;
@@ -5921,13 +5914,15 @@ again:
 	if (migrate_task(p, rq)) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
-		task_rq_unlock(rq, &flags);
+		__task_rq_unlock(rq);
+		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
 		tlb_migrate_finish(p->mm);
 		return 0;
 	}
 out:
-	task_rq_unlock(rq, &flags);
+	__task_rq_unlock(rq);
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
 	return ret;
 }
