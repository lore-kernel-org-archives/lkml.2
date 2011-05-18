Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab1ERVvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:51:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42702 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab1ERVvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:51:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6350"; a="91952574"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 6/7] gpio_msm: Move Qualcomm v6 MSM driver into drivers
Date: Wed, 18 May 2011 14:50:52 -0700
Message-Id: <1305755453-31112-7-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migrate the driver for the v6-based MSM chips into drivers/gpio.  The
driver is unchanged, only moved.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/Kconfig                          |    3 +++
 arch/arm/mach-msm/Makefile                         |    2 --
 drivers/gpio/Kconfig                               |    8 ++++++++
 drivers/gpio/Makefile                              |    1 +
 arch/arm/mach-msm/gpio.c => drivers/gpio/msm_v1.c  |    7 +++----
 .../mach-msm/gpio_hw.h => drivers/gpio/msm_v1.h    |    9 ++++-----
 6 files changed, 19 insertions(+), 11 deletions(-)
 rename arch/arm/mach-msm/gpio.c => drivers/gpio/msm_v1.c (98%)
 rename arch/arm/mach-msm/gpio_hw.h => drivers/gpio/msm_v1.h (98%)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 1516896..cc7c0b2 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -11,6 +11,7 @@ config ARCH_MSM7X00A
 	select MSM_SMD
 	select MSM_SMD_PKG3
 	select CPU_V6
+	select GPIO_MSM_V1
 	select MSM_PROC_COMM
 	select HAS_MSM_DEBUG_UART_PHYS
 
@@ -22,6 +23,7 @@ config ARCH_MSM7X30
 	select MSM_VIC
 	select CPU_V7
 	select MSM_GPIOMUX
+	select GPIO_MSM_V1
 	select MSM_PROC_COMM
 	select HAS_MSM_DEBUG_UART_PHYS
 
@@ -33,6 +35,7 @@ config ARCH_QSD8X50
 	select MSM_VIC
 	select CPU_V7
 	select MSM_GPIOMUX
+	select GPIO_MSM_V1
 	select MSM_PROC_COMM
 	select HAS_MSM_DEBUG_UART_PHYS
 
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index c72cb8e..edb6659 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -37,6 +37,4 @@ ifndef CONFIG_ARCH_MSM8960
 # TODO: TLMM Mapping issues need to be resolved
 obj-y	+= gpio-v2.o
 endif
-else
-obj-y	+= gpio.o
 endif
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d3b2953..aa5a3f9 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -131,6 +131,14 @@ config GPIO_VX855
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
 
+config GPIO_MSM_V1
+	tristate "Qualcomm MSM GPIO v1"
+	depends on GPIOLIB && ARCH_MSM
+	help
+	  Say yes here to support the GPIO interface on ARM v6 based
+	  Qualcomm MSM chips.  Most of the pins on the MSM can be
+	  selected for GPIO, and are controlled by this driver.
+
 comment "I2C GPIO expanders:"
 
 config GPIO_MAX7300
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index becef59..b6386e4 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -41,5 +41,6 @@ obj-$(CONFIG_GPIO_RDC321X)	+= rdc321x-gpio.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= janz-ttl.o
 obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
 obj-$(CONFIG_GPIO_VX855)	+= vx855_gpio.o
+obj-$(CONFIG_GPIO_MSM_V1)	+= msm_v1.o
 obj-$(CONFIG_GPIO_ML_IOH)	+= ml_ioh_gpio.o
 obj-$(CONFIG_AB8500_GPIO)       += ab8500-gpio.o
diff --git a/arch/arm/mach-msm/gpio.c b/drivers/gpio/msm_v1.c
similarity index 98%
rename from arch/arm/mach-msm/gpio.c
rename to drivers/gpio/msm_v1.c
index 2ac3a0f..4ba2067 100644
--- a/arch/arm/mach-msm/gpio.c
+++ b/drivers/gpio/msm_v1.c
@@ -1,7 +1,6 @@
-/* linux/arch/arm/mach-msm/gpio.c
- *
+/*
  * Copyright (C) 2007 Google, Inc.
- * Copyright (c) 2009-2010, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2009-2011, Code Aurora Forum. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -22,7 +21,7 @@
 #include <linux/module.h>
 #include <mach/cpu.h>
 #include <linux/msm_gpiomux.h>
-#include "gpio_hw.h"
+#include "msm_v1.h"
 
 #define FIRST_GPIO_IRQ MSM_GPIO_TO_INT(0)
 
diff --git a/arch/arm/mach-msm/gpio_hw.h b/drivers/gpio/msm_v1.h
similarity index 98%
rename from arch/arm/mach-msm/gpio_hw.h
rename to drivers/gpio/msm_v1.h
index ba7972a..a3e3cb2 100644
--- a/arch/arm/mach-msm/gpio_hw.h
+++ b/drivers/gpio/msm_v1.h
@@ -1,8 +1,7 @@
-/* arch/arm/mach-msm/gpio_hw.h
- *
+/*
  * Copyright (C) 2007 Google, Inc.
  * Author: Brian Swetland <swetland@google.com>
- * Copyright (c) 2008-2010, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2008-2011, Code Aurora Forum. All rights reserved.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -15,8 +14,8 @@
  *
  */
 
-#ifndef __ARCH_ARM_MACH_MSM_GPIO_HW_H
-#define __ARCH_ARM_MACH_MSM_GPIO_HW_H
+#ifndef _MSM_GPIO_V1_H
+#define _MSM_GPIO_V1_H
 
 #include <mach/msm_iomap.h>
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

