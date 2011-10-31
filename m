Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934798Ab1KAAWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:22:37 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56443 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933935Ab1KAARs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:17:48 -0400
Message-Id: <093448$3uejsg@wolverine01.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6516"; a="132599696"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Mon, 31 Oct 2011 18:43:44 -0500
Subject: [PATCH v5 19/36] Hexagon: Add ptrace support
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Linas Vepstas <linas@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/hexagon/include/asm/ptrace.h |   35 +++++++
 arch/hexagon/kernel/ptrace.c      |  180 +++++++++++++++++++++++++++++++++++++
 2 files changed, 215 insertions(+), 0 deletions(-)
 create mode 100644 arch/hexagon/include/asm/ptrace.h
 create mode 100644 arch/hexagon/kernel/ptrace.c

diff --git a/arch/hexagon/include/asm/ptrace.h b/arch/hexagon/include/asm/ptrace.h
new file mode 100644
index 0000000..3d2f607
--- /dev/null
+++ b/arch/hexagon/include/asm/ptrace.h
@@ -0,0 +1,35 @@
+/*
+ * Ptrace definitions for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_PTRACE_H
+#define _ASM_PTRACE_H
+
+#include <asm/registers.h>
+
+#define instruction_pointer(regs) pt_elr(regs)
+#define user_stack_pointer(regs) ((regs)->r29)
+
+#define profile_pc(regs) instruction_pointer(regs)
+
+/* kprobe-based event tracer support */
+extern int regs_query_register_offset(const char *name);
+extern const char *regs_query_register_name(unsigned int offset);
+
+#endif
diff --git a/arch/hexagon/kernel/ptrace.c b/arch/hexagon/kernel/ptrace.c
new file mode 100644
index 0000000..bea3f08
--- /dev/null
+++ b/arch/hexagon/kernel/ptrace.c
@@ -0,0 +1,180 @@
+/*
+ * Ptrace support for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <generated/compile.h>
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/errno.h>
+#include <linux/ptrace.h>
+#include <linux/regset.h>
+#include <linux/user.h>
+
+#include <asm/system.h>
+#include <asm/user.h>
+
+static int genregs_get(struct task_struct *target,
+		   const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   void *kbuf, void __user *ubuf)
+{
+	int ret;
+	unsigned int dummy;
+	struct pt_regs *regs = task_pt_regs(target);
+
+
+	if (!regs)
+		return -EIO;
+
+	/* The general idea here is that the copyout must happen in
+	 * exactly the same order in which the userspace expects these
+	 * regs. Now, the sequence in userspace does not match the
+	 * sequence in the kernel, so everything past the 32 gprs
+	 * happens one at a time.
+	 */
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+				  &regs->r00, 0, 32*sizeof(unsigned long));
+
+#define ONEXT(KPT_REG, USR_REG) \
+	if (!ret) \
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, \
+			KPT_REG, offsetof(struct user_regs_struct, USR_REG), \
+			offsetof(struct user_regs_struct, USR_REG) + \
+				 sizeof(unsigned long));
+
+	/* Must be exactly same sequence as struct user_regs_struct */
+	ONEXT(&regs->sa0, sa0);
+	ONEXT(&regs->lc0, lc0);
+	ONEXT(&regs->sa1, sa1);
+	ONEXT(&regs->lc1, lc1);
+	ONEXT(&regs->m0, m0);
+	ONEXT(&regs->m1, m1);
+	ONEXT(&regs->usr, usr);
+	ONEXT(&regs->preds, p3_0);
+	ONEXT(&regs->gp, gp);
+	ONEXT(&regs->ugp, ugp);
+	ONEXT(&pt_elr(regs), pc);
+	dummy = pt_cause(regs);
+	ONEXT(&dummy, cause);
+	ONEXT(&pt_badva(regs), badva);
+
+	/* Pad the rest with zeros, if needed */
+	if (!ret)
+		ret = user_regset_copyout_zero(&pos, &count, &kbuf, &ubuf,
+					offsetof(struct user_regs_struct, pad1), -1);
+	return ret;
+}
+
+static int genregs_set(struct task_struct *target,
+		   const struct user_regset *regset,
+		   unsigned int pos, unsigned int count,
+		   const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+	unsigned long bucket;
+	struct pt_regs *regs = task_pt_regs(target);
+
+	if (!regs)
+		return -EIO;
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 &regs->r00, 0, 32*sizeof(unsigned long));
+
+#define INEXT(KPT_REG, USR_REG) \
+	if (!ret) \
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, \
+			KPT_REG, offsetof(struct user_regs_struct, USR_REG), \
+			offsetof(struct user_regs_struct, USR_REG) + \
+				sizeof(unsigned long));
+
+	/* Must be exactly same sequence as struct user_regs_struct */
+	INEXT(&regs->sa0, sa0);
+	INEXT(&regs->lc0, lc0);
+	INEXT(&regs->sa1, sa1);
+	INEXT(&regs->lc1, lc1);
+	INEXT(&regs->m0, m0);
+	INEXT(&regs->m1, m1);
+	INEXT(&regs->usr, usr);
+	INEXT(&regs->preds, p3_0);
+	INEXT(&regs->gp, gp);
+	INEXT(&regs->ugp, ugp);
+	INEXT(&pt_elr(regs), pc);
+
+	/* CAUSE and BADVA aren't writeable. */
+	INEXT(&bucket, cause);
+	INEXT(&bucket, badva);
+
+	/* Ignore the rest, if needed */
+	if (!ret)
+		ret = user_regset_copyin_ignore(&pos, &count, &kbuf, &ubuf,
+					offsetof(struct user_regs_struct, pad1), -1);
+
+	if (ret)
+		return ret;
+
+	/*
+	 * This is special; SP is actually restored by the VM via the
+	 * special event record which is set by the special trap.
+	 */
+	regs->hvmer.vmpsp = regs->r29;
+	return 0;
+}
+
+enum hexagon_regset {
+	REGSET_GENERAL,
+};
+
+static const struct user_regset hexagon_regsets[] = {
+	[REGSET_GENERAL] = {
+		.core_note_type = NT_PRSTATUS,
+		.n = ELF_NGREG,
+		.size = sizeof(unsigned long),
+		.align = sizeof(unsigned long),
+		.get = genregs_get,
+		.set = genregs_set,
+	},
+};
+
+static const struct user_regset_view hexagon_user_view = {
+	.name = UTS_MACHINE,
+	.e_machine = ELF_ARCH,
+	.ei_osabi = ELF_OSABI,
+	.regsets = hexagon_regsets,
+	.n = ARRAY_SIZE(hexagon_regsets)
+};
+
+const struct user_regset_view *task_user_regset_view(struct task_struct *task)
+{
+	return &hexagon_user_view;
+}
+
+void ptrace_disable(struct task_struct *child)
+{
+	/* Boilerplate - resolves to null inline if no HW single-step */
+	user_disable_single_step(child);
+}
+
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
+{
+	return ptrace_request(child, request, addr, data);
+}
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
