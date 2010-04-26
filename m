Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab0D2AZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 20:25:44 -0400
Received: from smtp01.one2one.net ([149.254.200.196]:38617 "EHLO
	smtp01.one2one.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab0D2AZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 20:25:42 -0400
From: Christoffer Dall <christofferdall@christofferdall.dk>
To: containers <containers@lists.linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Christoffer Dall <christofferdall@christofferdall.dk>,
       Roland McGrath <roland@redhat.com>
Subject: [C/R ARM v2][PATCH 1/3] ARM: Rudimentary syscall interfaces
Date: Mon, 26 Apr 2010 17:43:41 -0400
Message-Id: <1272318223-28438-2-git-send-email-christofferdall@christofferdall.dk>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1272318223-28438-1-git-send-email-christofferdall@christofferdall.dk>
References: <1272318223-28438-1-git-send-email-christofferdall@christofferdall.dk>
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: christofferdall@christofferdall.dk
X-SA-Exim-Scanned: No (on localhost); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduces a few of the system call inspection functions for ARM. The
current motivation is checkpoint restart, but the general interface
requirements are met, making it possible for a debugger or tracer to
obtain information about the system call status of another process.

The patch is in part based on the following proposal from Roland McGrath:
https://patchwork.kernel.org/patch/32101/

Compared to other architectures, the code to implement syscall_get_nr is
somewhat comprehensive. However, it's a result of no globally stored
location for the system call number and the complexity of the ARM ABI with
multiple versions.

Changelog[v2]:
	- Get the system call number by inspecting the process instead of
	  storing the system call number globally on entry to each system
	  call.

Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Christoffer Dall <christofferdall@christofferdall.dk>
Acked-by: Oren Laadan <orenl@cs.columbia.edu>
---
 arch/arm/include/asm/syscall.h |  133 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 133 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/include/asm/syscall.h

diff --git a/arch/arm/include/asm/syscall.h b/arch/arm/include/asm/syscall.h
new file mode 100644
index 0000000..49cb10e
--- /dev/null
+++ b/arch/arm/include/asm/syscall.h
@@ -0,0 +1,133 @@
+/*
+ * syscalls.h - Linux syscall interfaces for ARM
+ *
+ * Copyright (c) 2010 Christoffer Dall
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#ifndef _ASM_ARM_SYSCALLS_H
+#define _ASM_ARM_SYSCALLS_H
+
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+#include <linux/memory.h>
+#include <asm/unistd.h>
+
+static inline int get_swi_instruction(struct task_struct *task,
+				      struct pt_regs *regs,
+				      unsigned long *instr)
+{
+	struct page *page = NULL;
+	unsigned long instr_addr;
+	unsigned long *ptr;
+	int ret;
+
+	instr_addr = regs->ARM_pc - 4;
+
+	down_read(&task->mm->mmap_sem);
+	ret = get_user_pages(task, task->mm, instr_addr,
+			     1, 0, 0, &page, NULL);
+	up_read(&task->mm->mmap_sem);
+
+	if (ret < 0)
+		return ret;
+
+	ptr = (unsigned long *)kmap_atomic(page, KM_USER1);
+	memcpy(instr,
+	       ptr + (instr_addr >> PAGE_SHIFT),
+	       sizeof(unsigned long));
+	kunmap_atomic(ptr, KM_USER1);
+
+	page_cache_release(page);
+
+	return 0;
+}
+
+/*
+ * This function essentially duplicates the logic from vector_swi in
+ * arch/arm/kernel/entry-common.S. However, that code is in the
+ * critical path for system calls and is hard to factor out without
+ * compromising performance. 
+ */
+static inline int __syscall_get_nr(struct task_struct *task,
+				   struct pt_regs *regs)
+{
+	int ret;
+	int scno;
+	unsigned long instr;
+	bool config_oabi = false;
+	bool config_aeabi = false;
+	bool config_arm_thumb = false;
+	bool config_cpu_endian_be8 = false;
+
+#ifdef CONFIG_OABI_COMPAT
+	config_oabi = true;
+#endif
+#ifdef CONFIG_AEABI
+	config_aeabi = true;
+#endif
+#ifdef CONFIG_ARM_THUMB
+	config_arm_thumb = true;
+#endif
+#ifdef CONFIG_CPU_ENDIAN_BE8
+	config_cpu_endian_be8 = true;
+#endif
+#ifdef CONFIG_CPU_ARM710
+	return -1;
+#endif
+
+	if (config_aeabi && !config_oabi) {
+		/* Pure EABI */
+		return regs->ARM_r7;
+	} else if (config_oabi) {
+		if (config_arm_thumb && (regs->ARM_cpsr & PSR_T_BIT))
+			return -1;
+
+		ret = get_swi_instruction(task, regs, &instr);
+		if (ret < 0)
+			return -1;
+
+		if (config_cpu_endian_be8)
+			asm ("rev %[out], %[in]": [out] "=r" (instr):
+						  [in] "r" (instr));
+
+		if ((instr & 0x00ffffff) == 0)
+			return regs->ARM_r7; /* EABI call */
+		else
+			return (instr & 0x00ffffff) | __NR_OABI_SYSCALL_BASE;
+	} else {
+		 /* Legacy ABI only */
+		if (config_arm_thumb && (regs->ARM_cpsr & PSR_T_BIT)) {
+			/* Thumb mode ABI */
+			scno = regs->ARM_r7 + __NR_SYSCALL_BASE;
+		} else {
+			ret = get_swi_instruction(task, regs, &instr);
+			if (ret < 0)
+				return -1;
+			scno = instr;
+		}
+		return scno & 0x00ffffff;
+	}
+}
+
+static inline int syscall_get_nr(struct task_struct *task,
+				 struct pt_regs *regs)
+{
+	return __syscall_get_nr(task, regs);
+}
+
+static inline long syscall_get_return_value(struct task_struct *task,
+					    struct pt_regs *regs)
+{
+	return regs->ARM_r0;
+}
+
+static inline long syscall_get_error(struct task_struct *task,
+				     struct pt_regs *regs)
+{
+	return regs->ARM_r0;
+}
+
+#endif /* _ASM_ARM_SYSCALLS_H */
-- 
1.5.6.5

