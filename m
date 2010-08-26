Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0HZD4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 23:56:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35109 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab0HZD4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 23:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VsmsUhVZUWdIIDC7Ij46Z1L9BX97IXhr4J+zAbB74GsSddyRElTyqLw1DXqc/lZ26X
         oLzCb1LQDPpTz+Sr8aI9i3dbxOjIXlq5Q+zVm5TqiH3krS81mXMjVeGLN9GAoL+iM89Q
         JavGEPnULANToNHigBiDqJocl5j4m2AO1DkDw=
From: Adam Jiang <jiang.adam@gmail.com>
To: ralf@linux-mips.org
Cc: dmitri.vorobiev@movial.com, wuzhangjin@gmail.com,
        ddaney@caviumnetworks.com, peterz@infradead.org, fweisbec@gmail.com,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Adam Jiang <jiang.adam@gmail.com>
Subject: [PATCH 3/3] mips: irq: add stackoverflow detection
Date: Thu, 26 Aug 2010 12:55:33 +0900
Message-Id: <1282794933-20639-1-git-send-email-jiang.adam@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <linux-kernel@vger.kernel.org>
References: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add stackoverflow detection to mips arch
---
 arch/mips/Kconfig.debug |    7 +++++++
 arch/mips/kernel/irq.c  |   22 ++++++++++++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

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
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index c6345f5..75c584d 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -151,6 +151,25 @@ void __init init_IRQ(void)
 #endif
 }
 
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+static inline void check_stack_overflow(void)
+{
+	long sp;
+
+	asm volatile("move %0, $sp" : "=r" (sp));
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
+static inline void check_stack_overflow(void)
+#endif
+
 /*
  * do_IRQ handles all normal device IRQ's (the special
  * SMP cross-CPU interrupts have their own specific
@@ -159,6 +178,9 @@ void __init init_IRQ(void)
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
1.7.0.4

