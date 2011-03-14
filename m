Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab1CNDv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 23:51:58 -0400
Received: from flusers.ccur.com ([173.221.59.2]:53878 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756746Ab1CNDvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 23:51:50 -0400
Date: Sun, 13 Mar 2011 23:50:41 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] jrcu: factor out preempt_count_cpu
Message-ID: <20110314035041.GA12965@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: make preempt_count_cpu() nonexistant if jrcu
nonexistant.

preempt_count_cpu()'s existance introduces a (very small)
bit of overhead in the context switch path, so don't
compile it in unless some kernel feature that uses it is
also compiled in.

Currently, jrcu is its only user.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/sched.c
===================================================================
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2657,6 +2657,8 @@ void sched_fork(struct task_struct *p, i
 	put_cpu();
 }
 
+#ifdef CONFIG_PREEMPT_COUNT_CPU
+
 /*
  * Fetch the preempt count of some cpu's current task.  Must be called
  * with interrupts blocked.  Stale return value.
@@ -2671,6 +2673,7 @@ int preempt_count_cpu(int cpu)
 	smp_rmb(); /* stop data prefetch until program ctr gets here */
 	return task_thread_info(cpu_curr(cpu))->preempt_count;
 }
+#endif
 
 /*
  * wake_up_new_task - wake up a newly created task for the first time.
@@ -4009,7 +4012,9 @@ need_resched_nonpreemptible:
 
 		rq->nr_switches++;
 		rq->curr = next;
-		smp_wmb(); /* for preempt_count_cpu() */
+#ifdef CONFIG_PREEMPT_COUNT_CPU
+		smp_wmb();
+#endif
 		++*switch_count;
 
 		context_switch(rq, prev, next); /* unlocks the rq */
@@ -8225,7 +8230,9 @@ struct task_struct *curr_task(int cpu)
 void set_curr_task(int cpu, struct task_struct *p)
 {
 	cpu_curr(cpu) = p;
-	smp_wmb(); /* for preempt_count_cpu() */
+#ifdef CONFIG_PREEMPT_COUNT_CPU
+	smp_wmb();
+#endif
 }
 
 #endif
Index: b/include/linux/preempt.h
===================================================================
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -22,7 +22,9 @@
 #define dec_preempt_count() sub_preempt_count(1)
 
 #define preempt_count()	(current_thread_info()->preempt_count)
+#ifdef CONFIG_PREEMPT_COUNT_CPU
 extern int preempt_count_cpu(int cpu);
+#endif
 
 #ifdef CONFIG_PREEMPT
 
Index: b/init/Kconfig
===================================================================
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -388,6 +388,7 @@ config JRCU
 	bool "A tiny single-CPU RCU for small SMP systems"
 	depends on PREEMPT
 	depends on SMP
+	select PREEMPT_COUNT_CPU
 	help
 	  This option selects a minimal-footprint RCU suitable for small SMP
 	  systems -- that is, those with fewer than 16 or perhaps 32, and
@@ -433,6 +434,16 @@ config JRCU_DAEMON
 	  Required. The context switch when leaving the daemon is needed
 	  to get the CPU to reliably participate in end-of-batch processing.
 
+config PREEMPT_COUNT_CPU
+	# bool "Let one CPU look at another CPUs preemption count"
+	bool
+	default n
+	help
+	  If Y then the preempt_count_cpu() function will be compiled into
+	  the kernel.  Its existance impacts kernel performance slightly,
+	  so this option should be selected only if other kernel features
+	  that use preempt_count_cpu() are also selected.
+
 config RCU_TRACE
 	bool "Enable tracing for RCU"
 	help
