Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756Ab2DZTo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 15:44:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56652 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758652Ab2DZToY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 15:44:24 -0400
Date: Thu, 26 Apr 2012 12:43:57 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-d7d7199002115b26687d6b78b380bb9fb9e53254@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de
In-Reply-To: <20120426173717.060120642@goodmis.org>
References: <20120426173717.060120642@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/ftrace] ftrace, x86:
  Have arch x86_64 use breakpoints instead of stop machine
Git-Commit-ID: d7d7199002115b26687d6b78b380bb9fb9e53254
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Apr 2012 12:44:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7d7199002115b26687d6b78b380bb9fb9e53254
Gitweb:     http://git.kernel.org/tip/d7d7199002115b26687d6b78b380bb9fb9e53254
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Thu, 26 Apr 2012 13:34:05 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 26 Apr 2012 11:22:20 -0700

ftrace, x86: Have arch x86_64 use breakpoints instead of stop machine

This method changes x86 to add a breakpoint to the mcount locations
instead of calling stop machine.

Now that iret can be handled by NMIs, we perform the following to
update code:

1) Add a breakpoint to all locations that will be modified

2) Sync all cores

3) Update all locations to be either a nop or call (except breakpoint
   op)

4) Sync all cores

5) Remove the breakpoint with the new code.

6) Sync all cores

[
  Added updates that Masami suggested:
   Use unlikely(modifying_ftrace_code) in int3 trap to keep kprobes efficient.
   Don't use NOTIFY_* in ftrace handler in int3 as it is not a notifier.
]

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20120426173717.060120642@goodmis.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/ftrace.h |    3 +
 arch/x86/kernel/ftrace.c      |  342 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps.c       |    8 +-
 include/linux/ftrace.h        |    6 +
 4 files changed, 358 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 268c783..18d9005 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -34,6 +34,7 @@
 
 #ifndef __ASSEMBLY__
 extern void mcount(void);
+extern int modifying_ftrace_code;
 
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
@@ -50,6 +51,8 @@ struct dyn_arch_ftrace {
 	/* No extra data needed for x86 */
 };
 
+int ftrace_int3_handler(struct pt_regs *regs);
+
 #endif /*  CONFIG_DYNAMIC_FTRACE */
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index c9a281f..80af347 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/kprobes.h>
 
 #include <trace/syscall.h>
 
@@ -334,6 +335,347 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ret;
 }
 
