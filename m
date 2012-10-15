Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab2JOVzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:55:33 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50881 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091Ab2JOVzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:55:06 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sascha Hauer <kernel@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH 10/10] ARM: FIQ: Get rid of init_FIQ()
Date: Mon, 15 Oct 2012 14:51:34 -0700
Message-Id: <1350337894-9744-10-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <20121015214954.GA3352@lizard>
References: <20121015214954.GA3352@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function only saves initial arch-specific "no FIQ" instruction, by
placing the code into set_fiq_handler() we can:

- Have less code and logic in the platform-specific files;
- Have the code that manages FIQ vector overwriting in one place, i.e.
  don't spread the logic around.

p.s. Also, I noticed that we saved no_fiq_insn w/o bothering about
!CONFIG_CPU_USE_DOMAINS case, but set_fiq_handler() handles this case
specifically. I wonder, was that on purpose, e.g. it does not matter for
init_FIQ(), or it was just overlooked? In the latter case, the patch fixes
the issue.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/arm/include/asm/mach/irq.h |  2 --
 arch/arm/kernel/fiq.c           | 17 ++++++++---------
 arch/arm/mach-rpc/irq.c         |  2 --
 arch/arm/plat-mxc/avic.c        |  3 ---
 arch/arm/plat-mxc/tzic.c        |  3 ---
 arch/arm/plat-s3c24xx/irq.c     |  2 --
 6 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/arch/arm/include/asm/mach/irq.h b/arch/arm/include/asm/mach/irq.h
index 8be5ba9..6e70ae3 100644
--- a/arch/arm/include/asm/mach/irq.h
+++ b/arch/arm/include/asm/mach/irq.h
@@ -18,10 +18,8 @@ struct seq_file;
  * This is internal.  Do not use it.
  */
 #ifdef CONFIG_FIQ
-extern void init_FIQ(void);
 extern void show_fiq_list(struct seq_file *, int);
 #else
-static inline void init_FIQ(void) {}
 static inline void show_fiq_list(struct seq_file *p, int prec) {}
 #endif
 
diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index 9bf3a60..3602df6 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -49,6 +49,7 @@
 #include <asm/mach/irq.h>
 
 static unsigned long no_fiq_insn;
+static int got_no_fiq_insn;
 
 /* Default reacquire function
  * - we always relinquish FIQ control
@@ -78,11 +79,14 @@ void show_fiq_list(struct seq_file *p, int prec)
 
 void set_fiq_handler(void *start, unsigned int length)
 {
-#if defined(CONFIG_CPU_USE_DOMAINS)
-	memcpy((void *)0xffff001c, start, length);
-#else
-	memcpy(vectors_page + 0x1c, start, length);
+	unsigned long *addr = (void *)0xffff001c;
+
+#ifndef CONFIG_CPU_USE_DOMAINS
+	addr = vectors_page + 0x1c;
 #endif
+	if (!cmpxchg(&got_no_fiq_insn, 0, 1))
+		no_fiq_insn = *addr;
+	memcpy(addr, start, length);
 	flush_icache_range(0xffff001c, 0xffff001c + length);
 	if (!vectors_high())
 		flush_icache_range(0x1c, 0x1c + length);
@@ -126,8 +130,3 @@ EXPORT_SYMBOL(__set_fiq_regs);	/* defined in fiqasm.S */
 EXPORT_SYMBOL(__get_fiq_regs);	/* defined in fiqasm.S */
 EXPORT_SYMBOL(claim_fiq);
 EXPORT_SYMBOL(release_fiq);
-
-void __init init_FIQ(void)
-{
-	no_fiq_insn = *(unsigned long *)0xffff001c;
-}
diff --git a/arch/arm/mach-rpc/irq.c b/arch/arm/mach-rpc/irq.c
index 07770c8..2d915ba 100644
--- a/arch/arm/mach-rpc/irq.c
+++ b/arch/arm/mach-rpc/irq.c
@@ -151,7 +151,5 @@ void __init rpc_init_irq(void)
 			break;
 		}
 	}
-
-	init_FIQ();
 }
 
diff --git a/arch/arm/plat-mxc/avic.c b/arch/arm/plat-mxc/avic.c
index 426980c..b173dc6 100644
--- a/arch/arm/plat-mxc/avic.c
+++ b/arch/arm/plat-mxc/avic.c
@@ -216,8 +216,5 @@ void __init mxc_init_irq(void __iomem *irqbase)
 	for (i = 0; i < 8; i++)
 		__raw_writel(0, avic_base + AVIC_NIPRIORITY(i));
 
-	/* Initialize FIQ */
-	init_FIQ();
-
 	printk(KERN_INFO "MXC IRQ initialized\n");
 }
diff --git a/arch/arm/plat-mxc/tzic.c b/arch/arm/plat-mxc/tzic.c
index 8a5a633..889267c 100644
--- a/arch/arm/plat-mxc/tzic.c
+++ b/arch/arm/plat-mxc/tzic.c
@@ -191,9 +191,6 @@ void __init tzic_init_irq(void __iomem *irqbase)
 	for (i = 0; i < 4; i++, irq_base += 32)
 		tzic_init_gc(i, irq_base);
 
-	/* Initialize FIQ */
-	init_FIQ();
-
 	pr_info("TrustZone Interrupt Controller (TZIC) initialized\n");
 }
 
diff --git a/arch/arm/plat-s3c24xx/irq.c b/arch/arm/plat-s3c24xx/irq.c
index 531d6a4..66b8856 100644
--- a/arch/arm/plat-s3c24xx/irq.c
+++ b/arch/arm/plat-s3c24xx/irq.c
@@ -532,8 +532,6 @@ void __init s3c24xx_init_irq(void)
 	int irqno;
 	int i;
 
-	init_FIQ();
-
 	irqdbf("s3c2410_init_irq: clearing interrupt status flags\n");
 
 	/* first, clear all interrupts pending... */
-- 
1.7.12.3

