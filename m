Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225Ab2BJLZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 06:25:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759179Ab2BJLZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 06:25:55 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] unwind, dwarf: Add dwarf unwind support
Date: Fri, 10 Feb 2012 12:25:17 +0100
Message-Id: <1328873119-21553-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
References: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding dwarf object to handle unwind processing, mainly:

dwarf-cfi.c
- handles the cfi processing for FDE/CIE instructions

dwarf-expression.c
- handles the expression processing for CFI instructions:
  DW_CFA_def_cfa_expression/DW_CFA_expression

dwarf-fde.c
- handles reading/processing FDE/CIE records
- governs the CFI intruction processing

dwarf-read.c
- data reading functions
---
 arch/x86/include/asm/dwarf.h |   89 ++++++
 arch/x86/kernel/Makefile     |    1 +
 arch/x86/kernel/dwarf.c      |  101 ++++++
 include/linux/dwarf.h        |  161 ++++++++++
 kernel/Makefile              |    5 +
 kernel/dwarf-cfi.c           |  337 ++++++++++++++++++++
 kernel/dwarf-expression.c    |  694 ++++++++++++++++++++++++++++++++++++++++++
 kernel/dwarf-fde.c           |  349 +++++++++++++++++++++
 kernel/dwarf-read.c          |  227 ++++++++++++++
 kernel/dwarf.c               |    7 +
 10 files changed, 1971 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/dwarf.h
 create mode 100644 arch/x86/kernel/dwarf.c
 create mode 100644 include/linux/dwarf.h
 create mode 100644 kernel/dwarf-cfi.c
 create mode 100644 kernel/dwarf-expression.c
 create mode 100644 kernel/dwarf-fde.c
 create mode 100644 kernel/dwarf-read.c
 create mode 100644 kernel/dwarf.c

diff --git a/arch/x86/include/asm/dwarf.h b/arch/x86/include/asm/dwarf.h
new file mode 100644
index 0000000..0592577
--- /dev/null
+++ b/arch/x86/include/asm/dwarf.h
@@ -0,0 +1,89 @@
+/*
+ * Code mostly taken from libunwind (git://git.sv.gnu.org/libunwind.git)
+ * Adding copyright notice as requested:
+ *
+ * Copyright (c) 2002 Hewlett-Packard Co.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining
+ * a copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sublicense, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be
+ * included in all copies or substantial portions of the Software.
+ */
+
+#ifndef _ARCH_X86_KERNEL_DWARF_H
+#define _ARCH_X86_KERNEL_DWARF_H
+
+#include <linux/types.h>
+
+#ifdef __i386__
+typedef uint32_t dwarf_word_t;
+typedef int32_t dwarf_sword_t;
+
+enum {
+	/* Standard x86 registers. */
+	DWARF_X86_EAX,
+	DWARF_X86_ECX,
+	DWARF_X86_EDX,
+	DWARF_X86_EBX,
+	DWARF_X86_ESP,
+	DWARF_X86_EBP,
+	DWARF_X86_ESI,
+	DWARF_X86_EDI,
+	DWARF_X86_EIP,
+	DWARF_X86_EFLAGS,
+	DWARF_X86_TRAPNO,
+	DWARF_X86_ST0,
+	DWARF_X86_ST1,
+	DWARF_X86_ST2,
+	DWARF_X86_ST3,
+	DWARF_X86_ST4,
+	DWARF_X86_ST5,
+	DWARF_X86_ST6,
+	DWARF_X86_ST7
+
+	/* Trating CFA as special register. */
+	DWARF_CFA_REG_COLUMN,
+	DWARF_CFA_OFF_COLUMN,
+
+	DWARF_REGS_NUM,
+	DWARF_SP = DWARF_X86_ESP,
+};
+#else
+typedef uint64_t dwarf_word_t;
+typedef int64_t dwarf_sword_t;
+
+enum {
+	/* Standard x86_64 registers. */
+	DWARF_X86_64_RAX,
+	DWARF_X86_64_RDX,
+	DWARF_X86_64_RCX,
+	DWARF_X86_64_RBX,
+	DWARF_X86_64_RSI,
+	DWARF_X86_64_RDI,
+	DWARF_X86_64_RBP,
+	DWARF_X86_64_RSP,
+	DWARF_X86_64_R8,
+	DWARF_X86_64_R9,
+	DWARF_X86_64_R10,
+	DWARF_X86_64_R11,
+	DWARF_X86_64_R12,
+	DWARF_X86_64_R13,
+	DWARF_X86_64_R14,
+	DWARF_X86_64_R15,
+	DWARF_X86_64_RIP,
+
+	/* Trating CFA as special register. */
+	DWARF_CFA_REG_COLUMN,
+	DWARF_CFA_OFF_COLUMN,
+
+	DWARF_REGS_NUM,
+	DWARF_SP = DWARF_X86_64_RSP,
+};
+#endif /* __i386__ */
+#endif  /* _ARCH_X86_KERNEL_UNWIND_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 5369059..8a7c0ec 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
 obj-$(CONFIG_OF)			+= devicetree.o
