Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab0DSOwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:52:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39533 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078Ab0DSOwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:52:01 -0400
Date: Mon, 19 Apr 2010 16:51:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU fixes
Message-ID: <20100419145146.GA17018@elte.hu>
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

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
David Howells (1):
      rcu: Better explain the condition parameter of rcu_dereference_check()

Paul E. McKenney (3):
      rcu: Add rcu_access_pointer and rcu_dereference_protected
      rcu: Update docs for rcu_access_pointer and rcu_dereference_protected
      rcu: Make RCU lockdep check the lockdep_recursion variable


 Documentation/RCU/NMI-RCU.txt   |   39 +++++++++++++----------
 Documentation/RCU/checklist.txt |    7 ++--
 Documentation/RCU/lockdep.txt   |   28 +++++++++++++++-
 Documentation/RCU/whatisRCU.txt |    6 +++
 include/linux/rcupdate.h        |   65 +++++++++++++++++++++++++++++++++-----
 kernel/rcupdate.c               |    7 ++++
 6 files changed, 121 insertions(+), 31 deletions(-)

diff --git a/Documentation/RCU/NMI-RCU.txt b/Documentation/RCU/NMI-RCU.txt
index a6d32e6..a8536cb 100644
--- a/Documentation/RCU/NMI-RCU.txt
+++ b/Documentation/RCU/NMI-RCU.txt
@@ -34,7 +34,7 @@ NMI handler.
 		cpu = smp_processor_id();
 		++nmi_count(cpu);
 
-		if (!rcu_dereference(nmi_callback)(regs, cpu))
+		if (!rcu_dereference_sched(nmi_callback)(regs, cpu))
 			default_do_nmi(regs);
 
 		nmi_exit();
@@ -47,12 +47,13 @@ function pointer.  If this handler returns zero, do_nmi() invokes the
 default_do_nmi() function to handle a machine-specific NMI.  Finally,
 preemption is restored.
 
-Strictly speaking, rcu_dereference() is not needed, since this code runs
-only on i386, which does not need rcu_dereference() anyway.  However,
-it is a good documentation aid, particularly for anyone attempting to
-do something similar on Alpha.
+In theory, rcu_dereference_sched() is not needed, since this code runs
+only on i386, which in theory does not need rcu_dereference_sched()
+anyway.  However, in practice it is a good documentation aid, particularly
+for anyone attempting to do something similar on Alpha or on systems
+with aggressive optimizing compilers.
 
-Quick Quiz:  Why might the rcu_dereference() be necessary on Alpha,
+Quick Quiz:  Why might the rcu_dereference_sched() be necessary on Alpha,
 	     given that the code referenced by the pointer is read-only?
 
 
@@ -99,17 +100,21 @@ invoke irq_enter() and irq_exit() on NMI entry and exit, respectively.
 
 Answer to Quick Quiz
 
-	Why might the rcu_dereference() be necessary on Alpha, given
+	Why might the rcu_dereference_sched() be necessary on Alpha, given
 	that the code referenced by the pointer is read-only?
 
 	Answer: The caller to set_nmi_callback() might well have
-		initialized some data that is to be used by the
-		new NMI handler.  In this case, the rcu_dereference()
-		would be needed, because otherwise a CPU that received
-		an NMI just after the new handler was set might see
-		the pointer to the new NMI handler, but the old
-		pre-initialized version of the handler's data.
-
-		More important, the rcu_dereference() makes it clear
-		to someone reading the code that the pointer is being
-		protected by RCU.
+		initialized some data that is to be used by the new NMI
+		handler.  In this case, the rcu_dereference_sched() would
+		be needed, because otherwise a CPU that received an NMI
+		just after the new handler was set might see the pointer
+		to the new NMI handler, but the old pre-initialized
+		version of the handler's data.
+
+		This same sad story can happen on other CPUs when using
+		a compiler with aggressive pointer-value speculation
+		optimizations.
+
+		More important, the rcu_dereference_sched() makes it
+		clear to someone reading the code that the pointer is
+		being protected by RCU-sched.
diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index cbc180f..790d1a8 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -260,7 +260,8 @@ over a rather long period of time, but improvements are always welcome!
 	The reason that it is permissible to use RCU list-traversal
 	primitives when the update-side lock is held is that doing so
 	can be quite helpful in reducing code bloat when common code is
