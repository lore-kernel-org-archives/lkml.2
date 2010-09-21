Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab0IUClp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 22:41:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51901 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab0IUClk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 22:41:40 -0400
X-Authority-Analysis: v=1.1 cv=Ba7GFA6IM/Rlu/bGJ5lftWmk/oljGo5ZwASPcBcXAAo= c=1 sm=0 a=9djwmVDfYk8A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=1nSz6Ew-AAAA:8 a=meVymXHHAAAA:8 a=6dgqTkKu9hYoR1qk6isA:9 a=7pFqqFLHdGiucYmFNxEA:7 a=EHmAdrPUI_iYo3OnE-NEyW1NpboA:4 a=jEp0ucaQiEUA:10 a=nj4rVwXhlm8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20100921024139.369929073@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 20 Sep 2010 22:40:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Gregory Haskins <ghaskins@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/4] tracing/sched: Add sched_rt_setprio tracepoint
References: <20100921024002.672817629@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-sched-Add-sched_rt_setprio-tracepoint.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add a tracepoint that shows the priority of a task being boosted
via priority inheritance.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/sched.h |   25 +++++++++++++++++++++++++
 kernel/sched.c               |    1 +
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 0e0c108..8feb641 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -398,6 +398,31 @@ DEFINE_EVENT_PRINT(sched_rt_push_pull, sched_rt_pull,
 			__entry->comm, __entry->pid,
 			__entry->prio, __entry->cpu));
 
+TRACE_EVENT(sched_rt_setprio,
+
+	TP_PROTO(struct task_struct *tsk, int newprio),
+
+	TP_ARGS(tsk, newprio),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+		__field( int,	oldprio			)
+		__field( int,	newprio			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid		= tsk->pid;
+		__entry->oldprio	= tsk->prio;
+		__entry->newprio	= newprio;
+	),
+
+	TP_printk("comm=%s pid=%d oldprio=%d newprio=%d",
+			__entry->comm, __entry->pid,
+			__entry->oldprio, __entry->newprio)
+);
+
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */
diff --git a/kernel/sched.c b/kernel/sched.c
index ed09d4f..4d4f35e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4358,6 +4358,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 
 	rq = task_rq_lock(p, &flags);
 
+	trace_sched_rt_setprio(p, prio);
 	oldprio = p->prio;
 	prev_class = p->sched_class;
 	on_rq = p->se.on_rq;
-- 
1.7.1


