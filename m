Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1ANH6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 02:58:00 -0500
Received: from mail.windriver.com ([147.11.1.11]:37088 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1ANH5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 02:57:55 -0500
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: replace rq->bkl_count with rq->rq_sched_info.bkl_count
Date: Fri, 14 Jan 2011 15:57:39 +0800
Message-Id: <1294991859-13246-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 14 Jan 2011 07:57:41.0311 (UTC) FILETIME=[B80C7CF0:01CBB3C0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now rq->rq_sched_info.bkl_count is not used for rq, scroll
rq->bkl_count into it. Thus we can save some space for rq.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched.c       |    5 +----
 kernel/sched_debug.c |    4 +++-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ea3e5ef..3d6df21 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -553,9 +553,6 @@ struct rq {
 	/* try_to_wake_up() stats */
 	unsigned int ttwu_count;
 	unsigned int ttwu_local;
-
-	/* BKL stats */
-	unsigned int bkl_count;
 #endif
 };
 
@@ -3887,7 +3884,7 @@ static inline void schedule_debug(struct task_struct *prev)
 	schedstat_inc(this_rq(), sched_count);
 #ifdef CONFIG_SCHEDSTATS
 	if (unlikely(prev->lock_depth >= 0)) {
-		schedstat_inc(this_rq(), bkl_count);
+		schedstat_inc(this_rq(), rq_sched_info.bkl_count);
 		schedstat_inc(prev, sched_info.bkl_count);
 	}
 #endif
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 1dfae3d..8ee0aa7 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -262,9 +262,11 @@ static void print_cpu(struct seq_file *m, int cpu)
 	P(ttwu_count);
 	P(ttwu_local);
 
-	P(bkl_count);
+	SEQ_printf(m, "  .%-30s: %d\n", "bkl_count",
+				rq->rq_sched_info.bkl_count);
 
 #undef P
+#undef P64
 #endif
 	print_cfs_stats(m, cpu);
 	print_rt_stats(m, cpu);
-- 
1.7.0.4