-	shared between readers and updaters.
+	shared between readers and updaters.  Additional primitives
+	are provided for this case, as discussed in lockdep.txt.
 
 10.	Conversely, if you are in an RCU read-side critical section,
 	and you don't hold the appropriate update-side lock, you -must-
@@ -344,8 +345,8 @@ over a rather long period of time, but improvements are always welcome!
 	requiring SRCU's read-side deadlock immunity or low read-side
 	realtime latency.
 
-	Note that, rcu_assign_pointer() and rcu_dereference() relate to
-	SRCU just as they do to other forms of RCU.
+	Note that, rcu_assign_pointer() relates to SRCU just as they do
+	to other forms of RCU.
 
 15.	The whole point of call_rcu(), synchronize_rcu(), and friends
 	is to wait until all pre-existing readers have finished before
diff --git a/Documentation/RCU/lockdep.txt b/Documentation/RCU/lockdep.txt
index fe24b58..d7a49b2 100644
--- a/Documentation/RCU/lockdep.txt
+++ b/Documentation/RCU/lockdep.txt
@@ -32,9 +32,20 @@ checking of rcu_dereference() primitives:
 	srcu_dereference(p, sp):
 		Check for SRCU read-side critical section.
 	rcu_dereference_check(p, c):
-		Use explicit check expression "c".
+		Use explicit check expression "c".  This is useful in
+		code that is invoked by both readers and updaters.
 	rcu_dereference_raw(p)
 		Don't check.  (Use sparingly, if at all.)
+	rcu_dereference_protected(p, c):
+		Use explicit check expression "c", and omit all barriers
+		and compiler constraints.  This is useful when the data
+		structure cannot change, for example, in code that is
+		invoked only by updaters.
+	rcu_access_pointer(p):
+		Return the value of the pointer and omit all barriers,
+		but retain the compiler constraints that prevent duplicating
+		or coalescsing.  This is useful when when testing the
+		value of the pointer itself, for example, against NULL.
 
 The rcu_dereference_check() check expression can be any boolean
 expression, but would normally include one of the rcu_read_lock_held()
@@ -59,7 +70,20 @@ In case (1), the pointer is picked up in an RCU-safe manner for vanilla
 RCU read-side critical sections, in case (2) the ->file_lock prevents
 any change from taking place, and finally, in case (3) the current task
 is the only task accessing the file_struct, again preventing any change
-from taking place.
+from taking place.  If the above statement was invoked only from updater
+code, it could instead be written as follows:
+
+	file = rcu_dereference_protected(fdt->fd[fd],
+					 lockdep_is_held(&files->file_lock) ||
+					 atomic_read(&files->count) == 1);
+
+This would verify cases #2 and #3 above, and furthermore lockdep would
+complain if this was used in an RCU read-side critical section unless one
+of these two cases held.  Because rcu_dereference_protected() omits all
+barriers and compiler constraints, it generates better code than do the
+other flavors of rcu_dereference().  On the other hand, it is illegal
+to use rcu_dereference_protected() if either the RCU-protected pointer
+or the RCU-protected data that it points to can change concurrently.
 
 There are currently only "universal" versions of the rcu_assign_pointer()
 and RCU list-/tree-traversal primitives, which do not (yet) check for
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 1dc00ee..cfaac34 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -840,6 +840,12 @@ SRCU:	Initialization/cleanup
 	init_srcu_struct
 	cleanup_srcu_struct
 
+All:  lockdep-checked RCU-protected pointer access
+
+	rcu_dereference_check
+	rcu_dereference_protected
+	rcu_access_pointer
+
 See the comment headers in the source code (or the docbook generated
 from them) for more information.
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 872a98e..07db2fe 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -101,10 +101,7 @@ extern struct lockdep_map rcu_sched_lock_map;
 # define rcu_read_release_sched() \
 		lock_release(&rcu_sched_lock_map, 1, _THIS_IP_)
 
