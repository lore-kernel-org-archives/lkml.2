Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab2JPRGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:06:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24105 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab2JPRGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:06:10 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=p1Vzg5AezZCuCwwaKnAA:9 a=QEXdDO2ut3YA:10 a=olm625cWNCFFATAe:21 a=5t0KMTfnhLCv06HB:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Subject: [ANNOUNCE] 3.4.13-rt22
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Oct 2012 13:06:05 -0400
Message-ID: <1350407165.19292.19.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.4.13-rt22 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: be16a1145ed848b4e96e70cba6e0f8e4a68a255d


Or to build 3.4.13-rt22 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.4.13.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4.13-rt22.patch.xz


You can also build from 3.4.13-rt21 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/incr/patch-3.4.13-rt21-rt22.patch.xz



Enjoy,

-- Steve


Changes from 3.4.13-rt21:

---

Steven Rostedt (2):
      softirq: Init softirq local lock after per cpu section is set up
      Linux 3.4.13-rt22

Thomas Gleixner (6):
      random: Make it work on rt
      mm: slab: Fix potential deadlock
      mm: page_alloc: Use local_lock_on() instead of plain spinlock
      rt: rwsem/rwlock: lockdep annotations
      sched: Better debug output for might sleep
      stomp_machine: Use mutex_trylock when called from inactive cpu

----
 drivers/char/random.c     |   10 ++++++----
 include/linux/irqdesc.h   |    1 +
 include/linux/locallock.h |   19 +++++++++++++++++++
 include/linux/random.h    |    2 +-
 include/linux/sched.h     |    4 ++++
 init/main.c               |    2 +-
 kernel/irq/handle.c       |    7 +++++--
 kernel/irq/manage.c       |    6 ++++++
 kernel/rt.c               |   46 ++++++++++++++++++++++++---------------------
 kernel/sched/core.c       |   23 +++++++++++++++++++++--
 kernel/stop_machine.c     |   13 +++++++++----
 localversion-rt           |    2 +-
 mm/page_alloc.c           |    4 ++--
 mm/slab.c                 |   10 ++--------
 14 files changed, 103 insertions(+), 46 deletions(-)
---------------------------
diff --git a/drivers/char/random.c b/drivers/char/random.c
index feae549..f786798 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -745,18 +745,16 @@ EXPORT_SYMBOL_GPL(add_input_randomness);
 
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
 
-void add_interrupt_randomness(int irq, int irq_flags)
+void add_interrupt_randomness(int irq, int irq_flags, __u64 ip)
 {
 	struct entropy_store	*r;
 	struct fast_pool	*fast_pool = &__get_cpu_var(irq_randomness);
-	struct pt_regs		*regs = get_irq_regs();
 	unsigned long		now = jiffies;
 	__u32			input[4], cycles = get_cycles();
 
 	input[0] = cycles ^ jiffies;
 	input[1] = irq;
-	if (regs) {
-		__u64 ip = instruction_pointer(regs);
+	if (ip) {
 		input[2] = ip;
 		input[3] = ip >> 32;
 	}
@@ -770,7 +768,11 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	fast_pool->last = now;
 
 	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
+#ifndef CONFIG_PREEMPT_RT_FULL
 	__mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool), NULL);
+#else
+	mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool), NULL);
+#endif
 	/*
 	 * If we don't have a valid cycle counter, and we see
 	 * back-to-back timer interrupts, then skip giving credit for
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 9a323d1..5bf5add 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -52,6 +52,7 @@ struct irq_desc {
 	unsigned int		irq_count;	/* For detecting broken IRQs */
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	unsigned int		irqs_unhandled;
+	u64			random_ip;
 	raw_spinlock_t		lock;
 	struct cpumask		*percpu_enabled;
 #ifdef CONFIG_SMP
diff --git a/include/linux/locallock.h b/include/linux/locallock.h
index 8fbc393..f1804a3 100644
--- a/include/linux/locallock.h
+++ b/include/linux/locallock.h
@@ -96,6 +96,9 @@ static inline void __local_lock_irq(struct local_irq_lock *lv)
 #define local_lock_irq(lvar)						\
 	do { __local_lock_irq(&get_local_var(lvar)); } while (0)
 
+#define local_lock_irq_on(lvar, cpu)					\
+	do { __local_lock_irq(&per_cpu(lvar, cpu)); } while (0)
+
 static inline void __local_unlock_irq(struct local_irq_lock *lv)
 {
 	LL_WARN(!lv->nestcnt);
@@ -111,6 +114,11 @@ static inline void __local_unlock_irq(struct local_irq_lock *lv)
 		put_local_var(lvar);					\
 	} while (0)
 
