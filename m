Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab1DLOKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:10:06 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:40447 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab1DLOKF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:10:05 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: um: this_cpu_cmpxchg16b_emu
Date: Tue, 12 Apr 2011 16:09:56 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: cl@linux.com, penberg@kernel.org, hpa@zytor.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104121609.56901.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch implements this_cpu_cmpxchg16b_emu() for UML.
As I'm not an amd64 assembly guru I'm not sure whether the assembly part is
correct.
Can someone please review it?

Especially I'm unsure which register have to be saved before each 
call to C functions.

Thanks,
//richard

>From 202b0efe024d7c0500e7c11f0aa105f7a1fafb9b Mon Sep 17 00:00:00 2001
From: Richard Weinberger <richard@nod.at>
Date: Mon, 11 Apr 2011 19:22:38 +0200
Subject: [PATCH] um: Implement this_cpu_cmpxchg16b_emu()

Commit 8a5ec0ba "Lockless (and preemptless) fastpaths for slub"
makes use of this_cpu_cmpxchg_double() which needs
this_cpu_cmpxchg16b_emu() on x86_64.
User Mode Linux has to serve this function too.

Reported-by: Sergei Trofimovich <slyich@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/sys-x86_64/Makefile            |    2 +-
 arch/um/sys-x86_64/cmpxchg16b_emu.S    |   72 ++++++++++++++++++++++++++++++++
 arch/um/sys-x86_64/cmpxchg16b_helper.c |   22 ++++++++++
 3 files changed, 95 insertions(+), 1 deletions(-)
 create mode 100644 arch/um/sys-x86_64/cmpxchg16b_emu.S
 create mode 100644 arch/um/sys-x86_64/cmpxchg16b_helper.c

diff --git a/arch/um/sys-x86_64/Makefile b/arch/um/sys-x86_64/Makefile
index c1ea9eb..9a66afe 100644
--- a/arch/um/sys-x86_64/Makefile
+++ b/arch/um/sys-x86_64/Makefile
@@ -6,7 +6,7 @@
 
 obj-y = bug.o bugs.o delay.o fault.o ldt.o mem.o ptrace.o ptrace_user.o \
 	setjmp.o signal.o stub.o stub_segv.o syscalls.o syscall_table.o \
-	sysrq.o ksyms.o tls.o
+	sysrq.o ksyms.o tls.o cmpxchg16b_emu.o cmpxchg16b_helper.o
 
 subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o \
 		lib/rwsem_64.o
diff --git a/arch/um/sys-x86_64/cmpxchg16b_emu.S b/arch/um/sys-x86_64/cmpxchg16b_emu.S
new file mode 100644
index 0000000..170b6fa
--- /dev/null
+++ b/arch/um/sys-x86_64/cmpxchg16b_emu.S
@@ -0,0 +1,72 @@
+/*
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; version 2
+ *	of the License.
+ *
+ *	Copyright 2011 Richard Weinberger <richard@nod.at>
+ *	Mostly copied from arch/x86/lib/cmpxchg16b_emu.S
+ *
+ */
+#include <linux/linkage.h>
+#include <asm/alternative-asm.h>
+#include <asm/frame.h>
+#include <asm/dwarf2.h>
+
+.text
+
+/*
+ * Inputs:
+ * %rsi : memory location to compare
+ * %rax : low 64 bits of old value
+ * %rdx : high 64 bits of old value
+ * %rbx : low 64 bits of new value
+ * %rcx : high 64 bits of new value
+ * %al  : Operation successful
+ */
+ENTRY(this_cpu_cmpxchg16b_emu)
+CFI_STARTPROC
+
+#
+# Emulate 'cmpxchg16b %gs:(%rsi)' except we return the result in %al not
+# via the ZF.  Caller will access %al to get result.
+#
+# Note that this is only useful for a cpuops operation.  Meaning that we
+# do *not* have a fully atomic operation but just an operation that is
+# *atomic* on a single cpu (as provided by the this_cpu_xx class of
+# macros).
+#
+this_cpu_cmpxchg16b_emu:
+	pushq %rdi
+	pushq %rax
+	pushq %rdx
+	call arch_local_irq_save_asm
+	movq %rax, %rdi
+	popq %rdx
+	popq %rax
+
+	cmpq (%rsi), %rax
+	jne not_same
+	cmpq 8(%rsi), %rdx
+	jne not_same
+
+	movq %rbx, (%rsi)
+	movq %rcx, 8(%rsi)
+
+	mov $1, %al
+	jmp out
+
+ not_same:
+	xor %al,%al
+
+ out:
+	pushq %rax
+	pushq %rdx
+	call arch_local_irq_restore_asm
+	popq %rdx
+	popq %rax
+	popq %rdi
+	ret
+CFI_ENDPROC
+
+ENDPROC(this_cpu_cmpxchg16b_emu)
diff --git a/arch/um/sys-x86_64/cmpxchg16b_helper.c b/arch/um/sys-x86_64/cmpxchg16b_helper.c
new file mode 100644
index 0000000..b7e665c
--- /dev/null
+++ b/arch/um/sys-x86_64/cmpxchg16b_helper.c
@@ -0,0 +1,22 @@
+/*
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; version 2
+ *	of the License.
+ *
+ *	Copyright 2011 Richard Weinberger <richard@nod.at>
+ *
+ */
+
+#include <linux/linkage.h>
+#include <asm/system.h>
+
+asmlinkage unsigned long arch_local_irq_save_asm(void)
+{
+	return arch_local_irq_save();
+}
+
+asmlinkage void arch_local_irq_restore_asm(unsigned long flags)
+{
+	arch_local_irq_restore(flags);
+}
-- 
1.7.4.2

