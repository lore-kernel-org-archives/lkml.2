Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab2BATo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:44:56 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41011 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303Ab2BATnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:43:33 -0500
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
Subject: [PATCH RFC tip/core/rcu 32/41] rcu: Update stall-warning documentation
Date: Wed,  1 Feb 2012 11:41:50 -0800
Message-Id: <1328125319-5205-32-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-1976-0000-0000-00000A09AE06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Add documentation of CONFIG_RCU_CPU_STALL_VERBOSE, CONFIG_RCU_CPU_STALL_INFO,
and RCU_STALL_DELAY_DELTA.  Describe multiple stall-warning messages from
a single stall, and the timing of the subsequent messages.  Add headings.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/stallwarn.txt |   85 ++++++++++++++++++++++++++++++++++++---
 1 files changed, 79 insertions(+), 6 deletions(-)

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 083d88c..54f354c 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -14,12 +14,36 @@ CONFIG_RCU_CPU_STALL_TIMEOUT
 	issues an RCU CPU stall warning.  This time period is normally
 	ten seconds.
 
-RCU_SECONDS_TILL_STALL_RECHECK
+	This configuration parameter may be changed at runtime via the
+	/sys/module/rcutree/parameters/rcu_cpu_stall_timeout, however
+	this parameter is checked only at the beginning of a cycle.
+	So if you are 30 seconds into a 70-second stall, setting this
+	sysfs parameter to (say) five will shorten the timeout for the
+	-next- stall, or the following warning for the current stall
+	(assuming the stall lasts long enough).  It will not affect the
+	timing of the next warning for the current stall.
 
-	This macro defines the period of time that RCU will wait after
-	issuing a stall warning until it issues another stall warning
-	for the same stall.  This time period is normally set to three
-	times the check interval plus thirty seconds.
+	Stall-warning messages may be enabled and disabled completely via
+	/sys/module/rcutree/parameters/rcu_cpu_stall_suppress.
+
+CONFIG_RCU_CPU_STALL_VERBOSE
+
+	This kernel configuration parameter causes the stall warning to
+	also dump the stacks of any tasks that are blocking the current
+	RCU-preempt grace period.
+
+RCU_CPU_STALL_INFO
+
+	This kernel configuration parameter causes the stall warning to
+	print out additional per-CPU diagnostic information, including
+	information on scheduling-clock ticks and RCU's idle-CPU tracking.
+
+RCU_STALL_DELAY_DELTA
+
+	Although the lockdep facility is extremely useful, it does add
+	some overhead.  Therefore, under CONFIG_PROVE_RCU, the
+	RCU_STALL_DELAY_DELTA macro allows five extra seconds before
+	giving an RCU CPU stall warning message.
 
 RCU_STALL_RAT_DELAY
 
@@ -64,6 +88,54 @@ INFO: rcu_bh_state detected stalls on CPUs/tasks: { } (detected by 4, 2502 jiffi
 
 This is rare, but does happen from time to time in real life.
 
+If the CONFIG_RCU_CPU_STALL_INFO kernel configuration parameter is set,
+more information is printed with the stall-warning message, for example:
+
+	INFO: rcu_preempt detected stall on CPU
+	0: (63959 ticks this GP) idle=241/3fffffffffffffff/0
+	   (t=65000 jiffies)
+
+In kernels with CONFIG_RCU_FAST_NO_HZ, even more information is
+printed:
+
+	INFO: rcu_preempt detected stall on CPU
+	0: (64628 ticks this GP) idle=dd5/3fffffffffffffff/0 drain=0 . timer=-1
+	   (t=65000 jiffies)
+
+The "(64628 ticks this GP)" indicates that this CPU has taken more
+than 64,000 scheduling-clock interrupts during the current stalled
+grace period.  If the CPU was not yet aware of the current grace
+period (for example, if it was offline), then this part of the message
+indicates how many grace periods behind the CPU is.
+
+The "idle=" portion of the message prints the dyntick-idle state.
+The hex number before the first "/" is the low-order 12 bits of the
+dynticks counter, which will have an even-numbered value if the CPU is
+in dyntick-idle mode and an odd-numbered value otherwise.  The hex
+number between the two "/"s is the value of the nesting, which will
+be a small positive number if in the idle loop and a very large positive
+number (as shown above) otherwise.
+
+For CONFIG_RCU_FAST_NO_HZ kernels, the "drain=0" indicates that the
+CPU is not in the process of trying to force itself into dyntick-idle
+state, the "." indicates that the CPU has not given up forcing RCU
+into dyntick-idle mode (it would be "H" otherwise), and the "timer=-1"
+indicates that the CPU has not recented forced RCU into dyntick-idle
+mode (it would otherwise indicate the number of microseconds remaining
+in this forced state).
+
+
+Multiple Warnings From One Stall
+
+If a stall lasts long enough, multiple stall-warning messages will be
+printed for it.  The second and subsequent messages are printed at
+longer intervals, so that the time between (say) the first and second
+message will be about three times the interval between the beginning
+of the stall and the first message.
+
+
+What Causes RCU CPU Stall Warnings?
+
 So your kernel printed an RCU CPU stall warning.  The next question is
 "What caused it?"  The following problems can result in RCU CPU stall
 warnings:
@@ -128,4 +200,5 @@ is occurring, which will usually be in the function nearest the top of
 that portion of the stack which remains the same from trace to trace.
 If you can reliably trigger the stall, ftrace can be quite helpful.
 
-RCU bugs can often be debugged with the help of CONFIG_RCU_TRACE.
+RCU bugs can often be debugged with the help of CONFIG_RCU_TRACE
+and with RCU's event tracing.
-- 
1.7.8

