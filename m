Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab2KLLtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:49:52 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:57531 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2KLLts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:49:48 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 32/55] ARC: [optim] Cache "current" in Register r25
Date: Mon, 12 Nov 2012 17:18:50 +0530
Message-ID: <1352720953-24321-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig                 |    7 ++++++
 arch/arc/Makefile                |    9 +++++++
 arch/arc/include/asm/Kbuild      |    1 -
 arch/arc/include/asm/current.h   |   32 +++++++++++++++++++++++++++
 arch/arc/include/asm/entry.h     |   45 ++++++++++++++++++++++++++++++++++++++
 arch/arc/include/asm/processor.h |    3 ++
 arch/arc/kernel/asm-offsets.c    |    3 ++
 arch/arc/kernel/ctx_sw.c         |    7 ++++++
 arch/arc/kernel/entry.S          |   14 +++++++++++
 9 files changed, 120 insertions(+), 1 deletions(-)
 create mode 100644 arch/arc/include/asm/current.h

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index f3aacfc..71e55c0 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -277,6 +277,13 @@ config ARC_PLAT_SDRAM_SIZE
 
 endmenu # "Platform Board Configuration"
 
+config ARC_CURR_IN_REG
+	bool "Dedicate Register r25 for current_task pointer"
+	default y
+	help
+	  This reserved Register R25 to point to Current Task in
+	  kernel mode. This saves memory access for each such access
+
 config ARC_STACK_NONEXEC
 	bool "Make stack non-executable"
 	default n
diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index 4d52a3b..eeb64dd 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -20,6 +20,15 @@ export PLATFORM
 cflags-y	+= -Iarch/arc/plat-$(PLATFORM)/include
 cflags-y	+= -mA7 -fno-common -pipe -fno-builtin -D__linux__
 
+ifdef CONFIG_ARC_CURR_IN_REG
+# For a global register defintion, make sure it gets passed to every file
+# We had a customer reported bug where some code built in kernel was NOT using
+# any kernel headers, and missing the r25 global register
+# Can't do unconditionally (like above) because of recursive include issues
+# due to <linux/thread_info.h>
+LINUXINCLUDE	+=  -include ${src}/arch/arc/include/asm/current.h
+endif
+
 atleast_gcc44 :=  $(call cc-ifversion, -gt, 0402, y)
 cflags-$(atleast_gcc44)			+= -fsection-anchors
 
diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index 148dfcf..a246390 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -11,7 +11,6 @@ generic-y += bugs.h
 generic-y += bitsperlong.h
 generic-y += clkdev.h
 generic-y += cputime.h
-generic-y += current.h
 generic-y += device.h
 generic-y += div64.h
 generic-y += emergency-restart.h
diff --git a/arch/arc/include/asm/current.h b/arch/arc/include/asm/current.h
new file mode 100644
index 0000000..87b9185
--- /dev/null
+++ b/arch/arc/include/asm/current.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Vineetg: May 16th, 2008
+ *  - Current macro is now implemented as "global register" r25
+ */
+
+#ifndef _ASM_ARC_CURRENT_H
+#define _ASM_ARC_CURRENT_H
+
+#ifdef __KERNEL__
+
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_ARC_CURR_IN_REG
+
+register struct task_struct *curr_arc asm("r25");
+#define current (curr_arc)
+
+#else
+#include <asm-generic/current.h>
+#endif /* ! CONFIG_ARC_CURR_IN_REG */
+
+#endif /* ! __ASSEMBLY__ */
+
+#endif	/* __KERNEL__ */
+
+#endif /* _ASM_ARC_CURRENT_H */
diff --git a/arch/arc/include/asm/entry.h b/arch/arc/include/asm/entry.h
index 3e0a9f4..6113e1a 100644
--- a/arch/arc/include/asm/entry.h
+++ b/arch/arc/include/asm/entry.h
@@ -13,6 +13,8 @@
  *   was being "CLEARED" rather then "SET". Actually "SET" clears ZOL context
  *
  * Vineetg: May 5th 2008
+ *  -Modified CALLEE_REG save/restore macros to handle the fact that
+ *      r25 contains the kernel current task ptr
  *  - Defined Stack Switching Macro to be reused in all intr/excp hdlrs
  *  - Shaved off 11 instructions from RESTORE_ALL_INT1 by using the
  *      address Write back load ld.ab instead of seperate ld/add instn
