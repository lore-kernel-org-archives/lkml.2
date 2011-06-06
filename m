Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab1FFSK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:10:28 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46735 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab1FFSK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:10:26 -0400
Date: Mon, 6 Jun 2011 11:10:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Milton Miller <miltonm@bga.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [1/4] rcu: Detect uses of rcu read side in extended quiescent
 states
Message-ID: <20110606181021.GL3066@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1307329858-14999-3-git-send-email-fweisbec@gmail.com>
 <rcu-splat-split-printk@mdm.bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rcu-splat-split-printk@mdm.bga.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 05, 2011 at 10:44:33PM -0500, Milton Miller wrote:
> On Mon, 06 Jun 2011 about 03:10:55 -0000, Frederic Weisbecker wrote:
> > @@ -3994,8 +3995,13 @@ void lockdep_rcu_dereference(const char *file, const int line)
> >  	printk("\n===================================================\n");
> >  	printk(  "[ INFO: suspicious rcu_dereference_check() usage. ]\n");
> >  	printk(  "---------------------------------------------------\n");
> > -	printk("%s:%d invoked rcu_dereference_check() without protection!\n",
> > -			file, line);
> > +	printk("%s:%d invoked rcu_dereference_check() ", file, line);
> > +
> > +	if (type == RCU_WARN_UNPROTECTED)
> > +		printk("without protection!\n");
> > +	else if (type == RCU_WARN_EXT_QS)
> > +		printk("while in RCU extended quiescent state!\n");
> > +
> >  	printk("\nother info that might help us debug this:\n\n");
> >  	printk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
> >  	lockdep_print_held_locks(curr);
> 
> Can we keep the above in one printk?   That way the printing is
> guaranteed to come out on one line.  Probably the easiest way would
> be add char *why = "" then assign a string based on the current
> conditions.  Do all of that before the first printk which gets the
> a %s added.

I have the following queued the -rcu tree which does add the string.

Frederic, would it be possible to base on this patch?

							Thanx, Paul

------------------------------------------------------------------------

commit c15d76f26712bd5228aa0c6af7a7e7c492a812c9
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Tue May 24 08:31:09 2011 -0700

    rcu: Restore checks for blocking in RCU read-side critical sections
    
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
    
    Finally, add a pair of rcu_lockdep_assert() calls from within
    rcu_note_context_switch(), one complaining if a context switch occurs
    in an RCU-bh read-side critical section and another complaining if a
    context switch occurs in an RCU-sched read-side critical section.
    These are present only if the PROVE_RCU kernel parameter is enabled.
    
    Again, you must enable PROVE_RCU to see these new diagnostics.  But you
    are enabling PROVE_RCU to check out new RCU uses in any case, aren't you?
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 4aef1dd..bfa66e7 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -545,7 +545,7 @@ do {									\
 #endif
 
 #ifdef CONFIG_PROVE_RCU
-extern void lockdep_rcu_dereference(const char *file, const int line);
+void lockdep_rcu_suspicious(const char *file, const int line, const char *s);
 #endif
 
 #endif /* __LINUX_LOCKDEP_H */
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 58b13f1..fb2933d 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -297,19 +297,20 @@ extern int rcu_my_thread_group_empty(void);
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
 
 #else /* #ifdef CONFIG_PROVE_RCU */
 
-#define rcu_lockdep_assert(c) do { } while (0)
+#define rcu_lockdep_assert(c, s) do { } while (0)
 
 #endif /* #else #ifdef CONFIG_PROVE_RCU */
 
@@ -338,14 +339,16 @@ extern int rcu_my_thread_group_empty(void);
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
@@ -359,7 +362,9 @@ extern int rcu_my_thread_group_empty(void);
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
index 53a6895..9789028 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3798,7 +3798,7 @@ void lockdep_sys_exit(void)
 	}
 }
 
-void lockdep_rcu_dereference(const char *file, const int line)
+void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 {
 	struct task_struct *curr = current;
 
@@ -3807,9 +3807,10 @@ void lockdep_rcu_dereference(const char *file, const int line)
 		return;
 #endif /* #ifdef CONFIG_PROVE_RCU_REPEATEDLY */
 	/* Note: the following can be executed concurrently, so be careful. */
-	printk("\n===================================================\n");
-	printk(  "[ INFO: suspicious rcu_dereference_check() usage. ]\n");
-	printk(  "---------------------------------------------------\n");
+	printk("\n===============================\n");
+	printk(  "[ INFO: suspicious RCU usage. ]\n");
+	printk(  "-------------------------------\n");
+	printk(  "%s\n", s);
 	printk("%s:%d invoked rcu_dereference_check() without protection!\n",
 			file, line);
 	printk("\nother info that might help us debug this:\n\n");
@@ -3818,4 +3819,4 @@ void lockdep_rcu_dereference(const char *file, const int line)
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
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 88547c8..8b4b3da 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -153,6 +153,12 @@ void rcu_bh_qs(int cpu)
  */
 void rcu_note_context_switch(int cpu)
 {
+	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map),
+			   "Illegal context switch in RCU-bh"
+			   " read-side critical section");
+	rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),
+			   "Illegal context switch in RCU-sched"
+			   " read-side critical section");
 	rcu_sched_qs(cpu);
 	rcu_preempt_note_context_switch(cpu);
 }
