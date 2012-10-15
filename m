Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab2JOVzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 17:55:05 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50881 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab2JOVy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 17:54:58 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sascha Hauer <kernel@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH 06/10] ARM: FIQ: Remove FIQ_START
Date: Mon, 15 Oct 2012 14:51:30 -0700
Message-Id: <1350337894-9744-6-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <20121015214954.GA3352@lizard>
References: <20121015214954.GA3352@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RPC:

 FIQ_START is irrelevant nowadays, the arch uses platform-specific
 iomd_{,un}mask_fiq() calls.

OMAP1:

 The only user of FIQs is MACH_AMS_DELTA, and in particular its
 drivers/input/serio/ams_delta_serio.c driver. The driver does not rely on
 the FIQ interrupts directly, instead it uses a "deferred fiq" interrupt
 (raised after a buffer filled by the FIQ routine).

 The FIQ handling routines are not using disable_fiq() or enable_fiq()
 stuff, so it currently does not use FIQ_START at all -- the asm code uses
 OMAP_IH1_BASE and twiddles the bits itself.

S3C:

 The only user of FIQs on s3c24xx is spi-s3c24xx driver. The driver works
 with interrupt controller directly (via S3C24XX_VA_IRQ base address), and
 does not use IRQ subsystem to mask/unmask IRQs.

MXC:

 Users now use enable/disable_irq() routines. The drivers rely on a
 correctly passed VIRQ cookie anyway, so FIQ_START becomes irrelevant.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 arch/arm/include/asm/mach/irq.h           | 2 +-
 arch/arm/kernel/fiq.c                     | 2 +-
 arch/arm/mach-omap1/include/mach/irqs.h   | 4 ----
 arch/arm/mach-rpc/include/mach/irqs.h     | 5 -----
 arch/arm/mach-rpc/irq.c                   | 2 +-
 arch/arm/mach-s3c24xx/include/mach/irqs.h | 3 ---
 arch/arm/plat-mxc/avic.c                  | 2 +-
 arch/arm/plat-mxc/include/mach/irqs.h     | 2 --
 arch/arm/plat-mxc/tzic.c                  | 2 +-
 arch/arm/plat-s3c24xx/irq.c               | 2 +-
 10 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/arch/arm/include/asm/mach/irq.h b/arch/arm/include/asm/mach/irq.h
index 15cb035..febe495 100644
--- a/arch/arm/include/asm/mach/irq.h
+++ b/arch/arm/include/asm/mach/irq.h
@@ -17,7 +17,7 @@ struct seq_file;
 /*
  * This is internal.  Do not use it.
  */
-extern void init_FIQ(int);
+extern void init_FIQ(void);
 extern int show_fiq_list(struct seq_file *, int);
 
 #ifdef CONFIG_MULTI_IRQ_HANDLER
diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index 29b93b8..bd369c5 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -128,7 +128,7 @@ EXPORT_SYMBOL(__get_fiq_regs);	/* defined in fiqasm.S */
 EXPORT_SYMBOL(claim_fiq);
 EXPORT_SYMBOL(release_fiq);
 
-void __init init_FIQ(int start)
+void __init init_FIQ(void)
 {
 	no_fiq_insn = *(unsigned long *)0xffff001c;
 }
diff --git a/arch/arm/mach-omap1/include/mach/irqs.h b/arch/arm/mach-omap1/include/mach/irqs.h
index 729992d..f254bb6 100644
--- a/arch/arm/mach-omap1/include/mach/irqs.h
+++ b/arch/arm/mach-omap1/include/mach/irqs.h
@@ -261,8 +261,4 @@
 
 #include <mach/hardware.h>
 
-#ifdef CONFIG_FIQ
-#define FIQ_START		1024
-#endif
-
 #endif
diff --git a/arch/arm/mach-rpc/include/mach/irqs.h b/arch/arm/mach-rpc/include/mach/irqs.h
index f27ead1..2536543 100644
--- a/arch/arm/mach-rpc/include/mach/irqs.h
+++ b/arch/arm/mach-rpc/include/mach/irqs.h
@@ -42,9 +42,4 @@ extern void iomd_mask_fiq(int fiq);
 extern void iomd_unmask_fiq(int fiq);
 #endif
 
