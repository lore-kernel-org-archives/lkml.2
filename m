Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab2D1BTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 21:19:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28798 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2D1BTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 21:19:33 -0400
X-Authority-Analysis: v=2.0 cv=T/EOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=rTZ4OEsa92IA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=kSemnC_1vDLSO_8a3vMA:9 a=xRrm0gaErvSJMlradF4A:7 a=PUjeQqilurYA:10 a=Y7qQXszKIT68Lt2X:21 a=A1E_cJARGRnZ9I0g:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335575969.28106.243.camel@gandalf.stny.rr.com>
Subject: [PATCH v3][GIT PULL] tracing: updates for 3.5
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Fri, 27 Apr 2012 21:19:29 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo, Peter,

This is the same as the last patch pull request, with the exception that
I added the Acked-by from Masami in the change log of patch 4. The
patches are the same.

-- Steve


Please pull the latest tip/perf/core-3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core-3

Head SHA1: 4a6d70c9505fef1d8906b1d61db3de5d8ecf9454


Dan Carpenter (1):
      tracing: Remove an unneeded check in trace_seq_buffer()

Steven Rostedt (3):
      tracing: Add percpu buffers for trace_printk()
      ftrace/x86: Have arch x86_64 use breakpoints instead of stop machine
      ftrace/x86: Remove the complex ftrace NMI handling code

Vaibhav Nagarnaik (1):
      ring-buffer: Add per_cpu ring buffer control files

----
 arch/x86/Kconfig              |    1 -
 arch/x86/include/asm/ftrace.h |    3 +
 arch/x86/kernel/ftrace.c      |  511 +++++++++++++++++++++++++++--------------
 arch/x86/kernel/nmi.c         |   10 +-
 arch/x86/kernel/traps.c       |    8 +-
 include/linux/ftrace.h        |    6 +
 include/linux/kernel.h        |   13 +-
 include/linux/ring_buffer.h   |    6 +-
 kernel/trace/ring_buffer.c    |  248 +++++++++++---------
 kernel/trace/trace.c          |  379 ++++++++++++++++++++++--------
 kernel/trace/trace.h          |    4 +-
 kernel/trace/trace_printk.c   |    4 +
 12 files changed, 810 insertions(+), 383 deletions(-)
---------------------------
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d14cc6..1324139 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -40,7 +40,6 @@ config X86
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_GRAPH_FP_TEST
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_KVM
 	select HAVE_ARCH_KGDB
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
index c9a281f..cf2d03e 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -20,44 +20,25 @@
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/kprobes.h>
 
 #include <trace/syscall.h>
 
 #include <asm/cacheflush.h>
 #include <asm/ftrace.h>
 #include <asm/nops.h>
-#include <asm/nmi.h>
-
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
-/*
- * modifying_code is set to notify NMIs that they need to use
- * memory barriers when entering or exiting. But we don't want
- * to burden NMIs with unnecessary memory barriers when code
- * modification is not being done (which is most of the time).
- *
- * A mutex is already held when ftrace_arch_code_modify_prepare
- * and post_process are called. No locks need to be taken here.
- *
- * Stop machine will make sure currently running NMIs are done
- * and new NMIs will see the updated variable before we need
- * to worry about NMIs doing memory barriers.
- */
-static int modifying_code __read_mostly;
-static DEFINE_PER_CPU(int, save_modifying_code);
-
 int ftrace_arch_code_modify_prepare(void)
 {
 	set_kernel_text_rw();
 	set_all_modules_text_rw();
-	modifying_code = 1;
 	return 0;
 }
 
 int ftrace_arch_code_modify_post_process(void)
 {
-	modifying_code = 0;
 	set_all_modules_text_ro();
 	set_kernel_text_ro();
 	return 0;
@@ -90,134 +71,6 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 	return calc.code;
 }
 
-/*
- * Modifying code must take extra care. On an SMP machine, if
- * the code being modified is also being executed on another CPU
- * that CPU will have undefined results and possibly take a GPF.
- * We use kstop_machine to stop other CPUS from exectuing code.
- * But this does not stop NMIs from happening. We still need
- * to protect against that. We separate out the modification of
- * the code to take care of this.
- *
- * Two buffers are added: An IP buffer and a "code" buffer.
- *
- * 1) Put the instruction pointer into the IP buffer
- *    and the new code into the "code" buffer.
- * 2) Wait for any running NMIs to finish and set a flag that says
- *    we are modifying code, it is done in an atomic operation.
- * 3) Write the code
- * 4) clear the flag.
- * 5) Wait for any running NMIs to finish.
- *
- * If an NMI is executed, the first thing it does is to call
- * "ftrace_nmi_enter". This will check if the flag is set to write
- * and if it is, it will write what is in the IP and "code" buffers.
- *
- * The trick is, it does not matter if everyone is writing the same
- * content to the code location. Also, if a CPU is executing code
- * it is OK to write to that code location if the contents being written
- * are the same as what exists.
- */
-
-#define MOD_CODE_WRITE_FLAG (1 << 31)	/* set when NMI should do the write */
-static atomic_t nmi_running = ATOMIC_INIT(0);
-static int mod_code_status;		/* holds return value of text write */
-static void *mod_code_ip;		/* holds the IP to write to */
-static const void *mod_code_newcode;	/* holds the text to write to the IP */
-
-static unsigned nmi_wait_count;
-static atomic_t nmi_update_count = ATOMIC_INIT(0);
-
-int ftrace_arch_read_dyn_info(char *buf, int size)
-{
-	int r;
-
-	r = snprintf(buf, size, "%u %u",
-		     nmi_wait_count,
-		     atomic_read(&nmi_update_count));
-	return r;
-}
-
-static void clear_mod_flag(void)
-{
-	int old = atomic_read(&nmi_running);
-
-	for (;;) {
-		int new = old & ~MOD_CODE_WRITE_FLAG;
-
-		if (old == new)
-			break;
-
-		old = atomic_cmpxchg(&nmi_running, old, new);
-	}
-}
-
-static void ftrace_mod_code(void)
-{
-	/*
-	 * Yes, more than one CPU process can be writing to mod_code_status.
-	 *    (and the code itself)
-	 * But if one were to fail, then they all should, and if one were
-	 * to succeed, then they all should.
-	 */
-	mod_code_status = probe_kernel_write(mod_code_ip, mod_code_newcode,
-					     MCOUNT_INSN_SIZE);
-
-	/* if we fail, then kill any new writers */
-	if (mod_code_status)
-		clear_mod_flag();
-}
-
-void ftrace_nmi_enter(void)
-{
-	__this_cpu_write(save_modifying_code, modifying_code);
-
-	if (!__this_cpu_read(save_modifying_code))
-		return;
-
-	if (atomic_inc_return(&nmi_running) & MOD_CODE_WRITE_FLAG) {
-		smp_rmb();
-		ftrace_mod_code();
-		atomic_inc(&nmi_update_count);
-	}
-	/* Must have previous changes seen before executions */
-	smp_mb();
-}
-
-void ftrace_nmi_exit(void)
-{
-	if (!__this_cpu_read(save_modifying_code))
-		return;
-
-	/* Finish all executions before clearing nmi_running */
-	smp_mb();
-	atomic_dec(&nmi_running);
-}
-
-static void wait_for_nmi_and_set_mod_flag(void)
-{
-	if (!atomic_cmpxchg(&nmi_running, 0, MOD_CODE_WRITE_FLAG))
-		return;
-
-	do {
-		cpu_relax();
-	} while (atomic_cmpxchg(&nmi_running, 0, MOD_CODE_WRITE_FLAG));
-
-	nmi_wait_count++;
-}
-
-static void wait_for_nmi(void)
-{
-	if (!atomic_read(&nmi_running))
-		return;
-
-	do {
-		cpu_relax();
-	} while (atomic_read(&nmi_running));
-
-	nmi_wait_count++;
-}
-
 static inline int
 within(unsigned long addr, unsigned long start, unsigned long end)
 {
@@ -238,26 +91,7 @@ do_ftrace_mod_code(unsigned long ip, const void *new_code)
 	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
 		ip = (unsigned long)__va(__pa(ip));
 
-	mod_code_ip = (void *)ip;
-	mod_code_newcode = new_code;
-
-	/* The buffers need to be visible before we let NMIs write them */
-	smp_mb();
-
-	wait_for_nmi_and_set_mod_flag();
-
-	/* Make sure all running NMIs have finished before we write the code */
-	smp_mb();
-
-	ftrace_mod_code();
-
-	/* Make sure the write happens before clearing the bit */
-	smp_mb();
-
-	clear_mod_flag();
-	wait_for_nmi();
-
-	return mod_code_status;
+	return probe_kernel_write((void *)ip, new_code, MCOUNT_INSN_SIZE);
 }
 
 static const unsigned char *ftrace_nop_replace(void)
