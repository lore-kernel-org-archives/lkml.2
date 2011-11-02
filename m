Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab1KBUd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:33:59 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60779 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab1KBUdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:33:55 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH RFC tip/core/rcu 16/28] rcu: Warn when srcu_read_lock() is used in an extended quiescent state
Date: Wed,  2 Nov 2011 13:30:37 -0700
Message-Id: <1320265849-5744-16-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-5112-0000-0000-0000019EA448
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catch SRCU up to the other variants of RCU by making PROVE_RCU
complain if either srcu_read_lock() or srcu_read_lock_held() are
used from within RCU-idle mode.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/srcu.h |   36 +++++++++++++++++++++++-------------
 1 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 58971e8..4e0a3d4 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -28,6 +28,7 @@
 #define _LINUX_SRCU_H
 
 #include <linux/mutex.h>
+#include <linux/rcupdate.h>
 
 struct srcu_struct_array {
 	int c[2];
@@ -60,18 +61,10 @@ int __init_srcu_struct(struct srcu_struct *sp, const char *name,
 	__init_srcu_struct((sp), #sp, &__srcu_key); \
 })
 
-# define srcu_read_acquire(sp) \
-		lock_acquire(&(sp)->dep_map, 0, 0, 2, 1, NULL, _THIS_IP_)
-# define srcu_read_release(sp) \
-		lock_release(&(sp)->dep_map, 1, _THIS_IP_)
-
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 int init_srcu_struct(struct srcu_struct *sp);
 
-# define srcu_read_acquire(sp)  do { } while (0)
-# define srcu_read_release(sp)  do { } while (0)
-
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 void cleanup_srcu_struct(struct srcu_struct *sp);
@@ -90,12 +83,29 @@ long srcu_batches_completed(struct srcu_struct *sp);
  * read-side critical section.  In absence of CONFIG_DEBUG_LOCK_ALLOC,
  * this assumes we are in an SRCU read-side critical section unless it can
  * prove otherwise.
+ *
+ * Note that if the CPU is in the idle loop from an RCU point of view
+ * (ie: that we are in the section between rcu_idle_enter() and
+ * rcu_idle_exit()) then srcu_read_lock_held() returns false even if
+ * the CPU did an srcu_read_lock().  The reason for this is that RCU
+ * ignores CPUs that are in such a section, considering these as in
+ * extended quiescent state, so such a CPU is effectively never in an
+ * RCU read-side critical section regardless of what RCU primitives it
+ * invokes.  This state of affairs is required --- we need to keep an
+ * RCU-free window in idle where the CPU may possibly enter into low
+ * power mode. This way we can notice an extended quiescent state to
+ * other CPUs that started a grace period. Otherwise we would delay any
+ * grace period as long as we run in the idle task.
  */
 static inline int srcu_read_lock_held(struct srcu_struct *sp)
 {
-	if (debug_locks)
-		return lock_is_held(&sp->dep_map);
-	return 1;
+	if (rcu_is_cpu_idle())
+		return 0;
+
+	if (!debug_locks)
+		return 1;
+
+	return lock_is_held(&sp->dep_map);
 }
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
@@ -150,7 +160,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 {
 	int retval = __srcu_read_lock(sp);
 
-	srcu_read_acquire(sp);
+	rcu_lock_acquire(&(sp)->dep_map);
 	return retval;
 }
 
@@ -164,7 +174,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
 	__releases(sp)
 {
-	srcu_read_release(sp);
+	rcu_lock_release(&(sp)->dep_map);
 	__srcu_read_unlock(sp, idx);
 }
 
-- 
1.7.3.2

