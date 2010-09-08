Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab0IHP5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:57:05 -0400
Received: from mail.openrapids.net ([64.15.138.104]:40043 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755789Ab0IHP5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:57:02 -0400
Date: Wed, 8 Sep 2010 11:56:59 -0400
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
Subject: [RFC PATCH 1/2] Idle notifier standardization (v2)
Message-ID: <20100908155659.GA23344@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 11:54:52 up 228 days, 18:31,  5 users,  load average: 0.08, 0.07,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move idle notifiers into arch-agnostic code. Adapt x86 64 accordingly to call
the new architecture-agnostic notifiers rather than its own.

The architectures implementing the idle notifier define the config option:

CONFIG_HAVE_IDLE_NOTIFIER

Changelog since v1:
* Add CONFIG_HAVE_IDLE_NOTIFIER.


This is needed by the generic ring buffer. It needs to let the system sleep if
there is nothing going on other than tracing on a cpu, but for streaming it also
has to provide an upper bound on the delay before the information is sent out
(for merging across event streams coming from different CPUs). These notifiers
lets the ring buffer use deferrable timers to perform data delivery by forcing a
buffer flush before going to sleep.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 arch/x86/Kconfig             |    1 +
 arch/x86/include/asm/idle.h  |    7 -------
 arch/x86/kernel/process_64.c |   19 +++----------------
 drivers/idle/i7300_idle.c    |    5 +++--
 include/linux/idle.h         |   19 +++++++++++++++++++
 init/Kconfig                 |    3 +++
 kernel/notifier.c            |   25 +++++++++++++++++++++++++
 7 files changed, 54 insertions(+), 25 deletions(-)

Index: linux.trees.git/arch/x86/kernel/process_64.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/process_64.c
+++ linux.trees.git/arch/x86/kernel/process_64.c
@@ -35,6 +35,7 @@
 #include <linux/tick.h>
 #include <linux/prctl.h>
 #include <linux/uaccess.h>
+#include <linux/idle.h>
 #include <linux/io.h>
 #include <linux/ftrace.h>
 
@@ -58,31 +59,17 @@ asmlinkage extern void ret_from_fork(voi
 DEFINE_PER_CPU(unsigned long, old_rsp);
 static DEFINE_PER_CPU(unsigned char, is_idle);
 
-static ATOMIC_NOTIFIER_HEAD(idle_notifier);
-
-void idle_notifier_register(struct notifier_block *n)
-{
-	atomic_notifier_chain_register(&idle_notifier, n);
-}
-EXPORT_SYMBOL_GPL(idle_notifier_register);
-
-void idle_notifier_unregister(struct notifier_block *n)
-{
-	atomic_notifier_chain_unregister(&idle_notifier, n);
-}
-EXPORT_SYMBOL_GPL(idle_notifier_unregister);
-
 void enter_idle(void)
 {
 	percpu_write(is_idle, 1);
-	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
+	notify_idle(IDLE_START);
 }
 
 static void __exit_idle(void)
 {
 	if (x86_test_and_clear_bit_percpu(0, is_idle) == 0)
 		return;
-	atomic_notifier_call_chain(&idle_notifier, IDLE_END, NULL);
+	notify_idle(IDLE_END);
 }
 
 /* Called from interrupts to signify idle end */
Index: linux.trees.git/arch/x86/include/asm/idle.h
===================================================================
--- linux.trees.git.orig/arch/x86/include/asm/idle.h
+++ linux.trees.git/arch/x86/include/asm/idle.h
@@ -1,13 +1,6 @@
 #ifndef _ASM_X86_IDLE_H
 #define _ASM_X86_IDLE_H
 
-#define IDLE_START 1
-#define IDLE_END 2
-
-struct notifier_block;
-void idle_notifier_register(struct notifier_block *n);
-void idle_notifier_unregister(struct notifier_block *n);
-
 #ifdef CONFIG_X86_64
 void enter_idle(void);
 void exit_idle(void);
Index: linux.trees.git/include/linux/idle.h
===================================================================
--- /dev/null
+++ linux.trees.git/include/linux/idle.h
@@ -0,0 +1,19 @@
+/*
+ * include/linux/idle.h - generic idle definition
+ *
+ */
+#ifndef _LINUX_IDLE_H_
+#define _LINUX_IDLE_H_
+
+#include <linux/notifier.h>
+
+enum idle_val {
+	IDLE_START = 1,
+	IDLE_END = 2,
+};
+
+int notify_idle(enum idle_val val);
+void register_idle_notifier(struct notifier_block *n);
+void unregister_idle_notifier(struct notifier_block *n);
+
+#endif /* _LINUX_IDLE_H_ */
Index: linux.trees.git/kernel/notifier.c
===================================================================
--- linux.trees.git.orig/kernel/notifier.c
+++ linux.trees.git/kernel/notifier.c
@@ -5,6 +5,7 @@
 #include <linux/rcupdate.h>
 #include <linux/vmalloc.h>
 #include <linux/reboot.h>
+#include <linux/idle.h>
 
 /*
  *	Notifier list for kernel code which wants to be called
@@ -584,3 +585,27 @@ int unregister_die_notifier(struct notif
 	return atomic_notifier_chain_unregister(&die_chain, nb);
 }
 EXPORT_SYMBOL_GPL(unregister_die_notifier);
+
+static ATOMIC_NOTIFIER_HEAD(idle_notifier);
+
+/*
+ * Trace last event before calling notifiers. Notifiers flush data from buffers
+ * before going to idle.
+ */
+int notrace notify_idle(enum idle_val val)
+{
+	return atomic_notifier_call_chain(&idle_notifier, val, NULL);
+}
+EXPORT_SYMBOL_GPL(notify_idle);
+
+void register_idle_notifier(struct notifier_block *n)
+{
+	atomic_notifier_chain_register(&idle_notifier, n);
+}
+EXPORT_SYMBOL_GPL(register_idle_notifier);
+
+void unregister_idle_notifier(struct notifier_block *n)
+{
+	atomic_notifier_chain_unregister(&idle_notifier, n);
+}
+EXPORT_SYMBOL_GPL(unregister_idle_notifier);
Index: linux.trees.git/drivers/idle/i7300_idle.c
===================================================================
--- linux.trees.git.orig/drivers/idle/i7300_idle.c
+++ linux.trees.git/drivers/idle/i7300_idle.c
@@ -27,6 +27,7 @@
 #include <linux/debugfs.h>
 #include <linux/stop_machine.h>
 #include <linux/i7300_idle.h>
+#include <linux/idle.h>
 
 #include <asm/idle.h>
 
@@ -583,7 +584,7 @@ static int __init i7300_idle_init(void)
 		}
 	}
 
