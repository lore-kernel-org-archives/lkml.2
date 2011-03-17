Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1CQW53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 18:57:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21745 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab1CQW52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 18:57:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6288"; a="80625660"
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: davidb@codeaurora.org, bryanh@codeaurora.org, linux@arm.linux.org.uk,
        dwalker@fifo99.com
Cc: dima@android.com, Rohit Vaswani <rvaswani@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH] msm: Add gpio support for 8960
Date: Thu, 17 Mar 2011 15:57:20 -0700
Message-Id: <1300402640-23995-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds GPIO support for 8960. The board file includes the
gpiomux configs and we now use gpio-v2 for 8960.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/mach-msm/Makefile                      |    4 +--
 arch/arm/mach-msm/board-msm8960.c               |   21 ++++++++++++
 arch/arm/mach-msm/gpio-v2.c                     |   13 ++++---
 arch/arm/mach-msm/include/mach/irqs-8960.h      |   38 +++++++++++-----------
 arch/arm/mach-msm/include/mach/irqs-8x60.h      |   24 +++++++-------
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h |    3 ++
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    5 +--
 arch/arm/mach-msm/include/mach/msm_iomap.h      |    1 +
 arch/arm/mach-msm/io.c                          |    2 +
 9 files changed, 68 insertions(+), 43 deletions(-)

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 5ab09a1..a4f55ec 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -30,11 +30,9 @@ obj-$(CONFIG_ARCH_MSM8960) += board-msm8960.o devices-msm8960.o
 obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-v2.o gpiomux.o
+obj-$(CONFIG_ARCH_MSM8960) += gpiomux-v2.o gpiomux.o
 ifdef CONFIG_MSM_V2_TLMM
-ifndef CONFIG_ARCH_MSM8960
-# TODO: TLMM Mapping issues need to be resolved
 obj-y	+= gpio-v2.o
-endif
 else
 obj-y	+= gpio.o
 endif
diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index 052cb35..1f003ba 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -29,6 +29,25 @@
 #include <mach/msm_iomap.h>
 
 #include "devices.h"
+#include "gpiomux.h"
+
+static struct msm_gpiomux_config msm8960_gpiomux_configs[NR_GPIO_IRQS] = {};
+
+static int __init gpiomux_init(void)
+{
+	int rc;
+
+	rc = msm_gpiomux_init(NR_GPIO_IRQS);
+	if (rc) {
+		printk(KERN_ERR "msm_gpiomux_init failed %d\n", rc);
+		return rc;
+	}
+
+	msm_gpiomux_install(msm8960_gpiomux_configs,
+			ARRAY_SIZE(msm8960_gpiomux_configs));
+
+	return 0;
+}
 
 static void __init msm8960_map_io(void)
 {
@@ -68,12 +87,14 @@ static struct platform_device *rumi3_devices[] __initdata = {
 static void __init msm8960_sim_init(void)
 {
 	msm_clock_init(msm_clocks_8960, msm_num_clocks_8960);
+	gpiomux_init();
 	platform_add_devices(sim_devices, ARRAY_SIZE(sim_devices));
 }
 
 static void __init msm8960_rumi3_init(void)
 {
 	msm_clock_init(msm_clocks_8960, msm_num_clocks_8960);
+	gpiomux_init();
 	platform_add_devices(rumi3_devices, ARRAY_SIZE(rumi3_devices));
 }
 
diff --git a/arch/arm/mach-msm/gpio-v2.c b/arch/arm/mach-msm/gpio-v2.c
index fb52d6d..6a37695 100644
--- a/arch/arm/mach-msm/gpio-v2.c
+++ b/arch/arm/mach-msm/gpio-v2.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2011 Code Aurora Forum. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -326,6 +326,7 @@ static int msm_gpio_irq_set_type(unsigned int irq, unsigned int flow_type)
 static void msm_summary_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned long i;
+	struct irq_chip *chip = get_irq_desc_chip(desc);
 
 	for (i = find_first_bit(msm_gpio.enabled_irqs, NR_GPIO_IRQS);
 	     i < NR_GPIO_IRQS;
@@ -334,7 +335,7 @@ static void msm_summary_irq_handler(unsigned int irq, struct irq_desc *desc)
 			generic_handle_irq(msm_gpio_to_irq(&msm_gpio.gpio_chip,
 							   i));
 	}
-	desc->chip->ack(irq);
+	chip->irq_ack(&desc->irq_data);
 }
 
 static int msm_gpio_irq_set_wake(unsigned int irq, unsigned int on)
@@ -343,12 +344,12 @@ static int msm_gpio_irq_set_wake(unsigned int irq, unsigned int on)
 
 	if (on) {
 		if (bitmap_empty(msm_gpio.wake_irqs, NR_GPIO_IRQS))
-			set_irq_wake(TLMM_SCSS_SUMMARY_IRQ, 1);
+			set_irq_wake(TLMM_MSM_SUMMARY_IRQ, 1);
 		set_bit(gpio, msm_gpio.wake_irqs);
 	} else {
 		clear_bit(gpio, msm_gpio.wake_irqs);
 		if (bitmap_empty(msm_gpio.wake_irqs, NR_GPIO_IRQS))
-			set_irq_wake(TLMM_SCSS_SUMMARY_IRQ, 0);
+			set_irq_wake(TLMM_MSM_SUMMARY_IRQ, 0);
 	}
 
 	return 0;
@@ -382,7 +383,7 @@ static int __devinit msm_gpio_probe(struct platform_device *dev)
 		set_irq_flags(irq, IRQF_VALID);
 	}
 
