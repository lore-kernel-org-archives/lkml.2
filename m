Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab0HTSp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 14:45:59 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60112 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab0HTSpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 14:45:51 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 6/7] rcu: apply TINY_PREEMPT_RCU read-side speedup to TREE_PREEMPT_RCU
Date: Fri, 20 Aug 2010 11:45:44 -0700
Message-Id: <1282329945-26043-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100820184521.GA24715@linux.vnet.ibm.com>
References: <20100820184521.GA24715@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace one of the ACCESS_ONCE() calls in each of __rcu_read_lock()
and __rcu_read_unlock() with barrier() as suggested by Steve Rostedt in
order to avoid the potential compiler-optimization-induced bug noted by
Mathieu Desnoyers.

Located-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 87f60f0..e9e0bc7 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -201,7 +201,7 @@ static void rcu_preempt_note_context_switch(int cpu)
  */
 void __rcu_read_lock(void)
 {
-	ACCESS_ONCE(current->rcu_read_lock_nesting)++;
+	current->rcu_read_lock_nesting++;
 	barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
 }
 EXPORT_SYMBOL_GPL(__rcu_read_lock);
@@ -344,7 +344,9 @@ void __rcu_read_unlock(void)
 	struct task_struct *t = current;
 
 	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
-	if (--ACCESS_ONCE(t->rcu_read_lock_nesting) == 0 &&
+	--t->rcu_read_lock_nesting;
+	barrier();  /* decrement before load of ->rcu_read_unlock_special */
+	if (t->rcu_read_lock_nesting == 0 &&
 	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
 		rcu_read_unlock_special(t);
 #ifdef CONFIG_PROVE_LOCKING
-- 
1.7.0.6

