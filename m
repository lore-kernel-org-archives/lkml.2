Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417Ab0KQBAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:00:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35453 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab0KQA7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:59:42 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=H7Pe8KIQNIUA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=10Bfq_dcW6yPcoGzCMAA:9 a=MwikNg5IJKQlyVlmSY8A:7 a=NsKVOslYlofZcneKrC04M69CAQgA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101117005940.416708704@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 16 Nov 2010 19:54:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 4/5] [PATCH 4/5] tracing/events: Add stable event sched_switch
References: <20101117005357.024472450@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-events-Add-stable-event-sched_switch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add the stable event for sched_switch.

[root@bxf ~]# cat /sys/kernel/event/sched_switch/format
	array:prev_comm	type:char	size:8	count:16	align:1	signed:1;
	field:prev_pid	type:pid_t	size:32	align:4	signed:1;
	field:prev_state	type:char	size:8	align:1	signed:1;
	array:next_comm	type:char	size:8	count:16	align:1	signed:1;
	field:next_pid	type:pid_t	size:32	align:4	signed:1;

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/stable/sched.h |   20 ++++++++++++++++++++
 include/trace/stable_list.h  |    1 +
 kernel/events/events.c       |   22 ++++++++++++++++++++++
 3 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/stable/sched.h

diff --git a/include/trace/stable/sched.h b/include/trace/stable/sched.h
new file mode 100644
index 0000000..b5f4fd7
--- /dev/null
+++ b/include/trace/stable/sched.h
@@ -0,0 +1,20 @@
+#if !defined(_STABLE_SCHED_H) || defined(STABLE_HEADER_MULTI_READ)
+#define _STABLE_SCHED_H
+
+#include <linux/sched.h>
+
+/*
+ * Tracepoint for task switches, performed by the scheduler:
+ */
+STABLE_EVENT(sched_switch,
+
+	EVENT_STRUCT(
+		__array(	char,	prev_comm,	TASK_COMM_LEN	)__SEP__
+		__field(	pid_t,	prev_pid			)__SEP__
+		__field(	char,	prev_state			)__SEP__
+		__array(	char,	next_comm,	TASK_COMM_LEN	)__SEP__
+		__field(	pid_t,	next_pid			)
+	)
+);
+
+#endif /* _STABLE_SCHED_H */
diff --git a/include/trace/stable_list.h b/include/trace/stable_list.h
index 996932a..9cbc006 100644
--- a/include/trace/stable_list.h
+++ b/include/trace/stable_list.h
@@ -1,2 +1,3 @@
 
 /* New stable defines must be added here */
+#include <trace/stable/sched.h>
diff --git a/kernel/events/events.c b/kernel/events/events.c
index 6868bf1..f69e720 100644
--- a/kernel/events/events.c
+++ b/kernel/events/events.c
@@ -13,4 +13,26 @@
 
 static struct mutex stable_event_mutex;
 
+#include <trace/events/sched.h>
+
+DECLARE_TRACE(stable_sched_switch,
+	      TP_PROTO(char *prev_comm, pid_t prev_pid, char prev_state,
+		       char *next_comm, pid_t next_pid),
+	      TP_ARGS(prev_comm, prev_pid, prev_state, next_comm, next_pid));
+DEFINE_TRACE(stable_sched_switch);
+
+static const char stat_nam[] = TASK_STATE_TO_CHAR_STR;
+static void hook_sched_switch(void *ignore,
+			      struct task_struct *prev,
+			      struct task_struct *next)
+{
+	unsigned state;
+
+	state = prev->state ? __ffs(prev->state) + 1 : 0;
+	state = state < sizeof(stat_nam) - 1 ? stat_nam[state] : '?';
+
+	trace_stable_sched_switch(prev->comm, prev->pid, state,
+				  next->comm, next->pid);
+}
+
 #include "event_reg.h"
-- 
1.7.1


