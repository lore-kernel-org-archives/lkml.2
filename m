Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab2FDIKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 04:10:32 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:12569 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab2FDIKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 04:10:13 -0400
From: Andrew Vagin <avagin@openvz.org>
Cc: Arun Sharma <asharma@fb.com>, Oleg Strikov <OSTRIKOV@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] sched: send the event sched_switch before perf_event_task_sched_out
Date: Mon,  4 Jun 2012 12:09:39 +0400
Message-Id: <1338797382-287275-3-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1338797382-287275-1-git-send-email-avagin@openvz.org>
References: <1338797382-287275-1-git-send-email-avagin@openvz.org>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwice they can't be filtered for a defined task.

perf record -e sched:sched_switch ./foo

This command doesn't report any event without this patch.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 kernel/sched/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 39eb601..e17a3ec 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1911,12 +1911,12 @@ static inline void
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
@@ -1976,6 +1976,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 		kprobe_flush_task(prev);
 		put_task_struct(prev);
 	}
+	trace_sched_switch_finish(current);
 }
 
 #ifdef CONFIG_SMP
-- 
1.7.1

