Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab1FFDMC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 23:12:02 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62855 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab1FFDLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 23:11:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=a2TlhP8HhI2axoPCu/PJjyNlii2fDMynAJA0IjWBcI8Up7G81C4dYTIx72OhMrXAsz
         wisx/Nq79CVOfDCCbWQs6qmYMzW7V90Qr65POyH/slfXYZO64l9ayGSCB57or8gETp8H
         BUMYb7ynIC8wRBMaicRLqGQMyztxc4A00te9A=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/4] rcu: Detect uses of rcu read side in extended quiescent states
Date: Mon,  6 Jun 2011 05:10:55 +0200
Message-Id: <1307329858-14999-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1307329858-14999-1-git-send-email-fweisbec@gmail.com>
References: <1307329858-14999-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detect uses of rcu that are not supposed to happen when we
are in an extended quiescent state.

This can happen for example if we use rcu between the time we
stop the tick and the time we restart it. Or inside an irq that
didn't use rcu_irq_enter,exit() or other possible kind of rcu API
misuse.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/lockdep.h  |    8 +++++++-
 include/linux/rcupdate.h |   20 ++++++++++++++------
 kernel/lockdep.c         |   12 +++++++++---
 kernel/pid.c             |    2 +-
 kernel/rcutree.c         |   14 ++++++++++++++
 5 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index ef820a3..452d547 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -547,8 +547,14 @@ do {									\
 # define might_lock_read(lock) do { } while (0)
 #endif
 
+enum rcu_warn {
+	RCU_WARN_UNPROTECTED,
+	RCU_WARN_EXT_QS
+};
+
 #ifdef CONFIG_PROVE_RCU
-extern void lockdep_rcu_dereference(const char *file, const int line);
+extern void
+lockdep_rcu_dereference(const char *file, const int line, enum rcu_warn type);
 #endif
 
 #endif /* __LINUX_LOCKDEP_H */
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 99f9aa7..651d90b 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -297,22 +297,29 @@ extern int rcu_my_thread_group_empty(void);
 /**
  * rcu_lockdep_assert - emit lockdep splat if specified condition not met
  * @c: condition to check
+ * @t: type of the rcu problem detected
  */
-#define rcu_lockdep_assert(c)						\
+#define rcu_lockdep_assert(c, t)					\
 	do {								\
 		static bool __warned;					\
 		if (debug_lockdep_rcu_enabled() && !__warned && !(c)) {	\
 			__warned = true;				\
-			lockdep_rcu_dereference(__FILE__, __LINE__);	\
+			lockdep_rcu_dereference(__FILE__, __LINE__, t);	\
 		}							\
 	} while (0)
 
 #else /* #ifdef CONFIG_PROVE_RCU */
 
-#define rcu_lockdep_assert(c) do { } while (0)
+#define rcu_lockdep_assert(c, t) do { } while (0)
 
 #endif /* #else #ifdef CONFIG_PROVE_RCU */
 
+#if defined(CONFIG_PROVE_RCU) && defined(CONFIG_NO_HZ)
+extern bool rcu_check_extended_qs(void);
+#else
+static inline bool rcu_check_extended_qs(void) { return false; }
+#endif
+
 /*
  * Helper functions for rcu_dereference_check(), rcu_dereference_protected()
  * and rcu_assign_pointer().  Some of these could be folded into their
@@ -338,14 +345,15 @@ extern int rcu_my_thread_group_empty(void);
 #define __rcu_dereference_check(p, c, space) \
 	({ \
 		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
-		rcu_lockdep_assert(c); \
+		rcu_lockdep_assert(c, RCU_WARN_UNPROTECTED); \
+		rcu_lockdep_assert(!rcu_check_extended_qs(), RCU_WARN_EXT_QS); \
 		rcu_dereference_sparse(p, space); \
 		smp_read_barrier_depends(); \
 		((typeof(*p) __force __kernel *)(_________p1)); \
 	})
 #define __rcu_dereference_protected(p, c, space) \
 	({ \
-		rcu_lockdep_assert(c); \
+		rcu_lockdep_assert(c, RCU_WARN_UNPROTECTED); \
 		rcu_dereference_sparse(p, space); \
 		((typeof(*p) __force __kernel *)(p)); \
 	})
@@ -359,7 +367,7 @@ extern int rcu_my_thread_group_empty(void);
 #define __rcu_dereference_index_check(p, c) \
 	({ \
 		typeof(p) _________p1 = ACCESS_ONCE(p); \
-		rcu_lockdep_assert(c); \
+		rcu_lockdep_assert(c, RCU_WARN_UNPROTECTED); \
 		smp_read_barrier_depends(); \
 		(_________p1); \
 	})
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 63437d0..eccfede 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3982,7 +3982,8 @@ void lockdep_sys_exit(void)
 	}
 }
 
-void lockdep_rcu_dereference(const char *file, const int line)
+void lockdep_rcu_dereference(const char *file, const int line,
+			     enum rcu_warn type)
 {
 	struct task_struct *curr = current;
 
@@ -3994,8 +3995,13 @@ void lockdep_rcu_dereference(const char *file, const int line)
 	printk("\n===================================================\n");
 	printk(  "[ INFO: suspicious rcu_dereference_check() usage. ]\n");
 	printk(  "---------------------------------------------------\n");
-	printk("%s:%d invoked rcu_dereference_check() without protection!\n",
-			file, line);
+	printk("%s:%d invoked rcu_dereference_check() ", file, line);
+
+	if (type == RCU_WARN_UNPROTECTED)
+		printk("without protection!\n");
+	else if (type == RCU_WARN_EXT_QS)
+		printk("while in RCU extended quiescent state!\n");
+
 	printk("\nother info that might help us debug this:\n\n");
 	printk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
 	lockdep_print_held_locks(curr);
diff --git a/kernel/pid.c b/kernel/pid.c
index 57a8346..87dd3c5 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -419,7 +419,7 @@ EXPORT_SYMBOL(pid_task);
  */
 struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
 {
-	rcu_lockdep_assert(rcu_read_lock_held());
+	rcu_lockdep_assert(rcu_read_lock_held(), RCU_WARN_UNPROTECTED);
 	return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
 }
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 89419ff..992ec56 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -433,6 +433,20 @@ void rcu_irq_exit(void)
 	rcu_enter_nohz();
 }
 
+#ifdef CONFIG_PROVE_RCU
+
+bool rcu_check_extended_qs(void)
+{
+	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+
+	if (atomic_read(&rdtp->dynticks) & 0x1)
+		return false;
+
+	return true;
+}
+
+#endif /* CONFIG_PROVE_RCU */
+
 #ifdef CONFIG_SMP
 
 /*
-- 
1.7.5.2

