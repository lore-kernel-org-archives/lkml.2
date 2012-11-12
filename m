Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab2KLLvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:51:24 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:64711 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2KLLvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:51:19 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 43/55] ARC: disassembly (needed by kprobes/kgdb/unaligned-access-emul)
Date: Mon, 12 Nov 2012 17:19:01 +0530
Message-ID: <1352720953-24321-13-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Orig written by Rajeshwar Ranga <rajeshwar.ranga@gmail.com>

Consolidation/cleanups by Mischa Jonker <mjonker@synopsys.com>

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/disasm.h |  116 +++++++++
 arch/arc/kernel/Makefile      |    2 +-
 arch/arc/kernel/disasm.c      |  539 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 656 insertions(+), 1 deletions(-)
 create mode 100644 arch/arc/include/asm/disasm.h
 create mode 100644 arch/arc/kernel/disasm.c

diff --git a/arch/arc/include/asm/disasm.h b/arch/arc/include/asm/disasm.h
new file mode 100644
index 0000000..f1cce3d
--- /dev/null
+++ b/arch/arc/include/asm/disasm.h
@@ -0,0 +1,116 @@
+/*
+ * several functions that help interpret ARC instructions
+ * used for unaligned accesses, kprobes and kgdb
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ARC_DISASM_H__
+#define __ARC_DISASM_H__
+
+enum {
+	op_Bcc = 0, op_BLcc = 1, op_LD = 2, op_ST = 3, op_MAJOR_4 = 4,
+	op_MAJOR_5 = 5, op_LD_ADD = 12, op_ADD_SUB_SHIFT = 13,
+	op_ADD_MOV_CMP = 14, op_S = 15, op_LD_S = 16, op_LDB_S = 17,
+	op_LDW_S = 18, op_LDWX_S = 19, op_ST_S = 20, op_STB_S = 21,
+	op_STW_S = 22, op_Su5 = 23, op_SP = 24, op_GP = 25,
+	op_Pcl = 26, op_MOV_S = 27, op_ADD_CMP = 28, op_BR_S = 29,
+	op_B_S = 30, op_BL_S = 31
+};
+
+enum flow {
+	noflow,
+	direct_jump,
+	direct_call,
+	indirect_jump,
+	indirect_call,
+	invalid_instr
+};
+
+#define IS_BIT(word, n)		((word) & (1<<n))
+#define BITS(word, s, e)	(((word) >> (s)) & (~((-2) << ((e) - (s)))))
+
+#define MAJOR_OPCODE(word)	(BITS((word), 27, 31))
+#define MINOR_OPCODE(word)	(BITS((word), 16, 21))
+#define FIELD_A(word)		(BITS((word), 0, 5))
+#define FIELD_B(word)		((BITS((word), 12, 14)<<3) | \
+				(BITS((word), 24, 26)))
+#define FIELD_C(word)		(BITS((word), 6, 11))
+#define FIELD_u6(word)		FIELDC(word)
+#define FIELD_s12(word)		sign_extend(((BITS((word), 0, 5) << 6) | \
+					BITS((word), 6, 11)), 12)
+
+/* note that for BL/BRcc these two macro's need another AND statement to mask
+ * out bit 1 (make the result a multiple of 4) */
+#define FIELD_s9(word)		sign_extend(((BITS(word, 15, 15) << 8) | \
+					BITS(word, 16, 23)), 9)
+#define FIELD_s21(word)		sign_extend(((BITS(word, 6, 15) << 11) | \
+					(BITS(word, 17, 26) << 1)), 12)
+#define FIELD_s25(word)		sign_extend(((BITS(word, 0, 3) << 21) | \
+					(BITS(word, 6, 15) << 11) | \
+					(BITS(word, 17, 26) << 1)), 12)
+
+/* note: these operate on 16 bits! */
+#define FIELD_S_A(word)		((BITS((word), 2, 2)<<3) | BITS((word), 0, 2))
+#define FIELD_S_B(word)		((BITS((word), 10, 10)<<3) | \
+				BITS((word), 8, 10))
+#define FIELD_S_C(word)		((BITS((word), 7, 7)<<3) | BITS((word), 5, 7))
+#define FIELD_S_H(word)		((BITS((word), 0, 2)<<3) | BITS((word), 5, 8))
+#define FIELD_S_u5(word)	(BITS((word), 0, 4))
+#define FIELD_S_u6(word)	(BITS((word), 0, 4) << 1)
+#define FIELD_S_u7(word)	(BITS((word), 0, 4) << 2)
+#define FIELD_S_u10(word)	(BITS((word), 0, 7) << 2)
+#define FIELD_S_s7(word)	sign_extend(BITS((word), 0, 5) << 1, 9)
+#define FIELD_S_s8(word)	sign_extend(BITS((word), 0, 7) << 1, 9)
+#define FIELD_S_s9(word)	sign_extend(BITS((word), 0, 8), 9)
+#define FIELD_S_s10(word)	sign_extend(BITS((word), 0, 8) << 1, 10)
+#define FIELD_S_s11(word)	sign_extend(BITS((word), 0, 8) << 2, 11)
+#define FIELD_S_s13(word)	sign_extend(BITS((word), 0, 10) << 2, 13)
+
+#define STATUS32_L		0x00000100
+#define REG_LIMM		62
+
+struct disasm_state {
+	/* generic info */
+	unsigned long words[2];
+	int instr_len;
+	int major_opcode;
+	/* info for branch/jump */
+	int is_branch;
+	int target;
+	int delay_slot;
+	enum flow flow;
+	/* info for load/store */
+	int src1, src2, src3, dest, wb_reg;
+	int zz, aa, x, pref, di;
+	int fault, write;
+};
+
+static inline int sign_extend(int value, int bits)
+{
+	if (IS_BIT(value, (bits - 1)))
+		value |= (0xffffffff << bits);
+
+	return value;
+}
+
+static inline int is_short_instr(unsigned long addr)
+{
+	uint16_t word = *((uint16_t *)addr);
+	int opcode = (word >> 11) & 0x1F;
+	return (opcode >= 0x0B);
+}
+
+void disasm_instr(unsigned long addr, struct disasm_state *state,
+	int userspace, struct pt_regs *regs, struct callee_regs *cregs);
+int disasm_next_pc(unsigned long pc, struct pt_regs *regs, struct callee_regs
+	*cregs, unsigned long *fall_thru, unsigned long *target);
+long get_reg(int reg, struct pt_regs *regs, struct callee_regs *cregs);
+void set_reg(int reg, long val, struct pt_regs *regs,
+		struct callee_regs *cregs);
+
+#endif	/* __ARC_DISASM_H__ */
diff --git a/arch/arc/kernel/Makefile b/arch/arc/kernel/Makefile
index 86b159f..1fc0461 100644
--- a/arch/arc/kernel/Makefile
+++ b/arch/arc/kernel/Makefile
@@ -9,7 +9,7 @@
 CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"'
 
 obj-y	:= arcksyms.o setup.o irq.o time.o reset.o ptrace.o entry.o process.o \
