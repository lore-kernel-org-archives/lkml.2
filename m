Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab1GVNrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 09:47:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52748 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313Ab1GVNrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 09:47:08 -0400
Date: Fri, 22 Jul 2011 15:46:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] sched/core changes for v3.1
Message-ID: <20110722134620.GA1445@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-core-for-linus

 Thanks,

	Ingo

------------------>
Bianca Lutz (1):
      sched: Do not attempt to destroy uninitialized rt_bandwidth

Frederic Weisbecker (7):
      sched: Remove pointless in_atomic() definition check
      sched: Isolate preempt counting in its own config option
      sched: Make sleeping inside spinlock detection working in !CONFIG_PREEMPT
      sched: Generalize sleep inside spinlock detection
      m32r: Use generic PREEMPT config
      h8300: Use generic config PREEMPT definition
      xtensa: Use generic config PREEMPT definition

Jan H. Schönherr (1):
      sched: Separate group-scheduling code more clearly

Jan Schoenherr (2):
      sched: Fix (harmless) typo 'CONFG_FAIR_GROUP_SCHED'
      sched: Remove unused function cpu_cfs_rq()

Lin Ming (1):
      sched: Cleanup duplicate local variable in [enqueue|dequeue]_task_fair

Nikunj A. Dadhania (1):
      sched: Remove rcu_read_lock() from wake_affine()

Paul Turner (2):
      sched: update correct entity's runtime in check_preempt_wakeup()
      sched: Don't update shares twice on on_rq parent

Peter Zijlstra (1):
      sched, cgroup: Optimize load_balance_fair()

Richard Kennedy (1):
      sched: Reorder root_domain to remove 64 bit alignment padding

Stephan Baerwolf (1):
      sched: Replace use of entity_key()

Steven Rostedt (3):
      sched: Change pick_next_task_rt from unlikely to likely
      sched: Remove unlikely() from rt_policy() in sched.c
      sched: Remove unlikely() from ttwu_post_activation

Thomas Gleixner (1):
      sched: Simplify mutex_spin_on_owner()

Yong Zhang (2):
      sched: Cleanup pre_schedule_rt
      sched: Skip autogroup when looking for all rt sched groups


 Documentation/DocBook/kernel-hacking.tmpl  |    2 +-
 Documentation/SubmitChecklist              |    2 +-
 Documentation/development-process/4.Coding |    2 +-
 Documentation/ja_JP/SubmitChecklist        |    2 +-
 Documentation/zh_CN/SubmitChecklist        |    2 +-
 arch/h8300/Kconfig.cpu                     |    4 +-
 arch/m32r/Kconfig                          |   12 +---
 arch/xtensa/Kconfig                        |   13 +---
 include/linux/bit_spinlock.h               |    2 +-
 include/linux/hardirq.h                    |    4 +-
 include/linux/kernel.h                     |    2 +-
 include/linux/pagemap.h                    |    4 +-
 include/linux/preempt.h                    |   26 ++++--
 include/linux/rcupdate.h                   |   12 ++--
 include/linux/sched.h                      |    2 +-
 kernel/Kconfig.preempt                     |    3 +
 kernel/sched.c                             |  117 +++++++++-------------------
 kernel/sched_autogroup.h                   |    1 +
 kernel/sched_fair.c                        |   72 ++++++++++-------
 kernel/sched_rt.c                          |   26 +++++--
 lib/Kconfig.debug                          |    9 ++-
 21 files changed, 145 insertions(+), 174 deletions(-)

diff --git a/Documentation/DocBook/kernel-hacking.tmpl b/Documentation/DocBook/kernel-hacking.tmpl
index 7b3f493..07a9c48 100644
--- a/Documentation/DocBook/kernel-hacking.tmpl
+++ b/Documentation/DocBook/kernel-hacking.tmpl
@@ -409,7 +409,7 @@ cond_resched(); /* Will sleep */
 
   <para>
    You should always compile your kernel
-   <symbol>CONFIG_DEBUG_SPINLOCK_SLEEP</symbol> on, and it will warn
+   <symbol>CONFIG_DEBUG_ATOMIC_SLEEP</symbol> on, and it will warn
    you if you break these rules.  If you <emphasis>do</emphasis> break
    the rules, you will eventually lock up your box.
   </para>
