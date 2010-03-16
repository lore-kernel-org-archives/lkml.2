Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966366Ab0CPOrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:47:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:44496 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966086Ab0CPOq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:46:58 -0400
Date: Tue, 16 Mar 2010 14:46:29 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eric.dumazet@gmail.com, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: arnd@arndb.de, paulmck@linux.vnet.ibm.com, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <20100316000343.GA25857@linux.vnet.ibm.com>
References: <20100316000343.GA25857@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] rcu: Make rcu_read_lock_bh_held() allow for disabled BH
Message-ID: <tip-e3818b8dce2a934cd1521dbc4827e5238d8f45d8@git.kernel.org>
Git-Commit-ID: e3818b8dce2a934cd1521dbc4827e5238d8f45d8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 14:46:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3818b8dce2a934cd1521dbc4827e5238d8f45d8
Gitweb:     http://git.kernel.org/tip/e3818b8dce2a934cd1521dbc4827e5238d8f45d8
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 15 Mar 2010 17:03:43 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 16 Mar 2010 09:57:49 +0100

rcu: Make rcu_read_lock_bh_held() allow for disabled BH

Disabling BH can stand in for rcu_read_lock_bh(), and this patch
updates rcu_read_lock_bh_held() to allow for this.  In order to
avoid include-file hell, this function is moved out of line to
kernel/rcupdate.c.

This fixes a false positive RCU warning.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <20100316000343.GA25857@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/rcupdate.h |   19 ++++---------------
 kernel/rcupdate.c        |   23 +++++++++++++++++++++++
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 3024050..e1bdc4b 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -123,22 +123,11 @@ static inline int rcu_read_lock_held(void)
 	return lock_is_held(&rcu_lock_map);
 }
 
-/**
- * rcu_read_lock_bh_held - might we be in RCU-bh read-side critical section?
- *
- * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in
- * an RCU-bh read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
- * this assumes we are in an RCU-bh read-side critical section unless it can
- * prove otherwise.
- *
- * Check rcu_scheduler_active to prevent false positives during boot.
+/*
+ * rcu_read_lock_bh_held() is defined out of line to avoid #include-file
+ * hell.
  */
-static inline int rcu_read_lock_bh_held(void)
-{
-	if (!debug_lockdep_rcu_enabled())
-		return 1;
-	return lock_is_held(&rcu_bh_lock_map);
-}
+extern int rcu_read_lock_bh_held(void);
 
 /**
  * rcu_read_lock_sched_held - might we be in RCU-sched read-side critical section?
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index f1125c1..63fe254 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -45,6 +45,7 @@
 #include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/kernel_stat.h>
+#include <linux/hardirq.h>
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
@@ -66,6 +67,28 @@ EXPORT_SYMBOL_GPL(rcu_sched_lock_map);
 int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+/**
+ * rcu_read_lock_bh_held - might we be in RCU-bh read-side critical section?
+ *
+ * Check for bottom half being disabled, which covers both the
+ * CONFIG_PROVE_RCU and not cases.  Note that if someone uses
+ * rcu_read_lock_bh(), but then later enables BH, lockdep (if enabled)
+ * will show the situation.
+ *
+ * Check debug_lockdep_rcu_enabled() to prevent false positives during boot.
+ */
+int rcu_read_lock_bh_held(void)
+{
+	if (!debug_lockdep_rcu_enabled())
+		return 1;
+	return in_softirq();
+}
+EXPORT_SYMBOL_GPL(rcu_read_lock_bh_held);
+
+#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 /*
  * This function is invoked towards the end of the scheduler's initialization
  * process.  Before this is called, the idle task might contain
