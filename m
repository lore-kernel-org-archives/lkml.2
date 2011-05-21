Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab1EUImT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:42:19 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:38210 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753568Ab1EUImN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:42:13 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 03/13] mach-ux500: update SoC and board IRQ handling
Date: Sat, 21 May 2011 10:42:04 +0200
Message-ID: <1305967324-16440-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

This splits out a per-SoC IRQ range handling, so that the
DB8500 and DB5500 SoC:s can reuse aproximately the same IRQ
range with the largest span setting the roof. The same change
is done for the boards, mutatis mutandis, with a new file for
the U5500 board.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 .../mach-ux500/include/mach/irqs-board-mop500.h    |    5 ++
 .../arm/mach-ux500/include/mach/irqs-board-u5500.h |   21 ++++++++
 arch/arm/mach-ux500/include/mach/irqs-db5500.h     |   27 ++++++++++
 arch/arm/mach-ux500/include/mach/irqs-db8500.h     |   54 ++++++++++++++++++++
 arch/arm/mach-ux500/include/mach/irqs.h            |   46 ++++++++---------
 5 files changed, 129 insertions(+), 24 deletions(-)
 create mode 100644 arch/arm/mach-ux500/include/mach/irqs-board-u5500.h

diff --git a/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h b/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
index 97ef55f..4796990 100644
--- a/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
+++ b/arch/arm/mach-ux500/include/mach/irqs-board-mop500.h
@@ -50,6 +50,11 @@
 
 #define MOP500_IRQ_END		MOP500_NR_IRQS
 
+/*
+ * We may have several boards, but only one will run at a
+ * time, so the one with most IRQs will bump this ahead,
+ * but the IRQ_BOARD_START remains the same for either board.
+ */
 #if MOP500_IRQ_END > IRQ_BOARD_END
 #undef IRQ_BOARD_END
 #define IRQ_BOARD_END	MOP500_IRQ_END
diff --git a/arch/arm/mach-ux500/include/mach/irqs-board-u5500.h b/arch/arm/mach-ux500/include/mach/irqs-board-u5500.h
new file mode 100644
index 0000000..29d972c
--- /dev/null
+++ b/arch/arm/mach-ux500/include/mach/irqs-board-u5500.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef __MACH_IRQS_BOARD_U5500_H
+#define __MACH_IRQS_BOARD_U5500_H
+
+#define AB5500_NR_IRQS		5
+#define IRQ_AB5500_BASE		IRQ_BOARD_START
+#define IRQ_AB5500_END		(IRQ_AB5500_BASE + AB5500_NR_IRQS)
+
+#define U5500_IRQ_END		IRQ_AB5500_END
+
+#if IRQ_BOARD_END < U5500_IRQ_END
+#undef IRQ_BOARD_END
+#define IRQ_BOARD_END		U5500_IRQ_END
+#endif
+
+#endif
diff --git a/arch/arm/mach-ux500/include/mach/irqs-db5500.h b/arch/arm/mach-ux500/include/mach/irqs-db5500.h
index bfa123d..7723977 100644
--- a/arch/arm/mach-ux500/include/mach/irqs-db5500.h
+++ b/arch/arm/mach-ux500/include/mach/irqs-db5500.h
@@ -83,4 +83,31 @@
 #define IRQ_DB5500_GPIO6		(IRQ_SHPI_START + 125)
 #define IRQ_DB5500_GPIO7		(IRQ_SHPI_START + 126)
 
+#ifdef CONFIG_UX500_SOC_DB5500
+
+/*
+ * After the GPIO ones we reserve a range of IRQ:s in which virtual
+ * IRQ:s representing modem IRQ:s can be allocated
+ */
+#define IRQ_MODEM_EVENTS_BASE	IRQ_SOC_START
+#define IRQ_MODEM_EVENTS_NBR	72
+#define IRQ_MODEM_EVENTS_END	(IRQ_MODEM_EVENTS_BASE + IRQ_MODEM_EVENTS_NBR)
+
+/* List of virtual IRQ:s that are allocated from the range above */
+#define MBOX_PAIR0_VIRT_IRQ	(IRQ_MODEM_EVENTS_BASE + 43)
+#define MBOX_PAIR1_VIRT_IRQ	(IRQ_MODEM_EVENTS_BASE + 45)
+#define MBOX_PAIR2_VIRT_IRQ	(IRQ_MODEM_EVENTS_BASE + 41)
+
+/*
+ * We may have several SoCs, but only one will run at a
+ * time, so the one with most IRQs will bump this ahead,
+ * but the IRQ_SOC_START remains the same for either SoC.
+ */
+#if IRQ_SOC_END < IRQ_MODEM_EVENTS_END
+#undef IRQ_SOC_END
+#define IRQ_SOC_END		IRQ_MODEM_EVENTS_END
+#endif
+
+#endif /* CONFIG_UX500_SOC_DB5500 */
+
 #endif