@@ -334,6 +168,347 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
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
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 47acaf3..eb1539e 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -84,7 +84,7 @@ __setup("unknown_nmi_panic", setup_unknown_nmi_panic);
 
 #define nmi_to_desc(type) (&nmi_desc[type])
 
-static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
+static int __kprobes nmi_handle(unsigned int type, struct pt_regs *regs, bool b2b)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
 	struct nmiaction *a;
@@ -209,7 +209,7 @@ void unregister_nmi_handler(unsigned int type, const char *name)
 
 EXPORT_SYMBOL_GPL(unregister_nmi_handler);
 
-static notrace __kprobes void
+static __kprobes void
 pci_serr_error(unsigned char reason, struct pt_regs *regs)
 {
 	pr_emerg("NMI: PCI system error (SERR) for reason %02x on CPU %d.\n",
@@ -236,7 +236,7 @@ pci_serr_error(unsigned char reason, struct pt_regs *regs)
 	outb(reason, NMI_REASON_PORT);
 }
 
-static notrace __kprobes void
+static __kprobes void
 io_check_error(unsigned char reason, struct pt_regs *regs)
 {
 	unsigned long i;
@@ -263,7 +263,7 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 	outb(reason, NMI_REASON_PORT);
 }
 
-static notrace __kprobes void
+static __kprobes void
 unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 {
 	int handled;
@@ -305,7 +305,7 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 static DEFINE_PER_CPU(bool, swallow_nmi);
 static DEFINE_PER_CPU(unsigned long, last_nmi_rip);
 
-static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
+static __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
 	int handled;
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
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 645231c..c0d3442 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -480,15 +480,16 @@ do {									\
 
 #define trace_printk(fmt, args...)					\
 do {									\
+	static const char *trace_printk_fmt				\
+		__attribute__((section("__trace_printk_fmt"))) =	\
+		__builtin_constant_p(fmt) ? fmt : NULL;			\
+									\
 	__trace_printk_check_format(fmt, ##args);			\
-	if (__builtin_constant_p(fmt)) {				\
-		static const char *trace_printk_fmt			\
-		  __attribute__((section("__trace_printk_fmt"))) =	\
-			__builtin_constant_p(fmt) ? fmt : NULL;		\
 									\
+	if (__builtin_constant_p(fmt))					\
 		__trace_bprintk(_THIS_IP_, trace_printk_fmt, ##args);	\
-	} else								\
-		__trace_printk(_THIS_IP_, fmt, ##args);		\
+	else								\
+		__trace_printk(_THIS_IP_, fmt, ##args);			\
 } while (0)
 
 extern __printf(2, 3)
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 7be2e88..6c8835f 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -96,9 +96,11 @@ __ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *k
 	__ring_buffer_alloc((size), (flags), &__key);	\
 })
 
+#define RING_BUFFER_ALL_CPUS -1
+
 void ring_buffer_free(struct ring_buffer *buffer);
 
-int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size);
+int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size, int cpu);
 
 void ring_buffer_change_overwrite(struct ring_buffer *buffer, int val);
 
@@ -129,7 +131,7 @@ ring_buffer_read(struct ring_buffer_iter *iter, u64 *ts);
 void ring_buffer_iter_reset(struct ring_buffer_iter *iter);
 int ring_buffer_iter_empty(struct ring_buffer_iter *iter);
 
-unsigned long ring_buffer_size(struct ring_buffer *buffer);
+unsigned long ring_buffer_size(struct ring_buffer *buffer, int cpu);
 
 void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu);
 void ring_buffer_reset(struct ring_buffer *buffer);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index cf8d11e..2d5eb33 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -449,6 +449,7 @@ struct ring_buffer_per_cpu {
 	raw_spinlock_t			reader_lock;	/* serialize readers */
 	arch_spinlock_t			lock;
 	struct lock_class_key		lock_key;
+	unsigned int			nr_pages;
 	struct list_head		*pages;
 	struct buffer_page		*head_page;	/* read from head */
 	struct buffer_page		*tail_page;	/* write to tail */
@@ -466,10 +467,12 @@ struct ring_buffer_per_cpu {
 	unsigned long			read_bytes;
 	u64				write_stamp;
 	u64				read_stamp;
+	/* ring buffer pages to update, > 0 to add, < 0 to remove */
+	int				nr_pages_to_update;
+	struct list_head		new_pages; /* new pages to add */
 };
 
 struct ring_buffer {
-	unsigned			pages;
 	unsigned			flags;
 	int				cpus;
 	atomic_t			record_disabled;
@@ -963,14 +966,10 @@ static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
 	return 0;
 }
 
-static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
-			     unsigned nr_pages)
+static int __rb_allocate_pages(int nr_pages, struct list_head *pages, int cpu)
 {
+	int i;
 	struct buffer_page *bpage, *tmp;
-	LIST_HEAD(pages);
-	unsigned i;
-
-	WARN_ON(!nr_pages);
 
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page;
@@ -981,15 +980,13 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 		 */
 		bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 				    GFP_KERNEL | __GFP_NORETRY,
-				    cpu_to_node(cpu_buffer->cpu));
+				    cpu_to_node(cpu));
 		if (!bpage)
 			goto free_pages;
 
-		rb_check_bpage(cpu_buffer, bpage);
+		list_add(&bpage->list, pages);
 
-		list_add(&bpage->list, &pages);
-
-		page = alloc_pages_node(cpu_to_node(cpu_buffer->cpu),
+		page = alloc_pages_node(cpu_to_node(cpu),
 					GFP_KERNEL | __GFP_NORETRY, 0);
 		if (!page)
 			goto free_pages;
@@ -997,6 +994,27 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 		rb_init_page(bpage->page);
 	}
 
+	return 0;
+
+free_pages:
+	list_for_each_entry_safe(bpage, tmp, pages, list) {
+		list_del_init(&bpage->list);
+		free_buffer_page(bpage);
+	}
+
+	return -ENOMEM;
+}
+
+static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
+			     unsigned nr_pages)
+{
+	LIST_HEAD(pages);
+
+	WARN_ON(!nr_pages);
+
+	if (__rb_allocate_pages(nr_pages, &pages, cpu_buffer->cpu))
+		return -ENOMEM;
+
 	/*
 	 * The ring buffer page list is a circular list that does not
 	 * start and end with a list head. All page list items point to
@@ -1005,20 +1023,15 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 	cpu_buffer->pages = pages.next;
 	list_del(&pages);
 
+	cpu_buffer->nr_pages = nr_pages;
+
 	rb_check_pages(cpu_buffer);
 
 	return 0;
-
- free_pages:
-	list_for_each_entry_safe(bpage, tmp, &pages, list) {
-		list_del_init(&bpage->list);
-		free_buffer_page(bpage);
-	}
-	return -ENOMEM;
 }
 
 static struct ring_buffer_per_cpu *
-rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
+rb_allocate_cpu_buffer(struct ring_buffer *buffer, int nr_pages, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_page *bpage;
@@ -1052,7 +1065,7 @@ rb_allocate_cpu_buffer(struct ring_buffer *buffer, int cpu)
 
 	INIT_LIST_HEAD(&cpu_buffer->reader_page->list);
 
-	ret = rb_allocate_pages(cpu_buffer, buffer->pages);
+	ret = rb_allocate_pages(cpu_buffer, nr_pages);
 	if (ret < 0)
 		goto fail_free_reader;
 
@@ -1113,7 +1126,7 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 {
 	struct ring_buffer *buffer;
 	int bsize;
-	int cpu;
+	int cpu, nr_pages;
 
 	/* keep it in its own cache line */
 	buffer = kzalloc(ALIGN(sizeof(*buffer), cache_line_size()),
@@ -1124,14 +1137,14 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 	if (!alloc_cpumask_var(&buffer->cpumask, GFP_KERNEL))
 		goto fail_free_buffer;
 
-	buffer->pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
+	nr_pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 	buffer->flags = flags;
 	buffer->clock = trace_clock_local;
 	buffer->reader_lock_key = key;
 
 	/* need at least two pages */
-	if (buffer->pages < 2)
-		buffer->pages = 2;
+	if (nr_pages < 2)
+		nr_pages = 2;
 
 	/*
 	 * In case of non-hotplug cpu, if the ring-buffer is allocated
@@ -1154,7 +1167,7 @@ struct ring_buffer *__ring_buffer_alloc(unsigned long size, unsigned flags,
 
 	for_each_buffer_cpu(buffer, cpu) {
 		buffer->buffers[cpu] =
-			rb_allocate_cpu_buffer(buffer, cpu);
+			rb_allocate_cpu_buffer(buffer, nr_pages, cpu);
 		if (!buffer->buffers[cpu])
 			goto fail_free_buffers;
 	}
@@ -1276,6 +1289,18 @@ out:
 	raw_spin_unlock_irq(&cpu_buffer->reader_lock);
 }
 
+static void update_pages_handler(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	if (cpu_buffer->nr_pages_to_update > 0)
+		rb_insert_pages(cpu_buffer, &cpu_buffer->new_pages,
+				cpu_buffer->nr_pages_to_update);
+	else
+		rb_remove_pages(cpu_buffer, -cpu_buffer->nr_pages_to_update);
+	cpu_buffer->nr_pages += cpu_buffer->nr_pages_to_update;
+	/* reset this value */
+	cpu_buffer->nr_pages_to_update = 0;
+}
+
 /**
  * ring_buffer_resize - resize the ring buffer
  * @buffer: the buffer to resize.
@@ -1285,14 +1310,12 @@ out:
  *
  * Returns -1 on failure.
  */
-int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
+int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
+			int cpu_id)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
-	unsigned nr_pages, rm_pages, new_pages;
-	struct buffer_page *bpage, *tmp;
-	unsigned long buffer_size;
-	LIST_HEAD(pages);
-	int i, cpu;
+	unsigned nr_pages;
+	int cpu;
 
 	/*
 	 * Always succeed at resizing a non-existent buffer:
@@ -1302,15 +1325,11 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 
 	size = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 	size *= BUF_PAGE_SIZE;
-	buffer_size = buffer->pages * BUF_PAGE_SIZE;
 
 	/* we need a minimum of two pages */
 	if (size < BUF_PAGE_SIZE * 2)
 		size = BUF_PAGE_SIZE * 2;
 
