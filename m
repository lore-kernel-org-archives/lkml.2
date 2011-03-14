Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab1CNDwE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 23:52:04 -0400
Received: from flusers.ccur.com ([173.221.59.2]:45685 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756767Ab1CNDvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 23:51:50 -0400
Date: Sun, 13 Mar 2011 23:50:44 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] jrcu: support lazy / not-lazy end-of-batch recognition
Message-ID: <20110314035044.GA12983@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: make lazy/not-lazy end-of-batch recognition a config option.

Some mb() are not needed for correct operation, they just make JRCU
recognize end-of-batch at the earliest possible moment.  Mark those
semi-optional mb's with an #ifdef.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/init/Kconfig
===================================================================
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -434,6 +434,23 @@ config JRCU_DAEMON
 	  Required. The context switch when leaving the daemon is needed
 	  to get the CPU to reliably participate in end-of-batch processing.
 
+config JRCU_LAZY
+	bool "Should JRCU be lazy recognizing end-of-batch"
+	depends on JRCU
+	default n
+	help
+	  If you say Y here, JRCU will on occasion fail to recognize
+	  end-of-batch for an rcu period or two.
+
+	  If you say N here, JRCU will be more aggressive; in fact it
+	  will always recognize end-of-batch at the earliest possible time.
+
+	  Being lazy should be fractionally more efficient in that JRCU
+	  inserts fewer memory barriers along some high performance kernel
+	  code paths.
+
+	  If unsure, say N.
+
 config PREEMPT_COUNT_CPU
 	# bool "Let one CPU look at another CPUs preemption count"
 	bool
Index: b/include/linux/preempt.h
===================================================================
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -10,12 +10,36 @@
 #include <linux/linkage.h>
 #include <linux/list.h>
 
+/* cannot include rcupdate.h here, so open-code this */
+
+#if defined(CONFIG_JRCU)
+# define __add_preempt_count(val) do { \
+	int newval = (preempt_count() += (val)); \
+	if (newval == (val)) \
+		smp_wmb(); \
+} while (0)
+#else
+# define __add_preempt_count(val) do { preempt_count() += (val); } while (0)
+#endif
+
+#if defined(CONFIG_JRCU_LAZY) || !defined(CONFIG_JRCU)
+# define __sub_preempt_count(val) do { preempt_count() -= (val); } while (0)
+#else
+# define __sub_preempt_count(val) do { \
+	int newval = (preempt_count() -= (val)); \
+	if (newval == 0) { \
+		/* race with preemption OK, preempt will do the mb for us */ \
+		smp_wmb(); \
+	} \
+} while (0)
+#endif
+
 #if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
   extern void add_preempt_count(int val);
   extern void sub_preempt_count(int val);
 #else
-# define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
-# define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
+# define add_preempt_count(val) __add_preempt_count(val)
+# define sub_preempt_count(val) __sub_preempt_count(val)
 #endif
 
 #define inc_preempt_count() add_preempt_count(1)
Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -154,9 +154,7 @@ static inline void rcu_eob(int cpu)
 	struct rcu_data *rd = &rcu_data[cpu];
 	if (unlikely(rd->wait)) {
 		rd->wait = 0;
-#ifdef CONFIG_RCU_PARANOID
-		/* not needed, we can tolerate some fuzziness on exactly
-		 * when other CPUs see the above write insn. */
+#ifndef CONFIG_JRCU_LAZY
 		smp_wmb();
 #endif
 	}
Index: b/kernel/sched.c
===================================================================
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3829,7 +3829,7 @@ void __kprobes add_preempt_count(int val
 	if (DEBUG_LOCKS_WARN_ON((preempt_count() < 0)))
 		return;
 #endif
-	preempt_count() += val;
+	__add_preempt_count(val);
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
 	 * Spinlock count overflowing soon?
@@ -3860,7 +3860,7 @@ void __kprobes sub_preempt_count(int val
 
 	if (preempt_count() == val)
 		trace_preempt_on(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
-	preempt_count() -= val;
+	__sub_preempt_count(val);
 }
 EXPORT_SYMBOL(sub_preempt_count);
 
