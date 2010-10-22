Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385Ab0JVU5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 16:57:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:36322 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694Ab0JVU5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 16:57:11 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 10/11] debug_core: refactor locking for master/slave cpus
Date: Fri, 22 Oct 2010 15:56:30 -0500
Message-Id: <1287780991-7476-11-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com>
References: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Oct 2010 20:56:56.0534 (UTC) FILETIME=[A9A25760:01CB722B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For quite some time there have been problems with memory barriers and
various races with NMI on multi processor systems using the kernel
debugger.  The algorithm for entering the kernel debug core and
resuming kernel execution was racy and had several known edge case
problems with attempting to debug something on a heavily loaded system
using breakpoints that are hit repeatedly and quickly.

The prior "locking" design entry worked as follows:

  * The atomic counter kgdb_active was used with atomic exchange in
    order to elect a master cpu out of all the cpus that may have
    taken a debug exception.
  * The master cpu increments all elements of passive_cpu_wait[].
  * The master cpu issues the round up cpus message.
  * Each "slave cpu" that enters the debug core increments its own
    element in cpu_in_kgdb[].
  * Each "slave cpu" spins on passive_cpu_wait[] until it becomes 0.
  * The master cpu debugs the system.

The new scheme removes the two arrays of atomic counters and replaces
them with 2 single counters.  One counter is used to count the number
of cpus waiting to become a master cpu (because one or more hit an
exception). The second counter is use to indicate how many cpus have
entered as slave cpus.

The new entry logic works as follows:

  * One or more cpus enters via kgdb_handle_exception() and increments
    the masters_in_kgdb. Each cpu attempts to get the spin lock called
    dbg_master_lock.
  * The master cpu sets kgdb_active to the current cpu.
  * The master cpu takes the spinlock dbg_slave_lock.
  * The master cpu asks to round up all the other cpus.
  * Each slave cpu that is not already in kgdb_handle_exception()
    will enter and increment slaves_in_kgdb.  Each slave will now spin
    try_locking on dbg_slave_lock.
  * The master cpu waits for the sum of masters_in_kgdb and slaves_in_kgdb
    to be equal to the sum of the online cpus.
  * The master cpu debugs the system.

In the new design the kgdb_active can only be changed while holding
dbg_master_lock.  Stress testing has not turned up any further
entry/exit races that existed in the prior locking design.  The prior
locking design suffered from atomic variables not being truly atomic
(in the capacity as used by kgdb) along with memory barrier races.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Dongdong Deng <dongdong.deng@windriver.com>
---
 kernel/debug/debug_core.c |  105 +++++++++++++++++++++++---------------------
 kernel/debug/debug_core.h |    1 +
 2 files changed, 56 insertions(+), 50 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index bb94977..26dbdc3 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -110,13 +110,15 @@ static struct kgdb_bkpt		kgdb_break[KGDB_MAX_BREAKPOINTS] = {
  */
 atomic_t			kgdb_active = ATOMIC_INIT(-1);
 EXPORT_SYMBOL_GPL(kgdb_active);
+static DEFINE_RAW_SPINLOCK(dbg_master_lock);
+static DEFINE_RAW_SPINLOCK(dbg_slave_lock);
 
 /*
  * We use NR_CPUs not PERCPU, in case kgdb is used to debug early
  * bootup code (which might not have percpu set up yet):
  */
-static atomic_t			passive_cpu_wait[NR_CPUS];
-static atomic_t			cpu_in_kgdb[NR_CPUS];
+static atomic_t			masters_in_kgdb;
+static atomic_t			slaves_in_kgdb;
 static atomic_t			kgdb_break_tasklet_var;
 atomic_t			kgdb_setting_breakpoint;
 
@@ -478,14 +480,23 @@ static void dbg_touch_watchdogs(void)
 	rcu_cpu_stall_reset();
 }
 
-static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs)
+static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs,
+		int exception_state)
 {
 	unsigned long flags;
 	int sstep_tries = 100;
 	int error;
-	int i, cpu;
+	int cpu;
 	int trace_on = 0;
+	int online_cpus = num_online_cpus();
 
+	kgdb_info[ks->cpu].enter_kgdb++;
+	kgdb_info[ks->cpu].exception_state |= exception_state;
+
+	if (exception_state == DCPU_WANT_MASTER)
+		atomic_inc(&masters_in_kgdb);
+	else
+		atomic_inc(&slaves_in_kgdb);
 	kgdb_disable_hw_debug(ks->linux_regs);
 
 acquirelock:
@@ -500,14 +511,15 @@ acquirelock:
 	kgdb_info[cpu].task = current;
 	kgdb_info[cpu].ret_state = 0;
 	kgdb_info[cpu].irq_depth = hardirq_count() >> HARDIRQ_SHIFT;
-	/*
-	 * Make sure the above info reaches the primary CPU before
-	 * our cpu_in_kgdb[] flag setting does:
-	 */
-	atomic_inc(&cpu_in_kgdb[cpu]);
 
-	if (exception_level == 1)
+	/* Make sure the above info reaches the primary CPU */
+	smp_mb();
+
+	if (exception_level == 1) {
+		if (raw_spin_trylock(&dbg_master_lock))
+			atomic_xchg(&kgdb_active, cpu);
 		goto cpu_master_loop;
+	}
 
 	/*
 	 * CPU will loop if it is a slave or request to become a kgdb
@@ -519,10 +531,12 @@ cpu_loop:
 			kgdb_info[cpu].exception_state &= ~DCPU_NEXT_MASTER;
 			goto cpu_master_loop;
 		} else if (kgdb_info[cpu].exception_state & DCPU_WANT_MASTER) {
-			if (atomic_cmpxchg(&kgdb_active, -1, cpu) == cpu)
+			if (raw_spin_trylock(&dbg_master_lock)) {
+				atomic_xchg(&kgdb_active, cpu);
 				break;
+			}
 		} else if (kgdb_info[cpu].exception_state & DCPU_IS_SLAVE) {
-			if (!atomic_read(&passive_cpu_wait[cpu]))
+			if (!raw_spin_is_locked(&dbg_slave_lock))
 				goto return_normal;
 		} else {
 return_normal:
@@ -533,7 +547,11 @@ return_normal:
 				arch_kgdb_ops.correct_hw_break();
 			if (trace_on)
 				tracing_on();
-			atomic_dec(&cpu_in_kgdb[cpu]);
+			kgdb_info[cpu].exception_state &=
+				~(DCPU_WANT_MASTER | DCPU_IS_SLAVE);
+			kgdb_info[cpu].enter_kgdb--;
+			smp_mb__before_atomic_dec();
+			atomic_dec(&slaves_in_kgdb);
 			dbg_touch_watchdogs();
 			local_irq_restore(flags);
 			return 0;
@@ -551,6 +569,7 @@ return_normal:
 	    (kgdb_info[cpu].task &&
 	     kgdb_info[cpu].task->pid != kgdb_sstep_pid) && --sstep_tries) {
 		atomic_set(&kgdb_active, -1);
+		raw_spin_unlock(&dbg_master_lock);
 		dbg_touch_watchdogs();
 		local_irq_restore(flags);
 
@@ -576,10 +595,8 @@ return_normal:
 	 * Get the passive CPU lock which will hold all the non-primary
 	 * CPU in a spin state while the debugger is active
 	 */
-	if (!kgdb_single_step) {
-		for (i = 0; i < NR_CPUS; i++)
-			atomic_inc(&passive_cpu_wait[i]);
-	}
+	if (!kgdb_single_step)
+		raw_spin_lock(&dbg_slave_lock);
 
 #ifdef CONFIG_SMP
 	/* Signal the other CPUs to enter kgdb_wait() */
@@ -590,10 +607,9 @@ return_normal:
 	/*
 	 * Wait for the other CPUs to be notified and be waiting for us:
 	 */
-	for_each_online_cpu(i) {
-		while (kgdb_do_roundup && !atomic_read(&cpu_in_kgdb[i]))
-			cpu_relax();
-	}
+	while (kgdb_do_roundup && (atomic_read(&masters_in_kgdb) +
+				atomic_read(&slaves_in_kgdb)) != online_cpus)
+		cpu_relax();
 
 	/*
 	 * At this point the primary processor is completely
@@ -634,24 +650,11 @@ cpu_master_loop:
 	if (dbg_io_ops->post_exception)
 		dbg_io_ops->post_exception();
 
-	atomic_dec(&cpu_in_kgdb[ks->cpu]);
-
 	if (!kgdb_single_step) {
-		for (i = NR_CPUS-1; i >= 0; i--)
-			atomic_dec(&passive_cpu_wait[i]);
-		/*
-		 * Wait till all the CPUs have quit from the debugger,
-		 * but allow a CPU that hit an exception and is
-		 * waiting to become the master to remain in the debug
-		 * core.
-		 */
-		for_each_online_cpu(i) {
-			while (kgdb_do_roundup &&
-			       atomic_read(&cpu_in_kgdb[i]) &&
-			       !(kgdb_info[i].exception_state &
-				 DCPU_WANT_MASTER))
-				cpu_relax();
-		}
+		raw_spin_unlock(&dbg_slave_lock);
+		/* Wait till all the CPUs have quit from the debugger. */
+		while (kgdb_do_roundup && atomic_read(&slaves_in_kgdb))
+			cpu_relax();
 	}
 
 kgdb_restore:
