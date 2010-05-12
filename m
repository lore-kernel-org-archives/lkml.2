Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345Ab0ELVjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:39:31 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48388 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758028Ab0ELVdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:33:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>, Christopher Li <sparse@chrisli.org>
Subject: [PATCH RFC tip/core/rcu 06/23] rcu: define __rcu address space modifier for sparse
Date: Wed, 12 May 2010 14:33:25 -0700
Message-Id: <1273700022-16523-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100512213317.GA15085@linux.vnet.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit provides definitions for the __rcu annotation defined earlier.
This annotation permits sparse to check for correct use of RCU-protected
pointers.  If a pointer that is annotated with __rcu is accessed
directly (as opposed to via rcu_dereference(), rcu_assign_pointer(),
or one of their variants), sparse can be made to complain.  To enable
such complaints, use the new default-disabled CONFIG_SPARSE_RCU_POINTER
kernel configuration option.  Please note that these sparse complaints are
intended to be a debugging aid, -not- a code-style-enforcement mechanism.

There are special rcu_dereference_protected() and rcu_access_pointer()
accessors for use when RCU read-side protection is not required, for
example, when no other CPU has access to the data structure in question
or while the current CPU hold the update-side lock.

This patch also updates a number of docbook comments that were showing
their age.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Christopher Li <sparse@chrisli.org>
Cc: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/compiler.h |    4 +
 include/linux/rcupdate.h |  352 ++++++++++++++++++++++++++++------------------
 include/linux/srcu.h     |   27 +++-
 kernel/rcupdate.c        |    6 +-
 lib/Kconfig.debug        |   13 ++
 5 files changed, 257 insertions(+), 145 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index c1a62c5..320d6c9 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -16,7 +16,11 @@
 # define __release(x)	__context__(x,-1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
 # define __percpu	__attribute__((noderef, address_space(3)))
+#ifdef CONFIG_SPARSE_RCU_POINTER
+# define __rcu		__attribute__((noderef, address_space(4)))
+#else
 # define __rcu
+#endif
 extern void __chk_user_ptr(const volatile void __user *);
 extern void __chk_io_ptr(const volatile void __iomem *);
 #else
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3be0ad7..0ce0f05 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -41,6 +41,7 @@
 #include <linux/lockdep.h>
 #include <linux/completion.h>
 #include <linux/debugobjects.h>
+#include <linux/compiler.h>
 
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable; /* for sysctl */
@@ -114,14 +115,15 @@ extern struct lockdep_map rcu_sched_lock_map;
 extern int debug_lockdep_rcu_enabled(void);
 
 /**
- * rcu_read_lock_held - might we be in RCU read-side critical section?
+ * rcu_read_lock_held() - might we be in RCU read-side critical section?
  *
  * If CONFIG_DEBUG_LOCK_ALLOC is selected, returns nonzero iff in an RCU
  * read-side critical section.  In absence of CONFIG_DEBUG_LOCK_ALLOC,
  * this assumes we are in an RCU read-side critical section unless it can
- * prove otherwise.
+ * prove otherwise.  This is useful for debug checks in functions that
+ * require that they be called within an RCU read-side critical section.
  *
- * Check debug_lockdep_rcu_enabled() to prevent false positives during boot
+ * Checks debug_lockdep_rcu_enabled() to prevent false positives during boot
  * and while lockdep is disabled.
  */
 static inline int rcu_read_lock_held(void)
