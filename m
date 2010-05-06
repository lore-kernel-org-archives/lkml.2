Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517Ab0EFSDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:03:11 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59854 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759499Ab0EFSDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:03:01 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 06 May 2010 23:32:56 +0530
Message-Id: <20100506180256.28877.30584.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v3 6/10] x86 support for Uprobes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobes_x86.patch

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

X86 support for Uprobes

This patch provides x86 specific details for uprobes.
This includes interrupt notifier for uprobes, enabling/disabling
singlestep.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---

 arch/x86/Kconfig          |    1 +
 arch/x86/kernel/Makefile  |    1 +
 arch/x86/kernel/signal.c  |   12 +++++++
 arch/x86/kernel/uprobes.c |   77 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/uprobes.c


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7dce185..57be1fa 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -54,6 +54,7 @@ config X86
 	select HAVE_KERNEL_LZO
 	select HAVE_HW_BREAKPOINT
 	select HAVE_USER_BKPT
+	select HAVE_UPROBES
 	select PERF_EVENTS
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 98c74b4..bfa48f0 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -118,6 +118,7 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 
 obj-$(CONFIG_USER_BKPT)			+= user_bkpt.o
+obj-$(CONFIG_UPROBES)			+= uprobes.o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 851bc8d..dde9a42 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -850,7 +850,19 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 
 	if (thread_info_flags & _TIF_UPROBE) {
 		clear_thread_flag(TIF_UPROBE);
+#ifdef CONFIG_X86_32
+		/*
+		 * On x86_32, do_notify_resume() gets called with
+		 * interrupts disabled. Hence enable interrupts if they
+		 * are still disabled.
+		 */
+		native_irq_enable();
+#endif
 		uprobe_notify_resume(regs);
+
+#ifdef CONFIG_X86_32
+		native_irq_disable();
+#endif
 	}
 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
new file mode 100644
index 0000000..5643b96
--- /dev/null
+++ b/arch/x86/kernel/uprobes.c
@@ -0,0 +1,77 @@
+/*
+ *  Userspace Probes (UProbes)
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
+ * Copyright (C) IBM Corporation, 2010
+ * Authors:
+ *	Srikar Dronamraju
+ *	Ananth N Mavinakayanahalli
+ */
+
+#include <linux/sched.h>
+#include <linux/kdebug.h>
+#include <linux/uprobes.h>
+
+/*
+ * Wrapper routine for handling exceptions.
+ */
+int uprobes_exception_notify(struct notifier_block *self,
+				       unsigned long val, void *data)
+{
+	struct die_args *args = data;
+	struct pt_regs *regs = args->regs;
+	int ret = NOTIFY_DONE;
+
+	/* We are only interested in userspace traps */
+	if (regs && !user_mode_vm(regs))
+		return NOTIFY_DONE;
+
+	switch (val) {
+	case DIE_INT3:
+		/* Run your handler here */
+		if (uprobe_bkpt_notifier(regs))
+			ret = NOTIFY_STOP;
+		break;
+	case DIE_DEBUG:
+		if (uprobe_post_notifier(regs))
+			ret = NOTIFY_STOP;
+	default:
+		break;
+	}
+	return ret;
+}
+
+void arch_uprobe_enable_sstep(struct pt_regs *regs)
+{
+	/*
+	 * Enable single-stepping by
+	 * - Set TF on stack
+	 * - Set TIF_SINGLESTEP: Guarantees that TF is set when
+	 *	returning to user mode.
+	 *  - Indicate that TF is set by us.
+	 */
+	regs->flags |= X86_EFLAGS_TF;
+	set_thread_flag(TIF_SINGLESTEP);
+	set_thread_flag(TIF_FORCED_TF);
+}
+
+void arch_uprobe_disable_sstep(struct pt_regs *regs)
+{
+		/* Disable single-stepping by clearing what we set */
+		clear_thread_flag(TIF_SINGLESTEP);
+		clear_thread_flag(TIF_FORCED_TF);
+		regs->flags &= ~X86_EFLAGS_TF;
+}
