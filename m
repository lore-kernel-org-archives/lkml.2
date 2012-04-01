Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2DAQEq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:04:46 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:32815 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab2DAQEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:04:41 -0400
Subject: [RFC PATCH -tip 14/16] x86: Indicate trapped address and probed
 address
To: linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 02 Apr 2012 01:04:37 +0900
Message-ID: <20120401160437.4502.78991.stgit@shimauta>
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
References: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show trapped address as a comment style on disassembled
code when kernel panicks.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
---
 arch/x86/kernel/dumpstack.c |   62 +++++++++++++++++++++++++++++++++----------
 1 files changed, 48 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 2966142..098e61a 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -322,22 +322,63 @@ static unsigned long find_instruction_boundary(unsigned long saddr,
 	return addr;
 }
 
+static int disasm_printk(unsigned long addr, unsigned long *next,
+			 unsigned long ip)
+{
+	char buf[DISASM_STR_LEN];
+	u8 kbuf[MAX_INSN_SIZE];
+	struct insn insn;
+	unsigned long fixed;
+	int i, ret;
+	u8 *v = (u8 *)addr;
+
+	/* recover if the instruction is probed */
+	fixed = recover_probed_instruction(kbuf, addr);
+	kernel_insn_init(&insn, (void *)fixed);
+	insn_get_length(&insn);
+	insn.kaddr = (void *)addr;
+
+	printk(KERN_CONT "%p: ", v);
+	for (i = 0; i < MAX_INSN_SIZE / 2 && i < insn.length; i++)
+		printk(KERN_CONT "%02x ", ((u8 *)v)[i]);
+	if (i != MAX_INSN_SIZE / 2)
+		printk(KERN_CONT "%*s", 3 * (MAX_INSN_SIZE / 2 - i), " ");
+
+	/* print assembly code */
+	ret = disassemble(buf, DISASM_STR_LEN, &insn);
+	if (ret < 0)
+		return ret;
+	printk(KERN_CONT "%s%s%s\n", (fixed != addr) ? "(probed)" : "", buf,
+		(addr == ip) ? "\t<-- trapping instruction" : "");
+
+	if (i < insn.length) {
+		printk(KERN_CONT "%p: ", v + i);
+		for (; i < insn.length - 1; i++)
+			printk(KERN_CONT "%02x ", ((u8 *)v)[i]);
+		printk(KERN_CONT "%02x\n", ((u8 *)v)[i]);
+	}
+
+	if (next)
+		*next = addr + insn.length;
+
+	return 0;
+}
+
 /* Disassemble between (ip - prologue) to (ip - prologue + length) */
 static int disassemble_code_dump(unsigned long ip, unsigned long prologue,
 				 unsigned long length)
 {
-	kprobe_opcode_t buf[MAX_INSN_SIZE];
-	unsigned long offs, addr, fixed;
-	unsigned long saddr = ip - prologue;
+	unsigned long offs;
+	unsigned long addr = ip - prologue;
 	unsigned long eaddr = ip - prologue + length;
 	char buf[KSYM_NAME_LEN] = {0};
 	char *modname;
 
 	/* given address must be in text area */
-	if (!kernel_text_address(saddr) || !kernel_text_address(eaddr))
+	if (!kernel_text_address(addr) || !kernel_text_address(eaddr))
 		return -EINVAL;
 
-	addr = find_instruction_boundary(saddr, &offs, &modname, buf);
+	addr = find_instruction_boundary(addr, &offs, &modname, buf);
 	if (!addr)
 		return -EINVAL;
 
@@ -348,15 +389,8 @@ static int disassemble_code_dump(unsigned long ip, unsigned long prologue,
 		printk(KERN_CONT "\n<%s+0x%lx>:\n", buf, addr - (ip - offs));
 
 	do {
-		if (addr == ip)
-			printk(KERN_CONT ">>");
-		fixed = recover_probed_instruction(buf, addr);
-		kernel_insn_init(&insn, (void *)fixed);
-		insn_get_length(&insn);
-		insn.kaddr = addr;
-		snprint_assembly(buf, sizeof(buf), &insn, DISASM_PR_ALL);
-		printk(KERN_CONT "%s", buf);
-		addr += insn.length;
+		if (disasm_printk(addr, &addr, ip) < 0)
+			break;
 	} while (addr < eaddr);
 
 	return 0;

