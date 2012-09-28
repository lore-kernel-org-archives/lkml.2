Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2I1IRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:17:25 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:33302 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2I1IRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:17:15 -0400
X-AuditID: b753bd60-98653ba000002f78-b5-50655d08343d
X-AuditID: b753bd60-98653ba000002f78-b5-50655d08343d
Subject: [PATCH -tip 2/3] kprobes/x86: Move ftrace-based kprobe code into
 kprobes-ftrace.c
To: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 28 Sep 2012 17:15:20 +0900
Message-ID: <20120928081520.3560.25624.stgit@ltc138.sdl.hitachi.co.jp>
In-Reply-To: <20120928081509.3560.8860.stgit@ltc138.sdl.hitachi.co.jp>
References: <20120928081509.3560.8860.stgit@ltc138.sdl.hitachi.co.jp>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split ftrace-based kprobes code from kprobes, and introduce
CONFIG_(HAVE_)KPROBES_ON_FTRACE Kconfig flags.
For the cleanup reason, this also moves kprobe_ftrace check
into skip_singlestep.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/Kconfig                     |   12 +++++
 arch/x86/Kconfig                 |    1 
 arch/x86/kernel/Makefile         |    1 
 arch/x86/kernel/kprobes-common.h |   11 ++++
 arch/x86/kernel/kprobes-ftrace.c |   93 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/kprobes.c        |   70 +----------------------------
 include/linux/kprobes.h          |   12 -----
 kernel/kprobes.c                 |    8 ++-
 8 files changed, 125 insertions(+), 83 deletions(-)
 create mode 100644 arch/x86/kernel/kprobes-ftrace.c

diff --git a/arch/Kconfig b/arch/Kconfig
index ea5feb6..d799de9 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -76,6 +76,15 @@ config OPTPROBES
 	depends on KPROBES && HAVE_OPTPROBES
 	depends on !PREEMPT
 
+config KPROBES_ON_FTRACE
+	def_bool y
+	depends on KPROBES && HAVE_KPROBES_ON_FTRACE
+	depends on DYNAMIC_FTRACE_WITH_REGS
+	help
+	 If function tracer is enabled and the arch supports full
+	 passing of pt_regs to function tracing, then kprobes can
+	 optimize on top of function tracing.
+
 config UPROBES
 	bool "Transparent user-space probes (EXPERIMENTAL)"
 	depends on UPROBE_EVENT && PERF_EVENTS
@@ -138,6 +147,9 @@ config HAVE_KRETPROBES
 config HAVE_OPTPROBES
 	bool
 
+config HAVE_KPROBES_ON_FTRACE
+	bool
+
 config HAVE_NMI_WATCHDOG
 	bool
 #
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9570638..8e657ce 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -37,6 +37,7 @@ config X86
 	select HAVE_DMA_CONTIGUOUS if !SWIOTLB
 	select HAVE_KRETPROBES
 	select HAVE_OPTPROBES
+	select HAVE_KPROBES_ON_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FENTRY if X86_64
 	select HAVE_C_RECORDMCOUNT
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 8d7a619..ebef9ad 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -67,6 +67,7 @@ obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_OPTPROBES)		+= kprobes-opt.o
+obj-$(CONFIG_KPROBES_ON_FTRACE)	+= kprobes-ftrace.o
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
diff --git a/arch/x86/kernel/kprobes-common.h b/arch/x86/kernel/kprobes-common.h
index 3230b68..2e9d4b5 100644
--- a/arch/x86/kernel/kprobes-common.h
+++ b/arch/x86/kernel/kprobes-common.h
@@ -99,4 +99,15 @@ static inline unsigned long __recover_optprobed_insn(kprobe_opcode_t *buf, unsig
 	return addr;
 }
 #endif
+
+#ifdef CONFIG_KPROBES_ON_FTRACE
+extern int skip_singlestep(struct kprobe *p, struct pt_regs *regs,
+			   struct kprobe_ctlblk *kcb);
+#else
+static inline int skip_singlestep(struct kprobe *p, struct pt_regs *regs,
+				  struct kprobe_ctlblk *kcb)
+{
+	return 0;
+}
+#endif
 #endif
