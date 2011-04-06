Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab1DFXUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 19:20:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62293 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab1DFXUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 19:20:16 -0400
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
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Dave Martin <dave.martin@linaro.org>, Simon Glass <sjg@google.com>,
        Simon Glass <sjg@chromium.org>
Subject: [PATCH v3] ARM: Use generic BUG() handler
Date: Wed,  6 Apr 2011 16:18:10 -0700
Message-Id: <1302131890-20953-1-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Glass <sjg@google.com>

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
a bug table containing the relevant information. Many versions of gcc do not
support %c properly for ARM (inserting a # when they shouldn't) so we work
around this using distasteful macro magic.

v1: Initial version to replace existing ARM BUG() implementation with something
more similar to other architectures.

v2: Add Thumb support, remove backtrace whitespace output changes. Change to
use macros instead of requiring the asm %d flag to work (thanks to
Dave Martin <dave.martin@linaro.org>)

v3: Remove old BUG() implementation in favor of this one.
Remove the Backtrace: message (will submit this separately).
Use ARM_EXIT_KEEP() so that some architectures can dump exit text at link time
thanks to Stephen Boyd <sboyd@codeaurora.org> (although since we always
define GENERIC_BUG this might be academic.)
Rebase to linux-2.6.git master.

Change-Id: I07d77c832e816f5ad2390e25f466ddf750adecf4

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 arch/arm/Kconfig              |    4 +++
 arch/arm/include/asm/bug.h    |   55 ++++++++++++++++++++++++++++++++++------
 arch/arm/kernel/traps.c       |   23 +++++++++++++++++
 arch/arm/kernel/vmlinux.lds.S |    3 +-
 4 files changed, 75 insertions(+), 10 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5b9f78b..7d7df40 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -207,6 +207,10 @@ config ARM_PATCH_PHYS_VIRT_16BIT
 	def_bool y
 	depends on ARM_PATCH_PHYS_VIRT && ARCH_MSM
 
+config GENERIC_BUG
+	def_bool y
+	depends on BUG
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/arm/include/asm/bug.h b/arch/arm/include/asm/bug.h
index 4d88425..2914724 100644
--- a/arch/arm/include/asm/bug.h
+++ b/arch/arm/include/asm/bug.h
@@ -3,21 +3,58 @@
 
 
 #ifdef CONFIG_BUG
-#ifdef CONFIG_DEBUG_BUGVERBOSE
-extern void __bug(const char *file, int line) __attribute__((noreturn));
-
-/* give file/line information */
-#define BUG()		__bug(__FILE__, __LINE__)
 
+/*
+ * Use a suitable undefined instruction to use for ARM/Thumb2 bug handling.
+ * We need to be careful not to conflict with those used by other modules and
+ * the register_undef_hook() system.
+ */
+#ifdef CONFIG_THUMB2_KERNEL
+#define BUG_INSTR_VALUE 0xde02
+#define BUG_INSTR_TYPE ".hword "
 #else
+#define BUG_INSTR_VALUE 0xe7f001f2
+#define BUG_INSTR_TYPE ".word "
+#endif
 
-/* this just causes an oops */
-#define BUG()		do { *(int *)0 = 0; } while (1)
 
-#endif
+#define BUG() _BUG(__FILE__, __LINE__, BUG_INSTR_VALUE)
+#define _BUG(file, line, value) __BUG(file, line, value)
+
+#ifdef CONFIG_DEBUG_BUGVERBOSE
+
+/*
+ * The extra indirection is to ensure that the __FILE__ string comes through
+ * OK. Many version of gcc do not support the asm %c parameter which would be
+ * preferable to this unpleasantness. We use mergeable string sections to
+ * avoid multiple copies of the string appearing in the kernel image.
+ */
+
+#define __BUG(__file, __line, __value)				\
+do {								\
+	BUILD_BUG_ON(sizeof(struct bug_entry) != 12);		\
+	asm volatile("1:\t" BUG_INSTR_TYPE #__value "\n"	\
+		".pushsection .rodata.str, \"aMS\", 1\n"	\
+		"2:\t.asciz " #__file "\n" 			\
+		".popsection\n" 				\
+		".pushsection __bug_table,\"a\"\n"		\
+		"3:\t.word 1b, 2b\n"				\
+		"\t.hword " #__line ", 0\n"			\
+		".popsection");					\
+	unreachable();						\
+} while (0)
+
+#else  /* not CONFIG_DEBUG_BUGVERBOSE */
+
+#define __BUG(__file, __line, __value)				\
+do {								\
+	asm volatile(BUG_INSTR_TYPE #__value);			\
+	unreachable();						\
+} while (0)
+#endif  /* CONFIG_DEBUG_BUGVERBOSE */
 
 #define HAVE_ARCH_BUG
-#endif
+#endif  /* CONFIG_BUG */
 
 #include <asm-generic/bug.h>
 
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index f0000e1..25dc8dc 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -21,6 +21,7 @@
 #include <linux/kdebug.h>
 #include <linux/module.h>
 #include <linux/kexec.h>
+#include <linux/bug.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/sched.h>
@@ -271,6 +272,8 @@ void die(const char *str, struct pt_regs *regs, int err)
 	spin_lock_irq(&die_lock);
 	console_verbose();
 	bust_spinlocks(1);
+	if (!user_mode(regs))
+		report_bug(regs->ARM_pc, regs);
 	ret = __die(str, err, thread, regs);
 
 	if (regs && kexec_should_crash(thread->task))
@@ -302,6 +305,26 @@ void arm_notify_die(const char *str, struct pt_regs *regs,
 	}
 }
 
+#ifdef CONFIG_GENERIC_BUG
+
+int is_valid_bugaddr(unsigned long pc)
+{
+#ifdef CONFIG_THUMB2_KERNEL
+	unsigned short bkpt;
+#else
+	unsigned long bkpt;
+#endif
+
+	if (pc < PAGE_OFFSET)
+		return 0;
+	if (probe_kernel_address((unsigned *)pc, bkpt))
+		return 0;
+
+	return bkpt == BUG_INSTR_VALUE;
+}
+
+#endif
+
 static LIST_HEAD(undef_hook);
 static DEFINE_SPINLOCK(undef_lock);
 
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index b4348e6..81d4efe 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -21,7 +21,8 @@
 #define ARM_CPU_KEEP(x)
 #endif
 
-#if defined(CONFIG_SMP_ON_UP) && !defined(CONFIG_DEBUG_SPINLOCK)
+#if (defined(CONFIG_SMP_ON_UP) && !defined(CONFIG_DEBUG_SPINLOCK)) || \
+	defined(CONFIG_GENERIC_BUG)
 #define ARM_EXIT_KEEP(x)	x
 #else
 #define ARM_EXIT_KEEP(x)
-- 
1.7.3.1

