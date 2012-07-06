Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030407Ab2GFMAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 08:00:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47279 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030390Ab2GFMAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 08:00:49 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/6] x86: Kernel entry/exit hooks for RCU
Date: Fri,  6 Jul 2012 14:00:17 +0200
Message-Id: <1341576018-10721-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1341576018-10721-1-git-send-email-fweisbec@gmail.com>
References: <1341576018-10721-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hook on kernel boundaries from syscall/exception entry/exit
and irq exit to implement RCU userspace extended quiescent
state.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/rcu.h |    7 +++++++
 arch/x86/kernel/entry_64.S |   25 +++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/rcu.h

diff --git a/arch/x86/include/asm/rcu.h b/arch/x86/include/asm/rcu.h
new file mode 100644
index 0000000..8ad018a
--- /dev/null
+++ b/arch/x86/include/asm/rcu.h
@@ -0,0 +1,7 @@
+#ifdef CONFIG_RCU_USER_QS
+# define ENTER_KERNEL callq rcu_user_exit
+# define EXIT_KERNEL callq rcu_user_enter
+#else
+# define ENTER_KERNEL
+# define EXIT_KERNEL
+#endif
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e97d42d..677a808 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -56,6 +56,7 @@
 #include <asm/ftrace.h>
 #include <asm/percpu.h>
 #include <asm/asm.h>
+#include <asm/rcu.h>
 #include <linux/err.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
@@ -517,6 +518,22 @@ GLOBAL(system_call_after_swapgs)
 	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
+#ifdef CONFIG_RCU_USER_QS
+	ENTER_KERNEL
+	/*
+	 * Syscall args/scratch reg might have been
+	 * clobbered by rcu_user_exit() call. Restore
+	 * them.
+	 */
+	movq RDI-ARGOFFSET(%rsp), %rdi
+	movq RSI-ARGOFFSET(%rsp), %rsi
+	movq RDX-ARGOFFSET(%rsp), %rdx
+	movq R8-ARGOFFSET(%rsp), %r8
+	movq R9-ARGOFFSET(%rsp), %r9
+	movq ORIG_RAX-ARGOFFSET(%rsp), %rax
+	movq R10-ARGOFFSET(%rsp), %r10
+	movq R11-ARGOFFSET(%rsp), %r11
+#endif
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz tracesys
 system_call_fastpath:
@@ -544,6 +561,7 @@ sysret_check:
 	movl TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET),%edx
 	andl %edi,%edx
 	jnz  sysret_careful
+	EXIT_KERNEL
 	CFI_REMEMBER_STATE
 	/*
 	 * sysretq will re-enable interrupts:
@@ -925,6 +943,7 @@ retint_swapgs:		/* return to user-space */
 	 */
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	TRACE_IRQS_IRETQ
+	EXIT_KERNEL
 	SWAPGS
 	jmp restore_args
 
@@ -1101,6 +1120,7 @@ ENTRY(\sym)
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call error_entry
+	ENTER_KERNEL
 	DEFAULT_FRAME 0
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
@@ -1119,6 +1139,7 @@ ENTRY(\sym)
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
 	TRACE_IRQS_OFF
+	ENTER_KERNEL
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
 	call \do_sym
@@ -1137,6 +1158,7 @@ ENTRY(\sym)
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
 	TRACE_IRQS_OFF_DEBUG
+	ENTER_KERNEL
 	movq %rsp,%rdi		/* pt_regs pointer */
 	xorl %esi,%esi		/* no error code */
 	subq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)
@@ -1154,6 +1176,7 @@ ENTRY(\sym)
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call error_entry
+	ENTER_KERNEL
 	DEFAULT_FRAME 0
 	movq %rsp,%rdi			/* pt_regs pointer */
 	movq ORIG_RAX(%rsp),%rsi	/* get error code */
@@ -1172,6 +1195,7 @@ ENTRY(\sym)
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 	call save_paranoid
+	ENTER_KERNEL
 	DEFAULT_FRAME 0
 	TRACE_IRQS_OFF
 	movq %rsp,%rdi			/* pt_regs pointer */
@@ -1437,6 +1461,7 @@ ENTRY(paranoid_exit)
 	testl $3,CS(%rsp)
 	jnz   paranoid_userspace
 paranoid_swapgs:
+	EXIT_KERNEL
 	TRACE_IRQS_IRETQ 0
 	SWAPGS_UNSAFE_STACK
 	RESTORE_ALL 8
-- 
1.7.5.4

