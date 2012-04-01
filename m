Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2DAQDQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:03:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55546 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2DAQDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:03:09 -0400
Subject: [RFC PATCH -tip 04/16] x86: Show kernel symbol in disassembler
To: linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 02 Apr 2012 01:03:06 +0900
Message-ID: <20120401160306.4502.25323.stgit@shimauta>
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
References: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show kernel symbol if the immediate value of disassembling
instruction is the destination of jump or call.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
---
 arch/x86/lib/disasm.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/disasm.c b/arch/x86/lib/disasm.c
index 473ae52..4abe844 100644
--- a/arch/x86/lib/disasm.c
+++ b/arch/x86/lib/disasm.c
@@ -7,6 +7,8 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/errno.h>
+#include <linux/kallsyms.h>
+
 #include <asm/disasm.h>
 
 #define X86_LEA_OPCODE 0x8d
@@ -28,6 +30,27 @@ static int psnprintf(char **buf, size_t *len, const char *fmt, ...)
 	return ret;
 }
 
+/* Print address with symbol */
+static int psnprint_symbol(char **buf, size_t *len, unsigned long addr)
+{
+	unsigned long offs;
+	char func[KSYM_NAME_LEN];
+	char *modname;
+	int ret;
+
+	ret = psnprintf(buf, len, "%lx", addr);
+	if (!kallsyms_lookup(addr, NULL, &offs, &modname, func))
+		return ret;
+
+	psnprintf(buf, len, " <%s", func);
+	if (offs)
+		psnprintf(buf, len, "+0x%lx", offs);
+	if (modname)
+		psnprintf(buf, len, " [%s]", modname);
+
+	return psnprintf(buf, len, ">");
+}
+
 /* Operand classifiers */
 static bool operand_is_register(const char *p)
 {
@@ -385,7 +408,7 @@ static int disasm_immediate(char **buf, size_t *len, const char *opnd,
 	if (opnd[0] == 'J' || opnd[0] == 'A') {
 		if (opnd[0] == 'J') /* Relative from IP */
 			imm += (long)insn->kaddr + insn->length;
-		return psnprintf(buf, len, "%lx", (unsigned long)imm);
+		return psnprint_symbol(buf, len, (unsigned long)imm);
 	}
 
 	size = insn->opnd_bytes;

