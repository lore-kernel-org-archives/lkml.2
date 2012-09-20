Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2ITMRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:17:30 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60100 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab2ITMNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:13:37 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olof.johansson@gmail.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 19/32] ARM: ux500: Pass MSP DMA platform data though AUXDATA
Date: Thu, 20 Sep 2012 14:12:37 +0200
Message-Id: <1348143170-2130-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
References: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It isn't currently possible to pass all platform specific configuration
though Device Tree. Thinks like device names used in the clock
infrastructure, call-backs and DMA information have to be passed in via
AUXDATA structures and the MSP is no exception. Here we're passing DMA
settings.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-msp.c |    8 ++++----
 arch/arm/mach-ux500/board-mop500.c     |    9 +++++++++
 arch/arm/mach-ux500/board-mop500.h     |    5 +++++
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-msp.c b/arch/arm/mach-ux500/board-mop500-msp.c
index bfd4851..1c60135 100644
--- a/arch/arm/mach-ux500/board-mop500-msp.c
+++ b/arch/arm/mach-ux500/board-mop500-msp.c
@@ -48,7 +48,7 @@ static struct stedma40_chan_cfg msp0_dma_tx = {
 	/* data_width is set during configuration */
 };
 
-static struct msp_i2s_platform_data msp0_platform_data = {
+struct msp_i2s_platform_data msp0_platform_data = {
 	.id = MSP_I2S_0,
 	.msp_i2s_dma_rx = &msp0_dma_rx,
 	.msp_i2s_dma_tx = &msp0_dma_tx,
@@ -80,7 +80,7 @@ static struct stedma40_chan_cfg msp1_dma_tx = {
 	/* data_width is set during configuration */
 };
 
-static struct msp_i2s_platform_data msp1_platform_data = {
+struct msp_i2s_platform_data msp1_platform_data = {
 	.id = MSP_I2S_1,
 	.msp_i2s_dma_rx = NULL,
 	.msp_i2s_dma_tx = &msp1_dma_tx,
@@ -159,13 +159,13 @@ static struct platform_device ux500_pcm = {
 		},
 };
 
-static struct msp_i2s_platform_data msp2_platform_data = {
+struct msp_i2s_platform_data msp2_platform_data = {
 	.id = MSP_I2S_2,
 	.msp_i2s_dma_rx = &msp2_dma_rx,
 	.msp_i2s_dma_tx = &msp2_dma_tx,
 };
 
-static struct msp_i2s_platform_data msp3_platform_data = {
+struct msp_i2s_platform_data msp3_platform_data = {
 	.id		= MSP_I2S_3,
 	.msp_i2s_dma_rx	= &msp1_dma_rx,
 	.msp_i2s_dma_tx	= NULL,
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index e7593b0..2cb13bc 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -755,6 +755,15 @@ struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("st,nomadik-i2c", 0x8012a000, "nmk-i2c.4", NULL),
 	/* Requires device name bindings. */
 	OF_DEV_AUXDATA("stericsson,nmk_pinctrl", 0, "pinctrl-db8500", NULL),
+	/* Requires clock name and DMA bindings. */
+	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80123000,
+		"ux500-msp-i2s.0", &msp0_platform_data),
+	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80124000,
+		"ux500-msp-i2s.1", &msp1_platform_data),
+	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80117000,
+		"ux500-msp-i2s.2", &msp2_platform_data),
+	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80125000,
+		"ux500-msp-i2s.3", &msp3_platform_data),
 	{},
 };
 
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index c6daea2..6794324 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -9,6 +9,7 @@
 
 /* For NOMADIK_NR_GPIO */
 #include <mach/irqs.h>
+#include <mach/msp.h>
 #include <linux/amba/mmci.h>
 
 /* Snowball specific GPIO assignments, this board has no GPIO expander */
@@ -83,6 +84,10 @@ extern struct mmci_platform_data mop500_sdi0_data;
 extern struct mmci_platform_data mop500_sdi1_data;
 extern struct mmci_platform_data mop500_sdi2_data;
 extern struct mmci_platform_data mop500_sdi4_data;
+extern struct msp_i2s_platform_data msp0_platform_data;
+extern struct msp_i2s_platform_data msp1_platform_data;
+extern struct msp_i2s_platform_data msp2_platform_data;
+extern struct msp_i2s_platform_data msp3_platform_data;
 extern struct arm_pmu_platdata db8500_pmu_platdata;
 
 extern void mop500_sdi_init(struct device *parent);
-- 
1.7.9.5