@@ -138,14 +140,16 @@ static inline int rcu_read_lock_held(void)
 extern int rcu_read_lock_bh_held(void);
 
 /**
- * rcu_read_lock_sched_held - might we be in RCU-sched read-side critical section?
+ * rcu_read_lock_sched_held() - might we be in RCU-sched read-side critical section?
  *
  * If CONFIG_DEBUG_LOCK_ALLOC is selected, returns nonzero iff in an
  * RCU-sched read-side critical section.  In absence of
  * CONFIG_DEBUG_LOCK_ALLOC, this assumes we are in an RCU-sched read-side
  * critical section unless it can prove otherwise.  Note that disabling
  * of preemption (including disabling irqs) counts as an RCU-sched
- * read-side critical section.
+ * read-side critical section.  This is useful for debug checks in functions
+ * that required that they be called within an RCU-sched read-side
+ * critical section.
  *
  * Check debug_lockdep_rcu_enabled() to prevent false positives during boot
  * and while lockdep is disabled.
@@ -214,41 +218,155 @@ extern int rcu_my_thread_group_empty(void);
 		}							\
 	} while (0)
 
+#else /* #ifdef CONFIG_PROVE_RCU */
+
+#define __do_rcu_dereference_check(c) do { } while (0)
+
+#endif /* #else #ifdef CONFIG_PROVE_RCU */
+
+/*
+ * Helper functions for rcu_dereference_check(), rcu_dereference_protected()
+ * and rcu_assign_pointer().  Some of these could be folded into their
+ * callers, but they are left separate in order to ease introduction of
+ * multiple flavors of pointers to match the multiple flavors of RCU
+ * (e.g., __rcu_bh, * __rcu_sched, and __srcu), should this make sense in
+ * the future.
+ */
+#define __rcu_access_pointer(p, space) \
+	({ \
+		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
+		(void) (((typeof (*p) space *)p) == p); \
+		((typeof(*p) __force __kernel *)(_________p1)); \
+	})
+#define __rcu_dereference_check(p, c, space) \
+	({ \
+		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
+		__do_rcu_dereference_check(c); \
+		(void) (((typeof (*p) space *)p) == p); \
+		smp_read_barrier_depends(); \
+		((typeof(*p) __force __kernel *)(_________p1)); \
+	})
+#define __rcu_dereference_protected(p, c, space) \
+	({ \
+		__do_rcu_dereference_check(c); \
+		(void) (((typeof (*p) space *)p) == p); \
+		((typeof(*p) __force __kernel *)(p)); \
+	})
+
+#define __rcu_dereference_index_check(p, c) \
+	({ \
+		typeof(p) _________p1 = ACCESS_ONCE(p); \
+		__do_rcu_dereference_check(c); \
+		smp_read_barrier_depends(); \
+		(_________p1); \
+	})
+#define __rcu_assign_pointer(p, v, space) \
+	({ \
+		if (!__builtin_constant_p(v) || \
+		    ((v) != NULL)) \
+			smp_wmb(); \
+		(p) = (typeof(*v) __force space *)(v); \
+	})
+
+
+/**
+ * rcu_access_pointer() - fetch RCU pointer with no dereferencing
+ * @p: The pointer to read
+ *
+ * Return the value of the specified RCU-protected pointer, but omit the
+ * smp_read_barrier_depends() and keep the ACCESS_ONCE().  This is useful
+ * when the value of this pointer is accessed, but the pointer is not
+ * dereferenced, for example, when testing an RCU-protected pointer against
+ * NULL.  Although rcu_access_pointer() may also be used in cases where
+ * update-side locks prevent the value of the pointer from changing, you
+ * should instead use rcu_dereference_protected() for this use case.
+ */
+#define rcu_access_pointer(p) __rcu_access_pointer((p), __rcu)
+
 /**
- * rcu_dereference_check - rcu_dereference with debug checking
+ * rcu_dereference_check() - rcu_dereference with debug checking
  * @p: The pointer to read, prior to dereferencing
  * @c: The conditions under which the dereference will take place
  *
  * Do an rcu_dereference(), but check that the conditions under which the
- * dereference will take place are correct.  Typically the conditions indicate
- * the various locking conditions that should be held at that point.  The check
- * should return true if the conditions are satisfied.
+ * dereference will take place are correct.  Typically the conditions
+ * indicate the various locking conditions that should be held at that
+ * point.  The check should return true if the conditions are satisfied.
+ * An implicit check for being in an RCU read-side critical section
+ * (rcu_read_lock()) is included.
  *
  * For example:
  *
- *	bar = rcu_dereference_check(foo->bar, rcu_read_lock_held() ||
- *					      lockdep_is_held(&foo->lock));
+ *	bar = rcu_dereference_check(foo->bar, lockdep_is_held(&foo->lock));
  *
  * could be used to indicate to lockdep that foo->bar may only be dereferenced
- * if either the RCU read lock is held, or that the lock required to replace
+ * if either rcu_read_lock() is held, or that the lock required to replace
  * the bar struct at foo->bar is held.
  *
  * Note that the list of conditions may also include indications of when a lock
  * need not be held, for example during initialisation or destruction of the
  * target struct:
  *
- *	bar = rcu_dereference_check(foo->bar, rcu_read_lock_held() ||
- *					      lockdep_is_held(&foo->lock) ||
+ *	bar = rcu_dereference_check(foo->bar, lockdep_is_held(&foo->lock) ||
  *					      atomic_read(&foo->usage) == 0);
+ *
+ * Inserts memory barriers on architectures that require them
+ * (currently only the Alpha), prevents the compiler from refetching
+ * (and from merging fetches), and, more importantly, documents exactly
+ * which pointers are protected by RCU and checks that the pointer is
+ * annotated as __rcu.
  */
 #define rcu_dereference_check(p, c) \
