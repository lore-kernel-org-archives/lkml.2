Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1BVO73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:59:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50295 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab1BVO71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:59:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vJfu2DbgMZadOKaQ6zjCH7dgNwDpitxkdrhJbGJ71qGdEbWnuA+7YYAMkeKcsymrT5
         PYILA6UKtiIssZg8Ni6pi428lrxNKXAjlZADusZnQFOzRP6UcYGq2iR6duFNphjhjGc0
         2ERgFo1fop0QOBf4X3ChJ0hYzuCMo6hWXB2YA=
From: "Anoop P.A" <anoop.pa@gmail.com>
To: ralf@linux-mips.org, ars@metafoo.de, ddaney@caviumnetworks.com,
        tj@kernel.org, yuasa@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Anoop P A <anoop.pa@gmail.com>
Subject: [PATCH] MSP82XX Acadia board support.
Date: Tue, 22 Feb 2011 20:50:26 +0530
Message-Id: <1298388026-11221-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>

MSP82XX series of processors comes under MSP7100 family.
Currently couple of SoC's (MSP8210 and MSP8220) available in this series.

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
This patch depends on following two patches

http://patchwork.linux-mips.org/patch/2094/
http://patchwork.linux-mips.org/patch/2073/

 arch/mips/include/asm/bootinfo.h         |    1 +
 arch/mips/pmc-sierra/Kconfig             |   38 ++++++++++++++++++++++++++++++
 arch/mips/pmc-sierra/msp71xx/msp_irq.c   |    9 ++++++-
 arch/mips/pmc-sierra/msp71xx/msp_prom.c  |    6 ++++
 arch/mips/pmc-sierra/msp71xx/msp_setup.c |    4 ++-
 arch/mips/pmc-sierra/msp71xx/msp_time.c  |    2 +
 6 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/bootinfo.h b/arch/mips/include/asm/bootinfo.h
index 35cd1ba..3604102 100644
--- a/arch/mips/include/asm/bootinfo.h
+++ b/arch/mips/include/asm/bootinfo.h
@@ -50,6 +50,7 @@
 #define MACH_MSP7120_EVAL       3	/* PMC-Sierra MSP7120 Evaluation */
 #define MACH_MSP7120_GW         4	/* PMC-Sierra MSP7120 Residential GW */
 #define MACH_MSP7120_FPGA       5	/* PMC-Sierra MSP7120 Emulation */
+#define MACH_MSP82XX_ACADIA	9	/* PMC-Sierra MSP82XX Acadia */
 #define MACH_MSP_OTHER        255	/* PMC-Sierra unknown board type */
 
 /*
diff --git a/arch/mips/pmc-sierra/Kconfig b/arch/mips/pmc-sierra/Kconfig
index d4984c3..0147b01 100644
--- a/arch/mips/pmc-sierra/Kconfig
+++ b/arch/mips/pmc-sierra/Kconfig
@@ -32,12 +32,50 @@ config PMC_MSP7120_FPGA
 	select IRQ_MSP_CIC
 	select MSP_HAS_PCI
 
+config PMC_MSP8210
+	bool "PMC-Sierra MSP8210 SoC"
+	select PMC_MSP82XX_ACADIA
+	help
+		Support for the PMC-Sierra MSP8210 System-on-a-Chip with
+		custom mips 34Kc core (7 TC) cpu.
+	  	For info http://www.pmc-sierra.com/products/details/msp8210/
+
+config PMC_MSP8220
+	bool "PMC-Sierra MSP8220 Security SoC"
+	select PMC_MSP82XX_ACADIA
+	select MSP_HAS_SEC
+	help
+		Support for the PMC-Sierra MSP8220 System-on-a-Chip with
+		custom mips 34Kc core (7 TC) cpu and IPSEC accelartion engine.
+		For info http://www.pmc-sierra.com/products/details/msp8220/
+
 endchoice
 
 config HYPERTRANSPORT
 	bool "Hypertransport Support for PMC-Sierra Yosemite"
 	depends on PMC_YOSEMITE
 
+config PMC_MSP82XX_ACADIA
+	select SYS_SUPPORTS_MULTITHREADING
+	select IRQ_MSP_CIC
+	select HW_HAS_CARB
+	select DMA_TO_SPRAM
+	select MSP_HAS_DUAL_USB
+	select MSP_HAS_TSMAC
+	select MSP_HAS_PCI
+	bool
+
+config MSP_HAS_DUAL_USB
+	select MSP_HAS_USB
+	bool
+
+config MSP_HAS_TSMAC
+	select MSP_HAS_MAC
+	bool
+
+config MSP_HAS_SEC
+	bool
+
 config MSP_HAS_USB
 	boolean
 	depends on PMC_MSP
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_irq.c b/arch/mips/pmc-sierra/msp71xx/msp_irq.c
index 4531c4a..5b74d3a 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_irq.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_irq.c
@@ -37,7 +37,9 @@ static inline void mac0_int_dispatch(void) { do_IRQ(MSP_INT_MAC0); }
 static inline void mac1_int_dispatch(void) { do_IRQ(MSP_INT_MAC1); }
 static inline void mac2_int_dispatch(void) { do_IRQ(MSP_INT_SAR); }
 static inline void usb_int_dispatch(void)  { do_IRQ(MSP_INT_USB);  }
+#ifndef CONFIG_PMC_MSP8210
 static inline void sec_int_dispatch(void)  { do_IRQ(MSP_INT_SEC);  }
+#endif
 
 /*
  * The PMC-Sierra MSP interrupts are arranged in a 3 level cascaded
@@ -79,8 +81,10 @@ asmlinkage void plat_irq_dispatch(struct pt_regs *regs)
 	else if (pending & C_IRQ3)
 		do_IRQ(MSP_INT_SAR);
 
+#ifndef CONFIG_PMC_MSP8210
 	else if (pending & C_IRQ5)
 		do_IRQ(MSP_INT_SEC);
+#endif
 
 #else
 	if (pending & C_IRQ5)
@@ -133,7 +137,9 @@ void __init arch_init_irq(void)
 	set_vi_handler(MSP_INT_MAC1, mac1_int_dispatch);
 	set_vi_handler(MSP_INT_SAR, mac2_int_dispatch);
 	set_vi_handler(MSP_INT_USB, usb_int_dispatch);
+#ifndef CONFIG_PMC_MSP8210
 	set_vi_handler(MSP_INT_SEC, sec_int_dispatch);
+#endif
 #ifdef CONFIG_MIPS_MT_SMP
 	msp_vsmp_int_init();
 #elif defined CONFIG_MIPS_MT_SMTC
@@ -142,8 +148,9 @@ void __init arch_init_irq(void)
 	irq_hwmask[MSP_INT_MAC1] = C_IRQ1;
 	irq_hwmask[MSP_INT_USB] = C_IRQ2;
 	irq_hwmask[MSP_INT_SAR] = C_IRQ3;
+#ifndef CONFIG_PMC_MSP8210
 	irq_hwmask[MSP_INT_SEC] = C_IRQ5;
-
+#endif
 #endif	/* CONFIG_MIPS_MT_SMP */
 #endif	/* CONFIG_MIPS_MT */
 	/* setup the cascaded interrupts */
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_prom.c b/arch/mips/pmc-sierra/msp71xx/msp_prom.c
index db00deb..adf8f3b 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_prom.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_prom.c
@@ -71,6 +71,8 @@ static char msp_default_features[] =
 	"EMEMSP";
 #elif defined(CONFIG_PMC_MSP7120_FPGA)
 	"EMEM";
