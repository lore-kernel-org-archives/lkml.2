Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab2DAQDH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:03:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55546 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2DAQDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:03:01 -0400
Subject: [RFC PATCH -tip 03/16] x86: Add bogus disassembler support
To: linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 02 Apr 2012 01:02:56 +0900
Message-ID: <20120401160256.4502.29300.stgit@shimauta>
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
References: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a bogus x86 in-kernel disassember to dress up your
panic message :)
This time, the disassembler just supports basic
instructions (no SSE, no AVX, no FPU etc.).
However most of the case, it can show the code
in kernel.

Note that this currently shows assembler code in intel
format, instead of gas-like att format.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
---
 arch/x86/Kconfig.debug                   |    9 +
 arch/x86/include/asm/disasm.h            |   14 +
 arch/x86/include/asm/inat.h              |    8 
 arch/x86/include/asm/insn.h              |   14 +
 arch/x86/lib/Makefile                    |   18 +
 arch/x86/lib/disasm.c                    |  530 ++++++++++++++++++++++++++++++
 arch/x86/lib/mnemonic.c                  |   77 ++++
 arch/x86/tools/gen-insn-mnemonic-x86.awk |  344 +++++++++++++++++++
 8 files changed, 1009 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/include/asm/disasm.h
 create mode 100644 arch/x86/lib/disasm.c
 create mode 100644 arch/x86/lib/mnemonic.c
 create mode 100644 arch/x86/tools/gen-insn-mnemonic-x86.awk

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index e46c214..ae64888 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -172,6 +172,15 @@ config X86_DECODER_SELFTEST
 	 decoder code.
 	 If unsure, say "N".
 
+config X86_DISASSEMBLER
+	bool "Enable x86 instruction disassembler"
+	depends on INSTRUCTION_DECODER
+	---help---
+	 This option enables x86 instruction disassembler code in kernel.
+	 This will show disassembled code on console when you hit a bug or
+	 kernel panic.
+	 If unsure, say "Y" here, since this will help you to report bugs.
+
 #
 # IO delay types:
 #
diff --git a/arch/x86/include/asm/disasm.h b/arch/x86/include/asm/disasm.h
new file mode 100644
index 0000000..ec5208f
--- /dev/null
+++ b/arch/x86/include/asm/disasm.h
@@ -0,0 +1,14 @@
+#ifndef __X86_DISASM_H__
+#define __X86_DISASM_H__
+#include <asm/insn.h>
+
+/* Mnemonic format table lookup routines */
+extern const char *get_mnemonic_format(struct insn *insn, const char **grp);
+extern const char *get_prefix_name(struct insn *insn);
+
+#define DISASM_STR_LEN	128
+
+/* Disassemble given decoded instruction */
+extern int disassemble(char *buf, size_t len, struct insn *insn);
+
+#endif	/*__X86_DISASM_H__*/
diff --git a/arch/x86/include/asm/inat.h b/arch/x86/include/asm/inat.h
index 2a86c26..2c90f5f 100644
--- a/arch/x86/include/asm/inat.h
+++ b/arch/x86/include/asm/inat.h
@@ -50,6 +50,8 @@
 #define INAT_PFX_VEX3	14	/* 3-bytes VEX prefix */
 
 #define INAT_LSTPFX_MAX	3
+#define INAT_SEGPFX_MIN	5
+#define INAT_SEGPFX_MAX	10
 #define INAT_LGCPFX_MAX	11
 
 /* Immediate size */
@@ -116,6 +118,12 @@ static inline int inat_is_legacy_prefix(insn_attr_t attr)
 	return attr && attr <= INAT_LGCPFX_MAX;
 }
 
