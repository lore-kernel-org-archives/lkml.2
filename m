Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab1KBUcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:32:12 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33371 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab1KBUcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:32:05 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 26/28] rcu: Add more information to the wrong-idle-task complaint
Date: Wed,  2 Nov 2011 13:30:47 -0700
Message-Id: <1320265849-5744-26-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-9360-0000-0000-00000045A50B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

The current code just complains if the current task is not the idle task.
This commit therefore adds printing of the identity of the idle task.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny.c |   12 ++++++++++--
 kernel/rcutree.c |   12 ++++++++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index e0df33f..f4e7bc3 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -66,10 +66,14 @@ static void rcu_idle_enter_common(long long oldval)
 	}
 	RCU_TRACE(trace_rcu_dyntick("Start", oldval, rcu_dynticks_nesting));
 	if (!idle_cpu(smp_processor_id())) {
-		WARN_ON_ONCE(1);	/* must be idle task! */
+		struct task_struct *idle = idle_task(smp_processor_id());
+
 		RCU_TRACE(trace_rcu_dyntick("Error on entry: not idle task",
 					    oldval, rcu_dynticks_nesting));
 		ftrace_dump(DUMP_ALL);
+		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
+			  current->pid, current->comm,
+			  idle->pid, idle->comm); /* must be idle task! */
 	}
 	rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
 }
@@ -116,10 +120,14 @@ static void rcu_idle_exit_common(long long oldval)
 	}
 	RCU_TRACE(trace_rcu_dyntick("End", oldval, rcu_dynticks_nesting));
 	if (!idle_cpu(smp_processor_id())) {
-		WARN_ON_ONCE(1);	/* must be idle task! */
+		struct task_struct *idle = idle_task(smp_processor_id());
+
 		RCU_TRACE(trace_rcu_dyntick("Error on exit: not idle task",
 			  oldval, rcu_dynticks_nesting));
 		ftrace_dump(DUMP_ALL);
+		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
+			  current->pid, current->comm,
+			  idle->pid, idle->comm); /* must be idle task! */
 	}
 }
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index cc04876..2a8d9a6 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -356,10 +356,14 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 	}
 	trace_rcu_dyntick("Start", oldval, rdtp->dynticks_nesting);
 	if (!idle_cpu(smp_processor_id())) {
-		WARN_ON_ONCE(1);	/* must be idle task! */
+		struct task_struct *idle = idle_task(smp_processor_id());
+
 		trace_rcu_dyntick("Error on entry: not idle task",
 				   oldval, rdtp->dynticks_nesting);
 		ftrace_dump(DUMP_ALL);
+		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
+			  current->pid, current->comm,
+			  idle->pid, idle->comm); /* must be idle task! */
 	}
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic_inc();  /* See above. */
@@ -445,10 +449,14 @@ static void rcu_idle_exit_common(struct rcu_dynticks *rdtp, long long oldval)
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 	trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);
 	if (!idle_cpu(smp_processor_id())) {
-		WARN_ON_ONCE(1);	/* must be idle task! */
+		struct task_struct *idle = idle_task(smp_processor_id());
+
 		trace_rcu_dyntick("Error on exit: not idle task",
 				  oldval, rdtp->dynticks_nesting);
 		ftrace_dump(DUMP_ALL);
+		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
+			  current->pid, current->comm,
+			  idle->pid, idle->comm); /* must be idle task! */
 	}
 }
 
-- 
1.7.3.2

