Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab1I3GND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 02:13:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:32863 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974Ab1I3GNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 02:13:00 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <aneesh@ti.com>, <khilman@ti.com>,
        <santosh.shilimkar@ti.com>, <christian.gmeiner@gmail.com>,
        Abhilash K V <abhilash.kv@ti.com>, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH v5 2/3] omap_twl: Prevent SR to enable for am3517/am3505 devices
Date: Fri, 30 Sep 2011 11:42:32 +0530
Message-ID: <1317363153-10259-3-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1317363153-10259-2-git-send-email-abhilash.kv@ti.com>
References: <1317363153-10259-1-git-send-email-abhilash.kv@ti.com>
 <1317363153-10259-2-git-send-email-abhilash.kv@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhilash K V <abhilash.kv@ti.com>

In case of AM3517 & AM3505, SmartReflex is not applicable so
we must not enable it. So omap3_twl_init() is now not called
when the processor does not support SR.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/mach-omap2/id.c              |    2 +-
 arch/arm/mach-omap2/pm.c              |    3 ++-
 arch/arm/plat-omap/include/plat/cpu.h |    2 ++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index d27daf9..b7e3082 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -188,7 +188,7 @@ static void __init omap3_check_features(void)
 	if (cpu_is_omap3630())
 		omap_features |= OMAP3_HAS_192MHZ_CLK;
 	if (!cpu_is_omap3505() && !cpu_is_omap3517())
-		omap_features |= OMAP3_HAS_IO_WAKEUP;
+		omap_features |= (OMAP3_HAS_IO_WAKEUP | OMAP3_HAS_SR);
 
 	omap_features |= OMAP3_HAS_SDRC;
 
diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index 0844e2e..6835198 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -250,7 +250,8 @@ postcore_initcall(omap2_common_pm_init);
 static int __init omap2_common_pm_late_init(void)
 {
 	/* Init the OMAP TWL parameters */
-	omap3_twl_init();
+	if (omap3_has_sr())
+		omap3_twl_init();
 	omap4_twl_init();
 
 	/* Init the voltage layer */
diff --git a/arch/arm/plat-omap/include/plat/cpu.h b/arch/arm/plat-omap/include/plat/cpu.h
index 2f90269..cc6fcd3 100644
--- a/arch/arm/plat-omap/include/plat/cpu.h
+++ b/arch/arm/plat-omap/include/plat/cpu.h
@@ -413,6 +413,7 @@ extern u32 omap_features;
 #define OMAP4_HAS_MPU_1GHZ		BIT(8)
 #define OMAP4_HAS_MPU_1_2GHZ		BIT(9)
 #define OMAP4_HAS_MPU_1_5GHZ		BIT(10)
+#define OMAP3_HAS_SR			BIT(11)
 
 
 #define OMAP3_HAS_FEATURE(feat,flag)			\
@@ -429,6 +430,7 @@ OMAP3_HAS_FEATURE(isp, ISP)
 OMAP3_HAS_FEATURE(192mhz_clk, 192MHZ_CLK)
 OMAP3_HAS_FEATURE(io_wakeup, IO_WAKEUP)
 OMAP3_HAS_FEATURE(sdrc, SDRC)
+OMAP3_HAS_FEATURE(sr, SR)
 
 /*
  * Runtime detection of OMAP4 features
-- 
1.7.1

