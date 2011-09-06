Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab1IFTAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 15:00:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:50722 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab1IFTAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:00:40 -0400
Date: Tue, 6 Sep 2011 21:00:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, mingo@tglx.de,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] scheduler fixes for 3.1
Message-ID: <alpine.LFD.2.02.1109062059450.2723@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://tesla.tglx.de/git/linux-2.6-tip.git sched-fixes-for-linus

Thanks,

	tglx

------------------>
Thomas Gleixner (2):
      sched: Separate the scheduler entry for preemption
      sched: Move blk_schedule_flush_plug() out of __schedule()

WANG Cong (1):
      sched: Fix a memory leak in __sdt_free()


 kernel/sched.c |   41 ++++++++++++++++++++++++++---------------
 1 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ccacdbd..c79e7c6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4279,9 +4279,9 @@ pick_next_task(struct rq *rq)
 }
 
 /*
- * schedule() is the main scheduler function.
+ * __schedule() is the main scheduler function.
  */
-asmlinkage void __sched schedule(void)
+static void __sched __schedule(void)
 {
 	struct task_struct *prev, *next;
 	unsigned long *switch_count;
@@ -4322,16 +4322,6 @@ need_resched:
 				if (to_wakeup)
 					try_to_wake_up_local(to_wakeup);
 			}
-
-			/*
-			 * If we are going to sleep and we have plugged IO
-			 * queued, make sure to submit it to avoid deadlocks.
-			 */
-			if (blk_needs_flush_plug(prev)) {
-				raw_spin_unlock(&rq->lock);
-				blk_schedule_flush_plug(prev);
-				raw_spin_lock(&rq->lock);
-			}
 		}
 		switch_count = &prev->nvcsw;
 	}
@@ -4369,6 +4359,26 @@ need_resched:
 	if (need_resched())
 		goto need_resched;
 }
+
+static inline void sched_submit_work(struct task_struct *tsk)
+{
+	if (!tsk->state)
+		return;
+	/*
+	 * If we are going to sleep and we have plugged IO queued,
+	 * make sure to submit it to avoid deadlocks.
+	 */
+	if (blk_needs_flush_plug(tsk))
+		blk_schedule_flush_plug(tsk);
+}
+
+asmlinkage void schedule(void)
+{
+	struct task_struct *tsk = current;
+
+	sched_submit_work(tsk);
+	__schedule();
+}
 EXPORT_SYMBOL(schedule);
 
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
@@ -4435,7 +4445,7 @@ asmlinkage void __sched notrace preempt_schedule(void)
 
 	do {
 		add_preempt_count_notrace(PREEMPT_ACTIVE);
-		schedule();
+		__schedule();
 		sub_preempt_count_notrace(PREEMPT_ACTIVE);
 
 		/*
@@ -4463,7 +4473,7 @@ asmlinkage void __sched preempt_schedule_irq(void)
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
 		local_irq_enable();
-		schedule();
+		__schedule();
 		local_irq_disable();
 		sub_preempt_count(PREEMPT_ACTIVE);
 
@@ -5588,7 +5598,7 @@ static inline int should_resched(void)
 static void __cond_resched(void)
 {
 	add_preempt_count(PREEMPT_ACTIVE);
-	schedule();
+	__schedule();
 	sub_preempt_count(PREEMPT_ACTIVE);
 }
 
@@ -7443,6 +7453,7 @@ static void __sdt_free(const struct cpumask *cpu_map)
 			struct sched_domain *sd = *per_cpu_ptr(sdd->sd, j);
 			if (sd && (sd->flags & SD_OVERLAP))
 				free_sched_groups(sd->groups, 0);
+			kfree(*per_cpu_ptr(sdd->sd, j));
 			kfree(*per_cpu_ptr(sdd->sg, j));
 			kfree(*per_cpu_ptr(sdd->sgp, j));
 		}
