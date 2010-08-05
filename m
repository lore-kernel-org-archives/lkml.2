Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904Ab0HEHeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:34:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57088 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758847Ab0HEHd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:33:59 -0400
Date: Thu, 5 Aug 2010 09:33:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] RCU updates for v2.6.36
Message-ID: <20100805073345.GA6681@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-rcu-for-linus

 Thanks,

	Ingo

------------------>
Mathieu Desnoyers (1):
      tree/tiny rcu: Add debug RCU head objects

Paul E. McKenney (10):
      powerpc: remove all rcu head initializations
      fs: remove all rcu head initializations, except on_stack initializations
      mm: remove all rcu head initializations
      rcu: add an rcu_dereference_index_check()
      rcu: add __rcu API for later sparse checking
      lockdep: Add an in_workqueue_context() lockdep-based test function
      vfs: add fs.h to define struct file
      net: Make accesses to ->br_port safe for sparse RCU
      mce: convert to rcu_dereference_index_check()
      Revert "net: Make accesses to ->br_port safe for sparse RCU"


 arch/powerpc/mm/pgtable.c        |    1 -
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 fs/file.c                        |    3 -
 fs/partitions/check.c            |    1 -
 include/linux/compiler.h         |    2 +
 include/linux/fdtable.h          |    1 +
 include/linux/rcupdate.h         |   82 +++++++++++++++++++
 include/linux/workqueue.h        |    4 +
 kernel/rcupdate.c                |  160 ++++++++++++++++++++++++++++++++++++++
 kernel/rcutiny.c                 |    2 +
 kernel/rcutree.c                 |    2 +
 kernel/workqueue.c               |   15 ++++
 lib/Kconfig.debug                |    6 ++
 mm/backing-dev.c                 |    1 -
 mm/slob.c                        |    1 -
 15 files changed, 275 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
index ebc2f38..2c7e801 100644
--- a/arch/powerpc/mm/pgtable.c
+++ b/arch/powerpc/mm/pgtable.c
@@ -92,7 +92,6 @@ static void pte_free_rcu_callback(struct rcu_head *head)
 
 static void pte_free_submit(struct pte_freelist_batch *batch)
 {
-	INIT_RCU_HEAD(&batch->rcu);
 	call_rcu(&batch->rcu, pte_free_rcu_callback);
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 18cc425..0e78657 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -51,7 +51,7 @@
 static DEFINE_MUTEX(mce_read_mutex);
 
 #define rcu_dereference_check_mce(p) \
-	rcu_dereference_check((p), \
+	rcu_dereference_index_check((p), \
 			      rcu_read_lock_sched_held() || \
 			      lockdep_is_held(&mce_read_mutex))
 
diff --git a/fs/file.c b/fs/file.c
index 34bb7f7..cccaead 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -178,7 +178,6 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	fdt->open_fds = (fd_set *)data;
 	data += nr / BITS_PER_BYTE;
 	fdt->close_on_exec = (fd_set *)data;
-	INIT_RCU_HEAD(&fdt->rcu);
 	fdt->next = NULL;
 
 	return fdt;
@@ -312,7 +311,6 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	new_fdt->close_on_exec = (fd_set *)&newf->close_on_exec_init;
 	new_fdt->open_fds = (fd_set *)&newf->open_fds_init;
 	new_fdt->fd = &newf->fd_array[0];
-	INIT_RCU_HEAD(&new_fdt->rcu);
 	new_fdt->next = NULL;
 
 	spin_lock(&oldf->file_lock);
@@ -430,7 +428,6 @@ struct files_struct init_files = {
 		.fd		= &init_files.fd_array[0],
 		.close_on_exec	= (fd_set *)&init_files.close_on_exec_init,
 		.open_fds	= (fd_set *)&init_files.open_fds_init,
-		.rcu		= RCU_HEAD_INIT,
 	},
 	.file_lock	= __SPIN_LOCK_UNLOCKED(init_task.file_lock),
 };
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 5dcd4b0..72c5265 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -459,7 +459,6 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	}
 
 	/* everything is up and running, commence */
-	INIT_RCU_HEAD(&p->rcu_head);
 	rcu_assign_pointer(ptbl->part[partno], p);
 
 	/* suppress uevent if the disk supresses it */
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index a5a472b..c1a62c5 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -16,6 +16,7 @@
 # define __release(x)	__context__(x,-1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
 # define __percpu	__attribute__((noderef, address_space(3)))
