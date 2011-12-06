Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab1LFD2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 22:28:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44921 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859Ab1LFD2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 22:28:07 -0500
Date: Tue, 6 Dec 2011 11:27:54 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Subject: [PATCH 1/3] kernel.h: sched: introduce might_sleep_disabled()
Message-ID: <20111206032754.GA17091@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20111203183417.GA18914@linux.vnet.ibm.com>
 <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111205091924.GA28117@zhy>
 <20111205164505.GB2326@linux.vnet.ibm.com>
 <20111206012635.GA32498@zhy>
 <20111206021227.GO2326@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111206021227.GO2326@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [5342e269: rcu: Permit rt_mutex_unlock() with
irqs disabled], rt_mutex_lock() could be called with irqs
disabled and it will call might_sleep() unconditionally.
To prevent this kind of false positive, introduce
might_sleep_disabled() which will be used in later patch.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 include/linux/kernel.h |   25 +++++++++++++++++++++----
 include/linux/sched.h  |   14 +++++++-------
 kernel/sched.c         |    6 ++++--
 3 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e8b1597..deaba68 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -130,7 +130,8 @@ extern int _cond_resched(void);
 #endif
 
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
-  void __might_sleep(const char *file, int line, int preempt_offset);
+  void __might_sleep(const char *file, int line, int preempt_offset,
+					bool warn_irqs);
 /**
  * might_sleep - annotation for functions that can sleep
  *
@@ -141,12 +142,28 @@ extern int _cond_resched(void);
  * be bitten later when the calling function happens to sleep when it is not
  * supposed to.
  */
-# define might_sleep() \
-	do { __might_sleep(__FILE__, __LINE__, 0); might_resched(); } while (0)
+# define might_sleep()						\
+	do {							\
+		__might_sleep(__FILE__, __LINE__, 0, true);	\
+		might_resched(); }				\
+	while (0)
+
+/*
+ * Special version of might_sleep() which don't warn when called
+ * with irq disabled. Will be used in rt_mutex_lock() which
+ * could be called with irq disabled.
+ */
+# define might_sleep_irqdisabled()						\
+	do {							\
+		__might_sleep(__FILE__, __LINE__, 0, false);	\
+		might_resched(); }				\
+	while (0)
+
 #else
   static inline void __might_sleep(const char *file, int line,
-				   int preempt_offset) { }
+		int preempt_offset, bool warn_irqs) { }
 # define might_sleep() do { might_resched(); } while (0)
+# define might_sleep_irqdisabled() do { might_resched(); } while (0)
 #endif
 
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4a7e4d3..d077c62 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2534,9 +2534,9 @@ static inline int need_resched(void)
  */
 extern int _cond_resched(void);
 
-#define cond_resched() ({			\
-	__might_sleep(__FILE__, __LINE__, 0);	\
-	_cond_resched();			\
+#define cond_resched() ({				\
+	__might_sleep(__FILE__, __LINE__, 0, true);	\
+	_cond_resched();				\
 })
 
 extern int __cond_resched_lock(spinlock_t *lock);
@@ -2547,15 +2547,15 @@ extern int __cond_resched_lock(spinlock_t *lock);
 #define PREEMPT_LOCK_OFFSET	0
 #endif
 
-#define cond_resched_lock(lock) ({				\
-	__might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET);	\
-	__cond_resched_lock(lock);				\
+#define cond_resched_lock(lock) ({					\
+	__might_sleep(__FILE__, __LINE__, PREEMPT_LOCK_OFFSET, true);	\
+	__cond_resched_lock(lock);					\
 })
 
 extern int __cond_resched_softirq(void);
 
 #define cond_resched_softirq() ({					\
-	__might_sleep(__FILE__, __LINE__, SOFTIRQ_DISABLE_OFFSET);	\
+	__might_sleep(__FILE__, __LINE__, SOFTIRQ_DISABLE_OFFSET, true);\
 	__cond_resched_softirq();					\
 })
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 0e9344a..ce24450 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8363,12 +8363,14 @@ static inline int preempt_count_equals(int preempt_offset)
 	return (nested == preempt_offset);
 }
 
-void __might_sleep(const char *file, int line, int preempt_offset)
+void __might_sleep(const char *file, int line, int preempt_offset,
+		   bool warn_irqs)
 {
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
 	rcu_sleep_check(); /* WARN_ON_ONCE() by default, no rate limit reqd. */
-	if ((preempt_count_equals(preempt_offset) && !irqs_disabled()) ||
+	if ((preempt_count_equals(preempt_offset) &&
+	    (warn_irqs ? !irqs_disabled() : 1)) ||
 	    system_state != SYSTEM_RUNNING || oops_in_progress)
 		return;
 	if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
-- 
1.7.5.4

