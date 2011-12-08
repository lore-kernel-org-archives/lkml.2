Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1LHMry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:47:54 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12530 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab1LHMrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:47:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 08 Dec 2011 04:47:32 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Russell King <linux@arm.linux.org.uk>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>, Gary King <gking@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v6 09/10] arm/tegra: implement support for tegra30
Date: Thu, 8 Dec 2011 14:43:52 +0200
Message-ID: <1323348254-29072-10-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1323348254-29072-1-git-send-email-pdeschrijver@nvidia.com>
References: <1323348254-29072-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for tegra30 SoC. This includes a device tree compatible type for
this SoC ("nvidia,tegra30") and adds L2 cache initialization for this new SoC.
The clock framework is still missing, which prevents most drivers from working.
The basic IRQs are the same, so remove the dependency on
CONFIG_ARCH_TEGRA_2x_SOC.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/Kconfig             |   18 +++++++++++++-----
 arch/arm/mach-tegra/board-dt.c          |   17 +++++++++++++++++
 arch/arm/mach-tegra/board.h             |    1 +
 arch/arm/mach-tegra/common.c            |    6 ++++++
 arch/arm/mach-tegra/include/mach/irqs.h |    2 --
 5 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 2b1d49b..aad54ca 100644
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
+	  Support for NVIDIA Tegra T30 processor family, based on the
+	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller
 
 config TEGRA_PCI
 	bool "PCI Express support"
diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
index ef9843c..d1ed473 100644
--- a/arch/arm/mach-tegra/board-dt.c
+++ b/arch/arm/mach-tegra/board-dt.c
@@ -154,3 +154,20 @@ DT_MACHINE_START(TEGRA_DT, "nVidia Tegra20 (Flattened Device Tree)")
 	.dt_compat	= tegra20_dt_board_compat,
 MACHINE_END
 #endif
+
+#ifdef CONFIG_ARCH_TEGRA_3x_SOC
+static const char *tegra30_dt_board_compat[] = {
+	NULL
+};
+
+DT_MACHINE_START(TEGRA30_DT, "nVidia Tegra30 (Flattened Device Tree)")
+	.map_io		= tegra_map_common_io,
+	.init_early	= tegra30_init_early,
+	.init_irq	= tegra_dt_init_irq,
+	.handle_irq	= gic_handle_irq,
+	.timer		= &tegra_timer,
+	.init_machine	= tegra_dt_init,
+	.restart	= tegra_assert_system_reset,
+	.dt_compat	= tegra30_dt_board_compat,
+MACHINE_END
+#endif
diff --git a/arch/arm/mach-tegra/board.h b/arch/arm/mach-tegra/board.h
index c268cfa..cfe1de1 100644
--- a/arch/arm/mach-tegra/board.h
+++ b/arch/arm/mach-tegra/board.h
@@ -26,6 +26,7 @@
 void tegra_assert_system_reset(char mode, const char *cmd);
 
 void __init tegra20_init_early(void);
+void __init tegra30_init_early(void);
 void __init tegra_map_common_io(void);
 void __init tegra_init_irq(void);
 void __init tegra_init_clock(void);
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 5b711ad..31c99f3 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -87,3 +87,9 @@ void __init tegra20_init_early(void)
 	tegra_init_cache(0x331, 0x441);
 }
 #endif
+#ifdef CONFIG_ARCH_TEGRA_3x_SOC
+void __init tegra30_init_early(void)
+{
+	tegra_init_cache(0x441, 0x551);
+}
+#endif
diff --git a/arch/arm/mach-tegra/include/mach/irqs.h b/arch/arm/mach-tegra/include/mach/irqs.h
index 73265af..a2146cd 100644
--- a/arch/arm/mach-tegra/include/mach/irqs.h
+++ b/arch/arm/mach-tegra/include/mach/irqs.h
@@ -25,7 +25,6 @@
 
 #define IRQ_LOCALTIMER                  29
 
-#ifdef CONFIG_ARCH_TEGRA_2x_SOC
 /* Primary Interrupt Controller */
 #define INT_PRI_BASE			(INT_GIC_BASE + 32)
 #define INT_TMR1			(INT_PRI_BASE + 0)
@@ -178,6 +177,5 @@
 #define NR_BOARD_IRQS			32
 
 #define NR_IRQS				(INT_BOARD_BASE + NR_BOARD_IRQS)
-#endif
 
 #endif
-- 
1.7.7.rc0.72.g4b5ea.dirty