-	({ \
-		__do_rcu_dereference_check(c); \
-		rcu_dereference_raw(p); \
-	})
+	__rcu_dereference_check((p), rcu_read_lock_held() || (c), __rcu)
+
+/**
+ * rcu_dereference_bh_check() - rcu_dereference_bh with debug checking
+ * @p: The pointer to read, prior to dereferencing
+ * @c: The conditions under which the dereference will take place
+ *
+ * This is the RCU-bh counterpart to rcu_dereference_check().
+ */
+#define rcu_dereference_bh_check(p, c) \
+	__rcu_dereference_check((p), rcu_read_lock_bh_held() || (c), __rcu)
 
 /**
- * rcu_dereference_protected - fetch RCU pointer when updates prevented
+ * rcu_dereference_sched_check() - rcu_dereference_sched with debug checking
+ * @p: The pointer to read, prior to dereferencing
+ * @c: The conditions under which the dereference will take place
+ *
+ * This is the RCU-sched counterpart to rcu_dereference_check().
+ */
+#define rcu_dereference_sched_check(p, c) \
+	__rcu_dereference_check((p), rcu_read_lock_sched_held() || (c), \
+				__rcu)
+
+#define rcu_dereference_raw(p) rcu_dereference_check(p, 1) /*@@@ needed? @@@*/
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
+/**
+ * rcu_dereference_protected() - fetch RCU pointer when updates prevented
+ * @p: The pointer to read, prior to dereferencing
+ * @c: The conditions under which the dereference will take place
  *
  * Return the value of the specified RCU-protected pointer, but omit
  * both the smp_read_barrier_depends() and the ACCESS_ONCE().  This
@@ -257,35 +375,61 @@ extern int rcu_my_thread_group_empty(void);
  * prevent the compiler from repeating this reference or combining it
  * with other references, so it should not be used without protection
  * of appropriate locks.
+ *
+ * This function is only for update-side use.  Using this function
+ * when protected only by rcu_read_lock() will result in infrequent
+ * but very ugly failures.
  */
 #define rcu_dereference_protected(p, c) \
-	({ \
-		__do_rcu_dereference_check(c); \
-		(p); \
-	})
+	__rcu_dereference_protected((p), (c), __rcu)
 
-#else /* #ifdef CONFIG_PROVE_RCU */
+/**
+ * rcu_dereference_bh_protected() - fetch RCU-bh pointer when updates prevented
+ * @p: The pointer to read, prior to dereferencing
+ * @c: The conditions under which the dereference will take place
+ *
+ * This is the RCU-bh counterpart to rcu_dereference_protected().
+ */
+#define rcu_dereference_bh_protected(p, c) \
+	__rcu_dereference_protected((p), (c), __rcu)
 
-#define rcu_dereference_check(p, c)	rcu_dereference_raw(p)
-#define rcu_dereference_protected(p, c) (p)
+/**
+ * rcu_dereference_sched_protected() - fetch RCU-sched pointer when updates prevented
+ * @p: The pointer to read, prior to dereferencing
+ * @c: The conditions under which the dereference will take place
+ *
+ * This is the RCU-sched counterpart to rcu_dereference_protected().
+ */
+#define rcu_dereference_sched_protected(p, c) \
+	__rcu_dereference_protected((p), (c), __rcu)
 
