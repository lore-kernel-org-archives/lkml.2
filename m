Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab2DAQDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:03:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55546 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab2DAQDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:03:18 -0400
Subject: [RFC PATCH -tip 05/16] x86: Disassemble x86-64 only instructions
To: linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 02 Apr 2012 01:03:15 +0900
Message-ID: <20120401160315.4502.55715.stgit@shimauta>
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
References: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support x86-64 only instructions on disassembler.
For example, syscall and sysret.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
---
 arch/x86/lib/mnemonic.c                  |   23 +++++++++++++++++++++--
 arch/x86/tools/gen-insn-mnemonic-x86.awk |   11 +++++++++--
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/arch/x86/lib/mnemonic.c b/arch/x86/lib/mnemonic.c
index 0c375fb..dfd1aab 100644
--- a/arch/x86/lib/mnemonic.c
+++ b/arch/x86/lib/mnemonic.c
@@ -1,10 +1,29 @@
 #include <linux/kernel.h>
+#include <linux/string.h>
 #include <asm/insn.h>
 #include <asm/disasm.h>
 
 /* Define mnemonic lookup table */
 #include "mnemonic-tables.c"
 
+static const char *get_variant(const char *fmt, struct insn *insn)
+{
+	const char *p;
+
+	if (!fmt)
+		goto out;
+
+	if (insn->x86_64) {
+		p = strstr(fmt, "%6");
+		if (!p)
+			goto out;
+		fmt = strchr(p, ':') + 1;
+	} else if (strstr(fmt, "%6") == fmt)
+		fmt = NULL;
+out:
+	return fmt;
+}
+
 const char *get_mnemonic_format(struct insn *insn, const char **grp)
 {
 	insn_attr_t attr;
@@ -39,7 +58,7 @@ const char *get_mnemonic_format(struct insn *insn, const char **grp)
 				table = mnemonic_escape_tables[n][0];
 		}
 		if (table)
-			ret = table[idx];
+			ret = get_variant(table[idx], insn);
 
 		/* Solve groups */
 		if (grp && inat_is_group(attr)) {
@@ -51,7 +70,7 @@ const char *get_mnemonic_format(struct insn *insn, const char **grp)
 			else
 				table = mnemonic_group_tables[n][0];
 			idx = X86_MODRM_REG(idx);
-			*grp = table[idx];
+			*grp = get_variant(table[idx], insn);
 		}
 	}
 	return ret;
diff --git a/arch/x86/tools/gen-insn-mnemonic-x86.awk b/arch/x86/tools/gen-insn-mnemonic-x86.awk
index 2714f2f..14fca68 100644
--- a/arch/x86/tools/gen-insn-mnemonic-x86.awk
+++ b/arch/x86/tools/gen-insn-mnemonic-x86.awk
@@ -49,6 +49,7 @@ BEGIN {
 	regs_expr = "^[ABCDESR][0-9A-Z]"
 	vregs_expr = "^[re][0-9A-Z]"
 
+	only64_expr = "\\(o64\\)"
 	lprefix1_expr = "\\(66\\)"
 	lprefix2_expr = "\\(F3\\)"
 	lprefix3_expr = "\\(F2\\)"
@@ -254,6 +255,7 @@ function get_operand(opnd,	i,count,f8,opnds) {
 		ext = null
 		flags = null
 		opnd = null
+		pfx = ""
 		# parse one opcode
 		if (match($i, opnd_expr))
 			opnd = get_operand($(i++))
@@ -283,10 +285,15 @@ function get_operand(opnd,	i,count,f8,opnds) {
 			opcode = "call"
 		if (match(opcode, "^ret.*"))
 			opcode = "ret"
+
+		# additional flags
+		if (match(ext, only64_expr))
+			pfx = "%6:"
+
 		if (length(opnd) != 0)
-			flags = "\"" opcode " " opnd "\""
+			flags = "\"" pfx opcode " " opnd "\""
 		else
-			flags = "\"" opcode "\""
+			flags = "\"" pfx opcode "\""
 
 		if (length(flags) == 0)
 			continue

