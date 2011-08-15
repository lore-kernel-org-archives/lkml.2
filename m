Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab1HOQnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 12:43:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45464 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab1HOQnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 12:43:16 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=IDWtwbh4UWQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=YdSgsZ06l0Q__kDHXZYA:9 a=fxWA9VXx4Jy9p42r-UcA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [RFC][PATCH] lockdep/rcu: Find where rcu/pi/rq lock problems occur
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 15 Aug 2011 12:43:13 -0400
Message-ID: <1313426593.15704.16.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been talking with Paul about what can trigger the problems with
rcu_read_unlock_special(). He told me the following is bad and can cause
lockdep to spit out problems if they happen. They are:


rcu_read_lock();
irqs enabled anywhere here
rq/pi_lock();
rcu_read_unlock();


That is, if rcu_read_lock() has interrupts enabled anywhere in the rcu
critical section, and then it takes either the rq or pi_lock, and then
releases the rcu_read_lock() (outer most nesting), we can trigger a case
where rcu_read_unlock_special() can deadlock with either rq or pi_lock.

This patch adds a state flag to the task_struct and uses that to detect
if this case happens. It then reports where interrupts were enabled, as
well as where the rq and pi_lock was taken.

This is just an RFC, and probably could use some more clean ups,
especially around the comments, as I stopped updating the comments while
developing this patch ;)

-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index ef820a3..1392c91 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -394,6 +394,16 @@ struct lock_class_key { };
 
 #endif /* !LOCKDEP */
 
+#if defined(CONFIG_LOCKDEP) && defined(CONFIG_PREEMPT_RCU)
+extern void lockdep_set_pi_lock(struct lock_class_key *key);
+extern void lockdep_set_rqlock(struct lock_class_key *key);
+extern void lockdep_rcu(int enter);
+#else
+#define lockdep_set_pi_lock(key)
+#define lockdep_set_rqlock(key)
+static inline void lockdep_rcu(int enter) { }
+#endif
+
 #ifdef CONFIG_LOCK_STAT
 
 extern void lock_contended(struct lockdep_map *lock, unsigned long ip);
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 8ca18f2..b5a7d1f 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -618,6 +618,7 @@ static inline void rcu_read_lock(void)
 	__rcu_read_lock();
 	__acquire(RCU);
 	rcu_read_acquire();