-#endif /* #else #ifdef CONFIG_PROVE_RCU */
 
 /**
- * rcu_access_pointer - fetch RCU pointer with no dereferencing
+ * rcu_dereference() - fetch RCU-protected pointer for dereferencing
+ * @p: The pointer to read, prior to dereferencing
  *
- * Return the value of the specified RCU-protected pointer, but omit the
- * smp_read_barrier_depends() and keep the ACCESS_ONCE().  This is useful
- * when the value of this pointer is accessed, but the pointer is not
- * dereferenced, for example, when testing an RCU-protected pointer against
- * NULL.  This may also be used in cases where update-side locks prevent
- * the value of the pointer from changing, but rcu_dereference_protected()
- * is a lighter-weight primitive for this use case.
+ * This is a simple wrapper around rcu_dereference_check().
  */
-#define rcu_access_pointer(p)	ACCESS_ONCE(p)
+#define rcu_dereference(p) rcu_dereference_check(p, 0)
 
 /**
- * rcu_read_lock - mark the beginning of an RCU read-side critical section.
+ * rcu_dereference_bh() - fetch an RCU-bh-protected pointer for dereferencing
+ * @p: The pointer to read, prior to dereferencing
+ *
+ * Makes rcu_dereference_check() do the dirty work.
+ */
+#define rcu_dereference_bh(p) rcu_dereference_bh_check(p, 0)
+
+/**
+ * rcu_dereference_sched() - fetch RCU-sched-protected pointer for dereferencing
+ * @p: The pointer to read, prior to dereferencing
+ *
+ * Makes rcu_dereference_check() do the dirty work.
+ */
+#define rcu_dereference_sched(p) rcu_dereference_sched_check(p, 0)
+
+/**
+ * rcu_read_lock() - mark the beginning of an RCU read-side critical section
  *
  * When synchronize_rcu() is invoked on one CPU while other CPUs
  * are within RCU read-side critical sections, then the
@@ -331,7 +475,7 @@ static inline void rcu_read_lock(void)
  */
 
 /**
- * rcu_read_unlock - marks the end of an RCU read-side critical section.
+ * rcu_read_unlock() - marks the end of an RCU read-side critical section.
  *
  * See rcu_read_lock() for more information.
  */
@@ -343,15 +487,16 @@ static inline void rcu_read_unlock(void)
 }
 
 /**
- * rcu_read_lock_bh - mark the beginning of a softirq-only RCU critical section
+ * rcu_read_lock_bh() - mark the beginning of an RCU-bh critical section
  *
  * This is equivalent of rcu_read_lock(), but to be used when updates
- * are being done using call_rcu_bh(). Since call_rcu_bh() callbacks
- * consider completion of a softirq handler to be a quiescent state,
- * a process in RCU read-side critical section must be protected by
- * disabling softirqs. Read-side critical sections in interrupt context
- * can use just rcu_read_lock().
- *
+ * are being done using call_rcu_bh() or synchronize_rcu_bh(). Since
+ * both call_rcu_bh() and synchronize_rcu_bh() consider completion of a
+ * softirq handler to be a quiescent state, a process in RCU read-side
+ * critical section must be protected by disabling softirqs. Read-side
+ * critical sections in interrupt context can use just rcu_read_lock(),
+ * though this should at least be commented to avoid confusing people
+ * reading the code.
  */
 static inline void rcu_read_lock_bh(void)
 {
@@ -373,13 +518,12 @@ static inline void rcu_read_unlock_bh(void)
 }
 
 /**
- * rcu_read_lock_sched - mark the beginning of a RCU-classic critical section
+ * rcu_read_lock_sched() - mark the beginning of a RCU-sched critical section
  *
- * Should be used with either
- * - synchronize_sched()
- * or
- * - call_rcu_sched() and rcu_barrier_sched()
- * on the write-side to insure proper synchronization.
+ * This is equivalent of rcu_read_lock(), but to be used when updates
+ * are being done using call_rcu_sched() or synchronize_rcu_sched().
+ * Read-side critical sections can also be introduced by anything that
+ * disables preemption, including local_irq_disable() and friends.
  */
 static inline void rcu_read_lock_sched(void)
 {
@@ -414,54 +558,14 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 	preempt_enable_notrace();
 }
 
