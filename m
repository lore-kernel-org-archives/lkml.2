Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab0F1GDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 02:03:47 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:51233 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0F1GDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 02:03:41 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 28 Jun 2010 11:28:35 +0530
Message-Id: <20100628055835.6869.59481.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100628055740.6869.77397.sendpatchset@localhost6.localdomain6>
References: <20100628055740.6869.77397.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv6 2.6.35-rc3-tip 4/12]  uprobes: x86 specific functions for user space breakpointing.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


uprobes: x86 specific functions for user space breakpointing.

Changelog from V5: Merged into uprobes layer.

Changelog from V1:
   set UPROBES_FIX_SLEEPY if post_xol might sleep.

Provides x86 specific functions for instruction analysis and
instruction validation and x86 specific pre-processing and
post-processing of singlestep especially for RIP relative
instructions. Uses "x86: instruction decoder API" for validation and
analysis of user space instructions. This analysis is used at the time
of post-processing of breakpoint hit to do the necessary fix-ups.
There is support for breakpointing RIP relative instructions. However
there are still few instructions that cannot be singlestepped.

Also defines TIF_UPROBE flag for x86.

This patch requires "x86: instruction decoder API"
http://lkml.org/lkml/2009/6/1/459

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 arch/x86/Kconfig                   |    1 
 arch/x86/include/asm/thread_info.h |    2 
 arch/x86/include/asm/uprobes.h     |   43 +++
 arch/x86/kernel/Makefile           |    2 
 arch/x86/kernel/uprobes.c          |  547 ++++++++++++++++++++++++++++++++++++
 5 files changed, 595 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/uprobes.h
 create mode 100644 arch/x86/kernel/uprobes.c


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3069a6d..8f2bdbf 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -54,6 +54,7 @@ config X86
 	select HAVE_KERNEL_LZO
 	select HAVE_HW_BREAKPOINT
 	select HAVE_MIXED_BREAKPOINTS_REGS
+	select ARCH_SUPPORTS_UPROBES
 	select PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI
 	select ANON_INODES
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index f0b6e5d..5b9c9f0 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -84,6 +84,7 @@ struct thread_info {
 #define TIF_SECCOMP		8	/* secure computing */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
 #define TIF_USER_RETURN_NOTIFY	11	/* notify kernel of userspace return */
+#define TIF_UPROBE		12	/* breakpointed or singlestepping */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* 32bit process */
 #define TIF_FORK		18	/* ret_from_fork */
@@ -107,6 +108,7 @@ struct thread_info {
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
 #define _TIF_USER_RETURN_NOTIFY	(1 << TIF_USER_RETURN_NOTIFY)
+#define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
new file mode 100644
index 0000000..035c2c9
--- /dev/null
+++ b/arch/x86/include/asm/uprobes.h
@@ -0,0 +1,43 @@
+#ifndef _ASM_UPROBES_H
+#define _ASM_UPROBES_H
+/*
+ * Userspace Probes (UProbes) for x86
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
+#define UPROBES_XOL_SLOT_BYTES (MAX_UINSN_BYTES)
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
+#endif	/* _ASM_UPROBES_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0925676..f1da575 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -116,6 +116,8 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 
+obj-$(CONFIG_UPROBES)			+= uprobes.o
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
new file mode 100644
index 0000000..1eb85bb
--- /dev/null
+++ b/arch/x86/kernel/uprobes.c
@@ -0,0 +1,547 @@
+/*
+ * Userspace Probes (UProbes) for x86
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
+#include <linux/uprobes.h>
+
+#include <asm/insn.h>
+
+#ifdef CONFIG_X86_32
+#define is_32bit_app(tsk) 1
+#else
+#define is_32bit_app(tsk) (test_tsk_thread_flag(tsk, TIF_IA32))
+#endif
+
+#define UPROBES_FIX_RIP_AX	0x8000
+#define UPROBES_FIX_RIP_CX	0x4000
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
+			(UPROBES_FIX_RIP_AX | UPROBES_FIX_RIP_CX)) != 0);
+}
+
+#endif	/* CONFIG_X86_64 */
+
+#define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
+	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
+	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
+	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
+	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
+	 << (row % 32))
+
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
+/* Good-instruction tables for 32-bit apps */
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
+#undef W
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
+	printk(KERN_ERR "uprobes does not currently support probing "
+		"instructions with any of the following prefixes: "
+		"cs:, ds:, es:, ss:, lock:\n");
+}
+
+static void report_bad_1byte_opcode(int mode, user_bkpt_opcode_t op)
+{
+	printk(KERN_ERR "In %d-bit apps, "
+		"uprobes does not currently support probing "
+		"instructions whose first byte is 0x%2.2x\n", mode, op);
+}
+
+static void report_bad_2byte_opcode(user_bkpt_opcode_t op)
+{
+	printk(KERN_ERR "uprobes does not currently support probing "
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
+		user_bkpt->fixups |= UPROBES_FIX_IP;
+	if (fix_call)
+		user_bkpt->fixups |=
+			(UPROBES_FIX_CALL | UPROBES_FIX_SLEEPY);
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
+	if (is_32bit_app(tsk))
+		ret = validate_insn_32bits(user_bkpt, &insn);
+	else
+		ret = validate_insn_64bits(user_bkpt, &insn);
+	if (ret != 0)
+		return ret;
+#ifdef CONFIG_X86_64
+	ret = handle_riprel_insn(user_bkpt, &insn);
+	if (ret == -1)
+		/* rip-relative; can't XOL */
+		return 0;
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
+		user_bkpt->fixups = UPROBES_FIX_RIP_CX;
+		/* Change modrm from 00 000 101 to 00 000 001. */
+		*cursor = 0x1;
+	} else {
+		/* Use %rax (register #0) for the scratch register. */
+		user_bkpt->fixups = UPROBES_FIX_RIP_AX;
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
+	if (user_bkpt->fixups & UPROBES_FIX_RIP_AX) {
+		tskinfo->saved_scratch_register = regs->ax;
+		regs->ax = user_bkpt->arch_info.rip_target_address;
+	} else if (user_bkpt->fixups & UPROBES_FIX_RIP_CX) {
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
+	ncopied = uprobes_read_vm(tsk, (void __user *) sp, &ra, rasize);
+	if (unlikely(ncopied != rasize))
+		goto fail;
+	ra += correction;
+	ncopied = uprobes_write_data(tsk, (void __user *) sp, &ra, rasize);
+	if (unlikely(ncopied != rasize))
+		goto fail;
+	return 0;
+
+fail:
+	printk(KERN_ERR
+		"uprobes: Failed to adjust return address after"
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
+		if (user_bkpt->fixups & UPROBES_FIX_RIP_AX)
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
+	if (user_bkpt->fixups & UPROBES_FIX_IP)
+		regs->ip += correction;
+	if (user_bkpt->fixups & UPROBES_FIX_CALL)
+		result = adjust_ret_addr(tsk, regs->sp, correction);
+	return result;
+}
+
+struct user_bkpt_arch_info user_bkpt_arch_info = {
+	.bkpt_insn = 0xcc,
+	.ip_advancement_by_bkpt_insn = 1,
+	.max_insn_bytes = MAX_UINSN_BYTES,
+#ifdef CONFIG_X86_64
+	.pre_xol = pre_xol,
+#endif
+	.set_ip = set_ip,
+	.analyze_insn = analyze_insn,
+	.post_xol = post_xol,
+};
