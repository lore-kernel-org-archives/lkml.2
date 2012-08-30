Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab2H3VOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:14:35 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:47877 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab2H3VO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:14:28 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/26] rcu: New rcu_user_enter_irq() and rcu_user_exit_irq() APIs
Date: Thu, 30 Aug 2012 14:05:19 -0700
Message-Id: <1346360743-3628-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-7606-0000-0000-00000334D234
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

In some cases, it is necessary to enter or exit userspace-RCU-idle mode
from an interrupt handler, for example, if some other CPU sends this
CPU a resched IPI.  In this case, the current CPU would enter the IPI
handler in userspace-RCU-idle mode, but would need to exit the IPI handler
after having exited that mode.

To allow this to work, this commit adds two new APIs to TREE_RCU:

- rcu_user_enter_irq(). This must be called from an interrupt between
rcu_irq_enter() and rcu_irq_exit().  After the irq calls rcu_irq_exit(),
the irq handler will return into an RCU extended quiescent state.
In theory, this interrupt is never a nested interrupt, but in practice
it might interrupt softirq, which looks to RCU like a nested interrupt.

- rcu_user_exit_irq(). This must be called from a non-nesting
interrupt, interrupting an RCU extended quiescent state, also
between rcu_irq_enter() and rcu_irq_exit(). After the irq calls
rcu_irq_exit(), the irq handler will return in an RCU non-quiescent
state.

[ Combined with "Allow calls to rcu_exit_user_irq from nesting irqs." ]

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    2 ++
 kernel/rcutree.c         |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 2a7549c..81d3d5c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -193,6 +193,8 @@ extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
 extern void rcu_user_enter(void);
 extern void rcu_user_exit(void);
+extern void rcu_user_enter_irq(void);
+extern void rcu_user_exit_irq(void);
 extern void exit_rcu(void);
 
 /**
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index c0507b7..8fdea17 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -440,6 +440,27 @@ EXPORT_SYMBOL_GPL(rcu_user_enter);
 
 
 /**
+ * rcu_user_enter_irq - inform RCU that we are going to resume userspace
+ * after the current irq returns.
+ *
+ * This is similar to rcu_user_enter() but in the context of a non-nesting
+ * irq. After this call, RCU enters into idle mode when the interrupt
+ * returns.
+ */
+void rcu_user_enter_irq(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	/* Ensure this irq is interrupting a non-idle RCU state.  */
+	WARN_ON_ONCE(!(rdtp->dynticks_nesting & DYNTICK_TASK_MASK));
+	rdtp->dynticks_nesting = 1;
+	local_irq_restore(flags);
+}
+
+/**
  * rcu_irq_exit - inform RCU that current CPU is exiting irq towards idle
  *
  * Exit from an interrupt handler, which might possibly result in entering
@@ -554,6 +575,28 @@ void rcu_user_exit(void)
 EXPORT_SYMBOL_GPL(rcu_user_exit);
 
 /**
+ * rcu_user_exit_irq - inform RCU that we won't resume to userspace
+ * idle mode after the current non-nesting irq returns.
+ *
+ * This is similar to rcu_user_exit() but in the context of an irq.
+ * This is called when the irq has interrupted a userspace RCU idle mode
+ * context. When the current non-nesting interrupt returns after this call,
+ * the CPU won't restore the RCU idle mode.
+ */
+void rcu_user_exit_irq(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	/* Ensure we are interrupting an RCU idle mode. */
+	WARN_ON_ONCE(rdtp->dynticks_nesting & DYNTICK_TASK_NEST_MASK);
+	rdtp->dynticks_nesting += DYNTICK_TASK_EXIT_IDLE;
+	local_irq_restore(flags);
+}
+
+/**
  * rcu_irq_enter - inform RCU that current CPU is entering irq away from idle
  *
  * Enter an interrupt handler, which might possibly result in exiting
-- 
1.7.8