-
 /**
- * rcu_dereference_raw - fetch an RCU-protected pointer
+ * rcu_assign_pointer() - assign to RCU-protected pointer
+ * @p: pointer to assign to
+ * @v: value to assign (publish)
  *
- * The caller must be within some flavor of RCU read-side critical
- * section, or must be otherwise preventing the pointer from changing,
- * for example, by holding an appropriate lock.  This pointer may later
- * be safely dereferenced.  It is the caller's responsibility to have
- * done the right thing, as this primitive does no checking of any kind.
- *
- * Inserts memory barriers on architectures that require them
- * (currently only the Alpha), and, more importantly, documents
- * exactly which pointers are protected by RCU.
- */
-#define rcu_dereference_raw(p)	({ \
-				typeof(p) _________p1 = ACCESS_ONCE(p); \
-				smp_read_barrier_depends(); \
-				(_________p1); \
-				})
-
-/**
- * rcu_dereference - fetch an RCU-protected pointer, checking for RCU
- *
- * Makes rcu_dereference_check() do the dirty work.
- */
-#define rcu_dereference(p) \
-	rcu_dereference_check(p, rcu_read_lock_held())
-
-/**
- * rcu_dereference_bh - fetch an RCU-protected pointer, checking for RCU-bh
- *
- * Makes rcu_dereference_check() do the dirty work.
- */
-#define rcu_dereference_bh(p) \
-		rcu_dereference_check(p, rcu_read_lock_bh_held())
-
-/**
- * rcu_dereference_sched - fetch RCU-protected pointer, checking for RCU-sched
- *
- * Makes rcu_dereference_check() do the dirty work.
- */
-#define rcu_dereference_sched(p) \
-		rcu_dereference_check(p, rcu_read_lock_sched_held())
-
-/**
- * rcu_assign_pointer - assign (publicize) a pointer to a newly
- * initialized structure that will be dereferenced by RCU read-side
- * critical sections.  Returns the value assigned.
+ * Assigns the specified value to the specified RCU-protected
+ * pointer, ensuring that any concurrent RCU readers will see
+ * any prior initialization.  Returns the value assigned.
  *
  * Inserts memory barriers on architectures that require them
  * (pretty much all of them other than x86), and also prevents
@@ -470,14 +574,17 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  * call documents which pointers will be dereferenced by RCU read-side
  * code.
  */
-
 #define rcu_assign_pointer(p, v) \
-	({ \
-		if (!__builtin_constant_p(v) || \
-		    ((v) != NULL)) \
-			smp_wmb(); \
-		(p) = (v); \
-	})
+	__rcu_assign_pointer((p), (v), __rcu)
+
+/**
+ * RCU_INIT_POINTER() - initialize an RCU protected pointer
+ *
+ * Initialize an RCU-protected pointer in such a way to avoid RCU-lockdep
+ * splats.
+ */
+#define RCU_INIT_POINTER(p, v) \
+		p = (typeof(*v) __force __rcu *)(v)
 
 /* Infrastructure to implement the synchronize_() primitives. */
 