-	set_irq_chained_handler(TLMM_SCSS_SUMMARY_IRQ,
+	set_irq_chained_handler(TLMM_MSM_SUMMARY_IRQ,
 				msm_summary_irq_handler);
 	return 0;
 }
@@ -394,7 +395,7 @@ static int __devexit msm_gpio_remove(struct platform_device *dev)
 	if (ret < 0)
 		return ret;
 
-	set_irq_handler(TLMM_SCSS_SUMMARY_IRQ, NULL);
+	set_irq_handler(TLMM_MSM_SUMMARY_IRQ, NULL);
 
 	return 0;
 }
diff --git a/arch/arm/mach-msm/include/mach/irqs-8960.h b/arch/arm/mach-msm/include/mach/irqs-8960.h
index 81ab2a6..3dda5d3 100644
--- a/arch/arm/mach-msm/include/mach/irqs-8960.h
+++ b/arch/arm/mach-msm/include/mach/irqs-8960.h
@@ -43,19 +43,19 @@
 #define SC_SICL2IRPTREQ				(GIC_SPI_START + 1)
 #define SC_SICL2PERFMONIRPTREQ			(GIC_SPI_START + 2)
 #define SC_SICAGCIRPTREQ			(GIC_SPI_START + 3)
-#define TLMM_APCC_DIR_CONN_IRQ_0		(GIC_SPI_START + 4)
-#define TLMM_APCC_DIR_CONN_IRQ_1		(GIC_SPI_START + 5)
-#define TLMM_APCC_DIR_CONN_IRQ_2		(GIC_SPI_START + 6)
-#define TLMM_APCC_DIR_CONN_IRQ_3		(GIC_SPI_START + 7)
-#define TLMM_APCC_DIR_CONN_IRQ_4		(GIC_SPI_START + 8)
-#define TLMM_APCC_DIR_CONN_IRQ_5		(GIC_SPI_START + 9)
-#define TLMM_APCC_DIR_CONN_IRQ_6		(GIC_SPI_START + 10)
-#define TLMM_APCC_DIR_CONN_IRQ_7		(GIC_SPI_START + 11)
-#define TLMM_APCC_DIR_CONN_IRQ_8		(GIC_SPI_START + 12)
-#define TLMM_APCC_DIR_CONN_IRQ_9		(GIC_SPI_START + 13)
+#define TLMM_MSM_DIR_CONN_IRQ_0			(GIC_SPI_START + 4)
+#define TLMM_MSM_DIR_CONN_IRQ_1			(GIC_SPI_START + 5)
+#define TLMM_MSM_DIR_CONN_IRQ_2			(GIC_SPI_START + 6)
+#define TLMM_MSM_DIR_CONN_IRQ_3			(GIC_SPI_START + 7)
+#define TLMM_MSM_DIR_CONN_IRQ_4			(GIC_SPI_START + 8)
+#define TLMM_MSM_DIR_CONN_IRQ_5			(GIC_SPI_START + 9)
+#define TLMM_MSM_DIR_CONN_IRQ_6			(GIC_SPI_START + 10)
+#define TLMM_MSM_DIR_CONN_IRQ_7			(GIC_SPI_START + 11)
+#define TLMM_MSM_DIR_CONN_IRQ_8			(GIC_SPI_START + 12)
+#define TLMM_MSM_DIR_CONN_IRQ_9			(GIC_SPI_START + 13)
 #define PM8921_SEC_IRQ_103			(GIC_SPI_START + 14)
 #define PM8018_SEC_IRQ_106			(GIC_SPI_START + 15)
