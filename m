Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab2LNSnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:43:55 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:34661 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891Ab2LNSmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:42:15 -0500
Subject: [RFC][PATCH 7/7] group locking debugging options
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 14 Dec 2012 13:42:08 -0500
References: <20121214184200.8EC5168B@kernel.stglabs.ibm.com>
In-Reply-To: <20121214184200.8EC5168B@kernel.stglabs.ibm.com>
Message-Id: <20121214184208.D9E5804D@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121418-2876-0000-0000-000003225222
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are quite a few of these, and we want to make sure that
there is one-stop-shopping for lock debugging.  

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/lib/Kconfig.debug |  120 ++++++++++++++++++-----------------
 1 file changed, 62 insertions(+), 58 deletions(-)

diff -puN lib/Kconfig.debug~order-lock-debugging-options lib/Kconfig.debug
--- linux-2.6.git/lib/Kconfig.debug~order-lock-debugging-options	2012-12-14 13:34:27.967847057 -0500
+++ linux-2.6.git-dave/lib/Kconfig.debug	2012-12-14 13:34:27.971847091 -0500
@@ -694,6 +694,8 @@ config DEBUG_PREEMPT
 	  if kernel code uses it in a preemption-unsafe way. Also, the kernel
 	  will detect preemption count underflows.
 
+menu "Lock Debugging (spinlocks, mutexes, etc...)"
+
 config DEBUG_RT_MUTEXES
 	bool "RT Mutex debugging, deadlock detection"
 	depends on DEBUG_KERNEL && RT_MUTEXES
@@ -786,6 +788,66 @@ config PROVE_LOCKING
 
 	 For more details, see Documentation/lockdep-design.txt.
 
+config LOCKDEP
+	bool
+	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	select STACKTRACE
+	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE
+	select KALLSYMS
+	select KALLSYMS_ALL
+
+config LOCK_STAT
+	bool "Lock usage statistics"
+	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
+	select LOCKDEP
+	select DEBUG_SPINLOCK
+	select DEBUG_MUTEXES
+	select DEBUG_LOCK_ALLOC
+	default n
+	help
+	 This feature enables tracking lock contention points
+
+	 For more details, see Documentation/lockstat.txt
+
+	 This also enables lock events required by "perf lock",
+	 subcommand of perf.
+	 If you want to use "perf lock", you also need to turn on
+	 CONFIG_EVENT_TRACING.
+
+	 CONFIG_LOCK_STAT defines "contended" and "acquired" lock events.
+	 (CONFIG_LOCKDEP defines "acquire" and "release" events.)
+
+config DEBUG_LOCKDEP
+	bool "Lock dependency engine debugging"
+	depends on DEBUG_KERNEL && LOCKDEP
+	help
+	  If you say Y here, the lock dependency engine will do
+	  additional runtime checks to debug itself, at the price
+	  of more runtime overhead.
+
+config DEBUG_ATOMIC_SLEEP
+	bool "Sleep inside atomic section checking"
+	select PREEMPT_COUNT
+	depends on DEBUG_KERNEL
+	help
+	  If you say Y here, various routines which may sleep will become very
+	  noisy if they are called inside atomic sections: when a spinlock is
+	  held, inside an rcu read side critical section, inside preempt disabled
+	  sections, inside an interrupt, etc...
+
+config DEBUG_KERNEL_API_SELFTESTS
+	bool "Locking API boot-time self-tests"
+	depends on DEBUG_KERNEL
+	help
+	  Say Y here if you want the kernel to run a short self-test during
+	  bootup. The self-test checks whether common types of locking bugs
+	  are detected by debugging mechanisms or not. (if you disable
+	  lock debugging then those bugs wont be detected of course.)
+	  The following locking APIs are covered: spinlocks, rwlocks,
+	  mutexes and rwsems.
+
+endmenu # lock debugging
+
 menu "RCU Debugging"
 
 config PROVE_RCU
@@ -923,70 +985,12 @@ config RCU_TRACE
 
 endmenu # RCU Debugging
 
-config LOCKDEP
-	bool
-	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
-	select STACKTRACE
-	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE
-	select KALLSYMS
-	select KALLSYMS_ALL
-
-config LOCK_STAT
-	bool "Lock usage statistics"
-	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
-	select LOCKDEP
-	select DEBUG_SPINLOCK
-	select DEBUG_MUTEXES
-	select DEBUG_LOCK_ALLOC
-	default n
-	help
-	 This feature enables tracking lock contention points
-
-	 For more details, see Documentation/lockstat.txt
-
-	 This also enables lock events required by "perf lock",
-	 subcommand of perf.
-	 If you want to use "perf lock", you also need to turn on
-	 CONFIG_EVENT_TRACING.
-
-	 CONFIG_LOCK_STAT defines "contended" and "acquired" lock events.
-	 (CONFIG_LOCKDEP defines "acquire" and "release" events.)
-
-config DEBUG_LOCKDEP
-	bool "Lock dependency engine debugging"
-	depends on DEBUG_KERNEL && LOCKDEP
-	help
-	  If you say Y here, the lock dependency engine will do
-	  additional runtime checks to debug itself, at the price
-	  of more runtime overhead.
-
 config TRACE_IRQFLAGS
 	bool
 	help
 	  Enables hooks to interrupt enabling and disabling for
 	  either tracing or lock debugging.
 
-config DEBUG_ATOMIC_SLEEP
-	bool "Sleep inside atomic section checking"
-	select PREEMPT_COUNT
-	depends on DEBUG_KERNEL
-	help
-	  If you say Y here, various routines which may sleep will become very
-	  noisy if they are called inside atomic sections: when a spinlock is
-	  held, inside an rcu read side critical section, inside preempt disabled
-	  sections, inside an interrupt, etc...
-
-config DEBUG_LOCKING_API_SELFTESTS
-	bool "Locking API boot-time self-tests"
-	depends on DEBUG_KERNEL
-	help
-	  Say Y here if you want the kernel to run a short self-test during
-	  bootup. The self-test checks whether common types of locking bugs
-	  are detected by debugging mechanisms or not. (if you disable
-	  lock debugging then those bugs wont be detected of course.)
-	  The following locking APIs are covered: spinlocks, rwlocks,
-	  mutexes and rwsems.
-
 config STACKTRACE
 	bool
 	depends on STACKTRACE_SUPPORT
_

