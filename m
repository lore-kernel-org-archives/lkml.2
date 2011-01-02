Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab1ABH5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:57:37 -0500
Received: from mail.windriver.com ([147.11.1.11]:35299 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab1ABHXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:07 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 089/260] sched: Optimize task_rq_lock()
Date: Sun,  2 Jan 2011 02:16:25 -0500
Message-Id: <1293952756-15010-90-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:47.0680 (UTC) FILETIME=[B76D7A00:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 65cc8e4859ff29a9ddc989c88557d6059834c2a2 upstream.

Now that we hold the rq->lock over set_task_cpu() again, we can do
away with most of the TASK_WAKING checks and reduce them again to
set_cpus_allowed_ptr().

Removes some conditionals from scheduling hot-paths.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sched.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 31b0bae..e542c1e 100644
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
@@ -5341,7 +5337,18 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
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
-- 
1.7.3.3

