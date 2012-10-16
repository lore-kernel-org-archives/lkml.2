Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab2JPRIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:08:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23485 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab2JPRIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:08:46 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=NbYD9KISzMsA:10 a=VwQbUJbxAAAA:8 a=3jxhucFPFU15GcvyjYAA:9 a=QEXdDO2ut3YA:10 a=dIT1rXXINhYA:10 a=mlqpGjxt3s4A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Subject: [ANNOUNCE] 3.0.45-rt68
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Oct 2012 13:08:43 -0400
Message-ID: <1350407323.19292.23.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.0.45-rt68 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 5df08aeb90f542384bd1c362ff8608f3d39503d5


Or to build 3.0.45-rt68 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.45.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.45-rt68.patch.xz


You can also build from 3.0.45-rt67 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.45-rt67-rt68.patch.xz



Enjoy,

-- Steve


Changes from 3.0.45-rt67:

---

Steven Rostedt (2):
      softirq: Init softirq local lock after per cpu section is set up
      Linux 3.0.45-rt68

Thomas Gleixner (4):
      mm: slab: Fix potential deadlock
      mm: page_alloc: Use local_lock_on() instead of plain spinlock
      rt: rwsem/rwlock: lockdep annotations
      sched: Better debug output for might sleep

----
 include/linux/locallock.h |   19 +++++++++++++++++++
 include/linux/sched.h     |    4 ++++
 init/main.c               |    2 +-
 kernel/rt.c               |   46 ++++++++++++++++++++++++---------------------
 kernel/sched.c            |   23 +++++++++++++++++++++--
 localversion-rt           |    2 +-
 mm/page_alloc.c           |    4 ++--
 mm/slab.c                 |   10 ++--------
 8 files changed, 75 insertions(+), 35 deletions(-)
---------------------------
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
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8155129..a179dd0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1606,6 +1606,10 @@ struct task_struct {
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
index 2713360..2f96fad 100644
--- a/init/main.c
+++ b/init/main.c
@@ -490,6 +490,7 @@ asmlinkage void __init start_kernel(void)
 	setup_command_line(command_line);
 	setup_nr_cpu_ids();
 	setup_per_cpu_areas();
+	softirq_early_init();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 
 	build_all_zonelists(NULL);
@@ -500,7 +501,6 @@ asmlinkage void __init start_kernel(void)
 	parse_args("Booting kernel", static_command_line, __start___param,
 		   __stop___param - __start___param,
 		   &unknown_bootoption);
-	softirq_early_init();
 	/*
 	 * These use large bootmem allocations and must precede
 	 * kmem_cache_init()
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
 
diff --git a/kernel/sched.c b/kernel/sched.c
index ea235b6..38f9104 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4121,8 +4121,13 @@ void __kprobes add_preempt_count(int val)
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
 
@@ -4164,6 +4169,13 @@ static noinline void __schedule_bug(struct task_struct *prev)
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
 
 	if (regs)
 		show_regs(regs);
@@ -8483,6 +8495,13 @@ void __might_sleep(const char *file, int line, int preempt_offset)
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
 #endif
 }
diff --git a/localversion-rt b/localversion-rt
index 5513b84..df2c52c 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt67
+-rt68
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 47d939e..c645e07 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -227,9 +227,9 @@ static DEFINE_LOCAL_IRQ_LOCK(pa_lock);
 
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
index f451650..d7cdccb 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -745,18 +745,12 @@ slab_on_each_cpu(void (*func)(void *arg, int this_cpu), void *arg)
 
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
 


