Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab2BCBND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 20:13:03 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59013 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab2BCBNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 20:13:00 -0500
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
Subject: [PATCH RFC tip/core/rcu 2/3] rcu: Add RCU_NONIDLE() for idle-loop RCU read-side critical sections
Date: Thu,  2 Feb 2012 17:12:47 -0800
Message-Id: <1328231568-2971-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328231568-2971-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120203011208.GA2004@linux.vnet.ibm.com>
 <1328231568-2971-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020301-8974-0000-0000-000005D35138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

RCU, RCU-bh, and RCU-sched read-side critical sections are forbidden
in the inner idle loop, that is, between the rcu_idle_enter() and the
rcu_idle_exit() -- RCU will happily ignore any such read-side critical
sections.  However, things like powertop need tracepoints in the inner
idle loop.

This commit therefore provides an RCU_NONIDLE() macro that can be used to
wrap code in the idle loop that requires RCU read-side critical sections.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |   27 +++++++++++++++++++++++++++
 kernel/rcutiny.c         |    2 ++
 kernel/rcutree.c         |    2 ++
 3 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 6ee663c..9372174 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -190,6 +190,33 @@ extern void rcu_idle_exit(void);
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
 
+/**
+ * RCU_NONIDLE - Indicate idle-loop code that needs RCU readers
+ * @a: Code that RCU needs to pay attention to.
+ *
+ * RCU, RCU-bh, and RCU-sched read-side critical sections are forbidden
+ * in the inner idle loop, that is, between the rcu_idle_enter() and
+ * the rcu_idle_exit() -- RCU will happily ignore any such read-side
+ * critical sections.  However, things like powertop need tracepoints
+ * in the inner idle loop.
+ *
+ * This macro provides the way out:  RCU_NONIDLE(do_something_with_RCU())
+ * will tell RCU that it needs to pay attending, invoke its argument
+ * (in this example, a call to the do_something_with_RCU() function),
+ * and then tell RCU to go back to ignoring this CPU.  It is permissible
+ * to nest RCU_NONIDLE() wrappers, but the nesting level is currently
+ * quite limited.  If deeper nesting is required, it will be necessary
+ * to adjust DYNTICK_TASK_NESTING_VALUE accordingly.
+ *
+ * This macro may be used from process-level code only.
+ */
+#define RCU_NONIDLE(a) \
+	do { \
+		rcu_idle_exit(); \
+		do { a; } while (0); \
+		rcu_idle_enter(); \
+	} while (0)
+
 /*
  * Infrastructure to implement the synchronize_() primitives in
  * TREE_RCU and rcu_barrier_() primitives in TINY_RCU.
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 5098aea..b4142a9 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -97,6 +97,7 @@ void rcu_idle_enter(void)
 	rcu_idle_enter_common(oldval);
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(rcu_idle_enter);
 
 /*
  * Exit an interrupt handler towards idle.
@@ -153,6 +154,7 @@ void rcu_idle_exit(void)
 	rcu_idle_exit_common(oldval);
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(rcu_idle_exit);
 
 /*
  * Enter an interrupt handler, moving away from idle.
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e81298a..25111d3 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -402,6 +402,7 @@ void rcu_idle_enter(void)
 	rcu_idle_enter_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(rcu_idle_enter);
 
 /**
  * rcu_irq_exit - inform RCU that current CPU is exiting irq towards idle
@@ -493,6 +494,7 @@ void rcu_idle_exit(void)
 	rcu_idle_exit_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(rcu_idle_exit);
 
 /**
  * rcu_irq_enter - inform RCU that current CPU is entering irq away from idle
-- 
1.7.8

