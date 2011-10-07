Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202Ab1JGQYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:24:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50139 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760121Ab1JGQWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:22:32 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/11] rcu: Warn when srcu_read_lock() is used in an extended quiescent state
Date: Fri,  7 Oct 2011 18:22:04 +0200
Message-Id: <1318004530-705-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318004530-705-1-git-send-email-fweisbec@gmail.com>
References: <1318004530-705-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Catch SRCU up to the other variants of RCU by making PROVE_RCU
complain if either srcu_read_lock() or srcu_read_lock_held() are
used from within RCU-idle mode.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/srcu.h |   35 ++++++++++++++++++++++-------------
 1 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 58971e8..553c003 100644
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
@@ -90,12 +83,28 @@ long srcu_batches_completed(struct srcu_struct *sp);
  * read-side critical section.  In absence of CONFIG_DEBUG_LOCK_ALLOC,
  * this assumes we are in an SRCU read-side critical section unless it can
  * prove otherwise.
+ *
+ * Note that if the CPU is in the idle loop from an RCU point of view
+ * (ie: that we are in the section between rcu_idle_enter() and rcu_idle_exit())
+ * then srcu_read_lock_held() returns false even if the CPU did an srcu_read_lock().
+ * The reason for this is that RCU ignores CPUs that are in such a section,
+ * considering these as in extended quiescent state, so such a CPU is effectively
+ * never in an RCU read-side critical section regardless of what RCU primitives it
+ * invokes.  This state of affairs is required --- we need to keep an RCU-free
+ * window in idle where the CPU may possibly enter into low power mode. This way
+ * we can notice an extended quiescent state to other CPUs that started a grace
+ * period. Otherwise we would delay any grace period as long as we run in the
+ * idle task.
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
@@ -150,7 +159,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 {
 	int retval = __srcu_read_lock(sp);
 
-	srcu_read_acquire(sp);
+	rcu_lock_acquire(&(sp)->dep_map);
 	return retval;
 }
 
@@ -164,7 +173,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
 static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
 	__releases(sp)
 {
-	srcu_read_release(sp);
+	rcu_lock_release(&(sp)->dep_map);
 	__srcu_read_unlock(sp, idx);
 }
 
-- 
1.7.5.4