+obj-$(CONFIG_UNWIND)			+= dwarf.o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/dwarf.c b/arch/x86/kernel/dwarf.c
new file mode 100644
index 0000000..7f9f108
--- /dev/null
+++ b/arch/x86/kernel/dwarf.c
@@ -0,0 +1,101 @@
+#include <linux/dwarf.h>
+#include <linux/ptrace.h>
+
+dwarf_word_t dwarf_regs_ip(struct dwarf_regs *regs)
+{
+#ifdef __i386__
+	return regs->reg[DWARF_X86_EIP];
+#else
+	return regs->reg[DWARF_X86_64_RIP];
+#endif /* __i386__ */
+}
+
+void dwarf_regs_pt2dwarf(struct pt_regs *pt, struct dwarf_regs *dw)
+{
+#ifdef __i386__
+	dw->reg[DWARF_X86_EAX] = pt->ax;
+	dw->reg[DWARF_X86_ECX] = pt->cx;
+	dw->reg[DWARF_X86_EDX] = pt->dx;
+	dw->reg[DWARF_X86_EBX] = pt->bx;
+	dw->reg[DWARF_X86_ESP] = pt->sp;
+	dw->reg[DWARF_X86_EBP] = pt->bp;
+	dw->reg[DWARF_X86_ESI] = pt->si;
+	dw->reg[DWARF_X86_EDI] = pt->di;
+	dw->reg[DWARF_X86_EIP] = pt->ip;
+	dw->reg[DWARF_X86_EFLAGS] = pt->flags;
+/* WTF???
+	dw->reg[DWARF_X86_TRAPNO]
+	dw->reg[DWARF_X86_ST0]
+	dw->reg[DWARF_X86_ST1]
+	dw->reg[DWARF_X86_ST2]
+	dw->reg[DWARF_X86_ST3]
+	dw->reg[DWARF_X86_ST4]
+	dw->reg[DWARF_X86_ST5]
+	dw->reg[DWARF_X86_ST6]
+	dw->reg[DWARF_X86_ST]
+*/
+#else
+	dw->reg[DWARF_X86_64_RAX] = pt->ax;
+        dw->reg[DWARF_X86_64_RDX] = pt->dx;
+        dw->reg[DWARF_X86_64_RCX] = pt->cx;
+        dw->reg[DWARF_X86_64_RBX] = pt->bx;
+        dw->reg[DWARF_X86_64_RSI] = pt->si;
+        dw->reg[DWARF_X86_64_RDI] = pt->di;
+        dw->reg[DWARF_X86_64_RBP] = pt->bp;
+        dw->reg[DWARF_X86_64_RSP] = pt->sp;
+        dw->reg[DWARF_X86_64_R8] =  pt->r8;
+        dw->reg[DWARF_X86_64_R9] =  pt->r9;
+        dw->reg[DWARF_X86_64_R10] = pt->r10;
+        dw->reg[DWARF_X86_64_R11] = pt->r11;
+        dw->reg[DWARF_X86_64_R12] = pt->r12;
+        dw->reg[DWARF_X86_64_R13] = pt->r13;
+        dw->reg[DWARF_X86_64_R14] = pt->r14;
+        dw->reg[DWARF_X86_64_R15] = pt->r15;
+        dw->reg[DWARF_X86_64_RIP] = pt->ip;
+#endif
+}
+
+void dwarf_regs_dwarf2pt(struct dwarf_regs *dw, struct pt_regs *pt)
+{
+#ifdef __i386__
+	pt->ax = dw->reg[DWARF_X86_EAX];
+	pt->cx = dw->reg[DWARF_X86_ECX];
+	pt->dx = dw->reg[DWARF_X86_EDX];
+	pt->bx = dw->reg[DWARF_X86_EBX];
+	pt->sp = dw->reg[DWARF_X86_ESP];
+	pt->bp = dw->reg[DWARF_X86_EBP];
+	pt->si = dw->reg[DWARF_X86_ESI];
+	pt->di = dw->reg[DWARF_X86_EDI];
+	pt->ip = dw->reg[DWARF_X86_EIP];
+	pt->flags = dw->reg[DWARF_X86_EFLAGS];
+/* WTF???
+	dw->reg[DWARF_X86_TRAPNO]
+	dw->reg[DWARF_X86_ST0]
+	dw->reg[DWARF_X86_ST1]
+	dw->reg[DWARF_X86_ST2]
+	dw->reg[DWARF_X86_ST3]
+	dw->reg[DWARF_X86_ST4]
+	dw->reg[DWARF_X86_ST5]
+	dw->reg[DWARF_X86_ST6]
+	dw->reg[DWARF_X86_ST]
+*/
+#else
+	pt->ax = dw->reg[DWARF_X86_64_RAX];
+	pt->dx = dw->reg[DWARF_X86_64_RDX];
+	pt->cx = dw->reg[DWARF_X86_64_RCX];
+	pt->bx = dw->reg[DWARF_X86_64_RBX];
+	pt->si = dw->reg[DWARF_X86_64_RSI];
+	pt->di = dw->reg[DWARF_X86_64_RDI];
+	pt->bp = dw->reg[DWARF_X86_64_RBP];
+	pt->sp = dw->reg[DWARF_X86_64_RSP];
+	pt->r8 = dw->reg[DWARF_X86_64_R8];
+	pt->r9 = dw->reg[DWARF_X86_64_R9];
+	pt->r10 = dw->reg[DWARF_X86_64_R10];
+	pt->r11 = dw->reg[DWARF_X86_64_R11];
+	pt->r12 = dw->reg[DWARF_X86_64_R12];
+	pt->r13 = dw->reg[DWARF_X86_64_R13];
+	pt->r14 = dw->reg[DWARF_X86_64_R14];
+	pt->r15 = dw->reg[DWARF_X86_64_R15];
+	pt->ip = dw->reg[DWARF_X86_64_RIP];
+#endif
+}
diff --git a/include/linux/dwarf.h b/include/linux/dwarf.h
new file mode 100644
index 0000000..6cebc89
--- /dev/null
+++ b/include/linux/dwarf.h
@@ -0,0 +1,161 @@
+/*
+ * Code mostly taken from libunwind (git://git.sv.gnu.org/libunwind.git)
+ * Adding copyright notice as requested:
+ *
+ * Copyright (c) 2002 Hewlett-Packard Co.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining
+ * a copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sublicense, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be
+ * included in all copies or substantial portions of the Software.
+ */
+
+#ifndef DWARF_H
+#define DWARF_H
+
+#include <linux/ptrace.h>
+#include <asm/dwarf.h>
+
+extern int dwarf_debug;
+#define DWARF_DEBUG(cond, fmt, args...) \
+do { \
+        if (cond > dwarf_debug) \
+                break; \
+	printk("[%s:%05d] ", __FUNCTION__, __LINE__); \
+        printk(fmt, ## args); \
+} while(0)
+
+#define DWARF_CIE_VERSION	3
+#define DWARF_CIE_VERSION_GCC	1
+
+#define DWARF_CFA_OPCODE_MASK	0xc0
+#define DWARF_CFA_OPERAND_MASK	0x3f
+
+#define DW_EH_PE_FORMAT_MASK	0x0f	/* format of the encoded value */
+#define DW_EH_PE_APPL_MASK	0x70	/* how the value is to be applied */
+/*
+ * Flag bit.  If set, the resulting pointer is the address of the word
+ * that contains the final address.
+ */
+#define DW_EH_PE_indirect	0x80
+
+/* Pointer-encoding formats: */
+#define DW_EH_PE_omit		0xff
+#define DW_EH_PE_ptr		0x00	/* pointer-sized unsigned value */
+#define DW_EH_PE_uleb128	0x01	/* unsigned LE base-128 value */
+#define DW_EH_PE_udata2		0x02	/* unsigned 16-bit value */
+#define DW_EH_PE_udata4		0x03	/* unsigned 32-bit value */
+#define DW_EH_PE_udata8		0x04	/* unsigned 64-bit value */
+#define DW_EH_PE_sleb128	0x09	/* signed LE base-128 value */
+#define DW_EH_PE_sdata2		0x0a	/* signed 16-bit value */
+#define DW_EH_PE_sdata4		0x0b	/* signed 32-bit value */
+#define DW_EH_PE_sdata8		0x0c	/* signed 64-bit value */
+
+/* Pointer-encoding application: */
+#define DW_EH_PE_absptr		0x00	/* absolute value */
+#define DW_EH_PE_pcrel		0x10	/* rel. to addr. of encoded value */
+#define DW_EH_PE_textrel	0x20	/* text-relative (GCC-specific???) */
+#define DW_EH_PE_datarel	0x30	/* data-relative */
+/*
+ * The following are not documented by LSB v1.3, yet they are used by
+ * GCC, presumably they aren't documented by LSB since they aren't
+ * used on Linux:
+ */
+#define DW_EH_PE_funcrel	0x40	/* start-of-procedure-relative */
+#define DW_EH_PE_aligned	0x50	/* aligned pointer */
+
+enum {
+        DWARF_WHERE_UNDEF,      /* register isn't saved at all */
+        DWARF_WHERE_SAME,       /* register has same value as in prev. frame */
+        DWARF_WHERE_CFAREL,     /* register saved at CFA-relative address */
+        DWARF_WHERE_REG,        /* register saved in another register */
+        DWARF_WHERE_EXPR,       /* register saved */
+};
+
+struct dwarf_cie {
+	dwarf_word_t cie_instr_start;
+	dwarf_word_t cie_instr_end;
+	dwarf_word_t code_align;
+	dwarf_word_t data_align;
+	dwarf_word_t ret_addr_column;
+        uint8_t lsda_encoding;
+	uint8_t fde_encoding;
+	unsigned int sized_augmentation : 1;
+};
+
+struct dwarf_fde {
+	struct dwarf_cie cie;
+        dwarf_word_t start_ip;
+        dwarf_word_t end_ip;
+        dwarf_word_t fde_instr_start;
+        dwarf_word_t fde_instr_end;
+        dwarf_word_t lsda;
+};
+
+struct dwarf_save_loc {
+	int where;
+	dwarf_word_t val;
+};
+
+struct dwarf_regs_state {
+	struct dwarf_save_loc reg[DWARF_REGS_NUM];
+	struct dwarf_regs_state *next;
+};
+
+struct dwarf_state {
+	struct dwarf_regs_state rs_initial;
+	struct dwarf_regs_state rs_current;
+};
+
+struct dwarf_regs {
+	dwarf_word_t reg[DWARF_REGS_NUM];
+	dwarf_word_t cfa;
+};
+
+dwarf_word_t dwarf_regs_ip(struct dwarf_regs *regs);
+void dwarf_regs_pt2dwarf(struct pt_regs *pt, struct dwarf_regs *dw);
+void dwarf_regs_dwarf2pt(struct dwarf_regs *dw, struct pt_regs *pt);
+
+uint8_t  dwarf_readu8(dwarf_word_t *addr);
+uint16_t dwarf_readu16(dwarf_word_t *addr);
+uint32_t dwarf_readu32(dwarf_word_t *addr);
+uint64_t dwarf_readu64(dwarf_word_t *addr);
+int8_t   dwarf_reads8(dwarf_word_t *addr);
+int16_t  dwarf_reads16(dwarf_word_t *addr);
+int32_t  dwarf_reads32(dwarf_word_t *addr);
+int64_t  dwarf_reads64(dwarf_word_t *addr);
+
+dwarf_word_t dwarf_read_sleb128(dwarf_word_t *addr);
+dwarf_word_t dwarf_read_uleb128(dwarf_word_t *addr);
+
+dwarf_word_t dwarf_readw(dwarf_word_t *addr);
+
+int dwarf_read_pointer(dwarf_word_t *addr,
+		       unsigned char encoding,
+		       dwarf_word_t *valp);
+
+int dwarf_fde_init(struct dwarf_fde *fde, void *data);
+int dwarf_fde_process(struct dwarf_fde *fde, struct dwarf_regs *regs);
+
+int dwarf_cfi_run(struct dwarf_fde *fde, struct dwarf_state *state,
+		  dwarf_word_t ip, dwarf_word_t start_addr,
+		  dwarf_word_t end_addr);
+
+int dwarf_expression(struct dwarf_regs *regs, dwarf_word_t *addr,
+		     dwarf_word_t len, dwarf_word_t *val);
+
+static inline
+void dwarf_setreg(struct dwarf_regs_state *rs, dwarf_word_t regnum,
+		  int where, dwarf_word_t val)
+{
+	rs->reg[regnum].where = where;
+	rs->reg[regnum].val = val;
+}
+
+#endif /* DWARF_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index 2d9de86..3ddbc72 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -107,6 +107,11 @@ obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
 obj-$(CONFIG_CRASH_DUMP) += crash_dump.o
 obj-$(CONFIG_JUMP_LABEL) += jump_label.o
+obj-$(CONFIG_UNWIND) += dwarf.o
+obj-$(CONFIG_UNWIND) += dwarf-read.o
+obj-$(CONFIG_UNWIND) += dwarf-cfi.o
+obj-$(CONFIG_UNWIND) += dwarf-expression.o
+obj-$(CONFIG_UNWIND) += dwarf-fde.o
 
 $(obj)/configs.o: $(obj)/config_data.h
 
diff --git a/kernel/dwarf-cfi.c b/kernel/dwarf-cfi.c
new file mode 100644
index 0000000..9b19a3b
--- /dev/null
+++ b/kernel/dwarf-cfi.c
@@ -0,0 +1,337 @@
+/*
+ * Code mostly taken from libunwind (git://git.sv.gnu.org/libunwind.git)
+ * Adding copyright notice as requested:
+ *
+ * Copyright (c) 2002 Hewlett-Packard Co.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining
+ * a copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sublicense, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be
+ * included in all copies or substantial portions of the Software.
+ */
+
+#include <linux/kernel.h>
+#include <linux/dwarf.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+
+typedef enum {
+	DW_CFA_advance_loc		= 0x40,
+	DW_CFA_offset			= 0x80,
+	DW_CFA_restore			= 0xc0,
+	DW_CFA_nop			= 0x00,
+	DW_CFA_set_loc			= 0x01,
+	DW_CFA_advance_loc1		= 0x02,
+	DW_CFA_advance_loc2		= 0x03,
+	DW_CFA_advance_loc4		= 0x04,
+	DW_CFA_offset_extended		= 0x05,
+	DW_CFA_restore_extended		= 0x06,
+	DW_CFA_undefined		= 0x07,
+	DW_CFA_same_value		= 0x08,
+	DW_CFA_register			= 0x09,
+	DW_CFA_remember_state		= 0x0a,
+	DW_CFA_restore_state		= 0x0b,
+	DW_CFA_def_cfa			= 0x0c,
+	DW_CFA_def_cfa_register		= 0x0d,
+	DW_CFA_def_cfa_offset		= 0x0e,
+	DW_CFA_def_cfa_expression	= 0x0f,
+	DW_CFA_expression		= 0x10,
+	DW_CFA_offset_extended_sf	= 0x11,
+	DW_CFA_def_cfa_sf		= 0x12,
+	DW_CFA_def_cfa_offset_sf	= 0x13,
+	DW_CFA_lo_user			= 0x1c,
+	DW_CFA_MIPS_advance_loc8	= 0x1d,
+	DW_CFA_GNU_window_save		= 0x2d,
+	DW_CFA_GNU_args_size		= 0x2e,
+	DW_CFA_GNU_negative_offset_extended	= 0x2f,
+	DW_CFA_hi_user			= 0x3c
+} dwarf_cfa_t;
+
+static int read_regnum(dwarf_word_t *addr, dwarf_word_t *valp)
+{
+	*valp = dwarf_read_uleb128(addr);
+
+	if (*valp >= DWARF_REGS_NUM) {
+		DWARF_DEBUG(1, "Invalid register number %u\n", (unsigned int) *valp);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+int dwarf_cfi_run(struct dwarf_fde *fde, struct dwarf_state *state,
+                  dwarf_word_t ip, dwarf_word_t start_addr,
+		  dwarf_word_t end_addr)
+{
+	struct dwarf_regs_state *new_rs, *old_rs, *rs_stack = NULL;
+	dwarf_word_t curr_ip, operand = 0, regnum, val;
+	dwarf_word_t addr = start_addr;
+	dwarf_word_t len;
+	uint8_t u8, op;
+	uint16_t u16;
+	uint32_t u32;
+	int ret = 0;
+
+	curr_ip = fde->start_ip;
+
+	/*
+	 * Process everything up to and including the current 'ip',
+	 * including all the DW_CFA_advance_loc instructions.  See
+	 * 'c->use_prev_instr' use in 'fetch_proc_info' for details.
+	 */
+	while (curr_ip <= ip && addr < end_addr) {
+		op = dwarf_readu8(&addr);
+
+		if (op & DWARF_CFA_OPCODE_MASK) {
+			operand = op & DWARF_CFA_OPERAND_MASK;
+			op &= ~DWARF_CFA_OPERAND_MASK;
+		}
+
+		switch ((dwarf_cfa_t) op) {
+		case DW_CFA_advance_loc:
+			curr_ip += operand * fde->cie.code_align;
+			DWARF_DEBUG(1, "CFA_advance_loc to 0x%lx\n", (long) curr_ip);
+			break;
+
+		case DW_CFA_advance_loc1:
+			u8 = dwarf_readu8(&addr);
+			curr_ip += u8 * fde->cie.code_align;
+			DWARF_DEBUG(1, "CFA_advance_loc1 to 0x%lx\n", (long) curr_ip);
+			break;
+
+		case DW_CFA_advance_loc2:
+			u16 = dwarf_readu16(&addr);
+			curr_ip += u16 * fde->cie.code_align;
+			DWARF_DEBUG(1, "CFA_advance_loc2 to 0x%lx\n", (long) curr_ip);
+			break;
+
+		case DW_CFA_advance_loc4:
+			u32 = dwarf_readu32(&addr);
+			curr_ip += u32 * fde->cie.code_align;
+			DWARF_DEBUG(1, "CFA_advance_loc4 to 0x%lx\n", (long) curr_ip);
+			break;
+
+		case DW_CFA_MIPS_advance_loc8:
+			DWARF_DEBUG(1, "FAILED DW_CFA_MIPS_advance_loc8\n");
+			goto fail;
+
+		case DW_CFA_offset:
+			regnum = operand;
+			if (regnum >= DWARF_REGS_NUM) {
+				DWARF_DEBUG(1, "Invalid register number %u in DW_cfa_OFFSET\n",
+					(unsigned int) regnum);
+				ret = -EINVAL;
+				goto fail;
+			}
+			val = dwarf_read_uleb128(&addr);
+			dwarf_setreg(&state->rs_current, regnum, DWARF_WHERE_CFAREL, val * fde->cie.data_align);
+			DWARF_DEBUG(1, "CFA_offset r%lu at cfa+0x%lx\n", (long) regnum, (long) (val * fde->cie.data_align));
+			break;
+
+		case DW_CFA_offset_extended:
+			if ((ret = read_regnum(&addr, &regnum)) < 0)
+				goto fail;
+			val = dwarf_read_uleb128(&addr);
+			dwarf_setreg(&state->rs_current, regnum, DWARF_WHERE_CFAREL, val * fde->cie.data_align);
+			DWARF_DEBUG(1, "CFA_offset_extended r%lu at cf+0x%lx\n", (long) regnum, (long) (val * fde->cie.data_align));
+			break;
+
+		case DW_CFA_offset_extended_sf:
+			if ((ret = read_regnum(&addr, &regnum)) < 0)
+				goto fail;
+
+			val = dwarf_read_sleb128(&addr);
+			dwarf_setreg(&state->rs_current, regnum, DWARF_WHERE_CFAREL, val * fde->cie.data_align);
+			DWARF_DEBUG(1, "CFA_offset_extended_sf r%lu at cf+0x%lx\n", (long) regnum, (long) (val * fde->cie.data_align));
+			break;
+
+		case DW_CFA_restore:
+			regnum = operand;
+			if (regnum >= DWARF_REGS_NUM) {
+				DWARF_DEBUG(1, "Invalid register number %u in DW_CFA_restore\n", (unsigned int) regnum);
+				ret = -EINVAL;
+				goto fail;
+			}
+			state->rs_current.reg[regnum] = state->rs_initial.reg[regnum];
+			DWARF_DEBUG(1, "CFA_restore r%lu\n", (long) regnum);
+			break;
+
+		case DW_CFA_restore_extended:
+			regnum = dwarf_read_uleb128(&addr);
+			if (regnum >= DWARF_REGS_NUM) {
+				DWARF_DEBUG(1, "Invalid register number %u in "
+					"DW_CFA_restore_extended\n", (unsigned int) regnum);
+				ret = -EINVAL;
+				goto fail;
+			}
+			state->rs_current.reg[regnum] = state->rs_initial.reg[regnum];
+			DWARF_DEBUG(1, "CFA_restore_extended r%lu\n", (long) regnum);
+			break;
+
+		case DW_CFA_nop:
+			DWARF_DEBUG(1, "DW_CFA_nop\n");
+			break;
+
+		case DW_CFA_set_loc:
+			if ((ret = dwarf_read_pointer(&addr, fde->cie.fde_encoding, &curr_ip)) < 0)
+				goto fail;
+			DWARF_DEBUG(1, "CFA_set_loc to 0x%lx\n", (long) curr_ip);
+			break;
+
+		case DW_CFA_undefined:
+			if ((ret = read_regnum(&addr, &regnum)) < 0)
+				goto fail;
+			dwarf_setreg(&state->rs_current, regnum, DWARF_WHERE_UNDEF, 0);
+			DWARF_DEBUG(1, "CFA_undefined r%lu\n", (long) regnum);
+			break;
+
+		case DW_CFA_same_value:
+			if ((ret = read_regnum(&addr, &regnum)) < 0)
+				goto fail;
+			dwarf_setreg(&state->rs_current, regnum, DWARF_WHERE_SAME, 0);
+			DWARF_DEBUG(1, "CFA_same_value r%lu\n", (long) regnum);
+			break;
+
+		case DW_CFA_register:
+			if ((ret = read_regnum(&addr, &regnum)) < 0)
+				goto fail;
+
+			val = dwarf_read_uleb128(&addr);
+			dwarf_setreg(&state->rs_current, regnum, DWARF_WHERE_REG, val);
+			DWARF_DEBUG(1, "CFA_register r%lu to r%lu\n", (long) regnum, (long) val);
+			break;
+
+		case DW_CFA_remember_state:
+			new_rs = kzalloc(sizeof(*new_rs), GFP_KERNEL);
+			if (!new_rs) {
+				DWARF_DEBUG(1, "Out of memory in DW_CFA_remember_state\n");
+				ret = -ENOMEM;
+				goto fail;
+			}
+
+			memcpy (new_rs->reg, &state->rs_current.reg, sizeof(new_rs->reg));
+			new_rs->next = rs_stack;
+			rs_stack = new_rs;
+			DWARF_DEBUG(1, "CFA_remember_state\n");
+			break;
+
+		case DW_CFA_restore_state:
+			if (!rs_stack) {
+				DWARF_DEBUG(1, "register-state stack underflow\n");
+				ret = -EINVAL;
+				goto fail;
+			}
+
+			memcpy(&state->rs_current.reg, &rs_stack->reg, sizeof(rs_stack->reg));
+			old_rs = rs_stack;
+			rs_stack = rs_stack->next;
+			kfree(old_rs);
+			DWARF_DEBUG(1, "CFA_restore_state\n");
+			break;
+
+		case DW_CFA_def_cfa:
+			if ((ret = read_regnum(&addr, &regnum)) < 0)
+				goto fail;
+
+			val = dwarf_read_uleb128(&addr);
+			dwarf_setreg(&state->rs_current, DWARF_CFA_REG_COLUMN, DWARF_WHERE_REG, regnum);
+			dwarf_setreg(&state->rs_current, DWARF_CFA_OFF_COLUMN, 0, val);
+			DWARF_DEBUG(1, "CFA_def_cfa r%lu+0x%lx\n", (long) regnum, (long) val);
+			break;
+
+		case DW_CFA_def_cfa_sf:
+			if ((ret = read_regnum(&addr, &regnum)) < 0)
+				goto fail;
+
+			val = dwarf_read_sleb128(&addr);
+			dwarf_setreg(&state->rs_current, DWARF_CFA_REG_COLUMN, DWARF_WHERE_REG, regnum);
+			dwarf_setreg(&state->rs_current, DWARF_CFA_OFF_COLUMN, 0, val * fde->cie.data_align);
+			DWARF_DEBUG(1, "CFA_def_cfa_sf r%lu+0x%lx\n", (long) regnum, (long) (val * fde->cie.data_align));
+			break;
+
+		case DW_CFA_def_cfa_register:
+			if ((ret = read_regnum(&addr, &regnum)) < 0)
+				goto fail;
+			dwarf_setreg(&state->rs_current, DWARF_CFA_REG_COLUMN, DWARF_WHERE_REG, regnum);
+			DWARF_DEBUG(1, "CFA_def_cfa_register r%lu\n", (long) regnum);
+			break;
+
+		case DW_CFA_def_cfa_offset:
+			val = dwarf_read_uleb128(&addr);
+			dwarf_setreg(&state->rs_current, DWARF_CFA_OFF_COLUMN, 0, val);
+			DWARF_DEBUG(1, "CFA_def_cfa_offset 0x%lx\n", (long) val);
+			break;
+
+		case DW_CFA_def_cfa_offset_sf:
+			val = dwarf_read_sleb128(&addr);
+			dwarf_setreg(&state->rs_current, DWARF_CFA_OFF_COLUMN, 0, val * fde->cie.data_align);
+			DWARF_DEBUG(1, "CFA_def_cfa_offset_sf 0x%lx\n", (long) (val * fde->cie.data_align));
+			break;
+
+		case DW_CFA_def_cfa_expression:
+			dwarf_setreg(&state->rs_current, DWARF_CFA_REG_COLUMN, DWARF_WHERE_EXPR, addr);
+
+			len = dwarf_read_uleb128(&addr);
+			DWARF_DEBUG(1, "CFA_def_cfa_expr @ 0x%lx [%lu bytes]\n", (long) addr, (long) len);
+			addr += len;
+			break;
+
+		case DW_CFA_expression:
+			if ((ret = read_regnum(&addr, &regnum)) < 0)
+				goto fail;
+
+			/* Save the address of the DW_FORM_block for later evaluation. */
+			dwarf_setreg(&state->rs_current, regnum, DWARF_WHERE_EXPR, addr);
+
+			len = dwarf_read_uleb128(&addr);
+			DWARF_DEBUG(1, "CFA_expression r%lu @ 0x%lx [%lu bytes]\n", (long) regnum, (long) addr, (long) len);
+			addr += len;
+			break;
+
+/* XXX NOT USED?
+		case DW_CFA_GNU_args_size:
+			if ((ret = dwarf_read_uleb128(&addr, &val)) < 0)
+				goto fail;
+			sr->args_size = val;
+			printk("CFA_GNU_args_size %lu\n", (long) val);
+			break;
+*/
+		case DW_CFA_GNU_negative_offset_extended:
+			if ((ret = read_regnum(&addr, &regnum)) < 0)
+				goto fail;
+
+			val = dwarf_read_uleb128(&addr);
+			dwarf_setreg(&state->rs_current, regnum, DWARF_WHERE_CFAREL, -(val * fde->cie.data_align));
+			DWARF_DEBUG(1, "CFA_GNU_negative_offset_extended cfa+0x%lx\n", (long) -(val * fde->cie.data_align));
+			break;
+
+		case DW_CFA_GNU_window_save:
+			/* This is a special CFA to handle all 16 windowed registers
+			   on SPARC. FALL THROUGH */
+
+		case DW_CFA_lo_user:
+		case DW_CFA_hi_user:
+		default:
+			printk("Unexpected CFA opcode 0x%x\n", op);
+			ret = -EINVAL;
+			goto fail;
+		}
+	}
+
+ fail:
+	DWARF_DEBUG(1, "run_cfi_program ret %d\n", ret);
+
+	/* Free the register-state stack, if not empty already.  */
+	while (rs_stack) {
+		old_rs = rs_stack;
+		rs_stack = rs_stack->next;
+		kfree(old_rs);
+	}
+
+	return ret;
+}
diff --git a/kernel/dwarf-expression.c b/kernel/dwarf-expression.c
new file mode 100644
index 0000000..3ed61f2
--- /dev/null
+++ b/kernel/dwarf-expression.c
@@ -0,0 +1,694 @@
+/*
+ * Code mostly taken from libunwind (git://git.sv.gnu.org/libunwind.git)
+ * Adding copyright notice as requested:
+ *
+ * Copyright (c) 2002 Hewlett-Packard Co.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining
+ * a copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sublicense, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be
+ * included in all copies or substantial portions of the Software.
+ */
+
+#include <linux/kernel.h>
+#include <linux/dwarf.h>
+#include <linux/errno.h>
+
+#define MAX_EXPR_STACK_SIZE	64
+
+#define NUM_OPERANDS(signature)	(((signature) >> 6) & 0x3)
+#define OPND1_TYPE(signature)	(((signature) >> 3) & 0x7)
+#define OPND2_TYPE(signature)	(((signature) >> 0) & 0x7)
+
+#define OPND_SIGNATURE(n, t1, t2) (((n) << 6) | ((t1) << 3) | ((t2) << 0))
+#define OPND1(t1)		OPND_SIGNATURE(1, t1, 0)
+#define OPND2(t1, t2)		OPND_SIGNATURE(2, t1, t2)
+
+#define VAL8	0x0
+#define VAL16	0x1
+#define VAL32	0x2
+#define VAL64	0x3
+#define ULEB128	0x4
+#define SLEB128	0x5
+#define OFFSET	0x6	/* 32-bit offset for 32-bit DWARF, 64-bit otherwise */
+#define ADDR	0x7	/* Machine address.  */
+
+enum {
+	DW_OP_addr			= 0x03,
+	DW_OP_deref			= 0x06,
+	DW_OP_const1u			= 0x08,
+	DW_OP_const1s			= 0x09,
+	DW_OP_const2u			= 0x0a,
+	DW_OP_const2s			= 0x0b,
+	DW_OP_const4u			= 0x0c,
+	DW_OP_const4s			= 0x0d,
+	DW_OP_const8u			= 0x0e,
+	DW_OP_const8s			= 0x0f,
+	DW_OP_constu			= 0x10,
+	DW_OP_consts			= 0x11,
+	DW_OP_dup			= 0x12,
+	DW_OP_drop			= 0x13,
+	DW_OP_over			= 0x14,
+	DW_OP_pick			= 0x15,
+	DW_OP_swap			= 0x16,
+	DW_OP_rot			= 0x17,
+	DW_OP_xderef			= 0x18,
+	DW_OP_abs			= 0x19,
+	DW_OP_and			= 0x1a,
+	DW_OP_div			= 0x1b,
+	DW_OP_minus			= 0x1c,
+	DW_OP_mod			= 0x1d,
+	DW_OP_mul			= 0x1e,
+	DW_OP_neg			= 0x1f,
+	DW_OP_not			= 0x20,
+	DW_OP_or			= 0x21,
+	DW_OP_plus			= 0x22,
+	DW_OP_plus_uconst		= 0x23,
+	DW_OP_shl			= 0x24,
+	DW_OP_shr			= 0x25,
+	DW_OP_shra			= 0x26,
+	DW_OP_xor			= 0x27,
+	DW_OP_skip			= 0x2f,
+	DW_OP_bra			= 0x28,
+	DW_OP_eq			= 0x29,
+	DW_OP_ge			= 0x2a,
+	DW_OP_gt			= 0x2b,
+	DW_OP_le			= 0x2c,
+	DW_OP_lt			= 0x2d,
+	DW_OP_ne			= 0x2e,
+	DW_OP_lit0			= 0x30,
+	DW_OP_lit1,  DW_OP_lit2,  DW_OP_lit3,  DW_OP_lit4,  DW_OP_lit5,
+	DW_OP_lit6,  DW_OP_lit7,  DW_OP_lit8,  DW_OP_lit9,  DW_OP_lit10,
+	DW_OP_lit11, DW_OP_lit12, DW_OP_lit13, DW_OP_lit14, DW_OP_lit15,
+	DW_OP_lit16, DW_OP_lit17, DW_OP_lit18, DW_OP_lit19, DW_OP_lit20,
+	DW_OP_lit21, DW_OP_lit22, DW_OP_lit23, DW_OP_lit24, DW_OP_lit25,
+	DW_OP_lit26, DW_OP_lit27, DW_OP_lit28, DW_OP_lit29, DW_OP_lit30,
+	DW_OP_lit31,
+	DW_OP_reg0			= 0x50,
+	DW_OP_reg1,  DW_OP_reg2,  DW_OP_reg3,  DW_OP_reg4,  DW_OP_reg5,
+	DW_OP_reg6,  DW_OP_reg7,  DW_OP_reg8,  DW_OP_reg9,  DW_OP_reg10,
+	DW_OP_reg11, DW_OP_reg12, DW_OP_reg13, DW_OP_reg14, DW_OP_reg15,
+	DW_OP_reg16, DW_OP_reg17, DW_OP_reg18, DW_OP_reg19, DW_OP_reg20,
+	DW_OP_reg21, DW_OP_reg22, DW_OP_reg23, DW_OP_reg24, DW_OP_reg25,
+	DW_OP_reg26, DW_OP_reg27, DW_OP_reg28, DW_OP_reg29, DW_OP_reg30,
+	DW_OP_reg31,
+	DW_OP_breg0			= 0x70,
+	DW_OP_breg1,  DW_OP_breg2,  DW_OP_breg3,  DW_OP_breg4,  DW_OP_breg5,
+	DW_OP_breg6,  DW_OP_breg7,  DW_OP_breg8,  DW_OP_breg9,  DW_OP_breg10,
+	DW_OP_breg11, DW_OP_breg12, DW_OP_breg13, DW_OP_breg14, DW_OP_breg15,
+	DW_OP_breg16, DW_OP_breg17, DW_OP_breg18, DW_OP_breg19, DW_OP_breg20,
+	DW_OP_breg21, DW_OP_breg22, DW_OP_breg23, DW_OP_breg24, DW_OP_breg25,
+	DW_OP_breg26, DW_OP_breg27, DW_OP_breg28, DW_OP_breg29, DW_OP_breg30,
+	DW_OP_breg31,
+	DW_OP_regx			= 0x90,
+	DW_OP_fbreg			= 0x91,
+	DW_OP_bregx			= 0x92,
+	DW_OP_piece			= 0x93,
+	DW_OP_deref_size		= 0x94,
+	DW_OP_xderef_size		= 0x95,
+	DW_OP_nop			= 0x96,
+	DW_OP_push_object_address	= 0x97,
+	DW_OP_call2			= 0x98,
+	DW_OP_call4			= 0x99,
+	DW_OP_call_ref			= 0x9a,
+	DW_OP_lo_user			= 0xe0,
+	DW_OP_hi_user			= 0xff
+};
+
+static uint8_t operands[256] =
+{
+	[DW_OP_addr] =		OPND1 (ADDR),
+	[DW_OP_const1u] =		OPND1 (VAL8),
+	[DW_OP_const1s] =		OPND1 (VAL8),
+	[DW_OP_const2u] =		OPND1 (VAL16),
+	[DW_OP_const2s] =		OPND1 (VAL16),
+	[DW_OP_const4u] =		OPND1 (VAL32),
+	[DW_OP_const4s] =		OPND1 (VAL32),
+	[DW_OP_const8u] =		OPND1 (VAL64),
+	[DW_OP_const8s] =		OPND1 (VAL64),
+	[DW_OP_pick] =		OPND1 (VAL8),
+	[DW_OP_plus_uconst] =	OPND1 (ULEB128),
+	[DW_OP_skip] =		OPND1 (VAL16),
+	[DW_OP_bra] =		OPND1 (VAL16),
+	[DW_OP_breg0 +  0] =	OPND1 (SLEB128),
+	[DW_OP_breg0 +  1] =	OPND1 (SLEB128),
+	[DW_OP_breg0 +  2] =	OPND1 (SLEB128),
+	[DW_OP_breg0 +  3] =	OPND1 (SLEB128),
+	[DW_OP_breg0 +  4] =	OPND1 (SLEB128),
+	[DW_OP_breg0 +  5] =	OPND1 (SLEB128),
+	[DW_OP_breg0 +  6] =	OPND1 (SLEB128),
+	[DW_OP_breg0 +  7] =	OPND1 (SLEB128),
+	[DW_OP_breg0 +  8] =	OPND1 (SLEB128),
+	[DW_OP_breg0 +  9] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 10] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 11] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 12] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 13] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 14] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 15] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 16] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 17] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 18] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 19] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 20] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 21] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 22] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 23] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 24] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 25] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 26] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 27] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 28] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 29] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 30] =	OPND1 (SLEB128),
+	[DW_OP_breg0 + 31] =	OPND1 (SLEB128),
+	[DW_OP_regx] =		OPND1 (ULEB128),
+	[DW_OP_fbreg] =		OPND1 (SLEB128),
+	[DW_OP_bregx] =		OPND2 (ULEB128, SLEB128),
+	[DW_OP_piece] =		OPND1 (ULEB128),
+	[DW_OP_deref_size] =	OPND1 (VAL8),
+	[DW_OP_xderef_size] =	OPND1 (VAL8),
+	[DW_OP_call2] =		OPND1 (VAL16),
+	[DW_OP_call4] =		OPND1 (VAL32),
+	[DW_OP_call_ref] =		OPND1 (OFFSET)
+};
+
+static dwarf_sword_t sword(dwarf_word_t val)
+{
+	switch (sizeof(val)) {
+	case 4: return (int32_t) val;
+	case 8: return (int64_t) val;
+	}
+
+	WARN(1, "wrong dwarf_word_t size %lu\n", sizeof(val));
+	return -1;
+}
+
+static int read_operand(dwarf_word_t *addr, int operand_type,
+			dwarf_word_t *val)
+{
+	int ret = 0;
+
+	if (operand_type == ADDR)
+		switch (sizeof(dwarf_word_t)) {
+		case 4: operand_type = VAL32; break;
+		case 8: operand_type = VAL64; break;
+		default:
+			WARN(1, "wrong dwarf_word_t size %lu\n", sizeof(val));
+			return -1;
+		}
+
+	switch (operand_type) {
+	case VAL8:
+		*val = dwarf_readu8(addr);
+		break;
+
+	case VAL16:
+		*val = dwarf_readu16(addr);
+		break;
+
+	case VAL32:
+		*val = dwarf_readu32(addr);
+		break;
+
+	case VAL64:
+		*val = dwarf_readu64(addr);
+		break;
+
+	case ULEB128:
+		*val = dwarf_read_uleb128(addr);
+		break;
+
+	case SLEB128:
+		*val = dwarf_read_sleb128(addr);
+		break;
+
+	case OFFSET: /* only used by DW_OP_call_ref, which we don't implement */
+	default:
+		DWARF_DEBUG(1, "Unexpected operand type %d\n", operand_type);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+#define dwarf_is_big_endian() 0
+
+int dwarf_expression(struct dwarf_regs *regs, dwarf_word_t *addr,
+                     dwarf_word_t len, dwarf_word_t *val)
+{
+	dwarf_word_t operand1 = 0, operand2 = 0, tmp1, tmp2, tmp3, end_addr;
+	uint8_t opcode, operands_signature;
+	dwarf_word_t stack[MAX_EXPR_STACK_SIZE];
+	unsigned int tos = 0;
+	int ret, reg;
+
+#define pop()						\
+({							\
+	if ((tos - 1) >= MAX_EXPR_STACK_SIZE)		\
+	{						\
+		DWARF_DEBUG(1, "Stack underflow\n");	\
+		return -EINVAL;				\
+	}						\
+	stack[--tos];					\
+})
+
+#define push(x)						\
+do {							\
+	if (tos >= MAX_EXPR_STACK_SIZE)			\
+	{						\
+		DWARF_DEBUG(1, "Stack overflow\n");	\
+		return -EINVAL;				\
+	}						\
+	stack[tos++] = (x);				\
+} while (0)
+
+# define pick(n)					\
+({							\
+	unsigned int _index = tos - 1 - (n);		\
+	if (_index >= MAX_EXPR_STACK_SIZE)		\
+	{						\
+		DWARF_DEBUG(1, "Out-of-stack pick\n");	\
+		return -EINVAL;				\
+	}						\
+	stack[_index];					\
+})
+
+	end_addr = *addr + len;
+
+	DWARF_DEBUG(1, "len=%lu, pushing cfa=0x%lx\n",
+		    (unsigned long) len, (unsigned long) regs->cfa);
+
+	/* push current CFA as required by DWARF spec */
+	push(regs->cfa);
+
+	while (*addr < end_addr) {
+
+		opcode = dwarf_readu8(addr);
+		operands_signature = operands[opcode];
+
+		if ((NUM_OPERANDS(operands_signature) > 0)) {
+			if (read_operand(addr, OPND1_TYPE(operands_signature),
+					 &operand1))
+				return -EINVAL;
+
+			if (NUM_OPERANDS(operands_signature > 1)) {
+				if (read_operand(addr, OPND2_TYPE(operands_signature),
+						 &operand2))
+					return ret;
+			}
+		}
+
+		switch (opcode) {
+		case DW_OP_lit0:  case DW_OP_lit1:  case DW_OP_lit2:
+		case DW_OP_lit3:  case DW_OP_lit4:  case DW_OP_lit5:
+		case DW_OP_lit6:  case DW_OP_lit7:  case DW_OP_lit8:
+		case DW_OP_lit9:  case DW_OP_lit10: case DW_OP_lit11:
+		case DW_OP_lit12: case DW_OP_lit13: case DW_OP_lit14:
+		case DW_OP_lit15: case DW_OP_lit16: case DW_OP_lit17:
+		case DW_OP_lit18: case DW_OP_lit19: case DW_OP_lit20:
+		case DW_OP_lit21: case DW_OP_lit22: case DW_OP_lit23:
+		case DW_OP_lit24: case DW_OP_lit25: case DW_OP_lit26:
+		case DW_OP_lit27: case DW_OP_lit28: case DW_OP_lit29:
+		case DW_OP_lit30: case DW_OP_lit31:
+			DWARF_DEBUG(1, "OP_lit(%d)\n", (int) opcode - DW_OP_lit0);
+			push(opcode - DW_OP_lit0);
+			break;
+
+		case DW_OP_breg0:  case DW_OP_breg1:  case DW_OP_breg2:
+		case DW_OP_breg3:  case DW_OP_breg4:  case DW_OP_breg5:
+		case DW_OP_breg6:  case DW_OP_breg7:  case DW_OP_breg8:
+		case DW_OP_breg9:  case DW_OP_breg10: case DW_OP_breg11:
+		case DW_OP_breg12: case DW_OP_breg13: case DW_OP_breg14:
+		case DW_OP_breg15: case DW_OP_breg16: case DW_OP_breg17:
+		case DW_OP_breg18: case DW_OP_breg19: case DW_OP_breg20:
+		case DW_OP_breg21: case DW_OP_breg22: case DW_OP_breg23:
+		case DW_OP_breg24: case DW_OP_breg25: case DW_OP_breg26:
+		case DW_OP_breg27: case DW_OP_breg28: case DW_OP_breg29:
+		case DW_OP_breg30: case DW_OP_breg31:
+			reg = (int) opcode - DW_OP_breg0;
+
+			DWARF_DEBUG(1, "OP_breg(r%d,0x%lx)\n",
+				    reg, (unsigned long) operand1);
+
+			if (reg >= DWARF_REGS_NUM) {
+				DWARF_DEBUG(1, "wrong register number %d\n", reg);
+				return -EINVAL;
+			}
+
+			tmp1 = regs->reg[reg];
+			push(tmp1 + operand1);
+			break;
+
+		case DW_OP_bregx:
+			reg = (int) operand1;
+
+			DWARF_DEBUG(1, "OP_bregx(r%d,0x%lx)\n",
+				    reg, (unsigned long) operand2);
+
+			if (reg >= DWARF_REGS_NUM) {
+				DWARF_DEBUG(1, "wrong register number %d\n", reg);
+				return -EINVAL;
+			}
+
+			tmp1 = regs->reg[reg];
+			push(tmp1 + operand2);
+			break;
+
+		case DW_OP_reg0:  case DW_OP_reg1:  case DW_OP_reg2:
+		case DW_OP_reg3:  case DW_OP_reg4:  case DW_OP_reg5:
+		case DW_OP_reg6:  case DW_OP_reg7:  case DW_OP_reg8:
+		case DW_OP_reg9:  case DW_OP_reg10: case DW_OP_reg11:
+		case DW_OP_reg12: case DW_OP_reg13: case DW_OP_reg14:
+		case DW_OP_reg15: case DW_OP_reg16: case DW_OP_reg17:
+		case DW_OP_reg18: case DW_OP_reg19: case DW_OP_reg20:
+		case DW_OP_reg21: case DW_OP_reg22: case DW_OP_reg23:
+		case DW_OP_reg24: case DW_OP_reg25: case DW_OP_reg26:
+		case DW_OP_reg27: case DW_OP_reg28: case DW_OP_reg29:
+		case DW_OP_reg30: case DW_OP_reg31:
+			reg = (int) opcode - DW_OP_reg0;
+			DWARF_DEBUG(1, "OP_reg(r%d)\n", reg);
+			*val = regs->reg[reg];
+			return 0;
+
+		case DW_OP_regx:
+			reg = (int) operand1;
+			DWARF_DEBUG(1, "OP_regx(r%d)\n", reg);
+			*val = regs->reg[reg];
+			return 0;
+
+		case DW_OP_addr:
+		case DW_OP_const1u:
+		case DW_OP_const2u:
+		case DW_OP_const4u:
+		case DW_OP_const8u:
+		case DW_OP_constu:
+		case DW_OP_const8s:
+		case DW_OP_consts:
+			DWARF_DEBUG(1, "OP_const(0x%lx)\n", (unsigned long) operand1);
+			push(operand1);
+			break;
+
+		case DW_OP_const1s:
+			if (operand1 & 0x80)
+				operand1 |= ((dwarf_word_t) -1) << 8;
+			DWARF_DEBUG(1, "OP_const1s(%ld)\n", (long) operand1);
+			push(operand1);
+			break;
+
+		case DW_OP_const2s:
+			if (operand1 & 0x8000)
+				operand1 |= ((dwarf_word_t) -1) << 16;
+
+			DWARF_DEBUG(1, "OP_const2s(%ld)\n", (long) operand1);
+			push(operand1);
+			break;
+
+		case DW_OP_const4s:
+			if (operand1 & 0x80000000)
+				operand1 |= (((dwarf_word_t) -1) << 16) << 16;
+			DWARF_DEBUG(1, "OP_const4s(%ld)\n", (long) operand1);
+			push(operand1);
+			break;
+
+		case DW_OP_deref:
+			DWARF_DEBUG(1, "OP_deref\n");
+			tmp1 = pop();
+			tmp2 = dwarf_readw(&tmp1);
+			push(tmp2);
+			break;
+
+		case DW_OP_deref_size:
+			DWARF_DEBUG(1, "OP_deref_size(%d)\n", (int) operand1);
+			tmp1 = pop();
+
+			switch (operand1) {
+			default:
+				DWARF_DEBUG(1, "Unexpected DW_OP_deref_size size %d\n",
+					    (int) operand1);
+				return -EINVAL;
+
+			case 1:
+				tmp2 = dwarf_readu8(&tmp1);
+				break;
+
+			case 2:
+				tmp2 = dwarf_readu16(&tmp1);
+				break;
+
+			case 3:
+			case 4:
+				tmp2 = dwarf_readu32(&tmp1);
+
+				if (operand1 == 3) {
+					if (dwarf_is_big_endian())
+						tmp2 >>= 8;
+					else
+						tmp2 &= 0xffffff;
+				}
+				break;
+			case 5:
+			case 6:
+			case 7:
+			case 8:
+				tmp2 = dwarf_readu64(&tmp1);
+
+				if (operand1 != 8) {
+					if (dwarf_is_big_endian())
+						tmp2 >>= 64 - 8 * operand1;
+					else
+						tmp2 &= (~ (dwarf_word_t) 0) << (8 * operand1);
+				}
+				break;
+			}
+			push(tmp2);
+			break;
+
+		case DW_OP_dup:
+			DWARF_DEBUG(1, "OP_dup\n");
+			push(pick(0));
+			break;
+
+		case DW_OP_drop:
+			DWARF_DEBUG(1, "OP_drop\n");
+			pop();
+			break;
+
+		case DW_OP_pick:
+			DWARF_DEBUG(1, "OP_pick(%d)\n", (int) operand1);
+			push(pick (operand1));
+			break;
+
+		case DW_OP_over:
+			DWARF_DEBUG(1, "OP_over\n");
+			push(pick(1));
+			break;
+
+		case DW_OP_swap:
+			DWARF_DEBUG(1, "OP_swap\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			push(tmp1);
+			push(tmp2);
+			break;
+
+		case DW_OP_rot:
+			DWARF_DEBUG(1, "OP_rot\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			tmp3 = pop();
+			push(tmp1);
+			push(tmp3);
+			push(tmp2);
+			break;
+
+		case DW_OP_abs:
+			DWARF_DEBUG(1, "OP_abs\n");
+			tmp1 = pop();
+			if (tmp1 & ((dwarf_word_t) 1 << (8 * sizeof(dwarf_word_t) - 1)))
+			tmp1 = -tmp1;
+			push(tmp1);
+			break;
+
+		case DW_OP_and:
+			DWARF_DEBUG(1, "OP_and\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			push(tmp1 & tmp2);
+			break;
+
+		case DW_OP_div:
+			DWARF_DEBUG(1, "OP_div\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			if (tmp1)
+				tmp1 = sword(tmp2) / sword(tmp1);
+			push (tmp1);
+			break;
+
+		case DW_OP_minus:
+			DWARF_DEBUG(1, "OP_minus\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			tmp1 = tmp2 - tmp1;
+			push(tmp1);
+			break;
+
+		case DW_OP_mod:
+			DWARF_DEBUG(1, "OP_mod\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			if (tmp1)
+				tmp1 = tmp2 % tmp1;
+			push (tmp1);
+			break;
+
+		case DW_OP_mul:
+			DWARF_DEBUG(1, "OP_mul\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			if (tmp1)
+				tmp1 = tmp2 * tmp1;
+			push(tmp1);
+			break;
+
+		case DW_OP_neg:
+			DWARF_DEBUG(1, "OP_neg\n");
+			push(-pop());
+			break;
+
+		case DW_OP_not:
+			DWARF_DEBUG(1, "OP_not\n");
+			push(~pop());
+			break;
+
+		case DW_OP_or:
+			DWARF_DEBUG(1, "OP_or\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			push (tmp1 | tmp2);
+			break;
+
+		case DW_OP_plus:
+			DWARF_DEBUG(1, "OP_plus\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			push(tmp1 + tmp2);
+			break;
+
+		case DW_OP_plus_uconst:
+			DWARF_DEBUG(1, "OP_plus_uconst(%lu)\n", (unsigned long) operand1);
+			tmp1 = pop();
+			push(tmp1 + operand1);
+			break;
+
+		case DW_OP_shl:
+			DWARF_DEBUG(1, "OP_shl\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			push(tmp2 << tmp1);
+			break;
+
+		case DW_OP_shr:
+			DWARF_DEBUG(1, "OP_shr\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			push(tmp2 >> tmp1);
+			break;
+
+		case DW_OP_shra:
+			DWARF_DEBUG(1, "OP_shra\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			push (sword(tmp2) >> tmp1);
+			break;
+
+		case DW_OP_xor:
+			DWARF_DEBUG(1, "OP_xor\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			push(tmp1 ^ tmp2);
+			break;
+
+		case DW_OP_le:
+			DWARF_DEBUG(1, "OP_le\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			push (sword(tmp1) <= sword(tmp2));
+			break;
+
+		case DW_OP_ge:
+			DWARF_DEBUG(1, "OP_ge\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			push (sword(tmp1) >= sword(tmp2));
+			break;
+
+		case DW_OP_eq:
+			DWARF_DEBUG(1, "OP_eq\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			push(sword(tmp1) == sword(tmp2));
+			break;
+
+		case DW_OP_lt:
+			DWARF_DEBUG(1, "OP_lt\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			push (sword(tmp1) < sword(tmp2));
+			break;
+
+		case DW_OP_gt:
+			DWARF_DEBUG(1, "OP_gt\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			push (sword(tmp1) > sword(tmp2));
+			break;
+
+		case DW_OP_ne:
+			DWARF_DEBUG(1, "OP_ne\n");
+			tmp1 = pop();
+			tmp2 = pop();
+			push (sword(tmp1) != sword(tmp2));
+			break;
+
+		case DW_OP_skip:
+			DWARF_DEBUG(1, "OP_skip(%d)\n", (int16_t) operand1);
+			*addr += (int16_t) operand1;
+			break;
+
+		case DW_OP_bra:
+			DWARF_DEBUG(1, "OP_skip(%d)\n", (int16_t) operand1);
+			tmp1 = pop();
+			if (tmp1)
+				*addr += (int16_t) operand1;
+			break;
+
+		case DW_OP_nop:
+			DWARF_DEBUG(1, "OP_nop\n");
+			break;
+
+		case DW_OP_call2:
+		case DW_OP_call4:
+		case DW_OP_call_ref:
+		case DW_OP_fbreg:
+		case DW_OP_piece:
+		case DW_OP_push_object_address:
+		case DW_OP_xderef:
+		case DW_OP_xderef_size:
+		default:
+			DWARF_DEBUG(1, "Unexpected opcode 0x%x\n", opcode);
+			return -EINVAL;
+		} /* switch opcode */
+	}
+
+	*val = pop ();
+	DWARF_DEBUG(1, "final value = 0x%lx\n", (unsigned long) *val);
+	return 0;
+}
diff --git a/kernel/dwarf-fde.c b/kernel/dwarf-fde.c
new file mode 100644
index 0000000..100e09c
--- /dev/null
+++ b/kernel/dwarf-fde.c
@@ -0,0 +1,349 @@
+/*
+ * Code mostly taken from libunwind (git://git.sv.gnu.org/libunwind.git)
+ * Adding copyright notice as requested:
+ *
+ * Copyright (c) 2002 Hewlett-Packard Co.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining
+ * a copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sublicense, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be
+ * included in all copies or substantial portions of the Software.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/dwarf.h>
+
+static int parse_cie(struct dwarf_cie *cie, void *cie_data)
+{
+	dwarf_word_t addr = (dwarf_word_t) cie_data;
+	dwarf_word_t len, cie_end_addr, aug_size;
+	uint8_t fde_encoding, augstr[5], ch, version;
+	uint32_t u32val;
+	uint64_t u64val;
+	int i;
+
+	DWARF_DEBUG(1, "cie %p\n", cie_data);
+
+	switch(sizeof(dwarf_word_t)) {
+	case 4:
+		fde_encoding = DW_EH_PE_udata4;
+		break;
+	case 8:
+		fde_encoding = DW_EH_PE_udata8;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	u32val = dwarf_readu32(&addr);
+
+	if (u32val != 0xffffffff) {
+		/* The CIE is in the 32-bit DWARF format */
+		uint32_t cie_id;
+
+		len = u32val;
+		cie_end_addr = addr + len;
+		cie_id = dwarf_readu32(&addr);
+		if (cie_id != 0)
+			return -EINVAL;
+	} else {
+		uint64_t cie_id;
+
+		u64val = dwarf_readu64(&addr);
+		len = u64val;
+		cie_end_addr = addr + len;
+
+		cie_id = dwarf_readu64(&addr);
+		if (cie_id != 0)
+			return -EINVAL;
+	}
+
+	cie->cie_instr_end = cie_end_addr;
+
+	version = dwarf_readu8(&addr);
+
+	DWARF_DEBUG(1, "version %d\n", version);
+
+	if (version != DWARF_CIE_VERSION_GCC &&
+	    version != DWARF_CIE_VERSION)
+		return -EINVAL;
+
+	memset(augstr, 0, sizeof(augstr));
+	for (i = 0;;) {
+		ch = dwarf_readu8(&addr);
+		if (!ch)
+			break;
+
+		DWARF_DEBUG(1, "aug '%c'\n", ch);
+
+		if (i < sizeof (augstr) - 1)
+			augstr[i++] = ch;
+	}
+
+	cie->code_align = dwarf_read_uleb128(&addr);
+	cie->data_align = dwarf_read_sleb128(&addr);
+
+	DWARF_DEBUG(1, "code_align %llx\n", cie->code_align);
+	DWARF_DEBUG(1, "data_align %llx\n", cie->data_align);
+
+	/* Read the return-address column either as a u8 or as a uleb128. */
+	if (version == DWARF_CIE_VERSION_GCC)
+		cie->ret_addr_column = dwarf_readu8(&addr);
+	else
+		cie->ret_addr_column = dwarf_read_uleb128(&addr);
+
+	DWARF_DEBUG(1, "ret_addr_column %llu\n", cie->ret_addr_column);
+
+	i = 0;
+
+	if (augstr[0] == 'z') {
+		cie->sized_augmentation = 1;
+		aug_size = dwarf_read_uleb128(&addr);
+		i++;
+	}
+
+	for (; i < sizeof(augstr) && augstr[i]; i++)
+		switch (augstr[i]) {
+		case 'L':
+			cie->lsda_encoding = dwarf_readu8(&addr);
+			break;
+
+		case 'R':
+			fde_encoding = dwarf_readu8(&addr);
+			break;
+
+		/* XXX ommiting handller... no idea ;) */
+		case 'P':
+			return -EINVAL;
+
+		/* XXX ommiting this as well... supposee this should never appear in kernel..  */
+		case 'S':
+			return -EINVAL;
+
+		default:
+			/* If we have the size of the augmentation body, we can skip
+			*  over the parts that we don't understand, so we're OK. */
+			if (cie->sized_augmentation)
+				goto done;
+			else
+				return -EINVAL;
+		}
+
+ done:
+	cie->fde_encoding = fde_encoding;
+	cie->cie_instr_start = addr;
+
+	DWARF_DEBUG(1, "cie_instr_start %p, cie_instr_end %p\n",
+	      (void*) cie->cie_instr_start, (void*) cie->cie_instr_end);
+	return 0;
+}
+
+static int is_cie_id(dwarf_word_t val)
+{
+	return (val == 0);
+}
+
+int dwarf_fde_init(struct dwarf_fde *fde, void *data)
+{
+	dwarf_word_t addr = (dwarf_word_t) data;
+	dwarf_word_t fde_end_addr, cie_offset_addr, cie_addr;
+	dwarf_word_t start_ip, ip_range;
+	dwarf_word_t aug_size, aug_end_addr = 0;
+	uint64_t u64val;
+	uint32_t u32val;
+	int ret, ip_range_encoding;
+
+	memset(fde, 0, sizeof(*fde));
+	fde->cie.lsda_encoding = DW_EH_PE_omit;
+
+	DWARF_DEBUG(1, "fde %p\n", data);
+
+	u32val = dwarf_readu32(&addr);
+
+	if (u32val != 0xffffffff) {
+		int32_t cie_offset;
+
+		if (u32val == 0)
+			return -ENODEV;
+
+		fde_end_addr = addr + u32val;
+		cie_offset_addr = addr;
+		cie_offset = dwarf_reads32(&addr);
+
+		if (is_cie_id(cie_offset))
+			return 0;
+
+		cie_addr = cie_offset_addr - cie_offset;
+	} else {
+		int64_t cie_offset;
+
+		u64val = dwarf_readu64(&addr);
+
+		fde_end_addr = addr + u64val;
+		cie_offset_addr = addr;
+
+		cie_offset = dwarf_reads64(&addr);
+
+		if (is_cie_id(cie_offset))
+			return 0;
+
+		cie_addr = (dwarf_word_t) ((uint64_t) cie_offset_addr - cie_offset);
+	}
+
+	ret = parse_cie(&fde->cie, (void *) cie_addr);
+	if (ret)
+		return ret;
+
+	ip_range_encoding = fde->cie.fde_encoding & DW_EH_PE_FORMAT_MASK;
+
+	DWARF_DEBUG(1, "ip_range_encoding %x\n", ip_range_encoding);
+
+	if ((ret = dwarf_read_pointer(&addr, fde->cie.fde_encoding, &start_ip)) < 0 ||
+	    (ret = dwarf_read_pointer(&addr, ip_range_encoding, &ip_range)) < 0)
+		return ret;
+
+	fde->start_ip = start_ip;
+	fde->end_ip = start_ip + ip_range;
+
+	DWARF_DEBUG(1, "start_ip %p, end_ip %p\n",
+		    (void*) fde->start_ip, (void*) fde->end_ip);
+	DWARF_DEBUG(1, "sized_augmentation %d\n",
+		    fde->cie.sized_augmentation);
+
+	if (fde->cie.sized_augmentation) {
+		aug_size = dwarf_read_uleb128(&addr);
+		aug_end_addr = addr + aug_size;
+
+		DWARF_DEBUG(1, "aug_end_addr %p, aug_size %llx\n",
+		      (void*) aug_end_addr, aug_size);
+	}
+
+	DWARF_DEBUG(1, "lsda_encoding %x\n", fde->cie.lsda_encoding);
+
+	if ((ret = dwarf_read_pointer(&addr, fde->cie.lsda_encoding,
+				      &fde->lsda)) < 0)
+		return ret;
+
+	DWARF_DEBUG(1, "lsda %p\n", (void*) fde->lsda);
+
+	if (fde->cie.sized_augmentation)
+		fde->fde_instr_start = aug_end_addr;
+	else
+		fde->fde_instr_start = addr;
+
+	fde->fde_instr_end = fde_end_addr;
+
+	DWARF_DEBUG(1, "fde_instr_start %p, fde_instr_end %p\n",
+	      (void*) fde->fde_instr_start, (void*) fde->fde_instr_end);
+	return 0;
+}
+
+static int
+apply_reg_state(struct dwarf_regs *regs, struct dwarf_regs_state *rs)
+{
+	dwarf_word_t prev_cfa, cfa;
+	dwarf_word_t prev_ip;
+	dwarf_word_t regnum;
+	dwarf_word_t addr;
+	dwarf_word_t len;
+	int i;
+
+	prev_ip  = dwarf_regs_ip(regs);
+	prev_cfa = regs->cfa;
+
+	if (rs->reg[DWARF_CFA_REG_COLUMN].where == DWARF_WHERE_REG) {
+		/* CFA is equal to [reg] + offset: */
+		/*
+		 * As a special-case, if the stack-pointer is the CFA and the
+		 * stack-pointer wasn't saved, popping the CFA implicitly pops
+		 * the stack-pointer as well.
+		 */
+		if ((rs->reg[DWARF_CFA_REG_COLUMN].val == DWARF_SP) &&
+		    (rs->reg[DWARF_SP].where == DWARF_WHERE_SAME))
+			cfa = prev_cfa;
+		else {
+			regnum = rs->reg[DWARF_CFA_REG_COLUMN].val;
+			cfa = regs->reg[regnum];
+		}
+
+		cfa += rs->reg[DWARF_CFA_OFF_COLUMN].val;
+       } else {
+		if (rs->reg[DWARF_CFA_REG_COLUMN].where != DWARF_WHERE_EXPR)
+			return -EINVAL;
+
+		addr = rs->reg[DWARF_CFA_REG_COLUMN].val;
+		len = dwarf_read_uleb128(&addr);
+
+		if (dwarf_expression(regs, &addr, len, &cfa))
+			return -EINVAL;
+	}
+
+	for (i = 0; i < DWARF_REGS_NUM; ++i) {
+		switch (rs->reg[i].where) {
+		case DWARF_WHERE_UNDEF:
+			regs->reg[i] = 0;
+			break;
+
+		case DWARF_WHERE_SAME:
+			break;
+
+		case DWARF_WHERE_CFAREL:
+			regs->reg[i] = *((dwarf_word_t*) (cfa + rs->reg[i].val));
+			break;
+
+		case DWARF_WHERE_REG:
+			regs->reg[i] = rs->reg[i].val;
+			break;
+
+		case DWARF_WHERE_EXPR:
+			addr = rs->reg[i].val;
+			len = dwarf_read_uleb128(&addr);
+			if (dwarf_expression(regs, &addr, len, &regs->reg[i]))
+				return -EINVAL;
+			break;
+		}
+	}
+
+	if ((dwarf_regs_ip(regs) == prev_ip) &&
+	    (cfa == prev_cfa)) {
+		DWARF_DEBUG(1, "ip and cfa unchanged, ip=0x%llx)\n",
+			    dwarf_regs_ip(regs));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int dwarf_fde_process(struct dwarf_fde *fde, struct dwarf_regs *regs)
+{
+	struct dwarf_state state;
+	int i, ret;
+
+	memset(&state, 0, sizeof(state));
+	for(i = 0; i < DWARF_REGS_NUM; ++i)
+		dwarf_setreg(&state.rs_current, i, DWARF_WHERE_SAME, 0);
+
+	ret = dwarf_cfi_run(fde, &state, dwarf_regs_ip(regs),
+			    fde->cie.cie_instr_start,
+			    fde->cie.cie_instr_end);
+	if (ret)
+		return ret;
+
+	memcpy(&state.rs_initial, &state.rs_current, sizeof(state.rs_initial));
+
+	ret = dwarf_cfi_run(fde, &state, dwarf_regs_ip(regs),
+			    fde->fde_instr_start,
+			    fde->fde_instr_end);
+	if (ret)
+		return ret;
+
+	return apply_reg_state(regs, &state.rs_current);
+}
diff --git a/kernel/dwarf-read.c b/kernel/dwarf-read.c
new file mode 100644
index 0000000..6791223
--- /dev/null
+++ b/kernel/dwarf-read.c
@@ -0,0 +1,227 @@
+/*
+ * Code mostly taken from libunwind (git://git.sv.gnu.org/libunwind.git)
+ * Adding copyright notice as requested:
+ *
+ * Copyright (c) 2002 Hewlett-Packard Co.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining
+ * a copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sublicense, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be
+ * included in all copies or substantial portions of the Software.
+ */
+
+#include <linux/bug.h>
+#include <linux/errno.h>
+#include <linux/dwarf.h>
+
+typedef union __packed {
+	int8_t          s8;
+	int16_t		s16;
+	int32_t		s32;
+	int64_t		s64;
+	uint8_t		u8;
+	uint16_t	u16;
+	uint32_t	u32;
+	uint64_t	u64;
+} dwarf_misaligned_value_t;
+
+int8_t dwarf_reads8(dwarf_word_t *addr)
+{
+	dwarf_misaligned_value_t *mvp = (void *) *addr;
+	*addr += sizeof (mvp->s8);
+	return mvp->s8;
+}
+
+int16_t dwarf_reads16(dwarf_word_t *addr)
+{
+	dwarf_misaligned_value_t *mvp = (void*) *addr;
+	*addr += sizeof (mvp->s16);
+	return mvp->s16;
+}
+
+int32_t dwarf_reads32(dwarf_word_t *addr)
+{
+	dwarf_misaligned_value_t *mvp = (void *) *addr;
+	*addr += sizeof (mvp->s32);
+	return mvp->s32;
+}
+
+int64_t dwarf_reads64(dwarf_word_t *addr)
+{
+	dwarf_misaligned_value_t *mvp = (void *) *addr;
+	*addr += sizeof (mvp->s64);
+	return mvp->s64;
+}
+
+uint8_t dwarf_readu8(dwarf_word_t *addr)
+{
+	dwarf_misaligned_value_t *mvp = (void *) *addr;
+	*addr += sizeof (mvp->u8);
+	return mvp->u8;
+}
+
+uint16_t dwarf_readu16(dwarf_word_t *addr)
+{
+	dwarf_misaligned_value_t *mvp = (void *) *addr;
+	*addr += sizeof (mvp->u16);
+	return mvp->u16;
+}
+
+uint32_t dwarf_readu32(dwarf_word_t *addr)
+{
+	dwarf_misaligned_value_t *mvp = (void *) *addr;
+	*addr += sizeof (mvp->u32);
+	return mvp->u32;
+}
+
+uint64_t dwarf_readu64(dwarf_word_t *addr)
+{
+	dwarf_misaligned_value_t *mvp = (void *) *addr;
+	*addr += sizeof (mvp->u64);
+	return mvp->u64;
+}
+
+dwarf_word_t dwarf_read_uleb128(dwarf_word_t *addr)
+{
+	dwarf_word_t val = 0, shift = 0;
+	unsigned char byte;
+
+	do {
+		byte = dwarf_readu8(addr);
+		val |= ((unsigned long) byte & 0x7f) << shift;
+		shift += 7;
+	} while (byte & 0x80);
+
+	return val;
+}
+
+dwarf_word_t dwarf_read_sleb128(dwarf_word_t *addr)
+{
+	dwarf_word_t val = 0, shift = 0;
+	unsigned char byte;
+
+	do {
+		byte = dwarf_readu8(addr);
+		val |= ((unsigned long) byte & 0x7f) << shift;
+		shift += 7;
+	} while (byte & 0x80);
+
+	if (shift < 8 * sizeof(unsigned long) && (byte & 0x40) != 0)
+		/* sign-extend negative value */
+		val |= ((unsigned long) -1) << shift;
+
+	return val;
+}
+
+dwarf_word_t dwarf_readw(dwarf_word_t *addr)
+{
+	switch (sizeof(dwarf_word_t)) {
+	case 4:
+		return dwarf_readu32(addr);
+	case 8:
+		return dwarf_readu64(addr);
+	}
+
+	WARN_ON(1);
+	return 0;
+}
+
+int dwarf_read_pointer(dwarf_word_t *addr, unsigned char encoding,
+		       dwarf_word_t *valp)
+{
+	dwarf_word_t val, initial_addr = *addr;
+
+	if (encoding == DW_EH_PE_omit) {
+		*valp = 0;
+		return 0;
+	} else if (encoding == DW_EH_PE_aligned) {
+		int size = sizeof(unsigned long);
+		*addr = (initial_addr + size - 1) & -size;
+		*valp = dwarf_readw(addr);
+		return 0;
+	}
+
+	switch (encoding & DW_EH_PE_FORMAT_MASK) {
+	case DW_EH_PE_ptr:
+		val = dwarf_readw(addr);
+		break;
+
+	case DW_EH_PE_uleb128:
+		val = dwarf_read_uleb128(addr);
+		break;
+
+	case DW_EH_PE_udata2:
+		val = dwarf_readu16(addr);
+		break;
+
+	case DW_EH_PE_udata4:
+		val = dwarf_readu32(addr);
+		break;
+
+	case DW_EH_PE_udata8:
+		val = dwarf_readu64(addr);
+		break;
+
+	case DW_EH_PE_sleb128:
+		val = dwarf_read_uleb128(addr);
+		break;
+
+	case DW_EH_PE_sdata2:
+		val = dwarf_reads16(addr);
+		break;
+
+	case DW_EH_PE_sdata4:
+		val = dwarf_reads32(addr);
+		break;
+
+	case DW_EH_PE_sdata8:
+		val = dwarf_reads64(addr);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (val == 0) {
+		*valp = 0;
+		return 0;
+	}
+
+	switch (encoding & DW_EH_PE_APPL_MASK) {
+	case DW_EH_PE_absptr:
+		break;
+
+	case DW_EH_PE_pcrel:
+		val += initial_addr;
+		break;
+
+	case DW_EH_PE_datarel:
+		/* TODO
+		val += pi->gp;
+		*/
+		break;
+
+	case DW_EH_PE_funcrel:
+		/* TODO
+		val += pi->start_ip;
+		*/
+		break;
+
+	case DW_EH_PE_textrel:
+		return -EINVAL;
+	}
+
+	if (encoding & DW_EH_PE_indirect) {
+		dwarf_word_t indirect_addr = val;
+		val = dwarf_readw(&indirect_addr);
+	}
+
+	*valp = val;
+	return 0;
+}
diff --git a/kernel/dwarf.c b/kernel/dwarf.c
new file mode 100644
index 0000000..4b06f71
--- /dev/null
+++ b/kernel/dwarf.c
@@ -0,0 +1,7 @@
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+int dwarf_debug = 0;
+module_param(dwarf_debug, int, 0644);
+MODULE_PARM_DESC(dwarf_debug, "Turns on debug for dwarf code.");
-- 
1.7.1

