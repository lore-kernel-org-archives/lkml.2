Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2EHJqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:46:07 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:45129 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753123Ab2EHJqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:46:00 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: [PATCH 11/12] ARM: ux500: alter MSP registration to return a device pointer
Date: Tue, 8 May 2012 11:45:39 +0200
Message-ID: <1336470339-23851-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Alter the db8500_add_msp_i2s() calls to return a struct
platform_device * pointer, not an integer. We nee the pointer
to obtain a pinctrl handle.

Cc: Ola Lilja <ola.o.lilja@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-msp.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-msp.c b/arch/arm/mach-ux500/board-mop500-msp.c
index c8f6300..aacaf80 100644
--- a/arch/arm/mach-ux500/board-mop500-msp.c
+++ b/arch/arm/mach-ux500/board-mop500-msp.c
@@ -170,7 +170,8 @@ static struct stedma40_chan_cfg msp2_dma_tx = {
 	/* data_width is set during configuration */
 };
 
-static int db8500_add_msp_i2s(struct device *parent, int id,
+static struct platform_device *db8500_add_msp_i2s(struct device *parent,
+			int id,
 			resource_size_t base, int irq,
 			struct msp_i2s_platform_data *pdata)
 {
@@ -188,10 +189,10 @@ static int db8500_add_msp_i2s(struct device *parent, int id,
 	if (!pdev) {
 		pr_err("Failed to register platform-device 'ux500-msp-i2s.%d'!\n",
 			id);
-		return -EIO;
+		return NULL;
 	}
 
-	return 0;
+	return pdev;
 }
 
 /* Platform device for ASoC U8500 machine */
@@ -228,23 +229,21 @@ static struct msp_i2s_platform_data msp3_platform_data = {
 
 int mop500_msp_init(struct device *parent)
 {
-	int ret;
-
 	pr_info("%s: Register platform-device 'snd-soc-u8500'.\n", __func__);
 	platform_device_register(&snd_soc_u8500);
 
 	pr_info("Initialize MSP I2S-devices.\n");
-	ret = db8500_add_msp_i2s(parent, 0, U8500_MSP0_BASE, IRQ_DB8500_MSP0,
-				&msp0_platform_data);
-	ret |= db8500_add_msp_i2s(parent, 1, U8500_MSP1_BASE, IRQ_DB8500_MSP1,
-				&msp1_platform_data);
-	ret |= db8500_add_msp_i2s(parent, 2, U8500_MSP2_BASE, IRQ_DB8500_MSP2,
-				&msp2_platform_data);
-	ret |= db8500_add_msp_i2s(parent, 3, U8500_MSP3_BASE, IRQ_DB8500_MSP1,
-				&msp3_platform_data);
+	db8500_add_msp_i2s(parent, 0, U8500_MSP0_BASE, IRQ_DB8500_MSP0,
+			   &msp0_platform_data);
+	db8500_add_msp_i2s(parent, 1, U8500_MSP1_BASE, IRQ_DB8500_MSP1,
+			   &msp1_platform_data);
+	db8500_add_msp_i2s(parent, 2, U8500_MSP2_BASE, IRQ_DB8500_MSP2,
+			   &msp2_platform_data);
+	db8500_add_msp_i2s(parent, 3, U8500_MSP3_BASE, IRQ_DB8500_MSP1,
+			   &msp3_platform_data);
 
 	pr_info("%s: Register platform-device 'ux500-pcm'\n", __func__);
 	platform_device_register(&ux500_pcm);
 
-	return ret;
+	return 0;
 }
-- 
1.7.9.2

