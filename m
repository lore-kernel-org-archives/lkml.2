Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab2DAQD6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:03:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55546 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab2DAQDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:03:54 -0400
Subject: [RFC PATCH -tip 09/16] x86: kernel function disassembly interface
To: linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 02 Apr 2012 01:03:50 +0900
Message-ID: <20120401160350.4502.57559.stgit@shimauta>
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
References: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a debugfs interface for disassembling kernel functions
as /sys/kernel/debug/x86/disassembly.
To disassemble a kernel function, at first write a symbol
name into above file, as below;
 # echo sys_symlink > /sys/kernel/debug/x86/disassembly
And then, it shows the assembly code of that function.
 # cat /sys/kernel/debug/x86/disassembly
<sys_symlink>:
ffffffff81169f90: 55                      push   %rbp
ffffffff81169f91: 48 89 e5                mov    %rsp,%rbp
ffffffff81169f94: 66 66 66 66 90          nop
ffffffff81169f99: 48 89 f2                mov    %rsi,%rdx
ffffffff81169f9c: be 9c ff ff ff          mov    $0xffffff9c,%esi
...

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
---
 arch/x86/Kconfig.debug         |    7 ++
 arch/x86/include/asm/kprobes.h |    2 +
 arch/x86/kernel/kdebugfs.c     |  140 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 149 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index ae64888..5f51e05 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -181,6 +181,13 @@ config X86_DISASSEMBLER
 	 kernel panic.
 	 If unsure, say "Y" here, since this will help you to report bugs.
 
+config DEBUG_X86_DISASSEMBLY
+	bool "x86 instruction disassembly interface on debugfs"
+	depends on X86_DISASSEMBLER && DEBUG_FS
+	---help---
+	 This option adds /sys/kernel/debug/x86/disassembly interface
+	 for disassembling a kernel function.
+
 #
 # IO delay types:
 #
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 5478825..9fc372b 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -114,4 +114,6 @@ struct kprobe_ctlblk {
 extern int kprobe_fault_handler(struct pt_regs *regs, int trapnr);
 extern int kprobe_exceptions_notify(struct notifier_block *self,
 				    unsigned long val, void *data);
+extern unsigned long recover_probed_instruction(kprobe_opcode_t *buf,
+						unsigned long addr);
 #endif /* _ASM_X86_KPROBES_H */
diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index 90fcf62..5da917d 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -14,8 +14,12 @@
 #include <linux/stat.h>
 #include <linux/io.h>
 #include <linux/mm.h>
+#include <linux/kallsyms.h>
+#include <linux/kprobes.h>
+#include <linux/ctype.h>
 
 #include <asm/setup.h>
+#include <asm/disasm.h>
 
 struct dentry *arch_debugfs_dir;
 EXPORT_SYMBOL(arch_debugfs_dir);
@@ -202,6 +206,137 @@ err_dir:
 }
 #endif /* CONFIG_DEBUG_BOOT_PARAMS */
 
+#ifdef CONFIG_DEBUG_X86_DISASSEMBLY
+static DEFINE_MUTEX(disasm_lock);
+static char disasm_funcname[KSYM_NAME_LEN];
+static unsigned long disasm_addr;
+static unsigned long disasm_size;
+static void *disasm_pos;
+
+static ssize_t disasm_write(struct file *file, const char __user *buffer,
+			    size_t count, loff_t *ppos)
+{
+	ssize_t ret = count;
+	char *c;
+
+	if (count >= KSYM_NAME_LEN)
+		return -E2BIG;
+
+	mutex_lock(&disasm_lock);
+	if (copy_from_user(disasm_funcname, buffer, count)) {
+		ret = -EFAULT;
+		goto end;
+	}
+
+	disasm_funcname[count] = '\0';
+	c = strchr(disasm_funcname, '\n');
+	if (c)
+		*c = '\0';
+
+	disasm_addr = (unsigned long)kallsyms_lookup_name(disasm_funcname);
+	if (!disasm_addr)
+		ret = -EINVAL;
+end:
+	mutex_unlock(&disasm_lock);
+
+	return ret;
+}
+
+static void *disasm_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct insn insn;
+	char kbuf[MAX_INSN_SIZE];
+	void *p;
+
+	if (!v)
+		return NULL;
+
+	p = (void *)recover_probed_instruction(kbuf, (unsigned long)v);
+	kernel_insn_init(&insn, p);
+	insn_get_length(&insn);
+	v += insn.length;
+
+	if ((unsigned long)v >= disasm_addr + disasm_size)
+		return NULL;
+	return v;
+}
+
+static void *disasm_seq_start(struct seq_file *m, loff_t *pos)
+{
+	unsigned long offs;
+	const char *name;
+
+	mutex_lock(&disasm_lock);
+	if (!disasm_addr)
+		return NULL;
+
+	if (*pos == 0) {
+		name = kallsyms_lookup(disasm_addr, &disasm_size, &offs, NULL,
+					disasm_funcname);
+		if (!name || offs != 0)
+			return NULL;
+
+		seq_printf(m, "<%s>:\n", name);
+		return (void *)disasm_addr;
+	} else
+		return disasm_seq_next(m, disasm_pos, pos);
+}
+
+static void disasm_seq_stop(struct seq_file *m, void *v)
+{
+	disasm_pos = v;
+	mutex_unlock(&disasm_lock);
+}
+
+#define DISASM_BUF_LEN	150
+
+static int disasm_seq_show(struct seq_file *m, void *v)
+{
+	char buf[DISASM_BUF_LEN];
+	u8 kbuf[MAX_INSN_SIZE];
+	struct insn insn;
+	void *p;
+
+	p = (void *)recover_probed_instruction(kbuf, (unsigned long)v);
+	kernel_insn_init(&insn, p);
+	insn_get_length(&insn);
+	insn.kaddr = v;
+	snprint_assembly(buf, DISASM_BUF_LEN, &insn, DISASM_PR_ALL);
+	seq_printf(m, "%s", buf);
+
+	return 0;
+}
+
+static const struct seq_operations disasm_seq_ops = {
+	.start	= disasm_seq_start,
+	.next	= disasm_seq_next,
+	.stop	= disasm_seq_stop,
+	.show	= disasm_seq_show,
+};
+
+static int disasm_open(struct inode *inode, struct file *file)
+{
+	/* Currently we just ignore O_APPEND */
+	return seq_open(file, &disasm_seq_ops);
+}
+
+static const struct file_operations disasm_fops = {
+	.open		= disasm_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+	.write		= disasm_write,
+};
+
+static int __init disassembly_kdebugfs_init(void)
+{
+	debugfs_create_file("disassembly", S_IRUSR | S_IWUSR,
+		 arch_debugfs_dir, NULL, &disasm_fops);
+	return 0;
+}
+
+#endif /* CONFIG_DEBUG_X86_DISASSEMBLY */
+
 static int __init arch_kdebugfs_init(void)
 {
 	int error = 0;
@@ -210,6 +345,11 @@ static int __init arch_kdebugfs_init(void)
 	if (!arch_debugfs_dir)
 		return -ENOMEM;
 
+#ifdef CONFIG_DEBUG_X86_DISASSEMBLY
+	error = disassembly_kdebugfs_init();
+	if (error)
+		return error;
+#endif
 #ifdef CONFIG_DEBUG_BOOT_PARAMS
 	error = boot_params_kdebugfs_init();
 #endif

