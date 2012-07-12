Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646Ab2GLKOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:14:36 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:34371 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271Ab2GLKOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:14:35 -0400
From: Andrew Vagin <avagin@openvz.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Arun Sharma <asharma@fb.com>
Subject: [PATCH] sched: deliver sched_switch events to a current task
Date: Thu, 12 Jul 2012 14:14:29 +0400
Message-Id: <1342088069-1005148-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise they can't be filtered for a defined task.

perf record -e sched:sched_switch ./foo

This command doesn't report any event without this patch.

I think it isn't a big problem for security, if someone will know
who will be executed next. By default perf is disabled for non-root
users.

I need this events for profiling sleep times.  sched_switch is used for
getting callchains and sched_stat_* is used for getting time periods.
This events are combined in user space, then it can be analized by
perf tools.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Arun Sharma <asharma@fb.com>
Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 kernel/sched/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d5594a4..c5d6a0f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1910,12 +1910,12 @@ static inline void
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
+	trace_sched_switch(prev, next);
 	sched_info_switch(prev, next);
 	perf_event_task_sched_out(prev, next);
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
-	trace_sched_switch(prev, next);
 }
 
 /**
-- 
1.7.1

