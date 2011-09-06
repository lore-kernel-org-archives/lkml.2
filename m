Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab1IGGZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:25:15 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48853 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab1IGGVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:21:02 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/55] rcu: Restore checks for blocking in RCU read-side critical sections
Date: Tue,  6 Sep 2011 10:59:58 -0700
Message-Id: <1315332049-2604-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Long ago, using TREE_RCU with PREEMPT would result in "scheduling
while atomic" diagnostics if you blocked in an RCU read-side critical
section.  However, PREEMPT now implies TREE_PREEMPT_RCU, which defeats
this diagnostic.  This commit therefore adds a replacement diagnostic
based on PROVE_RCU.

Because rcu_lockdep_assert() and lockdep_rcu_dereference() are now being
used for things that have nothing to do with rcu_dereference(), rename
lockdep_rcu_dereference() to lockdep_rcu_suspicious() and add a third
argument that is a string indicating what is suspicious.  This third
argument is passed in from a new third argument to rcu_lockdep_assert().
Update all calls to rcu_lockdep_assert() to add an informative third
argument.

Also, add a pair of rcu_lockdep_assert() calls from within
rcu_note_context_switch(), one complaining if a context switch occurs
in an RCU-bh read-side critical section and another complaining if a
context switch occurs in an RCU-sched read-side critical section.
These are present only if the PROVE_RCU kernel parameter is enabled.

Finally, fix some checkpatch whitespace complaints in lockdep.c.

Again, you must enable PROVE_RCU to see these new diagnostics.  But you
are enabling PROVE_RCU to check out new RCU uses in any case, aren't you?

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/lockdep.h  |    2 +-
 include/linux/rcupdate.h |   28 ++++++++++++---
 kernel/lockdep.c         |   84 +++++++++++++++++++++++++--------------------
 kernel/pid.c             |    4 ++-
 kernel/sched.c           |    2 +
 5 files changed, 75 insertions(+), 45 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index ef820a3..b6a56e3 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -548,7 +548,7 @@ do {									\
 #endif
 
 #ifdef CONFIG_PROVE_RCU
-extern void lockdep_rcu_dereference(const char *file, const int line);
+void lockdep_rcu_suspicious(const char *file, const int line, const char *s);
 #endif
 
 #endif /* __LINUX_LOCKDEP_H */
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 99f9aa7..8be0433 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -297,19 +297,31 @@ extern int rcu_my_thread_group_empty(void);
 /**
  * rcu_lockdep_assert - emit lockdep splat if specified condition not met
  * @c: condition to check
+ * @s: informative message
  */
-#define rcu_lockdep_assert(c)						\
+#define rcu_lockdep_assert(c, s)					\
 	do {								\
 		static bool __warned;					\
 		if (debug_lockdep_rcu_enabled() && !__warned && !(c)) {	\
 			__warned = true;				\
-			lockdep_rcu_dereference(__FILE__, __LINE__);	\
+			lockdep_rcu_suspicious(__FILE__, __LINE__, s);	\
 		}							\
 	} while (0)
 
+#define rcu_sleep_check()						\
+	do {								\
+		rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map),	\
+				   "Illegal context switch in RCU-bh"	\
+				   " read-side critical section");	\
+		rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),	\
+				   "Illegal context switch in RCU-sched"\
+				   " read-side critical section");	\
+	} while (0)
+
 #else /* #ifdef CONFIG_PROVE_RCU */
 
-#define rcu_lockdep_assert(c) do { } while (0)
+#define rcu_lockdep_assert(c, s) do { } while (0)
+#define rcu_sleep_check() do { } while (0)
 
 #endif /* #else #ifdef CONFIG_PROVE_RCU */
 
@@ -338,14 +350,16 @@ extern int rcu_my_thread_group_empty(void);
 #define __rcu_dereference_check(p, c, space) \
 	({ \
 		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
-		rcu_lockdep_assert(c); \
+		rcu_lockdep_assert(c, "suspicious rcu_dereference_check()" \
+				      " usage"); \
 		rcu_dereference_sparse(p, space); \
 		smp_read_barrier_depends(); \
 		((typeof(*p) __force __kernel *)(_________p1)); \
 	})
 #define __rcu_dereference_protected(p, c, space) \
 	({ \
-		rcu_lockdep_assert(c); \
+		rcu_lockdep_assert(c, "suspicious rcu_dereference_protected()" \
+				      " usage"); \
 		rcu_dereference_sparse(p, space); \
 		((typeof(*p) __force __kernel *)(p)); \
 	})