-	if (size == buffer_size)
-		return size;
-
 	atomic_inc(&buffer->record_disabled);
 
 	/* Make sure all writers are done with this buffer. */
@@ -1321,68 +1340,56 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 
 	nr_pages = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 
-	if (size < buffer_size) {
-
-		/* easy case, just free pages */
-		if (RB_WARN_ON(buffer, nr_pages >= buffer->pages))
-			goto out_fail;
-
-		rm_pages = buffer->pages - nr_pages;
-
+	if (cpu_id == RING_BUFFER_ALL_CPUS) {
+		/* calculate the pages to update */
 		for_each_buffer_cpu(buffer, cpu) {
 			cpu_buffer = buffer->buffers[cpu];
-			rb_remove_pages(cpu_buffer, rm_pages);
-		}
-		goto out;
-	}
 
-	/*
-	 * This is a bit more difficult. We only want to add pages
-	 * when we can allocate enough for all CPUs. We do this
-	 * by allocating all the pages and storing them on a local
-	 * link list. If we succeed in our allocation, then we
-	 * add these pages to the cpu_buffers. Otherwise we just free
-	 * them all and return -ENOMEM;
-	 */
-	if (RB_WARN_ON(buffer, nr_pages <= buffer->pages))
-		goto out_fail;
+			cpu_buffer->nr_pages_to_update = nr_pages -
+							cpu_buffer->nr_pages;
 
-	new_pages = nr_pages - buffer->pages;
+			/*
+			 * nothing more to do for removing pages or no update
+			 */
+			if (cpu_buffer->nr_pages_to_update <= 0)
+				continue;
 
-	for_each_buffer_cpu(buffer, cpu) {
-		for (i = 0; i < new_pages; i++) {
-			struct page *page;
 			/*
-			 * __GFP_NORETRY flag makes sure that the allocation
-			 * fails gracefully without invoking oom-killer and
-			 * the system is not destabilized.
+			 * to add pages, make sure all new pages can be
+			 * allocated without receiving ENOMEM
 			 */
-			bpage = kzalloc_node(ALIGN(sizeof(*bpage),
-						  cache_line_size()),
-					    GFP_KERNEL | __GFP_NORETRY,
-					    cpu_to_node(cpu));
-			if (!bpage)
-				goto free_pages;
-			list_add(&bpage->list, &pages);
-			page = alloc_pages_node(cpu_to_node(cpu),
-						GFP_KERNEL | __GFP_NORETRY, 0);
-			if (!page)
-				goto free_pages;
-			bpage->page = page_address(page);
-			rb_init_page(bpage->page);
+			INIT_LIST_HEAD(&cpu_buffer->new_pages);
+			if (__rb_allocate_pages(cpu_buffer->nr_pages_to_update,
+						&cpu_buffer->new_pages, cpu))
+				/* not enough memory for new pages */
+				goto no_mem;
 		}
-	}
 
-	for_each_buffer_cpu(buffer, cpu) {
-		cpu_buffer = buffer->buffers[cpu];
-		rb_insert_pages(cpu_buffer, &pages, new_pages);
-	}
+		/* wait for all the updates to complete */
+		for_each_buffer_cpu(buffer, cpu) {
+			cpu_buffer = buffer->buffers[cpu];
+			if (cpu_buffer->nr_pages_to_update) {
+				update_pages_handler(cpu_buffer);
+			}
+		}
+	} else {
+		cpu_buffer = buffer->buffers[cpu_id];
+		if (nr_pages == cpu_buffer->nr_pages)
+			goto out;
 
-	if (RB_WARN_ON(buffer, !list_empty(&pages)))
-		goto out_fail;
+		cpu_buffer->nr_pages_to_update = nr_pages -
+						cpu_buffer->nr_pages;
+
+		INIT_LIST_HEAD(&cpu_buffer->new_pages);
+		if (cpu_buffer->nr_pages_to_update > 0 &&
+			__rb_allocate_pages(cpu_buffer->nr_pages_to_update,
+						&cpu_buffer->new_pages, cpu_id))
+			goto no_mem;
+
+		update_pages_handler(cpu_buffer);
+	}
 
  out:
