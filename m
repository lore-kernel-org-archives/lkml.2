Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030242Ab2JDIvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:51:05 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14161 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965535Ab2JDIvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:51:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6854"; a="243279459"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Simon Horman <horms@verge.net.au>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tony Lindgren <tony@atomide.com>,
        Viresh Kumar <viresh.linux@gmail.com>
Subject: [PATCH] ARM: Push selects for TWD/SCU into machine entries
Date: Thu,  4 Oct 2012 01:50:44 -0700
Message-Id: <1349340644-13937-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TWD and SCU configs are selected by default as long as
SCORPIONMP is false and/or MCT is false. Implementing the logic
this way certainly saves lines in the Kconfig but it precludes
those machines which select SCORPIONMP or MCT from participating
in the single zImage effort because when those machines are
combined with other SMP capable machines the TWD and SCU are no
longer selected.

Push the select out to the machine entries so that we can compile
these machines together and still select the appropriate configs.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>
---

Does OMAP5 need to select TWD? I suspect not if it uses the
architected timers.

 arch/arm/Kconfig               | 8 ++++++--
 arch/arm/mach-exynos/Kconfig   | 2 ++
 arch/arm/mach-highbank/Kconfig | 1 +
 arch/arm/mach-imx/Kconfig      | 2 ++
 arch/arm/mach-msm/Kconfig      | 7 ++-----
 arch/arm/mach-omap2/Kconfig    | 4 ++++
 arch/arm/mach-realview/Kconfig | 8 ++++++++
 arch/arm/mach-vexpress/Kconfig | 2 ++
 arch/arm/plat-spear/Kconfig    | 2 ++
 9 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e85f2b6..303ce90 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -639,6 +639,8 @@ config ARCH_TEGRA
 	select GENERIC_GPIO
 	select HAVE_CLK
 	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select MIGHT_HAVE_CACHE_L2X0
 	select ARCH_HAS_CPUFREQ
 	select USE_OF
@@ -686,6 +688,8 @@ config ARCH_SHMOBILE
 	select CLKDEV_LOOKUP
 	select HAVE_MACH_CLKDEV
 	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select GENERIC_CLOCKEVENTS
 	select MIGHT_HAVE_CACHE_L2X0
 	select NO_IOPORT
@@ -882,6 +886,8 @@ config ARCH_U8500
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_HAS_CPUFREQ
 	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select MIGHT_HAVE_CACHE_L2X0
 	help
 	  Support for ST-Ericsson's Ux500 architecture
@@ -1507,7 +1513,6 @@ config SMP
 	depends on HAVE_SMP
 	depends on MMU
 	select USE_GENERIC_SMP_HELPERS
-	select HAVE_ARM_SCU if !ARCH_MSM_SCORPIONMP
 	help
 	  This enables support for systems with more than one CPU. If you have
 	  a system with only one CPU, like most personal computers, say N. If
@@ -1620,7 +1625,6 @@ config LOCAL_TIMERS
 	bool "Use local timer interrupts"
 	depends on SMP
 	default y
-	select HAVE_ARM_TWD if (!ARCH_MSM_SCORPIONMP && !EXYNOS4_MCT)
 	help
 	  Enable support for local timers on SMP platforms, rather then the
 	  legacy IPI broadcast method.  Local timers allows the system
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 4372075..8f97e92 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -15,6 +15,7 @@ config ARCH_EXYNOS4
 	bool "SAMSUNG EXYNOS4"
 	default y
 	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
 	select MIGHT_HAVE_CACHE_L2X0
 	help
 	  Samsung EXYNOS4 SoCs based systems
@@ -22,6 +23,7 @@ config ARCH_EXYNOS4
 config ARCH_EXYNOS5
 	bool "SAMSUNG EXYNOS5"
 	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
 	help
 	  Samsung EXYNOS5 (Cortex-A15) SoC based systems
 
diff --git a/arch/arm/mach-highbank/Kconfig b/arch/arm/mach-highbank/Kconfig
index 0e1d0a4..f1ad1f0 100644
--- a/arch/arm/mach-highbank/Kconfig
+++ b/arch/arm/mach-highbank/Kconfig
@@ -11,5 +11,6 @@ config ARCH_HIGHBANK
 	select GENERIC_CLOCKEVENTS
 	select HAVE_ARM_SCU
 	select HAVE_SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select SPARSE_IRQ
 	select USE_OF
diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 519ed57..13f765c 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -759,6 +759,8 @@ config SOC_IMX6Q
 	select HAVE_IMX_MMDC
 	select HAVE_IMX_SRC
 	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select MFD_SYSCON
 	select PINCTRL
 	select PINCTRL_IMX6Q
diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 7902de15..5bff882 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -44,7 +44,7 @@ endchoice
 
 config ARCH_MSM8X60
 	bool "MSM8X60"
-	select ARCH_MSM_SCORPIONMP
+	select HAVE_SMP
 	select ARM_GIC
 	select CPU_V7
 	select MSM_V2_TLMM
@@ -55,7 +55,7 @@ config ARCH_MSM8X60
 
 config ARCH_MSM8960
 	bool "MSM8960"
-	select ARCH_MSM_SCORPIONMP
+	select HAVE_SMP
 	select ARM_GIC
 	select CPU_V7
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
index a6219ea..b618748 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -58,7 +58,9 @@ config ARCH_OMAP4
 	select CPU_V7
 	select ARM_GIC
 	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
 	select LOCAL_TIMERS if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select PL310_ERRATA_588369
 	select PL310_ERRATA_727915
 	select ARM_ERRATA_720789
@@ -75,6 +77,8 @@ config SOC_OMAP5
 	select CPU_V7
 	select ARM_GIC
 	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select ARM_CPU_SUSPEND if PM
 	select SOC_HAS_REALTIME_COUNTER
 	select ARM_ARCH_TIMER
diff --git a/arch/arm/mach-realview/Kconfig b/arch/arm/mach-realview/Kconfig
index c593be4..0c019b7 100644
--- a/arch/arm/mach-realview/Kconfig
+++ b/arch/arm/mach-realview/Kconfig
@@ -13,6 +13,8 @@ config REALVIEW_EB_A9MP
 	depends on MACH_REALVIEW_EB
 	select CPU_V7
 	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select MIGHT_HAVE_CACHE_L2X0
 	help
 	  Enable support for the Cortex-A9MPCore tile fitted to the
@@ -24,6 +26,8 @@ config REALVIEW_EB_ARM11MP
 	select CPU_V6K
 	select ARCH_HAS_BARRIERS if SMP
 	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select MIGHT_HAVE_CACHE_L2X0
 	help
 	  Enable support for the ARM11MPCore tile fitted to the Realview(R)
@@ -44,6 +48,8 @@ config MACH_REALVIEW_PB11MP
 	select ARM_GIC
 	select HAVE_PATA_PLATFORM
 	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select MIGHT_HAVE_CACHE_L2X0
 	select ARCH_HAS_BARRIERS if SMP
 	help
@@ -86,6 +92,8 @@ config MACH_REALVIEW_PBX
 	select ARM_GIC
 	select HAVE_PATA_PLATFORM
 	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select MIGHT_HAVE_CACHE_L2X0
 	select ARCH_SPARSEMEM_ENABLE if CPU_V7 && !REALVIEW_HIGH_PHYS_OFFSET
 	select ZONE_DMA if SPARSEMEM
diff --git a/arch/arm/mach-vexpress/Kconfig b/arch/arm/mach-vexpress/Kconfig
index c952960..4f8e0db 100644
--- a/arch/arm/mach-vexpress/Kconfig
+++ b/arch/arm/mach-vexpress/Kconfig
@@ -11,6 +11,8 @@ config ARCH_VEXPRESS
 	select HAVE_CLK
 	select HAVE_PATA_PLATFORM
 	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select ICST
 	select MIGHT_HAVE_CACHE_L2X0
 	select NO_IOPORT
diff --git a/arch/arm/plat-spear/Kconfig b/arch/arm/plat-spear/Kconfig
index 4404f82..a090ea3 100644
--- a/arch/arm/plat-spear/Kconfig
+++ b/arch/arm/plat-spear/Kconfig
@@ -14,6 +14,8 @@ config ARCH_SPEAR13XX
 	select CPU_V7
 	select USE_OF
 	select HAVE_SMP
+	select HAVE_ARM_SCU if SMP
+	select HAVE_ARM_TWD if LOCAL_TIMERS
 	select MIGHT_HAVE_CACHE_L2X0
 	select PINCTRL
 	help
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