-#define TLMM_APCC_SUMMARY_IRQ			(GIC_SPI_START + 16)
+#define TLMM_MSM_SUMMARY_IRQ			(GIC_SPI_START + 16)
 #define SPDM_RT_1_IRQ				(GIC_SPI_START + 17)
 #define SPDM_DIAG_IRQ				(GIC_SPI_START + 18)
 #define RPM_APCC_CPU0_GP_HIGH_IRQ		(GIC_SPI_START + 19)
@@ -258,20 +258,20 @@
 #define QDSS_ETB_IRQ				(GIC_SPI_START + 216)
 #define QDSS_CTI2KPSS_CPU1_IRQ			(GIC_SPI_START + 217)
 #define QDSS_CTI2KPSS_CPU0_IRQ			(GIC_SPI_START + 218)
-#define TLMM_APCC_DIR_CONN_IRQ_16		(GIC_SPI_START + 219)
-#define TLMM_APCC_DIR_CONN_IRQ_17		(GIC_SPI_START + 220)
-#define TLMM_APCC_DIR_CONN_IRQ_18		(GIC_SPI_START + 221)
-#define TLMM_APCC_DIR_CONN_IRQ_19		(GIC_SPI_START + 222)
-#define TLMM_APCC_DIR_CONN_IRQ_20		(GIC_SPI_START + 223)
-#define TLMM_APCC_DIR_CONN_IRQ_21		(GIC_SPI_START + 224)
+#define TLMM_MSM_DIR_CONN_IRQ_16		(GIC_SPI_START + 219)
+#define TLMM_MSM_DIR_CONN_IRQ_17		(GIC_SPI_START + 220)
+#define TLMM_MSM_DIR_CONN_IRQ_18		(GIC_SPI_START + 221)
+#define TLMM_MSM_DIR_CONN_IRQ_19		(GIC_SPI_START + 222)
+#define TLMM_MSM_DIR_CONN_IRQ_20		(GIC_SPI_START + 223)
+#define TLMM_MSM_DIR_CONN_IRQ_21		(GIC_SPI_START + 224)
 #define PM8921_SEC_IRQ_104			(GIC_SPI_START + 225)
 #define PM8018_SEC_IRQ_107			(GIC_SPI_START + 226)
 
 /* For now, use the maximum number of interrupts until a pending GIC issue
  * is sorted out */
-#define NR_MSM_IRQS 1020
+#define NR_MSM_IRQS 870
 #define NR_BOARD_IRQS 0
-#define NR_GPIO_IRQS 0
+#define NR_GPIO_IRQS 150
 
 #endif
 
diff --git a/arch/arm/mach-msm/include/mach/irqs-8x60.h b/arch/arm/mach-msm/include/mach/irqs-8x60.h
index f65841c..deb7a2e 100644
--- a/arch/arm/mach-msm/include/mach/irqs-8x60.h
+++ b/arch/arm/mach-msm/include/mach/irqs-8x60.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010 Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2011 Code Aurora Forum. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -44,19 +44,19 @@
 #define SC_SICL2IRPTREQ				(GIC_SPI_START + 1)
 #define SC_SICL2ACGIRPTREQ			(GIC_SPI_START + 2)
 #define NC					(GIC_SPI_START + 3)
