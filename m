Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab0DESf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 14:35:29 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48095 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559Ab0DESem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 14:34:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 07/10] rcu: shrink rcutiny by making synchronize_rcu_bh() be inline
Date: Mon,  5 Apr 2010 11:34:29 -0700
Message-Id: <1270492472-23222-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100405183403.GA23075@linux.vnet.ibm.com>
References: <20100405183403.GA23075@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because synchronize_rcu_bh() is identical to synchronize_sched(),
make the former a static inline invoking the latter, saving the
overhead of an EXPORT_SYMBOL_GPL() and the duplicate code.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    2 --
 include/linux/rcutiny.h  |   12 +++++++++++-
 include/linux/rcutree.h  |    2 ++
 kernel/rcutiny.c         |    9 ++-------
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 804ce3e..56fa2d4 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -56,8 +56,6 @@ struct rcu_head {
 };
 
 /* Exported common interfaces */
-extern void synchronize_rcu_bh(void);
-extern void synchronize_sched(void);
 extern void rcu_barrier(void);
 extern void rcu_barrier_bh(void);
 extern void rcu_barrier_sched(void);
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index a519587..bbeb55b 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -74,7 +74,17 @@ static inline void rcu_sched_force_quiescent_state(void)
 {
 }
 
-#define synchronize_rcu synchronize_sched
+extern void synchronize_sched(void);
+
+static inline void synchronize_rcu(void)
+{
+	synchronize_sched();
+}
+
+static inline void synchronize_rcu_bh(void)
+{
+	synchronize_sched();
+}
 
 static inline void synchronize_rcu_expedited(void)
 {
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 42cc3a0..7484fe6 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -86,6 +86,8 @@ static inline void __rcu_read_unlock_bh(void)
 
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));
+extern void synchronize_rcu_bh(void);
+extern void synchronize_sched(void);
 extern void synchronize_rcu_expedited(void);
 
 static inline void synchronize_rcu_bh_expedited(void)
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 9f6d9ff..272c6d2 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -187,7 +187,8 @@ static void rcu_process_callbacks(struct softirq_action *unused)
  *
  * Cool, huh?  (Due to Josh Triplett.)
  *
- * But we want to make this a static inline later.
+ * But we want to make this a static inline later.  The cond_resched()
+ * currently makes this problematic.
  */
 void synchronize_sched(void)
 {
@@ -195,12 +196,6 @@ void synchronize_sched(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_sched);
 
-void synchronize_rcu_bh(void)
-{
-	synchronize_sched();
-}
-EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
-
 /*
  * Helper function for call_rcu() and call_rcu_bh().
  */
-- 
1.7.0