-	idle_notifier_register(&i7300_idle_nb);
+	register_idle_notifier(&i7300_idle_nb);
 
 	printk(KERN_INFO "i7300_idle: loaded v%s\n", I7300_IDLE_DRIVER_VERSION);
 	return 0;
@@ -591,7 +592,7 @@ static int __init i7300_idle_init(void)
 
 static void __exit i7300_idle_exit(void)
 {
-	idle_notifier_unregister(&i7300_idle_nb);
+	unregister_idle_notifier(&i7300_idle_nb);
 	free_cpumask_var(idle_cpumask);
 
 	if (debugfs_dir) {
Index: linux.trees.git/arch/x86/Kconfig
===================================================================
--- linux.trees.git.orig/arch/x86/Kconfig
+++ linux.trees.git/arch/x86/Kconfig
@@ -45,6 +45,7 @@ config X86
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
+	select HAVE_IDLE_NOTIFIER if X86_64
 	select USER_STACKTRACE_SUPPORT
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_DMA_API_DEBUG
Index: linux.trees.git/init/Kconfig
===================================================================
--- linux.trees.git.orig/init/Kconfig
+++ linux.trees.git/init/Kconfig
@@ -1149,6 +1149,9 @@ source "arch/Kconfig"
 
 endmenu		# General setup
 
+config HAVE_IDLE_NOTIFIER
+	bool
+
 config HAVE_GENERIC_DMA_COHERENT
 	bool
 	default n
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
