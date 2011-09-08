Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab1IHMFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:05:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54014 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932556Ab1IHMFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:05:12 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <khilman@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Abhilash K V <abhilash.kv@ti.com>, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH v3 2/2] omap_twl: Prevent SR to enable for am3517/am3505 devices
Date: Thu, 8 Sep 2011 17:34:56 +0530
Message-ID: <1315483496-17547-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of AM3517 & AM3505, SmartReflex is not applicable so
we must not enable it. So omap3_twl_init() is now not called
when the processor does not support SR.
This is as per discussion at 
http://marc.info/?l=linux-omap&m=131417482924928&w=2

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/mach-omap2/id.c              |    2 +-
 arch/arm/mach-omap2/pm.c              |    3 ++-
 arch/arm/plat-omap/include/plat/cpu.h |    2 ++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 37efb86..da71098 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -202,7 +202,7 @@ static void __init omap3_check_features(void)
 	if (cpu_is_omap3630())
 		omap_features |= OMAP3_HAS_192MHZ_CLK;
 	if (!cpu_is_omap3505() && !cpu_is_omap3517())
-		omap_features |= OMAP3_HAS_IO_WAKEUP;
+		omap_features |= (OMAP3_HAS_IO_WAKEUP | OMAP3_HAS_SR);
 
 	omap_features |= OMAP3_HAS_SDRC;
 
diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index 3feb359..8929798 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -254,7 +254,8 @@ postcore_initcall(omap2_common_pm_init);
 static int __init omap2_common_pm_late_init(void)
 {
 	/* Init the OMAP TWL parameters */
-	omap3_twl_init();
+	if (omap3_has_sr())
+		omap3_twl_init();
 	omap4_twl_init();
 
 	/* Init the voltage layer */
diff --git a/arch/arm/plat-omap/include/plat/cpu.h b/arch/arm/plat-omap/include/plat/cpu.h
index 67b3d75..294e015 100644
--- a/arch/arm/plat-omap/include/plat/cpu.h
+++ b/arch/arm/plat-omap/include/plat/cpu.h
@@ -491,6 +491,7 @@ extern u32 omap_features;
 #define OMAP4_HAS_MPU_1GHZ		BIT(8)
 #define OMAP4_HAS_MPU_1_2GHZ		BIT(9)
 #define OMAP4_HAS_MPU_1_5GHZ		BIT(10)
+#define OMAP3_HAS_SR			BIT(11)
 
 
 #define OMAP3_HAS_FEATURE(feat,flag)			\
@@ -507,6 +508,7 @@ OMAP3_HAS_FEATURE(isp, ISP)
 OMAP3_HAS_FEATURE(192mhz_clk, 192MHZ_CLK)
 OMAP3_HAS_FEATURE(io_wakeup, IO_WAKEUP)
 OMAP3_HAS_FEATURE(sdrc, SDRC)
+OMAP3_HAS_FEATURE(sr, SR)
 
 /*
  * Runtime detection of OMAP4 features
-- 
1.7.1

