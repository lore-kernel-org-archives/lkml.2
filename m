Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab2ILXae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:30:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37074 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab2ILXa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:30:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Shawn Guo <shawn.guo@linaro.org>, Eric Miao <eric.miao@linaro.org>
Subject: [ 016/108] ARM: imx: build i.MX6 functions only when needed
Date: Wed, 12 Sep 2012 16:28:14 -0700
Message-Id: <20120912232452.227346030@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 1fc593feaf8e440511f381f4cdff483b55bbf546 upstream.

The head-v7.S contains a call to the generic cpu_suspend function,
which is only available when selected by the i.MX6 code. As
pointed out by Shawn Guo, i.MX5 does not actually use any
functions defined in head-v7.S. It is also needed only for
the i.MX6 power management code and for the SMP code, so
we can restrict building this file to situations in which
at least one of those two is present.

Finally, other platforms with a similar file call it headsmp.S,
so we can rename it to the same for consistency.

Without this patch, building imx5 standalone results in:

arch/arm/mach-imx/built-in.o: In function `v7_cpu_resume':
arch/arm/mach-imx/head-v7.S:104: undefined reference to `cpu_resume'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Eric Miao <eric.miao@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/Makefile  |    7 +-
 arch/arm/mach-imx/head-v7.S |  106 --------------------------------------------
 arch/arm/mach-imx/headsmp.S |  106 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 109 insertions(+), 110 deletions(-)

--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -70,14 +70,13 @@ obj-$(CONFIG_DEBUG_LL) += lluart.o
 obj-$(CONFIG_HAVE_IMX_GPC) += gpc.o
 obj-$(CONFIG_HAVE_IMX_MMDC) += mmdc.o
 obj-$(CONFIG_HAVE_IMX_SRC) += src.o
-obj-$(CONFIG_CPU_V7) += head-v7.o
-AFLAGS_head-v7.o :=-Wa,-march=armv7-a
-obj-$(CONFIG_SMP) += platsmp.o
+AFLAGS_headsmp.o :=-Wa,-march=armv7-a
+obj-$(CONFIG_SMP) += headsmp.o platsmp.o
 obj-$(CONFIG_HOTPLUG_CPU) += hotplug.o
 obj-$(CONFIG_SOC_IMX6Q) += clk-imx6q.o mach-imx6q.o
 
 ifeq ($(CONFIG_PM),y)
-obj-$(CONFIG_SOC_IMX6Q) += pm-imx6q.o
+obj-$(CONFIG_SOC_IMX6Q) += pm-imx6q.o headsmp.o
 endif
 
 # i.MX5 based machines
