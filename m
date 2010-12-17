Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0LQNCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 08:02:47 -0500
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:60851 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab0LQNCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 08:02:36 -0500
X-AuditID: c1b4fb39-b7cfbae000005c8e-11-4d0b5f6b7a9c
From: Harald Gustafsson <harald.gustafsson@ericsson.com>
To: Dario Faggioli <faggioli@gandalf.sssup.it>,
        Peter Zijlstra <peterz@infradead.org>,
        Harald Gustafsson <hgu1972@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>
Subject: [PATCH 3/3] sched trace updated with normalized clock info.
Date: Fri, 17 Dec 2010 14:02:04 +0100
Message-ID: <02d8fe6a95a8ad6ac4413c79766461b9705fb4f6.1292578808.git.harald.gustafsson@ericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated the sched deadline v3 traces with the normalized runtime clock.
The delta execution runtime and the last start of execution is also
using the normalized clock.

Change-Id: I6f05a76ad876e8895f3f24940f3ee07f1cb0e8b8

Signed-off-by: Harald Gustafsson <harald.gustafsson@ericsson.com>
---
 include/trace/events/sched.h |   25 +++++++++++++++++--------
 kernel/sched.c               |    2 +-
 kernel/sched_dl.c            |    2 +-
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 3307353..3c766eb 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -379,16 +379,17 @@ TRACE_EVENT(sched_stat_runtime,
  */
 TRACE_EVENT(sched_switch_dl,
 
-	TP_PROTO(u64 clock,
+	TP_PROTO(u64 clock, u64 clock_norm,
 		 struct task_struct *prev,
 		 struct task_struct *next),
 
-	TP_ARGS(clock, prev, next),
+	TP_ARGS(clock, clock_norm, prev, next),
 
 	TP_STRUCT__entry(
 		__array(	char,	prev_comm,	TASK_COMM_LEN	)
 		__field(	pid_t,	prev_pid			)
 		__field(	u64,	clock				)
+		__field(	u64,	clock_norm			)
 		__field(	s64,	prev_rt				)
 		__field(	u64,	prev_dl				)
 		__field(	long,	prev_state			)
@@ -402,6 +403,7 @@ TRACE_EVENT(sched_switch_dl,
 		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
 		__entry->prev_pid	= prev->pid;
 		__entry->clock		= clock;
+		__entry->clock_norm	= clock_norm;
 		__entry->prev_rt	= prev->dl.runtime;
 		__entry->prev_dl	= prev->dl.deadline;
 		__entry->prev_state	= prev->state;
@@ -412,7 +414,7 @@ TRACE_EVENT(sched_switch_dl,
 	),
 
 	TP_printk("prev_comm=%s prev_pid=%d prev_rt=%Ld [ns] prev_dl=%Lu [ns] prev_state=%s ==> "
-		  "next_comm=%s next_pid=%d next_rt=%Ld [ns] next_dl=%Lu [ns] clock=%Lu [ns]",
+		  "next_comm=%s next_pid=%d next_rt=%Ld [ns] next_dl=%Lu [ns] clock=%Lu (%Lu) [ns]",
 		  __entry->prev_comm, __entry->prev_pid, (long long)__entry->prev_rt,
 		  (unsigned long long)__entry->prev_dl, __entry->prev_state ?
 		    __print_flags(__entry->prev_state, "|",
@@ -420,7 +422,8 @@ TRACE_EVENT(sched_switch_dl,
 				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
 				{ 128, "W" }) : "R",
 		  __entry->next_comm, __entry->next_pid, (long long)__entry->next_rt,
-		  (unsigned long long)__entry->next_dl, (unsigned long long)__entry->clock)
+		  (unsigned long long)__entry->next_dl, (unsigned long long)__entry->clock,
+		  (unsigned long long)__entry->clock_norm)
 );
 
 /*
@@ -655,9 +658,9 @@ DEFINE_EVENT(sched_stat_template_dl, sched_stat_updt_dl,
  */
 TRACE_EVENT(sched_stat_runtime_dl,
 
-	TP_PROTO(struct task_struct *p, u64 clock, u64 last),
+	TP_PROTO(struct task_struct *p, u64 clock, u64 last, u64 clock_norm),
 
-	TP_ARGS(p, clock, last),
+	TP_ARGS(p, clock, last, clock_norm),
 
 	TP_STRUCT__entry(
 		__array(	char,	comm,	TASK_COMM_LEN	)
@@ -667,6 +670,8 @@ TRACE_EVENT(sched_stat_runtime_dl,
 		__field(	s64,	rt			)
 		__field(	u64,	dl			)
 		__field(	u64,	start			)
+		__field(	u64,	start_norm		)
+		__field(	u64,	clock_norm		)
         ),
 
 	TP_fast_assign(
@@ -677,12 +682,16 @@ TRACE_EVENT(sched_stat_runtime_dl,
 		__entry->rt		= p->dl.runtime - last;
 		__entry->dl		= p->dl.deadline;
 		__entry->start		= p->se.exec_start;
+		__entry->start_norm	= p->dl.exec_start_norm;
+		__entry->clock_norm	= clock_norm;
 	),
 
-	TP_printk("comm=%s pid=%d clock=%Lu [ns] delta_exec=%Lu [ns] rt=%Ld [ns] dl=%Lu [ns] exec_start=%Lu [ns]",
+	TP_printk("comm=%s pid=%d clock=%Lu (%Lu) [ns] delta_exec=%Lu [ns] rt=%Ld [ns] dl=%Lu [ns] exec_start=%Lu (%Lu) [ns]",
 		  __entry->comm, __entry->pid, (unsigned long long)__entry->clock,
+		  (unsigned long long)__entry->clock_norm,
 		  (unsigned long long)__entry->last, (long long)__entry->rt,
-		  (unsigned long long)__entry->dl, (unsigned long long)__entry->start)
+		  (unsigned long long)__entry->dl, (unsigned long long)__entry->start,
+		  (unsigned long long)__entry->start_norm)
 );
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index ddb18d2..b6b8ccc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3027,7 +3027,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	prepare_task_switch(rq, prev, next);
 	trace_sched_switch(rq, prev, next);
 	if (unlikely(__dl_task(prev) || __dl_task(next)))
-		trace_sched_switch_dl(rq->clock, prev, next);
+		trace_sched_switch_dl(rq->clock, rq->clock_norm, prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
diff --git a/kernel/sched_dl.c b/kernel/sched_dl.c
index 049c001..b37a905 100644
--- a/kernel/sched_dl.c
+++ b/kernel/sched_dl.c
@@ -647,7 +647,7 @@ static void update_curr_dl(struct rq *rq)
 	curr->se.sum_exec_runtime += delta_exec;
 	schedstat_add(&rq->dl, exec_clock, delta_exec);
 	account_group_exec_runtime(curr, delta_exec);
-	trace_sched_stat_runtime_dl(curr, rq->clock, delta_exec_norm);
+	trace_sched_stat_runtime_dl(curr, rq->clock, delta_exec_norm, rq->clock_norm);
 
 	curr->se.exec_start = rq->clock;
 	curr->dl.exec_start_norm = rq->clock_norm;
-- 
1.7.0.4

