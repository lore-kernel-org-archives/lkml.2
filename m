Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab0HQXX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 19:23:28 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:39754 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab0HQXXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 19:23:13 -0400
Message-Id: <20100817232151.029653346@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 17 Aug 2010 19:16:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ltt-dev@lists.casi.polymtl.ca,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [RFC PATCH 04/20] Idle notifier standardization x86_32
References: <20100817231619.277457797@efficios.com>
Content-Disposition: inline; filename=idle-notifier-x86_32.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 17 Aug 2010 23:21:51 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add idle notifier callback to x86_32.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 arch/x86/include/asm/idle.h  |    5 -----
 arch/x86/kernel/apm_32.c     |    6 ++++++
 arch/x86/kernel/process_32.c |   33 +++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 5 deletions(-)

Index: linux.trees.git/arch/x86/kernel/process_32.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/process_32.c	2010-06-19 16:09:48.000000000 -0400
+++ linux.trees.git/arch/x86/kernel/process_32.c	2010-06-19 16:16:53.000000000 -0400
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
--- linux.trees.git.orig/arch/x86/include/asm/idle.h	2010-06-19 16:15:29.000000000 -0400
+++ linux.trees.git/arch/x86/include/asm/idle.h	2010-06-19 16:15:34.000000000 -0400
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
--- linux.trees.git.orig/arch/x86/kernel/apm_32.c	2010-06-19 16:08:32.000000000 -0400
+++ linux.trees.git/arch/x86/kernel/apm_32.c	2010-06-19 16:15:34.000000000 -0400
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

