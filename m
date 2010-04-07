Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab0DGQ00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:26:26 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37407 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535Ab0DGQ0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:26:25 -0400
Date: Wed, 7 Apr 2010 09:26:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: [PATCH tip/urgent] rcu: add rcu_access_pointer and
 rcu_dereference_protected
Message-ID: <20100407162620.GA11543@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds variants of rcu_dereference() that handle situations
where the RCU-protected data structure cannot change, perhaps due to
our holding the update-side lock, or where the RCU-protected pointer is
only to be fetched, not dereferenced.  These are needed due to some
performance concerns with using rcu_dereference() where it is not
required, aside from the need for lockdep/sparse checking.

The new rcu_access_pointer() primitive is for the case where the pointer
is be fetch and not dereferenced.  This primitive may be used without
protection, RCU or otherwise, due to the fact that it uses ACCESS_ONCE().

The new rcu_dereference_protected() primitive is for the case where updates
are prevented, for example, due to holding the update-side lock.  This
primitive does neither ACCESS_ONCE() nor smp_read_barrier_depends(), so
can only be used when updates are somehow prevented.

Suggested-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

 rcupdate.h |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 872a98e..3f06b3d 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -209,9 +209,47 @@ static inline int rcu_read_lock_sched_held(void)
 		rcu_dereference_raw(p); \
 	})
 
+/**
+ * rcu_access_pointer - fetch RCU pointer with no dereferencing
+ *
+ * Return the value of the specified RCU-protected pointer, but omit the
+ * smp_read_barrier_depends() and keep the ACCESS_ONCE().  This is useful
+ * when the value of this pointer is accessed, but the pointer is not
+ * dereferenced, for example, when testing an RCU-protected pointer against
+ * NULL.  This may also be used in cases where update-side locks prevent
+ * the value of the pointer from changing, but rcu_dereference_protected()
+ * is a lighter-weight primitive for this use case.
+ */
+#define rcu_access_pointer(p, c) \
+	({ \
+		if (debug_lockdep_rcu_enabled() && !(c)) \
+			lockdep_rcu_dereference(__FILE__, __LINE__); \
+		ACCESS_ONCE(p); \
+	})
+
+/**
+ * rcu_dereference_protected - fetch RCU pointer when updates prevented
+ *
+ * Return the value of the specified RCU-protected pointer, but omit
+ * both the smp_read_barrier_depends() and the ACCESS_ONCE().  This
+ * is useful in cases where update-side locks prevent the value of the
+ * pointer from changing.  Please note that this primitive does -not-
+ * prevent the compiler from repeating this reference or combining it
+ * with other references, so it should not be used without protection
+ * of appropriate locks.
+ */
+#define rcu_dereference_protected(p, c) \
+	({ \
+		if (debug_lockdep_rcu_enabled() && !(c)) \
+			lockdep_rcu_dereference(__FILE__, __LINE__); \
+		(p); \
+	})
+
 #else /* #ifdef CONFIG_PROVE_RCU */
 
 #define rcu_dereference_check(p, c)	rcu_dereference_raw(p)
+#define rcu_access_pointer(p, c)	ACCESS_ONCE(p)
+#define rcu_dereference_protected(p, c) (p)
 
 #endif /* #else #ifdef CONFIG_PROVE_RCU */
 
