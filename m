Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab0GIXjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:39:20 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59632 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706Ab0GIXhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:37:25 -0400
Message-Id: <20100709225815.380485188@efficios.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 18:57:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
Subject: [patch 03/20] idle notifier standardization
References: <20100709225727.312232266@efficios.com>
Content-Disposition: inline; filename=idle-notifier-standardize.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  9 Jul 2010 22:58:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move idle notifiers into arch-agnostic code. Adapt x86 64 accordingly to call
the new architecture-agnostic notifiers rather than its own. Other architectures
are still "todo".

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 arch/x86/include/asm/idle.h  |    7 -------
 arch/x86/kernel/process_64.c |   19 +++----------------
 drivers/idle/i7300_idle.c    |    5 +++--
 include/linux/idle.h         |   19 +++++++++++++++++++
 kernel/notifier.c            |   25 +++++++++++++++++++++++++
 5 files changed, 50 insertions(+), 25 deletions(-)

Index: linux.trees.git/arch/x86/kernel/process_64.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/process_64.c	2010-06-25 15:12:56.000000000 -0400
+++ linux.trees.git/arch/x86/kernel/process_64.c	2010-06-25 15:12:59.000000000 -0400
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
--- linux.trees.git.orig/arch/x86/include/asm/idle.h	2010-06-25 15:12:56.000000000 -0400
+++ linux.trees.git/arch/x86/include/asm/idle.h	2010-06-25 15:12:59.000000000 -0400
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
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/include/linux/idle.h	2010-06-25 15:12:59.000000000 -0400
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
--- linux.trees.git.orig/kernel/notifier.c	2010-06-25 15:12:59.000000000 -0400
+++ linux.trees.git/kernel/notifier.c	2010-06-25 15:12:59.000000000 -0400
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
--- linux.trees.git.orig/drivers/idle/i7300_idle.c	2010-06-19 16:08:34.000000000 -0400
+++ linux.trees.git/drivers/idle/i7300_idle.c	2010-06-25 15:13:11.000000000 -0400
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