-#define TLMM_SCSS_DIR_CONN_IRQ_0		(GIC_SPI_START + 4)
-#define TLMM_SCSS_DIR_CONN_IRQ_1		(GIC_SPI_START + 5)
-#define TLMM_SCSS_DIR_CONN_IRQ_2		(GIC_SPI_START + 6)
-#define TLMM_SCSS_DIR_CONN_IRQ_3		(GIC_SPI_START + 7)
-#define TLMM_SCSS_DIR_CONN_IRQ_4		(GIC_SPI_START + 8)
-#define TLMM_SCSS_DIR_CONN_IRQ_5		(GIC_SPI_START + 9)
-#define TLMM_SCSS_DIR_CONN_IRQ_6		(GIC_SPI_START + 10)
-#define TLMM_SCSS_DIR_CONN_IRQ_7		(GIC_SPI_START + 11)
-#define TLMM_SCSS_DIR_CONN_IRQ_8		(GIC_SPI_START + 12)
-#define TLMM_SCSS_DIR_CONN_IRQ_9		(GIC_SPI_START + 13)
+#define TLMM_MSM_DIR_CONN_IRQ_0			(GIC_SPI_START + 4)
+#define TLMM_MSM_DIR_CONN_IRQ_1			(GIC_SPI_START + 5)
+#define TLMM_MSM_DIR_CONN_IRQ_2			(GIC_SPI_START + 6)
+#define TLMM_MSM_DIR_CONN_IRQ_3			(GIC_SPI_START + 7)
+#define TLMM_MSM_DIR_CONN_IRQ_4			(GIC_SPI_START + 8)
+#define TLMM_MSM_DIR_CONN_IRQ_5			(GIC_SPI_START + 9)
+#define TLMM_MSM_DIR_CONN_IRQ_6			(GIC_SPI_START + 10)
+#define TLMM_MSM_DIR_CONN_IRQ_7			(GIC_SPI_START + 11)
+#define TLMM_MSM_DIR_CONN_IRQ_8			(GIC_SPI_START + 12)
+#define TLMM_MSM_DIR_CONN_IRQ_9			(GIC_SPI_START + 13)
 #define PM8058_SEC_IRQ_N			(GIC_SPI_START + 14)
 #define PM8901_SEC_IRQ_N			(GIC_SPI_START + 15)
-#define TLMM_SCSS_SUMMARY_IRQ			(GIC_SPI_START + 16)
+#define TLMM_MSM_SUMMARY_IRQ			(GIC_SPI_START + 16)
 #define SPDM_RT_1_IRQ				(GIC_SPI_START + 17)
 #define SPDM_DIAG_IRQ				(GIC_SPI_START + 18)
 #define RPM_SCSS_CPU0_GP_HIGH_IRQ		(GIC_SPI_START + 19)
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
index 3c9d960..f735026 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
@@ -45,4 +45,7 @@
 #define MSM8960_TMR0_PHYS	0x0208A000
 #define MSM8960_TMR0_SIZE	SZ_4K
 
+#define MSM8960_TLMM_PHYS	0x00800000
+#define MSM8960_TLMM_SIZE	SZ_16K
+
 #endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index 3b19b8f..e0aa98a 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -49,9 +49,8 @@
 #define MSM_GCC_PHYS		0x02082000
 #define MSM_GCC_SIZE		SZ_4K
 
-#define MSM_TLMM_BASE		IOMEM(0xF0004000)
-#define MSM_TLMM_PHYS		0x00800000
-#define MSM_TLMM_SIZE		SZ_16K
+#define MSM8X60_TLMM_PHYS	0x00800000
+#define MSM8X60_TLMM_SIZE	SZ_16K
 
 #define MSM_SHARED_RAM_BASE	IOMEM(0xF0100000)
 #define MSM_SHARED_RAM_SIZE	SZ_1M
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index c98c759..f3980ce 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -61,5 +61,6 @@
 #define MSM_QGIC_CPU_BASE	IOMEM(0xF0001000)
 #define MSM_TMR_BASE		IOMEM(0xF0200000)
 #define MSM_TMR0_BASE		IOMEM(0xF0201000)
+#define MSM_TLMM_BASE		IOMEM(0xF0202000)
 
 #endif
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index cec6ed1..2285682 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -106,6 +106,7 @@ static struct map_desc msm8x60_io_desc[] __initdata = {
 	MSM_CHIP_DEVICE(QGIC_CPU, MSM8X60),
 	MSM_CHIP_DEVICE(TMR, MSM8X60),
 	MSM_CHIP_DEVICE(TMR0, MSM8X60),
+	MSM_CHIP_DEVICE(TLMM, MSM8X60),
 	MSM_DEVICE(ACC),
 	MSM_DEVICE(GCC),
 };
@@ -122,6 +123,7 @@ static struct map_desc msm8960_io_desc[] __initdata = {
 	MSM_CHIP_DEVICE(QGIC_CPU, MSM8960),
 	MSM_CHIP_DEVICE(TMR, MSM8960),
 	MSM_CHIP_DEVICE(TMR0, MSM8960),
+	MSM_CHIP_DEVICE(TLMM, MSM8960),
 };
 
 void __init msm_map_msm8960_io(void)
-- 
Sent by an employee of the Qualcomm Innovation Center,Inc
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

