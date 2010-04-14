Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0DNPBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:01:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:53746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943Ab0DNPBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:01:20 -0400
Date: Wed, 14 Apr 2010 15:00:56 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, dhowells@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1270852752-25278-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1270852752-25278-1-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Add rcu_access_pointer and rcu_dereference_protected
Message-ID: <tip-b62730baea32f86fe91a7930e4b7ee8d82778b79@git.kernel.org>
Git-Commit-ID: b62730baea32f86fe91a7930e4b7ee8d82778b79
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Apr 2010 15:00:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b62730baea32f86fe91a7930e4b7ee8d82778b79
Gitweb:     http://git.kernel.org/tip/b62730baea32f86fe91a7930e4b7ee8d82778b79
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Fri, 9 Apr 2010 15:39:10 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Apr 2010 12:19:51 +0200

rcu: Add rcu_access_pointer and rcu_dereference_protected

This patch adds variants of rcu_dereference() that handle
situations where the RCU-protected data structure cannot change,
perhaps due to our holding the update-side lock, or where the
RCU-protected pointer is only to be fetched, not dereferenced.
These are needed due to some performance concerns with using
rcu_dereference() where it is not required, aside from the need
for lockdep/sparse checking.

The new rcu_access_pointer() primitive is for the case where the
pointer is be fetch and not dereferenced.  This primitive may be
used without protection, RCU or otherwise, due to the fact that
it uses ACCESS_ONCE().

The new rcu_dereference_protected() primitive is for the case
where updates are prevented, for example, due to holding the
update-side lock.  This primitive does neither ACCESS_ONCE() nor
smp_read_barrier_depends(), so can only be used when updates are
somehow prevented.

Suggested-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: eric.dumazet@gmail.com
LKML-Reference: <1270852752-25278-1-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/rcupdate.h |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 872a98e..8fe8660 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -209,13 +209,45 @@ static inline int rcu_read_lock_sched_held(void)
 		rcu_dereference_raw(p); \
 	})
 
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
+#define rcu_dereference_protected(p, c) (p)
 
 #endif /* #else #ifdef CONFIG_PROVE_RCU */
 
 /**
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
+#define rcu_access_pointer(p)	ACCESS_ONCE(p)
+
+/**
  * rcu_read_lock - mark the beginning of an RCU read-side critical section.
  *
  * When synchronize_rcu() is invoked on one CPU while other CPUs
