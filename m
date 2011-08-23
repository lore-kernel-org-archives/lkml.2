Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1HWNVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:21:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35198 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898Ab1HWNV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:21:29 -0400
From: Abhilash K V <abhilash.kv@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <paul@pwsan.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Vaibhav Hiremath <hvaibhav@ti.com>,
        Abhilash K V <abhilash.kv@ti.com>
Subject: [PATCH v2 2/2] omap_twl: Prevent SR to enable for am3517/am3505 devices
Date: Tue, 23 Aug 2011 18:51:20 +0530
Message-ID: <1314105680-17426-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: git-send-email 1.6.2.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Hiremath <hvaibhav@ti.com>

In case of AM3517 & AM3505, Smart Reflex is not applicable so
we must not enable it. So add check for absence of SR feature
in omap3_twl_init() and return -ENODEV if absence, else continue.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
---
 arch/arm/mach-omap2/id.c              |    2 +-
 arch/arm/mach-omap2/omap_twl.c        |    8 ++++++++
 arch/arm/plat-omap/include/plat/cpu.h |    2 ++
 3 files changed, 11 insertions(+), 1 deletions(-)

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
 
diff --git a/arch/arm/mach-omap2/omap_twl.c b/arch/arm/mach-omap2/omap_twl.c
index 07d6140..47e27b5 100644
--- a/arch/arm/mach-omap2/omap_twl.c
+++ b/arch/arm/mach-omap2/omap_twl.c
@@ -269,6 +269,14 @@ int __init omap3_twl_init(void)
 	if (!cpu_is_omap34xx())
 		return -ENODEV;
 
+	/*
+	 * In case of AM3517/AM3505 we should not be going down
+	 * further, since SR is not applicable there.
+	 */
+	if (!omap3_has_sr()) {
+		return -ENODEV;
+	}
+
 	if (cpu_is_omap3630()) {
 		omap3_mpu_volt_info.vp_vddmin = OMAP3630_VP1_VLIMITTO_VDDMIN;
 		omap3_mpu_volt_info.vp_vddmax = OMAP3630_VP1_VLIMITTO_VDDMAX;
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

