Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab0GNUL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:11:28 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54619 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757374Ab0GNUKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:10:23 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 28/30] rcu: rename __do_rcu_dereference_check() to rcu_lockdep_assert()
Date: Wed, 14 Jul 2010 13:10:02 -0700
Message-Id: <1279138204-12849-28-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100714200945.GA10535@linux.vnet.ibm.com>
References: <20100714200945.GA10535@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __do_rcu_dereference_check() functionality needs to be exported,
so make a real name for it.  This allows RCU-lockdep assertions to
be used independent of rcu_dereference() and friends.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 0ce0f05..508ebba 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -209,7 +209,11 @@ static inline int rcu_read_lock_sched_held(void)
 
 extern int rcu_my_thread_group_empty(void);
 
-#define __do_rcu_dereference_check(c)					\
+/**
+ * rcu_lockdep_assert - emit lockdep splat if specified condition not met
+ * @c: condition to check
+ */
+#define rcu_lockdep_assert(c)						\
 	do {								\
 		static bool __warned;					\
 		if (debug_lockdep_rcu_enabled() && !__warned && !(c)) {	\
@@ -220,7 +224,7 @@ extern int rcu_my_thread_group_empty(void);
 
 #else /* #ifdef CONFIG_PROVE_RCU */
 
-#define __do_rcu_dereference_check(c) do { } while (0)
+#define rcu_lockdep_assert(c) do { } while (0)
 
 #endif /* #else #ifdef CONFIG_PROVE_RCU */
 
@@ -241,14 +245,14 @@ extern int rcu_my_thread_group_empty(void);
 #define __rcu_dereference_check(p, c, space) \
 	({ \
 		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
-		__do_rcu_dereference_check(c); \
+		rcu_lockdep_assert(c); \
 		(void) (((typeof (*p) space *)p) == p); \
 		smp_read_barrier_depends(); \
 		((typeof(*p) __force __kernel *)(_________p1)); \
 	})
 #define __rcu_dereference_protected(p, c, space) \
 	({ \
-		__do_rcu_dereference_check(c); \
+		rcu_lockdep_assert(c); \
 		(void) (((typeof (*p) space *)p) == p); \
 		((typeof(*p) __force __kernel *)(p)); \
 	})
@@ -256,7 +260,7 @@ extern int rcu_my_thread_group_empty(void);
 #define __rcu_dereference_index_check(p, c) \
 	({ \
 		typeof(p) _________p1 = ACCESS_ONCE(p); \
-		__do_rcu_dereference_check(c); \
+		rcu_lockdep_assert(c); \
 		smp_read_barrier_depends(); \
 		(_________p1); \
 	})
-- 
1.7.0.6

