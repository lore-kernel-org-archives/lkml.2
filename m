Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293Ab1EANXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:23:07 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38463 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758377Ab1EANW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:56 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 33/86] rcu: optimize rcutiny
Date: Sun,  1 May 2011 06:21:13 -0700
Message-Id: <1304256126-26015-33-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

rcu_sched_qs() currently calls local_irq_save()/local_irq_restore() up
to three times.

Remove irq masking from rcu_qsctr_help() / invoke_rcu_kthread()
and do it once in rcu_sched_qs() / rcu_bh_qs()

This generates smaller code as well.

# size kernel/rcutiny.old.o kernel/rcutiny.new.o
   text	   data	    bss	    dec	    hex	filename
   2314	    156	     24	   2494	    9be	kernel/rcutiny.old.o
   2250	    156	     24	   2430	    97e	kernel/rcutiny.new.o

Fix an outdated comment for rcu_qsctr_help()
Move invoke_rcu_kthread() definition before its use.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutiny.c |   42 ++++++++++++++++++++----------------------
 1 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 4d60fbc..0aa3bc5 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -40,7 +40,6 @@
 static struct task_struct *rcu_kthread_task;
 static DECLARE_WAIT_QUEUE_HEAD(rcu_kthread_wq);
 static unsigned long have_rcu_kthread_work;
-static void invoke_rcu_kthread(void);
 
 /* Forward declarations for rcutiny_plugin.h. */
 struct rcu_ctrlblk;
@@ -79,36 +78,45 @@ void rcu_exit_nohz(void)
 #endif /* #ifdef CONFIG_NO_HZ */
 
 /*
- * Helper function for rcu_qsctr_inc() and rcu_bh_qsctr_inc().
- * Also disable irqs to avoid confusion due to interrupt handlers
+ * Helper function for rcu_sched_qs() and rcu_bh_qs().
+ * Also irqs are disabled to avoid confusion due to interrupt handlers
  * invoking call_rcu().
  */
 static int rcu_qsctr_help(struct rcu_ctrlblk *rcp)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
 	if (rcp->rcucblist != NULL &&
 	    rcp->donetail != rcp->curtail) {
 		rcp->donetail = rcp->curtail;
-		local_irq_restore(flags);
 		return 1;
 	}
-	local_irq_restore(flags);
 
 	return 0;
 }
 
 /*
+ * Wake up rcu_kthread() to process callbacks now eligible for invocation
+ * or to boost readers.
+ */
+static void invoke_rcu_kthread(void)
+{
+	have_rcu_kthread_work = 1;
+	wake_up(&rcu_kthread_wq);
+}
+
+/*
  * Record an rcu quiescent state.  And an rcu_bh quiescent state while we
  * are at it, given that any rcu quiescent state is also an rcu_bh
  * quiescent state.  Use "+" instead of "||" to defeat short circuiting.
  */
 void rcu_sched_qs(int cpu)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	if (rcu_qsctr_help(&rcu_sched_ctrlblk) +
 	    rcu_qsctr_help(&rcu_bh_ctrlblk))
 		invoke_rcu_kthread();
+	local_irq_restore(flags);
 }
 
 /*
@@ -116,8 +124,12 @@ void rcu_sched_qs(int cpu)
  */
 void rcu_bh_qs(int cpu)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	if (rcu_qsctr_help(&rcu_bh_ctrlblk))
 		invoke_rcu_kthread();
+	local_irq_restore(flags);
 }
 
 /*
@@ -208,20 +220,6 @@ static int rcu_kthread(void *arg)
 }
 
 /*
- * Wake up rcu_kthread() to process callbacks now eligible for invocation
- * or to boost readers.
- */
-static void invoke_rcu_kthread(void)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	have_rcu_kthread_work = 1;
-	wake_up(&rcu_kthread_wq);
-	local_irq_restore(flags);
-}
-
-/*
  * Wait for a grace period to elapse.  But it is illegal to invoke
  * synchronize_sched() from within an RCU read-side critical section.
  * Therefore, any legal call to synchronize_sched() is a quiescent
-- 
1.7.3.2

