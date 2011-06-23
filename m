Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934591Ab1FWXM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:12:59 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34124 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934558Ab1FWXM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:12:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GUrCTZTil8+sgJXk07uw72TzaLlktSnWiJSWdOwR+SO0/bskvHShYCI3r3lfulykpD
         5gaCPCoJuzVCjzEq1YJ39NvUaUmY4m/o8nt+4pY7ZFuPFElpMli9Jfrt56J0C6CqcdjH
         cM+56OVmE0Hig+tcPeIzjGRpY/q7/makWzFng=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 3/3] rcu: Warn when rcu_read_lock() is used in extended quiescent state
Date: Fri, 24 Jun 2011 01:12:40 +0200
Message-Id: <1308870760-14153-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308870760-14153-1-git-send-email-fweisbec@gmail.com>
References: <1308870760-14153-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are currently able to detect uses of rcu_dereference_check()
inside extended quiescent states. But rcu_read_lock() and friends
can be used without rcu_dereference(), making their illegal
uses inside extended quiescent invisible sometimes.

Thus, check we don't call these functions from dyntick idle mode.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/rcupdate.h |   52 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 713eb6c..073f5f9 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -189,21 +189,53 @@ static inline bool rcu_check_extended_qs(void) { return false; }
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
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
1.7.5.4

