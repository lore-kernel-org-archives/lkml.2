Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0GLKlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 06:41:50 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:47765 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab0GLKlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 06:41:45 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 12 Jul 2010 16:03:19 +0530
Message-Id: <20100712103319.27491.33530.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv9 2.6.35-rc4-tip 6/13]  uprobes: X86 support for Uprobes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


uprobes: X86 support for Uprobes

Changelog from V5: Using local_irq_enable() instead of
    native_irq_enable and no more disabling irqs as suggested by Oleg
    Nesterov.

Provides x86 specific details for uprobes.
This includes interrupt notifier for uprobes, enabling/disabling
singlestep.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---

 arch/x86/kernel/signal.c  |   13 +++++++++++
 arch/x86/kernel/uprobes.c |   52 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 0 deletions(-)


diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 4fd173c..3657563 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -848,6 +848,19 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
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
index 1eb85bb..9456328 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -26,6 +26,7 @@
 #include <linux/ptrace.h>
 #include <linux/uprobes.h>
 
+#include <linux/kdebug.h>
 #include <asm/insn.h>
 
 #ifdef CONFIG_X86_32
@@ -545,3 +546,54 @@ struct user_bkpt_arch_info user_bkpt_arch_info = {
 	.analyze_insn = analyze_insn,
 	.post_xol = post_xol,
 };
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
+	/* Disable single-stepping by clearing what we set */
+	clear_thread_flag(TIF_SINGLESTEP);
+	clear_thread_flag(TIF_FORCED_TF);
+	regs->flags &= ~X86_EFLAGS_TF;
+}
