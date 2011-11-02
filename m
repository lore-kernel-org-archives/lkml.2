Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1KBUds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:33:48 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60703 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab1KBUdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:33:43 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH RFC tip/core/rcu 14/28] rcu: Warn when rcu_read_lock() is used in extended quiescent state
Date: Wed,  2 Nov 2011 13:30:35 -0700
Message-Id: <1320265849-5744-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-5112-0000-0000-0000019EA423
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

We are currently able to detect uses of rcu_dereference_check() inside
extended quiescent states (such as the RCU-free window in idle).
But rcu_read_lock() and friends can be used without rcu_dereference(),
so that the earlier commit checking for use of rcu_dereference() and
friends while in RCU idle mode miss some error conditions.  This commit
therefore adds extended quiescent state checking to rcu_read_lock() and
friends.

Uses of RCU from within RCU-idle mode are totally ignored by
RCU, hence the importance of these checks.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   52 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index bf91fcf..d201c15 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -237,21 +237,53 @@ static inline int rcu_is_cpu_idle(void)
 }
 #endif /* else !CONFIG_PROVE_RCU */
 
+static inline void rcu_lock_acquire(struct lockdep_map *map)
+{
+	WARN_ON_ONCE(rcu_is_cpu_idle());
+	lock_acquire(map, 0, 0, 2, 1, NULL, _THIS_IP_);
+}
+
+static inline void rcu_lock_release(struct lockdep_map *map)
+{
+	WARN_ON_ONCE(rcu_is_cpu_idle());
+	lock_release(map, 1, _THIS_IP_);
+}
+
 extern struct lockdep_map rcu_lock_map;
-# define rcu_read_acquire() \
-		lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
-# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
+
+static inline void rcu_read_acquire(void)
+{
+	rcu_lock_acquire(&rcu_lock_map);
+}
+
+static inline void rcu_read_release(void)
+{
+	rcu_lock_release(&rcu_lock_map);
+}
 
 extern struct lockdep_map rcu_bh_lock_map;
-# define rcu_read_acquire_bh() \
-		lock_acquire(&rcu_bh_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
-# define rcu_read_release_bh()	lock_release(&rcu_bh_lock_map, 1, _THIS_IP_)
+
+static inline void rcu_read_acquire_bh(void)
+{
+	rcu_lock_acquire(&rcu_bh_lock_map);
+}
+
+static inline void rcu_read_release_bh(void)
+{
+	rcu_lock_release(&rcu_bh_lock_map);
+}
 
 extern struct lockdep_map rcu_sched_lock_map;
-# define rcu_read_acquire_sched() \
-		lock_acquire(&rcu_sched_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
-# define rcu_read_release_sched() \
-		lock_release(&rcu_sched_lock_map, 1, _THIS_IP_)
+
+static inline void rcu_read_acquire_sched(void)
+{
+	rcu_lock_acquire(&rcu_sched_lock_map);
+}
+
+static inline void rcu_read_release_sched(void)
+{
+	rcu_lock_release(&rcu_sched_lock_map);
+}
 
 extern int debug_lockdep_rcu_enabled(void);
 
-- 
1.7.3.2

