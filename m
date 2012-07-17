Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab2GQRMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:12:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55586 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab2GQRMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:12:38 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, peterz@infradead.org, tglx@linutronix.de,
        linux-pm@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/9] workqueue: drop CPU_DYING notifier operation
Date: Tue, 17 Jul 2012 10:12:22 -0700
Message-Id: <1342545149-3515-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1342545149-3515-1-git-send-email-tj@kernel.org>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueued used CPU_DYING notification to mark GCWQ_DISASSOCIATED.
This was necessary because workqueue's CPU_DOWN_PREPARE happened
before other DOWN_PREPARE notifiers and workqueue needed to stay
associated across the rest of DOWN_PREPARE.

After the previous patch, workqueue's DOWN_PREPARE happens after
others and can set GCWQ_DISASSOCIATED directly.  Drop CPU_DYING and
let the trustee set GCWQ_DISASSOCIATED after disabling concurrency
management.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   29 +++++++++++++----------------
 1 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f59b7fd..1405fb9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1250,11 +1250,11 @@ static void worker_leave_idle(struct worker *worker)
  * verbatim as it's best effort and blocking and gcwq may be
  * [dis]associated in the meantime.
  *
- * This function tries set_cpus_allowed() and locks gcwq and verifies
- * the binding against GCWQ_DISASSOCIATED which is set during
- * CPU_DYING and cleared during CPU_ONLINE, so if the worker enters
- * idle state or fetches works without dropping lock, it can guarantee
- * the scheduling requirement described in the first paragraph.
+ * This function tries set_cpus_allowed() and locks gcwq and verifies the
+ * binding against %GCWQ_DISASSOCIATED which is set during
+ * %CPU_DOWN_PREPARE and cleared during %CPU_ONLINE, so if the worker
+ * enters idle state or fetches works without dropping lock, it can
+ * guarantee the scheduling requirement described in the first paragraph.
  *
  * CONTEXT:
  * Might sleep.  Called without any lock but returns with gcwq->lock
@@ -3349,6 +3349,12 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	rc = trustee_wait_event(!gcwq_is_managing_workers(gcwq));
 	BUG_ON(rc < 0);
 
+	/*
+	 * We've claimed all manager positions.  Make all workers unbound
+	 * and set DISASSOCIATED.  Before this, all workers except for the
+	 * ones which are still executing works from before the last CPU
+	 * down must be on the cpu.  After this, they may become diasporas.
+	 */
 	for_each_worker_pool(pool, gcwq) {
 		pool->flags |= POOL_MANAGING_WORKERS;
 
@@ -3359,6 +3365,8 @@ static int __cpuinit trustee_thread(void *__gcwq)
 	for_each_busy_worker(worker, i, pos, gcwq)
 		worker->flags |= WORKER_ROGUE;
 
+	gcwq->flags |= GCWQ_DISASSOCIATED;
+
 	/*
 	 * Call schedule() so that we cross rq->lock and thus can
 	 * guarantee sched callbacks see the rogue flag.  This is
@@ -3582,16 +3590,6 @@ static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 		}
 		break;
 
-	case CPU_DYING:
-		/*
-		 * Before this, the trustee and all workers except for
-		 * the ones which are still executing works from
-		 * before the last CPU down must be on the cpu.  After
-		 * this, they'll all be diasporas.
-		 */
-		gcwq->flags |= GCWQ_DISASSOCIATED;
-		break;
-
 	case CPU_POST_DEAD:
 		gcwq->trustee_state = TRUSTEE_BUTCHER;
 		/* fall through */
@@ -3672,7 +3670,6 @@ static int __devinit workqueue_cpu_down_callback(struct notifier_block *nfb,
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
-	case CPU_DYING:
 	case CPU_POST_DEAD:
 		return workqueue_cpu_callback(nfb, action, hcpu);
 	}
-- 
1.7.7.3

