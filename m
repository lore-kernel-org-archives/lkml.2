Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab2ATCUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 21:20:33 -0500
Received: from intmgw001.ash2.facebook.com ([66.220.155.178]:61913 "EHLO
	intmgw003.ash2.facebook.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757179Ab2ATCU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 21:20:26 -0500
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] trace: reset sleep/block start time on task switch
Date: Thu, 19 Jan 2012 18:20:20 -0800
Message-Id: <1327026020-32376-1-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, the first sample we get on a
task might be bad because of a stale sleep_start
value that wasn't reset at the last task switch
because the tracepoint was not active.

The problem can be worked around via perf record
--filter "sleeptime < some-large-number" in practice
and it's not clear if the added code to the context
switch path is worth it.

I'm posting this patch regardless, just in case
more people start noticing this and start wondering
where the bogus numbers came from.

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
---
 include/trace/events/sched.h |    3 ---
 kernel/sched/core.c          |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 6ba596b..814cdf1 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -378,9 +378,6 @@ static inline u64 trace_get_sleeptime(struct task_struct *tsk)
 
 	block = tsk->se.statistics.block_start;
 	sleep = tsk->se.statistics.sleep_start;
-	tsk->se.statistics.block_start = 0;
-	tsk->se.statistics.sleep_start = 0;
-
 	return block ? block : sleep ? sleep : 0;
 #else
 	return 0;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 457c881..6349cee 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1937,7 +1937,10 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	local_irq_enable();
 #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
 	finish_lock_switch(rq, prev);
+
 	trace_sched_stat_sleeptime(current, rq->clock);
+	current->se.statistics.block_start = 0;
+	current->se.statistics.sleep_start = 0;
 
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)
-- 
1.7.4

