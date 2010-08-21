Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab0HUG3B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 02:29:01 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51280 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab0HUG27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 02:28:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ODIToE9HmHs/EYhG3LpLgMkOSg8KBRR+ciGZMY289SjiqOvu3KI8jF/owxMTzf3di7
         JxEZyGHBmuc4OORJKFn9BtRJTGgkm0OKmIGt+YF34WOjDSyIefJjQM30nWHrPv7aH+46
         c8lTvxgiYqgcfgbO6Ble1f2PEVTb8WWd7jsxU=
From: jiang.adam@gmail.com
To: ralf@linux-mips.org
Cc: dmitri.vorobiev@movial.com, wuzhangjin@gmail.com,
        ddaney@caviumnetworks.com, peterz@infradead.org, fweisbec@gmail.com,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Adam Jiang <jiang.adam@gmail.com>
Subject: [PATCH] mips: irq: add statckoverflow detection
Date: Sat, 21 Aug 2010 15:31:33 +0900
Message-Id: <1282372293-30211-1-git-send-email-jiang.adam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adam Jiang <jiang.adam@gmail.com>

Add stackoverflow detection to mips arch

Signed-off-by: Adam Jiang <jiang.adam@gmail.com>
---
 arch/mips/Kconfig.debug |    7 +++++++
 arch/mips/kernel/irq.c  |   19 +++++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig.debug b/arch/mips/Kconfig.debug
index 43dc279..f1a00a2 100644
--- a/arch/mips/Kconfig.debug
+++ b/arch/mips/Kconfig.debug
@@ -67,6 +67,13 @@ config CMDLINE_OVERRIDE
 
 	  Normally, you will choose 'N' here.
 
+config DEBUG_STACKOVERFLOW
+	bool "Check for stack overflows"
+	depends on DEBUG_KERNEL
+	help
+	  This option will cause messages to be printed if free stack space
+	  drops below a certain limit.
+
 config DEBUG_STACK_USAGE
 	bool "Enable stack utilization instrumentation"
 	depends on DEBUG_KERNEL
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index c6345f5..6334037 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -151,6 +151,22 @@ void __init init_IRQ(void)
 #endif
 }
 
+static inline void check_stack_overflow(void)
+{
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+	long sp;
+
+	asm volatile("move %0, $sp" : "=r" (sp));
+	sp = sp & (THREAD_SIZE-1);
+
+	/* check for stack overflow: is there less then 2KB free? */
+	if (unlikely(sp < (sizeof(struct thread_info) + 2048))) {
+		printk("do_IRQ: stack overflow: %ld\n",
+		       sp - sizeof(struct thread_info));
+		dump_stack();
+	}
+#endif
+}
 /*
  * do_IRQ handles all normal device IRQ's (the special
  * SMP cross-CPU interrupts have their own specific
@@ -159,6 +175,9 @@ void __init init_IRQ(void)
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
1.7.1

