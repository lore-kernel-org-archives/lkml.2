Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965873Ab0CPADt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 20:03:49 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45675 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965842Ab0CPADq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 20:03:46 -0400
Date: Mon, 15 Mar 2010 17:03:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       arnd@arndb.de
Subject: [PATCH tip/core/rcu] rcu: make rcu_read_lock_bh_held() allow for
	disabled BH
Message-ID: <20100316000343.GA25857@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disabling BH can stand in for rcu_read_lock_bh(), and this patch updates
rcu_read_lock_bh_held() to allow for this.  In order to avoid include-file
hell, this function is moved out of line to kernel/rcupdate.c.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   19 ++++---------------
 kernel/rcupdate.c        |   23 +++++++++++++++++++++++
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3024050..e1bdc4b 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -123,22 +123,11 @@ static inline int rcu_read_lock_held(void)
 	return lock_is_held(&rcu_lock_map);
 }
 
-/**
- * rcu_read_lock_bh_held - might we be in RCU-bh read-side critical section?
- *
- * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in
- * an RCU-bh read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
- * this assumes we are in an RCU-bh read-side critical section unless it can
- * prove otherwise.
- *
- * Check rcu_scheduler_active to prevent false positives during boot.
+/*
+ * rcu_read_lock_bh_held() is defined out of line to avoid #include-file
+ * hell.
  */
-static inline int rcu_read_lock_bh_held(void)
-{
-	if (!debug_lockdep_rcu_enabled())
-		return 1;
-	return lock_is_held(&rcu_bh_lock_map);
-}
+extern int rcu_read_lock_bh_held(void);
 
 /**
  * rcu_read_lock_sched_held - might we be in RCU-sched read-side critical section?
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index f1125c1..63fe254 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -45,6 +45,7 @@
 #include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/kernel_stat.h>
+#include <linux/hardirq.h>
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
@@ -66,6 +67,28 @@ EXPORT_SYMBOL_GPL(rcu_sched_lock_map);
 int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+/**
+ * rcu_read_lock_bh_held - might we be in RCU-bh read-side critical section?
+ *
+ * Check for bottom half being disabled, which covers both the
+ * CONFIG_PROVE_RCU and not cases.  Note that if someone uses
+ * rcu_read_lock_bh(), but then later enables BH, lockdep (if enabled)
+ * will show the situation.
+ *
+ * Check debug_lockdep_rcu_enabled() to prevent false positives during boot.
+ */
+int rcu_read_lock_bh_held(void)
+{
+	if (!debug_lockdep_rcu_enabled())
+		return 1;
+	return in_softirq();
+}
+EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
+
+#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 /*
  * This function is invoked towards the end of the scheduler's initialization
  * process.  Before this is called, the idle task might contain
-- 
1.6.6

