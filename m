Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab0IHQAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 12:00:08 -0400
Received: from mail.openrapids.net ([64.15.138.104]:33202 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755935Ab0IHP74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:59:56 -0400
Date: Wed, 8 Sep 2010 11:59:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: linux-kernel@vger.kernel.org
Cc: ltt-dev@lists.casi.polymtl.ca,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [RFC PATCH 2/2] Idle notifier standardization x86_32 (v2)
Message-ID: <20100908155953.GB23344@Krystal>
References: <20100908155659.GA23344@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100908155659.GA23344@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:57:06 up 228 days, 18:33,  5 users,  load average: 0.18, 0.10,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add idle notifier callback to x86_32.

Changelog since v1:
* Add CONFIG_HAVE_IDLE_NOTIFIER.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 arch/x86/Kconfig             |    2 +-
 arch/x86/include/asm/idle.h  |    5 -----
 arch/x86/kernel/apm_32.c     |    6 ++++++
 arch/x86/kernel/process_32.c |   33 +++++++++++++++++++++++++++++++++
 4 files changed, 40 insertions(+), 6 deletions(-)

Index: linux.trees.git/arch/x86/kernel/process_32.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/process_32.c
+++ linux.trees.git/arch/x86/kernel/process_32.c
@@ -38,6 +38,8 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/kdebug.h>
+#include <linux/notifier.h>
+#include <linux/idle.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -61,6 +63,30 @@
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
+static DEFINE_PER_CPU(unsigned char, is_idle);
+
+void enter_idle(void)
+{
+	percpu_write(is_idle, 1);
+	notify_idle(IDLE_START);
+}
+
+static void __exit_idle(void)
+{
+	if (x86_test_and_clear_bit_percpu(0, is_idle) == 0)
+		return;
+	notify_idle(IDLE_END);
+}
+
+/* Called from interrupts to signify idle end */
+void exit_idle(void)
+{
+	/* idle loop has pid 0 */
+	if (current->pid)
+		return;
+	__exit_idle();
+}
+
 /*
  * Return saved PC of a blocked thread.
  */
@@ -109,10 +135,17 @@ void cpu_idle(void)
 				play_dead();
 
 			local_irq_disable();
+			enter_idle();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
 			pm_idle();
 			start_critical_timings();
+			/*
+			 * In many cases the interrupt that ended idle
+			 * has already called exit_idle. But some idle loops can
+			 * be woken up without interrupt.
+			 */
+			__exit_idle();
 
 			trace_power_end(smp_processor_id());
 		}
Index: linux.trees.git/arch/x86/include/asm/idle.h
===================================================================
--- linux.trees.git.orig/arch/x86/include/asm/idle.h
+++ linux.trees.git/arch/x86/include/asm/idle.h
@@ -1,13 +1,8 @@
 #ifndef _ASM_X86_IDLE_H
 #define _ASM_X86_IDLE_H
 
-#ifdef CONFIG_X86_64
 void enter_idle(void);
 void exit_idle(void);
-#else /* !CONFIG_X86_64 */
-static inline void enter_idle(void) { }
-static inline void exit_idle(void) { }
-#endif /* CONFIG_X86_64 */
 
 void c1e_remove_cpu(int cpu);
 
Index: linux.trees.git/arch/x86/kernel/apm_32.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/apm_32.c
+++ linux.trees.git/arch/x86/kernel/apm_32.c
@@ -227,6 +227,7 @@
 #include <linux/suspend.h>
 #include <linux/kthread.h>
 #include <linux/jiffies.h>
+#include <linux/idle.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -947,10 +948,15 @@ recalc:
 				break;
 			}
 		}
+		enter_idle();
 		if (original_pm_idle)
 			original_pm_idle();
 		else
 			default_idle();
+		/* In many cases the interrupt that ended idle
+		   has already called exit_idle. But some idle
+		   loops can be woken up without interrupt. */
+		__exit_idle();
 		local_irq_disable();
 		jiffies_since_last_check = jiffies - last_jiffies;
 		if (jiffies_since_last_check > idle_period)
Index: linux.trees.git/arch/x86/Kconfig
===================================================================
--- linux.trees.git.orig/arch/x86/Kconfig
+++ linux.trees.git/arch/x86/Kconfig
@@ -45,7 +45,7 @@ config X86
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
-	select HAVE_IDLE_NOTIFIER if X86_64
+	select HAVE_IDLE_NOTIFIER
 	select USER_STACKTRACE_SUPPORT
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_DMA_API_DEBUG
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
