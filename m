Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964790Ab2B1Ha7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:30:59 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:41427 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932267Ab2B1H2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:28:36 -0500
From: zhaoy <zhaoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk, hzhuang1@marvell.com,
        cxie4@marvell.com, leoy@marvell.com
Cc: zhaoy <zhaoy@marvell.com>
Subject: [PATCH 06/13] mmp3:register dma devices for mmp3 platform
Date: Tue, 28 Feb 2012 15:27:38 +0800
Message-Id: <1330414065-2949-7-git-send-email-zhaoy@marvell.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <Y>
References: <Y>
X-OriginalArrivalTime: 28 Feb 2012 07:28:19.0735 (UTC) FILETIME=[8B6ED270:01CCF5EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	1.register dma device for mmp3 platform

Change-Id: I93675ca4df66c17e08d6d64e3352d5bccf8afa9c
Signed-off-by: zhaoy <zhaoy@marvell.com>
---
 arch/arm/mach-mmp/mmp3.c |   78 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-mmp/mmp3.c b/arch/arm/mach-mmp/mmp3.c
index 8ae7d1f..a98c611 100644
--- a/arch/arm/mach-mmp/mmp3.c
+++ b/arch/arm/mach-mmp/mmp3.c
@@ -249,6 +249,80 @@ struct platform_device mmp3_device_asoc_hdmi = {
 	.id		= -1,
 };
 
+static struct resource mmp3_adma_resource[] = {
+	[0] = {
+		.name   = "reg_phys",
+		.start  = 0xc0ffd800,
+		.end    = 0xc0ffd800 + SZ_512 - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.name   = "adma_irq",
+		.start  = IRQ_MMP3_DMA_SECONDARY(18),
+		.end    = IRQ_MMP3_DMA_SECONDARY(21),
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+struct mmp_tdma_chan_info amda_chan_info[] = {
+	[0] = {
+		.type	  = ADMA1_CH0,
+		.reg_base = 0xc0ffd800,
+	},
+	[1] = {
+		.type	  = ADMA1_CH1,
+		.reg_base = 0xc0ffd804,
+	},
+	[2] = {
+		.type	  = ADMA2_CH0,
+		.reg_base = 0xc0ffd900,
+	},
+	[3] = {
+		.type	  = ADMA2_CH1,
+		.reg_base = 0xc0ffd904,
+	},
+};
+
+struct mmp_tdma_platform_data amda_platform_data = {
+	.nr_ch = 4,
+	.info  = amda_chan_info,
+};
+
+static struct platform_device mmp3_device_adma = {
+	.name		= "mmp-adma",
+	.id		= -1,
+	.num_resources  = ARRAY_SIZE(mmp3_adma_resource),
+	.resource       = mmp3_adma_resource,
+	.dev		= {
+		.platform_data = &amda_platform_data,
+	},
+};
+
+static struct resource mmp3_dmac_resource[] = {
+	[0] = {
+		.name   = "reg_phys",
+		.start  = 0xd4000000,
+		.end    = 0xd4000000 + SZ_1K - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+struct pxa_dmac_platform_data dmac_platform_data = {
+	.irq_base = IRQ_MMP3_DMA_BASE,
+	.nr_ch = 16,
+};
+
+static struct platform_device mmp3_device_dmac = {
+	.name           = "pxa-dmac",
+	.id             = -1,
+	.num_resources  = ARRAY_SIZE(mmp3_dmac_resource),
+	.resource       = mmp3_dmac_resource,
+	.dev            = {
+		.platform_data = &dmac_platform_data,
+		.coherent_dma_mask = DMA_BIT_MASK(64),
+	},
+};
+
 static int __init mmp3_init(void)
 {
 	/*
@@ -263,8 +337,8 @@ static int __init mmp3_init(void)
 
 	mmp3_init_gpio();
 
-	pxa_init_dma(IRQ_MMP3_DMA_RIQ, 16);
-	mmp_init_dma(IRQ_MMP3_DMA_RIQ);
+	platform_device_register(&mmp3_device_dmac);
+	platform_device_register(&mmp3_device_adma);
 
 	platform_device_register(&mmp3_device_asoc_sspa1);
 	platform_device_register(&mmp3_device_asoc_platform);
-- 
1.7.0.4

