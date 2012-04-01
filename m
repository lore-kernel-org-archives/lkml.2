Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab2DAQFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:05:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46444 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab2DAQFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:05:03 -0400
Subject: [RFC PATCH -tip 15/16] x86/kdb: Add x86 disassembe command
To: linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 02 Apr 2012 01:04:46 +0900
Message-ID: <20120401160446.4502.35872.stgit@shimauta>
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
References: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a simple 'dis' command for x86 on KDB.
This command takes 2 arguments, the first one is the address
and the second one is the length of disassembling bytes.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
---
 arch/x86/kernel/dumpstack.c |    6 ++--
 arch/x86/kernel/kgdb.c      |   72 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/kdb.h         |    3 ++
 kernel/debug/kdb/kdb_main.c |   35 +++++++++++++++++++++
 4 files changed, 113 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 098e61a..1441efc 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -297,9 +297,9 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 #ifdef CONFIG_X86_DISASSEMBLER
 
 /* Find the instruction boundary address */
-static unsigned long find_instruction_boundary(unsigned long saddr,
-						unsigned long *poffs,
-						char **modname, char *namebuf)
+unsigned long find_instruction_boundary(unsigned long saddr,
+					unsigned long *poffs,
+					char **modname, char *namebuf)
 {
 	kprobe_opcode_t buf[MAX_INSN_SIZE];
 	unsigned long offs, addr, fixed;
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index db6720e..0215a67 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -39,13 +39,17 @@
 #include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/kgdb.h>
+#include <linux/kdb.h>
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/nmi.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/kallsyms.h>
+#include <linux/kprobes.h>
 
 #include <asm/debugreg.h>
 #include <asm/apicdef.h>
+#include <asm/disasm.h>
 #include <asm/apic.h>
 #include <asm/nmi.h>
 
@@ -751,3 +755,71 @@ struct kgdb_arch arch_kgdb_ops = {
 	.remove_all_hw_break	= kgdb_remove_all_hw_break,
 	.correct_hw_break	= kgdb_correct_hw_break,
 };
+
+#if defined(CONFIG_X86_DISASSEMBLER)
+extern unsigned long find_instruction_boundary(unsigned long addr,
+						unsigned long *poffs,
+						char **modname, char *namebuf);
+
+static int kdb_disasm_printk(unsigned long addr, unsigned long *next)
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
+	kdb_printf("%p: ", v);
+	for (i = 0; i < MAX_INSN_SIZE / 2 && i < insn.length; i++)
+		kdb_printf("%02x ", ((u8 *)v)[i]);
+	if (i != MAX_INSN_SIZE / 2)
+		kdb_printf("%*s", 3 * (MAX_INSN_SIZE / 2 - i), " ");
+
+	/* print assembly code */
+	ret = disassemble(buf, DISASM_STR_LEN, &insn);
+	if (ret < 0)
+		return ret;
+	kdb_printf("%s%s\n", (fixed != addr) ? "(probed)" : "", buf);
+
+	if (i < insn.length) {
+		kdb_printf("%p: ", v + i);
+		for (; i < insn.length - 1; i++)
+			kdb_printf("%02x ", ((u8 *)v)[i]);
+		kdb_printf("%02x\n", ((u8 *)v)[i]);
+	}
+
+	if (next)
+		*next = addr + insn.length;
+
+	return 0;
+}
+
+int kdb_show_disasm(unsigned long addr, size_t len)
+{
+	unsigned long offs, eaddr = addr + len;
+	char buf[KSYM_NAME_LEN] = {0};
+	char *modname;
+
+	addr = find_instruction_boundary(addr, &offs, &modname, buf);
+	if (!addr)
+		return KDB_BADADDR;
+
+	if (modname)
+		kdb_printf("<%s+0x%lx [%s]>:\n", buf, offs, modname);
+	else
+		kdb_printf("<%s+0x%lx>:\n", buf, offs);
+
+	do {
+		kdb_disasm_printk(addr, &addr);
+	} while (addr < eaddr);
+
+	return 0;
+}
+#endif
diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 0647258..ff4b765 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -166,4 +166,7 @@ enum {
 extern int kdbgetintenv(const char *, int *);
 extern int kdb_set(int, const char **);
 
+/* Some architectures support disassembling in kernel */
+extern int kdb_show_disasm(unsigned long addr, size_t len);
+
 #endif	/* !_KDB_H */
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 67b847d..f09aca4 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2672,6 +2672,39 @@ static int kdb_per_cpu(int argc, const char **argv)
 	return 0;
 }
 
+int __weak kdb_show_disasm(unsigned long addr, size_t len)
+{
+	return KDB_NOTIMP;
+}
+
+/*
+ * kdb_dis - This function implements the 'dis' command.
+ */
+static int kdb_dis(int argc, const char **argv)
+{
+	int diag;
+	unsigned long addr;
+	long offset;
+	int nextarg;
+	unsigned long len;
+
+	if (argc > 3)
+		return KDB_ARGCOUNT;
+
+	nextarg = 1;
+	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
+	if (diag)
+		return diag;
+
+	if (argc == 2) {
+		if (kstrtoul(argv[2], 0, &len) < 0)
+			return KDB_BADINT;
+	} else
+		len = 0;
+
+	return kdb_show_disasm(addr + offset, (size_t)len);
+}
+
 /*
  * display help for the use of cmd | grep pattern
  */
@@ -2899,6 +2932,8 @@ static void __init kdb_inittab(void)
 	  "Display per_cpu variables", 3, KDB_REPEAT_NONE);
 	kdb_register_repeat("grephelp", kdb_grep_help, "",
 	  "Display help on | grep", 0, KDB_REPEAT_NONE);
+	kdb_register_repeat("dis", kdb_dis, "<addr> [<len>]",
+	  "Display disassmbled code", 2, KDB_REPEAT_NONE);
 }
 
 /* Execute any commands defined in kdb_cmds.  */

