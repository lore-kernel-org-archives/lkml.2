Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab1FFVwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:52:16 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16131 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845Ab1FFVvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:51:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6369"; a="95967502"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v3 6/8] msm: gpio: Fold register defs into C file
Date: Mon,  6 Jun 2011 14:51:13 -0700
Message-Id: <1307397075-11733-7-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307397075-11733-1-git-send-email-davidb@codeaurora.org>
References: <1305755453-31112-1-git-send-email-davidb@codeaurora.org>
 <1307397075-11733-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to have a separate header file containing only register
definitions that are used by a single driver.  Fold these into the
gpio driver.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/gpio.c    |  251 +++++++++++++++++++++++++++++++++++++++-
 arch/arm/mach-msm/gpio_hw.h |  272 -------------------------------------------
 2 files changed, 250 insertions(+), 273 deletions(-)
 delete mode 100644 arch/arm/mach-msm/gpio_hw.h

diff --git a/arch/arm/mach-msm/gpio.c b/arch/arm/mach-msm/gpio.c
index 6767deb..3bbf50e 100644
--- a/arch/arm/mach-msm/gpio.c
+++ b/arch/arm/mach-msm/gpio.c
@@ -22,7 +22,256 @@
 #include <linux/module.h>
 #include <mach/cpu.h>
 #include <mach/msm_gpiomux.h>
