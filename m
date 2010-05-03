Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0ECSxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 14:53:35 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40164 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab0ECSx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 14:53:27 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/urgent 01/10] rcu: v2: optionally leave lockdep enabled after RCU lockdep splat
Date: Mon,  3 May 2010 11:53:10 -0700
Message-Id: <1272912799-17859-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100503185253.GA17672@linux.vnet.ibm.com>
References: <20100503185253.GA17672@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

There is no need to disable lockdep after an RCU lockdep splat, so
remove the debug_lockdeps_off() from lockdep_rcu_dereference().
To avoid repeated lockdep splats, use a static variable in the
inlined rcu_dereference_check() and rcu_dereference_protected()
macros so that a given instance splats only once, but so that
multiple instances can be detected per boot.

This is controlled by a new config variable CONFIG_PROVE_RCU_REPEATEDLY,
which is disabled by default.

Requested-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   15 +++++++++++----
 kernel/lockdep.c         |    2 ++
 lib/Kconfig.debug        |   12 ++++++++++++
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 07db2fe..ec9ab49 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -190,6 +190,15 @@ static inline int rcu_read_lock_sched_held(void)
 
 #ifdef CONFIG_PROVE_RCU
 
+#define __do_rcu_dereference_check(c)					\
+	do {								\
+		static bool __warned;					\
+		if (debug_lockdep_rcu_enabled() && !__warned && !(c)) {	\
+			__warned = true;				\
+			lockdep_rcu_dereference(__FILE__, __LINE__);	\
+		}							\
+	} while (0)
+
 /**
  * rcu_dereference_check - rcu_dereference with debug checking
  * @p: The pointer to read, prior to dereferencing
@@ -219,8 +228,7 @@ static inline int rcu_read_lock_sched_held(void)
  */
 #define rcu_dereference_check(p, c) \
 	({ \
-		if (debug_lockdep_rcu_enabled() && !(c)) \
-			lockdep_rcu_dereference(__FILE__, __LINE__); \
+		__do_rcu_dereference_check(c); \
 		rcu_dereference_raw(p); \
 	})
 
@@ -237,8 +245,7 @@ static inline int rcu_read_lock_sched_held(void)
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

