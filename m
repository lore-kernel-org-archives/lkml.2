Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094Ab0EAOjH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:39:07 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:64375 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997Ab0EAOib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:38:31 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Nathan Lynch <ntl@pobox.com>,
       linuxppc-dev@ozlabs.org
Subject: [PATCH v21 085/100] powerpc: provide APIs for validating and updating DABR
Date: Sat,  1 May 2010 10:16:07 -0400
Message-Id: <1272723382-19470-86-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Lynch <ntl@pobox.com>

A checkpointed task image may specify a value for the DABR (Data
Access Breakpoint Register).  The restart code needs to validate this
value before making any changes to the current task.

ptrace_set_debugreg encapsulates the bounds checking and platform
dependencies of programming the DABR.  Split this into "validate"
(debugreg_valid) and "update" (debugreg_update) functions, and make
them available for use outside of the ptrace code.

Also ptrace_set_debugreg has extern linkage, but no users outside of
ptrace.c.  Make it static.

Cc: linuxppc-dev@ozlabs.org
Signed-off-by: Nathan Lynch <ntl@pobox.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
---
 arch/powerpc/include/asm/ptrace.h |    7 +++
 arch/powerpc/kernel/ptrace.c      |   83 ++++++++++++++++++++++++++-----------
 2 files changed, 66 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/include/asm/ptrace.h b/arch/powerpc/include/asm/ptrace.h
index 9e2d84c..a88d711 100644
--- a/arch/powerpc/include/asm/ptrace.h
+++ b/arch/powerpc/include/asm/ptrace.h
@@ -87,6 +87,8 @@ struct pt_regs {
 
 #ifndef __ASSEMBLY__
 
+#include <linux/types.h>
+
 #define instruction_pointer(regs) ((regs)->nip)
 #define user_stack_pointer(regs) ((regs)->gpr[1])
 #define regs_return_value(regs) ((regs)->gpr[3])
@@ -141,6 +143,11 @@ do {									      \
 #define arch_has_block_step()	(!cpu_has_feature(CPU_FTR_601))
 #define ARCH_HAS_USER_SINGLE_STEP_INFO
 
+/* for reprogramming DABR/DAC during restart of a checkpointed task */
+extern bool debugreg_valid(unsigned long val, unsigned int index);
+extern void debugreg_update(struct task_struct *task, unsigned long val,
+			    unsigned int index);
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index ed2cfe1..972e6a1 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -763,19 +763,23 @@ void user_disable_single_step(struct task_struct *task)
 	clear_tsk_thread_flag(task, TIF_SINGLESTEP);
 }
 
-int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
-			       unsigned long data)
+/**
+ * debugreg_valid() - validate the value to be written to a debug register
+ * @val:	The prospective contents of the register.
+ * @index:	Must be zero.
+ *
+ * Returns true if @val is an acceptable value for the register indicated by
+ * @index, false otherwise.
+ */
+bool debugreg_valid(unsigned long val, unsigned int index)
 {
-	/* For ppc64 we support one DABR and no IABR's at the moment (ppc64).
-	 *  For embedded processors we support one DAC and no IAC's at the
-	 *  moment.
-	 */
-	if (addr > 0)
-		return -EINVAL;
+	/* We support only one debug register for now */
+	if (index != 0)
+		return false;
 
 	/* The bottom 3 bits in dabr are flags */
-	if ((data & ~0x7UL) >= TASK_SIZE)
-		return -EIO;
+	if ((val & ~0x7UL) >= TASK_SIZE)
+		return false;
 
 #ifndef CONFIG_PPC_ADV_DEBUG_REGS
 	/* For processors using DABR (i.e. 970), the bottom 3 bits are flags.
@@ -791,19 +795,38 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 	 */
 
 	/* Ensure breakpoint translation bit is set */
-	if (data && !(data & DABR_TRANSLATION))
-		return -EIO;
-
-	/* Move contents to the DABR register */
-	task->thread.dabr = data;
-#else /* CONFIG_PPC_ADV_DEBUG_REGS */
+	if (val && !(val & DABR_TRANSLATION))
+		return false;
+#else
 	/* As described above, it was assumed 3 bits were passed with the data
 	 *  address, but we will assume only the mode bits will be passed
 	 *  as to not cause alignment restrictions for DAC-based processors.
 	 */
 
+	/* Read or Write bits must be set */
+	if (!(val & 0x3UL))
+		return -EINVAL;
+#endif
+	return true;
+}
+
+/**
+ * debugreg_update() - update a debug register associated with a task
+ * @task:	The task whose register state is to be modified.
+ * @val:	The value to be written to the debug register.
+ * @index:	Specifies the debug register.  Currently unused.
+ *
+ * Set a task's DABR/DAC to @val, which should be validated with
+ * debugreg_valid() beforehand.
+ */
+void debugreg_update(struct task_struct *task, unsigned long val,
+		     unsigned int index)
+{
+#ifndef CONFIG_PPC_ADV_DEBUG_REGS
+	task->thread.dabr = val;
+#else
 	/* DAC's hold the whole address without any mode flags */
-	task->thread.dac1 = data & ~0x3UL;
+	task->thread.dabr = val & ~0x3UL;
 
 	if (task->thread.dac1 == 0) {
 		dbcr_dac(task) &= ~(DBCR_DAC1R | DBCR_DAC1W);
@@ -812,13 +835,8 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 			task->thread.regs->msr &= ~MSR_DE;
 			task->thread.dbcr0 &= ~DBCR0_IDM;
 		}
-		return 0;
 	}
 
-	/* Read or Write bits must be set */
-
-	if (!(data & 0x3UL))
-		return -EINVAL;
 
 	/* Set the Internal Debugging flag (IDM bit 1) for the DBCR0
 	   register */
@@ -827,12 +845,29 @@ int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
 	/* Check for write and read flags and set DBCR0
 	   accordingly */
 	dbcr_dac(task) &= ~(DBCR_DAC1R|DBCR_DAC1W);
-	if (data & 0x1UL)
+	if (val & 0x1UL)
 		dbcr_dac(task) |= DBCR_DAC1R;
-	if (data & 0x2UL)
+	if (val & 0x2UL)
 		dbcr_dac(task) |= DBCR_DAC1W;
 	task->thread.regs->msr |= MSR_DE;
 #endif /* CONFIG_PPC_ADV_DEBUG_REGS */
+}
+
+static int ptrace_set_debugreg(struct task_struct *task, unsigned long addr,
+			       unsigned long data)
+{
+	/* For ppc64 we support one DABR and no IABR's at the moment (ppc64).
+	 * For embedded processors we support one DAC and no IAC's at the
+	 * moment.
+	 */
+	if (addr > 0)
+		return -EINVAL;
+
+	if (!debugreg_valid(data, 0))
+		return -EIO;
+
+	debugreg_update(task, data, 0);
+
 	return 0;
 }
 
-- 
1.6.3.3

