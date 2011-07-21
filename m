Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab1GUJTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:19:07 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:57239 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab1GUJSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:18:46 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 06/10] um: Set __HAVE_ARCH_GATE_AREA for i386
Date: Thu, 21 Jul 2011 11:18:30 +0200
Message-Id: <1311239914-8301-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311239914-8301-1-git-send-email-richard@nod.at>
References: <1311239914-8301-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When UML is unable to reuse the host's vDSO FIXADDR_USER_START
is zero.
To handle this special case correclty we have to implement custom
gate area helper methods.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/sys-i386/Makefile  |    2 +-
 arch/um/sys-i386/asm/elf.h |    2 +
 arch/um/sys-i386/mem.c     |   62 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 1 deletions(-)
 create mode 100644 arch/um/sys-i386/mem.c

diff --git a/arch/um/sys-i386/Makefile b/arch/um/sys-i386/Makefile
index b1da91c..daaea15 100644
--- a/arch/um/sys-i386/Makefile
+++ b/arch/um/sys-i386/Makefile
@@ -4,7 +4,7 @@
 
 obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
 	ptrace_user.o setjmp.o signal.o stub.o stub_segv.o syscalls.o sysrq.o \
-	sys_call_table.o tls.o atomic64_cx8_32.o
+	sys_call_table.o tls.o atomic64_cx8_32.o mem.o
 
 obj-$(CONFIG_BINFMT_ELF) += elfcore.o
 
diff --git a/arch/um/sys-i386/asm/elf.h b/arch/um/sys-i386/asm/elf.h
index d964a41..4230555 100644
--- a/arch/um/sys-i386/asm/elf.h
+++ b/arch/um/sys-i386/asm/elf.h
@@ -105,6 +105,8 @@ extern unsigned long __kernel_vsyscall;
 #define FIXADDR_USER_START      VSYSCALL_BASE
 #define FIXADDR_USER_END        VSYSCALL_END
 
+#define __HAVE_ARCH_GATE_AREA 1
+
 /*
  * Architecture-neutral AT_ values in 0-17, leave some room
  * for more of them, start the x86-specific ones at 32.
diff --git a/arch/um/sys-i386/mem.c b/arch/um/sys-i386/mem.c
new file mode 100644
index 0000000..639900a
--- /dev/null
+++ b/arch/um/sys-i386/mem.c
@@ -0,0 +1,62 @@
+/*
+ * Copyright (C) 2011 Richard Weinberger <richrd@nod.at>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/mm.h>
+#include <asm/page.h>
+#include <asm/mman.h>
+
+static struct vm_area_struct gate_vma;
+
+static int __init gate_vma_init(void)
+{
+	if (!FIXADDR_USER_START)
+		return 0;
+
+	gate_vma.vm_mm = NULL;
+	gate_vma.vm_start = FIXADDR_USER_START;
+	gate_vma.vm_end = FIXADDR_USER_END;
+	gate_vma.vm_flags = VM_READ | VM_MAYREAD | VM_EXEC | VM_MAYEXEC;
+	gate_vma.vm_page_prot = __P101;
+
+	/*
+	 * Make sure the vDSO gets into every core dump.
+	 * Dumping its contents makes post-mortem fully interpretable later
+	 * without matching up the same kernel and hardware config to see
+	 * what PC values meant.
+	 */
+	gate_vma.vm_flags |= VM_ALWAYSDUMP;
+
+	return 0;
+}
+__initcall(gate_vma_init);
+
+struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
+{
+	return FIXADDR_USER_START ? &gate_vma : NULL;
+}
+
+int in_gate_area_no_mm(unsigned long addr)
+{
+	if (!FIXADDR_USER_START)
+		return 0;
+
+	if ((addr >= FIXADDR_USER_START) && (addr < FIXADDR_USER_END))
+		return 1;
+
+	return 0;
+}
+
+int in_gate_area(struct mm_struct *mm, unsigned long addr)
+{
+	struct vm_area_struct *vma = get_gate_vma(mm);
+
+	if (!vma)
+		return 0;
+
+	return (addr >= vma->vm_start) && (addr < vma->vm_end);
+}
-- 
1.7.6

