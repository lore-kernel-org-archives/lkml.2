Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1IVN1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:27:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41615 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab1IVN1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:27:03 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <aneesh@ti.com>, <khilman@ti.com>,
        <santosh.shilimkar@ti.com>, <christian.gmeiner@gmail.com>,
        Abhilash K V <abhilash.kv@ti.com>, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH v4 2/3] omap_twl: Prevent SR to enable for am3517/am3505 devices
Date: Thu, 22 Sep 2011 18:56:32 +0530
Message-ID: <1316697993-696-3-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1316697993-696-2-git-send-email-abhilash.kv@ti.com>
References: <1316697993-696-1-git-send-email-abhilash.kv@ti.com>
 <1316697993-696-2-git-send-email-abhilash.kv@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index d34fc52..da71abc 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -252,7 +252,8 @@ postcore_initcall(omap2_common_pm_init);
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