+	lockdep_rcu(1);
 }
 
 /*
@@ -637,6 +638,7 @@ static inline void rcu_read_lock(void)
  */
 static inline void rcu_read_unlock(void)
 {
+	lockdep_rcu(0);
 	rcu_read_release();
 	__release(RCU);
 	__rcu_read_unlock();
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d9ce827..71daf8b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1221,6 +1221,8 @@ enum perf_event_task_context {
 	perf_nr_task_contexts,
 };
 
+#define LOCKDEP_RCU_STACK_DEPTH 8
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	volatile long saved_state;	/* saved state for "spinlock sleepers" */
@@ -1469,6 +1471,10 @@ struct task_struct {
 	unsigned int lockdep_recursion;
 	struct held_lock held_locks[MAX_LOCK_DEPTH];
 	gfp_t lockdep_reclaim_gfp;
+	unsigned long lockdep_rcu_state;
+	unsigned long lockdep_rcu_rq_stack[LOCKDEP_RCU_STACK_DEPTH];
+	unsigned long lockdep_rcu_pi_stack[LOCKDEP_RCU_STACK_DEPTH];
+	unsigned long lockdep_rcu_irq_stack[LOCKDEP_RCU_STACK_DEPTH];
 #endif
 
 /* journalling filesystem info */
diff --git a/kernel/fork.c b/kernel/fork.c
index aa5fe26..ffebee0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1036,6 +1036,7 @@ SYSCALL_DEFINE1(set_tid_address, int __user *, tidptr)
 static void rt_mutex_init_task(struct task_struct *p)
 {
 	raw_spin_lock_init(&p->pi_lock);
+	lockdep_set_pi_lock(p->pi_lock.dep_map.key);
 #ifdef CONFIG_RT_MUTEXES
 	plist_head_init_raw(&p->pi_waiters, &p->pi_lock);
 	p->pi_blocked_on = NULL;
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index a8d5a46..20ee620 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -66,6 +66,185 @@ module_param(lock_stat, int, 0644);
 #define lock_stat 0
 #endif
 
+#ifdef CONFIG_PREEMPT_RCU
+static struct lock_class_key *pi_lock_class;
+static struct lock_class_key *rq_lock_class;
+
+static int lockdep_rcu_err;
+
+#define LOCKDEP_RCU_WARN(cond) ({					\
+	int ___ret = (cond);						\
+	if (!lockdep_rcu_err && ___ret) {				\
+		lockdep_rcu_err = 1;					\
+		printk(KERN_WARNING "RCU lockdep debugging error"	\
+		       " state=0x%lx\n", current->lockdep_rcu_state);	\
+		WARN_ON(1);						\
+	}								\
+	___ret;								\
+		})
+
+
+void lockdep_set_pi_lock(struct lock_class_key *key)
+{
+	if (!pi_lock_class)
+		pi_lock_class = key;
+}
+
+void lockdep_set_rqlock(struct lock_class_key *key)
+{
+	if (!rq_lock_class)
+		rq_lock_class = key;
+}
+
+/*
+ * Due to RCU boosting, the following lock sequence is not allowed:
+ *
+ * rcu_read_lock();
+ * spin_lock(rq->lock);
+ * rcu_read_unlock();
+ *
+ * The same is true if you substitute the above rq->lock with pi_lock.
+ *
+ * To detect this, the task_struct->lockdep_rcu_state is used to
+ * maintain state.
+ *
+ * The states are:
+ *
+ * 0: no locks
+ *    rcu_read_lock   - goto state 1
+ *
+ * 1: rcu_read_unlock - goto state 0
+ *    lock spinlock   - goto state 2
+ *
+ * 2: rcu_read_unlock - goto bug
+ *    unlock spinlock - goto state 1
+ *
+ * Since rq_lock can be nested inside pi_lock, we still need
+ * to differentiate the two. Thus state 2 is for rq_lock
+ * and state 4 is for pi_lock, and they are set via bits.
+ * thus state 2 for rq_lock will be represented by 3 (bits
+ * 1 and 2 set), and pi_lock will be represted by 5 (bits
+ * 1 and 3 set).
+ */
+
+enum {
+	LD_RCU_ACTIVE		= 1,
+	LD_RCU_RQ_LOCK		= 2,
+	LD_RCU_PI_LOCK		= 4,
+	LD_RCU_IRQ_ENABLED	= 8,
+};
+
+#define LD_RCU_LOCKS	(LD_RCU_RQ_LOCK | LD_RCU_PI_LOCK)
+
+static void lockdep_rcu_save_stack(unsigned long *stack)
+{
+	struct stack_trace trace;
+
+	trace.nr_entries = 0;
+	trace.max_entries = LOCKDEP_RCU_STACK_DEPTH;
+	trace.entries = stack;
+
+	trace.skip = 3;
+
+	save_stack_trace(&trace);
+}
+
+static void print_lockdep_rcu_stack(unsigned long *stack)
+{
+	int i;
+
+	for (i = 0; stack[i] != -1 && i < LOCKDEP_RCU_STACK_DEPTH; i++) {
+		printk("  %pS <%lx>\n", (void *)stack[i], stack[i]);
+	}
+}
+
+static void test_lock_type(struct lock_class_key *key, int lock)
+{
+	unsigned long state;
+
+	if (!current->lockdep_rcu_state)
+		return;
+
+	if (key == rq_lock_class) {
+		lockdep_rcu_save_stack(current->lockdep_rcu_rq_stack);
+		state = LD_RCU_RQ_LOCK;
+	} else if (key == pi_lock_class) {
+		lockdep_rcu_save_stack(current->lockdep_rcu_pi_stack);
+		state = LD_RCU_PI_LOCK;
+	} else
+		return;
+
+	if (lock)
+		current->lockdep_rcu_state |= state;
+        else
+		current->lockdep_rcu_state &= ~state;
+}
+
+static void lockdep_rcu_bug(unsigned long state)
+{
+	if (lockdep_rcu_err)
+		return;
+
+	lockdep_rcu_err = 1;
+	printk(KERN_WARNING "lockdep: Found dangerous rcu locking");
+	if (state & 2)
+		printk(KERN_CONT " with rq locks");
+	else
+		printk(KERN_CONT " with pi locks");
+	printk(KERN_CONT " (%lx)\n", current->lockdep_rcu_state);
+	printk(KERN_CONT "IRQS enabled at:\n");
+	print_lockdep_rcu_stack(current->lockdep_rcu_irq_stack);
+	if (current->lockdep_rcu_state & LD_RCU_RQ_LOCK) {
+		printk("rq_lock taken at:\n");
+		print_lockdep_rcu_stack(current->lockdep_rcu_rq_stack);
+	}
+	if (current->lockdep_rcu_state & LD_RCU_PI_LOCK) {
+		printk("pi_lock taken at:\n");
+		print_lockdep_rcu_stack(current->lockdep_rcu_pi_stack);
+	}
+
+	WARN_ON(1);
+}
+
+void lockdep_rcu(int enter)
+{
+	if (current->rcu_read_lock_nesting != 1)
+		return;
+
+	if (enter) {
+		LOCKDEP_RCU_WARN(current->lockdep_rcu_state);
+		current->lockdep_rcu_state = LD_RCU_ACTIVE;
+		if (!irqs_disabled()) {
+			lockdep_rcu_save_stack(current->lockdep_rcu_irq_stack);
+			current->lockdep_rcu_state |= LD_RCU_IRQ_ENABLED;
+		}
+		return;
+	}
+
+	if (current->lockdep_rcu_state & LD_RCU_LOCKS &&
+	    current->lockdep_rcu_state & LD_RCU_IRQ_ENABLED)
+		lockdep_rcu_bug(current->lockdep_rcu_state);
+
+	current->lockdep_rcu_state = 0;
+}
+EXPORT_SYMBOL(lockdep_rcu);
+
+static void lockdep_rcu_irq(int on)
+{
+	if (!(current->lockdep_rcu_state & LD_RCU_ACTIVE))
+		return;
+
+	if (on) {
+		lockdep_rcu_save_stack(current->lockdep_rcu_irq_stack);
+		current->lockdep_rcu_state |= LD_RCU_IRQ_ENABLED;
+	}
+}
+
+#else /* CONFIG_PREEMPT_RCU */
+static inline void lockdep_rcu_irq(int on) { }
+#endif
+
+
 /*
  * lockdep_lock: protects the lockdep graph, the hashes and the
  *               class/list/hash allocators.
@@ -2484,6 +2663,8 @@ void trace_hardirqs_on_caller(unsigned long ip)
 
 	time_hardirqs_on(CALLER_ADDR0, ip);
 
+	lockdep_rcu_irq(1);
+
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
 
@@ -2540,6 +2721,8 @@ void trace_hardirqs_off_caller(unsigned long ip)
 {
 	struct task_struct *curr = current;
 
+	lockdep_rcu_irq(0);
+
 	time_hardirqs_off(CALLER_ADDR0, ip);
 
 	if (unlikely(!debug_locks || current->lockdep_recursion))
@@ -3392,6 +3575,7 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	raw_local_irq_save(flags);
 	check_flags(flags);
 
+	test_lock_type(lock->key, 1);
 	current->lockdep_recursion = 1;
 	trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
 	__lock_acquire(lock, subclass, trylock, read, check,
@@ -3415,6 +3599,7 @@ void lock_release(struct lockdep_map *lock, int nested,
 	trace_lock_release(lock, ip);
 	__lock_release(lock, nested, ip);
 	current->lockdep_recursion = 0;
+	test_lock_type(lock->key, 0);
 	raw_local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(lock_release);
diff --git a/kernel/sched.c b/kernel/sched.c
index ffd6bd4..4b6ce8c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8231,6 +8231,7 @@ void __init sched_init(void)
 
 		rq = cpu_rq(i);
 		raw_spin_lock_init(&rq->lock);
+		lockdep_set_rqlock(rq->lock.dep_map.key);
 		rq->nr_running = 0;
 		rq->calc_load_active = 0;
 		rq->calc_load_update = jiffies + LOAD_FREQ;


