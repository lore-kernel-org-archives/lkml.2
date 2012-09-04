Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab2IDSoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 14:44:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47790 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab2IDSoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 14:44:32 -0400
Date: Tue, 4 Sep 2012 11:43:51 -0700
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-f319da0c6894fcf55e21320e40506418a2aad629@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rakib.mullick@gmail.com, a.p.zijlstra@chello.nl, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: paulmck@linux.vnet.ibm.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, rakib.mullick@gmail.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1345454817.23018.27.camel@twins>
References: <1345454817.23018.27.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix load avg vs cpu-hotplug
Git-Commit-ID: f319da0c6894fcf55e21320e40506418a2aad629
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 04 Sep 2012 11:43:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f319da0c6894fcf55e21320e40506418a2aad629
Gitweb:     http://git.kernel.org/tip/f319da0c6894fcf55e21320e40506418a2aad629
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 20 Aug 2012 11:26:57 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Sep 2012 14:30:18 +0200

sched: Fix load avg vs cpu-hotplug

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

Reported-by: Rakib Mullick <rakib.mullick@gmail.com>
Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1345454817.23018.27.camel@twins
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |   31 ++++++++++---------------------
 1 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fbf1fd0..207a81c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5304,27 +5304,17 @@ void idle_task_exit(void)
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
@@ -5618,8 +5608,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		BUG_ON(rq->nr_running != 1); /* the migration thread */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
 
-		migrate_nr_uninterruptible(rq);
-		calc_global_load_remove(rq);
+		calc_load_migrate(rq);
 		break;
 #endif
 	}
