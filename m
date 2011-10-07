Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965496Ab1JGQZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:25:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50139 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759955Ab1JGQW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:22:28 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 03/11] rcu: Warn when rcu_read_lock() is used in extended quiescent state
Date: Fri,  7 Oct 2011 18:22:02 +0200
Message-Id: <1318004530-705-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318004530-705-1-git-send-email-fweisbec@gmail.com>
References: <1318004530-705-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 2f8e0a4..fe4f8976 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -227,21 +227,53 @@ static inline int rcu_is_cpu_idle(void)
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
1.7.5.4

