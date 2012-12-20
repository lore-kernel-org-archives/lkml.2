Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab2LTGP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:15:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:12653 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab2LTGPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:15:47 -0500
X-IronPort-AV: E=Sophos;i="4.84,322,1355068800"; 
   d="scan'208";a="6438608"
From: liguang <lig.fnst@cn.fujitsu.com>
To: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH] sched: correct some annotations
Date: Thu, 20 Dec 2012 14:12:44 +0800
Message-Id: <1355983964-21523-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/20 14:14:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/20 14:14:43,
	Serialize complete at 2012/12/20 14:14:43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 include/linux/sched.h |    6 +++---
 kernel/sched/fair.c   |   16 ++++++----------
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ce834e7..57b31f9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -84,9 +84,9 @@ extern void get_avenrun(unsigned long *loads, unsigned long offset, int shift);
 #define FSHIFT		11		/* nr of bits of precision */
 #define FIXED_1		(1<<FSHIFT)	/* 1.0 as fixed-point */
 #define LOAD_FREQ	(5*HZ+1)	/* 5 sec intervals */
-#define EXP_1		1884		/* 1/exp(5sec/1min) as fixed-point */
-#define EXP_5		2014		/* 1/exp(5sec/5min) */
-#define EXP_15		2037		/* 1/exp(5sec/15min) */
+#define EXP_1		1884		/* 1/exp^(5sec/1min) as fixed-point */
+#define EXP_5		2014		/* 1/exp^(5sec/5min) */
+#define EXP_15		2037		/* 1/exp^(5sec/15min) */
 
 #define CALC_LOAD(load,exp,n) \
 	load *= exp; \
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index eaff006..fecdb02 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4850,15 +4850,11 @@ static bool numa_allow_migration(struct task_struct *p, int prev_cpu, int new_cp
 
 
 /*
- * sched_balance_self: balance the current task (running on cpu) in domains
- * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
- * SD_BALANCE_EXEC.
+ * select_task_rq_fair: select a proper cpu for current task to run on.
  *
- * Balance, ie. select the least loaded group.
+ * Return the target CPU number.
  *
- * Returns the target CPU number, or the same CPU if no balancing is needed.
- *
- * preempt must be disabled.
+ * Note: preempt must be disabled.
  */
 static int
 select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
@@ -4933,12 +4929,12 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 
 		new_cpu = find_idlest_cpu(group, p, cpu);
 		if (new_cpu == -1 || new_cpu == cpu) {
-			/* Now try balancing at a lower domain level of cpu */
+			/* Now try a lower domain level of cpu */
 			sd = sd->child;
 			continue;
 		}
 
-		/* Now try balancing at a lower domain level of new_cpu */
+		/* Now try a upper domain level of new_cpu */
 		cpu = new_cpu;
 		weight = sd->span_weight;
 		sd = NULL;
@@ -5149,7 +5145,7 @@ preempt:
 	 * point, either of which can * drop the rq lock.
 	 *
 	 * Also, during early boot the idle thread is in the fair class,
-	 * for obvious reasons its a bad idea to schedule back to it.
+	 * for obvious reasons it's a bad idea to schedule back to it.
 	 */
 	if (unlikely(!se->on_rq || curr == rq->idle))
 		return;
-- 
1.7.2.5

