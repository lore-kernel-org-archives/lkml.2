Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab0FRTNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 15:13:16 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55857 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab0FRTNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 15:13:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6017"; a="44863406"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 2/3] msm: 7x30: Add gpio device configuration.
Date: Fri, 18 Jun 2010 12:12:54 -0700
Message-Id: <1276888375-13221-3-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1276888375-13221-1-git-send-email-gbean@codeaurora.org>
References: <1276888375-13221-1-git-send-email-gbean@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device configuration and board-init for gpio on the MSM7x30.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/board-msm7x30.c     |   29 +++++++++++++++++++++++++-
 arch/arm/mach-msm/devices-msm7x30.c   |   23 +++++++++++++++++++++
 arch/arm/mach-msm/devices.h           |   35 +++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/include/mach/gpio.h |    2 +
 4 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index edd5983..f1ae525 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -55,7 +55,31 @@ static void msm7x30_init_uart2(void)
 }
 #endif
 
-static struct platform_device *devices[] __initdata = {
+/*
+ * Early devices are those which provide a system service which will be
+ * required by one or more of the function calls in msm7x30_init.
+ * These devices must be probed and online first in order for
+ * the init routine to run successfully.
+ */
+static struct platform_device *early_devices[] __initdata = {
+#ifdef CONFIG_GPIOLIB
+	&msm_gpio_devices[0],
+	&msm_gpio_devices[1],
+	&msm_gpio_devices[2],
+	&msm_gpio_devices[3],
+	&msm_gpio_devices[4],
+	&msm_gpio_devices[5],
+	&msm_gpio_devices[6],
+	&msm_gpio_devices[7],
+#endif
+};
+
+/*
+ * Late devices are those which are dependent upon services initialized
+ * by msm7x30_init, or which simply have no dependents and can have
+ * their initialization deferred.
+ */
+static struct platform_device *late_devices[] __initdata = {
 #if defined(CONFIG_SERIAL_MSM) || defined(CONFIG_MSM_SERIAL_DEBUGGER)
         &msm_device_uart2,
 #endif
@@ -69,10 +93,11 @@ static void __init msm7x30_init_irq(void)
 
 static void __init msm7x30_init(void)
 {
+	platform_add_devices(early_devices, ARRAY_SIZE(early_devices));
 #ifdef CONFIG_SERIAL_MSM_CONSOLE
 	msm7x30_init_uart2();
 #endif
-	platform_add_devices(devices, ARRAY_SIZE(devices));
+	platform_add_devices(late_devices, ARRAY_SIZE(late_devices));
 }
 
 static void __init msm7x30_map_io(void)
diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index b449e8a..995b1f7 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -126,3 +126,26 @@ struct clk msm_clocks_7x30[] = {
 
 unsigned msm_num_clocks_7x30 = ARRAY_SIZE(msm_clocks_7x30);
 
+#ifdef CONFIG_GPIOLIB
+static struct msm7200a_gpio_platform_data gpio_platform_data[] = {
+	MSM7200A_GPIO_PLATFORM_DATA(0,   0,  15, INT_GPIO_GROUP1),
+	MSM7200A_GPIO_PLATFORM_DATA(1,  16,  43, INT_GPIO_GROUP2),
+	MSM7200A_GPIO_PLATFORM_DATA(2,  44,  67, INT_GPIO_GROUP1),
+	MSM7200A_GPIO_PLATFORM_DATA(3,  68,  94, INT_GPIO_GROUP1),
+	MSM7200A_GPIO_PLATFORM_DATA(4,  95, 106, INT_GPIO_GROUP1),
+	MSM7200A_GPIO_PLATFORM_DATA(5, 107, 133, INT_GPIO_GROUP1),
+	MSM7200A_GPIO_PLATFORM_DATA(6, 134, 150, INT_GPIO_GROUP1),
+	MSM7200A_GPIO_PLATFORM_DATA(7, 151, 181, INT_GPIO_GROUP1),
+};
+
+struct platform_device msm_gpio_devices[] = {
+	MSM7200A_GPIO_DEVICE(0, gpio_platform_data),
+	MSM7200A_GPIO_DEVICE(1, gpio_platform_data),
+	MSM7200A_GPIO_DEVICE(2, gpio_platform_data),
+	MSM7200A_GPIO_DEVICE(3, gpio_platform_data),
+	MSM7200A_GPIO_DEVICE(4, gpio_platform_data),
+	MSM7200A_GPIO_DEVICE(5, gpio_platform_data),
+	MSM7200A_GPIO_DEVICE(6, gpio_platform_data),
+	MSM7200A_GPIO_DEVICE(7, gpio_platform_data),
+};
+#endif
diff --git a/arch/arm/mach-msm/devices.h b/arch/arm/mach-msm/devices.h
index 568443e..321d4db 100644
--- a/arch/arm/mach-msm/devices.h
+++ b/arch/arm/mach-msm/devices.h
@@ -17,6 +17,8 @@
 #define __ARCH_ARM_MACH_MSM_DEVICES_H
 
 #include "clock.h"
+#include "gpio_hw.h"
+#include "msm7200a-gpio.h"
 
 extern struct platform_device msm_device_uart1;
 extern struct platform_device msm_device_uart2;
@@ -44,4 +46,37 @@ extern unsigned msm_num_clocks_7x30;
 extern struct clk msm_clocks_8x50[];
 extern unsigned msm_num_clocks_8x50;
 
+#ifdef CONFIG_GPIOLIB
+#define MSM7200A_GPIO_PLATFORM_DATA(ix, begin, end, irq)		\
+	[ix] = {							\
+		.gpio_base		= begin,			\
+		.ngpio			= end - begin + 1,		\
+		.irq_base		= MSM_GPIO_TO_INT(begin),	\
+		.irq_summary		= irq,				\
+		.latch_level_irqs	= false,			\
+		.regs = {						\
+			.in		= GPIO_IN_ ## ix,		\
+			.out		= GPIO_OUT_ ## ix,		\
+			.oe		= GPIO_OE_ ## ix,		\
+			.int_status	= GPIO_INT_STATUS_ ## ix,	\
+			.int_clear	= GPIO_INT_CLEAR_ ## ix,	\
+			.int_en		= GPIO_INT_EN_ ## ix,		\
+			.int_edge	= GPIO_INT_EDGE_ ## ix,		\
+			.int_pos	= GPIO_INT_POS_ ## ix,		\
+		},							\
+	}
+
+#define MSM7200A_GPIO_DEVICE(ix, pdata)			\
+	{						\
+		.name		= "msm7200a-gpio",	\
+		.id		= ix,			\
+		.num_resources	= 0,			\
+		.dev = {				\
+			.platform_data = &pdata[ix],	\
+		},					\
+	}
+
+extern struct platform_device msm_gpio_devices[];
+#endif
+
 #endif
diff --git a/arch/arm/mach-msm/include/mach/gpio.h b/arch/arm/mach-msm/include/mach/gpio.h
index 83e47c0..ff80758 100644
--- a/arch/arm/mach-msm/include/mach/gpio.h
+++ b/arch/arm/mach-msm/include/mach/gpio.h
@@ -16,6 +16,8 @@
 #ifndef __ASM_ARCH_MSM_GPIO_H
 #define __ASM_ARCH_MSM_GPIO_H
 
+#define ARCH_NR_GPIOS 512
+
 #include <asm-generic/gpio.h>
 
 #define gpio_get_value  __gpio_get_value
-- 
1.7.0.4

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
