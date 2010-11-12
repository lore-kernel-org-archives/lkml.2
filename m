Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab0KLIST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 03:18:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37000 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab0KLISR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 03:18:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=BYOCiTP+ugh+F7vnMMwCbaEFTUiabIt4vRokt/KV3Pfoum7ORLIXMNmBsQyqWG+6hz
         HyZPLNSs8zI+VWr6yp3+9Fcy7/xtJhA4rUk2aCij1PRjzy82P+ZeuY4R3G9CRJp8AuoN
         z/9tClAQdcs46o3M9YVlISQgUhpXX4AOS5Q2A=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux@arm.linux.org.uk
Cc: kgene.kim@samsung.com, kmpark@infradead.org, konkers@android.com,
        tony@atomide.com, adharmap@codeaurora.org, avorontsov@mvista.com,
        linux-kernel@vger.kernel.org, srinidhikasagar@gmail.com,
        dwalker@codeaurora.org, santosh.shilimkar@ti.com, ccross@android.com,
        olof@lixom.net, Magnus Damm <magnus.damm@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 12 Nov 2010 17:21:10 +0900
Message-Id: <20101112082110.27221.55529.sendpatchset@t400s>
In-Reply-To: <20101112082059.27221.52879.sendpatchset@t400s>
References: <20101112082059.27221.52879.sendpatchset@t400s>
Subject: [PATCH 01/07] ARM: Introduce asm/hardware/entry-macro-gic.S
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch is the identical GIC demux implementation
merge V3. Instead of implementing same code over and
over simply share it in entry-macro-gic.S. The shared
code is based on the realview implementation.

Each GIC demux instance still has to setup the base address
of the controller using the get_irqnr_preamble macro. The
rest of the GIC specific code can be shared.

Signed-off-by: Magnus Damm <damm@opensource.se>
Acked-by: Srinidhi Kasagar<srinidhi.kasagar@stericsson.com>
---

 Changes since V2:
 - broke out patches into base + per sub-arch

 arch/arm/include/asm/hardware/entry-macro-gic.S |   68 +++++++++++++++++++++++
 1 file changed, 68 insertions(+)

--- /dev/null
+++ work/arch/arm/include/asm/hardware/entry-macro-gic.S	2010-11-12 15:57:05.000000000 +0900
@@ -0,0 +1,68 @@
+/*
+ * arch/arm/include/asm/hardware/entry-macro-gic.S
+ *
+ * Low-level IRQ helper macros for GIC
+ *
+ * This file is licensed under  the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <asm/hardware/gic.h>
+
+/*
+ * The interrupt numbering scheme is defined in the
+ * interrupt controller spec.  To wit:
+ *
+ * Interrupts 0-15 are IPI
+ * 16-28 are reserved
+ * 29-31 are local.  We allow 30 to be used for the watchdog.
+ * 32-1020 are global
+ * 1021-1022 are reserved
+ * 1023 is "spurious" (no interrupt)
+ *
+ * For now, we ignore all local interrupts so only return an interrupt if it's
+ * between 30 and 1020.  The test_for_ipi routine below will pick up on IPIs.
+ *
+ * A simple read from the controller will tell us the number of the highest
+ * priority enabled interrupt.  We then just need to check whether it is in the
+ * valid range for an IRQ (30-1020 inclusive).
+ */
+
+	.macro  get_irqnr_and_base, irqnr, irqstat, base, tmp
+
+	ldr     \irqstat, [\base, #GIC_CPU_INTACK]
+	/* bits 12-10 = src CPU, 9-0 = int # */
+
+	ldr	\tmp, =1021
+	bic     \irqnr, \irqstat, #0x1c00
+	cmp     \irqnr, #29
+	cmpcc	\irqnr, \irqnr
+	cmpne	\irqnr, \tmp
+	cmpcs	\irqnr, \irqnr
+	.endm
+
+/* We assume that irqstat (the raw value of the IRQ acknowledge
+ * register) is preserved from the macro above.
+ * If there is an IPI, we immediately signal end of interrupt on the
+ * controller, since this requires the original irqstat value which
+ * we won't easily be able to recreate later.
+ */
+
+	.macro test_for_ipi, irqnr, irqstat, base, tmp
+	bic	\irqnr, \irqstat, #0x1c00
+	cmp	\irqnr, #16
+	strcc	\irqstat, [\base, #GIC_CPU_EOI]
+	cmpcs	\irqnr, \irqnr
+	.endm
+
+/* As above, this assumes that irqstat and base are preserved.. */
+
+	.macro test_for_ltirq, irqnr, irqstat, base, tmp
+	bic	\irqnr, \irqstat, #0x1c00
+	mov 	\tmp, #0
+	cmp	\irqnr, #29
+	moveq	\tmp, #1
+	streq	\irqstat, [\base, #GIC_CPU_EOI]
+	cmp	\tmp, #0
+	.endm
