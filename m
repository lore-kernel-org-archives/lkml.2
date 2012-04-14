Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2DNQWE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:22:04 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50857 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab2DNQUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:20:54 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org, torvalds@linux-foundation.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC 2/7] rcu: Create per-CPU variables and avoid name conflict
Date: Sat, 14 Apr 2012 09:20:32 -0700
Message-Id: <1334420437-19264-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1334420437-19264-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120414161953.GA18140@linux.vnet.ibm.com>
 <1334420437-19264-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041416-5518-0000-0000-000003AA61D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

This commit creates the rcu_read_lock_nesting and rcu_read_unlock_special
per-CPU variables, and renames the rcu_read_unlock_special() function to
rcu_read_unlock_do_special() to avoid a name conflict with the new per-CPU
variable.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    3 +++
 kernel/rcupdate.c        |    5 +++++
 kernel/rcutiny_plugin.h  |   10 +++++-----
 kernel/rcutree_plugin.h  |   12 ++++++------
 4 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index aca4ef0..1cf19ef 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -144,6 +144,9 @@ extern void synchronize_sched(void);
 
 #ifdef CONFIG_PREEMPT_RCU
 
+DECLARE_PER_CPU(int, rcu_read_lock_nesting);
+DECLARE_PER_CPU(int, rcu_read_unlock_special);
+
 extern void __rcu_read_lock(void);
 extern void __rcu_read_unlock(void);
 void synchronize_rcu(void);
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index a86f174..eb5d160 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -51,6 +51,11 @@
 
 #include "rcu.h"
 
+#ifdef CONFIG_PREEMPT_RCU
+DEFINE_PER_CPU(int, rcu_read_lock_nesting);
+DEFINE_PER_CPU(int, rcu_read_unlock_special);
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
 struct lockdep_map rcu_lock_map =
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 22ecea0..ff7ec65 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -132,7 +132,7 @@ static struct rcu_preempt_ctrlblk rcu_preempt_ctrlblk = {
 	RCU_TRACE(.rcb.name = "rcu_preempt")
 };
 
-static void rcu_read_unlock_special(struct task_struct *t);
+static void rcu_read_unlock_do_special(struct task_struct *t);
 static int rcu_preempted_readers_exp(void);
 static void rcu_report_exp_done(void);
 
@@ -510,7 +510,7 @@ void rcu_preempt_note_context_switch(void)
 		 * Complete exit from RCU read-side critical section on
 		 * behalf of preempted instance of __rcu_read_unlock().
 		 */
-		rcu_read_unlock_special(t);
+		rcu_read_unlock_do_special(t);
 	}
 
 	/*
@@ -543,7 +543,7 @@ EXPORT_SYMBOL_GPL(__rcu_read_lock);
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
  */
-static noinline void rcu_read_unlock_special(struct task_struct *t)
+static noinline void rcu_read_unlock_do_special(struct task_struct *t)
 {
 	int empty;
 	int empty_exp;
@@ -630,7 +630,7 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
  * Tiny-preemptible RCU implementation for rcu_read_unlock().
  * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
  * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
- * invoke rcu_read_unlock_special() to clean up after a context switch
+ * invoke rcu_read_unlock_do_special() to clean up after a context switch
  * in an RCU read-side critical section and other special cases.
  */
 void __rcu_read_unlock(void)
@@ -644,7 +644,7 @@ void __rcu_read_unlock(void)
 		t->rcu_read_lock_nesting = INT_MIN;
 		barrier();  /* assign before ->rcu_read_unlock_special load */
 		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
-			rcu_read_unlock_special(t);
+			rcu_read_unlock_do_special(t);
 		barrier();  /* ->rcu_read_unlock_special load before assign */
 		t->rcu_read_lock_nesting = 0;
 	}
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index b1ac22e..f60b315 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -78,7 +78,7 @@ struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt);
 DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
 static struct rcu_state *rcu_state = &rcu_preempt_state;
 
-static void rcu_read_unlock_special(struct task_struct *t);
+static void rcu_read_unlock_do_special(struct task_struct *t);
 static int rcu_preempted_readers_exp(struct rcu_node *rnp);
 
 /*
@@ -215,7 +215,7 @@ void rcu_preempt_note_context_switch(void)
 		 * Complete exit from RCU read-side critical section on
 		 * behalf of preempted instance of __rcu_read_unlock().
 		 */
-		rcu_read_unlock_special(t);
+		rcu_read_unlock_do_special(t);
 	}
 
 	/*
@@ -310,7 +310,7 @@ static struct list_head *rcu_next_node_entry(struct task_struct *t,
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
  */
-static noinline void rcu_read_unlock_special(struct task_struct *t)
+static noinline void rcu_read_unlock_do_special(struct task_struct *t)
 {
 	int empty;
 	int empty_exp;
@@ -422,7 +422,7 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
  * Tree-preemptible RCU implementation for rcu_read_unlock().
  * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
  * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
- * invoke rcu_read_unlock_special() to clean up after a context switch
+ * invoke rcu_read_unlock_do_special() to clean up after a context switch
  * in an RCU read-side critical section and other special cases.
  */
 void __rcu_read_unlock(void)
@@ -436,7 +436,7 @@ void __rcu_read_unlock(void)
 		t->rcu_read_lock_nesting = INT_MIN;
 		barrier();  /* assign before ->rcu_read_unlock_special load */
 		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
-			rcu_read_unlock_special(t);
+			rcu_read_unlock_do_special(t);
 		barrier();  /* ->rcu_read_unlock_special load before assign */
 		t->rcu_read_lock_nesting = 0;
 	}
@@ -573,7 +573,7 @@ static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
  * Handle tasklist migration for case in which all CPUs covered by the
  * specified rcu_node have gone offline.  Move them up to the root
  * rcu_node.  The reason for not just moving them to the immediate
- * parent is to remove the need for rcu_read_unlock_special() to
+ * parent is to remove the need for rcu_read_unlock_do_special() to
  * make more than two attempts to acquire the target rcu_node's lock.
  * Returns true if there were tasks blocking the current RCU grace
  * period.
-- 
1.7.8

