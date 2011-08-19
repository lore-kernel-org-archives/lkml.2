Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1HSL4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:56:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44059 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab1HSLzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:55:51 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <khilman@ti.com>,
        Abhilash K V <abhilash.kv@ti.com>,
        Ranjith Lohithakshan <ranjithl@ti.com>
Subject: [PATCH 1/4] AM3517 : support for suspend/resume
Date: Fri, 19 Aug 2011 17:25:24 +0530
Message-ID: <1313754927-11992-2-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1313754927-11992-1-git-send-email-abhilash.kv@ti.com>
References: <1313754927-11992-1-git-send-email-abhilash.kv@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Patch to disable dynamic sleep (as it is not supported
   on AM35xx).
2. Imported the unique suspend/resume sequence for AM3517,
   contained in the new file arch/arm/mach-omap2/sleep3517.S.
3. Added omap3517_ to symbol-names in sleep3517.S which are common
   with sleep34xx.S, and added appropriate checks.

There are still 3 caveats:

1. If "no_console_suspend" is enabled (via boot-args), the device
   doesnot resume but simply hangs.
2. Every second and subsequent attempt to suspend/resume prints this slow-path
   WARNING (for both uart1 and uart2), while resuming :
   [   70.943939] omap_hwmod: uart1: idle state can only be entered from
   enabled state
3. Wakeup using the TSC2004 touch-screen controller is not supported.

Signed-off-by: Ranjith Lohithakshan <ranjithl@ti.com>
Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/mach-omap2/Makefile    |    2 +-
 arch/arm/mach-omap2/control.c   |    7 ++-
 arch/arm/mach-omap2/control.h   |    1 +
 arch/arm/mach-omap2/pm.h        |    4 +
 arch/arm/mach-omap2/pm34xx.c    |   18 ++++-
 arch/arm/mach-omap2/sleep3517.S |  144 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 170 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm/mach-omap2/sleep3517.S

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 46f5fbc..3fdf086 100644
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
diff --git a/arch/arm/mach-omap2/control.c b/arch/arm/mach-omap2/control.c
index da53ba3..7d2d8a8 100644
--- a/arch/arm/mach-omap2/control.c
+++ b/arch/arm/mach-omap2/control.c
@@ -284,10 +284,13 @@ void omap3_save_scratchpad_contents(void)
 	 * The restore pointer is stored into the scratchpad.
 	 */
 	scratchpad_contents.boot_config_ptr = 0x0;
