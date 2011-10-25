Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab1JYQzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 12:55:55 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9266 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1JYQyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 12:54:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 25 Oct 2011 09:54:30 -0700
From: <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH 4/6] arm/tegra: implement support for tegra30
Date: Tue, 25 Oct 2011 19:53:58 +0300
Message-ID: <1319561644-6160-5-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1319561644-6160-1-git-send-email-pdeschrijver@nvidia.com>
References: <1319561644-6160-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter De Schrijver <pdeschrijver@nvidia.com>

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/Kconfig    |   18 +++++++++++++-----
 arch/arm/mach-tegra/board-dt.c |    1 +
 arch/arm/mach-tegra/board.h    |    1 +
 arch/arm/mach-tegra/common.c   |   12 +++++++++---
 4 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 91aff7c..21c99f9 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -2,11 +2,8 @@ if ARCH_TEGRA
 
 comment "NVIDIA Tegra options"
 
-choice
-	prompt "Select Tegra processor family for target system"
-
 config ARCH_TEGRA_2x_SOC
-	bool "Tegra 2 family"
+	bool "Enable support for Tegra20 family"
 	select CPU_V7
 	select ARM_GIC
 	select ARCH_REQUIRE_GPIOLIB
@@ -17,7 +14,18 @@ config ARCH_TEGRA_2x_SOC
 	  Support for NVIDIA Tegra AP20 and T20 processors, based on the
 	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller
 
-endchoice
+config ARCH_TEGRA_3x_SOC
+	bool "Enable support for Tegra30 family"
+	select CPU_V7
+	select ARM_GIC
+	select ARCH_REQUIRE_GPIOLIB
+	select USB_ARCH_HAS_EHCI if USB_SUPPORT
+	select USB_ULPI if USB_SUPPORT
+	select USB_ULPI_VIEWPORT if USB_SUPPORT
+	select USE_OF
+	help
+	  Support for NVIDIA Tegra T30 processorfamily, based on the
+	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller
 
 config TEGRA_PCI
 	bool "PCI Express support"
diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
index 9130037..01dc31a 100644
--- a/arch/arm/mach-tegra/board-dt.c
+++ b/arch/arm/mach-tegra/board-dt.c
@@ -124,6 +124,7 @@ static struct {
 	void (*init)(void);
 } early_init[] __initdata = {
 	{ "nvidia,tegra20", tegra20_init_early },
+	{ "nvidia,tegra30", tegra30_init_early },
 };
 
 static void __init tegra_init_early(void)
diff --git a/arch/arm/mach-tegra/board.h b/arch/arm/mach-tegra/board.h
index b86cdab..708b330a 100644
--- a/arch/arm/mach-tegra/board.h
+++ b/arch/arm/mach-tegra/board.h
@@ -24,6 +24,7 @@
 #include <linux/types.h>
 
 void __init tegra20_init_early(void);
+void __init tegra30_init_early(void);
 void __init tegra_map_common_io(void);
 void __init tegra_init_irq(void);
 void __init tegra_init_clock(void);
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 8553fde..d0ed0b1 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -61,7 +61,7 @@ static __initdata struct tegra_clk_init_table tegra20_clk_init_table[] = {
 	{ NULL,		NULL,		0,		0},
 };
 
-static void __init tegra_init_cache(void)
+static void __init tegra_init_cache(u32 prefetch_ctrl)
 {
 #ifdef CONFIG_CACHE_L2X0
 	void __iomem *p = IO_ADDRESS(TEGRA_ARM_PERIF_BASE) + 0x3000;
@@ -69,7 +69,7 @@ static void __init tegra_init_cache(void)
 
 	writel_relaxed(0x331, p + L2X0_TAG_LATENCY_CTRL);
 	writel_relaxed(0x441, p + L2X0_DATA_LATENCY_CTRL);
-	writel(2, p + L2X0_PREFETCH_CTRL);
+	writel(prefetch_ctrl, p + L2X0_PREFETCH_CTRL);
 
 	aux_ctrl = readl(p + L2X0_CACHE_TYPE);
 	aux_ctrl = (aux_ctrl & 0x700) << (17-8);
@@ -85,5 +85,11 @@ void __init tegra20_init_early(void)
 	tegra_init_fuse();
 	tegra_init_clock();
 	tegra_clk_init_from_table(tegra20_clk_init_table);
-	tegra_init_cache();
+	tegra_init_cache(2);
+}
+
+void __init tegra30_init_early(void)
+{
+	/* Enable PL310 double line fill feature. */
+	tegra_init_cache(1<<30);
 }
-- 
1.7.7.rc0.72.g4b5ea.dirty