-#include "gpio_hw.h"
+#include <mach/msm_iomap.h>
+
+/* see 80-VA736-2 Rev C pp 695-751
+**
+** These are actually the *shadow* gpio registers, since the
+** real ones (which allow full access) are only available to the
+** ARM9 side of the world.
+**
+** Since the _BASE need to be page-aligned when we're mapping them
+** to virtual addresses, adjust for the additional offset in these
+** macros.
+*/
+
+#define MSM_GPIO1_REG(off) (MSM_GPIO1_BASE + (off))
+#define MSM_GPIO2_REG(off) (MSM_GPIO2_BASE + 0x400 + (off))
+#define MSM_GPIO1_SHADOW_REG(off) (MSM_GPIO1_BASE + 0x800 + (off))
+#define MSM_GPIO2_SHADOW_REG(off) (MSM_GPIO2_BASE + 0xC00 + (off))
+
+/*
+ * MSM7X00 registers
+ */
+/* output value */
+#define MSM7X00_GPIO_OUT_0	MSM_GPIO1_SHADOW_REG(0x00)  /* gpio  15-0  */
+#define MSM7X00_GPIO_OUT_1	MSM_GPIO2_SHADOW_REG(0x00)  /* gpio  42-16 */
+#define MSM7X00_GPIO_OUT_2	MSM_GPIO1_SHADOW_REG(0x04)  /* gpio  67-43 */
+#define MSM7X00_GPIO_OUT_3	MSM_GPIO1_SHADOW_REG(0x08)  /* gpio  94-68 */
+#define MSM7X00_GPIO_OUT_4	MSM_GPIO1_SHADOW_REG(0x0C)  /* gpio 106-95 */
+#define MSM7X00_GPIO_OUT_5	MSM_GPIO1_SHADOW_REG(0x50)  /* gpio 107-121 */
+
+/* same pin map as above, output enable */
+#define MSM7X00_GPIO_OE_0	MSM_GPIO1_SHADOW_REG(0x10)
+#define MSM7X00_GPIO_OE_1	MSM_GPIO2_SHADOW_REG(0x08)
+#define MSM7X00_GPIO_OE_2	MSM_GPIO1_SHADOW_REG(0x14)
+#define MSM7X00_GPIO_OE_3	MSM_GPIO1_SHADOW_REG(0x18)
+#define MSM7X00_GPIO_OE_4	MSM_GPIO1_SHADOW_REG(0x1C)
+#define MSM7X00_GPIO_OE_5	MSM_GPIO1_SHADOW_REG(0x54)
+
+/* same pin map as above, input read */
+#define MSM7X00_GPIO_IN_0	MSM_GPIO1_SHADOW_REG(0x34)
+#define MSM7X00_GPIO_IN_1	MSM_GPIO2_SHADOW_REG(0x20)
+#define MSM7X00_GPIO_IN_2	MSM_GPIO1_SHADOW_REG(0x38)
+#define MSM7X00_GPIO_IN_3	MSM_GPIO1_SHADOW_REG(0x3C)
+#define MSM7X00_GPIO_IN_4	MSM_GPIO1_SHADOW_REG(0x40)
+#define MSM7X00_GPIO_IN_5	MSM_GPIO1_SHADOW_REG(0x44)
+
+/* same pin map as above, 1=edge 0=level interrup */
+#define MSM7X00_GPIO_INT_EDGE_0	MSM_GPIO1_SHADOW_REG(0x60)
+#define MSM7X00_GPIO_INT_EDGE_1	MSM_GPIO2_SHADOW_REG(0x50)
+#define MSM7X00_GPIO_INT_EDGE_2	MSM_GPIO1_SHADOW_REG(0x64)
+#define MSM7X00_GPIO_INT_EDGE_3	MSM_GPIO1_SHADOW_REG(0x68)
+#define MSM7X00_GPIO_INT_EDGE_4	MSM_GPIO1_SHADOW_REG(0x6C)
+#define MSM7X00_GPIO_INT_EDGE_5	MSM_GPIO1_SHADOW_REG(0xC0)
+
+/* same pin map as above, 1=positive 0=negative */
+#define MSM7X00_GPIO_INT_POS_0	MSM_GPIO1_SHADOW_REG(0x70)
+#define MSM7X00_GPIO_INT_POS_1	MSM_GPIO2_SHADOW_REG(0x58)
+#define MSM7X00_GPIO_INT_POS_2	MSM_GPIO1_SHADOW_REG(0x74)
+#define MSM7X00_GPIO_INT_POS_3	MSM_GPIO1_SHADOW_REG(0x78)
+#define MSM7X00_GPIO_INT_POS_4	MSM_GPIO1_SHADOW_REG(0x7C)
+#define MSM7X00_GPIO_INT_POS_5	MSM_GPIO1_SHADOW_REG(0xBC)
+
+/* same pin map as above, interrupt enable */
+#define MSM7X00_GPIO_INT_EN_0	MSM_GPIO1_SHADOW_REG(0x80)
+#define MSM7X00_GPIO_INT_EN_1	MSM_GPIO2_SHADOW_REG(0x60)
+#define MSM7X00_GPIO_INT_EN_2	MSM_GPIO1_SHADOW_REG(0x84)
+#define MSM7X00_GPIO_INT_EN_3	MSM_GPIO1_SHADOW_REG(0x88)
+#define MSM7X00_GPIO_INT_EN_4	MSM_GPIO1_SHADOW_REG(0x8C)
+#define MSM7X00_GPIO_INT_EN_5	MSM_GPIO1_SHADOW_REG(0xB8)
+
+/* same pin map as above, write 1 to clear interrupt */
+#define MSM7X00_GPIO_INT_CLEAR_0	MSM_GPIO1_SHADOW_REG(0x90)
+#define MSM7X00_GPIO_INT_CLEAR_1	MSM_GPIO2_SHADOW_REG(0x68)
+#define MSM7X00_GPIO_INT_CLEAR_2	MSM_GPIO1_SHADOW_REG(0x94)
+#define MSM7X00_GPIO_INT_CLEAR_3	MSM_GPIO1_SHADOW_REG(0x98)
+#define MSM7X00_GPIO_INT_CLEAR_4	MSM_GPIO1_SHADOW_REG(0x9C)
+#define MSM7X00_GPIO_INT_CLEAR_5	MSM_GPIO1_SHADOW_REG(0xB4)
+
+/* same pin map as above, 1=interrupt pending */
+#define MSM7X00_GPIO_INT_STATUS_0	MSM_GPIO1_SHADOW_REG(0xA0)
+#define MSM7X00_GPIO_INT_STATUS_1	MSM_GPIO2_SHADOW_REG(0x70)
+#define MSM7X00_GPIO_INT_STATUS_2	MSM_GPIO1_SHADOW_REG(0xA4)
+#define MSM7X00_GPIO_INT_STATUS_3	MSM_GPIO1_SHADOW_REG(0xA8)
+#define MSM7X00_GPIO_INT_STATUS_4	MSM_GPIO1_SHADOW_REG(0xAC)
+#define MSM7X00_GPIO_INT_STATUS_5	MSM_GPIO1_SHADOW_REG(0xB0)
+
+/*
+ * QSD8X50 registers
+ */
+/* output value */
+#define QSD8X50_GPIO_OUT_0	MSM_GPIO1_SHADOW_REG(0x00)  /* gpio  15-0   */
+#define QSD8X50_GPIO_OUT_1	MSM_GPIO2_SHADOW_REG(0x00)  /* gpio  42-16  */
+#define QSD8X50_GPIO_OUT_2	MSM_GPIO1_SHADOW_REG(0x04)  /* gpio  67-43  */
+#define QSD8X50_GPIO_OUT_3	MSM_GPIO1_SHADOW_REG(0x08)  /* gpio  94-68  */
+#define QSD8X50_GPIO_OUT_4	MSM_GPIO1_SHADOW_REG(0x0C)  /* gpio 103-95  */
+#define QSD8X50_GPIO_OUT_5	MSM_GPIO1_SHADOW_REG(0x10)  /* gpio 121-104 */
+#define QSD8X50_GPIO_OUT_6	MSM_GPIO1_SHADOW_REG(0x14)  /* gpio 152-122 */
+#define QSD8X50_GPIO_OUT_7	MSM_GPIO1_SHADOW_REG(0x18)  /* gpio 164-153 */
+
+/* same pin map as above, output enable */
+#define QSD8X50_GPIO_OE_0	MSM_GPIO1_SHADOW_REG(0x20)
+#define QSD8X50_GPIO_OE_1	MSM_GPIO2_SHADOW_REG(0x08)
+#define QSD8X50_GPIO_OE_2	MSM_GPIO1_SHADOW_REG(0x24)
+#define QSD8X50_GPIO_OE_3	MSM_GPIO1_SHADOW_REG(0x28)
+#define QSD8X50_GPIO_OE_4	MSM_GPIO1_SHADOW_REG(0x2C)
+#define QSD8X50_GPIO_OE_5	MSM_GPIO1_SHADOW_REG(0x30)
+#define QSD8X50_GPIO_OE_6	MSM_GPIO1_SHADOW_REG(0x34)
+#define QSD8X50_GPIO_OE_7	MSM_GPIO1_SHADOW_REG(0x38)
+
+/* same pin map as above, input read */
+#define QSD8X50_GPIO_IN_0	MSM_GPIO1_SHADOW_REG(0x50)
+#define QSD8X50_GPIO_IN_1	MSM_GPIO2_SHADOW_REG(0x20)
+#define QSD8X50_GPIO_IN_2	MSM_GPIO1_SHADOW_REG(0x54)
+#define QSD8X50_GPIO_IN_3	MSM_GPIO1_SHADOW_REG(0x58)
+#define QSD8X50_GPIO_IN_4	MSM_GPIO1_SHADOW_REG(0x5C)
+#define QSD8X50_GPIO_IN_5	MSM_GPIO1_SHADOW_REG(0x60)
+#define QSD8X50_GPIO_IN_6	MSM_GPIO1_SHADOW_REG(0x64)
+#define QSD8X50_GPIO_IN_7	MSM_GPIO1_SHADOW_REG(0x68)
+
+/* same pin map as above, 1=edge 0=level interrup */
+#define QSD8X50_GPIO_INT_EDGE_0	MSM_GPIO1_SHADOW_REG(0x70)
+#define QSD8X50_GPIO_INT_EDGE_1	MSM_GPIO2_SHADOW_REG(0x50)
+#define QSD8X50_GPIO_INT_EDGE_2	MSM_GPIO1_SHADOW_REG(0x74)
+#define QSD8X50_GPIO_INT_EDGE_3	MSM_GPIO1_SHADOW_REG(0x78)
+#define QSD8X50_GPIO_INT_EDGE_4	MSM_GPIO1_SHADOW_REG(0x7C)
+#define QSD8X50_GPIO_INT_EDGE_5	MSM_GPIO1_SHADOW_REG(0x80)
+#define QSD8X50_GPIO_INT_EDGE_6	MSM_GPIO1_SHADOW_REG(0x84)
+#define QSD8X50_GPIO_INT_EDGE_7	MSM_GPIO1_SHADOW_REG(0x88)
+
+/* same pin map as above, 1=positive 0=negative */
+#define QSD8X50_GPIO_INT_POS_0	MSM_GPIO1_SHADOW_REG(0x90)
+#define QSD8X50_GPIO_INT_POS_1	MSM_GPIO2_SHADOW_REG(0x58)
+#define QSD8X50_GPIO_INT_POS_2	MSM_GPIO1_SHADOW_REG(0x94)
+#define QSD8X50_GPIO_INT_POS_3	MSM_GPIO1_SHADOW_REG(0x98)
+#define QSD8X50_GPIO_INT_POS_4	MSM_GPIO1_SHADOW_REG(0x9C)
+#define QSD8X50_GPIO_INT_POS_5	MSM_GPIO1_SHADOW_REG(0xA0)
+#define QSD8X50_GPIO_INT_POS_6	MSM_GPIO1_SHADOW_REG(0xA4)
+#define QSD8X50_GPIO_INT_POS_7	MSM_GPIO1_SHADOW_REG(0xA8)
+
+/* same pin map as above, interrupt enable */
+#define QSD8X50_GPIO_INT_EN_0	MSM_GPIO1_SHADOW_REG(0xB0)
+#define QSD8X50_GPIO_INT_EN_1	MSM_GPIO2_SHADOW_REG(0x60)
+#define QSD8X50_GPIO_INT_EN_2	MSM_GPIO1_SHADOW_REG(0xB4)
+#define QSD8X50_GPIO_INT_EN_3	MSM_GPIO1_SHADOW_REG(0xB8)
+#define QSD8X50_GPIO_INT_EN_4	MSM_GPIO1_SHADOW_REG(0xBC)
+#define QSD8X50_GPIO_INT_EN_5	MSM_GPIO1_SHADOW_REG(0xC0)
+#define QSD8X50_GPIO_INT_EN_6	MSM_GPIO1_SHADOW_REG(0xC4)
+#define QSD8X50_GPIO_INT_EN_7	MSM_GPIO1_SHADOW_REG(0xC8)
+
+/* same pin map as above, write 1 to clear interrupt */
+#define QSD8X50_GPIO_INT_CLEAR_0	MSM_GPIO1_SHADOW_REG(0xD0)
+#define QSD8X50_GPIO_INT_CLEAR_1	MSM_GPIO2_SHADOW_REG(0x68)
+#define QSD8X50_GPIO_INT_CLEAR_2	MSM_GPIO1_SHADOW_REG(0xD4)
+#define QSD8X50_GPIO_INT_CLEAR_3	MSM_GPIO1_SHADOW_REG(0xD8)
+#define QSD8X50_GPIO_INT_CLEAR_4	MSM_GPIO1_SHADOW_REG(0xDC)
+#define QSD8X50_GPIO_INT_CLEAR_5	MSM_GPIO1_SHADOW_REG(0xE0)
+#define QSD8X50_GPIO_INT_CLEAR_6	MSM_GPIO1_SHADOW_REG(0xE4)
+#define QSD8X50_GPIO_INT_CLEAR_7	MSM_GPIO1_SHADOW_REG(0xE8)
+
+/* same pin map as above, 1=interrupt pending */
+#define QSD8X50_GPIO_INT_STATUS_0	MSM_GPIO1_SHADOW_REG(0xF0)
+#define QSD8X50_GPIO_INT_STATUS_1	MSM_GPIO2_SHADOW_REG(0x70)
+#define QSD8X50_GPIO_INT_STATUS_2	MSM_GPIO1_SHADOW_REG(0xF4)
+#define QSD8X50_GPIO_INT_STATUS_3	MSM_GPIO1_SHADOW_REG(0xF8)
+#define QSD8X50_GPIO_INT_STATUS_4	MSM_GPIO1_SHADOW_REG(0xFC)
+#define QSD8X50_GPIO_INT_STATUS_5	MSM_GPIO1_SHADOW_REG(0x100)
+#define QSD8X50_GPIO_INT_STATUS_6	MSM_GPIO1_SHADOW_REG(0x104)
+#define QSD8X50_GPIO_INT_STATUS_7	MSM_GPIO1_SHADOW_REG(0x108)
+
+/*
+ * MSM7X30 registers
+ */
+/* output value */
+#define MSM7X30_GPIO_OUT_0	MSM_GPIO1_REG(0x00)   /* gpio  15-0   */
+#define MSM7X30_GPIO_OUT_1	MSM_GPIO2_REG(0x00)   /* gpio  43-16  */
+#define MSM7X30_GPIO_OUT_2	MSM_GPIO1_REG(0x04)   /* gpio  67-44  */
+#define MSM7X30_GPIO_OUT_3	MSM_GPIO1_REG(0x08)   /* gpio  94-68  */
+#define MSM7X30_GPIO_OUT_4	MSM_GPIO1_REG(0x0C)   /* gpio 106-95  */
+#define MSM7X30_GPIO_OUT_5	MSM_GPIO1_REG(0x50)   /* gpio 133-107 */
+#define MSM7X30_GPIO_OUT_6	MSM_GPIO1_REG(0xC4)   /* gpio 150-134 */
+#define MSM7X30_GPIO_OUT_7	MSM_GPIO1_REG(0x214)  /* gpio 181-151 */
+
+/* same pin map as above, output enable */
+#define MSM7X30_GPIO_OE_0	MSM_GPIO1_REG(0x10)
+#define MSM7X30_GPIO_OE_1	MSM_GPIO2_REG(0x08)
+#define MSM7X30_GPIO_OE_2	MSM_GPIO1_REG(0x14)
+#define MSM7X30_GPIO_OE_3	MSM_GPIO1_REG(0x18)
+#define MSM7X30_GPIO_OE_4	MSM_GPIO1_REG(0x1C)
+#define MSM7X30_GPIO_OE_5	MSM_GPIO1_REG(0x54)
+#define MSM7X30_GPIO_OE_6	MSM_GPIO1_REG(0xC8)
+#define MSM7X30_GPIO_OE_7	MSM_GPIO1_REG(0x218)
+
+/* same pin map as above, input read */
+#define MSM7X30_GPIO_IN_0	MSM_GPIO1_REG(0x34)
+#define MSM7X30_GPIO_IN_1	MSM_GPIO2_REG(0x20)
+#define MSM7X30_GPIO_IN_2	MSM_GPIO1_REG(0x38)
+#define MSM7X30_GPIO_IN_3	MSM_GPIO1_REG(0x3C)
+#define MSM7X30_GPIO_IN_4	MSM_GPIO1_REG(0x40)
+#define MSM7X30_GPIO_IN_5	MSM_GPIO1_REG(0x44)
+#define MSM7X30_GPIO_IN_6	MSM_GPIO1_REG(0xCC)
+#define MSM7X30_GPIO_IN_7	MSM_GPIO1_REG(0x21C)
+
+/* same pin map as above, 1=edge 0=level interrup */
+#define MSM7X30_GPIO_INT_EDGE_0	MSM_GPIO1_REG(0x60)
+#define MSM7X30_GPIO_INT_EDGE_1	MSM_GPIO2_REG(0x50)
+#define MSM7X30_GPIO_INT_EDGE_2	MSM_GPIO1_REG(0x64)
+#define MSM7X30_GPIO_INT_EDGE_3	MSM_GPIO1_REG(0x68)
+#define MSM7X30_GPIO_INT_EDGE_4	MSM_GPIO1_REG(0x6C)
+#define MSM7X30_GPIO_INT_EDGE_5	MSM_GPIO1_REG(0xC0)
+#define MSM7X30_GPIO_INT_EDGE_6	MSM_GPIO1_REG(0xD0)
+#define MSM7X30_GPIO_INT_EDGE_7	MSM_GPIO1_REG(0x240)
+
+/* same pin map as above, 1=positive 0=negative */
+#define MSM7X30_GPIO_INT_POS_0	MSM_GPIO1_REG(0x70)
+#define MSM7X30_GPIO_INT_POS_1	MSM_GPIO2_REG(0x58)
+#define MSM7X30_GPIO_INT_POS_2	MSM_GPIO1_REG(0x74)
+#define MSM7X30_GPIO_INT_POS_3	MSM_GPIO1_REG(0x78)
+#define MSM7X30_GPIO_INT_POS_4	MSM_GPIO1_REG(0x7C)
+#define MSM7X30_GPIO_INT_POS_5	MSM_GPIO1_REG(0xBC)
+#define MSM7X30_GPIO_INT_POS_6	MSM_GPIO1_REG(0xD4)
+#define MSM7X30_GPIO_INT_POS_7	MSM_GPIO1_REG(0x228)
+
+/* same pin map as above, interrupt enable */
+#define MSM7X30_GPIO_INT_EN_0	MSM_GPIO1_REG(0x80)
+#define MSM7X30_GPIO_INT_EN_1	MSM_GPIO2_REG(0x60)
+#define MSM7X30_GPIO_INT_EN_2	MSM_GPIO1_REG(0x84)
+#define MSM7X30_GPIO_INT_EN_3	MSM_GPIO1_REG(0x88)
+#define MSM7X30_GPIO_INT_EN_4	MSM_GPIO1_REG(0x8C)
+#define MSM7X30_GPIO_INT_EN_5	MSM_GPIO1_REG(0xB8)
+#define MSM7X30_GPIO_INT_EN_6	MSM_GPIO1_REG(0xD8)
+#define MSM7X30_GPIO_INT_EN_7	MSM_GPIO1_REG(0x22C)
+
+/* same pin map as above, write 1 to clear interrupt */
+#define MSM7X30_GPIO_INT_CLEAR_0	MSM_GPIO1_REG(0x90)
+#define MSM7X30_GPIO_INT_CLEAR_1	MSM_GPIO2_REG(0x68)
+#define MSM7X30_GPIO_INT_CLEAR_2	MSM_GPIO1_REG(0x94)
+#define MSM7X30_GPIO_INT_CLEAR_3	MSM_GPIO1_REG(0x98)
+#define MSM7X30_GPIO_INT_CLEAR_4	MSM_GPIO1_REG(0x9C)
+#define MSM7X30_GPIO_INT_CLEAR_5	MSM_GPIO1_REG(0xB4)
+#define MSM7X30_GPIO_INT_CLEAR_6	MSM_GPIO1_REG(0xDC)
+#define MSM7X30_GPIO_INT_CLEAR_7	MSM_GPIO1_REG(0x230)
+
+/* same pin map as above, 1=interrupt pending */
+#define MSM7X30_GPIO_INT_STATUS_0	MSM_GPIO1_REG(0xA0)
+#define MSM7X30_GPIO_INT_STATUS_1	MSM_GPIO2_REG(0x70)
+#define MSM7X30_GPIO_INT_STATUS_2	MSM_GPIO1_REG(0xA4)
+#define MSM7X30_GPIO_INT_STATUS_3	MSM_GPIO1_REG(0xA8)
+#define MSM7X30_GPIO_INT_STATUS_4	MSM_GPIO1_REG(0xAC)
+#define MSM7X30_GPIO_INT_STATUS_5	MSM_GPIO1_REG(0xB0)
+#define MSM7X30_GPIO_INT_STATUS_6	MSM_GPIO1_REG(0xE0)
+#define MSM7X30_GPIO_INT_STATUS_7	MSM_GPIO1_REG(0x234)
 
 #define FIRST_GPIO_IRQ MSM_GPIO_TO_INT(0)
 
