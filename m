Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948Ab0EDMji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:39:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:51781 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab0EDMjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:39:18 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/12] sched: add switch_in and tick tracepoints
Date: Tue,  4 May 2010 14:38:40 +0200
Message-Id: <1272976724-14312-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1272976724-14312-1-git-send-email-tj@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 12:38:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define and add sched_switch_in and sched_tick tracepoints.  Both are
colocated with perf event functions.  These will be used to make perf
use tracepoints.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/trace/events/sched.h |   14 ++++++++++++++
 kernel/sched.c               |    4 ++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index cfceb0b..2bed8de 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -220,6 +220,20 @@ DECLARE_EVENT_CLASS(sched_process_template,
 );
 
 /*
+ * Tracepoint for task switch in:
+ */
+DEFINE_EVENT(sched_process_template, sched_switch_in,
+	     TP_PROTO(struct task_struct *p),
+	     TP_ARGS(p));
+
+/*
+ * Tracepoint for scheduler tick:
+ */
+DEFINE_EVENT(sched_process_template, sched_tick,
+	     TP_PROTO(struct task_struct *p),
+	     TP_ARGS(p));
+
+/*
  * Tracepoint for freeing a task:
  */
 DEFINE_EVENT(sched_process_template, sched_process_free,
diff --git a/kernel/sched.c b/kernel/sched.c
index 1acec30..f70f9d7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2827,7 +2827,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	finish_arch_switch(prev);
 	finish_lock_switch(rq, prev);
 
-	SCHED_EVENT(NONE, sched_in, in, SE_ARGS(current));
+	SCHED_EVENT(switch_in, sched_in, in, SE_ARGS(current));
 	if (mm)
 		mmdrop(mm);
 	if (unlikely(prev_state == TASK_DEAD)) {
@@ -3529,7 +3529,7 @@ void scheduler_tick(void)
 	curr->sched_class->task_tick(rq, curr, 0);
 	raw_spin_unlock(&rq->lock);
 
-	SCHED_EVENT(NONE, tick, NONE, SE_ARGS(curr));
+	SCHED_EVENT(tick, tick, NONE, SE_ARGS(curr));
 
 #ifdef CONFIG_SMP
 	rq->idle_at_tick = idle_cpu(cpu);
-- 
1.6.4.2

