Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab0HZNQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:16:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57262 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab0HZNQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:16:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vlKvj+fX3w+8ask1jk/7sTORUHMXla+c5Y5lRF/NKvKZ1euSz3y8RlyJV9cY4ZEaTP
         WAasNVlEVt7bf/cuZbDOMjohjn5XSgAyRL0sb14InW41qn2UoCpX3h9kEJWVeg8Tp1gS
         wTIijIJ1ilwvcrT//k9QCdhzHKbjsgltMgckI=
From: Adam Jiang <jiang.adam@gmail.com>
To: ralf@linux-mips.org
Cc: dmitri.vorobiev@movial.com, wuzhangjin@gmail.com,
        ddaney@caviumnetworks.com, peterz@infradead.org, fweisbec@gmail.com,
        tj@kernel.org, linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Adam Jiang <jiang.adam@gmail.com>
Subject: [PATCH] mips: irq: add stackoverflow detection
Date: Thu, 26 Aug 2010 22:19:15 +0900
Message-Id: <1282828755-11953-1-git-send-email-jiang.adam@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <linux-mips@linux-mips.org>
References: <linux-mips@linux-mips.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add stackoverflow detection to mips arch
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
index c6345f5..8fdf79e 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -151,6 +151,25 @@ void __init init_IRQ(void)
 #endif
 }
 
+#ifdef DEBUG_STACKOVERFLOW
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
+static inline void check_stack_overflow(void) {}
+#endif
+
 /*
  * do_IRQ handles all normal device IRQ's (the special
  * SMP cross-CPU interrupts have their own specific
-- 
1.7.1