diff --git a/Documentation/SubmitChecklist b/Documentation/SubmitChecklist
index da0382d..7b13be4 100644
--- a/Documentation/SubmitChecklist
+++ b/Documentation/SubmitChecklist
@@ -53,7 +53,7 @@ kernel patches.
 
 12: Has been tested with CONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT,
     CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES,
-    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_SPINLOCK_SLEEP all simultaneously
+    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_ATOMIC_SLEEP all simultaneously
     enabled.
 
 13: Has been build- and runtime tested with and without CONFIG_SMP and
diff --git a/Documentation/development-process/4.Coding b/Documentation/development-process/4.Coding
index f3f1a46..83f5f5b 100644
--- a/Documentation/development-process/4.Coding
+++ b/Documentation/development-process/4.Coding
@@ -244,7 +244,7 @@ testing purposes.  In particular, you should turn on:
  - DEBUG_SLAB can find a variety of memory allocation and use errors; it
    should be used on most development kernels.
 
- - DEBUG_SPINLOCK, DEBUG_SPINLOCK_SLEEP, and DEBUG_MUTEXES will find a
+ - DEBUG_SPINLOCK, DEBUG_ATOMIC_SLEEP, and DEBUG_MUTEXES will find a
    number of common locking errors.
 
 There are quite a few other debugging options, some of which will be
diff --git a/Documentation/ja_JP/SubmitChecklist b/Documentation/ja_JP/SubmitChecklist
index 2df4576..cb5507b 100644
--- a/Documentation/ja_JP/SubmitChecklist
+++ b/Documentation/ja_JP/SubmitChecklist
@@ -68,7 +68,7 @@ Linux カーネルパッチ投稿者向けチェックリスト
 
 12: CONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT, CONFIG_DEBUG_SLAB,
     CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES, CONFIG_DEBUG_SPINLOCK,
-    CONFIG_DEBUG_SPINLOCK_SLEEP これら全てを同時に有効にして動作確認を
+    CONFIG_DEBUG_ATOMIC_SLEEP これら全てを同時に有効にして動作確認を
     行ってください。
 
 13: CONFIG_SMP, CONFIG_PREEMPT を有効にした場合と無効にした場合の両方で
diff --git a/Documentation/zh_CN/SubmitChecklist b/Documentation/zh_CN/SubmitChecklist
index 951415b..4c741d6 100644
--- a/Documentation/zh_CN/SubmitChecklist
+++ b/Documentation/zh_CN/SubmitChecklist
@@ -67,7 +67,7 @@ Linux
 
 12���Ѿ�ͨ��CONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT,
     CONFIG_DEBUG_SLAB, CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES,
-    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_SPINLOCK_SLEEP���ԣ�����ͬʱ��
+    CONFIG_DEBUG_SPINLOCK, CONFIG_DEBUG_ATOMIC_SLEEP���ԣ�����ͬʱ��
     ʹ�ܡ�
 
 13���Ѿ�����������ʹ�û��߲�ʹ�� CONFIG_SMP �� CONFIG_PREEMPT����ִ��ʱ�䡣
diff --git a/arch/h8300/Kconfig.cpu b/arch/h8300/Kconfig.cpu
index d236ab4..15c2228 100644
--- a/arch/h8300/Kconfig.cpu
+++ b/arch/h8300/Kconfig.cpu
@@ -162,9 +162,7 @@ config H8300_TPU_CH
 	int "TPU channel"
 	depends on H8300_TPU
 
-config PREEMPT
-	bool "Preemptible Kernel"
-	default n
+source "kernel/Kconfig.preempt"
 
 source "mm/Kconfig"
 
diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index 85b44e8..b92b944 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -268,17 +268,7 @@ config SCHED_OMIT_FRAME_POINTER
         bool
         default y
 
-config PREEMPT
-	bool "Preemptible Kernel"
-	help
-	  This option reduces the latency of the kernel when reacting to
-	  real-time or interactive events by allowing a low priority process to
-	  be preempted even if it is in kernel mode executing a system call.
-	  This allows applications to run more reliably even when the system is
-	  under load.
-
-	  Say Y here if you are building a kernel for a desktop, embedded
-	  or real-time system.  Say N if you are unsure.
+source "kernel/Kconfig.preempt"
 
 config SMP
 	bool "Symmetric multi-processing support"
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 5d43c1f..c346ccd 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -80,18 +80,7 @@ config XTENSA_UNALIGNED_USER
 
 	  Say Y here to enable unaligned memory access in user space.
 
