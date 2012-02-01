Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab2BATrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:47:13 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39321 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932205Ab2BATrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:47:09 -0500
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
Subject: [PATCH RFC tip/core/rcu 20/41] rcu: Prevent RCU callbacks from executing before scheduler initialized
Date: Wed,  1 Feb 2012 11:41:38 -0800
Message-Id: <1328125319-5205-20-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-5112-0000-0000-0000049E707D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

This is a port of commit #b0d3041 from TREE_RCU to TREE_PREEMPT_RCU.

Under some rare but real combinations of configuration parameters, RCU
callbacks are posted during early boot that use kernel facilities that are
not yet initialized.  Therefore, when these callbacks are invoked, hard
hangs and crashes ensue.  This commit therefore prevents RCU callbacks
from being invoked until after the scheduler is fully up and running,
as in after multiple tasks have been spawned.

It might well turn out that a better approach is to identify the specific
RCU callbacks that are causing this problem, but that discussion will
wait until such time as someone really needs an RCU callback to be invoked
(as opposed to merely registered) during early boot.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcutiny.h |    4 ----
 kernel/rcutiny_plugin.h |   15 ++++++++++++---
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 51bf29c..e93df77 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -27,13 +27,9 @@
 
 #include <linux/cache.h>
 
-#ifdef CONFIG_RCU_BOOST
 static inline void rcu_init(void)
 {
 }
-#else /* #ifdef CONFIG_RCU_BOOST */
-void rcu_init(void);
-#endif /* #else #ifdef CONFIG_RCU_BOOST */
 
 static inline void rcu_barrier_bh(void)
 {
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 9fbb911..3f6c07e 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -913,7 +913,8 @@ static void rcu_preempt_process_callbacks(void)
 static void invoke_rcu_callbacks(void)
 {
 	have_rcu_kthread_work = 1;
-	wake_up(&rcu_kthread_wq);
+	if (rcu_kthread_task != NULL)
+		wake_up(&rcu_kthread_wq);
 }
 
 #ifdef CONFIG_RCU_TRACE
@@ -974,12 +975,16 @@ early_initcall(rcu_spawn_kthreads);
 
 #else /* #ifdef CONFIG_RCU_BOOST */
 
+/* Hold off callback invocation until early_initcall() time. */
+static int rcu_scheduler_fully_active __read_mostly;
+
 /*
  * Start up softirq processing of callbacks.
  */
 void invoke_rcu_callbacks(void)
 {
-	raise_softirq(RCU_SOFTIRQ);
+	if (rcu_scheduler_fully_active)
+		raise_softirq(RCU_SOFTIRQ);
 }
 
 #ifdef CONFIG_RCU_TRACE
@@ -994,10 +999,14 @@ static bool rcu_is_callbacks_kthread(void)
 
 #endif /* #ifdef CONFIG_RCU_TRACE */
 
-void rcu_init(void)
+static int __init rcu_scheduler_really_started(void)
 {
+	rcu_scheduler_fully_active = 1;
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+	raise_softirq(RCU_SOFTIRQ);  /* Invoke any callbacks from early boot. */
+	return 0;
 }
+early_initcall(rcu_scheduler_really_started);
 
 #endif /* #else #ifdef CONFIG_RCU_BOOST */
 
-- 
1.7.8

