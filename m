Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab1LHCDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 21:03:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57175 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756792Ab1LHCDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 21:03:54 -0500
Message-ID: <4EE01ACB.1000102@fb.com>
Date: Wed, 7 Dec 2011 18:02:51 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Vagin <avagin@openvz.org>,
        <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: Re: [PATCH 3/4] trace: add ability to collect call chain of non-current
 task.
References: <1317052535-1765247-1-git-send-email-avagin@openvz.org> <1317052535-1765247-4-git-send-email-avagin@openvz.org> <1317132351.15383.66.camel@twins> <20110927205548.GN18553@somewhere>
In-Reply-To: <20110927205548.GN18553@somewhere>
Content-Type: multipart/mixed;
	boundary="------------010309000002020505020307"
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-07_09:2011-12-08,2011-12-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------010309000002020505020307
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/64 12:06 PM, Frederic Weisbecker wrote:
[..]
>
> That and the fact there are other ways to get that callchain like taking
> the one of the last sched_switch event from the waked thread.
>
> Perhaps we should use the sched_switch event and a post_sched_switch
> event, compute the time difference as a weight and use the callchain of any of
> those. Perhaps as a plugin in perf report?
>
> In any case that rather sounds like something that should be done in post-processing
> in userspace, in perf tools.
>
> We should probably avoid the remote callchains, sounds like asking for complications
> everywhere.

Agreed on remote callchains and maintaining consistency about what the 
tracepoints mean.

As I said on the other thread, post-processing in userspace has the 
issue that we collect more info than we actually need and under load, 
perf record can't keep up.

Attached is an alternative approach that does what you allude to above.

perf record -agPe sched:sched_switch --filter "delay > 1000000" -- sleep 1

allows us to collect a lot less. For some reason, "perf script" shows 
the correct delay field, but the sample period still contains 1 (i.e 
__perf_count() hint is not working for me).

  -Arun

--------------010309000002020505020307
Content-Type: text/plain; x-mac-type=0; x-mac-creator=0;
	name="sched-switch-delay.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="sched-switch-delay.patch"

commit c58595bd2899685a2b9d94374203708bf279c2d9
Author: Arun Sharma <asharma@fb.com>
Date:   Wed Dec 7 16:17:00 2011 -0800

    Make sleep/iowait delay available at the sched_switch tracepoint.
    Also move trace_sched_switch() to finish_task_switch so the event
    applies to next rather than prev.
  
    If such a move doesn't make sense, we might have to consider adding
    a new event that's called something else.

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 959ff18..f67cf35 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -113,9 +113,10 @@ static inline long __trace_sched_switch_state(struct task_struct *p)
 TRACE_EVENT(sched_switch,
 
 	TP_PROTO(struct task_struct *prev,
-		 struct task_struct *next),
+		 struct task_struct *next,
+		 unsigned long now),
 
-	TP_ARGS(prev, next),
+	TP_ARGS(prev, next, now),
 
 	TP_STRUCT__entry(
 		__array(	char,	prev_comm,	TASK_COMM_LEN	)
@@ -125,6 +126,7 @@ TRACE_EVENT(sched_switch,
 		__array(	char,	next_comm,	TASK_COMM_LEN	)
 		__field(	pid_t,	next_pid			)
 		__field(	int,	next_prio			)
+		__field(	long,	delay				)
 	),
 
 	TP_fast_assign(
@@ -135,9 +137,20 @@ TRACE_EVENT(sched_switch,
 		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
 		__entry->next_pid	= next->pid;
 		__entry->next_prio	= next->prio;
+#ifdef CONFIG_SCHEDSTATS
+ 		__entry->delay		= next->se.statistics.block_start ? next->se.statistics.block_start
+ 					  : next->se.statistics.sleep_start ? next->se.statistics.sleep_start : 0;
+ 		__entry->delay = __entry->delay ? now - __entry->delay : 0;
+#else
+ 		__entry->delay = 0;
+#endif
+	)
+
+	TP_perf_assign(
+		__perf_count(__entry->delay);
 	),
 
-	TP_printk("prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s%s ==> next_comm=%s next_pid=%d next_prio=%d",
+	TP_printk("prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s%s ==> next_comm=%s next_pid=%d next_prio=%d delay=%ld",
 		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
 		__entry->prev_state & (TASK_STATE_MAX-1) ?
 		  __print_flags(__entry->prev_state & (TASK_STATE_MAX-1), "|",
@@ -145,7 +158,7 @@ TRACE_EVENT(sched_switch,
 				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
 				{ 128, "W" }) : "R",
 		__entry->prev_state & TASK_STATE_MAX ? "+" : "",
-		__entry->next_comm, __entry->next_pid, __entry->next_prio)
+		__entry->next_comm, __entry->next_pid, __entry->next_prio, __entry->delay)
 );
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index df2452b..c1e64f9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3156,7 +3156,6 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
-	trace_sched_switch(prev, next);
 }
 
 /**
@@ -3180,6 +3179,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	struct mm_struct *mm = rq->prev_mm;
 	long prev_state;
 
+	trace_sched_switch(prev, current, rq->clock);
 	rq->prev_mm = NULL;
 
 	/*
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index fc6a8e9..58d4bdc 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -880,7 +880,6 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		if (unlikely(delta > se->statistics.sleep_max))
 			se->statistics.sleep_max = delta;
 
-		se->statistics.sleep_start = 0;
 		se->statistics.sum_sleep_runtime += delta;
 
 		if (tsk) {
@@ -897,7 +896,6 @@ static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		if (unlikely(delta > se->statistics.block_max))
 			se->statistics.block_max = delta;
 
-		se->statistics.block_start = 0;
 		se->statistics.sum_sleep_runtime += delta;
 
 		if (tsk) {
@@ -1070,8 +1068,12 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 
 			if (tsk->state & TASK_INTERRUPTIBLE)
 				se->statistics.sleep_start = rq_of(cfs_rq)->clock;
+			else
+				se->statistics.sleep_start = 0;
 			if (tsk->state & TASK_UNINTERRUPTIBLE)
 				se->statistics.block_start = rq_of(cfs_rq)->clock;
+			else
+				se->statistics.block_start = 0;
 		}
 #endif
 	}
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 7e62c0a..b8b98d4 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -50,7 +50,7 @@ tracing_sched_switch_trace(struct trace_array *tr,
 }
 
 static void
-probe_sched_switch(void *ignore, struct task_struct *prev, struct task_struct *next)
+probe_sched_switch(void *ignore, struct task_struct *prev, struct task_struct *next, unsigned long now)
 {
 	struct trace_array_cpu *data;
 	unsigned long flags;

--------------010309000002020505020307--
