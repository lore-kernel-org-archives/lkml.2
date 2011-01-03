Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab1ACLth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:49:37 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:45743 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab1ACLt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:49:29 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 2/8] unicore32 additional architecture files: float point unit
Date: Mon, 3 Jan 2011 19:49:28 +0800
Message-ID: <012701cbab3c$46d283e0$d4778ba0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcurPDhhF6QZ2mptTe+qkTEg3P2mmg==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

Patch 2 implements support for float point unit, which using UniCore-F64 FPU hardware
in UniCore32 ISA.

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/fpstate.h   |   41 ++
 arch/unicore32/include/asm/uc-f64.h    |   60 +++
 arch/unicore32/uc-f64/Makefile         |   13 +
 arch/unicore32/uc-f64/entry.S          |   33 ++
 arch/unicore32/uc-f64/f64_double_cmp.h |  245 ++++++++++
 arch/unicore32/uc-f64/f64_single_cmp.h |  245 ++++++++++
 arch/unicore32/uc-f64/f64double.c      |  758 +++++++++++++++++++++++++++++++
 arch/unicore32/uc-f64/f64hw.S          |  155 +++++++
 arch/unicore32/uc-f64/f64instr.h       |  101 +++++
 arch/unicore32/uc-f64/f64module.c      |  180 ++++++++
 arch/unicore32/uc-f64/f64single.c      |  771 ++++++++++++++++++++++++++++++++
 arch/unicore32/uc-f64/f64sint.c        |   94 ++++
 arch/unicore32/uc-f64/uc-f64.h         |  332 ++++++++++++++
 13 files changed, 3028 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/include/asm/fpstate.h b/arch/unicore32/include/asm/fpstate.h