diff --git a/arch/arm/mach-msm/gpio_hw.h b/arch/arm/mach-msm/gpio_hw.h
deleted file mode 100644
index ba7972a..0000000
--- a/arch/arm/mach-msm/gpio_hw.h
+++ /dev/null
@@ -1,272 +0,0 @@
-/* arch/arm/mach-msm/gpio_hw.h
- *
- * Copyright (C) 2007 Google, Inc.
- * Author: Brian Swetland <swetland@google.com>
- * Copyright (c) 2008-2010, Code Aurora Forum. All rights reserved.
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#ifndef __ARCH_ARM_MACH_MSM_GPIO_HW_H
-#define __ARCH_ARM_MACH_MSM_GPIO_HW_H
-
-#include <mach/msm_iomap.h>
-
-/* see 80-VA736-2 Rev C pp 695-751
-**
-** These are actually the *shadow* gpio registers, since the
-** real ones (which allow full access) are only available to the
-** ARM9 side of the world.
-**
-** Since the _BASE need to be page-aligned when we're mapping them
-** to virtual addresses, adjust for the additional offset in these
-** macros.
-*/
-
-#define MSM_GPIO1_REG(off) (MSM_GPIO1_BASE + (off))
-#define MSM_GPIO2_REG(off) (MSM_GPIO2_BASE + 0x400 + (off))
-#define MSM_GPIO1_SHADOW_REG(off) (MSM_GPIO1_BASE + 0x800 + (off))
-#define MSM_GPIO2_SHADOW_REG(off) (MSM_GPIO2_BASE + 0xC00 + (off))
-
-/*
- * MSM7X00 registers
- */
-/* output value */
-#define MSM7X00_GPIO_OUT_0	MSM_GPIO1_SHADOW_REG(0x00)  /* gpio  15-0  */
-#define MSM7X00_GPIO_OUT_1	MSM_GPIO2_SHADOW_REG(0x00)  /* gpio  42-16 */
-#define MSM7X00_GPIO_OUT_2	MSM_GPIO1_SHADOW_REG(0x04)  /* gpio  67-43 */
-#define MSM7X00_GPIO_OUT_3	MSM_GPIO1_SHADOW_REG(0x08)  /* gpio  94-68 */
-#define MSM7X00_GPIO_OUT_4	MSM_GPIO1_SHADOW_REG(0x0C)  /* gpio 106-95 */
-#define MSM7X00_GPIO_OUT_5	MSM_GPIO1_SHADOW_REG(0x50)  /* gpio 107-121 */
-
-/* same pin map as above, output enable */
-#define MSM7X00_GPIO_OE_0	MSM_GPIO1_SHADOW_REG(0x10)
-#define MSM7X00_GPIO_OE_1	MSM_GPIO2_SHADOW_REG(0x08)
-#define MSM7X00_GPIO_OE_2	MSM_GPIO1_SHADOW_REG(0x14)
-#define MSM7X00_GPIO_OE_3	MSM_GPIO1_SHADOW_REG(0x18)
-#define MSM7X00_GPIO_OE_4	MSM_GPIO1_SHADOW_REG(0x1C)
-#define MSM7X00_GPIO_OE_5	MSM_GPIO1_SHADOW_REG(0x54)
-
-/* same pin map as above, input read */
-#define MSM7X00_GPIO_IN_0	MSM_GPIO1_SHADOW_REG(0x34)
-#define MSM7X00_GPIO_IN_1	MSM_GPIO2_SHADOW_REG(0x20)
-#define MSM7X00_GPIO_IN_2	MSM_GPIO1_SHADOW_REG(0x38)
-#define MSM7X00_GPIO_IN_3	MSM_GPIO1_SHADOW_REG(0x3C)
-#define MSM7X00_GPIO_IN_4	MSM_GPIO1_SHADOW_REG(0x40)
-#define MSM7X00_GPIO_IN_5	MSM_GPIO1_SHADOW_REG(0x44)
-
-/* same pin map as above, 1=edge 0=level interrup */
-#define MSM7X00_GPIO_INT_EDGE_0	MSM_GPIO1_SHADOW_REG(0x60)
-#define MSM7X00_GPIO_INT_EDGE_1	MSM_GPIO2_SHADOW_REG(0x50)
-#define MSM7X00_GPIO_INT_EDGE_2	MSM_GPIO1_SHADOW_REG(0x64)
-#define MSM7X00_GPIO_INT_EDGE_3	MSM_GPIO1_SHADOW_REG(0x68)
-#define MSM7X00_GPIO_INT_EDGE_4	MSM_GPIO1_SHADOW_REG(0x6C)
-#define MSM7X00_GPIO_INT_EDGE_5	MSM_GPIO1_SHADOW_REG(0xC0)
-
-/* same pin map as above, 1=positive 0=negative */
-#define MSM7X00_GPIO_INT_POS_0	MSM_GPIO1_SHADOW_REG(0x70)
-#define MSM7X00_GPIO_INT_POS_1	MSM_GPIO2_SHADOW_REG(0x58)
-#define MSM7X00_GPIO_INT_POS_2	MSM_GPIO1_SHADOW_REG(0x74)
-#define MSM7X00_GPIO_INT_POS_3	MSM_GPIO1_SHADOW_REG(0x78)
-#define MSM7X00_GPIO_INT_POS_4	MSM_GPIO1_SHADOW_REG(0x7C)
-#define MSM7X00_GPIO_INT_POS_5	MSM_GPIO1_SHADOW_REG(0xBC)
-
-/* same pin map as above, interrupt enable */
-#define MSM7X00_GPIO_INT_EN_0	MSM_GPIO1_SHADOW_REG(0x80)
-#define MSM7X00_GPIO_INT_EN_1	MSM_GPIO2_SHADOW_REG(0x60)
-#define MSM7X00_GPIO_INT_EN_2	MSM_GPIO1_SHADOW_REG(0x84)
-#define MSM7X00_GPIO_INT_EN_3	MSM_GPIO1_SHADOW_REG(0x88)
-#define MSM7X00_GPIO_INT_EN_4	MSM_GPIO1_SHADOW_REG(0x8C)
-#define MSM7X00_GPIO_INT_EN_5	MSM_GPIO1_SHADOW_REG(0xB8)
-
-/* same pin map as above, write 1 to clear interrupt */
-#define MSM7X00_GPIO_INT_CLEAR_0	MSM_GPIO1_SHADOW_REG(0x90)
-#define MSM7X00_GPIO_INT_CLEAR_1	MSM_GPIO2_SHADOW_REG(0x68)
-#define MSM7X00_GPIO_INT_CLEAR_2	MSM_GPIO1_SHADOW_REG(0x94)
-#define MSM7X00_GPIO_INT_CLEAR_3	MSM_GPIO1_SHADOW_REG(0x98)
-#define MSM7X00_GPIO_INT_CLEAR_4	MSM_GPIO1_SHADOW_REG(0x9C)
-#define MSM7X00_GPIO_INT_CLEAR_5	MSM_GPIO1_SHADOW_REG(0xB4)
-
-/* same pin map as above, 1=interrupt pending */
-#define MSM7X00_GPIO_INT_STATUS_0	MSM_GPIO1_SHADOW_REG(0xA0)
-#define MSM7X00_GPIO_INT_STATUS_1	MSM_GPIO2_SHADOW_REG(0x70)
-#define MSM7X00_GPIO_INT_STATUS_2	MSM_GPIO1_SHADOW_REG(0xA4)
-#define MSM7X00_GPIO_INT_STATUS_3	MSM_GPIO1_SHADOW_REG(0xA8)
-#define MSM7X00_GPIO_INT_STATUS_4	MSM_GPIO1_SHADOW_REG(0xAC)
-#define MSM7X00_GPIO_INT_STATUS_5	MSM_GPIO1_SHADOW_REG(0xB0)
-
-/*
- * QSD8X50 registers
- */
-/* output value */
-#define QSD8X50_GPIO_OUT_0	MSM_GPIO1_SHADOW_REG(0x00)  /* gpio  15-0   */
-#define QSD8X50_GPIO_OUT_1	MSM_GPIO2_SHADOW_REG(0x00)  /* gpio  42-16  */
-#define QSD8X50_GPIO_OUT_2	MSM_GPIO1_SHADOW_REG(0x04)  /* gpio  67-43  */
-#define QSD8X50_GPIO_OUT_3	MSM_GPIO1_SHADOW_REG(0x08)  /* gpio  94-68  */
-#define QSD8X50_GPIO_OUT_4	MSM_GPIO1_SHADOW_REG(0x0C)  /* gpio 103-95  */
-#define QSD8X50_GPIO_OUT_5	MSM_GPIO1_SHADOW_REG(0x10)  /* gpio 121-104 */
-#define QSD8X50_GPIO_OUT_6	MSM_GPIO1_SHADOW_REG(0x14)  /* gpio 152-122 */
-#define QSD8X50_GPIO_OUT_7	MSM_GPIO1_SHADOW_REG(0x18)  /* gpio 164-153 */
-
-/* same pin map as above, output enable */
-#define QSD8X50_GPIO_OE_0	MSM_GPIO1_SHADOW_REG(0x20)
-#define QSD8X50_GPIO_OE_1	MSM_GPIO2_SHADOW_REG(0x08)
-#define QSD8X50_GPIO_OE_2	MSM_GPIO1_SHADOW_REG(0x24)
-#define QSD8X50_GPIO_OE_3	MSM_GPIO1_SHADOW_REG(0x28)
-#define QSD8X50_GPIO_OE_4	MSM_GPIO1_SHADOW_REG(0x2C)
-#define QSD8X50_GPIO_OE_5	MSM_GPIO1_SHADOW_REG(0x30)
-#define QSD8X50_GPIO_OE_6	MSM_GPIO1_SHADOW_REG(0x34)
-#define QSD8X50_GPIO_OE_7	MSM_GPIO1_SHADOW_REG(0x38)
-
-/* same pin map as above, input read */
-#define QSD8X50_GPIO_IN_0	MSM_GPIO1_SHADOW_REG(0x50)
-#define QSD8X50_GPIO_IN_1	MSM_GPIO2_SHADOW_REG(0x20)
-#define QSD8X50_GPIO_IN_2	MSM_GPIO1_SHADOW_REG(0x54)
-#define QSD8X50_GPIO_IN_3	MSM_GPIO1_SHADOW_REG(0x58)
-#define QSD8X50_GPIO_IN_4	MSM_GPIO1_SHADOW_REG(0x5C)
-#define QSD8X50_GPIO_IN_5	MSM_GPIO1_SHADOW_REG(0x60)
-#define QSD8X50_GPIO_IN_6	MSM_GPIO1_SHADOW_REG(0x64)
-#define QSD8X50_GPIO_IN_7	MSM_GPIO1_SHADOW_REG(0x68)
-
-/* same pin map as above, 1=edge 0=level interrup */
-#define QSD8X50_GPIO_INT_EDGE_0	MSM_GPIO1_SHADOW_REG(0x70)
-#define QSD8X50_GPIO_INT_EDGE_1	MSM_GPIO2_SHADOW_REG(0x50)
-#define QSD8X50_GPIO_INT_EDGE_2	MSM_GPIO1_SHADOW_REG(0x74)
-#define QSD8X50_GPIO_INT_EDGE_3	MSM_GPIO1_SHADOW_REG(0x78)
-#define QSD8X50_GPIO_INT_EDGE_4	MSM_GPIO1_SHADOW_REG(0x7C)
-#define QSD8X50_GPIO_INT_EDGE_5	MSM_GPIO1_SHADOW_REG(0x80)
-#define QSD8X50_GPIO_INT_EDGE_6	MSM_GPIO1_SHADOW_REG(0x84)
-#define QSD8X50_GPIO_INT_EDGE_7	MSM_GPIO1_SHADOW_REG(0x88)
-
-/* same pin map as above, 1=positive 0=negative */
-#define QSD8X50_GPIO_INT_POS_0	MSM_GPIO1_SHADOW_REG(0x90)
-#define QSD8X50_GPIO_INT_POS_1	MSM_GPIO2_SHADOW_REG(0x58)
-#define QSD8X50_GPIO_INT_POS_2	MSM_GPIO1_SHADOW_REG(0x94)
-#define QSD8X50_GPIO_INT_POS_3	MSM_GPIO1_SHADOW_REG(0x98)
-#define QSD8X50_GPIO_INT_POS_4	MSM_GPIO1_SHADOW_REG(0x9C)
-#define QSD8X50_GPIO_INT_POS_5	MSM_GPIO1_SHADOW_REG(0xA0)
-#define QSD8X50_GPIO_INT_POS_6	MSM_GPIO1_SHADOW_REG(0xA4)
-#define QSD8X50_GPIO_INT_POS_7	MSM_GPIO1_SHADOW_REG(0xA8)
-
-/* same pin map as above, interrupt enable */
-#define QSD8X50_GPIO_INT_EN_0	MSM_GPIO1_SHADOW_REG(0xB0)
-#define QSD8X50_GPIO_INT_EN_1	MSM_GPIO2_SHADOW_REG(0x60)
-#define QSD8X50_GPIO_INT_EN_2	MSM_GPIO1_SHADOW_REG(0xB4)
-#define QSD8X50_GPIO_INT_EN_3	MSM_GPIO1_SHADOW_REG(0xB8)
-#define QSD8X50_GPIO_INT_EN_4	MSM_GPIO1_SHADOW_REG(0xBC)
-#define QSD8X50_GPIO_INT_EN_5	MSM_GPIO1_SHADOW_REG(0xC0)
-#define QSD8X50_GPIO_INT_EN_6	MSM_GPIO1_SHADOW_REG(0xC4)
-#define QSD8X50_GPIO_INT_EN_7	MSM_GPIO1_SHADOW_REG(0xC8)
-
-/* same pin map as above, write 1 to clear interrupt */
-#define QSD8X50_GPIO_INT_CLEAR_0	MSM_GPIO1_SHADOW_REG(0xD0)
-#define QSD8X50_GPIO_INT_CLEAR_1	MSM_GPIO2_SHADOW_REG(0x68)
-#define QSD8X50_GPIO_INT_CLEAR_2	MSM_GPIO1_SHADOW_REG(0xD4)
-#define QSD8X50_GPIO_INT_CLEAR_3	MSM_GPIO1_SHADOW_REG(0xD8)
-#define QSD8X50_GPIO_INT_CLEAR_4	MSM_GPIO1_SHADOW_REG(0xDC)
-#define QSD8X50_GPIO_INT_CLEAR_5	MSM_GPIO1_SHADOW_REG(0xE0)
-#define QSD8X50_GPIO_INT_CLEAR_6	MSM_GPIO1_SHADOW_REG(0xE4)
-#define QSD8X50_GPIO_INT_CLEAR_7	MSM_GPIO1_SHADOW_REG(0xE8)
-
-/* same pin map as above, 1=interrupt pending */
-#define QSD8X50_GPIO_INT_STATUS_0	MSM_GPIO1_SHADOW_REG(0xF0)
-#define QSD8X50_GPIO_INT_STATUS_1	MSM_GPIO2_SHADOW_REG(0x70)
-#define QSD8X50_GPIO_INT_STATUS_2	MSM_GPIO1_SHADOW_REG(0xF4)
-#define QSD8X50_GPIO_INT_STATUS_3	MSM_GPIO1_SHADOW_REG(0xF8)
-#define QSD8X50_GPIO_INT_STATUS_4	MSM_GPIO1_SHADOW_REG(0xFC)
-#define QSD8X50_GPIO_INT_STATUS_5	MSM_GPIO1_SHADOW_REG(0x100)
-#define QSD8X50_GPIO_INT_STATUS_6	MSM_GPIO1_SHADOW_REG(0x104)
-#define QSD8X50_GPIO_INT_STATUS_7	MSM_GPIO1_SHADOW_REG(0x108)
-
-/*
- * MSM7X30 registers
- */
-/* output value */
-#define MSM7X30_GPIO_OUT_0	MSM_GPIO1_REG(0x00)   /* gpio  15-0   */
-#define MSM7X30_GPIO_OUT_1	MSM_GPIO2_REG(0x00)   /* gpio  43-16  */
-#define MSM7X30_GPIO_OUT_2	MSM_GPIO1_REG(0x04)   /* gpio  67-44  */
-#define MSM7X30_GPIO_OUT_3	MSM_GPIO1_REG(0x08)   /* gpio  94-68  */
-#define MSM7X30_GPIO_OUT_4	MSM_GPIO1_REG(0x0C)   /* gpio 106-95  */
-#define MSM7X30_GPIO_OUT_5	MSM_GPIO1_REG(0x50)   /* gpio 133-107 */
-#define MSM7X30_GPIO_OUT_6	MSM_GPIO1_REG(0xC4)   /* gpio 150-134 */
-#define MSM7X30_GPIO_OUT_7	MSM_GPIO1_REG(0x214)  /* gpio 181-151 */
-
-/* same pin map as above, output enable */
-#define MSM7X30_GPIO_OE_0	MSM_GPIO1_REG(0x10)
-#define MSM7X30_GPIO_OE_1	MSM_GPIO2_REG(0x08)
-#define MSM7X30_GPIO_OE_2	MSM_GPIO1_REG(0x14)
-#define MSM7X30_GPIO_OE_3	MSM_GPIO1_REG(0x18)
-#define MSM7X30_GPIO_OE_4	MSM_GPIO1_REG(0x1C)
-#define MSM7X30_GPIO_OE_5	MSM_GPIO1_REG(0x54)
-#define MSM7X30_GPIO_OE_6	MSM_GPIO1_REG(0xC8)
-#define MSM7X30_GPIO_OE_7	MSM_GPIO1_REG(0x218)
-
-/* same pin map as above, input read */
-#define MSM7X30_GPIO_IN_0	MSM_GPIO1_REG(0x34)
-#define MSM7X30_GPIO_IN_1	MSM_GPIO2_REG(0x20)
-#define MSM7X30_GPIO_IN_2	MSM_GPIO1_REG(0x38)
-#define MSM7X30_GPIO_IN_3	MSM_GPIO1_REG(0x3C)
-#define MSM7X30_GPIO_IN_4	MSM_GPIO1_REG(0x40)
-#define MSM7X30_GPIO_IN_5	MSM_GPIO1_REG(0x44)
-#define MSM7X30_GPIO_IN_6	MSM_GPIO1_REG(0xCC)
-#define MSM7X30_GPIO_IN_7	MSM_GPIO1_REG(0x21C)
-
-/* same pin map as above, 1=edge 0=level interrup */
-#define MSM7X30_GPIO_INT_EDGE_0	MSM_GPIO1_REG(0x60)
-#define MSM7X30_GPIO_INT_EDGE_1	MSM_GPIO2_REG(0x50)
-#define MSM7X30_GPIO_INT_EDGE_2	MSM_GPIO1_REG(0x64)
-#define MSM7X30_GPIO_INT_EDGE_3	MSM_GPIO1_REG(0x68)
-#define MSM7X30_GPIO_INT_EDGE_4	MSM_GPIO1_REG(0x6C)
-#define MSM7X30_GPIO_INT_EDGE_5	MSM_GPIO1_REG(0xC0)
-#define MSM7X30_GPIO_INT_EDGE_6	MSM_GPIO1_REG(0xD0)
-#define MSM7X30_GPIO_INT_EDGE_7	MSM_GPIO1_REG(0x240)
-
-/* same pin map as above, 1=positive 0=negative */
-#define MSM7X30_GPIO_INT_POS_0	MSM_GPIO1_REG(0x70)
-#define MSM7X30_GPIO_INT_POS_1	MSM_GPIO2_REG(0x58)
-#define MSM7X30_GPIO_INT_POS_2	MSM_GPIO1_REG(0x74)
-#define MSM7X30_GPIO_INT_POS_3	MSM_GPIO1_REG(0x78)
-#define MSM7X30_GPIO_INT_POS_4	MSM_GPIO1_REG(0x7C)
-#define MSM7X30_GPIO_INT_POS_5	MSM_GPIO1_REG(0xBC)
-#define MSM7X30_GPIO_INT_POS_6	MSM_GPIO1_REG(0xD4)
-#define MSM7X30_GPIO_INT_POS_7	MSM_GPIO1_REG(0x228)
-
-/* same pin map as above, interrupt enable */
-#define MSM7X30_GPIO_INT_EN_0	MSM_GPIO1_REG(0x80)
-#define MSM7X30_GPIO_INT_EN_1	MSM_GPIO2_REG(0x60)
-#define MSM7X30_GPIO_INT_EN_2	MSM_GPIO1_REG(0x84)
-#define MSM7X30_GPIO_INT_EN_3	MSM_GPIO1_REG(0x88)
-#define MSM7X30_GPIO_INT_EN_4	MSM_GPIO1_REG(0x8C)
-#define MSM7X30_GPIO_INT_EN_5	MSM_GPIO1_REG(0xB8)
-#define MSM7X30_GPIO_INT_EN_6	MSM_GPIO1_REG(0xD8)
-#define MSM7X30_GPIO_INT_EN_7	MSM_GPIO1_REG(0x22C)
-
-/* same pin map as above, write 1 to clear interrupt */
-#define MSM7X30_GPIO_INT_CLEAR_0	MSM_GPIO1_REG(0x90)
-#define MSM7X30_GPIO_INT_CLEAR_1	MSM_GPIO2_REG(0x68)
-#define MSM7X30_GPIO_INT_CLEAR_2	MSM_GPIO1_REG(0x94)
-#define MSM7X30_GPIO_INT_CLEAR_3	MSM_GPIO1_REG(0x98)
-#define MSM7X30_GPIO_INT_CLEAR_4	MSM_GPIO1_REG(0x9C)
-#define MSM7X30_GPIO_INT_CLEAR_5	MSM_GPIO1_REG(0xB4)
-#define MSM7X30_GPIO_INT_CLEAR_6	MSM_GPIO1_REG(0xDC)
-#define MSM7X30_GPIO_INT_CLEAR_7	MSM_GPIO1_REG(0x230)
-
-/* same pin map as above, 1=interrupt pending */
-#define MSM7X30_GPIO_INT_STATUS_0	MSM_GPIO1_REG(0xA0)
-#define MSM7X30_GPIO_INT_STATUS_1	MSM_GPIO2_REG(0x70)
-#define MSM7X30_GPIO_INT_STATUS_2	MSM_GPIO1_REG(0xA4)
-#define MSM7X30_GPIO_INT_STATUS_3	MSM_GPIO1_REG(0xA8)
-#define MSM7X30_GPIO_INT_STATUS_4	MSM_GPIO1_REG(0xAC)
-#define MSM7X30_GPIO_INT_STATUS_5	MSM_GPIO1_REG(0xB0)
-#define MSM7X30_GPIO_INT_STATUS_6	MSM_GPIO1_REG(0xE0)
-#define MSM7X30_GPIO_INT_STATUS_7	MSM_GPIO1_REG(0x234)
-
-#endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

