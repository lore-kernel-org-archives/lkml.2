Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab1CGSfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 13:35:40 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46557 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab1CGSfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 13:35:39 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6278"; a="78490983"
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: davidb@codeaurora.org, bryanh@codeaurora.org, linux@arm.linux.org.uk,
        dwalker@fifo99.com
Cc: dima@android.com, Rohit Vaswani <rvaswani@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCHv2 1/3] msm: Remove arch-specific gpiomux tables
Date: Mon,  7 Mar 2011 10:35:22 -0800
Message-Id: <1299522922-31294-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove arch-specific gpiomux files and include the gpiomux configs
as a part of the board file.

Change-Id: I83de33c6d5f9e8e91832d8173d31a96cf11ce592
Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
v2: Re-send

 arch/arm/mach-msm/Makefile        |    4 +-
 arch/arm/mach-msm/board-msm8x60.c |    3 ++
 arch/arm/mach-msm/board-qsd8x50.c |   12 ++++++++
 arch/arm/mach-msm/gpiomux-8x50.c  |   51 -------------------------------------
 arch/arm/mach-msm/gpiomux-8x60.c  |   19 -------------
 5 files changed, 17 insertions(+), 72 deletions(-)
 delete mode 100644 arch/arm/mach-msm/gpiomux-8x50.c
 delete mode 100644 arch/arm/mach-msm/gpiomux-8x60.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index ea8c74f..b6c6ec8 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -30,8 +30,8 @@ obj-$(CONFIG_ARCH_MSM8X60) += board-msm8x60.o
 obj-$(CONFIG_ARCH_MSM8960) += board-msm8960.o devices-msm8960.o
 
 obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-v1.o gpiomux.o
-obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-v1.o gpiomux.o
-obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-8x60.o gpiomux-v2.o gpiomux.o
+obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-v1.o gpiomux.o
+obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-v2.o gpiomux.o
 ifdef CONFIG_MSM_V2_TLMM
 ifndef CONFIG_ARCH_MSM8960
 # TODO: TLMM Mapping issues need to be resolved
diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index b3c55f1..6c0b868 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -27,6 +27,9 @@
 
 #include <mach/board.h>
 #include <mach/msm_iomap.h>
+#include "gpiomux.h"
+
+struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {};
 
 
 static void __init msm8x60_map_io(void)
diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index b464d48..b63b7c4 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -36,9 +36,21 @@
 #include <mach/mmc.h>
 
 #include "devices.h"
+#include "gpiomux.h"
 
 extern struct sys_timer msm_timer;
 
+struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {
+	[86] = { /* UART3 RX */
+		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
+			     GPIOMUX_FUNC_1 | GPIOMUX_VALID,
+	},
+	[87] = { /* UART3 TX */
+		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
+			     GPIOMUX_FUNC_1 | GPIOMUX_VALID,
+	},
+};
+
 static const resource_size_t qsd8x50_surf_smc91x_base __initdata = 0x70000300;
 static const unsigned        qsd8x50_surf_smc91x_gpio __initdata = 156;
 
diff --git a/arch/arm/mach-msm/gpiomux-8x50.c b/arch/arm/mach-msm/gpiomux-8x50.c
deleted file mode 100644
index f7a4ea5..0000000
--- a/arch/arm/mach-msm/gpiomux-8x50.c
+++ /dev/null
@@ -1,51 +0,0 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- */
-#include "gpiomux.h"
-
-#if defined(CONFIG_MMC_MSM) || defined(CONFIG_MMC_MSM_MODULE)
-	#define SDCC_DAT_0_3_CMD_ACTV_CFG (GPIOMUX_VALID | GPIOMUX_PULL_UP\
-					| GPIOMUX_FUNC_1 | GPIOMUX_DRV_8MA)
-	#define SDCC_CLK_ACTV_CFG (GPIOMUX_VALID | GPIOMUX_PULL_NONE\
-					| GPIOMUX_FUNC_1 | GPIOMUX_DRV_8MA)
-#else
-	#define SDCC_DAT_0_3_CMD_ACTV_CFG 0
-	#define SDCC_CLK_ACTV_CFG 0
-#endif
-
-#define SDC1_SUSPEND_CONFIG (GPIOMUX_VALID | GPIOMUX_PULL_DOWN\
-				| GPIOMUX_FUNC_GPIO | GPIOMUX_DRV_2MA)
-
-struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {
-	[86] = { /* UART3 RX */
-		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
-			     GPIOMUX_FUNC_1 | GPIOMUX_VALID,
-	},
-	[87] = { /* UART3 TX */
-		.suspended = GPIOMUX_DRV_2MA | GPIOMUX_PULL_DOWN |
-			     GPIOMUX_FUNC_1 | GPIOMUX_VALID,
-	},
-	/* SDC1 data[3:0] & CMD */
-	[51 ... 55] = {
-		.active = SDCC_DAT_0_3_CMD_ACTV_CFG,
-		.suspended = SDC1_SUSPEND_CONFIG
-	},
-	/* SDC1 CLK */
-	[56] = {
-		.active = SDCC_CLK_ACTV_CFG,
-		.suspended = SDC1_SUSPEND_CONFIG
-	},
-};
diff --git a/arch/arm/mach-msm/gpiomux-8x60.c b/arch/arm/mach-msm/gpiomux-8x60.c
deleted file mode 100644
index 7b380b3..0000000
--- a/arch/arm/mach-msm/gpiomux-8x60.c
+++ /dev/null
@@ -1,19 +0,0 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- */
-#include "gpiomux.h"
-
-struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {};
-- 
Sent by an employee of the Qualcomm Innovation Center,Inc
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