+#define local_unlock_irq_on(lvar, cpu)					\
+	do {								\
+		__local_unlock_irq(&per_cpu(lvar, cpu));		\
+	} while (0)
+
 static inline int __local_lock_irqsave(struct local_irq_lock *lv)
 {
 	if (lv->owner != current) {
@@ -129,6 +137,12 @@ static inline int __local_lock_irqsave(struct local_irq_lock *lv)
 		_flags = __get_cpu_var(lvar).flags;			\
 	} while (0)
 
+#define local_lock_irqsave_on(lvar, _flags, cpu)			\
+	do {								\
+		__local_lock_irqsave(&per_cpu(lvar, cpu));		\
+		_flags = per_cpu(lvar, cpu).flags;			\
+	} while (0)
+
 static inline int __local_unlock_irqrestore(struct local_irq_lock *lv,
 					    unsigned long flags)
 {
@@ -148,6 +162,11 @@ static inline int __local_unlock_irqrestore(struct local_irq_lock *lv,
 			put_local_var(lvar);				\
 	} while (0)
 
+#define local_unlock_irqrestore_on(lvar, flags, cpu)			\
+	do {								\
+		__local_unlock_irqrestore(&per_cpu(lvar, cpu), flags);	\
+	} while (0)
+
 #define local_spin_trylock_irq(lvar, lock)				\
 	({								\
 		int __locked;						\
diff --git a/include/linux/random.h b/include/linux/random.h
index ac621ce..9ae01e2 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -51,7 +51,7 @@ struct rnd_state {
 extern void add_device_randomness(const void *, unsigned int);
 extern void add_input_randomness(unsigned int type, unsigned int code,
 				 unsigned int value);
-extern void add_interrupt_randomness(int irq, int irq_flags);
+extern void add_interrupt_randomness(int irq, int irq_flags, __u64 ip);
 
 extern void get_random_bytes(void *buf, int nbytes);
 extern void get_random_bytes_arch(void *buf, int nbytes);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6f342d8..f291347 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1655,6 +1655,10 @@ struct task_struct {
 	int kmap_idx;
 	pte_t kmap_pte[KM_TYPE_NR];
 #endif
+
+#ifdef CONFIG_DEBUG_PREEMPT
+	unsigned long preempt_disable_ip;
+#endif
 };
 
 #ifdef CONFIG_PREEMPT_RT_FULL
diff --git a/init/main.c b/init/main.c
index f07f2b0..cee1a91 100644
--- a/init/main.c
+++ b/init/main.c
@@ -490,7 +490,6 @@ asmlinkage void __init start_kernel(void)
  * Interrupts are still disabled. Do necessary setups, then
  * enable them
  */
-	softirq_early_init();
 	tick_init();
 	boot_cpu_init();
 	page_address_init();
@@ -501,6 +500,7 @@ asmlinkage void __init start_kernel(void)
 	setup_command_line(command_line);
 	setup_nr_cpu_ids();
 	setup_per_cpu_areas();
+	softirq_early_init();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 
 	build_all_zonelists(NULL);
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 311c4e6..7f50c55 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -132,6 +132,8 @@ static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 irqreturn_t
 handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 {
+	struct pt_regs *regs = get_irq_regs();
+	u64 ip = regs ? instruction_pointer(regs) : 0;
 	irqreturn_t retval = IRQ_NONE;
 	unsigned int flags = 0, irq = desc->irq_data.irq;
 
@@ -173,8 +175,9 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 	} while (action);
 
 #ifndef CONFIG_PREEMPT_RT_FULL
-	/* FIXME: Can we unbreak that ? */
-	add_interrupt_randomness(irq, flags);
+	add_interrupt_randomness(irq, flags, ip);
+#else
+	desc->random_ip = ip;
 #endif
 
 	if (!noirqdebug)
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index ede56ac..90bf44a 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -814,6 +814,12 @@ static int irq_thread(void *data)
 		if (!noirqdebug)
 			note_interrupt(action->irq, desc, action_ret);
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+		migrate_disable();
+		add_interrupt_randomness(action->irq, 0,
+					 desc->random_ip ^ (u64) action);
+		migrate_enable();
+#endif
 		wake_threads_waitq(desc);
 	}
 
diff --git a/kernel/rt.c b/kernel/rt.c
index 092d6b3..aa10504 100644
--- a/kernel/rt.c
+++ b/kernel/rt.c
@@ -216,15 +216,17 @@ int __lockfunc rt_read_trylock(rwlock_t *rwlock)
 	 * write locked.
 	 */
 	migrate_disable();
-	if (rt_mutex_owner(lock) != current)
+	if (rt_mutex_owner(lock) != current) {
 		ret = rt_mutex_trylock(lock);
-	else if (!rwlock->read_depth)
+		if (ret)
+			rwlock_acquire(&rwlock->dep_map, 0, 1, _RET_IP_);
+	} else if (!rwlock->read_depth) {
 		ret = 0;
+	}
 
-	if (ret) {
+	if (ret)
 		rwlock->read_depth++;
-		rwlock_acquire_read(&rwlock->dep_map, 0, 1, _RET_IP_);
-	} else
+	else
 		migrate_enable();
 
 	return ret;
@@ -242,13 +244,13 @@ void __lockfunc rt_read_lock(rwlock_t *rwlock)
 {
 	struct rt_mutex *lock = &rwlock->lock;
 
-	rwlock_acquire_read(&rwlock->dep_map, 0, 0, _RET_IP_);
-
 	/*
 	 * recursive read locks succeed when current owns the lock
 	 */
-	if (rt_mutex_owner(lock) != current)
+	if (rt_mutex_owner(lock) != current) {
+		rwlock_acquire(&rwlock->dep_map, 0, 0, _RET_IP_);
 		__rt_spin_lock(lock);
+	}
 	rwlock->read_depth++;
 }
 
@@ -264,11 +266,11 @@ EXPORT_SYMBOL(rt_write_unlock);
 
 void __lockfunc rt_read_unlock(rwlock_t *rwlock)
 {
-	rwlock_release(&rwlock->dep_map, 1, _RET_IP_);
-
 	/* Release the lock only when read_depth is down to 0 */
-	if (--rwlock->read_depth == 0)
+	if (--rwlock->read_depth == 0) {
+		rwlock_release(&rwlock->dep_map, 1, _RET_IP_);
 		__rt_spin_unlock(&rwlock->lock);
+	}
 }
 EXPORT_SYMBOL(rt_read_unlock);
 
@@ -315,9 +317,10 @@ EXPORT_SYMBOL(rt_up_write);
 
 void  rt_up_read(struct rw_semaphore *rwsem)
 {
-	rwsem_release(&rwsem->dep_map, 1, _RET_IP_);
-	if (--rwsem->read_depth == 0)
+	if (--rwsem->read_depth == 0) {
+		rwsem_release(&rwsem->dep_map, 1, _RET_IP_);
 		rt_mutex_unlock(&rwsem->lock);
+	}
 }
 EXPORT_SYMBOL(rt_up_read);
 
@@ -366,15 +369,16 @@ int  rt_down_read_trylock(struct rw_semaphore *rwsem)
 	 * but not when read_depth == 0 which means that the rwsem is
 	 * write locked.
 	 */
-	if (rt_mutex_owner(lock) != current)
+	if (rt_mutex_owner(lock) != current) {
 		ret = rt_mutex_trylock(&rwsem->lock);
-	else if (!rwsem->read_depth)
+		if (ret)
+			rwsem_acquire(&rwsem->dep_map, 0, 1, _RET_IP_);
+	} else if (!rwsem->read_depth) {
 		ret = 0;
+	}
 
-	if (ret) {
+	if (ret)
 		rwsem->read_depth++;
-		rwsem_acquire(&rwsem->dep_map, 0, 1, _RET_IP_);
-	}
 	return ret;
 }
 EXPORT_SYMBOL(rt_down_read_trylock);
@@ -383,10 +387,10 @@ static void __rt_down_read(struct rw_semaphore *rwsem, int subclass)
 {
 	struct rt_mutex *lock = &rwsem->lock;
 
-	rwsem_acquire_read(&rwsem->dep_map, subclass, 0, _RET_IP_);
-
-	if (rt_mutex_owner(lock) != current)
+	if (rt_mutex_owner(lock) != current) {
+		rwsem_acquire(&rwsem->dep_map, subclass, 0, _RET_IP_);
 		rt_mutex_lock(&rwsem->lock);
+	}
 	rwsem->read_depth++;
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 66d4dea..263fd96 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3215,8 +3215,13 @@ void __kprobes add_preempt_count(int val)
 	DEBUG_LOCKS_WARN_ON((preempt_count() & PREEMPT_MASK) >=
 				PREEMPT_MASK - 10);
 #endif
-	if (preempt_count() == val)
-		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
+	if (preempt_count() == val) {
+		unsigned long ip = get_parent_ip(CALLER_ADDR1);
+#ifdef CONFIG_DEBUG_PREEMPT
+		current->preempt_disable_ip = ip;
+#endif
+		trace_preempt_off(CALLER_ADDR0, ip);
+	}
 }
 EXPORT_SYMBOL(add_preempt_count);
 
@@ -3259,6 +3264,13 @@ static noinline void __schedule_bug(struct task_struct *prev)
 	print_modules();
 	if (irqs_disabled())
 		print_irqtrace_events(prev);
+#ifdef DEBUG_PREEMPT
+	if (in_atomic_preempt_off()) {
+		pr_err("Preemption disabled at:");
+		print_ip_sym(current->preempt_disable_ip);
+		pr_cont("\n");
+	}
+#endif
 	dump_stack();
 }
 
@@ -7479,6 +7491,13 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 	debug_show_held_locks(current);
 	if (irqs_disabled())
 		print_irqtrace_events(current);
+#ifdef DEBUG_PREEMPT
+	if (!preempt_count_equals(preempt_offset)) {
+		pr_err("Preemption disabled at:");
+		print_ip_sym(current->preempt_disable_ip);
+		pr_cont("\n");
+	}
+#endif
 	dump_stack();
 }
 EXPORT_SYMBOL(__might_sleep);
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 561ba3a..e98c70b 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -158,7 +158,7 @@ static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
 
 static void queue_stop_cpus_work(const struct cpumask *cpumask,
 				 cpu_stop_fn_t fn, void *arg,
-				 struct cpu_stop_done *done)
+				 struct cpu_stop_done *done, bool inactive)
 {
 	struct cpu_stop_work *work;
 	unsigned int cpu;
@@ -175,7 +175,12 @@ static void queue_stop_cpus_work(const struct cpumask *cpumask,
 	 * Make sure that all work is queued on all cpus before we
 	 * any of the cpus can execute it.
 	 */
-	mutex_lock(&stopper_lock);
+	if (!inactive) {
+		mutex_lock(&stopper_lock);
+	} else {
+		while (!mutex_trylock(&stopper_lock))
+			cpu_relax();
+	}
 	for_each_cpu(cpu, cpumask)
 		cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu),
 				    &per_cpu(stop_cpus_work, cpu));