-	buffer->pages = nr_pages;
 	put_online_cpus();
 	mutex_unlock(&buffer->mutex);
 
@@ -1390,25 +1397,24 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 
 	return size;
 
- free_pages:
-	list_for_each_entry_safe(bpage, tmp, &pages, list) {
-		list_del_init(&bpage->list);
-		free_buffer_page(bpage);
+ no_mem:
+	for_each_buffer_cpu(buffer, cpu) {
+		struct buffer_page *bpage, *tmp;
+		cpu_buffer = buffer->buffers[cpu];
+		/* reset this number regardless */
+		cpu_buffer->nr_pages_to_update = 0;
+		if (list_empty(&cpu_buffer->new_pages))
+			continue;
+		list_for_each_entry_safe(bpage, tmp, &cpu_buffer->new_pages,
+					list) {
+			list_del_init(&bpage->list);
+			free_buffer_page(bpage);
+		}
 	}
 	put_online_cpus();
 	mutex_unlock(&buffer->mutex);
 	atomic_dec(&buffer->record_disabled);
 	return -ENOMEM;
-
-	/*
-	 * Something went totally wrong, and we are too paranoid
-	 * to even clean up the mess.
-	 */
- out_fail:
-	put_online_cpus();
-	mutex_unlock(&buffer->mutex);
-	atomic_dec(&buffer->record_disabled);
-	return -1;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_resize);
 
@@ -1510,7 +1516,7 @@ rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
 	 * assign the commit to the tail.
 	 */
  again:
-	max_count = cpu_buffer->buffer->pages * 100;
+	max_count = cpu_buffer->nr_pages * 100;
 
 	while (cpu_buffer->commit_page != cpu_buffer->tail_page) {
 		if (RB_WARN_ON(cpu_buffer, !(--max_count)))
@@ -3588,9 +3594,18 @@ EXPORT_SYMBOL_GPL(ring_buffer_read);
  * ring_buffer_size - return the size of the ring buffer (in bytes)
  * @buffer: The ring buffer.
  */
-unsigned long ring_buffer_size(struct ring_buffer *buffer)
+unsigned long ring_buffer_size(struct ring_buffer *buffer, int cpu)
 {
-	return BUF_PAGE_SIZE * buffer->pages;
+	/*
+	 * Earlier, this method returned
+	 *	BUF_PAGE_SIZE * buffer->nr_pages
+	 * Since the nr_pages field is now removed, we have converted this to
+	 * return the per cpu buffer value.
+	 */
+	if (!cpumask_test_cpu(cpu, buffer->cpumask))
+		return 0;
+
+	return BUF_PAGE_SIZE * buffer->buffers[cpu]->nr_pages;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_size);
 
@@ -3765,8 +3780,11 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 	    !cpumask_test_cpu(cpu, buffer_b->cpumask))
 		goto out;
 
+	cpu_buffer_a = buffer_a->buffers[cpu];
+	cpu_buffer_b = buffer_b->buffers[cpu];
+
 	/* At least make sure the two buffers are somewhat the same */
-	if (buffer_a->pages != buffer_b->pages)
+	if (cpu_buffer_a->nr_pages != cpu_buffer_b->nr_pages)
 		goto out;
 
 	ret = -EAGAIN;
