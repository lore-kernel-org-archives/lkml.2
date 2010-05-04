Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020Ab0EDU1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:27:34 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33830 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933769Ab0EDUUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:20:17 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/48] rcu: optionally leave lockdep enabled after RCU lockdep splat
Date: Tue,  4 May 2010 13:19:11 -0700
Message-Id: <1273004398-19760-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100504201934.GA19234@linux.vnet.ibm.com>
References: <20100504201934.GA19234@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

There is no need to disable lockdep after an RCU lockdep splat,
so remove the debug_lockdeps_off() from lockdep_rcu_dereference().
To avoid repeated lockdep splats, use a static variable in the inlined
rcu_dereference_check() and rcu_dereference_protected() macros so that
a given instance splats only once, but so that multiple instances can
be detected per boot.

This is controlled by a new config variable CONFIG_PROVE_RCU_REPEATEDLY,
which is disabled by default.  This provides the normal lockdep behavior
by default, but permits people who want to find multiple RCU-lockdep
splats per boot to easily do so.

Requested-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    6 ++----
 kernel/lockdep.c         |    2 ++
 lib/Kconfig.debug        |   12 ++++++++++++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index a8b2e03..4dca275 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -230,8 +230,7 @@ extern int rcu_my_thread_group_empty(void);
  */
 #define rcu_dereference_check(p, c) \
 	({ \
-		if (debug_lockdep_rcu_enabled() && !(c)) \
-			lockdep_rcu_dereference(__FILE__, __LINE__); \
+		__do_rcu_dereference_check(c); \
 		rcu_dereference_raw(p); \
 	})
 
@@ -248,8 +247,7 @@ extern int rcu_my_thread_group_empty(void);
  */
 #define rcu_dereference_protected(p, c) \
 	({ \
-		if (debug_lockdep_rcu_enabled() && !(c)) \
-			lockdep_rcu_dereference(__FILE__, __LINE__); \
+		__do_rcu_dereference_check(c); \
 		(p); \
 	})
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 2594e1c..73747b7 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3801,8 +3801,10 @@ void lockdep_rcu_dereference(const char *file, const int line)
 {
 	struct task_struct *curr = current;
 
+#ifndef CONFIG_PROVE_RCU_REPEATEDLY
 	if (!debug_locks_off())
 		return;
+#endif /* #ifdef CONFIG_PROVE_RCU_REPEATEDLY */
 	printk("\n===================================================\n");
 	printk(  "[ INFO: suspicious rcu_dereference_check() usage. ]\n");
 	printk(  "---------------------------------------------------\n");
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 935248b..94090b4 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -512,6 +512,18 @@ config PROVE_RCU
 
 	 Say N if you are unsure.
 
+config PROVE_RCU_REPEATEDLY
+	bool "RCU debugging: don't disable PROVE_RCU on first splat"
+	depends on PROVE_RCU
+	default n
+	help
+	 By itself, PROVE_RCU will disable checking upon issuing the
+	 first warning (or "splat").  This feature prevents such
+	 disabling, allowing multiple RCU-lockdep warnings to be printed
+	 on a single reboot.
+
+	 Say N if you are unsure.
+
 config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
-- 
1.7.0