+#elif defined(CONFIG_PMC_MSP82XX_ACADIA)
+	"EGEGEGSP";
 #endif
 
 /* conversion functions */
@@ -132,6 +134,10 @@ const char *get_system_type(void)
 	return "PMC-Sierra MSP7120 Residential Gateway";
 #elif defined(CONFIG_PMC_MSP7120_FPGA)
 	return "PMC-Sierra MSP7120 FPGA";
+#elif defined(CONFIG_PMC_MSP8210)
+	return "PMC-Sierra MSP8210 SoC";
+#elif defined(CONFIG_PMC_MSP8220)
+	return "PMC-Sierra MSP8220 SoC";
 #else
 	#error "What is the type of *your* MSP?"
 #endif
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_setup.c b/arch/mips/pmc-sierra/msp71xx/msp_setup.c
index 3bf92cd..406353d 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_setup.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_setup.c
@@ -20,7 +20,7 @@
 #include <msp_regs.h>
 #include <msp_gpio_macros.h>
 
-#if defined(CONFIG_PMC_MSP7120_GW)
+#if defined(CONFIG_PMC_MSP7120_GW) || defined(CONFIG_PMC_MSP82XX_ACADIA)
 	/* GPIO 9 is the 4th GPIO of register 3*/
 #define MSP_BOARD_RESET_GPIO	9
 #else
@@ -203,6 +203,8 @@ void __init prom_init(void)
 		mips_machtype = MACH_MSP7120_EVAL;
 #elif defined(CONFIG_PMC_MSP7120_GW)
 		mips_machtype = MACH_MSP7120_GW;
+#elif defined(CONFIG_PMC_MSP82XX_ACADIA)
+		mips_machtype = MACH_MSP82XX_ACADIA;
 #else
 		mips_machtype = MACH_MSP_OTHER;
 #endif
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_time.c b/arch/mips/pmc-sierra/msp71xx/msp_time.c
index 8b42f30..929c18a 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_time.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_time.c
@@ -74,6 +74,8 @@ void __init plat_time_init(void)
 		cpu_rate = 400000000;
 #elif defined(CONFIG_PMC_MSP7120_FPGA)
 		cpu_rate = 25000000;
+#elif defined(CONFIG_PMC_MSP82XX_ACADIA)
+		cpu_rate = 60000000;
 #else
 		cpu_rate = 150000000;
 #endif
-- 
1.7.0.4

