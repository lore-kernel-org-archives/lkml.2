Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab1D0PXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:23:40 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:36043 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759326Ab1D0PXh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 27 Apr 2011 11:23:37 -0400
Message-Id: <4DB85162020000780003E6AE@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 27 Apr 2011 16:24:50 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] x86: unify rwsem assembly implementation
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/um/sys-i386/Makefile   |    2 
 arch/um/sys-x86_64/Makefile |    2 
 arch/x86/lib/Makefile       |    3 
 arch/x86/lib/rwsem.S        |  136 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/lib/rwsem_64.S     |   93 ------------------------------
 arch/x86/lib/semaphore_32.S |   80 -------------------------
 6 files changed, 139 insertions(+), 177 deletions(-)

--- 2.6.39-rc5-x86-rw.orig/arch/um/sys-i386/Makefile
+++ 2.6.39-rc5-x86-rw/arch/um/sys-i386/Makefile
@@ -8,7 +8,7 @@ obj-y = bug.o bugs.o checksum.o delay.o 
 
 obj-$(CONFIG_BINFMT_ELF) += elfcore.o
 
-subarch-obj-y = lib/semaphore_32.o lib/string_32.o
+subarch-obj-y = lib/rwsem.o lib/string_32.o
 subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem_32.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
 
--- 2.6.39-rc5-x86-rw.orig/arch/um/sys-x86_64/Makefile
+++ 2.6.39-rc5-x86-rw/arch/um/sys-x86_64/Makefile
@@ -9,7 +9,7 @@ obj-y = bug.o bugs.o delay.o fault.o ldt
 	sysrq.o ksyms.o tls.o
 
 subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o \
-		lib/rwsem_64.o
+		lib/rwsem.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
 
 ldt-y = ../sys-i386/ldt.o
--- 2.6.39-rc5-x86-rw.orig/arch/x86/lib/Makefile
+++ 2.6.39-rc5-x86-rw/arch/x86/lib/Makefile
@@ -21,6 +21,7 @@ lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
 lib-$(CONFIG_SMP) += rwlock.o
+lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o
 
 obj-y += msr.o msr-reg.o msr-reg-export.o
@@ -30,7 +31,6 @@ ifeq ($(CONFIG_X86_32),y)
         lib-y += atomic64_cx8_32.o
         lib-y += checksum_32.o
         lib-y += strstr_32.o
-        lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += semaphore_32.o
         lib-y += string_32.o
         lib-y += cmpxchg.o
 ifneq ($(CONFIG_X86_CMPXCHG64),y)
@@ -43,6 +43,5 @@ else
         lib-y += thunk_64.o clear_page_64.o copy_page_64.o
         lib-y += memmove_64.o memset_64.o
         lib-y += copy_user_64.o copy_user_nocache_64.o
-	lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem_64.o
 	lib-y += cmpxchg16b_emu.o
 endif
