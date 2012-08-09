Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031399Ab2HIPvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:51:50 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51769 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031281Ab2HIPsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:48:31 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 13/22] ARM: ux500: Fork MSP platform registration for step-by-step DT enablement
Date: Thu,  9 Aug 2012 16:47:39 +0100
Message-Id: <1344527268-5964-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've done this before and it worked well last time. Here we're
duplicating a complex registration function to ease the process
of enabling it for Device Tree. As there are quite a few steps
taken during the registration process, it makes sense to break
them up into more manageable chunks. This patch will aid us.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-msp.c |   20 ++++++++++++++++++++
 arch/arm/mach-ux500/board-mop500.c     |    2 +-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-ux500/board-mop500-msp.c b/arch/arm/mach-ux500/board-mop500-msp.c
index 1a67577..24a3604 100644
--- a/arch/arm/mach-ux500/board-mop500-msp.c
+++ b/arch/arm/mach-ux500/board-mop500-msp.c
@@ -172,6 +172,26 @@ static struct msp_i2s_platform_data msp3_platform_data = {
 	.msp_i2s_dma_tx	= NULL,
 };
 
+/* Due for removal once the MSP driver has been fully DT:ed. */
+void mop500_of_msp_init(struct device *parent)
+{
+	pr_info("%s: Register platform-device 'snd-soc-u8500'.\n", __func__);
+	platform_device_register(&snd_soc_mop500);
+
+	pr_info("Initialize MSP I2S-devices.\n");
+	db8500_add_msp_i2s(parent, 0, U8500_MSP0_BASE, IRQ_DB8500_MSP0,
+			   &msp0_platform_data);
+	db8500_add_msp_i2s(parent, 1, U8500_MSP1_BASE, IRQ_DB8500_MSP1,
+			   &msp1_platform_data);
+	db8500_add_msp_i2s(parent, 2, U8500_MSP2_BASE, IRQ_DB8500_MSP2,
+			   &msp2_platform_data);
+	db8500_add_msp_i2s(parent, 3, U8500_MSP3_BASE, IRQ_DB8500_MSP1,
+			   &msp3_platform_data);
+
+	pr_info("%s: Register platform-device 'ux500-pcm'\n", __func__);
+	platform_device_register(&ux500_pcm);
+}
+
 void mop500_msp_init(struct device *parent)
 {
 	pr_info("%s: Register platform-device 'snd-soc-mop500'.\n", __func__);
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 11dd962..8f419b1 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -807,7 +807,7 @@ static void __init u8500_init_machine(void)
 		mop500_uib_init();
 
 	} else if (of_machine_is_compatible("calaosystems,snowball-a9500")) {
-		mop500_msp_init(parent);
+		mop500_of_msp_init(parent);
 	} else if (of_machine_is_compatible("st-ericsson,hrefv60+")) {
 		/*
 		 * The HREFv60 board removed a GPIO expander and routed
-- 
1.7.9.5