+static inline int inat_is_segment_prefix(insn_attr_t attr)
+{
+	attr &= INAT_PFX_MASK;
+	return INAT_SEGPFX_MIN <= attr && attr <= INAT_SEGPFX_MAX;
+}
+
 static inline int inat_is_address_size_prefix(insn_attr_t attr)
 {
 	return (attr & INAT_PFX_MASK) == INAT_PFX_ADDRSZ;
diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 34aecec..d96fca9 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -82,6 +82,7 @@ struct insn {
 #define X86_REX_R(rex) ((rex) & 4)
 #define X86_REX_X(rex) ((rex) & 2)
 #define X86_REX_B(rex) ((rex) & 1)
+#define X86_REX_WRXB(rex) ((rex) & 0xf)
 
 #define X86_OPCODE_GPR(opcode) ((opcode) & 0x07)
 
@@ -168,6 +169,19 @@ static inline int insn_last_prefix_id(struct insn *insn)
 	return 0;
 }
 
+static inline insn_attr_t insn_has_segment_prefix(struct insn *insn)
+{
+	insn_attr_t attr;
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		attr = inat_get_opcode_attribute(insn->prefixes.bytes[i]);
+		if (inat_is_segment_prefix(attr))
+			return attr;
+	}
+	return 0;
+}
+
 /* Offset of each field from kaddr */
 static inline int insn_offset_rex_prefix(struct insn *insn)
 {
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index b00f678..2571061 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -1,18 +1,25 @@
 #
 # Makefile for x86 specific library files.
 #
+x86_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
 
 inat_tables_script = $(srctree)/arch/x86/tools/gen-insn-attr-x86.awk
-inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
 quiet_cmd_inat_tables = GEN     $@
-      cmd_inat_tables = $(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@ || rm -f $@
-
-$(obj)/inat-tables.c: $(inat_tables_script) $(inat_tables_maps)
+      cmd_inat_tables = $(AWK) -f $(inat_tables_script) $(x86_tables_maps) > $@ || rm -f $@
+$(obj)/inat-tables.c: $(inat_tables_script) $(x86_tables_maps)
 	$(call cmd,inat_tables)
 
 $(obj)/inat.o: $(obj)/inat-tables.c
 
-clean-files := inat-tables.c
+mnemonic_tables_script = $(srctree)/arch/x86/tools/gen-insn-mnemonic-x86.awk
+quiet_cmd_mnemonic_tables = GEN     $@
+      cmd_mnemonic_tables = $(AWK) -f $(mnemonic_tables_script) $(x86_tables_maps) > $@ || rm -f $@
+$(obj)/mnemonic-tables.c: $(mnemonic_tables_script) $(x86_tables_maps)
+	$(call cmd,mnemonic_tables)
+
+$(obj)/mnemonic.o: $(obj)/mnemonic-tables.c
+
+clean-files := inat-tables.c mnemonic-tables.c
 
 obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
 
@@ -23,6 +30,7 @@ lib-y += memcpy_$(BITS).o
 lib-$(CONFIG_SMP) += rwlock.o
 lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem.o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o
+lib-$(CONFIG_X86_DISASSEMBLER) += disasm.o mnemonic.o
 
 obj-y += msr.o msr-reg.o msr-reg-export.o
 
diff --git a/arch/x86/lib/disasm.c b/arch/x86/lib/disasm.c
new file mode 100644
index 0000000..473ae52
--- /dev/null
+++ b/arch/x86/lib/disasm.c
@@ -0,0 +1,530 @@
+/*
+ * Disasm.c -- the core of bogus disassembler code
+ * Written by Masami Hiramatsu <masami.hiramatsu@gmail.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/errno.h>
+#include <asm/disasm.h>
+
+#define X86_LEA_OPCODE 0x8d
+
+static int psnprintf(char **buf, size_t *len, const char *fmt, ...)
+{
+	va_list ap;
+	int ret;
+
+	va_start(ap, fmt);
+	ret = vsnprintf(*buf, *len, fmt, ap);
+	va_end(ap);
+	if (ret > 0 && ret < *len) {
+		*buf += ret;
+		*len -= ret;
+	} else
+		ret = -E2BIG;
+
+	return ret;
+}
+
+/* Operand classifiers */
+static bool operand_is_register(const char *p)
+{
+	return !isupper(*p);
+}
+
+static bool operand_is_imm(const char *p)
+{
+	return strchr("AIJO", *p) != NULL;
+}
+
+static bool operand_is_gp_reg(const char *p)
+{
+	return *p == 'G';
+}
+
+static bool operand_is_ctl_reg(const char *p)
+{
+	return *p == 'C';
+}
+
+static bool operand_is_dbg_reg(const char *p)
+{
+	return *p == 'D';
+}
+
+static bool operand_is_seg_reg(const char *p)
+{
+	return *p == 'S';
+}
+
+static bool operand_is_flags(const char *p)
+{
+	return *p == 'F';
+}
+
+static bool operand_is_fixmem(const char *p)
+{
+	return *p == 'X' || *p == 'Y';
+}
+
+static bool operand_is_memreg(const char *p)
+{
+	return *p == 'E' || *p == 'M' || *p == 'R';
+}
+
+/* register maps */
+const char *gpreg_map[8] = {"ax", "cx", "dx", "bx", "sp", "bp", "si", "di"};
+const char *gpreg8_map[8] = {"al", "cl", "dl", "bl", "ah", "ch", "dh", "bh"};
+const char *gpreg8_map2[8] = {"al", "cl", "dl", "bl", "spl", "bpl", "sil", "dil"};
+const char *segreg_map[8] = {"es", "cs", "ss", "ds", "fs", "gs", "(bad)", "(bad)"};
+const char *gprea16_map[8] = {"bx+si", "bx+di", "bp+si", "bp+di", "si", "di", "bp", "bx"};
+
+static unsigned int insn_field_get_uval(struct insn_field *field)
+{
+	switch (field->nbytes) {
+	case 1:
+		return field->bytes[0];
+	case 2:
+		return (unsigned short)field->value;
+	default:
+		return (unsigned int)field->value;
+	}
+}
+
+static int bad_modrm_operand(char c, int mod)
+{
+	return (c == 'R' && mod != 3) || (c == 'M' && mod == 3);
+}
+
+/* Print General Purpose Registers by number */
+static int psnprint_gpr8(char **buf, size_t *len, int idx)
+{
+	if (idx < 8)
+		return psnprintf(buf, len, "%s", gpreg8_map[idx]);
+	else if (16 < idx && idx < 24)
+		return psnprintf(buf, len, "%s", gpreg8_map2[idx - 16]);
+	else
+		return psnprintf(buf, len, "r%dl", idx);
+}
+
+static int psnprint_gpr16(char **buf, size_t *len, int idx)
+{
+	if (idx < 8)
+		return psnprintf(buf, len, "%s", gpreg_map[idx]);
+	else
+		return psnprintf(buf, len, "r%dw", idx);
+}
+
+static int psnprint_gpr32(char **buf, size_t *len, int idx)
+{
+	if (idx < 8)
+		return psnprintf(buf, len, "e%s", gpreg_map[idx]);
+	else
+		return psnprintf(buf, len, "r%dd", idx);
+}
+
+static int psnprint_gpr64(char **buf, size_t *len, int idx)
+{
+	if (idx < 8)
+		return psnprintf(buf, len, "r%s", gpreg_map[idx]);
+	else
+		return psnprintf(buf, len, "r%d", idx);
+}
+
+/* Disassemble GPR operands */
+static int __disasm_gpr(char **buf, size_t *len, const char *opnd,
+			const char *end, struct insn *insn, int idx)
+{
+	switch (opnd[1]) {
+	case 'b':
+		return psnprint_gpr8(buf, len, idx);
+	case 'w':
+		return psnprint_gpr16(buf, len, idx);
+	case 'l':
+		if (insn->opnd_bytes == 8)
+			return psnprint_gpr64(buf, len, idx);
+		else
+			return psnprint_gpr32(buf, len, idx);
+	case 'v':
+		if (insn->opnd_bytes == 8)
+			return psnprint_gpr64(buf, len, idx);
+		else if (insn->opnd_bytes == 4)
+			return psnprint_gpr32(buf, len, idx);
+		else
+			return psnprint_gpr16(buf, len, idx);
+	default:
+		return psnprintf(buf, len, "(%.*s)(bad)", end - opnd, opnd);
+	}
+}
+
+/* Disassemble GPR operand from RM bits */
+static int disasm_rm_gpr(char **buf, size_t *len, const char *opnd,
+			const char *end, struct insn *insn)
+{
+	int idx = X86_MODRM_RM(insn->modrm.bytes[0]);
+	if (insn->rex_prefix.nbytes && X86_REX_B(insn->rex_prefix.bytes[0]))
+		idx += 8;
+	return __disasm_gpr(buf, len, opnd, end, insn, idx);
+}
+
+/* Disassemble GPR operand from Reg bits */
+static int disasm_reg_gpr(char **buf, size_t *len, const char *opnd,
+			const char *end, struct insn *insn)
+{
+	int idx = X86_MODRM_REG(insn->modrm.bytes[0]);
+	if (insn->rex_prefix.nbytes) {
+		if (X86_REX_R(insn->rex_prefix.bytes[0]))
+			idx += 8;
+		else if (X86_REX_WRXB(insn->rex_prefix.bytes[0]) == 0)
+			idx += 16;
+	}
+	return __disasm_gpr(buf, len, opnd, end, insn, idx);
+}
+
+/* Disassemble GPR operand from Opcode */
+static int disasm_opcode_gpr(char **buf, size_t *len, const char *opnd,
+			     const char *end, struct insn *insn)
+{
+	int idx = X86_OPCODE_GPR(insn->opcode.bytes[insn->opcode.nbytes - 1]);
+	if (insn->rex_prefix.nbytes && X86_REX_R(insn->rex_prefix.bytes[0]))
+		idx += 8;
+	return __disasm_gpr(buf, len, opnd, end, insn, idx);
+}
+
+/* Disassemble GPR for Effective Address */
+static int __disasm_gprea(char **buf, size_t *len, const char *opnd,
+			const char *end, struct insn *insn, int idx)
+{
+	if (insn->addr_bytes == 8)
+		return psnprint_gpr64(buf, len, idx);
+	else if (insn->addr_bytes == 4)
+		return psnprint_gpr32(buf, len, idx);
+	else
+		return psnprintf(buf, len, "%s", gprea16_map[idx]);
+}
+
+static int get_operand_size(struct insn *insn, int type)
+{
+	int size = insn->opnd_bytes;
+
+	switch (type) {
+	case 'b':
+		size = 1;
+		break;
+	case 'w':
+		size = 2;
+		break;
+	case 'd':
+		size = 4;
+		break;
+	case 'q':
+		size = 8;
+		break;
+	case 'z':
+		if (size == 8)
+			size = 4;
+		break;
+	}
+	return size;
+}
+
+static int disasm_pointer(char **buf, size_t *len, const char *opnd,
+			  const char *end, struct insn *insn)
+{
+	const char *type = "(bad)";
+
+	if (insn->opcode.bytes[0] == X86_LEA_OPCODE)
+		return 0;
+
+	switch (get_operand_size(insn, opnd[1])) {
+	case 1:
+		type = "BYTE";
+		break;
+	case 2:
+		type = "WORD";
+		break;
+	case 4:
+		type = "DWORD";
+		break;
+	case 8:
+		type = "QWORD";
+		break;
+	}
+	return psnprintf(buf, len, "%s PTR ", type);
+}
+
+/* Disassemble a segment prefix */
+static int __disasm_segment_prefix(char **buf, size_t *len,
+				   struct insn *insn, insn_attr_t def_attr)
+{
+	insn_attr_t attr = insn_has_segment_prefix(insn);
+
+	if (!attr) {
+		if (!def_attr)
+			return 0;
+		else
+			attr = def_attr;
+	}
+
+	attr = (attr & INAT_PFX_MASK) - INAT_SEGPFX_MIN;
+	return psnprintf(buf, len, "%s:", segreg_map[attr]);
+}
+
+static int disasm_segment_prefix(char **buf, size_t *len, struct insn *insn)
+{
+	return __disasm_segment_prefix(buf, len, insn, 0);
+}
+
+static int disasm_displacement(char **buf, size_t *len, struct insn *insn)
+{
+	__disasm_segment_prefix(buf, len, insn, INAT_PFX_DS);
+	return psnprintf(buf, len, "0x%x", insn->displacement.value);
+}
+
+/* Disassemble SIB byte */
+static int disasm_sib(char **buf, size_t *len, const char *opnd,
+			const char *end, struct insn *insn)
+{
+	int mod = X86_MODRM_MOD(insn->modrm.bytes[0]);
+	int scale = X86_SIB_SCALE(insn->sib.bytes[0]);
+	int index = X86_SIB_INDEX(insn->sib.bytes[0]);
+	int base = X86_SIB_BASE(insn->sib.bytes[0]);
+	int rexb = X86_REX_B(insn->rex_prefix.bytes[0]) * 8;
+	int rexx = X86_REX_X(insn->rex_prefix.bytes[0]) * 8;
+
+	/* Check the case which has just a displacement */
+	if (mod == 0 && index == 4 && base == 5)
+		return disasm_displacement(buf, len, insn);
+
+	disasm_segment_prefix(buf, len, insn);
+	psnprintf(buf, len, "[");
+	if (mod != 0 || base != 5)	/* With base */
+		__disasm_gprea(buf, len, opnd, end, insn, base + rexb);
+
+	if (index != 4)	{	/* With scale * index */
+		if (mod != 0 || base != 5)
+			psnprintf(buf, len, "+");
+		__disasm_gprea(buf, len, opnd, end, insn, index + rexx);
+		psnprintf(buf, len, "*%x", 1 << scale);
+	}
+	if (mod != 0 || base == 5) {	/* With displacement offset */
+		if (insn->displacement.value < 0)
+			psnprintf(buf, len, "-0x%x", -insn->displacement.value);
+		else
+			psnprintf(buf, len, "+0x%x", insn->displacement.value);
+	}
+	return psnprintf(buf, len, "]");
+}
+
+/* Disassemble memory-register from MODR/M */
+static int disasm_modrm(char **buf, size_t *len, const char *opnd,
+			const char *end, struct insn *insn)
+{
+	int mod = X86_MODRM_MOD(insn->modrm.bytes[0]);
+	int rm = X86_MODRM_RM(insn->modrm.bytes[0]);
+
+	if (bad_modrm_operand(*opnd, mod))
+		psnprintf(buf, len, "(bad)");
+
+	if (mod == 0x3)	/* mod == 11B: GPR, MM or XMM */
+		return disasm_rm_gpr(buf, len, opnd, end, insn);
+
+	/* Memory addressing */
+	disasm_pointer(buf, len, opnd, end, insn);
+
+	if (insn->sib.nbytes)	/* SIB addressing */
+		return disasm_sib(buf, len, opnd, end, insn);
+
+	if (mod == 0 && rm == 5) {	/* displacement only */
+		if (insn_rip_relative(insn))	/* RIP relative */
+			return psnprintf(buf, len, "[rip+0x%x]",
+					  insn->displacement.value);
+		else
+			return disasm_displacement(buf, len, insn);
+	} else {
+		disasm_segment_prefix(buf, len, insn);
+		psnprintf(buf, len, "[");
+		if (insn->rex_prefix.nbytes && X86_REX_B(insn->rex_prefix.bytes[0]))
+			rm += 8;
+		__disasm_gprea(buf, len, opnd, end, insn, rm);
+		if (mod != 0) {
+			if (insn->displacement.value < 0)
+				psnprintf(buf, len, "-0x%x", -insn->displacement.value);
+			else
+				psnprintf(buf, len, "+0x%x", insn->displacement.value);
+		}
+		return psnprintf(buf, len, "]");
+	}
+}
+
+static int disasm_immediate(char **buf, size_t *len, const char *opnd,
+			    const char *end, struct insn *insn)
+{
+	long long imm;
+	int size;
+
+	if (inat_has_moffset(insn->attr) && insn->addr_bytes == 8) {
+		/* 64bit memory offset */
+		unsigned long long moffs;
+		moffs = insn_field_get_uval(&insn->immediate2);
+		moffs <<= 32;
+		moffs += insn_field_get_uval(&insn->immediate);
+		__disasm_segment_prefix(buf, len, insn, INAT_PFX_DS);
+		return psnprintf(buf, len, "0x%llx", moffs);
+	}
+
+	/* Immediates are sign-extended */
+	if (inat_has_second_immediate(insn->attr) &&
+	    opnd[0] == 'I' && opnd[1] == 'b')
+		imm = insn->immediate2.value;
+	else
+		imm = insn->immediate1.value;
+
+	if (opnd[0] == 'J' || opnd[0] == 'A') {
+		if (opnd[0] == 'J') /* Relative from IP */
+			imm += (long)insn->kaddr + insn->length;
+		return psnprintf(buf, len, "%lx", (unsigned long)imm);
+	}
+
+	size = insn->opnd_bytes;
+	if (opnd[1] == 'B')
+		size = 1;
+	switch (size) {
+	case 8:
+		return psnprintf(buf, len, "0x%llx", imm);
+	case 4:
+		return psnprintf(buf, len, "0x%x", (unsigned int)imm);
+	case 2:
+		return psnprintf(buf, len, "0x%x", (unsigned short)imm);
+	default:
+		return psnprintf(buf, len, "0x%x", (unsigned char)imm);
+	}
+}
+
+static int disasm_fixmem(char **buf, size_t *len, const char *opnd,
+			 const char *end, struct insn *insn)
+{
+	const char *pfx = "";
+	if (insn->addr_bytes == 4)
+		pfx = "e";
+	else if (insn->addr_bytes == 8)
+		pfx = "r";
+
+	disasm_pointer(buf, len, opnd, end, insn);
+	return psnprintf(buf, len, "%cs:[%s%ci]", *opnd == 'x' ? 'd' : 'e',
+			 pfx, *opnd == 'x' ? 's' : 'd');
+}
+
+static int disasm_register(char **buf, size_t *len, const char *opnd,
+			   const char *end, struct insn *insn)
+{
+	char pfx[2] = {'\0', '\0'};
+
+	if (*opnd == '_') {
+		if (opnd[1] == 'r' || opnd[1] == 'e') {
+			if (insn->opnd_bytes == 4)
+				pfx[0] = 'e';
+			else if (insn->opnd_bytes == 8)
+				pfx[0] = opnd[1];
+			opnd += 2;
+			return psnprintf(buf, len, "%s%.*s", pfx, end - opnd, opnd);
+		} else
+			return disasm_opcode_gpr(buf, len, opnd, end, insn);
+	} else
+		return psnprintf(buf, len, "%.*s", end - opnd, opnd);
+}
+
+/* Disassembe an operand */
+static int disasm_operand(char **buf, size_t *len, const char *opnd,
+			  const char *end, struct insn *insn)
+{
+	if (operand_is_register(opnd))
+		return disasm_register(buf, len, opnd, end, insn);
+	else if (operand_is_memreg(opnd))	/* Mod and RM */
+		return disasm_modrm(buf, len, opnd, end, insn);
+	else if (operand_is_imm(opnd)) /* Immedate */
+		return disasm_immediate(buf, len, opnd, end, insn);
+	else if (operand_is_gp_reg(opnd))
+		return disasm_reg_gpr(buf, len, opnd, end, insn);
+	else if (operand_is_ctl_reg(opnd)) {
+		int idx = X86_MODRM_REG(insn->modrm.bytes[0]);
+		return psnprintf(buf, len, "cr%d", idx);
+	} else if (operand_is_dbg_reg(opnd)) {
+		int idx = X86_MODRM_REG(insn->modrm.bytes[0]);
+		return psnprintf(buf, len, "dr%d", idx);
+	} else if (operand_is_seg_reg(opnd)) {
+		int idx = X86_MODRM_REG(insn->modrm.bytes[0]);
+		return psnprintf(buf, len, "%s", segreg_map[idx]);
+	} else if (operand_is_fixmem(opnd))
+		return disasm_fixmem(buf, len, opnd, end, insn);
+	else if (operand_is_flags(opnd))
+		/* Ignore EFLAGS/RFLAGS */
+		return 0;
+	else /* Unknown type */
+		return psnprintf(buf, len, "(%.*s)", end - opnd, opnd);
+}
+
+/**
+ * disassemble() - Disassemble given instruction
+ * @buf:	A buffer in which assembly code is stored
+ * @len:	The size of @buf
+ * @insn:	An instruction which will be disassembled
+ *
+ * This disassembles given instruction.
+ * Caller must decode @insn with insn_get_length().
+ */
+int disassemble(char *buf, size_t len, struct insn *insn)
+{
+	const char *mn_fmt;
+	const char *grp_fmt = NULL;
+	const char *prefix;
+	const char *p, *q = NULL;
+	size_t orig_len = len;
+	int ret;
+
+	/* Get the mnemonic format of given instruction */
+	mn_fmt = get_mnemonic_format(insn, &grp_fmt);
+	if (!mn_fmt)
+		return -ENOENT;
+
+	/* Put a prefix if exist */
+	prefix = get_prefix_name(insn);
+	if (prefix) {
+		ret = psnprintf(&buf, &len, "%s ", prefix);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* Get operand */
+	q = p = strpbrk(mn_fmt, " |");	/* q is the end of opcode */
+	if (grp_fmt) {	/* Group opcode */
+		q = strpbrk(grp_fmt, " |");
+		mn_fmt = grp_fmt;
+		if (!p)	/* No group operand. use individual operand */
+			p = q;
+	}
+
+	/* Print opcode */
+	if (!q)
+		ret = psnprintf(&buf, &len, "%-6s ", mn_fmt);
+	else
+		ret = psnprintf(&buf, &len, "%-6.*s ", q - mn_fmt, mn_fmt);
+
+	/* Disassemble operands */
+	while (p && *p != '\0' && *p != '|' && ret >= 0) {
+		p++;
+		q = strpbrk(p, ",|");
+		if (!q)
+			q = p + strlen(p);
+		ret = disasm_operand(&buf, &len, p, q, insn);
+		if (ret < 0)
+			break;
+		if (*q == ',')
+			ret = psnprintf(&buf, &len, ",");
+		p = q;
+	}
+
+	return ret < 0 ? ret : orig_len - len;
+}
diff --git a/arch/x86/lib/mnemonic.c b/arch/x86/lib/mnemonic.c
new file mode 100644
index 0000000..0c375fb
--- /dev/null
+++ b/arch/x86/lib/mnemonic.c
@@ -0,0 +1,77 @@
+#include <linux/kernel.h>
+#include <asm/insn.h>
+#include <asm/disasm.h>
+
+/* Define mnemonic lookup table */
+#include "mnemonic-tables.c"
+
+const char *get_mnemonic_format(struct insn *insn, const char **grp)
+{
+	insn_attr_t attr;
+	const char *ret = NULL;
+	const char * const *table;
+	int n, m;
+	insn_byte_t idx, *bytes = insn->opcode.bytes;
+
+	if (!insn_complete(insn))
+		goto fail;	/* Decode it first! */
+
+	if (insn_is_avx(insn)) {
+		/* Lookup AVX instruction */
+		goto fail;
+	} else {
+		/* Lookup normal instruction */
+		idx = *bytes;
+		attr = inat_get_opcode_attribute(idx);
+		m = insn_last_prefix_id(insn);
+		/*TODO use (inat_has_variant(attr))*/
+		table = mnemonic_primary_tables[m];
+		if (!table || !table[idx])
+			table = mnemonic_primary_tables[0];
+		/* Solve escapes */
+		while (inat_is_escape(attr)) {
+			n = inat_escape_id(attr);
+			idx = *++bytes;
+			attr = inat_get_escape_attribute(idx, 0, attr);
+			if (inat_has_variant(attr))
+				table = mnemonic_escape_tables[n][m];
+			else
+				table = mnemonic_escape_tables[n][0];
+		}
+		if (table)
+			ret = table[idx];
+
+		/* Solve groups */
+		if (grp && inat_is_group(attr)) {
+			n = inat_group_id(attr);
+			idx = insn->modrm.bytes[0];
+			attr = inat_get_group_attribute(idx, 0, attr);
+			if (inat_has_variant(attr))
+				table = mnemonic_group_tables[n][m];
+			else
+				table = mnemonic_group_tables[n][0];
+			idx = X86_MODRM_REG(idx);
+			*grp = table[idx];
+		}
+	}
+	return ret;
+
+fail:
+	return NULL;
+}
+
+const char *get_prefix_name(struct insn *insn)
+{
+	int i = 0;
+	insn_attr_t attr;
+
+	for (i = 0; i < insn->prefixes.nbytes; i++) {
+		attr = inat_get_opcode_attribute(insn->prefixes.bytes[i]);
+		attr &= INAT_PFX_MASK;
+		if (attr == INAT_PFX_REPE ||
+		    attr == INAT_PFX_REPNE ||
+		    attr == INAT_PFX_LOCK)
+			return mnemonic_primary_table[insn->prefixes.bytes[i]];
+	}
+	return NULL;
+}
diff --git a/arch/x86/tools/gen-insn-mnemonic-x86.awk b/arch/x86/tools/gen-insn-mnemonic-x86.awk
new file mode 100644
index 0000000..2714f2f
--- /dev/null
+++ b/arch/x86/tools/gen-insn-mnemonic-x86.awk
@@ -0,0 +1,344 @@
+#!/bin/awk -f
+# gen-insn-mnemonic-x86.awk: X86 Instruction mnemonic table generator
+# Written by Masami Hiramatsu <masami.hiramatsu@gmail.com>
+#
+# Usage: awk -f gen-insn-mnemonic-x86.awk x86-opcode-map.txt > mnemonic-tables.c
+
+# Awk implementation sanity check
+function check_awk_implement() {
+	if (sprintf("%x", 0) != "0")
+		return "Your awk has a printf-format problem."
+	return ""
+}
+
+# Clear working vars
+function clear_vars() {
+	delete table
+	delete lptable1
+	delete lptable2
+	delete lptable3
+	eid = -1 # escape id
+	gid = -1 # group id
+	aid = -1 # AVX id
+	tname = ""
+}
+
+BEGIN {
+	# Implementation error checking
+	awkchecked = check_awk_implement()
+	if (awkchecked != "") {
+		print "Error: " awkchecked > "/dev/stderr"
+		print "Please try to use gawk." > "/dev/stderr"
+		exit 1
+	}
+
+	# Setup generating tables
+	print "/* x86 opcode map generated from x86-opcode-map.txt */"
+	print "/* Do not change this code. */\n"
+	ggid = 1
+	geid = 1
+	gaid = 0
+	delete etable
+	delete gtable
+	delete atable
+
+	opnd_expr = "^[A-Za-z/]"
+	ext_expr = "^\\("
+	sep_expr = "^\\|$"
+	group_expr = "^Grp[0-9A-Za-z]+"
+	regs_expr = "^[ABCDESR][0-9A-Z]"
+	vregs_expr = "^[re][0-9A-Z]"
+
+	lprefix1_expr = "\\(66\\)"
+	lprefix2_expr = "\\(F3\\)"
+	lprefix3_expr = "\\(F2\\)"
+	max_lprefix = 4
+
+	prefix_expr = "\\(Prefix\\)"
+	imm_expr = "^[IJAO][a-z]"
+	clear_vars()
+}
+
+function semantic_error(msg) {
+	print "Semantic error at " NR ": " msg > "/dev/stderr"
+	exit 1
+}
+
+function debug(msg) {
+	print "DEBUG: " msg
+}
+
+function array_size(arr,   i,c) {
+	c = 0
+	for (i in arr)
+		c++
+	return c
+}
+
+/^Table:/ {
+	print "/* " $0 " */"
+	if (tname != "")
+		semantic_error("Hit Table: before EndTable:.");
+}
+
+/^Referrer:/ {
+	if (NF != 1) {
+		# escape opcode table
+		ref = ""
+		for (i = 2; i <= NF; i++)
+			ref = ref $i
+		eid = escape[ref]
+		tname = sprintf("mnemonic_escape_table_%d", eid)
+	}
+}
+
+/^AVXcode:/ {
+	if (NF != 1) {
+		# AVX/escape opcode table
+		aid = $2
+		if (gaid <= aid)
+			gaid = aid + 1
+		if (tname == "")	# AVX only opcode table
+			tname = sprintf("mnemonic_avx_table_%d", $2)
+	}
+	if (aid == -1 && eid == -1)	# primary opcode table
+		tname = "mnemonic_primary_table"
+}
+
+/^GrpTable:/ {
+	print "/* " $0 " */"
+	if (!($2 in group))
+		semantic_error("No group: " $2 )
+	gid = group[$2]
+	tname = "mnemonic_group_table_" gid
+}
+
+function print_table(tbl,name,fmt,n)
+{
+	print "const char *" name " = {"
+	for (i = 0; i < n; i++) {
+		id = sprintf(fmt, i)
+		if (tbl[id])
+			print "	[" id "] = " tbl[id] ","
+	}
+	print "};"
+}
+
+/^EndTable/ {
+	if (gid != -1) {
+		# print group tables
+		if (array_size(table) != 0) {
+			print_table(table, tname "[INAT_GROUP_TABLE_SIZE]",
+				    "0x%x", 8)
+			gtable[gid,0] = tname
+		}
+		if (array_size(lptable1) != 0) {
+			print_table(lptable1, tname "_1[INAT_GROUP_TABLE_SIZE]",
+				    "0x%x", 8)
+			gtable[gid,1] = tname "_1"
+		}
+		if (array_size(lptable2) != 0) {
+			print_table(lptable2, tname "_2[INAT_GROUP_TABLE_SIZE]",
+				    "0x%x", 8)
+			gtable[gid,2] = tname "_2"
+		}
+		if (array_size(lptable3) != 0) {
+			print_table(lptable3, tname "_3[INAT_GROUP_TABLE_SIZE]",
+				    "0x%x", 8)
+			gtable[gid,3] = tname "_3"
+		}
+	} else {
+		# print primary/escaped tables
+		if (array_size(table) != 0) {
+			print_table(table, tname "[INAT_OPCODE_TABLE_SIZE]",
+				    "0x%02x", 256)
+			etable[eid,0] = tname
+			if (aid >= 0)
+				atable[aid,0] = tname
+		}
+		if (array_size(lptable1) != 0) {
+			print_table(lptable1,tname "_1[INAT_OPCODE_TABLE_SIZE]",
+				    "0x%02x", 256)
+			etable[eid,1] = tname "_1"
+			if (aid >= 0)
+				atable[aid,1] = tname "_1"
+		}
+		if (array_size(lptable2) != 0) {
+			print_table(lptable2,tname "_2[INAT_OPCODE_TABLE_SIZE]",
+				    "0x%02x", 256)
+			etable[eid,2] = tname "_2"
+			if (aid >= 0)
+				atable[aid,2] = tname "_2"
+		}
+		if (array_size(lptable3) != 0) {
+			print_table(lptable3,tname "_3[INAT_OPCODE_TABLE_SIZE]",
+				    "0x%02x", 256)
+			etable[eid,3] = tname "_3"
+			if (aid >= 0)
+				atable[aid,3] = tname "_3"
+		}
+	}
+	print ""
+	clear_vars()
+}
+
+function add_flags(old,new) {
+	if (old && new)
+		return old "\"|\"" new
+	else if (old)
+		return old
+	else
+		return new
+}
+
+function get_operand(opnd,	i,count,f8,opnds) {
+	count = split(opnd, opnds, ",")
+	# re-encode registers
+	f8 = 0
+	for (i = 1; i <= count; i++) {
+		if (match(opnds[i], "^r[A-Z][XIP]/r[189]"))
+			opnds[i] = "_vgpr"	# GPR encoded in opcode
+		else if (match(opnds[i], "^R[A-Z]*/E[A-Z]*/R[0-9]"))
+			opnds[i] = "_lgpr"	# 32 or 64 bit GPR encoded in opcode
+		else if (match(opnds[i], "^[A-Z][LH]/R[189]")) {
+			opnds[i] = "_bgpr"	# 8 bit GPR encoded in opcode
+			f8 = 1	# forcibly 8 bit cast
+		} else if (match(opnds[i], regs_expr)) {
+			if (match(opnds[i], "^[A-Z][LH]"))
+				f8 = 1
+			opnds[i] = tolower(opnds[i])
+		} else if (match(opnds[i], vregs_expr))
+			opnds[i] = "_" tolower(opnds[i])
+	}
+
+	for (i = 1; i <= count; i++) {
+		if (f8 == 1 && match(opnds[i],"Ib"))
+			opnds[i] = toupper(opnds[i])
+		if (i == 1)
+			opnd = opnds[i]
+		else
+			opnd = opnd "," opnds[i]
+	}
+	return opnd
+}
+
+/^[0-9a-f]+\:/ {
+	if (NR == 1)
+		next
+	# get index
+	idx = "0x" substr($1, 1, index($1,":") - 1)
+	if (idx in table)
+		semantic_error("Redefine " idx " in " tname)
+
+	# check if escaped opcode
+	if ("escape" == $2) {
+		if ($3 != "#")
+			semantic_error("No escaped name")
+		ref = ""
+		for (i = 4; i <= NF; i++)
+			ref = ref $i
+		if (ref in escape)
+			semantic_error("Redefine escape (" ref ")")
+		escape[ref] = geid
+		geid++
+		#table[idx] = "INAT_MAKE_ESCAPE(" escape[ref] ")"
+		table[idx] = "\"Escape_" escape[ref] "\""
+		next
+	}
+
+	variant = null
+	# converts
+	i = 2
+	while (i <= NF) {
+		opcode = $(i++)
+		ext = null
+		flags = null
+		opnd = null
+		# parse one opcode
+		if (match($i, opnd_expr))
+			opnd = get_operand($(i++))
+		if (match($i, ext_expr))
+			ext = $(i++)
+		if (match($i, sep_expr))
+			i++
+		else if (i < NF)
+			semantic_error($i " is not a separator")
+
+		# check if group opcode
+		if (match(opcode, group_expr)) {
+			if (!(opcode in group)) {
+				group[opcode] = ggid
+				ggid++
+			}
+		}
+
+		# opcode to lower characters
+		opcode = tolower(opcode)
+		if (index(opcode, "/"))
+			opcode = substr(opcode, 0, index(opcode, "/") - 1)
+		# remove near/far postfix
+		if (match(opcode, "^jmp.*"))
+			opcode = "jmp"
+		if (match(opcode, "^call.*"))
+			opcode = "call"
+		if (match(opcode, "^ret.*"))
+			opcode = "ret"
+		if (length(opnd) != 0)
+			flags = "\"" opcode " " opnd "\""
+		else
+			flags = "\"" opcode "\""
+
+		if (length(flags) == 0)
+			continue
+		# check if last prefix
+		if (match(ext, lprefix1_expr)) {
+			lptable1[idx] = add_flags(lptable1[idx], flags)
+		} else if (match(ext, lprefix2_expr)) {
+			lptable2[idx] = add_flags(lptable2[idx], flags)
+		} else if (match(ext, lprefix3_expr)) {
+			lptable3[idx] = add_flags(lptable3[idx], flags)
+		} else {
+			table[idx] = add_flags(table[idx], flags)
+		}
+	}
+}
+
+END {
+	if (awkchecked != "")
+		exit 1
+	# print primary opcode map's array
+	print "/* Primary opcode map array */"
+	print "const char * const *mnemonic_primary_tables[INAT_LSTPFX_MAX + 1] = {"
+	for (j = 0; j < max_lprefix; j++)
+		if (etable[-1,j])
+			print "	["j"] = "etable[-1,j]","
+	print "};\n"
+	# print escape opcode map's array
+	print "/* Escape opcode map array */"
+	print "const char * const *mnemonic_escape_tables[INAT_ESC_MAX + 1]" \
+	      "[INAT_LSTPFX_MAX + 1] = {"
+	for (i = 0; i < geid; i++)
+		for (j = 0; j < max_lprefix; j++)
+			if (etable[i,j])
+				print "	["i"]["j"] = "etable[i,j]","
+	print "};\n"
+	# print group opcode map's array
+	print "/* Group opcode map array */"
+	print "const char * const *mnemonic_group_tables[INAT_GRP_MAX + 1]"\
+	      "[INAT_LSTPFX_MAX + 1] = {"
+	for (i = 0; i < ggid; i++)
+		for (j = 0; j < max_lprefix; j++)
+			if (gtable[i,j])
+				print "	["i"]["j"] = "gtable[i,j]","
+	print "};\n"
+	# print AVX opcode map's array
+	print "/* AVX opcode map array */"
+	print "const char * const *mnemonic_avx_tables[X86_VEX_M_MAX + 1]"\
+	      "[INAT_LSTPFX_MAX + 1] = {"
+	for (i = 0; i < gaid; i++)
+		for (j = 0; j < max_lprefix; j++)
+			if (atable[i,j])
+				print "	["i"]["j"] = "atable[i,j]","
+	print "};"
+}
+

