Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab0KLISu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 03:18:50 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35163 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab0KLISs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 03:18:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ug6H/eC08VUPMdnJewB0gpQ2A9TYft7JlL+ycwVMoiEL8LQerabQ4S/15iYWmlXYg9
         WPW4EucuqEgYcPHdT3fuWr+5XkRNagENNHKKCqng5dnhAIv9uAHZYOxsN3nVAyt4i6Tv
         bq4ZHH7gV4T2RNby/wAQbbn8Jxo07QCM7G7+U=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux@arm.linux.org.uk
Cc: kgene.kim@samsung.com, kmpark@infradead.org, konkers@android.com,
        tony@atomide.com, adharmap@codeaurora.org, avorontsov@mvista.com,
        linux-kernel@vger.kernel.org, srinidhikasagar@gmail.com,
        dwalker@codeaurora.org, santosh.shilimkar@ti.com, ccross@android.com,
        olof@lixom.net, Magnus Damm <magnus.damm@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 12 Nov 2010 17:21:41 +0900
Message-Id: <20101112082141.27221.50202.sendpatchset@t400s>
In-Reply-To: <20101112082059.27221.52879.sendpatchset@t400s>
References: <20101112082059.27221.52879.sendpatchset@t400s>
Subject: [PATCH 04/07] ARM: Use shared GIC entry macros on Tegra
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Use the GIC demux code in asm/hardware/entry-macro-gic.S
on the Tegra subarchitecture.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/mach-tegra/include/mach/entry-macro.S |   64 ------------------------
 1 file changed, 1 insertion(+), 63 deletions(-)

--- 0001/arch/arm/mach-tegra/include/mach/entry-macro.S
+++ work/arch/arm/mach-tegra/include/mach/entry-macro.S	2010-11-12 16:01:47.000000000 +0900
@@ -17,7 +17,7 @@
 
 #if defined(CONFIG_ARM_GIC)
 
-#include <asm/hardware/gic.h>
+#include <asm/hardware/entry-macro-gic.S>
 
 	/* Uses the GIC interrupt controller built into the cpu */
 #define ICTRL_BASE (IO_CPU_VIRT + 0x100)
@@ -32,68 +32,6 @@
 
 	.macro  arch_ret_to_user, tmp1, tmp2
 	.endm
-
-	/*
-	 * The interrupt numbering scheme is defined in the
-	 * interrupt controller spec.  To wit:
-	 *
-	 * Interrupts 0-15 are IPI
-	 * 16-28 are reserved
-	 * 29-31 are local.  We allow 30 to be used for the watchdog.
-	 * 32-1020 are global
-	 * 1021-1022 are reserved
-	 * 1023 is "spurious" (no interrupt)
-	 *
-	 * For now, we ignore all local interrupts so only return an interrupt
-	 * if it's between 30 and 1020.  The test_for_ipi routine below will
-	 * pick up on IPIs.
-	 *
-	 * A simple read from the controller will tell us the number of the
-	 * highest priority enabled interrupt.  We then just need to check
-	 * whether it is in the valid range for an IRQ (30-1020 inclusive).
-	 */
-
-	.macro  get_irqnr_and_base, irqnr, irqstat, base, tmp
-
-	/* bits 12-10 = src CPU, 9-0 = int # */
-	ldr     \irqstat, [\base, #GIC_CPU_INTACK]
-
-	ldr		\tmp, =1021
-
-	bic     \irqnr, \irqstat, #0x1c00
-
-	cmp     \irqnr, #29
-	cmpcc	\irqnr, \irqnr
-	cmpne	\irqnr, \tmp
-	cmpcs	\irqnr, \irqnr
-
-	.endm
-
-	/* We assume that irqstat (the raw value of the IRQ acknowledge
-	 * register) is preserved from the macro above.
-	 * If there is an IPI, we immediately signal end of interrupt on the
-	 * controller, since this requires the original irqstat value which
-	 * we won't easily be able to recreate later.
-	 */
-
-	.macro test_for_ipi, irqnr, irqstat, base, tmp
-	bic	\irqnr, \irqstat, #0x1c00
-	cmp	\irqnr, #16
-	strcc	\irqstat, [\base, #GIC_CPU_EOI]
-	cmpcs	\irqnr, \irqnr
-	.endm
-
-	/* As above, this assumes that irqstat and base are preserved.. */
-
-	.macro test_for_ltirq, irqnr, irqstat, base, tmp
-	bic	\irqnr, \irqstat, #0x1c00
-	mov 	\tmp, #0
-	cmp	\irqnr, #29
-	moveq	\tmp, #1
-	streq	\irqstat, [\base, #GIC_CPU_EOI]
-	cmp	\tmp, #0
-	.endm
-
 #else
 	/* legacy interrupt controller for AP16 */
 	.macro	disable_fiq
