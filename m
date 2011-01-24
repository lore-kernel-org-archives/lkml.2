Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1AXCCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 21:02:17 -0500
Received: from smtp-out.google.com ([216.239.44.51]:42948 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab1AXCCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 21:02:01 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 21/28] ARM: tegra: Allow overriding arch_reset
Date: Sun, 23 Jan 2011 18:01:26 -0800
Message-Id: <1295834493-5019-22-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1295834493-5019-1-git-send-email-ccross@android.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
v2: Move definition of tegra_assert_system_reset out of static
    inline

 arch/arm/mach-tegra/board.h               |    2 ++
 arch/arm/mach-tegra/common.c              |   13 +++++++++++++
 arch/arm/mach-tegra/include/mach/system.h |   10 ++--------
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-tegra/board.h b/arch/arm/mach-tegra/board.h
index ae5c333..15d561b 100644
--- a/arch/arm/mach-tegra/board.h
+++ b/arch/arm/mach-tegra/board.h
@@ -23,6 +23,8 @@
 
 #include <linux/types.h>
 
+void tegra_assert_system_reset(char mode, const char *cmd);
+
 void __init tegra_common_init(void);
 void __init tegra_map_common_io(void);
 void __init tegra_init_irq(void);
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 53ddf55..1b32495 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -27,6 +27,7 @@
 
 #include <mach/iomap.h>
 #include <mach/dma.h>
+#include <mach/system.h>
 
 #include "board.h"
 #include "clock.h"
@@ -36,6 +37,18 @@
 unsigned long tegra_lp0_vec_start;
 unsigned long tegra_lp0_vec_size;
 
+void (*arch_reset)(char mode, const char *cmd) = tegra_assert_system_reset;
+
+void tegra_assert_system_reset(char mode, const char *cmd)
+{
+	void __iomem *reset = IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x04);
+	u32 reg;
+
+	reg = readl(reset);
+	reg |= 0x04;
+	writel(reg, reset);
+}
+
 static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
 	/* name		parent		rate		enabled */
 	{ "clk_m",	NULL,		0,		true },
diff --git a/arch/arm/mach-tegra/include/mach/system.h b/arch/arm/mach-tegra/include/mach/system.h
index 84d5d46..d0183d8 100644
--- a/arch/arm/mach-tegra/include/mach/system.h
+++ b/arch/arm/mach-tegra/include/mach/system.h
@@ -24,16 +24,10 @@
 #include <mach/hardware.h>
 #include <mach/iomap.h>
 
-static inline void arch_idle(void)
-{
-}
+extern void (*arch_reset)(char mode, const char *cmd);
 
-static inline void arch_reset(char mode, const char *cmd)
+static inline void arch_idle(void)
 {
-	void __iomem *reset = IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x04);
-	u32 reg = readl(reset);
-	reg |= 0x04;
-	writel(reg, reset);
 }
 
 #endif
-- 
1.7.3.1

