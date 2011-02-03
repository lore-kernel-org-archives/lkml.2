Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab1BCPnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 10:43:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199Ab1BCPnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 10:43:14 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com
Subject: [PATCH 3/4] ktrace - function trace support
Date: Thu,  3 Feb 2011 16:42:40 +0100
Message-Id: <1296747761-9082-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1296747761-9082-1-git-send-email-jolsa@redhat.com>
References: <1296747761-9082-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adding ktrace support with function tracer

wbr,
jirka
---
 Makefile                   |    2 +-
 arch/x86/Kconfig           |    2 +-
 arch/x86/kernel/Makefile   |    1 +
 arch/x86/kernel/entry_64.S |   23 +++
 arch/x86/kernel/ftrace.c   |  153 +++++++++++----------
 arch/x86/kernel/ktrace.c   |  256 ++++++++++++++++++++++++++++++++++
 include/linux/ftrace.h     |   36 +++++-
 kernel/trace/Kconfig       |   28 ++++-
 kernel/trace/Makefile      |    1 +
 kernel/trace/ftrace.c      |   11 ++
 kernel/trace/ktrace.c      |  330 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c       |    1 +
 12 files changed, 764 insertions(+), 80 deletions(-)
 create mode 100644 arch/x86/kernel/ktrace.c
 create mode 100644 kernel/trace/ktrace.c

diff --git a/Makefile b/Makefile
index 66e7e97..26d3d60 100644
--- a/Makefile
+++ b/Makefile
@@ -577,7 +577,7 @@ ifdef CONFIG_DEBUG_INFO_REDUCED
 KBUILD_CFLAGS 	+= $(call cc-option, -femit-struct-debug-baseonly)
 endif
 
-ifdef CONFIG_FUNCTION_TRACER
+ifdef CONFIG_FTRACE_MCOUNT_RECORD
 KBUILD_CFLAGS	+= -pg
 ifdef CONFIG_DYNAMIC_FTRACE
 	ifdef CONFIG_HAVE_C_RECORDMCOUNT
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 95c36c4..a02718c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -38,7 +38,7 @@ config X86
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_GRAPH_FP_TEST
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
+	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE || KTRACE
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_KVM
 	select HAVE_ARCH_KGDB
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 34244b2..b664584 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -73,6 +73,7 @@ obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-y				+= apic/
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
+obj-$(CONFIG_KTRACE)		+= ktrace.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
 obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index aed1ffb..4d70019 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -62,6 +62,29 @@
 
 	.code64
 #ifdef CONFIG_FUNCTION_TRACER
+#ifdef CONFIG_KTRACE
+ENTRY(ktrace_callback)
+	cmpl $0, function_trace_stop
+	jne  ftrace_stub
+
+	cmpq $ftrace_stub, ftrace_trace_function
+	jnz ktrace_trace
+	retq
+
+ktrace_trace:
+	MCOUNT_SAVE_FRAME
+
+	movq 0x48(%rsp), %rdi
+	movq 0x50(%rsp), %rsi
+
+	call   *ftrace_trace_function
+
+	MCOUNT_RESTORE_FRAME
+
+	retq
+END(ktrace_callback)
+#endif /* CONFIG_KTRACE */
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 ENTRY(mcount)
 	retq
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 979ec14..ffa87f9 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -29,67 +29,7 @@
 #include <asm/nmi.h>
 
 
