Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1DQUCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 16:02:05 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:38431 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab1DQUB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 16:01:59 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: user-mode-linux-devel@lists.sourceforge.net, walch.martin@web.de,
        Richard Weinberger <richard@nod.at>
Subject: =?UTF-8?q?=5BPATCH=5D=20um=3A=20Add=20support=20for=2064=20bit=20atomic=20operations?=
Date: Sun, 17 Apr 2011 22:01:48 +0200
Message-Id: <1303070508-10465-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for 64 bit atomic operations on
32 bit UML systems.
XFS needs them since 2.6.38.

Reported-by: Martin Walch <walch.martin@web.de>
Tested-by: Martin Walch <walch.martin@web.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/sys-i386/Makefile          |    2 +-
 arch/um/sys-i386/atomic64_cx8_32.S |  225 ++++++++++++++++++++++++++++++++++++
 2 files changed, 226 insertions(+), 1 deletions(-)
 create mode 100644 arch/um/sys-i386/atomic64_cx8_32.S

diff --git a/arch/um/sys-i386/Makefile b/arch/um/sys-i386/Makefile
index 804b28d..b1da91c 100644
--- a/arch/um/sys-i386/Makefile
+++ b/arch/um/sys-i386/Makefile
@@ -4,7 +4,7 @@
 
 obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
 	ptrace_user.o setjmp.o signal.o stub.o stub_segv.o syscalls.o sysrq.o \
-	sys_call_table.o tls.o
+	sys_call_table.o tls.o atomic64_cx8_32.o
 
 obj-$(CONFIG_BINFMT_ELF) += elfcore.o
 
diff --git a/arch/um/sys-i386/atomic64_cx8_32.S b/arch/um/sys-i386/atomic64_cx8_32.S
new file mode 100644
index 0000000..1e901d3
--- /dev/null
+++ b/arch/um/sys-i386/atomic64_cx8_32.S
@@ -0,0 +1,225 @@
+/*
+ * atomic64_t for 586+
+ *
+ * Copied from arch/x86/lib/atomic64_cx8_32.S
+ *
+ * Copyright © 2010  Luca Barbieri
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/linkage.h>
+#include <asm/alternative-asm.h>
+#include <asm/dwarf2.h>
+
+.macro SAVE reg
+	pushl_cfi %\reg
+	CFI_REL_OFFSET \reg, 0
+.endm
+
+.macro RESTORE reg
+	popl_cfi %\reg
+	CFI_RESTORE \reg
+.endm
+
+.macro read64 reg
+	movl %ebx, %eax
+	movl %ecx, %edx
+/* we need LOCK_PREFIX since otherwise cmpxchg8b always does the write */
+	LOCK_PREFIX
+	cmpxchg8b (\reg)
+.endm
+
+ENTRY(atomic64_read_cx8)
+	CFI_STARTPROC
+
+	read64 %ecx
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_read_cx8)
+
+ENTRY(atomic64_set_cx8)
+	CFI_STARTPROC
+
+1:
+/* we don't need LOCK_PREFIX since aligned 64-bit writes
+ * are atomic on 586 and newer */
+	cmpxchg8b (%esi)
+	jne 1b
+
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_set_cx8)
+
+ENTRY(atomic64_xchg_cx8)
+	CFI_STARTPROC
+
+	movl %ebx, %eax
+	movl %ecx, %edx
+1:
+	LOCK_PREFIX
+	cmpxchg8b (%esi)
+	jne 1b
+
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_xchg_cx8)
+
+.macro addsub_return func ins insc
+ENTRY(atomic64_\func\()_return_cx8)
+	CFI_STARTPROC
+	SAVE ebp
+	SAVE ebx
+	SAVE esi
+	SAVE edi
+
+	movl %eax, %esi
+	movl %edx, %edi
+	movl %ecx, %ebp
+
+	read64 %ebp
+1:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	\ins\()l %esi, %ebx
+	\insc\()l %edi, %ecx
+	LOCK_PREFIX
+	cmpxchg8b (%ebp)
+	jne 1b
+
+10:
+	movl %ebx, %eax
+	movl %ecx, %edx
+	RESTORE edi
+	RESTORE esi
+	RESTORE ebx
+	RESTORE ebp
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_\func\()_return_cx8)
+.endm
+
+addsub_return add add adc
+addsub_return sub sub sbb
+
+.macro incdec_return func ins insc
+ENTRY(atomic64_\func\()_return_cx8)
+	CFI_STARTPROC
+	SAVE ebx
+
+	read64 %esi
+1:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	\ins\()l $1, %ebx
+	\insc\()l $0, %ecx
+	LOCK_PREFIX
+	cmpxchg8b (%esi)
+	jne 1b
+
+10:
+	movl %ebx, %eax
+	movl %ecx, %edx
+	RESTORE ebx
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_\func\()_return_cx8)
+.endm
+
+incdec_return inc add adc
+incdec_return dec sub sbb
+
+ENTRY(atomic64_dec_if_positive_cx8)
+	CFI_STARTPROC
+	SAVE ebx
+
+	read64 %esi
+1:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	subl $1, %ebx
+	sbb $0, %ecx
+	js 2f
+	LOCK_PREFIX
+	cmpxchg8b (%esi)
+	jne 1b
+
+2:
+	movl %ebx, %eax
+	movl %ecx, %edx
+	RESTORE ebx
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_dec_if_positive_cx8)
+
+ENTRY(atomic64_add_unless_cx8)
+	CFI_STARTPROC
+	SAVE ebp
+	SAVE ebx
+/* these just push these two parameters on the stack */
+	SAVE edi
+	SAVE esi
+
+	movl %ecx, %ebp
+	movl %eax, %esi
+	movl %edx, %edi
+
+	read64 %ebp
+1:
+	cmpl %eax, 0(%esp)
+	je 4f
+2:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	addl %esi, %ebx
+	adcl %edi, %ecx
+	LOCK_PREFIX
+	cmpxchg8b (%ebp)
+	jne 1b
+
+	movl $1, %eax
+3:
+	addl $8, %esp
+	CFI_ADJUST_CFA_OFFSET -8
+	RESTORE ebx
+	RESTORE ebp
+	ret
+4:
+	cmpl %edx, 4(%esp)
+	jne 2b
+	xorl %eax, %eax
+	jmp 3b
+	CFI_ENDPROC
+ENDPROC(atomic64_add_unless_cx8)
+
+ENTRY(atomic64_inc_not_zero_cx8)
+	CFI_STARTPROC
+	SAVE ebx
+
+	read64 %esi
+1:
+	testl %eax, %eax
+	je 4f
+2:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	addl $1, %ebx
+	adcl $0, %ecx
+	LOCK_PREFIX
+	cmpxchg8b (%esi)
+	jne 1b
+
+	movl $1, %eax
+3:
+	RESTORE ebx
+	ret
+4:
+	testl %edx, %edx
+	jne 2b
+	jmp 3b
+	CFI_ENDPROC
+ENDPROC(atomic64_inc_not_zero_cx8)
-- 
1.7.4.2

