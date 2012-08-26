Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315Ab2HZE1I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 00:27:08 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:46937 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab2HZE1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 00:27:06 -0400
Date: Sat, 25 Aug 2012 21:24:40 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sascha Hauer <kernel@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 0/9] Get rid of FIQ_START/enable/disable_fiq() + some FIQ
 cleanups
Message-ID: <20120826042437.GA26164@lizard>
References: <20120805230238.GA1663@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120805230238.GA1663@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Sun, Aug 05, 2012 at 04:02:38PM -0700, Anton Vorontsov wrote:
> During KDB FIQ patches review you mentioned that I should not introduce
> another FIQ_START. It seems that in v3.6-rc the FIQ_START issue was
> somewhat band-aided, i.e. machines don't necessary need to define this
> stuff any longer, but I also read the background of the issue, and you
> once said that you don't want the FIQ subsystem to mess with genirq.

Just wonder if you had a chance to look into this patch set...

Plus, I also realized that maybe it's a good time to get rid of
init_FIQ() altogether? Maybe there are some not so obvious reasons for
its existence, but if not, does the following patch on top of this
series makes sense?

(Also, I noticed that we save no_fiq_insn w/o bothering about
!CONFIG_CPU_USE_DOMAINS case, but set_fiq_handler() has a special
handling for this. I wonder, was that on purpose, e.g. it does not
matter for init_FIQ(), or it was just overlooked? In latter case,
the patch fixes the issue.)

- - - -
[PATCH] ARM: FIQ: Get rid of init_FIQ()

The function only saves initial arch-specific "no FIQ" instruction,
by placing the code into set_fiq_handler() we can:

- Have less code and logic in the platform-specific files;
- Have the code that manages FIQ vector overwriting in one place, i.e.
  not spread the logic around (both code placement wise and execution
  time wise).

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
1.7.11.5

