Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab2FDIKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 04:10:30 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:35373 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab2FDIKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 04:10:13 -0400
From: Andrew Vagin <avagin@openvz.org>
Cc: Arun Sharma <asharma@fb.com>, Oleg Strikov <OSTRIKOV@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] sched: save a previous state on task_struct
Date: Mon,  4 Jun 2012 12:09:40 +0400
Message-Id: <1338797382-287275-4-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1338797382-287275-1-git-send-email-avagin@openvz.org>
References: <1338797382-287275-1-git-send-email-avagin@openvz.org>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prev_state is a state of task, when it stops executing on cpu.

It's needed for filtering sched:sched_switch_finish.
For example If we want to track when a task is sleeping:

./perf record -e sched:sched_switch -g --filter 'prev_state == 1' \
	-e sched:sched_switch_finish --filter 'state == 1' -P  foo

The previous state is set in sched:sched_switch, so it works when
both events sched:sched_switch and sched:sched_switch_finish are
enabled.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 include/linux/sched.h        |    3 +++
 include/trace/events/sched.h |   12 +++++++++++-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f45c0b2..172bbe3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1576,6 +1576,9 @@ struct task_struct {
 	struct uprobe_task *utask;
 	int uprobe_srcu_id;
 #endif
+#ifdef CONFIG_EVENT_TRACING
+	volatile long prev_state;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index b2219d8..c1b70b1 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -133,6 +133,7 @@ TRACE_EVENT(sched_switch,
 		__entry->prev_pid	= prev->pid;
 		__entry->prev_prio	= prev->prio;
 		__entry->prev_state	= __trace_sched_switch_state(prev);
+		prev->prev_state	= __trace_sched_switch_state(prev);
 		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
 		__entry->next_pid	= next->pid;
 		__entry->next_prio	= next->prio;
@@ -158,14 +159,23 @@ TRACE_EVENT(sched_switch_finish,
 	TP_STRUCT__entry(
 		__array(	char,	comm,	TASK_COMM_LEN	)
 		__field(	pid_t,	pid			)
+		__field(	long,	state			)
 	),
 
 	TP_fast_assign(
 		__entry->pid	= p->pid;
+		__entry->state	= p->prev_state;
 		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("comm=%s pid=%d", __entry->comm, __entry->pid)
+	TP_printk("comm=%s pid=%d state=%s%s",
+		__entry->comm, __entry->pid,
+		__entry->state & (TASK_STATE_MAX-1) ?
+		  __print_flags(__entry->state & (TASK_STATE_MAX-1), "|",
+				{ 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
+				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
+				{ 128, "W" }) : "R",
+		__entry->state & TASK_STATE_MAX ? "+" : "")
 );
 
 /*
-- 
1.7.1

