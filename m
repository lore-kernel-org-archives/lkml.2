Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab2AENef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 08:34:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47977 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932324Ab2AENee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 08:34:34 -0500
Date: Thu, 5 Jan 2012 14:32:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/locking changes for v3.3
Message-ID: <20120105133232.GA26657@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-locking-for-linus

 Thanks,

	Ingo

------------------>
Ben Hutchings (2):
      lockdep, rtmutex, bug: Show taint flags on error
      lockdep, bug: Exclude TAINT_OOT_MODULE from disabling lock debugging

Ming Lei (2):
      init/main.c: Execute lockdep_init() as early as possible
      lockdep: Print lock name in lockdep_init_error()

Peter Zijlstra (2):
      lockdep, bug: Exclude TAINT_FIRMWARE_WORKAROUND from disabling lockdep
      lockdep/waitqueues: Add better annotation

Yong Zhang (2):
      lockdep: Always try to set ->class_cache in register_lock_class() lockdep_init_map()
      lockdep, kmemcheck: Annotate ->lock in lockdep_init_map()


 include/linux/wait.h   |    4 ++--
 init/main.c            |    3 +--
 kernel/lockdep.c       |   31 +++++++++++++++++++++----------
 kernel/panic.c         |   17 +++++++++++++----
 kernel/rtmutex-debug.c |    1 +
 kernel/wait.c          |    4 ++--
 6 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 3efc9f3..a9ce45e 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -77,13 +77,13 @@ struct task_struct;
 #define __WAIT_BIT_KEY_INITIALIZER(word, bit)				\
 	{ .flags = word, .bit_nr = bit, }
 
-extern void __init_waitqueue_head(wait_queue_head_t *q, struct lock_class_key *);
+extern void __init_waitqueue_head(wait_queue_head_t *q, const char *name, struct lock_class_key *);
 
 #define init_waitqueue_head(q)				\
 	do {						\
 		static struct lock_class_key __key;	\
 							\
-		__init_waitqueue_head((q), &__key);	\
+		__init_waitqueue_head((q), #q, &__key);	\
 	} while (0)
 
 #ifdef CONFIG_LOCKDEP
diff --git a/init/main.c b/init/main.c
index 217ed23..2c76efb 100644
--- a/init/main.c
+++ b/init/main.c
@@ -469,13 +469,12 @@ asmlinkage void __init start_kernel(void)
 	char * command_line;
 	extern const struct kernel_param __start___param[], __stop___param[];
 
-	smp_setup_processor_id();
-
 	/*
 	 * Need to run as early as possible, to initialize the
 	 * lockdep hash:
 	 */
 	lockdep_init();
+	smp_setup_processor_id();
 	debug_objects_early_init();
 
 	/*
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index b2e08c9..e69d633 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -431,6 +431,7 @@ unsigned int max_lockdep_depth;
  * about it later on, in lockdep_info().
  */
 static int lockdep_init_error;
+static const char *lock_init_error;
 static unsigned long lockdep_init_trace_data[20];
 static struct stack_trace lockdep_init_trace = {
 	.max_entries = ARRAY_SIZE(lockdep_init_trace_data),
@@ -568,11 +569,12 @@ static void lockdep_print_held_locks(struct task_struct *curr)
 	}
 }
 
-static void print_kernel_version(void)
+static void print_kernel_ident(void)
 {
-	printk("%s %.*s\n", init_utsname()->release,
+	printk("%s %.*s %s\n", init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version);
+		init_utsname()->version,
+		print_tainted());
 }
 
 static int very_verbose(struct lock_class *class)
@@ -656,6 +658,7 @@ look_up_lock_class(struct lockdep_map *lock, unsigned int subclass)
 	if (unlikely(!lockdep_initialized)) {
 		lockdep_init();
 		lockdep_init_error = 1;
+		lock_init_error = lock->name;
 		save_stack_trace(&lockdep_init_trace);
 	}
 #endif
