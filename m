Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab2IUSdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:33:33 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38324 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518Ab2IUSda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:33:30 -0400
From: morten.rasmussen@arm.com
To: paulmck@linux.vnet.ibm.com, pjt@google.com, peterz@infradead.org,
        suresh.b.siddha@intel.com
Cc: morten.rasmussen@arm.com, linaro-sched-sig@lists.linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 08/10] sched: Add ftrace events for entity load-tracking
Date: Fri, 21 Sep 2012 19:32:23 +0100
Message-Id: <1348252345-5642-9-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 21 Sep 2012 18:32:27.0038 (UTC) FILETIME=[735F3BE0:01CD9827]
X-MC-Unique: 112092119322809701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8LIXfQT011352

From: Morten Rasmussen <morten.rasmussen@arm.com>

Adds ftrace events for key variables related to the entity
load-tracking to help debugging scheduler behaviour. Allows tracing
of load contribution and runqueue residency ratio for both entities
and runqueues as well as entity CPU usage ratio.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 include/trace/events/sched.h |  125 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/fair.c          |    7 +++
 2 files changed, 132 insertions(+)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 5a8671e..847eb76 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -430,6 +430,131 @@ TRACE_EVENT(sched_pi_setprio,
 			__entry->oldprio, __entry->newprio)
 );
 
+/*
+ * Tracepoint for showing tracked load contribution.
+ */
+TRACE_EVENT(sched_task_load_contrib,
+
+	TP_PROTO(struct task_struct *tsk, unsigned long load_contrib),
+
+	TP_ARGS(tsk, load_contrib),
+
+	TP_STRUCT__entry(
+		__array(char, comm, TASK_COMM_LEN)
+		__field(pid_t, pid)
+		__field(unsigned long, load_contrib)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid            = tsk->pid;
+		__entry->load_contrib   = load_contrib;
+	),
+
+	TP_printk("comm=%s pid=%d load_contrib=%lu",
+			__entry->comm, __entry->pid,
+			__entry->load_contrib)
+);
+
+/*
+ * Tracepoint for showing tracked task runnable ratio [0..1023].
+ */
+TRACE_EVENT(sched_task_runnable_ratio,
+
+	TP_PROTO(struct task_struct *tsk, unsigned long ratio),
+
+	TP_ARGS(tsk, ratio),
+
+	TP_STRUCT__entry(
+		__array(char, comm, TASK_COMM_LEN)
+		__field(pid_t, pid)
+		__field(unsigned long, ratio)
+	),
+
+	TP_fast_assign(
+	memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid   = tsk->pid;
+		__entry->ratio = ratio;
+	),
+
+	TP_printk("comm=%s pid=%d ratio=%lu",
+			__entry->comm, __entry->pid,
+			__entry->ratio)
+);
+
+/*
+ * Tracepoint for showing tracked rq runnable ratio [0..1023].
+ */
+TRACE_EVENT(sched_rq_runnable_ratio,
+
+	TP_PROTO(int cpu, unsigned long ratio),
+
+	TP_ARGS(cpu, ratio),
+
+	TP_STRUCT__entry(
+		__field(int, cpu)
+		__field(unsigned long, ratio)
+	),
+
+	TP_fast_assign(
+		__entry->cpu   = cpu;
+		__entry->ratio = ratio;
+	),
+
+	TP_printk("cpu=%d ratio=%lu",
+			__entry->cpu,
+			__entry->ratio)
+);
+
+/*
+ * Tracepoint for showing tracked rq runnable load.
+ */
+TRACE_EVENT(sched_rq_runnable_load,
+
+	TP_PROTO(int cpu, u64 load),
+
+	TP_ARGS(cpu, load),
+
+	TP_STRUCT__entry(
+		__field(int, cpu)
+		__field(u64, load)
+	),
+
+	TP_fast_assign(
+		__entry->cpu  = cpu;
+		__entry->load = load;
+	),
+
+	TP_printk("cpu=%d load=%llu",
+			__entry->cpu,
+			__entry->load)
+);
+
+/*
+ * Tracepoint for showing tracked task cpu usage ratio [0..1023].
+ */
+TRACE_EVENT(sched_task_usage_ratio,
+
+	TP_PROTO(struct task_struct *tsk, unsigned long ratio),
+
+	TP_ARGS(tsk, ratio),
+
+	TP_STRUCT__entry(
+		__array(char, comm, TASK_COMM_LEN)
+		__field(pid_t, pid)
+		__field(unsigned long, ratio)
+	),
+
+	TP_fast_assign(
+	memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid   = tsk->pid;
+		__entry->ratio = ratio;
+	),
+
+	TP_printk("comm=%s pid=%d ratio=%lu",
+			__entry->comm, __entry->pid,
+			__entry->ratio)
+);
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8f0f3b9..0be53be 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1192,9 +1192,11 @@ static inline void __update_task_entity_contrib(struct sched_entity *se)
 	contrib = se->avg.runnable_avg_sum * scale_load_down(se->load.weight);
 	contrib /= (se->avg.runnable_avg_period + 1);
 	se->avg.load_avg_contrib = scale_load(contrib);
+	trace_sched_task_load_contrib(task_of(se), se->avg.load_avg_contrib);
 	contrib = se->avg.runnable_avg_sum * scale_load_down(NICE_0_LOAD);
 	contrib /= (se->avg.runnable_avg_period + 1);
 	se->avg.load_avg_ratio = scale_load(contrib);
+	trace_sched_task_runnable_ratio(task_of(se), se->avg.load_avg_ratio);
 }
 
 /* Compute the current contribution to load_avg by se, return any delta */
@@ -1286,9 +1288,14 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 
 static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
 {
+	u32 contrib;
 	__update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable,
 				     runnable);
 	__update_tg_runnable_avg(&rq->avg, &rq->cfs);
+	contrib = rq->avg.runnable_avg_sum * scale_load_down(1024);
+	contrib /= (rq->avg.runnable_avg_period + 1);
+	trace_sched_rq_runnable_ratio(cpu_of(rq), scale_load(contrib));
+	trace_sched_rq_runnable_load(cpu_of(rq), rq->cfs.runnable_load_avg);
 }
 
 /* Add the load generated by se into cfs_rq's child load-average */
-- 
1.7.9.5


