Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1FHTic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:38:32 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44602 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755008Ab1FHTa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:30:28 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/28] rcu: Streamline code produced by __rcu_read_unlock()
Date: Wed,  8 Jun 2011 12:29:42 -0700
Message-Id: <1307561407-13809-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110608192943.GA13211@linux.vnet.ibm.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given some common flag combinations, particularly -Os, gcc will inline
rcu_read_unlock_special() despite its being in an unlikely() clause.
Use noline to prohibit this misoptimization.

In addition, move the second barrier() in __rcu_read_unlock() so that
it is not on the common-case code path.  This will allow the compiler to
generate better code for the common-case path through __rcu_read_unlock().

Finally, fix up whitespace in kernel/lockdep.c to keep checkpatch happy.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index ea2e2fb..40a6db7 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -284,7 +284,7 @@ static struct list_head *rcu_next_node_entry(struct task_struct *t,
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
  */
-static void rcu_read_unlock_special(struct task_struct *t)
+static noinline void rcu_read_unlock_special(struct task_struct *t)
 {
 	int empty;
 	int empty_exp;
@@ -387,11 +387,11 @@ void __rcu_read_unlock(void)
 	struct task_struct *t = current;
 
 	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
-	--t->rcu_read_lock_nesting;
-	barrier();  /* decrement before load of ->rcu_read_unlock_special */
-	if (t->rcu_read_lock_nesting == 0 &&
-	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
-		rcu_read_unlock_special(t);
+	if (--t->rcu_read_lock_nesting == 0) {
+		barrier();  /* decr before ->rcu_read_unlock_special load */
+		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
+			rcu_read_unlock_special(t);
+	}
 #ifdef CONFIG_PROVE_LOCKING
 	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
 #endif /* #ifdef CONFIG_PROVE_LOCKING */
-- 
1.7.3.2

