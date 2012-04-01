Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2DAQDb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:03:31 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:32815 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2DAQD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:03:27 -0400
Subject: [RFC PATCH -tip 06/16] x86: Change asm syntax to AT&T-like one
To: linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 02 Apr 2012 01:03:23 +0900
Message-ID: <20120401160323.4502.97507.stgit@shimauta>
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
References: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For most x86 linux kernel developers, change the asm syntax
to AT&T style as like as gas default.
This changes followings;
 - Move the last operand to the first
 - Remove pointer-size description (e.g. "DWORD PTR")
 - Change effective address expression
 - Add '%' prefix to registers
 - Add '$' prefix to non-address immediates
Note, this doesn't support operand-size suffix of mnemonics
as like as "movl" or "popd". Instead, this still shows the
registers with width prefixes like as "%eax", "%rdx" etc.
Also, this doesn't support '*' prefix which is for the
absolute jump address.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
---
 arch/x86/lib/disasm.c                    |  130 +++++++++---------------------
 arch/x86/tools/gen-insn-mnemonic-x86.awk |    5 +
 2 files changed, 41 insertions(+), 94 deletions(-)

diff --git a/arch/x86/lib/disasm.c b/arch/x86/lib/disasm.c
index 4abe844..fc5e493 100644
--- a/arch/x86/lib/disasm.c
+++ b/arch/x86/lib/disasm.c
@@ -125,35 +125,35 @@ static int bad_modrm_operand(char c, int mod)
 static int psnprint_gpr8(char **buf, size_t *len, int idx)
 {
 	if (idx < 8)
-		return psnprintf(buf, len, "%s", gpreg8_map[idx]);
+		return psnprintf(buf, len, "%%%s", gpreg8_map[idx]);
 	else if (16 < idx && idx < 24)
-		return psnprintf(buf, len, "%s", gpreg8_map2[idx - 16]);
+		return psnprintf(buf, len, "%%%s", gpreg8_map2[idx - 16]);
 	else
-		return psnprintf(buf, len, "r%dl", idx);
+		return psnprintf(buf, len, "%%r%dl", idx);
 }
 
 static int psnprint_gpr16(char **buf, size_t *len, int idx)
 {
 	if (idx < 8)
-		return psnprintf(buf, len, "%s", gpreg_map[idx]);
+		return psnprintf(buf, len, "%%%s", gpreg_map[idx]);
 	else
-		return psnprintf(buf, len, "r%dw", idx);
+		return psnprintf(buf, len, "%%r%dw", idx);
 }
 
 static int psnprint_gpr32(char **buf, size_t *len, int idx)
 {
 	if (idx < 8)
-		return psnprintf(buf, len, "e%s", gpreg_map[idx]);
+		return psnprintf(buf, len, "%%e%s", gpreg_map[idx]);
 	else
-		return psnprintf(buf, len, "r%dd", idx);
+		return psnprintf(buf, len, "%%r%dd", idx);
 }
 
 static int psnprint_gpr64(char **buf, size_t *len, int idx)
 {
 	if (idx < 8)
-		return psnprintf(buf, len, "r%s", gpreg_map[idx]);
+		return psnprintf(buf, len, "%%r%s", gpreg_map[idx]);
 	else
-		return psnprintf(buf, len, "r%d", idx);
+		return psnprintf(buf, len, "%%r%d", idx);
 }
 
 /* Disassemble GPR operands */
@@ -225,57 +225,7 @@ static int __disasm_gprea(char **buf, size_t *len, const char *opnd,
 	else if (insn->addr_bytes == 4)
 		return psnprint_gpr32(buf, len, idx);
 	else
-		return psnprintf(buf, len, "%s", gprea16_map[idx]);
-}
-
-static int get_operand_size(struct insn *insn, int type)
-{
-	int size = insn->opnd_bytes;
-
-	switch (type) {
-	case 'b':
-		size = 1;
-		break;
-	case 'w':
-		size = 2;
-		break;
-	case 'd':
-		size = 4;
-		break;
-	case 'q':
-		size = 8;
-		break;
-	case 'z':
-		if (size == 8)
-			size = 4;
-		break;
-	}
-	return size;
-}
-
-static int disasm_pointer(char **buf, size_t *len, const char *opnd,
-			  const char *end, struct insn *insn)
-{
-	const char *type = "(bad)";
-
-	if (insn->opcode.bytes[0] == X86_LEA_OPCODE)
-		return 0;
-
-	switch (get_operand_size(insn, opnd[1])) {
-	case 1:
-		type = "BYTE";
-		break;
-	case 2:
-		type = "WORD";
-		break;
-	case 4:
-		type = "DWORD";
-		break;
-	case 8:
-		type = "QWORD";
-		break;
-	}
-	return psnprintf(buf, len, "%s PTR ", type);
+		return psnprintf(buf, len, "%%%s", gprea16_map[idx]);
 }
 
 /* Disassemble a segment prefix */
