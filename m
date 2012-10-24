Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935296Ab2JXRYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:24:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18006 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816Ab2JXRYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:24:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6875"; a="1499776"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCHv2] ARM: Push selects for TWD/SCU into machine entries
Date: Wed, 24 Oct 2012 10:24:35 -0700
Message-Id: <1351099475-29349-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TWD and SCU configs are selected by default as long as
MSM_SCORPIONMP is false and/or MCT is false. Implementing the
logic this way certainly saves lines in the Kconfig but it
precludes those machines which select MSM_SCORPIONMP or MCT from
participating in the single zImage effort because when those
machines are combined with other SMP capable machines the TWD and
SCU are no longer selected by default.

Push the select out to the machine entries so that we can compile
these machines together and still select the appropriate configs.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Pawel Moll <pawel.moll@arm.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Acked-by: Simon Horman <horms@verge.net.au>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tony Lindgren <tony@atomide.com>
Acked-by: Viresh Kumar <viresh.linux@gmail.com>
---

Changes since v1:
 * Dropped OMAP5 hunk
 * alphabetical order

 arch/arm/Kconfig               | 8 ++++++--
 arch/arm/mach-exynos/Kconfig   | 2 ++
 arch/arm/mach-highbank/Kconfig | 1 +
 arch/arm/mach-imx/Kconfig      | 3 ++-
 arch/arm/mach-msm/Kconfig      | 7 ++-----
 arch/arm/mach-omap2/Kconfig    | 2 ++
 arch/arm/mach-realview/Kconfig | 8 ++++++++
 arch/arm/mach-vexpress/Kconfig | 2 ++
 arch/arm/plat-spear/Kconfig    | 2 ++
 9 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index fe90e60..53112d0 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -633,6 +633,8 @@ config ARCH_TEGRA
 	select GENERIC_GPIO
 	select HAVE_CLK
 	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select MIGHT_HAVE_CACHE_L2X0
 	select SPARSE_IRQ
 	select USE_OF
@@ -677,6 +679,8 @@ config ARCH_SHMOBILE
 	bool "Renesas SH-Mobile / R-Mobile"
 	select CLKDEV_LOOKUP
 	select GENERIC_CLOCKEVENTS
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select HAVE_CLK
 	select HAVE_MACH_CLKDEV
 	select HAVE_SMP
@@ -875,6 +879,8 @@ config ARCH_U8500
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
 	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select MIGHT_HAVE_CACHE_L2X0
 	help
 	  Support for ST-Ericsson's Ux500 architecture
@@ -1490,7 +1496,6 @@ config SMP
 	depends on GENERIC_CLOCKEVENTS
 	depends on HAVE_SMP
 	depends on MMU
-	select HAVE_ARM_SCU if !ARCH_MSM_SCORPIONMP
 	select USE_GENERIC_SMP_HELPERS
 	help
 	  This enables support for systems with more than one CPU. If you have
@@ -1604,7 +1609,6 @@ config LOCAL_TIMERS
 	bool "Use local timer interrupts"
 	depends on SMP
 	default y
-	select HAVE_ARM_TWD if (!ARCH_MSM_SCORPIONMP && !EXYNOS4_MCT)
 	help
 	  Enable support for local timers on SMP platforms, rather then the
 	  legacy IPI broadcast method.  Local timers allows the system
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index da55107..a8176d4 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -14,6 +14,7 @@ menu "SAMSUNG EXYNOS SoCs Support"
 config ARCH_EXYNOS4
 	bool "SAMSUNG EXYNOS4"
 	default y
+	select HAVE_ARM_SCU if SMP
 	select HAVE_SMP
 	select MIGHT_HAVE_CACHE_L2X0
 	help
@@ -21,6 +22,7 @@ config ARCH_EXYNOS4
 
 config ARCH_EXYNOS5
 	bool "SAMSUNG EXYNOS5"
+	select HAVE_ARM_SCU if SMP
 	select HAVE_SMP
 	help
 	  Samsung EXYNOS5 (Cortex-A15) SoC based systems
diff --git a/arch/arm/mach-highbank/Kconfig b/arch/arm/mach-highbank/Kconfig
index 0e1d0a4..d87ac5b 100644
--- a/arch/arm/mach-highbank/Kconfig
+++ b/arch/arm/mach-highbank/Kconfig
@@ -10,6 +10,7 @@ config ARCH_HIGHBANK
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
 	select HAVE_ARM_SCU
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select HAVE_SMP
 	select SPARSE_IRQ
 	select USE_OF
diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 892631f..3887fe2 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -833,7 +833,8 @@ config SOC_IMX6Q
 	select ARM_GIC
 	select COMMON_CLK
 	select CPU_V7
-	select HAVE_ARM_SCU
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select HAVE_CAN_FLEXCAN if CAN
 	select HAVE_IMX_GPC
 	select HAVE_IMX_MMDC
diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index b619085..fceb093 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -44,10 +44,10 @@ endchoice
 
 config ARCH_MSM8X60
 	bool "MSM8X60"
-	select ARCH_MSM_SCORPIONMP
 	select ARM_GIC
 	select CPU_V7
 	select GPIO_MSM_V2
+	select HAVE_SMP
 	select MSM_GPIOMUX
 	select MSM_SCM if SMP
 	select MSM_V2_TLMM
@@ -55,9 +55,9 @@ config ARCH_MSM8X60
 
 config ARCH_MSM8960
 	bool "MSM8960"
-	select ARCH_MSM_SCORPIONMP
 	select ARM_GIC
 	select CPU_V7
+	select HAVE_SMP
 	select MSM_GPIOMUX
 	select MSM_SCM if SMP
 	select MSM_V2_TLMM
@@ -68,9 +68,6 @@ config MSM_HAS_DEBUG_UART_HS
 
 config MSM_SOC_REV_A
 	bool
-config  ARCH_MSM_SCORPIONMP
-	bool
-	select HAVE_SMP
 
 config  ARCH_MSM_ARM11
 	bool
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 2a1a898..3221a20 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -62,6 +62,8 @@ config ARCH_OMAP4
 	select CACHE_L2X0
 	select CPU_V7
 	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select LOCAL_TIMERS if SMP
 	select OMAP_INTERCONNECT
 	select PL310_ERRATA_588369
diff --git a/arch/arm/mach-realview/Kconfig b/arch/arm/mach-realview/Kconfig
index 14c1d47..d210c0f9 100644
--- a/arch/arm/mach-realview/Kconfig
+++ b/arch/arm/mach-realview/Kconfig
@@ -12,6 +12,8 @@ config REALVIEW_EB_A9MP
 	bool "Support Multicore Cortex-A9 Tile"
 	depends on MACH_REALVIEW_EB
 	select CPU_V7
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select HAVE_SMP
 	select MIGHT_HAVE_CACHE_L2X0
 	help
@@ -23,6 +25,8 @@ config REALVIEW_EB_ARM11MP
 	depends on MACH_REALVIEW_EB
 	select ARCH_HAS_BARRIERS if SMP
 	select CPU_V6K
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select HAVE_SMP
 	select MIGHT_HAVE_CACHE_L2X0
 	help
@@ -43,6 +47,8 @@ config MACH_REALVIEW_PB11MP
 	select ARCH_HAS_BARRIERS if SMP
 	select ARM_GIC
 	select CPU_V6K
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select HAVE_PATA_PLATFORM
 	select HAVE_SMP
 	select MIGHT_HAVE_CACHE_L2X0
@@ -85,6 +91,8 @@ config MACH_REALVIEW_PBX
 	bool "Support RealView(R) Platform Baseboard Explore"
 	select ARCH_SPARSEMEM_ENABLE if CPU_V7 && !REALVIEW_HIGH_PHYS_OFFSET
 	select ARM_GIC
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select HAVE_PATA_PLATFORM
 	select HAVE_SMP
 	select MIGHT_HAVE_CACHE_L2X0
diff --git a/arch/arm/mach-vexpress/Kconfig b/arch/arm/mach-vexpress/Kconfig
index c952960..96b1101 100644
--- a/arch/arm/mach-vexpress/Kconfig
+++ b/arch/arm/mach-vexpress/Kconfig
@@ -8,6 +8,8 @@ config ARCH_VEXPRESS
 	select COMMON_CLK
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select HAVE_CLK
 	select HAVE_PATA_PLATFORM
 	select HAVE_SMP
diff --git a/arch/arm/plat-spear/Kconfig b/arch/arm/plat-spear/Kconfig
index f8db7b2..a53936e 100644
--- a/arch/arm/plat-spear/Kconfig
+++ b/arch/arm/plat-spear/Kconfig
@@ -12,6 +12,8 @@ config ARCH_SPEAR13XX
 	bool "ST SPEAr13xx with Device Tree"
 	select ARM_GIC
 	select CPU_V7
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select HAVE_SMP
 	select MIGHT_HAVE_CACHE_L2X0
 	select PINCTRL
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

