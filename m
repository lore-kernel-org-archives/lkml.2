Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2LRBIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:08:19 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:51089 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab2LRBIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:08:18 -0500
From: Simon Marchi <simon.marchi@polymtl.ca>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, Simon Marchi <simon.marchi@polymtl.ca>
Subject: [PATCH v3 1/3] arch/tile: implement user_regset interface on tile
Date: Mon, 17 Dec 2012 20:08:09 -0500
Message-Id: <1355792891-16145-1-git-send-email-simon.marchi@polymtl.ca>
X-Mailer: git-send-email 1.7.1
X-Poly-FromMTA: ([132.207.72.18]) at Tue, 18 Dec 2012 01:08:12 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a basic implementation of user_regset for the tile
architecture. It reuses the basic blocks that were already there.

Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
---
v2 included change for all tile architectures (not just tilegx)
v3 changed #include <uapi/arch/chip.h> to <arch/chip.h>

 arch/tile/kernel/ptrace.c |   62 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index b32bc3f..882e381 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -19,7 +19,10 @@
 #include <linux/kprobes.h>
 #include <linux/compat.h>
 #include <linux/uaccess.h>
+#include <linux/regset.h>
+#include <linux/elf.h>
 #include <asm/traps.h>
+#include <arch/chip.h>
 
 void user_enable_single_step(struct task_struct *child)
 {
@@ -80,6 +83,65 @@ static void putregs(struct task_struct *child, struct pt_regs *uregs)
 	*regs = *uregs;
 }
 
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
+	.name = CHIP_ARCH_NAME,
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
 long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
-- 
1.7.1

