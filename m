Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1IGGaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:30:46 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48768 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643Ab1IGGUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:48 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 34/55] rcu: Move __rcu_read_unlock()'s barrier() within if-statement
Date: Tue,  6 Sep 2011 11:00:28 -0700
Message-Id: <1315332049-2604-34-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

We only need to constrain the compiler if we are actually exiting
the top-level RCU read-side critical section.  This commit therefore
moves the first barrier() cal in __rcu_read_unlock() to inside the
"if" statement, thus avoiding needless register flushes for inner
rcu_read_unlock() calls.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   14 ++------------
 kernel/rcutree_plugin.h  |    2 +-
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 9873040..e86bc28 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -134,16 +134,6 @@ extern void call_rcu_sched(struct rcu_head *head,
 
 extern void synchronize_sched(void);
 
-static inline void __rcu_read_lock_bh(void)
-{
-	local_bh_disable();
-}
-
-static inline void __rcu_read_unlock_bh(void)
-{
-	local_bh_enable();
-}
-
 #ifdef CONFIG_PREEMPT_RCU
 
 extern void __rcu_read_lock(void);
@@ -686,7 +676,7 @@ static inline void rcu_read_unlock(void)
  */
 static inline void rcu_read_lock_bh(void)
 {
-	__rcu_read_lock_bh();
+	local_bh_disable();
 	__acquire(RCU_BH);
 	rcu_read_acquire_bh();
 }
@@ -700,7 +690,7 @@ static inline void rcu_read_unlock_bh(void)
 {
 	rcu_read_release_bh();
 	__release(RCU_BH);
-	__rcu_read_unlock_bh();
+	local_bh_enable();
 }
 
 /**
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 4bac5a2..ed70f6b 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -415,10 +415,10 @@ void __rcu_read_unlock(void)
 {
 	struct task_struct *t = current;
 
-	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
 	if (t->rcu_read_lock_nesting != 1)
 		--t->rcu_read_lock_nesting;
 	else {
+		barrier();  /* critical section before exit code. */
 		t->rcu_read_lock_nesting = INT_MIN;
 		barrier();  /* assign before ->rcu_read_unlock_special load */
 		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
-- 
1.7.3.2

