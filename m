Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133Ab1JGQWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:22:34 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41062 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760108Ab1JGQWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:22:30 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/11] rcu: Remove one layer of abstraction from PROVE_RCU checking
Date: Fri,  7 Oct 2011 18:22:03 +0200
Message-Id: <1318004530-705-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318004530-705-1-git-send-email-fweisbec@gmail.com>
References: <1318004530-705-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Simplify things a bit by substituting the definitions of the single-line
rcu_read_acquire(), rcu_read_release(), rcu_read_acquire_bh(),
rcu_read_release_bh(), rcu_read_acquire_sched(), and
rcu_read_release_sched() functions at their call points.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   53 +++++++---------------------------------------
 1 files changed, 8 insertions(+), 45 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index fe4f8976..e550f2a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -240,41 +240,8 @@ static inline void rcu_lock_release(struct lockdep_map *map)
 }
 
 extern struct lockdep_map rcu_lock_map;
-
-static inline void rcu_read_acquire(void)
-{
-	rcu_lock_acquire(&rcu_lock_map);
-}
-
-static inline void rcu_read_release(void)
-{
-	rcu_lock_release(&rcu_lock_map);
-}
-
 extern struct lockdep_map rcu_bh_lock_map;
-
-static inline void rcu_read_acquire_bh(void)
-{
-	rcu_lock_acquire(&rcu_bh_lock_map);
-}
-
-static inline void rcu_read_release_bh(void)
-{
-	rcu_lock_release(&rcu_bh_lock_map);
-}
-
 extern struct lockdep_map rcu_sched_lock_map;
-
-static inline void rcu_read_acquire_sched(void)
-{
-	rcu_lock_acquire(&rcu_sched_lock_map);
-}
-
-static inline void rcu_read_release_sched(void)
-{
-	rcu_lock_release(&rcu_sched_lock_map);
-}
-
 extern int debug_lockdep_rcu_enabled(void);
 
 /**
@@ -357,12 +324,8 @@ static inline int rcu_read_lock_sched_held(void)
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
-# define rcu_read_acquire()		do { } while (0)
-# define rcu_read_release()		do { } while (0)
-# define rcu_read_acquire_bh()		do { } while (0)
-# define rcu_read_release_bh()		do { } while (0)
-# define rcu_read_acquire_sched()	do { } while (0)
-# define rcu_read_release_sched()	do { } while (0)
+# define rcu_lock_acquire(a)		do { } while (0)
+# define rcu_lock_release(a)		do { } while (0)
 
 static inline int rcu_read_lock_held(void)
 {
@@ -683,7 +646,7 @@ static inline void rcu_read_lock(void)
 {
 	__rcu_read_lock();
 	__acquire(RCU);
-	rcu_read_acquire();
+	rcu_lock_acquire(&rcu_lock_map);
 }
 
 /*
@@ -703,7 +666,7 @@ static inline void rcu_read_lock(void)
  */
 static inline void rcu_read_unlock(void)
 {
-	rcu_read_release();
+	rcu_lock_release(&rcu_lock_map);
 	__release(RCU);
 	__rcu_read_unlock();
 }
@@ -724,7 +687,7 @@ static inline void rcu_read_lock_bh(void)
 {
 	local_bh_disable();
 	__acquire(RCU_BH);
-	rcu_read_acquire_bh();
+	rcu_lock_acquire(&rcu_bh_lock_map);
 }
 
 /*
@@ -734,7 +697,7 @@ static inline void rcu_read_lock_bh(void)
  */
 static inline void rcu_read_unlock_bh(void)
 {
-	rcu_read_release_bh();
+	rcu_lock_release(&rcu_bh_lock_map);
 	__release(RCU_BH);
 	local_bh_enable();
 }
@@ -751,7 +714,7 @@ static inline void rcu_read_lock_sched(void)
 {
 	preempt_disable();
 	__acquire(RCU_SCHED);
-	rcu_read_acquire_sched();
+	rcu_lock_acquire(&rcu_sched_lock_map);
 }
 
 /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
@@ -768,7 +731,7 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
  */
 static inline void rcu_read_unlock_sched(void)
 {
-	rcu_read_release_sched();
+	rcu_lock_release(&rcu_sched_lock_map);
 	__release(RCU_SCHED);
 	preempt_enable();
 }
-- 
1.7.5.4