-static inline int debug_lockdep_rcu_enabled(void)
-{
-	return likely(rcu_scheduler_active && debug_locks);
-}
+extern int debug_lockdep_rcu_enabled(void);
 
 /**
  * rcu_read_lock_held - might we be in RCU read-side critical section?
@@ -195,12 +192,30 @@ static inline int rcu_read_lock_sched_held(void)
 
 /**
  * rcu_dereference_check - rcu_dereference with debug checking
+ * @p: The pointer to read, prior to dereferencing
+ * @c: The conditions under which the dereference will take place
+ *
+ * Do an rcu_dereference(), but check that the conditions under which the
+ * dereference will take place are correct.  Typically the conditions indicate
+ * the various locking conditions that should be held at that point.  The check
+ * should return true if the conditions are satisfied.
+ *
+ * For example:
+ *
+ *	bar = rcu_dereference_check(foo->bar, rcu_read_lock_held() ||
+ *					      lockdep_is_held(&foo->lock));
  *
- * Do an rcu_dereference(), but check that the context is correct.
- * For example, rcu_dereference_check(gp, rcu_read_lock_held()) to
- * ensure that the rcu_dereference_check() executes within an RCU
- * read-side critical section.  It is also possible to check for
- * locks being held, for example, by using lockdep_is_held().
+ * could be used to indicate to lockdep that foo->bar may only be dereferenced
+ * if either the RCU read lock is held, or that the lock required to replace
+ * the bar struct at foo->bar is held.
+ *
+ * Note that the list of conditions may also include indications of when a lock
+ * need not be held, for example during initialisation or destruction of the
+ * target struct:
+ *
+ *	bar = rcu_dereference_check(foo->bar, rcu_read_lock_held() ||
+ *					      lockdep_is_held(&foo->lock) ||
+ *					      atomic_read(&foo->usage) == 0);
  */
 #define rcu_dereference_check(p, c) \
 	({ \
@@ -209,13 +224,45 @@ static inline int rcu_read_lock_sched_held(void)
 		rcu_dereference_raw(p); \
 	})
 
+/**
+ * rcu_dereference_protected - fetch RCU pointer when updates prevented
+ *
+ * Return the value of the specified RCU-protected pointer, but omit
+ * both the smp_read_barrier_depends() and the ACCESS_ONCE().  This
+ * is useful in cases where update-side locks prevent the value of the
+ * pointer from changing.  Please note that this primitive does -not-
+ * prevent the compiler from repeating this reference or combining it
+ * with other references, so it should not be used without protection
+ * of appropriate locks.
+ */
+#define rcu_dereference_protected(p, c) \
+	({ \
+		if (debug_lockdep_rcu_enabled() && !(c)) \
+			lockdep_rcu_dereference(__FILE__, __LINE__); \
+		(p); \
+	})
+
 #else /* #ifdef CONFIG_PROVE_RCU */
 
 #define rcu_dereference_check(p, c)	rcu_dereference_raw(p)
+#define rcu_dereference_protected(p, c) (p)
 
 #endif /* #else #ifdef CONFIG_PROVE_RCU */
 
 /**
+ * rcu_access_pointer - fetch RCU pointer with no dereferencing
+ *
+ * Return the value of the specified RCU-protected pointer, but omit the
+ * smp_read_barrier_depends() and keep the ACCESS_ONCE().  This is useful
+ * when the value of this pointer is accessed, but the pointer is not
+ * dereferenced, for example, when testing an RCU-protected pointer against
+ * NULL.  This may also be used in cases where update-side locks prevent
+ * the value of the pointer from changing, but rcu_dereference_protected()
+ * is a lighter-weight primitive for this use case.
+ */
+#define rcu_access_pointer(p)	ACCESS_ONCE(p)
+
+/**
  * rcu_read_lock - mark the beginning of an RCU read-side critical section.
  *
  * When synchronize_rcu() is invoked on one CPU while other CPUs
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 63fe254..03a7ea1 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -69,6 +69,13 @@ EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
+int debug_lockdep_rcu_enabled(void)
+{
+	return rcu_scheduler_active && debug_locks &&
+	       current->lockdep_recursion == 0;
+}
+EXPORT_SYMBOL_GPL(debug_lockdep_rcu_enabled);
+
 /**
  * rcu_read_lock_bh_held - might we be in RCU-bh read-side critical section?
  *
