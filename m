Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab0DITu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 15:50:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959Ab0DITuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 15:50:21 -0400
Date: Fri, 9 Apr 2010 15:49:52 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
       fweisbec@gmail.com, avi@redhat.com
Message-Id: <5af00b8b556dd239d7666df4a56eac91d6ef27b6.1270839564.git.jbaron@redhat.com>
In-Reply-To: <cover.1270839564.git.jbaron@redhat.com>
References: <cover.1270839564.git.jbaron@redhat.com>
Subject: [PATCH 6/9] jump label: move ftrace_dyn_arch_init to common code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move Steve's code for finding the best 5-byte no-op from ftrace.c to alternative.c.
The idea is that other consumers (in this case jump label) want to make use of
that code. I've created a global: 'char ideal_nop[5]', that is setup during
setup_arch that can be used.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/include/asm/alternative.h |   14 +++++++
 arch/x86/include/asm/jump_label.h  |   10 ++----
 arch/x86/kernel/alternative.c      |   71 +++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/ftrace.c           |   70 +-----------------------------------
 arch/x86/kernel/jump_label.c       |   15 +-------
 arch/x86/kernel/module.c           |    3 ++
 arch/x86/kernel/setup.c            |    2 +
 include/linux/jump_label.h         |    9 +++++
 kernel/jump_label.c                |   33 +++++++++++++++++
 kernel/trace/ftrace.c              |   13 +------
 10 files changed, 137 insertions(+), 103 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index b09ec55..0218dbd 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -5,6 +5,7 @@
 #include <linux/stddef.h>
 #include <linux/stringify.h>
 #include <asm/asm.h>
+#include <asm/jump_label.h>
 
 /*
  * Alternative inline assembly for SMP.
@@ -153,6 +154,8 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
 #define __parainstructions_end	NULL
 #endif
 
+extern void *text_poke_early(void *addr, const void *opcode, size_t len);
+
 /*
  * Clear and restore the kernel write-protection flag on the local CPU.
  * Allows the kernel to edit read-only pages.
@@ -173,4 +176,15 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
 
+#if defined(CONFIG_DYNAMIC_FTRACE) || defined(__HAVE_ARCH_JUMP_LABEL)
+#define IDEAL_NOP_SIZE_5 5
+extern unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
+extern int arch_init_ideal_nop5(void);
+#else
+static inline arch_init_ideal_nop5(void)
+{
+	return 0;
+}
+#endif
+
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index b8ebdc8..e3af6ca 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -9,23 +9,19 @@
 
 #ifdef __HAVE_ARCH_JUMP_LABEL
 
-# ifdef CONFIG_X86_64
-#  define JUMP_LABEL_NOP P6_NOP5
-# else
-#  define JUMP_LABEL_NOP ".byte 0xe9 \n\t .long 0\n\t"
-# endif
+# define JUMP_LABEL_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
 
 # define JUMP_LABEL(tag, label, cond)				\
 	do {							\
 		extern const char __jlstrtab_##tag[];		\
 		asm goto("1:"					\
-			JUMP_LABEL_NOP				\
+			JUMP_LABEL_INITIAL_NOP			\
 			".pushsection __jump_table,  \"a\" \n\t"\
 			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
 			".popsection \n\t"			\
 			: :  "i" (__jlstrtab_##tag) :  : label);\
 	} while (0)
 
-# endif
+#endif
 
 #endif
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 3a4bf35..083ce9d 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -194,7 +194,6 @@ static void __init_or_module add_nops(void *insns, unsigned int len)
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern u8 *__smp_locks[], *__smp_locks_end[];
-static void *text_poke_early(void *addr, const void *opcode, size_t len);
 
 /* Replace instructions with better alternatives for this CPU type.
    This runs before SMP is initialized to avoid SMP problems with
@@ -513,7 +512,7 @@ void __init alternative_instructions(void)
  * instructions. And on the local CPU you need to be protected again NMI or MCE
  * handlers seeing an inconsistent instruction while you patch.
  */
