Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab2BCBNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 20:13:30 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:53799 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550Ab2BCBN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 20:13:26 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: [PATCH RFC tip/core/rcu 1/3] rcu: Allow nesting of rcu_idle_enter() and rcu_idle_exit()
Date: Thu,  2 Feb 2012 17:12:46 -0800
Message-Id: <1328231568-2971-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20120203011208.GA2004@linux.vnet.ibm.com>
References: <20120203011208.GA2004@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020301-1780-0000-0000-000002D4E37D
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000245; HX=3.00000181; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00110417; UDB=6.00027440; UTC=2012-02-03
 01:13:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Use of RCU in the idle loop is incorrect, quite a few instances of
just that have made their way into mainline, primarily event tracing.
The problem with RCU read-side critical sections on CPUs that RCU believes
to be idle is that RCU is completely ignoring the CPU, along with any
attempts and RCU read-side critical sections.

The approaches of eliminating the offending uses and of pushing the
definition of idle down beyond the offending uses have both proved
impractical.  The new approach is to encapsulate offending uses of RCU
with rcu_idle_exit() and rcu_idle_enter(), but this requires nesting
for code that is invoked both during idle and and during normal execution.
Therefore, this commit modifies rcu_idle_enter() and rcu_idle_exit() to
permit nesting.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Conflicts:

	kernel/rcutree.c
---
 kernel/rcu.h     |   18 +++++++++++++++++-
 kernel/rcutiny.c |   16 ++++++++++++----
 kernel/rcutree.c |   19 +++++++++++++------
 3 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/kernel/rcu.h b/kernel/rcu.h
index 30876f4..0d0f9e8 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -33,8 +33,24 @@
  * Process-level increment to ->dynticks_nesting field.  This allows for
  * architectures that use half-interrupts and half-exceptions from
  * process context.
+ *
+ * DYNTICK_TASK_NESTING_MASK is a three-bit field that counts the number
+ * of process-based reasons why RCU cannot consider the corresponding CPU
+ * to be idle, and DYNTICK_TASK_NESTING_VALUE is the value used to increment
+ * or decrement this three-bit field.  The rest of the bits could in
+ * principle be used to count interrupts, but this would mean that a
+ * negative-one value in the interrupt field could incorrectly zero out
+ * the DYNTICK_TASK_NESTING_MASK field.  We therefore provide a two-bit
+ * guard field defined by DYNTICK_TASK_MASK that is set to DYNTICK_TASK_FLAG
+ * upon initial exit from idle.  The DYNTICK_TASK_EXIT_IDLE value is
+ * thus the combined value used upon initial exit from idle.
  */
-#define DYNTICK_TASK_NESTING (LLONG_MAX / 2 - 1)
+#define DYNTICK_TASK_NESTING_VALUE (LLONG_MAX / 8 + 1)
+#define DYNTICK_TASK_NESTING_MASK  (LLONG_MAX - DYNTICK_TASK_NESTING_VALUE + 1)
+#define DYNTICK_TASK_FLAG	   ((DYNTICK_TASK_NESTING_VALUE / 8) * 2)
+#define DYNTICK_TASK_MASK	   ((DYNTICK_TASK_NESTING_VALUE / 8) * 3)
+#define DYNTICK_TASK_EXIT_IDLE	   (DYNTICK_TASK_NESTING_VALUE + \
+				    DYNTICK_TASK_FLAG)
 
 /*
  * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 4eb34fc..5098aea 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -53,7 +53,7 @@ static void __call_rcu(struct rcu_head *head,
 
 #include "rcutiny_plugin.h"
 
-static long long rcu_dynticks_nesting = DYNTICK_TASK_NESTING;
+static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 
 /* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
 static void rcu_idle_enter_common(long long oldval)
@@ -88,7 +88,12 @@ void rcu_idle_enter(void)
 
 	local_irq_save(flags);
 	oldval = rcu_dynticks_nesting;
-	rcu_dynticks_nesting = 0;
+	WARN_ON_ONCE((rcu_dynticks_nesting & DYNTICK_TASK_NESTING_MASK) == 0);
+	if ((rcu_dynticks_nesting & DYNTICK_TASK_NESTING_MASK) ==
+	    DYNTICK_TASK_NESTING_VALUE)
+		rcu_dynticks_nesting = 0;
+	else
+		rcu_dynticks_nesting  -= DYNTICK_TASK_NESTING_VALUE;
 	rcu_idle_enter_common(oldval);
 	local_irq_restore(flags);
 }
@@ -140,8 +145,11 @@ void rcu_idle_exit(void)
 
 	local_irq_save(flags);
 	oldval = rcu_dynticks_nesting;
-	WARN_ON_ONCE(oldval != 0);
-	rcu_dynticks_nesting = DYNTICK_TASK_NESTING;
+	WARN_ON_ONCE(rcu_dynticks_nesting < 0);
+	if (rcu_dynticks_nesting & DYNTICK_TASK_NESTING_MASK)
+		rcu_dynticks_nesting += DYNTICK_TASK_NESTING_VALUE;
+	else
+		rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 	rcu_idle_exit_common(oldval);
 	local_irq_restore(flags);
 }
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index df0e3c1..e81298a 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -198,7 +198,7 @@ void rcu_note_context_switch(int cpu)
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
-	.dynticks_nesting = DYNTICK_TASK_NESTING,
+	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
 	.dynticks = ATOMIC_INIT(1),
 };
 
@@ -394,7 +394,11 @@ void rcu_idle_enter(void)
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
-	rdtp->dynticks_nesting = 0;
+	WARN_ON_ONCE((oldval & DYNTICK_TASK_NESTING_MASK) == 0);
+	if ((oldval & DYNTICK_TASK_NESTING_MASK) == DYNTICK_TASK_NESTING_VALUE)
+		rdtp->dynticks_nesting = 0;
+	else
+		rdtp->dynticks_nesting -= DYNTICK_TASK_NESTING_VALUE;
 	rcu_idle_enter_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
@@ -481,8 +485,11 @@ void rcu_idle_exit(void)
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
-	WARN_ON_ONCE(oldval != 0);
-	rdtp->dynticks_nesting = DYNTICK_TASK_NESTING;
+	WARN_ON_ONCE(oldval < 0);
+	if (oldval & DYNTICK_TASK_NESTING_MASK)
+		rdtp->dynticks_nesting += DYNTICK_TASK_NESTING_VALUE;
+	else
+		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 	rcu_idle_exit_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
@@ -2253,7 +2260,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->qlen_lazy = 0;
 	rdp->qlen = 0;
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
-	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_NESTING);
+	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_EXIT_IDLE);
 	WARN_ON_ONCE(atomic_read(&rdp->dynticks->dynticks) != 1);
 	rdp->cpu = cpu;
 	rdp->rsp = rsp;
@@ -2281,7 +2288,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	rdp->qlen_last_fqs_check = 0;
 	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
-	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_NESTING;
+	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 	atomic_set(&rdp->dynticks->dynticks,
 		   (atomic_read(&rdp->dynticks->dynticks) & ~0x1) + 1);
 	rcu_prepare_for_idle_init(cpu);
-- 
1.7.8

