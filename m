Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab2DAQEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:04:38 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:32815 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab2DAQEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:04:32 -0400
Subject: [RFC PATCH -tip 13/16] x86: Disassemble support in register dump
To: linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 02 Apr 2012 01:04:29 +0900
Message-ID: <20120401160429.4502.9283.stgit@shimauta>
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
References: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disassemble executed instructions as same as stackdump
when resisters are dumped. The disassemble will replace
the code dump and if the code is not in the kernel text,
it falls back the classic code dump.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
---
 arch/x86/kernel/dumpstack.c |   81 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 0d35e70..2966142 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -17,6 +17,8 @@
 #include <linux/sysfs.h>
 
 #include <asm/stacktrace.h>
+#include <asm/kprobes.h>
+#include <asm/disasm.h>
 
 
 int panic_on_unrecovered_nmi;
@@ -292,6 +294,81 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 	return 0;
 }
 
+#ifdef CONFIG_X86_DISASSEMBLER
+
+/* Find the instruction boundary address */
+static unsigned long find_instruction_boundary(unsigned long saddr,
+						unsigned long *poffs,
+						char **modname, char *namebuf)
+{
+	kprobe_opcode_t buf[MAX_INSN_SIZE];
+	unsigned long offs, addr, fixed;
+	struct insn insn;
+
+	/* find which function has given ip */
+	if (!kallsyms_lookup(saddr, NULL, &offs, modname, namebuf))
+		return 0;
+
+	addr = saddr - offs;	/* Function start address */
+	while (addr < saddr) {
+		fixed = recover_probed_instruction(buf, addr);
+		kernel_insn_init(&insn, (void *)fixed);
+		insn_get_length(&insn);
+		addr += insn.length;
+	}
+	if (poffs)
+		*poffs = offs;
+
+	return addr;
+}
+
+/* Disassemble between (ip - prologue) to (ip - prologue + length) */
+static int disassemble_code_dump(unsigned long ip, unsigned long prologue,
+				 unsigned long length)
+{
+	kprobe_opcode_t buf[MAX_INSN_SIZE];
+	unsigned long offs, addr, fixed;
+	unsigned long saddr = ip - prologue;
+	unsigned long eaddr = ip - prologue + length;
+	char buf[KSYM_NAME_LEN] = {0};
+	char *modname;
+
+	/* given address must be in text area */
+	if (!kernel_text_address(saddr) || !kernel_text_address(eaddr))
+		return -EINVAL;
+
+	addr = find_instruction_boundary(saddr, &offs, &modname, buf);
+	if (!addr)
+		return -EINVAL;
+
+	if (modname)
+		printk(KERN_CONT "\n<%s+0x%lx [%s]>:\n", buf,
+			addr - (ip - offs), modname);
+	else
+		printk(KERN_CONT "\n<%s+0x%lx>:\n", buf, addr - (ip - offs));
+
+	do {
+		if (addr == ip)
+			printk(KERN_CONT ">>");
+		fixed = recover_probed_instruction(buf, addr);
+		kernel_insn_init(&insn, (void *)fixed);
+		insn_get_length(&insn);
+		insn.kaddr = addr;
+		snprint_assembly(buf, sizeof(buf), &insn, DISASM_PR_ALL);
+		printk(KERN_CONT "%s", buf);
+		addr += insn.length;
+	} while (addr < eaddr);
+
+	return 0;
+}
+#else
+static int disassemble_code_dump(unsigned long ip, unsigned long prologue,
+				 unsigned long length)
+{
+	return -ENOTSUP;
+}
+#endif
+
 void __kprobes show_code_dump(struct pt_regs *regs)
 {
 	int i;
@@ -300,6 +377,10 @@ void __kprobes show_code_dump(struct pt_regs *regs)
 	unsigned char c;
 	u8 *ip;
 
+	/* try to disassemble code */
+	if (disassemble_code_dump(regs->ip, code_prologue, code_len) == 0)
+		return;
+
 	ip = (u8 *)regs->ip - code_prologue;
 	if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
 		/* try starting at IP */