+# define __rcu
 extern void __chk_user_ptr(const volatile void __user *);
 extern void __chk_io_ptr(const volatile void __iomem *);
 #else
@@ -34,6 +35,7 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 # define __release(x) (void)0
 # define __cond_lock(x,c) (c)
 # define __percpu
+# define __rcu
 #endif
 
 #ifdef __KERNEL__
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 013dc52..551671e 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -11,6 +11,7 @@
 #include <linux/rcupdate.h>
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/fs.h>
 
 #include <asm/atomic.h>
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index b653b4a..9fbc54a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -40,6 +40,7 @@
 #include <linux/seqlock.h>
 #include <linux/lockdep.h>
 #include <linux/completion.h>
+#include <linux/debugobjects.h>
 
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable; /* for sysctl */
@@ -79,6 +80,16 @@ extern void rcu_init(void);
        (ptr)->next = NULL; (ptr)->func = NULL; \
 } while (0)
 
+/*
+ * init_rcu_head_on_stack()/destroy_rcu_head_on_stack() are needed for dynamic
+ * initialization and destruction of rcu_head on the stack. rcu_head structures
+ * allocated dynamically in the heap or defined statically don't need any
+ * initialization.
+ */
+#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+extern void init_rcu_head_on_stack(struct rcu_head *head);
+extern void destroy_rcu_head_on_stack(struct rcu_head *head);
+#else /* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 static inline void init_rcu_head_on_stack(struct rcu_head *head)
 {
 }
@@ -86,6 +97,7 @@ static inline void init_rcu_head_on_stack(struct rcu_head *head)
 static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
 {
 }
+#endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
@@ -517,4 +529,74 @@ extern void call_rcu(struct rcu_head *head,
 extern void call_rcu_bh(struct rcu_head *head,
 			void (*func)(struct rcu_head *head));
 
+/*
+ * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
+ * by call_rcu() and rcu callback execution, and are therefore not part of the
+ * RCU API. Leaving in rcupdate.h because they are used by all RCU flavors.
+ */
+
+#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+# define STATE_RCU_HEAD_READY	0
+# define STATE_RCU_HEAD_QUEUED	1
+
+extern struct debug_obj_descr rcuhead_debug_descr;
+
+static inline void debug_rcu_head_queue(struct rcu_head *head)
+{
+	debug_object_activate(head, &rcuhead_debug_descr);
+	debug_object_active_state(head, &rcuhead_debug_descr,
+				  STATE_RCU_HEAD_READY,
+				  STATE_RCU_HEAD_QUEUED);
+}
+
+static inline void debug_rcu_head_unqueue(struct rcu_head *head)
+{
+	debug_object_active_state(head, &rcuhead_debug_descr,
+				  STATE_RCU_HEAD_QUEUED,
+				  STATE_RCU_HEAD_READY);
+	debug_object_deactivate(head, &rcuhead_debug_descr);
+}
+#else	/* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+static inline void debug_rcu_head_queue(struct rcu_head *head)
+{
+}
+
+static inline void debug_rcu_head_unqueue(struct rcu_head *head)
+{
+}
+#endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+
+#ifndef CONFIG_PROVE_RCU
+#define __do_rcu_dereference_check(c) do { } while (0)
+#endif /* #ifdef CONFIG_PROVE_RCU */
+
+#define __rcu_dereference_index_check(p, c) \
+	({ \
+		typeof(p) _________p1 = ACCESS_ONCE(p); \
+		__do_rcu_dereference_check(c); \
+		smp_read_barrier_depends(); \
+		(_________p1); \
+	})
+
+/**
+ * rcu_dereference_index_check() - rcu_dereference for indices with debug checking
+ * @p: The pointer to read, prior to dereferencing
+ * @c: The conditions under which the dereference will take place
+ *
+ * Similar to rcu_dereference_check(), but omits the sparse checking.
+ * This allows rcu_dereference_index_check() to be used on integers,
+ * which can then be used as array indices.  Attempting to use
+ * rcu_dereference_check() on an integer will give compiler warnings
+ * because the sparse address-space mechanism relies on dereferencing
+ * the RCU-protected pointer.  Dereferencing integers is not something
+ * that even gcc will put up with.
+ *
+ * Note that this function does not implicitly check for RCU read-side
+ * critical sections.  If this function gains lots of uses, it might
+ * make sense to provide versions for each flavor of RCU, but it does
+ * not make sense as of early 2010.
+ */
+#define rcu_dereference_index_check(p, c) \
+	__rcu_dereference_index_check((p), (c))
+
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 9466e86..d0f7c81 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -297,4 +297,8 @@ static inline long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 #else
 long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg);
 #endif /* CONFIG_SMP */
