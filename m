Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab0DNPBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:01:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:53755 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930Ab0DNPBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:01:45 -0400
Date: Wed, 14 Apr 2010 15:01:14 GMT
From: tip-bot for David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, dhowells@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1270852752-25278-2-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1270852752-25278-2-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Better explain the condition parameter of rcu_dereference_check()
Message-ID: <tip-c08c68dd76bd6b776bc0eb45a5e8f354ed772cdf@git.kernel.org>
Git-Commit-ID: c08c68dd76bd6b776bc0eb45a5e8f354ed772cdf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Apr 2010 15:01:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c08c68dd76bd6b776bc0eb45a5e8f354ed772cdf
Gitweb:     http://git.kernel.org/tip/c08c68dd76bd6b776bc0eb45a5e8f354ed772cdf
Author:     David Howells <dhowells@redhat.com>
AuthorDate: Fri, 9 Apr 2010 15:39:11 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Apr 2010 12:20:04 +0200

rcu: Better explain the condition parameter of rcu_dereference_check()

Better explain the condition parameter of
rcu_dereference_check() that describes the conditions under
which the dereference is permitted to take place (and
incorporate Yong Zhang's suggestion).  This condition is only
checked under lockdep proving.

Signed-off-by: David Howells <dhowells@redhat.com>
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
Cc: eric.dumazet@gmail.com
LKML-Reference: <1270852752-25278-2-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
