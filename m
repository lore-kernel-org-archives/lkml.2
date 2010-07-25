Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab0GYRLl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 13:11:41 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:47239 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab0GYRLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 13:11:22 -0400
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Richard Woodruff <r-woodruff2@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] save and restore etm state across core OFF modes
Date: Sun, 25 Jul 2010 20:05:19 +0300
Message-Id: <1280077520-7538-7-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
References: <13B9B4C6EF24D648824FF11BE896716203BADA0745@dlee02.ent.ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prevents ETM stalls whenever core enters OFF mode. Original patch
author is Richard Woodruff <r-woodruff2@ti.com>.

This version of the patch makes use of the ETM OS save/restore mechanism,
which takes about 55 words in omap3_arm_context[] instead of 128. Also,
saving ETM context can be switched on/off at runtime.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
Cc: Richard Woodruff <r-woodruff2@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-omap2/Kconfig               |    9 ++
 arch/arm/mach-omap2/control.c             |    2 +-
 arch/arm/mach-omap2/sleep34xx.S           |  135 +++++++++++++++++++++++++++++
 arch/arm/plat-omap/include/plat/control.h |    2 +-
 4 files changed, 146 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index b48bacf..0413d88 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -243,6 +243,15 @@ config MACH_OMAP4_PANDA
 	default y
 	depends on ARCH_OMAP4
 
+config ENABLE_OFF_MODE_JTAG_ETM_DEBUG
+	bool "Enable hardware emulation context save and restore"
+	depends on ARCH_OMAP3
+	default y
+	help
+	  This option enables JTAG & ETM debugging across power states.
+	  With out this option emulation features are reset across OFF
+	  mode state changes.
+
 config OMAP3_EMU
 	bool "OMAP3 debugging peripherals"
 	depends on ARCH_OMAP3
diff --git a/arch/arm/mach-omap2/control.c b/arch/arm/mach-omap2/control.c
index a8d20ee..22dd240 100644
--- a/arch/arm/mach-omap2/control.c
+++ b/arch/arm/mach-omap2/control.c
@@ -93,7 +93,7 @@ void *omap3_secure_ram_storage;
  * The address is stored in scratchpad, so that it can be used
  * during the restore path.
  */
