Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859Ab1INNtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 09:49:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36691 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab1INNtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 09:49:13 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <khilman@ti.com>,
        <aneesh@ti.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Abhilash K V <abhilash.kv@ti.com>,
        Ranjith Lohithakshan <ranjithl@ti.com>
Subject: [PATCH v2] AM3517 : support for suspend/resume
Date: Wed, 14 Sep 2011 19:18:46 +0530
Message-ID: <1316008126-7322-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set adds support for suspension to RAM and
resumption on the AM3517. This includes:
1. Patch to disable dynamic sleep (as it is not supported
   on AM35xx).
2. Imported the unique suspend/resume sequence for AM3517,
   contained in the new file arch/arm/mach-omap2/sleep3517.S.

Caveat: If "no_console_suspend" is enabled (via boot-args),the
device doesnot resume but simply hangs.
Kevin's fix below should fix this:
 http://marc.info/?l=linux-omap&m=131593828001388&w=2#1

Signed-off-by: Ranjith Lohithakshan <ranjithl@ti.com>
Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
This patch is dependent on the following patch-sets:
* [PATCH v3 0/2] AM3517: Booting up
  at http://marc.info/?l=linux-omap&m=131548349725176&w=2
* [PATCH v2 0/3] AM35x: Adding PM init
  at http://marc.info/?l=linux-kernel&m=131548606728209&w=2

The patches are tested on master of tmlind/linux-omap-2.6.git.
Kernel version is 3.1-rc3 and last commit on top of which these patches
were added is:
	b148d763841161894ed6629794064065a834aa2b: Linux-omap rebuilt: Updated to
	use omap_sdrc_init

with the folowing commit reverted:
	f3637a5f2e2eb391ff5757bc83fb5de8f9726464: irq: Always set IRQF_ONESHOT
	if no primary handler is specified

Changes in v2:
 * Synchronised with the cleaned-up suspend-resume code for OMAP3
 * Removed unused *_get_restore_pointer code
 * Added SECURE_SRAM feature to disallow saving and restoring
   secure ram context for AM35x
 * Compacted the number of patches by squashing three closely coupled
   ones and eliminating one that was no longer needed.

 arch/arm/mach-omap2/Makefile          |    3 +-
 arch/arm/mach-omap2/id.c              |    4 +-
 arch/arm/mach-omap2/pm.h              |    3 +
 arch/arm/mach-omap2/pm34xx.c          |   21 ++++-
 arch/arm/mach-omap2/sleep3517.S       |  156 +++++++++++++++++++++++++++++++++
 arch/arm/plat-omap/include/plat/cpu.h |    2 +
 6 files changed, 183 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm/mach-omap2/sleep3517.S

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 590e797..37f62ae 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -61,7 +61,7 @@ endif
 ifeq ($(CONFIG_PM),y)
 obj-$(CONFIG_ARCH_OMAP2)		+= pm24xx.o
 obj-$(CONFIG_ARCH_OMAP2)		+= sleep24xx.o
-obj-$(CONFIG_ARCH_OMAP3)		+= pm34xx.o sleep34xx.o \
+obj-$(CONFIG_ARCH_OMAP3)		+= pm34xx.o sleep34xx.o sleep3517.o \
 					   cpuidle34xx.o
 obj-$(CONFIG_ARCH_OMAP4)		+= pm44xx.o
 obj-$(CONFIG_PM_DEBUG)			+= pm-debug.o
@@ -70,6 +70,7 @@ obj-$(CONFIG_OMAP_SMARTREFLEX_CLASS3)	+= smartreflex-class3.o
 
 AFLAGS_sleep24xx.o			:=-Wa,-march=armv6
 AFLAGS_sleep34xx.o			:=-Wa,-march=armv7-a$(plus_sec)
+AFLAGS_sleep3517.o			:=-Wa,-march=armv7-a$(plus_sec)
 
 ifeq ($(CONFIG_PM_VERBOSE),y)
 CFLAGS_pm_bus.o				+= -DDEBUG
diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index da71098..3e40c02 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -202,7 +202,9 @@ static void __init omap3_check_features(void)
 	if (cpu_is_omap3630())
 		omap_features |= OMAP3_HAS_192MHZ_CLK;
 	if (!cpu_is_omap3505() && !cpu_is_omap3517())
-		omap_features |= (OMAP3_HAS_IO_WAKEUP | OMAP3_HAS_SR);
+		omap_features |= (OMAP3_HAS_IO_WAKEUP
+					| OMAP3_HAS_SR
+					| OMAP3_HAS_SECURE_SRAM);
 
 	omap_features |= OMAP3_HAS_SDRC;
 
