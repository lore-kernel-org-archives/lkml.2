Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760372Ab2ILQ7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:59:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40251 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab2ILQ7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233521463"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 17/24] ARM: msm: Move io mapping prototypes to common.h
Date: Wed, 12 Sep 2012 09:58:53 -0700
Message-Id: <1347469140-25069-18-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Consolidate the handful of iomapping functions into common.h so
that board files don't need to include mach/msm_iomap.h if they
don't need static virtual mapping addresses.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/board-dt-8660.c               |  1 -
 arch/arm/mach-msm/common.h                      | 10 ++++++++++
 arch/arm/mach-msm/include/mach/board.h          |  1 -
 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h |  7 -------
 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h |  4 ----
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h |  4 ----
 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h |  4 ----
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |  4 ----
 arch/arm/mach-msm/io.c                          |  2 ++
 9 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/arch/arm/mach-msm/board-dt-8660.c b/arch/arm/mach-msm/board-dt-8660.c
index 0d32464..f77f57f 100644
--- a/arch/arm/mach-msm/board-dt-8660.c
+++ b/arch/arm/mach-msm/board-dt-8660.c
@@ -19,7 +19,6 @@
 #include <asm/hardware/gic.h>
 
 #include <mach/board.h>
-#include <mach/msm_iomap.h>
 #include "common.h"
 
 static const struct of_device_id msm_dt_gic_match[] __initconst = {
diff --git a/arch/arm/mach-msm/common.h b/arch/arm/mach-msm/common.h
index a20e78e..9975575 100644
--- a/arch/arm/mach-msm/common.h
+++ b/arch/arm/mach-msm/common.h
@@ -18,4 +18,14 @@ extern struct sys_timer msm8960_timer;
 extern struct sys_timer msm_dt_timer;
 extern struct sys_timer qsd8x50_timer;
 
+extern void msm_map_common_io(void);
+extern void msm_map_msm7x30_io(void);
+extern void msm_map_msm8x60_io(void);
+extern void msm_map_msm8960_io(void);
+extern void msm_map_qsd8x50_io(void);
+
+extern void __iomem *__msm_ioremap_caller(unsigned long phys_addr, size_t size,
+					  unsigned int mtype, void *caller);
+
+
 #endif
diff --git a/arch/arm/mach-msm/include/mach/board.h b/arch/arm/mach-msm/include/mach/board.h
index fc40bbc..09654ac 100644
--- a/arch/arm/mach-msm/include/mach/board.h
+++ b/arch/arm/mach-msm/include/mach/board.h
@@ -36,7 +36,6 @@ struct clk_lookup;
 /* common init routines for use by arch/arm/mach-msm/board-*.c */
 
 void __init msm_add_devices(void);
-void __init msm_map_common_io(void);
 void __init msm_init_irq(void);
 void __init msm_init_gpio(void);
 void __init msm_clock_init(struct clk_lookup *clock_tbl, unsigned num_clocks);
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
index 6c4046c..67dc0e9 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
@@ -105,11 +105,4 @@
 #define MSM_AD5_PHYS          0xAC000000
 #define MSM_AD5_SIZE          (SZ_1M*13)
 
-#ifndef __ASSEMBLY__
-
-extern void __iomem *__msm_ioremap_caller(unsigned long phys_addr, size_t size,
-					  unsigned int mtype, void *caller);
-
-#endif
-
 #endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
index f944fe6..198202c 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
@@ -100,8 +100,4 @@
 #define MSM_HSUSB_PHYS        0xA3600000
 #define MSM_HSUSB_SIZE        SZ_1K
 
-#ifndef __ASSEMBLY__
-extern void msm_map_msm7x30_io(void);
-#endif
-
 #endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
index facf434..9819a55 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
@@ -50,8 +50,4 @@
 #define MSM_DEBUG_UART_PHYS	0x16440000
 #endif
 
-#ifndef __ASSEMBLY__
-extern void msm_map_msm8960_io(void);
-#endif
-
 #endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
index da77cc1..0faa894 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
@@ -122,8 +122,4 @@
 #define MSM_SDC4_PHYS          0xA0600000
 #define MSM_SDC4_SIZE          SZ_4K
 
-#ifndef __ASSEMBLY__
-extern void msm_map_qsd8x50_io(void);
-#endif
-
 #endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index 21a2a88..c6d38f1 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -67,8 +67,4 @@
 #define MSM_DEBUG_UART_PHYS	0x19C40000
 #endif
 
-#ifndef __ASSEMBLY__
-extern void msm_map_msm8x60_io(void);
-#endif
-
 #endif
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index af43f6a..d908a37 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -29,6 +29,8 @@
 
 #include <mach/board.h>
 
+#include "common.h"
+
 #define MSM_CHIP_DEVICE_TYPE(name, chip, mem_type) {			      \
 		.virtual = (unsigned long) MSM_##name##_BASE, \
 		.pfn = __phys_to_pfn(chip##_##name##_PHYS), \
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

