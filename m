Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab0IWAvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 20:51:55 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47629 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab0IWAvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 20:51:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH tip/core/rcu 5/8] rcu: only one evaluation of arg in rcu_dereference_check() unless sparse
Date: Wed, 22 Sep 2010 17:50:50 -0700
Message-Id: <1285203053-22068-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100923005033.GA22006@linux.vnet.ibm.com>
References: <20100923005033.GA22006@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current version of the __rcu_access_pointer(), __rcu_dereference_check(),
and __rcu_dereference_protected() macros evaluate their "p" argument
three times, not counting typeof()s.  This is bad news if that argument
contains a side effect.  This commit therefore evaluates this argument
only once in normal kernel builds.  However, the straightforward approach
defeats sparse's RCU-pointer checking, so when __CHECKER__ is defined,
the additional pair of evaluations of the "p" argument are performed in
order to permit sparse to detect misuse of RCU-protected pointers.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/rcupdate.h |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 89414d6..03cda7b 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -310,24 +310,32 @@ extern int rcu_my_thread_group_empty(void);
  * (e.g., __rcu_bh, * __rcu_sched, and __srcu), should this make sense in
  * the future.
  */
+
+#ifdef __CHECKER__
+#define rcu_dereference_sparse(p, space) \
+	((void)(((typeof(*p) space *)p) == p))
+#else /* #ifdef __CHECKER__ */
+#define rcu_dereference_sparse(p, space)
+#endif /* #else #ifdef __CHECKER__ */
+
 #define __rcu_access_pointer(p, space) \
 	({ \
 		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
-		(void) (((typeof (*p) space *)p) == p); \
+		rcu_dereference_sparse(p, space); \
 		((typeof(*p) __force __kernel *)(_________p1)); \
 	})
 #define __rcu_dereference_check(p, c, space) \
 	({ \
 		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
 		rcu_lockdep_assert(c); \
-		(void) (((typeof (*p) space *)p) == p); \
+		rcu_dereference_sparse(p, space); \
 		smp_read_barrier_depends(); \
 		((typeof(*p) __force __kernel *)(_________p1)); \
 	})
 #define __rcu_dereference_protected(p, c, space) \
 	({ \
 		rcu_lockdep_assert(c); \
-		(void) (((typeof (*p) space *)p) == p); \
+		rcu_dereference_sparse(p, space); \
 		((typeof(*p) __force __kernel *)(p)); \
 	})
 
-- 
1.7.0.6

