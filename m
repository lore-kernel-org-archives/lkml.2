Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0KLISj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 03:18:39 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34255 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab0KLISi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 03:18:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pMHxNhhgjFv/4tLHPtd1eEg+1kCSnwK0XX9H/dEW8t0fB8ARTIF5tnyVQ54Pm0Q8hb
         2tWNgMTTnrQYKcDJOsourG/Z0Nz+Dp2o3maZKS5bGxTzd5FZbC7gzxFmKrnQBODN1Phj
         1bi/14HigsUP2HswB4SZsdl/iJQ8eF/IvvBrI=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux@arm.linux.org.uk
Cc: kgene.kim@samsung.com, kmpark@infradead.org, konkers@android.com,
        tony@atomide.com, adharmap@codeaurora.org, avorontsov@mvista.com,
        linux-kernel@vger.kernel.org, srinidhikasagar@gmail.com,
        dwalker@codeaurora.org, santosh.shilimkar@ti.com, ccross@android.com,
        olof@lixom.net, Magnus Damm <magnus.damm@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 12 Nov 2010 17:21:31 +0900
Message-Id: <20101112082131.27221.51642.sendpatchset@t400s>
In-Reply-To: <20101112082059.27221.52879.sendpatchset@t400s>
References: <20101112082059.27221.52879.sendpatchset@t400s>
Subject: [PATCH 03/07] ARM: Use shared GIC entry macros on Realview
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Use the GIC demux code in asm/hardware/entry-macro-gic.S
on the Realview subarchitecture.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/mach-realview/include/mach/entry-macro.S |   60 ---------------------
 1 file changed, 1 insertion(+), 59 deletions(-)

--- 0001/arch/arm/mach-realview/include/mach/entry-macro.S
+++ work/arch/arm/mach-realview/include/mach/entry-macro.S	2010-11-12 15:59:57.000000000 +0900
@@ -8,7 +8,7 @@
  * warranty of any kind, whether express or implied.
  */
 #include <mach/hardware.h>
-#include <asm/hardware/gic.h>
+#include <asm/hardware/entry-macro-gic.S>
 
 		.macro	disable_fiq
 		.endm
@@ -21,61 +21,3 @@
 		.macro  arch_ret_to_user, tmp1, tmp2
 		.endm
 
-		/*
-		 * The interrupt numbering scheme is defined in the
-		 * interrupt controller spec.  To wit:
-		 *
-		 * Interrupts 0-15 are IPI
-		 * 16-28 are reserved
-		 * 29-31 are local.  We allow 30 to be used for the watchdog.
-		 * 32-1020 are global
-		 * 1021-1022 are reserved
-		 * 1023 is "spurious" (no interrupt)
-		 *
-		 * For now, we ignore all local interrupts so only return an interrupt if it's
-		 * between 30 and 1020.  The test_for_ipi routine below will pick up on IPIs.
-		 *
-		 * A simple read from the controller will tell us the number of the highest
-                 * priority enabled interrupt.  We then just need to check whether it is in the
-		 * valid range for an IRQ (30-1020 inclusive).
-		 */
-
-		.macro  get_irqnr_and_base, irqnr, irqstat, base, tmp
-
-		ldr     \irqstat, [\base, #GIC_CPU_INTACK] /* bits 12-10 = src CPU, 9-0 = int # */
-
-		ldr	\tmp, =1021
-
-		bic     \irqnr, \irqstat, #0x1c00
-
-		cmp     \irqnr, #29
-		cmpcc	\irqnr, \irqnr
-		cmpne	\irqnr, \tmp
-		cmpcs	\irqnr, \irqnr
-
-		.endm
-
-		/* We assume that irqstat (the raw value of the IRQ acknowledge
-		 * register) is preserved from the macro above.
-		 * If there is an IPI, we immediately signal end of interrupt on the
-		 * controller, since this requires the original irqstat value which
-		 * we won't easily be able to recreate later.
-		 */
-
-		.macro test_for_ipi, irqnr, irqstat, base, tmp
-		bic	\irqnr, \irqstat, #0x1c00
-		cmp	\irqnr, #16
-		strcc	\irqstat, [\base, #GIC_CPU_EOI]
-		cmpcs	\irqnr, \irqnr
-		.endm
-
-		/* As above, this assumes that irqstat and base are preserved.. */
-
-		.macro test_for_ltirq, irqnr, irqstat, base, tmp
-		bic	\irqnr, \irqstat, #0x1c00
-		mov 	\tmp, #0
-		cmp	\irqnr, #29
-		moveq	\tmp, #1
-		streq	\irqstat, [\base, #GIC_CPU_EOI]
-		cmp	\tmp, #0
-		.endm
