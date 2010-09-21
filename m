Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab0IUCln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 22:41:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43995 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab0IUClk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 22:41:40 -0400
X-Authority-Analysis: v=1.1 cv=QPMnOuvfoRK4nyqTv0NRvva4Xk0fUUuJArrqv1I9dZo= c=1 sm=0 a=Ott1jUwYHe0A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=1nSz6Ew-AAAA:8 a=meVymXHHAAAA:8 a=iHI-OginZfNdvPUayUcA:9 a=sViH7_HjmtPpgycg0xsA:7 a=FT2yU8yZii7O88UFxgGah11QbYkA:4 a=jEp0ucaQiEUA:10 a=nj4rVwXhlm8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100921024139.095017089@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 20 Sep 2010 22:40:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Gregory Haskins <ghaskins@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/4] tracing/sched: Add sched_rt_push and sched_rt_pull tracepoints
References: <20100921024002.672817629@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-sched-Add-sched_rt_push-and-sched_rt_pull-tr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Seeing how tasks are affected by the push/pull algorithm of the RT
scheduler helps in understanding the migration of RT tasks.

Adding these two tracepoints to show when an RT task is pushed from
one CPU to another, or pulled helps with analyzing the way the
scheduler works.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/sched.h |   36 ++++++++++++++++++++++++++++++++++++
 kernel/sched_rt.c            |    2 ++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 9208c92..0e0c108 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -362,6 +362,42 @@ TRACE_EVENT(sched_stat_runtime,
 			(unsigned long long)__entry->vruntime)
 );
 
+DECLARE_EVENT_CLASS(sched_rt_push_pull,
+
+	TP_PROTO(struct task_struct *tsk, int cpu),
+
+	TP_ARGS(tsk, cpu),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+		__field( int,	prio			)
+		__field( int,   cpu			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid		= tsk->pid;
+		__entry->prio		= tsk->prio;
+		__entry->cpu		= cpu;
+	),
+
+	TP_printk("comm=%s pid=%d prio=%d dest_cpu=%d",
+			__entry->comm, __entry->pid,
+			__entry->prio, __entry->cpu)
+);
+
+DEFINE_EVENT(sched_rt_push_pull, sched_rt_push,
+	TP_PROTO(struct task_struct *tsk, int cpu),
+	TP_ARGS(tsk, cpu));
+
+DEFINE_EVENT_PRINT(sched_rt_push_pull, sched_rt_pull,
+	TP_PROTO(struct task_struct *tsk, int cpu),
+	TP_ARGS(tsk, cpu),
+	TP_printk("comm=%s pid=%d prio=%d src_cpu=%d",
+			__entry->comm, __entry->pid,
+			__entry->prio, __entry->cpu));
+
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index baef30f..3aed9b0 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1372,6 +1372,7 @@ static int push_rt_task(struct rq *rq)
 	}
 
 	deactivate_task(rq, next_task, 0);
+	trace_sched_rt_push(next_task, lowest_rq->cpu);
 	set_task_cpu(next_task, lowest_rq->cpu);
 	activate_task(lowest_rq, next_task, 0);
 
@@ -1455,6 +1456,7 @@ static int pull_rt_task(struct rq *this_rq)
 			ret = 1;
 
 			deactivate_task(src_rq, p, 0);
+			trace_sched_rt_pull(p, src_rq->cpu);
 			set_task_cpu(p, this_cpu);
 			activate_task(this_rq, p, 0);
 			/*
-- 
1.7.1


