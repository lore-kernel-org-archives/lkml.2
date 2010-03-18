Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab0CRTZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 15:25:45 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40174 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab0CRTZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 15:25:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 1/2] rcu: local_irq_disable() also delimits RCU_SCHED read-site critical sections
Date: Thu, 18 Mar 2010 12:25:33 -0700
Message-Id: <1268940334-10892-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100318192513.GA10832@linux.vnet.ibm.com>
References: <20100318192513.GA10832@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

It is documented that local_irq_disable() also delimits
RCU_SCHED read-site critical sections.
See the document of synchronize_sched() or
Documentation/RCU/whatisRCU.txt.

So we have to test irqs_disabled() in rcu_read_lock_sched_held().
Otherwise rcu-lockdep brings incorrect complaint.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index e1bdc4b..872a98e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -149,7 +149,7 @@ static inline int rcu_read_lock_sched_held(void)
 		return 1;
 	if (debug_locks)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
-	return lockdep_opinion || preempt_count() != 0;
+	return lockdep_opinion || preempt_count() != 0 || irqs_disabled();
 }
 #else /* #ifdef CONFIG_PREEMPT */
 static inline int rcu_read_lock_sched_held(void)
@@ -180,7 +180,7 @@ static inline int rcu_read_lock_bh_held(void)
 #ifdef CONFIG_PREEMPT
 static inline int rcu_read_lock_sched_held(void)
 {
-	return !rcu_scheduler_active || preempt_count() != 0;
+	return !rcu_scheduler_active || preempt_count() != 0 || irqs_disabled();
 }
 #else /* #ifdef CONFIG_PREEMPT */
 static inline int rcu_read_lock_sched_held(void)
-- 
1.7.0

