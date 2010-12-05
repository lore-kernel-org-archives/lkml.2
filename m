Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab0LEXKN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 18:10:13 -0500
Received: from smtp-out.google.com ([216.239.44.51]:37654 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab0LEXKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 18:10:08 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Colin Cross <ccross@google.com>,
        Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 20/21] ARM: tegra: Allow overriding arch_reset
Date: Sun,  5 Dec 2010 15:09:07 -0800
Message-Id: <1291590548-7341-21-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1291590548-7341-1-git-send-email-ccross@android.com>
References: <1291590548-7341-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@google.com>

Signed-off-by: Colin Cross <ccross@google.com>
---
 arch/arm/mach-tegra/common.c              |    3 +++
 arch/arm/mach-tegra/include/mach/system.h |   18 ++++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 64ea415..c8e9bdb 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -26,12 +26,15 @@
 
 #include <mach/iomap.h>
 #include <mach/dma.h>
+#include <mach/system.h>
 
 #include "board.h"
 #include "clock.h"
 #include "fuse.h"
 #include "power.h"
 
+void (*tegra_reset)(char mode, const char *cmd);
+
 static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
 	/* name		parent		rate		enabled */
 	{ "clk_m",	NULL,		0,		true },
diff --git a/arch/arm/mach-tegra/include/mach/system.h b/arch/arm/mach-tegra/include/mach/system.h
index 84d5d46..70c95ac 100644
--- a/arch/arm/mach-tegra/include/mach/system.h
+++ b/arch/arm/mach-tegra/include/mach/system.h
@@ -24,16 +24,30 @@
 #include <mach/hardware.h>
 #include <mach/iomap.h>
 
+extern void (*tegra_reset)(char mode, const char *cmd);
+
 static inline void arch_idle(void)
 {
 }
 
-static inline void arch_reset(char mode, const char *cmd)
+static inline void tegra_assert_system_reset(void)
 {
 	void __iomem *reset = IO_ADDRESS(TEGRA_CLK_RESET_BASE + 0x04);
-	u32 reg = readl(reset);
+	u32 reg;
+
+	reg = readl(reset);
 	reg |= 0x04;
 	writel(reg, reset);
 }
 
+static inline void arch_reset(char mode, const char *cmd)
+{
+	if (tegra_reset)
+		tegra_reset(mode, cmd);
+	else
+		tegra_assert_system_reset();
+
+	do { } while (1);
+}
+
 #endif
-- 
1.7.3.1