@@ -723,7 +726,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 
 	class = look_up_lock_class(lock, subclass);
 	if (likely(class))
-		return class;
+		goto out_set_class_cache;
 
 	/*
 	 * Debug-check: all keys must be persistent!
@@ -808,6 +811,7 @@ out_unlock_set:
 	graph_unlock();
 	raw_local_irq_restore(flags);
 
+out_set_class_cache:
 	if (!subclass || force)
 		lock->class_cache[0] = class;
 	else if (subclass < NR_LOCKDEP_CACHING_CLASSES)
@@ -1149,7 +1153,7 @@ print_circular_bug_header(struct lock_list *entry, unsigned int depth,
 	printk("\n");
 	printk("======================================================\n");
 	printk("[ INFO: possible circular locking dependency detected ]\n");
-	print_kernel_version();
+	print_kernel_ident();
 	printk("-------------------------------------------------------\n");
 	printk("%s/%d is trying to acquire lock:\n",
 		curr->comm, task_pid_nr(curr));
@@ -1488,7 +1492,7 @@ print_bad_irq_dependency(struct task_struct *curr,
 	printk("======================================================\n");
 	printk("[ INFO: %s-safe -> %s-unsafe lock order detected ]\n",
 		irqclass, irqclass);
-	print_kernel_version();
+	print_kernel_ident();
 	printk("------------------------------------------------------\n");
 	printk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] is trying to acquire:\n",
 		curr->comm, task_pid_nr(curr),
@@ -1717,7 +1721,7 @@ print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
 	printk("\n");
 	printk("=============================================\n");
 	printk("[ INFO: possible recursive locking detected ]\n");
-	print_kernel_version();
+	print_kernel_ident();
 	printk("---------------------------------------------\n");
 	printk("%s/%d is trying to acquire lock:\n",
 		curr->comm, task_pid_nr(curr));
@@ -2224,7 +2228,7 @@ print_usage_bug(struct task_struct *curr, struct held_lock *this,
 	printk("\n");
 	printk("=================================\n");
 	printk("[ INFO: inconsistent lock state ]\n");
-	print_kernel_version();
+	print_kernel_ident();
 	printk("---------------------------------\n");
 
 	printk("inconsistent {%s} -> {%s} usage.\n",
@@ -2289,7 +2293,7 @@ print_irq_inversion_bug(struct task_struct *curr,
 	printk("\n");
 	printk("=========================================================\n");
 	printk("[ INFO: possible irq lock inversion dependency detected ]\n");
-	print_kernel_version();
+	print_kernel_ident();
 	printk("---------------------------------------------------------\n");
 	printk("%s/%d just changed the state of lock:\n",
 		curr->comm, task_pid_nr(curr));
@@ -3175,6 +3179,7 @@ print_unlock_inbalance_bug(struct task_struct *curr, struct lockdep_map *lock,
 	printk("\n");
 	printk("=====================================\n");
 	printk("[ BUG: bad unlock balance detected! ]\n");
+	print_kernel_ident();
 	printk("-------------------------------------\n");
 	printk("%s/%d is trying to release lock (",
 		curr->comm, task_pid_nr(curr));
@@ -3619,6 +3624,7 @@ print_lock_contention_bug(struct task_struct *curr, struct lockdep_map *lock,
 	printk("\n");
 	printk("=================================\n");
 	printk("[ BUG: bad contention detected! ]\n");
+	print_kernel_ident();
 	printk("---------------------------------\n");
 	printk("%s/%d is trying to contend lock (",
 		curr->comm, task_pid_nr(curr));
@@ -3974,7 +3980,8 @@ void __init lockdep_info(void)
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 	if (lockdep_init_error) {
-		printk("WARNING: lockdep init error! Arch code didn't call lockdep_init() early enough?\n");
+		printk("WARNING: lockdep init error! lock-%s was acquired"
+			"before lockdep_init\n", lock_init_error);
 		printk("Call stack leading to lockdep invocation was:\n");
 		print_stack_trace(&lockdep_init_trace, 0);
 	}
@@ -3993,6 +4000,7 @@ print_freed_lock_bug(struct task_struct *curr, const void *mem_from,
 	printk("\n");
 	printk("=========================\n");
 	printk("[ BUG: held lock freed! ]\n");
+	print_kernel_ident();
 	printk("-------------------------\n");
 	printk("%s/%d is freeing memory %p-%p, with a lock still held there!\n",
 		curr->comm, task_pid_nr(curr), mem_from, mem_to-1);
@@ -4050,6 +4058,7 @@ static void print_held_locks_bug(struct task_struct *curr)
 	printk("\n");
 	printk("=====================================\n");
 	printk("[ BUG: lock held at task exit time! ]\n");
+	print_kernel_ident();
 	printk("-------------------------------------\n");
 	printk("%s/%d is exiting with locks still held!\n",
 		curr->comm, task_pid_nr(curr));
@@ -4147,6 +4156,7 @@ void lockdep_sys_exit(void)
 		printk("\n");
 		printk("================================================\n");
 		printk("[ BUG: lock held when returning to user space! ]\n");
+		print_kernel_ident();
 		printk("------------------------------------------------\n");
 		printk("%s/%d is leaving the kernel with locks still held!\n",
 				curr->comm, curr->pid);
@@ -4166,6 +4176,7 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 	printk("\n");
 	printk("===============================\n");
 	printk("[ INFO: suspicious RCU usage. ]\n");
+	print_kernel_ident();
 	printk("-------------------------------\n");
 	printk("%s:%d %s!\n", file, line, s);
 	printk("\nother info that might help us debug this:\n\n");
diff --git a/kernel/panic.c b/kernel/panic.c
index b2659360..3458469 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -237,11 +237,20 @@ void add_taint(unsigned flag)
 	 * Can't trust the integrity of the kernel anymore.
 	 * We don't call directly debug_locks_off() because the issue
 	 * is not necessarily serious enough to set oops_in_progress to 1
-	 * Also we want to keep up lockdep for staging development and
-	 * post-warning case.
+	 * Also we want to keep up lockdep for staging/out-of-tree
+	 * development and post-warning case.
 	 */