diff --git a/arch/arm/mach-ux500/include/mach/irqs-db8500.h b/arch/arm/mach-ux500/include/mach/irqs-db8500.h
index 8b5d9f0..68bc149 100644
--- a/arch/arm/mach-ux500/include/mach/irqs-db8500.h
+++ b/arch/arm/mach-ux500/include/mach/irqs-db8500.h
@@ -93,4 +93,58 @@
 #define IRQ_DB8500_GPIO7		(IRQ_SHPI_START + 126)
 #define IRQ_DB8500_GPIO8		(IRQ_SHPI_START + 127)
 
+#define IRQ_CA_WAKE_REQ_ED			(IRQ_SHPI_START + 71)
+#define IRQ_AC_READ_NOTIFICATION_0_ED		(IRQ_SHPI_START + 66)
+#define IRQ_AC_READ_NOTIFICATION_1_ED		(IRQ_SHPI_START + 64)
+#define IRQ_CA_MSG_PEND_NOTIFICATION_0_ED	(IRQ_SHPI_START + 67)
+#define IRQ_CA_MSG_PEND_NOTIFICATION_1_ED	(IRQ_SHPI_START + 65)
+
+#define IRQ_CA_WAKE_REQ_V1			(IRQ_SHPI_START + 83)
+#define IRQ_AC_READ_NOTIFICATION_0_V1		(IRQ_SHPI_START + 78)
+#define IRQ_AC_READ_NOTIFICATION_1_V1		(IRQ_SHPI_START + 76)
+#define IRQ_CA_MSG_PEND_NOTIFICATION_0_V1	(IRQ_SHPI_START + 79)
+#define IRQ_CA_MSG_PEND_NOTIFICATION_1_V1	(IRQ_SHPI_START + 77)
+
+#ifdef CONFIG_UX500_SOC_DB8500
+
+/* Virtual interrupts corresponding to the PRCMU wakeups.  */
+#define IRQ_PRCMU_BASE IRQ_SOC_START
+#define NUM_PRCMU_WAKEUPS (IRQ_PRCMU_END - IRQ_PRCMU_BASE)
+
+#define IRQ_PRCMU_RTC (IRQ_PRCMU_BASE)
+#define IRQ_PRCMU_RTT0 (IRQ_PRCMU_BASE + 1)
+#define IRQ_PRCMU_RTT1 (IRQ_PRCMU_BASE + 2)
+#define IRQ_PRCMU_HSI0 (IRQ_PRCMU_BASE + 3)
+#define IRQ_PRCMU_HSI1 (IRQ_PRCMU_BASE + 4)
+#define IRQ_PRCMU_CA_WAKE (IRQ_PRCMU_BASE + 5)
+#define IRQ_PRCMU_USB (IRQ_PRCMU_BASE + 6)
+#define IRQ_PRCMU_ABB (IRQ_PRCMU_BASE + 7)
+#define IRQ_PRCMU_ABB_FIFO (IRQ_PRCMU_BASE + 8)
+#define IRQ_PRCMU_ARM (IRQ_PRCMU_BASE + 9)
+#define IRQ_PRCMU_MODEM_SW_RESET_REQ (IRQ_PRCMU_BASE + 10)
+#define IRQ_PRCMU_GPIO0 (IRQ_PRCMU_BASE + 11)
+#define IRQ_PRCMU_GPIO1 (IRQ_PRCMU_BASE + 12)
+#define IRQ_PRCMU_GPIO2 (IRQ_PRCMU_BASE + 13)
+#define IRQ_PRCMU_GPIO3 (IRQ_PRCMU_BASE + 14)
+#define IRQ_PRCMU_GPIO4 (IRQ_PRCMU_BASE + 15)
+#define IRQ_PRCMU_GPIO5 (IRQ_PRCMU_BASE + 16)
+#define IRQ_PRCMU_GPIO6 (IRQ_PRCMU_BASE + 17)
+#define IRQ_PRCMU_GPIO7 (IRQ_PRCMU_BASE + 18)
+#define IRQ_PRCMU_GPIO8 (IRQ_PRCMU_BASE + 19)
+#define IRQ_PRCMU_CA_SLEEP (IRQ_PRCMU_BASE + 20)
+#define IRQ_PRCMU_HOTMON_LOW (IRQ_PRCMU_BASE + 21)
+#define IRQ_PRCMU_HOTMON_HIGH (IRQ_PRCMU_BASE + 22)
+#define IRQ_PRCMU_END (IRQ_PRCMU_BASE + 23)
+
+/*
+ * We may have several SoCs, but only one will run at a
+ * time, so the one with most IRQs will bump this ahead,
+ * but the IRQ_SOC_START remains the same for either SoC.
+ */
+#if IRQ_SOC_END < IRQ_PRCMU_END
+#undef IRQ_SOC_END
+#define IRQ_SOC_END IRQ_PRCMU_END
+#endif
+
+#endif /* CONFIG_UX500_SOC_DB8500 */
 #endif
