Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab1EFVFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:05:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:33070 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536Ab1EFVFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:05:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,328,1301900400"; 
   d="scan'208";a="639164489"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, arnd@arndb.de, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/4] SCHED: Remove BKL accounting from schedstats
Date: Fri,  6 May 2011 14:05:26 -0700
Message-Id: <1304715928-19266-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1304715928-19266-1-git-send-email-andi@firstfloor.org>
References: <1304715928-19266-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Remove the BKL accounting from schedstats.

I removed the field from the debug file too, in theory
it could be kept as 0 for compatibility.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/sched.h |    4 ----
 kernel/sched.c        |    6 ------
 kernel/sched_debug.c  |    3 ---
 3 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 18d63ce..53373bc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -731,10 +731,6 @@ struct sched_info {
 	/* timestamps */
 	unsigned long long last_arrival,/* when we last ran on a cpu */
 			   last_queued;	/* when we were last queued to run */
-#ifdef CONFIG_SCHEDSTATS
-	/* BKL stats */
-	unsigned int bkl_count;
-#endif
 };
 #endif /* defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT) */
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 312f8b9..7fa5334 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4025,12 +4025,6 @@ static inline void schedule_debug(struct task_struct *prev)
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
 
 	schedstat_inc(this_rq(), sched_count);
-#ifdef CONFIG_SCHEDSTATS
-	if (unlikely(prev->lock_depth >= 0)) {
-		schedstat_inc(this_rq(), rq_sched_info.bkl_count);
-		schedstat_inc(prev, sched_info.bkl_count);
-	}
-#endif
 }
 
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 7bacd83..a14e399 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -296,9 +296,6 @@ static void print_cpu(struct seq_file *m, int cpu)
 	P(ttwu_count);
 	P(ttwu_local);
 
-	SEQ_printf(m, "  .%-30s: %d\n", "bkl_count",
-				rq->rq_sched_info.bkl_count);
-
 #undef P
 #undef P64
 #endif
-- 
1.7.4.4

