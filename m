Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab0JAMAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:00:03 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:54761 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932451Ab0JAL75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:59:57 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Shiraz Hashim <shiraz.hashim@st.com>, vipin.kumar@st.com,
        deepak.sikri@st.com, armando.visconti@st.com, vipulkumar.samar@st.com,
        rajeev-dlh.kumar@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 49/69] ST SPEAr13xx: add L2 cache support
Date: Fri,  1 Oct 2010 17:26:09 +0530
Message-Id: <cfeb5d8653735f68acee9dfed7d91e4e2441d329.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shiraz Hashim <shiraz.hashim@st.com>

Signed-off-by: shiraz hashim <shiraz.hashim@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/mach-spear13xx/spear13xx.c |   19 +++++++++++++++++++
 arch/arm/mm/Kconfig                 |    2 +-
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-spear13xx/spear13xx.c b/arch/arm/mach-spear13xx/spear13xx.c
index c86bd1c..8c8a21d 100644
--- a/arch/arm/mach-spear13xx/spear13xx.c
+++ b/arch/arm/mach-spear13xx/spear13xx.c
@@ -22,6 +22,7 @@
 #include <asm/irq.h>
 #include <asm/localtimer.h>
 #include <asm/mach/arch.h>
+#include <asm/hardware/cache-l2x0.h>
 #include <asm/smp_twd.h>
 #include <mach/irqs.h>
 #include <mach/generic.h>
@@ -526,6 +527,17 @@ struct platform_device spear13xx_pcie_gadget2_device = {
 /* Do spear13xx familiy common initialization part here */
 void __init spear13xx_init(void)
 {
+#ifdef CONFIG_CACHE_L2X0
+	/*
+	 * 512KB (64KB/way), 8-way associativity, parity supported
+	 *
+	 * TODO: 0x249, picked from nomadik, to be analyzed
+	 * Comment from nomadik:
+	 * At full speed latency must be >=2, so 0x249 in low bits
+	 */
+	l2x0_init(__io_address(SPEAR13XX_L2CC_BASE), 0x00260249, 0xfe00ffff);
+#endif
+
 	sdhci_enable();
 }
 
@@ -548,6 +560,13 @@ struct map_desc spear13xx_io_desc[] __initdata = {
 		.pfn		= __phys_to_pfn(SPEAR13XX_A9SM_PERIP_BASE),
 		.length		= SZ_8K,
 		.type		= MT_DEVICE
+#ifdef CONFIG_CACHE_L2X0
+	}, {
+		.virtual	= IO_ADDRESS(SPEAR13XX_L2CC_BASE),
+		.pfn		= __phys_to_pfn(SPEAR13XX_L2CC_BASE),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE
+#endif
 	}, {
 		.virtual	= IO_ADDRESS(SPEAR13XX_MISC_BASE),
 		.pfn		= __phys_to_pfn(SPEAR13XX_MISC_BASE),
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index a0a2928..f3eea13 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -772,7 +772,7 @@ config CACHE_L2X0
 	depends on REALVIEW_EB_ARM11MP || MACH_REALVIEW_PB11MP || MACH_REALVIEW_PB1176 || \
 		   REALVIEW_EB_A9MP || ARCH_MX35 || ARCH_MX31 || MACH_REALVIEW_PBX || \
 		   ARCH_NOMADIK || ARCH_OMAP4 || ARCH_S5PV310 || ARCH_TEGRA || \
-		   ARCH_U8500 || ARCH_VEXPRESS_CA9X4
+		   ARCH_SPEAR13XX || ARCH_U8500 || ARCH_VEXPRESS_CA9X4
 	default y
 	select OUTER_CACHE
 	select OUTER_CACHE_SYNC
-- 
1.7.2.2