-config PREEMPT
-	bool "Preemptible Kernel"
-	help
-          This option reduces the latency of the kernel when reacting to
-          real-time or interactive events by allowing a low priority process to
-          be preempted even if it is in kernel mode executing a system call.
-          Unfortunately the kernel code has some race conditions if both
-          CONFIG_SMP and CONFIG_PREEMPT are enabled, so this option is
-          currently disabled if you are building an SMP kernel.
-
-          Say Y here if you are building a kernel for a desktop, embedded
-          or real-time system.  Say N if you are unsure.
+source "kernel/Kconfig.preempt"
 
 config MATH_EMULATION
 	bool "Math emulation"
diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
index b4326bf..564d997 100644
--- a/include/linux/bit_spinlock.h
+++ b/include/linux/bit_spinlock.h
@@ -88,7 +88,7 @@ static inline int bit_spin_is_locked(int bitnum, unsigned long *addr)
 {
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 	return test_bit(bitnum, addr);
-#elif defined CONFIG_PREEMPT
+#elif defined CONFIG_PREEMPT_COUNT
 	return preempt_count();
 #else
 	return 1;
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index ba36217..f743883f 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -93,7 +93,7 @@
  */
 #define in_nmi()	(preempt_count() & NMI_MASK)
 
-#if defined(CONFIG_PREEMPT)
+#if defined(CONFIG_PREEMPT_COUNT)
 # define PREEMPT_CHECK_OFFSET 1
 #else
 # define PREEMPT_CHECK_OFFSET 0
@@ -115,7 +115,7 @@
 #define in_atomic_preempt_off() \
 		((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_CHECK_OFFSET)
 
-#ifdef CONFIG_PREEMPT
+#ifdef CONFIG_PREEMPT_COUNT
 # define preemptible()	(preempt_count() == 0 && !irqs_disabled())
 # define IRQ_EXIT_OFFSET (HARDIRQ_OFFSET-1)
 #else
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 953352a..567a6f7 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -121,7 +121,7 @@ extern int _cond_resched(void);
 # define might_resched() do { } while (0)
 #endif
 
-#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
+#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
   void __might_sleep(const char *file, int line, int preempt_offset);
 /**
  * might_sleep - annotation for functions that can sleep
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 716875e..8e38d4c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -134,7 +134,7 @@ static inline int page_cache_get_speculative(struct page *page)
 	VM_BUG_ON(in_interrupt());
 
 #if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
-# ifdef CONFIG_PREEMPT
+# ifdef CONFIG_PREEMPT_COUNT
 	VM_BUG_ON(!in_atomic());
 # endif
 	/*
@@ -172,7 +172,7 @@ static inline int page_cache_add_speculative(struct page *page, int count)
 	VM_BUG_ON(in_interrupt());
 
 #if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
-# ifdef CONFIG_PREEMPT
+# ifdef CONFIG_PREEMPT_COUNT
 	VM_BUG_ON(!in_atomic());
 # endif
 	VM_BUG_ON(page_count(page) == 0);
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 2e681d9..58969b2 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -27,6 +27,21 @@
 
 asmlinkage void preempt_schedule(void);
 
+#define preempt_check_resched() \
+do { \
+	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
+		preempt_schedule(); \
+} while (0)
+
+#else /* !CONFIG_PREEMPT */
+
+#define preempt_check_resched()		do { } while (0)
+
+#endif /* CONFIG_PREEMPT */
+
+
+#ifdef CONFIG_PREEMPT_COUNT
+
 #define preempt_disable() \
 do { \
 	inc_preempt_count(); \
@@ -39,12 +54,6 @@ do { \
 	dec_preempt_count(); \
 } while (0)
 
-#define preempt_check_resched() \
-do { \
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
-		preempt_schedule(); \
-} while (0)
-
 #define preempt_enable() \
 do { \
 	preempt_enable_no_resched(); \
@@ -80,18 +89,17 @@ do { \
 	preempt_check_resched(); \
 } while (0)
 
-#else
+#else /* !CONFIG_PREEMPT_COUNT */
 
 #define preempt_disable()		do { } while (0)
 #define preempt_enable_no_resched()	do { } while (0)
 #define preempt_enable()		do { } while (0)
-#define preempt_check_resched()		do { } while (0)
 
 #define preempt_disable_notrace()		do { } while (0)
 #define preempt_enable_no_resched_notrace()	do { } while (0)
 #define preempt_enable_notrace()		do { } while (0)
 
-#endif
+#endif /* CONFIG_PREEMPT_COUNT */
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 99f9aa7..8f4f881 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -239,7 +239,7 @@ extern int rcu_read_lock_bh_held(void);
  * Check debug_lockdep_rcu_enabled() to prevent false positives during boot
  * and while lockdep is disabled.
  */
-#ifdef CONFIG_PREEMPT
+#ifdef CONFIG_PREEMPT_COUNT
 static inline int rcu_read_lock_sched_held(void)
 {
 	int lockdep_opinion = 0;
@@ -250,12 +250,12 @@ static inline int rcu_read_lock_sched_held(void)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
 	return lockdep_opinion || preempt_count() != 0 || irqs_disabled();
 }
-#else /* #ifdef CONFIG_PREEMPT */
+#else /* #ifdef CONFIG_PREEMPT_COUNT */
 static inline int rcu_read_lock_sched_held(void)
 {
 	return 1;
 }
-#endif /* #else #ifdef CONFIG_PREEMPT */
+#endif /* #else #ifdef CONFIG_PREEMPT_COUNT */
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
@@ -276,17 +276,17 @@ static inline int rcu_read_lock_bh_held(void)
 	return 1;
 }
 
-#ifdef CONFIG_PREEMPT
+#ifdef CONFIG_PREEMPT_COUNT
 static inline int rcu_read_lock_sched_held(void)
 {
 	return preempt_count() != 0 || irqs_disabled();
 }
-#else /* #ifdef CONFIG_PREEMPT */
+#else /* #ifdef CONFIG_PREEMPT_COUNT */
 static inline int rcu_read_lock_sched_held(void)
 {
 	return 1;
 }
-#endif /* #else #ifdef CONFIG_PREEMPT */
+#endif /* #else #ifdef CONFIG_PREEMPT_COUNT */
 
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 14a6c7b..341a4d7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2510,7 +2510,7 @@ extern int _cond_resched(void);
 
 extern int __cond_resched_lock(spinlock_t *lock);
 
-#ifdef CONFIG_PREEMPT
+#ifdef CONFIG_PREEMPT_COUNT
 #define PREEMPT_LOCK_OFFSET	PREEMPT_OFFSET
 #else
 #define PREEMPT_LOCK_OFFSET	0
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index bf987b9..24e7cb0 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -35,6 +35,7 @@ config PREEMPT_VOLUNTARY
 
 config PREEMPT
 	bool "Preemptible Kernel (Low-Latency Desktop)"
+	select PREEMPT_COUNT
 	help
 	  This option reduces the latency of the kernel by making
 	  all kernel code (that is not executing in a critical section)
@@ -52,3 +53,5 @@ config PREEMPT
 
 endchoice
 
+config PREEMPT_COUNT
+       bool
\ No newline at end of file
diff --git a/kernel/sched.c b/kernel/sched.c
index fde6ff9..6fdf7ff 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -124,7 +124,7 @@
 
 static inline int rt_policy(int policy)
 {
-	if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR))
+	if (policy == SCHED_FIFO || policy == SCHED_RR)
 		return 1;
 	return 0;
 }
@@ -422,6 +422,7 @@ struct rt_rq {
  */
 struct root_domain {
 	atomic_t refcount;
+	atomic_t rto_count;
 	struct rcu_head rcu;
 	cpumask_var_t span;
 	cpumask_var_t online;
@@ -431,7 +432,6 @@ struct root_domain {
 	 * one runnable RT task.
 	 */
 	cpumask_var_t rto_mask;
-	atomic_t rto_count;
 	struct cpupri cpupri;
 };
 
@@ -1568,38 +1568,6 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 	return rq->avg_load_per_task;
 }
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
-
-/*
- * Compute the cpu's hierarchical load factor for each task group.
- * This needs to be done in a top-down fashion because the load of a child
- * group is a fraction of its parents load.
- */
-static int tg_load_down(struct task_group *tg, void *data)
-{
-	unsigned long load;
-	long cpu = (long)data;
-
-	if (!tg->parent) {
-		load = cpu_rq(cpu)->load.weight;
-	} else {
-		load = tg->parent->cfs_rq[cpu]->h_load;
-		load *= tg->se[cpu]->load.weight;
-		load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
-	}
-
-	tg->cfs_rq[cpu]->h_load = load;
-
-	return 0;
-}
-
-static void update_h_load(long cpu)
-{
-	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
-}
-
-#endif
-
 #ifdef CONFIG_PREEMPT
 
 static void double_rq_lock(struct rq *rq1, struct rq *rq2);
@@ -2497,7 +2465,7 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 	if (p->sched_class->task_woken)
 		p->sched_class->task_woken(rq, p);
 
-	if (unlikely(rq->idle_stamp)) {
+	if (rq->idle_stamp) {
 		u64 delta = rq->clock - rq->idle_stamp;
 		u64 max = 2*sysctl_sched_migration_cost;
 
@@ -2886,7 +2854,7 @@ void sched_fork(struct task_struct *p)
 #if defined(CONFIG_SMP)
 	p->on_cpu = 0;
 #endif
-#ifdef CONFIG_PREEMPT
+#ifdef CONFIG_PREEMPT_COUNT
 	/* Want to start with kernel preemption disabled. */
 	task_thread_info(p)->preempt_count = 1;
 #endif
@@ -4338,11 +4306,8 @@ EXPORT_SYMBOL(schedule);
 
 static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
 {
-	bool ret = false;
-
-	rcu_read_lock();
 	if (lock->owner != owner)
-		goto fail;
+		return false;
 
 	/*
 	 * Ensure we emit the owner->on_cpu, dereference _after_ checking
@@ -4352,11 +4317,7 @@ static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
 	 */
 	barrier();
 
-	ret = owner->on_cpu;
-fail:
-	rcu_read_unlock();
-
-	return ret;
+	return owner->on_cpu;
 }
 
 /*
@@ -4368,21 +4329,21 @@ int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
 	if (!sched_feat(OWNER_SPIN))
 		return 0;
 
+	rcu_read_lock();
 	while (owner_running(lock, owner)) {
 		if (need_resched())
-			return 0;
+			break;
 
 		arch_mutex_cpu_relax();
 	}
+	rcu_read_unlock();
 
 	/*
-	 * If the owner changed to another task there is likely
-	 * heavy contention, stop spinning.
+	 * We break out the loop above on need_resched() and when the
+	 * owner changed, which is a sign for heavy contention. Return
+	 * success only when lock->owner is NULL.
 	 */
-	if (lock->owner)
-		return 0;
-
-	return 1;
+	return lock->owner == NULL;
 }
 #endif
 
@@ -7898,17 +7859,10 @@ int in_sched_functions(unsigned long addr)
 		&& addr < (unsigned long)__sched_text_end);
 }
 
-static void init_cfs_rq(struct cfs_rq *cfs_rq, struct rq *rq)
+static void init_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	cfs_rq->tasks_timeline = RB_ROOT;
 	INIT_LIST_HEAD(&cfs_rq->tasks);
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	cfs_rq->rq = rq;
-	/* allow initial update_cfs_load() to truncate */
-#ifdef CONFIG_SMP
-	cfs_rq->load_stamp = 1;
-#endif
-#endif
 	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
 #ifndef CONFIG_64BIT
 	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
@@ -7928,13 +7882,9 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 	/* delimiter for bitsearch: */
 	__set_bit(MAX_RT_PRIO, array->bitmap);
 
-#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
+#if defined CONFIG_SMP
 	rt_rq->highest_prio.curr = MAX_RT_PRIO;
-#ifdef CONFIG_SMP
 	rt_rq->highest_prio.next = MAX_RT_PRIO;
-#endif
-#endif
-#ifdef CONFIG_SMP
 	rt_rq->rt_nr_migratory = 0;
 	rt_rq->overloaded = 0;
 	plist_head_init_raw(&rt_rq->pushable_tasks, &rq->lock);
@@ -7944,11 +7894,6 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 	rt_rq->rt_throttled = 0;
 	rt_rq->rt_runtime = 0;
 	raw_spin_lock_init(&rt_rq->rt_runtime_lock);
-
-#ifdef CONFIG_RT_GROUP_SCHED
-	rt_rq->rt_nr_boosted = 0;
-	rt_rq->rq = rq;
-#endif
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -7957,11 +7902,17 @@ static void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
 				struct sched_entity *parent)
 {
 	struct rq *rq = cpu_rq(cpu);
-	tg->cfs_rq[cpu] = cfs_rq;
-	init_cfs_rq(cfs_rq, rq);
+
 	cfs_rq->tg = tg;
+	cfs_rq->rq = rq;
+#ifdef CONFIG_SMP
+	/* allow initial update_cfs_load() to truncate */
+	cfs_rq->load_stamp = 1;
+#endif
 
+	tg->cfs_rq[cpu] = cfs_rq;
 	tg->se[cpu] = se;
+
 	/* se could be NULL for root_task_group */
 	if (!se)
 		return;
@@ -7984,12 +7935,14 @@ static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 {
 	struct rq *rq = cpu_rq(cpu);
 
-	tg->rt_rq[cpu] = rt_rq;
-	init_rt_rq(rt_rq, rq);
+	rt_rq->highest_prio.curr = MAX_RT_PRIO;
+	rt_rq->rt_nr_boosted = 0;
+	rt_rq->rq = rq;
 	rt_rq->tg = tg;
-	rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
 
+	tg->rt_rq[cpu] = rt_rq;
 	tg->rt_se[cpu] = rt_se;
+
 	if (!rt_se)
 		return;
 
@@ -8071,7 +8024,7 @@ void __init sched_init(void)
 		rq->nr_running = 0;
 		rq->calc_load_active = 0;
 		rq->calc_load_update = jiffies + LOAD_FREQ;
-		init_cfs_rq(&rq->cfs, rq);
+		init_cfs_rq(&rq->cfs);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		root_task_group.shares = root_task_group_load;
@@ -8185,7 +8138,7 @@ void __init sched_init(void)
 	scheduler_running = 1;
 }
 
-#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
+#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
 static inline int preempt_count_equals(int preempt_offset)
 {
 	int nested = (preempt_count() & ~PREEMPT_ACTIVE) + rcu_preempt_depth();
@@ -8195,7 +8148,6 @@ static inline int preempt_count_equals(int preempt_offset)
 
 void __might_sleep(const char *file, int line, int preempt_offset)
 {
-#ifdef in_atomic
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
 	if ((preempt_count_equals(preempt_offset) && !irqs_disabled()) ||
@@ -8217,7 +8169,6 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 	if (irqs_disabled())
 		print_irqtrace_events(current);
 	dump_stack();
-#endif
 }
 EXPORT_SYMBOL(__might_sleep);
 #endif
@@ -8376,6 +8327,7 @@ int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
 		if (!se)
 			goto err_free_rq;
 
+		init_cfs_rq(cfs_rq);
 		init_tg_cfs_entry(tg, cfs_rq, se, i, parent->se[i]);
 	}
 
@@ -8403,7 +8355,7 @@ static inline void unregister_fair_sched_group(struct task_group *tg, int cpu)
 	list_del_leaf_cfs_rq(tg->cfs_rq[cpu]);
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
-#else /* !CONFG_FAIR_GROUP_SCHED */
+#else /* !CONFIG_FAIR_GROUP_SCHED */
 static inline void free_fair_sched_group(struct task_group *tg)
 {
 }
@@ -8424,7 +8376,8 @@ static void free_rt_sched_group(struct task_group *tg)
 {
 	int i;
 
-	destroy_rt_bandwidth(&tg->rt_bandwidth);
+	if (tg->rt_se)
+		destroy_rt_bandwidth(&tg->rt_bandwidth);
 
 	for_each_possible_cpu(i) {
 		if (tg->rt_rq)
@@ -8465,6 +8418,8 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 		if (!rt_se)
 			goto err_free_rq;
 
+		init_rt_rq(rt_rq, cpu_rq(i));
+		rt_rq->rt_runtime = tg->rt_bandwidth.rt_runtime;
 		init_tg_rt_entry(tg, rt_rq, rt_se, i, parent->rt_se[i]);
 	}
 
diff --git a/kernel/sched_autogroup.h b/kernel/sched_autogroup.h
index 0557705..c2f0e72 100644
--- a/kernel/sched_autogroup.h
+++ b/kernel/sched_autogroup.h
@@ -13,6 +13,7 @@ struct autogroup {
 	int			nice;
 };
 
+static inline bool task_group_is_autogroup(struct task_group *tg);
 static inline struct task_group *
 autogroup_task_group(struct task_struct *p, struct task_group *tg);
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c768588..bc8ee99 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -135,14 +135,6 @@ static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
 	return grp->my_q;
 }
 
-/* Given a group's cfs_rq on one cpu, return its corresponding cfs_rq on
- * another cpu ('this_cpu')
- */
-static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
-{
-	return cfs_rq->tg->cfs_rq[this_cpu];
-}
-
 static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	if (!cfs_rq->on_list) {
@@ -271,11 +263,6 @@ static inline struct cfs_rq *group_cfs_rq(struct sched_entity *grp)
 	return NULL;
 }
 
-static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
-{
-	return &cpu_rq(this_cpu)->cfs;
-}
-
 static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 {
 }
@@ -334,11 +321,6 @@ static inline int entity_before(struct sched_entity *a,
 	return (s64)(a->vruntime - b->vruntime) < 0;
 }
 
-static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	return se->vruntime - cfs_rq->min_vruntime;
-}
-
 static void update_min_vruntime(struct cfs_rq *cfs_rq)
 {
 	u64 vruntime = cfs_rq->min_vruntime;
@@ -372,7 +354,6 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
 	struct rb_node *parent = NULL;
 	struct sched_entity *entry;
-	s64 key = entity_key(cfs_rq, se);
 	int leftmost = 1;
 
 	/*
@@ -385,7 +366,7 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		 * We dont care about collisions. Nodes with
 		 * the same key stay together.
 		 */
-		if (key < entity_key(cfs_rq, entry)) {
+		if (entity_before(se, entry)) {
 			link = &parent->rb_left;
 		} else {
 			link = &parent->rb_right;
@@ -1336,7 +1317,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	}
 
 	for_each_sched_entity(se) {
-		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		cfs_rq = cfs_rq_of(se);
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
@@ -1370,13 +1351,16 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 			 */
 			if (task_sleep && parent_entity(se))
 				set_next_buddy(parent_entity(se));
+
+			/* avoid re-evaluating load for this entity */
+			se = parent_entity(se);
 			break;
 		}
 		flags |= DEQUEUE_SLEEP;
 	}
 
 	for_each_sched_entity(se) {
-		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		cfs_rq = cfs_rq_of(se);
 
 		update_cfs_load(cfs_rq, 0);
 		update_cfs_shares(cfs_rq);
@@ -1481,7 +1465,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	 * effect of the currently running task from the load
 	 * of the current CPU:
 	 */
-	rcu_read_lock();
 	if (sync) {
 		tg = task_group(current);
 		weight = current->se.load.weight;
@@ -1517,7 +1500,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 		balanced = this_eff_load <= prev_eff_load;
 	} else
 		balanced = true;
-	rcu_read_unlock();
 
 	/*
 	 * If the currently running task will sleep within
@@ -1921,8 +1903,8 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
-	update_curr(cfs_rq);
 	find_matching_se(&se, &pse);
+	update_curr(cfs_rq_of(se));
 	BUG_ON(!pse);
 	if (wakeup_preempt_entity(se, pse) == 1) {
 		/*
@@ -2231,11 +2213,43 @@ static void update_shares(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 
 	rcu_read_lock();
+	/*
+	 * Iterates the task_group tree in a bottom up fashion, see
+	 * list_add_leaf_cfs_rq() for details.
+	 */
 	for_each_leaf_cfs_rq(rq, cfs_rq)
 		update_shares_cpu(cfs_rq->tg, cpu);
 	rcu_read_unlock();
 }
 
+/*
+ * Compute the cpu's hierarchical load factor for each task group.
+ * This needs to be done in a top-down fashion because the load of a child
+ * group is a fraction of its parents load.
+ */
+static int tg_load_down(struct task_group *tg, void *data)
+{
+	unsigned long load;
+	long cpu = (long)data;
+
+	if (!tg->parent) {
+		load = cpu_rq(cpu)->load.weight;
+	} else {
+		load = tg->parent->cfs_rq[cpu]->h_load;
+		load *= tg->se[cpu]->load.weight;
+		load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
+	}
+
+	tg->cfs_rq[cpu]->h_load = load;
+
+	return 0;
+}
+
+static void update_h_load(long cpu)
+{
+	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
+}
+
 static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
@@ -2243,14 +2257,12 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  int *all_pinned)
 {
 	long rem_load_move = max_load_move;
-	int busiest_cpu = cpu_of(busiest);
-	struct task_group *tg;
+	struct cfs_rq *busiest_cfs_rq;
 
 	rcu_read_lock();
-	update_h_load(busiest_cpu);
+	update_h_load(cpu_of(busiest));
 
-	list_for_each_entry_rcu(tg, &task_groups, list) {
-		struct cfs_rq *busiest_cfs_rq = tg->cfs_rq[busiest_cpu];
+	for_each_leaf_cfs_rq(busiest, busiest_cfs_rq) {
 		unsigned long busiest_h_load = busiest_cfs_rq->h_load;
 		unsigned long busiest_weight = busiest_cfs_rq->load.weight;
 		u64 rem_load, moved_load;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 10d0182..97540f0 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -185,11 +185,23 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 
 typedef struct task_group *rt_rq_iter_t;
 
-#define for_each_rt_rq(rt_rq, iter, rq) \
-	for (iter = list_entry_rcu(task_groups.next, typeof(*iter), list); \
-	     (&iter->list != &task_groups) && \
-	     (rt_rq = iter->rt_rq[cpu_of(rq)]); \
-	     iter = list_entry_rcu(iter->list.next, typeof(*iter), list))
+static inline struct task_group *next_task_group(struct task_group *tg)
+{
+	do {
+		tg = list_entry_rcu(tg->list.next,
+			typeof(struct task_group), list);
+	} while (&tg->list != &task_groups && task_group_is_autogroup(tg));
+
+	if (&tg->list == &task_groups)
+		tg = NULL;
+
+	return tg;
+}
+
+#define for_each_rt_rq(rt_rq, iter, rq)					\
+	for (iter = container_of(&task_groups, typeof(*iter), list);	\
+		(iter = next_task_group(iter)) &&			\
+		(rt_rq = iter->rt_rq[cpu_of(rq)]);)
 
 static inline void list_add_leaf_rt_rq(struct rt_rq *rt_rq)
 {
@@ -1126,7 +1138,7 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 
 	rt_rq = &rq->rt;
 
-	if (unlikely(!rt_rq->rt_nr_running))
+	if (!rt_rq->rt_nr_running)
 		return NULL;
 
 	if (rt_rq_throttled(rt_rq))
@@ -1548,7 +1560,7 @@ skip:
 static void pre_schedule_rt(struct rq *rq, struct task_struct *prev)
 {
 	/* Try to pull RT tasks here if we lower this rq's prio */
-	if (unlikely(rt_task(prev)) && rq->rt.highest_prio.curr > prev->prio)
+	if (rq->rt.highest_prio.curr > prev->prio)
 		pull_rt_task(rq);
 }
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dd373c8..9f0d826 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -648,12 +648,15 @@ config TRACE_IRQFLAGS
 	  Enables hooks to interrupt enabling and disabling for
 	  either tracing or lock debugging.
 
-config DEBUG_SPINLOCK_SLEEP
-	bool "Spinlock debugging: sleep-inside-spinlock checking"
+config DEBUG_ATOMIC_SLEEP
+	bool "Sleep inside atomic section checking"
+	select PREEMPT_COUNT
 	depends on DEBUG_KERNEL
 	help
 	  If you say Y here, various routines which may sleep will become very
-	  noisy if they are called with a spinlock held.
+	  noisy if they are called inside atomic sections: when a spinlock is
+	  held, inside an rcu read side critical section, inside preempt disabled
+	  sections, inside an interrupt, etc...
 
 config DEBUG_LOCKING_API_SELFTESTS
 	bool "Locking API boot-time self-tests"