@@ -666,8 +669,15 @@ kgdb_restore:
 		arch_kgdb_ops.correct_hw_break();
 	if (trace_on)
 		tracing_on();
+
+	kgdb_info[cpu].exception_state &=
+		~(DCPU_WANT_MASTER | DCPU_IS_SLAVE);
+	kgdb_info[cpu].enter_kgdb--;
+	smp_mb__before_atomic_dec();
+	atomic_dec(&masters_in_kgdb);
 	/* Free kgdb_active */
 	atomic_set(&kgdb_active, -1);
+	raw_spin_unlock(&dbg_master_lock);
 	dbg_touch_watchdogs();
 	local_irq_restore(flags);
 
@@ -686,7 +696,6 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
 {
 	struct kgdb_state kgdb_var;
 	struct kgdb_state *ks = &kgdb_var;
-	int ret;
 
 	ks->cpu			= raw_smp_processor_id();
 	ks->ex_vector		= evector;
@@ -697,11 +706,10 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
 
 	if (kgdb_reenter_check(ks))
 		return 0; /* Ouch, double exception ! */
-	kgdb_info[ks->cpu].exception_state |= DCPU_WANT_MASTER;
-	ret = kgdb_cpu_enter(ks, regs);
-	kgdb_info[ks->cpu].exception_state &= ~(DCPU_WANT_MASTER |
-						DCPU_IS_SLAVE);
-	return ret;
+	if (kgdb_info[ks->cpu].enter_kgdb != 0)
+		return 0;
+
+	return kgdb_cpu_enter(ks, regs, DCPU_WANT_MASTER);
 }
 
 int kgdb_nmicallback(int cpu, void *regs)
