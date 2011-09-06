Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab1IGGam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:30:42 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38091 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645Ab1IGGUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:48 -0400
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
Subject: [PATCH tip/core/rcu 51/55] rcu: Warn when rcu_read_lock() is used in extended quiescent state
Date: Tue,  6 Sep 2011 11:00:45 -0700
Message-Id: <1315332049-2604-51-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

We are currently able to detect uses of rcu_dereference_check() inside
extended quiescent states (such as dyntick-idle mode). But rcu_read_lock()
and friends can be used without rcu_dereference(), so that the earlier
commit checking for use of rcu_dereference() and friends while in
dyntick-idle mode miss some error conditions.  This commit therefore adds
dyntick-idle checking to rcu_read_lock() and friends.

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
index 7d8fa7c..a9bc36d 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -243,21 +243,53 @@ static inline bool rcu_check_extended_qs(void) { return false; }
 
 #define PROVE_RCU(a) a
 
+static inline void rcu_lock_acquire(struct lockdep_map *map)
+{
+	WARN_ON_ONCE(rcu_check_extended_qs());
+	lock_acquire(map, 0, 0, 2, 1, NULL, _THIS_IP_);
+}
+
+static inline void rcu_lock_release(struct lockdep_map *map)
+{
+	WARN_ON_ONCE(rcu_check_extended_qs());
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

