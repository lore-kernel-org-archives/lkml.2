Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab0JFKoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 06:44:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52817 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab0JFKoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 06:44:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=C9P2Q0dKpk9M1kakr/Urve7zYpfYK5wrBTvyrBawXGmGTHq3OP5lymslMA3JF1B15l
         JkCRrIC3azNqZ2Tt9lhXkmrAq98LJXyfoLmwpaNrChdAZ2ILNpU8ctSXF+HAT7Qgi/nu
         HjNfytsz+5P6I31+YU8Yhz8ujgEOCKreuDE3E=
From: Adam Jiang <jiang.adam@gmail.com>
To: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Adam Jiang <jiang.adam@gmail.com>
Subject: [PATCH v3] mips: irq: add stackoverflow detection
Date: Wed,  6 Oct 2010 19:41:16 +0900
Message-Id: <1286361676-10743-1-git-send-email-jiang.adam@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add stackoverflow detection to mips arch

This is the 3rd version of the smiple patch. 2K is too big for many
system, so I Modified the warning line by following Ralf's suggestion.

Signed-off-by: Adam Jiang <jiang.adam@gmail.com>
---
 arch/mips/Kconfig.debug             |    7 +++++++
 arch/mips/include/asm/thread_info.h |    2 ++
 arch/mips/kernel/irq.c              |   25 +++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig.debug b/arch/mips/Kconfig.debug
index 43dc279..30c58d4 100644
--- a/arch/mips/Kconfig.debug
+++ b/arch/mips/Kconfig.debug
@@ -67,6 +67,13 @@ config CMDLINE_OVERRIDE
 
 	  Normally, you will choose 'N' here.
 
+config DEBUG_STACKOVERFLOW
+	bool "Check for stack overflows"
+	depends on DEBUG_KERNEL
+	help
+	  This option will cause messages to be printed if free stack
+	  space drops below a certain limit.
+
 config DEBUG_STACK_USAGE
 	bool "Enable stack utilization instrumentation"
 	depends on DEBUG_KERNEL
diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index 70df9c0..b60b28d 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -83,6 +83,8 @@ register struct thread_info *__current_thread_info __asm__("$28");
 #define THREAD_SIZE (PAGE_SIZE << THREAD_SIZE_ORDER)
 #define THREAD_MASK (THREAD_SIZE - 1UL)
 
+#define STACK_WARN  (THREAD_SIZE/8)
+
 #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index c6345f5..b43edb7 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -151,6 +151,28 @@ void __init init_IRQ(void)
 #endif
 }
 
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+static inline void check_stack_overflow(void)
+{
+	unsigned long sp;
+
+	asm volatile("move %0, $sp" : "=r" (sp));
+	sp = sp & THREAD_MASK;
+
+	/*
+	 * check for stack overflow: is there less than STACK_WARN free?
+	 * STACK_WARN is defined as 1/8 of THREAD_SIZE by default.
+	 */
+	if (unlikely(sp < (sizeof(struct thread_info) + STACK_WARN))) {
+		printk("do_IRQ: stack overflow: %ld\n",
+		       sp - sizeof(struct thread_info));
+		dump_stack();
+	}
+}
+#else
+static inline void check_stack_overflow(void) {}
+#endif
+
 /*
  * do_IRQ handles all normal device IRQ's (the special
  * SMP cross-CPU interrupts have their own specific
@@ -159,6 +181,9 @@ void __init init_IRQ(void)
 void __irq_entry do_IRQ(unsigned int irq)
 {
 	irq_enter();
+
+	check_stack_overflow();
+
 	__DO_IRQ_SMTC_HOOK(irq);
 	generic_handle_irq(irq);
 	irq_exit();
-- 
1.7.2.2