+
+#ifdef CONFIG_LOCKDEP
+int in_workqueue_context(struct workqueue_struct *wq);
+#endif
 #endif
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 72a8dc9..4d16983 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -114,3 +114,163 @@ int rcu_my_thread_group_empty(void)
 }
 EXPORT_SYMBOL_GPL(rcu_my_thread_group_empty);
 #endif /* #ifdef CONFIG_PROVE_RCU */
+
+#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+static inline void debug_init_rcu_head(struct rcu_head *head)
+{
+	debug_object_init(head, &rcuhead_debug_descr);
+}
+
+static inline void debug_rcu_head_free(struct rcu_head *head)
+{
+	debug_object_free(head, &rcuhead_debug_descr);
+}
+
+/*
+ * fixup_init is called when:
+ * - an active object is initialized
+ */
+static int rcuhead_fixup_init(void *addr, enum debug_obj_state state)
+{
+	struct rcu_head *head = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		/*
+		 * Ensure that queued callbacks are all executed.
+		 * If we detect that we are nested in a RCU read-side critical
+		 * section, we should simply fail, otherwise we would deadlock.
+		 */
+		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
+		    irqs_disabled()) {
+			WARN_ON(1);
+			return 0;
+		}
+		rcu_barrier();
+		rcu_barrier_sched();
+		rcu_barrier_bh();
+		debug_object_init(head, &rcuhead_debug_descr);
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+/*
+ * fixup_activate is called when:
+ * - an active object is activated
+ * - an unknown object is activated (might be a statically initialized object)
+ * Activation is performed internally by call_rcu().
+ */
+static int rcuhead_fixup_activate(void *addr, enum debug_obj_state state)
+{
+	struct rcu_head *head = addr;
+
+	switch (state) {
+
+	case ODEBUG_STATE_NOTAVAILABLE:
+		/*
+		 * This is not really a fixup. We just make sure that it is
+		 * tracked in the object tracker.
+		 */
+		debug_object_init(head, &rcuhead_debug_descr);
+		debug_object_activate(head, &rcuhead_debug_descr);
+		return 0;
+
+	case ODEBUG_STATE_ACTIVE:
+		/*
+		 * Ensure that queued callbacks are all executed.
+		 * If we detect that we are nested in a RCU read-side critical
+		 * section, we should simply fail, otherwise we would deadlock.
+		 */
+		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
+		    irqs_disabled()) {
+			WARN_ON(1);
+			return 0;
+		}
+		rcu_barrier();
+		rcu_barrier_sched();
+		rcu_barrier_bh();
+		debug_object_activate(head, &rcuhead_debug_descr);
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+/*
+ * fixup_free is called when:
+ * - an active object is freed
+ */
+static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
+{
+	struct rcu_head *head = addr;
+
+	switch (state) {
+	case ODEBUG_STATE_ACTIVE:
+		/*
+		 * Ensure that queued callbacks are all executed.
+		 * If we detect that we are nested in a RCU read-side critical
+		 * section, we should simply fail, otherwise we would deadlock.
+		 */
+#ifndef CONFIG_PREEMPT
+		WARN_ON(1);
+		return 0;
+#else
+		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
+		    irqs_disabled()) {
+			WARN_ON(1);
+			return 0;
+		}
+		rcu_barrier();
+		rcu_barrier_sched();
+		rcu_barrier_bh();
+		debug_object_free(head, &rcuhead_debug_descr);
+		return 1;
+#endif
+	default:
+		return 0;
+	}
+}
+
+/**
+ * init_rcu_head_on_stack() - initialize on-stack rcu_head for debugobjects
+ * @head: pointer to rcu_head structure to be initialized
+ *
+ * This function informs debugobjects of a new rcu_head structure that
+ * has been allocated as an auto variable on the stack.  This function
+ * is not required for rcu_head structures that are statically defined or
+ * that are dynamically allocated on the heap.  This function has no
+ * effect for !CONFIG_DEBUG_OBJECTS_RCU_HEAD kernel builds.
+ */
+void init_rcu_head_on_stack(struct rcu_head *head)
+{
+	debug_object_init_on_stack(head, &rcuhead_debug_descr);
+}
+EXPORT_SYMBOL_GPL(init_rcu_head_on_stack);
+
+/**
+ * destroy_rcu_head_on_stack() - destroy on-stack rcu_head for debugobjects
+ * @head: pointer to rcu_head structure to be initialized
+ *
+ * This function informs debugobjects that an on-stack rcu_head structure
+ * is about to go out of scope.  As with init_rcu_head_on_stack(), this
+ * function is not required for rcu_head structures that are statically
+ * defined or that are dynamically allocated on the heap.  Also as with
+ * init_rcu_head_on_stack(), this function has no effect for
+ * !CONFIG_DEBUG_OBJECTS_RCU_HEAD kernel builds.
+ */
+void destroy_rcu_head_on_stack(struct rcu_head *head)
+{
+	debug_object_free(head, &rcuhead_debug_descr);
+}
+EXPORT_SYMBOL_GPL(destroy_rcu_head_on_stack);
+
+struct debug_obj_descr rcuhead_debug_descr = {
+	.name = "rcu_head",
+	.fixup_init = rcuhead_fixup_init,
+	.fixup_activate = rcuhead_fixup_activate,
+	.fixup_free = rcuhead_fixup_free,
+};
+EXPORT_SYMBOL_GPL(rcuhead_debug_descr);
+#endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 38729d3..196ec02 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -169,6 +169,7 @@ static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp)
 	while (list) {
 		next = list->next;
 		prefetch(next);
+		debug_rcu_head_unqueue(list);
 		list->func(list);
 		list = next;
 	}
