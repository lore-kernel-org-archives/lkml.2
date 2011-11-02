Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1KBUcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:32:05 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33272 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab1KBUb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:31:59 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 15/28] rcu: Remove one layer of abstraction from PROVE_RCU checking
Date: Wed,  2 Nov 2011 13:30:36 -0700
Message-Id: <1320265849-5744-15-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-9360-0000-0000-00000045A4F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify things a bit by substituting the definitions of the single-line
rcu_read_acquire(), rcu_read_release(), rcu_read_acquire_bh(),
rcu_read_release_bh(), rcu_read_acquire_sched(), and
rcu_read_release_sched() functions at their call points.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   53 +++++++---------------------------------------
 1 files changed, 8 insertions(+), 45 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index d201c15..5dd6fd8 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -250,41 +250,8 @@ static inline void rcu_lock_release(struct lockdep_map *map)
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
@@ -364,12 +331,8 @@ static inline int rcu_read_lock_sched_held(void)
 
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
@@ -690,7 +653,7 @@ static inline void rcu_read_lock(void)
 {
 	__rcu_read_lock();
 	__acquire(RCU);
-	rcu_read_acquire();
+	rcu_lock_acquire(&rcu_lock_map);
 }
 
 /*
@@ -710,7 +673,7 @@ static inline void rcu_read_lock(void)
  */
 static inline void rcu_read_unlock(void)
 {
-	rcu_read_release();
+	rcu_lock_release(&rcu_lock_map);
 	__release(RCU);
 	__rcu_read_unlock();
 }
@@ -731,7 +694,7 @@ static inline void rcu_read_lock_bh(void)
 {
 	local_bh_disable();
 	__acquire(RCU_BH);
-	rcu_read_acquire_bh();
+	rcu_lock_acquire(&rcu_bh_lock_map);
 }
 
 /*
@@ -741,7 +704,7 @@ static inline void rcu_read_lock_bh(void)
  */
 static inline void rcu_read_unlock_bh(void)
 {
-	rcu_read_release_bh();
+	rcu_lock_release(&rcu_bh_lock_map);
 	__release(RCU_BH);
 	local_bh_enable();
 }
@@ -758,7 +721,7 @@ static inline void rcu_read_lock_sched(void)
 {
 	preempt_disable();
 	__acquire(RCU_SCHED);
-	rcu_read_acquire_sched();
+	rcu_lock_acquire(&rcu_sched_lock_map);
 }
 
 /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
@@ -775,7 +738,7 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
  */
 static inline void rcu_read_unlock_sched(void)
 {
-	rcu_read_release_sched();
+	rcu_lock_release(&rcu_sched_lock_map);
 	__release(RCU_SCHED);
 	preempt_enable();
 }
-- 
1.7.3.2

