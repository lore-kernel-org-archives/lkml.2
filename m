Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934579Ab1FWXMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:12:54 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51164 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934558Ab1FWXMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:12:52 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/3] rcu: Detect illegal rcu dereference in extended quiescent state
Date: Fri, 24 Jun 2011 01:12:38 +0200
Message-Id: <1308870760-14153-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308870760-14153-1-git-send-email-fweisbec@gmail.com>
References: <1308870760-14153-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report that none of the rcu read lock map are held while we are in
an RCU extended quiescent state. This helps detecting any use of
rcu dereference when we are in dynticks idle mode.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/rcupdate.h |   16 ++++++++++++++++
 kernel/rcupdate.c        |    4 ++++
 kernel/rcutiny.c         |   13 +++++++++++++
 kernel/rcutree.c         |   14 ++++++++++++++
 4 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 8be0433..713eb6c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -179,6 +179,14 @@ static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
 }
 #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
+
+#if defined(CONFIG_PROVE_RCU) && defined(CONFIG_NO_HZ)
+extern bool rcu_check_extended_qs(void);
+#else
+static inline bool rcu_check_extended_qs(void) { return false; }
+#endif
+
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 extern struct lockdep_map rcu_lock_map;
@@ -215,6 +223,10 @@ static inline int rcu_read_lock_held(void)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
+
+	if (rcu_check_extended_qs())
+		return 0;
+
 	return lock_is_held(&rcu_lock_map);
 }
 
@@ -246,6 +258,10 @@ static inline int rcu_read_lock_sched_held(void)
 
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
+
+	if (rcu_check_extended_qs())
+		return 0;
+
 	if (debug_locks)
 		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
 	return lockdep_opinion || preempt_count() != 0 || irqs_disabled();
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 7784bd2..d883253 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -88,6 +88,10 @@ int rcu_read_lock_bh_held(void)
 {
 	if (!debug_lockdep_rcu_enabled())
 		return 1;
+
+	if (rcu_check_extended_qs())
+		return 0;
+
 	return in_softirq() || irqs_disabled();
 }
 EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 7bbac7d..95581f1 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -77,6 +77,19 @@ void rcu_exit_nohz(void)
 	rcu_dynticks_nesting++;
 }
 
+
+#ifdef CONFIG_PROVE_RCU
+
+bool rcu_check_extended_qs(void)
+{
+	if (!rcu_dynticks_nesting)
+		return true;
+
+	return false;
+}
+
+#endif
+
 #endif /* #ifdef CONFIG_NO_HZ */
 
 /*
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7e59ffb..c397a86 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -438,6 +438,20 @@ void rcu_irq_exit(void)
 	rcu_enter_nohz();
 }
 
+#ifdef CONFIG_PROVE_RCU
+
+bool rcu_check_extended_qs(void)
+{
+	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+
+	if (atomic_read(&rdtp->dynticks) & 0x1)
+		return false;
+
+	return true;
+}
+
+#endif /* CONFIG_PROVE_RCU */
+
 #ifdef CONFIG_SMP
 
 /*
-- 
1.7.5.4

