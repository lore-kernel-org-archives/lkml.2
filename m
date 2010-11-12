Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab0KLITN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 03:19:13 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36154 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab0KLITJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 03:19:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=CxnHE6T/B9W4ln4vi3XCjyWxwvfyaOH80SLNGjT/eVSq7mCyvwSAGY0rwP/v8gZ530
         5kDitD5rU5JfskqOiM2hwFA6CN0BFHf1MiMZqugWqKzl75GjflDMxFHbCkV0JpF8v5O0
         lsGsEDnfHipu7Ni8MId04VUJv/f2Ezay8zEHw=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux@arm.linux.org.uk
Cc: kgene.kim@samsung.com, kmpark@infradead.org, konkers@android.com,
        tony@atomide.com, adharmap@codeaurora.org, avorontsov@mvista.com,
        linux-kernel@vger.kernel.org, srinidhikasagar@gmail.com,
        dwalker@codeaurora.org, santosh.shilimkar@ti.com, ccross@android.com,
        olof@lixom.net, Magnus Damm <magnus.damm@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 12 Nov 2010 17:22:01 +0900
Message-Id: <20101112082201.27221.40594.sendpatchset@t400s>
In-Reply-To: <20101112082059.27221.52879.sendpatchset@t400s>
References: <20101112082059.27221.52879.sendpatchset@t400s>
Subject: [PATCH 06/07] ARM: Use shared GIC entry macros on Vexpress
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Use the GIC demux code in asm/hardware/entry-macro-gic.S
on the Versatile Express subarchitecture.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/mach-vexpress/include/mach/entry-macro.S |   57 ---------------------
 1 file changed, 1 insertion(+), 56 deletions(-)

--- 0001/arch/arm/mach-vexpress/include/mach/entry-macro.S
+++ work/arch/arm/mach-vexpress/include/mach/entry-macro.S	2010-11-12 16:03:56.000000000 +0900
@@ -1,4 +1,4 @@
-#include <asm/hardware/gic.h>
+#include <asm/hardware/entry-macro-gic.S>
 
 	.macro	disable_fiq
 	.endm
@@ -10,58 +10,3 @@
 
 	.macro	arch_ret_to_user, tmp1, tmp2
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
-	 * For now, we ignore all local interrupts so only return an interrupt if it's
-	 * between 30 and 1020.  The test_for_ipi routine below will pick up on IPIs.
-	 *
-	 * A simple read from the controller will tell us the number of the highest
-	 * priority enabled interrupt.  We then just need to check whether it is in the
-	 * valid range for an IRQ (30-1020 inclusive).
-	 */
-
-	.macro	get_irqnr_and_base, irqnr, irqstat, base, tmp
-	ldr     \irqstat, [\base, #GIC_CPU_INTACK] /* bits 12-10 = src CPU, 9-0 = int # */
-	ldr	\tmp, =1021
-	bic     \irqnr, \irqstat, #0x1c00
-	cmp     \irqnr, #29
-	cmpcc	\irqnr, \irqnr
-	cmpne	\irqnr, \tmp
-	cmpcs	\irqnr, \irqnr
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