-#ifdef CONFIG_DYNAMIC_FTRACE
-
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
-int ftrace_arch_code_modify_prepare(void)
-{
-	set_kernel_text_rw();
-	set_all_modules_text_rw();
-	modifying_code = 1;
-	return 0;
-}
-
-int ftrace_arch_code_modify_post_process(void)
-{
-	modifying_code = 0;
-	set_all_modules_text_ro();
-	set_kernel_text_ro();
-	return 0;
-}
-
-union ftrace_code_union {
-	char code[MCOUNT_INSN_SIZE];
-	struct {
-		char e8;
-		int offset;
-	} __attribute__((packed));
-};
-
-static int ftrace_calc_offset(long ip, long addr)
-{
-	return (int)(addr - ip);
-}
-
-static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
-{
-	static union ftrace_code_union calc;
-
-	calc.e8		= 0xe8;
-	calc.offset	= ftrace_calc_offset(ip + MCOUNT_INSN_SIZE, addr);
-
-	/*
-	 * No locking needed, this must be called via kstop_machine
-	 * which in essence is like running on a uniprocessor machine.
-	 */
-	return calc.code;
-}
-
+#if defined(CONFIG_DYNAMIC_FTRACE) || defined(CONFIG_KTRACE)
 /*
  * Modifying code must take extra care. On an SMP machine, if
  * the code being modified is also being executed on another CPU
@@ -129,15 +69,21 @@ static int mod_code_size;		/* holds the size of the new code */
 static unsigned nmi_wait_count;
 static atomic_t nmi_update_count = ATOMIC_INIT(0);
 
-int ftrace_arch_read_dyn_info(char *buf, int size)
-{
-	int r;
-
-	r = snprintf(buf, size, "%u %u",
-		     nmi_wait_count,
-		     atomic_read(&nmi_update_count));
-	return r;
-}
+/*
+ * modifying_code is set to notify NMIs that they need to use
+ * memory barriers when entering or exiting. But we don't want
+ * to burden NMIs with unnecessary memory barriers when code
+ * modification is not being done (which is most of the time).
+ *
+ * A mutex is already held when ftrace_arch_code_modify_prepare
+ * and post_process are called. No locks need to be taken here.
+ *
+ * Stop machine will make sure currently running NMIs are done
+ * and new NMIs will see the updated variable before we need
+ * to worry about NMIs doing memory barriers.
+ */
+static int modifying_code __read_mostly;
+static DEFINE_PER_CPU(int, save_modifying_code);
 
 static void clear_mod_flag(void)
 {
@@ -226,7 +172,7 @@ within(unsigned long addr, unsigned long start, unsigned long end)
 }
 
 static int
