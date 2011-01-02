Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab1ABIAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:00:24 -0500
Received: from mail.windriver.com ([147.11.1.11]:35178 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab1ABHW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:56 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 083/260] sched: move_task_off_dead_cpu(): Take rq->lock around select_fallback_rq()
Date: Sun,  2 Jan 2011 02:16:19 -0500
Message-Id: <1293952756-15010-84-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:40.0461 (UTC) FILETIME=[B31FF1D0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit 1445c08d06c5594895b4fae952ef8a457e89c390 upstream.

move_task_off_dead_cpu()->select_fallback_rq() reads/updates ->cpus_allowed
lockless. We can race with set_cpus_allowed() running in parallel.

Change it to take rq->lock around select_fallback_rq(). Note that it is not
trivial to move this spin_lock() into select_fallback_rq(), we must recheck
the task was not migrated after we take the lock and other callers do not
need this lock.

To avoid the races with other callers of select_fallback_rq() which rely on
TASK_WAKING, we also check p->state != TASK_WAKING and do nothing otherwise.
The owner of TASK_WAKING must update ->cpus_allowed and choose the correct
CPU anyway, and the subsequent __migrate_task() is just meaningless because
p->se.on_rq must be false.

Alternatively, we could change select_task_rq() to take rq->lock right
after it calls sched_class->select_task_rq(), but this looks a bit ugly.

Also, change it to not assume irqs are disabled and absorb __migrate_task_irq().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100315091010.GA9131@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sched.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 489d985..743af02 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5527,29 +5527,29 @@ static int migration_thread(void *data)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-
-static int __migrate_task_irq(struct task_struct *p, int src_cpu, int dest_cpu)
-{
-	int ret;
-
-	local_irq_disable();
-	ret = __migrate_task(p, src_cpu, dest_cpu);
-	local_irq_enable();
-	return ret;
-}
-
 /*
  * Figure out where task on dead CPU should go, use force if necessary.
  */
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
-	int dest_cpu;
-
+	struct rq *rq = cpu_rq(dead_cpu);
+	int needs_cpu, uninitialized_var(dest_cpu);
+	unsigned long flags;
 again:
-	dest_cpu = select_fallback_rq(dead_cpu, p);
+	local_irq_save(flags);
+
+	raw_spin_lock(&rq->lock);
+	needs_cpu = (task_cpu(p) == dead_cpu) && (p->state != TASK_WAKING);
+	if (needs_cpu)
+		dest_cpu = select_fallback_rq(dead_cpu, p);
+	raw_spin_unlock(&rq->lock);
 
 	/* It can have affinity changed while we were choosing. */
-	if (unlikely(!__migrate_task_irq(p, dead_cpu, dest_cpu)))
+	if (needs_cpu)
+		needs_cpu = !__migrate_task(p, dead_cpu, dest_cpu);
+	local_irq_restore(flags);
+
+	if (unlikely(needs_cpu))
 		goto again;
 }
 
-- 
1.7.3.3

