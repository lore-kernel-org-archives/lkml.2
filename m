Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab0KFS0P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:26:15 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41354 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab0KFS0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:26:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=AjZcseV87D5N/iZUbtJcG0/sDo2ZlkzPhX3QZWz7KU4Q6PJd1EA27DpcSN+55Cc28a
         1CKQAi5JZDoph6IFythdOXfRD7pgqD4kp7n4Qh6pg3VJ5unoBG+G1jNqKkLqlpeLfzj+
         6azldAepjdrlEY0omtgRXdr31OzGlfMztMrxM=
From: Rabin Vincent <rabin@rab.in>
To: linux-arm-kernel@lists.infradead.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tim Bird <tim.bird@am.sony.com>, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 2/6] ARM: place C irq handlers in IRQ_ENTRY for ftrace
Date: Sat,  6 Nov 2010 23:55:50 +0530
Message-Id: <1289067954-5080-2-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1289067954-5080-1-git-send-email-rabin@rab.in>
References: <1289067954-5080-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When FUNCTION_GRAPH_TRACER is enabled, place do_IRQ() and friends in the
IRQ_ENTRY section so that the irq-related features of the function graph
tracer work.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/include/asm/system.h |    5 +++++
 arch/arm/include/asm/traps.h  |   23 +++++++++++++++++++++--
 arch/arm/kernel/irq.c         |    4 +++-
 arch/arm/kernel/smp.c         |    5 +++--
 arch/arm/kernel/vmlinux.lds.S |    1 +
 5 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
index 1120f18..ec4327a 100644
--- a/arch/arm/include/asm/system.h
+++ b/arch/arm/include/asm/system.h
@@ -63,6 +63,11 @@
 #include <asm/outercache.h>
 
 #define __exception	__attribute__((section(".exception.text")))
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+#define __exception_irq_entry	__irq_entry
+#else
+#define __exception_irq_entry	__exception
+#endif
 
 struct thread_info;
 struct task_struct;
diff --git a/arch/arm/include/asm/traps.h b/arch/arm/include/asm/traps.h
index af5d5d1..1b960d5 100644
--- a/arch/arm/include/asm/traps.h
+++ b/arch/arm/include/asm/traps.h
@@ -15,13 +15,32 @@ struct undef_hook {
 void register_undef_hook(struct undef_hook *hook);
 void unregister_undef_hook(struct undef_hook *hook);
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static inline int __in_irqentry_text(unsigned long ptr)
+{
+	extern char __irqentry_text_start[];
+	extern char __irqentry_text_end[];
+
+	return ptr >= (unsigned long)&__irqentry_text_start &&
+	       ptr < (unsigned long)&__irqentry_text_end;
+}
+#else
+static inline int __in_irqentry_text(unsigned long ptr)
+{
+	return 0;
+}
+#endif
+
 static inline int in_exception_text(unsigned long ptr)
 {
 	extern char __exception_text_start[];
 	extern char __exception_text_end[];
+	int in;
+
+	in = ptr >= (unsigned long)&__exception_text_start &&
+	     ptr < (unsigned long)&__exception_text_end;
 
-	return ptr >= (unsigned long)&__exception_text_start &&
-	       ptr < (unsigned long)&__exception_text_end;
+	return in ? : __in_irqentry_text(ptr);
 }
 
 extern void __init early_trap_init(void);
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 36ad3be..6d61633 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -35,6 +35,7 @@
 #include <linux/list.h>
 #include <linux/kallsyms.h>
 #include <linux/proc_fs.h>
+#include <linux/ftrace.h>
 
 #include <asm/system.h>
 #include <asm/mach/irq.h>
@@ -105,7 +106,8 @@ unlock:
  * come via this function.  Instead, they should provide their
  * own 'handler'
  */
-asmlinkage void __exception asm_do_IRQ(unsigned int irq, struct pt_regs *regs)
+asmlinkage void __exception_irq_entry
+asm_do_IRQ(unsigned int irq, struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 8c19595..bbca898 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -16,6 +16,7 @@
 #include <linux/cache.h>
 #include <linux/profile.h>
 #include <linux/errno.h>
+#include <linux/ftrace.h>
 #include <linux/mm.h>
 #include <linux/err.h>
 #include <linux/cpu.h>
@@ -457,7 +458,7 @@ static void ipi_timer(void)
 }
 
 #ifdef CONFIG_LOCAL_TIMERS
-asmlinkage void __exception do_local_timer(struct pt_regs *regs)
+asmlinkage void __exception_irq_entry do_local_timer(struct pt_regs *regs)
 {
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	int cpu = smp_processor_id();
@@ -544,7 +545,7 @@ static void ipi_cpu_stop(unsigned int cpu)
  *
  *  Bit 0 - Inter-processor function call
  */
-asmlinkage void __exception do_IPI(struct pt_regs *regs)
+asmlinkage void __exception_irq_entry do_IPI(struct pt_regs *regs)
 {
 	unsigned int cpu = smp_processor_id();
 	struct ipi_data *ipi = &per_cpu(ipi_data, cpu);
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index cead889..897c1a8 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -101,6 +101,7 @@ SECTIONS
 			__exception_text_start = .;
 			*(.exception.text)
 			__exception_text_end = .;
+			IRQENTRY_TEXT
 			TEXT_TEXT
 			SCHED_TEXT
 			LOCK_TEXT
-- 
1.7.2.3