-do_ftrace_mod_code(unsigned long ip, void *new_code, int size)
+__do_ftrace_mod_code(unsigned long ip, void *new_code, int size)
 {
 	/*
 	 * On x86_64, kernel text mappings are mapped read-only with
@@ -262,6 +208,67 @@ do_ftrace_mod_code(unsigned long ip, void *new_code, int size)
 	return mod_code_status;
 }
 
+int do_ftrace_mod_code(unsigned long ip, void *new_code, int size)
+{
+	return __do_ftrace_mod_code(ip, new_code, size);
+}
+
+int ftrace_arch_code_modify_post_process(void)
+{
+	modifying_code = 0;
+	set_all_modules_text_ro();
+	set_kernel_text_ro();
+	return 0;
+}
+
+int ftrace_arch_code_modify_prepare(void)
+{
+	set_kernel_text_rw();
+	set_all_modules_text_rw();
+	modifying_code = 1;
+	return 0;
+}
+
+#endif
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+int ftrace_arch_read_dyn_info(char *buf, int size)
+{
+	int r;
+
+	r = snprintf(buf, size, "%u %u",
+		     nmi_wait_count,
+		     atomic_read(&nmi_update_count));
+	return r;
+}
+
+union ftrace_code_union {
+	char code[MCOUNT_INSN_SIZE];
+	struct {
+		char e8;
+		int offset;
+	} __attribute__((packed));
+};
+
+static int ftrace_calc_offset(long ip, long addr)
+{
+	return (int)(addr - ip);
+}
+
+static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
+{
+	static union ftrace_code_union calc;
+
+	calc.e8		= 0xe8;
+	calc.offset	= ftrace_calc_offset(ip + MCOUNT_INSN_SIZE, addr);
+
+	/*
+	 * No locking needed, this must be called via kstop_machine
+	 * which in essence is like running on a uniprocessor machine.
+	 */
+	return calc.code;
+}
+
 static unsigned char *ftrace_nop_replace(void)
 {
 	return ideal_nop5;
@@ -292,7 +299,7 @@ ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		return -EINVAL;
 
 	/* replace the text with the new text */
-	if (do_ftrace_mod_code(ip, new_code, MCOUNT_INSN_SIZE))
+	if (__do_ftrace_mod_code(ip, new_code, MCOUNT_INSN_SIZE))
 		return -EPERM;
 
 	sync_core();
@@ -363,7 +370,7 @@ static int ftrace_mod_jmp(unsigned long ip,
 
 	*(int *)(&code[1]) = new_offset;
 
-	if (do_ftrace_mod_code(ip, &code, MCOUNT_INSN_SIZE))
+	if (__do_ftrace_mod_code(ip, &code, MCOUNT_INSN_SIZE))
 		return -EPERM;
 
 	return 0;
diff --git a/arch/x86/kernel/ktrace.c b/arch/x86/kernel/ktrace.c
new file mode 100644
index 0000000..2bfaa77
--- /dev/null
+++ b/arch/x86/kernel/ktrace.c
@@ -0,0 +1,256 @@
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/ftrace.h>
+#include <asm/insn.h>
+#include <asm/nops.h>
+#include <linux/kprobes.h>
+
+static void __used ktrace_template_holder(void)
+{
+	asm volatile (
+		".global ktrace_template_entry \n"
+		"ktrace_template_entry: \n"
+		"	pushfq \n"
+
+		".global ktrace_template_call \n"
+		"ktrace_template_call: \n"
+		ASM_NOP5
+
+		"	popfq \n"
+		/* eat ret value */
+		"	addq $8, %rsp \n"
+		".global ktrace_template_end \n"
+		"ktrace_template_end: \n"
+	);
+}
+
+extern u8 ktrace_template_entry;
+extern u8 ktrace_template_end;
+extern u8 ktrace_template_call;
+
+extern void ktrace_callback(void);
+
+#define TMPL_CALL_IDX \
+        ((long)&ktrace_template_call - (long)&ktrace_template_entry)
+
+#define TMPL_END_IDX \
+        ((long)&ktrace_template_end - (long)&ktrace_template_entry)
+
+#define RELATIVECALL_SIZE 5
+#define RELATIVE_ADDR_SIZE 4
+#define RELATIVECALL_OPCODE 0xe8
+#define RELATIVEJUMP_OPCODE 0xe9
+#define MAX_OPTIMIZED_LENGTH (MAX_INSN_SIZE + RELATIVE_ADDR_SIZE)
+
+#define MAX_KTRACE_INSN_SIZE                          \
+	(((unsigned long)&ktrace_template_end -       \
+	  (unsigned long)&ktrace_template_entry) +    \
+	MAX_OPTIMIZED_LENGTH + RELATIVECALL_SIZE)
+
+#define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
+	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
+	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
+	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
+	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
+	 << (row % 32))
+	/*
+	 * Undefined/reserved opcodes, conditional jump, Opcode Extension
+	 * Groups, and some special opcodes can not boost.
+	 */
+static const u32 twobyte_is_boostable[256 / 32] = {
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+	/*      ----------------------------------------------          */
+	W(0x00, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0) | /* 00 */
+	W(0x10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 10 */
+	W(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 20 */
+	W(0x30, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 30 */
+	W(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) | /* 40 */
+	W(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) , /* 50 */
+	W(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1) | /* 60 */
+	W(0x70, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1) , /* 70 */
+	W(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) | /* 80 */
+	W(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) , /* 90 */
+	W(0xa0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) | /* a0 */
+	W(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1) , /* b0 */
+	W(0xc0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) | /* c0 */
+	W(0xd0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) , /* d0 */
+	W(0xe0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) | /* e0 */
+	W(0xf0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0)   /* f0 */
+	/*      -----------------------------------------------         */
+	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
+};
+#undef W
+
+static int __copy_instruction(u8 *dest, u8 *src)
+{
+	struct insn insn;
+
+	kernel_insn_init(&insn, src);
+	insn_get_length(&insn);
+	memcpy(dest, insn.kaddr, insn.length);
+
+#ifdef CONFIG_X86_64
+	if (insn_rip_relative(&insn)) {
+		s64 newdisp;
+		u8 *disp;
+		kernel_insn_init(&insn, dest);
+		insn_get_displacement(&insn);
+		/*
+		 * The copied instruction uses the %rip-relative addressing
+		 * mode.  Adjust the displacement for the difference between
+		 * the original location of this instruction and the location
+		 * of the copy that will actually be run.  The tricky bit here
+		 * is making sure that the sign extension happens correctly in
+		 * this calculation, since we need a signed 32-bit result to
+		 * be sign-extended to 64 bits when it's added to the %rip
+		 * value and yield the same 64-bit result that the sign-
+		 * extension of the original signed 32-bit displacement would
+		 * have given.
+		 */
+		newdisp = (u8 *) src + (s64) insn.displacement.value -
+			  (u8 *) dest;
+		BUG_ON((s64) (s32) newdisp != newdisp); /* Sanity check.  */
+		disp = (u8 *) dest + insn_offset_displacement(&insn);
+		*(s32 *) disp = (s32) newdisp;
+	}
+#endif
+	return insn.length;
+}
+
+static int can_boost(u8 *opcodes)
+{
+	u8 opcode;
+	u8 *orig_opcodes = opcodes;
+
+	if (search_exception_tables((unsigned long)opcodes))
+		return 0;	/* Page fault may occur on this address. */
+
+retry:
+	if (opcodes - orig_opcodes > MAX_INSN_SIZE - 1)
+		return 0;
+	opcode = *(opcodes++);
+
+	/* 2nd-byte opcode */
+	if (opcode == 0x0f) {
+		if (opcodes - orig_opcodes > MAX_INSN_SIZE - 1)
+			return 0;
+		return test_bit(*opcodes,
+				(unsigned long *)twobyte_is_boostable);
+	}
+
+	switch (opcode & 0xf0) {
+#ifdef CONFIG_X86_64
+	case 0x40:
+		goto retry; /* REX prefix is boostable */
+#endif
+	case 0x60:
+		if (0x63 < opcode && opcode < 0x67)
+			goto retry; /* prefixes */
+		/* can't boost Address-size override and bound */
+		return (opcode != 0x62 && opcode != 0x67);
+	case 0x70:
+		return 0; /* can't boost conditional jump */
+	case 0xc0:
+		/* can't boost software-interruptions */
+		return (0xc1 < opcode && opcode < 0xcc) || opcode == 0xcf;
+	case 0xd0:
+		/* can boost AA* and XLAT */
+		return (opcode == 0xd4 || opcode == 0xd5 || opcode == 0xd7);
+	case 0xe0:
+		/* can boost in/out and absolute jmps */
+		return ((opcode & 0x04) || opcode == 0xea);
+	case 0xf0:
+		if ((opcode & 0x0c) == 0 && opcode != 0xf1)
+			goto retry; /* lock/rep(ne) prefix */
+		/* clear and set flags are boostable */
+		return (opcode == 0xf5 || (0xf7 < opcode && opcode < 0xfe));
+	default:
+		/* segment override prefixes are boostable */
+		if (opcode == 0x26 || opcode == 0x36 || opcode == 0x3e)
+			goto retry; /* prefixes */
+		/* CS override prefix and call are not boostable */
+		return (opcode != 0x2e && opcode != 0x9a);
+	}
+}
+
+static int copy_instructions(u8 *dest, u8 *src)
+{
+	int len = 0, ret;
+
+	while (len < RELATIVECALL_SIZE) {
+		ret = __copy_instruction(dest + len, src + len);
+		if (!ret || !can_boost(dest + len))
+			return -EINVAL;
+		len += ret;
+	}
+
+	return len;
+}
+
+static void synthesize_relative_insn(u8 *buf, void *from, void *to, u8 op)
+{
+	struct __arch_relative_insn {
+		u8 op;
+		s32 raddr;
+	} __attribute__((packed)) *insn;
+
+	insn = (struct __arch_relative_insn *) buf;
+	insn->raddr = (s32)((long)(to) - ((long)(from) + 5));
+	insn->op = op;
+}
+
+void ktrace_enable_sym(struct ktrace_symbol *ksym)
+{
+	u8 call_buf[RELATIVECALL_SIZE];
+
+	synthesize_relative_insn(call_buf,
+				 ksym->addr,
+				 ksym->insn_templ,
+				 RELATIVECALL_OPCODE);
+
+	do_ftrace_mod_code((unsigned long) ksym->addr,
+			   call_buf, RELATIVECALL_SIZE);
+	ksym->enabled = 1;
+}
+
+void ktrace_disable_sym(struct ktrace_symbol *ksym)
+{
+	do_ftrace_mod_code((unsigned long) ksym->addr,
+			   ksym->insn_saved,
+			   ksym->insn_saved_size);
+	ksym->enabled = 0;
+}
+
+int ktrace_init_template(struct ktrace_symbol *ksym)
+{
+	u8* insn_templ = ksym->insn_templ;
+	u8 *addr = ksym->addr;
+	int size;
+
+	size = copy_instructions(insn_templ + TMPL_END_IDX, addr);
+	if (size < 0)
+		return -EINVAL;
+
+	memcpy(insn_templ, &ktrace_template_entry, TMPL_END_IDX);
+
+	synthesize_relative_insn(insn_templ + TMPL_END_IDX + size,
+				 insn_templ + TMPL_END_IDX + size,
+				 addr + size,
+				 RELATIVEJUMP_OPCODE);
+
+	synthesize_relative_insn(insn_templ + TMPL_CALL_IDX,
+				 insn_templ + TMPL_CALL_IDX,
+				 ktrace_callback,
+				 RELATIVECALL_OPCODE);
+
+	ksym->insn_saved = insn_templ + TMPL_END_IDX;
+	ksym->insn_saved_size = size;
+	return 0;
+}
+
+int __init ktrace_arch_init(void)
+{
+	ktrace_insn_init(MAX_KTRACE_INSN_SIZE);
+	return 0;
+}
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index dcd6a7c..11c3d5b 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -116,9 +116,6 @@ struct ftrace_func_command {
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
-int ftrace_arch_code_modify_prepare(void);
-int ftrace_arch_code_modify_post_process(void);
-
 struct seq_file;
 
 struct ftrace_probe_ops {
@@ -530,4 +527,37 @@ unsigned long arch_syscall_addr(int nr);
 
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
+#ifdef CONFIG_KTRACE
+enum {
+	KTRACE_ENABLE,
+	KTRACE_DISABLE
+};
+
+struct ktrace_symbol {
+        struct list_head list;
+        int enabled;
+
+        u8 *addr;
+        u8 *insn_templ;
+        u8 *insn_saved;
+        int insn_saved_size;
+};
+
+extern void ktrace_init(void);
+extern int ktrace_init_template(struct ktrace_symbol *ksym);
+extern int ktrace_arch_init(void);
+extern void ktrace_startup(void);
+extern void ktrace_shutdown(void);
+extern void ktrace_enable_sym(struct ktrace_symbol *ksym);
+extern void ktrace_disable_sym(struct ktrace_symbol *ksym);
+#else
+static inline void ktrace_init(void) {}
+#endif /* CONFIG_KTRACE */
+
+#if defined CONFIG_DYNAMIC_FTRACE || defined CONFIG_KTRACE
+extern int do_ftrace_mod_code(unsigned long ip, void *new_code, int size);
+extern int ftrace_arch_code_modify_prepare(void);
+extern int ftrace_arch_code_modify_post_process(void);
+#endif
+
 #endif /* _LINUX_FTRACE_H */
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 14674dc..1cf0aba 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -140,8 +140,6 @@ if FTRACE
 
 config FUNCTION_TRACER
 	bool "Kernel Function Tracer"
-	depends on HAVE_FUNCTION_TRACER
-	select FRAME_POINTER if !ARM_UNWIND && !S390
 	select KALLSYMS
 	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
@@ -168,6 +166,30 @@ config FUNCTION_GRAPH_TRACER
 	  the return value. This is done by setting the current return
 	  address on the current task structure into a stack of calls.
 
+config KTRACE
+	bool
+	depends on FTRACER_ENG_KTRACE
+
+choice
+	prompt "Function trace engine"
+	default FTRACER_ENG_MCOUNT_RECORD
+	depends on FUNCTION_TRACER
+
+config FTRACER_ENG_MCOUNT_RECORD
+	bool "mcount"
+	depends on HAVE_FUNCTION_TRACER
+	select FRAME_POINTER if !ARM_UNWIND && !S390
+	help
+	  standard -pg mcount record generation
+
+config FTRACER_ENG_KTRACE
+	bool "ktrace"
+	select KTRACE
+	help
+	  dynamic call probes
+
+endchoice
+
 
 config IRQSOFF_TRACER
 	bool "Interrupts-off Latency Tracer"
@@ -389,6 +411,7 @@ config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
 	depends on FUNCTION_TRACER
 	depends on HAVE_DYNAMIC_FTRACE
+	depends on FTRACER_ENG_MCOUNT_RECORD
 	default y
 	help
           This option will modify all the calls to ftrace dynamically
@@ -422,6 +445,7 @@ config FTRACE_MCOUNT_RECORD
 	def_bool y
 	depends on DYNAMIC_FTRACE
 	depends on HAVE_FTRACE_MCOUNT_RECORD
+	depends on FTRACER_ENG_MCOUNT_RECORD
 
 config FTRACE_SELFTEST
 	bool
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 761c510..f557200 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -21,6 +21,7 @@ endif
 #
 obj-y += trace_clock.o
 
+obj-$(CONFIG_KTRACE) += ktrace.o
 obj-$(CONFIG_FUNCTION_TRACER) += libftrace.o
 obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
 obj-$(CONFIG_RING_BUFFER_BENCHMARK) += ring_buffer_benchmark.o
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f3dadae..762e2b3 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3152,7 +3152,12 @@ int register_ftrace_function(struct ftrace_ops *ops)
 	mutex_lock(&ftrace_lock);
 
 	ret = __register_ftrace_function(ops);
+
+#ifdef CONFIG_KTRACE
+	ktrace_startup();
+#else
 	ftrace_startup(0);
+#endif
 
 	mutex_unlock(&ftrace_lock);
 	return ret;
@@ -3170,7 +3175,13 @@ int unregister_ftrace_function(struct ftrace_ops *ops)
 
 	mutex_lock(&ftrace_lock);
 	ret = __unregister_ftrace_function(ops);
+
+#ifdef CONFIG_KTRACE
+	ktrace_shutdown();
+#else
 	ftrace_shutdown(0);
+#endif
+
 	mutex_unlock(&ftrace_lock);
 
 	return ret;
diff --git a/kernel/trace/ktrace.c b/kernel/trace/ktrace.c
new file mode 100644
index 0000000..3e45e2c
--- /dev/null
+++ b/kernel/trace/ktrace.c
@@ -0,0 +1,330 @@
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/kallsyms.h>
+#include <linux/ctype.h>
+#include <linux/slab.h>
+#include <linux/kprobes.h>
+#include <linux/slab.h>
+#include <linux/stop_machine.h>
+
+#include "trace.h"
+
+static DEFINE_MUTEX(symbols_mutex);
+static LIST_HEAD(symbols);
+
+static struct kmem_cache *symbols_cache;
+static int ktrace_disabled;
+static int ktrace_enabled;
+
+static void ktrace_enable_all(void);
+
+static struct ktrace_symbol* ktrace_find_symbol(u8 *addr)
+{
+	struct ktrace_symbol *ksym, *found = NULL;
+
+	mutex_lock(&symbols_mutex);
+
+	list_for_each_entry(ksym, &symbols, list) {
+		if (ksym->addr == addr) {
+			found = ksym;
+			break;
+		}
+	}
+
+	mutex_unlock(&symbols_mutex);
+	return found;
+}
+
+static int ktrace_unregister_symbol(struct ktrace_symbol *ksym)
+{
+	free_ktrace_insn_slot(ksym->insn_templ, 1);
+	kmem_cache_free(symbols_cache, ksym);
+	return 0;
+}
+
+static int ktrace_unregister_all_symbols(void)
+{
+	struct ktrace_symbol *ksym, *n;
+
+	if (ktrace_enabled)
+		return -EINVAL;
+
+	mutex_lock(&symbols_mutex);
+
+	list_for_each_entry_safe(ksym, n, &symbols, list) {
+		list_del(&ksym->list);
+		ktrace_unregister_symbol(ksym);
+	}
+
+	mutex_unlock(&symbols_mutex);
+	return 0;
+}
+
+static int ktrace_register_symbol(char *symbol)
+{
+	struct ktrace_symbol *ksym;
+	u8 *addr, *insn_templ;
+	int ret = -ENOMEM;
+
+	/* Is it really symbol address. */
+	addr = (void*) kallsyms_lookup_name(symbol);
+	if (!addr)
+		return -EINVAL;
+
+	/* Is it already registered. */
+	if (ktrace_find_symbol(addr))
+		return -EINVAL;
+
+	/* Register new symbol. */
+	ksym = kmem_cache_zalloc(symbols_cache, GFP_KERNEL);
+	if (!ksym)
+		return -ENOMEM;
+
+	insn_templ = get_ktrace_insn_slot();
+	if (!insn_templ)
+		goto err_release_ksym;
+
+	ksym->insn_templ = insn_templ;
+	ksym->addr = addr;
+
+	ret = ktrace_init_template(ksym);
+	if (ret)
+		goto err_release_insn;
+
+	mutex_lock(&symbols_mutex);
+	list_add(&ksym->list, &symbols);
+	mutex_unlock(&symbols_mutex);
+
+	return 0;
+
+ err_release_insn:
+	free_ktrace_insn_slot(insn_templ, 1);
+
+ err_release_ksym:
+	kmem_cache_free(symbols_cache, ksym);
+
+	return ret;
+}
+
+static inline int
+within(unsigned long addr, unsigned long start, unsigned long end)
+{
+	return addr >= start && addr < end;
+}
+
+static int ktrace_symbol(void *data, const char *symbol,
+		  struct module *mod, unsigned long addr)
+{
+	if (!within(addr, (unsigned long)_text, (unsigned long)_etext))
+		return 0;
+
+	ktrace_register_symbol((char*) symbol);
+	return 0;
+}
+
+static int ktrace_register_all(void)
+{
+	printk("not supported\n");
+	return 0;
+
+	kallsyms_on_each_symbol(ktrace_symbol, NULL);
+	return 0;
+}
+
+static void *ktrace_start(struct seq_file *m, loff_t *pos)
+{
+	mutex_lock(&symbols_mutex);
+
+	if (list_empty(&symbols) && (!*pos))
+		return (void *) 1;
+
+	return seq_list_start(&symbols, *pos);
+}
+
+static void *ktrace_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	if (v == (void *)1)
+		return NULL;
+
+	return seq_list_next(v, &symbols, pos);
+}
+
+static void ktrace_stop(struct seq_file *m, void *p)
+{
+	mutex_unlock(&symbols_mutex);
+}
+
+static int ktrace_show(struct seq_file *m, void *v)
+{
+	const struct ktrace_symbol *ksym = list_entry(v, struct ktrace_symbol, list);
+
+	if (v == (void *)1) {
+		seq_printf(m, "no symbol\n");
+		return 0;
+	}
+
+	seq_printf(m, "%ps\n", ksym->addr);
+	return 0;
+}
+
+static const struct seq_operations ktrace_sops = {
+        .start = ktrace_start,
+        .next = ktrace_next,
+        .stop = ktrace_stop,
+        .show = ktrace_show,
+};
+
+static int
+ktrace_open(struct inode *inode, struct file *file)
+{
+	int ret = 0;
+
+	if ((file->f_mode & FMODE_WRITE) &&
+	    (file->f_flags & O_TRUNC))
+		ktrace_unregister_all_symbols();
+
+	if (file->f_mode & FMODE_READ)
+		ret = seq_open(file, &ktrace_sops);
+
+	return ret;
+}
+
+static ssize_t
+ktrace_write(struct file *filp, const char __user *ubuf,
+                      size_t cnt, loff_t *ppos)
+{
+#define SYMMAX 50
+	char symbol[SYMMAX];
+	int ret, i;
+
+	if (cnt >= SYMMAX)
+		return -EINVAL;
+
+	if (copy_from_user(&symbol, ubuf, cnt))
+		return -EFAULT;
+
+	symbol[cnt] = 0;
+
+	for (i = cnt - 1;
+	     i >= 0 && (isspace(symbol[i]) || (symbol[i] == '\n')); i--)
+		symbol[i] = 0;
+
+	if (!symbol[0])
+		return cnt;
+
+	if (!strcmp(symbol, "all"))
+		ret = ktrace_register_all();
+	else
+		ret = ktrace_register_symbol(symbol);
+
+	if (ret)
+		return ret;
+
+	if (ktrace_enabled)
+		ktrace_startup();
+
+	return ret ? ret : cnt;
+}
+
+static const struct file_operations ktrace_fops = {
+	.open           = ktrace_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.write          = ktrace_write,
+};
+
+static void ktrace_enable_all(void)
+{
+	struct ktrace_symbol *ksym;
+
+	list_for_each_entry(ksym, &symbols, list) {
+		if (ksym->enabled)
+			continue;
+
+		ktrace_enable_sym(ksym);
+	}
+
+	ktrace_enabled = 1;
+}
+
+static void ktrace_disable_all(void)
+{
+	struct ktrace_symbol *ksym;
+
+	list_for_each_entry(ksym, &symbols, list) {
+		if (ksym->enabled)
+			continue;
+
+		ktrace_disable_sym(ksym);
+	}
+
+	ktrace_enabled = 0;
+}
+
+static int __ktrace_modify_code(void *data)
+{
+	int *command = data;
+
+	if (*command == KTRACE_ENABLE)
+		ktrace_enable_all();
+
+	if (*command == KTRACE_DISABLE)
+		ktrace_disable_all();
+
+	return 0;
+}
+
+#define FTRACE_WARN_ON(cond)	\
+do {				\
+	if (WARN_ON(cond))	\
+	ftrace_kill();		\
+} while (0)
+
+static void ktrace_run_update_code(int command)
+{
+	int ret;
+
+	if (ktrace_disabled)
+		return;
+
+	ret = ftrace_arch_code_modify_prepare();
+	FTRACE_WARN_ON(ret);
+	if (ret)
+		return;
+
+	stop_machine(__ktrace_modify_code, &command, NULL);
+
+	ret = ftrace_arch_code_modify_post_process();
+	FTRACE_WARN_ON(ret);
+}
+
+void ktrace_startup(void)
+{
+	ktrace_run_update_code(KTRACE_ENABLE);
+}
+
+void ktrace_shutdown(void)
+{
+	ktrace_run_update_code(KTRACE_DISABLE);
+}
+
+void __init ktrace_init(void)
+{
+	struct dentry *d_tracer = tracing_init_dentry();
+
+	trace_create_file("ktrace", 0644, d_tracer,
+			NULL, &ktrace_fops);
+
+	symbols_cache = KMEM_CACHE(ktrace_symbol, 0);
+	if (!symbols_cache) {
+		printk("ktrace disabled - kmem cache allocation failed\n");
+		ktrace_disabled = 1;
+		return;
+	}
+
+	ktrace_arch_init();
+	printk("ktrace initialized\n");
+}
+
+MODULE_LICENSE("GPL");
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dc53ecb..b901c94 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4361,6 +4361,7 @@ static __init int tracer_init_debugfs(void)
 	for_each_tracing_cpu(cpu)
 		tracing_init_debugfs_percpu(cpu);
 
+	ktrace_init();
 	return 0;
 }
 
-- 
1.7.1

