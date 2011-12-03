Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab1LCSf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 13:35:27 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57180 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab1LCSez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 13:34:55 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Yong Zhang <yong.zhang0@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 7/7] rcu: Quiet RCU-lockdep warnings involving interrupt disabling
Date: Sat,  3 Dec 2011 10:34:42 -0800
Message-Id: <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111203183417.GA18914@linux.vnet.ibm.com>
References: <20111203183417.GA18914@linux.vnet.ibm.com>
x-cbid: 11120318-9360-0000-0000-000001361776
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang0@gmail.com>

RCU-lockdep will issue warnings given the following use pattern:

	rcu_read_lock();
	local_irq_disable();
	rcu_read_unlock();
	local_irq_enable();

However, this use pattern is legal except for the scheduler's runqueue
and priority-inheritance locks (and any other locks that the scheduler
might use during priority-inheritance operations).

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 8cd9efe..2020e8a 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -401,8 +401,11 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
 
 #ifdef CONFIG_RCU_BOOST
 		/* Unboost if we were boosted. */
-		if (rbmp)
+		if (rbmp) {
+			local_irq_save(flags);
 			rt_mutex_unlock(rbmp);
+			local_irq_restore(flags);
+		}
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
 		/*
@@ -1233,9 +1236,10 @@ static int rcu_boost(struct rcu_node *rnp)
 	lockdep_set_class_and_name(&mtx.wait_lock, &rcu_boost_class,
 				   "rcu_boost_mutex");
 	t->rcu_boost_mutex = &mtx;
-	raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock(&rnp->lock); /* rrupts remain disabled. */
 	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
+	local_irq_restore(flags);
 
 	return rnp->exp_tasks != NULL || rnp->boost_tasks != NULL;
 }
-- 
1.7.3.2

