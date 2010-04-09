Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0DIWjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:39:25 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52997 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719Ab0DIWjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:39:20 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 2/3] RCU: Better explain the condition parameter of rcu_dereference_check()
Date: Fri,  9 Apr 2010 15:39:11 -0700
Message-Id: <1270852752-25278-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100409223843.GA25133@linux.vnet.ibm.com>
References: <20100409223843.GA25133@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Better explain the condition parameter of rcu_dereference_check() that
describes the conditions under which the dereference is permitted to
take place (and incorporate Yong Zhang's suggestion).  This condition
is only checked under lockdep proving.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 8fe8660..9f1ddfe 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -195,12 +195,30 @@ static inline int rcu_read_lock_sched_held(void)
 
 /**
  * rcu_dereference_check - rcu_dereference with debug checking
+ * @p: The pointer to read, prior to dereferencing
+ * @c: The conditions under which the dereference will take place
  *
- * Do an rcu_dereference(), but check that the context is correct.
- * For example, rcu_dereference_check(gp, rcu_read_lock_held()) to
- * ensure that the rcu_dereference_check() executes within an RCU
- * read-side critical section.  It is also possible to check for
- * locks being held, for example, by using lockdep_is_held().
+ * Do an rcu_dereference(), but check that the conditions under which the
+ * dereference will take place are correct.  Typically the conditions indicate
+ * the various locking conditions that should be held at that point.  The check
+ * should return true if the conditions are satisfied.
+ *
+ * For example:
+ *
+ *	bar = rcu_dereference_check(foo->bar, rcu_read_lock_held() ||
+ *					      lockdep_is_held(&foo->lock));
+ *
+ * could be used to indicate to lockdep that foo->bar may only be dereferenced
+ * if either the RCU read lock is held, or that the lock required to replace
+ * the bar struct at foo->bar is held.
+ *
+ * Note that the list of conditions may also include indications of when a lock
+ * need not be held, for example during initialisation or destruction of the
+ * target struct:
+ *
+ *	bar = rcu_dereference_check(foo->bar, rcu_read_lock_held() ||
+ *					      lockdep_is_held(&foo->lock) ||
+ *					      atomic_read(&foo->usage) == 0);
  */
 #define rcu_dereference_check(p, c) \
 	({ \
-- 
1.7.0

