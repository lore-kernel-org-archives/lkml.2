Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab2FDIK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 04:10:27 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:2035 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab2FDIKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 04:10:13 -0400
From: Andrew Vagin <avagin@openvz.org>
Cc: Arun Sharma <asharma@fb.com>, Oleg Strikov <OSTRIKOV@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] sched: event: add trace events when a task starts executing on a cpu
Date: Mon,  4 Jun 2012 12:09:38 +0400
Message-Id: <1338797382-287275-2-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1338797382-287275-1-git-send-email-avagin@openvz.org>
References: <1338797382-287275-1-git-send-email-avagin@openvz.org>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_switch_finish is sent when a task starts executing on a cpu.
It sends in context of this task, that's why sched_switch can't be used.
sched_switch is send when a task goes out from a cpu.

This two events will be needed for profiling sleep time.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 include/trace/events/sched.h |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index ea7a203..b2219d8 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -149,6 +149,25 @@ TRACE_EVENT(sched_switch,
 		__entry->next_comm, __entry->next_pid, __entry->next_prio)
 );
 
+TRACE_EVENT(sched_switch_finish,
+
+	TP_PROTO(struct task_struct *p),
+
+	TP_ARGS(p),
+
+	TP_STRUCT__entry(
+		__array(	char,	comm,	TASK_COMM_LEN	)
+		__field(	pid_t,	pid			)
+	),
+
+	TP_fast_assign(
+		__entry->pid	= p->pid;
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+	),
+
+	TP_printk("comm=%s pid=%d", __entry->comm, __entry->pid)
+);
+
 /*
  * Tracepoint for a task being migrated:
  */
-- 
1.7.1

