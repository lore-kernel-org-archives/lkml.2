Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab2DRU5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:57:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:36408 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2DRU5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:57:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] irq: hide debug macros so they don't collide with others.
Date: Wed, 18 Apr 2012 16:56:42 -0400
Message-Id: <1334782602-591-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file kernel/irq/debug.h temporarily defines P, PS, PD
and then undefines them.  However these names aren't really
"internal" enough, and collide with other more legit users
such as the ones in the xtensa arch, causing:

In file included from kernel/irq/internals.h:58:0,
                 from kernel/irq/irqdesc.c:18:
kernel/irq/debug.h:8:0: warning: "PS" redefined [enabled by default]
arch/xtensa/include/asm/regs.h:59:0: note: this is the location of the previous definition

Add a handful of underscores to do a better job of hiding these
temporary macros.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/kernel/irq/debug.h b/kernel/irq/debug.h
index 97a8bfa..e75e29e 100644
--- a/kernel/irq/debug.h
+++ b/kernel/irq/debug.h
@@ -4,10 +4,10 @@
 
 #include <linux/kallsyms.h>
 
-#define P(f) if (desc->status_use_accessors & f) printk("%14s set\n", #f)
-#define PS(f) if (desc->istate & f) printk("%14s set\n", #f)
+#define ___P(f) if (desc->status_use_accessors & f) printk("%14s set\n", #f)
+#define ___PS(f) if (desc->istate & f) printk("%14s set\n", #f)
 /* FIXME */
-#define PD(f) do { } while (0)
+#define ___PD(f) do { } while (0)
 
 static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
 {
@@ -23,23 +23,23 @@ static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
 		print_symbol("%s\n", (unsigned long)desc->action->handler);
 	}
 
-	P(IRQ_LEVEL);
-	P(IRQ_PER_CPU);
-	P(IRQ_NOPROBE);
-	P(IRQ_NOREQUEST);
-	P(IRQ_NOTHREAD);
-	P(IRQ_NOAUTOEN);
+	___P(IRQ_LEVEL);
+	___P(IRQ_PER_CPU);
+	___P(IRQ_NOPROBE);
+	___P(IRQ_NOREQUEST);
+	___P(IRQ_NOTHREAD);
+	___P(IRQ_NOAUTOEN);
 
-	PS(IRQS_AUTODETECT);
-	PS(IRQS_REPLAY);
-	PS(IRQS_WAITING);
-	PS(IRQS_PENDING);
+	___PS(IRQS_AUTODETECT);
+	___PS(IRQS_REPLAY);
+	___PS(IRQS_WAITING);
+	___PS(IRQS_PENDING);
 
-	PD(IRQS_INPROGRESS);
-	PD(IRQS_DISABLED);
-	PD(IRQS_MASKED);
+	___PD(IRQS_INPROGRESS);
+	___PD(IRQS_DISABLED);
+	___PD(IRQS_MASKED);
 }
 
-#undef P
-#undef PS
-#undef PD
+#undef ___P
+#undef ___PS
+#undef ___PD
-- 
1.7.9.1

