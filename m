Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab0IUPCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 11:02:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48842 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab0IUPCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:02:32 -0400
X-Authority-Analysis: v=1.1 cv=GglhOq9PVtWDmzXFaQc2b9ix+3dKCE90LyQFAZ1FxMQ= c=1 sm=0 a=z4ntZRkq5-oA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=1nSz6Ew-AAAA:8 a=meVymXHHAAAA:8 a=mmk_OMQFTzCicvbQgxkA:9 a=92waGzCgXGjT2GnEQUwA:7 a=zb2vHYSbx80s_DAio43BsGaSjT4A:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=nj4rVwXhlm8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL] tracing/sched: Add sched_pi_setprio tracepoint
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Gregory Haskins <ghaskins@novell.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 21 Sep 2010 11:02:29 -0400
Message-ID: <1285081349.23122.1907.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I rebased this against tip/sched/core, and removed the push/pull
tracepoint. I made the change that Peter suggested and got his Acked-by.

Please pull the latest tip/sched/rt tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/sched/rt


Steven Rostedt (1):
      tracing/sched: Add sched_pi_setprio tracepoint

----
 include/trace/events/sched.h |   29 +++++++++++++++++++++++++++++
 kernel/sched.c               |    1 +
 2 files changed, 30 insertions(+), 0 deletions(-)
---------------------------
commit a8027073eb127cd207070891374b5c54c2ce3d23
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Mon Sep 20 15:13:34 2010 -0400

    tracing/sched: Add sched_pi_setprio tracepoint
    
    Add a tracepoint that shows the priority of a task being boosted
    via priority inheritance.
    
    Cc: Gregory Haskins <ghaskins@novell.com>
    Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 9208c92..f633478 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -362,6 +362,35 @@ TRACE_EVENT(sched_stat_runtime,
 			(unsigned long long)__entry->vruntime)
 );
 
+/*
+ * Tracepoint for showing priority inheritance modifying a tasks
+ * priority.
+ */
+TRACE_EVENT(sched_pi_setprio,
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
index 9ca8ad0..4ad4738 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4355,6 +4355,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 
 	rq = task_rq_lock(p, &flags);
 
+	trace_sched_pi_setprio(p, prio);
 	oldprio = p->prio;
 	prev_class = p->sched_class;
 	on_rq = p->se.on_rq;


