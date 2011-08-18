Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab1HRTAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:00:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49903 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1HRTAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:00:09 -0400
Date: Thu, 18 Aug 2011 20:00:09 +0100
To: richard@nod.at
Subject: Subject: [PATCH 07/91] um: use subarch-obj instead of copying...
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Message-Id: <E1Qu7p3-0007Sp-6F@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/sys-i386/Makefile          |    4 +-
 arch/um/sys-i386/atomic64_cx8_32.S |  225 ------------------------------------
 2 files changed, 2 insertions(+), 227 deletions(-)
 delete mode 100644 arch/um/sys-i386/atomic64_cx8_32.S

diff --git a/arch/um/sys-i386/Makefile b/arch/um/sys-i386/Makefile
index 3923cfb..e5e56d7 100644
--- a/arch/um/sys-i386/Makefile
+++ b/arch/um/sys-i386/Makefile
@@ -4,11 +4,11 @@
 
 obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
 	ptrace_user.o setjmp.o signal.o stub.o stub_segv.o syscalls.o sysrq.o \
-	sys_call_table.o tls.o atomic64_cx8_32.o mem.o
+	sys_call_table.o tls.o mem.o
 
 obj-$(CONFIG_BINFMT_ELF) += elfcore.o
 
-subarch-obj-y = lib/string_32.o
+subarch-obj-y = lib/string_32.o lib/atomic64_32.o lib/atomic64_cx8_32.o
 subarch-obj-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += lib/rwsem.o
 subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem_32.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
