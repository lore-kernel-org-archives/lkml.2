Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab1HODHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 23:07:54 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:33245 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab1HODHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 23:07:40 -0400
X-ASG-Debug-ID: 1313377659-082e211d0001-xx1T2L
X-Barracuda-Envelope-From: leoy@marvell.com
From: Leo Yan <leoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <hzhuang1@marvell.com>
Cc: Leo Yan <leoy@marvell.com>
X-ASG-Orig-Subj: [PATCH 3/3] ARM: mmp: register internal sram bank
Subject: [PATCH 3/3] ARM: mmp: register internal sram bank
Date: Mon, 15 Aug 2011 11:09:54 +0800
X-ASG-Orig-Subj: [PATCH 3/3] ARM: mmp: register internal sram bank
Message-Id: <1313377794-26721-4-git-send-email-leoy@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313377794-26721-1-git-send-email-leoy@marvell.com>
References: <1313377794-26721-1-git-send-email-leoy@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1313377659
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MMP2 have the internal sram, this sram can be allocated
for video, power management and secure processor.

Now the sram usage is:
0xd1000000 ~ 0xd101ffff (128KB) : reserved for secure processor
0xd1020000 ~ 0xd1037fff (96KB)  : for video and PM

Register the internal sram's second half 96KB buffer,
so that video and PM can dynamically alloc/free from it.

Signed-off-by: Leo Yan <leoy@marvell.com>
---
 arch/arm/mach-mmp/brownstone.c        |    6 ++++++
 arch/arm/mach-mmp/include/mach/mmp2.h |    6 ++++++
 arch/arm/mach-mmp/mmp2.c              |    2 ++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mmp/brownstone.c b/arch/arm/mach-mmp/brownstone.c
index db4b5fd..59dcf9d 100644
--- a/arch/arm/mach-mmp/brownstone.c
+++ b/arch/arm/mach-mmp/brownstone.c
@@ -191,6 +191,11 @@ static struct sram_platdata mmp2_asram_platdata = {
 	.granularity	= SRAM_GRANULARITY,
 };
 
+static struct sram_platdata mmp2_isram_platdata = {
+	.pool_name	= "isram",
+	.granularity	= SRAM_GRANULARITY,
+};
+
 static void __init brownstone_init(void)
 {
 	mfp_config(ARRAY_AND_SIZE(brownstone_pin_config));
@@ -202,6 +207,7 @@ static void __init brownstone_init(void)
 	mmp2_add_sdhost(0, &mmp2_sdh_platdata_mmc0); /* SD/MMC */
 	mmp2_add_sdhost(2, &mmp2_sdh_platdata_mmc2); /* eMMC */
 	mmp2_add_asram(&mmp2_asram_platdata);
+	mmp2_add_isram(&mmp2_isram_platdata);
 
 	/* enable 5v regulator */
 	platform_device_register(&brownstone_v_5vp_device);
diff --git a/arch/arm/mach-mmp/include/mach/mmp2.h b/arch/arm/mach-mmp/include/mach/mmp2.h
index c227328..2f7b2d3 100644
--- a/arch/arm/mach-mmp/include/mach/mmp2.h
+++ b/arch/arm/mach-mmp/include/mach/mmp2.h
@@ -30,6 +30,7 @@ extern struct pxa_device_desc mmp2_device_sdh1;
 extern struct pxa_device_desc mmp2_device_sdh2;
 extern struct pxa_device_desc mmp2_device_sdh3;
 extern struct pxa_device_desc mmp2_device_asram;
+extern struct pxa_device_desc mmp2_device_isram;
 
 static inline int mmp2_add_uart(int id)
 {
@@ -92,5 +93,10 @@ static inline int mmp2_add_asram(struct sram_platdata *data)
 	return pxa_register_device(&mmp2_device_asram, data, sizeof(*data));
 }
 
+static inline int mmp2_add_isram(struct sram_platdata *data)
+{
+	return pxa_register_device(&mmp2_device_isram, data, sizeof(*data));
+}
+
 #endif /* __ASM_MACH_MMP2_H */
 
diff --git a/arch/arm/mach-mmp/mmp2.c b/arch/arm/mach-mmp/mmp2.c
index 9d00754..43266c4 100644
--- a/arch/arm/mach-mmp/mmp2.c
+++ b/arch/arm/mach-mmp/mmp2.c
@@ -227,4 +227,6 @@ MMP2_DEVICE(sdh1, "sdhci-pxav3", 1, MMC2, 0xd4280800, 0x120);
 MMP2_DEVICE(sdh2, "sdhci-pxav3", 2, MMC3, 0xd4281000, 0x120);
 MMP2_DEVICE(sdh3, "sdhci-pxav3", 3, MMC4, 0xd4281800, 0x120);
 MMP2_DEVICE(asram, "asram", -1, NONE, 0xe0000000, 0x4000);
+/* 0xd1000000 ~ 0xd101ffff is reserved for secure processor */
+MMP2_DEVICE(isram, "isram", -1, NONE, 0xd1020000, 0x18000);
 
-- 
1.7.4.1

