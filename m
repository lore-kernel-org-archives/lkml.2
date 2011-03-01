Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab1CAA3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 19:29:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:8036 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab1CAA3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 19:29:14 -0500
From: Simon Glass <sjg@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        Simon Glass <sjg@chromium.org>
Subject: [RFC PATCH] ARM: Use generic BUG() handler
Date: Mon, 28 Feb 2011 16:27:43 -0800
Message-Id: <1298939263-16421-1-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am looking for comments please on this patch.

ARM uses its own BUG() handler which makes its output slightly different
from other archtectures.

One of the problems is that the ARM implementation doesn't report the function
with the BUG() in it, but always reports the PC being in __bug(). The generic
implementation doesn't have this problem.

Currently we get something like:

kernel BUG at fs/proc/breakme.c:35!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
...
PC is at __bug+0x20/0x2c

With this patch it displays:

kernel BUG at fs/proc/breakme.c:35!
Internal error: Oops - undefined instruction: 0 [#1] PREEMPT SMP
...
PC is at write_breakme+0xd0/0x1b4

This implementation uses an undefined instruction to implement BUG, and sets up
a bug table containing the relevant information.

Also backtraces were reported slightly differently - so I have added a newline
after the backtrace message, a space before the address, and ensured that the
message appears even when CONFIG_ARM_UNWIND is defined. These are aimed at
consistency between architectures, and may or may not be acceptable for ARM.
In any case they may be best as a separate patch.

Change-Id: I515db9a04e98084e6bbb21c4a1d13579568a0904

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 arch/arm/Kconfig              |    4 ++++
 arch/arm/include/asm/bug.h    |   40 +++++++++++++++++++++++++++++++++++++++-
 arch/arm/kernel/traps.c       |   21 +++++++++++++++++++--
 arch/arm/kernel/unwind.c      |    1 +
 arch/arm/kernel/vmlinux.lds.S |   15 +++++++++++++--
 5 files changed, 76 insertions(+), 5 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 26d45e5..d4fb0fb 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -191,6 +191,10 @@ config VECTORS_BASE
 	help
 	  The base address of exception vectors.
 
+config GENERIC_BUG
+	def_bool y
+	depends on BUG
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/arm/include/asm/bug.h b/arch/arm/include/asm/bug.h
index 4d88425..bbbebe4 100644
--- a/arch/arm/include/asm/bug.h
+++ b/arch/arm/include/asm/bug.h
@@ -3,6 +3,40 @@
 
 
 #ifdef CONFIG_BUG
+
+#ifdef CONFIG_GENERIC_BUG
+
+
+/* A suitable undefined instruction to use for ARM bug handling */
+#define BUG_INSTR_ARM 0xec000000
+
+
+#ifdef CONFIG_DEBUG_BUGVERBOSE
+#define BUG()							\
+do {								\
+	asm volatile("1:\t.word %c3\n"				\
+		     ".pushsection __bug_table,\"a\"\n"		\
+		     "2:\t.word 1b, %c0\n"			\
+		     "\t.hword %c1, 0\n"			\
+		     "\t.org 2b+%c2\n"				\
+		     ".popsection"				\
+		     :						\
+		     : "i" (__FILE__), "i" (__LINE__),		\
+		     "i" (sizeof(struct bug_entry)),		\
+		     "i" (BUG_INSTR_ARM));			\
+	unreachable();						\
+} while (0)
+
+#else
+#define BUG()							\
+do {								\
+	asm volatile("ud2");					\
+	unreachable();						\
+} while (0)
+#endif
+
+#else  /* not CONFIG_GENERIC_BUG */
+
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 extern void __bug(const char *file, int line) __attribute__((noreturn));
 
@@ -16,8 +50,12 @@ extern void __bug(const char *file, int line) __attribute__((noreturn));
 
 #endif
 
+#endif  /* CONFIG_GENERIC_BUG */
+
 #define HAVE_ARCH_BUG
-#endif
+
+#endif /* CONFIG_BUG */
+
 
 #include <asm-generic/bug.h>
 
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index ee57640..d5e5df9 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -21,6 +21,7 @@
 #include <linux/kdebug.h>
 #include <linux/module.h>
 #include <linux/kexec.h>
+#include <linux/bug.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 
@@ -55,7 +56,8 @@ static void dump_mem(const char *, const char *, unsigned long, unsigned long);
 void dump_backtrace_entry(unsigned long where, unsigned long from, unsigned long frame)
 {
 #ifdef CONFIG_KALLSYMS
-	printk("[<%08lx>] (%pS) from [<%08lx>] (%pS)\n", where, (void *)where, from, (void *)from);
+	printk(" [<%08lx>] (%pS) from [<%08lx>] (%pS)\n", where, (void *)where,
+	       from, (void *)from);
 #else
 	printk("Function entered at [<%08lx>] from [<%08lx>]\n", where, from);
 #endif
@@ -171,7 +173,7 @@ static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 	unsigned int fp, mode;
 	int ok = 1;
 
-	printk("Backtrace: ");
+	printk("Backtrace:\n");
 
 	if (!tsk)
 		tsk = current;
@@ -271,6 +273,8 @@ void die(const char *str, struct pt_regs *regs, int err)
 	spin_lock_irq(&die_lock);
 	console_verbose();
 	bust_spinlocks(1);
+	if (!user_mode(regs))
+		report_bug(regs->ARM_pc, regs);
 	ret = __die(str, err, thread, regs);
 
 	if (regs && kexec_should_crash(thread->task))
@@ -302,6 +306,19 @@ void arm_notify_die(const char *str, struct pt_regs *regs,
 	}
 }
 
+int is_valid_bugaddr(unsigned long pc)
+{
+	unsigned bkpt;
+
+	if (pc < PAGE_OFFSET)
+		return 0;
+	if (probe_kernel_address((unsigned *)pc, bkpt))
+		return 0;
+
+	return bkpt == BUG_INSTR_ARM;
+}
+
+
 static LIST_HEAD(undef_hook);
 static DEFINE_SPINLOCK(undef_lock);
 
diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index d2cb0b3..3f065bd 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -355,6 +355,7 @@ void unwind_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 	register unsigned long current_sp asm ("sp");
 
 	pr_debug("%s(regs = %p tsk = %p)\n", __func__, regs, tsk);
+	printk("Backtrace:\n");
 
 	if (!tsk)
 		tsk = current;
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index 86b66f3..591ab50 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -72,6 +72,18 @@ SECTIONS
 
 	PERCPU(PAGE_SIZE)
 
+	/*
+	 * .exit.text is discarded at runtime, not link time, to deal with
+	 *  references from bug_table
+	 */
+	.exit.text : AT(ADDR(.exit.text)) {
+		EXIT_TEXT
+	}
+
+	.exit.data : AT(ADDR(.exit.data)) {
+		EXIT_DATA
+	}
+
 #ifndef CONFIG_XIP_KERNEL
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
@@ -246,7 +258,6 @@ SECTIONS
 		__tcm_end = .;
 	}
 #endif
-
 	BSS_SECTION(0, 0, 0)
 	_end = .;
 
@@ -254,7 +265,7 @@ SECTIONS
 	.comment 0 : { *(.comment) }
 
 	/* Default discards */
-	DISCARDS
+	/*DISCARDS*/
 
 #ifndef CONFIG_SMP_ON_UP
 	/DISCARD/ : {
-- 
1.7.3.1