-/*
- * This is the offset of the FIQ "IRQ" numbers
- */
-#define FIQ_START		64
-
 #define NR_IRQS			128
diff --git a/arch/arm/mach-rpc/irq.c b/arch/arm/mach-rpc/irq.c
index a4221b3..07770c8 100644
--- a/arch/arm/mach-rpc/irq.c
+++ b/arch/arm/mach-rpc/irq.c
@@ -152,6 +152,6 @@ void __init rpc_init_irq(void)
 		}
 	}
 
-	init_FIQ(FIQ_START);
+	init_FIQ();
 }
 
diff --git a/arch/arm/mach-s3c24xx/include/mach/irqs.h b/arch/arm/mach-s3c24xx/include/mach/irqs.h
index b7a9f4d..7d66d41 100644
--- a/arch/arm/mach-s3c24xx/include/mach/irqs.h
+++ b/arch/arm/mach-s3c24xx/include/mach/irqs.h
@@ -209,7 +209,4 @@
 #define IRQ_S3C244X_AC97 IRQ_S3C2443_AC97
 #endif
 
-/* Our FIQs are routable from IRQ_EINT0 to IRQ_ADCPARENT */
-#define FIQ_START		IRQ_EINT0
-
 #endif /* __ASM_ARCH_IRQ_H */
diff --git a/arch/arm/plat-mxc/avic.c b/arch/arm/plat-mxc/avic.c
index cbd55c3..19701ec 100644
--- a/arch/arm/plat-mxc/avic.c
+++ b/arch/arm/plat-mxc/avic.c
@@ -218,7 +218,7 @@ void __init mxc_init_irq(void __iomem *irqbase)
 
 #ifdef CONFIG_FIQ
 	/* Initialize FIQ */
-	init_FIQ(FIQ_START);
+	init_FIQ();
 #endif
 
 	printk(KERN_INFO "MXC IRQ initialized\n");
diff --git a/arch/arm/plat-mxc/include/mach/irqs.h b/arch/arm/plat-mxc/include/mach/irqs.h
index d73f5e8..2ec942f 100644
--- a/arch/arm/plat-mxc/include/mach/irqs.h
+++ b/arch/arm/plat-mxc/include/mach/irqs.h
@@ -13,8 +13,6 @@
 
 extern int imx_irq_set_priority(unsigned char irq, unsigned char prio);
 
-/* all normal IRQs can be FIQs */
-#define FIQ_START	0
 /* switch between IRQ and FIQ */
 extern int mxc_set_irq_fiq(unsigned int irq, unsigned int type);
 
diff --git a/arch/arm/plat-mxc/tzic.c b/arch/arm/plat-mxc/tzic.c
index 3ed1adb..d09b573 100644
--- a/arch/arm/plat-mxc/tzic.c
+++ b/arch/arm/plat-mxc/tzic.c
@@ -193,7 +193,7 @@ void __init tzic_init_irq(void __iomem *irqbase)
 
 #ifdef CONFIG_FIQ
 	/* Initialize FIQ */
-	init_FIQ(FIQ_START);
+	init_FIQ();
 #endif
 
 	pr_info("TrustZone Interrupt Controller (TZIC) initialized\n");
diff --git a/arch/arm/plat-s3c24xx/irq.c b/arch/arm/plat-s3c24xx/irq.c
index e4e9567..e0de92a 100644
--- a/arch/arm/plat-s3c24xx/irq.c
+++ b/arch/arm/plat-s3c24xx/irq.c
@@ -533,7 +533,7 @@ void __init s3c24xx_init_irq(void)
 	int i;
 
 #ifdef CONFIG_FIQ
-	init_FIQ(FIQ_START);
+	init_FIQ();
 #endif
 
 	irqdbf("s3c2410_init_irq: clearing interrupt status flags\n");
-- 
1.7.12.3

