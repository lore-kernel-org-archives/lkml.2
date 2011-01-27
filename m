Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1A0UMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 15:12:14 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19241 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab1A0UMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 15:12:13 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6239"; a="72018081"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCHv2] msm: serial: Add MSM8960 serial support
Date: Thu, 27 Jan 2011 12:12:07 -0800
Message-Id: <1296159127-13945-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1295663921-32723-1-git-send-email-stepanm@codeaurora.org>
References: <1295663921-32723-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device definitions and platform data to support
the console serial port on MSM8960 Simulator and RUMI3
targets.

Change-Id: I6681a446ed1e1fce62bb52af879110228e907c5e
Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
V2: Minor cosmetic changes
* Change the order of some fields based on Russell's rules
* Update copyright header

 arch/arm/mach-msm/Makefile          |    2 +-
 arch/arm/mach-msm/board-msm8960.c   |   22 +++++++++
 arch/arm/mach-msm/devices-msm8960.c |   85 +++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/devices.h         |    3 +
 4 files changed, 111 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-msm/devices-msm8960.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index e3e38064..57b3062 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -25,7 +25,7 @@ obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
 obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
 obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
 obj-$(CONFIG_ARCH_MSM8X60) += board-msm8x60.o
-obj-$(CONFIG_ARCH_MSM8960) += board-msm8960.o
+obj-$(CONFIG_ARCH_MSM8960) += board-msm8960.o devices-msm8960.o

 obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-v1.o gpiomux.o
diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
index 2b09573..ef80f46 100644
--- a/arch/arm/mach-msm/board-msm8960.c
+++ b/arch/arm/mach-msm/board-msm8960.c
@@ -27,6 +27,8 @@
 #include <mach/board.h>
 #include <mach/msm_iomap.h>

+#include "devices.h"
+
 static void __init msm8960_map_io(void)
 {
 	msm_map_msm8960_io();
@@ -54,15 +56,35 @@ static void __init msm8960_init_irq(void)
 	}
 }

+static struct platform_device *sim_devices[] __initdata = {
+	&msm8960_device_uart_gsbi2,
+};
+
+static struct platform_device *rumi3_devices[] __initdata = {
+	&msm8960_device_uart_gsbi5,
+};
+
+static void __init msm8960_sim_init(void)
+{
+	platform_add_devices(sim_devices, ARRAY_SIZE(sim_devices));
+}
+
+static void __init msm8960_rumi3_init(void)
+{
+	platform_add_devices(rumi3_devices, ARRAY_SIZE(rumi3_devices));
+}
+
 MACHINE_START(MSM8960_SIM, "QCT MSM8960 SIMULATOR")
 	.map_io = msm8960_map_io,
 	.init_irq = msm8960_init_irq,
 	.timer = &msm_timer,
+	.init_machine = msm8960_sim_init,
 MACHINE_END

 MACHINE_START(MSM8960_RUMI3, "QCT MSM8960 RUMI3")
 	.map_io = msm8960_map_io,
 	.init_irq = msm8960_init_irq,
 	.timer = &msm_timer,
+	.init_machine = msm8960_rumi3_init,
 MACHINE_END

diff --git a/arch/arm/mach-msm/devices-msm8960.c b/arch/arm/mach-msm/devices-msm8960.c
new file mode 100644
index 0000000..d9e1f26
--- /dev/null
+++ b/arch/arm/mach-msm/devices-msm8960.c
@@ -0,0 +1,85 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+
+#include <linux/dma-mapping.h>
+#include <mach/irqs-8960.h>
+#include <mach/board.h>
+
+#include "devices.h"
+
+#define MSM_GSBI2_PHYS		0x16100000
+#define MSM_UART2DM_PHYS	(MSM_GSBI2_PHYS + 0x40000)
+
+#define MSM_GSBI5_PHYS		0x16400000
+#define MSM_UART5DM_PHYS	(MSM_GSBI5_PHYS + 0x40000)
+
+static struct resource resources_uart_gsbi2[] = {
+	{
+		.start	= GSBI2_UARTDM_IRQ,
+		.end	= GSBI2_UARTDM_IRQ,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= MSM_UART2DM_PHYS,
+		.end	= MSM_UART2DM_PHYS + PAGE_SIZE - 1,
+		.name	= "uart_resource",
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= MSM_GSBI2_PHYS,
+		.end	= MSM_GSBI2_PHYS + PAGE_SIZE - 1,
+		.name	= "gsbi_resource",
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+struct platform_device msm8960_device_uart_gsbi2 = {
+	.name	= "msm_serial",
+	.id	= 0,
+	.num_resources	= ARRAY_SIZE(resources_uart_gsbi2),
+	.resource	= resources_uart_gsbi2,
+};
+
+static struct resource resources_uart_gsbi5[] = {
+	{
+		.start	= GSBI5_UARTDM_IRQ,
+		.end	= GSBI5_UARTDM_IRQ,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.start	= MSM_UART5DM_PHYS,
+		.end	= MSM_UART5DM_PHYS + PAGE_SIZE - 1,
+		.name	= "uart_resource",
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= MSM_GSBI5_PHYS,
+		.end	= MSM_GSBI5_PHYS + PAGE_SIZE - 1,
+		.name	= "gsbi_resource",
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+struct platform_device msm8960_device_uart_gsbi5 = {
+	.name	= "msm_serial",
+	.id	= 0,
+	.num_resources	= ARRAY_SIZE(resources_uart_gsbi5),
+	.resource	= resources_uart_gsbi5,
+};
diff --git a/arch/arm/mach-msm/devices.h b/arch/arm/mach-msm/devices.h
index 87c70bf..e2643b3 100644
--- a/arch/arm/mach-msm/devices.h
+++ b/arch/arm/mach-msm/devices.h
@@ -22,6 +22,9 @@ extern struct platform_device msm_device_uart1;
 extern struct platform_device msm_device_uart2;
 extern struct platform_device msm_device_uart3;

+extern struct platform_device msm8960_device_uart_gsbi2;
+extern struct platform_device msm8960_device_uart_gsbi5;
+
 extern struct platform_device msm_device_sdc1;
 extern struct platform_device msm_device_sdc2;
 extern struct platform_device msm_device_sdc3;
--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

