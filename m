Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652Ab1D2S6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:58:53 -0400
Received: from kroah.org ([198.145.64.141]:35107 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933624Ab1D2S6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:57 2011
Message-Id: <20110429185657.133877914@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:56:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Martin Walch <walch.martin@web.de>,
        Richard Weinberger <richard@nod.at>
Subject: [47/55] um: mdd support for 64 bit atomic operations
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Richard Weinberger <richard@nod.at>

commit 57d8e02e3cd21bccf2b84b26b42feb79e1f0f83e upstream.

This adds support for 64 bit atomic operations on 32 bit UML systems.  XFS
needs them since 2.6.38.

  $ make ARCH=um SUBARCH=i386
  ...
    LD      .tmp_vmlinux1
  fs/built-in.o: In function `xlog_regrant_reserve_log_space':
  xfs_log.c:(.text+0xd8584): undefined reference to `atomic64_read_386'
  xfs_log.c:(.text+0xd85ac): undefined reference to `cmpxchg8b_emu'
  ...

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=32812

Reported-by: Martin Walch <walch.martin@web.de>
Tested-by: Martin Walch <walch.martin@web.de>
Cc: Martin Walch <walch.martin@web.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/sys-i386/Makefile          |    2 
 arch/um/sys-i386/atomic64_cx8_32.S |  225 +++++++++++++++++++++++++++++++++++++
 2 files changed, 226 insertions(+), 1 deletion(-)

--- a/arch/um/sys-i386/Makefile
+++ b/arch/um/sys-i386/Makefile
@@ -4,7 +4,7 @@
 
 obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
 	ptrace_user.o setjmp.o signal.o stub.o stub_segv.o syscalls.o sysrq.o \
-	sys_call_table.o tls.o
+	sys_call_table.o tls.o atomic64_cx8_32.o
 
 obj-$(CONFIG_BINFMT_ELF) += elfcore.o
 
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