+int modifying_ftrace_code __read_mostly;
+
+/*
+ * A breakpoint was added to the code address we are about to
+ * modify, and this is the handle that will just skip over it.
+ * We are either changing a nop into a trace call, or a trace
+ * call to a nop. While the change is taking place, we treat
+ * it just like it was a nop.
+ */
+int ftrace_int3_handler(struct pt_regs *regs)
+{
+	if (WARN_ON_ONCE(!regs))
+		return 0;
+
+	if (!ftrace_location(regs->ip - 1))
+		return 0;
+
+	regs->ip += MCOUNT_INSN_SIZE - 1;
+
+	return 1;
+}
+
+static int ftrace_write(unsigned long ip, const char *val, int size)
+{
+	/*
+	 * On x86_64, kernel text mappings are mapped read-only with
+	 * CONFIG_DEBUG_RODATA. So we use the kernel identity mapping instead
+	 * of the kernel text mapping to modify the kernel text.
+	 *
+	 * For 32bit kernels, these mappings are same and we can use
+	 * kernel identity mapping to modify code.
+	 */
+	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
+		ip = (unsigned long)__va(__pa(ip));
+
+	return probe_kernel_write((void *)ip, val, size);
+}
+
+static int add_break(unsigned long ip, const char *old)
+{
+	unsigned char replaced[MCOUNT_INSN_SIZE];
+	unsigned char brk = BREAKPOINT_INSTRUCTION;
+
+	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+	/* Make sure it is what we expect it to be */
+	if (memcmp(replaced, old, MCOUNT_INSN_SIZE) != 0)
+		return -EINVAL;
+
+	if (ftrace_write(ip, &brk, 1))
+		return -EPERM;
+
+	return 0;
+}
+
+static int add_brk_on_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned const char *old;
+	unsigned long ip = rec->ip;
+
+	old = ftrace_call_replace(ip, addr);
+
+	return add_break(rec->ip, old);
+}
+
+
+static int add_brk_on_nop(struct dyn_ftrace *rec)
+{
+	unsigned const char *old;
+
+	old = ftrace_nop_replace();
+
+	return add_break(rec->ip, old);
+}
+
+static int add_breakpoints(struct dyn_ftrace *rec, int enable)
+{
+	unsigned long ftrace_addr;
+	int ret;
+
+	ret = ftrace_test_record(rec, enable);
+
+	ftrace_addr = (unsigned long)FTRACE_ADDR;
+
+	switch (ret) {
+	case FTRACE_UPDATE_IGNORE:
+		return 0;
+
+	case FTRACE_UPDATE_MAKE_CALL:
+		/* converting nop to call */
+		return add_brk_on_nop(rec);
+
+	case FTRACE_UPDATE_MAKE_NOP:
+		/* converting a call to a nop */
+		return add_brk_on_call(rec, ftrace_addr);
+	}
+	return 0;
+}
+
+/*
+ * On error, we need to remove breakpoints. This needs to
+ * be done caefully. If the address does not currently have a
+ * breakpoint, we know we are done. Otherwise, we look at the
+ * remaining 4 bytes of the instruction. If it matches a nop
+ * we replace the breakpoint with the nop. Otherwise we replace
+ * it with the call instruction.
+ */
+static int remove_breakpoint(struct dyn_ftrace *rec)
+{
+	unsigned char ins[MCOUNT_INSN_SIZE];
+	unsigned char brk = BREAKPOINT_INSTRUCTION;
+	const unsigned char *nop;
+	unsigned long ftrace_addr;
+	unsigned long ip = rec->ip;
+
+	/* If we fail the read, just give up */
+	if (probe_kernel_read(ins, (void *)ip, MCOUNT_INSN_SIZE))
+		return -EFAULT;
+
+	/* If this does not have a breakpoint, we are done */
+	if (ins[0] != brk)
+		return -1;
+
+	nop = ftrace_nop_replace();
+
+	/*
+	 * If the last 4 bytes of the instruction do not match
+	 * a nop, then we assume that this is a call to ftrace_addr.
+	 */
+	if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) != 0) {
+		/*
+		 * For extra paranoidism, we check if the breakpoint is on
+		 * a call that would actually jump to the ftrace_addr.
+		 * If not, don't touch the breakpoint, we make just create
+		 * a disaster.
+		 */
+		ftrace_addr = (unsigned long)FTRACE_ADDR;
+		nop = ftrace_call_replace(ip, ftrace_addr);
+
+		if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) != 0)
+			return -EINVAL;
+	}
+
+	return probe_kernel_write((void *)ip, &nop[0], 1);
+}
+
+static int add_update_code(unsigned long ip, unsigned const char *new)
+{
+	/* skip breakpoint */
+	ip++;
+	new++;
+	if (ftrace_write(ip, new, MCOUNT_INSN_SIZE - 1))
+		return -EPERM;
+	return 0;
+}
+
+static int add_update_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned long ip = rec->ip;
+	unsigned const char *new;
+
+	new = ftrace_call_replace(ip, addr);
+	return add_update_code(ip, new);
+}
+
+static int add_update_nop(struct dyn_ftrace *rec)
+{
+	unsigned long ip = rec->ip;
+	unsigned const char *new;
+
+	new = ftrace_nop_replace();
+	return add_update_code(ip, new);
+}
+
+static int add_update(struct dyn_ftrace *rec, int enable)
+{
+	unsigned long ftrace_addr;
+	int ret;
+
+	ret = ftrace_test_record(rec, enable);
+
+	ftrace_addr = (unsigned long)FTRACE_ADDR;
+
+	switch (ret) {
+	case FTRACE_UPDATE_IGNORE:
+		return 0;
+
+	case FTRACE_UPDATE_MAKE_CALL:
+		/* converting nop to call */
+		return add_update_call(rec, ftrace_addr);
+
+	case FTRACE_UPDATE_MAKE_NOP:
+		/* converting a call to a nop */
+		return add_update_nop(rec);
+	}
+
+	return 0;
+}
+
+static int finish_update_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned long ip = rec->ip;
+	unsigned const char *new;
+
+	new = ftrace_call_replace(ip, addr);
+
+	if (ftrace_write(ip, new, 1))
+		return -EPERM;
+
+	return 0;
+}
+
+static int finish_update_nop(struct dyn_ftrace *rec)
+{
+	unsigned long ip = rec->ip;
+	unsigned const char *new;
+
+	new = ftrace_nop_replace();
+
+	if (ftrace_write(ip, new, 1))
+		return -EPERM;
+	return 0;
+}
+
+static int finish_update(struct dyn_ftrace *rec, int enable)
+{
+	unsigned long ftrace_addr;
+	int ret;
+
+	ret = ftrace_update_record(rec, enable);
+
+	ftrace_addr = (unsigned long)FTRACE_ADDR;
+
+	switch (ret) {
+	case FTRACE_UPDATE_IGNORE:
+		return 0;
+
+	case FTRACE_UPDATE_MAKE_CALL:
+		/* converting nop to call */
+		return finish_update_call(rec, ftrace_addr);
+
+	case FTRACE_UPDATE_MAKE_NOP:
+		/* converting a call to a nop */
+		return finish_update_nop(rec);
+	}
+
+	return 0;
+}
+
+static void do_sync_core(void *data)
+{
+	sync_core();
+}
+
+static void run_sync(void)
+{
+	int enable_irqs = irqs_disabled();
+
+	/* We may be called with interrupts disbled (on bootup). */
+	if (enable_irqs)
+		local_irq_enable();
+	on_each_cpu(do_sync_core, NULL, 1);
+	if (enable_irqs)
+		local_irq_disable();
+}
+
+static void ftrace_replace_code(int enable)
+{
+	struct ftrace_rec_iter *iter;
+	struct dyn_ftrace *rec;
+	const char *report = "adding breakpoints";
+	int count = 0;
+	int ret;
+
+	for_ftrace_rec_iter(iter) {
+		rec = ftrace_rec_iter_record(iter);
+
+		ret = add_breakpoints(rec, enable);
+		if (ret)
+			goto remove_breakpoints;
+		count++;
+	}
+
+	run_sync();
+
+	report = "updating code";
+
+	for_ftrace_rec_iter(iter) {
+		rec = ftrace_rec_iter_record(iter);
+
+		ret = add_update(rec, enable);
+		if (ret)
+			goto remove_breakpoints;
+	}
+
+	run_sync();
+
+	report = "removing breakpoints";
+
+	for_ftrace_rec_iter(iter) {
+		rec = ftrace_rec_iter_record(iter);
+
+		ret = finish_update(rec, enable);
+		if (ret)
+			goto remove_breakpoints;
+	}
+
+	run_sync();
+
+	return;
+
+ remove_breakpoints:
+	ftrace_bug(ret, rec ? rec->ip : 0);
+	printk(KERN_WARNING "Failed on %s (%d):\n", report, count);
+	for_ftrace_rec_iter(iter) {
+		rec = ftrace_rec_iter_record(iter);
+		remove_breakpoint(rec);
+	}
+}
+
+void arch_ftrace_update_code(int command)
+{
+	modifying_ftrace_code++;
+
+	if (command & FTRACE_UPDATE_CALLS)
+		ftrace_replace_code(1);
+	else if (command & FTRACE_DISABLE_CALLS)
+		ftrace_replace_code(0);
+
+	if (command & FTRACE_UPDATE_TRACE_FUNC)
+		ftrace_update_ftrace_func(ftrace_trace_function);
+
+	if (command & FTRACE_START_FUNC_RET)
+		ftrace_enable_ftrace_graph_caller();
+	else if (command & FTRACE_STOP_FUNC_RET)
+		ftrace_disable_ftrace_graph_caller();
+
+	modifying_ftrace_code--;
+}
+
 int __init ftrace_dyn_arch_init(void *data)
 {
 	/* The return code is retured via data */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ff9281f1..92d5756 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -50,6 +50,7 @@
 #include <asm/processor.h>
 #include <asm/debugreg.h>
 #include <linux/atomic.h>
+#include <asm/ftrace.h>
 #include <asm/traps.h>
 #include <asm/desc.h>
 #include <asm/i387.h>
@@ -303,8 +304,13 @@ gp_in_kernel:
 }
 
 /* May run on IST stack. */
-dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
+dotraplinkage void __kprobes notrace do_int3(struct pt_regs *regs, long error_code)
 {
+#ifdef CONFIG_DYNAMIC_FTRACE
+	/* ftrace must be first, everything else may cause a recursive crash */
+	if (unlikely(modifying_ftrace_code) && ftrace_int3_handler(regs))
+		return;
+#endif
 #ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 	if (kgdb_ll_trap(DIE_INT3, "int3", regs, error_code, X86_TRAP_BP,
 				SIGTRAP) == NOTIFY_STOP)
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 72a6cab..0b55903 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -286,6 +286,12 @@ struct ftrace_rec_iter *ftrace_rec_iter_start(void);
 struct ftrace_rec_iter *ftrace_rec_iter_next(struct ftrace_rec_iter *iter);
 struct dyn_ftrace *ftrace_rec_iter_record(struct ftrace_rec_iter *iter);
 
+#define for_ftrace_rec_iter(iter)		\
+	for (iter = ftrace_rec_iter_start();	\
+	     iter;				\
+	     iter = ftrace_rec_iter_next(iter))
+
+
 int ftrace_update_record(struct dyn_ftrace *rec, int enable);
 int ftrace_test_record(struct dyn_ftrace *rec, int enable);
 void ftrace_run_stop_machine(int command);