-	if (cpu_is_omap3630())
+	if (cpu_is_omap3505() || cpu_is_omap3517()) {
+		scratchpad_contents.public_restore_ptr =
+			virt_to_phys(omap3517_get_restore_pointer());
+	} else if (cpu_is_omap3630()) {
 		scratchpad_contents.public_restore_ptr =
 			virt_to_phys(get_omap3630_restore_pointer());
-	else if (omap_rev() != OMAP3430_REV_ES3_0 &&
+	} else if (omap_rev() != OMAP3430_REV_ES3_0 &&
 					omap_rev() != OMAP3430_REV_ES3_1)
 		scratchpad_contents.public_restore_ptr =
 			virt_to_phys(get_restore_pointer());
diff --git a/arch/arm/mach-omap2/control.h b/arch/arm/mach-omap2/control.h
index ad024df..3003940 100644
--- a/arch/arm/mach-omap2/control.h
+++ b/arch/arm/mach-omap2/control.h
@@ -389,6 +389,7 @@ extern void omap4_ctrl_pad_writel(u32 val, u16 offset);
 extern void omap3_save_scratchpad_contents(void);
 extern void omap3_clear_scratchpad_contents(void);
 extern u32 *get_restore_pointer(void);
+extern u32 *omap3517_get_restore_pointer(void);
 extern u32 *get_es3_restore_pointer(void);
 extern u32 *get_omap3630_restore_pointer(void);
 extern u32 omap3_arm_context[128];
diff --git a/arch/arm/mach-omap2/pm.h b/arch/arm/mach-omap2/pm.h
index 5c2bd2f..d773e07 100644
--- a/arch/arm/mach-omap2/pm.h
+++ b/arch/arm/mach-omap2/pm.h
@@ -77,13 +77,17 @@ extern void omap24xx_idle_loop_suspend(void);
 extern void omap24xx_cpu_suspend(u32 dll_ctrl, void __iomem *sdrc_dlla_ctrl,
 					void __iomem *sdrc_power);
 extern void omap34xx_cpu_suspend(u32 *addr, int save_state);
+extern void omap3517_cpu_suspend(u32 *addr, int save_state);
 extern int save_secure_ram_context(u32 *addr);
+extern void omap3517_save_secure_ram_context(u32 *addr);
 extern void omap3_save_scratchpad_contents(void);
 
 extern unsigned int omap24xx_idle_loop_suspend_sz;
 extern unsigned int save_secure_ram_context_sz;
+extern unsigned int omap3517_save_secure_ram_context_sz;
 extern unsigned int omap24xx_cpu_suspend_sz;
 extern unsigned int omap34xx_cpu_suspend_sz;
+extern unsigned int omap3517_cpu_suspend_sz;
 
 #define PM_RTA_ERRATUM_i608		(1 << 0)
 #define PM_SDRC_WAKEUP_ERRATUM_i583	(1 << 1)
diff --git a/arch/arm/mach-omap2/pm34xx.c b/arch/arm/mach-omap2/pm34xx.c
index 96a7624..12af5b9 100644
--- a/arch/arm/mach-omap2/pm34xx.c
+++ b/arch/arm/mach-omap2/pm34xx.c
@@ -497,6 +497,8 @@ console_still_active:
 
 int omap3_can_sleep(void)
 {
+	if (cpu_is_omap3505() || cpu_is_omap3517())
+		return 0;
 	if (!omap_uart_can_sleep())
 		return 0;
 	return 1;
@@ -848,11 +850,21 @@ static int __init clkdms_setup(struct clockdomain *clkdm, void *unused)
 
 void omap_push_sram_idle(void)
 {
-	_omap_sram_idle = omap_sram_push(omap34xx_cpu_suspend,
+	if (cpu_is_omap3505() || cpu_is_omap3517())
+		_omap_sram_idle = omap_sram_push(omap3517_cpu_suspend,
+					omap3517_cpu_suspend_sz);
+	else
+		_omap_sram_idle = omap_sram_push(omap34xx_cpu_suspend,
 					omap34xx_cpu_suspend_sz);
 	if (omap_type() != OMAP2_DEVICE_TYPE_GP)
-		_omap_save_secure_sram = omap_sram_push(save_secure_ram_context,
-				save_secure_ram_context_sz);
+		if (cpu_is_omap3505() || cpu_is_omap3517())
+			_omap_save_secure_sram = omap_sram_push(
+					omap3517_save_secure_ram_context,
+					omap3517_save_secure_ram_context_sz);
+		else
+			_omap_save_secure_sram = omap_sram_push(
+					save_secure_ram_context,
+					save_secure_ram_context_sz);
 }
 
 static void __init pm_errata_configure(void)
diff --git a/arch/arm/mach-omap2/sleep3517.S b/arch/arm/mach-omap2/sleep3517.S
new file mode 100644
index 0000000..3fceefc
--- /dev/null
+++ b/arch/arm/mach-omap2/sleep3517.S
@@ -0,0 +1,144 @@
+/*
+/* linux/arch/arm/mach-omap2/sleep3517.S
+ *
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
+#define CM_IDLEST1_CORE_V OMAP34XX_CM_REGADDR(CORE_MOD, CM_IDLEST1)
+#define CM_CLKST_CORE_V   OMAP34XX_CM_REGADDR(CORE_MOD, OMAP3430_CM_CLKSTST)
+#define CM_ICLKEN1_CORE_V OMAP34XX_CM_REGADDR(CORE_MOD, CM_ICLKEN1)
+
+#define EMIF_PM_CTR_V           OMAP2_L3_IO_ADDRESS(0x6D000038)
+#define OMAP3517_CONF1_REG_V    OMAP2_L4_IO_ADDRESS(0x48002584)
+
+/*
+ * Forces OMAP into idle state
+ *
+ * omap34xx_suspend() - This bit of code just executes the WFI
+ * for normal idles.
+ *
+ * Note: This code get's copied to internal SRAM at boot. When the OMAP
+ *	 wakes up it continues execution at the point it went to sleep.
+ */
+ENTRY(omap3517_cpu_suspend)
+	stmfd	sp!, {r0-r12, lr}		@ save registers on stack
+loop:
+	/*b	loop*/	@Enable to debug by stepping through code
+
+	/* Put EMIF in self-refresh */
+	ldr     r4, emif_pm_ctrl
+	ldr     r5, [r4]
+	orr     r5, r5, #0x200
+	str     r5, [r4]
+
+	/* Disable SDRC and Control Module */
+	ldr     r4, cm_iclken1_core
+	ldr     r5, clk_core_disable
+	str     r5, [r4]
+wait_sdrc_ok:
+	ldr     r4, cm_idlest1_core
+	ldr     r5, [r4]
+	and     r5, r5, #0x2
+	cmp     r5, #0x2
+	bne     wait_sdrc_ok
+
+	/* Gate DDR Phy clock */
+	ldr     r4, omap3517_conf1
+	ldr     r5, emif_phy_gate
+	str     r5, [r4]
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
+	ldr     r4, cm_iclken1_core
+	ldr     r5, iclk_core_enable
+	str     r5, [r4]
+
+	/* Enable DDR Phy Clock */
+	ldr     r4, omap3517_conf1
+	ldr     r5, emif_phy_enable
+	str     r5, [r4]
+
+	/* Take EMIF out of self-refresh */
+	ldr     r4, emif_pm_ctrl
+	ldr     r5, [r4]
+	bic     r5, r5, #0x200
+	str     r5, [r4]
+
+	ldmfd	sp!, {r0-r12, pc}		@ restore regs and return
+
+clk_core_disable:
+	.word   0x0
+iclk_core_enable:
+	.word   0x42
+emif_phy_gate:
+	.word   0x2620
+emif_phy_enable:
+	.word   0x8620
+cm_idlest1_core:
+	.word   CM_IDLEST1_CORE_V
+cm_clkst_core:
+	.word   CM_CLKST_CORE_V
+emif_pm_ctrl:
+	.word   EMIF_PM_CTR_V
+cm_iclken1_core:
+	.word   CM_ICLKEN1_CORE_V
+omap3517_conf1:
+	.word   OMAP3517_CONF1_REG_V
+ENTRY(omap3517_cpu_suspend_sz)
+	.word	. - omap3517_cpu_suspend
+
+/* Function to call rom code to save secure ram context */
+ENTRY(omap3517_save_secure_ram_context)
+	stmfd   sp!, {r1-r12, lr}   @ save registers on stack
+save_secure_ram_debug:
+	/* b save_secure_ram_debug */   @ enable to debug save code
+	ldmfd   sp!, {r1-r12, pc}
+ENTRY(omap3517_save_secure_ram_context_sz)
+	.word   . - omap3517_save_secure_ram_context
+
+/* Function call to get the restore pointer for resume from OFF */
+ENTRY(omap3517_get_restore_pointer)
+	stmfd   sp!, {lr}     @ save registers on stack
+	ldmfd   sp!, {pc}     @ restore regs and return
+ENTRY(omap3517_get_restore_pointer_sz)
+	.word   . - omap3517_get_restore_pointer
+
-- 
1.7.1