--- /dev/null
+++ 2.6.39-rc5-x86-rw/arch/x86/lib/rwsem.S
@@ -0,0 +1,136 @@
+/*
+ * x86 semaphore implementation.
+ *
+ * (C) Copyright 1999 Linus Torvalds
+ *
+ * Portions Copyright 1999 Red Hat, Inc.
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ * rw semaphores implemented November 1999 by Benjamin LaHaise <bcrl@kvack.org>
+ */
+
+#include <linux/linkage.h>
+#include <asm/alternative-asm.h>
+#include <asm/dwarf2.h>
+
+#define __ASM_HALF_REG(reg)	__ASM_SEL(reg, e##reg)
+#define __ASM_HALF_SIZE(inst)	__ASM_SEL(inst##w, inst##l)
+
+#ifdef CONFIG_X86_32
+
+/*
+ * The semaphore operations have a special calling sequence that
+ * allow us to do a simpler in-line version of them. These routines
+ * need to convert that sequence back into the C sequence when
+ * there is contention on the semaphore.
+ *
+ * %eax contains the semaphore pointer on entry. Save the C-clobbered
+ * registers (%eax, %edx and %ecx) except %eax whish is either a return
+ * value or just clobbered..
+ */
+
+#define save_common_regs \
+	pushl_cfi %ecx; CFI_REL_OFFSET ecx, 0
+
+#define restore_common_regs \
+	popl_cfi %ecx; CFI_RESTORE ecx
+
+	/* Avoid uglifying the argument copying x86-64 needs to do. */
+	.macro movq src, dst
+	.endm
+
+#else
+
+/*
+ * x86-64 rwsem wrappers
+ *
+ * This interfaces the inline asm code to the slow-path
+ * C routines. We need to save the call-clobbered regs
+ * that the asm does not mark as clobbered, and move the
+ * argument from %rax to %rdi.
+ *
+ * NOTE! We don't need to save %rax, because the functions
+ * will always return the semaphore pointer in %rax (which
+ * is also the input argument to these helpers)
+ *
+ * The following can clobber %rdx because the asm clobbers it:
+ *   call_rwsem_down_write_failed
+ *   call_rwsem_wake
+ * but %rdi, %rsi, %rcx, %r8-r11 always need saving.
+ */
+
+#define save_common_regs \
+	pushq_cfi %rdi; CFI_REL_OFFSET rdi, 0; \
+	pushq_cfi %rsi; CFI_REL_OFFSET rsi, 0; \
+	pushq_cfi %rcx; CFI_REL_OFFSET rcx, 0; \
+	pushq_cfi %r8;  CFI_REL_OFFSET r8,  0; \
+	pushq_cfi %r9;  CFI_REL_OFFSET r9,  0; \
+	pushq_cfi %r10; CFI_REL_OFFSET r10, 0; \
+	pushq_cfi %r11; CFI_REL_OFFSET r11, 0
+
+#define restore_common_regs \
+	popq_cfi %r11; CFI_RESTORE r11; \
+	popq_cfi %r10; CFI_RESTORE r10; \
+	popq_cfi %r9;  CFI_RESTORE r9; \
+	popq_cfi %r8;  CFI_RESTORE r8; \
+	popq_cfi %rcx; CFI_RESTORE rcx; \
+	popq_cfi %rsi; CFI_RESTORE rsi; \
+	popq_cfi %rdi; CFI_RESTORE rdi
+
+#endif
+
+/* Fix up special calling conventions */
+ENTRY(call_rwsem_down_read_failed)
+	CFI_STARTPROC
+	save_common_regs
+	__ASM_SIZE(push,_cfi) %__ASM_REG(dx)
+	CFI_REL_OFFSET __ASM_REG(dx), 0
+	movq %rax,%rdi
+	call rwsem_down_read_failed
+	__ASM_SIZE(pop,_cfi) %__ASM_REG(dx)
+	CFI_RESTORE __ASM_REG(dx)
+	restore_common_regs
+	ret
+	CFI_ENDPROC
+ENDPROC(call_rwsem_down_read_failed)
+
+ENTRY(call_rwsem_down_write_failed)
+	CFI_STARTPROC
+	save_common_regs
+	movq %rax,%rdi
+	call rwsem_down_write_failed
+	restore_common_regs
+	ret
+	CFI_ENDPROC
+ENDPROC(call_rwsem_down_write_failed)
+
+ENTRY(call_rwsem_wake)
+	CFI_STARTPROC
+	/* do nothing if still outstanding active readers */
+	__ASM_HALF_SIZE(dec) %__ASM_HALF_REG(dx)
+	jnz 1f
+	save_common_regs
+	movq %rax,%rdi
+	call rwsem_wake
+	restore_common_regs
+1:	ret
+	CFI_ENDPROC
+ENDPROC(call_rwsem_wake)
+
+ENTRY(call_rwsem_downgrade_wake)
+	CFI_STARTPROC
+	save_common_regs
+	__ASM_SIZE(push,_cfi) %__ASM_REG(dx)
+	CFI_REL_OFFSET __ASM_REG(dx), 0
+	movq %rax,%rdi
+	call rwsem_downgrade_wake
+	__ASM_SIZE(pop,_cfi) %__ASM_REG(dx)
+	CFI_RESTORE __ASM_REG(dx)
+	restore_common_regs
+	ret
+	CFI_ENDPROC
+ENDPROC(call_rwsem_downgrade_wake)
--- 2.6.39-rc5-x86-rw.orig/arch/x86/lib/rwsem_64.S
+++ /dev/null
@@ -1,93 +0,0 @@
-/*
- * x86-64 rwsem wrappers
- *
- * This interfaces the inline asm code to the slow-path
- * C routines. We need to save the call-clobbered regs
- * that the asm does not mark as clobbered, and move the
- * argument from %rax to %rdi.
- *
- * NOTE! We don't need to save %rax, because the functions
- * will always return the semaphore pointer in %rax (which
- * is also the input argument to these helpers)
- *
- * The following can clobber %rdx because the asm clobbers it:
- *   call_rwsem_down_write_failed
- *   call_rwsem_wake
- * but %rdi, %rsi, %rcx, %r8-r11 always need saving.
- */
-
-#include <linux/linkage.h>
-#include <asm/rwlock.h>
-#include <asm/alternative-asm.h>
-#include <asm/frame.h>
-#include <asm/dwarf2.h>
-
-#define save_common_regs \
-	pushq_cfi %rdi; CFI_REL_OFFSET rdi, 0; \
-	pushq_cfi %rsi; CFI_REL_OFFSET rsi, 0; \
-	pushq_cfi %rcx; CFI_REL_OFFSET rcx, 0; \
-	pushq_cfi %r8;  CFI_REL_OFFSET r8,  0; \
-	pushq_cfi %r9;  CFI_REL_OFFSET r9,  0; \
-	pushq_cfi %r10; CFI_REL_OFFSET r10, 0; \
-	pushq_cfi %r11; CFI_REL_OFFSET r11, 0
-
-#define restore_common_regs \
-	popq_cfi %r11; CFI_RESTORE r11; \
-	popq_cfi %r10; CFI_RESTORE r10; \
-	popq_cfi %r9;  CFI_RESTORE r9; \
-	popq_cfi %r8;  CFI_RESTORE r8; \
-	popq_cfi %rcx; CFI_RESTORE rcx; \
-	popq_cfi %rsi; CFI_RESTORE rsi; \
-	popq_cfi %rdi; CFI_RESTORE rdi
-
-/* Fix up special calling conventions */
-ENTRY(call_rwsem_down_read_failed)
-	CFI_STARTPROC
-	save_common_regs
-	pushq_cfi %rdx
-	CFI_REL_OFFSET rdx, 0
-	movq %rax,%rdi
-	call rwsem_down_read_failed
-	popq_cfi %rdx
-	CFI_RESTORE rdx
-	restore_common_regs
-	ret
-	CFI_ENDPROC
-ENDPROC(call_rwsem_down_read_failed)
-
-ENTRY(call_rwsem_down_write_failed)
-	CFI_STARTPROC
-	save_common_regs
-	movq %rax,%rdi
-	call rwsem_down_write_failed
-	restore_common_regs
-	ret
-	CFI_ENDPROC
-ENDPROC(call_rwsem_down_write_failed)
-
-ENTRY(call_rwsem_wake)
-	CFI_STARTPROC
-	decl %edx	/* do nothing if still outstanding active readers */
-	jnz 1f
-	save_common_regs
-	movq %rax,%rdi
-	call rwsem_wake
-	restore_common_regs
-1:	ret
-	CFI_ENDPROC
-ENDPROC(call_rwsem_wake)
-
-/* Fix up special calling conventions */
-ENTRY(call_rwsem_downgrade_wake)
-	CFI_STARTPROC
-	save_common_regs
-	pushq_cfi %rdx
-	CFI_REL_OFFSET rdx, 0
-	movq %rax,%rdi
-	call rwsem_downgrade_wake
-	popq_cfi %rdx
-	CFI_RESTORE rdx
-	restore_common_regs
-	ret
-	CFI_ENDPROC
-ENDPROC(call_rwsem_downgrade_wake)
--- 2.6.39-rc5-x86-rw.orig/arch/x86/lib/semaphore_32.S
+++ /dev/null
@@ -1,80 +0,0 @@
-/*
- * i386 semaphore implementation.
- *
- * (C) Copyright 1999 Linus Torvalds
- *
- * Portions Copyright 1999 Red Hat, Inc.
- *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License
- *	as published by the Free Software Foundation; either version
- *	2 of the License, or (at your option) any later version.
- *
- * rw semaphores implemented November 1999 by Benjamin LaHaise <bcrl@kvack.org>
- */
-
-#include <linux/linkage.h>
-#include <asm/frame.h>
-#include <asm/dwarf2.h>
-
-/*
- * The semaphore operations have a special calling sequence that
- * allow us to do a simpler in-line version of them. These routines
- * need to convert that sequence back into the C sequence when
- * there is contention on the semaphore.
- *
- * %eax contains the semaphore pointer on entry. Save the C-clobbered
- * registers (%eax, %edx and %ecx) except %eax whish is either a return
- * value or just clobbered..
- */
-	.section .sched.text, "ax"
-
-/* Fix up special calling conventions */
-ENTRY(call_rwsem_down_read_failed)
-	CFI_STARTPROC
-	pushl_cfi %ecx
-	CFI_REL_OFFSET ecx,0
-	pushl_cfi %edx
-	CFI_REL_OFFSET edx,0
-	call rwsem_down_read_failed
-	popl_cfi %edx
-	popl_cfi %ecx
-	ret
-	CFI_ENDPROC
-	ENDPROC(call_rwsem_down_read_failed)
-
-ENTRY(call_rwsem_down_write_failed)
-	CFI_STARTPROC
-	pushl_cfi %ecx
-	CFI_REL_OFFSET ecx,0
-	calll rwsem_down_write_failed
-	popl_cfi %ecx
-	ret
-	CFI_ENDPROC
-	ENDPROC(call_rwsem_down_write_failed)
-
-ENTRY(call_rwsem_wake)
-	CFI_STARTPROC
-	decw %dx    /* do nothing if still outstanding active readers */
-	jnz 1f
-	pushl_cfi %ecx
-	CFI_REL_OFFSET ecx,0
-	call rwsem_wake
-	popl_cfi %ecx
-1:	ret
-	CFI_ENDPROC
-	ENDPROC(call_rwsem_wake)
-
-/* Fix up special calling conventions */
-ENTRY(call_rwsem_downgrade_wake)
-	CFI_STARTPROC
-	pushl_cfi %ecx
-	CFI_REL_OFFSET ecx,0
-	pushl_cfi %edx
-	CFI_REL_OFFSET edx,0
-	call rwsem_downgrade_wake
-	popl_cfi %edx
-	popl_cfi %ecx
-	ret
-	CFI_ENDPROC
-	ENDPROC(call_rwsem_downgrade_wake)