@@ -359,7 +373,9 @@ extern int rcu_my_thread_group_empty(void);
 #define __rcu_dereference_index_check(p, c) \
 	({ \
 		typeof(p) _________p1 = ACCESS_ONCE(p); \
-		rcu_lockdep_assert(c); \
+		rcu_lockdep_assert(c, \
+				   "suspicious rcu_dereference_index_check()" \
+				   " usage"); \
 		smp_read_barrier_depends(); \
 		(_________p1); \
 	})
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 298c927..df2ad37 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1129,10 +1129,11 @@ print_circular_bug_header(struct lock_list *entry, unsigned int depth,
 	if (debug_locks_silent)
 		return 0;
 
-	printk("\n=======================================================\n");
-	printk(  "[ INFO: possible circular locking dependency detected ]\n");
+	printk("\n");
+	printk("======================================================\n");
+	printk("[ INFO: possible circular locking dependency detected ]\n");
 	print_kernel_version();
-	printk(  "-------------------------------------------------------\n");
+	printk("-------------------------------------------------------\n");
 	printk("%s/%d is trying to acquire lock:\n",
 		curr->comm, task_pid_nr(curr));
 	print_lock(check_src);
@@ -1463,11 +1464,12 @@ print_bad_irq_dependency(struct task_struct *curr,
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	printk("\n======================================================\n");
-	printk(  "[ INFO: %s-safe -> %s-unsafe lock order detected ]\n",
+	printk("\n");
+	printk("======================================================\n");
+	printk("[ INFO: %s-safe -> %s-unsafe lock order detected ]\n",
 		irqclass, irqclass);
 	print_kernel_version();
-	printk(  "------------------------------------------------------\n");
+	printk("------------------------------------------------------\n");
 	printk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] is trying to acquire:\n",
 		curr->comm, task_pid_nr(curr),
 		curr->hardirq_context, hardirq_count() >> HARDIRQ_SHIFT,
@@ -1692,10 +1694,11 @@ print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	printk("\n=============================================\n");
-	printk(  "[ INFO: possible recursive locking detected ]\n");
+	printk("\n");
+	printk("=============================================\n");
+	printk("[ INFO: possible recursive locking detected ]\n");
 	print_kernel_version();
-	printk(  "---------------------------------------------\n");
+	printk("---------------------------------------------\n");
 	printk("%s/%d is trying to acquire lock:\n",
 		curr->comm, task_pid_nr(curr));
 	print_lock(next);
@@ -2177,10 +2180,11 @@ print_usage_bug(struct task_struct *curr, struct held_lock *this,
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	printk("\n=================================\n");
-	printk(  "[ INFO: inconsistent lock state ]\n");
+	printk("\n");
+	printk("=================================\n");
+	printk("[ INFO: inconsistent lock state ]\n");
 	print_kernel_version();
-	printk(  "---------------------------------\n");
+	printk("---------------------------------\n");
 
 	printk("inconsistent {%s} -> {%s} usage.\n",
 		usage_str[prev_bit], usage_str[new_bit]);
@@ -2241,10 +2245,11 @@ print_irq_inversion_bug(struct task_struct *curr,
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	printk("\n=========================================================\n");
-	printk(  "[ INFO: possible irq lock inversion dependency detected ]\n");
+	printk("\n");
+	printk("=========================================================\n");
+	printk("[ INFO: possible irq lock inversion dependency detected ]\n");
 	print_kernel_version();
-	printk(  "---------------------------------------------------------\n");
+	printk("---------------------------------------------------------\n");
 	printk("%s/%d just changed the state of lock:\n",
 		curr->comm, task_pid_nr(curr));
 	print_lock(this);
@@ -3053,9 +3058,10 @@ print_unlock_inbalance_bug(struct task_struct *curr, struct lockdep_map *lock,
 	if (debug_locks_silent)
 		return 0;
 
-	printk("\n=====================================\n");
-	printk(  "[ BUG: bad unlock balance detected! ]\n");
-	printk(  "-------------------------------------\n");
+	printk("\n");
+	printk("=====================================\n");
+	printk("[ BUG: bad unlock balance detected! ]\n");
+	printk("-------------------------------------\n");
 	printk("%s/%d is trying to release lock (",
 		curr->comm, task_pid_nr(curr));
 	print_lockdep_cache(lock);
@@ -3460,9 +3466,10 @@ print_lock_contention_bug(struct task_struct *curr, struct lockdep_map *lock,
 	if (debug_locks_silent)
 		return 0;
 
-	printk("\n=================================\n");
-	printk(  "[ BUG: bad contention detected! ]\n");
-	printk(  "---------------------------------\n");
+	printk("\n");
+	printk("=================================\n");
+	printk("[ BUG: bad contention detected! ]\n");
+	printk("---------------------------------\n");
 	printk("%s/%d is trying to contend lock (",
 		curr->comm, task_pid_nr(curr));
 	print_lockdep_cache(lock);
@@ -3821,9 +3828,10 @@ print_freed_lock_bug(struct task_struct *curr, const void *mem_from,
 	if (debug_locks_silent)
 		return;
 
-	printk("\n=========================\n");
-	printk(  "[ BUG: held lock freed! ]\n");
-	printk(  "-------------------------\n");
+	printk("\n");
+	printk("=========================\n");
+	printk("[ BUG: held lock freed! ]\n");
+	printk("-------------------------\n");
 	printk("%s/%d is freeing memory %p-%p, with a lock still held there!\n",
 		curr->comm, task_pid_nr(curr), mem_from, mem_to-1);
 	print_lock(hlock);
@@ -3877,9 +3885,10 @@ static void print_held_locks_bug(struct task_struct *curr)
 	if (debug_locks_silent)
 		return;
 
-	printk("\n=====================================\n");
-	printk(  "[ BUG: lock held at task exit time! ]\n");
-	printk(  "-------------------------------------\n");
+	printk("\n");
+	printk("=====================================\n");
+	printk("[ BUG: lock held at task exit time! ]\n");
+	printk("-------------------------------------\n");
 	printk("%s/%d is exiting with locks still held!\n",
 		curr->comm, task_pid_nr(curr));
 	lockdep_print_held_locks(curr);
@@ -3973,16 +3982,17 @@ void lockdep_sys_exit(void)
 	if (unlikely(curr->lockdep_depth)) {
 		if (!debug_locks_off())
 			return;
-		printk("\n================================================\n");
-		printk(  "[ BUG: lock held when returning to user space! ]\n");
-		printk(  "------------------------------------------------\n");
+		printk("\n");
+		printk("================================================\n");
+		printk("[ BUG: lock held when returning to user space! ]\n");
+		printk("------------------------------------------------\n");
 		printk("%s/%d is leaving the kernel with locks still held!\n",
 				curr->comm, curr->pid);
 		lockdep_print_held_locks(curr);
 	}
 }
 
-void lockdep_rcu_dereference(const char *file, const int line)
+void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 {
 	struct task_struct *curr = current;
 
@@ -3991,15 +4001,15 @@ void lockdep_rcu_dereference(const char *file, const int line)
 		return;
 #endif /* #ifdef CONFIG_PROVE_RCU_REPEATEDLY */
 	/* Note: the following can be executed concurrently, so be careful. */
-	printk("\n===================================================\n");
-	printk(  "[ INFO: suspicious rcu_dereference_check() usage. ]\n");
-	printk(  "---------------------------------------------------\n");
-	printk("%s:%d invoked rcu_dereference_check() without protection!\n",
-			file, line);
+	printk("\n");
+	printk("===============================\n");
+	printk("[ INFO: suspicious RCU usage. ]\n");
+	printk("-------------------------------\n");
+	printk("%s:%d %s!\n", file, line, s);
 	printk("\nother info that might help us debug this:\n\n");
 	printk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
 	lockdep_print_held_locks(curr);
 	printk("\nstack backtrace:\n");
 	dump_stack();
 }
-EXPORT_SYMBOL_GPL(lockdep_rcu_dereference);
+EXPORT_SYMBOL_GPL(lockdep_rcu_suspicious);
diff --git a/kernel/pid.c b/kernel/pid.c
index 57a8346..a7577b3 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -419,7 +419,9 @@ EXPORT_SYMBOL(pid_task);
  */
 struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
 {
-	rcu_lockdep_assert(rcu_read_lock_held());
+	rcu_lockdep_assert(rcu_read_lock_held(),
+			   "find_task_by_pid_ns() needs rcu_read_lock()"
+			   " protection");
 	return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
 }
 
diff --git a/kernel/sched.c b/kernel/sched.c
index fde6ff9..1c87917 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4200,6 +4200,7 @@ static inline void schedule_debug(struct task_struct *prev)
 	 */
 	if (unlikely(in_atomic_preempt_off() && !prev->exit_state))
 		__schedule_bug(prev);
+	rcu_sleep_check();
 
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
 
@@ -8198,6 +8199,7 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 #ifdef in_atomic
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
+	rcu_sleep_check(); /* WARN_ON_ONCE() by default, no rate limit reqd. */
 	if ((preempt_count_equals(preempt_offset) && !irqs_disabled()) ||
 	    system_state != SYSTEM_RUNNING || oops_in_progress)
 		return;
-- 
1.7.3.2

