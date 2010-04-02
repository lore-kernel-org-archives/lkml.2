Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0DBTMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:12:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:38803 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144Ab0DBTMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:12:17 -0400
Date: Fri, 2 Apr 2010 19:12:00 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
       mingo@elte.hu
In-Reply-To: <20100315091010.GA9131@redhat.com>
References: <20100315091010.GA9131@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: move_task_off_dead_cpu(): Take rq->lock around select_fallback_rq()
Message-ID: <tip-1445c08d06c5594895b4fae952ef8a457e89c390@git.kernel.org>
Git-Commit-ID: 1445c08d06c5594895b4fae952ef8a457e89c390
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:12:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1445c08d06c5594895b4fae952ef8a457e89c390
Gitweb:     http://git.kernel.org/tip/1445c08d06c5594895b4fae952ef8a457e89c390
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Mon, 15 Mar 2010 10:10:10 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 20:12:01 +0200

sched: move_task_off_dead_cpu(): Take rq->lock around select_fallback_rq()

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
---
 kernel/sched.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index c0b3ebc..27774b5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5448,29 +5448,29 @@ static int migration_thread(void *data)
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
 
