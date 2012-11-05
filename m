Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab2KEKZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:25:25 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49373 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab2KEKZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:25:24 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <linux_omap@vger.kernel.org>
CC: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: OMAP4: ID: Improve features detection and check
Date: Mon, 5 Nov 2012 12:16:57 +0200
Message-ID: <1352110617-3571-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaces several flags bearing the same meaning. There is no need
to set flags due to different omap types here, it can be checked
in appropriate places as well.

Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Nishanth Menon <nm@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 arch/arm/mach-omap2/id.c  |   25 +++++++------------------
 arch/arm/mach-omap2/soc.h |    8 ++------
 2 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index cf2362c..3c47a19 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -28,6 +28,9 @@
 #include "soc.h"
 #include "control.h"
 
+#define OMAP4_SILICON_TYPE_STANDARD		0x01
+#define OMAP4_SILICON_TYPE_PERFORMANCE		0x02
+
 static unsigned int omap_revision;
 static const char *cpu_rev;
 u32 omap_features;
@@ -273,25 +276,11 @@ void __init omap4xxx_check_features(void)
 {
 	u32 si_type;
 
-	if (cpu_is_omap443x())
-		omap_features |= OMAP4_HAS_MPU_1GHZ;
-
+	si_type =
+	(read_tap_reg(OMAP4_CTRL_MODULE_CORE_STD_FUSE_PROD_ID_1) >> 16) & 0x03;
 
-	if (cpu_is_omap446x()) {
-		si_type =
-			read_tap_reg(OMAP4_CTRL_MODULE_CORE_STD_FUSE_PROD_ID_1);
-		switch ((si_type & (3 << 16)) >> 16) {
-		case 2:
-			/* High performance device */
-			omap_features |= OMAP4_HAS_MPU_1_5GHZ;
-			break;
-		case 1:
-		default:
-			/* Standard device */
-			omap_features |= OMAP4_HAS_MPU_1_2GHZ;
-			break;
-		}
-	}
+	if (si_type == OMAP4_SILICON_TYPE_PERFORMANCE)
+		omap_features = OMAP4_HAS_PERF_SILICON;
 }
 
 void __init ti81xx_check_features(void)
diff --git a/arch/arm/mach-omap2/soc.h b/arch/arm/mach-omap2/soc.h
index 0700964..f31d907 100644
--- a/arch/arm/mach-omap2/soc.h
+++ b/arch/arm/mach-omap2/soc.h
@@ -435,9 +435,7 @@ extern u32 omap_features;
 #define OMAP3_HAS_IO_WAKEUP		BIT(6)
 #define OMAP3_HAS_SDRC			BIT(7)
 #define OMAP3_HAS_IO_CHAIN_CTRL		BIT(8)
-#define OMAP4_HAS_MPU_1GHZ		BIT(9)
-#define OMAP4_HAS_MPU_1_2GHZ		BIT(10)
-#define OMAP4_HAS_MPU_1_5GHZ		BIT(11)
+#define OMAP4_HAS_PERF_SILICON		BIT(9)
 
 
 #define OMAP3_HAS_FEATURE(feat,flag)			\
@@ -465,9 +463,7 @@ static inline unsigned int omap4_has_ ##feat(void)	\
 	return omap_features & OMAP4_HAS_ ##flag;	\
 }							\
 
-OMAP4_HAS_FEATURE(mpu_1ghz, MPU_1GHZ)
-OMAP4_HAS_FEATURE(mpu_1_2ghz, MPU_1_2GHZ)
-OMAP4_HAS_FEATURE(mpu_1_5ghz, MPU_1_5GHZ)
+OMAP4_HAS_FEATURE(perf_silicon, PERF_SILICON)
 
 #endif	/* __ASSEMBLY__ */
 
-- 
1.7.9.5