diff --git a/arch/um/sys-i386/atomic64_cx8_32.S b/arch/um/sys-i386/atomic64_cx8_32.S
deleted file mode 100644
index 1e901d3..0000000
--- a/arch/um/sys-i386/atomic64_cx8_32.S
+++ /dev/null
@@ -1,225 +0,0 @@
-/*
- * atomic64_t for 586+
- *
- * Copied from arch/x86/lib/atomic64_cx8_32.S
- *
- * Copyright © 2010  Luca Barbieri
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-
-#include <linux/linkage.h>
-#include <asm/alternative-asm.h>
-#include <asm/dwarf2.h>
-
-.macro SAVE reg
-	pushl_cfi %\reg
-	CFI_REL_OFFSET \reg, 0
-.endm
-
-.macro RESTORE reg
-	popl_cfi %\reg
-	CFI_RESTORE \reg
-.endm
-
-.macro read64 reg
-	movl %ebx, %eax
-	movl %ecx, %edx
-/* we need LOCK_PREFIX since otherwise cmpxchg8b always does the write */
-	LOCK_PREFIX
-	cmpxchg8b (\reg)
-.endm
-
-ENTRY(atomic64_read_cx8)
-	CFI_STARTPROC
-
-	read64 %ecx
-	ret
-	CFI_ENDPROC
-ENDPROC(atomic64_read_cx8)
-
-ENTRY(atomic64_set_cx8)
-	CFI_STARTPROC
-
-1:
-/* we don't need LOCK_PREFIX since aligned 64-bit writes
- * are atomic on 586 and newer */
-	cmpxchg8b (%esi)
-	jne 1b
-
-	ret
-	CFI_ENDPROC
-ENDPROC(atomic64_set_cx8)
-
-ENTRY(atomic64_xchg_cx8)
-	CFI_STARTPROC
-
-	movl %ebx, %eax
-	movl %ecx, %edx
-1:
-	LOCK_PREFIX
-	cmpxchg8b (%esi)
-	jne 1b
-
-	ret
-	CFI_ENDPROC
-ENDPROC(atomic64_xchg_cx8)
-
-.macro addsub_return func ins insc
-ENTRY(atomic64_\func\()_return_cx8)
-	CFI_STARTPROC
-	SAVE ebp
-	SAVE ebx
-	SAVE esi
-	SAVE edi
-
-	movl %eax, %esi
-	movl %edx, %edi
-	movl %ecx, %ebp
-
-	read64 %ebp
-1:
-	movl %eax, %ebx
-	movl %edx, %ecx
-	\ins\()l %esi, %ebx
-	\insc\()l %edi, %ecx
-	LOCK_PREFIX
-	cmpxchg8b (%ebp)
-	jne 1b
-
-10:
-	movl %ebx, %eax
-	movl %ecx, %edx
-	RESTORE edi
-	RESTORE esi
-	RESTORE ebx
-	RESTORE ebp
-	ret
-	CFI_ENDPROC
-ENDPROC(atomic64_\func\()_return_cx8)
-.endm
-
-addsub_return add add adc
-addsub_return sub sub sbb
-
-.macro incdec_return func ins insc
-ENTRY(atomic64_\func\()_return_cx8)
-	CFI_STARTPROC
-	SAVE ebx
-
-	read64 %esi
-1:
-	movl %eax, %ebx
-	movl %edx, %ecx
-	\ins\()l $1, %ebx
-	\insc\()l $0, %ecx
-	LOCK_PREFIX
-	cmpxchg8b (%esi)
-	jne 1b
-
-10:
-	movl %ebx, %eax
-	movl %ecx, %edx
-	RESTORE ebx
-	ret
-	CFI_ENDPROC
-ENDPROC(atomic64_\func\()_return_cx8)
-.endm
-
-incdec_return inc add adc
-incdec_return dec sub sbb
-
-ENTRY(atomic64_dec_if_positive_cx8)
-	CFI_STARTPROC
-	SAVE ebx
-
-	read64 %esi
-1:
-	movl %eax, %ebx
-	movl %edx, %ecx
-	subl $1, %ebx
-	sbb $0, %ecx
-	js 2f
-	LOCK_PREFIX
-	cmpxchg8b (%esi)
-	jne 1b
-
-2:
-	movl %ebx, %eax
-	movl %ecx, %edx
-	RESTORE ebx
-	ret
-	CFI_ENDPROC
-ENDPROC(atomic64_dec_if_positive_cx8)
-
-ENTRY(atomic64_add_unless_cx8)
-	CFI_STARTPROC
-	SAVE ebp
-	SAVE ebx
-/* these just push these two parameters on the stack */
-	SAVE edi
-	SAVE esi
-
-	movl %ecx, %ebp
-	movl %eax, %esi
-	movl %edx, %edi
-
-	read64 %ebp
-1:
-	cmpl %eax, 0(%esp)
-	je 4f
-2:
-	movl %eax, %ebx
-	movl %edx, %ecx
-	addl %esi, %ebx
-	adcl %edi, %ecx
-	LOCK_PREFIX
-	cmpxchg8b (%ebp)
-	jne 1b
-
-	movl $1, %eax
-3:
-	addl $8, %esp
-	CFI_ADJUST_CFA_OFFSET -8
-	RESTORE ebx
-	RESTORE ebp
-	ret
-4:
-	cmpl %edx, 4(%esp)
-	jne 2b
-	xorl %eax, %eax
-	jmp 3b
-	CFI_ENDPROC
-ENDPROC(atomic64_add_unless_cx8)
-
-ENTRY(atomic64_inc_not_zero_cx8)
-	CFI_STARTPROC
-	SAVE ebx
-
-	read64 %esi
-1:
-	testl %eax, %eax
-	je 4f
-2:
-	movl %eax, %ebx
-	movl %edx, %ecx
-	addl $1, %ebx
-	adcl $0, %ecx
-	LOCK_PREFIX
-	cmpxchg8b (%esi)
-	jne 1b
-
-	movl $1, %eax
-3:
-	RESTORE ebx
-	ret
-4:
-	testl %edx, %edx
-	jne 2b
-	jmp 3b
-	CFI_ENDPROC
-ENDPROC(atomic64_inc_not_zero_cx8)
-- 
1.7.2.5


