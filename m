Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab2DNQU6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:20:58 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41568 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab2DNQU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:20:56 -0400
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
Subject: [PATCH RFC 7/7] rcu: Inline preemptible RCU __rcu_read_unlock()
Date: Sat, 14 Apr 2012 09:20:37 -0700
Message-Id: <1334420437-19264-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1334420437-19264-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120414161953.GA18140@linux.vnet.ibm.com>
 <1334420437-19264-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041416-2398-0000-0000-000005D1BC36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Move __rcu_read_unlock() from kernel/rcupdate.c to
include/linux/rcupdate.h, allowing the compiler to inline it.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   35 ++++++++++++++++++++++++++++++++++-
 kernel/rcu.h             |    4 ----
 kernel/rcupdate.c        |   33 ---------------------------------
 kernel/rcutiny_plugin.h  |    1 +
 kernel/rcutree_plugin.h  |    1 +
 5 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9967b2b..8113505 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -162,7 +162,40 @@ static inline void __rcu_read_lock(void)
 	barrier(); /* Keep code within RCU read-side critical section. */
 }
 
-extern void __rcu_read_unlock(void);
+extern void rcu_read_unlock_do_special(void);
+
+/*
+ * Tree-preemptible RCU implementation for rcu_read_unlock().
+ * Decrement rcu_read_lock_nesting.  If the result is zero (outermost
+ * rcu_read_unlock()) and rcu_read_unlock_special is non-zero, then
+ * invoke rcu_read_unlock_do_special() to clean up after a context switch
+ * in an RCU read-side critical section and other special cases.
+ * Set rcu_read_lock_nesting to a large negative value during cleanup
+ * in order to ensure that if rcu_read_unlock_special is non-zero, then
+ * rcu_read_lock_nesting is also non-zero.
+ */
+static inline void __rcu_read_unlock(void)
+{
+	if (__this_cpu_read(rcu_read_lock_nesting) != 1)
+		__this_cpu_dec(rcu_read_lock_nesting);
+	else {
+		barrier();  /* critical section before exit code. */
+		__this_cpu_write(rcu_read_lock_nesting, INT_MIN);
+		barrier();  /* assign before ->rcu_read_unlock_special load */
+		if (unlikely(__this_cpu_read(rcu_read_unlock_special)))
+			rcu_read_unlock_do_special();
+		barrier();  /* ->rcu_read_unlock_special load before assign */
+		__this_cpu_write(rcu_read_lock_nesting, 0);
+	}
+#ifdef CONFIG_PROVE_LOCKING
+	{
+		int rln = __this_cpu_read(rcu_read_lock_nesting);
+
+		WARN_ON_ONCE(rln < 0 && rln > INT_MIN / 2);
+	}
+#endif /* #ifdef CONFIG_PROVE_LOCKING */
+}
+
 void synchronize_rcu(void);
 
 /*
diff --git a/kernel/rcu.h b/kernel/rcu.h
index 6243d8d..8ba99cd 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -109,8 +109,4 @@ static inline bool __rcu_reclaim(char *rn, struct rcu_head *head)
 	}
 }
 
-#ifdef CONFIG_PREEMPT_RCU
-extern void rcu_read_unlock_do_special(void);
-#endif /* #ifdef CONFIG_PREEMPT_RCU */
-
 #endif /* __LINUX_RCU_H */
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index d52c68e..f607cb5 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -59,39 +59,6 @@ DEFINE_PER_CPU(struct task_struct *, rcu_current_task);
 #endif /* #ifdef CONFIG_PROVE_RCU */
 
 /*
- * Tree-preemptible RCU implementation for rcu_read_unlock().
- * Decrement rcu_read_lock_nesting.  If the result is zero (outermost
- * rcu_read_unlock()) and rcu_read_unlock_special is non-zero, then
- * invoke rcu_read_unlock_do_special() to clean up after a context switch
- * in an RCU read-side critical section and other special cases.
- * Set rcu_read_lock_nesting to a large negative value during cleanup
- * in order to ensure that if rcu_read_unlock_special is non-zero, then
- * rcu_read_lock_nesting is also non-zero.
- */
-void __rcu_read_unlock(void)
-{
-	if (__this_cpu_read(rcu_read_lock_nesting) != 1)
-		__this_cpu_dec(rcu_read_lock_nesting);
-	else {
-		barrier();  /* critical section before exit code. */
-		__this_cpu_write(rcu_read_lock_nesting, INT_MIN);
-		barrier();  /* assign before ->rcu_read_unlock_special load */
-		if (unlikely(__this_cpu_read(rcu_read_unlock_special)))
-			rcu_read_unlock_do_special();
-		barrier();  /* ->rcu_read_unlock_special load before assign */
-		__this_cpu_write(rcu_read_lock_nesting, 0);
-	}
-#ifdef CONFIG_PROVE_LOCKING
-	{
-		int rln = __this_cpu_read(rcu_read_lock_nesting);
-
-		WARN_ON_ONCE(rln < 0 && rln > INT_MIN / 2);
-	}
-#endif /* #ifdef CONFIG_PROVE_LOCKING */
-}
-EXPORT_SYMBOL_GPL(__rcu_read_unlock);
-
-/*
  * Check for a task exiting while in a preemptible-RCU read-side
  * critical section, clean up if so.  No need to issue warnings,
  * as debug_check_no_locks_held() already does this if lockdep
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 6b416af..49cb5b0 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -598,6 +598,7 @@ void rcu_read_unlock_do_special(void)
 	}
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(rcu_read_unlock_do_special);
 
 /*
  * Check for a quiescent state from the current CPU.  When a task blocks,
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 20be289..7afde96 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -409,6 +409,7 @@ void rcu_read_unlock_do_special(void)
 		local_irq_restore(flags);
 	}
 }
+EXPORT_SYMBOL_GPL(rcu_read_unlock_do_special);
 
 #ifdef CONFIG_RCU_CPU_STALL_VERBOSE
 
-- 
1.7.8

