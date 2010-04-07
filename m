Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab0DGRPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:15:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825Ab0DGRPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:15:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] RCU: Better explain the condition parameter of
	rcu_dereference_check()
To: paulmck@linux.vnet.ibm.com, eric.dumazet@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 07 Apr 2010 18:15:00 +0100
Message-ID: <20100407171500.27710.88994.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better explain the condition parameter of rcu_dereference_check() that
describes the conditions under which the dereference is permitted to take
place.  This condition is only checked under lockdep proving.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/rcupdate.h |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 872a98e..acf9958 100644
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
+ *					      lockdep_is_held(&foo->lock),
+ *					      atomic_read(&foo->usage) == 0);
  */
 #define rcu_dereference_check(p, c) \
 	({ \

