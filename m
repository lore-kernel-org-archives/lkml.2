Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab2IUSdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:33:09 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36861 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757546Ab2IUSca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:32:30 -0400
From: morten.rasmussen@arm.com
To: paulmck@linux.vnet.ibm.com, pjt@google.com, peterz@infradead.org,
        suresh.b.siddha@intel.com
Cc: morten.rasmussen@arm.com, linaro-sched-sig@lists.linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 09/10] sched: Add HMP task migration ftrace event
Date: Fri, 21 Sep 2012 19:32:24 +0100
Message-Id: <1348252345-5642-10-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 21 Sep 2012 18:32:27.0522 (UTC) FILETIME=[73A91620:01CD9827]
X-MC-Unique: 112092119322807901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q8LIY4Vv011360

From: Morten Rasmussen <morten.rasmussen@arm.com>

Adds ftrace event for tracing task migrations using HMP
optimized scheduling.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 include/trace/events/sched.h |   28 ++++++++++++++++++++++++++++
 kernel/sched/fair.c          |   15 +++++++++++----
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 847eb76..501aa32 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -555,6 +555,34 @@ TRACE_EVENT(sched_task_usage_ratio,
 			__entry->comm, __entry->pid,
 			__entry->ratio)
 );
+
+/*
+ * Tracepoint for HMP (CONFIG_SCHED_HMP) task migrations.
+ */
+TRACE_EVENT(sched_hmp_migrate,
+
+	TP_PROTO(struct task_struct *tsk, int dest, int force),
+
+	TP_ARGS(tsk, dest, force),
+
+	TP_STRUCT__entry(
+		__array(char, comm, TASK_COMM_LEN)
+		__field(pid_t, pid)
+		__field(int,  dest)
+		__field(int,  force)
+	),
+
+	TP_fast_assign(
+	memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid   = tsk->pid;
+		__entry->dest  = dest;
+		__entry->force = force;
+	),
+
+	TP_printk("comm=%s pid=%d dest=%d force=%d",
+			__entry->comm, __entry->pid,
+			__entry->dest, __entry->force)
+);
 #endif /* _TRACE_SCHED_H */
 
 /* This part must be outside protection */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0be53be..811b2b9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3333,10 +3333,16 @@ unlock:
 	rcu_read_unlock();
 
 #ifdef CONFIG_SCHED_HMP
-	if (hmp_up_migration(prev_cpu, &p->se))
-		return hmp_select_faster_cpu(p, prev_cpu);
-	if (hmp_down_migration(prev_cpu, &p->se))
-		return hmp_select_slower_cpu(p, prev_cpu);
+	if (hmp_up_migration(prev_cpu, &p->se)) {
+		new_cpu = hmp_select_faster_cpu(p, prev_cpu);
+		trace_sched_hmp_migrate(p, new_cpu, 0);
+		return new_cpu;
+	}
+	if (hmp_down_migration(prev_cpu, &p->se)) {
+		new_cpu = hmp_select_slower_cpu(p, prev_cpu);
+		trace_sched_hmp_migrate(p, new_cpu, 0);
+		return new_cpu;
+	}
 	/* Make sure that the task stays in its previous hmp domain */
 	if (!cpumask_test_cpu(new_cpu, &hmp_cpu_domain(prev_cpu)->cpus))
 		return prev_cpu;
@@ -5718,6 +5724,7 @@ static void hmp_force_up_migration(int this_cpu)
 				target->push_cpu = hmp_select_faster_cpu(p, cpu);
 				target->migrate_task = p;
 				force = 1;
+				trace_sched_hmp_migrate(p, target->push_cpu, 1);
 			}
 		}
 		raw_spin_unlock_irqrestore(&target->lock, flags);
-- 
1.7.9.5


