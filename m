Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab2G0Mq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 08:46:29 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34184 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2G0Mq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 08:46:26 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/18] ARM: ux500: Pass MSP DMA platform data though AUXDATA
Date: Fri, 27 Jul 2012 13:45:55 +0100
Message-Id: <1343393162-11938-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It isn't currently possible to pass all platform specific configuration
though Device Tree. Thinks like device names used in the clock
infrastructure, call-backs and DMA information have to be passed in via
AUXDATA structures and the MSP is no exception. Here we're passing DMA
settings.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-msp.c |    8 ++++----
 arch/arm/mach-ux500/board-mop500.c     |    9 +++++++++
 arch/arm/mach-ux500/board-mop500.h     |    5 +++++
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-msp.c b/arch/arm/mach-ux500/board-mop500-msp.c
index ec5857b..7691f71 100644
--- a/arch/arm/mach-ux500/board-mop500-msp.c
+++ b/arch/arm/mach-ux500/board-mop500-msp.c
@@ -49,7 +49,7 @@ static struct stedma40_chan_cfg msp0_dma_tx = {
 	/* data_width is set during configuration */
 };
 
-static struct msp_i2s_platform_data msp0_platform_data = {
+struct msp_i2s_platform_data msp0_platform_data = {
 	.id = MSP_I2S_0,
 	.msp_i2s_dma_rx = &msp0_dma_rx,
 	.msp_i2s_dma_tx = &msp0_dma_tx,
@@ -81,7 +81,7 @@ static struct stedma40_chan_cfg msp1_dma_tx = {
 	/* data_width is set during configuration */
 };
 
-static struct msp_i2s_platform_data msp1_platform_data = {
+struct msp_i2s_platform_data msp1_platform_data = {
 	.id = MSP_I2S_1,
 	.msp_i2s_dma_rx = NULL,
 	.msp_i2s_dma_tx = &msp1_dma_tx,
@@ -161,13 +161,13 @@ static struct platform_device ux500_pcm = {
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
index 6f53a6f..d455a61 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -753,6 +753,15 @@ struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
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
index 1d7316b..3fbf48f 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -9,6 +9,7 @@
 
 /* For NOMADIK_NR_GPIO */
 #include <mach/irqs.h>
+#include <mach/msp.h>
 #include <linux/amba/mmci.h>
 
 /* Snowball specific GPIO assignments, this board has no GPIO expander */
@@ -81,6 +82,10 @@ struct device;
 struct i2c_board_info;
 extern struct mmci_platform_data mop500_sdi0_data;
 extern struct mmci_platform_data mop500_sdi4_data;
+extern struct msp_i2s_platform_data msp0_platform_data;
+extern struct msp_i2s_platform_data msp1_platform_data;
+extern struct msp_i2s_platform_data msp2_platform_data;
+extern struct msp_i2s_platform_data msp3_platform_data;
 extern struct arm_pmu_platdata db8500_pmu_platdata;
 
 extern void mop500_sdi_init(struct device *parent);
-- 
1.7.9.5

