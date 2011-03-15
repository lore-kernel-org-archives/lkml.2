Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1COFBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 01:01:49 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63697 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab1COFBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 01:01:25 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6285"; a="79964169"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jeff Ohlstein <johlstei@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>, San Mehat <san@google.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 09/11] msm: dma: Support msm8x60 dma
Date: Mon, 14 Mar 2011 22:01:12 -0700
Message-Id: <1300165274-8544-10-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
References: <1300165274-8544-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike previous targets, 8x60 has two different ADMs, which are managed
separately.

Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
---
 arch/arm/mach-msm/Makefile                      |    3 +-
 arch/arm/mach-msm/board-msm8x60.c               |    9 +++-
 arch/arm/mach-msm/devices-msm8x60.c             |   56 +++++++++++++++++++++++
 arch/arm/mach-msm/devices.h                     |    2 +
 arch/arm/mach-msm/dma.c                         |   17 +++++--
 arch/arm/mach-msm/include/mach/dma.h            |   55 ++++++++++++++++------
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    6 +++
 7 files changed, 126 insertions(+), 22 deletions(-)
 create mode 100644 arch/arm/mach-msm/devices-msm8x60.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 86acfa3..9998f75 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_MSM_IOMMU) += iommu.o iommu_dev.o devices-iommu.o
 obj-$(CONFIG_ARCH_MSM7X00A) += dma.o irq.o acpuclock-arm11.o
 obj-$(CONFIG_ARCH_MSM7X30) += dma.o
 obj-$(CONFIG_ARCH_QSD8X50) += dma.o sirc.o
+obj-$(CONFIG_ARCH_MSM8X60) += dma.o
 obj-$(CONFIG_ARCH_MSM8960) += clock-dummy.o
 
 obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
@@ -24,7 +25,7 @@ obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o b
 obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
 obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
 obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
-obj-$(CONFIG_ARCH_MSM8X60) += board-msm8x60.o
+obj-$(CONFIG_ARCH_MSM8X60) += board-msm8x60.o devices-msm8x60.o
 obj-$(CONFIG_ARCH_MSM8960) += board-msm8960.o devices-msm8960.o
 
 obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-v1.o gpiomux.o
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index b3c55f1..92105c4 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -28,12 +28,18 @@
 #include <mach/board.h>
 #include <mach/msm_iomap.h>
 
+#include <devices.h>
 
 static void __init msm8x60_map_io(void)
 {
 	msm_map_msm8x60_io();
 }
 