@@ -292,7 +242,7 @@ static int __disasm_segment_prefix(char **buf, size_t *len,
 	}
 
 	attr = (attr & INAT_PFX_MASK) - INAT_SEGPFX_MIN;
-	return psnprintf(buf, len, "%s:", segreg_map[attr]);
+	return psnprintf(buf, len, "%%%s:", segreg_map[attr]);
 }
 
 static int disasm_segment_prefix(char **buf, size_t *len, struct insn *insn)
@@ -322,23 +272,22 @@ static int disasm_sib(char **buf, size_t *len, const char *opnd,
 		return disasm_displacement(buf, len, insn);
 
 	disasm_segment_prefix(buf, len, insn);
-	psnprintf(buf, len, "[");
+	if (mod != 0 || base == 5) {	/* With displacement offset */
+		if (insn->displacement.value < 0)
+			psnprintf(buf, len, "-0x%x", -insn->displacement.value);
+		else
+			psnprintf(buf, len, "0x%x", insn->displacement.value);
+	}
+	psnprintf(buf, len, "(");
 	if (mod != 0 || base != 5)	/* With base */
 		__disasm_gprea(buf, len, opnd, end, insn, base + rexb);
 
 	if (index != 4)	{	/* With scale * index */
-		if (mod != 0 || base != 5)
-			psnprintf(buf, len, "+");
+		psnprintf(buf, len, ",");
 		__disasm_gprea(buf, len, opnd, end, insn, index + rexx);
-		psnprintf(buf, len, "*%x", 1 << scale);
-	}
-	if (mod != 0 || base == 5) {	/* With displacement offset */
-		if (insn->displacement.value < 0)
-			psnprintf(buf, len, "-0x%x", -insn->displacement.value);
-		else
-			psnprintf(buf, len, "+0x%x", insn->displacement.value);
+		psnprintf(buf, len, ",%x", 1 << scale);
 	}
-	return psnprintf(buf, len, "]");
+	return psnprintf(buf, len, ")");
 }
 
 /* Disassemble memory-register from MODR/M */
