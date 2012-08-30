Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab2H3Vnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:43:45 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53104 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2H3Vnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:43:42 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 13/15] rcu: Move TINY_PREEMPT_RCU away from raw_local_irq_save()
Date: Thu, 30 Aug 2012 11:56:26 -0700
Message-Id: <1346352988-32444-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-7282-0000-0000-00000C769FE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The use of raw_local_irq_save() is unnecessary, given that local_irq_save()
really does disable interrupts.  Also, it appears to interfere with lockdep.
Therefore, this commit moves to local_irq_save().

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
---
 kernel/rcutiny_plugin.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 918fd1e..3d01902 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -278,7 +278,7 @@ static int rcu_boost(void)
 	    rcu_preempt_ctrlblk.exp_tasks == NULL)
 		return 0;  /* Nothing to boost. */
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 
 	/*
 	 * Recheck with irqs disabled: all tasks in need of boosting
@@ -287,7 +287,7 @@ static int rcu_boost(void)
 	 */
 	if (rcu_preempt_ctrlblk.boost_tasks == NULL &&
 	    rcu_preempt_ctrlblk.exp_tasks == NULL) {
-		raw_local_irq_restore(flags);
+		local_irq_restore(flags);
 		return 0;
 	}
 
@@ -317,7 +317,7 @@ static int rcu_boost(void)
 	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&mtx, t);
 	t->rcu_boost_mutex = &mtx;
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 	rt_mutex_lock(&mtx);
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
 
@@ -991,9 +991,9 @@ static void rcu_trace_sub_qlen(struct rcu_ctrlblk *rcp, int n)
 {
 	unsigned long flags;
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	rcp->qlen -= n;
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 }
 
 /*
-- 
1.7.8

