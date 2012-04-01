Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab2DAQCr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:02:47 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:37898 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab2DAQCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:02:43 -0400
Subject: [RFC PATCH -tip 01/16] x86: Split default64 flag from force64 flag
To: linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 02 Apr 2012 01:02:38 +0900
Message-ID: <20120401160238.4502.96019.stgit@shimauta>
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
References: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since current x86 instruction decoder treats default 64 bit
instructions as same as force 64 bit one, eventually the
decoder says the operand size is always 8 on those
instructions.
However, in real, when thoes have an operand-size prefix,
its operand size should be 2.
So this fixes that to split default64 from force64.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
---
 arch/x86/include/asm/inat.h          |   18 ++++++++++++------
 arch/x86/include/asm/insn.h          |    2 ++
 arch/x86/lib/insn.c                  |    2 ++
 arch/x86/tools/gen-insn-attr-x86.awk |    7 +++++--
 4 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/inat.h b/arch/x86/include/asm/inat.h
index 74a2e31..55e438b 100644
--- a/arch/x86/include/asm/inat.h
+++ b/arch/x86/include/asm/inat.h
@@ -83,12 +83,13 @@
 /* Flags */
 #define INAT_FLAG_OFFS	(INAT_IMM_OFFS + INAT_IMM_BITS)
 #define INAT_MODRM	(1 << (INAT_FLAG_OFFS))
-#define INAT_FORCE64	(1 << (INAT_FLAG_OFFS + 1))
-#define INAT_SCNDIMM	(1 << (INAT_FLAG_OFFS + 2))
-#define INAT_MOFFSET	(1 << (INAT_FLAG_OFFS + 3))
-#define INAT_VARIANT	(1 << (INAT_FLAG_OFFS + 4))
-#define INAT_VEXOK	(1 << (INAT_FLAG_OFFS + 5))
-#define INAT_VEXONLY	(1 << (INAT_FLAG_OFFS + 6))
+#define INAT_DEFAULT64	(1 << (INAT_FLAG_OFFS + 1))
+#define INAT_FORCE64	(1 << (INAT_FLAG_OFFS + 2))
+#define INAT_SCNDIMM	(1 << (INAT_FLAG_OFFS + 3))
+#define INAT_MOFFSET	(1 << (INAT_FLAG_OFFS + 4))
+#define INAT_VARIANT	(1 << (INAT_FLAG_OFFS + 5))
+#define INAT_VEXOK	(1 << (INAT_FLAG_OFFS + 6))
+#define INAT_VEXONLY	(1 << (INAT_FLAG_OFFS + 7))
 /* Attribute making macros for attribute tables */
 #define INAT_MAKE_PREFIX(pfx)	(pfx << INAT_PFX_OFFS)
 #define INAT_MAKE_ESCAPE(esc)	(esc << INAT_ESC_OFFS)
@@ -194,6 +195,11 @@ static inline int inat_is_force64(insn_attr_t attr)
 	return attr & INAT_FORCE64;
 }
 
+static inline int inat_is_default64(insn_attr_t attr)
+{
+	return attr & INAT_DEFAULT64;
+}
+
 static inline int inat_has_second_immediate(insn_attr_t attr)
 {
 	return attr & INAT_SCNDIMM;
diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 48eb30a..34aecec 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -83,6 +83,8 @@ struct insn {
 #define X86_REX_X(rex) ((rex) & 2)
 #define X86_REX_B(rex) ((rex) & 1)
 
+#define X86_OPCODE_GPR(opcode) ((opcode) & 0x07)
+
 /* VEX bit flags  */
 #define X86_VEX_W(vex)	((vex) & 0x80)	/* VEX3 Byte2 */
 #define X86_VEX_R(vex)	((vex) & 0x80)	/* VEX2/3 Byte1 */
diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 25feb1a..e34829a 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -257,6 +257,8 @@ void insn_get_modrm(struct insn *insn)
 
 	if (insn->x86_64 && inat_is_force64(insn->attr))
 		insn->opnd_bytes = 8;
+	if (insn->x86_64 && inat_is_default64(insn->attr) && insn->opnd_bytes == 4)
+		insn->opnd_bytes = 8;
 	modrm->got = 1;
 
 err_out:
diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index 5f6a5b6..76d8889 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -62,7 +62,8 @@ BEGIN {
 	imm_flag["Lx"] = "INAT_MAKE_IMM(INAT_IMM_BYTE)"
 
 	modrm_expr = "^([CDEGMNPQRSUVW/][a-z]+|NTA|T[012])"
-	force64_expr = "\\([df]64\\)"
+	force64_expr = "\\(f64\\)"
+	def64_expr = "\\(d64\\)"
 	rex_expr = "^REX(\\.[XRWB]+)*"
 	fpu_expr = "^ESC" # TODO
 
@@ -303,9 +304,11 @@ function convert_operands(count,opnd,       i,j,imm,mod)
 			}
 			flags = add_flags(flags, "INAT_MAKE_GROUP(" group[opcode] ")")
 		}
-		# check force(or default) 64bit
+		# check force or default 64bit
 		if (match(ext, force64_expr))
 			flags = add_flags(flags, "INAT_FORCE64")
+		if (match(ext, def64_expr))
+			flags = add_flags(flags, "INAT_DEFAULT64")
 
 		# check REX prefix
 		if (match(opcode, rex_expr))