@@ -211,6 +212,7 @@ static void __call_rcu(struct rcu_head *head,
 {
 	unsigned long flags;
 
+	debug_rcu_head_queue(head);
 	head->func = func;
 	head->next = NULL;
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d443734..d5bc439 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1112,6 +1112,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	while (list) {
 		next = list->next;
 		prefetch(next);
+		debug_rcu_head_unqueue(list);
 		list->func(list);
 		list = next;
 		if (++count >= rdp->blimit)
@@ -1388,6 +1389,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	unsigned long flags;
 	struct rcu_data *rdp;
 
+	debug_rcu_head_queue(head);
 	head->func = func;
 	head->next = NULL;
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 327d2de..59fef15 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -68,6 +68,21 @@ struct workqueue_struct {
 #endif
 };
 
+#ifdef CONFIG_LOCKDEP
+/**
+ * in_workqueue_context() - in context of specified workqueue?
+ * @wq: the workqueue of interest
+ *
+ * Checks lockdep state to see if the current task is executing from
+ * within a workqueue item.  This function exists only if lockdep is
+ * enabled.
+ */
+int in_workqueue_context(struct workqueue_struct *wq)
+{
+	return lock_is_held(&wq->lockdep_map);
+}
+#endif
+
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 
 static struct debug_obj_descr work_debug_descr;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e722e9d..142faa2 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -307,6 +307,12 @@ config DEBUG_OBJECTS_WORK
 	  work queue routines to track the life time of work objects and
 	  validate the work operations.
 
+config DEBUG_OBJECTS_RCU_HEAD
+	bool "Debug RCU callbacks objects"
+	depends on DEBUG_OBJECTS && PREEMPT
+	help
+	  Enable this to turn on debugging of RCU list heads (call_rcu() usage).
+
 config DEBUG_OBJECTS_ENABLE_DEFAULT
 	int "debug_objects bootup default value (0-1)"
         range 0 1
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 660a87a..42f6d20 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -668,7 +668,6 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = PROP_FRAC_BASE;
 	spin_lock_init(&bdi->wb_lock);
-	INIT_RCU_HEAD(&bdi->rcu_head);
 	INIT_LIST_HEAD(&bdi->bdi_list);
 	INIT_LIST_HEAD(&bdi->wb_list);
 	INIT_LIST_HEAD(&bdi->work_list);
diff --git a/mm/slob.c b/mm/slob.c
index 23631e2..19d2e5d 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -639,7 +639,6 @@ void kmem_cache_free(struct kmem_cache *c, void *b)
 	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
 		struct slob_rcu *slob_rcu;
 		slob_rcu = b + (c->size - sizeof(struct slob_rcu));
-		INIT_RCU_HEAD(&slob_rcu->head);
 		slob_rcu->size = c->size;
 		call_rcu(&slob_rcu->head, kmem_rcu_free);
 	} else {
