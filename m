Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0HYE6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 00:58:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59678 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab0HYE6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 00:58:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6084"; a="52012239"
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="72366135"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: [PATCH 05/24] msm: io: MSM8X60 io support
Date: Tue, 24 Aug 2010 21:57:34 -0700
Message-Id: <1282712273-344-6-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Muckle <smuckle@codeaurora.org>

MSM8X60 has different IO mappings than previous MSMs.

Signed-off-by: Steve Muckle <smuckle@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/io.h             |    1 +
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |   21 +++++++++++++++++++++
 arch/arm/mach-msm/io.c                          |   15 +++++++++++++++
 3 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/io.h b/arch/arm/mach-msm/include/mach/io.h
index c35b29f..7386e73 100644
--- a/arch/arm/mach-msm/include/mach/io.h
+++ b/arch/arm/mach-msm/include/mach/io.h
@@ -28,6 +28,7 @@ void __iomem *__msm_ioremap(unsigned long phys_addr, size_t size, unsigned int m
 
 void msm_map_qsd8x50_io(void);
 void msm_map_msm7x30_io(void);
+void msm_map_msm8x60_io(void);
 
 extern unsigned int msm_shared_ram_phys;
 
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index 17209f7..ee58da5 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -35,8 +35,29 @@
  *
  */
 
+
+#define MSM_QGIC_DIST_BASE	IOMEM(0xF0000000)
+#define MSM_QGIC_DIST_PHYS	0x02080000
+#define MSM_QGIC_DIST_SIZE	SZ_4K
+
+#define MSM_QGIC_CPU_BASE	IOMEM(0xF0001000)
+#define MSM_QGIC_CPU_PHYS	0x02081000
+#define MSM_QGIC_CPU_SIZE	SZ_4K
+
+#define MSM_ACC_BASE		IOMEM(0xF0002000)
+#define MSM_ACC_PHYS		0x02001000
+#define MSM_ACC_SIZE		SZ_4K
+
+#define MSM_GCC_BASE		IOMEM(0xF0003000)
+#define MSM_GCC_PHYS		0x02082000
+#define MSM_GCC_SIZE		SZ_4K
+
 #define MSM_TLMM_BASE		IOMEM(0xF0004000)
 #define MSM_TLMM_PHYS		0x00800000
 #define MSM_TLMM_SIZE		SZ_16K
 
+#define MSM_SHARED_RAM_BASE	IOMEM(0xF0100000)
+#define MSM_SHARED_RAM_SIZE	SZ_1M
+
+
 #endif
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 1c05060..d36b610 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -100,6 +100,21 @@ void __init msm_map_qsd8x50_io(void)
 }
 #endif /* CONFIG_ARCH_QSD8X50 */
 
+#ifdef CONFIG_ARCH_MSM8X60
+static struct map_desc msm8x60_io_desc[] __initdata = {
+	MSM_DEVICE(QGIC_DIST),
+	MSM_DEVICE(QGIC_CPU),
+	MSM_DEVICE(TMR),
+	MSM_DEVICE(ACC),
+	MSM_DEVICE(GCC),
+};
+
+void __init msm_map_msm8x60_io(void)
+{
+	iotable_init(msm8x60_io_desc, ARRAY_SIZE(msm8x60_io_desc));
+}
+#endif /* CONFIG_ARCH_MSM8X60 */
+
 #ifdef CONFIG_ARCH_MSM7X30
 static struct map_desc msm7x30_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
