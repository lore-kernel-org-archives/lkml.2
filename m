Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab1CIWTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:19:48 -0500
Received: from flusers.ccur.com ([173.221.59.2]:54245 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751128Ab1CIWTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:19:46 -0500
Date: Wed, 9 Mar 2011 17:19:16 -0500
From: Joe Korty <joe.korty@ccur.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "loic.minier@linaro.org" <loic.minier@linaro.org>,
        "dhaval.giani@gmail.com" <dhaval.giani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "houston.jim@comcast.net" <houston.jim@comcast.net>
Subject: [PATCH 1/4] jrcu: remove preempt_enable() tap [resend]
Message-ID: <20110309221916.GE24670@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <4CD912E9.1080907@cn.fujitsu.com>
 <20101110155419.GC5750@nowhere>
 <1289410271.2084.25.camel@laptop>
 <20101111041920.GD3134@linux.vnet.ibm.com>
 <20101113223046.GB5445@nowhere>
 <20101116012846.GV2555@linux.vnet.ibm.com>
 <20101116135230.GA5362@nowhere>
 <20101116155104.GB2497@linux.vnet.ibm.com>
 <20101117005229.GC26243@nowhere>
 <20110307203106.GA23002@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307203106.GA23002@tsunami.ccur.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: remove the preempt_enable() tap.

This is expensive, and does not seem to be needed.

Without this tap present, jrcu was able to successfully
recognize end-of-batch in a timely manner, under all the
tests I could throw at it.

It did however take longer. Batch lengths approaching 400
msecs now easily occur. Before it was very difficult to get
a batch length greater than one RCU_HZ period, 50 msecs.

One interesting side effect: with this change the daemon
approach is now required. If the invoking cpu is otherwise
idle, then the context switch on daemon exit is the only
source of recognized quiescent points for that cpu.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

-----

From: Joe Korty <joe.korty@ccur.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 8 Mar 2011 17:53:55 -0500
Subject: Re: [PATCH] An RCU for SMP with a single CPU garbage collector

Hi Paul,
I had a brainstorm. It _seems_ that JRCU might work fine if
all I did was remove the expensive preempt_enable() tap.
No new taps on system calls or anywhere else.  That would
leave only the context switch tap plus the batch start/end
sampling that is remotely performed on each cpu by the
garbage collector.  Not even rcu_read_unlock has a tap --
it is just a plain-jane preempt_enable() now.

And indeed it works!  I am able to turn off the local
timer interrupt on one (of 15) cpus and the batches
keep flowing on.  I have two user 100%  use test apps
(one of them does no system calls), when I run that
on the timer-disabled cpu the batches still advance.
Admittedly the batches do not advance as fast as before
.. they used to advance at the max rate of 50 msecs/batch.
Now I regularly see batch lengths approaching 400 msecs.

I plan to put some taps into some other low overhead places
-- at all the voluntary preemption points, at might_sleep,
at rcu_read_unlock, for safety purposes.  But it is nice
to see a zero overhead approach that works fine without
any of that.

Regards,
Joe

Index: b/include/linux/preempt.h
===================================================================
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -10,26 +10,12 @@
 #include <linux/linkage.h>
 #include <linux/list.h>
 
-# define __add_preempt_count(val) do { preempt_count() += (val); } while (0)
-
-#ifndef CONFIG_JRCU
-# define __sub_preempt_count(val) do { preempt_count() -= (val); } while (0)
-#else
-  extern void __rcu_preempt_sub(void);
-# define __sub_preempt_count(val) do { \
-	if (!(preempt_count() -= (val))) { \
-		/* preempt is enabled, RCU OK with consequent stale result */ \
-		__rcu_preempt_sub(); \
-	} \
-} while (0)
-#endif
-
 #if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
   extern void add_preempt_count(int val);
   extern void sub_preempt_count(int val);
 #else
-# define add_preempt_count(val)	__add_preempt_count(val)
-# define sub_preempt_count(val)	__sub_preempt_count(val)
+# define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
+# define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
 #endif
 
 #define inc_preempt_count() add_preempt_count(1)
Index: b/init/Kconfig
===================================================================
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -426,15 +426,12 @@ config PREEMPT_RCU
 	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
 
 config JRCU_DAEMON
-	bool "Drive JRCU from a daemon"
+	bool
 	depends on JRCU
-	default Y
+	default y
 	help
-	  Normally JRCU end-of-batch processing is driven from a SoftIRQ
-	  'interrupt' driver.  If you consider this to be too invasive,
-	  this option can be used to drive JRCU from a kernel daemon.
-
-	  If unsure, say Y here.
+	  Required. The context switch when leaving the daemon is needed
+	  to get the CPU to reliably participate in end-of-batch processing.
 
 config RCU_TRACE
 	bool "Enable tracing for RCU"
Index: b/kernel/sched.c
===================================================================
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3826,7 +3826,7 @@ void __kprobes add_preempt_count(int val
 	if (DEBUG_LOCKS_WARN_ON((preempt_count() < 0)))
 		return;
 #endif
-	__add_preempt_count(val);
+	preempt_count() += val;
 #ifdef CONFIG_DEBUG_PREEMPT
 	/*
 	 * Spinlock count overflowing soon?
@@ -3857,7 +3857,7 @@ void __kprobes sub_preempt_count(int val
 
 	if (preempt_count() == val)
 		trace_preempt_on(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
-	__sub_preempt_count(val);
+	preempt_count() -= val;
 }
 EXPORT_SYMBOL(sub_preempt_count);
 
Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -158,12 +158,6 @@ void rcu_note_context_switch(int cpu)
 	rcu_eob(cpu);
 }
 
-void __rcu_preempt_sub(void)
-{
-	rcu_eob(rcu_cpu());
-}
-EXPORT_SYMBOL(__rcu_preempt_sub);
-
 void rcu_barrier(void)
 {
 	struct rcu_synchronize rcu;
