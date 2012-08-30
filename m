Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab2H3Vnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:43:55 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40630 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2H3Vnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:43:51 -0400
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
Subject: [PATCH tip/core/rcu 04/15] rcu: Permit RCU_NONIDLE() to be used from interrupt context
Date: Thu, 30 Aug 2012 11:56:17 -0700
Message-Id: <1346352988-32444-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-4242-0000-0000-000002BA0758
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

There is a need to use RCU from interrupt context, but either before
rcu_irq_enter() is called or after rcu_irq_exit() is called.  If the
interrupt occurs from idle, then lockdep-RCU will complain about such
uses, as they appear to be illegal uses of RCU from the idle loop.
In other environments, RCU_NONIDLE() could be used to properly protect
the use of RCU, but RCU_NONIDLE() currently cannot be invoked except
from process context.

This commit therefore modifies RCU_NONIDLE() to permit its use more
globally.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    6 ++----
 kernel/rcutiny.c         |    2 ++
 kernel/rcutree.c         |    2 ++
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 115ead2..0fbbd52 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -210,14 +210,12 @@ extern void exit_rcu(void);
  * to nest RCU_NONIDLE() wrappers, but the nesting level is currently
  * quite limited.  If deeper nesting is required, it will be necessary
  * to adjust DYNTICK_TASK_NESTING_VALUE accordingly.
- *
- * This macro may be used from process-level code only.
  */
 #define RCU_NONIDLE(a) \
 	do { \
-		rcu_idle_exit(); \
+		rcu_irq_enter(); \
 		do { a; } while (0); \
-		rcu_idle_enter(); \
+		rcu_irq_exit(); \
 	} while (0)
 
 /*
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index e4163c5..2e073a2 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -115,6 +115,7 @@ void rcu_irq_exit(void)
 	rcu_idle_enter_common(newval);
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(rcu_irq_exit);
 
 /* Common code for rcu_idle_exit() and rcu_irq_enter(), see kernel/rcutree.c. */
 static void rcu_idle_exit_common(long long oldval)
@@ -172,6 +173,7 @@ void rcu_irq_enter(void)
 	rcu_idle_exit_common(oldval);
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(rcu_irq_enter);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f280e54..96b8aff 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -447,6 +447,7 @@ void rcu_irq_exit(void)
 		rcu_idle_enter_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(rcu_irq_exit);
 
 /*
  * rcu_idle_exit_common - inform RCU that current CPU is moving away from idle
@@ -542,6 +543,7 @@ void rcu_irq_enter(void)
 		rcu_idle_exit_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(rcu_irq_enter);
 
 /**
  * rcu_nmi_enter - inform RCU of entry to NMI context
-- 
1.7.8

