Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab0H0Jcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:32:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43350 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab0H0Jco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:32:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eUx3hpTjZVXrkokisCnvN3WQR8GVX3j6aGR+YaTPaRBRfbiFniPHSRbqoI5j/6I4th
         tA5yFHsPSh4Qke8Vm6t6PxjRf3TB7vHW3uTjLksuBVpxgRWX/9Binzpg70XKnHIbDlKG
         gDHJQn3/Bltme448IxfA+oVjCFaAZO+UkkHZA=
From: jiang.adam@gmail.com
To: ralf@linux-mips.org
Cc: dmitri.vorobiev@movial.com, wuzhangjin@gmail.com,
        ddaney@caviumnetworks.com, peterz@infradead.org, fweisbec@gmail.com,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Adam Jiang <jiang.adam@gmail.com>
Subject: [PATCH V2] mips: irq: add stackoverflow detection
Date: Fri, 27 Aug 2010 18:32:06 +0900
Message-Id: <1282901526-28405-1-git-send-email-jiang.adam@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <linux-mips@linux-mips.org>
References: <linux-mips@linux-mips.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adam Jiang <jiang.adam@gmail.com>

Add stackoverflow detection to mips arch

Signed-off-by: Adam Jiang <jiang.adam@gmail.com>
---
 arch/mips/Kconfig.debug |    9 +++++++++
 arch/mips/kernel/irq.c  |   21 +++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig.debug b/arch/mips/Kconfig.debug
index 43dc279..f437cd1 100644
--- a/arch/mips/Kconfig.debug
+++ b/arch/mips/Kconfig.debug
@@ -67,6 +67,15 @@ config CMDLINE_OVERRIDE
 
 	  Normally, you will choose 'N' here.
 
+config DEBUG_STACKOVERFLOW
+	bool "Check for stack overflows"
+	depends on DEBUG_KERNEL
+	help
+	  This option will cause messages to be printed if free stack space
+	  drops below a certain limit(2GB on MIPS). The debugging option
+	  provides another way to check stack overflow happened on kernel mode
+	  stack usually caused by nested interruption.
+
 config DEBUG_STACK_USAGE
 	bool "Enable stack utilization instrumentation"
 	depends on DEBUG_KERNEL
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index c6345f5..d0b924d 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -151,6 +151,26 @@ void __init init_IRQ(void)
 #endif
 }
 
+#ifdef DEBUG_STACKOVERFLOW
+static inline void check_stack_overflow(void)
+{
+	long sp;
+
+	__asm__ __volatile__("move %0, $sp" : "=r" (sp));
+	sp = sp & (THREAD_SIZE-1);
+
+	/* check for stack overflow: is there less than 2KB free? */
+	if (unlikely(sp < (sizeof(struct thread_info) + 2048))) {
+		printk("do_IRQ: stack overflow: %ld\n",
+		       sp - sizeof(struct thread_info));
+		dump_stack();
+	}
+}
+#else
+static inline void check_stack_overflow(void) {}
+#endif
+
+
 /*
  * do_IRQ handles all normal device IRQ's (the special
  * SMP cross-CPU interrupts have their own specific
@@ -159,6 +179,7 @@ void __init init_IRQ(void)
 void __irq_entry do_IRQ(unsigned int irq)
 {
 	irq_enter();
+	check_stack_overflow();
 	__DO_IRQ_SMTC_HOOK(irq);
 	generic_handle_irq(irq);
 	irq_exit();
-- 
1.7.2.2