diff --git a/arch/arm/mach-ux500/include/mach/irqs.h b/arch/arm/mach-ux500/include/mach/irqs.h
index ba1294c..9db68d2 100644
--- a/arch/arm/mach-ux500/include/mach/irqs.h
+++ b/arch/arm/mach-ux500/include/mach/irqs.h
@@ -10,49 +10,47 @@
 #ifndef ASM_ARCH_IRQS_H
 #define ASM_ARCH_IRQS_H
 
-#include <mach/irqs-db5500.h>
-#include <mach/irqs-db8500.h>
+#include <mach/hardware.h>
 
-#define IRQ_LOCALTIMER                  29
-#define IRQ_LOCALWDOG                   30
+#define IRQ_LOCALTIMER			29
+#define IRQ_LOCALWDOG			30
 
 /* Shared Peripheral Interrupt (SHPI) */
 #define IRQ_SHPI_START			32
 
-/* Interrupt numbers generic for shared peripheral */
+/*
+ * MTU0 preserved for now until plat-nomadik is taught not to use it.  Don't
+ * add any other IRQs here, use the irqs-dbx500.h files.
+ */
 #define IRQ_MTU0		(IRQ_SHPI_START + 4)
 
-/* There are 128 shared peripheral interrupts assigned to
- * INTID[160:32]. The first 32 interrupts are reserved.
- */
-#define DBX500_NR_INTERNAL_IRQS		161
+#define DBX500_NR_INTERNAL_IRQS		160
 
 /* After chip-specific IRQ numbers we have the GPIO ones */
 #define NOMADIK_NR_GPIO			288
 #define NOMADIK_GPIO_TO_IRQ(gpio)	((gpio) + DBX500_NR_INTERNAL_IRQS)
 #define NOMADIK_IRQ_TO_GPIO(irq)	((irq) - DBX500_NR_INTERNAL_IRQS)
-#define IRQ_BOARD_START			NOMADIK_GPIO_TO_IRQ(NOMADIK_NR_GPIO)
+#define IRQ_GPIO_END			NOMADIK_GPIO_TO_IRQ(NOMADIK_NR_GPIO)
+
+#define IRQ_SOC_START		IRQ_GPIO_END
+/* This will be overridden by SoC-specific irq headers */
+#define IRQ_SOC_END		IRQ_SOC_START
 
+#include <mach/irqs-db5500.h>
+#include <mach/irqs-db8500.h>
+
+#define IRQ_BOARD_START		IRQ_SOC_END
 /* This will be overridden by board-specific irq headers */
-#define IRQ_BOARD_END			IRQ_BOARD_START
+#define IRQ_BOARD_END		IRQ_BOARD_START
 
 #ifdef CONFIG_MACH_U8500
 #include <mach/irqs-board-mop500.h>
 #endif
 
-/*
- * After the board specific IRQ:s we reserve a range of IRQ:s in which virtual
- * IRQ:s representing modem IRQ:s can be allocated
- */
-#define IRQ_MODEM_EVENTS_BASE (IRQ_BOARD_END + 1)
-#define IRQ_MODEM_EVENTS_NBR 72
-#define IRQ_MODEM_EVENTS_END (IRQ_MODEM_EVENTS_BASE + IRQ_MODEM_EVENTS_NBR)
-
-/* List of virtual IRQ:s that are allocated from the range above */
-#define MBOX_PAIR0_VIRT_IRQ (IRQ_MODEM_EVENTS_BASE + 43)
-#define MBOX_PAIR1_VIRT_IRQ (IRQ_MODEM_EVENTS_BASE + 45)
-#define MBOX_PAIR2_VIRT_IRQ (IRQ_MODEM_EVENTS_BASE + 41)
+#ifdef CONFIG_MACH_U5500
+#include <mach/irqs-board-u5500.h>
+#endif
 
-#define NR_IRQS				IRQ_MODEM_EVENTS_END
+#define NR_IRQS			IRQ_BOARD_END
 
 #endif /* ASM_ARCH_IRQS_H */
-- 
1.7.3.2