-	if (flag != TAINT_CRAP && flag != TAINT_WARN && __debug_locks_off())
-		printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
+	switch (flag) {
+	case TAINT_CRAP:
+	case TAINT_OOT_MODULE:
+	case TAINT_WARN:
+	case TAINT_FIRMWARE_WORKAROUND:
+		break;
+
+	default:
+		if (__debug_locks_off())
+			printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
+	}
 
 	set_bit(flag, &tainted_mask);
 }
diff --git a/kernel/rtmutex-debug.c b/kernel/rtmutex-debug.c
index 8eafd1b..16502d3 100644
--- a/kernel/rtmutex-debug.c
+++ b/kernel/rtmutex-debug.c
@@ -101,6 +101,7 @@ void debug_rt_mutex_print_deadlock(struct rt_mutex_waiter *waiter)
 
 	printk("\n============================================\n");
 	printk(  "[ BUG: circular locking deadlock detected! ]\n");
+	printk("%s\n", print_tainted());
 	printk(  "--------------------------------------------\n");
 	printk("%s/%d is deadlocking current task %s/%d\n\n",
 	       task->comm, task_pid_nr(task),
diff --git a/kernel/wait.c b/kernel/wait.c
index 26fa779..7fdd9ea 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -10,10 +10,10 @@
 #include <linux/wait.h>
 #include <linux/hash.h>
 
-void __init_waitqueue_head(wait_queue_head_t *q, struct lock_class_key *key)
+void __init_waitqueue_head(wait_queue_head_t *q, const char *name, struct lock_class_key *key)
 {
 	spin_lock_init(&q->lock);
-	lockdep_set_class(&q->lock, key);
+	lockdep_set_class_and_name(&q->lock, key, name);
 	INIT_LIST_HEAD(&q->task_list);
 }
 