-	   signal.o traps.o sys.o troubleshoot.o stacktrace.o
+	   signal.o traps.o sys.o troubleshoot.o stacktrace.o disasm.c
 
 obj-$(CONFIG_MODULES)			+= arcksyms.o module.o
 obj-$(CONFIG_ARC_DBG_EVENT_TIMELINE)	+= event-log.o
diff --git a/arch/arc/kernel/disasm.c b/arch/arc/kernel/disasm.c
new file mode 100644
index 0000000..254d11a
--- /dev/null
+++ b/arch/arc/kernel/disasm.c
@@ -0,0 +1,539 @@
+/*
+ * several functions that help interpret ARC instructions
+ * used for unaligned accesses, kprobes and kgdb
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/kprobes.h>
+#include <linux/slab.h>
+#include <asm/disasm.h>
+#include <asm/uaccess.h>
+
+#if defined(CONFIG_KGDB) || defined(CONFIG_MISALIGN_ACCESS) || \
+	defined(CONFIG_KPROBES)
+
+/* disasm_instr: Analyses instruction at addr, stores
+ * findings in *state
+ */
+void __kprobes disasm_instr(unsigned long addr, struct disasm_state *state,
+	int userspace, struct pt_regs *regs, struct callee_regs *cregs)
+{
+	int fieldA = 0;
+	int fieldC = 0, fieldCisReg = 0;
+	uint16_t word1 = 0, word0 = 0;
+	int subopcode, is_linked, op_format;
+	uint16_t *ins_ptr;
+	uint16_t ins_buf[4];
+	int bytes_not_copied = 0;
+
+	memset(state, 0, sizeof(struct disasm_state));
+
+	/* This fetches the upper part of the 32 bit instruction
+	 * in both the cases of Little Endian or Big Endian configurations. */
+	if (userspace) {
+		bytes_not_copied = copy_from_user(ins_buf,
+						(const void __user *) addr, 8);
+		if (bytes_not_copied > 6)
+			goto fault;
+		ins_ptr = ins_buf;
+	} else {
+		ins_ptr = (uint16_t *) addr;
+	}
+
+	word1 = *((uint16_t *)addr);
+
+	state->major_opcode = (word1 >> 11) & 0x1F;
+
+	/* Check if the instruction is 32 bit or 16 bit instruction */
+	if (state->major_opcode < 0x0B) {
+		if (bytes_not_copied > 4)
+			goto fault;
+		state->instr_len = 4;
+		word0 = *((uint16_t *)(addr+2));
+		state->words[0] = (word1 << 16) | word0;
+	} else {
+		state->instr_len = 2;
+		state->words[0] = word1;
+	}
+
+	/* Read the second word in case of limm */
+	word1 = *((uint16_t *)(addr + state->instr_len));
+	word0 = *((uint16_t *)(addr + state->instr_len + 2));
+	state->words[1] = (word1 << 16) | word0;
+
+	switch (state->major_opcode) {
+	case op_Bcc:
+		state->is_branch = 1;
+
+		/* unconditional branch s25, conditional branch s21 */
+		fieldA = (IS_BIT(state->words[0], 16)) ?
+			FIELD_s25(state->words[0]) :
+			FIELD_s21(state->words[0]);
+
+		state->delay_slot = IS_BIT(state->words[0], 5);
+		state->target = fieldA + (addr & ~0x3);
+		state->flow = direct_jump;
+		break;
+
+	case op_BLcc:
+		if (IS_BIT(state->words[0], 16)) {
+			/* Branch and Link*/
+			/* unconditional branch s25, conditional branch s21 */
+			fieldA = (IS_BIT(state->words[0], 17)) ?
+				(FIELD_s25(state->words[0]) & ~0x3) :
+				FIELD_s21(state->words[0]);
+
+			state->flow = direct_call;
+		} else {
+			/*Branch On Compare */
+			fieldA = FIELD_s9(state->words[0]) & ~0x3;
+			state->flow = direct_jump;
+		}
+
+		state->delay_slot = IS_BIT(state->words[0], 5);
+		state->target = fieldA + (addr & ~0x3);
+		state->is_branch = 1;
+		break;
+
+	case op_LD:  /* LD<zz> a,[b,s9] */
+		state->write = 0;
+		state->di = BITS(state->words[0], 11, 11);
+		if (state->di)
+			break;
+		state->x = BITS(state->words[0], 6, 6);
+		state->zz = BITS(state->words[0], 7, 8);
+		state->aa = BITS(state->words[0], 9, 10);
+		state->wb_reg = FIELD_B(state->words[0]);
+		if (state->wb_reg == REG_LIMM) {
+			state->instr_len += 4;
+			state->aa = 0;
+			state->src1 = state->words[1];
+		} else {
+			state->src1 = get_reg(state->wb_reg, regs, cregs);
+		}
+		state->src2 = FIELD_s9(state->words[0]);
+		state->dest = FIELD_A(state->words[0]);
+		state->pref = (state->dest == REG_LIMM);
+		break;
+
+	case op_ST:
+		state->write = 1;
+		state->di = BITS(state->words[0], 5, 5);
+		if (state->di)
+			break;
+		state->aa = BITS(state->words[0], 3, 4);
+		state->zz = BITS(state->words[0], 1, 2);
+		state->src1 = FIELD_C(state->words[0]);
+		if (state->src1 == REG_LIMM) {
+			state->instr_len += 4;
+			state->src1 = state->words[1];
+		} else {
+			state->src1 = get_reg(state->src1, regs, cregs);
+		}
+		state->wb_reg = FIELD_B(state->words[0]);
+		if (state->wb_reg == REG_LIMM) {
+			state->aa = 0;
+			state->instr_len += 4;
+			state->src2 = state->words[1];
+		} else {
+			state->src2 = get_reg(state->wb_reg, regs, cregs);
+		}
+		state->src3 = FIELD_s9(state->words[0]);
+		break;
+
+	case op_MAJOR_4:
+		subopcode = MINOR_OPCODE(state->words[0]);
+		switch (subopcode) {
+		case 32:	/* Jcc */
+		case 33:	/* Jcc.D */
+		case 34:	/* JLcc */
+		case 35:	/* JLcc.D */
+			is_linked = 0;
+
+			if (subopcode == 33 || subopcode == 35)
+				state->delay_slot = 1;
+
+			if (subopcode == 34 || subopcode == 35)
+				is_linked = 1;
+
+			fieldCisReg = 0;
+			op_format = BITS(state->words[0], 22, 23);
+			if (op_format == 0 || ((op_format == 3) &&
+				(!IS_BIT(state->words[0], 5)))) {
+				fieldC = FIELD_C(state->words[0]);
+
+				if (fieldC == REG_LIMM) {
+					fieldC = state->words[1];
+					state->instr_len += 4;
+				} else {
+					fieldCisReg = 1;
+				}
+			} else if (op_format == 1 || ((op_format == 3)
+				&& (IS_BIT(state->words[0], 5)))) {
+				fieldC = FIELD_C(state->words[0]);
+			} else  {
+				/* op_format == 2 */
+				fieldC = FIELD_s12(state->words[0]);
+			}
+
+			if (!fieldCisReg) {
+				state->target = fieldC;
+				state->flow = is_linked ?
+					direct_call : direct_jump;
+			} else {
+				state->target = get_reg(fieldC, regs, cregs);
+				state->flow = is_linked ?
+					indirect_call : indirect_jump;
+			}
+			state->is_branch = 1;
+			break;
+
+		case 40:	/* LPcc */
+			if (BITS(state->words[0], 22, 23) == 3) {
+				/* Conditional LPcc u7 */
+				fieldC = FIELD_C(state->words[0]);
+
+				fieldC = fieldC << 1;
+				fieldC += (addr & ~0x03);
+				state->is_branch = 1;
+				state->flow = direct_jump;
+				state->target = fieldC;
+			}
+			/* For Unconditional lp, next pc is the fall through
+			 * which is updated */
+			break;
+
+		case 48 ... 55:	/* LD a,[b,c] */
+			state->di = BITS(state->words[0], 15, 15);
+			if (state->di)
+				break;
+			state->x = BITS(state->words[0], 16, 16);
+			state->zz = BITS(state->words[0], 17, 18);
+			state->aa = BITS(state->words[0], 22, 23);
+			state->wb_reg = FIELD_B(state->words[0]);
+			if (state->wb_reg == REG_LIMM) {
+				state->instr_len += 4;
+				state->src1 = state->words[1];
+			} else {
+				state->src1 = get_reg(state->wb_reg, regs,
+						cregs);
+			}
+			state->src2 = FIELD_C(state->words[0]);
+			if (state->src2 == REG_LIMM) {
+				state->instr_len += 4;
+				state->src2 = state->words[1];
+			} else {
+				state->src2 = get_reg(state->src2, regs,
+					cregs);
+			}
+			state->dest = FIELD_A(state->words[0]);
+			if (state->dest == REG_LIMM)
+				state->pref = 1;
+			break;
+
+		case 10:	/* MOV */
+			/* still need to check for limm to extract instr len */
+			/* MOV is special case because it only takes 2 args */
+			switch (BITS(state->words[0], 22, 23)) {
+			case 0: /* OP a,b,c */
+				if (FIELD_C(state->words[0]) == REG_LIMM)
+					state->instr_len += 4;
+				break;
+			case 1: /* OP a,b,u6 */
+				break;
+			case 2: /* OP b,b,s12 */
+				break;
+			case 3: /* OP.cc b,b,c/u6 */
+				if ((!IS_BIT(state->words[0], 5)) &&
+				    (FIELD_C(state->words[0]) == REG_LIMM))
+					state->instr_len += 4;
+				break;
+			}
+			break;
+
+
+		default:
+			/* Not a Load, Jump or Loop instruction */
+			/* still need to check for limm to extract instr len */
+			switch (BITS(state->words[0], 22, 23)) {
+			case 0: /* OP a,b,c */
+				if ((FIELD_B(state->words[0]) == REG_LIMM) ||
+				    (FIELD_C(state->words[0]) == REG_LIMM))
+					state->instr_len += 4;
+				break;
+			case 1: /* OP a,b,u6 */
+				break;
+			case 2: /* OP b,b,s12 */
+				break;
+			case 3: /* OP.cc b,b,c/u6 */
+				if ((!IS_BIT(state->words[0], 5)) &&
+				   ((FIELD_B(state->words[0]) == REG_LIMM) ||
+				    (FIELD_C(state->words[0]) == REG_LIMM)))
+					state->instr_len += 4;
+				break;
+			}
+			break;
+		}
+		break;
+
+	/* 16 Bit Instructions */
+	case op_LD_ADD: /* LD_S|LDB_S|LDW_S a,[b,c] */
+		state->zz = BITS(state->words[0], 3, 4);
+		state->src1 = get_reg(FIELD_S_B(state->words[0]), regs, cregs);
+		state->src2 = get_reg(FIELD_S_C(state->words[0]), regs, cregs);
+		state->dest = FIELD_S_A(state->words[0]);
+		break;
+
+	case op_ADD_MOV_CMP:
+		/* check for limm, ignore mov_s h,b (== mov_s 0,b) */
+		if ((BITS(state->words[0], 3, 4) < 3) &&
+		    (FIELD_S_H(state->words[0]) == REG_LIMM))
+			state->instr_len += 4;
+		break;
+
+	case op_S:
+		subopcode = BITS(state->words[0], 5, 7);
+		switch (subopcode) {
+		case 0:	/* j_s */
+		case 1:	/* j_s.d */
+		case 2:	/* jl_s */
+		case 3:	/* jl_s.d */
+			state->target = get_reg(FIELD_S_B(state->words[0]),
+						regs, cregs);
+			state->delay_slot = subopcode & 1;
+			state->flow = (subopcode >= 2) ?
+				direct_call : indirect_jump;
+			break;
+		case 7:
+			switch (BITS(state->words[0], 8, 10)) {
+			case 4:	/* jeq_s [blink] */
+			case 5:	/* jne_s [blink] */
+			case 6:	/* j_s [blink] */
+			case 7:	/* j_s.d [blink] */
+				state->delay_slot = (subopcode == 7);
+				state->flow = indirect_jump;
+				state->target = get_reg(31, regs, cregs);
+			default:
+				break;
+			}
+		default:
+			break;
+		}
+		break;
+
+	case op_LD_S:	/* LD_S c, [b, u7] */
+		state->src1 = get_reg(FIELD_S_B(state->words[0]), regs, cregs);
+		state->src2 = FIELD_S_u7(state->words[0]);
+		state->dest = FIELD_S_C(state->words[0]);
+		break;
+
+	case op_LDB_S:
+	case op_STB_S:
+		/* no further handling required as byte accesses should not
+		 * cause an unaligned access exception */
+		state->zz = 1;
+		break;
+
+	case op_LDWX_S:	/* LDWX_S c, [b, u6] */
+		state->x = 1;
+		/* intentional fall-through */
+
+	case op_LDW_S:	/* LDW_S c, [b, u6] */
+		state->zz = 2;
+		state->src1 = get_reg(FIELD_S_B(state->words[0]), regs, cregs);
+		state->src2 = FIELD_S_u6(state->words[0]);
+		state->dest = FIELD_S_C(state->words[0]);
+		break;
+
+	case op_ST_S:	/* ST_S c, [b, u7] */
+		state->write = 1;
+		state->src1 = get_reg(FIELD_S_C(state->words[0]), regs, cregs);
+		state->src2 = get_reg(FIELD_S_B(state->words[0]), regs, cregs);
+		state->src3 = FIELD_S_u7(state->words[0]);
+		break;
+
+	case op_STW_S:	/* STW_S c,[b,u6] */
+		state->write = 1;
+		state->zz = 2;
+		state->src1 = get_reg(FIELD_S_C(state->words[0]), regs, cregs);
+		state->src2 = get_reg(FIELD_S_B(state->words[0]), regs, cregs);
+		state->src3 = FIELD_S_u6(state->words[0]);
+		break;
+
+	case op_SP:	/* LD_S|LDB_S b,[sp,u7], ST_S|STB_S b,[sp,u7] */
+		/* note: we are ignoring possibility of:
+		 * ADD_S, SUB_S, PUSH_S, POP_S as these should not
+		 * cause unaliged exception anyway */
+		state->write = BITS(state->words[0], 6, 6);
+		state->zz = BITS(state->words[0], 5, 5);
+		if (state->zz)
+			break;	/* byte accesses should not come here */
+		if (!state->write) {
+			state->src1 = get_reg(28, regs, cregs);
+			state->src2 = FIELD_S_u7(state->words[0]);
+			state->dest = FIELD_S_B(state->words[0]);
+		} else {
+			state->src1 = get_reg(FIELD_S_B(state->words[0]), regs,
+					cregs);
+			state->src2 = get_reg(28, regs, cregs);
+			state->src3 = FIELD_S_u7(state->words[0]);
+		}
+		break;
+
+	case op_GP:	/* LD_S|LDB_S|LDW_S r0,[gp,s11/s9/s10] */
+		/* note: ADD_S r0, gp, s11 is ignored */
+		state->zz = BITS(state->words[0], 9, 10);
+		state->src1 = get_reg(26, regs, cregs);
+		state->src2 = state->zz ? FIELD_S_s10(state->words[0]) :
+			FIELD_S_s11(state->words[0]);
+		state->dest = 0;
+		break;
+
+	case op_Pcl:	/* LD_S b,[pcl,u10] */
+		state->src1 = regs->ret & ~3;
+		state->src2 = FIELD_S_u10(state->words[0]);
+		state->dest = FIELD_S_B(state->words[0]);
+		break;
+
+	case op_BR_S:
+		state->target = FIELD_S_s8(state->words[0]) + (addr & ~0x03);
+		state->flow = direct_jump;
+		state->is_branch = 1;
+		break;
+
+	case op_B_S:
+		fieldA = (BITS(state->words[0], 9, 10) == 3) ?
+			FIELD_S_s7(state->words[0]) :
+			FIELD_S_s10(state->words[0]);
+		state->target = fieldA + (addr & ~0x03);
+		state->flow = direct_jump;
+		state->is_branch = 1;
+		break;
+
+	case op_BL_S:
+		state->target = FIELD_S_s13(state->words[0]) + (addr & ~0x03);
+		state->flow = direct_call;
+		state->is_branch = 1;
+		break;
+
+	default:
+		break;
+	}
+
+	if (bytes_not_copied <= (8 - state->instr_len))
+		return;
+
+fault:	state->fault = 1;
+}
+
+long __kprobes get_reg(int reg, struct pt_regs *regs,
+		       struct callee_regs *cregs)
+{
+	long *p;
+
+	if (reg <= 12) {
+		p = &regs->r0;
+		return p[-reg];
+	}
+
+	if (cregs && (reg <= 25)) {
+		p = &cregs->r13;
+		return p[13-reg];
+	}
+
+	if (reg == 26)
+		return regs->r26;
+	if (reg == 27)
+		return regs->fp;
+	if (reg == 28)
+		return regs->sp;
+	if (reg == 31)
+		return regs->blink;
+
+	return 0;
+}
+
+void __kprobes set_reg(int reg, long val, struct pt_regs *regs,
+		struct callee_regs *cregs)
+{
+	long *p;
+
+	switch (reg) {
+	case 0 ... 12:
+		p = &regs->r0;
+		p[-reg] = val;
+		break;
+	case 13 ... 25:
+		if (cregs) {
+			p = &cregs->r13;
+			p[13-reg] = val;
+		}
+		break;
+	case 26:
+		regs->r26 = val;
+		break;
+	case 27:
+		regs->fp = val;
+		break;
+	case 28:
+		regs->sp = val;
+		break;
+	case 31:
+		regs->blink = val;
+		break;
+	default:
+		break;
+	}
+}
+
+/*
+ * Disassembles the insn at @pc and sets @next_pc to next PC (which could be
+ * @pc +2/4/6 (ARCompact ISA allows free intermixing of 16/32 bit insns).
+ *
+ * If @pc is a branch
+ * 	-@tgt_if_br is set to branch target.
+ * 	-If branch has delay slot, @next_pc updated with actual next PC.
+ *
+ */
+int __kprobes disasm_next_pc(unsigned long pc, struct pt_regs *regs,
+			     struct callee_regs *cregs,
+			     unsigned long *next_pc, unsigned long *tgt_if_br)
+{
+	struct disasm_state instr;
+
+	memset(&instr, 0, sizeof(struct disasm_state));
+	disasm_instr(pc, &instr, 0, regs, cregs);
+
+	*next_pc = pc + instr.instr_len;
+
+	/* Instruction with possible two targets branch, jump and loop */
+	if (instr.is_branch)
+		*tgt_if_br = instr.target;
+
+	/* For the instructions with delay slots, the fall through is the
+	 * instruction following the instruction in delay slot.
+	 */
+	 if (instr.delay_slot) {
+		struct disasm_state instr_d;
+
+		disasm_instr(*next_pc, &instr_d, 0, regs, cregs);
+
+		*next_pc += instr_d.instr_len;
+	 }
+
+	 /* Zero Overhead Loop - end of the loop */
+	if (!(regs->status32 & STATUS32_L) && (*next_pc == regs->lp_end)
+		&& (regs->lp_count > 1)) {
+		*next_pc = regs->lp_start;
+	}
+
+	return instr.is_branch;
+}
+
+#endif /* CONFIG_KGDB || CONFIG_MISALIGN_ACCESS || CONFIG_KPROBES */
-- 
1.7.4.1