@@ -3780,9 +3798,6 @@ int ring_buffer_swap_cpu(struct ring_buffer *buffer_a,
 	if (atomic_read(&buffer_b->record_disabled))
 		goto out;
 
-	cpu_buffer_a = buffer_a->buffers[cpu];
-	cpu_buffer_b = buffer_b->buffers[cpu];
-
 	if (atomic_read(&cpu_buffer_a->record_disabled))
 		goto out;
 
@@ -4071,6 +4086,8 @@ static int rb_cpu_notify(struct notifier_block *self,
 	struct ring_buffer *buffer =
 		container_of(self, struct ring_buffer, cpu_notify);
 	long cpu = (long)hcpu;
+	int cpu_i, nr_pages_same;
+	unsigned int nr_pages;
 
 	switch (action) {
 	case CPU_UP_PREPARE:
@@ -4078,8 +4095,23 @@ static int rb_cpu_notify(struct notifier_block *self,
 		if (cpumask_test_cpu(cpu, buffer->cpumask))
 			return NOTIFY_OK;
 
+		nr_pages = 0;
+		nr_pages_same = 1;
+		/* check if all cpu sizes are same */
+		for_each_buffer_cpu(buffer, cpu_i) {
+			/* fill in the size from first enabled cpu */
+			if (nr_pages == 0)
+				nr_pages = buffer->buffers[cpu_i]->nr_pages;
+			if (nr_pages != buffer->buffers[cpu_i]->nr_pages) {
+				nr_pages_same = 0;
+				break;
+			}
+		}
+		/* allocate minimum pages, user can later expand it */
+		if (!nr_pages_same)
+			nr_pages = 2;
 		buffer->buffers[cpu] =
-			rb_allocate_cpu_buffer(buffer, cpu);
+			rb_allocate_cpu_buffer(buffer, nr_pages, cpu);
 		if (!buffer->buffers[cpu]) {
 			WARN(1, "failed to allocate ring buffer on CPU %ld\n",
 			     cpu);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ed7b5d1..f11a285 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -629,7 +629,6 @@ ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
 static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 {
 	int len;
-	void *ret;
 
 	if (s->len <= s->readpos)
 		return -EBUSY;
@@ -637,9 +636,7 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 	len = s->len - s->readpos;
 	if (cnt > len)
 		cnt = len;
-	ret = memcpy(buf, s->buffer + s->readpos, cnt);
-	if (!ret)
-		return -EFAULT;
+	memcpy(buf, s->buffer + s->readpos, cnt);
 
 	s->readpos += cnt;
 	return cnt;
@@ -841,7 +838,8 @@ __acquires(kernel_lock)
 
 		/* If we expanded the buffers, make sure the max is expanded too */
 		if (ring_buffer_expanded && type->use_max_tr)
-			ring_buffer_resize(max_tr.buffer, trace_buf_size);
+			ring_buffer_resize(max_tr.buffer, trace_buf_size,
+						RING_BUFFER_ALL_CPUS);
 
 		/* the test is responsible for initializing and enabling */
 		pr_info("Testing tracer %s: ", type->name);
@@ -857,7 +855,8 @@ __acquires(kernel_lock)
 
 		/* Shrink the max buffer again */
 		if (ring_buffer_expanded && type->use_max_tr)
-			ring_buffer_resize(max_tr.buffer, 1);
+			ring_buffer_resize(max_tr.buffer, 1,
+						RING_BUFFER_ALL_CPUS);
 
 		printk(KERN_CONT "PASSED\n");
 	}
@@ -1498,25 +1497,119 @@ static void __trace_userstack(struct trace_array *tr, unsigned long flags)
 
 #endif /* CONFIG_STACKTRACE */
 
+/* created for use with alloc_percpu */
+struct trace_buffer_struct {
+	char buffer[TRACE_BUF_SIZE];
+};
+
+static struct trace_buffer_struct *trace_percpu_buffer;
+static struct trace_buffer_struct *trace_percpu_sirq_buffer;
+static struct trace_buffer_struct *trace_percpu_irq_buffer;
+static struct trace_buffer_struct *trace_percpu_nmi_buffer;
+
+/*
+ * The buffer used is dependent on the context. There is a per cpu
+ * buffer for normal context, softirq contex, hard irq context and
+ * for NMI context. Thise allows for lockless recording.
+ *
+ * Note, if the buffers failed to be allocated, then this returns NULL
+ */
+static char *get_trace_buf(void)
+{
+	struct trace_buffer_struct *percpu_buffer;
+	struct trace_buffer_struct *buffer;
+
+	/*
+	 * If we have allocated per cpu buffers, then we do not
+	 * need to do any locking.
+	 */
+	if (in_nmi())
+		percpu_buffer = trace_percpu_nmi_buffer;
+	else if (in_irq())
+		percpu_buffer = trace_percpu_irq_buffer;
+	else if (in_softirq())
+		percpu_buffer = trace_percpu_sirq_buffer;
+	else
+		percpu_buffer = trace_percpu_buffer;
+
+	if (!percpu_buffer)
+		return NULL;
+
+	buffer = per_cpu_ptr(percpu_buffer, smp_processor_id());
+
+	return buffer->buffer;
+}
+
+static int alloc_percpu_trace_buffer(void)
+{
+	struct trace_buffer_struct *buffers;
+	struct trace_buffer_struct *sirq_buffers;
+	struct trace_buffer_struct *irq_buffers;
+	struct trace_buffer_struct *nmi_buffers;
+
+	buffers = alloc_percpu(struct trace_buffer_struct);
+	if (!buffers)
+		goto err_warn;
+
+	sirq_buffers = alloc_percpu(struct trace_buffer_struct);
+	if (!sirq_buffers)
+		goto err_sirq;
+
+	irq_buffers = alloc_percpu(struct trace_buffer_struct);
+	if (!irq_buffers)
+		goto err_irq;
+
+	nmi_buffers = alloc_percpu(struct trace_buffer_struct);
+	if (!nmi_buffers)
+		goto err_nmi;
+
+	trace_percpu_buffer = buffers;
+	trace_percpu_sirq_buffer = sirq_buffers;
+	trace_percpu_irq_buffer = irq_buffers;
+	trace_percpu_nmi_buffer = nmi_buffers;
+
+	return 0;
+
+ err_nmi:
+	free_percpu(irq_buffers);
+ err_irq:
+	free_percpu(sirq_buffers);
+ err_sirq:
+	free_percpu(buffers);
+ err_warn:
+	WARN(1, "Could not allocate percpu trace_printk buffer");
+	return -ENOMEM;
+}
+
+void trace_printk_init_buffers(void)
+{
+	static int buffers_allocated;
+
+	if (buffers_allocated)
+		return;
+
+	if (alloc_percpu_trace_buffer())
+		return;
+
+	pr_info("ftrace: Allocated trace_printk buffers\n");
+
+	buffers_allocated = 1;
+}
+
 /**
  * trace_vbprintk - write binary msg to tracing buffer
  *
  */
 int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 {
-	static arch_spinlock_t trace_buf_lock =
-		(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
-	static u32 trace_buf[TRACE_BUF_SIZE];
-
 	struct ftrace_event_call *call = &event_bprint;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
 	struct trace_array *tr = &global_trace;
-	struct trace_array_cpu *data;
 	struct bprint_entry *entry;
 	unsigned long flags;
-	int disable;
-	int cpu, len = 0, size, pc;
+	char *tbuffer;
+	int len = 0, size, pc;
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
 		return 0;
@@ -1526,43 +1619,36 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 
 	pc = preempt_count();
 	preempt_disable_notrace();
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
 
-	disable = atomic_inc_return(&data->disabled);
-	if (unlikely(disable != 1))
+	tbuffer = get_trace_buf();
+	if (!tbuffer) {
+		len = 0;
 		goto out;
+	}
 
-	/* Lockdep uses trace_printk for lock tracing */
-	local_irq_save(flags);
-	arch_spin_lock(&trace_buf_lock);
-	len = vbin_printf(trace_buf, TRACE_BUF_SIZE, fmt, args);
+	len = vbin_printf((u32 *)tbuffer, TRACE_BUF_SIZE/sizeof(int), fmt, args);
 
-	if (len > TRACE_BUF_SIZE || len < 0)
-		goto out_unlock;
+	if (len > TRACE_BUF_SIZE/sizeof(int) || len < 0)
+		goto out;
 
+	local_save_flags(flags);
 	size = sizeof(*entry) + sizeof(u32) * len;
 	buffer = tr->buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_BPRINT, size,
 					  flags, pc);
 	if (!event)
-		goto out_unlock;
+		goto out;
 	entry = ring_buffer_event_data(event);
 	entry->ip			= ip;
 	entry->fmt			= fmt;
 
-	memcpy(entry->buf, trace_buf, sizeof(u32) * len);
+	memcpy(entry->buf, tbuffer, sizeof(u32) * len);
 	if (!filter_check_discard(call, entry, buffer, event)) {
 		ring_buffer_unlock_commit(buffer, event);
 		ftrace_trace_stack(buffer, flags, 6, pc);
 	}
 
-out_unlock:
-	arch_spin_unlock(&trace_buf_lock);
-	local_irq_restore(flags);
-
 out:
-	atomic_dec_return(&data->disabled);
 	preempt_enable_notrace();
 	unpause_graph_tracing();
 
@@ -1588,58 +1674,53 @@ int trace_array_printk(struct trace_array *tr,
 int trace_array_vprintk(struct trace_array *tr,
 			unsigned long ip, const char *fmt, va_list args)
 {
-	static arch_spinlock_t trace_buf_lock = __ARCH_SPIN_LOCK_UNLOCKED;
-	static char trace_buf[TRACE_BUF_SIZE];
-
 	struct ftrace_event_call *call = &event_print;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
-	struct trace_array_cpu *data;
-	int cpu, len = 0, size, pc;
+	int len = 0, size, pc;
 	struct print_entry *entry;
-	unsigned long irq_flags;
-	int disable;
+	unsigned long flags;
+	char *tbuffer;
 
 	if (tracing_disabled || tracing_selftest_running)
 		return 0;
 
+	/* Don't pollute graph traces with trace_vprintk internals */
+	pause_graph_tracing();
+
 	pc = preempt_count();
 	preempt_disable_notrace();
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
 
-	disable = atomic_inc_return(&data->disabled);
-	if (unlikely(disable != 1))
+
+	tbuffer = get_trace_buf();
+	if (!tbuffer) {
+		len = 0;
 		goto out;
+	}
 
-	pause_graph_tracing();
-	raw_local_irq_save(irq_flags);
-	arch_spin_lock(&trace_buf_lock);
-	len = vsnprintf(trace_buf, TRACE_BUF_SIZE, fmt, args);
+	len = vsnprintf(tbuffer, TRACE_BUF_SIZE, fmt, args);
+	if (len > TRACE_BUF_SIZE)
+		goto out;
 
+	local_save_flags(flags);
 	size = sizeof(*entry) + len + 1;
 	buffer = tr->buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
-					  irq_flags, pc);
+					  flags, pc);
 	if (!event)
-		goto out_unlock;
+		goto out;
 	entry = ring_buffer_event_data(event);
 	entry->ip = ip;
 
-	memcpy(&entry->buf, trace_buf, len);
+	memcpy(&entry->buf, tbuffer, len);
 	entry->buf[len] = '\0';
 	if (!filter_check_discard(call, entry, buffer, event)) {
 		ring_buffer_unlock_commit(buffer, event);
-		ftrace_trace_stack(buffer, irq_flags, 6, pc);
+		ftrace_trace_stack(buffer, flags, 6, pc);
 	}
-
- out_unlock:
-	arch_spin_unlock(&trace_buf_lock);
-	raw_local_irq_restore(irq_flags);
-	unpause_graph_tracing();
  out:
-	atomic_dec_return(&data->disabled);
 	preempt_enable_notrace();
+	unpause_graph_tracing();
 
 	return len;
 }
@@ -2974,7 +3055,14 @@ int tracer_init(struct tracer *t, struct trace_array *tr)
 	return t->init(tr);
 }
 
-static int __tracing_resize_ring_buffer(unsigned long size)
+static void set_buffer_entries(struct trace_array *tr, unsigned long val)
+{
+	int cpu;
+	for_each_tracing_cpu(cpu)
+		tr->data[cpu]->entries = val;
+}
+
+static int __tracing_resize_ring_buffer(unsigned long size, int cpu)
 {
 	int ret;
 
@@ -2985,19 +3073,32 @@ static int __tracing_resize_ring_buffer(unsigned long size)
 	 */
 	ring_buffer_expanded = 1;
 
-	ret = ring_buffer_resize(global_trace.buffer, size);
+	ret = ring_buffer_resize(global_trace.buffer, size, cpu);
 	if (ret < 0)
 		return ret;
 
 	if (!current_trace->use_max_tr)
 		goto out;
 
-	ret = ring_buffer_resize(max_tr.buffer, size);
+	ret = ring_buffer_resize(max_tr.buffer, size, cpu);
 	if (ret < 0) {
-		int r;
+		int r = 0;
+
+		if (cpu == RING_BUFFER_ALL_CPUS) {
+			int i;
+			for_each_tracing_cpu(i) {
+				r = ring_buffer_resize(global_trace.buffer,
+						global_trace.data[i]->entries,
+						i);
+				if (r < 0)
+					break;
+			}
+		} else {
+			r = ring_buffer_resize(global_trace.buffer,
+						global_trace.data[cpu]->entries,
+						cpu);
+		}
 
-		r = ring_buffer_resize(global_trace.buffer,
-				       global_trace.entries);
 		if (r < 0) {
 			/*
 			 * AARGH! We are left with different
@@ -3019,14 +3120,21 @@ static int __tracing_resize_ring_buffer(unsigned long size)
 		return ret;
 	}
 
-	max_tr.entries = size;
+	if (cpu == RING_BUFFER_ALL_CPUS)
+		set_buffer_entries(&max_tr, size);
+	else
+		max_tr.data[cpu]->entries = size;
+
  out:
-	global_trace.entries = size;
+	if (cpu == RING_BUFFER_ALL_CPUS)
+		set_buffer_entries(&global_trace, size);
+	else
+		global_trace.data[cpu]->entries = size;
 
 	return ret;
 }
 
-static ssize_t tracing_resize_ring_buffer(unsigned long size)
+static ssize_t tracing_resize_ring_buffer(unsigned long size, int cpu_id)
 {
 	int cpu, ret = size;
 
@@ -3042,12 +3150,19 @@ static ssize_t tracing_resize_ring_buffer(unsigned long size)
 			atomic_inc(&max_tr.data[cpu]->disabled);
 	}
 
-	if (size != global_trace.entries)
-		ret = __tracing_resize_ring_buffer(size);
+	if (cpu_id != RING_BUFFER_ALL_CPUS) {
+		/* make sure, this cpu is enabled in the mask */
+		if (!cpumask_test_cpu(cpu_id, tracing_buffer_mask)) {
+			ret = -EINVAL;
+			goto out;
+		}
+	}
 
+	ret = __tracing_resize_ring_buffer(size, cpu_id);
 	if (ret < 0)
 		ret = -ENOMEM;
 
+out:
 	for_each_tracing_cpu(cpu) {
 		if (global_trace.data[cpu])
 			atomic_dec(&global_trace.data[cpu]->disabled);
@@ -3078,7 +3193,8 @@ int tracing_update_buffers(void)
 
 	mutex_lock(&trace_types_lock);
 	if (!ring_buffer_expanded)
-		ret = __tracing_resize_ring_buffer(trace_buf_size);
+		ret = __tracing_resize_ring_buffer(trace_buf_size,
+						RING_BUFFER_ALL_CPUS);
 	mutex_unlock(&trace_types_lock);
 
 	return ret;
@@ -3102,7 +3218,8 @@ static int tracing_set_tracer(const char *buf)
 	mutex_lock(&trace_types_lock);
 
 	if (!ring_buffer_expanded) {
-		ret = __tracing_resize_ring_buffer(trace_buf_size);
+		ret = __tracing_resize_ring_buffer(trace_buf_size,
+						RING_BUFFER_ALL_CPUS);
 		if (ret < 0)
 			goto out;
 		ret = 0;
@@ -3128,8 +3245,8 @@ static int tracing_set_tracer(const char *buf)
 		 * The max_tr ring buffer has some state (e.g. ring->clock) and
 		 * we want preserve it.
 		 */
-		ring_buffer_resize(max_tr.buffer, 1);
-		max_tr.entries = 1;
+		ring_buffer_resize(max_tr.buffer, 1, RING_BUFFER_ALL_CPUS);
+		set_buffer_entries(&max_tr, 1);
 	}
 	destroy_trace_option_files(topts);
 
@@ -3137,10 +3254,17 @@ static int tracing_set_tracer(const char *buf)
 
 	topts = create_trace_option_files(current_trace);
 	if (current_trace->use_max_tr) {
-		ret = ring_buffer_resize(max_tr.buffer, global_trace.entries);
-		if (ret < 0)
-			goto out;
-		max_tr.entries = global_trace.entries;
+		int cpu;
+		/* we need to make per cpu buffer sizes equivalent */
+		for_each_tracing_cpu(cpu) {
+			ret = ring_buffer_resize(max_tr.buffer,
+						global_trace.data[cpu]->entries,
+						cpu);
+			if (ret < 0)
+				goto out;
+			max_tr.data[cpu]->entries =
+					global_trace.data[cpu]->entries;
+		}
 	}
 
 	if (t->init) {
@@ -3642,30 +3766,82 @@ out_err:
 	goto out;
 }
 
+struct ftrace_entries_info {
+	struct trace_array	*tr;
+	int			cpu;
+};
+
+static int tracing_entries_open(struct inode *inode, struct file *filp)
+{
+	struct ftrace_entries_info *info;
+
+	if (tracing_disabled)
+		return -ENODEV;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->tr = &global_trace;
+	info->cpu = (unsigned long)inode->i_private;
+
+	filp->private_data = info;
+
+	return 0;
+}
+
 static ssize_t
 tracing_entries_read(struct file *filp, char __user *ubuf,
 		     size_t cnt, loff_t *ppos)
 {
-	struct trace_array *tr = filp->private_data;
-	char buf[96];
-	int r;
+	struct ftrace_entries_info *info = filp->private_data;
+	struct trace_array *tr = info->tr;
+	char buf[64];
+	int r = 0;
+	ssize_t ret;
 
 	mutex_lock(&trace_types_lock);
-	if (!ring_buffer_expanded)
-		r = sprintf(buf, "%lu (expanded: %lu)\n",
-			    tr->entries >> 10,
-			    trace_buf_size >> 10);
-	else
-		r = sprintf(buf, "%lu\n", tr->entries >> 10);
+
+	if (info->cpu == RING_BUFFER_ALL_CPUS) {
+		int cpu, buf_size_same;
+		unsigned long size;
+
+		size = 0;
+		buf_size_same = 1;
+		/* check if all cpu sizes are same */
+		for_each_tracing_cpu(cpu) {
+			/* fill in the size from first enabled cpu */
+			if (size == 0)
+				size = tr->data[cpu]->entries;
+			if (size != tr->data[cpu]->entries) {
+				buf_size_same = 0;
+				break;
+			}
+		}
+
+		if (buf_size_same) {
+			if (!ring_buffer_expanded)
+				r = sprintf(buf, "%lu (expanded: %lu)\n",
+					    size >> 10,
+					    trace_buf_size >> 10);
+			else
+				r = sprintf(buf, "%lu\n", size >> 10);
+		} else
+			r = sprintf(buf, "X\n");
+	} else
+		r = sprintf(buf, "%lu\n", tr->data[info->cpu]->entries >> 10);
+
 	mutex_unlock(&trace_types_lock);
 
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+	ret = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+	return ret;
 }
 
 static ssize_t
 tracing_entries_write(struct file *filp, const char __user *ubuf,
 		      size_t cnt, loff_t *ppos)
 {
+	struct ftrace_entries_info *info = filp->private_data;
 	unsigned long val;
 	int ret;
 
@@ -3680,7 +3856,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	/* value is in KB */
 	val <<= 10;
 
-	ret = tracing_resize_ring_buffer(val);
+	ret = tracing_resize_ring_buffer(val, info->cpu);
 	if (ret < 0)
 		return ret;
 
@@ -3689,6 +3865,16 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static int
+tracing_entries_release(struct inode *inode, struct file *filp)
+{
+	struct ftrace_entries_info *info = filp->private_data;
+
+	kfree(info);
+
+	return 0;
+}
+
 static ssize_t
 tracing_total_entries_read(struct file *filp, char __user *ubuf,
 				size_t cnt, loff_t *ppos)
@@ -3700,7 +3886,7 @@ tracing_total_entries_read(struct file *filp, char __user *ubuf,
 
 	mutex_lock(&trace_types_lock);
 	for_each_tracing_cpu(cpu) {
-		size += tr->entries >> 10;
+		size += tr->data[cpu]->entries >> 10;
 		if (!ring_buffer_expanded)
 			expanded_size += trace_buf_size >> 10;
 	}
@@ -3734,7 +3920,7 @@ tracing_free_buffer_release(struct inode *inode, struct file *filp)
 	if (trace_flags & TRACE_ITER_STOP_ON_FREE)
 		tracing_off();
 	/* resize the ring buffer to 0 */
-	tracing_resize_ring_buffer(0);
+	tracing_resize_ring_buffer(0, RING_BUFFER_ALL_CPUS);
 
 	return 0;
 }
@@ -3933,9 +4119,10 @@ static const struct file_operations tracing_pipe_fops = {
 };
 
 static const struct file_operations tracing_entries_fops = {
-	.open		= tracing_open_generic,
+	.open		= tracing_entries_open,
 	.read		= tracing_entries_read,
 	.write		= tracing_entries_write,
+	.release	= tracing_entries_release,
 	.llseek		= generic_file_llseek,
 };
 
@@ -4387,6 +4574,9 @@ static void tracing_init_debugfs_percpu(long cpu)
 
 	trace_create_file("stats", 0444, d_cpu,
 			(void *) cpu, &tracing_stats_fops);
+
+	trace_create_file("buffer_size_kb", 0444, d_cpu,
+			(void *) cpu, &tracing_entries_fops);
 }
 
 #ifdef CONFIG_FTRACE_SELFTEST
@@ -4716,7 +4906,7 @@ static __init int tracer_init_debugfs(void)
 			(void *) TRACE_PIPE_ALL_CPU, &tracing_pipe_fops);
 
 	trace_create_file("buffer_size_kb", 0644, d_tracer,
-			&global_trace, &tracing_entries_fops);
+			(void *) RING_BUFFER_ALL_CPUS, &tracing_entries_fops);
 
 	trace_create_file("buffer_total_size_kb", 0444, d_tracer,
 			&global_trace, &tracing_total_entries_fops);
@@ -4955,6 +5145,10 @@ __init static int tracer_alloc_buffers(void)
 	if (!alloc_cpumask_var(&tracing_cpumask, GFP_KERNEL))
 		goto out_free_buffer_mask;
 
+	/* Only allocate trace_printk buffers if a trace_printk exists */
+	if (__stop___trace_bprintk_fmt != __start___trace_bprintk_fmt)
+		trace_printk_init_buffers();
+
 	/* To save memory, keep the ring buffer size to its minimum */
 	if (ring_buffer_expanded)
 		ring_buf_size = trace_buf_size;
@@ -4973,7 +5167,6 @@ __init static int tracer_alloc_buffers(void)
 		WARN_ON(1);
 		goto out_free_cpumask;
 	}
-	global_trace.entries = ring_buffer_size(global_trace.buffer);
 	if (global_trace.buffer_disabled)
 		tracing_off();
 
@@ -4986,7 +5179,6 @@ __init static int tracer_alloc_buffers(void)
 		ring_buffer_free(global_trace.buffer);
 		goto out_free_cpumask;
 	}
-	max_tr.entries = 1;
 #endif
 
 	/* Allocate the first page for all buffers */
@@ -4995,6 +5187,11 @@ __init static int tracer_alloc_buffers(void)
 		max_tr.data[i] = &per_cpu(max_tr_data, i);
 	}
 
+	set_buffer_entries(&global_trace, ring_buf_size);
+#ifdef CONFIG_TRACER_MAX_TRACE
+	set_buffer_entries(&max_tr, 1);
+#endif
+
 	trace_init_cmdlines();
 
 	register_tracer(&nop_trace);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 95059f0..1c8b7c6 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -131,6 +131,7 @@ struct trace_array_cpu {
 	atomic_t		disabled;
 	void			*buffer_page;	/* ring buffer spare */
 
+	unsigned long		entries;
 	unsigned long		saved_latency;
 	unsigned long		critical_start;
 	unsigned long		critical_end;
@@ -152,7 +153,6 @@ struct trace_array_cpu {
  */
 struct trace_array {
 	struct ring_buffer	*buffer;
-	unsigned long		entries;
 	int			cpu;
 	int			buffer_disabled;
 	cycle_t			time_start;
@@ -826,6 +826,8 @@ extern struct list_head ftrace_events;
 extern const char *__start___trace_bprintk_fmt[];
 extern const char *__stop___trace_bprintk_fmt[];
 
+void trace_printk_init_buffers(void);
+
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print, filter)	\
 	extern struct ftrace_event_call					\
diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
index 6fd4ffd..a9077c1 100644
--- a/kernel/trace/trace_printk.c
+++ b/kernel/trace/trace_printk.c
@@ -51,6 +51,10 @@ void hold_module_trace_bprintk_format(const char **start, const char **end)
 	const char **iter;
 	char *fmt;
 
+	/* allocate the trace_printk per cpu buffers */
+	if (start != end)
+		trace_printk_init_buffers();
+
 	mutex_lock(&btrace_mutex);
 	for (iter = start; iter < end; iter++) {
 		struct trace_bprintk_fmt *tb_fmt = lookup_format(*iter);