-static void *__init_or_module text_poke_early(void *addr, const void *opcode,
+void *__init_or_module text_poke_early(void *addr, const void *opcode,
 					      size_t len)
 {
 	unsigned long flags;
@@ -632,3 +631,71 @@ void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
 	return addr;
 }
 
+#if defined(CONFIG_DYNAMIC_FTRACE) || defined(__HAVE_ARCH_JUMP_LABEL)
+
+unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
+
+int __init arch_init_ideal_nop5(void)
+{
+	extern const unsigned char ftrace_test_p6nop[];
+	extern const unsigned char ftrace_test_nop5[];
+	extern const unsigned char ftrace_test_jmp[];
+	int faulted = 0;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	/*
+	 * There is no good nop for all x86 archs.
+	 * We will default to using the P6_NOP5, but first we
+	 * will test to make sure that the nop will actually
+	 * work on this CPU. If it faults, we will then
+	 * go to a lesser efficient 5 byte nop. If that fails
+	 * we then just use a jmp as our nop. This isn't the most
+	 * efficient nop, but we can not use a multi part nop
+	 * since we would then risk being preempted in the middle
+	 * of that nop, and if we enabled tracing then, it might
+	 * cause a system crash.
+	 *
+	 * TODO: check the cpuid to determine the best nop.
+	 */
+	asm volatile (
+		"ftrace_test_jmp:"
+		"jmp ftrace_test_p6nop\n"
+		"nop\n"
+		"nop\n"
+		"nop\n"  /* 2 byte jmp + 3 bytes */
+		"ftrace_test_p6nop:"
+		P6_NOP5
+		"jmp 1f\n"
+		"ftrace_test_nop5:"
+		".byte 0x66,0x66,0x66,0x66,0x90\n"
+		"1:"
+		".section .fixup, \"ax\"\n"
+		"2:	movl $1, %0\n"
+		"	jmp ftrace_test_nop5\n"
+		"3:	movl $2, %0\n"
+		"	jmp 1b\n"
+		".previous\n"
+		_ASM_EXTABLE(ftrace_test_p6nop, 2b)
+		_ASM_EXTABLE(ftrace_test_nop5, 3b)
+		: "=r"(faulted) : "0" (faulted));
+
+	switch (faulted) {
+	case 0:
+		pr_info("converting mcount calls to 0f 1f 44 00 00\n");
+		memcpy(ideal_nop5, ftrace_test_p6nop, IDEAL_NOP_SIZE_5);
+		break;
+	case 1:
+		pr_info("converting mcount calls to 66 66 66 66 90\n");
+		memcpy(ideal_nop5, ftrace_test_nop5, IDEAL_NOP_SIZE_5);
+		break;
+	case 2:
+		pr_info("converting mcount calls to jmp . + 5\n");
+		memcpy(ideal_nop5, ftrace_test_jmp, IDEAL_NOP_SIZE_5);
+		break;
+	}
+
+	local_irq_restore(flags);
+	return 0;
+}
+#endif
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index cd37469..ba2e0d9 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -257,14 +257,9 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
 	return mod_code_status;
 }
 
-
-
-
-static unsigned char ftrace_nop[MCOUNT_INSN_SIZE];
-
 static unsigned char *ftrace_nop_replace(void)
 {
-	return ftrace_nop;
+	return ideal_nop5;
 }
 
 static int
@@ -336,69 +331,6 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ret;
 }
 
-int __init ftrace_dyn_arch_init(void *data)
-{
-	extern const unsigned char ftrace_test_p6nop[];
-	extern const unsigned char ftrace_test_nop5[];
-	extern const unsigned char ftrace_test_jmp[];
-	int faulted = 0;
-
-	/*
-	 * There is no good nop for all x86 archs.
-	 * We will default to using the P6_NOP5, but first we
-	 * will test to make sure that the nop will actually
-	 * work on this CPU. If it faults, we will then
-	 * go to a lesser efficient 5 byte nop. If that fails
-	 * we then just use a jmp as our nop. This isn't the most
-	 * efficient nop, but we can not use a multi part nop
-	 * since we would then risk being preempted in the middle
-	 * of that nop, and if we enabled tracing then, it might
-	 * cause a system crash.
-	 *
-	 * TODO: check the cpuid to determine the best nop.
-	 */
-	asm volatile (
-		"ftrace_test_jmp:"
-		"jmp ftrace_test_p6nop\n"
-		"nop\n"
-		"nop\n"
-		"nop\n"  /* 2 byte jmp + 3 bytes */
-		"ftrace_test_p6nop:"
-		P6_NOP5
-		"jmp 1f\n"
-		"ftrace_test_nop5:"
-		".byte 0x66,0x66,0x66,0x66,0x90\n"
-		"1:"
-		".section .fixup, \"ax\"\n"
-		"2:	movl $1, %0\n"
-		"	jmp ftrace_test_nop5\n"
-		"3:	movl $2, %0\n"
-		"	jmp 1b\n"
-		".previous\n"
-		_ASM_EXTABLE(ftrace_test_p6nop, 2b)
-		_ASM_EXTABLE(ftrace_test_nop5, 3b)
-		: "=r"(faulted) : "0" (faulted));
-
-	switch (faulted) {
-	case 0:
-		pr_info("converting mcount calls to 0f 1f 44 00 00\n");
-		memcpy(ftrace_nop, ftrace_test_p6nop, MCOUNT_INSN_SIZE);
-		break;
-	case 1:
-		pr_info("converting mcount calls to 66 66 66 66 90\n");
-		memcpy(ftrace_nop, ftrace_test_nop5, MCOUNT_INSN_SIZE);
-		break;
-	case 2:
-		pr_info("converting mcount calls to jmp . + 5\n");
-		memcpy(ftrace_nop, ftrace_test_jmp, MCOUNT_INSN_SIZE);
-		break;
-	}
-
-	/* The return code is retured via data */
-	*(unsigned long *)data = 0;
-
-	return 0;
-}
 #endif
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 7fc4f84..8eca1b8 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -30,19 +30,8 @@ void arch_jump_label_transform(struct jump_entry *entry, enum jump_label_type ty
 	if (type == JUMP_LABEL_ENABLE) {
 		code.jump = 0xe9;
 		code.offset = entry->target - (entry->code + RELATIVEJUMP_SIZE);
-	} else {
-#ifdef CONFIG_X86_64
-		/* opcode for P6_NOP5 */
-		code.code[0] = 0x0f;
-		code.code[1] = 0x1f;
-		code.code[2] = 0x44;
-		code.code[3] = 0x00;
-		code.code[4] = 0x00;
-#else
-		code.jump = 0xe9;
-		code.offset = 0;
-#endif
-	}
+	} else
+		memcpy(&code, ideal_nop5, 5);
 	get_online_cpus();
 	mutex_lock(&text_mutex);
 	text_poke_smp((void *)entry->code, &code, RELATIVEJUMP_SIZE);
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 89f386f..e47fe49 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -238,6 +238,9 @@ int module_finalize(const Elf_Ehdr *hdr,
 		apply_paravirt(pseg, pseg + para->sh_size);
 	}
 