+static struct platform_device *devices[] __initdata = {
+	&msm_device_dmov_adm0,
+	&msm_device_dmov_adm1,
+};
+
 static void __init msm8x60_init_irq(void)
 {
 	unsigned int i;
@@ -62,6 +68,7 @@ static void __init msm8x60_init_irq(void)
 
 static void __init msm8x60_init(void)
 {
+	platform_add_devices(devices, ARRAY_SIZE(devices));
 }
 
 MACHINE_START(MSM8X60_RUMI3, "QCT MSM8X60 RUMI3")
diff --git a/arch/arm/mach-msm/devices-msm8x60.c b/arch/arm/mach-msm/devices-msm8x60.c
new file mode 100644
index 0000000..33c236c
--- /dev/null
+++ b/arch/arm/mach-msm/devices-msm8x60.c
@@ -0,0 +1,56 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+
+#include <mach/board.h>
+#include <mach/msm_iomap.h>
+#include <mach/dma.h>
+
+static struct resource resources_dmov_adm0[] = {
+	{
+		.start = MSM8X60_DMOV_ADM0_PHYS,
+		.end = MSM8X60_DMOV_ADM0_PHYS + MSM8X60_DMOV_ADM0_SIZE - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = INT_ADM0_AARM,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct resource resources_dmov_adm1[] = {
+	{
+		.start = MSM8X60_DMOV_ADM1_PHYS,
+		.end = MSM8X60_DMOV_ADM1_PHYS + MSM8X60_DMOV_ADM1_SIZE - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = INT_ADM1_AARM,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device msm_device_dmov_adm0 = {
+	.name	= "msm_dmov",
+	.id	= 0,
+	.num_resources = ARRAY_SIZE(resources_dmov_adm0),
+	.resource = resources_dmov_adm0,
+};
+
+struct platform_device msm_device_dmov_adm1 = {
+	.name	= "msm_dmov",
+	.id	= 1,
+	.num_resources = ARRAY_SIZE(resources_dmov_adm1),
+	.resource = resources_dmov_adm1,
+};
diff --git a/arch/arm/mach-msm/devices.h b/arch/arm/mach-msm/devices.h
index 54ebfee..0abf25f 100644
--- a/arch/arm/mach-msm/devices.h
+++ b/arch/arm/mach-msm/devices.h
@@ -41,6 +41,8 @@ extern struct platform_device msm_device_i2c;
 extern struct platform_device msm_device_smd;
 
 extern struct platform_device msm_device_dmov;
+extern struct platform_device msm_device_dmov_adm0;
+extern struct platform_device msm_device_dmov_adm1;
 
 extern struct platform_device msm_device_nand;
 
diff --git a/arch/arm/mach-msm/dma.c b/arch/arm/mach-msm/dma.c
index 5510c61..44d9621 100644
--- a/arch/arm/mach-msm/dma.c
+++ b/arch/arm/mach-msm/dma.c
@@ -51,17 +51,24 @@ struct msm_dmov_conf {
 static struct msm_dmov_conf dmov_conf[MSM_DMOV_MAX_ADMS];
 static int nr_adms;
 
-#define DMOV_SD0(off, ch) (0x0000 + (off) + ((ch) << 2))
-#define DMOV_SD1(off, ch) (0x0400 + (off) + ((ch) << 2))
-#define DMOV_SD2(off, ch) (0x0800 + (off) + ((ch) << 2))
-#define DMOV_SD3(off, ch) (0x0C00 + (off) + ((ch) << 2))
-
 #if defined(CONFIG_ARCH_MSM7X30)
 #define DMOV_SD_AARM DMOV_SD2
+#define DMOV_SD_SIZE 0x400
+#elif defined(CONFIG_ARCH_MSM8X60)
+#define DMOV_SD_AARM DMOV_SD1
+#define DMOV_SD_SIZE 0x800
 #else
 #define DMOV_SD_AARM DMOV_SD3
+#define DMOV_SD_SIZE 0x400
 #endif
 
+#define DMOV_ADDR(sd, off, ch) (((sd) * DMOV_SD_SIZE) + (off) + ((ch) << 2))
+
+#define DMOV_SD0(off, ch) DMOV_ADDR(0, off, ch)
+#define DMOV_SD1(off, ch) DMOV_ADDR(1, off, ch)
+#define DMOV_SD2(off, ch) DMOV_ADDR(2, off, ch)
+#define DMOV_SD3(off, ch) DMOV_ADDR(3, off, ch)
+
 #define DMOV_CMD_PTR(ch)      DMOV_SD_AARM(0x000, ch)
 #define DMOV_RSLT(ch)         DMOV_SD_AARM(0x040, ch)
 #define DMOV_FLUSH0(ch)       DMOV_SD_AARM(0x080, ch)
diff --git a/arch/arm/mach-msm/include/mach/dma.h b/arch/arm/mach-msm/include/mach/dma.h
index 23041c7..3d67773 100644
--- a/arch/arm/mach-msm/include/mach/dma.h
+++ b/arch/arm/mach-msm/include/mach/dma.h
@@ -34,24 +34,10 @@ struct msm_dmov_cmd {
 	void *data;
 };
 
-#ifndef CONFIG_ARCH_MSM8X60
 int msm_dmov_enqueue_cmd(unsigned id, struct msm_dmov_cmd *cmd);
 int msm_dmov_stop_cmd(unsigned id, struct msm_dmov_cmd *cmd, int graceful);
 int msm_dmov_exec_cmd(unsigned id, unsigned int cmdptr);
 int msm_dmov_flush(unsigned int id);
-#else
-static inline
-int msm_dmov_enqueue_cmd(unsigned id, struct msm_dmov_cmd *cmd) { return -EIO; }
-static inline
-int msm_dmov_stop_cmd(unsigned id, struct msm_dmov_cmd *cmd, int graceful)
-{
-	return -EIO;
-}
-static inline
-int msm_dmov_exec_cmd(unsigned id, unsigned int cmdptr) { return -EIO; }
-static inline
-int msm_dmov_flush(unsigned int id) { return -EIO; }
-#endif
 
 #define DMOV_CMD_LIST         (0 << 29) /* does not work */
 #define DMOV_CMD_PTR_LIST     (1 << 29) /* works */
@@ -76,8 +62,47 @@ int msm_dmov_flush(unsigned int id) { return -EIO; }
 #define DMOV_CONFIG_FORCE_FLUSH_RSLT   (1 << 1)
 #define DMOV_CONFIG_IRQ_EN             (1 << 0)
 
-/* channel assignments */
+#define DMOV_8X60_GP_CHAN           16
+
+#define DMOV_8X60_CE_IN_CHAN        2
+#define DMOV_8X60_CE_IN_CRCI        4
+
+#define DMOV_8X60_CE_OUT_CHAN       3
+#define DMOV_8X60_CE_OUT_CRCI       5
+
+#define DMOV_8X60_CE_HASH_CRCI      15
+
+#define DMOV_8X60_SDC1_CHAN         18
+#define DMOV_8X60_SDC1_CRCI         1
+
+#define DMOV_8X60_SDC2_CHAN         19
+#define DMOV_8X60_SDC2_CRCI         4
+
+#define DMOV_8X60_SDC3_CHAN         20
+#define DMOV_8X60_SDC3_CRCI         2
+
+#define DMOV_8X60_SDC4_CHAN         21
+#define DMOV_8X60_SDC4_CRCI         5
+
+#define DMOV_8X60_SDC5_CHAN         21
+#define DMOV_8X60_SDC5_CRCI         14
+
+#define DMOV_8X60_TSIF_CHAN         4
+#define DMOV_8X60_TSIF_CRCI         6
+
+#define DMOV_8X60_HSUART1_TX_CHAN   22
+#define DMOV_8X60_HSUART1_TX_CRCI   8
+
+#define DMOV_8X60_HSUART1_RX_CHAN   23
+#define DMOV_8X60_HSUART1_RX_CRCI   9
+
+#define DMOV_8X60_HSUART2_TX_CHAN   8
+#define DMOV_8X60_HSUART2_TX_CRCI   13
+
+#define DMOV_8X60_HSUART2_RX_CHAN   8
+#define DMOV_8X60_HSUART2_RX_CRCI   14
 
+/* channel assignments before 8x60 */
 #define DMOV_NAND_CHAN        7
 #define DMOV_NAND_CRCI_CMD    5
 #define DMOV_NAND_CRCI_DATA   4
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index 3b19b8f..87a26c6 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -56,6 +56,12 @@
 #define MSM_SHARED_RAM_BASE	IOMEM(0xF0100000)
 #define MSM_SHARED_RAM_SIZE	SZ_1M
 
+#define MSM8X60_DMOV_ADM0_PHYS	0x18320000
+#define MSM8X60_DMOV_ADM0_SIZE	SZ_1M
+
+#define MSM8X60_DMOV_ADM1_PHYS	0x18420000
+#define MSM8X60_DMOV_ADM1_SIZE	SZ_1M
+
 #define MSM8X60_TMR_PHYS	0x02000000
 #define MSM8X60_TMR_SIZE	SZ_4K
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