@@ -714,12 +722,9 @@ int kgdb_nmicallback(int cpu, void *regs)
 	ks->cpu			= cpu;
 	ks->linux_regs		= regs;
 
-	if (!atomic_read(&cpu_in_kgdb[cpu]) &&
-	    atomic_read(&kgdb_active) != -1 &&
-	    atomic_read(&kgdb_active) != cpu) {
-		kgdb_info[cpu].exception_state |= DCPU_IS_SLAVE;
-		kgdb_cpu_enter(ks, regs);
-		kgdb_info[cpu].exception_state &= ~DCPU_IS_SLAVE;
+	if (kgdb_info[ks->cpu].enter_kgdb == 0 &&
+			raw_spin_is_locked(&dbg_master_lock)) {
+		kgdb_cpu_enter(ks, regs, DCPU_IS_SLAVE);
 		return 0;
 	}
 #endif
diff --git a/kernel/debug/debug_core.h b/kernel/debug/debug_core.h
index c5d753d..3494c28 100644
--- a/kernel/debug/debug_core.h
+++ b/kernel/debug/debug_core.h
@@ -40,6 +40,7 @@ struct debuggerinfo_struct {
 	int			exception_state;
 	int			ret_state;
 	int			irq_depth;
+	int			enter_kgdb;
 };
 
 extern struct debuggerinfo_struct kgdb_info[];
-- 
1.6.3.3

