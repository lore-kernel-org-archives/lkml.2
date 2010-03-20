Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab0CTO0h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:26:37 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:37951 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab0CTO0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:26:31 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Sat, 20 Mar 2010 19:56:28 +0530
Message-Id: <20100320142628.11427.53354.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v1 8/10] X86 details for uprobes.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X86 support for Uprobes

This patch provides x86 specific details for uprobes.
This includes interrupt notifier for uprobes, enabling/disabling
singlestep.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---

 arch/x86/Kconfig          |    1 +
 arch/x86/kernel/Makefile  |    1 +
 arch/x86/kernel/uprobes.c |   87 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/uprobes.c


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 851cedc..a860a9b 100644
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
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
new file mode 100644
index 0000000..1acce22
--- /dev/null
+++ b/arch/x86/kernel/uprobes.c
@@ -0,0 +1,87 @@
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
+
+void uprobe_enable_interrupts(void)
+{
+	native_irq_enable();
+}
+
+void uprobe_disable_interrupts(void)
+{
+	native_irq_disable();
+}
