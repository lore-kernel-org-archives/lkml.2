Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab1IGGZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:25:19 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50056 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab1IGGVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:21:02 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 45/55] rcu: check for entering dyntick-idle mode while in read-side critical section
Date: Tue,  6 Sep 2011 11:00:39 -0700
Message-Id: <1315332049-2604-45-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_RCU_FAST_NO_HZ assumes that all calls to rcu_needs_cpu() are
outside of all RCU read-side critical sections.  This patch adds diagnostic
checks to verify this assumption.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    3 +++
 kernel/rcutree.c         |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index e86bc28..8d7efc8 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -233,6 +233,8 @@ static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
+#define PROVE_RCU(a) a
+
 extern struct lockdep_map rcu_lock_map;
 # define rcu_read_acquire() \
 		lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
@@ -311,6 +313,7 @@ static inline int rcu_read_lock_sched_held(void)
 
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+# define PROVE_RCU(a)			do { } while (0)
 # define rcu_read_acquire()		do { } while (0)
 # define rcu_read_release()		do { } while (0)
 # define rcu_read_acquire_bh()		do { } while (0)
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 8455043..743a658 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1786,6 +1786,9 @@ static int rcu_pending(int cpu)
  */
 static int rcu_needs_cpu_quick_check(int cpu)
 {
+	PROVE_RCU(WARN_ON_ONCE(lock_is_held(&rcu_lock_map)));
+	PROVE_RCU(WARN_ON_ONCE(lock_is_held(&rcu_bh_lock_map)));
+	PROVE_RCU(WARN_ON_ONCE(lock_is_held(&rcu_sched_lock_map)));
 	/* RCU callbacks either ready or pending? */
 	return per_cpu(rcu_sched_data, cpu).nxtlist ||
 	       per_cpu(rcu_bh_data, cpu).nxtlist ||
-- 
1.7.3.2

