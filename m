Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab2BATtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:49:46 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41224 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab2BATto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:49:44 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 22/41] rcu: Simplify unboosting checks
Date: Wed,  1 Feb 2012 11:41:40 -0800
Message-Id: <1328125319-5205-22-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-3534-0000-0000-0000051AC76C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

This is a port of commit #82e78d80 from TREE_PREEMPT_RCU to
TINY_PREEMPT_RCU.

This commit uses the fact that current->rcu_boost_mutex is set
any time that the RCU_READ_UNLOCK_BOOSTED flag is set in the
current->rcu_read_unlock_special bitmask.  This allows tests of
the bit to be changed to tests of the pointer, which in turn allows
the RCU_READ_UNLOCK_BOOSTED flag to be eliminated.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/sched.h   |    3 +--
 kernel/rcutiny_plugin.h |   10 ++++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4032ec1..1db119f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1864,8 +1864,7 @@ extern void task_clear_jobctl_pending(struct task_struct *task,
 #ifdef CONFIG_PREEMPT_RCU
 
 #define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
-#define RCU_READ_UNLOCK_BOOSTED (1 << 1) /* boosted while in RCU read-side. */
-#define RCU_READ_UNLOCK_NEED_QS (1 << 2) /* RCU core needs CPU response. */
+#define RCU_READ_UNLOCK_NEED_QS (1 << 1) /* RCU core needs CPU response. */
 
 static inline void rcu_copy_process(struct task_struct *p)
 {
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 9d7d985..01eac49 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -318,7 +318,6 @@ static int rcu_boost(void)
 	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&mtx, t);
 	t->rcu_boost_mutex = &mtx;
-	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
 	raw_local_irq_restore(flags);
 	rt_mutex_lock(&mtx);
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
@@ -550,6 +549,9 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 	int empty_exp;
 	unsigned long flags;
 	struct list_head *np;
+#ifdef CONFIG_RCU_BOOST
+	struct rt_mutex *rbmp = NULL;
+#endif /* #ifdef CONFIG_RCU_BOOST */
 	int special;
 
 	/*
@@ -615,10 +617,10 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 	}
 #ifdef CONFIG_RCU_BOOST
 	/* Unboost self if was boosted. */
-	if (special & RCU_READ_UNLOCK_BOOSTED) {
-		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BOOSTED;
-		rt_mutex_unlock(t->rcu_boost_mutex);
+	if (t->rcu_boost_mutex != NULL) {
+		rbmp = t->rcu_boost_mutex;
 		t->rcu_boost_mutex = NULL;
+		rt_mutex_unlock(rbmp);
 	}
 #endif /* #ifdef CONFIG_RCU_BOOST */
 	local_irq_restore(flags);
-- 
1.7.8

