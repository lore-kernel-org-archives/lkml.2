Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2L0XVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 18:21:42 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:63662 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab2L0XVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 18:21:12 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 1/4] arm: vt8500: Add support for Wondermedia WM8750/WM8850
Date: Fri, 28 Dec 2012 12:20:49 +1300
Message-Id: <1356650452-16559-2-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356650452-16559-1-git-send-email-linux@prisktech.co.nz>
References: <1356650452-16559-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the WM8750 (ARMv6) and WM8850 (ARMv7).

Common features across all SoCs are split into ARCH_VT8500 and
unique features are specified by each SoC option.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 Documentation/devicetree/bindings/arm/vt8500.txt |    8 ++++++
 arch/arm/Kconfig                                 |   17 +++++++----
 arch/arm/mach-vt8500/Kconfig                     |   33 ++++++++++++++++++++--
 arch/arm/mach-vt8500/vt8500.c                    |    2 ++
 4 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/vt8500.txt b/Documentation/devicetree/bindings/arm/vt8500.txt
index d657832..87dc1dd 100644
--- a/Documentation/devicetree/bindings/arm/vt8500.txt
+++ b/Documentation/devicetree/bindings/arm/vt8500.txt
@@ -12,3 +12,11 @@ compatible = "wm,wm8505";
 Boards with the Wondermedia WM8650 SoC shall have the following properties:
 Required root node property:
 compatible = "wm,wm8650";
+
+Boards with the Wondermedia WM8750 SoC shall have the following properties:
+Required root node property:
+compatible = "wm,wm8750";
+
+Boards with the Wondermedia WM8850 SoC shall have the following properties:
+Required root node property:
+compatible = "wm,wm8850";
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index f95ba14..fbb9492 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -952,20 +952,25 @@ config ARCH_OMAP
 
 config ARCH_VT8500_SINGLE
 	bool "VIA/WonderMedia 85xx"
-	select ARCH_HAS_CPUFREQ
-	select ARCH_REQUIRE_GPIOLIB
-	select CLKDEV_LOOKUP
+	select ARCH_VT8500
 	select COMMON_CLK
 	select CPU_ARM926T
-	select GENERIC_CLOCKEVENTS
-	select GENERIC_GPIO
-	select HAVE_CLK
 	select MULTI_IRQ_HANDLER
 	select SPARSE_IRQ
 	select USE_OF
 	help
 	  Support for VIA/WonderMedia VT8500/WM85xx System-on-Chip.
 
+config ARCH_WM8750_SINGLE
+	bool "WonderMedia WM8750/WM8850"
+	select ARCH_VT8500
+	select COMMON_CLK
+	select MULTI_IRQ_HANDLER
+	select SPARSE_IRQ
+	select USE_OF
+	help
+	  Support for WonderMedia WM8750/WM8850 System-on-Chip.
+
 endchoice
 
 menu "Multiple platform selection"
diff --git a/arch/arm/mach-vt8500/Kconfig b/arch/arm/mach-vt8500/Kconfig
index 2ed0b7d..d67c7fa 100644
--- a/arch/arm/mach-vt8500/Kconfig
+++ b/arch/arm/mach-vt8500/Kconfig
@@ -1,12 +1,39 @@
 config ARCH_VT8500
-	bool "VIA/WonderMedia 85xx" if ARCH_MULTI_V5
-	default ARCH_VT8500_SINGLE
+	bool
 	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
 	select CLKDEV_LOOKUP
-	select CPU_ARM926T
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select HAVE_CLK
+
+config ARCH_WM8505
+	bool "VIA/WonderMedia 85xx" if !ARCH_VT8500_SINGLE
+	depends on ARCH_MULTI_V5
+	default ARCH_VT8500_SINGLE
+	select ARCH_VT8500
+	select CPU_ARM926T
 	help
 	  Support for VIA/WonderMedia VT8500/WM85xx System-on-Chip.
+
+config ARCH_WM8750
+	bool "WonderMedia WM8750"
+	depends on ARCH_MULTI_V6 || ARCH_WM8750_SINGLE
+	select ARCH_VT8500
+	select CPU_V6
+	help
+	  Support for WonderMedia WM8750 System-on-Chip.
+
+config ARCH_WM8850
+	bool "WonderMedia WM8850"
+	depends on ARCH_MULTI_V7 || ARCH_WM8750_SINGLE
+	select ARCH_VT8500
+	select CPU_V7
+	help
+	  Support for WonderMedia WM8850 System-on-Chip.
+
+# ensure that ARCH_WM8850 is on if ARCH_WM8750 is off
+config ARCH_WM8850_AUTO
+      def_bool y
+      depends on ARCH_WM8750_SINGLE && !ARCH_WM8750
+      select ARCH_WM8850
diff --git a/arch/arm/mach-vt8500/vt8500.c b/arch/arm/mach-vt8500/vt8500.c
index 3c66d48..55162ab 100644
--- a/arch/arm/mach-vt8500/vt8500.c
+++ b/arch/arm/mach-vt8500/vt8500.c
@@ -183,6 +183,8 @@ static const char * const vt8500_dt_compat[] = {
 	"via,vt8500",
 	"wm,wm8650",
 	"wm,wm8505",
+	"wm,wm8750",
+	"wm,wm8850",
 };
 
 DT_MACHINE_START(WMT_DT, "VIA/Wondermedia SoC (Device Tree Support)")
-- 
1.7.9.5