--- a/arch/arm/mach-imx/head-v7.S
+++ /dev/null
@@ -1,106 +0,0 @@
-/*
- * Copyright 2011 Freescale Semiconductor, Inc.
- * Copyright 2011 Linaro Ltd.
- *
- * The code contained herein is licensed under the GNU General Public
- * License. You may obtain a copy of the GNU General Public License
- * Version 2 or later at the following locations:
- *
- * http://www.opensource.org/licenses/gpl-license.html
- * http://www.gnu.org/copyleft/gpl.html
- */
-
-#include <linux/linkage.h>
-#include <linux/init.h>
-#include <asm/asm-offsets.h>
-#include <asm/hardware/cache-l2x0.h>
-
-	.section ".text.head", "ax"
-
-/*
- * The secondary kernel init calls v7_flush_dcache_all before it enables
- * the L1; however, the L1 comes out of reset in an undefined state, so
- * the clean + invalidate performed by v7_flush_dcache_all causes a bunch
- * of cache lines with uninitialized data and uninitialized tags to get
- * written out to memory, which does really unpleasant things to the main
- * processor.  We fix this by performing an invalidate, rather than a
- * clean + invalidate, before jumping into the kernel.
- *
- * This funciton is cloned from arch/arm/mach-tegra/headsmp.S, and needs
- * to be called for both secondary cores startup and primary core resume
- * procedures.  Ideally, it should be moved into arch/arm/mm/cache-v7.S.
- */
-ENTRY(v7_invalidate_l1)
-	mov	r0, #0
-	mcr	p15, 0, r0, c7, c5, 0	@ invalidate I cache
-	mcr	p15, 2, r0, c0, c0, 0
-	mrc	p15, 1, r0, c0, c0, 0
-
-	ldr	r1, =0x7fff
-	and	r2, r1, r0, lsr #13
-
-	ldr	r1, =0x3ff
-
-	and	r3, r1, r0, lsr #3	@ NumWays - 1
-	add	r2, r2, #1		@ NumSets
-
-	and	r0, r0, #0x7
-	add	r0, r0, #4	@ SetShift
-
-	clz	r1, r3		@ WayShift
-	add	r4, r3, #1	@ NumWays
-1:	sub	r2, r2, #1	@ NumSets--
-	mov	r3, r4		@ Temp = NumWays
-2:	subs	r3, r3, #1	@ Temp--
-	mov	r5, r3, lsl r1
-	mov	r6, r2, lsl r0
-	orr	r5, r5, r6	@ Reg = (Temp<<WayShift)|(NumSets<<SetShift)
-	mcr	p15, 0, r5, c7, c6, 2
-	bgt	2b
-	cmp	r2, #0
-	bgt	1b
-	dsb
-	isb
-	mov	pc, lr
-ENDPROC(v7_invalidate_l1)
-
-#ifdef CONFIG_SMP
-ENTRY(v7_secondary_startup)
-	bl	v7_invalidate_l1
-	b	secondary_startup
-ENDPROC(v7_secondary_startup)
-#endif
-
-#ifdef CONFIG_PM
-/*
- * The following code is located into the .data section.  This is to
- * allow phys_l2x0_saved_regs to be accessed with a relative load
- * as we are running on physical address here.
- */
-	.data
-	.align
-
-#ifdef CONFIG_CACHE_L2X0
-	.macro	pl310_resume
-	ldr	r2, phys_l2x0_saved_regs
-	ldr	r0, [r2, #L2X0_R_PHY_BASE]	@ get physical base of l2x0
-	ldr	r1, [r2, #L2X0_R_AUX_CTRL]	@ get aux_ctrl value
-	str	r1, [r0, #L2X0_AUX_CTRL]	@ restore aux_ctrl
-	mov	r1, #0x1
-	str	r1, [r0, #L2X0_CTRL]		@ re-enable L2
-	.endm
-
-	.globl	phys_l2x0_saved_regs
-phys_l2x0_saved_regs:
-        .long   0
-#else
-	.macro	pl310_resume
-	.endm
-#endif
-
-ENTRY(v7_cpu_resume)
-	bl	v7_invalidate_l1
-	pl310_resume
-	b	cpu_resume
-ENDPROC(v7_cpu_resume)
-#endif
--- /dev/null
+++ b/arch/arm/mach-imx/headsmp.S
@@ -0,0 +1,106 @@
+/*
+ * Copyright 2011 Freescale Semiconductor, Inc.
+ * Copyright 2011 Linaro Ltd.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <asm/asm-offsets.h>
+#include <asm/hardware/cache-l2x0.h>
+
+	.section ".text.head", "ax"
+
+/*
+ * The secondary kernel init calls v7_flush_dcache_all before it enables
+ * the L1; however, the L1 comes out of reset in an undefined state, so
+ * the clean + invalidate performed by v7_flush_dcache_all causes a bunch
+ * of cache lines with uninitialized data and uninitialized tags to get
+ * written out to memory, which does really unpleasant things to the main
+ * processor.  We fix this by performing an invalidate, rather than a
+ * clean + invalidate, before jumping into the kernel.
+ *
+ * This funciton is cloned from arch/arm/mach-tegra/headsmp.S, and needs
+ * to be called for both secondary cores startup and primary core resume
+ * procedures.  Ideally, it should be moved into arch/arm/mm/cache-v7.S.
+ */
+ENTRY(v7_invalidate_l1)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c5, 0	@ invalidate I cache
+	mcr	p15, 2, r0, c0, c0, 0
+	mrc	p15, 1, r0, c0, c0, 0
+
+	ldr	r1, =0x7fff
+	and	r2, r1, r0, lsr #13
+
+	ldr	r1, =0x3ff
+
+	and	r3, r1, r0, lsr #3	@ NumWays - 1
+	add	r2, r2, #1		@ NumSets
+
+	and	r0, r0, #0x7
+	add	r0, r0, #4	@ SetShift
+
+	clz	r1, r3		@ WayShift
+	add	r4, r3, #1	@ NumWays
+1:	sub	r2, r2, #1	@ NumSets--
+	mov	r3, r4		@ Temp = NumWays
+2:	subs	r3, r3, #1	@ Temp--
+	mov	r5, r3, lsl r1
+	mov	r6, r2, lsl r0
+	orr	r5, r5, r6	@ Reg = (Temp<<WayShift)|(NumSets<<SetShift)
+	mcr	p15, 0, r5, c7, c6, 2
+	bgt	2b
+	cmp	r2, #0
+	bgt	1b
+	dsb
+	isb
+	mov	pc, lr
+ENDPROC(v7_invalidate_l1)
+
+#ifdef CONFIG_SMP
+ENTRY(v7_secondary_startup)
+	bl	v7_invalidate_l1
+	b	secondary_startup
+ENDPROC(v7_secondary_startup)
+#endif
+
+#ifdef CONFIG_PM
+/*
+ * The following code is located into the .data section.  This is to
+ * allow phys_l2x0_saved_regs to be accessed with a relative load
+ * as we are running on physical address here.
+ */
+	.data
+	.align
+
+#ifdef CONFIG_CACHE_L2X0
+	.macro	pl310_resume
+	ldr	r2, phys_l2x0_saved_regs
+	ldr	r0, [r2, #L2X0_R_PHY_BASE]	@ get physical base of l2x0
+	ldr	r1, [r2, #L2X0_R_AUX_CTRL]	@ get aux_ctrl value
+	str	r1, [r0, #L2X0_AUX_CTRL]	@ restore aux_ctrl
+	mov	r1, #0x1
+	str	r1, [r0, #L2X0_CTRL]		@ re-enable L2
+	.endm
+
+	.globl	phys_l2x0_saved_regs
+phys_l2x0_saved_regs:
+        .long   0
+#else
+	.macro	pl310_resume
+	.endm
+#endif
+
+ENTRY(v7_cpu_resume)
+	bl	v7_invalidate_l1
+	pl310_resume
+	b	cpu_resume
+ENDPROC(v7_cpu_resume)
+#endif


