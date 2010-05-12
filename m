Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab0ELVjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:39:10 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48404 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757927Ab0ELVdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:33:54 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 01/23] rcu: add an rcu_dereference_index_check()
Date: Wed, 12 May 2010 14:33:20 -0700
Message-Id: <1273700022-16523-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100512213317.GA15085@linux.vnet.ibm.com>
References: <20100512213317.GA15085@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sparse RCU-pointer checking relies on type magic that dereferences
the pointer in question.  This does not work if the pointer is in fact
an array index.  This commit therefore supplies a new RCU API that
omits the sparse checking to continue to support rcu_dereference()
on integers.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 2f9e56c..3be0ad7 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -560,4 +560,37 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 }
 #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
+#ifndef CONFIG_PROVE_RCU
+#define __do_rcu_dereference_check(c) do { } while (0)
+#endif /* #ifdef CONFIG_PROVE_RCU */
+
+#define __rcu_dereference_index_check(p, c) \
+	({ \
+		typeof(p) _________p1 = ACCESS_ONCE(p); \
+		__do_rcu_dereference_check(c); \
+		smp_read_barrier_depends(); \
+		(_________p1); \
+	})
+
+/**
+ * rcu_dereference_index_check() - rcu_dereference for indices with debug checking
+ * @p: The pointer to read, prior to dereferencing
+ * @c: The conditions under which the dereference will take place
+ *
+ * Similar to rcu_dereference_check(), but omits the sparse checking.
+ * This allows rcu_dereference_index_check() to be used on integers,
+ * which can then be used as array indices.  Attempting to use
+ * rcu_dereference_check() on an integer will give compiler warnings
+ * because the sparse address-space mechanism relies on dereferencing
+ * the RCU-protected pointer.  Dereferencing integers is not something
+ * that even gcc will put up with.
+ *
+ * Note that this function does not implicitly check for RCU read-side
+ * critical sections.  If this function gains lots of uses, it might
+ * make sense to provide versions for each flavor of RCU, but it does
+ * not make sense as of early 2010.
+ */
+#define rcu_dereference_index_check(p, c) \
+	__rcu_dereference_index_check((p), (c))
+
 #endif /* __LINUX_RCUPDATE_H */
-- 
1.7.0.6