@@ -489,7 +596,7 @@ struct rcu_synchronize {
 extern void wakeme_after_rcu(struct rcu_head  *head);
 
 /**
- * call_rcu - Queue an RCU callback for invocation after a grace period.
+ * call_rcu() - Queue an RCU callback for invocation after a grace period.
  * @head: structure to be used for queueing the RCU updates.
  * @func: actual update function to be invoked after the grace period
  *
@@ -503,7 +610,7 @@ extern void call_rcu(struct rcu_head *head,
 			      void (*func)(struct rcu_head *head));
 
 /**
- * call_rcu_bh - Queue an RCU for invocation after a quicker grace period.
+ * call_rcu_bh() - Queue an RCU for invocation after a quicker grace period.
  * @head: structure to be used for queueing the RCU updates.
  * @func: actual update function to be invoked after the grace period
  *
@@ -560,37 +667,4 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 }
 #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
-#ifndef CONFIG_PROVE_RCU
-#define __do_rcu_dereference_check(c) do { } while (0)
-#endif /* #ifdef CONFIG_PROVE_RCU */
-
-#define __rcu_dereference_index_check(p, c) \
-	({ \
-		typeof(p) _________p1 = ACCESS_ONCE(p); \
-		__do_rcu_dereference_check(c); \
-		smp_read_barrier_depends(); \
-		(_________p1); \
-	})
-
-/**
- * rcu_dereference_index_check() - rcu_dereference for indices with debug checking
- * @p: The pointer to read, prior to dereferencing
- * @c: The conditions under which the dereference will take place
- *
- * Similar to rcu_dereference_check(), but omits the sparse checking.
- * This allows rcu_dereference_index_check() to be used on integers,
- * which can then be used as array indices.  Attempting to use
- * rcu_dereference_check() on an integer will give compiler warnings
- * because the sparse address-space mechanism relies on dereferencing
- * the RCU-protected pointer.  Dereferencing integers is not something
- * that even gcc will put up with.
- *
- * Note that this function does not implicitly check for RCU read-side
- * critical sections.  If this function gains lots of uses, it might
- * make sense to provide versions for each flavor of RCU, but it does
- * not make sense as of early 2010.
- */
-#define rcu_dereference_index_check(p, c) \
-	__rcu_dereference_index_check((p), (c))
-
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 4d5d2f5..6f456a7 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -108,12 +108,31 @@ static inline int srcu_read_lock_held(struct srcu_struct *sp)
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 /**
- * srcu_dereference - fetch SRCU-protected pointer with checking
+ * srcu_dereference_check - fetch SRCU-protected pointer for later dereferencing
+ * @p: the pointer to fetch and protect for later dereferencing
+ * @sp: pointer to the srcu_struct, which is used to check that we
+ *	really are in an SRCU read-side critical section.
+ * @c: condition to check for update-side use
  *
- * Makes rcu_dereference_check() do the dirty work.
+ * If PROVE_RCU is enabled, invoking this outside of an RCU read-side
+ * critical section will result in an RCU-lockdep splat, unless @c evaluates
+ * to 1.  The @c argument will normally be a logical expression containing
+ * lockdep_is_held() calls.
  */
-#define srcu_dereference(p, sp) \
-		rcu_dereference_check(p, srcu_read_lock_held(sp))
+#define srcu_dereference_check(p, sp, c) \
+	__rcu_dereference_check((p), srcu_read_lock_held(sp) || (c), __rcu)
+
+/**
+ * srcu_dereference - fetch SRCU-protected pointer for later dereferencing
+ * @p: the pointer to fetch and protect for later dereferencing
+ * @sp: pointer to the srcu_struct, which is used to check that we
+ *	really are in an SRCU read-side critical section.
+ *
+ * Makes rcu_dereference_check() do the dirty work.  If PROVE_RCU
+ * is enabled, invoking this outside of an RCU read-side critical
+ * section will result in an RCU-lockdep splat.
+ */
+#define srcu_dereference(p, sp) srcu_dereference_check((p), (sp), 0)
 
 /**
  * srcu_read_lock - register a new reader for an SRCU-protected structure.
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 5ab5a91..2d33c7e 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -73,12 +73,14 @@ int debug_lockdep_rcu_enabled(void)
 EXPORT_SYMBOL_GPL(debug_lockdep_rcu_enabled);
 
 /**
- * rcu_read_lock_bh_held - might we be in RCU-bh read-side critical section?
+ * rcu_read_lock_bh_held() - might we be in RCU-bh read-side critical section?
  *
  * Check for bottom half being disabled, which covers both the
  * CONFIG_PROVE_RCU and not cases.  Note that if someone uses
  * rcu_read_lock_bh(), but then later enables BH, lockdep (if enabled)
- * will show the situation.
+ * will show the situation.  This is useful for debug checks in functions
+ * that require that they be called within an RCU read-side critical
+ * section.
  *
  * Check debug_lockdep_rcu_enabled() to prevent false positives during boot.
  */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8689646..7698752 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -528,6 +528,19 @@ config PROVE_RCU_REPEATEDLY
 	 disabling, allowing multiple RCU-lockdep warnings to be printed
 	 on a single reboot.
 
+config SPARSE_RCU_POINTER
+	bool "RCU debugging: sparse-based checks for pointer usage"
+	default n
+	help
+	 This feature enables the __rcu sparse annotation for
+	 RCU-protected pointers.  This annotation will cause sparse
+	 to flag any non-RCU used of annotated pointers.  This can be
+	 helpful when debugging RCU usage.  Please note that this feature
+	 is not intended to enforce code cleanliness; it is instead merely
+	 a debugging aid.
+
+	 Say Y to make sparse flag questionable use of RCU-protected pointers
+
 	 Say N if you are unsure.
 
 config LOCKDEP
-- 
1.7.0.6

