Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab0DBTOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:14:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:46704 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286Ab0DBTOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:14:07 -0400
Date: Fri, 2 Apr 2010 19:13:41 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Optimize task_rq_lock()
Message-ID: <tip-65cc8e4859ff29a9ddc989c88557d6059834c2a2@git.kernel.org>
Git-Commit-ID: 65cc8e4859ff29a9ddc989c88557d6059834c2a2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:13:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  65cc8e4859ff29a9ddc989c88557d6059834c2a2
Gitweb:     http://git.kernel.org/tip/65cc8e4859ff29a9ddc989c88557d6059834c2a2
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 25 Mar 2010 21:05:16 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 20:12:04 +0200

sched: Optimize task_rq_lock()

Now that we hold the rq->lock over set_task_cpu() again, we can do
away with most of the TASK_WAKING checks and reduce them again to
set_cpus_allowed_ptr().

Removes some conditionals from scheduling hot-paths.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dcd1773..51d336e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -914,8 +914,8 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 #endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 
 /*
- * Check whether the task is waking, we use this to synchronize against
- * ttwu() so that task_cpu() reports a stable number.
+ * Check whether the task is waking, we use this to synchronize ->cpus_allowed
+ * against ttwu().
  */
 static inline int task_is_waking(struct task_struct *p)
 {
@@ -932,11 +932,9 @@ static inline struct rq *__task_rq_lock(struct task_struct *p)
 	struct rq *rq;
 
 	for (;;) {
-		while (task_is_waking(p))
-			cpu_relax();
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p) && !task_is_waking(p)))
+		if (likely(rq == task_rq(p)))
 			return rq;
 		raw_spin_unlock(&rq->lock);
 	}
@@ -953,12 +951,10 @@ static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
 	struct rq *rq;
 
 	for (;;) {
-		while (task_is_waking(p))
-			cpu_relax();
 		local_irq_save(*flags);
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
-		if (likely(rq == task_rq(p) && !task_is_waking(p)))
+		if (likely(rq == task_rq(p)))
 			return rq;
 		raw_spin_unlock_irqrestore(&rq->lock, *flags);
 	}
@@ -5262,7 +5258,18 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 	struct rq *rq;
 	int ret = 0;
 
+	/*
+	 * Serialize against TASK_WAKING so that ttwu() and wunt() can
+	 * drop the rq->lock and still rely on ->cpus_allowed.
+	 */
+again:
+	while (task_is_waking(p))
+		cpu_relax();
 	rq = task_rq_lock(p, &flags);
+	if (task_is_waking(p)) {
+		task_rq_unlock(rq, &flags);
+		goto again;
+	}
 
 	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
 		ret = -EINVAL;
