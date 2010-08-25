Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab0HYE7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 00:59:11 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17518 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0HYE6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 00:58:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6084"; a="52012248"
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="72366140"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 10/24] msm: irq: rename existing entry-macro to entry-macro-vic
Date: Tue, 24 Aug 2010 21:57:39 -0700
Message-Id: <1282712273-344-11-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Muckle <smuckle@codeaurora.org>

The existing MSM irq entry macro is specific to a VIC
implementation. Renaming this makes room for irq support based on
other interrupt controllers.

Signed-off-by: Steve Muckle <smuckle@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/entry-macro-qgic.S |   96 +++++++++++++++++++++
 arch/arm/mach-msm/include/mach/entry-macro-vic.S  |   37 ++++++++
 arch/arm/mach-msm/include/mach/entry-macro.S      |   43 +++------
 arch/arm/mach-msm/include/mach/smp.h              |   39 +++++++++
 4 files changed, 186 insertions(+), 29 deletions(-)
 create mode 100644 arch/arm/mach-msm/include/mach/entry-macro-qgic.S
 create mode 100644 arch/arm/mach-msm/include/mach/entry-macro-vic.S
 create mode 100644 arch/arm/mach-msm/include/mach/smp.h

diff --git a/arch/arm/mach-msm/include/mach/entry-macro-qgic.S b/arch/arm/mach-msm/include/mach/entry-macro-qgic.S
new file mode 100644
index 0000000..092e48e
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/entry-macro-qgic.S
@@ -0,0 +1,96 @@
+/*
+ * Low-level IRQ helper macros
+ *
+ * Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This file is licensed under  the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <mach/hardware.h>
+#include <asm/hardware/gic.h>
+
+	.macro	disable_fiq
+	.endm
+
+	.macro  get_irqnr_preamble, base, tmp
+	ldr	\base, =gic_cpu_base_addr
+	ldr	\base, [\base]
+	.endm
+
+	.macro  arch_ret_to_user, tmp1, tmp2
+	.endm
+
+	/*
+	 * The interrupt numbering scheme is defined in the
+	 * interrupt controller spec.  To wit:
+	 *
+	 * Migrated the code from ARM MP port to be more consistant
+	 * with interrupt processing , the following still holds true
+	 * however, all interrupts are treated the same regardless of
+	 * if they are local IPI or PPI
+	 *
+	 * Interrupts 0-15 are IPI
+	 * 16-31 are PPI
+	 *   (16-18 are the timers)
+	 * 32-1020 are global
+	 * 1021-1022 are reserved
+	 * 1023 is "spurious" (no interrupt)
+	 *
+	 * A simple read from the controller will tell us the number of the
+	 * highest priority enabled interrupt.  We then just need to check
+	 * whether it is in the valid range for an IRQ (0-1020 inclusive).
+	 *
+	 * Base ARM code assumes that the local (private) peripheral interrupts
+	 * are not valid, we treat them differently, in that the privates are
+	 * handled like normal shared interrupts with the exception that only
+	 * one processor can register the interrupt and the handler must be
+	 * the same for all processors.
+	 */
+
+	.macro  get_irqnr_and_base, irqnr, irqstat, base, tmp
+
+	ldr  \irqstat, [\base, #GIC_CPU_INTACK] /* bits 12-10 =srcCPU,
+						   9-0 =int # */
+
+	bic     \irqnr, \irqstat, #0x1c00	@mask src
+#ifdef CONFIG_REQUEST_IPI
+	cmp     \irqnr, #0
+#else
+	cmp     \irqnr, #15
+#endif
+	ldr		\tmp, =1021
+	cmpcc	\irqnr, \irqnr
+	cmpne	\irqnr, \tmp
+	cmpcs	\irqnr, \irqnr
+
+	.endm
+
+	/* We assume that irqstat (the raw value of the IRQ acknowledge
+	 * register) is preserved from the macro above.
+	 * If there is an IPI, we immediately signal end of interrupt on the
+	 * controller, since this requires the original irqstat value which
+	 * we won't easily be able to recreate later.
+	 */
+	.macro test_for_ipi, irqnr, irqstat, base, tmp
+#ifndef CONFIG_REQUEST_IPI
+    bic \irqnr, \irqstat, #0x1c00
+    cmp \irqnr, #16
+    strcc   \irqstat, [\base, #GIC_CPU_EOI]
+    cmpcs   \irqnr, \irqnr
+#endif
+	.endm
+
+	/* As above, this assumes that irqstat and base are preserved.. */
+
+	.macro test_for_ltirq, irqnr, irqstat, base, tmp
+#ifndef CONFIG_REQUEST_IPI
+    bic \irqnr, \irqstat, #0x1c00
+    mov     \tmp, #0
+    cmp \irqnr, #16
+    moveq   \tmp, #1
+    streq   \irqstat, [\base, #GIC_CPU_EOI]
+    cmp \tmp, #0
+#endif
+	.endm
diff --git a/arch/arm/mach-msm/include/mach/entry-macro-vic.S b/arch/arm/mach-msm/include/mach/entry-macro-vic.S
new file mode 100644
index 0000000..70563ed
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/entry-macro-vic.S
@@ -0,0 +1,37 @@
+/*
+ * Copyright (C) 2007 Google, Inc.
+ * Author: Brian Swetland <swetland@google.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <mach/msm_iomap.h>
+
+	.macro	disable_fiq
+	.endm
+
+	.macro	get_irqnr_preamble, base, tmp
+	@ enable imprecise aborts
+	cpsie	a
+	mov	\base, #MSM_VIC_BASE
+	.endm
+
+	.macro	arch_ret_to_user, tmp1, tmp2
+	.endm
+
+	.macro	get_irqnr_and_base, irqnr, irqstat, base, tmp
+	@ 0xD0 has irq# or old irq# if the irq has been handled
+	@ 0xD4 has irq# or -1 if none pending *but* if you just
+	@ read 0xD4 you never get the first irq for some reason
+	ldr	\irqnr, [\base, #0xD0]
+	ldr	\irqnr, [\base, #0xD4]
+	cmp	\irqnr, #0xffffffff
+	.endm
diff --git a/arch/arm/mach-msm/include/mach/entry-macro.S b/arch/arm/mach-msm/include/mach/entry-macro.S
index d225948..b16f082 100644
--- a/arch/arm/mach-msm/include/mach/entry-macro.S
+++ b/arch/arm/mach-msm/include/mach/entry-macro.S
@@ -1,38 +1,23 @@
-/* arch/arm/mach-msm7200/include/mach/entry-macro.S
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
  *
- * Copyright (C) 2007 Google, Inc.
- * Author: Brian Swetland <swetland@google.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
  */
 
-#include <mach/msm_iomap.h>
-
- 	.macro	disable_fiq
-	.endm
-
-	.macro	get_irqnr_preamble, base, tmp
-	@ enable imprecise aborts
-	cpsie	a
-	mov	\base, #MSM_VIC_BASE
-	.endm
-
-	.macro	arch_ret_to_user, tmp1, tmp2
-	.endm
-
-	.macro	get_irqnr_and_base, irqnr, irqstat, base, tmp
-	@ 0xD0 has irq# or old irq# if the irq has been handled
-	@ 0xD4 has irq# or -1 if none pending *but* if you just
-	@ read 0xD4 you never get the first irq for some reason
-	ldr	\irqnr, [\base, #0xD0]
-	ldr	\irqnr, [\base, #0xD4]
-	cmp	\irqnr, #0xffffffff
-	.endm
+#if defined(CONFIG_ARM_GIC)
+#include <mach/entry-macro-qgic.S>
+#else
+#include <mach/entry-macro-vic.S>
+#endif
diff --git a/arch/arm/mach-msm/include/mach/smp.h b/arch/arm/mach-msm/include/mach/smp.h
new file mode 100644
index 0000000..3ff7bf5
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/smp.h
@@ -0,0 +1,39 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Code Aurora nor
+ *       the names of its contributors may be used to endorse or promote
+ *       products derived from this software without specific prior written
+ *       permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
+ * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
+ * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
+ * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
+ * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
+ * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
+ * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#ifndef __ASM_ARCH_MSM_SMP_H
+#define __ASM_ARCH_MSM_SMP_H
+
+#include <asm/hardware/gic.h>
+
+static inline void smp_cross_call(const struct cpumask *mask)
+{
+	gic_raise_softirq(mask, 1);
+}
+
+#endif
-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