diff --git a/arch/x86/kernel/kprobes-ftrace.c b/arch/x86/kernel/kprobes-ftrace.c
new file mode 100644
index 0000000..70a81c7
--- /dev/null
+++ b/arch/x86/kernel/kprobes-ftrace.c
@@ -0,0 +1,93 @@
+/*
+ * Dynamic Ftrace based Kprobes Optimization
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) Hitachi Ltd., 2012
+ */
+#include <linux/kprobes.h>
+#include <linux/ptrace.h>
+#include <linux/hardirq.h>
+#include <linux/preempt.h>
+#include <linux/ftrace.h>
+
+#include "kprobes-common.h"
+
+static int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
+			     struct kprobe_ctlblk *kcb)
+{
+	/*
+	 * Emulate singlestep (and also recover regs->ip)
+	 * as if there is a 5byte nop
+	 */
+	regs->ip = (unsigned long)p->addr + MCOUNT_INSN_SIZE;
+	if (unlikely(p->post_handler)) {
+		kcb->kprobe_status = KPROBE_HIT_SSDONE;
+		p->post_handler(p, regs, 0);
+	}
+	__this_cpu_write(current_kprobe, NULL);
+	return 1;
+}
+
+int __kprobes skip_singlestep(struct kprobe *p, struct pt_regs *regs,
+			      struct kprobe_ctlblk *kcb)
+{
+	if (kprobe_ftrace(p))
+		return __skip_singlestep(p, regs, kcb);
+	else
+		return 0;
+}
+
+/* Ftrace callback handler for kprobes */
+void __kprobes kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
+				     struct ftrace_ops *ops, struct pt_regs *regs)
+{
+	struct kprobe *p;
+	struct kprobe_ctlblk *kcb;
+	unsigned long flags;
+
+	/* Disable irq for emulating a breakpoint and avoiding preempt */
+	local_irq_save(flags);
+
+	p = get_kprobe((kprobe_opcode_t *)ip);
+	if (unlikely(!p) || kprobe_disabled(p))
+		goto end;
+
+	kcb = get_kprobe_ctlblk();
+	if (kprobe_running()) {
+		kprobes_inc_nmissed_count(p);
+	} else {
+		/* Kprobe handler expects regs->ip = ip + 1 as breakpoint hit */
+		regs->ip = ip + sizeof(kprobe_opcode_t);
+
+		__this_cpu_write(current_kprobe, p);
+		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+		if (!p->pre_handler || !p->pre_handler(p, regs))
+			__skip_singlestep(p, regs, kcb);
+		/*
+		 * If pre_handler returns !0, it sets regs->ip and
+		 * resets current kprobe.
+		 */
+	}
+end:
+	local_irq_restore(flags);
+}
+
+int __kprobes arch_prepare_kprobe_ftrace(struct kprobe *p)
+{
+	p->ainsn.insn = NULL;
+	p->ainsn.boostable = -1;
+	return 0;
+}
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 57916c0..18114bf 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -541,23 +541,6 @@ reenter_kprobe(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb
 	return 1;
 }
 
-#ifdef KPROBES_CAN_USE_FTRACE
-static void __kprobes skip_singlestep(struct kprobe *p, struct pt_regs *regs,
-				      struct kprobe_ctlblk *kcb)
-{
-	/*
-	 * Emulate singlestep (and also recover regs->ip)
-	 * as if there is a 5byte nop
-	 */
-	regs->ip = (unsigned long)p->addr + MCOUNT_INSN_SIZE;
-	if (unlikely(p->post_handler)) {
-		kcb->kprobe_status = KPROBE_HIT_SSDONE;
-		p->post_handler(p, regs, 0);
-	}
-	__this_cpu_write(current_kprobe, NULL);
-}
-#endif
-
 /*
  * Interrupts are disabled on entry as trap3 is an interrupt gate and they
  * remain disabled throughout this function.
@@ -616,13 +599,8 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 	} else if (kprobe_running()) {
 		p = __this_cpu_read(current_kprobe);
 		if (p->break_handler && p->break_handler(p, regs)) {
-#ifdef KPROBES_CAN_USE_FTRACE
-			if (kprobe_ftrace(p)) {
-				skip_singlestep(p, regs, kcb);
-				return 1;
-			}
-#endif
-			setup_singlestep(p, regs, kcb, 0);
+			if (!skip_singlestep(p, regs, kcb))
+				setup_singlestep(p, regs, kcb, 0);
 			return 1;
 		}
 	} /* else: not a kprobe fault; let the kernel handle it */
@@ -1075,50 +1053,6 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	return 0;
 }
 