+	/* make jump label nops */
+	apply_jump_label_nops(me);
+
 	return module_bug_finalize(hdr, sechdrs, me);
 }
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 5d7ba1a..7a4577a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1040,6 +1040,8 @@ void __init setup_arch(char **cmdline_p)
 	x86_init.oem.banner();
 
 	mcheck_init();
+
+	arch_init_ideal_nop5();
 }
 
 #ifdef CONFIG_X86_32
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index e0f968d..9868c43 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -14,6 +14,8 @@ enum jump_label_type {
 	JUMP_LABEL_DISABLE
 };
 
+struct module;
+
 #ifdef __HAVE_ARCH_JUMP_LABEL
 
 extern struct jump_entry __start___jump_table[];
@@ -29,6 +31,8 @@ extern void arch_jump_label_transform(struct jump_entry *entry,
 
 extern void jump_label_update(const char *name, enum jump_label_type type);
 
+extern void apply_jump_label_nops(struct module *mod);
+
 #define enable_jump_label(name) \
 	jump_label_update(name, JUMP_LABEL_ENABLE);
 
@@ -55,6 +59,11 @@ static inline int disable_jump_label(const char *name)
 	return 0;
 }
 
+static inline int apply_jump_label_nops(struct module *mod)
+{
+	return 0;
+}
+
 #endif
 
 #endif
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 0714c20..7e7458b 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -182,10 +182,19 @@ void jump_label_update(const char *name, enum jump_label_type type)
 static int init_jump_label(void)
 {
 	int ret;
+	struct jump_entry *iter_start = __start___jump_table;
+	struct jump_entry *iter_stop = __start___jump_table;
+	struct jump_entry *iter;
 
 	mutex_lock(&jump_label_mutex);
 	ret = build_jump_label_hashtable(__start___jump_table,
 					 __stop___jump_table);
+	/* update with ideal nop */
+	iter = iter_start;
+	while (iter < iter_stop) {
+		text_poke_early((void *)iter->code, ideal_nop5, IDEAL_NOP_SIZE_5);
+		iter++;
+	}
 	mutex_unlock(&jump_label_mutex);
 	return ret;
 }
@@ -296,6 +305,30 @@ static int jump_label_module_notify(struct notifier_block *self, unsigned long v
 	return ret;
 }
 
+/***
+ * apply_jump_label_nops - patch module jump labels with ideal_nop5
+ * @mod: module to patch
+ *
+ * When a module is intially loaded the code has 'jump 5' instructions
+ * as nops. These are not the most optimal nops, so before the module
+ * loads patch these with the 'ideal_nop5', which was determined boot
+ * time.
+ */
+void apply_jump_label_nops(struct module *mod)
+{
+	struct jump_entry *iter;
+
+	/* if the module doesn't have jump label entries, just return */
+	if (!mod->num_jump_entries)
+		return;
+
+	iter = mod->jump_entries;
+	while (iter < mod->jump_entries + mod->num_jump_entries) {
+		text_poke_early((void *)iter->code, ideal_nop5, IDEAL_NOP_SIZE_5);
+		iter++;
+	}
+}
+
 struct notifier_block jump_label_module_nb = {
 	.notifier_call = jump_label_module_notify,
 	.priority = 0,
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8378357..abe6eaf 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2725,20 +2725,9 @@ extern unsigned long __stop_mcount_loc[];
 
 void __init ftrace_init(void)
 {
-	unsigned long count, addr, flags;
+	unsigned long count;
 	int ret;
 
-	/* Keep the ftrace pointer to the stub */
-	addr = (unsigned long)ftrace_stub;
-
-	local_irq_save(flags);
-	ftrace_dyn_arch_init(&addr);
-	local_irq_restore(flags);
-
-	/* ftrace_dyn_arch_init places the return code in addr */
-	if (addr)
-		goto failed;
-
 	count = __stop_mcount_loc - __start_mcount_loc;
 
 	ret = ftrace_dyn_table_alloc(count);
-- 
1.7.0.1

