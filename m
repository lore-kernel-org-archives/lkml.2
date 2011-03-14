Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab1CNNml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 09:42:41 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:36189 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab1CNNmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 09:42:39 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 14 Mar 2011 19:06:54 +0530
Message-Id: <20110314133654.27435.10282.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v2 2.6.38-rc8-tip 15/20] 15: x86: uprobes exception notifier for x86.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Provides a uprobes exception notifier for x86.  This uprobes_exception
notifier gets called in interrupt context and routes int3 and singlestep
exception when a uprobed process encounters a INT3 or a singlestep exception.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/x86/include/asm/uprobes.h |    3 +++
 arch/x86/kernel/signal.c       |   14 ++++++++++++++
 arch/x86/kernel/uprobes.c      |   29 +++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
index 0e1b23f..f49cf49 100644
--- a/arch/x86/include/asm/uprobes.h
+++ b/arch/x86/include/asm/uprobes.h
@@ -22,6 +22,7 @@
  *	Srikar Dronamraju
  *	Jim Keniston
  */
+#include <linux/notifier.h>
 
 typedef u8 uprobe_opcode_t;
 #define MAX_UINSN_BYTES 16
@@ -52,4 +53,6 @@ extern int pre_xol(struct uprobe *uprobe, struct pt_regs *regs);
 extern int post_xol(struct uprobe *uprobe, struct pt_regs *regs);
 extern void arch_uprobe_enable_sstep(struct pt_regs *regs);
 extern void arch_uprobe_disable_sstep(struct pt_regs *regs);
+extern int uprobes_exception_notify(struct notifier_block *self,
+				       unsigned long val, void *data);
 #endif	/* _ASM_UPROBES_H */
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 4fd173c..0b06b94 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -20,6 +20,7 @@
 #include <linux/personality.h>
 #include <linux/uaccess.h>
 #include <linux/user-return-notifier.h>
+#include <linux/uprobes.h>
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
@@ -848,6 +849,19 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
 
+	if (thread_info_flags & _TIF_UPROBE) {
+		clear_thread_flag(TIF_UPROBE);
+#ifdef CONFIG_X86_32
+		/*
+		 * On x86_32, do_notify_resume() gets called with
+		 * interrupts disabled. Hence enable interrupts if they
+		 * are still disabled.
+		 */
+		local_irq_enable();
+#endif
+		uprobe_notify_resume(regs);
+	}
+
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 5667e90..b55469c 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -569,3 +569,32 @@ void arch_uprobe_disable_sstep(struct pt_regs *regs)
 	clear_thread_flag(TIF_FORCED_TF);
 	regs->flags &= ~X86_EFLAGS_TF;
 }
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