diff --git a/arch/arm/mach-omap2/pm.h b/arch/arm/mach-omap2/pm.h
index ce028f6..952eb2b 100644
--- a/arch/arm/mach-omap2/pm.h
+++ b/arch/arm/mach-omap2/pm.h
@@ -82,10 +82,13 @@ extern unsigned int omap24xx_cpu_suspend_sz;
 
 /* 3xxx */
 extern void omap34xx_cpu_suspend(int save_state);
+extern void omap3517_cpu_suspend(int save_state);
 
 /* omap3_do_wfi function pointer and size, for copy to SRAM */
 extern void omap3_do_wfi(void);
+extern void omap3517_do_wfi(void);
 extern unsigned int omap3_do_wfi_sz;
+extern unsigned int omap3517_do_wfi_sz;
 /* ... and its pointer from SRAM after copy */
 extern void (*omap3_do_wfi_sram)(void);
 
diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 7255d9b..44f7bac 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -80,6 +80,7 @@ static LIST_HEAD(pwrst_list);
 
 static int (*_omap_save_secure_sram)(u32 *addr);
 void (*omap3_do_wfi_sram)(void);
+void (*omap3517_do_wfi_sram)(void);
 
 static struct powerdomain *mpu_pwrdm, *neon_pwrdm;
 static struct powerdomain *core_pwrdm, *per_pwrdm;
@@ -323,7 +324,10 @@ static void omap34xx_save_context(u32 *save)
 
 static int omap34xx_do_sram_idle(unsigned long save_state)
 {
-	omap34xx_cpu_suspend(save_state);
+	if (cpu_is_omap3505() || cpu_is_omap3517())
+		omap3517_cpu_suspend(save_state);
+	else
+		omap34xx_cpu_suspend(save_state);
 	return 0;
 }
 