@@ -355,30 +304,28 @@ static int disasm_modrm(char **buf, size_t *len, const char *opnd,
 		return disasm_rm_gpr(buf, len, opnd, end, insn);
 
 	/* Memory addressing */
-	disasm_pointer(buf, len, opnd, end, insn);
-
 	if (insn->sib.nbytes)	/* SIB addressing */
 		return disasm_sib(buf, len, opnd, end, insn);
 
 	if (mod == 0 && rm == 5) {	/* displacement only */
 		if (insn_rip_relative(insn))	/* RIP relative */
-			return psnprintf(buf, len, "[rip+0x%x]",
+			return psnprintf(buf, len, "0x%x(%rip)",
 					  insn->displacement.value);
 		else
 			return disasm_displacement(buf, len, insn);
 	} else {
 		disasm_segment_prefix(buf, len, insn);
-		psnprintf(buf, len, "[");
-		if (insn->rex_prefix.nbytes && X86_REX_B(insn->rex_prefix.bytes[0]))
-			rm += 8;
-		__disasm_gprea(buf, len, opnd, end, insn, rm);
 		if (mod != 0) {
 			if (insn->displacement.value < 0)
 				psnprintf(buf, len, "-0x%x", -insn->displacement.value);
 			else
-				psnprintf(buf, len, "+0x%x", insn->displacement.value);
+				psnprintf(buf, len, "0x%x", insn->displacement.value);
 		}
-		return psnprintf(buf, len, "]");
+		psnprintf(buf, len, "(");
+		if (insn->rex_prefix.nbytes && X86_REX_B(insn->rex_prefix.bytes[0]))
+			rm += 8;
+		__disasm_gprea(buf, len, opnd, end, insn, rm);
+		return psnprintf(buf, len, ")");
 	}
 }
 
@@ -416,13 +363,13 @@ static int disasm_immediate(char **buf, size_t *len, const char *opnd,
 		size = 1;
 	switch (size) {
 	case 8:
-		return psnprintf(buf, len, "0x%llx", imm);
+		return psnprintf(buf, len, "$0x%llx", imm);
 	case 4:
-		return psnprintf(buf, len, "0x%x", (unsigned int)imm);
+		return psnprintf(buf, len, "$0x%x", (unsigned int)imm);
 	case 2:
-		return psnprintf(buf, len, "0x%x", (unsigned short)imm);
+		return psnprintf(buf, len, "$0x%x", (unsigned short)imm);
 	default:
-		return psnprintf(buf, len, "0x%x", (unsigned char)imm);
+		return psnprintf(buf, len, "$0x%x", (unsigned char)imm);
 	}
 }
 
@@ -435,8 +382,7 @@ static int disasm_fixmem(char **buf, size_t *len, const char *opnd,
 	else if (insn->addr_bytes == 8)
 		pfx = "r";
 
-	disasm_pointer(buf, len, opnd, end, insn);
-	return psnprintf(buf, len, "%cs:[%s%ci]", *opnd == 'x' ? 'd' : 'e',
+	return psnprintf(buf, len, "%%%cs:(%%%s%ci)", *opnd == 'x' ? 'd' : 'e',
 			 pfx, *opnd == 'x' ? 's' : 'd');
 }
 
@@ -452,11 +398,11 @@ static int disasm_register(char **buf, size_t *len, const char *opnd,
 			else if (insn->opnd_bytes == 8)
 				pfx[0] = opnd[1];
 			opnd += 2;
-			return psnprintf(buf, len, "%s%.*s", pfx, end - opnd, opnd);
+			return psnprintf(buf, len, "%%%s%.*s", pfx, end - opnd, opnd);
 		} else
 			return disasm_opcode_gpr(buf, len, opnd, end, insn);
 	} else
-		return psnprintf(buf, len, "%.*s", end - opnd, opnd);
+		return psnprintf(buf, len, "%%%.*s", end - opnd, opnd);
 }
 
 /* Disassembe an operand */
@@ -473,13 +419,13 @@ static int disasm_operand(char **buf, size_t *len, const char *opnd,
 		return disasm_reg_gpr(buf, len, opnd, end, insn);
 	else if (operand_is_ctl_reg(opnd)) {
 		int idx = X86_MODRM_REG(insn->modrm.bytes[0]);
-		return psnprintf(buf, len, "cr%d", idx);
+		return psnprintf(buf, len, "%%cr%d", idx);
 	} else if (operand_is_dbg_reg(opnd)) {
 		int idx = X86_MODRM_REG(insn->modrm.bytes[0]);
-		return psnprintf(buf, len, "dr%d", idx);
+		return psnprintf(buf, len, "%%dr%d", idx);
 	} else if (operand_is_seg_reg(opnd)) {
 		int idx = X86_MODRM_REG(insn->modrm.bytes[0]);
-		return psnprintf(buf, len, "%s", segreg_map[idx]);
+		return psnprintf(buf, len, "%%%s", segreg_map[idx]);
 	} else if (operand_is_fixmem(opnd))
 		return disasm_fixmem(buf, len, opnd, end, insn);
 	else if (operand_is_flags(opnd))
diff --git a/arch/x86/tools/gen-insn-mnemonic-x86.awk b/arch/x86/tools/gen-insn-mnemonic-x86.awk
index 14fca68..f219af0 100644
--- a/arch/x86/tools/gen-insn-mnemonic-x86.awk
+++ b/arch/x86/tools/gen-insn-mnemonic-x86.awk
@@ -212,10 +212,11 @@ function get_operand(opnd,	i,count,f8,opnds) {
 			opnds[i] = "_" tolower(opnds[i])
 	}
 
-	for (i = 1; i <= count; i++) {
+	opnds[0] = opnds[count]
+	for (i = 0; i < count; i++) {
 		if (f8 == 1 && match(opnds[i],"Ib"))
 			opnds[i] = toupper(opnds[i])
-		if (i == 1)
+		if (i == 0)
 			opnd = opnds[i]
 		else
 			opnd = opnd "," opnds[i]