-#ifdef KPROBES_CAN_USE_FTRACE
-/* Ftrace callback handler for kprobes */
-void __kprobes kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
-				     struct ftrace_ops *ops, struct pt_regs *regs)
-{
-	struct kprobe *p;
-	struct kprobe_ctlblk *kcb;
-	unsigned long flags;
-
-	/* Disable irq for emulating a breakpoint and avoiding preempt */
-	local_irq_save(flags);
-
-	p = get_kprobe((kprobe_opcode_t *)ip);
-	if (unlikely(!p) || kprobe_disabled(p))
-		goto end;
-
-	kcb = get_kprobe_ctlblk();
-	if (kprobe_running()) {
-		kprobes_inc_nmissed_count(p);
-	} else {
-		/* Kprobe handler expects regs->ip = ip + 1 as breakpoint hit */
-		regs->ip = ip + sizeof(kprobe_opcode_t);
-
-		__this_cpu_write(current_kprobe, p);
-		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
-		if (!p->pre_handler || !p->pre_handler(p, regs))
-			skip_singlestep(p, regs, kcb);
-		/*
-		 * If pre_handler returns !0, it sets regs->ip and
-		 * resets current kprobe.
-		 */
-	}
-end:
-	local_irq_restore(flags);
-}
-
-int __kprobes arch_prepare_kprobe_ftrace(struct kprobe *p)
-{
-	p->ainsn.insn = NULL;
-	p->ainsn.boostable = -1;
-	return 0;
-}
-#endif
-
 int __init arch_init_kprobes(void)
 {
 	return arch_init_optprobes();
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 23755ba..4b6ef4d 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -49,16 +49,6 @@
 #define KPROBE_REENTER		0x00000004
 #define KPROBE_HIT_SSDONE	0x00000008
 
-/*
- * If function tracer is enabled and the arch supports full
- * passing of pt_regs to function tracing, then kprobes can
- * optimize on top of function tracing.
- */
-#if defined(CONFIG_FUNCTION_TRACER) && defined(ARCH_SUPPORTS_FTRACE_SAVE_REGS) \
-	&& defined(ARCH_SUPPORTS_KPROBES_ON_FTRACE)
-# define KPROBES_CAN_USE_FTRACE
-#endif
-
 /* Attach to insert probes on any functions which should be ignored*/
 #define __kprobes	__attribute__((__section__(".kprobes.text")))
 
@@ -316,7 +306,7 @@ extern int proc_kprobes_optimization_handler(struct ctl_table *table,
 #endif
 
 #endif /* CONFIG_OPTPROBES */
-#ifdef KPROBES_CAN_USE_FTRACE
+#ifdef CONFIG_KPROBES_ON_FTRACE
 extern void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 				  struct ftrace_ops *ops, struct pt_regs *regs);
 extern int arch_prepare_kprobe_ftrace(struct kprobe *p);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 098f396..f423c3e 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -919,7 +919,7 @@ static __kprobes struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 }
 #endif /* CONFIG_OPTPROBES */
 
-#ifdef KPROBES_CAN_USE_FTRACE
+#ifdef CONFIG_KPROBES_ON_FTRACE
 static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
 	.func = kprobe_ftrace_handler,
 	.flags = FTRACE_OPS_FL_SAVE_REGS,
@@ -964,7 +964,7 @@ static void __kprobes disarm_kprobe_ftrace(struct kprobe *p)
 			   (unsigned long)p->addr, 1, 0);
 	WARN(ret < 0, "Failed to disarm kprobe-ftrace at %p (%d)\n", p->addr, ret);
 }
-#else	/* !KPROBES_CAN_USE_FTRACE */
+#else	/* !CONFIG_KPROBES_ON_FTRACE */
 #define prepare_kprobe(p)	arch_prepare_kprobe(p)
 #define arm_kprobe_ftrace(p)	do {} while (0)
 #define disarm_kprobe_ftrace(p)	do {} while (0)
@@ -1414,12 +1414,12 @@ static __kprobes int check_kprobe_address_safe(struct kprobe *p,
 	 */
 	ftrace_addr = ftrace_location((unsigned long)p->addr);
 	if (ftrace_addr) {
-#ifdef KPROBES_CAN_USE_FTRACE
+#ifdef CONFIG_KPROBES_ON_FTRACE
 		/* Given address is not on the instruction boundary */
 		if ((unsigned long)p->addr != ftrace_addr)
 			return -EILSEQ;
 		p->flags |= KPROBE_FLAG_FTRACE;
-#else	/* !KPROBES_CAN_USE_FTRACE */
+#else	/* !CONFIG_KPROBES_ON_FTRACE */
 		return -EINVAL;
 #endif
 	}