@@ -485,6 +489,8 @@ console_still_active:
 
 int omap3_can_sleep(void)
 {
+	if (cpu_is_omap3505() || cpu_is_omap3517())
+		return 0;
 	if (!omap_uart_can_sleep())
 		return 0;
 	return 1;
@@ -843,11 +849,18 @@ static int __init clkdms_setup(struct clockdomain *clkdm, void *unused)
  */
 void omap_push_sram_idle(void)
 {
-	omap3_do_wfi_sram = omap_sram_push(omap3_do_wfi, omap3_do_wfi_sz);
+	if (cpu_is_omap3505() || cpu_is_omap3517())
+		omap3517_do_wfi_sram = omap_sram_push(omap3517_do_wfi,
+						 omap3517_do_wfi_sz);
+	else
+		omap3_do_wfi_sram = omap_sram_push(omap3_do_wfi,
+						 omap3_do_wfi_sz);
 
 	if (omap_type() != OMAP2_DEVICE_TYPE_GP)
-		_omap_save_secure_sram = omap_sram_push(save_secure_ram_context,
-				save_secure_ram_context_sz);
+		if (omap3_has_secure_sram())
+			_omap_save_secure_sram = omap_sram_push(
+						save_secure_ram_context,
+						save_secure_ram_context_sz);
 }
 
 static void __init pm_errata_configure(void)
diff --git a/arch/arm/mach-omap2/sleep3517.S b/arch/arm/mach-omap2/sleep3517.S
new file mode 100644
index 0000000..a4147bd
--- /dev/null
+++ b/arch/arm/mach-omap2/sleep3517.S
@@ -0,0 +1,156 @@
+/*
+ * AM3505/3517 Sleep Code.
+ * Ranjith Lohithakshan <ranjithl@ti.com>
+ *
+ * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <plat/sram.h>
+#include <mach/io.h>
+
+#include "cm2xxx_3xxx.h"
+#include "prm2xxx_3xxx.h"
+#include "sdrc.h"
+#include "control.h"
+
+#define CM_IDLEST1_CORE_V	OMAP34XX_CM_REGADDR(CORE_MOD, CM_IDLEST1)
+#define CM_CLKST_CORE_V		OMAP34XX_CM_REGADDR(CORE_MOD,\
+					 OMAP3430_CM_CLKSTST)
+#define CM_ICLKEN1_CORE_V	OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1)
+
+#define EMIF_PM_CTR_V		OMAP2_L3_IO_ADDRESS(0x6D000038)
+#define OMAP3517_CONF1_REG_V	OMAP2_L4_IO_ADDRESS(0x48002584)
+
+/*
+ * Forces OMAP into idle state
+ *
+ * omap3517_suspend() - This bit of code just executes the WFI
+ * for normal idles.
+ *
+ */
+ENTRY(omap3517_cpu_suspend)
+	stmfd	sp!, {r4-r12, lr}		@ save registers on stack
+loop:
+	/*b	loop*/	@Enable to debug by stepping through code
+	ldr	r4, omap3517_do_wfi_sram_addr
+	ldr	r5, [r4]
+	/*
+	 * Since OFF mode is unsupported r0 is always 0, and so no need to
+	 * save context
+	 */
+	bx	r5                      @  jump to the WFI code in SRAM
+/*
+ * Local variables
+ */
+omap3517_do_wfi_sram_addr:
+	.word omap3517_do_wfi_sram
+
+/* ===================================
+ * == WFI instruction => Enter idle ==
+ * ===================================
+ */
+
+/*
+ * Do WFI instruction
+ * Includes the resume path for non-OFF modes
+ *
+ * This code gets copied to internal SRAM and is accessible
+ * from both SDRAM and SRAM
+ * Always executed from SRAM (omap3517_do_wfi_sram),as AM35x does not
+ * support OFF mode
+ */
+	.align  3
+ENTRY(omap3517_do_wfi)
+	/* Put EMIF in self-refresh */
+	ldr	r4, emif_pm_ctrl
+	ldr	r5, [r4]
+	orr	r5, r5, #0x200
+	str	r5, [r4]
+
+	/* Disable SDRC and Control Module */
+	ldr	r4, cm_iclken1_core
+	ldr	r5, [r4]
+	str	r5, iclk_core_enable
+	ldr	r4, cm_iclken1_core
+	ldr	r5, clk_core_disable
+	str	r5, [r4]
+wait_sdrc_ok:
+	ldr	r4, cm_idlest1_core
+	ldr	r5, [r4]
+	and	r5, r5, #0x2
+	cmp	r5, #0x2
+	bne	wait_sdrc_ok
+
+	/* Gate DDR Phy clock */
+	ldr	r4, omap3517_conf1
+	ldr	r5, emif_phy_gate
+	str	r5, [r4]
+
+	/* Data memory barrier and Data sync barrier */
+	mov	r1, #0
+	mcr	p15, 0, r1, c7, c10, 4
+	mcr	p15, 0, r1, c7, c10, 5
+
+	wfi
+
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+	nop
+
+	/* Enable SDRC and Control Module */
+	ldr	r4, cm_iclken1_core
+	ldr	r5, iclk_core_enable
+	str	r5, [r4]
+
+	/* Enable DDR Phy Clock */
+	ldr	r4, omap3517_conf1
+	ldr	r5, emif_phy_enable
+	str	r5, [r4]
+
+	/* Take EMIF out of self-refresh */
+	ldr	r4, emif_pm_ctrl
+	ldr	r5, [r4]
+	bic	r5, r5, #0x200
+	str	r5, [r4]
+
+	ldmfd	sp!, {r4-r12, pc}		@ restore regs and return
+
+clk_core_disable:
+	.word	0x0
+iclk_core_enable:
+	.word	0x0
+emif_phy_gate:
+	.word	0x2620
+emif_phy_enable:
+	.word	0x8620
+cm_idlest1_core:
+	.word	CM_IDLEST1_CORE_V
+cm_clkst_core:
+	.word	CM_CLKST_CORE_V
+emif_pm_ctrl:
+	.word	EMIF_PM_CTR_V
+cm_iclken1_core:
+	.word	CM_ICLKEN1_CORE_V
+omap3517_conf1:
+	.word	OMAP3517_CONF1_REG_V
+ENTRY(omap3517_do_wfi_sz)
+	.word	. - omap3517_do_wfi
+
diff --git a/arch/arm/plat-omap/include/plat/cpu.h b/arch/arm/plat-omap/include/plat/cpu.h
index 294e015..7daeb36 100644
--- a/arch/arm/plat-omap/include/plat/cpu.h
+++ b/arch/arm/plat-omap/include/plat/cpu.h
@@ -492,6 +492,7 @@ extern u32 omap_features;
 #define OMAP4_HAS_MPU_1_2GHZ		BIT(9)
 #define OMAP4_HAS_MPU_1_5GHZ		BIT(10)
 #define OMAP3_HAS_SR			BIT(11)
+#define OMAP3_HAS_SECURE_SRAM		BIT(12)
 
 
 #define OMAP3_HAS_FEATURE(feat,flag)			\
@@ -509,6 +510,7 @@ OMAP3_HAS_FEATURE(192mhz_clk, 192MHZ_CLK)
 OMAP3_HAS_FEATURE(io_wakeup, IO_WAKEUP)
 OMAP3_HAS_FEATURE(sdrc, SDRC)
 OMAP3_HAS_FEATURE(sr, SR)
+OMAP3_HAS_FEATURE(secure_sram, SECURE_SRAM)
 
 /*
  * Runtime detection of OMAP4 features
-- 
1.7.1