@@ -188,7 +193,7 @@ static int __stop_cpus(const struct cpumask *cpumask,
 	struct cpu_stop_done done;
 
 	cpu_stop_init_done(&done, cpumask_weight(cpumask));
-	queue_stop_cpus_work(cpumask, fn, arg, &done);
+	queue_stop_cpus_work(cpumask, fn, arg, &done, false);
 	wait_for_stop_done(&done);
 	return done.executed ? done.ret : -ENOENT;
 }
@@ -601,7 +606,7 @@ int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
 	set_state(&smdata, STOPMACHINE_PREPARE);
 	cpu_stop_init_done(&done, num_active_cpus());
 	queue_stop_cpus_work(cpu_active_mask, stop_machine_cpu_stop, &smdata,
-			     &done);
+			     &done, true);
 	ret = stop_machine_cpu_stop(&smdata);
 
 	/* Busy wait for completion. */
diff --git a/localversion-rt b/localversion-rt
index 6c6cde1..c29508d 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt21
+-rt22
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e097a56..9be717b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -221,9 +221,9 @@ static DEFINE_LOCAL_IRQ_LOCK(pa_lock);
 
 #ifdef CONFIG_PREEMPT_RT_BASE
 # define cpu_lock_irqsave(cpu, flags)		\
-	spin_lock_irqsave(&per_cpu(pa_lock, cpu).lock, flags)
+	local_lock_irqsave_on(pa_lock, flags, cpu)
 # define cpu_unlock_irqrestore(cpu, flags)		\
-	spin_unlock_irqrestore(&per_cpu(pa_lock, cpu).lock, flags)
+	local_unlock_irqrestore_on(pa_lock, flags, cpu)
 #else
 # define cpu_lock_irqsave(cpu, flags)		local_irq_save(flags)
 # define cpu_unlock_irqrestore(cpu, flags)	local_irq_restore(flags)
diff --git a/mm/slab.c b/mm/slab.c
index 64eb636..09addf6 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -751,18 +751,12 @@ slab_on_each_cpu(void (*func)(void *arg, int this_cpu), void *arg)
 
 static void lock_slab_on(unsigned int cpu)
 {
-	if (cpu == smp_processor_id())
-		local_lock_irq(slab_lock);
-	else
-		local_spin_lock_irq(slab_lock, &per_cpu(slab_lock, cpu).lock);
+	local_lock_irq_on(slab_lock, cpu);
 }
 
 static void unlock_slab_on(unsigned int cpu)
 {
-	if (cpu == smp_processor_id())
-		local_unlock_irq(slab_lock);
-	else
-		local_spin_unlock_irq(slab_lock, &per_cpu(slab_lock, cpu).lock);
+	local_unlock_irq_on(slab_lock, cpu);
 }
 #endif
 


