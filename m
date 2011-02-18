Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab1BRNd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 08:33:29 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64551 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1BRNd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 08:33:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KAW5jHVRLWSrNQck0XxCbg5utFD8kWHQNgOrf/sUjUQafNjRez9fZtLufyCsjPreNP
         vhxqXCoumDj5kMe+H06lCcxrK06fs6olFC78rfcOUuaYa4ltk/1/n9YhcymhSH72RbAQ
         051k5D6NFpshohqgjRUbTSY+eBjU+g66vByqg=
From: "Anoop P.A" <anoop.pa@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Anoop P A <anoop.pa@gmail.com>
Subject: [PATCH] Make msp7120_reset generic
Date: Fri, 18 Feb 2011 19:25:29 +0530
Message-Id: <1298037329-13683-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>

Remove platform dependency code from msp7120 reset code and make it generic.
Now the code can be reused for other boards running msp71xx family SoC.

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
 arch/mips/pmc-sierra/msp71xx/msp_setup.c |   85 ++++++++++++++++++------------
 1 files changed, 52 insertions(+), 33 deletions(-)

diff --git a/arch/mips/pmc-sierra/msp71xx/msp_setup.c b/arch/mips/pmc-sierra/msp71xx/msp_setup.c
index fb37a10..4a6cc0d 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_setup.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_setup.c
@@ -18,30 +18,33 @@
 
 #include <msp_prom.h>
 #include <msp_regs.h>
+#include <msp_gpio_macros.h>
 
 #if defined(CONFIG_PMC_MSP7120_GW)
-#include <msp_regops.h>
+	/* GPIO 9 is the 4th GPIO of register 3
+	 */
 #define MSP_BOARD_RESET_GPIO	9
+#else
+#undef MSP_BOARD_RESET_GPIO
 #endif
 
 extern void msp_serial_setup(void);
 extern void pmctwiled_setup(void);
 
-#if defined(CONFIG_PMC_MSP7120_EVAL) || \
-    defined(CONFIG_PMC_MSP7120_GW) || \
-    defined(CONFIG_PMC_MSP7120_FPGA)
 /*
- * Performs the reset for MSP7120-based boards
+ * Performs the reset for MSP71xx-based boards
  */
-void msp7120_reset(void)
+void msp71xx_reset(void)
 {
 	void *start, *end, *iptr;
 	register int i;
+	register u32 temp __maybe_unused;
 
 	/* Diasble all interrupts */
 	local_irq_disable();
 #ifdef CONFIG_SYS_SUPPORTS_MULTITHREADING
 	dvpe();
+	dmt();
 #endif
 
 	/* Cache the reset code of this function */
@@ -78,49 +81,56 @@ void msp7120_reset(void)
 	/* Wait a bit for the DDRC to settle */
 	for (i = 0; i < 100000000; i++);
 
-#if defined(CONFIG_PMC_MSP7120_GW)
+#if defined MSP_BOARD_RESET_GPIO
 	/*
-	 * Set GPIO 9 HI, (tied to board reset logic)
-	 * GPIO 9 is the 4th GPIO of register 3
+	 * Set reset GPIO  HI, (tied to board reset logic)
 	 *
 	 * NOTE: We cannot use the higher-level msp_gpio_mode()/out()
 	 * as GPIO char driver may not be enabled and it would look up
 	 * data inRAM!
 	 */
-	set_value_reg32(GPIO_CFG3_REG, 0xf000, 0x8000);
-	set_reg32(GPIO_DATA3_REG, 8);
+	temp = __raw_readl(MSP_GPIO_MODE_REGISTER[MSP_BOARD_RESET_GPIO]) &
+					~BASIC_MODE_MASK(MSP_BOARD_RESET_GPIO);
+	__raw_writel(temp | BASIC_MODE(MSP_GPIO_OUTPUT, MSP_BOARD_RESET_GPIO),
+				MSP_GPIO_MODE_REGISTER[MSP_BOARD_RESET_GPIO]);
+	/* Now set the reset gpio pin hi */
+	temp = __raw_readl(MSP_GPIO_DATA_REGISTER[MSP_BOARD_RESET_GPIO]);
+	__raw_writel(temp | BASIC_DATA_MASK(MSP_BOARD_RESET_GPIO),
+			MSP_GPIO_DATA_REGISTER[MSP_BOARD_RESET_GPIO]);
 
 	/*
-	 * In case GPIO9 doesn't reset the board (jumper configurable!)
+	 * In case GPIO doesn't reset the board (jumper configurable!)
 	 * fallback to device reset below.
 	 */
 #endif
-	/* Set bit 1 of the MSP7120 reset register */
-	*RST_SET_REG = 0x00000001;
+	/* Set bit 1 of the MSP71xx reset register */
+	__raw_writel(0x00000001, RST_SET_REG);
 
 	__asm__ __volatile__ (
-		"endpoint:					\n"
+		"endpoint:\n"
 	);
 }
-#endif
 
 void msp_restart(char *command)
 {
-	printk(KERN_WARNING "Now rebooting .......\n");
-
-#if defined(CONFIG_PMC_MSP7120_EVAL) || \
-    defined(CONFIG_PMC_MSP7120_GW) || \
-    defined(CONFIG_PMC_MSP7120_FPGA)
-	msp7120_reset();
-#else
-	/* No chip-specific reset code, just jump to the ROM reset vector */
-	set_c0_status(ST0_BEV | ST0_ERL);
-	change_c0_config(CONF_CM_CMASK, CONF_CM_UNCACHED);
-	flush_cache_all();
-	write_c0_wired(0);
 
-	__asm__ __volatile__("jr\t%0"::"r"(0xbfc00000));
-#endif
+	unsigned long family = identify_family();
+	switch (family)	{
+	case FAMILY_MSP7100:
+		msp71xx_reset();
+		break;
+	default:
+		/* No chip-specific reset code, just jump
+		 * to the ROM reset vector
+		 */
+		set_c0_status(ST0_BEV | ST0_ERL);
+		change_c0_config(CONF_CM_CMASK, CONF_CM_UNCACHED);
+		flush_cache_all();
+		write_c0_wired(0);
+
+		__asm__ __volatile__("jr\t%0" : : "r"(0xbfc00000));
+		break;
+	}
 }
 
 void msp_halt(void)
@@ -141,9 +151,7 @@ void msp_power_off(void)
 
 void __init plat_mem_setup(void)
 {
-	_machine_restart = msp_restart;
-	_machine_halt = msp_halt;
-	pm_power_off = msp_power_off;
+/*TODO: Move mem setup here */
 }
 
 extern struct plat_smp_ops msp_smtc_smp_ops;
@@ -244,3 +252,14 @@ void __init prom_init(void)
 	pmctwiled_setup();
 #endif
 }
+
+static int __init mips_reboot_setup(void)
+{
+	_machine_restart = msp_restart;
+	_machine_halt = msp_halt;
+	pm_power_off = msp_power_off;
+
+	return 0;
+}
+
+arch_initcall(mips_reboot_setup);
-- 
1.7.0.4