@@ -28,6 +30,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/arcregs.h>
 #include <asm/ptrace.h>
+#include <asm/processor.h>	/* For VMALLOC_START */
 #include <asm/thread_info.h>	/* For THREAD_SIZE */
 
 /* Note on the LD/ST addr modes with addr reg wback
@@ -106,7 +109,14 @@
 	st.a    r22, [sp, -4]
 	st.a    r23, [sp, -4]
 	st.a    r24, [sp, -4]
+
+#ifdef CONFIG_ARC_CURR_IN_REG
+	; Retrieve orig r25 and save it on stack
+	ld      r12, [r25, TASK_THREAD + THREAD_USER_R25]
+	st.a    r12, [sp, -4]
+#else
 	st.a    r25, [sp, -4]
+#endif
 
 	/* move up by 1 word to "create" callee_regs->"stack_place_holder" */
 	sub sp, sp, 4
@@ -131,8 +141,12 @@
 	st.a    r22, [sp, -4]
 	st.a    r23, [sp, -4]
 	st.a    r24, [sp, -4]
+#ifdef CONFIG_ARC_CURR_IN_REG
+	sub     sp, sp, 8
+#else
 	st.a    r25, [sp, -4]
 	sub     sp, sp, 4
+#endif
 .endm
 
 /*--------------------------------------------------------------
@@ -148,8 +162,14 @@
  *-------------------------------------------------------------*/
 .macro RESTORE_CALLEE_SAVED_KERNEL
 
+
+#ifdef CONFIG_ARC_CURR_IN_REG
+	add     sp, sp, 8  /* skip callee_reg gutter and user r25 placeholder */
+#else
 	add     sp, sp, 4   /* skip "callee_regs->stack_place_holder" */
 	ld.ab   r25, [sp, 4]
+#endif
+
 	ld.ab   r24, [sp, 4]
 	ld.ab   r23, [sp, 4]
 	ld.ab   r22, [sp, 4]
@@ -200,6 +220,7 @@
  *
  * Entry   : r9 contains pre-IRQ/exception/trap status32
  * Exit    : SP is set to kernel mode stack pointer
+ *           If CURR_IN_REG, r25 set to "current" task pointer
  * Clobbers: r9
  *-------------------------------------------------------------*/
 
@@ -224,6 +245,16 @@
 
 	GET_CURR_TASK_ON_CPU   r9
 
+#ifdef CONFIG_ARC_CURR_IN_REG
+
+	/* If current task pointer cached in r25, time to
+	 *  -safekeep USER r25 in task->thread_struct->user_r25
+	 *  -load r25 with current task ptr
+	 */
+	st.as	r25, [r9, (TASK_THREAD + THREAD_USER_R25)/4]
+	mov	r25, r9
+#endif
+
 	/* With current tsk in r9, get it's kernel mode stack base */
 	GET_TSK_STACK_BASE  r9, r9
 
@@ -479,17 +510,31 @@
 
 .macro  SET_CURR_TASK_ON_CPU    tsk, tmp
 	st  \tsk, [@_current_task]
+#ifdef CONFIG_ARC_CURR_IN_REG
+	mov r25, \tsk
+#endif
 .endm
 
 /* ------------------------------------------------------------------
  * Get the ptr to some field of Current Task at @off in task struct
+ *  -Uses r25 for Current task ptr if that is enabled
  */
 
+#ifdef CONFIG_ARC_CURR_IN_REG
+
+.macro GET_CURR_TASK_FIELD_PTR  off,  reg
+	add \reg, r25, \off
+.endm
+
+#else
+
 .macro GET_CURR_TASK_FIELD_PTR  off,  reg
 	GET_CURR_TASK_ON_CPU  \reg
 	add \reg, \reg, \off
 .endm
 
+#endif	/* CONFIG_ARC_CURR_IN_REG */
+
 #endif  /* __ASSEMBLY__ */
 
 #endif  /* __ASM_ARC_ENTRY_H */