new file mode 100644
index 0000000..818042a
--- /dev/null
+++ b/arch/unicore32/include/asm/fpstate.h
@@ -0,0 +1,41 @@
+/*
+ * linux/arch/unicore32/include/asm/fpstate.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __UNICORE_FPSTATE_H__
+#define __UNICORE_FPSTATE_H__
+
+
+#ifndef __ASSEMBLY__
+
+
+#define FP_HARD_SIZE 33
+
+struct fp_hard_struct {
+	unsigned int save[FP_HARD_SIZE];	/* as yet undefined */
+};
+
+#define FP_SOFT_SIZE 33
+
+struct fp_soft_struct {
+	unsigned int save[FP_SOFT_SIZE];	/* undefined information */
+};
+
+union fp_state {
+	struct fp_hard_struct	hard;
+	struct fp_soft_struct	soft;
+} __attribute__((aligned(8)));
+
+#define FP_SIZE (sizeof(union fp_state) / sizeof(int))
+
+#endif
+
+#endif
diff --git a/arch/unicore32/include/asm/uc-f64.h b/arch/unicore32/include/asm/uc-f64.h
new file mode 100644
index 0000000..1a7faf1
--- /dev/null
+++ b/arch/unicore32/include/asm/uc-f64.h
@@ -0,0 +1,60 @@
+/*
+ * linux/arch/unicore32/include/asm/uc-f64.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Based on:
+ *
+ * Contributors & Additions/Fixes:
+ *
+ * TODO:
+ */
+#define FPSCR			s31
+
+
+/* FPSCR bits */
+#define FPSCR_DEFAULT_NAN	(1<<25)
+
+#define FPSCR_CMPINSTR_BIT	(1<<31)
+
+#define FPSCR_CON		(1<<29)
+#define FPSCR_TRAP		(1<<27)
+
+/* RND mode */
+#define FPSCR_ROUND_NEAREST	(0<<0)
+#define FPSCR_ROUND_PLUSINF	(2<<0)
+#define FPSCR_ROUND_MINUSINF	(3<<0)
+#define FPSCR_ROUND_TOZERO	(1<<0)
+#define FPSCR_RMODE_BIT		(0)
+#define FPSCR_RMODE_MASK	(7 << FPSCR_RMODE_BIT)
+
+/* trap enable */
+#define FPSCR_IOE		(1<<16)
+#define FPSCR_OFE		(1<<14)
+#define FPSCR_UFE		(1<<13)
+#define FPSCR_IXE		(1<<12)
+#define FPSCR_HIE		(1<<11)
+#define FPSCR_NDE		(1<<10)	/* non denomal */
+
+/* flags */
+#define FPSCR_IDC		(1<<24)
+#define FPSCR_HIC		(1<<23)
+#define FPSCR_IXC		(1<<22)
+#define FPSCR_OFC		(1<<21)
+#define FPSCR_UFC		(1<<20)
+#define FPSCR_IOC		(1<<19)
+
+/* stick bits */
+#define FPSCR_IOS		(1<<9)
+#define FPSCR_OFS		(1<<7)
+#define FPSCR_UFS		(1<<6)
+#define FPSCR_IXS		(1<<5)
+#define FPSCR_HIS		(1<<4)
+#define FPSCR_NDS		(1<<3)	/*non denomal */
diff --git a/arch/unicore32/uc-f64/Makefile b/arch/unicore32/uc-f64/Makefile
new file mode 100644
index 0000000..ac33d55
--- /dev/null
+++ b/arch/unicore32/uc-f64/Makefile
@@ -0,0 +1,13 @@
+#
+# linux/arch/unicore32/uc-f64/Makefile
+#
+
+# EXTRA_CFLAGS := -DDEBUG
+# EXTRA_AFLAGS := -DDEBUG
+
+#AFLAGS			:=$(AFLAGS:-msoft-float=-Wa,-mfpu=softfpu)
+#LDFLAGS		+=--no-warn-mismatch
+
+obj-y			+= uc-f64.o
+
+uc-f64-$(CONFIG_UNICORE_FPU_F64)	+= f64module.o entry.o f64hw.o f64single.o f64double.o f64sint.o
diff --git a/arch/unicore32/uc-f64/entry.S b/arch/unicore32/uc-f64/entry.S
new file mode 100644
index 0000000..4991ca6
--- /dev/null
+++ b/arch/unicore32/uc-f64/entry.S
@@ -0,0 +1,33 @@
+/*
+ * linux/arch/unicore32/uc-f64/entry.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Basic entry code, called from the kernel's data abort trap.
+ *  r0  = faulted instruction
+ *  r19 = successful return
+ *  r20 = thread_info structure
+ *  lr  = failure return
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/thread_info.h>
+#include <generated/asm-offsets.h>
+
+ENTRY(do_uc_f64)
+	enable_irq r4
+	ldw	r4, .LC_f64
+	add	r20, r20, #TI_FPSTATE		@ r20 = workspace
+	ldw	pc, [r4]			@ call FP entry point
+ENDPROC(do_uc_f64)
+
+	.align	2
+.LC_f64:
+	.word	f64_vector
+
diff --git a/arch/unicore32/uc-f64/f64_double_cmp.h b/arch/unicore32/uc-f64/f64_double_cmp.h
new file mode 100644
index 0000000..ceda0d6
--- /dev/null
+++ b/arch/unicore32/uc-f64/f64_double_cmp.h
@@ -0,0 +1,245 @@
+/*
+ * linux/arch/unicore32/uc-f64/f64_double_cmp.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ * Fragments that appear the same as the files in arm vfp
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Compare operations for double format
+ */
+
+static u32 f64_double_fcf(int unused, int dd, int dm, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	return exceptions;
+}
+static u32 f64_double_fcun(int unused, int dd, int dm, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(dd, 0, dm, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if (FSTATUS(result) == FUOD)
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_double_fceq(int unused, int dd, int dm, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(dd, 0, dm, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if (FSTATUS(result) == FEQ)
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_double_fcueq(int unused, int dd, int dm, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(dd, 0, dm, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if ((FSTATUS(result) == FUOD) || (FSTATUS(result) == FEQ))
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_double_fcolt(int unused, int dd, int dm, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(dd, 0, dm, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if (FSTATUS(result) == FLT)
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_double_fcult(int unused, int dd, int dm, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(dd, 0, dm, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if ((FSTATUS(result) == FUOD) || (FSTATUS(result) == FLT))
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_double_fcole(int unused, int dd, int dm, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(dd, 0, dm, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if ((FSTATUS(result) == FLT) || (FSTATUS(result) == FEQ))
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_double_fcule(int unused, int dd, int dm, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(dd, 0, dm, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if ((FSTATUS(result) != FGT))
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+
+static u32 f64_double_fcsf(int unused, int dd, int dm, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	return exceptions;
+}
+static u32 f64_double_fcngle(int unused, int dd, int dm, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(dd, 1, dm, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if (FSTATUS(result) == FUOD)
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_double_fcseq(int unused, int dd, int dm, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(dd, 1, dm, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if (FSTATUS(result) == FEQ)
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_double_fcngl(int unused, int dd, int dm, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(dd, 1, dm, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if ((FSTATUS(result) == FUOD) || (FSTATUS(result) == FEQ))
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_double_fclt(int unused, int dd, int dm, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(dd, 1, dm, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if (FSTATUS(result) == FLT)
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_double_fcnge(int unused, int dd, int dm, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(dd, 1, dm, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if ((FSTATUS(result) == FUOD) || (FSTATUS(result) == FLT))
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_double_fcle(int unused, int dd, int dm, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(dd, 1, dm, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if ((FSTATUS(result) == FLT) || (FSTATUS(result) == FEQ))
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_double_fcngt(int unused, int dd, int dm, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(dd, 1, dm, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if ((FSTATUS(result) != FGT))
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static struct op f_cmp_ops[16] = {
+	[FFUNC_TO_IDX(FOP_FCF)]		= { f64_double_fcf,    OP_DD },
+	[FFUNC_TO_IDX(FOP_FCUN)]	= { f64_double_fcun,   OP_DD },
+	[FFUNC_TO_IDX(FOP_FCEQ)]	= { f64_double_fceq,   OP_DD },
+	[FFUNC_TO_IDX(FOP_FCUEQ)]	= { f64_double_fcueq,  OP_DD },
+	[FFUNC_TO_IDX(FOP_FCOLT)]	= { f64_double_fcolt,  OP_DD },
+	[FFUNC_TO_IDX(FOP_FCULT)]	= { f64_double_fcult,  OP_DD },
+	[FFUNC_TO_IDX(FOP_FCOLE)]	= { f64_double_fcole,  OP_DD },
+	[FFUNC_TO_IDX(FOP_FCUL)]	= { f64_double_fcule,  OP_DD },
+
+	[FFUNC_TO_IDX(FOP_FCSF)]	= { f64_double_fcsf,   OP_DD },
+	[FFUNC_TO_IDX(FOP_FCNGLE)]	= { f64_double_fcngle, OP_DD },
+	[FFUNC_TO_IDX(FOP_FCSEQ)]	= { f64_double_fcseq,  OP_DD },
+	[FFUNC_TO_IDX(FOP_FCNGL)]	= { f64_double_fcngl,  OP_DD },
+	[FFUNC_TO_IDX(FOP_FCLT)]	= { f64_double_fclt,   OP_DD },
+	[FFUNC_TO_IDX(FOP_FCNGE)]	= { f64_double_fcnge,  OP_DD },
+	[FFUNC_TO_IDX(FOP_FCLE)]	= { f64_double_fcle,   OP_DD },
+	[FFUNC_TO_IDX(FOP_FCNGT)]	= { f64_double_fcngt,  OP_DD },
+};
+
+u32 f64_double_mffcdo(u32 inst, u32 ff, struct pt_regs *regs)
+{
+	u32 op1 = (inst & FOP1_MASK) >> 26;
+	u32 func = (inst & FFUNC_MASK) >> 6;
+	u32 exceptions = 0;
+	u32 except;
+	s32 m;
+	char type;
+	unsigned int dest;
+	unsigned int dn = f64_get_dn(inst);
+	unsigned int dm = f64_get_dm(inst);
+	struct op *fop;
+
+	fop =  &f_cmp_ops[func];
+
+	if (!fop->fn)
+		goto invalid;
+
+	dest = f64_get_rd(inst);
+	m = f64_get_double(dm);
+
+	type = 'w';
+	pr_debug("UniCore-F64:  (%c%u) = (s%u) op1[%u] func[%u] (s%u=%08x)\n",
+		type, dest, dn,
+		op1, func, dm, m);
+
+	except = fop->fn(dest, dn, m, ff);
+
+	pr_debug("UniCore-F64: exceptions=%08x\n", except);
+	if (dest < 31)
+		regs->uregs[dest] = except & 0x20000000;
+	else {
+		if (except & 0x20000000) {
+			regs->uregs[32] &= 0x0fffffff;
+			regs->uregs[32] |= 0x20000000;
+		} else
+			regs->uregs[32] &= 0x0fffffff;
+	}
+
+	exceptions |= except;
+	return exceptions;
+
+ invalid:
+	return (u32)-1;
+}
diff --git a/arch/unicore32/uc-f64/f64_single_cmp.h b/arch/unicore32/uc-f64/f64_single_cmp.h
new file mode 100644
index 0000000..8797c6d
--- /dev/null
+++ b/arch/unicore32/uc-f64/f64_single_cmp.h
@@ -0,0 +1,245 @@
+/*
+ * linux/arch/unicore32/uc-f64/f64_single_cmp.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ * Fragments that appear the same as the files in arm vfp
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Compare operations for single format
+ */
+static u32 f64_single_fcf(int unused, int sd, s32 m, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	return exceptions;
+}
+static u32 f64_single_fcun(int unused, int sd, s32 m, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(sd, 0, m, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if (FSTATUS(result) == FUOD)
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_single_fceq(int unused, int sd, s32 m, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(sd, 0, m, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if (FSTATUS(result) == FEQ)
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_single_fcueq(int unused, int sd, s32 m, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(sd, 0, m, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if ((FSTATUS(result) == FUOD) || (FSTATUS(result) == FEQ))
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_single_fcolt(int unused, int sd, s32 m, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(sd, 0, m, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if (FSTATUS(result) == FLT)
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_single_fcult(int unused, int sd, s32 m, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(sd, 0, m, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if ((FSTATUS(result) == FUOD) || (FSTATUS(result) == FLT))
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_single_fcole(int unused, int sd, s32 m, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(sd, 0, m, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if ((FSTATUS(result) == FLT) || (FSTATUS(result) == FEQ))
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_single_fcule(int unused, int sd, s32 m, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(sd, 0, m, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if ((FSTATUS(result) != FGT))
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+
+static u32 f64_single_fcsf(int unused, int sd, s32 m, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	return exceptions;
+}
+static u32 f64_single_fcngle(int unused, int sd, s32 m, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(sd, 1, m, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if (FSTATUS(result) == FUOD)
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_single_fcseq(int unused, int sd, s32 m, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(sd, 1, m, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if (FSTATUS(result) == FEQ)
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_single_fcngl(int unused, int sd, s32 m, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(sd, 1, m, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if ((FSTATUS(result) == FUOD) || (FSTATUS(result) == FEQ))
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_single_fclt(int unused, int sd, s32 m, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(sd, 1, m, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if (FSTATUS(result) == FLT)
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_single_fcnge(int unused, int sd, s32 m, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(sd, 1, m, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if ((FSTATUS(result) == FUOD) || (FSTATUS(result) == FLT))
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_single_fcle(int unused, int sd, s32 m, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(sd, 1, m, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if ((FSTATUS(result) == FLT) || (FSTATUS(result) == FEQ))
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+static u32 f64_single_fcngt(int unused, int sd, s32 m, u32 fpscr)
+{
+	u32 exceptions = FPSCR_CMPINSTR_BIT;
+	u32 result;
+	result = f64_compare(sd, 1, m, fpscr);
+	if (result & FPSCR_IOC)
+		exceptions |= FPSCR_IOC;
+	if ((FSTATUS(result) != FGT))
+		exceptions |= FPSCR_CON;
+	return exceptions;
+}
+
+static struct op f_cmp_ops[16] = {
+	[FFUNC_TO_IDX(FOP_FCF)]		= { f64_single_fcf,    OP_SD },
+	[FFUNC_TO_IDX(FOP_FCUN)]	= { f64_single_fcun,   OP_SD },
+	[FFUNC_TO_IDX(FOP_FCEQ)]	= { f64_single_fceq,   OP_SD },
+	[FFUNC_TO_IDX(FOP_FCUEQ)]	= { f64_single_fcueq,  OP_SD },
+	[FFUNC_TO_IDX(FOP_FCOLT)]	= { f64_single_fcolt,  OP_SD },
+	[FFUNC_TO_IDX(FOP_FCULT)]	= { f64_single_fcult,  OP_SD },
+	[FFUNC_TO_IDX(FOP_FCOLE)]	= { f64_single_fcole,  OP_SD },
+	[FFUNC_TO_IDX(FOP_FCUL)]	= { f64_single_fcule,  OP_SD },
+
+	[FFUNC_TO_IDX(FOP_FCSF)]	= { f64_single_fcsf,   OP_SD },
+	[FFUNC_TO_IDX(FOP_FCNGLE)]	= { f64_single_fcngle, OP_SD },
+	[FFUNC_TO_IDX(FOP_FCSEQ)]	= { f64_single_fcseq,  OP_SD },
+	[FFUNC_TO_IDX(FOP_FCNGL)]	= { f64_single_fcngl,  OP_SD },
+	[FFUNC_TO_IDX(FOP_FCLT)]	= { f64_single_fclt,   OP_SD },
+	[FFUNC_TO_IDX(FOP_FCNGE)]	= { f64_single_fcnge,  OP_SD },
+	[FFUNC_TO_IDX(FOP_FCLE)]	= { f64_single_fcle,   OP_SD },
+	[FFUNC_TO_IDX(FOP_FCNGT)]	= { f64_single_fcngt,  OP_SD },
+};
+
+u32 f64_single_mffcdo(u32 inst, u32 ff, struct pt_regs *regs)
+{
+	u32 op1 = (inst & FOP1_MASK) >> 26;
+	u32 func = (inst & FFUNC_MASK) >> 6;
+	u32 exceptions = 0;
+	u32 except;
+	s32 m;
+	char type;
+	unsigned int dest;
+	unsigned int sn = f64_get_sn(inst);
+	unsigned int sm = f64_get_sm(inst);
+	struct op *fop;
+
+	fop =  &f_cmp_ops[func];
+
+	if (!fop->fn)
+		goto invalid;
+
+	dest = f64_get_rd(inst);
+	m = f64_get_float(sm);
+
+	type = 'w';
+	pr_debug("UniCore-F64:  (%c%u) = (s%u) op1[%u] func[%u] (s%u=%08x)\n",
+		type, dest, sn,
+		op1, func, sm, m);
+
+	except = fop->fn(dest, sn, m, ff);
+
+	pr_debug("UniCore-F64: exceptions=%08x\n", except);
+	if (dest < 31)
+		regs->uregs[dest] = except & 0x20000000;
+	else {
+		if (except & 0x20000000) {
+			regs->uregs[32] &= 0x0fffffff;
+			regs->uregs[32] |= 0x20000000;
+		} else
+			regs->uregs[32] &= 0x0fffffff;
+	}
+
+	exceptions |= except;
+	return exceptions;
+
+ invalid:
+	return (u32)-1;
+}
diff --git a/arch/unicore32/uc-f64/f64double.c b/arch/unicore32/uc-f64/f64double.c
new file mode 100644
index 0000000..454b5e6
--- /dev/null
+++ b/arch/unicore32/uc-f64/f64double.c
@@ -0,0 +1,758 @@
+/*
+ * linux/arch/unicore32/uc-f64/f64double.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ * Fragments that appear the same as the files in arm vfp
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This code is derived in part from John R. Housers softfloat library, which
+ * carries the following notice:
+ *
+ * ===========================================================================
+ * This C source file is part of the SoftFloat IEC/IEEE Floating-point
+ * Arithmetic Package, Release 2.
+ *
+ * Written by John R. Hauser.  This work was made possible in part by the
+ * International Computer Science Institute, located at Suite 600, 1947 Center
+ * Street, Berkeley, California 94704.  Funding was partially provided by the
+ * National Science Foundation under grant MIP-9311980.  The original version
+ * of this code was written as part of a project to build a fixed-point vector
+ * processor in collaboration with the University of California at Berkeley,
+ * overseen by Profs. Nelson Morgan and John Wawrzynek.  More information
+ * is available through the web page `http://HTTP.CS.Berkeley.EDU/~jhauser/
+ * arithmetic/softfloat.html'.
+ *
+ * THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable effort
+ * has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WILL AT
+ * TIMES RESULT IN INCORRECT BEHAVIOR.  USE OF THIS SOFTWARE IS RESTRICTED TO
+ * PERSONS AND ORGANIZATIONS WHO CAN AND WILL TAKE FULL RESPONSIBILITY FOR ANY
+ * AND ALL LOSSES, COSTS, OR OTHER PROBLEMS ARISING FROM ITS USE.
+ *
+ * Derivative works are acceptable, even for commercial purposes, so long as
+ * (1) they include prominent notice that the work is derivative, and (2) they
+ * include prominent notice akin to these three paragraphs for those parts of
+ * this code that are retained.
+ * ===========================================================================
+ */
+#include <linux/kernel.h>
+#include <linux/bitops.h>
+
+#include <asm/div64.h>
+#include <asm/uc-f64.h>
+
+#include "f64instr.h"
+#include "uc-f64.h"
+
+static struct f64_double f64_double_default_qnan = {
+	.exponent	= 2047,
+	.sign		= 0,
+	.significand	= F64_DOUBLE_SIGNIFICAND_QNAN,
+};
+
+static void f64_double_dump(const char *str, struct f64_double *d)
+{
+	pr_debug("UniCore-F64 %s: sign=%d exponent=%d significand=%016llx\n",
+		 str, d->sign != 0, d->exponent, d->significand);
+}
+
+static void f64_double_normalise_denormal(struct f64_double *vd)
+{
+	int bits = 31 - fls(vd->significand >> 32);
+	if (bits == 31)
+		bits = 63 - fls(vd->significand);
+
+	f64_double_dump("normalise_denormal: in", vd);
+
+	if (bits) {
+		vd->exponent -= bits - 1;
+		vd->significand <<= bits;
+	}
+
+	f64_double_dump("normalise_denormal: out", vd);
+}
+
+u32 f64_double_normaliseround(int dd, struct f64_double *vd, u32 fpscr,
+		u32 exceptions, const char *func)
+{
+	u64 significand, incr;
+	int exponent, shift, underflow;
+	u32 rmode;
+
+	f64_double_dump("pack: in", vd);
+
+	/*
+	 * Infinities and NaNs are a special case.
+	 */
+	if (vd->exponent == 2047 && (vd->significand == 0 || exceptions))
+		goto pack;
+
+	/*
+	 * Special-case zero.
+	 */
+	if (vd->significand == 0) {
+		vd->exponent = 0;
+		goto pack;
+	}
+
+	exponent = vd->exponent;
+	significand = vd->significand;
+
+	shift = 32 - fls(significand >> 32);
+	if (shift == 32)
+		shift = 64 - fls(significand);
+	if (shift) {
+		exponent -= shift;
+		significand <<= shift;
+	}
+
+#ifdef DEBUG
+	vd->exponent = exponent;
+	vd->significand = significand;
+	f64_double_dump("pack: normalised", vd);
+#endif
+
+	/*
+	 * Tiny number?
+	 */
+	underflow = exponent < 0;
+	if (underflow) {
+		significand = f64_shiftright64jamming(significand, -exponent);
+		exponent = 0;
+#ifdef DEBUG
+		vd->exponent = exponent;
+		vd->significand = significand;
+		f64_double_dump("pack: tiny number", vd);
+#endif
+		if (!(significand & ((1ULL << (F64_DOUBLE_LOW_BITS + 1)) - 1)))
+			underflow = 0;
+	}
+
+	/*
+	 * Select rounding increment.
+	 */
+	incr = 0;
+	rmode = fpscr & FPSCR_RMODE_MASK;
+
+	if (rmode == FPSCR_ROUND_NEAREST) {
+		incr = 1ULL << F64_DOUBLE_LOW_BITS;
+		if ((significand & (1ULL << (F64_DOUBLE_LOW_BITS + 1))) == 0)
+			incr -= 1;
+	} else if (rmode == FPSCR_ROUND_TOZERO) {
+		incr = 0;
+	} else if ((rmode == FPSCR_ROUND_PLUSINF) ^ (vd->sign != 0))
+		incr = (1ULL << (F64_DOUBLE_LOW_BITS + 1)) - 1;
+
+	pr_debug("UniCore-F64 rounding increment = 0x%08llx\n", incr);
+
+	/*
+	 * Is our rounding going to overflow?
+	 */
+	if ((significand + incr) < significand) {
+		exponent += 1;
+		significand = (significand >> 1) | (significand & 1);
+		incr >>= 1;
+#ifdef DEBUG
+		vd->exponent = exponent;
+		vd->significand = significand;
+		f64_double_dump("pack: overflow", vd);
+#endif
+	}
+
+	/*
+	 * If any of the low bits (which will be shifted out of the
+	 * number) are non-zero, the result is inexact.
+	 */
+	if (significand & ((1 << (F64_DOUBLE_LOW_BITS + 1)) - 1))
+		exceptions |= FPSCR_IXC;
+
+	/*
+	 * Do our rounding.
+	 */
+	significand += incr;
+
+	/*
+	 * Infinity?
+	 */
+	if (exponent >= 2046) {
+		exceptions |= FPSCR_OFC | FPSCR_IXC;
+		if (incr == 0) {
+			vd->exponent = 2045;
+			vd->significand = 0x7fffffffffffffffULL;
+		} else {
+			vd->exponent = 2047;		/* infinity */
+			vd->significand = 0;
+		}
+	} else {
+		if (significand >> (F64_DOUBLE_LOW_BITS + 1) == 0)
+			exponent = 0;
+		if (exponent || significand > 0x8000000000000000ULL)
+			underflow = 0;
+		if (underflow)
+			exceptions |= FPSCR_UFC;
+		vd->exponent = exponent;
+		vd->significand = significand >> 1;
+	}
+
+ pack:
+	f64_double_dump("pack: final", vd);
+	{
+		s64 d = f64_double_pack(vd);
+		pr_debug("UniCore-F64 %s: d(d%d)=%016llx exceptions=%08x\n",
+				func, dd, d, exceptions);
+		f64_put_double(d, dd);
+	}
+	return exceptions;
+}
+
+/*
+ * Propagate the NaN, setting exceptions if it is signalling.
+ * 'n' is always a NaN.  'm' may be a number, NaN or infinity.
+ */
+static u32
+f64_propagate_nan(struct f64_double *vdd, struct f64_double *vdn,
+		  struct f64_double *vdm, u32 fpscr)
+{
+	struct f64_double *nan;
+	int tn, tm = 0;
+
+	tn = f64_double_type(vdn);
+
+	if (vdm)
+		tm = f64_double_type(vdm);
+
+	if (fpscr & FPSCR_DEFAULT_NAN)
+		/*
+		 * Default NaN mode - always returns a quiet NaN
+		 */
+		nan = &f64_double_default_qnan;
+	else {
+		/*
+		 * Contemporary mode - select the first signalling
+		 * NAN, or if neither are signalling, the first
+		 * quiet NAN.
+		 */
+		if (tn == F64_SNAN || (tm != F64_SNAN && tn == F64_QNAN))
+			nan = vdn;
+		else
+			nan = vdm;
+		/*
+		 * Make the NaN quiet.
+		 */
+		nan->significand |= F64_DOUBLE_SIGNIFICAND_QNAN;
+	}
+
+	*vdd = *nan;
+
+	/*
+	 * If one was a signalling NAN, raise invalid operation.
+	 */
+	return tn == F64_SNAN || tm == F64_SNAN ? FPSCR_IOC : F64_NAN_FLAG;
+}
+
+/*
+ * Extended operations
+ */
+static u32 f64_double_fabs(int dd, int unused, int dm, u32 fpscr)
+{
+	f64_put_double(f64_double_packed_abs(f64_get_double(dm)), dd);
+	return 0;
+}
+
+static u32 f64_double_fneg(int dd, int unused, int dm, u32 fpscr)
+{
+	f64_put_double(f64_double_packed_negate(f64_get_double(dm)), dd);
+	return 0;
+}
+/*
+ * Equal	:= ZC
+ * Less than	:= N
+ * Greater than	:= C
+ * Unordered	:= CV
+ */
+static u32 f64_compare(int dd, int signal_on_qnan, int dm, u32 fpscr)
+{
+	s64 d, m;
+	u32 ret = 0;
+
+	m = f64_get_double(dm);
+	if (f64_double_packed_exponent(m) == 2047
+			&& f64_double_packed_mantissa(m)) {
+		ret |= FPSCR_C | FPSCR_V;
+		if (signal_on_qnan || !(f64_double_packed_mantissa(m)
+				& (1ULL << (F64_DOUBLE_MANTISSA_BITS - 1))))
+			/*
+			 * Signalling NaN, or signalling on quiet NaN
+			 */
+			ret |= FPSCR_IOC;
+	}
+
+	d = f64_get_double(dd);
+	if (f64_double_packed_exponent(d) == 2047
+			&& f64_double_packed_mantissa(d)) {
+		ret |= FPSCR_C | FPSCR_V;
+		if (signal_on_qnan || !(f64_double_packed_mantissa(d)
+				& (1ULL << (F64_DOUBLE_MANTISSA_BITS - 1))))
+			/*
+			 * Signalling NaN, or signalling on quiet NaN
+			 */
+			ret |= FPSCR_IOC;
+	}
+
+	if (ret == 0) {
+		if (d == m || f64_double_packed_abs(d | m) == 0) {
+			/*
+			 * equal
+			 */
+			ret |= FPSCR_Z | FPSCR_C;
+		} else if (f64_double_packed_sign(d ^ m)) {
+			/*
+			 * different signs
+			 */
+			if (f64_double_packed_sign(d))
+				/*
+				 * d is negative, so d < m
+				 */
+				ret |= FPSCR_N;
+			else
+				/*
+				 * d is positive, so d > m
+				 */
+				ret |= FPSCR_C;
+		} else if ((f64_double_packed_sign(d) != 0) ^ (d < m)) {
+			/*
+			 * d < m
+			 */
+			ret |= FPSCR_N;
+		} else if ((f64_double_packed_sign(d) != 0) ^ (d > m)) {
+			/*
+			 * d > m
+			 */
+			ret |= FPSCR_C;
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * Conversion operations
+ */
+static u32 f64_double_fcvts(int sd, int unused, int dm, u32 fpscr)
+{
+	struct f64_double vdm;
+	struct f64_single vsd;
+	int tm;
+	u32 exceptions = 0;
+
+	f64_double_unpack(&vdm, f64_get_double(dm));
+
+	tm = f64_double_type(&vdm);
+
+	/*
+	 * If we have a signalling NaN, signal invalid operation.
+	 */
+	if (tm == F64_SNAN)
+		exceptions = FPSCR_IOC;
+
+	if (tm & F64_DENORMAL)
+		f64_double_normalise_denormal(&vdm);
+
+	vsd.sign = vdm.sign;
+	vsd.significand = f64_hi64to32jamming(vdm.significand);
+
+	/*
+	 * If we have an infinity or a NaN, the exponent must be 255
+	 */
+	if (tm & (F64_INFINITY|F64_NAN)) {
+		vsd.exponent = 255;
+		if (tm == F64_QNAN)
+			vsd.significand |= F64_SINGLE_SIGNIFICAND_QNAN;
+		goto pack_nan;
+	} else if (tm & F64_ZERO)
+		vsd.exponent = 0;
+	else
+		vsd.exponent = vdm.exponent - (1023 - 127);
+
+	return f64_single_normaliseround(sd, &vsd, fpscr, exceptions, "fcvts");
+
+ pack_nan:
+	f64_put_float(f64_single_pack(&vsd), sd);
+	return exceptions;
+}
+static u32 f64_double_fcvtd(int dd, int unused, int dm, u32 fpscr)
+{
+	return 0;
+}
+static u32 f64_double_ftosi(int sd, int unused, int dm, u32 fpscr)
+{
+	struct f64_double vdm;
+	u32 d, exceptions = 0;
+	int rmode = fpscr & FPSCR_RMODE_MASK;
+	int tm;
+
+	f64_double_unpack(&vdm, f64_get_double(dm));
+	f64_double_dump("VDM", &vdm);
+
+	/*
+	 * Do we have denormalised number?
+	 */
+	tm = f64_double_type(&vdm);
+	if (tm & F64_DENORMAL)
+		exceptions |= FPSCR_IDC;
+
+	if (tm & F64_NAN) {
+		d = 0;
+		exceptions |= FPSCR_IOC;
+	} else if (vdm.exponent >= 1023 + 32) {
+		d = 0x7fffffff;
+		if (vdm.sign)
+			d = ~d;
+		exceptions |= FPSCR_IOC;
+	} else if (vdm.exponent >= 1023 - 1) {
+		int shift = 1023 + 63 - vdm.exponent;	/* 58 */
+		u64 rem, incr = 0;
+
+		d = (vdm.significand << 1) >> shift;
+		rem = vdm.significand << (65 - shift);
+
+		if (rmode == FPSCR_ROUND_NEAREST) {
+			incr = 0x8000000000000000ULL;
+			if ((d & 1) == 0)
+				incr -= 1;
+		} else if (rmode == FPSCR_ROUND_TOZERO) {
+			incr = 0;
+		} else if ((rmode == FPSCR_ROUND_PLUSINF) ^ (vdm.sign != 0)) {
+			incr = ~0ULL;
+		}
+
+		if ((rem + incr) < rem && d < 0xffffffff)
+			d += 1;
+		if (d > 0x7fffffff + (vdm.sign != 0)) {
+			d = 0x7fffffff + (vdm.sign != 0);
+			exceptions |= FPSCR_IOC;
+		} else if (rem)
+			exceptions |= FPSCR_IXC;
+
+		if (vdm.sign)
+			d = -d;
+	} else {
+		d = 0;
+		if (vdm.exponent | vdm.significand) {
+			exceptions |= FPSCR_IXC;
+			if (rmode == FPSCR_ROUND_PLUSINF && vdm.sign == 0)
+				d = 1;
+			else if (rmode == FPSCR_ROUND_MINUSINF && vdm.sign)
+				d = -1;
+		}
+	}
+
+	pr_debug("UniCore-F64 ftosi: d(s%d)=%08x exceptions=%08x\n",
+			sd, d, exceptions);
+
+	f64_put_float((s32)d, sd);
+
+	return exceptions;
+}
+static struct op f_conv_ops[16] = {
+	[FFUNC_TO_IDX(FOP_FCVTS)]	= { f64_double_fcvts,  OP_SD },
+	[FFUNC_TO_IDX(FOP_FCVTD)]	= { f64_double_fcvtd,  OP_DD },
+	[FFUNC_TO_IDX(FOP_FCVTW)]	= { f64_double_ftosi,  OP_SD },
+};
+static u32
+f64_double_fadd_nonnumber(struct f64_double *vdd, struct f64_double *vdn,
+			  struct f64_double *vdm, u32 fpscr)
+{
+	struct f64_double *vdp;
+	u32 exceptions = 0;
+	int tn, tm;
+
+	tn = f64_double_type(vdn);
+	tm = f64_double_type(vdm);
+
+	if (tn & tm & F64_INFINITY) {
+		/*
+		 * Two infinities.  Are they different signs?
+		 */
+		if (vdn->sign ^ vdm->sign) {
+			/*
+			 * different signs -> invalid
+			 */
+			exceptions = FPSCR_IOC;
+			vdp = &f64_double_default_qnan;
+		} else {
+			/*
+			 * same signs -> valid
+			 */
+			vdp = vdn;
+		}
+	} else if (tn & F64_INFINITY && tm & F64_NUMBER) {
+		/*
+		 * One infinity and one number -> infinity
+		 */
+		vdp = vdn;
+	} else {
+		/*
+		 * 'n' is a NaN of some type
+		 */
+		return f64_propagate_nan(vdd, vdn, vdm, fpscr);
+	}
+	*vdd = *vdp;
+	return exceptions;
+}
+
+static u32
+f64_double_add(struct f64_double *vdd, struct f64_double *vdn,
+	       struct f64_double *vdm, u32 fpscr)
+{
+	u32 exp_diff;
+	u64 m_sig;
+
+	if (vdn->significand & (1ULL << 63) ||
+	    vdm->significand & (1ULL << 63)) {
+		pr_info("UniCore-F64 bad FP values in %s\n", __func__);
+		f64_double_dump("VDN", vdn);
+		f64_double_dump("VDM", vdm);
+	}
+
+	/*
+	 * Ensure that 'n' is the largest magnitude number.  Note that
+	 * if 'n' and 'm' have equal exponents, we do not swap them.
+	 * This ensures that NaN propagation works correctly.
+	 */
+	if (vdn->exponent < vdm->exponent) {
+		struct f64_double *t = vdn;
+		vdn = vdm;
+		vdm = t;
+	}
+
+	/*
+	 * Is 'n' an infinity or a NaN?  Note that 'm' may be a number,
+	 * infinity or a NaN here.
+	 */
+	if (vdn->exponent == 2047)
+		return f64_double_fadd_nonnumber(vdd, vdn, vdm, fpscr);
+
+	/*
+	 * We have two proper numbers, where 'vdn' is the larger magnitude.
+	 *
+	 * Copy 'n' to 'd' before doing the arithmetic.
+	 */
+	*vdd = *vdn;
+
+	/*
+	 * Align 'm' with the result.
+	 */
+	exp_diff = vdn->exponent - vdm->exponent;
+	m_sig = f64_shiftright64jamming(vdm->significand, exp_diff);
+
+	/*
+	 * If the signs are different, we are really subtracting.
+	 */
+	if (vdn->sign ^ vdm->sign) {
+		m_sig = vdn->significand - m_sig;
+		if ((s64)m_sig < 0) {
+			vdd->sign = f64_sign_negate(vdd->sign);
+			m_sig = -m_sig;
+		} else if (m_sig == 0) {
+			vdd->sign = (fpscr & FPSCR_RMODE_MASK) ==
+				      FPSCR_ROUND_MINUSINF ? 0x8000 : 0;
+		}
+	} else {
+		m_sig += vdn->significand;
+	}
+	vdd->significand = m_sig;
+
+	return 0;
+}
+
+static u32
+f64_double_multiply(struct f64_double *vdd, struct f64_double *vdn,
+		    struct f64_double *vdm, u32 fpscr)
+{
+	f64_double_dump("VDN", vdn);
+	f64_double_dump("VDM", vdm);
+
+	/*
+	 * Ensure that 'n' is the largest magnitude number.  Note that
+	 * if 'n' and 'm' have equal exponents, we do not swap them.
+	 * This ensures that NaN propagation works correctly.
+	 */
+	if (vdn->exponent < vdm->exponent) {
+		struct f64_double *t = vdn;
+		vdn = vdm;
+		vdm = t;
+		pr_debug("UniCore-F64 swapping M <-> N\n");
+	}
+
+	vdd->sign = vdn->sign ^ vdm->sign;
+
+	/*
+	 * If 'n' is an infinity or NaN, handle it.  'm' may be anything.
+	 */
+	if (vdn->exponent == 2047) {
+		if (vdn->significand || (vdm->exponent == 2047
+				&& vdm->significand))
+			return f64_propagate_nan(vdd, vdn, vdm, fpscr);
+		if ((vdm->exponent | vdm->significand) == 0) {
+			*vdd = f64_double_default_qnan;
+			return FPSCR_IOC;
+		}
+		vdd->exponent = vdn->exponent;
+		vdd->significand = 0;
+		return 0;
+	}
+
+	/*
+	 * If 'm' is zero, the result is always zero.  In this case,
+	 * 'n' may be zero or a number, but it doesn't matter which.
+	 */
+	if ((vdm->exponent | vdm->significand) == 0) {
+		vdd->exponent = 0;
+		vdd->significand = 0;
+		return 0;
+	}
+
+	/*
+	 * We add 2 to the destination exponent for the same reason
+	 * as the addition case - though this time we have +1 from
+	 * each input operand.
+	 */
+	vdd->exponent = vdn->exponent + vdm->exponent - 1023 + 2;
+	vdd->significand = f64_hi64multiply64(vdn->significand,
+			vdm->significand);
+
+	f64_double_dump("VDD", vdd);
+	return 0;
+}
+/*
+ * Standard operations
+ */
+
+/*
+ * sd = sn * sm
+ */
+static u32 f64_double_fmul(int dd, int dn, int dm, u32 fpscr)
+{
+	struct f64_double vdd, vdn, vdm;
+	u32 exceptions;
+
+	f64_double_unpack(&vdn, f64_get_double(dn));
+	if (vdn.exponent == 0 && vdn.significand)
+		f64_double_normalise_denormal(&vdn);
+
+	f64_double_unpack(&vdm, f64_get_double(dm));
+	if (vdm.exponent == 0 && vdm.significand)
+		f64_double_normalise_denormal(&vdm);
+
+	exceptions = f64_double_multiply(&vdd, &vdn, &vdm, fpscr);
+	return f64_double_normaliseround(dd, &vdd, fpscr, exceptions, "fmul");
+}
+/*
+ * sd = sn + sm
+ */
+static u32 f64_double_fadd(int dd, int dn, int dm, u32 fpscr)
+{
+	struct f64_double vdd, vdn, vdm;
+	u32 exceptions;
+
+	f64_double_unpack(&vdn, f64_get_double(dn));
+	if (vdn.exponent == 0 && vdn.significand)
+		f64_double_normalise_denormal(&vdn);
+
+	f64_double_unpack(&vdm, f64_get_double(dm));
+	if (vdm.exponent == 0 && vdm.significand)
+		f64_double_normalise_denormal(&vdm);
+
+	exceptions = f64_double_add(&vdd, &vdn, &vdm, fpscr);
+
+	return f64_double_normaliseround(dd, &vdd, fpscr, exceptions, "fadd");
+}
+
+/*
+ * sd = sn - sm
+ */
+static u32 f64_double_fsub(int dd, int dn, int dm, u32 fpscr)
+{
+	struct f64_double vdd, vdn, vdm;
+	u32 exceptions;
+
+	f64_double_unpack(&vdn, f64_get_double(dn));
+	if (vdn.exponent == 0 && vdn.significand)
+		f64_double_normalise_denormal(&vdn);
+
+	f64_double_unpack(&vdm, f64_get_double(dm));
+	if (vdm.exponent == 0 && vdm.significand)
+		f64_double_normalise_denormal(&vdm);
+
+	/*
+	 * Subtraction is like addition, but with a negated operand.
+	 */
+	vdm.sign = f64_sign_negate(vdm.sign);
+
+	exceptions = f64_double_add(&vdd, &vdn, &vdm, fpscr);
+
+	return f64_double_normaliseround(dd, &vdd, fpscr, exceptions, "fsub");
+}
+static struct op f_arith_ops[16] = {
+	[FFUNC_TO_IDX(FOP_FABS)]	= { f64_double_fabs,  OP_DD },
+	[FFUNC_TO_IDX(FOP_FMUL)]	= { f64_double_fmul,  OP_DD },
+	[FFUNC_TO_IDX(FOP_FADD)]	= { f64_double_fadd,  OP_DD },
+	[FFUNC_TO_IDX(FOP_FSUB)]	= { f64_double_fsub,  OP_DD },
+	[FFUNC_TO_IDX(FOP_FNEG)]	= { f64_double_fneg,  OP_DD },
+};
+
+
+#include "f64_double_cmp.h"
+
+u32 f64_double_cpdo(u32 inst, u32 fpscr)
+{
+	u32 op1 = (inst & FOP1_MASK) >> 26;
+	u32 func = (inst & FFUNC_MASK) >> 6;
+	u32 exceptions = 0;
+	u32 except;
+	char type;
+	unsigned int dest;
+	unsigned int dn = f64_get_dn(inst);
+	unsigned int dm = f64_get_dm(inst);
+	struct op *fop;
+
+	switch (op1) {
+	case 0:
+		fop = &f_arith_ops[func];
+		break;
+	case 2:
+		fop = &f_conv_ops[func];
+		break;
+	case 3:
+		fop = &f_cmp_ops[func];
+		break;
+	default:
+		goto  invalid;
+	}
+
+	if (!fop->fn)
+		goto invalid;
+
+	if (fop->flags & OP_SD)
+		dest = f64_get_sd(inst);
+	else
+		dest = f64_get_dd(inst);
+
+	type = fop->flags & OP_SD ? 's' : 'd';
+	pr_debug("UniCore-F64  (%c%u) = (d%u) op1[%u] func[%u] (d%u)\n",
+			type, dest, dn, op1, func, dm);
+
+	except = fop->fn(dest, dn, dm, fpscr);
+	pr_debug("UniCore-F64 exceptions=%08x\n", except);
+
+	exceptions |= except;
+	return exceptions;
+
+ invalid:
+	return (u32)-1;
+}
diff --git a/arch/unicore32/uc-f64/f64hw.S b/arch/unicore32/uc-f64/f64hw.S
new file mode 100644
index 0000000..5388999
--- /dev/null
+++ b/arch/unicore32/uc-f64/f64hw.S
@@ -0,0 +1,155 @@
+/*
+ * linux/arch/unicore32/uc-f64/f64hw.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ * Fragments that appear the same as the files in arm vfp
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This code is called from the kernel's data abort trap.
+ * r19 holds the return address for successful handling.
+ * lr holds the return address for unrecognised instructions.
+ * r20 points at the start of the private FP workspace in the thread structure
+ * sp points to a struct pt_regs (as defined in include/asm/proc/ptrace.h)
+ */
+#include <linux/linkage.h>
+#include <asm/thread_info.h>
+
+#undef DEBUG
+	.macro	DBGSTR, str
+#ifdef DEBUG
+	stm.w	(r0-r3), [sp-]
+	stm.w	(ip, lr), [sp-]
+	add	r0, pc, #8
+	b.l	printk
+	b	1f
+	.asciz  "<7>UniCore-F64: \str\n"
+	.balign 4
+1:	ldm.w	(ip, lr), [sp]+
+	ldm.w	(r0-r3), [sp]+
+#endif
+	.endm
+
+	.macro  DBGSTR1, str, arg
+#ifdef DEBUG
+	stm.w	(r0-r3), [sp-]
+	stm.w	(ip, lr), [sp-]
+	mov	r1, \arg
+	add	r0, pc, #8
+	b.l	printk
+	b	1f
+	.asciz  "<7>UniCore-F64: \str\n"
+	.balign 4
+1:	ldm.w	(ip, lr), [sp]+
+	ldm.w	(r0-r3), [sp]+
+#endif
+	.endm
+
+	.macro  DBGSTR3, str, arg1, arg2, arg3
+#ifdef DEBUG
+	stm.w	(r0-r3), [sp-]
+	stm.w	(ip, lr), [sp-]
+	mov	r3, \arg3
+	mov	r2, \arg2
+	mov	r1, \arg1
+	add	r0, pc, #8
+	b.l	printk
+	b	1f
+	.asciz  "<7>UniCore-F64: \str\n"
+	.balign 4
+1:	ldm.w	(ip, lr), [sp]+
+	ldm.w	(r0-r3), [sp]+
+#endif
+	.endm
+
+
+@ F64 hardware support entry point.
+@
+@  r0  = faulted instruction
+@  r2  = faulted PC
+@  r19 = successful return
+@  r20 = fp_state union
+@  lr  = failure return
+
+ENTRY(f64_support_entry)
+	DBGSTR3	"instr %08x pc %08x state %p", r0, r2, r20
+
+	cff	r1, s31			@ get fpu FPSCR
+	DBGSTR1	"fpscr %08x", r1
+	andn    r2, r1, #0x08000000
+	ctf     r2, s31			@ clear 27 bit
+process_exception:
+	DBGSTR	"bounce"
+	mov	r2, sp			@ nothing stacked - regdump is at TOS
+	mov	lr, r19			@ setup for a return to the user code.
+
+	@ Now call the C code to package up the bounce to the support code
+	@   r0 holds the trigger instruction
+	@   r1 holds the FPSCR value
+	@   r2 pointer to register dump
+	b	F64_bounce		@ we have handled this - the support
+					@ code will raise an exception if
+					@ required. If not, the user code will
+					@ retry the faulted instruction
+ENDPROC(f64_support_entry)
+
+	.macro	tbl_branch, base, shift
+	add	pc, pc, \base << \shift
+	.endm
+
+ENTRY(f64_get_float)
+	tbl_branch	r0, #3
+	.irp	dr,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+1:	mff	r0, f\dr
+	mov	pc, lr
+	.org	1b + 8
+	.endr
+ENDPROC(f64_get_float)
+
+ENTRY(f64_put_float)
+	tbl_branch	r1, #3
+	.irp	dr,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+1:	mtf	r0, f\dr
+	mov	pc, lr
+	.org	1b + 8
+	.endr
+ENDPROC(f64_put_float)
+
+ENTRY(f64_get_double)
+	tbl_branch	r0, #3
+	.irp	dr 1,3,4,7,9,11,13,15,17,19,21,23,25,27,29,31
+1:	mtf	r1, f\dr
+	b	100f
+	.org	1b + 8
+	.endr
+100:	tbl_branch	r0, #3
+	.irp	dr,0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30
+1:	mtf	r0, f\dr
+	mov	pc, lr
+	.org	1b + 8
+	.endr
+
+	@ virtual register 16 for compare with zero
+	mov	r0, #0
+	mov	r1, #0
+	mov	pc, lr
+ENDPROC(f64_get_double)
+
+ENTRY(f64_put_double)
+	tbl_branch	r2, #3
+	.irp	dr,0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30
+1:	mtf	r0, f\dr
+	b	100f
+	.org	1b + 8
+	.endr
+100:	tbl_branch	r2, #3
+	.irp	dr 1,3,4,7,9,11,13,15,17,19,21,23,25,27,29,31
+1:	mtf	r1, f\dr
+	mov	pc, lr
+	.org	1b + 8
+	.endr
+ENDPROC(f64_put_double)
diff --git a/arch/unicore32/uc-f64/f64instr.h b/arch/unicore32/uc-f64/f64instr.h
new file mode 100644
index 0000000..8355705
--- /dev/null
+++ b/arch/unicore32/uc-f64/f64instr.h
@@ -0,0 +1,101 @@
+/*
+ * linux/arch/unicore32/uc-f64/f64instr.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ * Fragments that appear the same as the files in arm vfp
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * UniCore-F64 instruction masks.
+ */
+#define INST_CPRTDO(inst)	(((inst) & 0xf0000000) == 0xe0000000)
+#define INST_CPRT_DP(inst)		((inst) & (1 << 5))
+#define INST_CPNUM(inst)	((inst) & 0x00003c00)
+#define CPNUM(cp)		((cp) << 10)
+
+#define FOP1_MASK	(0x0c000000)
+#define FFUNC_MASK	(0x000003c0)
+
+#define FOP_FADD	(0x00000000)
+#define FOP_FSUB	(0x00000040)
+#define FOP_FMUL	(0x00000080)
+#define FOP_FABS	(0x00000140)
+#define FOP_FNEG	(0x000001c0)
+
+#define FOP_FCVTS	(0x08000000)
+#define FOP_FCVTD	(0x08000040)
+#define FOP_FCVTW	(0x08000100)
+
+#define FOP_FCF		(0x0c000000)
+#define FOP_FCUN	(0x0c000040)
+#define FOP_FCEQ	(0x0c000080)
+#define FOP_FCUEQ	(0x0c0000c0)
+#define FOP_FCOLT	(0x0c000100)
+#define FOP_FCULT	(0x0c000140)
+#define FOP_FCOLE	(0x0c000180)
+#define FOP_FCUL	(0x0c0001c0)
+#define FOP_FCSF	(0x0c000200)
+#define FOP_FCNGLE	(0x0c000240)
+#define FOP_FCSEQ	(0x0c000280)
+#define FOP_FCNGL	(0x0c0002c0)
+#define FOP_FCLT	(0x0c000300)
+#define FOP_FCNGE	(0x0c000340)
+#define FOP_FCLE	(0x0c000380)
+#define FOP_FCNGT	(0x0c0003c0)
+
+#define FFUNC_TO_IDX(inst)	((inst & (0x000003c0)) >> 6)
+
+#define f64_get_sd(inst)	((inst & 0x0007c000) >> 14)
+#define f64_get_dd(inst)	((f64_get_sd(inst)) >> 1)
+#define f64_get_sm(inst)	((inst & 0x0000001f))
+#define f64_get_dm(inst)	((f64_get_sm(inst)) >> 1)
+#define f64_get_sn(inst)	((inst & 0x00f80000) >> 19)
+#define f64_get_dn(inst)	((f64_get_sn(inst)) >> 1)
+#define f64_get_rd(inst)	((inst & 0x0007c000) >> 14)
+
+#define f64_get_fmt(inst)	((inst & 0x03000000) >> 24)
+#define f64_get_mffc_fmt(inst)	((inst & 0x04000000) >> 26)
+
+#define f64_single(inst)	(((inst) & 0x03000000) == 0x00000000)
+
+#define FPSCR_N	(1 << 31)
+#define FPSCR_Z	(1 << 30)
+#define FPSCR_C (1 << 29)
+#define FPSCR_V	(1 << 28)
+
+#define FSTATUS(except)		((except & (0xc0000000)) >> 28 | \
+				(except & (0x10000000)) >> 27 | \
+				(except & (0x04000000)) >> 26)
+#define FGT	(0x2)
+#define FUOD	(0x3)
+#define FEQ	(0x6)
+#define FLT	(0x8)
+
+/*
+ * Since we aren't building with -mfpu=f64, we need to code
+ * these instructions using their MRC/MCR equivalents.
+ */
+#define f64reg(_f64_) #_f64_
+
+#define cff(_f64_) ({			\
+	u32 __v;			\
+	asm("cff %0, " f64reg(_f64_) "@ fmrx	%0, " #_f64_	\
+	    : "=r" (__v) : : "cc");	\
+	__v;				\
+	})
+
+#define ctf(_f64_, _var_)		\
+	asm("ctf %0, " f64reg(_f64_) "@ fmxr	" #_f64_ ", %0"	\
+	   : : "r" (_var_) : "cc")
+
+u32 f64_single_cpdo(u32 inst, u32 fpscr);
+u32 f64_single_mffcdo(u32 inst, u32 ff, struct pt_regs *regs);
+
+u32 f64_sint_cpdo(u32 inst, u32 fpscr);
+
+u32 f64_double_cpdo(u32 inst, u32 fpscr);
+u32 f64_double_mffcdo(u32 inst, u32 ff, struct pt_regs *regs);
diff --git a/arch/unicore32/uc-f64/f64module.c b/arch/unicore32/uc-f64/f64module.c
new file mode 100644
index 0000000..bba5624
--- /dev/null
+++ b/arch/unicore32/uc-f64/f64module.c
@@ -0,0 +1,180 @@
+/*
+ * linux/arch/unicore32/uc-f64/f64module.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ * Fragments that appear the same as the files in arm vfp
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/init.h>
+
+#include <asm/uc-f64.h>
+#include "f64instr.h"
+#include "uc-f64.h"
+
+void (*f64_vector)(void) = f64_support_entry;
+
+/*
+ * Raise a SIGFPE for the current process.
+ * sicode describes the signal being raised.
+ */
+void f64_raise_sigfpe(unsigned int sicode, struct pt_regs *regs)
+{
+	siginfo_t info;
+
+	memset(&info, 0, sizeof(info));
+
+	info.si_signo = SIGFPE;
+	info.si_code = sicode;
+	info.si_addr = (void __user *)(instruction_pointer(regs) - 4);
+
+	/*
+	 * This is the same as NWFPE, because it's not clear what
+	 * this is used for
+	 */
+	current->thread.error_code = 0;
+	current->thread.trap_no = 6;
+
+	send_sig_info(SIGFPE, &info, current);
+}
+
+static void f64_panic(char *reason, u32 inst)
+{
+	int i;
+
+	printk(KERN_ERR "UniCore-F64 Error: %s\n", reason);
+	printk(KERN_ERR "UniCore-F64 FPSCR 0x%08x INST 0x%08x\n",
+		cff(FPSCR), inst);
+	for (i = 0; i < 32; i += 2)
+		printk(KERN_ERR "UniCore-F64 s%2u: 0x%08x s%2u: 0x%08x\n",
+		       i, f64_get_float(i), i+1, f64_get_float(i+1));
+}
+
+/*
+ * Process bitmask of exception conditions.
+ */
+static void f64_raise_exceptions(u32 exceptions, u32 inst, u32 fpscr,
+		struct pt_regs *regs)
+{
+	if (exceptions & FPSCR_CMPINSTR_BIT) {
+		if (exceptions & FPSCR_CON)
+			fpscr |= FPSCR_CON;
+		else
+			fpscr &= ~(FPSCR_CON);
+		exceptions &= ~(FPSCR_CMPINSTR_BIT | FPSCR_CON);
+	} else
+		pr_debug("UniCore-F64 raising exceptions %08x\n", exceptions);
+
+	if (exceptions == F64_EXCEPTION_ERROR) {
+		f64_panic("unhandled bounce", inst);
+		f64_raise_sigfpe(0, regs);
+		return;
+	}
+
+	/*
+	 * Update the FPSCR with the additional exception flags.
+	 * Comparison instructions always return at least one of
+	 * these flags set.
+	 */
+	fpscr &= ~(FPSCR_TRAP | FPSCR_IOS | FPSCR_OFS | FPSCR_UFS |
+			FPSCR_IXS | FPSCR_HIS | FPSCR_IOC | FPSCR_OFC |
+			FPSCR_UFC | FPSCR_IXC | FPSCR_HIC);
+
+	fpscr |= exceptions;
+	ctf(FPSCR, fpscr);
+}
+/*
+ * Emulate a F64 instruction.
+ */
+static u32 f64_emulate_instruction(u32 inst, u32 fpscr, struct pt_regs *regs)
+{
+	u32 exceptions = F64_EXCEPTION_ERROR;
+	u32 fmt = f64_get_fmt(inst);
+
+	pr_debug("UniCore-F64 emulate: INST=0x%08x SCR=0x%08x\n", inst, fpscr);
+
+	if (INST_CPRTDO(inst)) {
+		if (INST_CPRT_DP(inst)) {
+			/*
+			 * CPDO
+			 */
+			switch (fmt) {
+			case 0:
+				exceptions = f64_single_cpdo(inst, fpscr);
+				break;
+			case 1:
+				exceptions = f64_double_cpdo(inst, fpscr);
+				break;
+			case 2:
+				exceptions = f64_sint_cpdo(inst, fpscr);
+				break;
+			default:
+				return exceptions;
+			}
+		} else {
+			/* deal with MFFC */
+			fmt = f64_get_mffc_fmt(inst);
+			switch (fmt) {
+			case 0:
+				exceptions = f64_single_mffcdo(inst, fpscr,
+						regs);
+				break;
+			case 1:
+				exceptions = f64_double_mffcdo(inst, fpscr,
+						regs);
+				break;
+			default:
+				return exceptions;
+			}
+		}
+	} else {
+		/*
+		 * A CPDT instruction can not cause an exception.
+		 * Therefore, we do not have to emulate it.
+		 */
+	}
+
+	return exceptions & ~F64_NAN_FLAG;
+}
+/*
+ * Package up a bounce condition.
+ */
+void F64_bounce(u32 trigger, u32 fpexc, struct pt_regs *regs)
+{
+	u32  exceptions;
+	u32  orig_fpscr = fpexc;
+	pr_debug("UniCore-F64: bounce: trigger %08x fpscr %08x\n",
+			trigger, fpexc);
+	/* emulate the inst */
+	exceptions = f64_emulate_instruction(trigger, orig_fpscr, regs);
+	if (exceptions)
+		f64_raise_exceptions(exceptions, trigger, orig_fpscr, regs);
+}
+
+#include <linux/smp.h>
+
+/*
+ * F64 support code initialisation.
+ */
+static int __init f64_init(void)
+{
+	f64_vector = f64_support_entry;
+	barrier();
+
+	ctf(FPSCR, 0x0);     /* FPSCR_UFE | FPSCR_NDE perhaps better */
+
+	printk(KERN_INFO "UniCore-F64 support\n");
+
+	return 0;
+}
+
+late_initcall(f64_init);
diff --git a/arch/unicore32/uc-f64/f64single.c b/arch/unicore32/uc-f64/f64single.c
new file mode 100644
index 0000000..f6ef44c
--- /dev/null
+++ b/arch/unicore32/uc-f64/f64single.c
@@ -0,0 +1,771 @@
+/*
+ * linux/arch/unicore32/uc-f64/f64single.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ * Fragments that appear the same as the files in arm vfp
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This code is derived in part from John R. Housers softfloat library, which
+ * carries the following notice:
+ *
+ * ===========================================================================
+ * This C source file is part of the SoftFloat IEC/IEEE Floating-point
+ * Arithmetic Package, Release 2.
+ *
+ * Written by John R. Hauser.  This work was made possible in part by the
+ * International Computer Science Institute, located at Suite 600, 1947 Center
+ * Street, Berkeley, California 94704.  Funding was partially provided by the
+ * National Science Foundation under grant MIP-9311980.  The original version
+ * of this code was written as part of a project to build a fixed-point vector
+ * processor in collaboration with the University of California at Berkeley,
+ * overseen by Profs. Nelson Morgan and John Wawrzynek.  More information
+ * is available through the web page `http://HTTP.CS.Berkeley.EDU/~jhauser/
+ * arithmetic/softfloat.html'.
+ *
+ * THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable effort
+ * has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WILL AT
+ * TIMES RESULT IN INCORRECT BEHAVIOR.  USE OF THIS SOFTWARE IS RESTRICTED TO
+ * PERSONS AND ORGANIZATIONS WHO CAN AND WILL TAKE FULL RESPONSIBILITY FOR ANY
+ * AND ALL LOSSES, COSTS, OR OTHER PROBLEMS ARISING FROM ITS USE.
+ *
+ * Derivative works are acceptable, even for commercial purposes, so long as
+ * (1) they include prominent notice that the work is derivative, and (2) they
+ * include prominent notice akin to these three paragraphs for those parts of
+ * this code that are retained.
+ * ===========================================================================
+ */
+#include <linux/kernel.h>
+#include <linux/bitops.h>
+
+#include <asm/div64.h>
+#include <asm/uc-f64.h>
+
+#include "f64instr.h"
+#include "uc-f64.h"
+
+static struct f64_single f64_single_default_qnan = {
+	.exponent	= 255,
+	.sign		= 0,
+	.significand	= F64_SINGLE_SIGNIFICAND_QNAN,
+};
+
+static void f64_single_dump(const char *str, struct f64_single *s)
+{
+	pr_debug("UniCore-F64: %s: sign=%d exponent=%d significand=%08x\n",
+		 str, s->sign != 0, s->exponent, s->significand);
+}
+
+static void f64_single_normalise_denormal(struct f64_single *vs)
+{
+	int bits = 31 - fls(vs->significand);
+
+	f64_single_dump("normalise_denormal: in", vs);
+
+	if (bits) {
+		vs->exponent -= bits - 1;
+		vs->significand <<= bits;
+	}
+
+	f64_single_dump("normalise_denormal: out", vs);
+}
+
+#ifndef DEBUG
+#define f64_single_normaliseround(sd, vsd, fpscr, except, func)	\
+	__f64_single_normaliseround(sd, vsd, fpscr, except)
+u32 __f64_single_normaliseround(int sd, struct f64_single *vs, u32 fpscr,
+		u32 exceptions)
+#else
+u32 f64_single_normaliseround(int sd, struct f64_single *vs, u32 fpscr,
+		u32 exceptions, const char *func)
+#endif
+{
+	u32 significand, incr, rmode;
+	int exponent, shift, underflow;
+
+	f64_single_dump("pack: in", vs);
+
+	/*
+	 * Infinities and NaNs are a special case.
+	 */
+	if (vs->exponent == 255 && (vs->significand == 0 || exceptions))
+		goto pack;
+
+	/*
+	 * Special-case zero.
+	 */
+	if (vs->significand == 0) {
+		vs->exponent = 0;
+		goto pack;
+	}
+
+	exponent = vs->exponent;
+	significand = vs->significand;
+
+	/*
+	 * Normalise first.  Note that we shift the significand up to
+	 * bit 31, so we have F64_SINGLE_LOW_BITS + 1 below the least
+	 * significant bit.
+	 */
+	shift = 32 - fls(significand);
+	if (shift < 32 && shift) {
+		exponent -= shift;
+		significand <<= shift;
+	}
+
+#ifdef DEBUG
+	vs->exponent = exponent;
+	vs->significand = significand;
+	f64_single_dump("pack: normalised", vs);
+#endif
+
+	/*
+	 * Tiny number?
+	 */
+	underflow = exponent < 0;
+	if (underflow) {
+		significand = f64_shiftright32jamming(significand, -exponent);
+		exponent = 0;
+#ifdef DEBUG
+		vs->exponent = exponent;
+		vs->significand = significand;
+		f64_single_dump("pack: tiny number", vs);
+#endif
+		if (!(significand & ((1 << (F64_SINGLE_LOW_BITS + 1)) - 1)))
+			underflow = 0;
+	}
+
+	/*
+	 * Select rounding increment.
+	 */
+	incr = 0;
+	rmode = fpscr & FPSCR_RMODE_MASK;
+
+	if (rmode == FPSCR_ROUND_NEAREST) {
+		incr = 1 << F64_SINGLE_LOW_BITS;
+		if ((significand & (1 << (F64_SINGLE_LOW_BITS + 1))) == 0)
+			incr -= 1;
+	} else if (rmode == FPSCR_ROUND_TOZERO) {
+		incr = 0;
+	} else if ((rmode == FPSCR_ROUND_PLUSINF) ^ (vs->sign != 0))
+		incr = (1 << (F64_SINGLE_LOW_BITS + 1)) - 1;
+
+	pr_debug("UniCore-F64: rounding increment = 0x%08x\n", incr);
+
+	/*
+	 * Is our rounding going to overflow?
+	 */
+	if ((significand + incr) < significand) {
+		exponent += 1;
+		significand = (significand >> 1) | (significand & 1);
+		incr >>= 1;
+#ifdef DEBUG
+		vs->exponent = exponent;
+		vs->significand = significand;
+		f64_single_dump("pack: overflow", vs);
+#endif
+	}
+
+	/*
+	 * If any of the low bits (which will be shifted out of the
+	 * number) are non-zero, the result is inexact.
+	 */
+	if (significand & ((1 << (F64_SINGLE_LOW_BITS + 1)) - 1))
+		exceptions |= FPSCR_IXC;
+
+	/*
+	 * Do our rounding.
+	 */
+	significand += incr;
+
+	/*
+	 * Infinity?
+	 */
+	if (exponent >= 254) {
+		exceptions |= FPSCR_OFC | FPSCR_IXC;
+		if (incr == 0) {
+			vs->exponent = 253;
+			vs->significand = 0x7fffffff;
+		} else {
+			vs->exponent = 255;		/* infinity */
+			vs->significand = 0;
+		}
+	} else {
+		if (significand >> (F64_SINGLE_LOW_BITS + 1) == 0)
+			exponent = 0;
+		if (exponent || significand > 0x80000000)
+			underflow = 0;
+		if (underflow)
+			exceptions |= FPSCR_UFC;
+		vs->exponent = exponent;
+		vs->significand = significand >> 1;
+	}
+
+ pack:
+	f64_single_dump("pack: final", vs);
+	{
+		s32 d = f64_single_pack(vs);
+#ifdef DEBUG
+		pr_debug("UniCore-F64: %s: d(s%d)=%08x exceptions=%08x\n", func,
+			 sd, d, exceptions);
+#endif
+		f64_put_float(d, sd);
+	}
+
+	return exceptions;
+}
+
+/*
+ * Propagate the NaN, setting exceptions if it is signalling.
+ * 'n' is always a NaN.  'm' may be a number, NaN or infinity.
+ */
+static u32 f64_propagate_nan(struct f64_single *vsd, struct f64_single *vsn,
+		  struct f64_single *vsm, u32 fpscr)
+{
+	struct f64_single *nan;
+	int tn, tm = 0;
+
+	tn = f64_single_type(vsn);
+
+	if (vsm)
+		tm = f64_single_type(vsm);
+
+	if (fpscr & FPSCR_DEFAULT_NAN)
+		/*
+		 * Default NaN mode - always returns a quiet NaN
+		 */
+		nan = &f64_single_default_qnan;
+	else {
+		/*
+		 * Contemporary mode - select the first signalling
+		 * NAN, or if neither are signalling, the first
+		 * quiet NAN.
+		 */
+		if (tn == F64_SNAN || (tm != F64_SNAN && tn == F64_QNAN))
+			nan = vsn;
+		else
+			nan = vsm;
+		/*
+		 * Make the NaN quiet.
+		 */
+		nan->significand |= F64_SINGLE_SIGNIFICAND_QNAN;
+	}
+
+	*vsd = *nan;
+
+	/*
+	 * If one was a signalling NAN, raise invalid operation.
+	 */
+	return tn == F64_SNAN || tm == F64_SNAN ? FPSCR_IOC : F64_NAN_FLAG;
+}
+
+
+/*
+ * Extended operations
+ */
+static u32 f64_single_fabs(int sd, int unused, s32 m, u32 fpscr)
+{
+	f64_put_float(f64_single_packed_abs(m), sd);
+	return 0;
+}
+
+static u32 f64_single_fneg(int sd, int unused, s32 m, u32 fpscr)
+{
+	f64_put_float(f64_single_packed_negate(m), sd);
+	return 0;
+}
+
+/*
+ * Equal	:= ZC
+ * Less than	:= N
+ * Greater than	:= C
+ * Unordered	:= CV
+ */
+static u32 f64_compare(int sd, int signal_on_qnan, s32 m, u32 fpscr)
+{
+	s32 d;
+	u32 ret = 0;
+
+	d = f64_get_float(sd);
+	if (f64_single_packed_exponent(m) == 255
+			&& f64_single_packed_mantissa(m)) {
+		ret |= FPSCR_C | FPSCR_V;
+		if (signal_on_qnan || !(f64_single_packed_mantissa(m)
+				& (1 << (F64_SINGLE_MANTISSA_BITS - 1))))
+			/*
+			 * Signalling NaN, or signalling on quiet NaN
+			 */
+			ret |= FPSCR_IOC;
+	}
+
+	if (f64_single_packed_exponent(d) == 255
+			&& f64_single_packed_mantissa(d)) {
+		ret |= FPSCR_C | FPSCR_V;
+		if (signal_on_qnan || !(f64_single_packed_mantissa(d)
+				& (1 << (F64_SINGLE_MANTISSA_BITS - 1))))
+			/*
+			 * Signalling NaN, or signalling on quiet NaN
+			 */
+			ret |= FPSCR_IOC;
+	}
+
+	if (ret == 0) {
+		if (d == m || f64_single_packed_abs(d | m) == 0) {
+			/*
+			 * equal
+			 */
+			ret |= FPSCR_Z | FPSCR_C;
+		} else if (f64_single_packed_sign(d ^ m)) {
+			/*
+			 * different signs
+			 */
+			if (f64_single_packed_sign(d))
+				/*
+				 * d is negative, so d < m
+				 */
+				ret |= FPSCR_N;
+			else
+				/*
+				 * d is positive, so d > m
+				 */
+				ret |= FPSCR_C;
+		} else if ((f64_single_packed_sign(d) != 0) ^ (d < m)) {
+			/*
+			 * d < m
+			 */
+			ret |= FPSCR_N;
+		} else if ((f64_single_packed_sign(d) != 0) ^ (d > m)) {
+			/*
+			 * d > m
+			 */
+			ret |= FPSCR_C;
+		}
+	}
+	return ret;
+}
+
+/*
+ * Conversion operations
+ */
+
+static u32 f64_single_fcvts(int dd, int unused, s32 m, u32 fpscr)
+{
+	return 0;
+}
+
+static u32 f64_single_fcvtd(int dd, int unused, s32 m, u32 fpscr)
+{
+	struct f64_single vsm;
+	struct f64_double vdd;
+	int tm;
+	u32 exceptions = 0;
+
+	f64_single_unpack(&vsm, m);
+
+	tm = f64_single_type(&vsm);
+
+	/*
+	 * If we have a signalling NaN, signal invalid operation.
+	 */
+	if (tm == F64_SNAN)
+		exceptions = FPSCR_IOC;
+
+	if (tm & F64_DENORMAL)
+		f64_single_normalise_denormal(&vsm);
+
+	vdd.sign = vsm.sign;
+	vdd.significand = (u64)vsm.significand << 32;
+
+	/*
+	 * If we have an infinity or NaN, the exponent must be 2047.
+	 */
+	if (tm & (F64_INFINITY|F64_NAN)) {
+		vdd.exponent = 2047;
+		if (tm == F64_QNAN)
+			vdd.significand |= F64_DOUBLE_SIGNIFICAND_QNAN;
+		goto pack_nan;
+	} else if (tm & F64_ZERO)
+		vdd.exponent = 0;
+	else
+		vdd.exponent = vsm.exponent + (1023 - 127);
+
+	return f64_double_normaliseround(dd, &vdd, fpscr, exceptions, "fcvtd");
+
+ pack_nan:
+	f64_put_double(f64_double_pack(&vdd), dd);
+	return exceptions;
+}
+
+static u32 f64_single_ftosi(int sd, int unused, s32 m, u32 fpscr)
+{
+	struct f64_single vsm;
+	u32 d, exceptions = 0;
+	int rmode = fpscr & FPSCR_RMODE_MASK;
+	int tm;
+
+	f64_single_unpack(&vsm, m);
+	f64_single_dump("VSM", &vsm);
+
+	/*
+	 * Do we have a denormalised number?
+	 */
+	tm = f64_single_type(&vsm);
+	if (f64_single_type(&vsm) & F64_DENORMAL)
+		exceptions |= FPSCR_IDC;
+
+	if (tm & F64_NAN) {
+		d = 0;
+		exceptions |= FPSCR_IOC;
+	} else if (vsm.exponent >= 127 + 32) {
+		/*
+		 * m >= 2^31-2^7: invalid
+		 */
+		d = 0x7fffffff;
+		if (vsm.sign)
+			d = ~d;
+		exceptions |= FPSCR_IOC;
+	} else if (vsm.exponent >= 127 - 1) {
+		int shift = 127 + 31 - vsm.exponent;
+		u32 rem, incr = 0;
+
+		/* 2^0 <= m <= 2^31-2^7 */
+		d = (vsm.significand << 1) >> shift;
+		rem = vsm.significand << (33 - shift);
+
+		if (rmode == FPSCR_ROUND_NEAREST) {
+			incr = 0x80000000;
+			if ((d & 1) == 0)
+				incr -= 1;
+		} else if (rmode == FPSCR_ROUND_TOZERO) {
+			incr = 0;
+		} else if ((rmode == FPSCR_ROUND_PLUSINF) ^ (vsm.sign != 0)) {
+			incr = ~0;
+		}
+
+		if ((rem + incr) < rem && d < 0xffffffff)
+			d += 1;
+		if (d > 0x7fffffff + (vsm.sign != 0)) {
+			d = 0x7fffffff + (vsm.sign != 0);
+			exceptions |= FPSCR_IOC;
+		} else if (rem)
+			exceptions |= FPSCR_IXC;
+
+		if (vsm.sign)
+			d = -d;
+	} else {
+		d = 0;
+		if (vsm.exponent | vsm.significand) {
+			exceptions |= FPSCR_IXC;
+			if (rmode == FPSCR_ROUND_PLUSINF && vsm.sign == 0)
+				d = 1;
+			else if (rmode == FPSCR_ROUND_MINUSINF && vsm.sign)
+				d = -1;
+		}
+	}
+
+	pr_debug("UniCore-F64: ftosi: d(s%d)=%08x exceptions=%08x\n",
+			sd, d, exceptions);
+
+	f64_put_float((s32)d, sd);
+
+	return exceptions;
+}
+
+static struct op f_conv_ops[16] = {
+	[FFUNC_TO_IDX(FOP_FCVTS)]	= { f64_single_fcvts,  OP_SD },
+	[FFUNC_TO_IDX(FOP_FCVTD)]	= { f64_single_fcvtd,  OP_DD },
+	[FFUNC_TO_IDX(FOP_FCVTW)]	= { f64_single_ftosi,  OP_SD },
+};
+
+static u32 f64_single_fadd_nonnumber(struct f64_single *vsd,
+		struct f64_single *vsn, struct f64_single *vsm, u32 fpscr)
+{
+	struct f64_single *vsp;
+	u32 exceptions = 0;
+	int tn, tm;
+
+	tn = f64_single_type(vsn);
+	tm = f64_single_type(vsm);
+
+	if (tn & tm & F64_INFINITY) {
+		/*
+		 * Two infinities.  Are they different signs?
+		 */
+		if (vsn->sign ^ vsm->sign) {
+			/*
+			 * different signs -> invalid
+			 */
+			exceptions = FPSCR_IOC;
+			vsp = &f64_single_default_qnan;
+		} else {
+			/*
+			 * same signs -> valid
+			 */
+			vsp = vsn;
+		}
+	} else if (tn & F64_INFINITY && tm & F64_NUMBER) {
+		/*
+		 * One infinity and one number -> infinity
+		 */
+		vsp = vsn;
+	} else {
+		/*
+		 * 'n' is a NaN of some type
+		 */
+		return f64_propagate_nan(vsd, vsn, vsm, fpscr);
+	}
+	*vsd = *vsp;
+	return exceptions;
+}
+
+static u32 f64_single_add(struct f64_single *vsd, struct f64_single *vsn,
+	       struct f64_single *vsm, u32 fpscr)
+{
+	u32 exp_diff, m_sig;
+
+	if (vsn->significand & 0x80000000 ||
+	    vsm->significand & 0x80000000) {
+		pr_info("UniCore-F64: bad FP values in %s\n", __func__);
+		f64_single_dump("VSN", vsn);
+		f64_single_dump("VSM", vsm);
+	}
+
+	/*
+	 * Ensure that 'n' is the largest magnitude number.  Note that
+	 * if 'n' and 'm' have equal exponents, we do not swap them.
+	 * This ensures that NaN propagation works correctly.
+	 */
+	if (vsn->exponent < vsm->exponent) {
+		struct f64_single *t = vsn;
+		vsn = vsm;
+		vsm = t;
+	}
+
+	/*
+	 * Is 'n' an infinity or a NaN?  Note that 'm' may be a number,
+	 * infinity or a NaN here.
+	 */
+	if (vsn->exponent == 255)
+		return f64_single_fadd_nonnumber(vsd, vsn, vsm, fpscr);
+
+	/*
+	 * We have two proper numbers, where 'vsn' is the larger magnitude.
+	 *
+	 * Copy 'n' to 'd' before doing the arithmetic.
+	 */
+	*vsd = *vsn;
+
+	/*
+	 * Align both numbers.
+	 */
+	exp_diff = vsn->exponent - vsm->exponent;
+	m_sig = f64_shiftright32jamming(vsm->significand, exp_diff);
+
+	/*
+	 * If the signs are different, we are really subtracting.
+	 */
+	if (vsn->sign ^ vsm->sign) {
+		m_sig = vsn->significand - m_sig;
+		if ((s32)m_sig < 0) {
+			vsd->sign = f64_sign_negate(vsd->sign);
+			m_sig = -m_sig;
+		} else if (m_sig == 0) {
+			vsd->sign = (fpscr & FPSCR_RMODE_MASK) ==
+				      FPSCR_ROUND_MINUSINF ? 0x8000 : 0;
+		}
+	} else {
+		m_sig = vsn->significand + m_sig;
+	}
+	vsd->significand = m_sig;
+
+	return 0;
+}
+
+static u32 f64_single_multiply(struct f64_single *vsd, struct f64_single *vsn,
+		struct f64_single *vsm, u32 fpscr)
+{
+	f64_single_dump("VSN", vsn);
+	f64_single_dump("VSM", vsm);
+
+	/*
+	 * Ensure that 'n' is the largest magnitude number.  Note that
+	 * if 'n' and 'm' have equal exponents, we do not swap them.
+	 * This ensures that NaN propagation works correctly.
+	 */
+	if (vsn->exponent < vsm->exponent) {
+		struct f64_single *t = vsn;
+		vsn = vsm;
+		vsm = t;
+		pr_debug("UniCore-F64: swapping M <-> N\n");
+	}
+
+	vsd->sign = vsn->sign ^ vsm->sign;
+
+	/*
+	 * If 'n' is an infinity or NaN, handle it.  'm' may be anything.
+	 */
+	if (vsn->exponent == 255) {
+		if (vsn->significand || (vsm->exponent == 255
+				&& vsm->significand))
+			return f64_propagate_nan(vsd, vsn, vsm, fpscr);
+		if ((vsm->exponent | vsm->significand) == 0) {
+			*vsd = f64_single_default_qnan;
+			return FPSCR_IOC;
+		}
+		vsd->exponent = vsn->exponent;
+		vsd->significand = 0;
+		return 0;
+	}
+
+	/*
+	 * If 'm' is zero, the result is always zero.  In this case,
+	 * 'n' may be zero or a number, but it doesn't matter which.
+	 */
+	if ((vsm->exponent | vsm->significand) == 0) {
+		vsd->exponent = 0;
+		vsd->significand = 0;
+		return 0;
+	}
+
+	/*
+	 * We add 2 to the destination exponent for the same reason as
+	 * the addition case - though this time we have +1 from each
+	 * input operand.
+	 */
+	vsd->exponent = vsn->exponent + vsm->exponent - 127 + 2;
+	vsd->significand = f64_hi64to32jamming((u64)vsn->significand
+			* vsm->significand);
+
+	f64_single_dump("VSD", vsd);
+	return 0;
+}
+
+/*
+ * Standard operations
+ */
+
+/*
+ * sd = sn * sm
+ */
+static u32 f64_single_fmul(int sd, int sn, s32 m, u32 fpscr)
+{
+	struct f64_single vsd, vsn, vsm;
+	u32 exceptions;
+	s32 n = f64_get_float(sn);
+
+	pr_debug("UniCore-F64: s%u = %08x\n", sn, n);
+
+	f64_single_unpack(&vsn, n);
+	if (vsn.exponent == 0 && vsn.significand)
+		f64_single_normalise_denormal(&vsn);
+
+	f64_single_unpack(&vsm, m);
+	if (vsm.exponent == 0 && vsm.significand)
+		f64_single_normalise_denormal(&vsm);
+
+	exceptions = f64_single_multiply(&vsd, &vsn, &vsm, fpscr);
+	return f64_single_normaliseround(sd, &vsd, fpscr, exceptions, "fmul");
+}
+
+/*
+ * sd = sn + sm
+ */
+static u32 f64_single_fadd(int sd, int sn, s32 m, u32 fpscr)
+{
+	struct f64_single vsd, vsn, vsm;
+	u32 exceptions;
+	s32 n = f64_get_float(sn);
+
+	pr_debug("UniCore-F64: s%u = %08x\n", sn, n);
+
+	/*
+	 * Unpack and normalise denormals.
+	 */
+	f64_single_unpack(&vsn, n);
+	if (vsn.exponent == 0 && vsn.significand)
+		f64_single_normalise_denormal(&vsn);
+
+	f64_single_unpack(&vsm, m);
+	if (vsm.exponent == 0 && vsm.significand)
+		f64_single_normalise_denormal(&vsm);
+
+	exceptions = f64_single_add(&vsd, &vsn, &vsm, fpscr);
+
+	return f64_single_normaliseround(sd, &vsd, fpscr, exceptions, "fadd");
+}
+
+/*
+ * sd = sn - sm
+ */
+static u32 f64_single_fsub(int sd, int sn, s32 m, u32 fpscr)
+{
+	/*
+	 * Subtraction is addition with one sign inverted.
+	 */
+	return f64_single_fadd(sd, sn, f64_single_packed_negate(m), fpscr);
+}
+
+
+static struct op f_arith_ops[16] = {
+	[FFUNC_TO_IDX(FOP_FABS)]	= { f64_single_fabs,  OP_SD },
+	[FFUNC_TO_IDX(FOP_FMUL)]	= { f64_single_fmul,  OP_SD },
+	[FFUNC_TO_IDX(FOP_FADD)]	= { f64_single_fadd,  OP_SD },
+	[FFUNC_TO_IDX(FOP_FSUB)]	= { f64_single_fsub,  OP_SD },
+	[FFUNC_TO_IDX(FOP_FNEG)]	= { f64_single_fneg,  OP_SD },
+};
+
+#include "f64_single_cmp.h"
+u32 f64_single_cpdo(u32 inst, u32 fpscr)
+{
+	u32 op1 = (inst & FOP1_MASK) >> 26;
+	u32 func = (inst & FFUNC_MASK) >> 6;
+	u32 exceptions = 0;
+	u32 except;
+	s32 m;
+	char type;
+	unsigned int dest;
+	unsigned int sn = f64_get_sn(inst);
+	unsigned int sm = f64_get_sm(inst);
+	struct op *fop;
+
+	switch (op1) {
+	case 0:
+		fop =  &f_arith_ops[func];
+		break;
+	case 2:
+		fop =  &f_conv_ops[func];
+		break;
+	case 3:
+		fop =  &f_cmp_ops[func];
+		break;
+	default:
+		goto  invalid;
+	}
+
+	if (!fop->fn)
+		goto invalid;
+
+	if (fop->flags & OP_DD)
+		dest = f64_get_dd(inst);
+	else
+		dest = f64_get_sd(inst);
+	m = f64_get_float(sm);
+
+	type = fop->flags & OP_DD ? 'd' : 's';
+	pr_debug("UniCore-F64:  (%c%u) = (s%u) op1[%u] func[%u] (s%u=%08x)\n",
+		type, dest, sn,
+		op1, func, sm, m);
+
+	except = fop->fn(dest, sn, m, fpscr);
+	pr_debug("UniCore-F64: exceptions=%08x\n", except);
+	exceptions |= except;
+
+	return exceptions;
+
+invalid:
+	return (u32)-1;
+}
diff --git a/arch/unicore32/uc-f64/f64sint.c b/arch/unicore32/uc-f64/f64sint.c
new file mode 100644
index 0000000..0e909ac
--- /dev/null
+++ b/arch/unicore32/uc-f64/f64sint.c
@@ -0,0 +1,94 @@
+/*
+ * linux/arch/unicore32/uc-f64/f64sint.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ * Fragments that appear the same as the files in arm vfp
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/bitops.h>
+
+#include <asm/div64.h>
+#include <asm/uc-f64.h>
+
+#include "f64instr.h"
+#include "uc-f64.h"
+
+static u32 f64_sint_fcvts(int sd, int unused, s32 m, u32 fpscr)
+{
+	struct f64_single vs;
+
+	vs.sign = (m & 0x80000000) >> 16;
+	vs.exponent = 127 + 31 - 1;
+	vs.significand = vs.sign ? -m : m;
+
+	return f64_single_normaliseround(sd, &vs, fpscr, 0, "f64_sint_fcvts");
+}
+
+static u32 f64_sint_fcvtd(int dd, int unused, s32 m, u32 fpscr)
+{
+	struct f64_double vdm;
+
+	vdm.sign = (m & 0x80000000) >> 16;
+	vdm.exponent = 1023 + 63 - 1;
+	vdm.significand = vdm.sign ? -m : m;
+
+	return f64_double_normaliseround(dd, &vdm, fpscr, 0, "f64_sint_fcvtd");
+}
+
+static u32 f64_sint_ftosi(int dd, int unused, s32 m, u32 fpscr)
+{
+	return 0;
+}
+static struct op f_conv_ops[16] = {
+	[FFUNC_TO_IDX(FOP_FCVTS)]	= { f64_sint_fcvts,  OP_SD },
+	[FFUNC_TO_IDX(FOP_FCVTD)]	= { f64_sint_fcvtd,  OP_DD },
+	[FFUNC_TO_IDX(FOP_FCVTW)]	= { f64_sint_ftosi,  OP_SD },
+};
+
+u32 f64_sint_cpdo(u32 inst, u32 ff)
+{
+	u32 op1 = (inst & FOP1_MASK) >> 26;
+	u32 func = (inst & FFUNC_MASK) >> 6;
+	u32 exceptions = 0;
+	u32 except;
+	s32 m;
+	char type;
+	unsigned int dest;
+	unsigned int sn = f64_get_sn(inst);
+	unsigned int sm = f64_get_sm(inst);
+	struct op *fop;
+
+	if (op1 == 2)
+		fop =  &f_conv_ops[func];
+	else
+		goto  invalid;
+
+	if (!fop->fn)
+		goto invalid;
+
+	if (fop->flags & OP_SD)
+		dest = f64_get_sd(inst);
+	else
+		dest = f64_get_dd(inst);
+
+	m = f64_get_float(sm);
+
+	type = fop->flags & OP_DD ? 'd' : 's';
+	pr_debug("UniCore-F64:  (%c%u) = (s%u) op1[%u] func[%u] (s%u=%08x)\n",
+		type, dest, sn,
+		op1, func, sm, m);
+
+	except = fop->fn(dest, sn, m, ff);
+	exceptions |= except;
+
+	return exceptions;
+
+ invalid:
+	return (u32)-1;
+}
diff --git a/arch/unicore32/uc-f64/uc-f64.h b/arch/unicore32/uc-f64/uc-f64.h
new file mode 100644
index 0000000..1e458d7
--- /dev/null
+++ b/arch/unicore32/uc-f64/uc-f64.h
@@ -0,0 +1,332 @@
+/*
+ * linux/arch/unicore/uc-f64/uc-f64.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ * Fragments that appear the same as the files in arm vfp
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+static inline u32 f64_shiftright32jamming(u32 val, unsigned int shift)
+{
+	if (shift) {
+		if (shift < 32)
+			val = val >> shift | ((val << (32 - shift)) != 0);
+		else
+			val = val != 0;
+	}
+	return val;
+}
+
+static inline u64 f64_shiftright64jamming(u64 val, unsigned int shift)
+{
+	if (shift) {
+		if (shift < 64)
+			val = val >> shift | ((val << (64 - shift)) != 0);
+		else
+			val = val != 0;
+	}
+	return val;
+}
+
+static inline u32 f64_hi64to32jamming(u64 val)
+{
+	u32 v;
+
+	asm(
+	"cmpsub.a	%Q1, #1		@ f64_hi64to32jamming\n\t"
+	"cmovub	%0, %R1\n\t"
+	"bub	100f\n\t"
+	"or	%0, %R1, #1\n\t"
+"100:	"
+	: "=r" (v) : "r" (val) : "cc");
+
+	return v;
+}
+
+static inline void mul64to128(u64 *resh, u64 *resl, u64 n, u64 m)
+{
+	u32 nh, nl, mh, ml;
+	u64 rh, rma, rmb, rl;
+
+	nl = n;
+	ml = m;
+	rl = (u64)nl * ml;
+
+	nh = n >> 32;
+	rma = (u64)nh * ml;
+
+	mh = m >> 32;
+	rmb = (u64)nl * mh;
+	rma += rmb;
+
+	rh = (u64)nh * mh;
+	rh += ((u64)(rma < rmb) << 32) + (rma >> 32);
+
+	rma <<= 32;
+	rl += rma;
+	rh += (rl < rma);
+
+	*resl = rl;
+	*resh = rh;
+}
+
+static inline void shift64left(u64 *resh, u64 *resl, u64 n)
+{
+	*resh = n >> 63;
+	*resl = n << 1;
+}
+
+static inline u64 f64_hi64multiply64(u64 n, u64 m)
+{
+	u64 rh, rl;
+	mul64to128(&rh, &rl, n, m);
+	return rh | (rl != 0);
+}
+
+/*
+ * Operations on unpacked elements
+ */
+#define f64_sign_negate(sign)	(sign ^ 0x8000)
+
+/*
+ * Single-precision
+ */
+struct f64_single {
+	s16	exponent;
+	u16	sign;
+	u32	significand;
+};
+
+extern s32 f64_get_float(unsigned int reg);
+extern void f64_put_float(s32 val, unsigned int reg);
+
+/*
+ * F64_SINGLE_MANTISSA_BITS - number of bits in the mantissa
+ * F64_SINGLE_EXPONENT_BITS - number of bits in the exponent
+ * F64_SINGLE_LOW_BITS - number of low bits in the unpacked significand
+ *  which are not propagated to the float upon packing.
+ */
+#define F64_SINGLE_MANTISSA_BITS	(23)
+#define F64_SINGLE_EXPONENT_BITS	(8)
+#define F64_SINGLE_LOW_BITS		(32 - F64_SINGLE_MANTISSA_BITS - 2)
+#define F64_SINGLE_LOW_BITS_MASK	((1 << F64_SINGLE_LOW_BITS) - 1)
+
+/*
+ * The bit in an unpacked float which indicates that it is a quiet NaN
+ */
+#define F64_SINGLE_SIGNIFICAND_QNAN	(1 << (F64_SINGLE_MANTISSA_BITS - 1 \
+					+ F64_SINGLE_LOW_BITS))
+
+/*
+ * Operations on packed single-precision numbers
+ */
+#define f64_single_packed_sign(v)	((v) & 0x80000000)
+#define f64_single_packed_negate(v)	((v) ^ 0x80000000)
+#define f64_single_packed_abs(v)	((v) & ~0x80000000)
+#define f64_single_packed_exponent(v)	(((v) >> F64_SINGLE_MANTISSA_BITS) \
+					& ((1 << F64_SINGLE_EXPONENT_BITS) \
+					- 1))
+#define f64_single_packed_mantissa(v)	((v) & \
+					((1 << F64_SINGLE_MANTISSA_BITS) \
+					- 1))
+
+/*
+ * Unpack a single-precision float.  Note that this returns the magnitude
+ * of the single-precision float mantissa with the 1. if necessary,
+ * aligned to bit 30.
+ */
+static inline void f64_single_unpack(struct f64_single *s, s32 val)
+{
+	u32 significand;
+
+	s->sign = f64_single_packed_sign(val) >> 16,
+	s->exponent = f64_single_packed_exponent(val);
+
+	significand = (u32) val;
+	significand = (significand << (32 - F64_SINGLE_MANTISSA_BITS)) >> 2;
+	if (s->exponent && s->exponent != 255)
+		significand |= 0x40000000;
+	s->significand = significand;
+}
+
+/*
+ * Re-pack a single-precision float.  This assumes that the float is
+ * already normalised such that the MSB is bit 30, _not_ bit 31.
+ */
+static inline s32 f64_single_pack(struct f64_single *s)
+{
+	u32 val;
+	val = (s->sign << 16) +
+	      (s->exponent << F64_SINGLE_MANTISSA_BITS) +
+	      (s->significand >> F64_SINGLE_LOW_BITS);
+	return (s32)val;
+}
+
+#define F64_NUMBER		(1<<0)
+#define F64_ZERO		(1<<1)
+#define F64_DENORMAL		(1<<2)
+#define F64_INFINITY		(1<<3)
+#define F64_NAN			(1<<4)
+#define F64_NAN_SIGNAL		(1<<5)
+
+#define F64_QNAN		(F64_NAN)
+#define F64_SNAN		(F64_NAN|F64_NAN_SIGNAL)
+
+static inline int f64_single_type(struct f64_single *s)
+{
+	int type = F64_NUMBER;
+	if (s->exponent == 255) {
+		if (s->significand == 0)
+			type = F64_INFINITY;
+		else if (s->significand & F64_SINGLE_SIGNIFICAND_QNAN)
+			type = F64_QNAN;
+		else
+			type = F64_SNAN;
+	} else if (s->exponent == 0) {
+		if (s->significand == 0)
+			type |= F64_ZERO;
+		else
+			type |= F64_DENORMAL;
+	}
+	return type;
+}
+
+#ifndef DEBUG
+#define f64_single_normaliseround(sd, vsd, fpscr, except, func)	\
+	__f64_single_normaliseround(sd, vsd, fpscr, except)
+u32 __f64_single_normaliseround(int sd, struct f64_single *vs, u32 fpscr,
+		u32 exceptions);
+#else
+u32 f64_single_normaliseround(int sd, struct f64_single *vs, u32 fpscr,
+		u32 exceptions, const char *func);
+#endif
+
+/*
+ * Double-precision
+ */
+struct f64_double {
+	s16	exponent;
+	u16	sign;
+	u64	significand;
+};
+
+extern u64 f64_get_double(unsigned int reg);
+extern void f64_put_double(u64 val, unsigned int reg);
+
+#define F64_DOUBLE_MANTISSA_BITS	(52)
+#define F64_DOUBLE_EXPONENT_BITS	(11)
+#define F64_DOUBLE_LOW_BITS		(64 - F64_DOUBLE_MANTISSA_BITS - 2)
+#define F64_DOUBLE_LOW_BITS_MASK	((1 << F64_DOUBLE_LOW_BITS) - 1)
+
+/*
+ * The bit in an unpacked double which indicates that it is a quiet NaN
+ */
+#define F64_DOUBLE_SIGNIFICAND_QNAN	(1ULL << (F64_DOUBLE_MANTISSA_BITS \
+					- 1 + F64_DOUBLE_LOW_BITS))
+
+/*
+ * Operations on packed single-precision numbers
+ */
+#define f64_double_packed_sign(v)	((v) & (1ULL << 63))
+#define f64_double_packed_negate(v)	((v) ^ (1ULL << 63))
+#define f64_double_packed_abs(v)	((v) & ~(1ULL << 63))
+#define f64_double_packed_exponent(v)	(((v) >> F64_DOUBLE_MANTISSA_BITS) \
+					& ((1 << F64_DOUBLE_EXPONENT_BITS) \
+					- 1))
+#define f64_double_packed_mantissa(v)	((v) & \
+					((1ULL << F64_DOUBLE_MANTISSA_BITS) \
+					- 1))
+
+/*
+ * Unpack a double-precision float.  Note that this returns the magnitude
+ * of the double-precision float mantissa with the 1. if necessary,
+ * aligned to bit 62.
+ */
+static inline void f64_double_unpack(struct f64_double *s, s64 val)
+{
+	u64 significand;
+
+	s->sign = f64_double_packed_sign(val) >> 48;
+	s->exponent = f64_double_packed_exponent(val);
+
+	significand = (u64) val;
+	significand = (significand << (64 - F64_DOUBLE_MANTISSA_BITS)) >> 2;
+	if (s->exponent && s->exponent != 2047)
+		significand |= (1ULL << 62);
+	s->significand = significand;
+}
+
+/*
+ * Re-pack a double-precision float.  This assumes that the float is
+ * already normalised such that the MSB is bit 30, _not_ bit 31.
+ */
+static inline s64 f64_double_pack(struct f64_double *s)
+{
+	u64 val;
+	val = ((u64)s->sign << 48) +
+	      ((u64)s->exponent << F64_DOUBLE_MANTISSA_BITS) +
+	      (s->significand >> F64_DOUBLE_LOW_BITS);
+	return (s64)val;
+}
+
+static inline int f64_double_type(struct f64_double *s)
+{
+	int type = F64_NUMBER;
+	if (s->exponent == 2047) {
+		if (s->significand == 0)
+			type = F64_INFINITY;
+		else if (s->significand & F64_DOUBLE_SIGNIFICAND_QNAN)
+			type = F64_QNAN;
+		else
+			type = F64_SNAN;
+	} else if (s->exponent == 0) {
+		if (s->significand == 0)
+			type |= F64_ZERO;
+		else
+			type |= F64_DENORMAL;
+	}
+	return type;
+}
+
+u32 f64_double_normaliseround(int dd, struct f64_double *vd, u32 fpscr,
+		u32 exceptions, const char *func);
+
+u32 f64_estimate_sqrt_significand(u32 exponent, u32 significand);
+
+/*
+ * A special flag to tell the normalisation code not to normalise.
+ */
+#define F64_NAN_FLAG	0x100
+
+/*
+ * A bit pattern used to indicate the initial (unset) value of the
+ * exception mask, in case nothing handles an instruction.  This
+ * doesn't include the NAN flag, which get masked out before
+ * we check for an error.
+ */
+#define F64_EXCEPTION_ERROR	((u32)-1 & ~F64_NAN_FLAG)
+
+/*
+ * A flag to tell f64 instruction type.
+ *  OP_SD - the instruction exceptionally writes to a single precision result.
+ *  OP_DD - the instruction exceptionally writes to a double precision result.
+ */
+#define OP_SD		(1 << 0)
+#define OP_DD		(1 << 1)
+
+struct op {
+	u32 (* const fn)(int dd, int dn, int dm, u32 fpscr);
+	u32 flags;
+};
+
+extern void f64_save_state(void *location, u32 fpexc);
+
+/*
+ * Our undef handlers (in entry.S)
+ */
+extern void f64_support_entry(void);

