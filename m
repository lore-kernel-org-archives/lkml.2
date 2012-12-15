Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab2LOEfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 23:35:06 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:47400 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab2LOEfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 23:35:04 -0500
From: Simon Marchi <simon.marchi@polymtl.ca>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, Simon Marchi <simon.marchi@polymtl.ca>
Subject: [PATCH 1/3] arch/tile: implement user_regset interface on tilegx
Date: Fri, 14 Dec 2012 23:34:49 -0500
Message-Id: <1355546091-32537-1-git-send-email-simon.marchi@polymtl.ca>
X-Mailer: git-send-email 1.7.1
X-Poly-FromMTA: ([132.207.72.18]) at Sat, 15 Dec 2012 04:34:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an implementation of user_regset for the tilegx architecture. It
reuses the basic blocks that were already there.

Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
---
I only tested these patches on a 3.0 kernel, as this is what my current
setup allows me. Some testing on more recent versions would be
appreciated, although I don't think the user_regset framework changed
much since then.

Also, I put some ifdefs so that these patches only affect tilegx and not
the older tile architectures, which I don't have access to. Hopefully
someone else can finish the work for those, it's probably not much.

 arch/tile/kernel/ptrace.c |   65 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index b32bc3f..0e68d06 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -19,6 +19,8 @@
 #include <linux/kprobes.h>
 #include <linux/compat.h>
 #include <linux/uaccess.h>
+#include <linux/regset.h>
+#include <linux/elf.h>
 #include <asm/traps.h>
 
 void user_enable_single_step(struct task_struct *child)
@@ -80,6 +82,69 @@ static void putregs(struct task_struct *child, struct pt_regs *uregs)
 	*regs = *uregs;
 }
 
+#ifdef __tilegx__
+
+enum tile_regset {
+	REGSET_GPR,
+};
+
+static int tile_gpr_get(struct task_struct *target,
+			  const struct user_regset *regset,
+			  unsigned int pos, unsigned int count,
+			  void *kbuf, void __user *ubuf)
+{
+	struct pt_regs regs;
+
+	getregs(target, &regs);
+
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, &regs, 0,
+				   sizeof(regs));
+}
+
+static int tile_gpr_set(struct task_struct *target,
+			  const struct user_regset *regset,
+			  unsigned int pos, unsigned int count,
+			  const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+	struct pt_regs regs;
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &regs, 0,
+				 sizeof(regs));
+	if (ret)
+		return ret;
+
+	putregs(target, &regs);
+
+	return 0;
+}
+
+static const struct user_regset tile_user_regset[] = {
+	[REGSET_GPR] = {
+		.core_note_type = NT_PRSTATUS,
+		.n = ELF_NGREG,
+		.size = sizeof(elf_greg_t),
+		.align = sizeof(elf_greg_t),
+		.get = tile_gpr_get,
+		.set = tile_gpr_set,
+	},
+};
+
+static const struct user_regset_view tile_user_regset_view = {
+	.name = "tilegx",
+	.e_machine = ELF_ARCH,
+	.ei_osabi = ELF_OSABI,
+	.regsets = tile_user_regset,
+	.n = ARRAY_SIZE(tile_user_regset),
+};
+
+const struct user_regset_view *task_user_regset_view(struct task_struct *task)
+{
+	return &tile_user_regset_view;
+}
+
+#endif /* __tilegx__ */
+
 long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
-- 
1.7.1