diff --git a/arch/arc/include/asm/processor.h b/arch/arc/include/asm/processor.h
index 38ea5fb..2fe9f22 100644
--- a/arch/arc/include/asm/processor.h
+++ b/arch/arc/include/asm/processor.h
@@ -29,6 +29,9 @@ struct thread_struct {
 	unsigned long callee_reg;	/* pointer to callee regs */
 	unsigned long fault_address;	/* dbls as brkpt holder as well */
 	unsigned long cause_code;	/* Exception Cause Code (ECR) */
+#ifdef CONFIG_ARC_CURR_IN_REG
+	unsigned long user_r25;
+#endif
 #ifdef CONFIG_ARC_FPU_SAVE_RESTORE
 	struct arc_fpu fpu;
 #endif
diff --git a/arch/arc/kernel/asm-offsets.c b/arch/arc/kernel/asm-offsets.c
index 7f3f611..b0e7254 100644
--- a/arch/arc/kernel/asm-offsets.c
+++ b/arch/arc/kernel/asm-offsets.c
@@ -23,6 +23,9 @@ int main(void)
 
 	DEFINE(THREAD_KSP, offsetof(struct thread_struct, ksp));
 	DEFINE(THREAD_CALLEE_REG, offsetof(struct thread_struct, callee_reg));
+#ifdef CONFIG_ARC_CURR_IN_REG
+	DEFINE(THREAD_USER_R25, offsetof(struct thread_struct, user_r25));
+#endif
 	DEFINE(THREAD_FAULT_ADDR,
 	       offsetof(struct thread_struct, fault_address));
 
diff --git a/arch/arc/kernel/ctx_sw.c b/arch/arc/kernel/ctx_sw.c
index 647e37a..fbf739c 100644
--- a/arch/arc/kernel/ctx_sw.c
+++ b/arch/arc/kernel/ctx_sw.c
@@ -24,6 +24,9 @@ __switch_to(struct task_struct *prev_task, struct task_struct *next_task)
 	unsigned int prev = (unsigned int)prev_task;
 	unsigned int next = (unsigned int)next_task;
 	int num_words_to_skip = 1;
+#ifdef CONFIG_ARC_CURR_IN_REG
+	num_words_to_skip++;
+#endif
 
 	__asm__ __volatile__(
 		/* FP/BLINK save generated by gcc (standard function prologue */
@@ -39,7 +42,9 @@ __switch_to(struct task_struct *prev_task, struct task_struct *next_task)
 		"st.a    r22, [sp, -4]   \n\t"
 		"st.a    r23, [sp, -4]   \n\t"
 		"st.a    r24, [sp, -4]   \n\t"
+#ifndef CONFIG_ARC_CURR_IN_REG
 		"st.a    r25, [sp, -4]   \n\t"
+#endif
 		"sub     sp, sp, %4      \n\t"	/* create gutter at top */
 
 		/* set ksp of outgoing task in tsk->thread.ksp */
@@ -62,7 +67,9 @@ __switch_to(struct task_struct *prev_task, struct task_struct *next_task)
 
 		"add    sp, sp, %4     \n\t"	/* skip gutter at top */
 
+#ifndef CONFIG_ARC_CURR_IN_REG
 		"ld.ab   r25, [sp, 4]   \n\t"
+#endif
 		"ld.ab   r24, [sp, 4]   \n\t"
 		"ld.ab   r23, [sp, 4]   \n\t"
 		"ld.ab   r22, [sp, 4]   \n\t"
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index deb2652..35406da 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -36,6 +36,9 @@
  *   was being "CLEARED" rather then "SET". Since it is Loop INHIBIT Bit,
  *   setting it and not clearing it clears ZOL context
  *
+ * Vineetg: May 16th, 2008
+ *  - r25 now contains the Current Task when in kernel
+ *
  * Vineetg: Dec 22, 2007
  *    Minor Surgery of Low Level ISR to make it SMP safe
  *    - MMU_SCRATCH0 Reg used for freeing up r9 in Level 1 ISR
@@ -540,6 +543,17 @@ restore_regs :
 	; XXX can this be optimised out
 	IRQ_DISABLE_SAVE    r9, r10	;@r10 has prisitine (pre-disable) copy
 
+#ifdef CONFIG_ARC_CURR_IN_REG
+	; Restore User R25
+	; Earlier this used to be only for returning to user mode
+	; However with 2 levels of IRQ this can also happen even if
+	; in kernel mode
+	ld r9, [sp, PT_sp]
+	brhs r9, VMALLOC_START, 8f
+	RESTORE_USER_R25
+8:
+#endif
+
 	; Restore REG File. In case multiple Events outstanding,
 	; use the same priorty as rtie: EXCPN, L2 IRQ, L1 IRQ, None
 	; Note that we use realtime STATUS32 (not pt_regs->status32) to
-- 
1.7.4.1

