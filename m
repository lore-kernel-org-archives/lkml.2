Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab1GUKIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:08:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:60091 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab1GUKI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:08:29 -0400
Date: Thu, 21 Jul 2011 10:07:24 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Message-ID: <tip-a738669464a1e0d8e7b20f631120192f9cf7cfbd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        jbeulich@novell.com, akpm@linux-foundation.org, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, jbeulich@novell.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        JBeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4E258DF3020000780004E3ED@nat28.tlf.novell.com>
References: <4E258DF3020000780004E3ED@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Unify rwsem assembly implementation
Git-Commit-ID: a738669464a1e0d8e7b20f631120192f9cf7cfbd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:07:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a738669464a1e0d8e7b20f631120192f9cf7cfbd
Gitweb:     http://git.kernel.org/tip/a738669464a1e0d8e7b20f631120192f9cf7cfbd
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Tue, 19 Jul 2011 13:00:19 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 09:03:32 +0200

x86: Unify rwsem assembly implementation

Rather than having two functionally identical implementations
for 32- and 64-bit configurations, use the previously extended
assembly abstractions to fold the rwsem two implementations into
a shared one.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4E258DF3020000780004E3ED@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/um/sys-i386/Makefile            |    2 +-
 arch/um/sys-x86_64/Makefile          |    2 +-
 arch/x86/lib/Makefile                |    3 +-
 arch/x86/lib/{rwsem_64.S => rwsem.S} |   75 +++++++++++++++++++++++++-------
 arch/x86/lib/semaphore_32.S          |   80 ----------------------------------
 5 files changed, 62 insertions(+), 100 deletions(-)

diff --git a/arch/um/sys-i386/Makefile b/arch/um/sys-i386/Makefile
index b1da91c..15587ed 100644
--- a/arch/um/sys-i386/Makefile
+++ b/arch/um/sys-i386/Makefile
@@ -8,7 +8,7 @@ obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
 
 obj-$(CONFIG_BINFMT_ELF) += elfcore.o
 
-subarch-obj-y = lib/semaphore_32.o lib/string_32.o
+subarch-obj-y = lib/rwsem.o lib/string_32.o
 subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem_32.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
 
diff --git a/arch/um/sys-x86_64/Makefile b/arch/um/sys-x86_64/Makefile
index c1ea9eb..61fc99a 100644
--- a/arch/um/sys-x86_64/Makefile
+++ b/arch/um/sys-x86_64/Makefile
@@ -9,7 +9,7 @@ obj-y = bug.o bugs.o delay.o fault.o ldt.o mem.o ptrace.o ptrace_user.o \
 	sysrq.o ksyms.o tls.o
 
 subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o \
-		lib/rwsem_64.o
+		lib/rwsem.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
 
 ldt-y = ../sys-i386/ldt.o
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index d3ed120..5d46ddc 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
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
diff --git a/arch/x86/lib/rwsem_64.S b/arch/x86/lib/rwsem.S
similarity index 55%
rename from arch/x86/lib/rwsem_64.S
rename to arch/x86/lib/rwsem.S
index 6774397..5dff5f0 100644
--- a/arch/x86/lib/rwsem_64.S
+++ b/arch/x86/lib/rwsem.S
@@ -1,4 +1,51 @@
 /*
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
  * x86-64 rwsem wrappers
  *
  * This interfaces the inline asm code to the slow-path
@@ -16,12 +63,6 @@
  * but %rdi, %rsi, %rcx, %r8-r11 always need saving.
  */
 
-#include <linux/linkage.h>
-#include <asm/rwlock.h>
-#include <asm/alternative-asm.h>
-#include <asm/frame.h>
-#include <asm/dwarf2.h>
-
 #define save_common_regs \
 	pushq_cfi %rdi; CFI_REL_OFFSET rdi, 0; \
 	pushq_cfi %rsi; CFI_REL_OFFSET rsi, 0; \
@@ -40,16 +81,18 @@
 	popq_cfi %rsi; CFI_RESTORE rsi; \
 	popq_cfi %rdi; CFI_RESTORE rdi
 
+#endif
+
 /* Fix up special calling conventions */
 ENTRY(call_rwsem_down_read_failed)
 	CFI_STARTPROC
 	save_common_regs
-	pushq_cfi %rdx
-	CFI_REL_OFFSET rdx, 0
+	__ASM_SIZE(push,_cfi) %__ASM_REG(dx)
+	CFI_REL_OFFSET __ASM_REG(dx), 0
 	movq %rax,%rdi
 	call rwsem_down_read_failed
-	popq_cfi %rdx
-	CFI_RESTORE rdx
+	__ASM_SIZE(pop,_cfi) %__ASM_REG(dx)
+	CFI_RESTORE __ASM_REG(dx)
 	restore_common_regs
 	ret
 	CFI_ENDPROC
@@ -67,7 +110,8 @@ ENDPROC(call_rwsem_down_write_failed)
 
 ENTRY(call_rwsem_wake)
 	CFI_STARTPROC
-	decl %edx	/* do nothing if still outstanding active readers */
+	/* do nothing if still outstanding active readers */
+	__ASM_HALF_SIZE(dec) %__ASM_HALF_REG(dx)
 	jnz 1f
 	save_common_regs
 	movq %rax,%rdi
@@ -77,16 +121,15 @@ ENTRY(call_rwsem_wake)
 	CFI_ENDPROC
 ENDPROC(call_rwsem_wake)
 
-/* Fix up special calling conventions */
 ENTRY(call_rwsem_downgrade_wake)
 	CFI_STARTPROC
 	save_common_regs
-	pushq_cfi %rdx
-	CFI_REL_OFFSET rdx, 0
+	__ASM_SIZE(push,_cfi) %__ASM_REG(dx)
+	CFI_REL_OFFSET __ASM_REG(dx), 0
 	movq %rax,%rdi
 	call rwsem_downgrade_wake
-	popq_cfi %rdx
-	CFI_RESTORE rdx
+	__ASM_SIZE(pop,_cfi) %__ASM_REG(dx)
+	CFI_RESTORE __ASM_REG(dx)
 	restore_common_regs
 	ret
 	CFI_ENDPROC
diff --git a/arch/x86/lib/semaphore_32.S b/arch/x86/lib/semaphore_32.S
deleted file mode 100644
index 65b591d..0000000
--- a/arch/x86/lib/semaphore_32.S
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
