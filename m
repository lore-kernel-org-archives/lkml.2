Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab2DNQVB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:21:01 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41581 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab2DNQU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:20:58 -0400
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
Subject: [PATCH RFC 6/7] rcu: Inline preemptible RCU __rcu_read_lock()
Date: Sat, 14 Apr 2012 09:20:36 -0700
Message-Id: <1334420437-19264-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1334420437-19264-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120414161953.GA18140@linux.vnet.ibm.com>
 <1334420437-19264-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041416-2398-0000-0000-000005D1BC38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Move __rcu_read_lock() from kernel/rcupdate.c to include/linux/rcupdate.h,
allowing the compiler to inline it.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   13 ++++++++++++-
 kernel/rcupdate.c        |   12 ------------
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 89f7e97..9967b2b 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -43,6 +43,7 @@
 #include <linux/completion.h>
 #include <linux/debugobjects.h>
 #include <linux/compiler.h>
+#include <linux/percpu.h>
 
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable; /* for sysctl */
@@ -150,7 +151,17 @@ DECLARE_PER_CPU(int, rcu_read_unlock_special);
 DECLARE_PER_CPU(struct task_struct *, rcu_current_task);
 #endif /* #ifdef CONFIG_PROVE_RCU */
 
-extern void __rcu_read_lock(void);
+/*
+ * Preemptible-RCU implementation for rcu_read_lock().  Just increment
+ * the per-CPU rcu_read_lock_nesting: Shared state and per-task state will
+ * be updated if we block.
+ */
+static inline void __rcu_read_lock(void)
+{
+	__this_cpu_inc(rcu_read_lock_nesting);
+	barrier(); /* Keep code within RCU read-side critical section. */
+}
+
 extern void __rcu_read_unlock(void);
 void synchronize_rcu(void);
 
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index f77a5fc..d52c68e 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -59,18 +59,6 @@ DEFINE_PER_CPU(struct task_struct *, rcu_current_task);
 #endif /* #ifdef CONFIG_PROVE_RCU */
 
 /*
- * Preemptible-RCU implementation for rcu_read_lock().  Just increment
- * the per-CPU rcu_read_lock_nesting: Shared state and per-task state will
- * be updated if we block.
- */
-void __rcu_read_lock(void)
-{
-	__this_cpu_inc(rcu_read_lock_nesting);
-	barrier(); /* Keep code within RCU read-side critical section. */
-}
-EXPORT_SYMBOL_GPL(__rcu_read_lock);
-
-/*
  * Tree-preemptible RCU implementation for rcu_read_unlock().
  * Decrement rcu_read_lock_nesting.  If the result is zero (outermost
  * rcu_read_unlock()) and rcu_read_unlock_special is non-zero, then
-- 
1.7.8

