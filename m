Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab0DWTnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:43:37 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42461 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197Ab0DWTnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:43:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v2.6.34-rc5 03/12] rcu: leave lockdep enabled after RCU lockdep splat
Date: Fri, 23 Apr 2010 12:43:21 -0700
Message-Id: <1272051810-11249-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100423194255.GE2589@linux.vnet.ibm.com>
References: <20100423194255.GE2589@linux.vnet.ibm.com>
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

Requested-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   15 +++++++++++----
 kernel/lockdep.c         |    2 --
 2 files changed, 11 insertions(+), 6 deletions(-)

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
index 2594e1c..03dd1fa 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3801,8 +3801,6 @@ void lockdep_rcu_dereference(const char *file, const int line)
 {
 	struct task_struct *curr = current;
 
-	if (!debug_locks_off())
-		return;
 	printk("\n===================================================\n");
 	printk(  "[ INFO: suspicious rcu_dereference_check() usage. ]\n");
 	printk(  "---------------------------------------------------\n");
-- 
1.7.0

