Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab0J0VH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 17:07:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230Ab0J0VHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 17:07:51 -0400
Date: Wed, 27 Oct 2010 17:07:13 -0400
From: Jason Baron <jbaron@redhat.com>
To: rostedt@goodmis.org, mingo@elte.hu
Cc: mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, ddaney@caviumnetworks.com, dsd@laptop.org,
        linux-kernel@vger.kernel.org
Message-Id: <2de96f2012e81597079ab0b09a1487e7061b9cc6.1288212486.git.jbaron@redhat.com>
In-Reply-To: <cover.1288212485.git.jbaron@redhat.com>
References: <cover.1288212485.git.jbaron@redhat.com>
Subject: [PATCH 1/2] move arch_init_ideal_nop5 later
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_init_ideal_nop5() was being called from setup_arch() before
the exception table was setup. Move it later into
alternative_instructions().

Fixes a boot hang on OLPC's XO-1 laptop based on Geode LX
processor.


Reported-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/include/asm/alternative.h |    1 -
 arch/x86/kernel/alternative.c      |  132 ++++++++++++++++++------------------
 arch/x86/kernel/setup.c            |    6 --
 3 files changed, 67 insertions(+), 72 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 76561d2..2a7f618 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -186,7 +186,6 @@ extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
 #if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
 #define IDEAL_NOP_SIZE_5 5
 extern unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
-extern void arch_init_ideal_nop5(void);
 #else
 static inline void arch_init_ideal_nop5(void) {}
 #endif
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index a36bb90..9f39a1c 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -452,6 +452,71 @@ extern struct paravirt_patch_site __start_parainstructions[],
 	__stop_parainstructions[];
 #endif	/* CONFIG_PARAVIRT */
 
+#if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
+
+unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
+
+static void __init arch_init_ideal_nop5(void)
+{
+	extern const unsigned char ftrace_test_p6nop[];
+	extern const unsigned char ftrace_test_nop5[];
+	extern const unsigned char ftrace_test_jmp[];
+	int faulted = 0;
+
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
+}
+#endif
+
 void __init alternative_instructions(void)
 {
 	/* The patching is not fully atomic, so try to avoid local interruptions
@@ -508,6 +573,8 @@ void __init alternative_instructions(void)
 				(unsigned long)__smp_locks_end);
 
 	restart_nmi();
+
+	arch_init_ideal_nop5();
 }
 
 /**
@@ -641,68 +708,3 @@ void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
 	__stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
 	return addr;
 }
-
-#if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
-
-unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
-
-void __init arch_init_ideal_nop5(void)
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
-		memcpy(ideal_nop5, ftrace_test_p6nop, IDEAL_NOP_SIZE_5);
-		break;
-	case 1:
-		pr_info("converting mcount calls to 66 66 66 66 90\n");
-		memcpy(ideal_nop5, ftrace_test_nop5, IDEAL_NOP_SIZE_5);
-		break;
-	case 2:
-		pr_info("converting mcount calls to jmp . + 5\n");
-		memcpy(ideal_nop5, ftrace_test_jmp, IDEAL_NOP_SIZE_5);
-		break;
-	}
-
-}
-#endif
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 0ac571d..850059d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -112,7 +112,6 @@
 #include <asm/numa_64.h>
 #endif
 #include <asm/mce.h>
-#include <asm/alternative.h>
 
 /*
  * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
@@ -695,7 +694,6 @@ void __init setup_arch(char **cmdline_p)
 {
 	int acpi = 0;
 	int k8 = 0;
-	unsigned long flags;
 
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
@@ -1055,10 +1053,6 @@ void __init setup_arch(char **cmdline_p)
 	x86_init.oem.banner();
 
 	mcheck_init();
-
-	local_irq_save(flags);
-	arch_init_ideal_nop5();
-	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_X86_32
-- 
1.7.1

