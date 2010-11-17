Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631Ab0KQBAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:00:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42678 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303Ab0KQA7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:59:42 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=aTFe0RLDT0UA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=5b3MVcyFxcIk-NN_KVAA:9 a=EJk3ee8jz5ho9PMuL-8A:7 a=iCS8uQstND9dwmcdVxbnRY8HS9YA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101117005940.688000675@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 16 Nov 2010 19:54:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 5/5] [PATCH 5/5] tracing/events: Add sched_migrate_task stable event
References: <20101117005357.024472450@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-events-Add-sched_migrate_task-stable-event.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add the stable event for sched_migrate_task.

[root@bxf ~]# cat /sys/kernel/event/sched_migrate_task/format
	array:comm	type:char	size:8	count:16	align:1	signed:1;
	field:pid	type:pid_t	size:32	align:4	signed:1;
	field:orig_cpu	type:int	size:32	align:4	signed:1;
	field:dest_cpu	type:int	size:32	align:4	signed:1;

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/stable/sched.h |   13 +++++++++++++
 kernel/events/events.c       |   10 ++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/trace/stable/sched.h b/include/trace/stable/sched.h
index b5f4fd7..55d0e6f 100644
--- a/include/trace/stable/sched.h
+++ b/include/trace/stable/sched.h
@@ -17,4 +17,17 @@ STABLE_EVENT(sched_switch,
 	)
 );
 
+/*
+ * Tracepoint for a task being migrated:
+ */
+STABLE_EVENT(sched_migrate_task,
+
+	EVENT_STRUCT(
+		__array(	char,	comm,	TASK_COMM_LEN	)__SEP__
+		__field(	pid_t,	pid			)__SEP__
+		__field(	int,	orig_cpu		)__SEP__
+		__field(	int,	dest_cpu		)
+	)
+);
+
 #endif /* _STABLE_SCHED_H */
diff --git a/kernel/events/events.c b/kernel/events/events.c
index f69e720..6ca2d2d 100644
--- a/kernel/events/events.c
+++ b/kernel/events/events.c
@@ -35,4 +35,14 @@ static void hook_sched_switch(void *ignore,
 				  next->comm, next->pid);
 }
 
+DECLARE_TRACE(stable_sched_migrate_task,
+	      TP_PROTO(char *comm, pid_t pid, int orig_cpu, int dest_cpu),
+	      TP_ARGS(comm, pid, orig_cpu, dest_cpu));
+DEFINE_TRACE(stable_sched_migrate_task);
+
+static void hook_sched_migrate_task(void *ignore, struct task_struct *p, int dest_cpu)
+{
+	trace_stable_sched_migrate_task(p->comm, p->pid, task_cpu(p), dest_cpu);
+}
+
 #include "event_reg.h"
-- 
1.7.1