-u32 omap3_arm_context[128];
+u32 omap3_arm_context[256];
 
 struct omap3_control_regs {
 	u32 sysconfig;
diff --git a/arch/arm/mach-omap2/sleep34xx.S b/arch/arm/mach-omap2/sleep34xx.S
index d522cd7..cd6a1d4 100644
--- a/arch/arm/mach-omap2/sleep34xx.S
+++ b/arch/arm/mach-omap2/sleep34xx.S
@@ -28,6 +28,7 @@
 #include <asm/assembler.h>
 #include <mach/io.h>
 #include <plat/control.h>
+#include <asm/hardware/coresight.h>
 
 #include "cm.h"
 #include "prm.h"
@@ -226,6 +227,18 @@ loop:
 	nop
 	bl wait_sdrc_ok
 
+#ifdef CONFIG_ENABLE_OFF_MODE_JTAG_ETM_DEBUG
+	/*
+	 * Restore Coresight debug registers
+	 */
+	ldr	r6, debug_vbase		/* base Vaddr of CortexA8-Debug */
+	ldr	r4, debug_xlar_key	/* get lock key for OSLAR */
+	bl	unlock_debug		/* remove global lock if set */
+	ldr	r6, etm_vbase		/* base Vaddr of ETM */
+	bl	unlock_debug		/* remove global lock if set */
+	str	r6, [r6, #ETMMR_OSLAR]	/* clear OSLAR lock using non-key */
+#endif
+
 	ldmfd	sp!, {r0-r12, pc}		@ restore regs and return
 restore_es3:
 	/*b restore_es3*/		@ Enable to debug restore code
@@ -385,6 +398,44 @@ logic_l1_restore:
 	/*normal memory remap register */
 	MCR p15, 0, r5, c10, c2, 1
 
+#ifdef CONFIG_ENABLE_OFF_MODE_JTAG_ETM_DEBUG
+	/*
+	 * Restore Coresight debug registers
+	 */
+	ldr	r6, debug_pbase		/* base paddr of CortexA8-Debug */
+	ldr	r4, debug_xlar_key	/* get lock key for OSLAR */
+	bl	unlock_debug		/* remove global lock if set */
+	str	r4, [r6, #ETMMR_OSLAR]	/* reset-pointer (already locked) */
+	ldr	r4, [r6, #ETMMR_OSSRR]	/* dummy read */
+	ldr	r4, [r3], #4		/* load save size */
+	cmp	r4, #0			/* check for zero */
+debug_restore:
+	ittt	ne			/* t2/compat if-then block */
+	ldrne	r5, [r3], #4		/* get saved value */
+	strne	r5, [r6,#ETMMR_OSSRR]	/* restore saved value */
+	subnes	r4, r4, #1		/* decrement loop */
+	bne	debug_restore		/* loop till done */
+	str	r5, [r6, #ETMMR_OSSRR]	/* clear lock */
+	/*
+	 * Restore CoreSight ETM registers
+	 */
+	ldr	r6, etm_pbase		/* base paddr of ETM */
+	ldr	r4, debug_xlar_key	/* get lock key for OSLAR */
+	bl	unlock_debug		/* remove global lock if set */
+	str	r4, [r6, #ETMMR_OSLAR]	/* reset-pointer (already locked) */
+	ldr	r4, [r6, #ETMMR_OSSRR]	/* dummy read */
+	ldr	r4, [r3], #4		/* load save size */
+	cmp	r4, #0			/* check for zero */
+	beq	etm_skip
+etm_restore:
+	ldrne	r5, [r3], #4		/* get saved value */
+	strne	r5, [r6, #ETMMR_OSSRR]	/* restore saved value */
+	subnes	r4, r4, #1		/* decrement loop */
+	bne	etm_restore		/* loop till done */
+etm_skip:
+	str	r6, [r6, #ETMMR_OSLAR]	/* remove OS lock */
+#endif
+
 	/* Restore cpsr */
 	ldmia	r3!,{r4}	/*load CPSR from SDRAM*/
 	msr	cpsr, r4	/*store cpsr */
@@ -506,6 +557,48 @@ l1_logic_lost:
 	mrc	p15, 0, r5, c10, c2, 1
 	stmia	r8!,{r4-r5}
 
+#ifdef CONFIG_ENABLE_OFF_MODE_JTAG_ETM_DEBUG
+	/*
+	 * Save Coresight debug registers
+	 */
+	ldr	r4, do_etm_save
+	cmp	r4, #0
+	streq	r4, [r8], #4		/* 0 for coresight saved size */
+	streq	r4, [r8], #4		/* 0 for ETM saved size */
+	beq	etm_skip_save
+	ldr	r6, debug_vbase		/* base vaddr of CortexA8-Debug */
+	ldr	r4, debug_xlar_key	/* get lock key for OSLAR */
+	bl	unlock_debug		/* force global unlock */
+	str	r4, [r6, #ETMMR_OSLAR]	/* lock debug access */
+	ldr	r4, [r6, #ETMMR_OSSRR]	/* OSSRR returns size on first read */
+	str	r4, [r8], #4		/* push item to save area */
+	cmp	r4, #0			/* zero check */
+debug_save:
+	ittt	ne			/* thumb 2 compat if-then block */
+	ldrne	r5, [r6, #ETMMR_OSSRR]	/* get reg value */
+	strne	r5, [r8], #4		/* push item to save area */
+	subnes	r4, r4, #1		/* decrement size */
+	bne	debug_save		/* loop till done */
+	str	r6, [r6, #ETMMR_OSLAR]	/* unlock debug access */
+	/*
+	 * Save etm registers
+	 */
+	ldr	r6, etm_vbase		/* base vaddr of ETM */
+	ldr	r4, debug_xlar_key	/* get lock key for OSLAR */
+	bl	unlock_debug		/* force global unlock */
+	str	r4, [r6, #ETMMR_OSLAR]	/* lock OS access to trace regs */
+	ldr	r4, [r6, #ETMMR_OSSRR]	/* OSSRR returns size on first read */
+	str	r4, [r8], #4		/* push size to save area */
+	cmp	r4, #0			/* zero check */
+etm_save:
+	ldrne	r5, [r6, #ETMMR_OSSRR]	/* get reg value */
+	strne	r5, [r8], #4		/* push item to save area */
+	subnes	r4, r4, #1		/* decrement size */
+	bne	etm_save		/* loop till done */
+	str	r6, [r6, #ETMMR_OSLAR]	/* unlock debug access */
+etm_skip_save:
+#endif
+
 	/* Store current cpsr*/
 	mrs	r2, cpsr
 	stmia	r8!, {r2}
@@ -520,6 +613,7 @@ clean_caches:
 	cmp	r9, #1 /* Check whether L2 inval is required or not*/
 	bne	skip_l2_inval
 clean_l2:
+#ifndef CONFIG_ENABLE_OFF_MODE_JTAG_ETM_DEBUG
 	/* read clidr */
 	mrc     p15, 1, r0, c0, c0, 1
 	/* extract loc from clidr */
@@ -586,6 +680,12 @@ finished:
 	/* select current cache level in cssr */
 	mcr     p15, 2, r10, c0, c0, 0
 	isb
+#else
+	ldr	r1, kernel_flush	/* get 32 bit addr of flush */
+	mov	lr, pc			/* prepare for return */
+	bx	r1			/* do it */
+#endif
+
 skip_l2_inval:
 	/* Data memory barrier and Data sync barrier */
 	mov     r1, #0
@@ -632,6 +732,36 @@ wait_dll_lock:
         bne     wait_dll_lock
         bx      lr
 
+#ifdef CONFIG_ENABLE_OFF_MODE_JTAG_ETM_DEBUG
+	/*
+	 * unlock debug:
+	 *  Input:
+	 *      r6 has base address of emulation
+	 *      r4 has unlock key
+	 *  Output
+	 *      r5 has PDS value (1=accessable)
+	 */
+unlock_debug:
+	ldr	r5, [r6, #CSMR_LOCKSTATUS]	/* get LSR */
+	cmp	r5, #0x3			/* need unlocking? */
+	streq	r4, [r6, #CSMR_LOCKACCESS]	/* unlock if so */
+	ldr	r5, [r6, #ETMMR_PDSR]		/* clear power status */
+	bx	lr				/* back to caller */
+
+debug_vbase:
+	.word OMAP34XX_DBG_VIRT
+debug_pbase:
+	.word OMAP34XX_DBG_PHYS
+etm_vbase:
+	.word OMAP34XX_ETM_VIRT
+etm_pbase:
+	.word OMAP34XX_ETM_PHYS
+debug_xlar_key:
+	.word UNLOCK_MAGIC
+#endif
+
+kernel_flush:
+	.word v7_flush_dcache_all
 cm_idlest1_core:
 	.word	CM_IDLEST1_CORE_V
 sdrc_dlla_status:
@@ -668,5 +798,10 @@ cache_pred_disable_mask:
 	.word	0xFFFFE7FB
 control_stat:
 	.word	CONTROL_STAT
+/* this word needs to be at the end */
+#ifdef CONFIG_ENABLE_OFF_MODE_JTAG_ETM_DEBUG
+do_etm_save:
+	.word   0
+#endif
 ENTRY(omap34xx_cpu_suspend_sz)
 	.word	. - omap34xx_cpu_suspend
diff --git a/arch/arm/plat-omap/include/plat/control.h b/arch/arm/plat-omap/include/plat/control.h
index 131bf40..537acbe 100644
--- a/arch/arm/plat-omap/include/plat/control.h
+++ b/arch/arm/plat-omap/include/plat/control.h
@@ -362,7 +362,7 @@ extern void omap3_save_scratchpad_contents(void);
 extern void omap3_clear_scratchpad_contents(void);
 extern u32 *get_restore_pointer(void);
 extern u32 *get_es3_restore_pointer(void);
-extern u32 omap3_arm_context[128];
+extern u32 omap3_arm_context[256];
 extern void omap3_control_save_context(void);
 extern void omap3_control_restore_context(void);
 
-- 
1.7.1

