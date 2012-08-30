Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab2H3TEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 15:04:08 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:37500 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2H3TEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 15:04:04 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: [PATCH tip/core/rcu 3/3] sched: Fix load avg vs cpu-hotplug
Date: Thu, 30 Aug 2012 12:03:03 -0700
Message-Id: <1346353383-350-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346353383-350-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830190245.GA32625@linux.vnet.ibm.com>
 <1346353383-350-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083019-5518-0000-0000-0000073A0F43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Rabik and Paul reported two different issues related to the same few
lines of code.

Rabik's issue is that the nr_uninterruptible migration code is wrong in
that he sees artifacts due to this (Rabik please do expand in more
detail).

Paul's issue is that this code as it stands relies on us using
stop_machine() for unplug, we all would like to remove this assumption
so that eventually we can remove this stop_machine() usage altogether.

The only reason we'd have to migrate nr_uninterruptible is so that we
could use for_each_online_cpu() loops in favour of
for_each_possible_cpu() loops, however since nr_uninterruptible() is the
only such loop and its using possible lets not bother at all.

The problem Rabik sees is (probably) caused by the fact that by
migrating nr_uninterruptible we screw rq->calc_load_active for both rqs
involved.

So don't bother with fancy migration schemes (meaning we now have to
keep using for_each_possible_cpu()) and instead fold any nr_active delta
after we migrate all tasks away to make sure we don't have any skewed
nr_active accounting.

[ paulmck: Move call to calc_load_migration to CPU_DEAD to avoid
miscounting noted by Rakib. ]

Reported-by: Rakib Mullick <rakib.mullick@gmail.com>
Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
---
 kernel/sched/core.c |   41 ++++++++++++++++++++---------------------
 1 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d325c4b..06051e0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5300,27 +5300,17 @@ void idle_task_exit(void)
 }
 
 /*
- * While a dead CPU has no uninterruptible tasks queued at this point,
- * it might still have a nonzero ->nr_uninterruptible counter, because
- * for performance reasons the counter is not stricly tracking tasks to
- * their home CPUs. So we just add the counter to another CPU's counter,
- * to keep the global sum constant after CPU-down:
- */
-static void migrate_nr_uninterruptible(struct rq *rq_src)
-{
-	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
-
-	rq_dest->nr_uninterruptible += rq_src->nr_uninterruptible;
-	rq_src->nr_uninterruptible = 0;
-}
-
-/*
- * remove the tasks which were accounted by rq from calc_load_tasks.
+ * Since this CPU is going 'away' for a while, fold any nr_active delta
+ * we might have. Assumes we're called after migrate_tasks() so that the
+ * nr_active count is stable.
+ *
+ * Also see the comment "Global load-average calculations".
  */
-static void calc_global_load_remove(struct rq *rq)
+static void calc_load_migrate(struct rq *rq)
 {
-	atomic_long_sub(rq->calc_load_active, &calc_load_tasks);
-	rq->calc_load_active = 0;
+	long delta = calc_load_fold_active(rq);
+	if (delta)
+		atomic_long_add(delta, &calc_load_tasks);
 }
 
 /*
@@ -5613,9 +5603,18 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		migrate_tasks(cpu);
 		BUG_ON(rq->nr_running != 1); /* the migration thread */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
+		break;
 
-		migrate_nr_uninterruptible(rq);
-		calc_global_load_remove(rq);
+	case CPU_DEAD:
+		{
+			struct rq *dest_rq;
+
+			local_irq_save(flags);
+			dest_rq = cpu_rq(smp_processor_id());
+			raw_spin_lock(&dest_rq->lock);
+			calc_load_migrate(rq);
+			raw_spin_unlock_irqrestore(&dest_rq->lock, flags);
+		}
 		break;
 #endif
 	}
-- 
1.7.8

