Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab0CTO0H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:26:07 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:36036 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab0CTO0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:26:03 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Sat, 20 Mar 2010 19:55:54 +0530
Message-Id: <20100320142554.11427.92182.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v1 5/10] X86 details for user space breakpoint assistance.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 support for user breakpoint Infrastructure

This patch provides x86 specific userspace breakpoint assistance
implementation details. It uses the "x86: instruction decoder API" patch
to do validate and analyze the instructions. This analysis is used at
the time of post-processing of breakpoint hit to do the necessary
fix-ups.

Almost all instructions are handled for traditional strategy and
execution out of line strategy. Instruction handled include the RIP
relative instructions.

This patch requires "x86: instruction decoder API" patch.
http://lkml.org/lkml/2009/6/1/459

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 arch/x86/Kconfig                 |    1 
 arch/x86/include/asm/user_bkpt.h |   43 +++
 arch/x86/kernel/Makefile         |    2 
 arch/x86/kernel/user_bkpt.c      |  574 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 620 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/user_bkpt.h
 create mode 100644 arch/x86/kernel/user_bkpt.c


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0eacb1f..851cedc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -53,6 +53,7 @@ config X86
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_LZO
 	select HAVE_HW_BREAKPOINT
+	select HAVE_USER_BKPT
 	select PERF_EVENTS
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
diff --git a/arch/x86/include/asm/user_bkpt.h b/arch/x86/include/asm/user_bkpt.h
new file mode 100644
index 0000000..df8a4a0
--- /dev/null
+++ b/arch/x86/include/asm/user_bkpt.h
@@ -0,0 +1,43 @@
+#ifndef _ASM_USER_BKPT_H
+#define _ASM_USER_BKPT_H
+/*
+ * User-space BreakPoint support (user_bkpt) for x86
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2008-2010
+ * Authors:
+ *	Srikar Dronamraju
+ *	Jim Keniston
+ */
+
+typedef u8 user_bkpt_opcode_t;
+#define MAX_UINSN_BYTES 16
+#define USER_BKPT_XOL_SLOT_BYTES (MAX_UINSN_BYTES)
+
+#ifdef CONFIG_X86_64
+struct bkpt_arch_info {
+	unsigned long rip_target_address;
+	u8 orig_insn[MAX_UINSN_BYTES];
+};
+struct user_bkpt_task_arch_info {
+	unsigned long saved_scratch_register;
+};
+#else
+struct bkpt_arch_info {};
+struct user_bkpt_task_arch_info {};
+#endif
+
+#endif	/* _ASM_USER_BKPT_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 4c58352..98c74b4 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -117,6 +117,8 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 
+obj-$(CONFIG_USER_BKPT)			+= user_bkpt.o
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/user_bkpt.c b/arch/x86/kernel/user_bkpt.c
new file mode 100644
index 0000000..cf08a12
--- /dev/null
+++ b/arch/x86/kernel/user_bkpt.c
@@ -0,0 +1,574 @@
+/*
+ * User-space BreakPoint support (user_bkpt) for x86
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2008-2010
+ * Authors:
+ *	Srikar Dronamraju
+ *	Jim Keniston
+ */
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/ptrace.h>
+#include <linux/user_bkpt.h>
+#include <asm/insn.h>
+
+#ifdef CONFIG_X86_32
+#define is_32bit_app(tsk) 1
+#else
+#define is_32bit_app(tsk) (test_tsk_thread_flag(tsk, TIF_IA32))
+#endif
+
+#define USER_BKPT_FIX_RIP_AX	0x8000
+#define USER_BKPT_FIX_RIP_CX	0x4000
+
+/* Adaptations for mhiramat x86 decoder v14. */
+#define OPCODE1(insn) ((insn)->opcode.bytes[0])
+#define OPCODE2(insn) ((insn)->opcode.bytes[1])
+#define OPCODE3(insn) ((insn)->opcode.bytes[2])
+#define MODRM_REG(insn) X86_MODRM_REG(insn->modrm.value)
+
+static void set_ip(struct pt_regs *regs, unsigned long vaddr)
+{
+	regs->ip = vaddr;
+}
+
+#ifdef CONFIG_X86_64
+static bool is_riprel_insn(struct user_bkpt *user_bkpt)
+{
+	return ((user_bkpt->fixups &
+			(USER_BKPT_FIX_RIP_AX | USER_BKPT_FIX_RIP_CX)) != 0);
+}
+
+static void cancel_xol(struct task_struct *tsk, struct user_bkpt *user_bkpt)
+{
+	if (is_riprel_insn(user_bkpt)) {
+		/*
+		 * We rewrote user_bkpt->insn to use indirect addressing rather
+		 * than rip-relative addressing for XOL.  For
+		 * single-stepping inline, put back the original instruction.
+		 */
+		memcpy(user_bkpt->insn, user_bkpt->arch_info.orig_insn,
+							MAX_UINSN_BYTES);
+		user_bkpt->strategy &= ~USER_BKPT_HNT_TSKINFO;
+	}
+}
+#endif	/* CONFIG_X86_64 */
+
+static const u32 good_insns_64[256 / 32] = {
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
+	/*      ----------------------------------------------         */
+	W(0x00, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) | /* 00 */
+	W(0x10, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) , /* 10 */
+	W(0x20, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) | /* 20 */
+	W(0x30, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0) , /* 30 */
+	W(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 40 */
+	W(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 50 */
+	W(0x60, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* 60 */
+	W(0x70, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 70 */
+	W(0x80, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 80 */
+	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 90 */
+	W(0xa0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* a0 */
+	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* b0 */
+	W(0xc0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0) | /* c0 */
+	W(0xd0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* d0 */
+	W(0xe0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* e0 */
+	W(0xf0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1)   /* f0 */
+	/*      ----------------------------------------------         */
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
+};
+
+/* Good-instruction tables for 32-bit apps -- copied from i386 uprobes */
+
+static const u32 good_insns_32[256 / 32] = {
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
+	/*      ----------------------------------------------         */
+	W(0x00, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0) | /* 00 */
+	W(0x10, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0) , /* 10 */
+	W(0x20, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1) | /* 20 */
+	W(0x30, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1) , /* 30 */
+	W(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 40 */
+	W(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 50 */
+	W(0x60, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* 60 */
+	W(0x70, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 70 */
+	W(0x80, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 80 */
+	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 90 */
+	W(0xa0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* a0 */
+	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* b0 */
+	W(0xc0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0) | /* c0 */
+	W(0xd0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* d0 */
+	W(0xe0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) | /* e0 */
+	W(0xf0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1)   /* f0 */
+	/*      ----------------------------------------------         */
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
+};
+
+/* Using this for both 64-bit and 32-bit apps */
+static const u32 good_2byte_insns[256 / 32] = {
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
+	/*      ----------------------------------------------         */
+	W(0x00, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1) | /* 00 */
+	W(0x10, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1) , /* 10 */
+	W(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) | /* 20 */
+	W(0x30, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 30 */
+	W(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 40 */
+	W(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 50 */
+	W(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 60 */
+	W(0x70, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1) , /* 70 */
+	W(0x80, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 80 */
+	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 90 */
+	W(0xa0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1) | /* a0 */
+	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1) , /* b0 */
+	W(0xc0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* c0 */
+	W(0xd0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* d0 */
+	W(0xe0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* e0 */
+	W(0xf0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0)   /* f0 */
+	/*      ----------------------------------------------         */
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f         */
+};
+
+/*
+ * opcodes we'll probably never support:
+ * 6c-6d, e4-e5, ec-ed - in
+ * 6e-6f, e6-e7, ee-ef - out
+ * cc, cd - int3, int
+ * cf - iret
+ * d6 - illegal instruction
+ * f1 - int1/icebp
+ * f4 - hlt
+ * fa, fb - cli, sti
+ * 0f - lar, lsl, syscall, clts, sysret, sysenter, sysexit, invd, wbinvd, ud2
+ *
+ * invalid opcodes in 64-bit mode:
+ * 06, 0e, 16, 1e, 27, 2f, 37, 3f, 60-62, 82, c4-c5, d4-d5
+ *
+ * 63 - we support this opcode in x86_64 but not in i386.
+ *
+ * opcodes we may need to refine support for:
+ * 0f - 2-byte instructions: For many of these instructions, the validity
+ * depends on the prefix and/or the reg field.  On such instructions, we
+ * just consider the opcode combination valid if it corresponds to any
+ * valid instruction.
+ * 8f - Group 1 - only reg = 0 is OK
+ * c6-c7 - Group 11 - only reg = 0 is OK
+ * d9-df - fpu insns with some illegal encodings
+ * f2, f3 - repnz, repz prefixes.  These are also the first byte for
+ * certain floating-point instructions, such as addsd.
+ * fe - Group 4 - only reg = 0 or 1 is OK
+ * ff - Group 5 - only reg = 0-6 is OK
+ *
+ * others -- Do we need to support these?
+ * 0f - (floating-point?) prefetch instructions
+ * 07, 17, 1f - pop es, pop ss, pop ds
+ * 26, 2e, 36, 3e - es:, cs:, ss:, ds: segment prefixes --
+ *	but 64 and 65 (fs: and gs:) seem to be used, so we support them
+ * 67 - addr16 prefix
+ * ce - into
+ * f0 - lock prefix
+ */
+
+/*
+ * TODO:
+ * - Where necessary, examine the modrm byte and allow only valid instructions
+ * in the different Groups and fpu instructions.
+ */
+
+static bool is_prefix_bad(struct insn *insn)
+{
+	int i;
+
+	for (i = 0; i < insn->prefixes.nbytes; i++) {
+		switch (insn->prefixes.bytes[i]) {
+		case 0x26:	 /*INAT_PFX_ES   */
+		case 0x2E:	 /*INAT_PFX_CS   */
+		case 0x36:	 /*INAT_PFX_DS   */
+		case 0x3E:	 /*INAT_PFX_SS   */
+		case 0xF0:	 /*INAT_PFX_LOCK */
+			return 1;
+		}
+	}
+	return 0;
+}
+
+static void report_bad_prefix(void)
+{
+	printk(KERN_ERR "user_bkpt does not currently support probing "
+		"instructions with any of the following prefixes: "
+		"cs:, ds:, es:, ss:, lock:\n");
+}
+
+static void report_bad_1byte_opcode(int mode, user_bkpt_opcode_t op)
+{
+	printk(KERN_ERR "In %d-bit apps, "
+		"user_bkpt does not currently support probing "
+		"instructions whose first byte is 0x%2.2x\n", mode, op);
+}
+
+static void report_bad_2byte_opcode(user_bkpt_opcode_t op)
+{
+	printk(KERN_ERR "user_bkpt does not currently support probing "
+		"instructions with the 2-byte opcode 0x0f 0x%2.2x\n", op);
+}
+
+static int validate_insn_32bits(struct user_bkpt *user_bkpt, struct insn *insn)
+{
+	insn_init(insn, user_bkpt->insn, false);
+
+	/* Skip good instruction prefixes; reject "bad" ones. */
+	insn_get_opcode(insn);
+	if (is_prefix_bad(insn)) {
+		report_bad_prefix();
+		return -EPERM;
+	}
+	if (test_bit(OPCODE1(insn), (unsigned long *) good_insns_32))
+		return 0;
+	if (insn->opcode.nbytes == 2) {
+		if (test_bit(OPCODE2(insn),
+					(unsigned long *) good_2byte_insns))
+			return 0;
+		report_bad_2byte_opcode(OPCODE2(insn));
+	} else
+		report_bad_1byte_opcode(32, OPCODE1(insn));
+	return -EPERM;
+}
+
+static int validate_insn_64bits(struct user_bkpt *user_bkpt, struct insn *insn)
+{
+	insn_init(insn, user_bkpt->insn, true);
+
+	/* Skip good instruction prefixes; reject "bad" ones. */
+	insn_get_opcode(insn);
+	if (is_prefix_bad(insn)) {
+		report_bad_prefix();
+		return -EPERM;
+	}
+	if (test_bit(OPCODE1(insn), (unsigned long *) good_insns_64))
+		return 0;
+	if (insn->opcode.nbytes == 2) {
+		if (test_bit(OPCODE2(insn),
+					(unsigned long *) good_2byte_insns))
+			return 0;
+		report_bad_2byte_opcode(OPCODE2(insn));
+	} else
+		report_bad_1byte_opcode(64, OPCODE1(insn));
+	return -EPERM;
+}
+
+/*
+ * Figure out which fixups post_xol() will need to perform, and annotate
+ * user_bkpt->fixups accordingly.  To start with, user_bkpt->fixups is
+ * either zero or it reflects rip-related fixups.
+ */
+static void prepare_fixups(struct user_bkpt *user_bkpt, struct insn *insn)
+{
+	bool fix_ip = true, fix_call = false;	/* defaults */
+	insn_get_opcode(insn);	/* should be a nop */
+
+	switch (OPCODE1(insn)) {
+	case 0xc3:		/* ret/lret */
+	case 0xcb:
+	case 0xc2:
+	case 0xca:
+		/* ip is correct */
+		fix_ip = false;
+		break;
+	case 0xe8:		/* call relative - Fix return addr */
+		fix_call = true;
+		break;
+	case 0x9a:		/* call absolute - Fix return addr, not ip */
+		fix_call = true;
+		fix_ip = false;
+		break;
+	case 0xff:
+	    {
+		int reg;
+		insn_get_modrm(insn);
+		reg = MODRM_REG(insn);
+		if (reg == 2 || reg == 3) {
+			/* call or lcall, indirect */
+			/* Fix return addr; ip is correct. */
+			fix_call = true;
+			fix_ip = false;
+		} else if (reg == 4 || reg == 5) {
+			/* jmp or ljmp, indirect */
+			/* ip is correct. */
+			fix_ip = false;
+		}
+		break;
+	    }
+	case 0xea:		/* jmp absolute -- ip is correct */
+		fix_ip = false;
+		break;
+	default:
+		break;
+	}
+	if (fix_ip)
+		user_bkpt->fixups |= USER_BKPT_FIX_IP;
+	if (fix_call)
+		user_bkpt->fixups |= USER_BKPT_FIX_CALL;
+}
+
+#ifdef CONFIG_X86_64
+static int handle_riprel_insn(struct user_bkpt *user_bkpt, struct insn *insn);
+#endif
+
+static int analyze_insn(struct task_struct *tsk, struct user_bkpt *user_bkpt)
+{
+	int ret;
+	struct insn insn;
+
+	user_bkpt->fixups = 0;
+#ifdef CONFIG_X86_64
+	user_bkpt->arch_info.rip_target_address = 0x0;
+#endif
+
+	if (is_32bit_app(tsk)) {
+		ret = validate_insn_32bits(user_bkpt, &insn);
+		if (ret != 0)
+			return ret;
+	} else {
+		ret = validate_insn_64bits(user_bkpt, &insn);
+		if (ret != 0)
+			return ret;
+	}
+	if (user_bkpt->strategy & USER_BKPT_HNT_INLINE)
+		return 0;
+#ifdef CONFIG_X86_64
+	ret = handle_riprel_insn(user_bkpt, &insn);
+	if (ret == -1)
+		/* rip-relative; can't XOL */
+		return 0;
+	else if (ret == 0)
+		/* not rip-relative */
+		user_bkpt->strategy &= ~USER_BKPT_HNT_TSKINFO;
+#endif
+	prepare_fixups(user_bkpt, &insn);
+	return 0;
+}
+
+#ifdef CONFIG_X86_64
+/*
+ * If user_bkpt->insn doesn't use rip-relative addressing, return 0.  Otherwise,
+ * rewrite the instruction so that it accesses its memory operand
+ * indirectly through a scratch register.  Set user_bkpt->fixups and
+ * user_bkpt->arch_info.rip_target_address accordingly.  (The contents of the
+ * scratch register will be saved before we single-step the modified
+ * instruction, and restored afterward.)  Return 1.
+ *
+ * (... except if the client doesn't support our USER_BKPT_HNT_TSKINFO strategy,
+ * we must suppress XOL for rip-relative instructions: return -1.)
+ *
+ * We do this because a rip-relative instruction can access only a
+ * relatively small area (+/- 2 GB from the instruction), and the XOL
+ * area typically lies beyond that area.  At least for instructions
+ * that store to memory, we can't execute the original instruction
+ * and "fix things up" later, because the misdirected store could be
+ * disastrous.
+ *
+ * Some useful facts about rip-relative instructions:
+ * - There's always a modrm byte.
+ * - There's never a SIB byte.
+ * - The displacement is always 4 bytes.
+ */
+static int handle_riprel_insn(struct user_bkpt *user_bkpt, struct insn *insn)
+{
+	u8 *cursor;
+	u8 reg;
+
+	if (!insn_rip_relative(insn))
+		return 0;
+
+	/*
+	 * We have a rip-relative instruction.  To allow this instruction
+	 * to be single-stepped out of line, the client must provide us
+	 * with a per-task user_bkpt_task_arch_info object.
+	 */
+	if (!(user_bkpt->strategy & USER_BKPT_HNT_TSKINFO)) {
+		user_bkpt->strategy |= USER_BKPT_HNT_INLINE;
+		return -1;
+	}
+	memcpy(user_bkpt->arch_info.orig_insn, user_bkpt->insn,
+							MAX_UINSN_BYTES);
+
+	/*
+	 * Point cursor at the modrm byte.  The next 4 bytes are the
+	 * displacement.  Beyond the displacement, for some instructions,
+	 * is the immediate operand.
+	 */
+	cursor = user_bkpt->insn + insn->prefixes.nbytes
+			+ insn->rex_prefix.nbytes + insn->opcode.nbytes;
+	insn_get_length(insn);
+
+	/*
+	 * Convert from rip-relative addressing to indirect addressing
+	 * via a scratch register.  Change the r/m field from 0x5 (%rip)
+	 * to 0x0 (%rax) or 0x1 (%rcx), and squeeze out the offset field.
+	 */
+	reg = MODRM_REG(insn);
+	if (reg == 0) {
+		/*
+		 * The register operand (if any) is either the A register
+		 * (%rax, %eax, etc.) or (if the 0x4 bit is set in the
+		 * REX prefix) %r8.  In any case, we know the C register
+		 * is NOT the register operand, so we use %rcx (register
+		 * #1) for the scratch register.
+		 */
+		user_bkpt->fixups = USER_BKPT_FIX_RIP_CX;
+		/* Change modrm from 00 000 101 to 00 000 001. */
+		*cursor = 0x1;
+	} else {
+		/* Use %rax (register #0) for the scratch register. */
+		user_bkpt->fixups = USER_BKPT_FIX_RIP_AX;
+		/* Change modrm from 00 xxx 101 to 00 xxx 000 */
+		*cursor = (reg << 3);
+	}
+
+	/* Target address = address of next instruction + (signed) offset */
+	user_bkpt->arch_info.rip_target_address = (long) user_bkpt->vaddr +
+				insn->length + insn->displacement.value;
+	/* Displacement field is gone; slide immediate field (if any) over. */
+	if (insn->immediate.nbytes) {
+		cursor++;
+		memmove(cursor, cursor + insn->displacement.nbytes,
+						insn->immediate.nbytes);
+	}
+	return 1;
+}
+
+/*
+ * If we're emulating a rip-relative instruction, save the contents
+ * of the scratch register and store the target address in that register.
+ */
+static int pre_xol(struct task_struct *tsk, struct user_bkpt *user_bkpt,
+		struct user_bkpt_task_arch_info *tskinfo, struct pt_regs *regs)
+{
+	BUG_ON(!user_bkpt->xol_vaddr);
+	regs->ip = user_bkpt->xol_vaddr;
+	if (user_bkpt->fixups & USER_BKPT_FIX_RIP_AX) {
+		tskinfo->saved_scratch_register = regs->ax;
+		regs->ax = user_bkpt->arch_info.rip_target_address;
+	} else if (user_bkpt->fixups & USER_BKPT_FIX_RIP_CX) {
+		tskinfo->saved_scratch_register = regs->cx;
+		regs->cx = user_bkpt->arch_info.rip_target_address;
+	}
+	return 0;
+}
+#endif
+
+/*
+ * Called by post_xol() to adjust the return address pushed by a call
+ * instruction executed out of line.
+ */
+static int adjust_ret_addr(struct task_struct *tsk, unsigned long sp,
+							long correction)
+{
+	int rasize, ncopied;
+	long ra = 0;
+
+	if (is_32bit_app(tsk))
+		rasize = 4;
+	else
+		rasize = 8;
+	ncopied = user_bkpt_read_vm(tsk, sp, &ra, rasize);
+	if (unlikely(ncopied != rasize))
+		goto fail;
+	ra += correction;
+	ncopied = user_bkpt_write_data(tsk, sp, &ra, rasize);
+	if (unlikely(ncopied != rasize))
+		goto fail;
+	return 0;
+
+fail:
+	printk(KERN_ERR
+		"user_bkpt: Failed to adjust return address after"
+		" single-stepping call instruction;"
+		" pid=%d, sp=%#lx\n", tsk->pid, sp);
+	return -EFAULT;
+}
+
+/*
+ * Called after single-stepping.  user_bkpt->vaddr is the address of the
+ * instruction whose first byte has been replaced by the "int3"
+ * instruction.  To avoid the SMP problems that can occur when we
+ * temporarily put back the original opcode to single-step, we
+ * single-stepped a copy of the instruction.  The address of this
+ * copy is user_bkpt->xol_vaddr.
+ *
+ * This function prepares to resume execution after the single-step.
+ * We have to fix things up as follows:
+ *
+ * Typically, the new ip is relative to the copied instruction.  We need
+ * to make it relative to the original instruction (FIX_IP).  Exceptions
+ * are return instructions and absolute or indirect jump or call instructions.
+ *
+ * If the single-stepped instruction was a call, the return address that
+ * is atop the stack is the address following the copied instruction.  We
+ * need to make it the address following the original instruction (FIX_CALL).
+ *
+ * If the original instruction was a rip-relative instruction such as
+ * "movl %edx,0xnnnn(%rip)", we have instead executed an equivalent
+ * instruction using a scratch register -- e.g., "movl %edx,(%rax)".
+ * We need to restore the contents of the scratch register and adjust
+ * the ip, keeping in mind that the instruction we executed is 4 bytes
+ * shorter than the original instruction (since we squeezed out the offset
+ * field).  (FIX_RIP_AX or FIX_RIP_CX)
+ */
+static int post_xol(struct task_struct *tsk, struct user_bkpt *user_bkpt,
+		struct user_bkpt_task_arch_info *tskinfo, struct pt_regs *regs)
+{
+	/* Typically, the XOL vma is at a high addr, so correction < 0. */
+	long correction = (long) (user_bkpt->vaddr - user_bkpt->xol_vaddr);
+	int result = 0;
+
+#ifdef CONFIG_X86_64
+	if (is_riprel_insn(user_bkpt)) {
+		if (user_bkpt->fixups & USER_BKPT_FIX_RIP_AX)
+			regs->ax = tskinfo->saved_scratch_register;
+		else
+			regs->cx = tskinfo->saved_scratch_register;
+		/*
+		 * The original instruction includes a displacement, and so
+		 * is 4 bytes longer than what we've just single-stepped.
+		 * Fall through to handle stuff like "jmpq *...(%rip)" and
+		 * "callq *...(%rip)".
+		 */
+		correction += 4;
+	}
+#endif
+	if (user_bkpt->fixups & USER_BKPT_FIX_IP)
+		regs->ip += correction;
+	if (user_bkpt->fixups & USER_BKPT_FIX_CALL)
+		result = adjust_ret_addr(tsk, regs->sp, correction);
+	return result;
+}
+
+struct user_bkpt_arch_info user_bkpt_arch_info = {
+	.bkpt_insn = 0xcc,
+	.ip_advancement_by_bkpt_insn = 1,
+	.max_insn_bytes = MAX_UINSN_BYTES,
+#ifdef CONFIG_X86_32
+	.strategies = 0x0,
+#else
+	/* rip-relative instructions require special handling. */
+	.strategies = USER_BKPT_HNT_TSKINFO,
+	.pre_xol = pre_xol,
+	.cancel_xol = cancel_xol,
+#endif
+	.set_ip = set_ip,
+	.analyze_insn = analyze_insn,
+	.post_xol = post_xol,
+};
